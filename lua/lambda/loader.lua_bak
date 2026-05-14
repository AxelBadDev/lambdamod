--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: PluginManager for addons
   * Modded from YourLocalCappy/YourLocalSunny ESM 2.0 Loader
--]]

includeC( "includes/splugin.lua" )
includeC( "includes/library.lua" )

if( !string.StartWith || !string.StartsWith  ) then
    function string.StartsWith( str, start )
	    return string.sub( str, 1, string.len( start ) ) == start
    end

    string.StartWith = string.StartsWith
end

if( !string.EndsWith ) then
    function string.EndsWith( str, endStr )
        return endStr == "" or string.sub( str, -string.len( endStr ) ) == endStr
    end
end    

local Msg = dbg.Msg

LambdaMod.Loader = {}
LambdaMod.Loader.Loaded = {}
LambdaMod.Loader.Status = {}

local Loader  = LambdaMod.Loader
local Loaded = LambdaMod.Loader.Loaded

LAMBDAMOD_PLUGIN_PATH = "lua/plugins/"
LAMBDAMOD_LIBRARY_PATH = "lua/plugins/includes/"

function LambdaMod.cvar.AddonCommand( pName, func, pHelp, flags )
  local cmd = "lambda_" .. pName 
  
  LambdaMod.cvar.RegConsoleCmd( cmd, func, pHelp, flags )
end

LambdaMod.Loader.AddonCommand = LambdaMod.cvar.AddonCommand

local function Normalize( base )
    local name = base
    --name = name:lower()
    name = string.gsub(name, "%s+", "")
    --name = string.gsub(name, "[^a-z0-9_]", "")
    
    return name
end

function Loader.Load( path )
    if ( LambdaMod.isRegistered( path ) ) then return end
    
    PLUGIN = PluginObj:CreateObj()
    
    do
        local ok, out = pcall( function()
            includeC( "../" .. path )
        end ) 
        
        if( !ok ) then
            dbg.Warning( "Error while running '" .. path .. "': " .. tostring( out ) .. "\n" )
            return
        end   
    end
    
    local name = PLUGIN.myinfo.name 
    local desc = PLUGIN.myinfo.description
    local version = PLUGIN.myinfo.version 
    local author = PLUGIN.myinfo.author
    local url = PLUGIN.myinfo.url 
    local api = PLUGIN.myinfo.api
    
    LambdaMod.RegPlugin( path, PLUGIN.myinfo )
    
    LambdaMod.CPrintf( 5, "[PluginManager]: ")
    LambdaMod.CPrintf( 6, "Loaded plugin (%s)\n", tostring( name ))
    
    local bRequired, pList = PLUGIN:findRequiredDependencies()
    if( bRequired ) then
        LambdaMod.CPrint( 3, "Following dependencies is missing: \n\t" .. table.concat( pList, "\n\t" ))
        LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
        return
    end 
    
    if ( !api ) then 
	   LambdaMod.Printfc(3, "Lua Error: ")
       LambdaMod.Printfc( 0, "[%s] NoAPIError: \"%s\" API Version is not specified\n", path, tostring(name) )
	   LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
       return 
    elseif ( api != LAMBDAMOD_API_VERSION ) then
       LambdaMod.Printfc( 3, "Lua Error: ") 
       LambdaMod.Printfc( 0, "[%s] OutdatedAPI: \"%s\" API Version is outdated!\n", path, tostring(name) )
       LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
       return 
    end   
    
    if type( PLUGIN.OnPluginStart ) != "function" then
        LambdaMod.CPrintf(3, "Failed to initialize '%s' (%s): Plugin has no PLUGIN.OnPluginStart()\n", tostring( name ), path ) 
        LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
        return
    end
    
	do
		local ok, err = pcall( PLUGIN.OnPluginStart, PLUGIN )
		if !ok then
            LambdaMod.CPrintf(3, "Failed to initialize '%s' (%s) in OnPluginStart(): %s\n", name, path, tostring( err ) )
            LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_ERROR
            return
        end
	end
    
 
    LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_RUNNING
	PLUGIN = nil
end    

local sandbox = 
{
    dbg = dbg,
    getmetatable = getmetatable,
    setmetatable = setmetatable,
    type = type,
    
    pcall = pcall,
    print = print,
    concommand = concommand,
    PluginObj = PluginObj,
    LibraryObj = LibraryObj,
    
    RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd,
    RegAdminCmd = LambdaMod.cvar.RegAdminCmd,
    RegServerCmd = LambdaMod.cvar.RegServerCmd,
    
    ParseTargets = LambdaMod.LibAdmin.ParseTargets,
    
    LambdaMod = 
    {
        RegPlugin = LambdaMod.RegPlugin,
        RegLibrary = LambdaMod.RegLibrary,
        isRegistered = LambdaMod.isRegistered
    }
}
function Loader.LoadLibrary( path )
    if ( LambdaMod.__REG_LIBRARIES_PATH[ path ] ) then return end
    
    local code = file.Read( path )
    if !code then
        dbg.Warning( string.format( "Failed to read: %s\n", path ))
        return
    end
    
    local fn, err = loadstring( code, path )
    if !fn then
        dbg.Warning( string.format( "Compile error in %s : %s\n", path, tostring(err)))
        return
    end
    
    LIBRARY = LibraryObj:Create()
    
    local ok, runErr = pcall( fn )
    if !ok then
        dbg.Warning( string.format( "Runtime error in %s : %s\n", path, tostring(runErr) ))
        return
    end
    
    local libInfo = LIBRARY:GetLibraryInfo()
    
    local name    = libInfo.name 
    local desc    = libInfo.description
    local version = libInfo.version 
    local author  = libInfo.author
    local url     = libInfo.url 
    local api     = libInfo.api
    
    
    
    --local temp = table.copy( LIBRARY )
    --temp.Info.version = nil
    --temp.Info.author = nil
    --temp.Info.api = nil
    --temp.Info.url = nil
    --temp.Info.description = nil
    
    --name = temp.Info.name 
        
    LambdaMod.CPrintf( 5, "[LibManager]: ")
    LambdaMod.CPrintf( 6, "Loaded library (%s)\n", tostring( name ))
    
    local bRequired, pList = LIBRARY:findRequiredDependencies()
    if( bRequired ) then
        dbg.Warning( string.format( "Following dependencies is missing: \n\t" .. table.concat( pList, "\n\t" ) .. "\n" ) )
        --LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
        return
    end 
    
    if ( !api ) then 
	   LambdaMod.Printfc(3, "Lua Error: ")
       LambdaMod.Printfc( 0, "[%s] NoAPIError: \"%s\" API Version is not specified\n", path, tostring(name) )
	   --LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
       return 
    elseif ( api != LAMBDAMOD_API_VERSION ) then
       LambdaMod.Printfc( 3, "Lua Error: ") 
       LambdaMod.Printfc( 0, "[%s] OutdatedAPI: \"%s\" API Version is outdated!\n", path, tostring(name) )
       --LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
       return 
    end   
    
    LambdaMod.__REG_LIBRARIES_PATH[ path ] = Normalize( name )
    LambdaMod.RegLibrary( LIBRARY )
    --LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_RUNNING
	LIBRARY = nil
end    

function Loader.LoadRecursiveLibrary()
    local files, _ = file.Find( LAMBDAMOD_LIBRARY_PATH .. "*.lua", "MOD" )
    if ( !files || #files == 0 ) then
        LambdaMod.CPrintf( 3, "Error! " );
        LambdaMod.CPrintf( 0, "No files found\n" );
        return
    end 
    
    for _, name in ipairs( files ) do
        Loader.LoadLibrary( LAMBDAMOD_LIBRARY_PATH .. name )
    end
end           
    

function Loader.LoadPlugin()
    local files, _ = file.Find( LAMBDAMOD_PLUGIN_PATH .. "*.lua", "MOD" )
    
    if ( !files || #files == 0 ) then
        LambdaMod.CPrintf( 3, "Error! " );
        LambdaMod.CPrintf( 0, "No files found\n" );
        return
    end    
    
    for _, name in ipairs( files ) do
        Loader.Load( "plugins/" .. name )
    end
end    


Loader.LoadRecursiveLibrary()
Loader.LoadPlugin()        
    