--[[

     Admin flags:
     
         DEFAULT                         0 [UNUSED]
         
         _ADMIN_GENERIC                   30    
         _ADMIN_KICK                      40
         _ADMIN_BAN                       50
         _ADMIN_SLAY                      70
         _ADMIN_CHEATS                    150
         _ADMIN_ROOT                      200

]]
--includeC("define_admin.lua")
if _G._DEFINES then return end
_G._DEFINES = {}

---@class _G._DEFINES
_G._DEFINES._VERSION = "2.3e"
_G._DEFINES._BRANCH = "experimential"
_G._DEFINES._BUILD = "0106"
_G._DEFINES._GAME_VERSION = "1.1"
_G._DEFINES._DEVELOPMENT = true

_G.__LAMBDAMOD_VERSION 	 = _G._DEFINES._VERSION
_G.__LAMBDAMOD_BRANCH 	  = _G._DEFINES._BRANCH
_G.__LAMBDAMOD_BUILD 	   = _G._DEFINES._BUILD
_G.__LAMBDAMOD_GAME_VERSION = _G._DEFINES._GAME_VERSION

_G._DEFINES._MONTHS = {
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
local month = _G._DEFINES._MONTHS
---@sub class _BUILD_DATA
_G._DEFINES._BUILD_DATA = {
	day = "20",
	month = month[3],
	year = "2026"
}


_G._DEFINES.Settings = {}
_G._DEFINES.Settings.Console_Prefix = "CONSOLE"

_G._DEFINES.SCOLOR = {}

_G._DEFINES.SCOLOR.CYAN    = Color(0, 255, 255, 255)
_G._DEFINES.SCOLOR.YELLOW  = Color(255, 255, 0, 255)
_G._DEFINES.SCOLOR.RED     = Color(255, 0, 0, 255)
_G._DEFINES.SCOLOR.LUAPLUS = Color(255, 120, 255, 255)
_G._DEFINES.SCOLOR.GREEN   = Color(0, 255, 0, 255)

_G._DEFINES.MCOLOR = {}

_G._DEFINES.MCOLOR.WHITE   = 0
_G._DEFINES.MCOLOR.CYAN    = 1
_G._DEFINES.MCOLOR.WARNING = 2
_G._DEFINES.MCOLOR.ERR     = 3
_G._DEFINES.MCOLOR.LUAPLUS = 4
_G._DEFINES.MCOLOR.GREEN   = 5
_G._DEFINES.MCOLOR.INFO    = 6


for k, v in pairs(_G._DEFINES.MCOLOR) do
	_G["MCOLOR_" .. k] = v 
end

for k, v in pairs(_G._DEFINES.SCOLOR) do
	_G["SCOLOR_" .. k] = v 
end

local function tableToSet(tble)
		local set = {}
		for _, v in ipairs(tble) do
				set[v] = true
		end
		return set
end

local blacklistedCmds = {
		"sv_cheats",
		"exec",
		"lua_dostring",
		"lua_dostring_cl",
		"lua_dofile",
		"lua_dofile_cl",
		"developer",
		"ent_fire",
		"echo",
		"fps_max",
		"quit",
		"sv_password",
		"name",
		"connect",
		"buildcubemaps",
		"bind",
		"unbind",
		"unbindall"
}

_G._DEFINES._GENERIC = 
{
	
}