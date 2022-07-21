main()
{
thread sr\api\_map::createSpawn((645, -2, 96), 360);
maps\mp\_load::main();
	
game["allies"] = "sas";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "woodland";
game["axis_soldiertype"] = "woodland";
	
setdvar( "r_specularcolorscale", "2" );	
setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");
setDvar("bg_falldamagemaxheight", 99999);
setDvar("bg_falldamageminheight", 99998);

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createTeleporter((2555.31, 0.981149, 96.125), 60, 10, (3555, 12, 156), 270, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createTeleporter((2200.05, -1985.79, 32.125), 65, 10, (-3202, -2595, -1294), 180, "freeze", "blue", "normal_0");
thread startspikes();
thread jumperstage3tp();
thread stage2tp_a();
thread part3fdoor();
thread trap4();
}

startspikes()
{
	spikes1 = getent("spikes1","targetname");
	spike2 = getent("spike2","targetname");

	while(1)
	{
	wait 0.1;
	spikes1 hide();
	spikes1 notsolid();
	spike2 hide();
	spike2 notsolid();
	}
}

jumperstage3tp()
{
	trig = getent("jumperstage3tp_t","targetname");
	org = getent("jumperstage3tp_o","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		player setorigin(org.origin);

	}
}

stage2tp_a()
{
	trig = getent("stage2tp_a","targetname");
	spot = getent("stage2tp_oa","targetname");
	for(;;)
	{
		trig waittill("trigger", a);
		a setorigin(spot.origin);
		a setplayerangles(spot.angles);
		wait .1;
	}
}

part3fdoor()
{
door = getent("part3fdoor","targetname");

while(1)
	{
	wait 0.1;
	door hide();
	door notsolid();
	}
}

trap4()
{
	s1 = getent("secret_1","targetname");
	s2 = getent("secret_2","targetname");
	k1 = getent("k1","targetname");
	k2 = getent("k2","targetname");
	trig = getent("trap4trig","targetname");
	k1 maps\mp\_utility::triggerOff();
	k2 maps\mp\_utility::triggerOff();
	trig waittill("trigger",player);
	{
		k1 maps\mp\_utility::triggerOn();
		k2 maps\mp\_utility::triggerOn();
		k1 enablelinkto();
		k1 linkto(s1);
		k2 enablelinkto();
		k2 linkto(s2);
		s1 movex(-32,3);
		s2 movex(32,3);
		wait randomint(5)+3;
		s1 movex(32,1);
		s2 movex(-32,1);
		wait 1;
		k1 delete();
		k2 delete();
	}
}