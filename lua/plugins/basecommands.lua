--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--]

PLUGIN:myinfo 
{
	name = "Basic Commands",
	author = "AxelBadDev",
	description = "Basic Admin Commands",
	version = LAMBDAMOD_VERSION,
	api = LAMBDAMOD_API_VERSION,
	url = "https://github.com/AxelBadDev/lambdamod"
}    
PLUGIN:Import "LambdaMod" 
PLUGIN:Import "ChatCmd" 
PLUGIN:Import "Hook" 

includeC( "basecommands/kick.lua" )

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LibAdmin = LambdaMod.LibAdmin
local ChatCmd = LambdaMod.ChatCmd

function PLUGIN:Init()
end    

local function Console_Kick( pPlayer, pCmd, pArg ) 
    if not arg or arg == "" then LambdaMod.printfc(0, "Usage: lambda_kick <player|me|others|all>\n") return end
        
    local targets = self.LambdaMod.ParseTargets( arg, pPlayer )
        
    for _, t in ipairs( targets ) do
        engine.ServerCommand("kick" .. t:GetPlayerName() .. "\n")
    end    
        
    LambdaMod.CPrintf( 0, "Kicked " .. #targets .. " player(s).\n" )
end

local function Chat_Kick( pPlayer, pArg ) 
    local targetArg = pArgs[ 1 ]
    if not targetArg or targetArg == "" then return "Usage: " .. LambdaMod.GetVar( "Prefix" ):GetString() .. "kick <player|me|all|others|index>" end
    local targets = self.LambdaMod.ParseTargets( targetArgs, pPlayer )
    for _, t in ipairs( targets ) do
        engine.ServerCommand("kick" .. t:GetPlayerName() .. "\n")
    end    
    return "Kicked " .. #targets .. " player(s)."
end

function PLUGIN:OnPluginStart()
    self.LambdaMod.RegAdminCmd( "lambda_kick", Console_Kick, "Kick player(s)")
    
    self.ChatCmd.AddAdminCmd( "kick", function( pPlayer, pCmd, pArgs ) 
        
    end, "Kicks player(s)")
end

