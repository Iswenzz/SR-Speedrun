main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((512, 192, 60), 90);


	/*jumpPads = getEntArray("trig_jumppad", "targetname");
	for(i = 0; i < jumpPads.size; i++)
	jumpPads[i] thread monitorTrigger();*/

	windtrigs = getentarray("auto1","targetname");
    for (i = 0; i < windtrigs.size; i++)
    windtrigs[i] delete();

	windtrigs1 = getentarray("auto4","targetname");
    for (i = 0; i < windtrigs1.size; i++)
    windtrigs1[i] delete();


}

/*monitorTrigger()
{
	for(;;)
	{
		self waittill("trigger", player);
		if(isPlayer(player) && isAlive(player))
		player thread Boost(Int(self.script_noteworthy));
	}
}

Boost(damage)
{
	eInflictor = self;
	eAttacker = self;
	iDamage = damage;
	iDFlags = 0;
	sMeansOfDeath = "MOD_PROJECTILE";
	sWeapon = "rpg_mp";
	vPoint =  (self.origin + (0, 0, -1));
	vDir = vectornormalize(self.origin - vPoint);
	sHitLoc = "none";
	psOffsetTime = 0;
	self.health += iDamage;
	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
}*/