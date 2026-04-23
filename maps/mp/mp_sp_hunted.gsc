main()
{
	precacheModel( "com_flashlight_on" );

	setdvar( "r_specularcolorscale", "2.3" );

	maps\mp\_load::main();
	maps\mp\mp_sp_hunted_fx::main();

	setExpFog(512, 6145, 0.132176, 0.192839, 0.238414, 0);
	VisionSetNaked( "hunted", 0 );
	
	thread sr\api\_map::createSpawn((1880, -8280, 328), 345);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((5530, 10618, 170), 80, 70, "normal_0");

	thread delEnts("targetname", "barn_rear_door");
	thread delEnts("targetname", "barn_main_door");
	thread delEnts("targetname", "glass");
	thread delEnts("targetname", "field_clip");
	thread delEnts("targetname", "basement_door");
	thread delEnts("targetname", "basement_door_handle");
	thread delEnts("targetname", "basement_inner_door");
	thread delEnts("targetname", "basement_player_block");
	thread delEnts("targetname", "door_pusher");
	thread delEnts("targetname", "creek_gate");
	thread delEnts("targetname", "doorknob");
	thread delEnts("targetname", "big_barn_door");
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
