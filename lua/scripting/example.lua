PLUGIN.myinfo = 
{
	name = "Example",
	author = "hedv948-source",
	description = "Example",
	version = LambdaMod.INFO._VERSION,
	api = LambdaMod.Loader.api.version,
	url = "https://github.com/hedv948-source"
}
--PLUGIN.name = "Example"
--PLUGIN.description = "Example"
--PLUGIN.version = LambdaMod.INFO._VERSION
--PLUGIN.protocol = LambdaMod.Loader.info.Protocol
--PLUGIN.author = "hedv948-source"
--PLUGIN.NoAutoCreateCommand = false
--PLUGIN.Settings.Category = ""
--PLUGIN.Settings.Icon = ""
--PLUGIN.Settings.ShowInSpawnmenu = false

function PLUGIN.OnPluginStart()
	LambdaMod.Loader.AddonCommand( "example", ( function(ply, cmd, arg) LambdaMod.printc(0, "Hello World") end ), "" )
end