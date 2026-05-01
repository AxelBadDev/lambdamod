require("spaint")
local draw = spaint
local hook = require( "hook" )

/*
surface = surface

if not spaint.CreateFont then
  local function register_font(name, data)
    local hFont = surface.CreateFont()
    local fontObj = pFont:new(name, hFont)

    fontObj:setupData(data)
    fontObj:setupFlags(data)
    fontObj:register()

    tFontHandle[string.lower(name)] = fontObj
  end

  local function getFont(name)
    return tFontHandle[string.lower(name)]
  end

  function spaint.CreateFont(name, data)
    if type(name) ~= "string" then
        error("spaint.CreateFont: expected string (1)", 2)
    end

    if type(data) ~= "table" then
        error("spaint.CreateFont: expected table (2)", 2)
    end

    register_font(name, data)
  end
end
*/

function round(num, decimalPlaces)
    local mult = 10^(decimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

spaint.CreateFont("SpeedNUM", {
    font = "HudNumbers",
    size = 32,
    weight = 0,
    antialias = true,
    shadow = false
})

hook.add("PostChildUIPaint", "LambdaModHUDWatermark", function()
	--dbg.DevMsg( tostring( pElementName ) .. "\n" );
	--if ( pElementName == "CHudWatermark" ) then
	--dbg.Msg( "[HudMeter]: Running this loop!\n" )
	
	--local velAbs = UTIL.PlayerByIndex( UTIL.GetLocalPlayerIndex() ):GetAbsVelocity():NormalizeInPlace()
    --local vel = round( velAbs, 2 )
    
    local pPlayer = _R.CBasePlayer.GetLocalPlayer() 
    
    local vel = pPlayer:GetLocalVelocity():Length()
       
    local tab = 
    {
        pos = { 57, 432 },
        width = 114,
        height = 36,
        color = Color(0, 0, 0, 76),
    }
    spaint.RoundedBox( tab ) 
    
    spaint.Text(
	{
        text = tostring( vel ) .. "UPS",
        pos = {75, 445},
        font = "SpeedNUM",
        color = Color(255, 160, 0)
    })
    --end

end)