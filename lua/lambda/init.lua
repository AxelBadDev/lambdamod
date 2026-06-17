--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

local easyfs = require( "easyfs" )
LambdaMod = LambdaMod or {}

includeC "core/globals.lua"
includeC "core/enum.lua"
includeC "core/print.lua"
includeC "core/config.lua"
includeC "core/core.lua"
includeC "core/concmd_split.lua"
includeC "core/net.lua"
includeC "core/info.lua"

---@class Settings
---@field Console_Prefix
LambdaMod.Settings = {}
LambdaMod.Settings.Console_Prefix = "CONSOLE"

function IncludeFolder( path )
    local state
    if(SERVER) then
        state = "Server"
    elseif (CLIENT) then
        state = "Client"
    end
    
    local fullPath = "lua/" .. path .. "/"
    local fullPath_2 = path .. "/"
    
    local files = easyfs.Find( fullPath .. "*.lua", "MOD" )
    
    if( !files && #files == 0 ) then
        dbg.Warning( "No files found in '"..fullPath.."'\n" )
        return
     end 
       
    for _, v in ipairs( files ) do
        LambdaMod.CPrintf( 4, "[LM] %s ", state )
        LambdaMod.CPrintf( 0, "included %s.\n", ( fullPath_2 .. v ) )
        include(  fullPath_2 ..  v )
    end
end        

IncludeFolder( "lambda/includes/modules")
IncludeFolder( "lambda/includes/extensions" )
IncludeFolder( "lambda/chatbase" )
IncludeFolder( "lambda/meta" )
IncludeFolder( "lambda/loader" )

LambdaMod.CPrintf( 2, "LambdaMod has started! (%s)\n", LambdaMod["VERSION"] )

hook.add( "InitHUD", "LambdaWelcomeMessage", function(pPlayer)
	UTIL.ClientPrint(pPlayer, 3, string.format( "This server is using LambdaMod v%s", tostring( LambdaMod["VERSION"] )))
end ) 

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local RegServerCmd = LambdaMod.cvar.RegServerCmd

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
        LambdaMod.CPrint(0, table.concat( helpText, "\n\t" ) )
        return
    end    
    
    if ( cmd:lower() == "list" ) then
        if ( !LambdaMod.AdminCFG ) then 
            LambdaMod.printfc(0, "[LM] Sorry, but currently admin table isn't available right now.\n")
            return 
        end
        local list = {}
        for k,v in pairs( LambdaMod.AdminCFG ) do
            table.insert(list, k)
            --LambdaMod.printfc(0, "%s\n", tostring( k ) )
        end
        table.sort(list)
        LambdaMod.CPrint(0, "[LM] Admins:\n\t" .. table.concat(list, "\n\t") )
    elseif ( cmd:lower() == "add" ) then
        local name = args[ 2 ]
        local permission = args[ 3 ] or 0
        local group = args[ 4 ] or 0
        if ( name == nil || name == "" ) then
            LambdaMod.CPrint(0, "[LM] Usage: lambda admins add <name> [permission] [group]")
            return
        end 
        LambdaMod.AddAdmin( name, permission, group )
    elseif ( cmd:lower() == "remove" ) then
        local name = args[ 2 ]
        local permission = args[ 3 ] or 0
        local group = args[ 4 ] or 0
        
        if ( name == nil || name == "" ) then
            LambdaMod.CPrint(0, "[LM] Usage: lambda admins remove <name>")
            return
        end   
        
        if ( !LambdaMod.AdminCFG[ name ] ) then
            LambdaMod.CPrint(3, "[LM] Admin '" .. name .. "' doesn't exist.")
            return
        end    
        LambdaMod.RemoveAdmin( name )  
    elseif ( cmd:lower() == "modify" ) then
        local name = args[ 2 ]
        local permission = args[ 3 ] or 0
        local group = args[ 4 ] or 0
        if ( name == nil || name == "" ) then
            LambdaMod.CPrint(0, "[LM] Usage: lambda admins modify <name> [permission] [group]")
            return
        end  
        
        if ( !LambdaMod.AdminCFG[ name ] ) then
            LambdaMod.CPrint(3, "[LM] Admin '" .. name .. "' doesn't exist.")
            return
        end    
        LambdaMod.WriteAdminConfig( name, permission, group )    
        
    elseif ( cmd:lower() == "refresh" ) then
        LambdaMod.CPrint(0, "[LM] Refreshing..." )  
        LambdaMod.LoadAdminConfig()  
    end    
end, "Admin manager" )

RegAdminCmd( "lambda_cvar", function( ply, cmd, arg ) 
  local tCmd = split( arg )
  if ( !tCmd[1] )then
    LambdaMod.printfc(0, "[LM] Usage: lambda_cvar <cvar> <value>\n")
    return
  end
  --engine.ServerCommand( tCmd[1] .. " " .. tostring(tCmd[2]) .. "\n" )
  LambdaMod.cvar.SetValue( tCmd[1], tCmd[2] )
  
  
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