--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

IPluginShared = IPluginShared or {}

function IPluginShared.CheckAPIVersion( ver )
    
    for _, v in ipairs( LambdaMod.Enum.APIVer ) do
        if ( ver == v ) then
            return true
        end
    end
    return false
end

return IPluginShared