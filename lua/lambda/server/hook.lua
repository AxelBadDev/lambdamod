--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LambdaMod.Hook = {}
LambdaMod.Hook.tHooks = {}
LambdaMod.Hook.tReturns = {}

local tHooks = LambdaMod.Hook.tHooks
local tReturns = LambdaMod.Hook.tHooks

function LambdaMod.Hook.Simple( pHookName, pFn )
    tHooks[ pHookName ] = tHooks[ pHookName ] or {}
    tHooks[ pHookName ][ pHookName .. "_" .. tostring(math.random(1000000)) ] = pFn
end    

function LambdaMod.Hook.Add( pHookName, pEventName, pFn )
    tHooks[ pHookName ] = tHooks[ pHookName ] or {}
    tHooks[ pHookName ][ pEventName ] = pFn
end    

function LambdaMod.Hook.Run( pHookName, ... )
    local tHooks = tHooks[ pHookName ]
    if tHooks ~= nil then
        for k, v in pairs( tHooks ) do
            if v == nil then
                dbg.Warning( "LambdaHook: Hook '" .. tostring(k) .. "' (" .. tostring( pHookName ) .. ") tried to call a nil function!\n" )
                tHooks[k] = nil
                break
            else
                tReturns = { pcall(v, ...) }
                if tReturns[1] == false then
                    dbg.Warning(
                        "LambdaHook: Hook '" ..
                         tostring(k) .. "' (" .. tostring(pHookName) .. ") Failed: " .. tostring(tReturns[2]) .. "\n"
                    )
                    tHooks[k] = nil
                elseif tReturns[2] ~= nil then
                    return unpack(tReturns, 2)
                end
            end
        end
    end
end