--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Example for plugin
--
--============================================================================--

PLUGIN.myinfo = 
{
	name = "Example",
	author = "hedv948-source",
	description = "Example",
	version = LambdaMod.INFO._VERSION,
	api = LAMBDAMOD_API_VERSION,
	url = "https://github.com/hedv948-source"
}

function PLUGIN:OnPluginStart()
	LambdaMod.Loader.AddonCommand( "example", ( function( ply, cmd, args ) 
	  if ( type( args ) == "table" ) then
	    for _, v in ipairs( args ) do
	      LambdaMod.Printc(0, v)
	    end
    end
	end ), "" )
end