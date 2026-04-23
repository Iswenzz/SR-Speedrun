main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_killhouse_fx::main();
	
	setExpFog( 0, 13397.4, 0.11, 0.162, 0.107, 0 );
	VisionSetNaked( "killhouse", 0 );

	thread sr\api\_map::createSpawn((-265, -4201, 55), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((4130, -994, 10), 60, 70, "normal_0");

	thread delEnts("targetname", "ship_hanger_clip");
	thread delEnts("targetname", "ship_hanger_door");
	thread delEnts("targetname", "rifle_range_door");
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
