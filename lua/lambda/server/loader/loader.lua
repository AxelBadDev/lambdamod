--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Plugin/library loader
--
--============================================================================--

includeC "plugins/IPluginManager.lua" 

local IPluginObj = LambdaMod.IPluginObj
local easyfs = require( "easyfs" )

function string_StartsWith( str, start )
    return string.sub( str, 1, string.len( start ) ) == start
end

function string_EndsWith( str, endStr )
    return endStr == "" or string.sub( str, -string.len( endStr ) ) == endStr
end

LAMBDAMOD_PLUGIN_PATH = "plugins/"
LAMBDAMOD_LIBRARY_PATH = "plugins/includes/"
        
local function LoadAll()
    local extLibPath = "lua/" .. LAMBDAMOD_LIBRARY_PATH
    local extPl = "lua/" .. LAMBDAMOD_PLUGIN_PATH
    local libFiles = easyfs.Find( extLibPath .. "*.lua", "MOD")
    
    LambdaMod.CPrintf( 7, "[LM] Library:")
    LambdaMod.CPrintf( 6, " Loading %d files\n", #libFiles )
    
    local ok, err = pcall( function() 
        for _, name in ipairs( libFiles ) do
            LambdaMod.CPrintf( 1, "Loading %s\n", tostring( extLibPath .. name ) )
            ILibraryLoader.LoadLibrary( extLibPath .. name )
        end
    end )
    
    if( !ok ) then
        LambdaMod.CPrintf( 3, "[LM] Library Loader Failed: %s\n", tostring( err ) )
    end        
end

local function LoadPlugin()
    local extPl = "lua/" .. LAMBDAMOD_PLUGIN_PATH
    local pluginFiles = easyfs.Find(  extPl .. "*.lua", "MOD")
    
    LambdaMod.CPrintf( 7, "[LM] Plugin: ")
    LambdaMod.CPrintf( 6, " Loading %d files\n", #pluginFiles )
    
    local ok, err = pcall( function()
        for _, name in ipairs( pluginFiles ) do
            LambdaMod.CPrintf( 1, "Loading %s\n", tostring( LAMBDAMOD_PLUGIN_PATH .. name ) )
            IPluginLoader.LoadPlugin( LAMBDAMOD_PLUGIN_PATH .. name )
        end
    end )    
    
    if( !ok ) then
        LambdaMod.CPrintf( 3, "[LM] Loader Failed: %s\n", tostring( err ) )
    end   
end    

LoadAll()
LoadPlugin()