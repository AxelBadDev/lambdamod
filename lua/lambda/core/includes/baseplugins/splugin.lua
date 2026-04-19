--========= Copyleft ? 2026 hedv948-source, Some Rights Reserved ============--
--                                                      
-- Purpose:                                   
--                                                      
--==========================================================================--

PluginObj = {}

function PluginObj:CreateObj()
    local o = {} 
    
    setmetatable( o, self ) 
    self.__index = self
    
    o.myinfo = {
        name = "Unknown",
        author = "Unknown",
        description = "A description",
        version = "?",
        api = "",
        url = ""
    }
    return o
end

function PluginObj:Initialize() end
function PluginObj:OnPluginStart() end    

return PluginObj
