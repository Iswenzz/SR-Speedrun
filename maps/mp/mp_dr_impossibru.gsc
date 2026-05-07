main()
{
	maps\mp\_load::main(); 
	//ambientPlay("map");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	level.bjump1 = getEnt( "gohere4", "targetname" );
	level.bacti1 = getEnt( "activator4", "targetname" );

	thread sr\api\_map::createSpawn((285, -1757, 1116), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((25.7193, -2858.25, 144.125), 185,120, "normal_0");
    
	thread custom_secret_enter();
	thread custom_secret_finish();

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	thread trap1();         
	thread trap2();
	thread trap3();
	thread trap3a();                
	thread trap4();                  //works but gives an error at the end if I put developer 1 
	//thread sniper();
	//thread knife();
	//thread gun();
	//thread spam();
	//thread cylinder();              
	//thread secret();               
	//thread playerJoined();
	//thread trap3a_trig();
	//thread prank();
	//thread update();
	//thread trapdoor();
	//thread bounce();
	//thread bounce_respawn();
	//thread bounce_ob();

	addTriggerToList( "trap1_trig" );
	addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
	addTriggerToList( "trap3b_trig" );
	addTriggerToList( "trap4_trig" );
	addTriggerToList( "trap3a_trig" );

}
custom_secret_enter()
{
	trig = spawn("trigger_radius",(83.6357, -1752.08, 1056.12), 0, 60, 120);
	trig.radius = 60;
	
	ori_t = spawn("script_origin",(-998,2990,92));
	ori_t.angles = (0,90,0);

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
custom_secret_finish()
{
   trig = getent("secret", "targetname");

   for(;;)
    {  
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_0");
    }
}
addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
 
trap1()                        
{
	trigger = getent("trap1_trig", "targetname");
	object = getent("trap1a", "targetname");
	object2 = getent("trap1b", "targetname");
	object3 = getent("trap1c", "targetname");
	object4 = getent("trap1d", "targetname");
	trigger setHintString("^1Spin");

	trigger waittill( "trigger", player );

}

trap2()
{
	trigger = getEnt("trap2_trig", "targetname");
	object = getEnt("trap2", "targetname");
	trigger setHintString("^2Hide Blocks");
	trigger waittill("trigger", who );
	
}

trap3()
{
	trigger = getent("trap3_trig", "targetname");
	object = getent("trap3", "targetname");
	trigger setHintString("^3Rotate Circles");
	trigger waittill ("trigger" , player );
	
}

trap3a()
{
	trigger = getent("trap3b_trig","targetname");
	object = getent("trap3a","targetname");
	trigger setHintString("^4No Short Cuts!!!");
	trigger waittill ("trigger" , player );
	
}

trap4()
{
	trigger = getent("trap4_trig", "targetname");
	object = getent("trap4", "targetname");
	killtrigger = getent ("killtrig4" , "targetname");

	killtrigger enablelinkto ();
	killtrigger linkto (object);

	trigger setHintString("^5Spikes");
	trigger waittill ("trigger" , player );
	
}

sniper()  
{
	level.snip_trig = getEnt( "enter", "targetname");
	jump = getEnt( "gohere", "targetname" );
	acti = getEnt( "activator", "targetname" );
	
	while( isDefined( level.snip_trig ) )
	{
		level.snip_trig waittill( "trigger", player );
		if( !isDefined( level.snip_trig ) )
			return;
		
		level.bounce_trig delete();
		level.gun_trig delete();
		level.knife_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "m40a3_mp" ); 
		player setSpawnWeapon( "m40a3_mp" );
		if( isDefined( level.activ ) && isAlive( level.activ ) )
		{
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon( "m40a3_mp" );
			level.activ SetSpawnWeapon( "m40a3_mp" );
		}
		iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN Sniper^1!" );
		while( isDefined( player ) && isAlive( player ) )
			wait 1;
	}
}

knife()     
{
	level.knife_trig = getEnt( "enter2", "targetname");
	jump = getEnt( "gohere2", "targetname" );
	acti = getEnt( "activator2", "targetname" );
	
	while( isDefined( level.knife_trig ) )
	{
		level.knife_trig waittill( "trigger", player );
		if( !isDefined( level.knife_trig ) )
			return;
		
		level.snip_trig delete();
		level.gun_trig delete();
		level.bounce_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" ); 
		player setSpawnWeapon( "tomahawk_mp" );

		if( isDefined( level.activ ) && isAlive( level.activ ) )
		{
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon( "tomahawk_mp" );
			level.activ SetSpawnWeapon( "tomahawk_mp" );
		}
		iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN Knife^1!" );
		while( isDefined( player ) && isAlive( player ) )
			wait 0.05;

	}
}

gun()       
{
	level.gun_trig = getEnt( "enter3", "targetname");
	jump = getEnt( "gohere3", "targetname" );
	acti = getEnt( "activator3", "targetname" );
	
	while( isDefined( level.gun_trig ) )
	{
		level.gun_trig waittill( "trigger", player );
		if( !isDefined( level.gun_trig ) )
			return;
		
		level.snip_trig delete();
		level.knife_trig delete();
		level.bounce_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "defaultweapon_mp" );
		player setSpawnWeapon( "defaultweapon_mp" );


		if( isDefined( level.activ ) && isAlive( level.activ ) )
		{
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon( "defaultweapon_mp" );
			
			level.activ SetSpawnWeapon( "defaultweapon_mp" );
		}
		iPrintlnBold( "^6" + player.name + " ^5 HAS CHOSEN Weapon^1!" );
		while( isDefined( player ) && isAlive( player ) )
			wait 0.05;
	}
}

spam()
{
	for(;;)
	{
		wait 10;
		iprintln ("^7Map created by ^5IceOps|Delta ^1& ^5mks!");
		wait 10;
		iprintln ("^7Mega Thanks ^3IceOps|Ninja & ^5IceOps|TheKelm & ^7Frosty &^8Phaedrean ");         
		wait 10;
		iprintln ("^1 Report bugs xfire: dragonflam4 , steam:xray190");
		wait 10;
		iprintln ("^3 Thanks for Xenon and Lossy Tutorials");
	}
}

cylinder()       
{
	wait 10;
	object = getent("autotrap", "targetname");
	killtrigger = getent ("killtrigauto" , "targetname");
	wait 0.01;
	killtrigger enablelinkto ();  
	killtrigger linkto (object);
	object movez(-1008, 3);
	object rotateroll(-360,3);
	object waittill("movedone");
	wait 0.01;
	iPrintlnBold( "^1Run!!!" ); 
	wait 0.01;
	object movey(5075,25);
	object rotateroll(-1440,25);
	object waittill ("movedone");
	object movez(-1024,3);
	object rotateroll(-360,3);
	object waittill ("movedone");
}

secret()
{
	trig = getEnt ("secret", "targetname");
	target = getEnt ("secret2", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		
		player iprintlnbold("You have been teleported");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

playerJoined()
{
	for(;;) 
	{
		level waittill("connected",player);
		if(!isDefined(player.pers["welcomed"]))
		{
			player.pers["welcomed"] = true;
			iPrintlnBold( "Welcome ^2" + player.name + " ^7to the server everyone!!" ); 
		}
	}
}

trap3a_trig()
{
	trig = getEnt ("trap3a_trig", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		trig delete();
		
		player iprintlnbold ("^1No easy way :/");
	}
}

prank()
{
	trig = getEnt ("prank", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		trig delete();
		
		player iprintlnbold ("^9You thought something was here :P");
	}
}

update()
{
	trig = getEnt ("update", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		trig delete();
		
		player iprintlnbold ("^0More if version 2 is released");
	}
}

trapdoor()
{
	object = getEnt ("trapdoor", "targetname");
	trigger = getEnt ("trapdoor_trig", "targetname");
	trigger waittill ("trigger" , player );
	trigger delete();
	wait 0.01;
	iPrintlnBold("^1Hurry the door is closing!!!!");
	object movey(112,12);
	object waittill("movedone");
	wait 0.01;
	iPrintlnBold("^2Door closed :/");
	wait 5;
	object movey(-112,5);
	object waittill("movedone");
	wait 0.01;
	iPrintlnBold("^3Door opened!!!");
}

bounce()
{
	level.bounce_trig = getEnt( "enter4", "targetname");
	jump = getEnt( "gohere4", "targetname" );
	acti = getEnt( "activator4", "targetname" );
	
	while( isDefined( level.bounce_trig ) )
	{
		level.bounce_trig waittill( "trigger", player );
		if( !isDefined( level.bounce_trig ) )
			return;
		
		level.snip_trig delete();
		level.gun_trig delete();
		level.knife_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" );
		player setSpawnWeapon( "tomahawk_mp" );
		if( isDefined( level.activ ) && isAlive( level.activ ) )
		{
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon( "tomahawk_mp" );
			level.activ SetSpawnWeapon( "tomahawk_mp" );
		}
		iPrintlnBold( "^6" + player.name + " ^5 HAS CHOSEN Bounce^1!" );

		while( isDefined( player ) && isAlive( player ) )
			wait 1;
	}
}

bounce_respawn(port_allies,port_axis)
{
 	trig = getent("bounce", "targetname");

	for(;;)
	{
		trig waittill( "trigger", player );
		if(player.pers["team"] == "axis")
		{
			player setPlayerangles( level.bacti1.angles );
			player setOrigin( level.bacti1.origin );
		}
		if(player.pers["team"] == "allies")
		{
			player setplayerangles( level.bjump1.angles, 3 );
			player setorigin( level.bjump1.origin, 3 );
		}
	}
}

bounce_ob()
{
	object1 = getEnt ("br1", "targetname");
	object2 = getEnt ("br2", "targetname");
	killtrigger1 = getEnt ("bo1", "targetname");
	killtrigger2 = getEnt ("bo2", "targetname");

	killtrigger1 enablelinkto();
	killtrigger1 linkto (object1);
	killtrigger2 enablelinkto();
	killtrigger2 linkto (object2);

	while(1)
	{
		object1 movey(1056,3);
		object1 waittill("movedone");
		wait(1);
		object2 movey(-1056,3);
		object2 waittill("movedone");
		wait(1);
		object1 movey(-1056,3);
		object1 waittill("movedone");
		wait(1);
		object2 movey(1056,3);
		object2 waittill("movedone");
	}
}