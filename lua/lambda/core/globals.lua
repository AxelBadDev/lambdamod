--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Global functions
--
--============================================================================--


function LambdaMod.IsTableExists( pName )
    if( !LambdaMod[ pName ] ) then return false end
    return true
end  

local function UTIL_using( namespaceName, targetTable )
    local firstword, remainingwords = string.match( namespaceName, "(%w+)%.(.+)")
    
    --if ( targetTable ~= nil and type( targetTable ) == "table" ) then
      --for k in pairs(targetTable) do print( "FuncStart", k ) end
    --end
    if firstword and remainingwords then
      --print( "FW", firstword, remainingwords )
      --local existing = targetTable[ firstword ]
      --if ( existing ~= nil and type( existing ) ~= "table" ) then
        --existing = existing or {}
        --return using( firstword, targetTable[ remainingwords ] )
      -- 
      
      return UTIL_using( remainingwords, targetTable[ firstword ] )
    else
      if ( targetTable[ namespaceName ] ~= nil ) then 
        return targetTable[ namespaceName ]
      else
        error( "Unknown namespace: '" .. namespaceName .. "'.", 2 )
      end   
    end  
end

local function using( namespaceName, targetTable )
    local firstword, remainingwords = string.match( namespaceName, "(%w+)%.(.+)" )
    --if ( targetTable ~= nil and type( targetTable ) == "table" ) then
      --for k in pairs(targetTable) do print( "FuncStart", k ) end
    --end
    if firstword and remainingwords then
      --print( "FW", firstword, remainingwords )
      local existing = targetTable[ firstword ]
      if ( existing ~= nil and type( existing ) ~= "table" ) then
        --existing = existing or {}
        return using( firstword, targetTable[ remainingwords ] )
      end 
      
      return using( remainingwords, targetTable[ firstword ] )
    else
      if ( targetTable[ namespaceName ] ~= nil ) then 
        return targetTable[ namespaceName ]
      end   
    end  
end

function LambdaMod.Using( namespace )
    return UTIL_using( namespace, LambdaMod )
end

function LambdaMod.SanitizeCommandName(name)
    name = string.lower(name or "plugin")
    name = string.gsub(name, "%s+", "_")
    name = string.gsub(name, "[^a-z0-9_]", "")
    return "sm_" .. name
end



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

