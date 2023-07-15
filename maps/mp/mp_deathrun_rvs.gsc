main()
{
	thread sr\api\_defrag::weapons("");
thread sr\api\_map::createSpawnOrigin((2, -84, 32), 270);
maps\mp\_load::main();

game["allies"] = "marines";
game["axies"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

setDvar("bg_falldamagemaxheight", 300000 );
setDvar("bg_falldamageminheight", 128000 );

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((220.04, -217.58, 32.125), 55, 30, (3187, 10264, 556), 90, "freeze", "yellow", "secret_0");
thread sr\api\_speedrun::createEndMap((424.799, 3968.03, -2175.88),200,20, "normal_0");

thread start();
thread bounce();
thread finishsecretroom();
thread movingplat();

}

start()
{
	startdoor = getent("startdoor","targetname");

    wait 0.1;
	startdoor Delete();

}

bounce()
{
	bounce = getEnt("trap10bounce", "targetname");

	wait 0.1;
	bounce moveX(800, 0.1);
	wait 0.3;
	bounce moveY(1000, 0.1);


}

finishsecretroom()
{
	for (;;)
	{
	finish = getEnt("finishsecretbounceroom", "targetname");
	teleport = getEnt("secretteleport", "targetname");
	finish waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_0");
	player SetPlayerAngles( teleport.angles );
	player setOrigin(teleport.origin);
	}

}

movingplat()
{
largeblock = getEnt("largeblockmove", "targetname");

wait 0.1;
largeblock moveY (100, 0.1);

}