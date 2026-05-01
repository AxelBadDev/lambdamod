--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Plugin loader
   * Adaptive from YourLocalCappy/YourLocalSunny ESM 2.0 Loader
--]]

if _G.__LIBCLAMBDALOADER then return end
_G.__LIBCLAMBDALOADER = true


include( "lambda/core/defines.lua" )
include( "lambda/core/shared.lua" )

LambdaMod = _G.LambdaMod or {}

CLambda = _G.CLambda or {}

CLambda.Loader = {}
CLambda.Loader.Loaded = {}

local function SanitizeCommandName(name)
    name = string.lower(name or "plugin")
    name = string.gsub(name, "%s+", "_")
    name = string.gsub(name, "[^a-z0-9_]", "")
    return "lambda_client_" .. name
end

function CLambda.Loader.Load( path )
	if CLambda.Loader.Loaded[ path ] then return end
	
	if not file.Exists( path, "MOD" ) then return end
	
	local code = fs.Read( path )
	if not code then
		LambdaMod.printfc( 3, "Failed to read: %s\n", tostring( path ) )
		return
	end
	
	local fn
	do
		local err
		fn, err = loadstring( code, path )
		if not fn then
			LambdaMod.printfc(3, "Compile error in %s : %s\n", path, tostring(err))
			return
		end
	end

	CPlugin = {}
	CPlugin.myinfo = {}
	CPlugin.settings = {}
	
	local ok, runErr = pcall( fn )
	if not ok then
		LambdaMod.printfc(3, "Runtime error in %s : %s\n", path, tostring(err))
		return
	end
	
	local name = CPlugin.myinfo.name or "Unknown"
    local desc = CPlugin.myinfo.description or "No description"
    local version = CPlugin.myinfo.version or "?"
    local author = CPlugin.myinfo.author or "Unknown"
    local url = CPlugin.myinfo.url or "No URL" 
    
    local sm = CPlugin.settings.spawnmenu == true
    local category = CPlugin.settings.category or "Addons"
    local icon = CPlugin.settings.icon or ""
    
    if not sm then
     category = ""
     icon = ""
	end
	
	LambdaMod.printfc(6, "Loaded plugin: %s\n", name)
    LambdaMod.printfc(6, " Description: %s\n", desc)
    LambdaMod.printfc(6, " Version: %s\n", version)
    LambdaMod.printfc(6, " Author: %s\n", author)
    
    
	if type(CPlugin.Init) ~= "function" then
        LambdaMod.printfc(3, "Addon has no CPlugin.Init(): " .. name .. "\n")
        return
    end

    local cmd = SanitizeCommandName(name)

    if CLambda and CLambda.cvar and CLambda.cvar.RegClientCmd then
        CLambda.cvar.RegClientCmd (cmd, function()
            local ok2, err2 = pcall( CPlugin.Init )
            if not ok2 then
                LambdaMod.printfc(3, "Content error in " .. name .. ": " .. tostring(err2) .. "\n" )
            end
        end)

        LambdaMod.printfc(0, "Concommand created: " .. cmd .. "\n")
    else
        LambdaMod.printfc(3, "concommand.Create not available\n")
    end

    if CPlugin.settings.spawnmenu == true then
        if smlib and smlib.CreateButtonInHeader then
            smlib.CreateButtonInHeader(
                true,
                "CLambda",
                name,
                icon,
                "",
                cmd,
                category
            )

            LambdaMod.printfc(0, "Spawnmenu button created for addon: " .. name .. "\n")
        else
            LambdaMod.printfc(3, "Spawnmenu requested but smlib not available: " .. name .. "\n")
        end
    end
    
    CLambda.Loader.Loaded[ path ] = true
    CPlugin = nil
end

