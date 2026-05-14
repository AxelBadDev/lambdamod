--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

--TODO: Print message using enum instead of numbers

local FCVAR_HIDDEN = FCVAR_HIDDEN or _E.FCVAR.HIDDEN

LambdaMod.Registered  = {}

--- Adds a lambda command
---@param pName string
---@param pFn function
---@param pHelp? string
---@param pHelpArg? string
function LambdaMod.AddCommand( pName, pFn, pHelp, pHelpArg )
	if ( LambdaMod.Registered[ pName ] ) then
		LambdaMod.CPrintf(3, "LambdaMod.AddCommand: Command already exists (%s)\n", tostring( pName) );
		return;
	end
	--if type(pFn) ~= "function" then return end
	--LambdaMod.CPrintf( 5, "Registered Commands: %s\n", tostring(pName))
	LambdaMod.Registered[ pName ] =
	{ 
		func = pFn,
		help = pHelp or "",
		helpArg = pHelpArg or ""
	}
end

function LambdaMod.ListCommand()
  for k, v in pairs( LambdaMod.Registered ) do
    LambdaMod.CPrintf(0, "Command: %s Help: %s\n", tostring( k ), tostring( v.help ) )
  end
end

--- Running a non console command
---@param pPlayer CBasePlayer
---@param pArg string[]
function LambdaMod.RunCommand( pPlayer, pArg )
    if ( !LambdaMod.Registered || LambdaMod.Registered == nil ) then return end
    
    --LambdaHook.Call( "OnRunCommand", pPlayer, pArg ) 
	--if pPlayer   
    --if(!cmd)
    
    local cmdName = string.lower( pArg[ 1 ] or "" )
    table.remove( pArg, 1 )
    
	if ( !cmdName ) then return end
    --if(!LambdaMod.Registered[cmd])
	if ( !LambdaMod.Registered[ cmdName ] ) then
         LambdaMod.CPrintf( 3, "Unknown command: \"%s\"\n", tostring( cmdName ) )
         return
	end
	
	local ok, err = pcall( LambdaMod.Registered[ cmdName ].func, pPlayer, pArg )
	if ( !ok ) then
	  LambdaMod.CPrintf( 3, "Failed to run \"%s\" : %s\n", cmdName, tostring(err) )
      return
	end
end
--LambdaMod.AddCommand( pName, pFn, pHelp, pHelpArg)

LambdaMod.AddCommand( "version", function( ply, args )
	LambdaMod.printfc(0, "LambdaMod version: %s\n", tostring( LambdaMod["VERSION"] ))
	LambdaMod.printfc(0, "Builded on: %s\n", tostring( LambdaMod["BUILD_DATE"] ))
	--LambdaMod.printfc(0, "Branch: %s\n", tostring( LambdaMod.INFO._BRANCH ))
end, "", "" )

LambdaMod.AddCommand( "cmds", function( ply, args )
	LambdaMod.printfc(0, "%-25s      - %-20s\n", "Command(s)", "Description")
	
    for k, v in pairs(LambdaMod.cvar.Registered) do
        --LambdaMod.printfc(0, "%s            %s\n", tostring( k ), tostring(( v.description or "" )) )
        LambdaMod.printfc(0, "%-25s      - %-20s\n", tostring( k ), tostring(( v.description or "" )) )
    end      
end, "", "" )

local function println(...)
    local args = {...}
    
    local text
    if #args > 0 then
        text = table.concat(args, " ")
    end
    
    dbg.ConMsg( text .. "\n" )
end   

local function PrintTable(t, bOrdered, i)
  i = i or 0
  local indent = ""
  for j = 1, i do
    indent = indent .. "\t"
  end
  if not bOrdered then
    for k, v in pairs(t) do
      if type(v) == "table" then
        dbg.ConMsg( indent .. k .. "\n" )
        PrintTable(v, false, i + 1)
      else
        dbg.ConMsg( indent .. k .. "   " .. v .. "\n" )
      end
    end
  else
    for j, pair in ipairs(t) do
      if type(pair.value) == "table" then
        dbg.ConMsg( indent .. pair.key .. "\n" )
        PrintTable(pair.value, true, i + 1)
      else
        dbg.ConMsg( indent .. pair.key .. "   " ..  pair.value)
      end
    end
  end
end

LambdaMod.AddCommand( "dump", function( ply, args )
	PrintTable( LambdaMod )
end, "Dumps LambdaMod table", "" )

LambdaMod.AddCommand( "credits", function( ply, args )
    local credits = {
        "LambdaMod was developed by:",
        "   LambdaMod developed by hedv948-source",
        "   Pluginloader made by YourLocalSunny modified by hedv948-source",
        "   HL2SB++ made by YourLocalMoon/ThePixelMoon",
        "   Inspired by Metamod:Source/SourceMod",
    }
	LambdaMod.CPrint(0, table.concat( credits, "\n") )
end, "Credits", "" )

