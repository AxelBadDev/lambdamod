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
function LambdaMod.RunCommand( pPlayer, pCmd, pArg )
    if ( !LambdaMod.Registered || LambdaMod.Registered == nil ) then return end
    
    --LambdaHook.Call( "OnRunCommand", pPlayer, pArg ) 
	--if pPlayer   
    --if(!cmd)
    
    local cmdName = string.lower( pCmd or "" )
    --table.remove( pArg, 1 )
    
	if ( !cmdName ) then return end
    --if(!LambdaMod.Registered[cmd])
    
    if ( cmdName == "" ) then
        LambdaMod.printfc(0, "[LM] Usage: lambda <command> [arguments]\n")
        for k, v in pairs( LambdaMod.Registered ) do
            LambdaMod.printfc(0, "    lambda %-12s - %s\n", tostring( k ), tostring( ( v.help or "" ) ) )
        end
        
        return
    end
    
    local cmd = LambdaMod.Registered[ cmdName ]
	if ( !cmd ) then
         LambdaMod.CPrintf( 3, "Unknown command: '%s'\n", tostring( cmdName ) )
         return
	end
	
	local ok, err = pcall( cmd.func, pPlayer, cmdName, pArg )
	if ( !ok && err ) then
	  LambdaMod.CPrintf( 3, "Failed to run '%s' : %s\n", cmdName, tostring(err) )
      return
	end
end
--LambdaMod.AddCommand( pName, pFn, pHelp, pHelpArg)

LambdaMod.AddCommand( "version", function( ply, cmd, args )
	LambdaMod.printfc(0, "LambdaMod version: %s\n", tostring( LambdaMod["VERSION"] ))
	LambdaMod.printfc(0, "Builded on: %s\n", tostring( LambdaMod["BUILD_DATE"] ))
	--LambdaMod.printfc(0, "Branch: %s\n", tostring( LambdaMod.INFO._BRANCH ))
end, "", "" )

LambdaMod.AddCommand( "help", function( ply, cmd, args )
	LambdaMod.printfc(0, "%-25s      - %-20s\n", "Command(s)", "Description")
	
    for k, v in pairs(LambdaMod.cvar.Registered) do
        --LambdaMod.printfc(0, "%s            %s\n", tostring( k ), tostring(( v.description or "" )) )
        LambdaMod.printfc(0, "%-25s      - %-20s\n", tostring( k ), tostring(( v.description or "" )) )
    end      
end, "", "" )

local function println(...)
    local args = {...}
    
    local text = ""
    if #args > 0 then
        text = text .. table.concat(args, " ")
    end
    
    dbg.ConMsg( tostring( text ) .. "\n" )
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
        println( indent, k )
        PrintTable(v, false, i + 1)
      else
        println( indent .. k, v )
      end
    end
  else
    for j, pair in ipairs(t) do
      if type(pair.value) == "table" then
        println( indent .. pair.key )
        PrintTable(pair.value, true, i + 1)
      else
        println( indent .. pair.key, pair.value )
      end
    end
  end
end

LambdaMod.AddCommand( "dump", function( ply, cmd, args )
	PrintTable( LambdaMod )
end, "Dumps LambdaMod table", "" )

LambdaMod.AddCommand( "credits", function( ply, cmd, args )
    local credits = {
        "LambdaMod was developed by:",
        "   LambdaMod developed by AxelBadDev",
        "   Pluginloader made by YourLocalSunny modified by AxelBadDev",
        "   Half-Life 2 Sandbox++ made by YourLocalMoon/ThePixelMoon",
        "   Inspired by Metamod:Source/SourceMod",
    }
	LambdaMod.CPrint(0, table.concat( credits, "\n") )
end, "Credits", "" )

