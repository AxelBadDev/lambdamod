--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: VScript implemention
--]]

LambdaMod.vscript = {}
LambdaMod.vscript.util = {}

local timer = require( "timer" )

local vscript = LambdaMod.vscript

function vscript.Run(...) end

function vscript.EntFire(targetname, inp, pString, delay, activator, caller)
    local entity = gEntList.FindEntityByClassname(NULL, targetname)
	libvscript.log_printf("Fired Entity '%s', input '%s', string '%s', delay '%s'\n", tostring(targetname), tostring(inp), tostring(str), tostring(delay))
    while entity:GetBaseEntity() != NULL do 
	
        entity:Fire( inp, pString, ( delay or 0 ), activator, caller )

        entity = gEntList.FindEntityByClassname(entity, targetname)
    end
end

function vscript.FireServer(cmd, delay)
	timer.Simple( ( delay or 0 ), function()
		LambdaMod.Core.ForwardToConsole( cmd )
	end)
end

--[[
---@param inputName string The name of the input to fire (matches `DEFINE_INPUT` names)
---@param value string|nil Optional string value to pass to the input (default `""`)
---@param delay number|nil Optional delay in seconds before the input is processed (default `0`)
---@param activator CBaseEntity|nil Optional CBaseEntity that triggered this input (default `nil`)
---@param caller CBaseEntity|nil Optional CBaseEntity that is considered the caller of this input (default `nil`)
---@return boolean True if the input was handled successfully, false otherwise
function CBaseEntity:Fire(inputName, value, delay, activator, caller) 

]]

function vscript.FireCMD(cmd)
	libvscript.log_printf("Engine: Running Command (%s)\n", tostring( cmd ) )
	if SERVER then
		engine.ServerCommand(cmd)
	else
		engine.ClientCmd_Unrestricted(cmd)
	end
end



function vscript.GetMapName()
	local worldspawn = gEntList.FindEntityByClassname(NULL, "worldspawn"):GetModelName()
	local MapName = string.sub(worldspawn, 6, -5) 
	return MapName
end
--[[
function vscript:EntFire(targetname, inp, str, delay)
	libvscript.log_printf("Fired Entity '%s', input '%s', string '%s', Delay: '%s'\n", tostring(targetname), tostring(inp), tostring(str), tostring(delay))
	timer.Simple(delay, function()
		self.Fire(targetname, inp, str)
	end)
end
]]