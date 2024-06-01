main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setdvar("bg_fallDamageMinHeight", "99998");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar( "r_specularcolorscale", "1" );


	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((449, 4738, -4477), 90);
	
	thread jumper();
	thread easy_enter();
	thread easy_fail();
	thread startdoor();
	thread secret5();

	

}

jumper()
{
jumpx = getent ("jump","targetname");
glow = getent ("glow","targetname");
air1 = getent ("air1","targetname");
air2 = getent ("air2","targetname");
air3 = getent ("air3","targetname");
air4 = getent ("air4","targetname");
air5 = getent ("air5","targetname");


	for(;;)
	{
	jumpx waittill ("trigger",player);
		if (player istouching(jumpx))
		{

        player sr\api\_player::antiElevator(false);

		air = spawn ("script_model",(0,0,0));

		air.origin = player.origin;
		air.angles = player.angles;
		player linkto (air);
		time = 1;
            air moveto (air1.origin, 1);
		wait 1;
            air moveto (air2.origin, 1);
		wait .5;
            air moveto (air3.origin, 1);
		wait .5;
            air moveto (air4.origin, 1);
			wait .5;
            air moveto (air5.origin, 1);

		wait 1;

		player sr\api\_player::antiElevator(true);

		player unlink();
		wait 1;
		}
	}
}

startdoor()
{
	door = getent("startdoor_brush","targetname");
	
	door delete();
}


secret5()
{
trig = getEnt("trigger_teleport4","targetname");


for(;; )
   {
    trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");
   

   }
}

easy_enter()
{
	trig = spawn("trigger_radius",(284.778, 4737.68, -4536.88), 0, 60, 100);
	trig.radius = 60;
	ori_t = getEnt("easy_enter_targ","targetname");

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

easy_fail()
{
	trig = getent("easy_fail_trig","targetname");

	for(;;)
	{
		trig waittill("trigger",player);

		player Suicide();

		
	}
}

teleport1()
{
trig = getEnt("trigger_teleport1","targetname");
tele1 = getEnt("origin_teleport1","targetname");


for(;; )
   {
    trig waittill("trigger", player);
    player setOrigin(tele1.origin);


   }
}

teleport2()
{
trig = getEnt("trigger_teleport2","targetname");
tele2 = getEnt("origin_teleport2","targetname");


for(;; )
   {
    trig waittill("trigger", player);
    player setOrigin(tele2.origin);


   }
}




teleport4()
{
trig = getEnt("trigger_teleport4","targetname");
tele4 = getEnt("origin_teleport4","targetname");


for(;; )
   {
    trig waittill("trigger", player);
    player setOrigin(tele4.origin);


   }
}
