main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_blackout_fx::main();

	setExpFog(16689.2, 31981.7, 0.0864362, 0.127279, 0.154118, 0);
	VisionSetNaked( "blackout", 0 );

	thread sr\api\_map::createSpawn((-16019, -10282, -109), 25);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-2891, -4627, 475), 90, 70, "normal_0");

	thread delEnts("targetname", "meeting_door");
	thread delEnts("targetname", "slow_door");
	thread delEnts("targetname", "blackout_path_block");
	thread delEnts("targetname", "exit_door");
	thread delEnts("targetname", "blackout_fence_up");
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
