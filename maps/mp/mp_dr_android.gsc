main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_speedrun::cj();
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-256, 217, 220), 270);
	thread sr\api\_speedrun::createWay((-955.159, 1.17853, 144.125), 260, 150, "cyan", "secret_0");


	thread main_door();
	thread secret_finish();


}


main_door()
{
	door = getEnt("main_door", "targetname");
	trig = getEnt ("secretdoor", "targetname");

	door delete();
	trig delete();
}

secret_finish()

{
	trig = getEnt ("secretend", "targetname");
	target = getEnt ("secrettarget", "targetname");

	for(;;)
{
	trig waittill ("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");

}

}
