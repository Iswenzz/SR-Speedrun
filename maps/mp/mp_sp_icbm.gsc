main()
{
    precacheModel( "com_powerline_tower_destroyed" );
    precacheModel( "com_flashlight_on" );
    precacheModel( "weapon_parabolic_knife" );
    precacheModel( "com_spray_can01" );
    precacheModel( "prop_flex_cuff" );
    precacheModel( "prop_flex_cuff_obj" );
    precacheModel( "com_folding_chair" );
	
	maps\mp\_load::main();
	maps\mp\mp_sp_icbm_fx::main();

	setExpFog(0, 1819.93, 0.566786, 0.495098, 0.45532, 0);
	VisionSetNaked( "icbm", 0 );

	thread sr\api\_map::createSpawn((9147, -21120, -607), 200);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-5377, -7042, -700), 80, 70, "normal_0");

	thread delEnts("targetname", "house01_basement_door");
	thread delEnts("targetname", "house01_front_door");
	thread delEnts("targetname", "house02_front_door");
	thread delEnts("targetname", "door_safehouse_livingroom");
	thread delEnts("targetname", "doorknob1");
	thread delEnts("targetname", "doorknob2");
	thread delEnts("targetname", "doorknob3");
	thread delEnts("targetname", "doorknob4");
	thread delEnts("targetname", "fence01_clip");
	thread delEnts("targetname", "fence_cut");
	thread delEnts("targetname", "glass");
}

delEnts(property, value, modelFilter)
{
	ents = getEntArray(value, property);

	for (i = 0; i < ents.size; i++)
	{
		if (isDefined(modelFilter))
		{
			if (ents[i].model == modelFilter)
				ents[i] delete();
		}
		else
		{
			ents[i] delete();
		}
	}
}
