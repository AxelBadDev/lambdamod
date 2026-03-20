--[[ 
   *
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: 
   *
--]]
PLUGIN.myinfo = 
{
	name = "Basic Comm Controls",
	author = "hedv948-source",
	description = "Provides methods of controlling communication.",
	version = LambdaMod.INFO._VERSION,
	protocol = LambdaMod.Loader.api.version,
	url = "https://github.com/hedv948-source"
}

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LibAdmin = LambdaMod.LibAdmin

local hook = require( "hook" )
local GaggedPlayers = {}

function PerformGag( pCaller, pTargets )
	local targets = LibAdmin.ParseTargets( pTargets, pCaller )
	
	for _, t in ipairs( targets ) do
        GaggedPlayers[ t ] = true
    end
    LambdaMod.printfc( 0, "Gagged %s player(s)\n", tostring( #targets ) )
end

function PerformUnGag( pCaller, pTargets )
	local targets = LibAdmin.ParseTargets( pTargets, pCaller )
	
	for _, t in ipairs( targets ) do
        GaggedPlayers[ t ] = nil
    end
    LambdaMod.printfc( 0, "Ungagged %s player(s)\n", tostring( #targets ) )
end

hook.add( "Host_Say", "Lambda::CheckGag", function( pPlayer, msg, teamonly )
    if GaggedPlayers[ pPlayer ] then
        LambdaMod.printfc(0, "%s tried to chat but is gagged.\n", tostring( pPlayer:GetPlayerName() ) )
        return false -- block the fucking message
    end
end )

local function StartHooks()	
end

function PLUGIN.OnPluginStart()
	RegAdminCmd( "lambda_gag", function( ply, cmd, arg )
		if not arg or arg == "" then 
			LambdaMod.printfc( 0, "Usage: lambda_gag <player|me|others|all>\n" ) 
			return
		end
		
		PerformGag( ply, arg )
	end, "lambda_gag <player|me|others|all> - Removes a player's ability to use chat." )
	
	RegAdminCmd( "lambda_ungag", function( ply, cmd, arg )
		if not arg or arg == "" then 
			LambdaMod.printfc( 0, "Usage: lambda_ungag <player|me|others|all>\n" ) 
			return
		end
		
		PerformUnGag( ply, arg )
	end, "lambda_ungag <player|me|others|all> - Restores a player's ability to use chat.")
end