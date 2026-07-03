--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

--TODO: Print message using enum instead of numbers

local FCVAR_HIDDEN = FCVAR_HIDDEN or _E.FCVAR.HIDDEN
LambdaMod._CMD = {
    registered = {}
}

LambdaMod.Registered  = {}

local PrintMessage = LambdaMod.Usermsg.PrintMessage
local HUD_PRINTCONSOLE = LambdaMod.Enum.HUD.PRINTCONSOLE    
local format = string.format

--- Adds a lambda command
---@param pName string
---@param pFn function
---@param pHelp? string
---@param pHelpArg? string
function LambdaMod.AddCommand( pName, pFn, pHelp, pHelpArg )
    if ( LambdaMod._CMD.registered[ pName ] ) then
        LambdaMod.CPrintf(3, "LambdaMod.AddCommand: Command already exists (%s)\n", tostring( pName) );
        return;
    end
    --if type(pFn) ~= "function" then return end
    --LambdaMod.CPrintf( 5, "Registered Commands: %s\n", tostring(pName))
    LambdaMod._CMD.registered[ pName ] =
    { 
        func = pFn,
        help = pHelp or "",
        helpArg = pHelpArg or ""
    }
end

function LambdaMod.ListCommand()
  for k, v in pairs( LambdaMod._CMD.registered ) do
    LambdaMod.CPrintf(0, "Command: %s Help: %s\n", tostring( k ), tostring( v.help ) )
  end
end

--- Running a non console command
---@param pPlayer CBasePlayer
---@param pArg string[]
function LambdaMod.RunCommand( pPlayer, pCmd, pArg )
    if ( !LambdaMod._CMD.registered || LambdaMod._CMD.registered == nil ) then return end
    
    
    local cmdName = string.lower( pCmd or "" )
    
    if ( !cmdName ) then return end
    
    if ( cmdName == "" ) then
        PrintMessage( pPlayer, HUD_PRINTCONSOLE, "[LM] Usage: lambda <command> [arguments]")
        for k, v in pairs( LambdaMod._CMD.registered ) do
            PrintMessage(pPlayer, HUD_PRINTCONSOLE, string.format("    lambda %-12s - %s", tostring( k ), tostring( v.help or "" )))
        end
        
        return
    end
    
    local cmd = LambdaMod._CMD.registered[ cmdName ]
    if ( !cmd ) then
         PrintMessage( pPlayer, HUD_PRINTCONSOLE, string.format("[LM] Unknown command: '%s'", tostring( cmdName ) ))
         return
    end
	
    local ok, err = pcall( cmd.func, pPlayer, cmdName, pArg )
    if ( !ok && err ) then
        PrintMessage( pPlayer, HUD_PRINTCONSOLE, string.format("[LM] Failed to run '%s' : %s", cmdName, tostring(err) ))
        PrintMessage( pPlayer, HUD_PRINTCONSOLE, "If you see this, please report to the server administrator.")
        --return
    end
end
--LambdaMod.AddCommand( pName, pFn, pHelp, pHelpArg)

LambdaMod.AddCommand( "version", function( ply, cmd, args )
    PrintMessage(ply, HUD_PRINTCONSOLE, format("LambdaMod version: %s", tostring( LambdaMod["VERSION"] )))
    PrintMessage(ply, HUD_PRINTCONSOLE, format("Builded on: %s", tostring( LambdaMod["BUILD_DATE"] )))
	--LambdaMod.printfc(0, "Branch: %s\n", tostring( LambdaMod.INFO._BRANCH ))
end, "", "" )

LambdaMod.AddCommand( "help", function( ply, cmd, args )
    PrintMessage( ply, HUD_PRINTCONSOLE, format("%-25s      - %-20s", "Command(s)", "Description"))
	
    for k, v in pairs( LambdaMod.console.registered ) do
        --LambdaMod.printfc(0, "%s            %s\n", tostring( k ), tostring(( v.description or "" )) )
        local cmdtype 
        if ( v.iscvar ) then 
            cmdtype = "convar"
        else 
            cmdtype = "cmd"
        end        
            
        PrintMessage(ply, HUD_PRINTCONSOLE, format("%-25s      - %-20s\n", tostring( k ), tostring( v.description or "None" )))
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
    if ( !ply:IsServer() ) then
        PrintMessage( ply, HUD_PRINTCONSOLE, "Duml can't not be called with client." )
        return false
    end    
    PrintTable( LambdaMod )
end, "Dumps LambdaMod table", "" )

LambdaMod.AddCommand( "credits", function( ply, cmd, args )
    local credits = {
        "LambdaMod was developed by:",
        "   LambdaMod developed by AxelBadDev",
        "   Pluginloader made by YourLocalSunny modified by AxelBadDev",
        "   Half-Life 2 Sandbox++ made by YourLocalMoon/ThePixelMoon (Now Aridity Team)",
        "   Inspired by Metamod:Source/SourceMod",
    }
    for _, text in ipairs(credits) do
        PrintMessage(ply, HUD_PRINTCONSOLE, text)
    end    
end, "Credits", "" )

