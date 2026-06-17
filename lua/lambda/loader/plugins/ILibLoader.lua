--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

includeC "IPluginShared.lua"
local IPluginObj = LambdaMod.IPluginObj
--includeC "base/libobject.lua"

local easyfs = require( "easyfs" )

ILibraryLoader = ILibraryLoader or {}

function ILibraryLoader.LoadLibrary( path )
    --LambdaMod.CPrintf( 5, "LoadLibrary: ")
    --LambdaMod.CPrintf( 6, "Loading %s\n", tostring( path ))
    do
        local name = LambdaMod.LibraryNameFromPath( path )
        if ( LambdaMod.__libraries[ name ] ) then
            return
        end
    end
    
    local content = easyfs.Read( path )       
    if ( !content ) then
        dbg.Warning( "\tLoadLibrary: couldn't open: '" .. path .. "' no such a file or directory\n" )
        return
    end
    
    local fn, err = loadstring( content, path ) 
    if ( !fn ) then
        dbg.Warning( "\tLoadLibrary: [Lua compile error]['"..path.."']: " .. err .. "\n" )
        return
    end    
    
    LIBRARY = IPluginObj.Library()
    
    local ok, out = pcall( fn ) 
    if ( !ok ) then
        dbg.Warning( "\tLoadLibrary: [Lua runtime error]['"..path.."']: " .. out .. "\n" )
        return
    end  
    
    LIBRARY.path = path
    
    local name = LIBRARY.name
    local version = LIBRARY.version
    local author = LIBRARY.author
    local url = LIBRARY.url
    local desc = LIBRARY.description
    local api_version = LIBRARY.api
    
    if ( !api_version ) then 
       LambdaMod.CPrintf( 3, "\tUnable to load \"%s\": unable to load library (undefined api version).\n", path )
	   --LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
       return 
    elseif ( !IPluginShared.CheckAPIVersion( tonumber( api_version ) ) ) then
       LambdaMod.CPrintf( 3, "\tUnable to load \"%s\": unable to load library (api version is too oudated).\n", path )
       --LambdaMod.__REG_PLUGINS[ path ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
       return 
    end   
    
    --LambdaMod.RegLibrary( LIBRARY )
    LIBRARY = nil
end   
return ILibraryLoader