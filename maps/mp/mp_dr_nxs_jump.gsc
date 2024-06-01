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
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((781, 152, 252), 90);
	thread sr\api\_speedrun::createTeleporter((916.198, 150.936, 192.125), 60, 100, (-1061, -1578, 836), 270, "freeze", "yellow", "secret_0");
	thread sr\api\_speedrun::createEndMap((810.318, -131.119, 241.125), 105, 100);


	thread sec_end();
	thread traps();

}

sec_end()
{
	trig = getent ("out", "targetname");

	while(1)
	{	
	trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");

	}
}

traps()
{
	hurt = GetEnt("trap6_dmg","targetname");
	trap3e = GetEnt("trap3_e","targetname");
	trap4 = GetEnt("trap4","targetname");
	trap6 = GetEnt("trap6","targetname");
	
	hurt delete();
	trap4 delete();
	trap6 delete();
	trap3e moveY(-600,0.1);
	trap3e waittill ("movedone");
	trap3e moveX(300,0.1);

}