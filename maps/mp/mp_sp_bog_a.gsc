main()
{
	SetDvar( "r_specularColorScale", "2.42" );
	
	maps\mp\_load::main();
	maps\mp\mp_sp_bog_a_fx::main();
	
	maps\createfx\mp_sp_bog_a_fx::main();

	setExpFog(477.057, 4556.45, 0.544852, 0.394025, 0.221177, 0);
	VisionSetNaked( "bog_a", 0 );

	thread sr\api\_map::createSpawn((12063, 4366, 263), 245);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((5007, 1605, 0), 70, 70, "normal_0");

	thread delEnts("targetname", "apartment_door");
	thread delEnts("targetname", "shanty_fence_clip");

	thread ac_unit();
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

ac_unit()
{
	ac_unit = getEnt("window_ac_unit", "targetname");

	ac_unit.origin = (9427, 490, 32);
	ac_unit.angles = (0, 27, 0);
}