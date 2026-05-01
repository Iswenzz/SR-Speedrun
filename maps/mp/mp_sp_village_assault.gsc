main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_village_assault_fx::main();

	setExpFog(500, 5500, .05, .08, 0.13, 0);
	VisionSetNaked( "village_assault", 0 );

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((1275, -3595, -533), 170);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

	thread sr\api\_speedrun::createEndMap((950.732, 7462.04, 961.125), 90, 70, "normal_0");

	thread delEnts("targetname", "alasad_barn_door");
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
