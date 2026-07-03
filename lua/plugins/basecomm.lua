--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

PLUGIN:myinfo
{
	name = "Basic Comm Controls",
	author = "AxelBadDev",
	description = "Provides methods of controlling communication.",
	version = LAMBDAMOD_VERSION,
	api = LAMBDAMOD_API_VERSION,
	url = "https://github.com/AxelBadDev/lambdamod/"
}
PLUGIN:Import "LambdaMod" 
PLUGIN:Import "ChatCmd" 
PLUGIN:Import "Hook" 

local PrintMessage = LambdaMod.Usermsg.PrintMessage
local ParseTargets = LambdaMod.LibAdmin.ParseTargets
local HUD_PRINTCONSOLE = LambdaMod.Enum.HUD.PRINTCONSOLE

local GaggedPlayers = {} 

--local GaggedPlayers = PLUGIN.GaggedPlayers

LambdaMod.CreateTable( false, "GaggedPlayers" )

includeC( "basecomm/gag.lua" )

function PLUGIN:SetupHook() 
    hook.add( "Host_Say", "LambdaMod::IsPlayerMuted", function( pPlayer, pMsg, bTeamOnly ) 
        -- local GaggedPlayers = LambdaMod.GetVar( "GaggedPlayers" ):GetTable()
        if ( GaggedPlayers[ pPlayer ] ) then
            LambdaMod.LogAction( "%s tried to chat but is gagged.", pPlayer:GetPlayerName() )
            return "" -- Don't show a fucking message to everyone
        end    
    end)
end

local function Console_doGAG( ply, cmd, arg )
    
    if ( cmd == "lambda_gag" ) then
        if ( !arg || arg == "" ) then 
            PrintMessage( ply, HUD_PRINTCONSOLE, "[LM] Usage: lambda_gag <player|me|others|all>" ) 
            return
        end
		
        local targets = ParseTargets( arg, ply ) 
        
        for _, t in ipairs( targets ) do
            GaggedPlayers[ t ] = true
        end    
        PrintMessage( ply, HUD_PRINTCONSOLE, string.format("[LM] Gagged %d player(s).", #targets ))
    end
    
    if ( cmd == "lambda_ungag" ) then
        if ( !arg || arg == "" ) then 
            PrintMessage( ply, HUD_PRINTCONSOLE, "[LM] Usage: lambda_ungag <player|me|others|all>" ) 
            return
        end
		
        local targets = ParseTargets( arg, ply ) 
        
        for _, t in ipairs( targets ) do
            GaggedPlayers[ t ] = nil
        end    
        PrintMessage( ply, HUD_PRINTCONSOLE, string.format("[LM] Ungagged %d player(s).", #targets ) )  
   end     
end 
       
function PLUGIN:OnPluginStart()
    self:SetupHook()
    self.LambdaMod.RegAdminCmd( "lambda_gag", Console_doGAG, "lambda_gag <player|me|others|all> - Removes a player's ability to use chat." )
    self.LambdaMod.RegAdminCmd( "lambda_ungag", Console_doGAG, "lambda_ungag <player|me|others|all> - Restores a player's ability to use chat.")
    
    self.ChatCmd.AddAdminCmd( "gag", function( ply, args ) 
        local targetArg = args[ 1 ]
        if not targetArg or targetArg == "" then 
			return "Usage: !gag <player|me|others|all>"; 
		end
        
        local targets = ParseTargets( targetArg, ply ) 
        
        for _, t in ipairs( targets ) do
            GaggedPlayers[ t ] = true
        end    
        return "Gagged " .. #targets .. " player(s)."
    end, "Removes a player's ability to use chat.")
    
   self.ChatCmd.AddAdminCmd( "ungag", function( ply, args ) 
        local targetArg = args[ 1 ]
        if not targetArg or targetArg == "" then 
			return "Usage: !ungag <player|me|others|all>"; 
		end
        
        local targets = ParseTargets( targetArg, ply ) 
        
        for _, t in ipairs( targets ) do
            GaggedPlayers[ t ] = nil
        end    
        return "Ungagged " .. #targets .. " player(s)."
    end, "Restores a player's ability to use chat.")    
end