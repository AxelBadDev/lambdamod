--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Initialize LambdaMod
--]]
--if CLIENT or _CLIENT then return end -- Make sure its server-side only

LambdaMod = LambdaMod or {}

---@class LambdaMod
LambdaMod["VERSION"] = "2.7"
LambdaMod["BRANCH"] = "main"
LambdaMod["BUILD"] = "0200"
LambdaMod["GAME_VERSION"] = "1.1"
LambdaMod["DEVELOPMENT"] = true

LambdaMod.GaggedPlayers = {}

_G["LAMBDAMOD_VERSION"] 	 = LambdaMod.VERSION
_G["LAMBDAMOD_BRANCH"] 	  = LambdaMod.BRANCH
_G["LAMBDAMOD_BUILD"] 	   = LambdaMod.BUILD
_G["LAMBDAMOD_GAME_VERSION"] = LambdaMod.GAME_VERSION

LambdaMod["MONTHS"] = {
	[1]  = "Jan",
	[2]  = "Feb",
	[3]  = "Mar",
	[4]  = "Apr",
	[5]  = "May",
	[6]  = "Jun",
	[7]  = "Jul",
	[8]  = "Aug",
	[9]  = "Sep",
	[10] = "Oct",
	[11] = "Nov",
	[12] = "Dec"
}
local month = LambdaMod["MONTHS"]

LambdaMod["BUILD_DATA"] = {
	day = "19",
	month = month[4],
	year = "2026"
}


LambdaMod.Settings = {}
LambdaMod.Settings.Console_Prefix = "CONSOLE"

LambdaMod["COLOR"] = {
    CYAN    = Color(0, 255, 255, 255),
    WARNING = Color(255, 255, 0, 255),
    RED     = Color(255, 0, 0, 255),
    LUAPLUS = Color(255, 120, 255, 255),
    GREEN   = Color(0, 255, 0, 255),
    INFO    = Color(0, 100, 255, 255)
}    

LambdaMod["_COLOR"] = LambdaMod["COLOR"]

---Expose table enum as Global variable
---@param t table
function LambdaMod.ExposeToGlobal( t )
    assert( type( t ) == "table", "bad argument #1 to 'ExposeToGlobal' (table expected got "..type(t)..")")
    
    for k,v in pairs( t ) do
        LambdaMod.Printfc(1, "Create global enum: %s\n", ( "LAMBDAMOD_" .. k:upper() ) )
        _G["LAMBDAMOD_" .. k:upper() ] = v
    end
end 

function LambdaMod.LogAction(...)
    dbg.Log( "Action: " .. string.format(...) .. "\n")
end           

---Prints colored text
---@param pMode number
---@vararg any
function LambdaMod.Printc(pMode, ...)

	if not pMode or pMode == nil then return end

	if pMode == 0 then  dbg.ConMsg( tostring( ... ) .. "\n" )
	elseif pMode == 1 then dbg.ConColorMsg(LambdaMod.COLOR.CYAN, tostring(...) .. "\n")
	elseif pMode == 2 then dbg.ConColorMsg(LambdaMod.COLOR.WARNING, tostring(...) .. "\n")
	elseif pMode == 3 then dbg.ConColorMsg(LambdaMod.COLOR.RED, tostring(...) .. "\n")
	elseif pMode == 4 then dbg.ConColorMsg(LambdaMod.COLOR.LUAPLUS, tostring(...) .. "\n")
	elseif pMode == 5 then dbg.ConColorMsg(LambdaMod.COLOR.GREEN, tostring(...) .. "\n")
	elseif pMode == 6 then dbg.ConColorMsg(LambdaMod.COLOR.INFO, tostring(...) .. "\n" )	
	end
end

---Prints formatted colored text
---@param pMode number
---@vararg any
function LambdaMod.Printfc(pMode, ...)

	if not pMode or pMode == nil then return end

	if pMode == 0 then dbg.ConMsg( string.format( ... ) )
	elseif pMode == 1 then dbg.ConColorMsg(LambdaMod.COLOR.CYAN, string.format(...))
	elseif pMode == 2 then dbg.ConColorMsg(LambdaMod.COLOR.WARNING, string.format(...) )
	elseif pMode == 3 then dbg.ConColorMsg(LambdaMod.COLOR.RED, string.format(...) )
	elseif pMode == 4 then dbg.ConColorMsg(LambdaMod.COLOR.LUAPLUS, string.format(...))
	elseif pMode == 5 then dbg.ConColorMsg(LambdaMod.COLOR.GREEN, string.format(...))
	elseif pMode == 6 then dbg.ConColorMsg(LambdaMod.COLOR.INFO, string.format(...))
	end
end

LambdaMod.printc = LambdaMod.Printc
LambdaMod.printfc = LambdaMod.Printfc

LambdaMod["INFO"] = 
{
	_VERSION     = LambdaMod["VERSION"] or "fallback-alpha",  --"1.5",
	_BRANCH      = LambdaMod["BRANCH"] or "Unknown",
	_DEVELOPMENT = LambdaMod["DEVELOPMENT"] or true,
	_BUILD       = LambdaMod["BUILD"] or "0",

	_BUILD_DATE  = string.format( 
                        "%s %s %s",	
                        tostring(( LambdaMod["BUILD_DATA"].month or "Jan" )), 
                        tostring(( LambdaMod["BUILD_DATA"].day or "1" )), 
                        tostring(( LambdaMod["BUILD_DATA"].year or "1970" )) 
                   )
}

function LambdaMod.SanitizeCommandName(name)
    name = string.lower(name or "plugin")
    name = string.gsub(name, "%s+", "_")
    name = string.gsub(name, "[^a-z0-9_]", "")
    return "sm_" .. name
end

---Prints cyan text
---@vararg any
function LambdaMod.SCprint(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].CYAN, tostring(...) .. "\n")
end

---Prints yellow text
---@vararg any
function LambdaMod.SYprint(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].WARNING, tostring(...) .. "\n")
end

---Prints red text
---@vararg any
function LambdaMod.SRprint(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].RED, tostring(...) .. "\n")
end

---Prints formatted cyan text
---@vararg any
function LambdaMod.SCprintf(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].CYAN, string.format(...))
end

---Prints formatted yellow text
---@vararg any
function LambdaMod.SYprintf(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].WARNING, string.format(...))
end

---Prints formatted red text
---@vararg any
function LambdaMod.SRPrintf(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].RED, string.format(...))
end

local tempPath = "config/lambdamod"

filesystem.CreateDirHierarchy( tempPath, "MOD" )


---Writes admin configuration
---@param name string
---@param set boolean
function LambdaMod.WriteAdminConfig( name, set )
    --assert( type( set ) == "table", "bad argument #1 to 'WriteAdminConfig' (table expected got "..type( set )..")")
    --UTF8 Encoded
    local buffer = {}
    buffer[name] = set;
    local KV = KeyValues( "Admins" );
    KV:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" );
    for name, data in pairs( buffer ) do
        local admin_kv = KeyValues( tostring( name ) );
        admin_kv:SetString( "admin", data );
        if ( KV:FindKey(tostring(cv)) != NULL_KEYVALUES ) then 
            KV:RemoveSubKey( KV:FindKey( tostring( name ) ) ) 
        end
        KV:AddSubKey( admin_kv );
    end    
    KV:SaveToFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ));
    KV:deleteThis();    
end    

function LambdaMod.LoadAdminConfig()
    local AdminCFG = KeyValues( "Admins" )
    AdminCFG:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" )
    
    LambdaMod.AdminCFG = AdminCFG:ToTable()
end    

function LambdaMod.LoadConfig()
    local Config = KeyValues( "LambdaMod" )
    Config:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "config" ), "MOD" )
    
    LambdaMod.CConfig = Config:ToTable()
end    

---Gets admin table
---@return table
function LambdaMod.GetAdminTable()
    return LambdaMod.AdminCFG
end    
    
LambdaMod.LoadConfig()    
LambdaMod.LoadAdminConfig()   

local function includeCore( pFile )
	include( "core/" .. pFile )
end

local function includelib( pFile )
	includeCore( "includes/" .. pFile  )
end

local function includeFolder( path )
    local gameSide
    if(SERVER) then
        gameSide = "Server"
    elseif (CLIENT) then
        gameSide = "Client"
    end
    
    local fullPath = "lua/" .. path .. "/"
    local fullPath_2 = path .. "/"
    
    local files = file.Find( fullPath .. "*.lua", "MOD" )
    
    if( !files && #files == 0 ) then
        dbg.Warning( "No files found in '"..fullPath.."'\n" )
        return
     end 
       
    for _, v in ipairs( files ) do
        LambdaMod.Printfc( 1, "%s LambdaMod -> included %s.\n", gameSide, ( fullPath_2 .. v ) )
        include(  fullPath_2 ..  v )
    end
end        

--include( "lambda/core/defines.lua" )
--include( "lambda/core/shared.lua" )

if _CLIENT then
	--include( "lambda/core/client/libCLambda.lua" )
	--include( "lambda/core/client/libClientLoader.lua" )
end

if SERVER then
	includeFolder( "lambda/core/includes" )

	hook.add( "InitHUD", "LambdaWelcomeMessage", function(pPlayer)
		UTIL.ClientPrint(pPlayer, 3, string.format( "This server is using LambdaMod v%s", tostring( LambdaMod["VERSION"] )))
	end ) 
end

if ( SERVER ) then
    local GaggedPlayers = LambdaMod.GaggedPlayers

    hook.add( "Host_Say", "BaseCommCheckGag", function( pPlayer, msg, teamonly )
        if ( GaggedPlayers[ pPlayer:GetPlayerName() ] ) then
            LambdaMod.LogAction( "%s tried to chat but is gagged.\n", tostring( pPlayer:GetPlayerName() ) )
            return false -- block the fucking message
        end
    end )
end

local function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

if SERVER then


local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local RegServerCmd = LambdaMod.cvar.RegServerCmd

RegAdminCmd( "lambda_cvar", function( ply, cmd, arg ) 
  local tCmd = split( arg )
  if ( !tCmd[1] )then
    LambdaMod.printfc(0, "Usage: lambda_cvar <cvar> <value>\n")
    return
  end
  --engine.ServerCommand( tCmd[1] .. " " .. tostring(tCmd[2]) .. "\n" )
  LambdaMod.cvar.SetValue( tCmd[1], tCmd[2] )
  
  
end, "Change ConVar value" )

LambdaMod.AddCommand( "admins", function( ply, args )
	if ( !LambdaMod.AdminCFG ) then 
		LambdaMod.printfc(0, "Sorry, but currently admin table isn't available right now.\n")
		return 
	end
	
	for k,v in pairs( LambdaMod.AdminCFG ) do
		LambdaMod.printfc(0, "%s\n", tostring( k ) )
	end
end )

RegServerCmd( "lambda", function( ply, cmd, arg )
	local tCmd = split( arg )
	
	--local parts = {}
    --for word in tCmd:gmatch( "%S+" ) do
        --table.insert( parts, word )
    --end
    
    --local cmdName = string.lower( parts[ 1 ] or "" )
    
	if !tCmd[1] then
		LambdaMod.printfc(0, "Usage:\n")
		for k, v in pairs( LambdaMod.Registered ) do
			LambdaMod.printfc(0, "lambda %s %s\n", tostring( k ), tostring( ( v.helpArg or "" ) ) )
		end
		return
	end
    --if GetConVar("developer"):GetBool() then LambdaMod:printfc(1, "CMD: %s, Args: %s\n", tostring( tCmd[1] ), tostring( tCmd[2]) ) end
	LambdaMod.RunCommand( ply, tCmd )
	--table.remove( 
	
end, "" )    

end