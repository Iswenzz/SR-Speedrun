main()
{
	thread port1();
	thread port2();
	thread port3();
	//thread port4();
	// thread bonus();
	// thread bonus2();
	// thread bonus3();
	thread door();
	//thread secret();
	thread visu();
	thread visu2();
	thread visu3();
	thread wait_connect();
	// thread final_doors();
	
	level.custom_knife = true; //false = ak47; true = tomahawk
	level.pre_weapon = false;
	
	if(level.custom_knife)
		PreCacheItem("tomahawk_mp");
		
	// PreCacheItem("m40a3_mp");
	// PreCacheItem("remington700_mp");
	
	// thread bounce_weapon();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();
	// thread trap12();
	// thread trap13();
	// thread trap14();
	// thread trap15();
	// thread trap16();
	// thread trap17();
	// thread trap18();
	// thread trap19();
	// thread trap20();
	// thread trap21();
	// thread trap22();
}
wait_connect()
{
	while(1)
	{
		level waittill("connected",player);
		player thread wait_spawn();
	}
}

wait_spawn()
{
	self waittill("spawned_player");
	level notify("first_spawn");
}
onactivetrap()
{
	self waittill("trigger");
	self delete();
}
door()
{
	door = getent("door","targetname");
	
	level waittill("first_spawn");
	
	wait 1;
	door movez(500,2); //druhy udaj je rychlost
	
}
secret()
{
	a = getent("secret","targetname");
	
	level waittill("first_spawn");
	
	while(1)
	{
		a rotatepitch(180,10);
		wait 10	;
		a rotatepitch(180,5);
		wait 5	;
	}	
}
bonus()
{
	trigger = getEnt( "xp1", "targetname" );
	
	trigger waittill( "trigger", player );
	player braxi\_rank::giveRankXP( "bonus", 10 );
}
bonus2()
{
	trigger = getEnt( "xp2", "targetname" );
	
	trigger waittill( "trigger", player );
	player braxi\_rank::giveRankXP( "bonus", 20 );
}
bonus3()
{
	trigger = getEnt( "xp3", "targetname" );
	
	trigger waittill( "trigger", player );
	player braxi\_rank::giveRankXP( "bonus", 30 );
}
visu()
{
	a = getent("va","targetname");
	b = getent("vb","targetname");
	c = getent("vc","targetname");
	d = getent("vd","targetname");
	e = getent("ve","targetname");
	f = getent("vf","targetname");
	g = getent("vg","targetname");
	h = getent("vh","targetname");
	i = getent("vi","targetname");
	j = getent("vj","targetname");
	k = getent("vk","targetname");
	l = getent("vl","targetname");
	m = getent("vm","targetname");
	n = getent("vn","targetname");
	o = getent("vo","targetname");
	p = getent("vp","targetname");
	
	level waittill("first_spawn");
	while(1)
	{
		a rotateyaw(180,0.5);
		b rotateyaw(180,0.6);
		c rotateyaw(180,0.7);
		d rotateyaw(180,0.8);
		e rotateyaw(180,0.9);
		f rotateyaw(180,1);
		g rotateyaw(180,1.1);
		h rotateyaw(180,1.2);
		i rotateyaw(180,1.3);
		j rotateyaw(180,1.4);
		k rotateyaw(180,1.5);
		l rotateyaw(180,1.6);
		m rotateyaw(180,1.7);
		n rotateyaw(180,1.8);
		o rotateyaw(180,1.9);
		p rotateyaw(180,2);
		wait 10	;
	}
}
visu2()
{
	a = getent("v2a","targetname");
	b = getent("v2b","targetname");
	c = getent("v2c","targetname");
	d = getent("v2d","targetname");
	e = getent("v2e","targetname");
	f = getent("v2f","targetname");
	g = getent("v2g","targetname");
	h = getent("v2h","targetname");
	i = getent("v2i","targetname");
	j = getent("v2j","targetname");
	k = getent("v2k","targetname");
	l = getent("v2l","targetname");
	m = getent("v2m","targetname");
	n = getent("v2n","targetname");
	o = getent("v2o","targetname");
	p = getent("v2p","targetname");
	q = getent("v2q","targetname");
	r = getent("v2r","targetname");
	s = getent("v2s","targetname");
	
	level waittill("first_spawn");
	while(1)
	{
		a rotateyaw(180,0.5);
		b rotateyaw(180,0.6);
		c rotateyaw(180,0.7);
		d rotateyaw(180,0.8);
		e rotateyaw(180,0.9);
		f rotateyaw(180,1);
		g rotateyaw(180,1.1);
		h rotateyaw(180,1.2);
		i rotateyaw(180,1.3);
		j rotateyaw(180,1.4);
		k rotateyaw(180,1.5);
		l rotateyaw(180,1.6);
		m rotateyaw(180,1.7);
		n rotateyaw(180,1.8);
		o rotateyaw(180,1.9);
		p rotateyaw(180,2);
		q rotateyaw(180,2.1);
		r rotateyaw(180,2.2);
		s rotateyaw(180,2.3);
		wait 10	;
	}
}
visu3()
{
	a = getent("v3a","targetname");
	b = getent("v3b","targetname");
	c = getent("v3c","targetname");
	d = getent("v3d","targetname");
	e = getent("v3e","targetname");
	f = getent("v3f","targetname");
	g = getent("v3g","targetname");
	h = getent("v3h","targetname");
	i = getent("v3i","targetname");
	j = getent("v3j","targetname");
	k = getent("v3k","targetname");
	l = getent("v3l","targetname");
	
	level waittill("first_spawn");
	while(1)
	{
		a rotateyaw(180,0.5);
		b rotateyaw(180,0.6);
		c rotateyaw(180,0.7);
		d rotateyaw(180,0.8);
		e rotateyaw(180,0.9);
		f rotateyaw(180,1);
		g rotateyaw(180,1.1);
		h rotateyaw(180,1.2);
		i rotateyaw(180,1.3);
		j rotateyaw(180,1.4);
		k rotateyaw(180,1.5);
		l rotateyaw(180,1.6);
		wait 10	;
	}
}

final_doors()
{
	snip_trig = getent("final_snip","targetname");
	bounce_trig = getent("final_bounce","targetname");
	weapons_trig = getent("final_weapons","targetname");
	knife_trig = getent("final_knife","targetname");
	
	snip_trig thread snip(bounce_trig,weapons_trig,knife_trig);
	bounce_trig thread bounce(snip_trig,weapons_trig,knife_trig);
	weapons_trig thread weapons(snip_trig,bounce_trig,knife_trig);
	knife_trig thread knife(snip_trig,bounce_trig,weapons_trig);
}


snip(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	AmbientPlay( "max" );
	
	iprintlnbold("Player ^1"+player.name+" ^3open snipe room!");
	
	porty_allies = getentarray("snip_allies","targetname");
	porty_axis = getentarray("snip_axis","targetname");
	raxis = randomint(porty_axis.size);
	
	players = getentarray("player","classname");
	
	for(i = 0;i < players.size;i++)
	{
		if(isdefined(players[i]) && isplayer(players[i]) && isalive(players[i]) && players[i].pers["team"] == "axis")
		{
			players[i] setorigin(porty_axis[raxis].origin);
			players[i] SetPlayerAngles(porty_axis[raxis].angles);
			
			if(randomint(2))
				weap = "m40a3_mp";
			else
				weap = "remington700_mp";
			
			players[i] TakeAllWeapons();
			players[i] GiveWeapon(weap);
			wait 0.01;
			players[i] SwitchToWeapon(weap);
		}
	}
	
	while(true)
	{
		if(randomint(2))
			weap = "m40a3_mp";
		else
			weap = "remington700_mp";
	
		self jumper_port(player,porty_allies,weap);
		
		self on_player_death(player);
		
		self waittill("trigger",player);
	}
	
}

on_player_death(player)
{	
	player endon("disconnect");
	
	player waittill("death");
}

jumper_port(player,porty_allies,weapon)
{
	rallies = randomint(porty_allies.size);
	
	player setorigin(porty_allies[rallies].origin);
	player SetPlayerAngles(porty_allies[rallies].angles);
	
	player TakeAllWeapons();
	player GiveWeapon(weapon);
	wait 0.01;
	player SwitchToWeapon(weapon);
}

bounce(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	AmbientPlay( "max" );
	
	iprintlnbold("Player ^1"+player.name+" ^3open bounce room!");
	
	porty_allies = getentarray("bounce_allies","targetname");
	porty_axis = getentarray("bounce_axis","targetname");
	raxis = randomint(porty_axis.size);
	
	thread bounce_teleport(porty_allies,porty_axis);
	thread bounce_weapon();
	
	players = getentarray("player","classname");
	
	for(i = 0;i < players.size;i++)
	{
		if(isdefined(players[i]) && isplayer(players[i]) && isalive(players[i]) && players[i].pers["team"] == "axis")
		{
			players[i] setorigin(porty_axis[raxis].origin);
			players[i] SetPlayerAngles(porty_axis[raxis].angles);
		}
	}
	
	while(true)
	{
		if(level.custom_knife)
			weap = "tomahawk_mp";
		else
			weap = "ak47_mp";
			
		self jumper_port(player,porty_allies,weap);
		
		//self on_player_death(player);
		
		self waittill("trigger",player);
	}
	
}

bounce_teleport(port_allies,port_axis)
{
	trig = getent("bounce_tele","targetname");
	
	while(true)
	{
		trig waittill("trigger",player);
		
		raxis = randomint(port_axis.size);
		rallies = randomint(port_allies.size);
		
		if(isplayer(player)&&isalive(player))
		{
			if(player.pers["team"] == "axis")
			{
				player setorigin(port_axis[raxis].origin);
				player SetPlayerAngles(port_axis[raxis].angles);
			}

			if(player.pers["team"] == "allies")
			{
				player setorigin(port_allies[rallies].origin);
				player SetPlayerAngles(port_allies[rallies].angles);
			}			
		}
	}
}

bounce_weapon()
{
	level.jura_weapons = [];
	level.jura_weapons[level.jura_weapons.size] = "saw_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "rpd_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "p90_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "mp5_silencer_mp";
	level.jura_weapons[level.jura_weapons.size] = "m60e4_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "m4_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "m21_acog_mp";
	level.jura_weapons[level.jura_weapons.size] = "m16_mp";
	level.jura_weapons[level.jura_weapons.size] = "m14_reflex_mp";
	level.jura_weapons[level.jura_weapons.size] = "g3_mp";
	level.jura_weapons[level.jura_weapons.size] = "dragunov_acog_mp";
	level.jura_weapons[level.jura_weapons.size] = "deserteagle_mp";
	level.jura_weapons[level.jura_weapons.size] = "ak74u_acog_mp";
	level.jura_weapons[level.jura_weapons.size] = "ak47_mp";
	level.jura_weapons[level.jura_weapons.size] = "colt45_silencer_mp";

	if(!level.pre_weapon)
	{
		level.pre_weapon = true;
		
		for(i = 0;i < level.jura_weapons.size;i++)
		{
			PreCacheItem(level.jura_weapons[i]);
		}
		
		return;
	}
	else
	{
		trig = getent("bounce_weapon","targetname");
		trig waittill("trigger",player);
		trig delete();
		
		rz = randomint(level.jura_weapons.size);
		rk = randomint(2);
		
		if(rk)
		{
			player TakeAllWeapons();
			player GiveWeapon(level.jura_weapons[rz]);
			wait 0.01;
			player SwitchToWeapon(level.jura_weapons[rz]);
			//player iprintlnbold("Toll, sehr schon Gewehr fur dich.");
		}
	}	
}

weapons(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	AmbientPlay( "max" );
	
	iprintlnbold("Player ^1"+player.name+" ^3open weapons room!");

	rz = randomint(level.jura_weapons.size);
	weap = level.jura_weapons[rz];
	
	porty_axis = getentarray("weapons_axis","targetname");
	raxis = randomint(porty_axis.size);
	
	players = getentarray("player","classname");
	
	for(i = 0;i < players.size;i++)
	{
		if(isdefined(players[i]) && isplayer(players[i]) && isalive(players[i]) && players[i].pers["team"] == "axis")
		{
			players[i] setorigin(porty_axis[raxis].origin);
			players[i] SetPlayerAngles(porty_axis[raxis].angles);
			
			players[i] TakeAllWeapons();
			players[i] GiveWeapon(weap);
			wait 0.01;
			players[i] SwitchToWeapon(weap);
		}
	}
	
	porty_allies = getentarray("weapons_allies","targetname");
	
	while(true)
	{
		rz = randomint(level.jura_weapons.size);
		weap = level.jura_weapons[rz];
		
		self jumper_port(player,porty_allies,weap);
		
		self on_player_death(player);
		
		self waittill("trigger",player);
	}
}

knife(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	AmbientPlay( "max" );
	
	iprintlnbold("Player ^1"+player.name+" ^3open knife room!");
	
	if(level.custom_knife)
		weap = "tomahawk_mp";
	else
		weap = "ak47_mp";
	
	while(1)
	{
		porty_axis = getentarray("knife_axis","targetname");
		raxis = randomint(porty_axis.size);
		porty_allies = getentarray("knife_allies","targetname");
		rallies = randomint(porty_allies.size);
	
		players = getentarray("player","classname");
		
		for(i = 0;i < players.size;i++)
		{
			if(isdefined(players[i]) && isplayer(players[i]) && isalive(players[i]) && players[i].pers["team"] == "axis")
			{
				players[i] setorigin(porty_axis[raxis].origin);
				players[i] SetPlayerAngles(porty_axis[raxis].angles);
			}
		}

		self jumper_port(player,porty_allies,weap);
		
		self on_player_death(player);
		
		self waittill("trigger",player);	
	}	
}


port1()
{
	trig = getent("port1","targetname");
	target = getent(trig.target , "targetname");
	while(1)
	{
		trig waittill("trigger",player);

		player setorigin(target.origin);
		player SetPlayerAngles(target.angles);
	}
}
port2()
{
	trig = getent("port2","targetname");
	target = getent(trig.target , "targetname");
	
	while(1)
	{
		trig waittill("trigger",player);

		player setorigin(target.origin);
		player SetPlayerAngles(target.angles);
	}
}
port3()
{
	trig = getent("port3","targetname");
	target = getent(trig.target , "targetname");
	
	while(1)
	{
		trig waittill("trigger",player);

		player setorigin(target.origin);
		player SetPlayerAngles(target.angles);
	}
}
port4()
{
	trig = getent("port4","targetname");
	target = getent(trig.target , "targetname");
	
	for(;;)
	{
		trig waittill("trigger",player);
		
		if(player getStance() != "prone")
			continue;
		
		player setorigin(target.origin);
		player SetPlayerAngles(target.angles);
	}
}

trap1()
{
	active = getent("t1_","targetname");
	a = getent("t1a","targetname");
	b = getent("t1b","targetname");
	c = getent("t1c","targetname");
	d = getent("t1d","targetname");
	e = getent("t1e","targetname");
	f = getent("t1f","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movex(56,0.5);
		b movex(-56,0.5);
		c movex(56,0.5);
		d movex(-56,0.5);
		e movex(56,0.5);
		f movex(-56,0.5);
		wait 2;
		a movex(-56,0.5);
		b movex(56,0.5);
		c movex(-56,0.5);
		d movex(56,0.5);
		e movex(-56,0.5);
		f movex(56,0.5);
		wait 2;
	}
}


trap2()
{
	active = getent("t2_","targetname");
	a = getent("t2a","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movez(200,1.5);

		wait 1.5;
		a movez(-200,1.5);

		wait 1.5;
	}
}

trap3()
{
	active = getent("t3_","targetname");
	a = getent("t3a","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movez(50,1);

		wait 1;
		a movez(-50,1);

		wait 1;
	}
}

trap4()
{
	active = getent("t4_","targetname");
	a = getent("t4a","targetname");
	b = getent("t4b","targetname");
	c = getent("t4c","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movez(-64,1.2);
		b movex(-128,1.2);
		c movez(64,1.2);
		wait 1.2;
		a movey(-64,1.2);
		b movex(128,1.2);
		c movey(64,1.2);
		wait 1.2;
		a movez(64,1.2);
		b movex(-128,1.2);
		c movez(-64,1.2);
		wait 1.2;
		a movey(64,1.2);
		b movex(128,1.2);
		c movey(-64,1.2);
		wait 1.2;
	}
}
trap5()
{
	active = getent("t5_","targetname");
	a = getent("t5a","targetname");
	b = getent("t5b","targetname");
	Z = 5; //rychlost otacania
	
	active onactivetrap();
	
	while(1)
	{
		a rotateyaw(360,Z);
		b rotateyaw(360,Z);
		wait Z	;
	}
}

trap6()
{
	active = getent("t6_","targetname");
	a = getent("t6a","targetname");
	b = getent("t6b","targetname");
	Z = 5; //rychlost otacania
	
	active onactivetrap();
	
	while(1)
	{
		a rotateyaw(-360,Z);
		b rotateyaw(-360,Z);
		wait Z	;
	}
}
trap7()
{
	active = getent("t7_","targetname");
	a = getent("t7a","targetname");
	b = getent("t7b","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movex(220,2);
		b movex(-220,2);
		wait 2;
		a movex(-220,2);
		b movex(220,2);
		wait 2;

	}
}
trap8()
{
	active = getent("t8_","targetname");
	a = getent("t8a","targetname");
	b = getent("t8b","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movey(120,2);
		b movey(-120,2);
		wait 2;
		a movey(-120,2);
		b movey(120,2);
		wait 2;

	}
}
trap9()
{
	active = getent("t9_","targetname");
	a = getent("t9a","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movez(-120,2);
		wait 2;
		a movex(-192,5);
		wait 5;
		a movex(192,5);
		wait 5;
		a movez(120,2);
		wait 2;

	}
}
trap10()
{
	active = getent("t10_","targetname");
	a = getent("t10a","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movex(180,3);

		wait 3;
		a movex(-180,3);

		wait 3;

	}
}
trap11()
{
	active = getent("t11_","targetname");
	a = getent("t11a","targetname");
	b = getent("t11b","targetname");
	c = getent("t11c","targetname");
	d = getent("t11d","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movex(-128,2);
		b movex(128,2);
		c movex(-128,2);
		d movex(128,2);
		wait 2;
		a movex(128,2);
		b movex(-128,2);
		c movex(128,2);
		d movex(-128,2);
		wait 2;

	}
}
trap12()
{
	active = getent("t12_","targetname");
	a = getent("t12a","targetname");
	b = getent("t12b","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movez(60,1);
		b movez(-70,1);
		wait 1;
		a movez(-60,1);
		b movez(70,1);
		wait 1;
		a movez(60,1);
		b movez(-70,1);
		wait 1;
		a movez(-60,1);
		b movez(70,1);
		wait 1;


	}
}
trap13()
{
	active = getent("t13_","targetname");
	a = getent("t13a","targetname");
	Z = 5; //rychlost otacania
	
	active onactivetrap();
	
	while(1)
	{
		a rotateyaw(360,Z);
		wait Z	;
	}
}
trap14()
{
	active = getent("t14_","targetname");
	a = getent("t14a","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movey(132,1);

		wait 2;
		a movey(-132,1);

		wait 2;


	}
}
trap15()
{
	active = getent("t15_","targetname");
	a = getent("t15a","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movez(198,1);

		wait 3;
		a movez(-198,1.5);

		wait 3.3;


	}
}
trap16()
{
	active = getent("t16_","targetname");
	a = getent("t16a","targetname");
	Z = 5; //rychlost otacania
	
	active onactivetrap();
	
	while(1)
	{
		a rotateyaw(360,Z);
		wait Z	;
	}
}
trap17()
{
	active = getent("t17_","targetname");
	a = getent("t17a","targetname");
	b = getent("t17b","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a moveY(96,2);
		b moveY(-96,2);

		wait 2;
		a moveY(-96,2);
		b moveY(96,2);

		wait 2;

	}
}
trap18()
{
	active = getent("t18_","targetname");
	a = getent("t18a","targetname");
	b = getent("t18b","targetname");
	c = getent("t18c","targetname");
	d = getent("t18d","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movez(-35,1);
		b movez(35,1);
		c movey(160,1);
		d movey(-160,1);
		wait 1;
		a movez(35,1);
		b movez(-35,1);
		c movey(-160,1);
		d movey(160,1);

		wait 1;

	}
}
trap19()
{
	active = getent("t19_","targetname");
	a = getent("t19a","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movey(192,2);

		wait 2;
		a movey(-192,2);

		wait 2;

	}
}
trap20()
{
	active = getent("t20_","targetname");
	a = getent("t20a","targetname");
	b = getent("t20b","targetname");
	c = getent("t20c","targetname");
	
	active onactivetrap();
	
	while(1)
	{
		a movex(148,1);
		b movex(-148,1);
		c movex(148,1);
		wait 1;
		a movex(-148,1);
		b movex(148,1);
		c movex(-148,1);
		wait 1;

	}
}
trap21()
{
	active = getent("t21_","targetname");
	a = getent("t21a","targetname");
	b = getent("t21b","targetname");
	c = getent("t21c","targetname");
	d = getent("t21d","targetname");
	e = getent("t21e","targetname");
	Z = 4; //rychlost otacania
	
	active onactivetrap();
	
	while(1)
	{
		a rotateyaw(360,Z);
		b rotateyaw(-360,Z);
		c rotateyaw(360,Z);
		d rotateyaw(-360,Z);
		e rotateyaw(360,Z);
		wait Z	;
		a rotateyaw(-360,Z);
		b rotateyaw(360,Z);
		c rotateyaw(-360,Z);
		d rotateyaw(360,Z);
		e rotateyaw(-360,Z);
		wait Z	;
	}
}
trap22()
{
	active = getent( "t22_", "targetname" );
	door = getent( "t22a", "targetname" );
	
	active onactivetrap();
	
	while(1)
	{
		
		door Movez(384,2);
		wait 2;
		door Movey(704,6);
		wait 6;
		door Movez(-384,2);
		wait 2;
		door Movey(-704,2);
		wait 2;
	}
}