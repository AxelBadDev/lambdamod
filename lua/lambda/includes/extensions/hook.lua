LambdaHook = LambdaHook or {}
LambdaHook.tHooks = {}
local tHooks = LambdaHook.tHooks

function LambdaHook.Simple( pHookName, pFn )
    tHooks[ pHookName ] = tHooks[ pHookName ] or {}
    tHooks[ pHookName ][ pHookName .. "_" .. tostring(math.random(1000000)) ] = pFn
end    

function LambdaHook.Add( pHookName, pEventName, pFn )
    tHooks[ pHookName ] = tHooks[ pHookName ] or {}
    tHooks[ pHookName ][ pEventName ] = pFn
end    

function LambdaHook.Call( pHookName, ... )
    local tHooks = tHooks[ pHookName ]
    if tHooks ~= nil then
        for k, v in pairs( tHooks ) do
            if v == nil then
                dbg.Warning( "LambdaHook: Hook '" .. tostring(k) .. "' (" .. tostring(strEventName) .. ") tried to call a nil function!\n" )
                tHooks[k] = nil
                break
            else
                tReturns = { pcall(v, ...) }
                if tReturns[1] == false then
                    dbg.Warning(
                        "LambdaHook: Hook '" ..
                         tostring(k) .. "' (" .. tostring(strEventName) .. ") Failed: " .. tostring(tReturns[2]) .. "\n"
                    )
                    tHooks[k] = nil
                elseif tReturns[2] ~= nil then
                    return table.unpack(tReturns, 2)
                end
            end
        end
    end
end

return LambdaHook