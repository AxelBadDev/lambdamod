--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--]

PLUGIN.myinfo = 
{
	name = "Basic Commands",
	author = "AxelBadDev",
	description = "Basic Admin Commands",
	version = LAMBDAMOD_VERSION,
	api = LAMBDAMOD_API_VERSION,
	url = "https://github.com/AxelBadDev/lambdamod"
}
PLUGIN:Include( "LambdaMod" )
PLUGIN:Include( "ChatCmd" )
PLUGIN:Include( "Hook" )

includeC( "basecommands/kick.lua" )

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LibAdmin = LambdaMod.LibAdmin
local ChatCmd = LambdaMod.ChatCmd

function PLUGIN:Init()
end    

function PLUGIN:OnPluginStart()
	RegAdminCmd( "lambda_kick", function( ply, cmd, arg )
		if not arg or arg == "" then LambdaMod.printfc(0, "Usage: lambda_kick <player|me|others|all>\n") return end
		self.PerformKick( ply, arg )
	end, "")
    
    self.ChatCmd:AddAdminCmd( "kick", function( pPlayer, pArgs ) 
        local targetArg = pArgs[ 1 ]
        if not targetArg then return "Usage: " .. LambdaMod.GetVar( "Prefix" ):GetString() .. "kick <player|me|all|others|index>" end
        
    end, "Kicks player(s)")
end

