--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: 
--]]

PLUGIN.myinfo = 
{
	name = "Basic Commands",
	author = "hedv948-source",
	description = "Basic Admin Commands",
	version = LambdaMod.INFO._VERSION,
	api = LambdaMod.Loader.api.version,
	url = "https://github.com/hedv948-source/lambdamod/"
}

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LibAdmin = LambdaMod.LibAdmin

local function PerformKick( pCaller, pTargets )
	local targets = LibAdmin.ParseTargets( pTargets, pCaller )
	
	if #targets == 0 then
        LambdaMod.printfc(3, "No matching players for \"%s\".\n", tostring(pTargets) )
        return
    end
	for _, v in ipairs( targets ) do
		LambdaMod.printfc( 0, "%s kicked %s\n", pCaller:GetPlayerName(), v:GetPlayerName() ) 
		LambdaMod.Core.ForwardToConsole("kick " .. v:GetPlayerName() )
	end
end

function PLUGIN.OnPluginStart()
	RegAdminCmd( "lambda_kick", function( ply, cmd, arg )
		if not arg or arg == "" then LambdaMod.printfc(0, "Usage: lambda_kick <player|me|others|all>\n") return end
		PerformKick( ply, arg )
	end, "")
end

