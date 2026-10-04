main()
{
    
	/* ... */

	maps\mp\_load::main();
	maps\mp\mp_dr_bridge_fx::main();

	/* ... */

    // -- Fall damage off
    SetDvar("bg_falldamagemaxheight", 99999);
    SetDvar("bg_falldamageminheight", 99998);

    thread lightning_fx();
}

lightning_fx()
{
    origin = getEnt("lightning_origin", "targetname");

    playfx(level._effect["lightning_mp_farm_bolt_a"], origin.origin);
}

