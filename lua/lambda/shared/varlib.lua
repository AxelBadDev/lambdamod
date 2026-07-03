--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--
LambdaMod.VarLib = {
    Vars = {}
}

    

local MetaVars = {}
MetaVars.__index = MetaVars

function MetaVars:GetType()
  return type( self.value )
end  

function MetaVars:isConst()
    return self.const == true
end
    
function MetaVars:GetString()
  if type( self.value ) ~= "string" then
    error( "in " .. tostring( self.var ) .. " Attempt to get a string from " .. self:GetType() .. " value.", 2)
  end
  return self.value
end  

function MetaVars:GetNumber()
  if type( self.value ) ~= "number" then
    error( "in " .. tostring( self.var ) .. " Attempt to get a number from " .. self:GetType() .. " value.", 2 )
  end
  return self.value
end  

function MetaVars:GetTable()
  if type( self.value ) ~= "table" then
    error( "in " .. tostring( self.var ) .. " Attempt to get a table from " .. self:GetType() .. " value.", 2 )
  end
  return self.value
end  

function MetaVars:GetBool()
  if type( self.value ) ~= "boolean" then
    error( "in " .. tostring( self.var ) .. " Attempt to get a boolean from " .. self:GetType() .. " value.", 2 )
  end
  return self.value
end  


function MetaVars:SetValue( value )
  if type( value ) ~= self:GetType() then
    error( "Attempt to assign to" .. self:GetType() .. " variable '"..self.var.."' with " .. type( value ) ..  " value", 2 )
  elseif ( self:isConst() ) then 
      error( "Attempt to assign to const variable '"..self.var.."'", 2 ) 
  end
  self.value = value
end  

function MetaVars:AddKeyValue( key, value )
  if ( self:GetType() != "table" ) then
    error( "Attempt to add key to " .. self:GetType() .. " value", 2)
  elseif ( self:isConst() ) then
    error( "Attempt to assign to const variable '"..self.var.."'", 2 )
  end
  
  if( self.value[ key ] ) then error( "Attempt to assign a value on an existing variable") end
  
  --if ( type( value ) ~= "string" ) then error( "Attempt to assign an " .. type( value ) .. " to " .. type( self:GetType() )) end
  
  self.value[ key ] = value
end  

function MetaVars:SetKeyValue( key, value )
  if ( self:GetType() != "table" ) then
    error( "Attempt to add key to " .. self:GetType() .. " variable", 2)
  elseif ( self:isConst() ) then
    error( "Attempt to assign to const variable '"..self.var.."'", 2 )
  end
  if( !self.value[ key ] ) then error( "Attempt to assign an undefined key", 2) end
  if ( type( value ) ~= type( self.value[ key ] ) ) then error( "Attempt to assign an " .. type( value ) .. " value to " .. type( self.value[ key ] ) .. " variable", 2 ) end
  self.value[ key ] = value
end  

function MetaVars:RemoveKey( key )
  if ( self:GetType() != "table" ) then
    error( "Attempt to remove key to " .. self:GetType() .. " variable", 2)
  elseif ( self:isConst() ) then
    error( "Attempt to remove to const variable '"..self.var.."'", 2 )
  end
  
  if( !self.value[ key ] ) then error( "Attempt to remove an undefined key", 2) end
  
  self.value[ key ] = nil
end  

MetaVars.__newindex = function( self, k, v )
  if ( k ~= self.var ) then
    error( "Attempt to assign an non-existing variable", 2 )
  end 
  
  if ( type( v ) ~= self:GetType() ) then
    error( "Attempt to assign to" .. self:GetType() .. " variable '"..self.var.."' with " .. type( v ) ..  " value", 2 )
  elseif ( self:isConst() ) then
      error( "Attempt to assign to const variable '"..self.var.."'", 2 )  
  end  
end 

function LambdaMod.CreateVar( isConst, dataType, pName, value )
    if ( LambdaMod.VarLib.Vars[ pName ] ) then
        LambdaMod.CPrintf( 3, "Error! " )
        LambdaMod.CPrintf( 0, "'%s' already exists\n", tostring( pName ) )
        return nil
    end
    
    assert( type( pName ) == "string", "Expected string got ".. type( pName ) )
    assert( pName ~= "", "Attempt to create a variable with an empty string" )
    assert( type( dataType ) == "string", "Expected string expected got "..type( dataType ))
    assert( type( value ) == dataType:lower(), "Attempt to assign ".. dataType:lower() ..  " variable '"..pName.."' with".. type( value ) .. " value." ) 
  --error( "Attempt to assign ".. dataType:lower() ..  " variable '"..pName.."' with ".. type( value ) .. " value.", 2 ) end
    LambdaMod.VarLib.Vars[ pName ] = {
        var = pName,
        const = isConst or false,
        value = value
    }
  
    return setmetatable( LambdaMod.VarLib.Vars[ pName ], MetaVars )
end 

function LambdaMod.GetVar( pName ) 
  assert( type( pName ) == "string", "bad argument #1 to 'GetVar' (string expected got " .. type(pName) ..")" )
  if ( !LambdaMod.VarLib.Vars[ pName ] ) then
      --j
      LambdaMod.CPrintf( 3, "Error! " )
      LambdaMod.CPrintf( 0, "Attempt to get a non-existing variable (%s)\n", tostring( pName ) )
      return nil
  end
  return LambdaMod.VarLib.Vars[ pName ]
end     

function LambdaMod.SetVar( pName, value ) 
  if ( !LambdaMod.VarLib.Vars[ pName ] ) then
      LambdaMod.CPrintf( 3, "Error! " )
      LambdaMod.CPrintf( 0, "Attempt to set a non existing variable (%s)\n", tostring( pName ) )
      return
  end
  local meta = LambdaMod.VarLib.Vars[ pName ] 
  meta:SetValue( value )
end

function LambdaMod.CreateTable( isConst, pName, data )
    data = data or {}
    return LambdaMod.CreateVar( isConst, "Table", pName, data )
end
    

        
        
