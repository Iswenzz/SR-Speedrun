main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_armada_fx::main();
	
	setExpFog(800, 6000, .583, .644 , .587, 0);
	VisionSetNaked( "armada", 0 );

	thread sr\api\_map::createSpawn((1113, 31663, 12), 270);
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((4580, 22143, 320), 65, 70, "normal_0");

	thread delEnts("targetname", "final_door_attachments");
	thread delEnts("targetname", "door_final");
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

