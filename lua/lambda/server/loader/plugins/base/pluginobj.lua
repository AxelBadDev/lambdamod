--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Scripted plugin object
--
--============================================================================--

PluginObj = PluginObj or {}

function PluginObj:CreateObj()
    local o = {} 
    
    setmetatable( o, self ) 
    self.__index = self
    --self.__type = "INVALID_HANDLE"
    
    o.myinfo = {
        name = "Unknown",
        author = "Unknown",
        description = "A description",
        version = "?",
        api = LAMBDAMOD_API_VERSION,
        url = ""
    }
    --o.LIBRARY
    o.REQUIRED = {}
    o.path = nil
    o.__LOAD_STATUS = LAMBDAMOD_PLUGIN_UNLOADED
    o.__DEFINES = {}
    
    return o
end

function PluginObj:funcBind() end

function PluginObj:SetAsRequired( data )
    if ( type( data ) == "string" ) then
        table.insert( self.REQUIRED, data )
    elseif ( type( data ) == "table" ) then
        for i, v in ipairs( data ) do
            table.insert( self.REQUIRED, v )
        end
    end    
end

function PluginObj:SetState( var )
    self.__LOAD_STATUS = var
end        
  
function PluginObj:GetState()
    return self.__LOAD_STATUS 
end    

function PluginObj:AddHook( pName, pFn )
    LambdaHook.Simple( pName, pFn )
end

function PluginObj:isCompatible()
    for i, v in ipairs( LambdaMod.Enum.PluginCompatible ) do
        if ( self.api == LAMBDAMOD_API_VERSION || self.api == v ) then return true end
    end
    return false
end    

            
--[[ 
function PluginObj:RegPluginLibrary( name )
  if ( LambdaMod.__REG_LIBRARIES[ name ]) then return end
  
  name = name or self.myinfo.name
  
  local temp = table.copy( self )
  temp.myinfo = nil
  temp.OnPluginStart = nil
  temp.REQUIRED = nil
  
  for k, v in pairs( temp ) do
    LambdaMod.__REG_LIBRARIES[ name ] = temp
    print( k )
  end  
end
]]

function PluginObj:findRequiredDependencies()
  if( #self.REQUIRED == 0 ) then return end
  
  -- I hate this but we're use this for now
  -- This is spaghetti
  local list = {}
  for _, v in ipairs( self.REQUIRED ) do
    if not LambdaMod.__libraries[ v ] then
      table.insert( list, v )
    end
  end
  
  for k, v in ipairs( self.REQUIRED ) do
    if not LambdaMod.__libraries[ v ] then
      return true, list
    end
  end  
  
  return false, nil
end  

function PluginObj:Include( pName )
    if( !pName || pName == "" ) then return end
    if( !LambdaMod.__libraries[ pName ] ) then 
        self.__LOAD_STATUS = LAMBDAMOD_PLUGIN_ERROR
        error( 
            "unable to load library '"..pName.."': \n\t"
            .. "no field: LambdaMod.__libraries['" .. pName .. "']",
            2
        )
    end
    self:SetAsRequired( pName )
    
    local temp = table.copy( LambdaMod.__libraries[ pName ] )
        
    self[ pName ] = temp
end    

function PluginObj:define( pName, pNew )
    if self.__DEFINES[ pName ] then return end
    
    self.__DEFINES[ pName ] = pNew
end    
    
function PluginObj:getDefineValue( pName )
    if !self.__DEFINES[ pName ] then
        error( "Undefined value '" .. pName .. "'", 2 )
    end  
    
    return self.__DEFINES[ pName ]
end
          
function PluginObj:OnPluginStart() end    

return PluginObj
