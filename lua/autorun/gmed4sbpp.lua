--[[ 
   *
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   *
   * Purpose: GMED Implemention (Partial)
   *
   *
]]

GMED4SBPP_VERSION = "1.1"
GMED4SBPP_CORE_PROFILE = ""

if SERVER or _SERVER then
  GMED4SBPP_CORE_PROFILE = "SERVER"
else
  GMED4SBPP_CORE_PROFILE = "CLIENT"
end

local modPath = 
{
	"gmed4sbpp/hud.lua",
	"gmed4sbpp/fcvar_gmed.lua",
	"gmed4sbpp/concommand.lua",
	"gmed4sbpp/defines_gmod9.lua"
}
dbg.ConColorMsg(Color(0, 255, 0, 255), string.format("[%s] GMED4SBPP Initialized\n", GMED4SBPP_CORE_PROFILE))
dbg.ConColorMsg(Color(0, 255, 0, 255), string.format("Running GMED4SBPP %s\n", GMED4SBPP_VERSION))

local function LoadGMED4SBPP()
    
    local files = file.Find( "lua/gmed4sbpp/*.lua", "MOD" )

    for k, v in ipairs( files ) do
        dbg.ConColorMsg(Color(0, 255, 0, 255), string.format("[%s][GMED4SBPP] Include: core/%s\n", GMED4SBPP_CORE_PROFILE, v ) )
        include("gmed4sbpp/" .. v )
    end
end    

LoadGMED4SBPP()