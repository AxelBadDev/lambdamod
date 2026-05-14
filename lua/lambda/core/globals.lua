--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Global functions
--
--============================================================================--

function LambdaMod.ToEnumGlobal( name, v )
    --assert( type( t ) == "table", "bad argument #1 to 'ExposeToGlobal' (table expected got "..type(t)..")")
   if type( v ) == "table" then 
       for k,v in pairs( v ) do
           _G["LAMBDAMOD_" .. k:upper() ] = v
       end
   else
       _G["LAMBDAMOD_" .. name:upper() ] = v
   end
end 

