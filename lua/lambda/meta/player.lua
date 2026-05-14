--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

local getmetatable = getmetatable
local setmetatable = setmetatable
--local CBasePlayer = _R.CBasePlayer

local function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

function _R.CBasePlayer.IsAdmin( self )
  local name = self:GetPlayerName()
  return tobool( _G.LambdaMod.AdminCFG[ name ].admin ) == true
end  
  
function _R.CBasePlayer.ConCommand( self, cmd )
    engine.ClientCommand( self, cmd )
end    