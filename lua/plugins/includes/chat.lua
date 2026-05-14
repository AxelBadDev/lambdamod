--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LIBRARY:RegLibrary( {
    name = "ChatCmd",
    author = "hedv948-source",
    description = "Chat command interface",
    version = LAMBDAMOD_VERSION,
    api = LAMBDAMOD_API_VERSION,
    url = "https://github.com/hedv948-source/lambdamod/"
} )

function LIBRARY:AddCmd( pName, func, desc, aliases )
    LambdaMod.ChatCmd.AddCommand( pName, func, desc, aliases )
end    

function LIBRARY:AddAdminCmd( pName, func, desc, aliases )
    LambdaMod.ChatCmd.AddAdminCommand( pName, func, desc, aliases )
end    