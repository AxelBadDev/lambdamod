-- Ammo

CreateConVar( "sk_max_mod_uranium", "100", { 16384 })

hook.add( "GetAmmoDef", "lambdaAmmoDefs", function(def)
    def:AddAmmoType(
        "MOD_Uranium",
        1024,
        0,
		nil,
		nil,
		100,
        0,
        0
	)
	--def:AddAmmoType("Uranium", DMG_ENERGYBEAM, AmmoTracer.NONE, nil, nil, "sk_max_uranium", 0, 0)	
end )

hook.add( "GiveDefaultItems", "lambdaGiveAmm", function(pPlayer)
    if(!CLIENT) then
		_R.CBasePlayer.GiveAmmo( pPlayer, 100, "MOD_Uranium" )
	end	
end )