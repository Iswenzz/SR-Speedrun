main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_launchfacility_b_fx::main();

	setExpFog( 512, 6145, 0.545098, 0.501961, 0.501961, 0 );
	VisionSetNaked( "launchfacility_b", 0 );

	thread sr\api\_map::createSpawn((-50, -1031, 62), 180);
	thread sr\api\_speedrun::createNormalWays(":sbo: Way; :sha: Way");

	thread sr\api\_speedrun::createEndMap((-2601.2, 4463.81, -391.875), 55, 60, "normal_0");
	thread sr\api\_speedrun::createEndMap((-2177.6, 6569.99, 794.125), 70, 80, "normal_1");

	thread sr\api\_speedrun::createTeleporter((-176.613, -1159.53, 0.125001), 50, 60, (-2700, 4868, -420), 45, "freeze", "blue", "normal_1");
	thread sr\api\_speedrun::createTeleporter((-1177.62, 5715.6, -352.875), 65, 70, (-1250, 5792, 795), 135, "freeze", "blue");

	thread delEnts("targetname", "blast_player_clip");
	thread delEnts("targetname", "vault_door_left");
	thread delEnts("targetname", "vault_door_right");
	thread delEnts("targetname", "blasted_wall");
	thread delEnts("targetname", "escape_door_right");
	thread delEnts("targetname", "elevator_player_clip");
	thread delEnts("targetname", "pf1640_auto113");
	thread delEnts("targetname", "pf1640_auto114");
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
