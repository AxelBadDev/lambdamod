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
	api = LambdaMod.Loader.api.version,
	url = "https://github.com/hedv948-source/lambdamod/"
}

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LogAction = LambdaMod.LogAction
local LibAdmin = LambdaMod.LibAdmin

local hook = require( "hook" )
local GaggedPlayers = LambdaMod.GaggedPlayers 

function PerformGag( pCaller, pTargets )
    LogAction( "%s triggered lambda_gag", pCaller:GetPlayerName() )
    
	local targets = LibAdmin.ParseTargets( pTargets, pCaller )
	
	for _, t in ipairs( targets ) do
        LogAction( "Gagged player: %s", t:GetPlayerName() )
        GaggedPlayers[ t:GetPlayerName() ] = true
    end
    LambdaMod.Printfc( 0, "Gagged %s player(s)\n", tostring( #targets ) )
end

function PerformUnGag( pCaller, pTargets )
    LogAction( "%s triggered lambda_ungag", pCaller:GetPlayerName() )
	local targets = LibAdmin.ParseTargets( pTargets, pCaller )
	
	for _, t in ipairs( targets ) do
        LogAction( "Ungagged player: %s", t:GetPlayerName() )
        GaggedPlayers[ t:GetPlayerName() ] = nil
    end
    LambdaMod.Printfc( 0, "Ungagged %s player(s)\n", tostring( #targets ) )
end

local function StartHooks()	
end

function PLUGIN:OnPluginStart()
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