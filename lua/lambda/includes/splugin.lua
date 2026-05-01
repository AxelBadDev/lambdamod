--========= Copyright (C) 2026 hedv948-source, All Rights Reserved ============--
--                                                      
-- Purpose: Create plugin object                                
--                                                      
--=============================================================================--

PluginObj = {}

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
        api = "9",
        url = ""
    }
    --o.LIBRARY
    o.REQUIRED = {}
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
     

function PluginObj.AddHook( pName, pFn )
    LambdaHook.Add( pName, pFn )
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
    if not LambdaMod.__REG_LIBRARIES[ v ] then
      table.insert( list, v )
    end
  end
  
  for k, v in ipairs( self.REQUIRED ) do
    if not LambdaMod.__REG_LIBRARIES[ v ] then
      return true, list
    end
  end  
  
  return false, nil
end  

function PluginObj:Include( pName )
    if( !pName || pName == "" ) then return end
    if( !LambdaMod.__REG_LIBRARIES[ pName ] ) then 
        dbg.Warning( 
            "library '"..pName.."' not found: \n\t"
            .. "no field: LambdaMod.__REG_LIBRARIES['" .. pName .. "']\n"
        )
        return 
    end
    self:SetAsRequired( pName )
    
    local temp = table.copy( LambdaMod.__REG_LIBRARIES[ pName ] )
        
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
