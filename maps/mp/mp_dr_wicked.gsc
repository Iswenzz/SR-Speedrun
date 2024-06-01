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
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");
    setdvar("compassmaxrange","1800");
	setExpFog(100, 1000, 0.4, 0.425, 0.44, 0.0);
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-179, -15, 76), 0);

	thread platform();
	thread trap5_2();
	thread trap1a();
	thread trap1b();
	thread jump();
	thread jump2();
}

platform()
{

platform = getEnt ("moving1", "targetname");


platform moveX (-150, 0.1);

}

trap5_2()
{
platforms2 = getEnt ("trap5_2", "targetname");

platforms2 moveX(520,0.1);
platforms2 waittill ("movedone");
platforms2 moveY(-90,0.1);

}

trap1a()
{
trap1a = getEnt ("trap1a", "targetname");
hurta = getEnt ("trap1a_hurt", "targetname");

hurta delete();
}

trap1b()
{
trap1b = getEnt ("trap1b", "targetname");
hurtb = getEnt ("trap1b_hurt", "targetname");

hurtb delete();
}

platforms2()
{
pf1 = getEnt ("endplatform1", "targetname");
pf2 = getEnt ("endplatform2", "targetname");
trig = getEnt ("platforms2", "targetname");


}

jump()
{
	jumpx = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
    
	time = .5;
	for(;;)
{
		jumpx waittill ("trigger",user);

		user sr\api\_player::antiElevator(true);

		if (user istouching(jumpx))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait .5;
			air moveto (air2.origin, time);
			wait .25;
			air moveto (air3.origin, time);
			wait .5;
			user sr\api\_player::antiElevator(false);
			user unlink();
			wait 1;
}
}
}

jump2()
{
	jump2 = getent ("jump2","targetname");
	glow = getent ("glow3","targetname");
	air1 = getent ("air4","targetname");
	air2 = getent ("air5","targetname");
	air3 = getent ("air6","targetname");

	time = .5;
	for(;;)
{
		jump2 waittill ("trigger",user);

		user sr\api\_player::antiElevator(true);

		if (user istouching(jump2))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait .5;
			air moveto (air2.origin, time);
			wait .25;
			air moveto (air3.origin, time);
			wait .5;
			user sr\api\_player::antiElevator(false);
			user unlink();
			wait 1;
}
}
}
