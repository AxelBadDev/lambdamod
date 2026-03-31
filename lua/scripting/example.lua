--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose:
--]]
PLUGIN.myinfo = 
{
	name = "Example",
	author = "hedv948-source",
	description = "Example",
	version = LambdaMod.INFO._VERSION,
	api = LambdaMod.Loader.api.version,
	url = "https://github.com/hedv948-source"
}

function PLUGIN.OnPluginStart()
	LambdaMod.Loader.AddonCommand( "example", ( function(ply, cmd, arg) LambdaMod.printc(0, "Hello World") end ), "" )
end