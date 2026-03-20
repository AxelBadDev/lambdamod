--[[ 
   *
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * 
   * Purpose: Plugin loader
   *
   * Notice: This code contains YourLocalCappy's ESM 2.0 Addon loader source code
   * and indeed incompatible with ESM 2.0's Addons
   *
]]

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

LambdaMod.Loader.Path = "addons/lambdamod-main/lua/scripting/"
LambdaMod.Loader.CPath = "addons/lambdamod-main/lua/plugins/"
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

file = file or {}
f = f or {}

FILESYSTEM_INVALID_HANDLE = FILESYSTEM_INVALID_HANDLE or nil

-- write a string to a file (overwrite)
function file.Write(name, content)
  local f = filesystem.Open(name, "w", "MOD")
  if not f then
    return false
  end
  local success = filesystem.Write(content, f) == #content
  filesystem.Close(f)
  return success
end

-- append a string to a file
function file.Append(name, content)
  local f = filesystem.Open(name, "a", "MOD")
  if not f then
    return false
  end
  local success = filesystem.Write(content, f) == #content
  filesystem.Close(f)
  return success
end

-- read a file
function file.Read(name)
  local f = filesystem.Open(name, "r", "MOD")
  if not f or f == FILESYSTEM_INVALID_HANDLE then
    return nil
  end
  local size = filesystem.Size(f)
  if size <= 0 then
    filesystem.Close(f)
    return nil
  end
  local _, content = filesystem.Read(size, f)
  filesystem.Close(f)
  return content
end

-- async read (calls callback with content)
function file.AsyncRead(name, gamePath, callback, sync)
  local f = filesystem.Open(name, "r", gamePath or "MOD")
  if not f then
    callback(nil)
    return
  end
  local size = filesystem.Size(f)

  local function readFunc()
    local _, content = filesystem.Read(size, f)
    filesystem.Close(f)
    callback(content)
  end

  if sync then
    readFunc()
  else
    -- TODO: run async
    readFunc()
  end
end

-- check if a file exists
function file.Exists(name, gamePath)
  return filesystem.FileExists(name, gamePath or "MOD")
end

-- check if a directory
function file.IsDir(name, gamePath)
  return filesystem.IsDirectory(name, gamePath or "MOD")
end

-- create a directory
function file.CreateDir(name)
  filesystem.CreateDirHierarchy(name, "MOD")
end

-- delete a file
function file.Delete(name)
  return filesystem.RemoveFile(name, "MOD")
end

-- rename a file
function file.Rename(oldName, newName)
  return filesystem.RenameFile(oldName, newName, "MOD")
end

-- get file size
function file.Size(name)
  local f = filesystem.Open(name, "r", "MOD")
  if not f or f == FILESYSTEM_INVALID_HANDLE then
    return 0
  end
  local size = filesystem.Size(f)
  filesystem.Close(f)
  return size
end

-- get file modification time
function file.Time(name)
  -- TODO: fix
  return 0
end

-- find files/folders in a directory
function file.Find(pattern, path, sorting)
  return filesystem.Find(pattern, path or "MOD")
end


--f = f or {}

---@param path string
---@param mode string
---@return file*|nil

local function fileFind(pattern, path, sorting)
  return filesystem.Find(pattern, path or "MOD")
end

local function safe_open(path, mode)
    local ok, file = pcall(io.open, path, mode)
    if not ok then
        return nil
    end
    return file
end

---@param fn function
---@return boolean
local function safe_call(fn)
    return pcall(fn)
end

---@param path string
---@return boolean
function f.Exists(path)
    local file = safe_open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

---@param path string
---@return string|nil
function f.Read(path)
    if filesystem and filesystem.Open then
        local file = filesystem.Open(path, "r", "MOD")
        if not file then
            return nil
        end

        local size = filesystem.Size(file)
        if not size or size <= 0 then
            filesystem.Close(file)
            return ""
        end

        local _, data = filesystem.Read(size, file)
        filesystem.Close(file)
        return data
    end

    local file = safe_open(path, "r")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()
    return content
end

---@param path string
---@param content string?
---@return boolean
function f.Write(path, content)
    local file = safe_open(path, "w")
    if not file then
        return false
    end
    file:write(content or "")
    file:close()
    return true
end

---@param path string
---@param content string?
---@return boolean
function f.Append(path, content)
    local file = safe_open(path, "a")
    if not file then
        return false
    end
    file:write(content or "")
    file:close()
    return true
end

---@param path string
---@return string[]|nil
function f.ReadLines(path)
    local file = safe_open(path, "r")
    if not file then
        return nil
    end
    local lines = {}
    for line in file:lines() do
        lines[#lines + 1] = line
    end
    file:close()
    return lines
end

---@param path string
---@param lines string[]
---@return boolean
function f.WriteLines(path, lines)
    local file = safe_open(path, "w")
    if not file then
        return false
    end
    for i = 1, #lines do
        file:write(lines[i], "\n")
    end
    file:close()
    return true
end

---@param path string
---@return integer|nil
function f.Size(path)
    local file = safe_open(path, "r")
    if not file then
        return nil
    end
    local size = file:seek("end")
    file:close()
    return size
end

---@param path string
---@return boolean
function f.IsEmpty(path)
    local size = f.Size(path)
    return size == 0
end

---@param path string
---@return boolean
function f.Delete(path)
    return safe_call(
        function()
            os.remove(path)
        end
    )
end

---@param from string
---@param to string
---@return boolean
function f.Move(from, to)
    return safe_call(
        function()
            os.rename(from, to)
        end
    )
end

---@param from string
---@param to string
---@return boolean
function f.Copy(from, to)
    local content = f.Read(from)
    if not content then
        return false
    end
    return f.Write(to, content)
end

---@param path string
---@return boolean
function f.Touch(path)
    if f.Exists(path) then
        return true
    end
    return f.Write(path, "")
end

---@param path string
---@return boolean
function f.MakeDir(path)
    return safe_call(
        function()
            os.execute('mkdir "' .. path .. '"') -- @hedv948-source: ThePixelMoon please patch this
        end
    )
end

---@param path string
---@return boolean
function f.RemoveDir(path)
    return safe_call(
        function()
            os.execute('rmdir "' .. path .. '"')
        end
    )
end

function f.IsWindows()
    return package.config:sub(1, 1) == "\\"
end

function f.Join(base, relative)
    if base:sub(-1) == "/" or base:sub(-1) == "\\" then
        return base .. relative
    end
    if f.IsWindows() then
        return base .. "\\" .. relative
    end
    return base .. "/" .. relative
end

function f.Normalize(path)
    path = path:gsub("\\", "/")
    path = path:gsub("/+", "/")
    return path
end

---@param dir string
---@param pattern string?
---@return string[]
function f.Find(dir, pattern)
    local tmp = os.tmpname()
    local cmd
    if f.IsWindows() then
        cmd = 'dir "' .. dir .. '" /b /s'
    else
        cmd = 'find "' .. dir .. '" -type f'
    end
    os.execute(cmd .. ' > "' .. tmp .. '"')
    local results = {}
    local lines = f.ReadLines(tmp)
    f.Delete(tmp)
    if not lines then
        return results
    end
    for i = 1, #lines do
        if not pattern or lines[i]:match(pattern) then
            results[#results + 1] = lines[i]
        end
    end
    return results
end

---@param dir string
---@param filename string
---@return string|nil
function f.FindOne(dir, filename)
    local files = f.Find(dir, filename)
    return files[1]
end

---@param path string
---@param mustContain string
---@return boolean
function f.Restrict_Detect(path, mustContain)
    local content = f.Read(path)
    if not content then
        return false
    end
    return content:find(mustContain, 1, true) ~= nil
end

---@param path string
---@param find string
---@param replace string
---@return boolean
function f.Replace(path, find, replace)
    local content = f.Read(path)
    if not content then
        return false
    end
    content = content:gsub(find, replace)
    return f.Write(path, content)
end

---@param path string
---@param line string
---@return boolean
function f.HasLine(path, line)
    local lines = f.ReadLines(path)
    if not lines then
        return false
    end
    for i = 1, #lines do
        if lines[i] == line then
            return true
        end
    end
    return false
end

---@param path string
---@param prefix string
---@return string[]
function f.FilterByPrefix(path, prefix)
    local lines = f.ReadLines(path)
    local out = {}
    if not lines then
        return out
    end
    for i = 1, #lines do
        if lines[i]:sub(1, #prefix) == prefix then
            out[#out + 1] = lines[i]
        end
    end
    return out
end


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
    
    local code = f.Read(path)
    if not code then
        LambdaMod.printfc(3, "Stack Begin\n" )
        LambdaMod.printfc(3, " Failed to read: %s\n", path)
        LambdaMod.printfc(3, "Stack End\n" )
        return
    end

    local fn, err = loadstring(code, path)
    if not fn then
        LambdaMod.printfc(3, "Stack Begin\n" )
        LambdaMod.printfc(3, " Compile error in %s : %s\n", path, tostring(err))
        LambdaMod.printfc(3, "Stack End\n" )
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
        LambdaMod.printfc(3, "Stack Begin\n" )
        LambdaMod.printfc(3, " Runtime error in %s : %s\n", path, tostring(runErr))
        LambdaMod.printfc(3, "Stack End\n" )
        return
    end

    local name = env.myinfo.name or "Unknown"
    local desc = env.myinfo.description or "No description"
    local version = env.myinfo.version or "?"
    local author = env.myinfo.author or "Unknown"
    
    local url = env.myinfo.url or "No URL" 

	local api = env.myinfo.api
	
	if not api then 
	   LambdaMod.printfc(3, "Stack Begin\n" )
	   LambdaMod.printfc(3, " [%s] NoAPIError: \"%s\" API Version is not specified\n",path, name )
	   LambdaMod.printfc(3, "Stack End\n" )
       return 
    end

    LambdaMod.printfc(6, "Loaded addon: %s\n", name)
    LambdaMod.printfc(6, " Description: %s\n", desc)
    LambdaMod.printfc(6, " Version: %s\n", version)
    LambdaMod.printfc(6, " Author: %s\n", author)

    if type(env.OnPluginStart) ~= "function" then
        LambdaMod.printfc(3, "Stack Begin\n" )
        LambdaMod.printfc(3, " [%s] Plugin has no PLUGIN.OnPluginStart(): %s\n",path, name)
        LambdaMod.printfc(3, "Stack End\n" )
        return
    end

	do
		local ok, err = pcall(env.OnPluginStart)
		if not ok then
			LambdaMod.printfc(3, "Stack Begin\n" )
            LambdaMod.printfc(3, " in [\"%s\"] OnPluginStart(): [Error: %s]\n", path, tostring( err ) )
            LambdaMod.printfc(3, "Stack End\n" )
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
		isluac = false
	}
	PLUGIN = nil
end

function CLoader.LoadPlugin(path)
    if Loader.Loaded[ path ] or CLoader.Loaded[path] then return end
    
    local code = f.Read(path)
    if not code then
        LambdaMod.printfc(3, "Stack Begin\n" )
        LambdaMod.printfc(3, " Failed to read: %s\n", path)
        LambdaMod.printfc(3, "Stack End\n" )
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
        LambdaMod.printfc(3, "Stack Begin\n" )
        LambdaMod.printfc(3, " Runtime error in %s : %s\n", path, tostring(runErr))
        LambdaMod.printfc(3, "Stack End\n" )
        return
    end

    local name = env.myinfo.name or "Unknown"
    local desc = env.myinfo.description or "No description"
    local version = env.myinfo.version or "?"
    local author = env.myinfo.author or "Unknown"
    
    local url = env.myinfo.url or "No URL" 

	local api = env.myinfo.api
    
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
	
	if not apo then 
	   LambdaMod.printfc(3, "Stack Begin\n" )
	   LambdaMod.printfc(3, " [%s] NoAPIError: \"%s\" API Version is not specified\n",path, name )
	   LambdaMod.printfc(3, "Stack End\n" )
       return 
    end

    LambdaMod.printfc(6, "Loaded addon: %s\n", name)
    LambdaMod.printfc(6, " Description: %s\n", desc)
    LambdaMod.printfc(6, " Version: %s\n", version)
    LambdaMod.printfc(6, " Author: %s\n", author)
    --LambdaMod.printfc(6, " Type: %s\n", mod_type)

    if type(env.OnPluginStart) ~= "function" then
        LambdaMod.printfc(3, "Stack Begin\n" )
        LambdaMod.printfc(3, " [%s] Plugin has no PLUGIN.OnPluginStart(): %s\n",path, name)
        LambdaMod.printfc(3, "Stack End\n" )
        return
    end

	do
		local ok, err = pcall(env.OnPluginStart)
		if not ok then
			LambdaMod.printfc(3, "Stack Begin\n" )
            LambdaMod.printfc(3, " in [\"%s\"] OnPluginStart(): [Error: %s]\n", path, tostring( err ) )
            LambdaMod.printfc(3, "Stack End\n" )
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

LambdaMod.AddCommand( "plugins", function( ply, cmd, arg )
  local files = file.Find(Loader.Path .. "*.lua", "MOD")

  if not arg then 
	LambdaMod.printfc(0, "Usage: lambda plugins <version|refresh|list>\n")
  end
  if arg == "version" then 
	LambdaMod.printfc(0, "LambdaMod Loader Version: %s\n", tostring( LambdaMod.INFO._VERSION ) )
	LambdaMod.printfc(0, "LambdaMod API: %s\n", tostring( Loader.api.version ) )
  elseif arg == "refresh" then
	Loader.LoadAll()
  elseif arg == "list" then
	if not files or #files == 0 then
        LambdaMod.printc(3, "No plugins found")
        return
    end
    --LambdaMod.printc(0, "LambdaMod Plugins:" )
    --LambdaMod.printfc(0, "-Id- Name                  Version        Author        Status\n")
    LambdaMod.printfc(0, "%-25s %-20s %-15s %-10s\n", "-Id- Name", "Version", "Author", "Compiled")
    --LambdaMod.printfc(0, "[00] %s                    %s             %s            NONE\n", tostring( v.name ), tostring( v.version ), tostring( v.author ) )
    for k, v in pairs(Loader.Loaded) do
	    LambdaMod.printfc(0, "[00] %-25s %-22s %-15s %-10s\n", v.name, v.version, v.author, tostring( v.isluac ) )
	end
  end
end, "", "<version|refresh|list>" ) 

LambdaMod.AddCommand( "cloader", function( ply, cmd, arg )
  Msg( tostring( dir ) .. "\n" )
  local files = file.Find( CLoader.CPath .. CLoader.Path .. "*.luac", "MOD")

  if not arg then 
	LambdaMod.printfc(0, "Usage: lambda cloader <version|refresh|list>\n")
  end
  if arg == "version" then 
	LambdaMod.printfc(0, "LambdaMod Compiled Loader Version: %s\n", tostring( LambdaMod.INFO._VERSION ) )
	LambdaMod.printfc(0, "LambdaMod API: %s\n", tostring( CLoader.api.version ) )
  elseif arg == "refresh" then
	CLoader.LoadAll()
  elseif arg == "list" then
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
