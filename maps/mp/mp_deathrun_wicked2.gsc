/*

Credits
---------
Map made by *AoD'DazE* | Xfire : *untzdaze*
Scripting help from *kaje11*
Water made by *Rycoon*
---------
*/

main()
{
    maps\mp\_load::main();
	
	level._effect["fire_blue"] = LoadFX("dr/fire_blue");
	level._effect["fire_ryellow"] = LoadFX("dr/fire_ryellow");
	level._effect["fire_large"] = LoadFX("dr/fire_large");
	
	level.wall_explosion_fx = LoadFX("explosions/boom");
	level._effect[ "beacon_glow2" ] = loadfx( "misc/eglow" );
	
	level._effect[ "lightning" ] = loadfx( "weather/lightning_mp_farm" );
	level._effect[ "fireflieslb" ] = loadfx( "misc/fireflieslb" );
	level._effect[ "fireflies" ] = loadfx( "misc/fireflies" );
	level._effect[ "firefliesp" ] = loadfx( "misc/fireflies2" );

	level.mp44_trig = getEnt ("end_mp44", "targetname");
	level.aku_trig = getEnt ("end_aku", "targetname");
	level.knife_trig = getEnt ("end_knife", "targetname");
	
	precacheItem( "ak74u_mp" );
	precacheItem( "m4_acog_mp" );
	precacheModel( "viewhands_desert_opfor_clr" );

    setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );
	
	//Traps//
	
	thread sr\api\_speedrun::createNormalWays("Normal Way");
		thread sr\api\_speedrun::createTeleporter((-2696.49, -3553.9, 368.125), 130, 105, (-1555, -3481, 428), 269, "freeze");
	//thread trap1();
	//thread trap2();
	//thread trap3_pushers();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap8();
	//thread trap9();
	//thread trap10();

	//Other//
	thread stagetwo();
	//thread credits();
	//thread acti_move1();
	thread createFX();
	//thread platformm();
	//thread other_stuff();
	//thread music();
	//thread acti_stagetwo();
	//thread acti_stagetwo2();
	thread fireflies();
	thread AddTestClients();
	//thread credits();
	thread startDoor();
	thread Siirtaja1();
	//thread sniper_ammo();
	
	//Endrooms//
	
	
	//thread endRoom_old();
	//thread endRoom( level.mp44_trig, "s_jumper", "s_acti", "m40a3_mp", "Sniper" , level.aku_trig, level.knife_trig);	
	//thread endRoom( level.aku_trig, "jumper_aku", "acti_aku", "ak74u_mp", "Smg", level.mp44_trig, level.knife_trig );	
	//thread endRoom( level.knife_trig, "jumper_knife", "acti_knife", "tomahawk_mp", "Knife", level.aku_trig, level.mp44_trig );
	
	//Thunder//
	
	//addThunder( (1608, 24, 408) );
	//addThunder( (5416, -40, 808) );
	//addThunder( (8744, -8, 728) );
	
	for( i = 1;i < 11;i++ )
		addTriggerToList( "trap" + i + "_trig" );
		addTriggerToList( "trap6a_trig");
		addTriggerToList( "trap6b_trig");
		addTriggerToList( "trap6c_trig");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
    game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

    setDvar( "r_glowbloomintensity0", ".25" );
    setDvar( "r_glowbloomintensity1", ".25" );
    setDvar( "r_glowskybleedintensity0", ".3" );
    setDvar( "compassmaxrange", "1800" );
	setDvar( "r_fullbright", "0" );
}

sniper_ammo()
{

ammo = getEnt ("sniper_ammo", "targetname");

while(true)
	{
	ammo waittill("trigger", user);
	user TakeAllWeapons();
	user giveWeapon( "m40a3_mp" );
	user giveWeapon( "remington700_mp" );
	wait 0.1;
	user switchtoweapon( "m40a3_mp" );
	}
}

startDoor()
{

door = getEnt("startdoor", "targetname");

wait 8;
{

door moveZ(-136, 2, 0.5, 0.5);
wait 3;
door delete();
}
}


endroom_Old()
{

level.old_trig = getEnt("end_old", "targetname");
level.old_wall = getEnt ("wall_old", "targetname");
acti = getEnt ("acti_stagetwo2enter", "targetname" );

level.old_trig waittill("trigger", player);

wait 0.05;
{

level.old_wall delete();
level.mp44_trig delete();
level.aku_trig delete();
level.knife_trig delete();
level.old_trig delete();
thread drawInformation( 800, 0.8, 1, " " + player.name + " Has chosen Old" );
level.activ setOrigin(acti.origin);
level.activ setPlayerAngles(acti.angles);
wait 1;
}
}

fireflies()
{
	addFireflies( "st", 10 );
	addFireflies( "ff", 7, "fireflieslb" );
	addFireflies( "cc", 5 );
	addFireflies( "ring", 5 );
	addFireflies( "knife", 9 );
	addFireflies( "bluefly", 7 );
	addFireflies( "pinkfly", 10 );
	addFireflies( "orangefly", 4 );
	
	glow1 = getEnt ("glow11", "targetname");
glow3 = getEnt ("glow13", "targetname");

level._effect[ "beacon_glow" ] = loadfx( "misc/eglow" );
	maps\mp\_fx::loopfx("beacon_glow", (glow1.origin), 3, (glow1.origin) + (0, 0, 90));
	maps\mp\_fx::loopfx("beacon_glow", (glow3.origin), 3, (glow3.origin) + (0, 0, 90));
	
}

stageTwo()
{
	trig = getEnt( "stagetwo", "targetname" );
	enter = getEnt( "stagetwo_start", "targetname" );

	while( 1 )
	{
		trig waittill( "trigger", user );
		user setOrigin( (-3920, -2736, 856) );
	user setPlayerAngles(enter.angles);
	}
}

acti_stageTwo()
{
	trig = getEnt ("a_stagetwo", "targetname" );
	enter = getEnt ("a_stage2_start", "targetname" );
	glow = getEnt ("a_stage2glow", "targetname" );

	maps\mp\_fx::loopfx("beacon_glow2", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	while( 1 )
	{
		trig waittill( "trigger", user );
		teleportPlayer( user, enter );
	}
}

acti_stageTwo2()
{
	trig = getEnt ("acti_stagetwo2", "targetname" );
	enter = getEnt ("acti_stagetwo2enter", "targetname" );

	while( 1 )
	{
		trig waittill( "trigger", user );
		teleportPlayer( user, enter );
	}
}

other_stuff()
{
	wait 20;
	iPrintLN( "Map made by ^1AoD'DazE^7" );
	wait 2;
	iPrintLN( "Feel free to report possible bugs to me on xfire" );
	wait 2;
	iPrintLN( "Xfire : ^1untzdaze^7" );
	wait 2;
	iPrintLN( "Thanks to ^1kaje11^7 & ^1Rycoon ^7for help" );
}

platformm()
{
	platform = getEnt( "mplatform1", "targetname" );

	// while( 1 )
	// {
	// 	platform moveX( 624, 3, 0.4, 0.4 );
	// 	platform waittill( "movedone" );
	// 	platform moveX( -624, 3, 0.4, 0.4 );
	// 	platform waittill( "movedone" );
	// }
}

music()
{


	music = RandomIntRange (0,4);

if( music == 1)

{

AmbientStop();
AmbientPlay("los");
wait 5;
hud = addTextHud( level, 5, 7, 1, "left", "middle", 1.4 );
hud setText( "Now playing: ^1Example ^7- ^5Last Ones Standing"  );
wait 8;
hud destroy();

}

if( music == 0)
{

AmbientStop();

}

if( music == 3)
{

AmbientStop();

}

if( music == 2)
{

AmbientStop();
AmbientPlay("los");
wait 5;
hud = addTextHud( level, 5, 7, 1, "left", "middle", 1.4 );
hud setText( "Now playing: ^1Example ^7- ^5Last Ones Standing"  );
wait 8;
hud destroy();
}
}
createFX()
{
	fire_blue = getentarray("fire_blue", "targetname");
	for(i=0;i<fire_blue.size;i++)
	{
		spawn_fire[i] = maps\mp\_utility::createOneshotEffect( "fire_blue" );
		spawn_fire[i].v[ "origin" ] = fire_blue[i].origin;
		spawn_fire[i].v[ "angles" ] = ( 270, 0, 0 );
		spawn_fire[i].v[ "fxid" ] = "fire_blue";
		spawn_fire[i].v[ "delay" ] = -15;
		spawn_fire[i].v[ "soundalias" ] = "fire_metal_large";
	}
	
	fire_yellow = getentarray("fire_yellow", "targetname");
	for(i=0;i<fire_yellow.size;i++)
	{
		fire[i] = maps\mp\_utility::createOneshotEffect( "fire_yellow" );
		fire[i].v[ "origin" ] = fire_yellow[i].origin;
		fire[i].v[ "angles" ] = ( 270, 0, 0 );
		fire[i].v[ "fxid" ] = "fire_ryellow";
		fire[i].v[ "delay" ] = -15;
		fire[i].v[ "soundalias" ] = "fire_metal_large";
	}
	
	stageglow = getentarray("stagetwoglows", "targetname");
	for(i=0;i<stageglow.size;i++)
	{
		glow[i] = maps\mp\_utility::createOneshotEffect( "beacon_glow2" );
		glow[i].v[ "origin" ] = stageglow[i].origin;
		glow[i].v[ "angles" ] = ( 270, 0, 0 );
		glow[i].v[ "fxid" ] = "beacon_glow2";
		glow[i].v[ "delay" ] = -15;
	}
}

credits()
{
	wait(12);
	thread drawInformation( 800, 0.8, 1, "Map made by AoD'DazE || Xfire : untzdaze" );
	wait(6);
	thread drawInformation( 800, 0.8, 1, "Visit us: AoD-Gaming.com" );
	wait(6);
}


trap1()
{

trap = getEnt ("trap1", "targetname");
trig = getEnt("trap1_trig", "targetname");
hurt = getEnt( "trap1_hurt", "targetname");
	
	hurt enableLinkTo();
	hurt LinkTo(trap);
	
	trig waittill("trigger");
	trig delete();
	
		trap moveZ( 18, 0.3, 0.1, 0.1);
		wait 1.5;
		trap moveZ( -18, 0.3, 0.1, 0.1);
}
trap2()
{
	trap = getEnt ("trap2", "targetname");
	trig = getEnt("trap2_trig", "targetname");
	
	
	trig waittill("trigger");
	trig delete();

	while( 1 )
	{
		trap rotateYaw(360, 4.5);
		wait 4.5;
	}
}

trap3_pushers()
{
	trapa = getEnt ("trap3a", "targetname");
	trapb = getEnt ("trap3b", "targetname");
	trapc = getEnt ("trap3c", "targetname");
	trig = getEnt("trap3_trig", "targetname");
	
	trig waittill("trigger");
	trig delete();

	while( 1 )
	{
		trapa moveY (304, 0.43);
		trapb moveY (-304, 0.43);
		trapc moveY (304, 0.43);
		
		wait 0.48;
		
		trapa moveY (-304, 0.5);
		trapb moveY (304, 0.5);
		trapc moveY (-304, 0.5);
		
		wait 0.55;
		
		trapa moveY (304, 0.55);
		trapb moveY (-304, 0.55);
		trapc moveY (304, 0.55);
		
		wait 0.6;
		
		trapa moveY (-304, 0.45);
		trapb moveY (304, 0.45);
		trapc moveY (-304, 0.45);
		
		wait 0.5;
	}
}

trap4()
{
	rings = getEnt("trap4", "targetname");
	trig = getEnt("trap4_trig", "targetname");
	
	
	trig waittill("trigger");
	trig delete();
	
while( 1 )
	{

		rings RotateRoll (540, 2, 0.3, 0.3);
		wait 2;
		rings moveZ (175, 0.2, 0.03, 0.03);
		rings waittill ("movedone");
		rings moveZ (-175, 0.2, 0.03, 0.03);
		rings waittill ("movedone");
		rings moveZ (175, 0.2, 0.03, 0.03);
		rings waittill ("movedone");
		rings moveZ (-175, 0.2, 0.03, 0.03);
		rings waittill ("movedone");
		wait 0.3;
	}
}

trap5()
{
	trig = getEnt("trap5_trig", "targetname");
	
	trig waittill("trigger");
	trig delete();

	thread spinner( "trap5a", 360, 1.65 );
	thread spinner( "trap5b", -360, 1.65 );
}




trap6()

{
thread hammertrap( "trap6a_trig", "hammer1l", "hammer1r", 360, 2.10);
thread hammertrap( "trap6b_trig", "hammer2l", "hammer2r", -360, 2.10);
thread hammertrap( "trap6c_trig", "hammer3l", "hammer3r", 360, 2.10);
}

trap8()

{
	trig = getEnt ("trap8_trig", "targetname");

	trig waittill ("trigger");
	trig delete();

	wait 0.05;
	
	thread ef( "ps1", 110, 0.8, 1.8 );
	thread ef( "ps2", -100, 0.7, 1.65 );
	thread ef( "ps3", 80, 0.65, 1.4 );	
	thread ef( "ps4", 90, 0.7, 1.4 );
	thread ef( "ps5", -110, 0.8, 1.4 );	
	thread ef( "ps6", 110, 0.8, 1.4 );	
	thread ef( "ps7", -115, 0.9, 1.9 );	
	thread ef( "ps8", 110, 0.8, 1.8 );	
	thread ef( "ps9", -110, 0.8, 1.8 );	
	thread ef( "ps10", -100, 0.7, 1.65 );
	thread ef( "ps11", 100, 0.7, 1.65 );
	thread ef( "ps12", 80, 0.65, 1.4 );
	thread ef( "ps13", -90, 0.9, 1.5 );
	thread ef( "ps14", 110, 0.8, 1.4 );
	thread ef( "ps15", -110, 0.8, 1.4 );
	thread ef( "ps16", 115, 0.8, 1.9 );	
}



acti_move1()
{
	jumpx = getent ("acti_tele1up","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("a_air1","targetname");
	air2 = getent ("a_air2","targetname");
	air3 = getent ("a_air3","targetname");
	air4 = getent ("a_air4", "targetname");
	
	time = .5;
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
			wait .5;
			air moveto (air2.origin, time);
			wait .25;
			air moveto (air3.origin, time);
			wait .25;
			air moveto (air4.origin, time);
			wait .5;
			user unlink();
			wait 0.05;
			air delete();
}
}
}
trap9()
{
	pusher = getEnt( "trap9", "targetname" );
	trig = getEnt( "trap9_trig", "targetname" );

	trig waittill( "trigger" );
	
	wait 0.05;
	
	pusher moveY( -232, 0.75, 0.1, 0.1 );
	wait 2.5;
	pusher moveY( 232, 1.3, 0.2, 0.2 );
	wait 2;
}

trap10()
{

	spinner = getEnt( "trap10", "targetname" );
	trig = getEnt("trap10_trig", "targetname");
	
	trig waittill("trigger");
	trig delete();

	while( 1 )
	{
		for( i = 0;i < 5;i++ )
		{
			yaw = -900;
			if( i == 0 || i == 3 ) yaw = 900;
			
			spinner rotateYaw( yaw, 2.7, 0.4, 0.4 );
			spinner waittill( "rotatedone" );
			wait .5;
		}
	}
}




// functions //

//Credits//

drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 90 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 5 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}

new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 2;

	hud.color = (0.8, 1, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.7, 0, 0);
	hud.glowAlpha = 1;
	hud SetPulseFX( 30, 100000, 700 );

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

addTextHud( who, x, y, alpha, alignX, alignY, fontScale )
{
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;
	return hud;
}



//Effects//

addThunder( origin)
{
ent = maps\mp\_utility::createOneshotEffect( "lightning" );
	ent.v[ "origin" ] = ( origin );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "lightning";
	ent.v[ "delay" ] = 20;
}

addFireflies( prefix, to, add )
{
	from = 1;
	if( !isDefined( add ) ) add = "fireflies";

	for( i = from;i < to;i++ )
	{
		x = getEnt( prefix + i, "targetname" );
		maps\mp\_fx::loopfx( add, x.origin, 3, x.origin + (0,0,90) );
	}
}


//Traps//

ef( id, fz, ft, st )
{
	e = getEnt( id , "targetname" );
	while( 1 )
	{
		e moveZ( fz, ft );
		wait ft;
		e moveZ( fz*-2, st );
		wait st;
		e moveZ( fz, ft );
		wait ft;
}
}


hammertrap( trigger, hammer1, hammer2, distance, time)
{

trig = getEnt( trigger, "targetname");
hammer1 = getEnt( hammer1, "targetname");
hammer2 = getEnt( hammer2, "targetname");

trig waittill("trigger");
trig delete();

while(true)
{

hammer1 rotateRoll ( distance, time);
hammer2 rotateRoll ( distance, time);
wait time;
}
}

spinner( spinner_id, v, t )
{
	e = getEnt( spinner_id, "targetname" );
	while( 1 )
	{
		e rotateYaw( v, t );
		wait t;
	}
}


//deathrun//

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
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

//EndRooms//

weaponStuff( who, acti, weapon )
{
	teleportPlayer( who, acti );
	who TakeAllWeapons();
	who GiveWeapon( weapon );
	wait .05;
	who switchtoweapon( weapon );
	who setViewModel("viewhands_desert_opfor_clr");
}
endRoom( endRoom, j, a, weapon, name, del1, del2 )
{
	trig = endRoom;
	if( !isDefined( trig ) ) return;
	
	jumper = getEnt( j, "targetname" );
	acti = getEnt( a, "targetname" );

	while( 1 )
	{
		trig waittill( "trigger", player );
		if( !isDefined( trig ) )
		return;

		del1 delete();
		del2 delete();
		level.old_trig delete();
		
		
		thread weaponStuff( player, jumper, weapon );
		player freezeControls(1);
		level.activ freezeControls(1);
		wait 1;
		player freezeControls(0);
		level.activ freezeControls(0);
		thread weaponStuff( level.activ, acti, weapon );

		thread drawInformation( 800, 0.8, 1, " " + player.name + " Has entered the " + name + " room" );
		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}


//Teleport//

teleportPlayer( who, item )
{
	who setPlayerangles( item.angles );
	who setOrigin( item.origin );
}


Siirrapelaaja( kuka, i1, i2, i3, i4, aika)
{


	kuka.ilmassa = true;

	ilma1 = getEnt ( i1,"targetname");
	ilma2 = getEnt ( i2,"targetname");
	ilma3 = getEnt ( i3,"targetname");
	ilma4 = getEnt ( i4,"targetname");



			ilma = spawn ("script_model",(0,0,0));
			ilma.origin = kuka.origin;
			ilma.angles = kuka.angles;
			kuka linkto (ilma);
			ilma moveto (ilma1.origin, aika, 0.1);
			wait aika;
			ilma moveto (ilma2.origin, aika);
			wait aika;
			ilma moveto (ilma3.origin, aika);
			wait aika;
			ilma moveto (ilma4.origin, aika, 0, 0.1);
			wait aika;
			kuka unlink();
			wait 1;
			ilma delete();
			kuka.ilmassa = undefined;

		kuka sr\api\_player::antiElevator(true);

}

Siirtaja1()
{

trigger = getEnt( "ts1_enter", "targetname" );



for(;;)
	{
	
	
	trigger waittill ( "trigger", pelaaja);

	
	siirtaja = RandomIntRange (0,3);
	
	if( siirtaja == 0)
	{
		pelaaja sr\api\_player::antiElevator(false);
		if( pelaaja istouching( trigger ) && !isDefined( pelaaja.ilmassa ) )
		thread Siirrapelaaja( pelaaja, "ts1_air_11", "ts1_air_12", "ts1_air_13", "ts1_air_14", 0.45);
	}

	if( siirtaja == 1)
	{
		pelaaja sr\api\_player::antiElevator(false);
		if( pelaaja istouching( trigger ) && !isDefined( pelaaja.ilmassa ) )
		thread Siirrapelaaja( pelaaja, "ts1_air_21", "ts1_air_22", "ts1_air_23", "ts1_air_24", 0.45);
	}
	
	if( siirtaja == 2)
	{
		pelaaja sr\api\_player::antiElevator(false);
		if( pelaaja istouching( trigger ) && !isDefined( pelaaja.ilmassa ) )
		thread Siirrapelaaja( pelaaja, "ts1_air_31", "ts1_air_32", "ts1_air_33", "ts1_air_34", 0.45);
	}
	
	}
}

