/*                                      
MMMMMMM MMMMMM  MMMMMM  MMMMMM   MMMMMM8  MMMMMM  
  MMI   MMOII7 .MM  MM  MM. MM  MM    MM  MM .MM  
  MM    MM=     MM MM   MM MM   MM   .MM  MM MM   
  MM    MMMMMM  MM MMM .MM DMM   MMMMMM   MM :MM 
*/

main()
{
	thread sr\api\_map::create_normal_way("Normal Way;");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::create_spawn_auto(auto_spawn[int(auto_spawn.size / 2)].origin + (0,0,20),
 auto_spawn[int(auto_spawn.size / 2)].angles[1]);
	maps\mp\_load::main();
	
	addTriggerToList( "trap1_trig" );
    addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
    addTriggerToList( "trap4_trig" );
	addTriggerToList( "trap5_trig" );
    addTriggerToList( "trap6_trig" );
	addTriggerToList( "trap7_trig" );
    addTriggerToList( "trap8_trig" );
	
	precacheModel( "bear_stickman_red" );
	precacheModel( "viewhands_bear_stickman_red" );
	PrecacheModel( "vehicle_blackhawk" );
	PrecacheItem("m14_reflex_mp");
	PrecacheItem("m60e4_mp");
	precacheItem( "ak74u_mp" );
	setExpFog(600, 600, 0, 0, 0, 0);
	level.mortar = LoadFX("explosions/artilleryExp_dirt_brown_low");
	level.bomb = LoadFX("explosions/artilleryexp_dirt_brown_2");
	level.dust = LoadFX( "dust/fallout_aftermath" );
	level._effect["green"] = loadfx("test/green_p");
	level._effect["red"] = loadfx("test/red_p");
	level.fire = loadfx("test/jeepride_smokeblind");
	level.boom = loadfx("explosions/airlift_explosion_large");
	level.brick = loadfx("test/brickblast_25");
	level.floorfire = loadfx("test/window_fire_large");
	level.fx_redspawn = loadfx("test/brickblast_25");
	level.epic = loadfx("test/epic2");
	level.fx_heliexplode = LoadFX( "explosions/tanker_explosion" );
	
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	
	//////////dvars/////////////////////////////
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	
	//////////////threads////////////////
	// thread fall();
	thread trap1();
	thread trap2();
	thread trap3();
	thread actitele1();
	thread actitele2();
	thread actitele3();
	thread trap4();
	thread actitele4();
	thread actitele5();
	thread actitele6();
	thread actitele7();
	thread trap5();
	thread trap5_short();
	thread trap6();
	thread trap7();
	thread trap7_teleport();
	thread trap7_teleport2();
	thread trap7_teleport3();
	thread trap8();
	thread main_door();
	/* [AUTO DELETE] thread Sniperroom(); */
	// thread blocks();
	// thread dunkroom();
	// thread dunk_jump_trig();
	// thread dunk_acti_trig();
	// thread dunk_move1();
	// thread dunk_move2();
	/* [AUTO DELETE] thread kniferoom(); */
	// thread truck();
	// thread weaproom();
	// thread roomhide();
	/* [AUTO DELETE] thread addTestClients(); */
	// thread dunktrigblock1();
	// thread dunktrigblock2();
	// thread terror();
	/* [AUTO DELETE] thread addTestClients(); */
	// thread onspawn();
	// thread WatchHelicopterTrigger();
	
	while( 1 )
	{
		level waittill( "player_spawn", player );
		//player thread effect();
	}

}


addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}



//////////////////////////////////////////////////////////////////////////////////


fall()
{
	death = getEnt ("death", "targetname");
	
	while(1)
	{
		death waittill ("trigger", player);
		player freezecontrols (1);
		player PlaySound("wtf");
		playFx( level.mortar, player.origin); 
		// Earthquake( 1, 1, player.origin, 500 );
		player suicide();
		player freezecontrols (0);
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap1()
{
	level endon("trigger");
	trig = getEnt ("trap1_trig", "targetname");

	trig waittill ("trigger", player);
	player PlaySound("box");
	trig delete();
	thread part1();
}


part1()
{
	trap1 = getEnt ("trap1", "targetname");
	death2 = getEnt ("death", "targetname");
	
	while (1)
	{
		trap1 rotateRoll (360,1);
		trap1 movez (192,0.5);
		trap1 waittill ("movedone");
		trap1 movez (-192,0.5);
		trap1 waittill ("movedone");
		trap1 movez (192,0.5);
		trap1 waittill ("movedone");
		trap1 movez (-192,0.5);
		trap1 waittill ("movedone");
		wait(0.1);
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap2()
{
	level endon("trigger");
	trig = getEnt ("trap2_trig", "targetname");
	trap2_hide = getEnt ("trap2_hide", "targetname");
	trap2_roll = getEnt ("trap2_roll", "targetname");

	trig waittill ("trigger", player);
	player PlaySound("box");
	trig delete();
	
	trap2_hide movez (-390,5);
	wait(5);
	trap2_hide hide();
	trap2_hide notSolid();	

	while (1)
	{
		trap2_roll rotateyaw (360, 4);
		wait 0.1;
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap3()
{
	level endon("trigger");
	trig = getEnt( "trap3_trig", "targetname" );
	trap3_easy = getEnt( "trap3_easy", "targetname" );
	trap3_easy2 = getEnt( "trap3_easy2", "targetname" );
	
	trig waittill( "trigger", player );
	player PlaySound("box");
	trig delete();
	
	trap3_easy movez(-400,4);
	trap3_easy2 movez(-400,4);
	wait 15;
	trap3_easy movez(400,4);
	trap3_easy2 movez(400,4);
	wait 6;
}



//////////////////////////////////////////////////////////////////////////////////


actitele1()
{
	acti_tele1=getent("acti_tele1","targetname");
	acti_p1=getent("acti_p1","targetname");
	while(1)
	{
		acti_tele1 waittill("trigger", player);
		player PlaySound("teleport");
		/* [AUTO DELETE] wait (0.5) ; */
		player FreezeControls(1);
		player SetOrigin( acti_p1.origin );
		player setplayerangles( acti_p1.angles );
		player FreezeControls(0);
	}
}



//////////////////////////////////////////////////////////////////////////////////


actitele2()
{
	acti_tele2=getent("acti_tele2","targetname");
	acti_p2=getent("acti_p2","targetname");
	while(1)
	{
		acti_tele2 waittill("trigger", player);
		player PlaySound("teleport");
		/* [AUTO DELETE] wait (0.5) ; */
		player FreezeControls(1);
		player SetOrigin( acti_p2.origin );
		player setplayerangles( acti_p2.angles );
		player FreezeControls(0);
	}
}



//////////////////////////////////////////////////////////////////////////////////


actitele3()
{
	acti_tele3=getent("acti_tele3","targetname");
	acti_p3=getent("acti_p3","targetname");
	while(1)
	{
		acti_tele3 waittill("trigger", player);
		player PlaySound("teleport");
		/* [AUTO DELETE] wait (0.5) ; */
		player FreezeControls(1);
		player SetOrigin( acti_p3.origin );
		player setplayerangles( acti_p3.angles );
		player FreezeControls(0);
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap4()
{
	level endon("trigger");
	trig4 = getent("trap4_trig", "targetname");
	trig4_a = getent("trap4_a", "targetname");
	trig4_b = getent("trap4_b", "targetname");
	trig4_c = getent("trap4_c", "targetname");
	trap4_1 = getent( "trap4_1", "targetname" );
	trap4_2 = getent( "trap4_2", "targetname" );
	trap4_3 = getent( "trap4_3", "targetname" );
	
	trig4_a enablelinkto();
	trig4_a linkto (trap4_1);
	trig4_b enablelinkto();
	trig4_b linkto (trap4_2);
	trig4_c enablelinkto();
	trig4_c linkto (trap4_3);

	trig4 waittill("trigger", player);
	player PlaySound("box");
	trig4 delete();
	
	while(1)
	{
		trap4_1 rotateroll (2280,1);
		trap4_1 movey (-860,1);
		trap4_2 rotateroll (2280,1);
		trap4_2 movey (-860,1);
		trap4_3 rotateroll (2280,1);
		trap4_3 movey (-860,1);
		wait(1);
		trap4_1 rotateroll (-2280,1);
		trap4_1 movey (860,1);
		trap4_2 rotateroll (-2280,1);
		trap4_2 movey (860,1);
		trap4_3 rotateroll (-2280,1);
		trap4_3 movey (860,1);
		wait(1);
	}
}



//////////////////////////////////////////////////////////////////////////////////


actitele4()
{
	opendoor=getent("opendoor","targetname");
	left_door=getent("left_door","targetname");
	right_door=getent("right_door","targetname");
	trig_move=getent("trig_move","targetname");
	move=getent("move","targetname");
	stop=getent("stop","targetname");
	block=getent("block","targetname");
	clip_move=getent("clip_move","targetname");
	kill=getent("elevator_kill","targetname");
	
	
	kill enablelinkto();
	kill linkto (move); 
	clip_move linkto (move);
	block notSolid();
	opendoor waittill("trigger", player);
	opendoor delete();
	left_door movex (16,1);
	right_door movex (16,1);
	wait(1);
	left_door movey (48,2);
	right_door movey (-48,2);
	wait(2);
	trig_move waittill("trigger", player);
	trig_move delete();
	block Solid();
	left_door movey (-48,2);
	right_door movey (48,2);
	wait(2);
	left_door movex (-16,0.5);
	right_door movex (-16,0.5);
	wait(2);
	left_door movey (1600,5);
	right_door movey (1600,5);
	move movey (1600,5);
	block movex (-32,1);
	wait(6);
	left_door movez (1120,5);
	right_door movez (1120,5);
	move movez (1120,5);
	wait(5);
	left_door movex (16,1);
	right_door movex (16,1);
	wait(1);
	left_door movey (48,2);
	right_door movey (-48,2);
	wait(2);
	stop waittill("trigger", player);
	stop delete();
	left_door movey (-48,2);
	right_door movey (48,2);
	wait(2);
	left_door movex (-16,0.5);
	right_door movex (-16,0.5);
	wait(1);
}



//////////////////////////////////////////////////////////////////////////////////


actitele5()
{
	acti_tele5=getent("acti_tele5","targetname");
	acti_p5=getent("acti_p5","targetname");
	while(1)
	{
		acti_tele5 waittill("trigger", player);
		player PlaySound("teleport");
		/* [AUTO DELETE] wait (0.5) ; */
		player FreezeControls(1);
		player SetOrigin( acti_p5.origin );
		player SetPlayerAngles((0,180,0));
		player FreezeControls(0);
	}
}



//////////////////////////////////////////////////////////////////////////////////


actitele6()
{
	acti_tele6=getent("acti_tele6","targetname");
	acti_p6=getent("acti_p6","targetname");
	while(1)
	{
		acti_tele6 waittill("trigger", player);
		player PlaySound("teleport");
		/* [AUTO DELETE] wait (0.5) ; */
		player FreezeControls(1);
		player SetOrigin( acti_p6.origin );
		player SetPlayerAngles((0,180,0));
		player FreezeControls(0);
	}
}



//////////////////////////////////////////////////////////////////////////////////


actitele7()
{
	acti_tele7=getent("acti_tele7","targetname");
	acti_p7=getent("acti_p7","targetname");
	while(1)
	{
		acti_tele7 waittill("trigger", player);
		player PlaySound("teleport");
		/* [AUTO DELETE] wait (0.5) ; */
		player FreezeControls(1);
		player SetOrigin( acti_p7.origin );
		player SetPlayerAngles((0,180,0));
		player FreezeControls(0);
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap5()
{
	level endon("trigger");
	trap5_1 = getent("trap5_1","targetname");
	trap5_2 = getent("trap5_2","targetname");
	trap5_3 = getent("trap5_3","targetname");
	trap5_4 = getent("trap5_4","targetname");
	trig5 = getent("trap5_trig", "targetname");
	
	trig5 waittill("trigger", player);
	player PlaySound("box");
	trig5 delete();
	
	while(1)
	{
		trap5_1 rotateyaw (360,10); 
		trap5_2 rotateyaw (360,10); 
		trap5_3 rotateyaw (360,10); 
		trap5_4 rotateyaw (360,10); 
		wait 1 ;
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap5_short()
{
	level endon("trigger");
	trap5 = getent("trap5_short","targetname");
	short_trig = getent("short_trig","targetname");
	
	
	trap5 hide();
	trap5 notSolid();
	
	short_trig waittill("trigger", player);
	player PlaySound("box");
	short_trig delete();
	
	trap5 Solid();
	trap5 show();
	wait 1 ;
}



//////////////////////////////////////////////////////////////////////////////////


trap6()
{
	level endon("trigger");
	death_trigger=getent("deathtrigger","targetname");
	trigger=getent("trap6_trig","targetname");
	death_trigger.dmg = 0;
	electrotimer=15;

	trigger waittill("trigger",player);
	player PlaySound("box");
	while(electrotimer>1)
	{
		death_trigger.dmg = 999;
		electrotimer--;
		playFx(level._effect["green"], (3512,256,1152));
		playFx(level._effect["red"], (3512,-64,1152));
		playFx(level._effect["green"], (3512,-384,1152));
		if(electrotimer<=1)
		{
			death_trigger.dmg = 0;
		}
		wait(1.1);
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap7()
{
	level endon("trigger");
	trigger = getent("trap7_trig","targetname");
	trap7_owned = getent("trap7_owned","targetname");
	trap7_tele = getent("trap7_tele","targetname");
	push = getent("push","targetname");
	room_dmg= getent("room_dmg","targetname");
	
	trap7_tele enablelinkto();
	trap7_tele linkto (trap7_owned);
	room_dmg enablelinkto();
	room_dmg linkto (push);
	
	trap7_owned hide();
	trap7_owned notSolid();
	
	trigger waittill("trigger", player);
	player PlaySound("box");
	trigger delete();
	
	trap7_owned movez (128,1);
	wait(1.1);
	trap7_owned show();
	wait(10);
	trap7_owned movez (-128,1);
	wait(1.1);
	trap7_owned hide();
	wait(4);
	push movey (464,20);
	wait(1);
}



//////////////////////////////////////////////////////////////////////////////////

trap7_teleport()
{
	level endon("trigger");
	trap7_tele = getent("trap7_tele","targetname");
	trap7_sp = getent("trap7_sp","targetname");
	while(1)
	{
		trap7_tele waittill("trigger", player);
		player FreezeControls(1);
		wait(5);
		player SetOrigin( trap7_sp.origin );
		player setplayerangles( trap7_sp.angles );
		wait(1);
		player FreezeControls(0);
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap7_teleport2()
{

	trap7_acmove = getEnt ( "trap7_acmove" , "targetname" );
	trap7_trig_map = getEnt ( "trap7_trig_map" , "targetname" );
	
	trap7_trig_map enablelinkto();
	trap7_trig_map linkto (trap7_acmove);
	
	while (1)
	{	
	trap7_acmove movex(1000,9);
	wait 0.5;
	trap7_acmove movex(-1000,9);
	wait 0.5;
	}

}



//////////////////////////////////////////////////////////////////////////////////


trap7_teleport3()
{
	level endon("trigger");
	trap7_trig_map=getent("trap7_trig_map","targetname");
	trap7_map2=getent("trap7_map2","targetname");
	{
		trap7_trig_map waittill("trigger", player);
		player SetOrigin( trap7_map2.origin );
		player setplayerangles( trap7_map2.angles );
	}
}



//////////////////////////////////////////////////////////////////////////////////


effect()
{	
	self endon( "death" );
	self endon( "disconnect" );

	oldPos = self.origin;
	while( self.sessionstate == "playing" )
	{
		wait 0.2;
		if( distance( oldPos, self.origin ) < 12 )
		{
			playFxOnTag( level.fx_redspawn, self, "j_spine" );
		}
		oldPos = self.origin;
	}
}



//////////////////////////////////////////////////////////////////////////////////


trap8()
{
	level endon("trigger");
	trap8_bomb=getent("trap8_bomb","targetname");
	trap8_bomb2=getent("trap8_bomb2","targetname");
	bomb_origin1=getent("bomb_origin1","targetname");
	bomb_origin2=getent("bomb_origin2","targetname");
	bomb_origin3=getent("bomb_origin3","targetname");
	bomb_origin4=getent("bomb_origin4","targetname");
	bomb_origin5=getent("bomb_origin5","targetname");
	bomb_origin6=getent("bomb_origin6","targetname");
	bomb_origin7=getent("bomb_origin7","targetname");
	bomb_origin8=getent("bomb_origin8","targetname");
	bomb_origin9=getent("bomb_origin9","targetname");
	bomb_origin10=getent("bomb_origin10","targetname");
	bomb_origin11=getent("bomb_origin11","targetname");
	bomb_origin12=getent("bomb_origin12","targetname");
	bomb_origin13=getent("bomb_origin13","targetname");
	bomb_origin14=getent("bomb_origin14","targetname");
	bomb_origin15=getent("bomb_origin15","targetname");
	bomb_origin16=getent("bomb_origin16","targetname");
	bomb_origin17=getent("bomb_origin17","targetname");
	bomb_origin18=getent("bomb_origin18","targetname");
	monkey_origin=getent("monkey_origin","targetname");
	monkey_right1=getent("monkey_right1","targetname");
	monkey_right2=getent("monkey_right2","targetname");
	monkey_right3=getent("monkey_right3","targetname");
	monkey_right4=getent("monkey_right4","targetname");
	monkey_right5=getent("monkey_right5","targetname");
	monkey_right6=getent("monkey_right6","targetname");
	monkey_centre1=getent("monkey_centre1","targetname");
	monkey_centre2=getent("monkey_centre2","targetname");
	monkey_centre3=getent("monkey_centre3","targetname");
	monkey_centre4=getent("monkey_centre4","targetname");
	monkey_centre5=getent("monkey_centre5","targetname");
	monkey_centre6=getent("monkey_centre6","targetname");
	monkey_left1=getent("monkey_left1","targetname");
	monkey_left2=getent("monkey_left2","targetname");
	monkey_left3=getent("monkey_left3","targetname");
	monkey_left4=getent("monkey_left4","targetname");
	monkey_left5=getent("monkey_left5","targetname");
	monkey_left6=getent("monkey_left6","targetname");
	trigger=getent("trap8_trig","targetname");
	trap8_bricks=getent("trap8_bricks","targetname");
	trap8_brickdam=getent("trap8_brickdam","targetname");
	trap8_normalglass=getent("trap8_normalglass","targetname");
	trap8_brokenglass=getent("trap8_brokenglass","targetname");

	trap8_brokenglass hide();
	trap8_brickdam hide();
	trap8_bomb2 hide();
	trap8_bomb2 notsolid();
	
	trap8_bomb enablelinkto();
	trap8_bomb linkto (trap8_bomb2);
	
	trigger waittill("trigger",player);
	player PlaySound("box");
	trigger delete();
	
	trap8_bomb2 movez(64,1);
	wait 1;
	monkey_origin playsound("monkey");
	monkey_origin delete();
	playFx(level.bomb, bomb_origin1.origin);
	playFx(level.bomb, bomb_origin2.origin);
	playFx(level.bomb, bomb_origin3.origin);
	playFx(level.bomb, bomb_origin4.origin);
	playFx(level.bomb, bomb_origin5.origin);
	playFx(level.bomb, bomb_origin6.origin);
	playFx(level.bomb, bomb_origin7.origin);
	playFx(level.bomb, bomb_origin8.origin);
	playFx(level.bomb, bomb_origin9.origin);
	playFx(level.bomb, bomb_origin10.origin);
	playFx(level.bomb, bomb_origin11.origin);
	playFx(level.bomb, bomb_origin12.origin);
	playFx(level.bomb, bomb_origin13.origin);
	playFx(level.bomb, bomb_origin14.origin);
	playFx(level.bomb, bomb_origin15.origin);
	playFx(level.bomb, bomb_origin16.origin);
	playFx(level.bomb, bomb_origin17.origin);
	playFx(level.bomb, bomb_origin18.origin);
	trap8_bricks hide();
	trap8_normalglass hide();
	trap8_brokenglass show();
	trap8_brickdam show();
	bomb_origin1 delete();
	bomb_origin2 delete();
	bomb_origin3 delete();
	bomb_origin4 delete();
	bomb_origin5 delete();
	bomb_origin6 delete();
	bomb_origin7 delete();
	bomb_origin8 delete();
	bomb_origin9 delete();
	bomb_origin10 delete();
	bomb_origin11 delete();
	bomb_origin12 delete();
	bomb_origin13 delete();
	bomb_origin14 delete();
	bomb_origin15 delete();
	bomb_origin16 delete();
	bomb_origin17 delete();
	bomb_origin18 delete();
	monkey_right1 hide();
	monkey_right2 hide();
	monkey_right3 hide();
	monkey_right4 hide();
	monkey_right5 hide();
	monkey_right6 hide();
	monkey_centre1 hide();
	monkey_centre2 hide();
	monkey_centre3 hide();
	monkey_centre4 hide();
	monkey_centre5 hide();
	monkey_centre6 hide();
	monkey_left1 hide();
	monkey_left2 hide();
	monkey_left3 hide();
	monkey_left4 hide();
	monkey_left5 hide();
	monkey_left6 hide();
	trap8_bomb2 movez(-64,1);
	wait 2;
}



//////////////////////////////////////////////////////////////////////////////////


main_door()
{	maindoor_broken  =getent( "maindoor_broken", "targetname" );
	spawn_whiteori  =getent( "spawn_whiteori", "targetname" );
	maindoor_remains  =getent( "maindoor_remains", "targetname" );
	meatboy_soundori =getent( "meatboy_soundori", "targetname" );
	fire1 =getent( "fire1", "targetname" );
	fire2 =getent( "fire2", "targetname" );
	fire3 =getent( "fire3", "targetname" );
	fire4 =getent( "fire4", "targetname" );
	fire5 =getent( "fire5", "targetname" );
	fire6 =getent( "fire6", "targetname" );
	brick1 =getent( "brick1", "targetname" );
	brick2 =getent( "brick2", "targetname" );
	floorfire1 =getent( "floorfire1", "targetname" );
	floorfire2 =getent( "floorfire2", "targetname" );
	boomsoundori =getent( "boomsoundori", "targetname" ); 
	flamesound1 =getent( "flamesound1", "targetname" ); 
	flamesound2 =getent( "flamesound2", "targetname" );
	terror =getent( "terror", "targetname" ); 
	/* [AUTO DELETE] sniperroom =getent( "sniperroom", "targetname" ); */ 
	
	maindoor_remains hide();
	terror hide();
	
	meatboy_soundori playsound("meatboy");
	wait 2;
	playFx(level.fire, fire1.origin);
	playFx(level.fire, fire2.origin);
	playFx(level.fire, fire3.origin);
	boomsoundori playsound("rock");
	// EarthQuake( 1, 1, boomsoundori.origin, 2000 );
	playFx(level.boom, fire4.origin);
	playFx(level.boom, fire5.origin);
	playFx(level.boom, fire6.origin);
	maindoor_broken hide();
	maindoor_broken notsolid();
	maindoor_remains show();
	terror show();
	wait 0.5;
	playFx(level.brick, brick1.origin);
	playFx(level.brick, brick2.origin);
	playFx(level.floorfire, floorfire1.origin);
	playFx(level.floorfire, floorfire2.origin);
	flamesound1 playsound("fire");
	flamesound2 playsound("fire");
	/* [AUTO DELETE] ambientPlay("ambient5"); */
	wait 2;
}

	
	
//////////////////////////////////////////////////////////////////////////////////


Sniperroom()
{
	level.trig_sniper = getEnt( "trig_sniper", "targetname");
	snip_jump = getEnt( "snip_jump", "targetname" );
	snip_acti = getEnt( "snip_acti", "targetname" );
	
	while(1)
	{
		level.trig_sniper waittill( "trigger", player );
		if( !isDefined( level.trig_sniper ) )
			return;
		
			thread dunkroomdel();
			thread kniferoomdel();
			thread weaproomdel();
			thread heliroomdel();
			
		/* [AUTO DELETE] //AmbientPlay( "friend" ); */
		player FreezeControls(1);
		player setplayerangles( snip_jump.angles );
		player setOrigin( snip_jump.origin );
		/* [AUTO DELETE] player TakeAllWeapons(); */
		/* [AUTO DELETE] player GiveWeapon( "remington700_mp" ); */
		/* [AUTO DELETE] player giveMaxAmmo( "remington700_mp" ); */
		level.activ FreezeControls(1);
		level.activ setPlayerangles( snip_acti.angles );
		level.activ setOrigin( snip_acti.origin );
		/* [AUTO DELETE] level.activ TakeAllWeapons(); */
		/* [AUTO DELETE] level.activ GiveWeapon( "remington700_mp" ); */
		/* [AUTO DELETE] level.activ GiveMaxAmmo( "remington700_mp" ); */
		wait 0.05;
		/* [AUTO DELETE] player switchToWeapon( "remington700_mp" ); */
		/* [AUTO DELETE] level.activ SwitchToWeapon( "remington700_mp" ); */
		/* [AUTO DELETE] iPrintlnBold( " ^7" + player.name + " has entered ^5S^7niper ^5R^7oom^5!!" ); */
		wait 5;
		player FreezeControls(0);
		level.activ FreezeControls(0);
		/* [AUTO DELETE] player iprintlnbold("^5F^7IGHT^5!!"); */
		/* [AUTO DELETE] level.activ iprintlnbold("^5F^7IGHT^5!!"); */
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}



//////////////////////////////////////////////////////////////////////////////////


blocks()
{
	trig_actiblock = getEnt( "trig_actiblock", "targetname" );
	block1 = getEnt( "block1", "targetname" );
	block2 = getEnt( "block2", "targetname" );
	block3 = getEnt( "block3", "targetname" );
	
	trig_actiblock waittill( "trigger", player );
	trig_actiblock delete();
	
	wait 2;
	block1 movey(-432,4);
	block2 movez(-384,4);
	block3 movey(432,4);
	wait 5;
}


//////////////////////////////////////////////////////////////////////////////////


dunkroomdel()
{

	dunk_portal = getent("dunk_portal","targetname");
	level.trig_dunk = getent("trig_dunk","targetname");
	dunk_portalfx = getent("dunk_portalfx","targetname");
	dunk_portalbroken = getent("dunk_portalbroken","targetname");

	playFx(level.bomb, dunk_portalfx.origin);
	dunk_portal hide();
	dunk_portalbroken show();
	dunk_portalfx delete();
	level.trig_dunk delete();
}


//////////////////////////////////////////////////////////////////////////////////


sniperroomdel()
{

	sniper_portal = getent("sniper_portal","targetname");
	level.trig_sniper = getent("trig_sniper","targetname");
	sniper_portalfx = getent("sniper_portalfx","targetname");
	sniper_portalbroken = getent("sniper_portalbroken","targetname");

	playFx(level.bomb, sniper_portalfx.origin);
	sniper_portal hide();
	sniper_portalbroken show();
	sniper_portalfx delete();
	level.trig_sniper delete();
}


//////////////////////////////////////////////////////////////////////////////////


weaproomdel()
{

	weap_portal = getent("weap_portal","targetname");
	level.trig_weap = getent("trig_weap","targetname");
	weap_portalfx = getent("weap_portalfx","targetname");
	weap_portalbroken = getent("weap_portalbroken","targetname");

	playFx(level.bomb, weap_portalfx.origin);
	weap_portal hide();
	weap_portalbroken show();
	weap_portalfx delete();
	level.trig_weap delete();
}


//////////////////////////////////////////////////////////////////////////////////


kniferoomdel()
{

	knife_portal = getent("knife_portal","targetname");
	level.trig_knife = getent("trig_knife","targetname");
	knife_portalfx = getent("knife_portalfx","targetname");
	knife_portalbroken = getent("knife_portalbroken","targetname");

	knife_portalbroken hide();

	playFx(level.bomb, knife_portalfx.origin);
	knife_portal hide();
	knife_portalbroken show();
	knife_portalfx delete();
	level.trig_knife delete();
}


//////////////////////////////////////////////////////////////////////////////////


heliroomdel()
{

	heli_portal = getent("heli_portal","targetname");
	level.trig_heli = getent("trig_heli","targetname");
	heli_portalfx = getent("heli_portalfx","targetname");
	heli_portalbroken = getent("heli_portalbroken","targetname");

	heli_portalbroken hide();

	playFx(level.bomb, heli_portalfx.origin);
	heli_portal hide();
	heli_portalbroken show();
	heli_portalfx delete();
	level.trig_heli delete();
}


//////////////////////////////////////////////////////////////////////////////////


dunkroom()
{
	// level.trig_dunk = getEnt( "trig_dunk", "targetname");
	// dunk_actitele = getEnt( "dunk_actitele", "targetname" );
	// dunk_jumptele = getEnt( "dunk_jumptele", "targetname" );
	// dunk_target_block=getent("dunk_target_block","targetname"); 
	
	// while(1)
	// {
	// 	level.trig_dunk waittill( "trigger", player );
	// 	if( !isDefined( level.trig_dunk ) )
	// 		return;
		
	// 	thread sniperroomdel();
	// 	thread kniferoomdel();
	// 	thread weaproomdel();
	// 	thread heliroomdel();
		
	// 	dunk_target_block notsolid();
	// 	player FreezeControls(1);
	// 	player SetPlayerAngles( dunk_jumptele.angles );
	// 	player setOrigin( dunk_jumptele.origin );
	// 	/* [AUTO DELETE] player TakeAllWeapons(); */
	// 	/* [AUTO DELETE] player GiveWeapon( "colt45_mp" ); */
	// 	 [AUTO DELETE] player giveMaxAmmo( "colt45_mp" ); 
	// 	level.activ setPlayerangles( dunk_actitele.angles );
	// 	level.activ setOrigin( dunk_actitele.origin );
	// 	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
	// 	/* [AUTO DELETE] level.activ GiveWeapon( "colt45_mp" ); */
	// 	/* [AUTO DELETE] level.activ GiveMaxAmmo( "colt45_mp" ); */
	// 	player FreezeControls(0);
	// 	/* [AUTO DELETE] wait 0.05; */
	// 	/* [AUTO DELETE] player switchToWeapon( "colt45_mp" ); */
	// 	/* [AUTO DELETE] level.activ SwitchToWeapon( "colt45_mp" ); */
	// 	/* [AUTO DELETE] iPrintlnBold( " ^7" + player.name + " ^7has entered ^5D^7unk ^5R^7oom^5!!" ); */	
 //                                     while( isAlive( player ) && isDefined( player ) )
	// 		/* [AUTO DELETE] wait 5; */
	// }
}



//////////////////////////////////////////////////////////////////////////////////


kniferoom()
{
	// level.trig_knife = getEnt( "trig_knife", "targetname");
	// knife_jump = getEnt( "knife_jumper", "targetname" );
	// knife_acti = getEnt( "knife_acti", "targetname" );
	
	// while(1)
	// {
	// 	level.trig_knife waittill( "trigger", player );
	// 	if( !isDefined( level.trig_knife ) )
	// 		return;
		
	// 	thread sniperroomdel();
	// 	thread dunkroomdel();
	// 	thread weaproomdel();
	// 	thread heliroomdel();
		
	// 	/* [AUTO DELETE] //AmbientPlay( "friend" ); */
	// 	player FreezeControls(1);
	// 	player SetPlayerAngles( knife_jump.angles );
	// 	player setOrigin( knife_jump.origin );
	// 	/* [AUTO DELETE] player TakeAllWeapons(); */
	// 	/* [AUTO DELETE] player GiveWeapon( "tomahawk_mp" ); */	
	// 	/* [AUTO DELETE] player GiveWeapon( "deserteagle_mp" ); */	
	// 	player setWeaponAmmoClip( "deserteagle_mp", 0 );
	// 	player setweaponammostock( "deserteagle_mp", 0 );
	// 	level.activ FreezeControls(1);
	// 	level.activ setPlayerangles( knife_acti.angles );
	// 	level.activ setOrigin( knife_acti.origin );
	// 	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
	// 	/* [AUTO DELETE] level.activ GiveWeapon( "tomahawk_mp" ); */	
	// 	/* [AUTO DELETE] level.activ GiveWeapon( "deserteagle_mp" ); */	
	// 	level.activ setWeaponAmmoClip( "deserteagle_mp", 0 );
	// 	level.activ setweaponammostock( "deserteagle_mp", 0 );		
	// 	wait 0.05;
	// 	/* [AUTO DELETE] player switchToWeapon( "deserteagle_mp" ); */
	// 	/* [AUTO DELETE] level.activ SwitchToWeapon( "deserteagle_mp" ); */
	// 	/* [AUTO DELETE] iPrintlnBold( " ^7" + player.name + " ^7has entered ^5K^7nife ^5R^7oom^5!!" ); */	
	// 	wait 5;
	// 	player FreezeControls(0);
	// 	level.activ FreezeControls(0);
	// 	/* [AUTO DELETE] player iprintlnbold("^5F^7IGHT^5!!"); */
	// 	/* [AUTO DELETE] level.activ iprintlnbold("^5F^7IGHT^5!!"); */
	// 	while( isAlive( player ) && isDefined( player ) )
	// 		wait 1;
	// }
}



//////////////////////////////////////////////////////////////////////////////////


dunk_jump_trig()
{
	dunk_trig_jumper=getent("dunk_trig_jumper","targetname");
	dunk_judoor=getent("dunk_judoor","targetname");
	
	while(1)
	{
		dunk_trig_jumper waittill("trigger", player);
		//player braxi\_rank::giveRankXP("kill",100); //Change number of xp u want to earn
		/* [AUTO DELETE] player iPrintLnBold("^5P^7erfect ^5S^7hot."); */
		/* [AUTO DELETE] iPrintLnBold("^5A^7ctivator ^5G^7oing ^5D^7own^5!!"); */
		dunk_judoor notsolid();
		wait 1 ;
		dunk_judoor solid();
	}
}



//////////////////////////////////////////////////////////////////////////////////


dunk_acti_trig()
{
	dunk_trig_acti=getent("dunk_trig_acti","targetname");
	dunk_acdoor=getent("dunk_acdoor","targetname");
	
	while(1)
	{
		dunk_trig_acti waittill("trigger", player);
		//player braxi\_rank::giveRankXP("kill",100); //Change number of xp u want to earn
		/* [AUTO DELETE] player iPrintLnBold("^5P^7erfect ^5S^7hot."); */
		/* [AUTO DELETE] iPrintLnBold("^5J^7umper ^5G^7oing ^5D^7own^5!!"); */
		dunk_acdoor notsolid();
		wait 2 ;
		dunk_acdoor solid();
	}
}



//////////////////////////////////////////////////////////////////////////////////


dunk_move1()
{

	dunk_acmove = getEnt ( "dunk_acmove" , "targetname" );
	trig_acti = getEnt ( "dunk_trig_acti" , "targetname" );
	
	trig_acti enablelinkto();
	trig_acti linkto (dunk_acmove);
	
	while (1)
	{	
	dunk_acmove movey(800,9);
	wait 0.5;
	dunk_acmove movey(-800,9);
	wait 0.5;
	}

}



//////////////////////////////////////////////////////////////////////////////////


dunk_move2()
{

	dunk_acmove2 = getEnt ( "dunk_acmove2" , "targetname" );
	trig_jumper = getEnt ( "dunk_trig_jumper" , "targetname" );
	
	trig_jumper enablelinkto();
	trig_jumper linkto (dunk_acmove2);
	
	while (1)
	{	
	dunk_acmove2 movey(800,9);
	wait 0.5;
	dunk_acmove2 movey(-800,9);
	wait 0.5;
	}

}



//////////////////////////////////////////////////////////////////////////////////


truck()
{

	truck1 = getent("truck1","targetname");
	truck_back = getent("truck_back","targetname");
	
	while (1)
	{	
	truck1 movex(7000,30);
	wait 31;
	truck1 rotateyaw (-45,2);
	wait 2;
	truck1 movex(100,2);
	wait 2;
	truck1 rotateyaw (-45,2);
	wait 2;
	truck1 movey(-5200,30);
	wait 31;
	truck1 rotateyaw (-90,2);
	truck1 movex(-7600,30);
	wait 31;
	truck1 rotateyaw (-90,2);
	wait 2;
	truck1 movey(5100,30);
	wait 31;
	truck1 rotateyaw (-90,2);
	truck1 MoveTo( truck_back.origin, 5 );
	wait 5;
	}
}



//////////////////////////////////////////////////////////////////////////////////


weaproom()
{
	// level.trig_weap = getEnt( "trig_weap", "targetname");
	// weap_jump = getEnt( "weap_jumper", "targetname" );
	// weap_acti = getEnt( "weap_acti", "targetname" );
	
	// while(1)
	// {
	// 	level.trig_weap waittill( "trigger", player );
	// 	if( !isDefined( level.trig_weap ) )
	// 		return;
		
	// 	thread sniperroomdel();
	// 	thread dunkroomdel();
	// 	thread kniferoomdel();
	// 	thread heliroomdel();
		
	// 	/* [AUTO DELETE] //AmbientPlay( "friend" ); */
	// 	player FreezeControls(1);
	// 	player SetPlayerAngles( weap_jump.angles );
	// 	player setOrigin( weap_jump.origin );
	// 	/* [AUTO DELETE] player TakeAllWeapons(); */
	// 	/* [AUTO DELETE] player GiveWeapon( "ak74u_mp" ); */		
	// 	level.activ FreezeControls(1);
	// 	level.activ setPlayerangles( weap_acti.angles );
	// 	level.activ setOrigin( weap_acti.origin );
	// 	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
	// 	/* [AUTO DELETE] level.activ GiveWeapon( "ak74u_mp" ); */		
	// 	/* [AUTO DELETE] wait 0.05; */
	// 	/* [AUTO DELETE] player switchToWeapon( "ak74u_mp" ); */
	// 	/* [AUTO DELETE] level.activ SwitchToWeapon( "ak74u_mp" ); */
	// 	/* [AUTO DELETE] iPrintlnBold( " ^7" + player.name + " ^7has entered ^5W^7eapon ^5R^7oom^5!!" ); */	
	// 	/* [AUTO DELETE] wait 5; */
	// 	player FreezeControls(0);
	// 	level.activ FreezeControls(0);
	// 	/* [AUTO DELETE] player iprintlnbold("^5F^7IGHT^5!!"); */
	// 	/* [AUTO DELETE] level.activ iprintlnbold("^5F^7IGHT^5!!"); */
	// 	while( isAlive( player ) && isDefined( player ) )
	// 		/* [AUTO DELETE] wait 1; */
	// }
}



//////////////////////////////////////////////////////////////////////////////////


roomhide()
{
	dunk_portalbroken = getent("dunk_portalbroken","targetname");
	sniper_portalbroken = getent("sniper_portalbroken","targetname");
	weap_portalbroken = getent("weap_portalbroken","targetname");
	knife_portalbroken = getent("knife_portalbroken","targetname");
	heli_portalbroken = getent("heli_portalbroken","targetname");

	heli_portalbroken hide();
	knife_portalbroken hide();
	weap_portalbroken hide();
	sniper_portalbroken hide();
	dunk_portalbroken hide();
}



//////////////////////////////////////////////////////////////////////////////////


WatchHelicopterTrigger()
{
	trig = getEnt( "trigger_helicopter", "targetname" );
	
	while(1)
	{
		trig waittill( "trigger", player );
		//if( GetTeamPlayersAlive( "allies" ) > 1 )
			//continue;
		player thread StartHelicopter();
		level.activ thread StartHelicopter();
		/* [AUTO DELETE] iPrintlnBold( "^1>> ^2" + player.name + " has chosen ^1Helicopter War!" ); */
		wait 2;
		/* [AUTO DELETE] iPrintlnBold( "^1FIGHT!" ); */
		break;
	}
}


StartHelicopter()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	if( !isDefined( self ) || !isAlive( self ) || !isPlayer( self ) )
		return;
	
	path = [];
	orig = getEntArray();
	if( self.pers["team"] == "allies" )
	{
		start = getEnt( "orig_heli_jumper_spawn", "targetname" );
		for(i=0;i<orig.size;i++)
		{
			if( isDefined( orig[i].targetname ) && IsSubStr( orig[i].targetname, "orig_heli_jumper"+path.size ) )
			{
				path[path.size] = orig[i];
				path[path.size-1].waittime = int( strTok( orig[i].targetname, "_" )[3] );
			}
		}
	}
	else
	{
		start = getEnt( "orig_heli_acti_spawn", "targetname" );
		for(i=0;i<orig.size;i++)
		{
			if( isDefined( orig[i].targetname ) && IsSubStr( orig[i].targetname, "orig_heli_acti"+path.size ) )
			{
				path[path.size] = orig[i];
				path[path.size-1].waittime = int( strTok( orig[i].targetname, "_" )[3] );
			}
		}
	}
	chopper = spawn_helicopter( self, start.origin, start.angles, "cobra_mp", "vehicle_blackhawk" );
	/* [AUTO DELETE] wait 0.05; */
	chopper.owner = self;
	chopper playLoopSound( "mp_cobra_helicopter" );
	chopper.linker = Spawn( "script_model", chopper GetTagOrigin( "tag_guy4" )-(0,0,20) );
	chopper.linker LinkTo( chopper );
	chopper setDamageStage( 3 );
	chopper setCanDamage( 1 );
	chopper.maxhealth = 5000;
	chopper.health = chopper.maxhealth;
	chopper setSpeed( 40, 15 );
	chopper setYawSpeed( 50, 20, 20 );
	chopper SetMaxPitchRoll( 30, 30 );
	chopper setNearGoalNotifyDist( 96 );
	chopper thread DamageMonitor();
	chopper endon( "crashed" );
	
	pathnum = 0;
	
	self setOrigin( chopper.linker.origin );
	self LinkTo( chopper.linker );
	/* [AUTO DELETE] self TakeAllWeapons(); */
	/* [AUTO DELETE] self GiveWeapon( "m14_reflex_mp" ); */
	/* [AUTO DELETE] self GiveMaxAmmo( "m14_reflex_mp" ); */
	self SetSpawnWeapon( "m14_reflex_mp" );
	self.maxhealth = 200;
	self.health = self.maxhealth;
	
	while( isDefined( self ) && isAlive( self ) )
	{
		/* [AUTO DELETE] wait 0.1; */
		chopper SetVehGoalPos( path[pathnum].origin+(0,0,120), 1 );
		chopper setGoalYaw( path[pathnum].angles[2] );
		chopper waittill( "near_goal" );
		/* [AUTO DELETE] wait int(path[pathnum].waittime); */
		pathnum++;
		if( pathnum >= path.size )
			pathnum = 0;
	}
	if( !isDefined( self ) || !isAlive( self ) )
		chopper notify( "damage", 3000, undefined );
}


DamageMonitor()
{
	while( isDefined( self.owner ) )
	{
		self waittill( "damage", dmg, attacker );
		self.health -= dmg;
		self.attacker = attacker;
		
		if( self.health >= 2000 && self.health < 3000 )
			self SetDamageStage( 2 );
		else if( self.health >= 1000 && self.health < 2000 )
			self SetDamageStage( 1 );
		else if( self.health < 1000 )
			self SetDamageStage( 0 );
		
		if( self.health <= 0 )
			break;
	}
	if( isDefined( self.owner ) )
		self.owner UnLink();
	
	// EarthQuake( 1.5, 1, self.origin, 1200 );
	self PlaySound( "exp_suitcase_bomb_main" );
	PlayFX( level.fx_heliexplode, self.origin-(0,0,60) );
	RadiusDamage( self.origin, 600, 500, 80, self.attacker );
	self.linker delete();
	self notify( "crashed" );
	self delete();
	/* [AUTO DELETE] //iPrintlnBold( "Helicopter is dead!" ); */
}


spawn_helicopter( owner, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	return chopper;
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
			/* [AUTO DELETE] println("Could not add test client"); */
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



//////////////////////////////////////////////////////////////////////////////////


dunktrigblock1()
{
	dunk_target_block=getent("dunk_target_block","targetname");
	dunk_trig_acti=getent("dunk_trig_acti","targetname");
	
	dunk_target_block notsolid();
	dunk_target_block hide();
	
	while(1)
	{
	dunk_trig_acti waittill("trigger", player);
	dunk_target_block solid();
	wait 1;	
	}
}



//////////////////////////////////////////////////////////////////////////////////


dunktrigblock2()
{
	dunk_target_block=getent("dunk_target_block","targetname");
	dunk_trig_jumper=getent("dunk_trig_jumper","targetname");
	
	dunk_target_block notsolid();
	dunk_target_block hide();
	
	while(1)
	{
	dunk_trig_jumper waittill("trigger", player);
	dunk_target_block solid();
	wait 1;
	}
}



//////////////////////////////////////////////////////////////////////////////////


terror()
{

	terror = getEnt ( "terror" , "targetname" );
	
	wait 35;
	terror rotateyaw (180,5);
	wait 6;
}



//////////////////////////////////////////////////////////////////////////////////


onSpawn()
{
	while(1)
	{
		level waittill( "player_spawn", player );
		player thread AfterFrame();
	}
}


AfterFrame()
{
	self endon( "disconnect" );
	
	waittillframeend;
	self detachAll();
	self setModel( "bear_stickman_red" );
	self SetViewModel( "viewhands_bear_stickman_red" );
}
