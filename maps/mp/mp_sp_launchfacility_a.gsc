main()
{
	setdvar( "r_specularcolorscale", "1.2" );
	
	maps\mp\_load::main();
	maps\mp\mp_sp_launchfacility_a_fx::main();
	
	setExpFog( 0, 7562.12, 0.168627, 0.168627, 0.188814, 0 );
	VisionSetNaked( "launchfacility_a", 0 );

	thread sr\api\_map::createSpawn((-6800, -7870, -854), 225);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-7125.96, -18140.2, -2118), 90, 250, "normal_0");

	thread delEnts("targetname", "vent_02");
	thread delEnts("targetname", "exploder");
	thread delEnts("targetname", "rifle_range_door");

	thread delBrushAt((-9800, -14287, -917));
	thread delBrushAt((-9800, -14287, -964));
	thread delBrushAt((-9800, -14287, -964));
	thread delBrushAt((-9877, -14287, -917));
	thread delBrushAt((-9876, -14287, -962));
	thread delBrushAt((-9841, -14287, -963));
	thread delBrushAt((-9876, -14287, -1010));
	thread delBrushAt((-9877, -14287, -1015));
	thread delBrushAt((-9799, -14287, -1015));
	thread delBrushAt((-9799, -14288, -1016));
	thread delBrushAt((-9800, -14287, -1011));
	thread delBrushAt((-9956, -14286, -964));
	thread delBrushAt((-9807, -14287, -1017));
	thread delBrushAt((-9791, -14287, -1017));
	thread delBrushAt((-9869, -14287, -1017));
	thread delBrushAt((-9885, -14287, -1017));
	thread delBrushAt((-9948, -14287, -1017));
	thread delBrushAt((-9963, -14287, -1017));
	thread delBrushAt((-9875, -14291, -965));
	thread delBrushAt((-9955, -14290, -967));
	thread delBrushAt((-9941, -14287, -1014));
}

delBrushAt(origin)
{
	ents = getEntArray("script_brushmodel", "classname");
	for (i = 0; i < ents.size; i++)
	{
		if (distanceSquared(ents[i].origin, origin) < 4)
		{
			ents[i] delete();
			return;
		}
	}
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
