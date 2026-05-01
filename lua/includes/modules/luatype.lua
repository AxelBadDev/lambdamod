-- no

module( "luatype", package.seeall )

local tBaseType = 
{
    -- Boolean
    ["boolean"] = "boolean",
    ["bool"]    = "boolean",
    ["Bool"]    = "boolean",
    ["Boolean"] = "boolean",
    
    -- Number/Int
    ["number"]  = "number",
    ["Number"]  = "number",
    ["Int"]     = "number",
    ["int"]     = "number",
    
    -- String
    ["string"]  = "string",
    ["String"]  = "string",
    ["Str"]     = "string",
    
    -- Table
    ["table"]   = "table",
    ["Table"]   = "table",
    
    --["list"]    = "list",
    --["List"]    = "list"
}

local Vars = {}

local meta = {}
meta.__index = meta

function meta:GetType()
  return type( self.value )
end  

function meta:isConst()
    return self.const == true
end
    
function meta:GetString()
  if type( self.value ) ~= "string" then
    error( "in " .. tostring( self.var ) .. " Attempt to get a string from " .. self:GetType() .. " value.", 2)
  end
  return self.value
end  

function meta:GetNumber()
  if type( self.value ) ~= "number" then
    error( "in " .. tostring( self.var ) .. " Attempt to get a number from " .. self:GetType() .. " value.", 2 )
  end
  return self.value
end  

function meta:GetTable()
  if type( self.value ) ~= "table" then
    error( "in " .. tostring( self.var ) .. " Attempt to get a table from " .. self:GetType() .. " value.", 2 )
  end
  return self.value
end  

function meta:GetBool()
  if type( self.value ) ~= "boolean" then
    error( "in " .. tostring( self.var ) .. " Attempt to get a boolean from " .. self:GetType() .. " value.", 2 )
  end
  return self.value
end  


function meta:SetValue( value )
  if type( value ) ~= self:GetType() then
    error( "Attempt to assign to" .. self:GetType() .. " variable '"..self.var.."' with " .. type( value ) ..  " value", 2 )
  elseif ( self:isConst() ) then 
      error( "Attempt to assign to const variable '"..self.var.."'", 2 ) 
  end
  self.value = value
end  
function meta:AddKeyValue( key, value )
  if self:GetType() ~= "table" then
    error( "Attempt to add key to " .. self:GetType() .. " value", 2)
  elseif self:isConst() then
    error( "Attempt to assign to const variable '"..self.var.."'", 2 )
  end
  
  if( self.value[ key ] ) then error( "Attempt to assign a value on an existing variable") end
  
  --if ( type( value ) ~= "string" ) then error( "Attempt to assign an " .. type( value ) .. " to " .. type( self:GetType() )) end
  
  self.value[ key ] = value
end  

function meta:SetKeyValue( key, value )
  if self:GetType() ~= "table" then
    error( "Attempt to add key to " .. self:GetType() .. " value", 2)
  elseif self:isConst() then
    error( "Attempt to assign to const variable '"..self.var.."'", 2 )
  end
  if( not self.value[ key ] ) then error( "Attempt to assign an undefined key", 2) end
  if ( type( value ) ~= type( self.value[ key ] ) ) then error( "Attempt to assign an " .. type( value ) .. " value to " .. type( self.value[ key ] ) .. " variable", 2 ) end
  self.value[ key ] = value
end  

function meta:RemoveKey( key )
  if self:GetType() ~= "table" then
    error( "Attempt to remove key to " .. self:GetType() .. " value", 2)
  elseif self:isConst() then
    error( "Attempt to remove to const variable '"..self.var.."'", 2 )
  end
  
  if( !self.value[ key ] ) then error( "Attempt to remove an undefined key", 2) end
  
  self.value[ key ] = nil
end  

function meta:deleteThis()
    self.var, self.value = nil, nil
    return nil
end    

meta.__newindex = function( self, k, v )
  error( "You can't define variable.", 2 )
end 

function CreateVar( bConst, pName, dType, value )
    if ( Vars[ pName ] ) then
       error( string.format( "Attempt to register an existed variable (%s)" , tostring( pName ) ), 2 )
    end
    
    assert( type( pName ) == "string", "Expected string got ".. type( pName ) )
    assert( pName ~= "", "Attempt to create a variable with an empty string" )
    assert( type( dType ) == "string", "Expected string expected got "..type( dataType ))
    
    if( !tBaseType[ dType ] ) then error( "Attempt to assign variable with non-existing type '" ..dType.. "'", 2 ) end
    assert( tBaseType[ dType ] == type( value ), "Attempt to assign ".. dType:lower() ..  " variable '"..pName.."' with".. type( value ) .. " value." ) 
  --error( "Attempt to assign ".. dataType:lower() ..  " variable '"..pName.."' with ".. type( value ) .. " value.", 2 ) end
    Vars[ pName ] = {
        var = pName,
        const = bConst or false,
        value = value
    }
  
    return setmetatable( Vars[ pName ], meta )
end    

function GetVar( pName ) 
  assert( type( pName ) == "string", "bad argument #1 to 'GetVar' (string expected got " .. type(pName) ..")" )
  if ( !Vars[ pName ] ) then
      error( string.format( "Attempt to get an undefined variable (%s)" , tostring( pName ) ), 2 )
  end
  return Vars[ pName ]
end     

function SetVar( pName, value ) 
  if ( !Vars[ pName ] ) then
      error( string.format( "Attempt to set a non existing variable (%s)", tostring( pName )), 2 )
  end
  local var = Vars[ pName ] 
  var:SetValue( value )
end

function CreateTable( bConst, pName, data )
    data = data or {}
    return CreateVar( bConst, pName, "table", data )
end

function UndefVar( pName )
    if ( !Vars[ pName ] ) then error( "Attempt to undefine a non-existing variable", 2 ) end
    Vars[ pName ]:deleteThis()
    Vars[ pName ] = nil
end    