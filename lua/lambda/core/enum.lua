--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Enumerations
--
--============================================================================--

---@class Enum
LambdaMod.Enum = {}
local Enum = LambdaMod.Enum

LambdaMod["VERSION"] = "3.3.0"
LambdaMod["BRANCH"] = "exp"
LambdaMod["BUILD"] = "0323"
LambdaMod["GAME_VERSION"] = "1.1"
LambdaMod["DEVELOPMENT"] = true

_G["LAMBDAMOD_VERSION"] 	 = LambdaMod.VERSION
_G["LAMBDAMOD_BRANCH"] 	  = LambdaMod.BRANCH
_G["LAMBDAMOD_BUILD"] 	   = LambdaMod.BUILD
_G["LAMBDAMOD_GAME_VERSION"] = LambdaMod.GAME_VERSION

_E["LAMBDAMOD"] = {}

LambdaMod["MONTHS"] = 
{
	"Jan",
	"Feb",
	"Mar",
	"Apr",
	"May",
	"Jun",
	"Jul",
	"Aug",
	"Sep",
	"Oct",
	"Nov",
	"Dec"
}

LambdaMod.ConsoleColor = 
{
    CONSOLE_DEFAULT = 0,
    CONSOLE_CYAN = 1,
    CONSOLE_WARNING = 2,
    CONSOLE_ERROR = 3,
    CONSOLE_LUAPLUS = 4,
    CONSOLE_GREEN = 5,
    CONSOLE_BLUE = 6,
    CONSOLE_ORANGE = 7
}


LambdaMod["BUILD_DATA"] = 
{
	day = "16",
	month = "June",
	year = "2026"
}

LambdaMod["BUILD_DATE"]  = string.format( 
    "%s %s %s",
    tostring(( LambdaMod["BUILD_DATA"].month or "Jan" )), 
    tostring(( LambdaMod["BUILD_DATA"].day or "1" )), 
    tostring(( LambdaMod["BUILD_DATA"].year or "1970" )) 
)

---@class COLOR
LambdaMod["COLOR"] = 
{
    CYAN    = Color( 0, 255, 255, 255 ),
    WARNING = Color( 255, 255, 0, 255 ),
    RED     = Color( 255, 90, 90, 255 ),
    LUAPLUS = Color( 255, 120, 255, 255 ),
    GREEN   = Color( 0, 255, 0, 255 ),
    BLUE    = Color( 0, 100, 255, 255 ),
    ORANGE  = Color( 255, 127, 0, 255 )
}
--[[
Enum["ColorMap"] = 
{
    [ LambdaMod.ConsoleColor.CONS0LE_CYAN ]    = LambdaMod["COLOR"]["CYAN"],
    [ LambdaMod.ConsoleColor.CONS0LE_WARNING ] = LambdaMod["COLOR"]["WARNING"],
    [ LambdaMod.ConsoleColor.CONS0LE_ERROR ]   = LambdaMod["COLOR"]["RED"],
    [ LambdaMod.ConsoleColor.CONS0LE_LUAPLUS ] = LambdaMod["COLOR"]["LUAPLUS"],
    [ LambdaMod.ConsoleColor.CONS0LE_GREEN ]   = LambdaMod["COLOR"]["GREEN"],
    [ LambdaMod.ConsoleColor.CONS0LE_BLUE ]    = LambdaMod["COLOR"]["BLUE"],
    [ LambdaMod.ConsoleColor.CONS0LE_ORANGE ]  = LambdaMod["COLOR"]["ORANGE"],
} 
]]--
   
---@class _COLOR : COLOR
LambdaMod["_COLOR"] = LambdaMod["COLOR"]


Enum.PluginState = 
{
    PLUGIN_UNLOADED = 0,
    PLUGIN_RUN = 1,
    PLUGIN_ERROR = 2,
    PLUGIN_FAILED = 3,
    PLUGIN_BADLOAD = 4
}

Enum.statePluginName = 
{
    [ Enum.PluginState.PLUGIN_UNLOADED ] = "UNLOAD",
    [ Enum.PluginState.PLUGIN_RUN ] = "RUN",
    [ Enum.PluginState.PLUGIN_ERROR ] = "ERROR",
    [ Enum.PluginState.PLUGIN_FAILED ] = "FAIL",
    [ Enum.PluginState.PLUGIN_BADLOAD ] = "BAD"
}

Enum.AdminFlags = 
{
    RESERVED = bitty.lshift( 1, 0 ), -- 1 << 0 == 1
    GENERIC  = bitty.lshift( 1, 1 ), -- 1 << 1 == 2
    ROOT     = bitty.lshift( 1, 20 ) -- 1 << 20 == 1048576 
}

Enum.Latest = 22
Enum.APIVer = 
{ 
    Enum.Latest 
}

for k, v in pairs(Enum) do
    if _E["LAMBDAMOD"][k] == nil then
        _E["LAMBDAMOD"][k] = v
    end    
end    
LambdaMod.ToEnumGlobal( "API_VERSION", Enum.Latest )  
LambdaMod.ToEnumGlobal( nil, Enum.PluginState )
LambdaMod.ToEnumGlobal( nil, LambdaMod.ConsoleColor )