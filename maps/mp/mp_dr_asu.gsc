// Map by Asu


main()
{
level.masterSpawn = spawn("script_origin", (-176,48,-52));
level.masterSpawn.angles = level.spawn["allies"][0].angles;
level.masterSpawn placeSpawnPoint();
 	maps\mp\_load::main();
 	maps\mp\mp_dr_asu_sound_fx::main();
 
 	game["allies"] = "marines";
 	game["axis"] = "opfor";
 	game["attackers"] = "axis";
 	game["defenders"] = "allies";
 	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("g_speed",190);
	setdvar("dr_jumpers_speed" ,"1");
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	level.asu_glow=(randomfloatrange(0.0, 1.0),randomfloatrange(0.0, 1.0),randomfloatrange(0.0, 1.0));
	level.noOld=false;

	thread way_connect();
	
	//thread automusic();
	thread startdoor();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	thread platforms();
	//thread trap6();
	//thread trap7();
	thread actitp();
	//thread trap8();
	//thread trap9();
	//thread endroom();
	thread secenter();
	thread secfail1();
	thread secfail2();
	thread secfail3();
	thread secfail4();
	thread secfail5();
	thread secfail6();
	thread secfail7();
	thread secfinish();
	thread secretd();
	thread sniper();
	thread knife();
	thread bouplat1();
	thread bouplat2();
	thread bounce();
	thread bounce_f();
	thread bouncer700();
	thread thankyou();
	thread old_room();
	thread logo1();
	thread logo2();
	thread logob();
	thread logok();
	thread logos();
	thread miniak();

	addtriggertolist("tirg_trap1");
	addtriggertolist("tirg_trap2");
	addtriggertolist("tirg_trap3");
	addtriggertolist("tirg_trap4");
	addtriggertolist("tirg_trap5");
	addtriggertolist("tirg_trap6");
	addtriggertolist("tirg_trap7");
	addtriggertolist("tirg_trap8");
	addtriggertolist("tirg_trap9");
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );
        
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

// Freerun Delete just in case for AFK Activator
addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}

automusic()
{
	level waittill("round_started");

	musicHud=newhudelem();
	musicHud.x=0;
	musicHud.y=30;
	musicHud.alignx="left";
	musicHud.aligny="middle";
	musicHud.horzalign="left";
	musicHud.vertalign="middle";
	musicHud.alpha=1;
	musicHud.fontscale=1.5;
	musicHud.glowalpha=1;
	musicHud.font="default";
	musicHud.glowcolor=level.asu_glow;

	switch(randomint(9))
	{
		case 0:
			ambientplay("music");
			musicHud.label=&"^0Music\nKrewella - Enjoy the Ride";
			break;
		case 1:
			ambientplay("music1");
			musicHud.label=&"^1Music\nLevianth & Axol - Remember";
			break;
		case 2:
			ambientplay("music2");
			musicHud.label=&"^2Music\nJim Yosef - Can't Wait";
			break;
		case 3:
			ambientplay("music3");
			musicHud.label=&"^3Music\nJanji - Heroes Tonight";
			break;
		case 4:
			ambientplay("music4");
			musicHud.label=&"^4Music\nSyn Cole - Feel Good";
			break;
		case 5:
			ambientplay("music5");
			musicHud.label=&"^5Music\nCash Cash - Take Me Home";
			break;
		case 6:
			ambientplay("music6");
			musicHud.label=&"^6Music\nAnthem Of The Lonely";
			break;
		case 7:
			ambientplay("music7");
			musicHud.label=&"^7Music\nKrewella- Say Goodbye";
			break;
		case 8:
			ambientplay("music8");
			musicHud.label=&"^8Music\nSeven Nation Army";
			break;
	}
	wait 10;

	musicHud fadeovertime(1);
	musicHud.alpha=0;

	if(isdefined(musicHud))
		musicHud destroy();
}

startdoor()
{	
	door=getent("sd","targetname");

	door delete();

}

trap1()
{
	trig=getent("tirg_trap1","targetname");
	pf1 = getent("trap1_1", "targetname");
	pf2 = getent("trap1_2", "targetname");
	pf3 = getent("trap1_3", "targetname");
	pf4 = getent("trap1_4", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();
	
	switch(randomint(4))
	{
		case 0:
			pf3 delete();
			pf4 delete();
			break;
		case 1:
			pf1 delete();
			pf2 delete();
			break;
		case 2:
			pf1 delete();
			pf3 delete();
			break;
		case 3:
			pf2 delete();
			pf4 delete();
			break;
	}
}

trap2()
{
	trig=getent("tirg_trap2","targetname");
	spin = getent("trap2", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();
	
	while(1)
	{
		spin rotateyaw (360, 2.5);
		wait 2.5;
		spin rotateyaw (-360, 2.5);
		wait 2.5;
	}
}

trap3()
{
	trig=getent("tirg_trap3","targetname");
	twoway = getent("trap3", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();

	twoway moveY (80, 1.5);
	wait 1.5;
	
	while(1)
	{
		twoway moveY (-160, 3);
		wait 3;
		twoway moveY (160, 3);
		wait 3;
	}
}

trap4()
{
	trig=getent("tirg_trap4","targetname");
	spike = getent("trap4", "targetname");
	bspike = getent("trap4_1", "targetname");
	spike_hurt = getent("trap4_hurt", "targetname");
	bspike_hurt = getent("trap4_1_hurt", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();

	spike_hurt enablelinkto();
	spike_hurt linkto (spike);
	bspike_hurt enablelinkto();
	bspike_hurt linkto (bspike);
	wait 0.1;
	spike moveZ (64, 5);
	wait 6;
	bspike moveZ (352, 1);

	wait 10;
	
	spike delete();
	bspike delete();
	spike_hurt delete();
	bspike_hurt delete();
}

trap5()
{
	trig=getent("tirg_trap5","targetname");
	bou = getent("trap5", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();
	
	while(1)
	{
		bou rotateyaw (-360, 4);
		wait 6;
		bou rotateroll (360, 4);
		wait 6;
	}
}

platforms()
{
	trig = getent("trig_plat", "targetname");
	plt = getent("plat", "targetname");
	plt2 = getent("plat2", "targetname");

	trig waittill("trigger");
	trig delete();

	wait 1;
	plt thread platf();
	plt2 thread platf2();
}

platf()
{
	while(isdefined(self))
	{
		self moveX (-1824, 2);
		wait 2;
		self rotateyaw (-180, 2);
		wait 2;
		self moveX (304, 1);
		wait 2;
		self moveZ (-240, 2);
		wait 2;
		self moveX (-304, 1);
		wait 1;
		self rotateyaw (180, 2);
		wait 2;
		self moveX (1824, 2);
		wait 2;
		self moveZ (240, 2);
		wait 2;
	}	
}

platf2()
{
	while(isdefined(self))
	{
		self moveX (-304, 1);
		wait 1;
		self rotateyaw (180, 2);
		wait 2;
		self moveX (1824, 6);
		wait 2;
		self moveZ (240, 2);
		wait 2;
		self moveX (-1824, 6);
		wait 2;
		self rotateyaw (-180, 2);
		wait 2;
		self moveX (304, 1);
		wait 2;
		self moveZ (-240, 2);
		wait 2;
	}
}

trap6()
{
	trig=getent("tirg_trap6","targetname");
	laser1 = getent("trap6_1", "targetname");
	laser2 = getent("trap6_2", "targetname");
	laser1_hurt = getent("trap6_1_hurt", "targetname");
	laser2_hurt = getent("trap6_2_hurt", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();

	laser1_hurt enablelinkto();
	laser1_hurt linkto (laser1);
	laser2_hurt enablelinkto();
	laser2_hurt linkto (laser2);

	while(1)
	{
		laser1 moveZ (-300, 5);
		wait 5.5;
		laser1 moveZ (300, 5);
		laser2 moveZ (-300, 5);
		wait 5.5;
		laser2 moveZ (300, 5);
	}
}

trap7()
{
	trig=getent("tirg_trap7","targetname");
	wall = getent("trap7", "targetname");
	wall_hurt = getent("trap7_hurt", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();
	
	wall_hurt enablelinkto();
	wall_hurt linkto (wall);
	wall moveZ (624, 2);
}

actitp()
{
	trig=getent("trig_actiport","targetname");
	targ=getent("actitp","targetname");

	trig waittill("trigger",who);
	trig delete();

	who setorigin(targ.origin);
	who setplayerangles(targ.angles);
}

trap8()
{
	trig=getent("tirg_trap8","targetname");
	ad1 = getent("trap8", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();
	
	x = Randomint(4);
	if( x == 0 )
	{
		while(1)
		{
			ad1 rotateroll (360, 3);
			wait 3;
			ad1 rotateroll (360, 3);
			wait 3;
		}
	}
	if( x == 1 )
	{
		while(1)
		{
			ad1 rotateroll (-360, 3);
			wait 3;
			ad1 rotateroll (-360, 3);
			wait 3;
		}
	}
	if( x == 2 )
	{
		while(1)
		{
			ad1 rotatepitch (360, 5);
			wait 5;
			ad1 rotatepitch (360, 5);
			wait 5;
		}
	}
	if( x == 3 )
	{
		while(1)
		{
			ad1 rotatepitch (-360, 5);
			wait 5;
			ad1 rotatepitch (-360, 5);
			wait 5;
		}
	}
}

trap9()
{
	trig=getent("tirg_trap9","targetname");
	pf1 = getent("trap9_pf_1", "targetname");
	pf2 = getent("trap9_pf_2", "targetname");
	pf3 = getent("trap9_pf_3", "targetname");
	pf4 = getent("trap9_pf_4", "targetname");
	pf0 = getent("trap9", "targetname");

	trig sethintstring("Press ^1&&1^7 to activate the trap.");
	trig waittill("trigger");
	trig delete();

	pf0 delete();
	
	pf2 moveZ (-176, 3);
	pf3 moveZ (-176, 3);
	wait 3.1;
	
	while(1)
	{
		pf1 moveX (480, 3);
		pf4 moveX (480, 3);
		pf2 moveX (-480, 3);
		pf3 moveX (-480, 3);
		pf2 rotateroll (-180, 3);
		pf3 rotateroll (180, 3);
		wait 3.1;
		pf1 moveZ (-176, 3);
		pf4 moveZ (-176, 3);
		pf2 moveZ (176, 3);
		pf3 moveZ (176, 3);
		wait 3.1;
		
		pf2 moveX (480, 3);
		pf3 moveX (480, 3);
		pf1 moveX (-480, 3);
		pf4 moveX (-480, 3);
		pf1 rotateroll (-180, 3);
		pf4 rotateroll (180, 3);
		wait 3.1;
		pf2 moveZ (-176, 3);
		pf3 moveZ (-176, 3);
		pf1 moveZ (176, 3);
		pf4 moveZ (176, 3);
		wait 3.1;
	}
}

endroom()
{
	trig=getent("trig_endroomtp","targetname");
	targ=getent("endroomtp2","targetname");

	while(1)
	{
		trig waittill("trigger",who);
		if(!isdefined(trig))
			return;

		who giveweapon("knife_mp");
		who switchtoweapon("knife_mp");
		who setorigin(targ.origin);
		who setplayerangles(targ.angles);

		while(isalive(who) && isdefined(who))
			wait 1;
	}
}

secenter()
{
	level.secenter_trigger = getEnt("trig_secenter", "targetname");
		telejumporigin = getEnt("secret_fail1", "targetname");

		while(1)
		{
		level.secenter_trigger waittill( "trigger", player );
		 player sr\api\_speedrun::changeWay("secret_0");
		//player thread secret_timer();
		
		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );
		
		}
}

secfail1()
{
	level.secfail1_trigger = getEnt("trig_secret_fail1", "targetname");
		telejumporigin = getEnt("secret_fail1", "targetname");

		while(1)
		{
		level.secfail1_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );
		
		}
}
secfail2()
{
	level.secfail2_trigger = getEnt("trig_secret_fail2", "targetname");
		telejumporigin = getEnt("secret_fail2", "targetname");

		while(1)
		{
		level.secfail2_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );
		
		}
}

secfail3()
{
	level.secfail3_trigger = getEnt("trig_secret_fail3", "targetname");
		telejumporigin = getEnt("secret_fail3", "targetname");

		while(1)
		{
		level.secfail3_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );
		
		}
}

secfail4()
{
	level.secfail4_trigger = getEnt("trig_secret_fail4", "targetname");
		telejumporigin = getEnt("secret_fail4", "targetname");

		while(1)
		{
		level.secfail4_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfail5()
{
	level.secfail5_trigger = getEnt("trig_secret_fail5", "targetname");
		telejumporigin = getEnt("secret_fail5", "targetname");

		while(1)
		{
		level.secfail5_trigger waittill( "trigger", player );


		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );
		
		}
}

secfail6()
{
	level.secfail6_trigger = getEnt("trig_secret_fail6", "targetname");
		telejumporigin = getEnt("secret_fail6", "targetname");

		while(1)
		{
		level.secfail6_trigger waittill( "trigger", player );

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );
		
		}
}

secfail7()
{
	level.secfail7_trigger = getEnt("trig_secret_fail7", "targetname");
		telejumporigin = getEnt("secret_fail7", "targetname");

		while(1)
		{
		level.secfail7_trigger waittill( "trigger", player );


		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );

		}
}

secfinish()
{
	level.secfinish_trigger = getEnt("trig_secfin", "targetname");
		telejumporigin = getEnt("secfin", "targetname");

		while(1)
		{
		level.secfinish_trigger waittill( "trigger", player );


		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );
		
		level.PlayerInRoom = false;

		}
}

secretd()
{
	secdoor = getent("secretdoor", "targetname");
	level.secretdoor_trigger = getent("trig_secretdoor", "targetname");
	step1 = getent("thx", "targetname");
		
		wait 1;
		secdoor delete();
		
}

sniper()
{
    level.sniper_trigger = getEnt( "trig_sniper", "targetname" );
    jump = getEnt( "sniper_jumper", "targetname" );
    acti = getEnt( "sniper_activator", "targetname" );
 
    for(;;)
	{
		level.sniper_trigger SetHintString("Press &&1 to enter the Sniper room.");
		level.sniper_trigger waittill("trigger",player);
		if(!isdefined(level.sniper_trigger))
			return;

		if(level.noOld==false)
		{
			level.noOld=true;
			level.old_room_trigger delete();
		}

		if(isdefined(level.activ) && isalive(level.activ))
		{
			player createRoom(jump.origin,jump.angles,"m40a3_mp","remington700_mp",100,1);
			level.activ createRoom(acti.origin,acti.angles,"m40a3_mp","remington700_mp",100,1);
		}
		else 
			player createRoom(jump.origin,jump.angles,"m40a3_mp","remington700_mp",100,1);

		iprintlnbold("^3"+player.name+"^6 has chosen the Sniper Room!");
		wait 4;

		player iPrintlnBold( "Fight!" );
        level.activ iPrintlnBold( "Fight!" );
        player freezecontrols(0);
        level.activ freezecontrols(0);
	}
}

knife()
{
    level.knife_trigger = getEnt( "trig_knife", "targetname" );
    jump = getEnt( "knife_jumper", "targetname" );
    acti = getEnt( "knife_activator", "targetname" );
 
    for(;;)
	{
		level.knife_trigger SetHintString("Press &&1 to enter the Knife room.");
		level.knife_trigger waittill("trigger",player);
		if(!isdefined(level.knife_trigger))
			return;

		if(level.noOld==false)
		{
			level.noOld=true;
			level.old_room_trigger delete();
		}

		if(isdefined(level.activ) && isalive(level.activ))
		{
			player createRoom(jump.origin,jump.angles,"knife_mp",undefined,100,1);
			level.activ createRoom(acti.origin,acti.angles,"knife_mp",undefined,100,1);
		}
		else 
			player createRoom(jump.origin,jump.angles,"knife_mp",undefined,100,1);

		iprintlnbold("^3"+player.name+"^6 has chosen the Knife Room!");
		wait 4;

		player iPrintlnBold( "Fight!" );
        level.activ iPrintlnBold( "Fight!" );
        player freezecontrols(0);
        level.activ freezecontrols(0);
	}
}

bouplat1()
{
	plat = getEnt( "brplatform1", "targetname" );
	level.bouplat1_trigger = getEnt( "trig_brplatform1", "targetname" );
	
	while(1)
	{
		level.bouplat1_trigger waittill( "trigger", player );
		wait 1;
		plat moveX (-1072, 1);
		level.bouplat1_trigger hide();
		wait 5;
		plat moveX (1072, 1);
		wait 1;
		level.bouplat1_trigger show();
		wait 0.1;
	}
}

bouplat2()
{
	plat = getEnt( "brplatform2", "targetname" );
	level.bouplat2_trigger = getEnt( "trig_brplatform2", "targetname" );
	
	while(1)
	{
		level.bouplat2_trigger waittill( "trigger", player );
		wait 1;
		plat moveX (1072, 1);
		level.bouplat2_trigger hide();
		wait 5;
		plat moveX (-1072, 1);
		wait 1;
		level.bouplat2_trigger show();
		wait 0.1;
	}
}

bounce()
{
    level.bounce_trigger = getEnt( "trig_bounce", "targetname" );
    jump = getEnt( "bounce_jumper", "targetname" );
    acti = getEnt( "bounce_activator", "targetname" );
 
    for(;;)
	{
		level.bounce_trigger SetHintString("Press &&1 to enter the Bounce room.");
		level.bounce_trigger waittill("trigger",player);
		if(!isdefined(level.bounce_trigger))
			return;

		if(level.noOld==false)
		{
			level.noOld=true;
			level.old_room_trigger delete();
		}

		if(isdefined(level.activ) && isalive(level.activ))
		{
			player createRoom(jump.origin,jump.angles,"knife_mp",undefined,100,1);
			level.activ createRoom(acti.origin,acti.angles,"knife_mp",undefined,100,1);
		}
		else 
			player createRoom(jump.origin,jump.angles,"knife_mp",undefined,100,1);

		iprintlnbold("^3"+player.name+"^6 has chosen the Bounce Room!");
		wait 4;

		player iPrintlnBold( "Fight!" );
        level.activ iPrintlnBold( "Fight!" );
        player freezecontrols(0);
        level.activ freezecontrols(0);
	}
}


miniak()
{
    level.miniak_trigger = getEnt( "trig_random_weapon", "targetname" );
    jump = getEnt( "sniper_jumper", "targetname" );
    acti = getEnt( "sniper_activator", "targetname" );
 
    for(;;)
	{
		level.miniak_trigger SetHintString("Press &&1 to enter the Ak74u room.");
		level.miniak_trigger waittill("trigger",player);
		if(!isdefined(level.miniak_trigger))
			return;

		if(level.noOld==false)
		{
			level.noOld=true;
			level.old_room_trigger delete();
		}

		if(isdefined(level.activ) && isalive(level.activ))
		{
			player createRoom(jump.origin,jump.angles,"ak74u_mp",undefined,100,1);
			level.activ createRoom(acti.origin,acti.angles,"ak74u_mp",undefined,100,1);
		}
		else 
			player createRoom(jump.origin,jump.angles,"ak74u_mp",undefined,100,1);

		iprintlnbold("^3"+player.name+"^6 has chosen the Ak74u Room!");
		wait 4;

		player iPrintlnBold( "Fight!" );
        level.activ iPrintlnBold( "Fight!" );
        player freezecontrols(0);
        level.activ freezecontrols(0);
	}
}

createRoom(origin,angles,weapon,weapon2,health,freeze)
{
	self setorigin(origin);
	self setplayerangles(angles);

	self takeallweapons();
	self giveweapon(weapon);
	self givemaxammo(weapon);
	self switchtoweapon(weapon);

	if(isdefined(weapon2))
	{
		self giveweapon(weapon2);
		self givemaxammo(weapon2);
	}

	self.health=health;
	self freezecontrols(freeze);
}

bounce_f()
{
    trig = getEnt( "bounce_fail", "targetname" ); //trigger 
    jump = getEnt( "bounce_jumper", "targetname" ); //jumper origin
    acti = getEnt( "bounce_activator", "targetname" ); //acti origin

    for(;;)
    {
    	trig waittill("trigger",player);
    	if(player.pers["team"]!="spectator")
    	{
    		if(player.pers["team"]=="allies")
    		{
    			player setplayerangles(jump.angles);
                player setorigin(jump.origin); 
    		}
    		else 
    		{
    			player setplayerangles(acti.angles);
                player setorigin(acti.origin); 
    		}
    	}
    }
}

bouncer700()
{
	trig=getent("bounceroom_sniper","targetname");
	for(;;)
	{
		trig sethintstring("^3>>^1Press &&1 to pickup the sniper.^3<<");
		trig waittill("trigger",who);
		who giveweapon( "remington700_mp" );
        who givemaxammo( "remington700_mp" );   
        who switchtoweapon( "remington700_mp" );
        iPrintLnBold( "^3"+who.name+" ^6has got a sniper!" );
        trig sethintstring("^3>>^1Loading^3<<");
        wait 3;
	}
}

thankyou()
{
	if(isdefined(level.topcredits))
        level.topcredits destroy();
 
    level.topcredits = newHudElem();
    level.topcredits.foreground = true;
    level.topcredits.alignX = "center";
    level.topcredits.alignY = "top";
    level.topcredits.horzAlign = "center";
    level.topcredits.vertAlign = "top";
    level.topcredits.x = 4;
    level.topcredits.y = 0;
    level.topcredits.sort = 0;
    level.topcredits.fontScale = 1.5;
    level.topcredits.glowColor = level.asu_glow;
    level.topcredits.glowAlpha = 1;
    level.topcredits.hidewheninmenu = true;

    while(1)
    {
    	level.topcredits setText("^6Map made by ^3VC' Asu");
    	level.topcredits fadeovertime(1);
    	wait 20;
    	level.topcredits setText("^6Thanks to every tester, and everyone who helped me!");
    	level.topcredits fadeovertime(1);
    	wait 20;
    	level.topcredits setText("^6Special thanks to ^3Legend ^6& ^3TheLixfe ^6for some scripts!");
    	level.topcredits fadeovertime(1);
    	wait 20;
    }
}

secret_timer()
{
self endon("secret1_done");
self endon("death");

if(isdefined(self.secretTimer))
self.secretTimer destroy();

self.secretTimer=newclienthudelem(self);
self.secretTimer.foreground = true;
self.secretTimer.alignX = "center";
self.secretTimer.alignY = "bottom";
self.secretTimer.horzAlign = "center";
self.secretTimer.vertAlign = "bottom";
self.secretTimer.x = 0;
self.secretTimer.y = -7;
self.secretTimer.sort = 5;
self.secretTimer.fontScale = 1.6;
self.secretTimer.font = "default";
self.secretTimer.glowAlpha = 1;
self.secretTimer.hidewheninmenu = true;
self.secretTimer.label = &"Time in left: &&1";
if(isdefined(level.randomcolor))
self.secretTimer.glowColor=level.randomcolor;
else 
self.secretTimer.glowColor=(1,0,0);

time=120;
for(i=0;i<time;i++)
{
self.secretTimer setvalue(time-i);
wait 1;
}
self.secretTimer setvalue(0);
self suicide();

if(isdefined(self.secretTimer))
wait 0.1;
self.secretTimer fadeovertime(0);
self.secretTimer = 0;
wait 0.1;
self.secretTimer destroy();
}

old_room()
{
    level.old_room_trigger = getEnt("trig_old", "targetname");
    jump = getEnt( "old", "targetname" );

    for(;;)
    {
    	level.old_room_trigger SetHintString("Press &&1 to enter the Old room.");
		level.old_room_trigger waittill("trigger",player);
		if(!isdefined(level.old_room_trigger))
			return;

		if(level.noOld==false)
		{
			level.noOld=true;
			level.sniper_trigger delete();
			level.knife_trigger delete();
			level.bounce_trigger delete();
			level.miniak_trigger delete();
		}

		player setorigin( jump.origin );
		player setplayerangles( jump.angles );
    }
}


logo1()
{
	logo1 = getent( "vc_logo_1", "targetname");
	
	while(1)
	{
		{
			logo1 rotateyaw (360, 15);
			logo1 moveZ (150, 15);
			wait 15.1;
			logo1 rotateyaw (360, 15);
			logo1 moveZ (-150, 15);
			wait 15.1;
		}
	}
}

logo2()
{
	logo2 = getent( "vc_logo_2", "targetname");
	
	while(1)
	{
		{
			logo2 rotateyaw (360, 15);
			logo2 moveZ (150, 15);
			wait 15.1;
			logo2 rotateyaw (360, 15);
			logo2 moveZ (-150, 15);
			wait 15.1;
		}
	}
}

logob()
{
	logob = getent( "vc_logo_b", "targetname");
	
	while(1)
	{
		{
			logob rotateyaw (360, 15);
			logob moveZ (150, 15);
			wait 15.1;
			logob rotateyaw (360, 15);
			logob moveZ (-150, 15);
			wait 15.1;
		}
	}
}

logok()
{
	logok = getent( "vc_logo_k", "targetname");
	
	while(1)
	{
		{
			logok rotateyaw (360, 15);
			logok moveZ (150, 15);
			wait 15.1;
			logok rotateyaw (360, 15);
			logok moveZ (-150, 15);
			wait 15.1;
		}
	}
}

logos()
{
	logos = getent( "vc_logo_s", "targetname");
	
	while(1)
	{
		{
			logos rotateyaw (360, 15);
			logos moveZ (150, 15);
			wait 15.1;
			logos rotateyaw (360, 15);
			logos moveZ (-150, 15);
			wait 15.1;
		}
	}
}
