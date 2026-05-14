--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--
includeC "IPluginShared.lua"
includeC "base/pluginobj.lua"

local easyfs = require( "easyfs" )
IPluginLoader = IPluginLoader or {}

function IPluginLoader.LoadPlugin( path )
    --LambdaMod.CPrintf( 5, "LoadPlugin: ")
    --LambdaMod.CPrintf( 6, "Loading %s\n", tostring( path ))
    do 
        local name = LambdaMod.PluginNameFromPath( path )
        if ( LambdaMod.__plugins[ name ] ) then
            return
        end
    end
    
    PLUGIN = PluginObj:CreateObj()
    
    local mOk, out = pcall( function() 
        includeC( "../../" .. path )
    end )
    
    if ( !mOk ) then
        dbg.Warning( "\tFailed to load '" .. path .. "': " .. out .. "\n" )
        return
    end
        
    PLUGIN.path = "lua/" .. path    
    local name = PLUGIN.myinfo.name 
    local desc = PLUGIN.myinfo.description
    local version = PLUGIN.myinfo.version 
    local author = PLUGIN.myinfo.author
    local url = PLUGIN.myinfo.url 
    local api = PLUGIN.myinfo.api
    
    LambdaMod.RegPlugin( PLUGIN )
    if ( !api ) then 
       LambdaMod.CPrintf( 3, "\tFailed to load \"%s\": Unable to load plugin (unknown api version).\n", path )
	   LambdaMod.__plugins[ name ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED
       return 
    elseif ( !IPluginShared.CheckAPIVersion( tonumber( api ) ) ) then
       LambdaMod.CPrintf( 3, "\tFailed to load \"%s\": Unable to load plugin (api version is too old).\n", path )
       LambdaMod.__plugins[ name ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_FAILED 
       return 
    end   
    
	do
		local ok, err = pcall( PLUGIN.OnPluginStart, PLUGIN )
		if !ok then
            LambdaMod.CPrintf(3, "\tFailed to initialize '%s' (%s) in OnPluginStart(): %s\n", name, path, tostring( err ) )
            LambdaMod.__plugins[ name ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_ERROR 
            return
        end
	end
    LambdaMod.__plugins[ name ].__LOAD_STATUS = LAMBDAMOD_PLUGIN_RUN
    PLUGIN = nil
end    

return IPluginLoader