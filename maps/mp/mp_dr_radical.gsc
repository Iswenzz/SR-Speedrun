//Map Made By: VC'R3K
//Scripts By: VC'R3K
//Vistic-Clan.com 

/*
 ____   ____   ______  _  _______     ______   ___  ____   
|_  _| |_  _|.' ___  || ||_   __ \   / ____ `.|_  ||_  _|  
  \ \   / / / .'   \_|\_|  | |__) |  `'  __) |  | |_/ /    
   \ \ / /  | |            |  __ /   _  |__ '.  |  __'.    
    \ ' /   \ `.___.'\    _| |  \ \_| \____) | _| |  \ \_  
     \_/     `.____ .'   |____| |___|\______.'|____||____| 
                                                           
*/

main()
{

	//ambientplay("soundalis");
	//ambientplay("tuesday");
	
	maps\mp\_load::main(); 

	addTriggerToList( "trigger_trap1" );
    addTriggerToList( "trigger_trap2" );
	addTriggerToList( "trigger_trap3" );
    addTriggerToList( "trigger_trap4" );
	addTriggerToList( "trigger_trap5" );
    addTriggerToList( "trigger_trap6" );
	addTriggerToList( "trigger_trap7" );
    addTriggerToList( "trigger_trap8" );
    addTriggerToList( "trigger_trap9" );
	//precacheItem( "rpg_mp" );
	//precacheItem( "m40a3_mp" );
	//precacheItem( "remington700_mp");
		
		
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

		
	//Dvars
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");

	thread sr\api\_map::createSpawn((-1060, 4457, 76), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");
	thread sr\api\_speedrun::createWay((-1064.21, 4631.82, 13.1267), 70, 120, "green", "secret_0");
    thread sr\api\_speedrun::createEndMap((-1421.9, -1087.26, 110.349), 135,120, "normal_0");

		
	//Traps
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();

	//Rooms
	//thread sniper();
	//thread hunter();
	//thread knife();

	//Misc
	//thread shitty1();

	
	//jumperteleports
	thread teleport1();
 	//thread endrooms();
 	
	//actiteleports
	//thread ateleport1();
	//thread ateleport2();
		
	//secret
	thread secret1();
		
	//fx
	//thread fx();

	//Messages
	//thread iPrintlns();
	//thread hudmessage();


	//level._effect["explode"] = LoadFX("dr/explode");
	//level._effect["splash"] = LoadFX("dr/splash");
	//level._effect["greenflame_fx"] = LoadFX("dr/greenflame");	
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
	addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

//Traps
trap1()
{
	trap1 = getEnt("trap1", "targetname");
	trigger = getEnt("trigger_trap1", "targetname");
	splash_fx = getEnt("splash_fx", "targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	trigger waittill("trigger");

}

trap2()
{
	trap2a = getEnt("trap2a", "targetname");
	trap2b = getEnt("trap2b", "targetname");
	trigger = getEnt("trigger_trap2", "targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	trigger waittill("trigger", player );
	
}

trap3()
{
	trap3a = getEnt("trap3a", "targetname");
	trap3b = getEnt("trap3b", "targetname");
	trigger = getEnt("trigger_trap3", "targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	trigger waittill("trigger", player );
	
}

trap4()
{
	object = getent("trap4","targetname");
	trigger = getent("trigger_trap4","targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	killtrigger = getent("killtrig1", "targetname"); 
	trigger waittill ("trigger", player );
	
}

trap5()
{
	trap5 = getEnt("trap5", "targetname");
	trigger = getEnt("trigger_trap5", "targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	trigger waittill("trigger", player );
	
}

trap6()
{
	trap6 = getEnt("trap6", "targetname");
	trigger = getEnt("trigger_trap6", "targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	trigger waittill("trigger", player );
	
}

trap7()
{
	trap7 = getEnt("trap7", "targetname");
	trigger = getEnt("trigger_trap7", "targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	trigger waittill("trigger");
	
}

trap8()
{
	trap8a = getEnt("trap8a", "targetname");
	trap8b = getEnt("trap8b", "targetname");
	trigger = getEnt("trigger_trap8", "targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	trigger waittill("trigger");
	
}

trap9()
{
	trap9 = getEnt("trap9", "targetname");
	trigger = getEnt("trigger_trap9", "targetname");
	explosion = getEnt("explosion", "targetname");
	trigger sethintstring("^5Awaiting ^3Authorization!");
	trigger waittill("trigger");

}

//Rooms
sniper()
{
    level.sniper = getEnt( "sniper_trig", "targetname");
    jump = getEnt( "jumper_snip", "targetname" );
    acti = getEnt( "acti_snip", "targetname" );
    level.sniper setHintString("^2Press ^1[USE] ^2to enter ^1Sniper");
    while(1)
    {
        level.sniper setHintString("^2Press ^1[USE] ^2to enter ^1Sniper");
        level.sniper waittill("trigger", player);
        if(!isDefined(level.sniper))
            return;
        level.knife delete();
        level.bounce delete();
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" );
        player GiveWeapon( "remington700_mp" );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );
        level.activ GiveWeapon( "remington700_mp" );
        wait 0.05;
        player switchToWeapon( "m40a3_mp" );
        level.activ SwitchToWeapon( "m40a3_mp" );
        player FreezeControls(1);
        level.activ FreezeControls(1);
        noti = SpawnStruct();
            noti.notifyText = "^1" + player.name + " ^2chose Sniper Room";
            noti.duration = 6;
            noti.glowcolor = (0, 0, 1.0);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
            wait 5;
        player FreezeControls(0);
        level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

hunter()
{
    level.hunter = getEnt( "hunter_trig", "targetname");
    jump = getEnt( "jumper_hunter", "targetname" );
    acti = getEnt( "acti_hunter", "targetname" );
    level.hunter setHintString("^2Press ^1[USE] ^2to enter ^1The Hunt!");
    while(1)
    {
        level.hunter setHintString("^3Press ^1[USE] ^4to enter ^8The Hunt!");
        level.hunter waittill("trigger", player);
        if(!isDefined(level.hunter))
            return;
        level.knife delete();
        level.bounce delete();
		level.snipe delete();
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
        player GiveWeapon( "m40a3_mp" );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "colt45_mp" );
        level.activ GiveWeapon( "deserteagle_mp" );
        wait 0.05;
        player switchToWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
        player FreezeControls(1);
        level.activ FreezeControls(1);
        noti = SpawnStruct();
            noti.notifyText = "^1" + player.name + " ^2chose The Hunters Room! ^3Hunt ^2Or ^1Be ^6Hunted^3!";
            noti.duration = 6;
            noti.glowcolor = (0, 0, 1.0);
            players = getEntArray("player", "classname");
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

	level.knife = getEnt( "knife_trig", "targetname");
    jump = getEnt( "jumper_knife", "targetname" );
    acti = getEnt( "acti_knife", "targetname" );
    level.knife setHintString("^2Press ^1[USE] ^2to enter ^1Knife");
    while(1)
    {
    	level.knife setHintString("^2Press ^1[USE] ^2to enter ^1Knife");
        level.knife waittill( "trigger", player );
        if(!isDefined(level.knife))
            return;
        level.sniper delete();
        level.bounce delete();
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);
		noti = SpawnStruct();
            noti.notifyText = "^1" + player.name + " ^2chose Knife Room";
            noti.duration = 6;
            noti.glowcolor = (0, 0, 1.0);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
            wait 5;
		player FreezeControls(0);
		level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

//Misc
shitty1() 
{
	shitty1 = getEnt( "shitty1", "targetname" ); 
	trig = getEnt( "trigger_shitty1", "targetname" ); 
	button = getEnt("button", "targetname");
	
	while(1) 
	{ 
		trig waittill ("trigger");
		shitty1 moveY (686, 4);
		button moveY (686, 4);
		shitty1 waittill ("movedone");
		button waittill ("movedone");
		wait .5;
		shitty1 moveY (-686, 4);
		button moveY (-686, 4);
		shitty1 waittill ("movedone");
		button waittill ("movedone");
		
		wait 3;  
	} 
}


//jumperteleports
teleport1()
{
 trig = getEnt("trigger_teleport1", "targetname");
 tele1 = getEnt("jumper1_teleport", "targetname");
 
 for(;;)
 {
  trig waittill("trigger", player );
  player SetOrigin(tele1.origin);
	player SetPlayerAngles(tele1.angles);
	player freeze_on_tps(0.1);
 }
}

endrooms()
{
 trig = getEnt("trigger_endrooms", "targetname");
 endrooms = getEnt("endrooms_teleport", "targetname");

 for(;;)
 {
  trig waittill("trigger", player );
    player SetOrigin(endrooms.origin);
	player SetPlayerAngles(endrooms.angles);
	player freeze_on_tps(0.1);
 }
}

//actiteleports
ateleport1()
{
 trig = getEnt("trigger_ateleport1", "targetname");
 atele1 = getEnt("acti1_teleport", "targetname");
 
 for(;;)
 {
  trig waittill("trigger", player );
  player SetOrigin(atele1.origin);
  player SetPlayerAngles(atele1.angles);
  player freeze_on_tps(0.1);
 }
}

ateleport2()
{
 trig = getEnt("trigger_ateleport2", "targetname");
 atele2 = getEnt("acti2_teleport", "targetname");
 
 for(;;)
 {
  trig waittill("trigger", player );
  player setOrigin(atele2.origin);
 }
}

//secret
secret1()
{
 trig = getEnt("trigger_secret1", "targetname");
 stele1 = getEnt("secret1_teleport", "targetname");
 
 for(;;)
 {
  trig waittill("trigger", player );
    player thread sr\api\_speedrun::finishWay("secret_0");
 }
}

//Fx
fx()
{
	{
		greenflame = getentarray("greenflame_fx", "targetname");
		for(i=0;i<greenflame.size;i++)
		{
			spawn_greenflame[i] = maps\mp\_utility::createOneShotEffect( "greenflame_fx" );
			spawn_greenflame[i].v[ "origin" ] = greenflame[i].origin;
			spawn_greenflame[i].v[ "angles" ] = ( 270, 0, 0 );
			spawn_greenflame[i].v[ "fixid" ] = "greenflame_fx";
			spawn_greenflame[i].v[ "delay" ] = -13;
		}
	}
}

//Messages
iprintlns()
{
    while(1)
    {
        iprintln("^5Server:^7 Map Made By ^5VC' ^7R3K");
        wait 10;
        iprintln("^6 I Hope You All Enjoy ^4Radical");
        wait 10;
        iprintln("^8Server:^1 mp_dr_^5radical");
        wait 10;
    }
}

hudmessage()
{
    level waittill("round_started");

    level.message = NewHudElem();
    level.message.alignX = "center";
    level.message.alignY = "middle";
    level.message.horzalign = "center";
    level.message.vertalign = "middle";
    level.message.alpha = 1;
    level.message.x = 0;
    level.message.y = 0;
    level.message.fontscale = 2;
    level.message.glowalpha = 1;
    level.message.glowcolor = (1, 0.5, 0);
    level.message.label = &"Map by VC' R3K";
    level.message SetPulseFX( 40, 5400, 200 );
    wait 3;
    level.message destroy();
}

