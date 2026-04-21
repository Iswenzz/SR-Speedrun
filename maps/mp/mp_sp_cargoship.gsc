main()
{
	level.fogvalue["near"] = 100;
	level.fogvalue["half"] = 15000;
	level.fogvalue["r"] = 0/256;
	level.fogvalue["g"] = 0/256;
	level.fogvalue["b"] = 0/256;
	setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 0.1);
	
	level.fogvalue["near"] = 100;
	level.fogvalue["half"] = 4000;
	setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 20);
	
	maps\mp\_load::main();
	maps\mp\mp_sp_cargoship_fx::main();
	maps\createfx\mp_sp_cargoship_fx::main();
	
	setDvar("r_specularColorScale", "3");

	VisionSetNaked( "cargoship", 0 );

	thread sr\api\_map::createSpawn((3230, 283, 397), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((2320, 203, -350), 50, 60, "normal_0");

	thread delEnts("targetname", "auto2463");
	thread delEnts("targetname", "auto2766");
	thread delEnts("targetname", "auto2825");
	thread delEnts("targetname", "auto2810");
	thread delEnts("targetname", "bridge_door");
	thread delEnts("targetname", "hallways_door");
	thread delEnts("targetname", "escape_door");
	thread delEnts("targetname", "cargohold1_door");
	thread delEnts("targetname", "player_end_water_clip");
	thread delEnts("targetname", "package_door_left");
	thread delEnts("targetname", "package_door_right");
	thread delEnts("target", "package_door_right");
	thread delEnts("target", "package_door_right");
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

