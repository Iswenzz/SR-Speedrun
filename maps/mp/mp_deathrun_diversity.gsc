main()
{
 maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1200");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_map::createSpawn((589, -5310, 92), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("Secret Way");
	thread sr\api\_speedrun::createEndMap((5276.65, 169.595, 20.4222), 210, 175, "normal_0");

	thread hurt_triggers();
	thread secret_enter();
	thread secret_exit();

	
}
	
hurt_triggers()
{
hurt_1 = getEnt("spinner_hurt", "targetname");
hurt_2 = getEnt("drill_hurt1", "targetname");
hurt_3 = getEnt("drill_hurt2", "targetname");
hurt_4 = getEnt("drill_hurt3", "targetname");
hurt_5 = getEnt("drill_hurt4", "targetname");
hurt_6 = getEnt("drill_hurt5", "targetname");
hurt_7 = getEnt("drill_hurt6", "targetname");
hurt_8 = getEnt("drill_hurt7", "targetname");

hurt_1 delete();
hurt_2 delete();
hurt_3 delete();
hurt_4 delete();
hurt_5 delete();
hurt_6 delete();
hurt_7 delete();
hurt_8 delete();

}

secret_enter()
{
	trig = spawn("trigger_radius",(752.096, -5309.99, 32.125), 0, 60, 100);
	trig.radius = 60;
	
	ori_t = spawn("script_origin",(1437,-4311,1380));
	ori_t.angles = (0,360,0);

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}

secret_exit()
{
    trig = spawn("trigger_radius",(6219.43, -3079.12, 1104.12), 0, 90, 80);
	trig.radius = 60;

	thread sr\api\_map::createTriggerFx(trig, "orange");
   
   for (;;)
    {   
    trig waittill ("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_0");
    }
}