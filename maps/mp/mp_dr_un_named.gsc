main()
{
	thread onConnect();
	thread way_connect();
	maps\mp\un_named\_teleport::main();
	
	// ambientPlay("ambient_mp_dr_un_named");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	// setdvar( "r_specular", "0" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 99999999 );
	setDvar("bg_falldamageminheight", 9999999 );
	
	//MAP
	// thread music();
	thread msg();
	thread rp();
	thread rp2();
	thread rp3();
	// thread message2();
	
	
	// addTriggerToList("e1t");
	// addTriggerToList("e2t");
	// addTriggerToList("e3t");
	// addTriggerToList("e4t");
	// addTriggerToList("e5t");
	// addTriggerToList("e6t");
	// addTriggerToList("e7t");
	// addTriggerToList("e8t");
	// addTriggerToList("e9t");
	
		
	
	//TRAPS
	// thread e1();
	// thread e2();
	// thread e3();
	// thread e4();
	// thread e5();
	// thread e6();
	// thread e7();
	// thread e8();
	// thread e9(); 
	
	//ROOMS
	// thread sniper();
	// thread bounce();
		// thread bend();
	// thread deagle();
	// thread old();
	// thread First();
	// thread games();
	
	//SECRET
	// thread secret1();
	// thread secret2();
	// thread creator();
	// thread wp1();
	// thread wp2();
	// thread wp3();
	// thread wp4();
	// thread wp5();
	// thread s1();
	// thread s2();
	// thread s3();
	
}

onConnect()
{	
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self.secret_1 = undefined;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
	thread sec_1();
	
    for(;;) 
    {
        level waittill( "connected", player );

    }
}

sec_1()
{
	trigger = spawn( "trigger_radius", (352.58, -1972.02, -428.447), 0, 260, 530 );
	
	for(;;)
	{
		trigger waittill("trigger",player);
		if(!isDefined(player.secret_1))
		{
			player.secret_1 = true;
			player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

s1()
{
	trig=getent("secret_enter", "targetname");
	ori=getent("secret_enter_ori", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		// iPrintLnBold("mdr");
	}
}

s2()
{
	trig=getent("secret_end", "targetname");
	ori=getent("secret_end_ori", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		player setOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player freezeControls(true);
		wait 2; 
		player freezeControls(false);
		iPrintLnBold(player.name + "^0 finished the secret !");
		player braxi\_rank::giveRankXP("", 500);
		wait 1;
	}
}

s3()
{
	
	trig=getent("secret_trig", "targetname");
	ori=getent("secret_brush", "targetname");
	
	
	trig waittill("trigger", player);
	player iPrintLnBold("This button is broken");
	ori notsolid();
	trig delete();
	wait 1;
	
}

creator()
{
me = "00000000194e9fda4e14a94efdb4fd52";
trig = getent("creator","targetname");
ori = getent ("creator_ori", "targetname");

while(1)
{
	trig SetHintString("creator only.");
	trig waittill ("trigger", user);
	guid = user getGUID();
	if(guid == me)
{
	user setOrigin(ori.origin);
	wait 1;
}
		else{
		user iPrintln("Access denied");
		wait 1;
		}
	
}
}

wp1()
{
	trig=getent("creator1", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		
		player GiveWeapon("m40a3_mp");
		player giveMaxAmmo( "m40a3_mp" ); 
		player SwitchToWeapon("m40a3_mp");
		wait 4;
	}
	
}

wp2()
{
	trig=getent("creator2", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		player GiveWeapon("deserteaglegold_mp");
		player giveMaxAmmo( "deserteaglegold_mp" ); 
		player SwitchToWeapon("deserteaglegold_mp");
		wait 4;
	}
	
}

wp3()
{
	trig=getent("creator3", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		player GiveWeapon("ak47_mp");
		player giveMaxAmmo( "ak47_mp" ); 
		player SwitchToWeapon("ak47_mp");
		wait 4;
	}
	
}

wp4()
{
	trig=getent("creator4", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		player GiveWeapon("rpg_mp");
		player giveMaxAmmo( "rpg_mp" ); 
		player SwitchToWeapon("rpg_mp");
		wait 4;
	}
	
}

wp5()
{
	trig=getent("creator5", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		player TakeAllWeapons();
		wait 1;
	}
}

message2()
{
	while(1)
	{
		iprintln( "^1Map by ^43xP' UnNamed" );
		wait 5;
		iprintln( "^7Textures and script by ^43xP' UnNamed" );
		wait 10;
		
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

music()
{
    wait 1;
	ambientPlay( "ille" );
	wait 1;
	
}

rp3()
{
	rp3b1=getent("rp3b1","targetname");
	rp3b2=getent("rp3b2","targetname");
	rp3b3=getent("rp3b3","targetname");
	rp3o1=getent("rp3o1","targetname");
	rp3o2=getent("rp3o2","targetname");
	rp3o3=getent("rp3o3","targetname");
	rp3o4=getent("rp3o4","targetname");
	rp3o5=getent("rp3o5","targetname");
	rp3o6=getent("rp3o6","targetname");
	rp3o7=getent("rp3o7","targetname");
	rp3o8=getent("rp3o8","targetname");
	rp3o9=getent("rp3o9","targetname");
	rp3o10=getent("rp3o10","targetname");
	rp3o11=getent("rp3o11","targetname");
	rp3o12=getent("rp3o12","targetname");
	rp3o13=getent("rp3o13","targetname");
	rp3o14=getent("rp3o14","targetname");
	rp3o15=getent("rp3o15","targetname");
	rp3o16=getent("rp3o16","targetname");
	
	
	rp3b1 delete();
	rp3b2 delete();
	rp3b3 delete();
}

rp2()
{
	rpb1=getent("rpb1","targetname");
	rpt1=getent("rpt1","targetname");
	// rpt1 waittill("trigger", player);
	rpt1 delete();

	trig = spawn("trigger_radius",(3680,-4390,-500),0,150,150);
	trig.radius = 150;

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "red");

	ori = spawn("script_origin",(4134,-4345,108));

	for(;;)
	{
		trig waittill("trigger",player);
		player setOrigin(ori.origin);
	}
}
rp()
{
	rp1=getent("rp1","targetname");
	rp2=getent("rp2","targetname");
	rp3=getent("rp3","targetname");
	rp4=getent("rp4","targetname");
	rp5=getent("rp5","targetname");
	rp6=getent("rp6","targetname");
	
	while(1)
	{
		rp1 rotateYaw(360,0.25);
		rp2 rotateYaw(360,0.25);
		rp3 rotateYaw(360,0.25);
		rp4 rotateYaw(360,0.25);
		rp5 rotateYaw(360,0.25);
		rp6 rotateYaw(360,0.25);
		wait 0.25;
		
	}
	
}

msg()
{
	d1=getent("d1","targetname");
	d2=getent("d2","targetname");
	d3=getent("d3","targetname");
	d4=getent("d4","targetname");
	d5=getent("d5","targetname");
	d6=getent("d6","targetname");
	d7=getent("d7","targetname");
	d8=getent("d8","targetname");
	wait 1;
	d1 moveX(144,1);
	wait 0.5;
	d2 moveX(-144,1);
	wait 0.5;
	d3 moveX(144,1);
	wait 0.5;
	d4 moveX(-144,1);
	wait 0.5;
	d5 moveX(144,1);
	wait 0.5;
	d6 moveX(-144,1);
	wait 0.5;
	d7 moveX(144,1);
	wait 0.5;
	d8 moveX(-144,1);
	wait 1;
}

e1()
{
	e1d=getent("e1d","targetname");
	e1b=getent("e1b","targetname");
	e1t=getent("e1t","targetname");
	e1d enablelinkto();
	e1d linkto(e1b);
	e1t SetHintString("^3[USE]");
	
	e1t waittill ("trigger",player);
	e1t delete();
	
	
	{
		e1b moveX(-256,1);
		wait 3;
		e1b moveX(256,1,0.2,0.2);
	}
	
}

e2()
{
	e2d=getent("e2d","targetname");
	e2b=getent("e2b","targetname");
	e2t=getent("e2t","targetname");
	e2d enablelinkto();
	e2d linkto(e2b);
	e2t SetHintString("^3[USE]");
	
	e2t waittill ("trigger",player);
	e2t delete();
	
	{
		e2b rotateYaw(1080,4,1,1);
		wait 4;
		e2b rotateYaw(-1080,4,1,1);
	}
	
}

e3()
{
	e3t=getent("e3t","targetname");
	e3b=getent("e3b","targetname");
	e3t SetHintString("^3[USE]");
	
	e3t waittill("trigger", player);
	e3t delete();
	
	{
		e3b moveZ(480,2);
		wait 2.5;
		e3b moveZ(-480,4,1,1);
	}
	
}

e4()
{
	e4t=getent("e4t","targetname");
	e4b=getent("e4b","targetname");
	e4t SetHintString("^3[USE]");
	
	e4t waittill("trigger", player);
	e4t delete();
	
	while(1)
	{
		e4b rotatePitch(360,4);
		wait 5;
	}
	
}

e5()
{
	e5t=getent("e5t","targetname");
	e5b11=getent("e5b11","targetname");
	e5b12=getent("e5b12","targetname");
	e5b13=getent("e5b13","targetname");
	e5b14=getent("e5b14","targetname");
	e5b21=getent("e5b21","targetname");
	e5b22=getent("e5b22","targetname");
	e5b23=getent("e5b23","targetname");
	e5b24=getent("e5b24","targetname");
	e5b31=getent("e5b31","targetname");
	e5b32=getent("e5b32","targetname");
	e5b33=getent("e5b33","targetname");
	e5b34=getent("e5b34","targetname");
	e5t SetHintString("^3[USE]");
	e5t waittill("trigger", player);
	e5t delete();
	
	{
		e5b11 moveX(416,0.5);
		e5b13 moveX(-416,0.5);
		wait 0.75;
		e5b12 moveX(416,0.5);
		e5b14 moveX(-416,0.5);
		wait 0.75;
		e5b21 moveX(416,0.5);
		e5b23 moveX(-416,0.5);
		wait 0.75;
		e5b22 moveX(416,0.5);
		e5b24 moveX(-416,0.5);
		wait 0.75;
		e5b31 moveX(416,0.5);
		e5b33 moveX(-416,0.5);
		wait 0.75;
		e5b32 moveX(416,0.5);
		e5b34 moveX(-416,0.5);
		wait 3;
		
		e5b11 moveX(-416,0.5);
		e5b13 moveX(416,0.5);
		wait 0.75;
		e5b12 moveX(-416,0.5);
		e5b14 moveX(416,0.5);
		wait 0.75;
		e5b21 moveX(-416,0.5);
		e5b23 moveX(416,0.5);
		wait 0.75;
		e5b22 moveX(-416,0.5);
		e5b24 moveX(416,0.5);
		wait 0.75;
		e5b31 moveX(-416,0.5);
		e5b33 moveX(416,0.5);
		wait 0.75;
		e5b32 moveX(-416,0.5);
		e5b34 moveX(416,0.5);
		wait 0.5;
	}
}

e6()
{
	e6t=getent("e6t","targetname");
	e6b1=getent("e6b1","targetname");
	e6b2=getent("e6b2","targetname");
	e6d=getent("e6d","targetname");
	e6d enablelinkto();
	e6d linkto(e6b2);
	e6t SetHintString("^3[USE]");
	
	e6t waittill("trigger", player);
	e6t delete();
	
	{
		e6b1 moveZ(304,2,0,1);
		wait 5;
		e6b2 moveZ(304,4,0,2);
		wait 6;
		e6b2 moveZ(-304,2,0,1);
		wait 3;
		e6b1 moveZ(-304,4,0,2);
		wait 4;
		
	}
	
}

e7()
{
	e7t=getent("e7t","targetname");
	e7b1=getent("e7b1","targetname");
	e7b2=getent("e7b2","targetname");
	e7t SetHintString("^3[USE]");
	e7t waittill("trigger", player);
	e7t delete();
	
	{
		e7b1 moveX(-160,2);
		e7b2 moveX(160,2);
		wait 4;
		e7b1 moveX(160,2);
		e7b2 moveX(-160,2);
	
	
	}
}

e8()
{
	
	e8t=getent("e8t","targetname");
	e8b=getent("e8b","targetname");
	e8t SetHintString("^3[USE]");
	e8t waittill("trigger", player);
	e8t delete();
	
	while(1)
	{
		e8b rotateYaw(360,3);
		wait 3;
	}
	
	
}

e9()
{
	e9d=getent("e9d","targetname");
	e9b=getent("e9b","targetname");
	e9t=getent("e9t","targetname");
	e9d enablelinkto();
	e9d linkto(e9b);
	e9t SetHintString("^3[USE]");
	
	e9t waittill ("trigger",player);
	e9t delete();
	
	
	{
		e9b moveX(272,0.75);
		wait 3;
		e9b moveX(-272,1,0.2,0.2);
	}
	
	
}

First()
{
	trig = getEnt ("end", "targetname");
	trig waittill("trigger", player);
	iPrintlnBold("^4" + player.name + " ^7Has Finished ^4First");
	player braxi\_rank::giveRankXP("", 100);
	trig delete();
}

games()
{
	trig = getEnt("games", "targetname");
	ori = getEnt ("minigames", "targetname");
	while (1)
	{
		trig waittill("trigger", player);
		iPrintlnBold("^4" + player.name + " ^7selects the room");
		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player Death();
		wait 0.1;
	}
}

Death()
{
        self endon("disconnect");
        self waittill("death");
		iprintlnbold("^4" + self.name + "^7 Rip");
}

GetActivator()
{
	players = getentarray( "player", "classname" );
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}
	
	return "Noactivator";
}

sniper()
{
        trig = getEnt( "sniper_trig", "targetname"); 
		old_trig = getEnt( "old_trig", "targetname");
		
        jumper = getEnt( "sniper1", "targetname" );
        acti = getEnt( "sniper2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		old_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the sniper room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player GiveWeapon("m40a3_mp");
		player GiveMaxAmmo("m40a3_mp");
		player SwitchToWeapon("m40a3_mp");
		activator = GetActivator();
		
		
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
			activator GiveWeapon( "m40a3_mp" ); 
			activator giveMaxAmmo( "m40a3_mp" ); 
			activator GiveWeapon( "remington700_mp" );
			activator giveMaxAmmo( "remington700_mp" );
            activator SwitchToWeapon( "m40a3_mp" );
         
		
	}
}

old()
{
        sniper_trig = getEnt( "sniper_trig", "targetname");
		trig = getEnt( "old_trig", "targetname");
		bounce_trig = getEnt( "bounce_trig", "targetname");
		deagle_trig = getEnt( "deagle_trig", "targetname");
		
		
        jumper = getEnt( "old1", "targetname" );
        acti = getEnt( "old2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		sniper_trig delete();
		bounce_trig delete();
		deagle_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the old room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		activator = GetActivator();
		
		
		
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			
         
		
	}
}

bounce()
{
        trig = getEnt( "bounce_trig", "targetname"); 
		old_trig = getEnt( "old_trig", "targetname");
		
        jumper = getEnt( "bounce1", "targetname" );
        acti = getEnt( "bounce2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		old_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the bounce room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
        player GiveWeapon( "knife_mp" ); 
        player GiveWeapon( "deserteagle_mp" );
		player SetWeaponAmmoClip("deserteagle_mp", 0);
        player SetWeaponAmmoStock("deserteagle_mp", 0);
        player switchToWeapon( "deserteagle_mp" ); 
		activator = GetActivator();
		
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
		    activator GiveWeapon( "knife_mp" ); 
			activator GiveWeapon( "deserteagle_mp" );
			activator SetWeaponAmmoClip("deserteagle_mp", 0);
			activator SetWeaponAmmoStock("deserteagle_mp", 0);
			activator switchToWeapon( "deserteagle_mp" ); 
         
		}
}


deagle()
{
        trig = getEnt( "deagle_trig", "targetname"); 
		old_trig = getEnt( "old_trig", "targetname");
		
        jumper = getEnt( "deagle1", "targetname" );
        acti = getEnt( "deagle2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		old_trig delete();
		iprintlnbold("^4" + player.name + "^7 entered the deagle room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
        player GiveWeapon( "knife_mp" ); 
        player GiveWeapon( "deserteagle_mp" );
		player SetWeaponAmmoClip("deserteagle_mp", 0);
        player SetWeaponAmmoStock("deserteagle_mp", 0);
        player switchToWeapon( "deserteagle_mp" ); 
		activator = GetActivator();
		
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
		    activator GiveWeapon( "knife_mp" ); 
			activator GiveWeapon( "deserteagle_mp" );
			activator SetWeaponAmmoClip("deserteagle_mp", 0);
			activator SetWeaponAmmoStock("deserteagle_mp", 0);
			activator switchToWeapon( "deserteagle_mp" ); 
         
		
	}
}



bend()
{
	trig=getent("give_sniper", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		player TakeAllWeapons(); 
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player GiveWeapon("m40a3_mp");
		player GiveMaxAmmo("m40a3_mp");
		player SwitchToWeapon("m40a3_mp");
		wait 5;
	}
	

}
