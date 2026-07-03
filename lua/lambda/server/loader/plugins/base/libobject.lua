--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Scripted library object
--
--============================================================================--

---@class LibraryObj

---@field name string
---@field author string
---@field description string
---@field version string|number
---@field api string|number
---@field url string

LibraryObj = LibraryObj or {}

---@method Create
---@return userdata
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
    o.path = nil
    o.__REQUIRED = {}
    
    return o
end

---@method SetAsRequired
--- Sets library as required
function LibraryObj:SetAsRequired( data )
    if ( type( data ) == "string" ) then
        table.insert( self.__REQUIRED, data )
    elseif ( type( data ) == "table" ) then
        for i, v in ipairs( data ) do
            table.insert( self.__REQUIRED, v )
        end
    end    
end    


--- Register a library data
---@method RegLibrary
---@param data table
function LibraryObj:RegLibrary( data )
    assert( type( data ) == "table", "bad argument #1 to method 'RegLibrary' (table expected got "..type( data ) .. ")")
    self.name = data.name
    self.author = data.author
    self.version = data.version
    self.description = data.description
    self.api = data.api
    self.url = data.url
end    

---@method GetLibraryInfo
---@return table 
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