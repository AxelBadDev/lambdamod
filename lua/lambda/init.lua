--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

local easyfs = require( "easyfs" )

LambdaMod = LambdaMod or {}

include "lambda/shared/bit.lua"
include "lambda/shared/globals.lua"
include "lambda/shared/enum.lua"
include "lambda/shared/print.lua"
include "lambda/shared/config.lua"
include "lambda/shared/core.lua"
include "lambda/shared/concmd_split.lua"
include "lambda/shared/info.lua"
include "lambda/shared/folderinc.lua"
include "lambda/shared/varlib.lua"
include "lambda/shared/usermsg.lua"
include "lambda/shared/console.lua"
include "lambda/shared/cvar.lua"
include "lambda/shared/conmsgcfg.lua"

local includes = {
    "hook.lua",
    "lambdamod.lua",
    "chatcmd.lua",
    "libadmin.lua",
    "net.lua",
    "plugins.lua",
    "reghooks.lua",
    "vscript.lua",
    "loader/loader.lua"
}


for _, v in ipairs(includes) do
    if ( v != nil ) then
        include( "lambda/server/" .. v )
    end
end        

--IncludeFolder( "lambda/includes/extensions" )
--IncludeFolder( "lambda/includes/modules")
--IncludeFolder( "lambda/chatbase" )
--IncludeFolder( "lambda/meta" )
--IncludeFolder( "lambda/loader" )

LambdaMod.CPrintf( 1, "(Server) LambdaMod has started! (%s)\n", LambdaMod["VERSION"] )

hook.add( "InitHUD", "LambdaWelcomeMessage", function(pPlayer)
	UTIL.ClientPrint(pPlayer, 3, string.format( "This server is using LambdaMod v%s", tostring( LambdaMod["VERSION"] )))
end ) 

local RegConsoleCmd = LambdaMod.RegConsoleCmd
local RegAdminCmd = LambdaMod.RegAdminCmd
local RegServerCmd = LambdaMod.RegServerCmd

local PrintMessage = LambdaMod.Usermsg.PrintMessage
local HUD_PRINTCONSOLE = LambdaMod.Enum.HUD.PRINTCONSOLE

LambdaMod.AddCommand( "admins", function( ply, pCmd, args )
	
    local helpText = {
        "Usage: lambda admins <command> [arguments]",
        "lambda admins list        - List of server admins",
        "lambda admins add         - Add an admin",
        "lambda admins remove      - Remove an admin",
        "lambda admins modify      - Modify an admin data",
        "lambda admins refresh     - Refreshs admin data"
    }
    
    local cmd = args[ 1 ] 
    
    if ( !cmd || cmd == "" ) then
        --LambdaMod.CPrint(0, table.concat( helpText, "\n\t" ) )
        for _, v in ipairs( helpText ) do
            PrintMessage( ply, HUD_PRINTCONSOLE, v )
        end   
        return
    end    
    
    if ( cmd:lower() == "list" ) then
        if ( !LambdaMod.AdminCFG ) then 
            PrintMessage(ply, HUD_PRINTCONSOLE, "Sorry, but currently admin table isn't available right now.\n")
            return 
        end
        local list = {}
        for k,v in pairs( LambdaMod.AdminCFG ) do
            table.insert(list, k)
            --LambdaMod.printfc(0, "%s\n", tostring( k ) )
        end
        table.sort(list)
        --LambdaMod.CPrint(0, "Admins:\n\t" .. table.concat(list, "\n\t") )
        PrintMessage( ply, HUD_PRINTCONSOLE, "[LM] Admins:" )
        for _, v in ipairs(list) do
            PrintMessage(ply, HUD_PRINTCONSOLE, v)
        end    
    elseif ( cmd:lower() == "add" ) then
        local name = args[ 2 ]
        local permission = args[ 3 ] or 0
        local group = args[ 4 ] or 0
        if ( name == nil || name == "" ) then
            PrintMessage(ply, HUD_PRINTCONSOLE, "[LM] Usage: lambda admins add <name> [permission] [group]")
            return
        end 
        LambdaMod.AddAdmin( name, permission, group )
        LambdaMod.LoadAdminConfig()
    elseif ( cmd:lower() == "remove" ) then
        local name = args[ 2 ]
        local permission = args[ 3 ] or 0
        local group = args[ 4 ] or 0
        
        if ( name == nil || name == "" ) then
            PrintMessage(ply, HUD_PRINTCONSOLE, "[LM] Usage: lambda admins remove <name>")
            return
        end   
        
        if ( !LambdaMod.AdminCFG[ name ] ) then
            PrintMessage(ply, HUD_PRINTCONSOLE, "[LM] Admin '" .. name .. "' does not exist.")
            return
        end    
        LambdaMod.RemoveAdmin( name )  
        LambdaMod.LoadAdminConfig()
    elseif ( cmd:lower() == "modify" ) then
        local name = args[ 2 ]
        local permission = args[ 3 ] or 0
        local group = args[ 4 ] or 0
        if ( name == nil || name == "" ) then
            PrintMessage(ply, HUD_PRINTCONSOLE, "[LM] Usage: lambda admins modify <name> [permission] [group]")
            return
        end  
        
        if ( !LambdaMod.AdminCFG[ name ] ) then
            PrintMessage(ply, HUD_PRINTCONSOLE, "[LM] Admin '" .. name .. "' doesn't exist.")
            return
        end    
        LambdaMod.WriteAdminConfig( name, permission, group )    
        
    elseif ( cmd:lower() == "refresh" ) then
        PrintMessage(ply, HUD_PRINTCONSOLE, "[LM] Refreshing..." )  
        LambdaMod.LoadAdminConfig()  
    end    
end, "Admin manager" )

RegAdminCmd( "lambda_cvar", function( ply, cmd, arg ) 
    --local PrintMessage = LambdaMod.Usermsg.PrintMessage
    local tCmd = _CONSPLIT.Q_cmdsplit( arg )
    if ( !tCmd[1] )then
      PrintMessage( ply, HUD_PRINTCONSOLE, "[LM] Usage: lambda_cvar <cvar> <value>" )
      return
    end
  --engine.ServerCommand( tCmd[1] .. " " .. tostring(tCmd[2]) .. "\n" )
    LambdaMod.cvar.SetValue( ply, tCmd[1], tCmd[2] )
  
  
end, "Change ConVar value" )

local function concmd_bor( t )
    assert( type( t ) == "table", "bad argument #1 'concmd_bor' (table expected got " .. type( t ) .. ")" )
    local flags = 0
    
    for _, v in ipairs( t ) do
        flags = bitty.bor( flags, v )
    end 
    
    return flags
end

RegServerCmd( "lambda", function( ply, cmd, arg )
    
    local args = _CONSPLIT.Q_cmdsplit( arg )
    
    --for word in arg:gmatch( "%S+" ) do
        --table.insert( tCmd, word )
    --end
    
    local cmdName = string.lower( args[ 1 ] or "" )
    table.remove( args, 1 )
    
    if ( cmdName ) then
        LambdaMod.RunCommand( ply, cmdName, args )
    end
        
end, "", concmd_bor { FCVAR.HIDDEN, FCVAR.SERVER_CAN_EXECUTE } )  