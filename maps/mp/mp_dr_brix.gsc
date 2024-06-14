main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-5, -245, 76), 270);
	thread sr\api\_speedrun::createTeleporter((-447.119, 6269.29, -103.875), 85, 100, (-1035, 6224, 1004), 90, "freeze");
	thread sr\api\_speedrun::createTeleporter((118.817, -3257.39, 16.125), 120, 100, (-1892,-3260,76), 180, "freeze");

	thread startdoor();
	thread movingplat();
	thread secret_enter();
	thread secret_fail();
	thread secret_exit();



}

startdoor()
{
foxi = getent("startdoor","targetname");

foxi delete();


}

movingplat()
{
	plat = getent ("moving_platform", "targetname");

	plat moveX (1824, 0.1);
	
}

secret_enter()
{
	trig = spawn("trigger_radius",(142.254, -244.99, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("secret_jumper_enter","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

secret_fail()
{
trig = getent("secret_floor","targetname");
jumper_restart = getent("secret_jumper_restart", "targetname");


for(;;)
{

trig waittill("trigger", player);

player Suicide();

}
}

secret_exit()
{
trig = getent("secret_out", "targetname");
jumper_out = getent("secret_jumper_out", "targetname");

for(;;)
{
trig waittill("trigger", player);

player thread sr\api\_speedrun::finishWay("secret_0");

}
}