main()
{

	thread way_connect();

	maps\mp\_load::main();
	maps\mp\sonic\_teleport::main();
	// ambientPlay("song");
	
	// precacheModel("sonic");

	
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	// thread message();
	// thread jumper1();
	// thread jumper2();
	thread first_door();
	// thread onPlayerSpawn();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	thread trap9();
	thread platform();
	// thread final_doors();
	// thread text();
	// thread exp2();
	// thread exp4();
	// thread exp6();
	// thread exp8();

	// addTriggerToList( "trap1_trig" );
	// addTriggerToList( "trap2_trig" );
	// addTriggerToList( "t3" );
	// addTriggerToList( "trap4_trig" );
	// addTriggerToList( "trap5_trig" );
	// addTriggerToList( "trap6_trig" );
	// addTriggerToList( "trap7_trig" );
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	sr\api\_map::createWay("secret", "Secret Way", "1");
	
	thread secret_1();
	
    for(;;) 
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
		player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self.secret_1 = undefined;
		self.secret_1_endtrig = undefined;
	}
}

secret_1()
{
	trigger = spawn( "trigger_radius", (-277.089, -485.057, 20.125), 0, 20, 105 );
	
	wait 1;
	trigger.radius = 20;
	thread speedrun\_triggerfx::createTrigFx(trigger, "secret");
	
	for(;;)
	{
		trigger waittill("trigger",player);
		
		if(!isDefined(player.secret_1))
		{
			player.secret_1 = true;
			player sr\api\_map::startSecret(); //Speedrun Copy Paste
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

message()
{
	trig = getEnt("message","targetname");
	trig waittill("trigger");
	trig delete();
	
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "bottom";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "bottom";
		hud_clock.alpha = 1;
		hud_clock.x = 0;
		hud_clock.y = -150;
		hud_clock.font = "objective";
		hud_clock.fontscale = 2;
		hud_clock.glowalpha = 1.5;
		hud_clock.glowcolor = (1,1,0);
		hud_clock.label = &"Map by Calum";
		hud_clock SetPulseFX( 40, 5400, 200 );
		wait 8;
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "bottom";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "bottom";
		hud_clock.alpha = 1;
		hud_clock.x = 0;
		hud_clock.y = -150;
		hud_clock.font = "objective";
		hud_clock.fontscale = 2;
		hud_clock.glowalpha = 1.5;
		hud_clock.glowcolor = (0,1,0);
		hud_clock.label = &"Sonic!!!";
		hud_clock SetPulseFX( 40, 5400, 200 );
		wait 6;
}
jumper1()
{
	jumpx = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");

	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}
jumper2()
{
	jumpx = getent ("jump1","targetname");
	glow1 = getent ("glow1","targetname");
	air4 = getent ("air4","targetname");
	air5 = getent ("air5","targetname");
	air6 = getent ("air6","targetname");

	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow1.origin), 3, (glow1.origin) + (0, 0, 90));

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air4.origin, time);
			wait 1;
			air moveto (air5.origin, time);
			wait .5;
			air moveto (air6.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

onPlayerSpawn()
{
	while(1)
	{
		level waittill( "player_spawn", player );
		player detachAll();
		player setModel( "sonic" );
		
	}
}

platform()
{
	platform = getEnt("trap4","targetname");
	
	{
		platform moveX(240,1);
	}
}

first_door()
{
	trig = getEnt("first_door_trig","targetname");
	brush = getEnt("first_door","targetname");
	button = getEnt("button_door","targetname");
	roof = getEnt("rooftop","targetname");
	
	wait 1;
	// trig waittill("trigger", user);
	trig delete();
	
	button moveX(-8,1);
	wait 1;
	brush moveZ(-240,1);
	brush waittill("movedone");
	brush delete();
	// roof delete();
}
trap1()
{
	trig = getEnt("trap1_trig","targetname");
	brush = getEnt("trap1","targetname");

	trig waittill("trigger");
	trig delete();


		while( 1 )
	{
		brush rotateroll(360,9); 
		wait 5; 
	}
}
trap2()
{
trig = getEnt ("trap2_trig", "targetname");	
spikes = getEnt ("trap2", "targetname"); 


trig waittill ("trigger");
trig delete ();


{
spikes moveZ (-210,2); 
wait 5;
spikes moveZ (210,2); 
wait 5;
}
}
trap3()
{
part1 = getentarray ("t3_1" ,"targetname");
part2 = getentarray ("t3_2" ,"targetname");

//red = getent ("red7" ,"targetname"); //origin
t3 = getent ("t3" , "targetname");

t3 waittill ("trigger");
t3 delete ();


//fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

part1[randomInt(part1.size)] notsolid();
part2[randomInt(part2.size)] notsolid();
}

text()
{
 for(;;)
 {
  iprintln("^1>>>  Map made by ^5Calum  ^1<<<");
  wait 30;
  iprintln("^1>>>  ^5#YOLO  ^1<<<");
  wait 30;
  iprintln("^2Bumba, Jack<3");
  wait 120;
 }
}
trap4()
{
trig = getEnt ("trap4_trig", "targetname");	
hurt = getEnt ("trap4_spikeshurt", "targetname");	
spikes = getEnt ("trap4_spike", "targetname"); 

hurt enablelinkto(); 
hurt linkto (spikes); 

trig waittill ("trigger");
trig delete ();


{
spikes moveZ (-196,1); 
wait 5;
spikes moveZ (196,1); 
wait 5;
}
}

trap5()
{
	trig = getEnt("trap5_trig","targetname");
	platform = getEnt("trap5","targetname");

	trig waittill("trigger", user);
	trig delete();
	
	
	platform moveY(416,3);
	wait 3;
	platform moveY(-416,3);
	wait 3;
}
trap6()
{
	trig = getEnt("trap6_trig","targetname");
	roll1 = getEnt("trap6","targetname");
	
	trig waittill("trigger");
	trig delete();
	while(true)
	{
		roll1 rotateroll(1440,4);
		wait 8;
		roll1 rotateroll(-1440,4);
		wait 8;
	}
}
trap7()
{
   trigger = getEnt ("trap7_trig" , "targetname");
   spikes = getEnt ("trap7" ,"targetname" );
   hurt = getEnt ("trap7_spikehurt", "targetname");
   
   hurt enablelinkto(); 
   hurt linkto (spikes); 

   trigger waittill ("trigger",player);  
   trigger delete ();
   
   for( i = 0; i < 999; i++ )
    {
        spikes moveY (700,4); 
        wait 3;
        spikes moveY (-700,4); 
        wait 3;
    }
}
trap8()
{
	hammer[0] = getEnt("trap8aa","targetname");
	hammer[1] = getEnt("trap8b","targetname");
	hammer[2] = getEnt("trap8c","targetname");
	hammer[3] = getEnt("trap8d","targetname");
	while(1)
	{
		hammer[0] rotateroll(180,1);
		hammer[1] rotateroll(-180,1);
		hammer[2] rotateroll(180,1);
		hammer[3] rotateroll(-180,1);
		wait 1.5;
		hammer[0] rotateroll(-180,1);
		hammer[1] rotateroll(180,1);
		hammer[2] rotateroll(-180,1);
		hammer[3] rotateroll(180,1);
		wait 1.5;
	}
}
trap9()
{
   spikes = getEnt ("trap9" ,"targetname" );

   
	{
        spikes moveZ (96,2); 
        wait 2;
	}
}
final_doors()
{
	old_trig = getent("final_old","targetname");
	snip_trig = getent("final_snip","targetname");
	bounce_trig = getent("final_bounce","targetname");
	weapons_trig = getent("final_weapons","targetname");
	knife_trig = getent("final_knife","targetname");
	
	old_trig thread old(snip_trig,bounce_trig,weapons_trig,knife_trig);
	snip_trig thread snip(old_trig,bounce_trig,weapons_trig,knife_trig);
	bounce_trig thread bounce(snip_trig,old_trig,weapons_trig,knife_trig);
	weapons_trig thread weapons(snip_trig,old_trig,bounce_trig,knife_trig);
	knife_trig thread knife(snip_trig,old_trig,bounce_trig,weapons_trig);
}

old(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	
	iprintlnbold("Player ^1"+player.name+" ^7open old room!");
	
	doors = getentarray("final_door","targetname");
	
	r = randomint(doors.size);
	doors[r] movez(110,2);
}

snip(final1,final2,final3,final4)
{
	self waittill("trigger", player);
	
	//self delete();
	final1 delete();
	final2 delete();
	final3 delete();
	final4 delete();
	
	
	
	iprintlnbold("Player ^1"+player.name+" ^7entered snipe room!");

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
			players[i] GiveMaxAmmo(weap);
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
	
	
	
	iprintlnbold("Player ^1"+player.name+" ^7entered bounce room!");
	
	porty_allies = getentarray("bounce_allies","targetname");
	porty_axis = getentarray("bounce_axis","targetname");
	raxis = randomint(porty_axis.size);
	
	thread bounce_teleport(porty_allies,porty_axis);
	
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
	
	
	
	iprintlnbold("Player ^1"+player.name+" ^7entered weapons room!");

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
			
			if(randomint(2))
				weap = "ak47_mp";
			else
				weap = "m60e4_reflex_mp";
			
			players[i] TakeAllWeapons();
			players[i] GiveWeapon(weap);
			wait 0.01;
			players[i] SwitchToWeapon(weap);
		}
	}
	
	porty_allies = getentarray("weapons_allies","targetname");
	
	while(true)
	{
		if(randomint(2))
			weap = "ak47_mp";
		else
			weap = "m60e4_reflex_mp";
		
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
	
	
	
	iprintlnbold("Player ^1"+player.name+" ^7entered knife room!");
	
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
exp2()
{
	trig = getEnt( "xp2", "targetname");
	
	trig waittill( "trigger", other );
	other braxi\_rank::giveRankXp( "kill", 10 );
	other iprintln ("^3You got 10xp!");
	other PlaySound ("ring");
	trig delete();
}
exp4()
{
	trig = getEnt( "xp4", "targetname");
	
	trig waittill( "trigger", other );
	other braxi\_rank::giveRankXp( "kill", 10 );
	other iprintln ("^3You got 10xp!");
	other PlaySound ("ring");
	trig delete();
}
exp6()
{
	trig = getEnt( "xp6", "targetname");
	
	trig waittill( "trigger", other );
	other braxi\_rank::giveRankXp( "kill", 10 );
	other iprintln ("^3You got 10xp!");
	other PlaySound ("ring");
	trig delete();
}
exp8()
{
	trig = getEnt( "xp8", "targetname");
	
	trig waittill( "trigger", other );
	other braxi\_rank::giveRankXp( "kill", 10 );
	other iprintln ("^3You got 10xp!");
	other PlaySound ("ring");
	trig delete();
}