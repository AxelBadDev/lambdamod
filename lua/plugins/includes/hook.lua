LIBRARY:RegLibrary( {
    name = "Hook",
    author = "hedv948-source",
    description = "Hook interface",
    version = LAMBDAMOD_VERSION,
    api = LAMBDAMOD_API_VERSION,
    url = "https://github.com/hedv948-source/lambdamod/"
} )

function LIBRARY:AddHook( pEventName, pName, func )
    LambdaHook.Add( pEventName, pName, func )
end

function LIBRARY:CallHook( pEventName, ... )
    return LambdaHook.Call( pEventName, ... )
end    
    
    