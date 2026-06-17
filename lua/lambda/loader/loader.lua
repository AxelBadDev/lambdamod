--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Plugin/library loader
--
--============================================================================--

includeC "plugins/IPluginManager.lua" 

local IPluginObj = LambdaMod.IPluginObj
local easyfs = require( "easyfs" )

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

LAMBDAMOD_PLUGIN_PATH = "plugins/"
LAMBDAMOD_LIBRARY_PATH = "plugins/includes/"
        
local function LoadAll()
    local extLib = "lua/" .. LAMBDAMOD_LIBRARY_PATH
    local extPl = "lua/" .. LAMBDAMOD_PLUGIN_PATH
    local libFiles = easyfs.Find( extLib .. "*.lua", "MOD")
    
    LambdaMod.CPrintf( 7, "[LM][IPLUGINMANAGER][ILibLoader]: ")
    LambdaMod.CPrintf( 6, "Loading %d files\n", #libFiles )
    
    for _, name in ipairs( libFiles ) do
        LambdaMod.CPrintf( 6, "\tLoading %s\n", tostring( extLib .. name ) )
        ILibraryLoader.LoadLibrary( extLib .. name )
    end
end

local function LoadPlugin()
    local extPl = "lua/" .. LAMBDAMOD_PLUGIN_PATH
    local pluginFiles = easyfs.Find(  extPl .. "*.lua", "MOD")
    
    LambdaMod.CPrintf( 7, "[LM][IPLUGINMANAGER][IPluginLoader]: ")
    LambdaMod.CPrintf( 6, "Loading %d files\n", #pluginFiles )
    
    for _, name in ipairs( pluginFiles ) do
        LambdaMod.CPrintf( 6, "\tLoading %s\n", tostring( LAMBDAMOD_PLUGIN_PATH .. name ) )
        IPluginLoader.LoadPlugin( LAMBDAMOD_PLUGIN_PATH .. name )
    end
end    

LoadAll()
LoadPlugin()