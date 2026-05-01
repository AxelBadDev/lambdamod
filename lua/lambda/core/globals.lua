function LambdaMod.ExposeToGlobal( t )
    assert( type( t ) == "table", "bad argument #1 to 'ExposeToGlobal' (table expected got "..type(t)..")")
    
    for k,v in pairs( t ) do
        --LambdaMod.StatePrintf( 0, "Create global enum: %s\n", ( "LAMBDAMOD_" .. k:upper() ) )
        _G["LAMBDAMOD_" .. k:upper() ] = v
    end
end 