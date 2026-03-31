--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Plugin loader
--]]

if CLIENT then return end

include( "lambda/shared/defines.lua" )
include( "lambda/core/core.lua" )
include( "lambda/core/includes/lambdamod.lua" )
include( "lambda/core/includes/cvar.lua" )
include( "lambda/core/includes/libadmin.lua" )

LambdaMod = LambdaMod or {}

LambdaMod.Loader = {}
LambdaMod.Loader.Loaded = {}
LambdaMod.Loader.Status = {}

LambdaMod.Loader.Path = "lua/scripting/"
LambdaMod.Loader.CPath = "lua/plugins/"
LambdaMod.Loader.LegacyPath = "lua/"

LambdaMod.CLoader = {}
LambdaMod.CLoader.Loaded = {}
LambdaMod.CLoader.Status = {}

LambdaMod.CLoader.Path = "addons/lambdamod-main/lua/plugins/"
LambdaMod.CLoader.CPath = "/storage/emulated/150/Source SDK Base 2013/game/hl2sbpp/"
LambdaMod.CLoader.LegacyPath = "lua/"

local CLoader = LambdaMod.CLoader
local Loader  = LambdaMod.Loader

CLoader.api = {}
CLoader.api.version = "8.1"

Loader.api = {}
Loader.api.version = "8.1"

--local LOG_PATH = "lambdamod/loader.log"
--f.MakeDir("lambdamod_legacy")

local function Log(msg)
	local date = os.date("%X")
	
    local line = string.format("[%s][LM Plugin] %s" , tostring(date), tostring(msg)) --[[ "["tostring(date)"]" .. "[SM Plugin] " .. tostring(msg) ]]
    print(line)
    --f.Append(LOG_PATH, line .. "\n")
end

local function SanitizeCommandName(name)
    name = string.lower(name or "plugin")
    name = string.gsub(name, "%s+", "_")
    name = string.gsub(name, "[^a-z0-9_]", "")
    return "lambda_" .. name
end

function LambdaMod.Loader.AddonCommand( pName, func, pHelp, flags )
  local cmd = SanitizeCommandName( pName )
  
  LambdaMod.cvar.RegConsoleCmd( cmd, func, pHelp, flags )
end

function Loader.LoadPlugin(path)
    if Loader.Loaded[path] then return end
    
    local code = fs.Read(path)
    if not code then
        LambdaMod.printfc(3, "Failed to read: %s\n", path)
        Loader.Loaded[path] = { status = "FAIL" }
        return
    end

    local fn, err = loadstring(code, path)
    if not fn then
        LambdaMod.printfc(3, "Compile error in %s : %s\n", path, tostring(err))
        Loader.Loaded[path] = { status = "FAIL" }
        return
    end
    
  --  PLUGIN = {}
    --[[
          PLUGIN.info =
          {
          	
          }
    ]]
    PLUGIN = {}
    PLUGIN.myinfo = {}
    local env = {}
    -- setmetatable {__index = PLUGIN} -> env
    setmetatable(env, { __index = PLUGIN })
    -- setfenv(fn, env)
    --
    --- local ok, runerr = PROTECTED -> pcall( fn )
    local ok, runErr = pcall(fn)
    if not ok then
        LambdaMod.printfc(3, "Runtime error in %s : %s\n", path, tostring(runErr))
        Loader.Loaded[path] = { status = "ERROR" }
        return
    end

    local name = PLUGIN.myinfo.name or "Unknown"
    local desc = PLUGIN.myinfo.description or "No description"
    local version = PLUGIN.myinfo.version or "?"
    local author = PLUGIN.myinfo.author or "Unknown"
    
    local url = PLUGIN.myinfo.url or "No URL" 

	local api = PLUGIN.myinfo.api
	
	if not api then 
	   LambdaMod.printfc(3, "[%s] NoAPIError: \"%s\" API Version is not specified\n",path, name )
	   Loader.Loaded[path] = { name = name, status = "FAIL" }
       return 
    elseif api ~= Loader.api.version then
       LambdaMod.printfc(3, "[%s] OutdatedAPI: \"%s\" API Version is not specified\n",path, name )
       Loader.Loaded[path] = { name = name, status = "FAIL" }
       return 
    end

    LambdaMod.printfc(6, "Loaded addon: %s\n", name)
    LambdaMod.printfc(6, " Description: %s\n", desc)
    LambdaMod.printfc(6, " Version: %s\n", version)
    LambdaMod.printfc(6, " Author: %s\n", author)

    if type(env.OnPluginStart) ~= "function" then
        LambdaMod.printfc(3, "[%s] Plugin has no PLUGIN.OnPluginStart(): %s\n",path, name)
        Loader.Loaded[path] = { name = name, status = "FAIL" }
        return
    end

	do
		local ok, err = pcall(env.OnPluginStart)
		if not ok then
            LambdaMod.printfc(3, "in [\"%s\"] OnPluginStart(): [Error: %s]\n", path, tostring( err ) )
            Loader.Loaded[path] = { name = name, status = "ERROR" }
            return
        end
	end
    local cmd = SanitizeCommandName(name)
 
    Loader.Loaded[path] = 
	{
    	name = name,
	    description = desc,
		version = version,
		api = api,
		--type = mod_type,
		author = author,
		url = url,
		status = "RUN",
		isluac = false
	}
	PLUGIN = nil
end

function CLoader.LoadPlugin(path)
    if Loader.Loaded[ path ] or CLoader.Loaded[path] then return end
    
    local code = fs.Read(path)
    if not code then
        LambdaMod.printfc(3, "Failed to read: %s\n", path)
        Loader.Loaded[path] = 
		{
        	status = "FAIL"
        }
        return
    end

    --local fn, err = loadstring(code, path)
    --if not fn then
        --LambdaMod.printfc(3, "Stack Begin\n" )
        --LambdaMod.printfc(3, " Compile error in %s : %s\n", path, tostring(err))
        --LambdaMod.printfc(3, "Stack End\n" )
        --return
    --end
    
  --  PLUGIN = {}
    --[[
          PLUGIN.info =
          {
          	
          }
    ]]
    PLUGIN = {}
    PLUGIN.myinfo = {}
    local env = {}
    setmetatable(env, { __index = PLUGIN })
    -- setfenv(fn, env)
    --
    --- local ok, runerr = PROTECTED -> pcall( fn )
    --alocal dir = os.getenv("PWD")
    --Msg( tostring( dir ) .. "\n" )
    local ok, runErr = pcall(dofile, path)
    if not ok then
        LambdaMod.printfc(3, "Runtime error in %s : %s\n", path, tostring(runErr))
        Loader.Loaded[path] = { status = "ERROR" }
        return
    end

    local name = PLUGIN.myinfo.name or "Unknown"
    local desc = PLUGIN.myinfo.description or "No description"
    local version = PLUGIN.myinfo.version or "?"
    local author = PLUGIN.myinfo.author or "Unknown"
    
    local url = PLUGIN.myinfo.url or "No URL" 

	local api = PLUGIN.myinfo.api
    
    --local sm = env.Settings.ShowInSpawnmenu == true
    --local category = env.Settings.Category or "Addons"
    --local icon = env.Settings.Icon or ""

	--local noinit = env.NoAutoCreateCommand == true
    
    --local mod_type = env.type or "Uncategorized" 
    
    --local flags

    --if not sm then
     --category = ""
     --icon = ""
	--end
	
	if not api then 
	   LambdaMod.printfc(3, "[%s] NoAPIError: \"%s\" API Version is not specified\n",path, name )
	   Loader.Loaded[path] = { name = name, status = "FAIL" }
       return 
    elseif api ~= CLoader.api.version then
       LambdaMod.printfc(3, "[%s] OutdatedAPI: \"%s\" API Version is outdated!\n",path, name )
       Loader.Loaded[path] = { name = name, status = "FAIL" }
       return 
    end

    LambdaMod.printfc(6, "Loaded addon: %s\n", name)
    LambdaMod.printfc(6, " Description: %s\n", desc)
    LambdaMod.printfc(6, " Version: %s\n", version)
    LambdaMod.printfc(6, " Author: %s\n", author)
    --LambdaMod.printfc(6, " Type: %s\n", mod_type)

    if type(env.OnPluginStart) ~= "function" then
        LambdaMod.printfc(3, "[%s] Plugin has no PLUGIN.OnPluginStart(): %s\n",path, name)
        Loader.Loaded[path] = { name = name, status = "FAIL" }
        return
    end

	do
		local ok, err = pcall(env.OnPluginStart)
		if not ok then
            LambdaMod.printfc(3, "in [\"%s\"] OnPluginStart(): [Error: %s]\n", path, tostring( err ) )
            Loader.Loaded[path] = { name = name, status = "FAIL" }
            return
        end
	end
    local cmd = SanitizeCommandName(name)
    
    CLoader.Loaded[path] = 
	{
    	name = name,
	    description = desc,
		version = version,
		api = api,
		--type = mod_type,
		author = author,
		url = url,
		status = "RUN",
		isluac = true
	}
	
	Loader.Loaded[path] = 
	{
    	name = name,
	    description = desc,
		version = version,
		api = api,
		--type = mod_type,
		author = author,
		url = url,
		status = "RUN",
		isluac = true
	}
	PLUGIN = nil
end

function Loader.LoadAll()
    --f.Write(LOG_PATH, "")

    local files = file.Find(Loader.Path .. "*.lua", "MOD")
    if not files then
        --Log("No addons found")
		LambdaMod.printfc(3, "No plugins found\n" )
        return
    end

    for _, name in ipairs(files) do
        Loader.LoadPlugin(Loader.Path .. name)
    end
end

function CLoader.LoadAll()
    --f.Write(LOG_PATH, "")
    local files = file.Find( CLoader.CPath .. CLoader.Path .. "*.luac", "MOD")
    if not files then
        --Log("No addons found")
		LambdaMod.printfc(3, "No plugins found\n" )
        return
    end

    for _, name in ipairs(files) do
        CLoader.LoadPlugin(CLoader.CPath .. CLoader.Path .. name)
    end
end

Loader.LoadAll()
CLoader.LoadAll()
--,LambdaMod.Loader.LoadAll()

LambdaMod.AddCommand( "plugins", function( ply, cmd, args )
  local files = file.Find(Loader.Path .. "*.lua", "MOD")

  if not args then 
	LambdaMod.printfc(0, "Usage: lambda plugins <version|refresh|list>\n")
  end
  if args == "version" then 
	LambdaMod.printfc(0, "LambdaMod Loader Version: %s\n", tostring( LambdaMod.INFO._VERSION ) )
	LambdaMod.printfc(0, "LambdaMod API: %s\n", tostring( Loader.api.version ) )
  elseif args == "refresh" then
	Loader.LoadAll()
  elseif args == "list" then
	if not files or #files == 0 then
        LambdaMod.printc(3, "No plugins found")
        return
    end
    --LambdaMod.printc(0, "LambdaMod Plugins:" )
    --LambdaMod.printfc(0, "-Id- Name                  Version        Author        Status\n")
    LambdaMod.printfc(0, "%-40s %-35s %-30s %-25s %-20s\n", "Name", "Version", "Author", "Mode", "Status")
    --LambdaMod.printfc(0, "[00] %s                    %s             %s            NONE\n", tostring( v.name ), tostring( v.version ), tostring( v.author ) )
    for k, v in pairs(Loader.Loaded) do
	    LambdaMod.printfc(0, "%-40s %-35s %-30s %-25s %-20s\n", ( v.name or "Unknown" ), ( v.version or "?" ), ( v.author or "Unknown" ), tostring( v.isluac and "COMPILED" or "INTERPRETED" ), tostring( v.status ))
	end
  end
end, "", "<version|refresh|list>" ) 

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
