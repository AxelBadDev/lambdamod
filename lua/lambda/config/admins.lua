if _G.__LM_CBaseCFG then return end
_G.__LM_CBaseCFG = true

local C_BLACKLIST_CMD = 
{
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


_G._LM_CAdmins = 
{
	--["SourceTest"] = true
}

_G._LM_CLoader = 
{
	--TODO: SOON
}

_G._LM_CBlockCvar = 
{
	
}