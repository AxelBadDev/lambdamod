local tempPath = "config/lambdamod"

filesystem.CreateDirHierarchy( tempPath, "MOD" )

function LambdaMod.WriteAdminLegacyConfig( name, set )
    --assert( type( set ) == "table", "bad argument #1 to 'WriteAdminConfig' (table expected got "..type( set )..")")
    --UTF8 Encoded
    local buffer = {}
    buffer[name] = set 
    local KV = KeyValues( "Admins" );
    KV:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" );
    for cv, data in pairs( buffer ) do
        local admin_kv = KeyValues( tostring( name ) );
        admin_kv:SetString( "admin", data );
        if ( KV:FindKey(tostring( name )) != NULL_KEYVALUES ) then 
            KV:RemoveSubKey( KV:FindKey( tostring( name ) ) ) 
        end
        KV:AddSubKey( admin_kv );
    end    
    KV:SaveToFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ));
    KV:deleteThis();    
end    

function LambdaMod.WriteAdminConfig( name, key, set )
    local buffer = {}
    
    buffer[ name ] = {}
    buffer[ name ][ key ] = set
    local AdminsKV = KeyValues( "Admins" );
    AdminsKV:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" )
    AdminsKV:FindKey( name, true )
        
    local admin_info = KeyValues( tostring( name ) );
    admin_info:SetString( key, set );
    
    if ( AdminsKV:FindKey( tostring( name ) ) != NULL_KEYVALUES ) then 
        AdminsKV:RemoveSubKey( AdminsKV:FindKey( tostring( name ) ) ) 
    end
    AdminsKV:AddSubKey( admin_info );
    AdminsKV:SaveToFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ));
    AdminsKV:deleteThis();    
end    



function LambdaMod.LoadAdminConfig()
    local AdminCFG = KeyValues( "Admins" )
    AdminCFG:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" )
    
    LambdaMod.AdminCFG = AdminCFG:ToTable()
end    

function LambdaMod.LoadConfig()
    local Config = KeyValues( "LambdaMod" )
    Config:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "config" ), "MOD" )
    
    LambdaMod.CConfig = Config:ToTable()
end    

function LambdaMod.GetAdminTable()
    return LambdaMod.AdminCFG
end    

function LambdaMod.GetConfig()
    return LambdaMod.CConfig
end    
    
LambdaMod.LoadConfig()    
LambdaMod.LoadAdminConfig()   