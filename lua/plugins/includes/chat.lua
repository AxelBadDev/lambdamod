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