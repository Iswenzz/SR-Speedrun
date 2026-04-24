main()
{
	maps\mp\_load::main();
	maps\mp\mp_sp_scoutsniper_fx::main();

	setExpFog(0, 5049.45, 0.479631, 0.508939, 0.570905, 0);
	VisionSetNaked( "scoutsniper", 0 );

	thread sr\api\_map::createSpawn((-9895, -12620, -110), 40);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

	thread sr\api\_speedrun::createEndMap((12837.4, 8767.32, -150.375), 90, 70, "normal_0");


	thread delEnts("targetname", "church_door_front");
	thread delEnts("targetname", "pf15401_auto1");
	thread delEnts("target", "pf15401_auto1");
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
