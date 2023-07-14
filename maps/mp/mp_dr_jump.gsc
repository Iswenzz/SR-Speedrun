main()
{
 maps\mp\_load::main();

 game["allies_soldiertype"] = "desert";
 game["allies_soldiertype"] = "desert";
 game["allies_soldiertype"] = "desert";
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["axis_soldiertype"] = "desert";
 
 
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("First Secret;Second Secret;");
	thread sr\api\_map::createSpawn((-40, 22, 76), 90);
	thread sr\api\_speedrun::createEndMap((4770.51, 1983.61, -15.875), 140, 100);
	thread sr\api\_speedrun::createTeleporter((133.983, 22.1149, 16.125), 60, 100, (-66, 17950, 1068), 88, "freeze", "orange", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-217.7, 24.1249, 16.125), 60, 100, (3176, 16849, 736), 1, "freeze", "green", "secret_1");

	thread startdoor();
	thread secretjumpfail();
	thread endsecret();
	thread endsecret2();
	
}

startdoor()
{
lootje = getent("startdoor","targetname");
{
lootje delete();

}
}

secretjumpfail()
{
	secretjumper = getEnt("secret_jumper_respawn", "targetname");
	origin_jumper_secret = getEnt("origin_jumper_secret", "targetname");
	
	for (;;)
	{
		secretjumper waittill("trigger", player);
		player Suicide();
	}
}

endsecret()
{
   endsecret_trigger = getent("trig_tp2","targetname");
   telejumporigin2 = getent("jumper_secretend", "targetname");
   
   for (;;)
   {
    endsecret_trigger waittill( "trigger", player );

    player thread sr\api\_speedrun::finishWay("secret_0");
   
}
}

endsecret2()
{
   endsecret2_trigger = getent("trig_tp3","targetname");
   telejumporigin3 = getent("jumper_secretend2", "targetname");
   
   for (;;)
   {
    endsecret2_trigger waittill( "trigger", player );

    player thread sr\api\_speedrun::finishWay("secret_1");
   
}
}