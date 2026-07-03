--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose:
--
--============================================================================--

LambdaMod.IPluginObj = {}

local IPluginObj = LambdaMod.IPluginObj
IPluginObj.Enum = {
    PLUGIN = 1,
    LIBRARY = 2
}

-- BaseClass constructor
local BasePluginObject = {
    __index = {
        name = "Unknown",
        description = "A description",
        author = "?",
        
        version = "0",
        api = nil,
        url = nil,
        path = nil,
        
        m_Id = 0,
        
        __LOAD_STATUS = 0
    },    
    __tostring = function( self )
        return "BasePluginObject '" .. self.name .. "' Version: " .. self.path
    end    
}

--local library = {}
--plugin.__index = plugin
--library.__index = library

function IPluginObj.Plugin() 
    local plugin = {} 
    plugin.__index = plugin
    function plugin:Import( pName )
        if( !pName || pName == "" ) then return end
        local import = LambdaMod.__libraries[ pName ]
    
        if( import ) then
            local temp = setmetatable( {}, { __index = import } )
            self[ pName ] = temp
            return self[ pName ]
        else     
            self.__LOAD_STATUS = LAMBDAMOD_PLUGIN_ERROR
            error( 
                "unable to load library '"..pName.."': \n\t"
                .. "no field: LambdaMod.__libraries['" .. pName .. "']",
                2
            )
        end
    end  

    function plugin:MyInfo( data )
        assert( type( data ) == "table", "bad argument #1 to method 'RegLibrary' (table expected got "..type( data ) .. ")")
        self.name = data.name
        self.author = data.author
        self.version = data.version
        self.description = data.description
        self.api = data.api
        self.url = data.url
    
        LambdaMod.__plugins[ self.name ] = self
    end    

    function plugin:SetState( var )
        self.__LOAD_STATUS = var
    end        
  
    function plugin:GetState()
        return self.__LOAD_STATUS 
    end    
    
    function plugin:PrePluginStart() end
    function plugin:OnPluginStart() end

    plugin.myinfo =  plugin.MyInfo 
    plugin.Include = plugin.Import 
    
    local obj = {}
    obj.name = "Unknown"
    obj.description = "A description"
    obj.author = "?"
    obj.version = "0"
    obj.api = nil
    obj.url = nil
    obj.path = nil
    obj.m_Id = 0
    obj.__LOAD_STATUS = 0
    return setmetatable( obj, plugin )
end 

function IPluginObj.Library()
    local library = {}
    library.__index = library
    function library:MyInfo( data )
        assert( type( data ) == "table", "bad argument #1 to method 'RegLibrary' (table expected got "..type( data ) .. ")")
        self.name = data.name
        self.author = data.author
        self.version = data.version
        self.description = data.description
        self.api = data.api
        self.url = data.url
    
        LambdaMod.__libraries[ self.name ] = self
    end    

    library.RegLibrary = library.MyInfo
    library.myinfo = library.MyInfo
    
    local obj = {}
    obj.name = "Unknown"
    obj.description = "A description"
    obj.author = "?"
    obj.version = "0"
    obj.api = nil
    obj.url = nil
    obj.path = nil
    --obj.m_Id = 0
    --obj.__LOAD_STATUS = 0
    return setmetatable( obj, library )
end        
        
function IPluginObj:new( mode ) 
    mode = mode or IPluginObj.Enum.PLUGIN
    if ( mode == IPluginObj.Enum.PLUGIN ) then
        return self.Plugin()
    elseif ( mode == IPluginObj.Enum.LIBRARY ) then
        return self.Library()
    end    
end