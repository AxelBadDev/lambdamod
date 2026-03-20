--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: 
--]]

if CLIENT or _CLIENT then return end

include( "lambda/core/shared.lua" )
include( "lambda/core/core.lua" )
include( "lambda/core/includes/cvar.lua" )
include( "lambda/core/includes/libadmin.lua" )
include( "lambda/core/includes/vscript.lua" )

if _G.__LM_CCmd then return end
_G.__LM_CCmd = true

local FCVAR_HIDDEN = FCVAR_HIDDEN or _E.FCVAR_HIDDEN

LambdaMod = LambdaMod or {}

LambdaMod.Registered = {}

function LambdaMod.AddCommand(pName, pFn, pHelp, pHelpArg)
	if (LambdaMod.Registered[pName]) then
		if _SERVER then
			SRprintf("[SERVER] LambdaMod.AddCommand: Command already exists (%s)\n", tostring( pName) );
		elseif _CLIENT then
			SRprintf("[CLIENT] LambdaMod.AddCommand: Command already exists (%s)\n", tostring( pName ) );
		end
		return;
	end
	--if type(pFn) ~= "function" then return end
	LambdaMod.printfc(5, "Registered Commands: %s\n", tostring(pName))
	LambdaMod.Registered[pName] =
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
function LambdaMod.RunCommand(pPlayer, cmd, arg)
    if not LambdaMod.Registered or LambdaMod.Registered == nil then return end 
	--if pPlayer   
    --if(!cmd)
	if not cmd then return end
    --if(!LambdaMod.Registered[cmd])
	if not (LambdaMod.Registered[cmd]) then
         LambdaMod.printfc(3, "Unknown command: \"%s\"\n", tostring( cmd ) )
         return
	end
	
	local ok, err = pcall(LambdaMod.Registered[cmd].func, pPlayer, cmd, arg)
	if not ok then
	  LambdaMod.printfc(3, "Exception: %s\n", tostring(err))
	end
end
--LambdaMod.AddCommand( pName, pFn, pHelp, pHelpArg)

LambdaMod.AddCommand( "version", function( ply, cmd, arg )
	LambdaMod.printfc(0, "LambdaMod version: %s\n", tostring( LambdaMod.INFO._VERSION ))
	LambdaMod.printfc(0, "Builded on: %s\n", tostring( LambdaMod.INFO._BUILD_DATE ))
	--LambdaMod.printfc(0, "Branch: %s\n", tostring( LambdaMod.INFO._BRANCH ))
end, "", "" )

LambdaMod.AddCommand( "cmds", function( ply, cmd, arg )
	LambdaMod.printfc(0, "Command(s)             Description\n")
	
    for k, v in pairs(LambdaMod.cvar.Registered) do
        --LambdaMod.printfc(0, "%s            %s\n", tostring( k ), tostring(( v.description or "" )) )
        LambdaMod.printfc(0, "%s                     %s\n", tostring( k ), tostring(( v.description or "" )) )
    end      
end, "", "" )

LambdaMod.AddCommand( "dump", function( ply, cmd, arg )
	for k in pairs( LambdaMod ) do
		LambdaMod.printfc(0, "%s\n", tostring( k ))
	end
end, "Dumps LambdaMod table", "" )

LambdaMod.AddCommand( "credits", function( ply, cmd, arg )
	LambdaMod.printfc(0, "LambdaMod was developed by:\n  Plugin Loader: originally made by YourLocalCappy hedv948-source\n  HL2SB++: YourLocalMoon/ThePixelMoon\n  Inspired by Metamod:Source/SourceMod made by AlliedModders\n  LambdaMod made by hedv948-source\n")
end, "Credits", "" )

