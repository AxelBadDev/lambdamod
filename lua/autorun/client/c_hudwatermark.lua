local draw = require( "spaint" )

local function ScreenScale( width )
    local sw, _ = surface.GetScreenSize()
	return width * ( sw / 640.0 )
end

local function ScreenScaleH( height )
    local _, sh = surface.GetScreenSize()
	return height * ( sh / 480.0 )
end

local function m_Lerp(a, b, f)
	return a + ( ( b - a ) * f )
end

local function d_drawTransparentGradient( x, y, w, h)
	local t = 0
	
	for i = 1, w do
		t = t + ( 1 / w )
		
		surface.DrawSetColor( 0, 0, 0, m_Lerp( 0, 60 ,t ) )
		
		surface.DrawFilledRect( x + i - 1, y , 1 ,h )
        
	end
end

draw.CreateFont("GM9LargeText",{
	font = "Verdana",
	size = 18,
	weight = 1000,
	antialias = true,
    shadow = false
})

draw.CreateFont("GM9SmallText",{
	font = "Verdana",
	size = 14,
	weight = 500,
	antialias = true,
    shadow = false
})

local cl_watermark_gmod9 = ConVar( "cl_watermark_gmod9", "1", _E.FCVAR.CLIENTDLL )

local function h_DrawHud()
    local screenW = ScreenScale( 640 )
    local screenH = ScreenScaleH( 480 )
    
    if cl_watermark_gmod9:GetInt() > 0 then
    
        local sw, sh = surface.GetScreenSize()
        local x_loc = sw-110
	    local y_loc = 0
        
        local pGrad =
        {
            texture = "vgui/gradient-r",
            pos = { x_loc + 50, y_loc },
            width = 110 - 50,
            height = 33,
            color = Color(0, 0, 0, 245) -- black
        }
    
        draw.Texture({
            texture = "vgui/gradient-r",
            pos = { x_loc + 50, y_loc },
            width = 110 - 50,
            height = 33,
            color = Color(0, 0, 0, 245) -- black
        })
    
        draw.Texture({
            texture = "vgui/gradient-r",
            pos = { x_loc + 50, y_loc },
            width = 110 - 50,
            height = 33,
            color = Color(0, 0, 0, 245) -- black
        })
    
    --surface.DrawFilledRect( x_loc + 50, y_loc, 110 - 50, 33)
	--surface.DrawSetColor(0, 0, 0, 225 )
    --d_drawTransparentGradient( x_loc, y_loc, 50, 33 )
        draw.Text( {
            text = "GMod 9.0",
            pos = { x_loc + 44, y_loc + 5 },
            font = "GM9LargeText",
            color = Color( 0, 0, 0 )
        })
        
        draw.Text( {
            text = "GMod 9.0",
            pos = { x_loc + 43, y_loc + 4 },
            font = "GM9LargeText",
            color = Color( 255, 255, 255 )
        })
        
        draw.Text( {
            text = "gmod.garry.tv",
            pos = { x_loc + 37, y_loc + 19 },
            font = "GM9SmallText",
            color = Color( 0, 0, 0 )
        })
      
        draw.Text( {
            text = "gmod.garry.tv",
            pos = { x_loc + 36, y_loc + 18 },
            font = "GM9SmallText",
            color = Color( 255, 255, 255 )
        })
    end    
    
end

hook.add( "PostChildUIPaint", "GM9Overlay", h_DrawHud )    
    
    
    
    