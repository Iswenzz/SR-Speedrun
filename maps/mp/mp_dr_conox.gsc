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
	thread sr\api\_map::createSpawn((23, -7, 76), 180);

	thread jport1();
	thread jport2();
	thread jport3();
	thread movingplat();
	thread sec_enter();
	thread sec_fail();
	thread sec_exit();
	thread startdoor();

}


startdoor()
{
door = getent("startdoor","targetname");

door delete();


}

jport1()
{
in = getent("jumper_in1", "targetname");
out = getent("jumper_out1", "targetname");


for(;;)
{
in waittill("trigger", player);
player SetOrigin(out.origin);
player setplayerangles(out.angles);
player FreezeControls(1);
wait 0.1;
player FreezeControls(0);
  
}
}

jport2()
{
in = getent("jumper_in2", "targetname");
out = getent("jumper_out2", "targetname");


for(;;)
{
in waittill("trigger", player);
player SetOrigin(out.origin);
player setplayerangles(out.angles);
player FreezeControls(1);
wait 0.1;
player FreezeControls(0);
  
}
}

jport3()
{
in = getent("jumper_in3", "targetname");
out = getent("jumper_out4", "targetname");


for(;;)
{
in waittill("trigger", player);
player SetOrigin(out.origin);
player setplayerangles(out.angles);
player FreezeControls(1);
wait 0.1;
player FreezeControls(0);
  
}
}


movingplat()
{

plat = getent("movingplat", "targetname");

plat moveX(-228, 0.1);

}

sec_enter()
{
	trig = spawn("trigger_radius",(23.0058, -134.646, 16.125), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("nd32_j","targetname");

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

sec_fail()
{
trig = getent("nd32_b","targetname");

for(;;)
{
trig waittill("trigger", player);

player Suicide();

}
}

sec_exit()
{
trig = getent("nd32_f", "targetname");

for(;;)
{

trig waittill("trigger", player);

player thread sr\api\_speedrun::finishWay("secret_0");

}
}
