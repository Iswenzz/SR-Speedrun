/*
╔═════╗╔════╗╔════╗╔╗  ╔╗╔════╗ ╔════╗╔════╗╔════╗
╚╣ ╔╗ ║║ ╔╗	║╠╦═══╝║║  ║║║    ║ ╚══╗ ║║ ╔╗ ║║ ╔╗ ║
 ║ ║║ ║║ ╚╝ ║╠╩══╗ ║║  ║║║ ╔╗ ║ ╔══╝ ║║ ║║ ║║ ╚╝ ║
 ║ ║║ ║║╔══╗║╠╦══╝ ║║  ║║║ ║║ ║ ║ ╔══╝║ ║║ ║╠═╦╦╦╝
╔╣ ╚╝ ║║║  ║║║║    ║╚══╝║║ ╚╝ ╠╗║ ╚══╗║ ╚╝ ║║ ║║╠╗╔═╗
╚═════╝╚╝  ╚╝╚╝	   ╚════╝╚════╩╝╚════╝╚════╝╚═╝╚╩╝╚═╝

                              ___________________________________________________________________________
                             //_______________- BRICKY -  Scripted and Made by DafuqzoR. -______________\\
                             \\ If you have a question about the following code, x-Fire add me borstey88//
                              \\!Please don't use this code or any variant of it without my permission!//
                               \\¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯//

THANKS ;)
*/

main()
{
thread sr\api\_map::createSpawnOrigin((-304, 0, 16.125), 0);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (170.32, 1645.52, -76.9696), 0, 220, 150 );
trigger.targetname = "endmap_trig";
trigger.radius = 220;
trigger.inAirCustom = true;
trigger.inAirValue = 20;
	maps\mp\_load::main();

		thread bricky_fix();

	// ambientPlay ("start");

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	// precacheItem( "rpg_mp" );
	// precacheItem( "remington700_mp" );
	// precacheItem("frag_grenade_mp");
	// precacheItem("g36c_acog_mp");
	// precacheItem("g3_silencer_mp");
	// precacheItem("ak74u_reflex_mp");
	// precacheItem("p90_acog_mp");
	// precacheItem("m60e4_grip_mp");
	// precacheItem("skorpion_silencer_mp");
	// precacheItem("m21_acog_mp");
	// precacheItem("winchester1200_reflex_mp");

	level._effect["explo"] = loadfx("explosions/belltower_explosion");
	level._effect["fire"] = loadfx("custom/fire_blue");
	level._effect["blii"] = loadfx("custom/end_blitz");
	level._effect["fireway"] = loadfx("custom/fire");

    thread sr\api\_speedrun::createTeleporter((-287.357, -163.664, 16.125), 55, 25, (1616, 6695, -1924), 270, "freeze", "blue", "secret_0");

	thread way_connect();
	thread door();
	// thread credit();
	thread dele();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	thread spin();
	thread fail2();
	thread fail3();
	thread whos1st();
	// thread ammo();
	// thread ammo2();
	// thread rpga2();
	// thread rpga();
	// thread knife();
	// thread sniper();
	// thread nade();
	// thread rpg();
	// thread weapon();
	thread secretfail();
	thread secretback();



					// addTriggerToList("trap1_trig");
					// addTriggerToList("trap2_trig");
					// addTriggerToList("trap3_trig");
					// addTriggerToList("trap4_trig");
					// addTriggerToList("trap5_trig");
					// addTriggerToList("trap6_trig");
					// addTriggerToList("trap7_trig");
					// addTriggerToList("trap8_trig");
					// addTriggerToList("trap9_trig");

}

bricky_fix()
{
	del_weapon("knife_mp");
	del_weapon("m16_gl_mp");
	del_weapon("ak74u_reflex_mp");
	del_weapon("ak74u_acog_mp");
	del_weapon("ak74u_silencer_mp");
	del_weapon("dog_mp");
	del_weapon("shovel_mp");
}

del_weapon(name)
{
	array = getEntArray("weapon_" + name, "classname");
	if (!isDefined(array) || isDefined(array) && !isDefined(array.size))
		return;

	for (i = 0; i < array.size ;i++)
		array[i] delete();
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


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

door()
{
	door = getEnt ("door", "targetname");
	trig = getEnt ("door_trig", "targetname");
	fx_point = getEnt ("door_fx", "targetname");
	fx_point2 = getEnt ("end_fire", "targetname");
	b1 = getEnt ("bl1", "targetname");
	b2 = getEnt ("bl2", "targetname");
	b3 = getEnt ("bl3", "targetname");
	b4 = getEnt ("bl4", "targetname");
	b5 = getEnt ("bl5", "targetname");
	g1 = getEnt ("g", "targetname");
	g2 = getEnt ("gg", "targetname");
	g3 = getEnt ("ggg", "targetname");
	g4 = getEnt ("gggg", "targetname");

	wait 0.1;
    playfx(level._effect["explo"],fx_point.origin);
	wait 0.1;
	door delete();
	wait 0.1;
	playfx(level._effect["fire"],fx_point2.origin);
	wait 0.05;
	playfx(level._effect["blii"],b1.origin);
	wait 0.05;
	playfx(level._effect["blii"],b2.origin);
	wait 0.05;
	playfx(level._effect["blii"],b3.origin);
	wait 0.05;
	playfx(level._effect["blii"],b4.origin);
	wait 0.05;
	playfx(level._effect["blii"],b5.origin);
	wait 0.05;
	playfx(level._effect["fireway"],g1.origin);
	wait 0.05;
	playfx(level._effect["fireway"],g2.origin);
	wait 0.05;
	playfx(level._effect["fireway"],g3.origin);
	wait 0.05;
	playfx(level._effect["fireway"],g4.origin);
	wait 0.05;
}

credit()
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
		self.logoText setText("^5----->^2Map Made By DafuqzoR^2.^5<-----");
		wait 8;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5----->^1!^6PLS REPORT BUGS^1!<^5-----");
		wait 8;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^3-----^2My ^1xFire^3: ^4borstey88^3-----");
		wait 8;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5---^2Deathrun ^2Bricky^5---");
		wait 8;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^3-----------------------------");
		wait 8;
	}
}

trap1()
{

	trap1 = getEnt ("trap1", "targetname");
	trig = getEnt ("trap1_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

	while(1)
	{
		trap1 rotateRoll (360, 1);
		trap1 movez (65,0.5);
		trap1 waittill ("movedone");
		trap1 movez (-65,0.5);
		trap1 waittill ("movedone");
		trap1 movez (65,0.5);
		trap1 waittill ("movedone");
		trap1 movez (-65,0.5);
		trap1 waittill ("movedone");
		wait 0.5;
	}
}

trap2()
{
	trap2_1 = getEnt ("trap2_1", "targetname");
	trap2_2 = getEnt ("trap2_2", "targetname");
	trig = getEnt ("trap2_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

	while(1)
	{
	trap2_1 RotateRoll (360, 2.3);
	wait 0.5;
	trap2_2 RotateRoll (-360, 2.3);
	}

}

trap3()
{
	trap3_1 = getEnt ("trap3_1", "targetname");
	trap3_2 = getEnt ("trap3_2", "targetname");
	trap3_3 = getEnt ("trap3_3", "targetname");
	trig = getEnt ("trap3_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

	while(1)
	{
	trap3_1 rotatePitch (360, 1.2);
	wait 2;
	trap3_2 rotateYaw (360, 1.2);
	wait 2;
	trap3_3 rotatePitch (360, 1.2);
	wait 5;
	}
}

trap4()
{
	trap4_1 = getEnt ("trap4_1", "targetname");
	trap4_2 = getEnt ("trap4_2", "targetname");
	trap4_3 = getEnt ("trap4_3", "targetname");
	trig = getEnt ("trap4_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

	while(1)
	{
	trap4_1 rotateYaw (360,2);
	wait 0.05;
	trap4_2 rotateYaw (-360,2);
	wait 0.05;
	trap4_3 notsolid();
	}
}

trap5()
{
	t1 = getEnt ("trap5_1", "targetname");
	t2 = getEnt ("trap5_2", "targetname");
	t3 = getEnt ("trap5_3", "targetname");
	t4 = getEnt ("trap5_4", "targetname");
	trig = getEnt ("trap5_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

	while(1)
	{
		t1 rotatePitch (360, 3);
		t2 rotatePitch (-360, 3);
		wait 3;
		t3 rotatePitch (-360, 3);
		t4 rotatePitch (360, 3);
		wait 3;
	}
}

trap6()
{
	t6 = getEnt ("trap6", "targetname");
	t7 = getEnt ("trap6_1", "targetname");
	trig = getEnt ("trap6_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

 	t7 delete();

	while(1)
	{
	t6 moveX (-150, 0.7);
	wait 0.7;
	t6 moveX (150, 0.7);
	wait 0.7;
	}
}

trap7()
{
	trap7_1 = getEnt ("trap7_1", "targetname");
	trap7_2 = getEnt ("trap7_2", "targetname");
	trig = getEnt ("trap7_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

	while(1)
	{
    trap7_1 moveZ (50,1);
	trap7_2 moveZ (-50,1);
	wait 1;
	trap7_1 moveZ (-50,1);
	trap7_2 moveZ (50,1);
	wait 1;
	trap7_1 moveZ (-50,1);
	trap7_2 moveZ (50,1);
	wait 1;
	trap7_1 moveZ (50,1);
	trap7_2 moveZ (-50,1);
	wait 1;
	}
}

trap8()
{
	trap8 = getEnt ("trap8", "targetname");
	trig = getEnt ("trap8_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

	while(1)
	{
	trap8 RotateYaw (360, 2.5);
	wait 0.5;
	}
}

trap9()
{
	trap9_1 = getEnt ("trap9_1", "targetname");
	trap9_2 = getEnt ("trap9_2", "targetname");
	trig = getEnt ("trap9_trig", "targetname");

	trig setHintString("^2USE ^7T^0o ^7A^0ctivate^2!");
	trig waittill("trigger", player);
	trig setHintString("^5Activated^2!");

	while(1)
	{
	trap9_1 RotateRoll (360, 2.5);
	trap9_2 RotateRoll (-360, 2.5);
	wait 0.5;
	}
}

spin()
{
	sp1 = getEnt ("spin1", "targetname");
	sp2 = getEnt ("spin2", "targetname");
	sp3 = getEnt ("wall", "targetname");
	sp4 = getEnt ("boden", "targetname");

	while(1)
	{
	sp1 RotateYaw (-360, 3);
	wait 0.05;
	sp2 RotateYaw (360, 3);
	wait 0.05;
	sp3 RotateYaw (-360, 3);
	wait 0.05;
	sp4 RotateYaw (360, 5);
	wait 0.05;
	}
}

whos1st()
{

	trig = getEnt ("1st_trig", "targetname");

}

secretback()
{
    trig = getEnt ("back_trig", "targetname");
    end = getEnt ("tp_re", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");

	}
}

dele()
{

	secretblock = getEnt ("secretdel", "targetname");
	trig = getEnt ("del_trig", "targetname");

	wait 0.1;
	secretblock delete();
}

secretfail()
{
    trig = getEnt ("fail_trig", "targetname");
    end = getEnt ("tp_fail", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

fail2()
{
    trig = getEnt ("fail2_trig", "targetname");
    end = getEnt ("fail2", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}

fail3()
{
    trig = getEnt ("fail3_trig", "targetname");
    end = getEnt ("fail3", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);
        player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}


ammo() //nade room ammo
{
	trig = getEnt ("nade_trig", "targetname");

	while(1)
	{
	trig waittill("trigger", player);
	wait 0.5;
	player giveMaxammo("frag_grenade_mp");
	}
}

ammo2() //nade room ammo
{
	trig = getEnt ("nade2_trig", "targetname");

	while(1)
	{
	trig waittill("trigger", player);
	wait 0.5;
	player giveMaxammo("frag_grenade_mp");
	}
}

rpga() //Rpg ammo
{
	trig = getEnt ("rpg_trig", "targetname");

	while(1)
	{
	trig waittill("trigger", player);
	wait 0.5;
	player giveMaxammo("rpg_mp");
	}
}

rpga2() //Rpg ammo
{
	trig = getEnt ("rpg2_trig", "targetname");

	while(1)
	{
	trig waittill("trigger", player);
	wait 0.5;
	player giveMaxammo("rpg_mp");
	}
}

sniper()
{

	level.final_sniper_trig = getEnt( "final_sniper_trig", "targetname");
    jump = getEnt( "sniper_j", "targetname" );
    acti = getEnt( "sniper_a", "targetname" );


     while(1)
    {
        level.final_sniper_trig waittill( "trigger", player );
        if( !isDefined( level.final_sniper_trig ) )
            return;

		//level.final_sniper_trig delete();
		level.final_knife_trig delete();
        level.final_wep_trig delete();
		level.final_rpg_trig delete();
		level.final_nade_trig delete();


         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
		player GiveWeapon( "m40a3_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" );
        level.activ GiveWeapon( "m40a3_mp" );
        wait 0.05;
        player switchToWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Sniper Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (1,0,0.9);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;

    }

}

rpg()
{

	level.final_rpg_trig = getEnt( "final_rpg_trig", "targetname");
    jump = getEnt( "rpg_j", "targetname" );
    acti = getEnt( "rpg_a", "targetname" );

     while(1)
    {

        level.final_rpg_trig waittill( "trigger", player );
        if( !isDefined( level.final_rpg_trig ) )
            return;

		level.final_sniper_trig delete();
		level.final_knife_trig delete();
        level.final_wep_trig delete();
		//level.final_rpg_trig delete();
		level.final_nade_trig delete();

         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "rpg_mp" );
		player GiveWeapon( "rpg_mp" );
		player giveMaxammo("rpg_mp");
		player giveMaxammo("rpg_mp");
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "rpg_mp" );
        level.activ GiveWeapon( "rpg_mp" );
		level.activ giveMaxammo("rpg_mp");
		level.activ giveMaxammo("rpg_mp");
        wait 0.05;
        player switchToWeapon( "rpg_mp" );
        level.activ SwitchToWeapon( "rpg_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "Rpg Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0.9,0.1);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;

    }

}

weapon()
{

	level.final_wep_trig = getEnt( "final_wep_trig", "targetname");
    jump = getEnt ("wep_j", "targetname");
    acti = getEnt ("wep_a", "targetname");

     while(1)
    {
        level.final_wep_trig waittill( "trigger", player );
        if( !isDefined( level.final_wep_trig ) )
            return;

		level.final_sniper_trig delete();
		level.final_knife_trig delete();
        //level.final_wep_trig delete();
		level.final_rpg_trig delete();
		level.final_nade_trig delete();


         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "winchester1200_reflex_mp" );
		player GiveWeapon( "winchester1200_reflex_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "winchester1200_reflex_mp" );
        level.activ GiveWeapon( "winchester1200_reflex_mp" );
        wait 0.05;
        player switchToWeapon( "winchester1200_reflex_mp" );
        level.activ SwitchToWeapon( "winchester1200_reflex_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "^7Weapon Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0,0.9);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;

    }
}

nade()
{

	level.final_nade_trig = getEnt( "final_nade_trig", "targetname");
    jump = getEnt ("nade_j", "targetname");
    acti = getEnt ("nade_a", "targetname");

     while(1)
    {
        level.final_nade_trig waittill( "trigger", player );
        if( !isDefined( level.final_nade_trig ) )
            return;

     	level.final_sniper_trig delete();
		level.final_knife_trig delete();
        level.final_wep_trig delete();
		level.final_rpg_trig delete();
		//level.final_nade_trig delete();

         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "frag_grenade_mp" );
		player GiveWeapon( "frag_grenade_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "frag_grenade_mp" );
        level.activ GiveWeapon( "frag_grenade_mp" );
        wait 0.05;
        player switchToWeapon( "frag_grenade_mp" );
        level.activ SwitchToWeapon( "frag_grenade_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "^5Nade ^5Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0,0.9);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

knife()
{

	level.final_knife_trig = getEnt( "final_knife_trig", "targetname");
    jump = getEnt( "enter_jumper_k", "targetname" );
    acti = getEnt( "activator_enter_k", "targetname" );

     while(1)
    {
        level.final_knife_trig waittill( "trigger", player );
        if( !isDefined( level.final_knife_trig ) )
            return;

		level.final_sniper_trig delete();
		//level.final_knife_trig delete();
        level.final_wep_trig delete();
		level.final_rpg_trig delete();
		level.final_nade_trig delete();

         player.health = player.maxhealth;
		 level.activ.health = level.activ.maxhealth;
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );
		player GiveWeapon( "knife_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );
        level.activ GiveWeapon( "knife_mp" );
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
				noti.titleText = "^7Crazy Knife Room";
				noti.notifyText = level.activ.name + " ^3VS^7 " + player.name;
				noti.glowcolor = (0.9,0,0.9);
				noti.duration = 5;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				wait 5;
				player FreezeControls(0);
				level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

