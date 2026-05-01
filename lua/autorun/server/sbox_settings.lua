if( !table.Random ) then
    function table.Count( t )
	    local i = 0
	    for k in pairs( t ) do i = i + 1 end
	    return i
    end
    
    function table.Random( t )
	    local rk = math.random( 1, table.Count( t ) )
	    local i = 1
	    for k, v in pairs( t ) do
		    if ( i == rk ) then return v, k end
		    i = i + 1
	    end
    end
end    

local function cvars_Bool( name, default )

	local convar = cvar.FindVar( name )
	if ( convar ~= nil ) then
		return convar:GetBool()
	end

	return default

end

local NPC_CombineS_RunFootstepLeft = {

	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear5.wav"

}

local NPC_CombineS_RunFootstepRight = {

	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear6.wav"

}

local sbox_godmode = ConVar( "sbox_godmode", "0", bit.bor( _E.FCVAR.REPLICATED, _E.FCVAR.NOTIFY ))
local sbox_playershurtplayers = ConVar( "sbox_playershurtplayers", "1", bit.bor( _E.FCVAR.REPLICATED, _E.FCVAR.NOTIFY ))

local footstep_combine = ConVar( "cl_footstep_combine", "0", _E.FCVAR.REPLICATED )

hook.add( "FPlayerCanTakeDamage", "CCheckPlayerDamage", function( pPlayer, pAttacker )
    if ( sbox_godmode:GetBool() == false ) then return false end -- No more taking damages
       
    if ( pAttacker:IsValid() && pAttacker:IsPlayer() && pPlayer != pAttacker ) then
		return sbox_playershurtplayers:GetBool()
	end
    
    return true
end )

--[[
hook.add( "PlayerPlayFootStep", "COverridesFootsteps", function(pPlayer, vecOrigin, fvol, force) 
    if( footstep_combine:GetBool() ) then
        pPlayer:EmitSound( table.Random( ))
end)
]]