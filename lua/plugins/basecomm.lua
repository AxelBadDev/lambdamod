--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

PLUGIN.myinfo = 
{
	name = "Basic Comm Controls",
	author = "AxelBadDev",
	description = "Provides methods of controlling communication.",
	version = LAMBDAMOD_VERSION,
	api = LAMBDAMOD_API_VERSION,
	url = "https://github.com/AxelBadDev/lambdamod/"
}

LambdaMod.CreateTable( false, "GaggedPlayers" )

includeC( "basecomm/gag.lua" )

function PLUGIN:OnPluginStart()
	LambdaMod.cvar.RegAdminCmd( "lambda_gag", function( ply, cmd, arg )
		if not arg or arg == "" then 
			LambdaMod.printfc( 0, "Usage: lambda_gag <player|me|others|all>\n" ) 
			return
		end
		
		self.PerformGag( ply, arg )
	end, "lambda_gag <player|me|others|all> - Removes a player's ability to use chat." )
	
	LambdaMod.cvar.RegAdminCmd( "lambda_ungag", function( ply, cmd, arg )
		if not arg or arg == "" then 
			LambdaMod.printfc( 0, "Usage: lambda_ungag <player|me|others|all>\n" ) 
			return
		end
		
		self.PerformUnGag( ply, arg )
	end, "lambda_ungag <player|me|others|all> - Restores a player's ability to use chat.")
end