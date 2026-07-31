--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

--[[ ULib code ]]--

local root_class = {}

function root_class.call( parent, ... )
    return parent:class():create( ... )
end    

function root_class:create( ... )
    local newinst = {}
    setmetatable( newinst, getmetatable( self ).instance_mt )
    newinst:instantiate( ... ) -- 'Constructor'
    return newinst
end



function root_class:class()
    return getmetatable( self ).class
end


function root_class:superClass()
    base_class = getmetatable( self ).base_class
    return base_class ~= root_class and base_class or nil -- Nil if root class
end


function root_class:instantiate()
end


function root_class:isa( target_class )
    local cur_class = self:class()

    while cur_class and not b_isa do
        if cur_class == target_class then
            return true
        else
            cur_class = cur_class:superClass()
        end
    end

    return false
end


function LambdaMod.inheritsFrom( baseclass )
    local new_class = {}
    
    local instance_mt = { 
        __index = new_class, 
        class = new_class, 
        base_class = base_class 
    }
    
    local class_mt = table.copy( baseclass )
    class_mt.__index = base_class or root_class -- Use base or our special meta-base
    class_mt.__call = root_class.call -- Set up call alias
    class_mt.class = new_class -- Set up alias to ourself
    class_mt.instance_mt = instance_mt -- Need this for root_class:create()

    setmetatable( new_class, class_mt )

    return new_class
end    