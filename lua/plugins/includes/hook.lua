--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LIBRARY:RegLibrary
{
    name = "Hook",
    author = "AxelBadDev",
    description = "Hook interface",
    version = LAMBDAMOD_VERSION,
    api = LAMBDAMOD_API_VERSION,
    url = "https://github.com/AxelBadDev/lambdamod/"
}

function LIBRARY.Add( pEventName, pName, func )
    LambdaMod.Hook.Add( pEventName, pName, func )
end

function LIBRARY.CallHook( pEventName, ... )
    return LambdaMod.Hook.Run( pEventName, ... )
end    
    
    