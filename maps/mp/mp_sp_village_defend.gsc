main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_village_defend_fx::main();

	setExpFog( 2000, 5500, 0.462745, 0.478431, 0.454902, 0 );
	VisionSetNaked( "village_defend", 0 );

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );

	thread sr\api\_map::createSpawn((937, 7433, 1022), 255);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

	thread sr\api\_speedrun::createEndMap((844.163, -3837.15, -593.614), 90, 70, "normal_0");

	thread delEnts("targetname", "helo_safety_blocker");
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
