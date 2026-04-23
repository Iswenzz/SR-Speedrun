main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_armada_fx::main();
	
	setExpFog(800, 6000, .583, .644 , .587, 0);
	VisionSetNaked( "armada", 0 );

	thread sr\api\_map::createSpawn((1113, 31663, 13), 270);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((4580, 22143, 320), 65, 70, "normal_0");

	thread delEnts("targetname", "final_door_attachments");
	thread delEnts("targetname", "door_final");
	thread delEnts("targetname", "door_tv_station");
	thread delEnts("targetname", "news_room_exit_door");
	thread delEnts("targetname", "news_door_attachments");
	thread delEnts("targetname", "door_safehouse_livingroom");
	thread delEnts("targetname", "hq_building_exit_door");
	thread delEnts("targetname", "pf12596_auto1");
	thread delEnts("targetname", "pf12596_auto2");
	thread delEnts("targetname", "pf12601_auto1");
	thread delEnts("targetname", "pf12601_auto2");
	thread delEnts("targetname", "pf12899_auto1");
	thread delEnts("targetname", "pf12899_auto2");
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