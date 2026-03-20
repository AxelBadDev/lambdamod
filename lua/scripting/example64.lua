--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: An example for building plugins
--]]

-- MUST BE COMPILED IN 64 bit
PLUGIN.myinfo = 
{
	name = "Example (64) bytecode",
	author = "hedv948-source",
	description = "Example",
	version = LambdaMod.INFO._VERSION,
	api = LambdaMod.CLoader.api.version,
	url = "https://github.com/hedv948-source/lambdamod/"
}

function PLUGIN.OnPluginStart()
  LambdaMod.printfc(0, "Hello world from example\n");
end