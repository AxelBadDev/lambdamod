--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

PLUGIN.myinfo = 
{
	name = "Player Commands",
	author = "hedv948-source",
	description = "Misc. Player Commands",
	version = LAMBDAMOD_VERSION,
	api = LAMBDAMOD_API_VERSION,
	url = "https://github.com/hedv948-source/lambdamod/"
}

--PLUGIN:SetAsRequired( "SourceMod" )
PLUGIN:Include( "LambdaMod" )
PLUGIN:Include( "ChatCmd" )
PLUGIN:Include( "Hook" )

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LibAdmin = LambdaMod.LibAdmin

function PLUGIN:OnPluginStart() 
    self.LambdaMod:RegAdminCmd( "lambda_slay", function( ply, cmd, arg )
        local pTargets = self.LambdaMod:ParseTargets( arg, ply )
        
        for _, t in ipairs( pTargets ) do
            self.LambdaMod:Damage( ply, t, 100000000 )
        end
        
        self.LambdaMod:LogAction( "Slayed", #pTargets, "player(s)")
    end, "" )       
    
    self.ChatCmd:AddAdminCmd( "slay", function( ply, args ) 
        local targetArg = args[ 1 ]
        if !targetArg then return "Usage: /slay player|me|all|others|index>" end
        
        local targets = self.LambdaMod:ParseTargets( targetArg, ply )
        
        for _, t in ipairs( targets ) do
            self.LambdaMod:Damage( ply, t, 100000000 )
        end
        
        return "Slayed " .. #targets .. " player(s)"
        
     end, "Instantly kill target(s)" ) 
     
end
