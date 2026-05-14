if( !CLIENT ) then return end

require( "spaint" )

module( "draw", package.seeall )

local surface = surface
local bit = bit
local table = table
local string = string
local type = type
local setmetatable = setmetatable
local ipairs = ipairs
local Color = Color

local function unpackColor(col)
  return col:r(), col:g(), col:b(), col:a()
end

TEXT_ALIGN_LEFT    = 0
TEXT_ALIGN_CENTER  = 1
TEXT_ALIGN_RIGHT   = 2
TEXT_ALIGN_TOP     = 3
TEXT_ALIGN_BOTTOM  = 4

function SimpleText( text, font, x, y, color, xalign, yalign )
    text = tostring( text )
    pFont = spaint.GetFont( ( font or "Default" ) )
    x = x or 0
    y = y or 0
    
    color = color or Color( 255, 255, 255 )
    
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    
    local w, h = surface.GetTextSize( pFont, text )
    
    if ( xalign == TEXT_ALIGN_CENTER ) then
        x = x - w / 2
    elseif ( xalign == TEXT_ALIGN_RIGHT ) then
        x = x - w
    end
    
    if ( yalign == TEXT_ALIGN_CENTER ) then
        y = y - h / 2
    elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
        y = y - h
    end
    
    surface.DrawSetTextColor( unpackColor( color ) )
    surface.DrawSetTextPos( math.ceil( x ), math.ceil( y ) )
    surface.DrawSetTextFont( pFont )
    surface.DrawPrintText( text )
    
    return w, h
end

function SimpleTextOutlined( text, font, x, y, color, xalign, yalign, outlinewidth, outlinecolor )
    local steps = ( outlinewidth * 2 ) / 3
    if( steps < 1 ) then steps = 1 end
    
    for _x = -outlinewidth, outlinewidth, steps do
        for _y = -outlinewidth, outlinewidth, steps do
            SimpleText( text, font, x + _x, y * _y, color, xalign, yalign )
        end
    end
    
    return SimpleText( text, font, x, y, color, xalign, yalign )        
end

function Text( tab ) 
    return SimpleText( tab.text, tab.font, tab.pos[ 1 ], tab.pos[ 2 ], tab.color, tab.xalign, tab.yalign )
end    

function TextOutlined( tab ) 
    return SimpleTextOutlined( tab.text, tab.font, tab.pos[ 1 ], tab.pos[ 2 ], tab.color, tab.xalign, tab.yalign, tab.outline, tab.outline_color )
end    
function WordBox( bordersize, x, y, text, font, color, fontcolor, xalign, yalign )

    fontcolor = fontcolor or Color( 255, 255, 255 )
    color = color or Color( 0, 0, 0, 120 )
    
	local pFont = spaint.GetFont( ( font or "Default" ) )
	local w, h = surface.GetTextSize( pFont, text )

	if ( xalign == TEXT_ALIGN_CENTER ) then
		x = x - ( bordersize + w / 2 )
	elseif ( xalign == TEXT_ALIGN_RIGHT ) then
		x = x - ( bordersize * 2 + w )
	end

	if ( yalign == TEXT_ALIGN_CENTER ) then
		y = y - ( bordersize + h / 2 )
	elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
		y = y - ( bordersize * 2 + h )
	end

	--RoundedBox( bordersize, x, y, w+bordersize * 2, h+bordersize * 2, color )
    
    spaint.RoundedBox( {
        pos = { x, y },
        width = w + bordersize * 2,
        height = h + bordersize * 2,
        color = color
    })

	surface.DrawSetTextColor( unpackColor( fontcolor ) )
	surface.DrawSetTextPos( x + bordersize, y + bordersize )
    surface.DrawSetTextFont( pFont )
	surface.DrawPrintText( text )

	return w + bordersize * 2, h + bordersize * 2

end

function TextBox( x, y, w, h, text, font, color, fontcolor, xalign, yalign )

    fontcolor = fontcolor or Color( 255, 255, 255 )
    color = color or Color( 0, 0, 0, 120 )
    
	local pFont = spaint.GetFont( ( font or "Default" ) )
	local tW, tH = surface.GetTextSize( pFont, text )

	if ( xalign == TEXT_ALIGN_CENTER ) then
		x = x - w / 2 
	elseif ( xalign == TEXT_ALIGN_RIGHT ) then
		x = x - w 
	end

	if ( yalign == TEXT_ALIGN_CENTER ) then
		y = y - h / 2 
	elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
		y = y - h 
	end

   -- local vW, vH = surface.GetScreenSize()
    local Ex, Eh = 50, 50
    
	--RoundedBox( bordersize, x, y, w+bordersize * 2, h+bordersize * 2, color )
    
    spaint.RoundedBox( {
        pos = { x, y },
        width = w,
        height = h,
        color = color
    })

	surface.DrawSetTextColor( unpackColor( fontcolor ) )
	surface.DrawSetTextPos( math.ceil( 10 ), math.ceil( 10 ) )
    surface.DrawSetTextFont( pFont )
	surface.DrawPrintText( text )

	return w, h

end