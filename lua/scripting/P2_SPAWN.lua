PLUGIN.myinfo = 
{
	name = "Portal 2 Base entity",
	author = "hedv948-source",
	description = "Portal 2 spawn entity commands",
	version = LambdaMod.INFO._VERSION,
	protocol = LambdaMod.Loader.api.version,
	url = "https://github.com/hedv948-source"
}

function PLUGIN.OnPluginStart()
	  LambdaMod.cvar.RegConsoleCmd(
		"lambda_create_prop_weighted_cube", 
		function() 
			LambdaMod.Core.ForwardToConsole( "ent_create prop_weighted_cube" ) 
		end, 
		"" 
	  )
end

