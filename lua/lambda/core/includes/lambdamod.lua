--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: 
--]]


local FCVAR_HIDDEN = FCVAR_HIDDEN or _E.FCVAR_HIDDEN

LambdaMod.Registered  = {}

function LambdaMod.AddCommand(pName, pFn, pHelp, pHelpArg)
	if ( LambdaMod.Registered[ pName ] ) then
		if ( SERVER ) then
			LambdaMod.Printfc(3, "[SERVER] LambdaMod.AddCommand: Command already exists (%s)\n", tostring( pName) );
		elseif ( CLIENT ) then
			LambdaMod.Printfc(3, "[CLIENT] LambdaMod.AddCommand: Command already exists (%s)\n", tostring( pName ) );
		end
		return;
	end
	--if type(pFn) ~= "function" then return end
	LambdaMod.printfc(5, "Registered Commands: %s\n", tostring(pName))
	LambdaMod.Registered[ pName ] =
	{ 
		func = pFn,
		help = pHelp or "",
		helpArg = pHelpArg or ""
	}
end


function LambdaMod.ListCommand()
  for k, v in pairs( LambdaMod.Registered ) do
    LambdaMod.printfc(0, "Command: %s Help: %s\n", tostring( k ), tostring( v.help ) )
  end
end
--- Running a non console command
function LambdaMod.RunCommand( pPlayer, pArg )
    if ( !LambdaMod.Registered || LambdaMod.Registered == nil ) then return end 
	--if pPlayer   
    --if(!cmd)
	if ( !pArg[1] ) then return end
    --if(!LambdaMod.Registered[cmd])
	if ( !LambdaMod.Registered[ pArg[1] ] ) then
         LambdaMod.printfc(3, "Unknown command: \"%s\"\n", tostring( pArg[1] ) )
         return
	end
	
	local ok, err = pcall(LambdaMod.Registered[ pArg[1] ].func, pPlayer, pArg )
	if ( !ok ) then
	  LambdaMod.printfc(3, "Failed to run \"%s\" : %s\n", pArg[1], tostring(err) )
	end
end

--LambdaMod.AddCommand( pName, pFn, pHelp, pHelpArg)

LambdaMod.AddCommand( "version", function( ply, cmd, args )
	LambdaMod.printfc(0, "LambdaMod version: %s\n", tostring( LambdaMod["VERSION"] ))
	LambdaMod.printfc(0, "Builded on: %s\n", tostring( LambdaMod["BUILD_DATE"] ))
	--LambdaMod.printfc(0, "Branch: %s\n", tostring( LambdaMod.INFO._BRANCH ))
end, "", "" )

LambdaMod.AddCommand( "cmds", function( ply, args )
	LambdaMod.printfc(0, "%-25s %-20s\n", "Command(s)", "Description")
	
    for k, v in pairs(LambdaMod.cvar.Registered) do
        --LambdaMod.printfc(0, "%s            %s\n", tostring( k ), tostring(( v.description or "" )) )
        LambdaMod.printfc(0, "%-25s  %-20s\n", tostring( k ), tostring(( v.description or "" )) )
    end      
end, "", "" )

LambdaMod.AddCommand( "dump", function( ply, args )
	for k in pairs( LambdaMod ) do
		LambdaMod.printfc(0, "%s\n", tostring( k ))
	end
end, "Dumps LambdaMod table", "" )

LambdaMod.AddCommand( "credits", function( ply, args )
	LambdaMod.printfc(0, "LambdaMod was developed by:\n  PluginLoader: originally made by YourLocalCappy modified by hedv948-source\n  HL2SB++: YourLocalMoon/ThePixelMoon\n  Inspired by Metamod:Source/SourceMod made by AlliedModders\n  LambdaMod made by hedv948-source\n")
end, "Credits", "" )

