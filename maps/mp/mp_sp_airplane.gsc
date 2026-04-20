main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_airplane_fx::main();

	VisionSetNaked( "airplane", 0 );

	thread sr\api\_map::createSpawn((-1246, 499, 188), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-1086.11, 356.146, 270.226), 30, 50, "normal_0");

	thread delEnts("classname", "script_brushmodel");
	thread delEnts("classname", "script_model", "ap_window_right_unit");

	thread delEnts("targetname", "door_bar");
	thread delEnts("targetname", "breach_seats");
	thread delEnts("targetname", "c4_door");
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
