//map by LateAX
//ABprice was here
main()
{
 maps\mp\_load::main();



 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((-488, 88, 76), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
 
	setdvar( "r_specularcolorscale", "1" );
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	
	//precacheItem("barrett_mp");
	
	thread startdoor();
	
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();
	
	//thread ele1();
	
	//thread room_selection();
	//thread sniper_room();
	//thread bounce_room();
	//thread gap_room();
	//thread knife_room();
	//thread tele1();
	//thread tele2();
	//thread tele3();
	//thread tele4();
	//thread tele5();
	//thread tele6();
	//thread tele7();
	//thread actitele1();
	//thread actitele2();
	//thread actitele3();
	//thread actitele4();
	
	//thread gun();
	//thread gun2();
	//thread music();
	//thread messages();
	//thread bottomtext();
	
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
	addTriggerToList( "trig_trap9" );
	addTriggerToList( "trig_trap10" );

	
}

startdoor()
{
ABprice = getent("startdoor","targetname");

wait 0.1;
ABprice delete();
}

music()
{
x = randomint(3);

	if(x == 0)
	{
	ambientplay("song1");
	}
	if(x == 1)
	{
	ambientplay("song2");
	}	
	if(x == 2)
	{
	ambientplay("song3");
	}
	if(x == 3)
	{
	ambientplay("song4");
	}
	if(x == 4)
	{
	ambientplay("song5");
	}
}

messages()
{
wait 10;
iprintlnBold("^3Welcome To The Latenight^1, ^5Map By LateAX");
wait 1;
}

bottomtext()
{
	level waittill("round_started");
	while(1)
	{
	wait 5;
	iPrintLn("^3Welcome to mp_dr_latenight!");
	wait 5;
	iPrintLn("^5Map By ^3LateAX");
	wait 5;
	iPrintLn("^6Thanks To ABprice For Helping Me With Script");
	wait 5;
	}
	
}

trap1()
{
	p1 = GetEnt("trap1","targetname");
	trig = GetEnt("trig_trap1","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();

	{
		p1 NotSolid();
	}
}

trap2()
{
	r1 = GetEnt("trap2_1","targetname");
	r2 = GetEnt("trap2_2","targetname");
	trig = GetEnt("trig_trap2","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();
	r1 Delete();

    for(;;)
	{
		wait 0.1;
		r2 rotatepitch (-360, 3);
		wait 5.9;
	}
}


trap3()
{
	f1 = GetEnt("trap3","targetname");
	trig = GetEnt("trig_trap3","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();
    for(;;)
	{
		wait 0.1;
		f1 rotateroll (-360, 3);
		wait 5.9;
	}
}

trap4()
{
	f1 = GetEnt("trap4","targetname");
	trig = GetEnt("trig_trap4","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();
    for(;;)
	{
		wait 0.1;
		f1 hide();
		wait 3;
		f1 show();
		wait 2.9;
	}
}

trap5()
{
	f1 = GetEnt("trap5","targetname");
	trig = GetEnt("trig_trap5","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();
    for(;;)
	{
		wait 0.1;
		f1 rotateYaw (-180, 3);
		wait 8;
		f1 rotateYaw (180, 3);
		wait 7.9;
	}
}

trap6()
{
	p1 = GetEnt("trap6","targetname");
	trig = GetEnt("trig_trap6","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();

	{
		p1 delete();
	}
}

trap7()
{
	p1 = GetEnt("trap7","targetname");
	trig = GetEnt("trig_trap7","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();

	{
		p1 delete();
	}
}

trap8()
{
	f1 = GetEnt("trap8","targetname");
	trig = GetEnt("trig_trap8","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();
    for(;;)
	{
		wait 0.1;
		f1 movex (272,2);
		wait 2;
		f1 movex (-272,2);
		wait 1.9;
	}
}

trap9()
{
	f1 = GetEnt("trap9","targetname");
	trig = GetEnt("trig_trap9","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();
	{
		wait 0.1;
		f1 movez (500,1);
		f1 rotateroll (360, 1);
		wait 3;
		f1 movez (-500,1);
		f1 rotateroll (-360, 1);
	}
}

trap10()
{
	p1 = GetEnt("trap10","targetname");
	trig = GetEnt("trig_trap10","targetname");

	trig SetHintString("^2Press ^3&&1 ^2to Activate Trap");
	trig waittill( "trigger" );
	//player braxi\_rank::giveRankXP("", 30);
	trig Delete();

	{
		p1 delete();
	}
}


ele1()
{
	platform = getEnt("ele1","targetname");
    trig = getEnt("trig_ele1","targetname");
    trig waittill("trigger", player);
	
	trig delete();
	
	for(;;)
	{
	wait 2;
	platform movex (2368,3);
	wait 5.1;
	platform movey (-4100,3);
	wait 7;
	platform movey (4100,3);
	wait 3.1;
	platform movex (-2368,3);
	wait 2;
	}
}

room_selection()
{
    trig = getent("endroom", "targetname"); // Trigger to enter the Selection
    targ = getent("endroom_origin", "targetname"); // Script Origin to the Place you want them to teleport

    while(1)
    {
        //trig sethintstring("^5Enter The Room Selection"); // Change Text to what you want
        trig waittill("trigger",player);

		noti = SpawnStruct();
		noti.titleText = "\n\n^2" + player.name; //upper text
		noti.notifyText = "\n\n\n^2Enter The Room Selection"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
		
        player takeallweapons(); // Removes all weapons

        player setorigin(targ.origin); // Teleport
        player setplayerangles(targ.angles); // Teleport

        while(isAlive(player)&&isDefined(player))
            wait 1;

		noti = SpawnStruct();
		noti.titleText = "\n\n^2" + player.name + "Died!!!"; //upper text
		noti.notifyText = "\n\n\n^2Room Selection Opened"; //lower text
		noti.glowcolor = (0,0.1,0.9);//outercolor
		noti.duration = 4; //time in screen
		players = getentarray("player", "classname"); //for all players
		for(i=0;i<players.size;i++) //all players
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
    }
}


knife_room()
{
	while(1)
	{
	level.trigknife = getEnt("trig_kniferoom", "targetname");
	
	jumporigin = getEnt("sf_1", "targetname");
	actiorigin = getEnt("sf_2", "targetname");
	
	//level.trigknife SetHintString("^5Press ^3[F] ^5To Enter");
	level.trigknife waittill("trigger", player);
	
	noti = SpawnStruct();
	noti.titleText = "\n\n^5Knife ^5Room"; //upper text
    noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
	noti.glowcolor = (0,0.1,0.9);//outercolor
	noti.duration = 4; //time in screen
	players = getentarray("player", "classname"); //for all players
	for(i=0;i<players.size;i++) //all players
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("knife_mp");
	player giveWeapon("knife_mp");
	player giveMaxAmmo("knife_mp");
	player giveMaxAmmo("knife_mp");
	level.activ giveWeapon("knife_mp");
	level.activ giveWeapon("knife_mp");
	level.activ giveMaxAmmo("knife_mp");
	level.activ giveMaxAmmo("knife_mp");
	
	
	player switchToWeapon("knife_mp");
	player switchToWeapon("knife_mp_mp");
	level.activ switchToWeapon("knife_mp");
	player switchToWeapon("knife_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	player iPrintLnBold("^13");
	level.activ iPrintLnBold("^13");
	wait 1;
	player iPrintLnBold("^52");
	level.activ iPrintLnBold("^52");
	wait 1;
	player iPrintLnBold("^21");
	level.activ iPrintLnBold("^21");
	wait 1;
	player iPrintLnBold("^5Kill That Activator^2!");
	level.activ iPrintLnBold("^5Kill That Jumper^2!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	while( isAlive( player ) && isDefined( player ) )
    wait 1;
	

	}
}

sniper_room()
{
	while(1)
	{
	level.trigsniper = getEnt("trig_sniperroom", "targetname");
	
	jumporigin = getEnt("sf_3", "targetname");
	actiorigin = getEnt("sf_4", "targetname");
	
	//level.trigsniper SetHintString("^5Press ^3[F] ^5To Enter");
	level.trigsniper waittill("trigger", player);

	noti = SpawnStruct();
	noti.titleText = "\n\n^5Sniper ^5Room"; //upper text
    noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
	noti.glowcolor = (0,0.1,0.9);//outercolor
	noti.duration = 4; //time in screen
	players = getentarray("player", "classname"); //for all players
	for(i=0;i<players.size;i++) //all players
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("m40a3_mp");
	player giveWeapon("remington700_mp");
	player giveMaxAmmo("remington700_mp");
	player giveMaxAmmo("m40a3_mp");
	level.activ giveWeapon("m40a3_mp");
	level.activ giveWeapon("remington700_mp");
	level.activ giveMaxAmmo("remington700_mp");
	level.activ giveMaxAmmo("m40a3_mp");
	
	
	player switchToWeapon("m40a3_mp");
	player switchToWeapon("m40a3_mp");
	level.activ switchToWeapon("m40a3_mp");
	player switchToWeapon("m40a3_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	player iPrintLnBold("^13");
	level.activ iPrintLnBold("^13");
	wait 1;
	player iPrintLnBold("^52");
	level.activ iPrintLnBold("^52");
	wait 1;
	player iPrintLnBold("^21");
	level.activ iPrintLnBold("^21");
	wait 1;
	player iPrintLnBold("^5Shoot That Activator^2!");
	level.activ iPrintLnBold("^5Shoot That Jumper^2!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	while( isAlive( player ) && isDefined( player ) )
    wait 1;
	

	}
}

bounce_room()
{
	while(1)
	{
	level.trigjump = getEnt("trig_bounceroom", "targetname");
	
	
	jumporigin = getEnt("sf_5", "targetname");
	actiorigin = getEnt("sf_6", "targetname");
	
	//level.trigjump sethintstring("^0Press ^3[F] ^0To Enter");
	level.trigjump waittill("trigger", player);
	
	noti = SpawnStruct();
	noti.titleText = "\n\n^5Bounce ^5Room"; //upper text
    noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
	noti.glowcolor = (0,0.1,0.9);//outercolor
	noti.duration = 4; //time in screen
	players = getentarray("player", "classname"); //for all players
	for(i=0;i<players.size;i++) //all players
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	
	
	
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("knife_mp");
	player giveWeapon("knife_mp");
	player giveMaxAmmo("knife_mp");
	player giveMaxAmmo("knife_mp");
	level.activ giveWeapon("knife_mp");
	level.activ giveWeapon("knife_mp");
	level.activ giveMaxAmmo("knife_mp");
	level.activ giveMaxAmmo("knife_mp");
	
	
	player switchToWeapon("knife_mp");
	player switchToWeapon("knife_mp");
	level.activ switchToWeapon("knife_mp");
	player switchToWeapon("knife_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	player iPrintLnBold("^13");
	level.activ iPrintLnBold("^13");
	wait 1;
	player iPrintLnBold("^52");
	level.activ iPrintLnBold("^52");
	wait 1;
	player iPrintLnBold("^21");
	level.activ iPrintLnBold("^21");
	wait 1;
	player iPrintLnBold("^5Kill That Activator^2!");
	level.activ iPrintLnBold("^5Kill That Jumper^2!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	while( isAlive( player ) && isDefined( player ) )
    wait 1;
	

	}
}

gap_room()
{
	level.trigladder = getEnt("trig_gaproom", "targetname");
	
	actiorigin = getEnt("sf_7", "targetname");
	jumporigin = getEnt("sf_8", "targetname");
	
	//level.trigladder sethintstring("^0Press ^3[F] ^0To Enter");
	
	while(1)
	{

	level.trigladder waittill("trigger", player);
	

	noti = SpawnStruct();
	noti.titleText = "\n\n^5Gap ^5Room"; //upper text
    noti.notifyText = "\n\n\n^1" + level.activ.name + " ^3VS^1 " + player.name;
	noti.glowcolor = (0,0.1,0.9);//outercolor
	noti.duration = 4; //time in screen
	players = getentarray("player", "classname"); //for all players
	for(i=0;i<players.size;i++) //all players
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti ); //something
	
	
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("knife_mp");
	level.activ giveWeapon("knife_mp");	
	
	player switchToWeapon("knife_mp");
	level.activ switchToWeapon("knife_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player show();
	level.activ show();
	
	player setOrigin (actiorigin.origin);
	player setPlayerAngles (actiorigin.angles);

	level.activ setOrigin (jumporigin.origin);
	level.activ setPlayerAngles (jumporigin.angles);
	wait 2; 
	
	player iPrintLnBold("^13");
	level.activ iPrintLnBold("^13");
	wait 1;
	player iPrintLnBold("^52");
	level.activ iPrintLnBold("^52");
	wait 1;
	player iPrintLnBold("^21");
	level.activ iPrintLnBold("^21");
	wait 1;
	player iPrintLnBold("^5Kill That Activator^2!");
	level.activ iPrintLnBold("^5Kill That Jumper^2!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	while( isAlive( player ) && isDefined( player ) )
    wait 1;
	


	}
}


//sniper
tele1()
{    
     trig = getEnt("sniper", "targetname");
	 tele = getEnt("origin_sniper", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}
//bounce
tele2()
{    
     trig = getEnt("jump_1", "targetname");
	 tele = getEnt("origin_jump1", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}
tele3()
{    
     trig = getEnt("jump_2", "targetname");
	 tele = getEnt("origin_jump2", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}
//gap

tele4()
{    
     trig = getEnt("gap1", "targetname");
	 tele = getEnt("origin_gap1", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

tele5()
{    
     trig = getEnt("gap2", "targetname");
	 tele = getEnt("origin_gap2", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

actitele1()
{    
     trig = getEnt("acti1", "targetname");
	 tele = getEnt("origin_acti1", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

actitele2()
{    
     trig = getEnt("acti2", "targetname");
	 tele = getEnt("origin_acti2", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

actitele3()
{    
     trig = getEnt("acti_back1", "targetname");
	 tele = getEnt("origin_acti_back1", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

actitele4()
{    
     trig = getEnt("acti_back2", "targetname");
	 tele = getEnt("origin_acti_back2", "targetname");
	 trig SetHintString("^0Press ^3[F] ^0To Teleport");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

//knife

tele6()
{    
     trig = getEnt("knife1", "targetname");
	 tele = getEnt("origin_knife1", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

tele7()
{    
     trig = getEnt("knife2", "targetname");
	 tele = getEnt("origin_knife2", "targetname");
	 
	 for(;;)
	 {
		 trig waittill("trigger", player);
		 player setorigin(tele.origin);
		 player setPlayerAngles (tele.angles);
		 player freezeControls(1);
         wait 0.02;
         player freezeControls(0);
	 }
}

gun()
{
    trigger = getEnt("gun", "targetname");
    trigger setHintString("^7 Press ^3F ^7To Take ^5Sniper");

    for(;;) 
	{
        trigger waittill("trigger", player);

        player TakeAllWeapons();
        player giveWeapon("barrett_mp");
        player giveMaxAmmo();
        player switchToWeapon("barrett_mp");
        wait 0.5;
    }
}

gun2()
{
    trigger = getEnt("gun2", "targetname");
    trigger setHintString("^7 Press ^3F ^7To Take ^5Sniper");

    for(;;) 
	{
        trigger waittill("trigger", player);

        player TakeAllWeapons();
        player giveWeapon("barrett_mp");
        player giveMaxAmmo();
        player switchToWeapon("barrett_mp");
        wait 0.5;
    }
	
}

addTriggerToList( name, positionOfIconAboveTrap )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

    if( !isDefined( level.icon_origins ) )
        level.icon_origins = [];
    level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
}
