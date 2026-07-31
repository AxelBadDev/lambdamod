--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--
LambdaMod.SandboxENV = {}

local cprint = _G.print
local function print(...)
    local args = {...}
    local szMsg = ""
    if #args > 0 then
        szMsg = szMsg .. table.concat(args, " ")
    end
    
    dbg.ConMsg(tostring(szMsg) .. "\n")
end
        
local meta = {
    ENV = {}
}
meta.__index = meta

function meta:AddField(name, field)
    if self.ENV[name] != nil then return end
    self.ENV[name] = field
end

function meta:Dostring(code, name, bErrorHandle) 
    name = name or nil
    local func, err = loadstring(code, name)  
    if not func then
         LambdaMod.error( "[%s] Sandbox compilation error: %s", tostring(name), err )
         return false
    end
    setfenv(func, self.ENV)
    local ok, err = pcall(func)
    if not ok then
        LambdaMod.error("[%s] Sandbox runtime error: %s", tostring(name), err)
        return false
    end
    
    return true
end        
       
function meta:GetField(name)
    if not self.ENV[name] then return nil end
    return self.ENV[name]  
end   
--[[
local env = SandboxENV.new()
env:AddFieldByTable({
    ["print"] = print
})    
]]    
function meta:AddFieldByTable(t)
    for key, value in pairs(t) do
        if self.ENV[key] == nil then
            self.ENV[key] = value
        end    
    end
end 
       
function LambdaMod.SandboxENV.new()
    return setmetatable({}, meta)
end    

