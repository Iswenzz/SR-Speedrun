main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_bog_b_fx::main();

	setExpFog(156.105, 2664.25, 0.627076, 0.611153, 0.5, 0);
	VisionSetNaked( "bog_b", 0 );

	thread sr\api\_map::createSpawn((6110, 1308, 81), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((8354, -5056, -135), 90, 70, "normal_0");

	thread delEnts("targetname", "alley_door");
	thread delEnts("targetname", "alley_door_player_clip");
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
