--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Plugin loader
   * Adaptive from YourLocalCappy/YourLocalSunny ESM 2.0 Loader
--]]

includeC( "baseplugin/splugin.lua" )

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

LAMBDAMOD_PLUGIN_PATH = "lua/scripting/"

local Loader  = LambdaMod.Loader

Loader.api = {}
Loader.api.version = "8.2"

function LambdaMod.cvar.AddonCommand( pName, func, pHelp, flags )
  local cmd = SanitizeCommandName( pName )
  
  LambdaMod.cvar.RegConsoleCmd( cmd, func, pHelp, flags )
end

LambdaMod.Loader.AddonCommand = LambdaMod.cvar.AddonCommand

function Loader.LoadPlugin(path)
    if ( !file.Exists( path, "MOD" ) ) then return end
    local fullPath = path
    
    
    --local fullPath
    --if file.IsDir( path, "MOD" ) then
        --fullPath = path .. "/init.lua"
   -- elseif path:EndsWith( ".lua" ) then
        --fullPath = path     
    --end  
    
    if Loader.Loaded[fullPath] then return end
    --if ( !fs ) then error( "No fs library found." ) end
    
    LambdaMod.Printfc(0, "Loading file: %s\n", tostring( fullPath ) )
    
    local code = file.Read(fullPath)
    if !code then
        LambdaMod.printfc(3, "Failed to read: %s\n", fullpath)
        Loader.Loaded[fullPath] = { 
            status = LAMBDAMOD_PLUGIN_BADLOAD
        }
        return
    end

    local fn, err = loadstring(code, fullPath)
    if !fn then
        LambdaMod.printfc(3, "Compile error in %s : %s\n", fullPath, tostring(err))
        Loader.Loaded[fullPath] = { 
            status = LAMBDAMOD_PLUGIN_FAILED 
           }
        return
    end
    
  --  PLUGIN = {}
    --[[
          PLUGIN.info =
          {
          	
          }
    ]]
    
    PLUGIN = PluginObj:CreateObj()
    
    local ok, runErr = pcall(fn)
    if !ok then
        LambdaMod.printfc(3, "Runtime error in %s : %s\n", fullPath, tostring(runErr))
        Loader.Loaded[fullPath] = { 
            status = LAMBDAMOD_PLUGIN_FAILED
           }
        return
    end

    local name = PLUGIN.myinfo.name or "Unknown"
    local desc = PLUGIN.myinfo.description or "No description"
    local version = PLUGIN.myinfo.version or "?"
    local author = PLUGIN.myinfo.author or "Unknown"
    local url = PLUGIN.myinfo.url or "No URL" 
	local api = PLUGIN.myinfo.api
	
	if ( !api ) then 
	   LambdaMod.printfc(3, "[%s] NoAPIError: \"%s\" API Version is not specified\n", fullPath, tostring(name) )
	   Loader.Loaded[fullPath] = { 
           name = name, 
           status = LAMBDAMOD_PLUGIN_ERROR
          }
       return 
    elseif ( api != Loader.api.version ) then
       LambdaMod.printfc(3, "[%s] OutdatedAPI: \"%s\" API Version is not specified\n",fullPath, tostring(name) )
       Loader.Loaded[fullPath] = { 
           name = name, 
           status = LAMBDAMOD_PLUGIN_ERROR
       }
       return 
    end

    LambdaMod.printfc(6, "Loaded plugin: %s\n", name)
    LambdaMod.printfc(6, " Description: %s\n", desc)
    LambdaMod.printfc(6, " Version: %s\n", version)
    LambdaMod.printfc(6, " Author: %s\n", author)

    if type( PLUGIN.OnPluginStart ) != "function" then
        LambdaMod.printfc(3, "[%s] Plugin has no PLUGIN.OnPluginStart(): %s\n", fullPath, tostring( name ) )
        Loader.Loaded[fullPath] = { 
            name = name, 
            status = LAMBDAMOD_PLUGIN_ERROR  
        }
        return
    end

	do
		local ok, err = pcall( PLUGIN.OnPluginStart, PLUGIN )
		if !ok then
            LambdaMod.printfc(3, "in [\"%s\"] OnPluginStart(): [Error: %s]\n", fullPath, tostring( err ) )
            Loader.Loaded[fullPath] = { 
                name = name, 
                status = LAMBDAMOD_PLUGIN_ERROR 
               }
            return
        end
	end
 
    Loader.Loaded[fullPath] = 
	{
    	name = name,
	    description = desc,
		version = version,
		api = api,
		--type = mod_type,
		author = author,
		url = url,
		status = LAMBDAMOD_PLUGIN_RUNNING,
		isluac = false
	}
	PLUGIN = nil
end

function Loader.LoadAll()
    --f.Write(LOG_PATH, "")

    local files = file.Find( LAMBDAMOD_PLUGIN_PATH .. "*", "MOD")
    if ( !files && #files == 0 ) then
        --Log("No addons found")
		LambdaMod.printfc(3, "No plugins found\n" )
        return
    end

    for _, name in ipairs(files) do
        local full = LAMBDAMOD_PLUGIN_PATH .. name
        
        --if( file.IsDir(full, "MOD") ) then
            
        Loader.LoadPlugin(LAMBDAMOD_PLUGIN_PATH .. name)
    end
end
Loader.LoadAll()
--,LambdaMod.Loader.LoadAll()

LambdaMod.AddCommand( "plugins", function( ply, args )
  --local files = file.Find(LAMBDAMOD_PLUGIN_PATH .. "*.lua", "MOD")

  if !args[2] then 
	LambdaMod.printfc(0, "Usage: lambda plugins <version|refresh|list|detail>\n")
  end
  if ( args[2] == "version" ) then 
	LambdaMod.printfc(0, "LambdaMod Loader Version: %s\n", tostring( LambdaMod.INFO._VERSION ) )
	LambdaMod.printfc(0, "LambdaMod API: %s\n", tostring( Loader.api.version ) )
  elseif ( args[2] == "refresh" ) then
	Loader.LoadAll()
  elseif ( args[2] == "list" ) then
	--if ( !files || #files == 0 ) then
        --LambdaMod.printc(3, "No plugins found")
        --return
    --end
    --LambdaMod.printc(0, "LambdaMod Plugins:" )
    --LambdaMod.printfc(0, "-Id- Name                  Version        Author        Status\n")
    LambdaMod.printfc(0, "%-40s %-35s %-30s %-25s\n", "Name", "Version", "Author", "Status")
    --LambdaMod.printfc(0, "[00] %s                    %s             %s            NONE\n", tostring( v.name ), tostring( v.version ), tostring( v.author ) )
    
    for k, v in pairs( Loader.Loaded ) do
        local status
        if ( v.status == LAMBDAMOD_PLUGIN_RUNNING ) then status = "RUN" 
        elseif  ( v.status == LAMBDAMOD_PLUGIN_BADLOAD ) then status = "BAD"
        elseif  ( v.status == LAMBDAMOD_PLUGIN_ERROR ) then status = "ERROR"
        elseif ( v.status == LAMBDAMOD_PLUGIN_FAILED ) then status = "FAIL" 
        end             
	    LambdaMod.printfc(0, "%-40s %-35s %-30s %-25s\n", ( v.name or "Unknown" ), ( v.version or "?" ), ( v.author or "Unknown" ), tostring( status ))
	end
  elseif ( args[2] == "detail" ) then
      if ( !Loader.Loaded || #Loader.Loaded == 0 ) then
          LambdaMod.printc(3, "No plugins found")
          return
      end
      
      LambdaMod.printfc(0, "%-40s %-25s\n", "Path", "Status")
    --LambdaMod.printfc(0, "[00] %s                    %s             %s            NONE\n", tostring( v.name ), tostring( v.version ), tostring( v.author ) )
    
      for k, v in pairs( Loader.Loaded ) do
          local status
          if ( v.status == LAMBDAMOD_PLUGIN_RUNNING ) then status = "RUN" 
          elseif  ( v.status == LAMBDAMOD_PLUGIN_BADLOAD ) then status = "BAD"
          elseif  ( v.status == LAMBDAMOD_PLUGIN_ERROR ) then status = "ERROR"
          elseif ( v.status == LAMBDAMOD_PLUGIN_FAILED ) then status = "FAIL" 
          end             
	      LambdaMod.printfc(0, "%-40s %-25s\n", tostring( k ), tostring( status ))
	  end
  end
end, "", "<version|refresh|list>" )

 
--[[
LambdaMod.AddCommand( "cloader", function( ply, cmd, args )
  Msg( tostring( dir ) .. "\n" )
  local files = file.Find( CLoader.CPath .. CLoader.Path .. "*.luac", "MOD")

  if not args then 
	LambdaMod.printfc(0, "Usage: lambda cloader <version|refresh|list>\n")
  end
  if args == "version" then 
	LambdaMod.printfc(0, "LambdaMod Compiled Loader Version: %s\n", tostring( LambdaMod.INFO._VERSION ) )
	LambdaMod.printfc(0, "LambdaMod API: %s\n", tostring( CLoader.api.version ) )
  elseif args == "refresh" then
	CLoader.LoadAll()
  elseif args == "list" then
	if not files or #files == 0 then
        LambdaMod.printc(3, "No plugins found")
        return
    end
    --LambdaMod.printc(0, "LambdaMod Plugins:" )
    --LambdaMod.printfc(0, "-Id- Name                  Version        Author        Status\n")
    LambdaMod.printfc(0, "%-25s %18s %13s\n", "-Id- Name", "Version", "Author")
    --LambdaMod.printfc(0, "[00] %s                    %s             %s            NONE\n", tostring( v.name ), tostring( v.version ), tostring( v.author ) )
    for k, v in pairs(CLoader.Loaded) do
	    LambdaMod.printfc(0, "[00] %-25s %10s %23s\n", v.name, v.version, v.author)
        
    end
  end
end, "", "<version|refresh|list>" ) 
]] 