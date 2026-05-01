LibraryObj = {}

function LibraryObj:Create()
    local o = {} 
    
    setmetatable( o, self ) 
    self.__index = self
    --self.__type = "INVALID_HANDLE"
    o.name = "Unknown"
    o.author = "Unknown"
    o.description = "A description"
    o.version = "?"
    o.api = "9"
    o.url = ""
    --o.LIBRARY
    o.__REQUIRED = {}
    
    return o
end


function LibraryObj:SetAsRequired( data )
    if ( type( data ) == "string" ) then
        table.insert( self.__REQUIRED, data )
    elseif ( type( data ) == "table" ) then
        for i, v in ipairs( data ) do
            table.insert( self.__REQUIRED, v )
        end
    end    
end    

function LibraryObj:findRequiredDependencies()
  if( #self.__REQUIRED == 0 ) then return end
  
  -- I hate this but we're use like this for now
  -- This is spaghetti
  local list = {}
  for _, v in ipairs( self.__REQUIRED ) do
    if not LambdaMod.__REG_LIBRARIES[ v ] then
      table.insert( list, v )
    end
  end
  
  for k, v in ipairs( self.__REQUIRED ) do
    if not LambdaMod.__REG_LIBRARIES[ v ] then
      return true, list
    end
  end  
  
  return false, nil
end  

function LibraryObj:DefineName( pName )
    self.name = pName
end    

function LibraryObj:RegLibrary( data )
    assert( type( data ) == "table", "bad argument #1 to method 'RegLibrary' (table expected got "..type( data ) .. ")")
    self.name = data.name
    self.author = data.author
    self.version = data.version
    self.description = data.description
    self.api = data.api
    self.url = data.url
end    

function LibraryObj:GetLibraryInfo()
    local t = table.copy( self )
    local temp = {}
    temp.name = t.name
    temp.author = t.author
    temp.version = t.version
    temp.description = t.description
    temp.api = t.api
    temp.url = t.url
    return temp
end    
return LibraryObj