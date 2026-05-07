main()
{
	maps\mp\_load::main();
	//maps\mp\_explosive_barrels::main();
	 
	//precacheItem("deserteagle_mp"); // just to be sure.. 
 //precacheItem("rpg_mp");

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((38, -253, 12), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread trap_adjustments();
	thread custom_tp();
	
				addTriggerToList( "trap1_trig" );
				addTriggerToList( "trap2_trig" );
				addTriggerToList( "trap3_trig" );
				addTriggerToList( "trap5_trig" );
				addTriggerToList( "trap6_trig" );
				addTriggerToList( "trap7_trigger" );
				addTriggerToList( "trap9_trigger" );
				addTriggerToList( "trap10_trig" );
				addTriggerToList( "trap11_a_trig" );
				addTriggerToList( "trap11_b_trig" );
				addTriggerToList( "trap11_c_trig" );
				addTriggerToList( "trap12_trig" );
				addTriggerToList( "trap13_trig" );
	
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread teleporthouse();
	//thread teleporthouseacti();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap10();
	//thread new();
	//thread xpsecret();
	//thread welcomebos();
	//thread welcomehea();
	//thread minefields();
	//thread teleportacti();
	//thread teleportacti2();
	//thread teleportacti4();
	thread teleport5();
	thread teleport6();
	thread trap11a();
	thread trap11b();
	thread trap11c();
	thread trap12();
	thread trap13();
	//thread jumper();
	//thread jumper2();
	//thread pay()
	//thread firee();
	//thread initMusic();
	//thread musictrig();
	thread trap9();
	//thread sniper();
	//thread knife();
	//thread secret();
	//thread old();
	//thread weapon();
	//thread rpg();
	//thread topbar();
	//thread infospam();
	//thread end();
	//thread ammo();
	//thread ammosniper();
	//thread ammodesert();
	//thread addTestClients();
	//level.fire = LoadFX("boss/fx2");
	
	precache();

	/*venders = getentarray("heal","targetname");
	for(i=0;i<venders.size;i++)
	venders[i] thread vender();*/

}
trap_adjustments()
{
	brush_1 = getentarray("mine","targetname");
	for(i=0;i<brush_1.size;i++)
	brush_1[i] delete();		

}
custom_tp()
{
	trig = spawn("trigger_radius",(7880.72, 2559.78, -1.07662), 0, 100, 120);
	trig.radius = 100;
	
	ori_t = spawn("script_origin",(23824,2559,-36));
	ori_t.angles = (0,0,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

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
precache()
{
	if(getDvar(getDvar("mapname") + "_allow_vender") == "")
		setDvar(getDvar("mapname") + "_allow_vender", 1); // This creates the dvar to enable the vending machines

	if(getDvar(getDvar("mapname") + "_health_wait") == "")
		setDvar(getDvar("mapname") + "_health_wait", 10); // This creates the dvar to set the time between being able to get health again

	level.allow_vender = int(getDvar(getDvar("mapname") + "_allow_vender"));
	level.vender_wait = int(getDvar(getDvar("mapname") + "_health_wait"));

	for(i=1;i<5;i++)
		precacheModel("com_bottle1"); // Precache (load) the com_bottle1, com_bottle2, com_bottle3 and com_bottle4 models

	level.venderbottles = [];
	level.venderbottlescurrent = 0;
	level.venderbottlesmax = 24; // Max bottles in the map at one time, try not to have this too high as it can cause lag and somtimes crash the server
}
	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
} 

vender()
{
	self.targetname = undefined;
	dir = getent(self.target,"targetname");
	if(isDefined(dir))
	{
		temp = spawnStruct();
		temp.origin = dir.origin;
		temp.angles = dir.angles; // Spawn a struct which doesnt count as an entity, record the script_origin's origin and angles then delete the script_origin
		dir delete();
		dir = temp;
	}
	self.target = undefined;

	randomMessages = []; // List of random messages when player has had a bottle recently, you can have as many of them as you want.
	randomMessages[0] = "^9You Can't have more!!!";
	randomMessages[1] = "^1Careful! You'll break it!";
	randomMessages[2] = "^3Call Headdy or BosnianArmy for more!!!";
	randomMessages[3] = "^4You're hungry ain't ya?";
	randomMessages[4] = "^7Fuck Yea";

	//self playLoopSound("vender"); // Make the trigger play a loop sound

	for(;;)
	{
		self waittill("trigger", player); // Wait until its triggered
		if(player.sessionstate != "playing")// Make sure the player is playing
			continue;

		if(!level.allow_vender)// If vending machines are not allowed then say a message
		{
			player iPrintlnBold("^2Defect");
			continue;
		}

		if(isDefined(dir))// If the script_origin is placed correctly in the map, then make a bottle pop out
		{
			//self playSound("vender_drop");// Play the bottle drop sound

			if(isDefined(level.venderbottles[level.venderbottlescurrent]))
				level.venderbottles[level.venderbottlescurrent] delete();// If we have gone over the limit for max bottle in the map, delete the oldest one

			level.venderbottles[level.venderbottlescurrent] = spawn("script_model",self.origin);// Spawn the bottle
			level.venderbottles[level.venderbottlescurrent].angles = dir.angles; // Set the angles of the bottle
			level.venderbottles[level.venderbottlescurrent] setModel("com_bottle1");    // Set random bottle model
			point = dir.origin;
			origin = level.venderbottles[level.venderbottlescurrent].origin + maps\mp\_utility::vector_Scale(anglestoup(level.venderbottles[level.venderbottlescurrent].angles),4 + randomFloat(1));
			velocity = VectorNormalize(origin - point);// Calculate velocity and direction of the impact
			velocity = maps\mp\_utility::vector_Scale(velocity,10000 + randomInt(5000));
			level.venderbottles[level.venderbottlescurrent] physicsLaunch(point, velocity);            // Make the bottle fly!

			level.venderbottlescurrent++;

			if(level.venderbottlescurrent >= level.venderbottlesmax)
				level.venderbottlescurrent = 0;
		}

		if(isDefined(player.healthwait))// If the player has already used the vending machine then...
		{
			player iPrintlnBold(randomMessages[randomInt(randomMessages.size)]); // display one of the rather insulting messages to the player. LOL
			continue;
		}

		player.healthwait = true;
		if(player.health < player.maxhealth)// If the players health is not at the max
		{
			player.health = player.maxhealth;// Set the players health to the max
			player iPrintlnBold("^2mmm... ^1y^2u^3m^4m^5y^6!");// Say these messages if the player was healed
			player iPrintlnBold("^1Health Restored!");
		}
		else
			player iPrintlnBold("^2You already have full health, but ^1y^2u^3m^4m^5y^6! ^2anyway!"); // If the player already has full health then say this message
		player thread healthwait();
	}
}

healthwait()
{
	self endon("disconnect"); // Kill the thread if the player disconnects
	wait level.vender_wait; // Wait how long level.vender_wait is
	self.healthwait = undefined; // Make self.healthwait undefined
}

trap1()
{	
trig = getEnt ("trap1_trig", "targetname");	
hurt = getEnt ("trap1_hurt", "targetname");	
trap1 = getEnt ("trap1", "targetname");
troll = getEnt ("troll", "targetname");

trap1 delete();
hurt delete();
}


trap2()
{	
trig = getEnt ("trap2_trig", "targetname");
hurt = getEnt ("trap2_hurt", "targetname"); 
trap2 = getEnt ("trap2", "targetname");
troll = getEnt ("trolla", "targetname");

	troll hide();
    trig waittill("trigger");

}
jumper()
{
	jumpx = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");

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
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}
jumper2()
{
	jumpx = getent ("jump1","targetname");
	glow = getent ("glow1","targetname");
	air1 = getent ("air11","targetname");
	air2 = getent ("air22","targetname");
	air3 = getent ("air33","targetname");
	air4 = getent ("air44","targetname");

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
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

trap3()
{	
trig = getEnt ("trap3_trig", "targetname");
hurt = getEnt ("trap3_hurt", "targetname"); 
trap3 = getEnt ("trap3", "targetname");
troll = getEnt ("trollb", "targetname");


	troll hide();
    trig waittill("trigger");

}
trap4()
{
trig = getEnt ("trap4_trig", "targetname");
trap4 = getEnt ("trap4", "targetname");
troll = getEnt ("trollc", "targetname");


	troll hide();
    trig waittill("trigger");

}
teleporthouse()
{
	trig = getent("teleport1", "targetname");
	spawn = getent("teleportspot1", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(spawn.origin);
		player SetPlayerAngles(spawn.angles);
		player freeze_on_tps(0.1);
	}
}

teleporthouseacti()
{
	trig = getent("teleportacti1", "targetname");
	spawn = getent("teleportspot1acti", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(spawn.origin);
		player SetPlayerAngles(spawn.angles);
		player freeze_on_tps(0.1);
	}
}

teleportacti()
{
	trig = getent("actiteleport3", "targetname");
	spawn = getent("spot3", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles ( spawn.angles );
		player SetOrigin ( spawn.origin );
		wait (0.05);
		player iPrintLnBold("^2 Teleported!");
	}
}

teleportacti2()
{
	trig = getent("actiteleport22", "targetname");
	spawn = getent("spot2", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles ( spawn.angles );
		player SetOrigin ( spawn.origin );
		wait (0.05);
		player iPrintLnBold("^2 Teleported!");
	}
}

teleportacti4()
{
	trig = getent("actiteleport4", "targetname");
	spawn = getent("spot4", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player SetPlayerAngles ( spawn.angles );
		player SetOrigin ( spawn.origin );
		wait (0.05);
		player iPrintLnBold("^2 Teleported!");
	}
}
teleport5()
{
	trig = getent("teleport5", "targetname");
	spawn = getent("spot5", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(spawn.origin);
		player SetPlayerAngles(spawn.angles);
		player freeze_on_tps(0.1);
	}
}
teleport6()
{
	trig = getent("teleport61", "targetname");
	spawn = getent("spot6", "targetname");
	

	for(;;)
	{
		trig waittill("trigger", player);
		player SetOrigin(spawn.origin);
		player SetPlayerAngles(spawn.angles);
		player freeze_on_tps(0.1);
	}
}
secret()
{
trig = getEnt ("secret", "targetname");
secret = getEnt ("block", "targetname");

    trig waittill("trigger", player);

	{
	secret moveZ(-272,6);
	iPrintLnBold("^1What! ^5"+ player.name + " has opened the secret minigame!");
	secret waittill("movedone");
	wait 2;
	secret moveZ(272,2);
	}
}

trap5()
{
trig = getEnt ("trap5_trig", "targetname");
trap5 = getEnt ("trap5", "targetname");
hurt = getEnt ("trap5_hurt", "targetname");
troll = getEnt ("trolld", "targetname");


	troll hide();
    trig waittill("trigger", player);
	iprintLn ("Trigger Is Used!");
	troll show();
	trig delete();

	hurt enablelinkto();
	hurt linkto (trap5);

	{
	iPrintLnBold("^1Oh no! ^5"+ player.name + " has used the Team-Mate-Troll trap!");
	trap5 moveZ(-292,2);
	trap5 waittill("movedone");
	wait 2;
	trap5 moveZ(292,5);
	trap5 waittill("movedone");
	}
}

// b x -568
trap6()
{
trig = getEnt ("trap6_trig", "targetname");
trap6 = getEnt ("trap6b", "targetname");
troll = getEnt ("trolle", "targetname");
door = getEnt ("deur", "targetname");
doora = getEnt ("deura", "targetname");

	troll hide();
	door hide();
	door notSolid();
    trig waittill("trigger");

}
trap7()
{	
trig = getEnt ("trap7_trigger", "targetname");
hurt = getEnt ("spikes_hurt", "targetname"); 
trap7 = getEnt ("spike", "targetname");
troll = getEnt ("trollf", "targetname");

	troll hide();
    trig waittill("trigger");

}
trap9() // Don't acti this together with spike, they will get into eachother :P
{	
trig = getEnt ("trap9_trigger", "targetname");
hurt = getEnt ("trap9_hurt", "targetname"); 
trap9 = getEnt ("trap99", "targetname");
troll = getEnt ("trollg", "targetname");

	troll hide();
    trig waittill("trigger");

}
trap10()
{
    trig = getEnt("trap10_trig","targetname");
	troll = getEnt("trollh","targetname");
	trap10 = getEnt("trap10","targetname");
	
	troll hide();
    trig waittill ("trigger");

}
trap11a()
{
    trig = getEnt("trap11_a_trig","targetname");
	troll = getEnt("trolli","targetname");
	trap10 = getEnt("trap11_a","targetname");
	
	troll hide();
    trig waittill ("trigger");

}
trap11b()
{
    trig = getEnt("trap11_b_trig","targetname");
	troll = getEnt("trollj","targetname");
	trap10 = getEnt("trap11_b","targetname");
	
	troll hide();
    trig waittill ("trigger");

}
trap11c()
{
    trig = getEnt("trap11_c_trig","targetname");
	troll = getEnt("trollk","targetname");
	trap10 = getEnt("trap11_c","targetname");
	
	troll hide();
    trig waittill ("trigger");
	
}
trap12() // -62, 27
{
    trig = getEnt("trap12_trig","targetname");
	troll = getEnt("trolll","targetname");
	trap12 = getEnt("trap12","targetname");
	
	troll hide();
    trig waittill ("trigger");

}
trap13()
{
    trig = getEnt("trap13_trig","targetname");
	troll = getEnt("trollm","targetname");
	trap13 = getEnt("trap13_a","targetname");
	trap13b = getEnt("trap13_b","targetname");
	hurt = getEnt("trap13_hurt","targetname");
	hurt2 = getEnt("trap13_hurt2","targetname");
	
	hurt enablelinkto();
	hurt linkto (trap13);
	hurt2 enablelinkto();
	hurt2 linkto (trap13b);
	
	troll hide();
    trig waittill ("trigger");

}
firee()
{ 
    f1 = getent ("fx1" ,"targetname");
	f2 = getent ("fx2" ,"targetname");
	
   playLoopedFx(level.fire, 1, f1.origin);	
   playLoopedFx(level.fire, 1, f2.origin);	

}
xpsecret()
{
	trig = getent("kill", "targetname");

	while (1)
	{
		trig waittill("trigger", player);
		player iPrintLnBold("^3Wait 5 seconds, the computer is getting your xp!");
		wait 5;
		player iPrintLnBold("^1Bosnian ^2& ^1Headdy are ^9Like A Boss.");
		player iPrintLnBold("^2XP is for noobs, go earn xp yourself.");
		player suicide();
		player iPrintLnbold("^5You ^1got ^2trolled, ^3bitch");
	}
}

new()
{
        trig = getEnt("new_trigger","targetname");

		trig waittill("trigger",player);
        trig delete();
          {
				wait 1;
        hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 5;
	hud_clock.glowcolor = (9,9,9);
	hud_clock.label = &"^9Special Thanks to ERIK";
                   hud_clock SetPulseFX( 40, 5400, 200 );
                   wait 3;
    player TakeAllWeapons();
    player GiveWeapon( "remington700_mp" );
    player switchToWeapon( "remington700_mp" ); 
}
}

minefields()
{
	minefields = getentarray("mine", "targetname");
	
	for(i = 0; i < minefields.size; i++)
	{
		minefields[i] hide();
	}	
}

minefield_think()
{
	while (1)
	{
		self waittill ("trigger",other);
		
		if(isPlayer(other))
			other thread minefield_kill(self);
	}
}

minefield_kill(trigger)
{
	if(isDefined(self.minefield))
		return;
		
	self.minefield = true;
	self playsound ("click_m"); //ahh it usly says missing soundaliases

	wait(.01);
	wait(randomFloat(.01));//did you ad wait? no, I want to

	if(isdefined(self) && self istouching(trigger))
	{
		origin = self getorigin();
		range = 100;
		maxdamage = 2000;
		mindamage = 50;
        wait 0.1;
		self playsound("mine_explo");
		playfx(level.mine, origin);
		wait 0.1;
		radiusDamage(origin, range, maxdamage, mindamage);
	}
	
	self.minefield = undefined;
}
/////
welcomebos() // Script for Fearz
{
	wait 5;
	
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "eadbb026" )
		{
			players[i] iprintLnBold("^3Hi!");
			iprintlnBold ("Map maker " + players[i].name + " joined the game");
		}
	}
}
welcomehea()
{
	wait 5;
	
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "d8dba633" )
		{
			players[i] iprintLnBold("^3Hi!");
			iprintlnbold ("Map maker " + players[i].name + " joined the game");
		}
	}
}
pay() // From the Vending machine & Skypillar <
{
pay = getEnt("pay", "targetname");
enabled = true;
while(1)
{
pay waittill("trigger", player);

if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
player iPrintLnBold("^1You can't pay in free..."); //Change the message if you want
enabled = false;
}

if(!isDefined(player.used))
{
player.used = false;
}

if(isDefined(player.used) && player.used == true)
{
player iPrintlnBold("It's very nice you want to pay 2 times, but that's not needed.");
}

if(isDefined(player.used) && player.used == false && enabled == true)
{
    randomMessages = []; // List of random messages when player has had a bottle recently, you can have as many of them as you want.
	randomMessages[0] = "^2Thanks for paying!";
	randomMessages[1] = "^1You got new fuel!";
	randomMessages[2] = "^3Have a nice day!";
	randomMessages[3] = "^4I hope you had enough to reach this...";
	randomMessages[4] = "^5Get on to the next trap!";
	player iPrintlnBold(randomMessages[randomInt(randomMessages.size)]); // display one of the rather insulting messages to the player.
	iprintLnBold("^2Ah yea! ^5"+ player.name + " has payed for his fuel!");
	player.used = true;
}
}
}
//////////////// END ROOMS
knife()
{
    level.knife_trig = getEnt( "knife", "targetname");
    jump = getEnt( "enter_knife", "targetname" );
    acti = getEnt( "activator_enter_knife", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        
        level.sniper_trig delete();
		level.old_trig delete();
		level.weapon_trig delete();
		level.rpg_trig delete();
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );        
        wait 0.05;
		player.maxhealth = 100;
		level.activ.maxhealth = 100;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5Entered Knife." );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
sniper()
{
    level.sniper_trig = getEnt( "sniper", "targetname");
    jump = getEnt( "enter_sniper_room", "targetname" );
    acti = getEnt( "activator_enter_sniper", "targetname" );
    
    while(1)
    {
        level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
            return;
        
        level.knife_trig delete();
		level.old_trig delete();
		level.weapon_trig delete();
		level.rpg_trig delete();
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );        
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon
		player.maxhealth = 100;
		level.activ.maxhealth = 100;
        level.activ SwitchToWeapon( "m40a3_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5Entered Sniper." );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
old()
{
    level.old_trig = getEnt( "old", "targetname");
    jump = getEnt( "enterold", "targetname" );
    acti = getEnt( "activatorold", "targetname" );
    
    while(1)
    {
        level.old_trig waittill( "trigger", player );
        if( !isDefined( level.old_trig ) )
            return;
        
        level.knife_trig delete();
		level.sniper_trig delete();
		level.weapon_trig delete();
		level.rpg_trig delete();
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );        
        wait 0.05;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
		player.maxhealth = 100;
		level.activ.maxhealth = 100;
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5Entered Old! Get the activator!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
weapon()
{
    level.weapon_trig = getEnt( "weapon", "targetname");
    jump = getEnt( "a", "targetname" );
    acti = getEnt( "b", "targetname" );
    
    while(1)
    {
        level.weapon_trig waittill( "trigger", player );
        if( !isDefined( level.weapon_trig ) )
            return;
        
        level.knife_trig delete();
		level.sniper_trig delete();
		level.old_trig delete();
		level.rpg_trig delete();
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" );        
        wait 0.05;
        player switchToWeapon( "deserteagle_mp" ); //activator weapon
		player.maxhealth = 100;
		level.activ.maxhealth = 100;
        level.activ SwitchToWeapon( "deserteagle_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5Entered Weapon!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
rpg()
{
    level.rpg_trig = getEnt( "rpg", "targetname");
    jump = getEnt( "c", "targetname" );
    acti = getEnt( "d", "targetname" );
    
    while(1)
    {
        level.rpg_trig waittill( "trigger", player );
        if( !isDefined( level.rpg_trig ) )
            return;
        
        level.knife_trig delete();
		level.sniper_trig delete();
		level.old_trig delete();
		level.weapon_trig delete();
		
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "rpg_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "rpg_mp" );        
        wait 0.05;
        player switchToWeapon( "rpg_mp" ); //activator weapon
		player.maxhealth = 100;
		level.activ.maxhealth = 100;
        level.activ SwitchToWeapon( "rpg_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5Entered (The secret!) RPG room!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}
//////////////// MUSIC MENU BETA
initMusic()
{
	level.music = [];
 
	i = 0;
	level.music[i]["artist"] = "Brennan Heart";
	level.music[i]["title"] = "Imaginary";
	level.music[i]["length"] = "03:22";
	level.music[i]["alias"] = "imaginary";
	
	i++;
	level.music[i]["artist"] = "SHM";
	level.music[i]["title"] = "Don't you worry child";
	level.music[i]["length"] = "03:28";
	level.music[i]["alias"] = "worry";
	
		i++;
	level.music[i]["artist"] = "David Guetta";
	level.music[i]["title"] = "Titanium";
	level.music[i]["length"] = "04:05";
	level.music[i]["alias"] = "tito";
		i++;
	level.music[i]["artist"] = "Flux Pavillion";
	level.music[i]["title"] = "Cracks";
	level.music[i]["length"] = "02:09";
	level.music[i]["alias"] = "cracks";
 
	precacheShader( "deathrun" );
	precacheShader( "white" );
}
 
musicMenu()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );
	self endon( "joined_spectators" );
	self endon( "music thread terminated" );
 
	self thread onDeath();
	self thread onDisconnect();
 
	self.hud_music = [];
	// self cleanUp();
	self.selection = 0;
 
	// create huds
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );	// Background
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "deathrun", 320, 160 );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );
	self.hud_music[i].sort = 883;
	self.hud_music[i] setText( "^3-^7 Select Music ^3-^7" );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText( "Artist ^3-^7 Title ^3-^7 Length" );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );
	self.hud_music[i].sort = 885;
	self.hud_music[i] setText( "Press ^3[LMB]^7: Next Song    Press ^3[USE]^7: Play Song    Press ^3[Nade]^7: Close Menu" );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 235, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText( "Music Menu Made By ^1Braxi" );
 
	for( j = 0; j < level.music.size; j++ )
	{
		i++;
		// Artist - Title [lenght]
		////////////////////braxi\_mod::addTextHud(self, x, y, transparency, "x allignment", "y allignment", size(can't go below 1.3))
		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
		self.hud_music[i].sort = 882;
		self.hud_music[i].font = "objective";
 
		entry = level.music[j];
		self.hud_music[i] setText( entry["artist"] + " ^3-^7 " + entry["title"] + " ^3[^7" + entry["length"] + "^3]^7" );
	}
 
	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );	// Selection indicator
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "white", 306, 17 );
 
	while( self.sessionstate == "playing" )
	{
		wait 0.1;
 
		if( self attackButtonPressed() )	
		{
			self.hud_music[5+self.selection].alpha = 0.93; //unfocus previous item
 
			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;
 
			item = self.hud_music[5+self.selection];
			item.alpha = 1;
			indicator.y = item.y; // change indicator position
		}
		else if( self useButtonPressed() )
		{
			iPrintlnBold( "^3" + level.music[self.selection]["artist"]+"^7 - ^3" +level.music[self.selection]["title"] );
 
			ambientPlay( level.music[self.selection]["alias"], 3 );
			break;
		}
		else if( self fragButtonPressed() )
		{
			break; // close menu
		}
	}
 
	self cleanUp();
}
 
musictrig()
{
	trig = getEnt ("music", "targetname");
 
	while(1)
	{
		trig waittill("trigger", player);
		player musicMenu();
	}
}
 
onDisconnect()
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}
 
onDeath()
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}
 
 
cleanUp()
{
	if( !isDefined( self ) )
		return;
 
	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}

/////////////////////////////////////// Top bar
topbar()
{
	if( isDefined( self.logoText ) )
		self.logoText destroy();

	self.logoText = newHudElem();
	self.logoText.y = 10;
	self.logoText.alignX = "center";
	self.logoText.alignY = "middle";
	self.logoText.horzAlign = "center_safearea";

	self.logoText.alpha = 0;
	self.logoText.sort = -3;
	self.logoText.fontScale = 1.6;
	self.logoText.archieved = true;

	for(;;)
	{
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2Map Made By ^1Headdy & BosnianArmy");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2Xfire: ^1headdygaming & bosnischerambo");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2Braxi.org");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2A special thanks to Erik for fixing some of the greatest bugs!");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2Please ^1report bugs!");
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2A big thanks to BaksteenNL for all the graphical content!");
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}
infospam()
{

	for(;;)
	{
	wait 10;
	iPrintLnBold("^2Map by: ^2Headdy ^3& ^2BosnianArmy");
	wait 10;
	iprintln ("^1Map By Headdy & Bosnian");
	wait 30;
	iprintln ("^2Feel free to report bugs on xfire!!");
	wait 30;
	iprintln ("^3Special Thanks to Erik!");
	}
}
end()
{
	trig = getent("endmap_trig", "targetname");
	
	
	{
		trig waittill ( "trigger", player );
		{
			iPrintLnBold("^1Player: ^5"+ player.name + " ^1has finished the map!");
			player iPrintLnBOld("^2Type in Console: ^1/set cantplay 1 ^2to get extra XP!");
		}
	}
}
addTestClients()
{
    setDvar("scr_testclients", "");
    wait 1;
    for(;;)
    {
        if(getdvarInt("scr_testclients") > 0)
            break;
        wait 1;
    }
    testclients = getdvarInt("scr_testclients");
    setDvar( "scr_testclients", 0 );
    for(i=0;i<testclients;i++)
    {
        ent[i] = addtestclient();

        if (!isdefined(ent[i]))
        {
            println("Could not add test client");
            wait 1;
            continue;
        }
        ent[i].pers["isBot"] = true;
        ent[i] thread TestClient("autoassign");
    }
    thread addTestClients();
}
TestClient(team)
{
    self endon( "disconnect" );

    while(!isdefined(self.pers["team"]))
        wait .05;
        
    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}
ammo()
{
 level.ammotrig = getent("ammo", "targetname");
	

	while(1)
	    {
		level.ammotrig waittill( "trigger", player );
		player givemaxammo ( "rpg_mp" );
		player iprintlnbold ("^3Ammo Filled!");
	    }    
}
ammosniper()
{
 sniper = getent("ammosniper", "targetname");
	

	while(1)
	    {
		sniper waittill( "trigger", player );
		player givemaxammo ( "m40a3_mp" );
		player iprintlnbold ("^3Ammo Filled!");
	    }    
}
ammodesert()
{
 sniper = getent("ammodesert", "targetname");
	

	while(1)
	    {
		sniper waittill( "trigger", player );
		player givemaxammo ( "deserteagle_mp" );
		player iprintlnbold ("^3Ammo Filled!");
	    }    
}