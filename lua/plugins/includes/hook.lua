--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LIBRARY:RegLibrary( {
    name = "Hook",
    author = "AxelBadDev",
    description = "Hook interface",
    version = LAMBDAMOD_VERSION,
    api = LAMBDAMOD_API_VERSION,
    url = "https://github.com/AxelBadDev/lambdamod/"
} )

function LIBRARY:AddHook( pEventName, pName, func )
    LambdaHook.Add( pEventName, pName, func )
end

function LIBRARY:CallHook( pEventName, ... )
    return LambdaHook.Call( pEventName, ... )
end    
    
    