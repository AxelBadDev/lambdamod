--[[

      admin defines
      
      
      
         GENERIC                   30    
         KICK                      40
         BAN                       50
         SLAY                      70
         CHEATS                    150
         ROOT                      200



]]
includeC("define.lua")

_DEFINES = _G._DEFINES or {}

_DEFINES.ADMIN  = {}
_DEFINES.ADCVAR = {}

ADMIN  = _DEFINES.ADMIN or {}
ADCVAR = _DEFINES.ADCVAR or {}

--ADMIN = {}
ADMIN.NONE = 0
ADMIN.SLAY = 16
ADMIN.KICK = 32
ADMIN.BAN = 64
ADMIN.GENERIC = 128
ADMIN.CHEATS = 256
ADMIN.ROOT = 32768

--ADCVAR = {}
ADCVAR.NONE = 0
ADCVAR.SLAY = 16
ADCVAR.KICK = 32
ADCVAR.BAN = 64
ADCVAR.GENERIC = 256
ADCVAR.CHEATS = 512
ADCVAR.RCON_ONLY_CAN_EXECUTE = 32768
ADCVAR.SERVER_CONSOLE_ONLY = 65536


-- No more manual Defines
for key, value in pairs(ADMIN) do
	_G["ADMIN_" .. key] = value
end

for key, value in pairs(ADCVAR) do
	_G["ADCVAR_" .. key] = value
end

-- TODO: Need adding Check permission
