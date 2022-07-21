/*                                      
MMMMMMM MMMMMM  MMMMMM  MMMMMM   MMMMMM8  MMMMMM  
  MMI   MMOII7 .MM  MM  MM. MM  MM    MM  MM .MM  
  MM    MM=     MM MM   MM MM   MM   .MM  MM MM   
  MM    MMMMMM  MM MMM .MM DMM   MMMMMM   MM :MM 
*/

main()
{
trigger = spawn( "trigger_radius", (6840, 506, -821), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;
	maps\mp\_load::main();
	
	addTriggerToList( "trap1_trig" );
    addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
    addTriggerToList( "trap4_trig" );
	addTriggerToList( "trap5_trig" );
    addTriggerToList( "trap6_trig" );
	addTriggerToList( "trap7_trig" );
	
	setExpFog(600, 600, 0, 0, 0, 0);
	level.laser = loadfx("rock/laser_center");
	level._effect["blinking"] = LoadFX( "rock/blinking_light" );
	level.explosion = LoadFX( "explosions/aerial_explosion" );
	level.boom = loadfx("explosions/airlift_explosion_large");
	level.smoke = loadfx("smoke/ic_grnd_smoke");
	level.brick = loadfx("test/brickblast_25");
	level.actifire = loadfx("rock/acti_fire");
	level._effect["orb"] = LoadFX( "rock/rock_light" );
	
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
	
		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createEndMap((-815.254, 4860.54, 305.192), 0, 275, 10);
	// thread sr\api\_speedrun::createTeleporter((3007, 492, -724), 70, 90, (3982, 491, -740), 359 , "freeze", "red", "normal_0");
	
	
	//////////////threads////////////////
//	thread laser();
	thread main_fall();
	thread addBlinkingLight();
//	thread trap1();
//	thread trap2();
//	thread move();
//	thread trap3();
//	thread trap4();
//	thread trap5();
//	thread trap6();
//	thread trap7();
    thread addorb();
//	thread oldtele();
//	thread oldrotation();
//	thread printCredits();
	thread onConnected();
//	thread mazerotation();
//	thread mazeroom();
//	thread maze_wall();
//	thread sniprotation();
//	thread Sniperroom();
    thread fuck_you();
}

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}


//////////////////////////////////////////////////////////////////////////////////


laser()
{
	laser_ori =getent( "laser_ori", "targetname" );
	fall_sound=getent("fall_sound","targetname");
	
	wait 1;
	playFx(level.laser, laser_ori.origin);
	playFx(level.smoke, fall_sound.origin);
	wait 1;
}


//////////////////////////////////////////////////////////////////////////////////


addBlinkingLight()
{
	ent = getEntArray("org_light", "targetname");
	
	for(i=0;i<ent.size;i++)
	{
		blink = maps\mp\_utility::createOneshotEffect( "blinking" );
		blink.v[ "origin" ] = ent[i].origin;
		blink.v[ "angles" ] = ( 270, 0, 0 );
		blink.v[ "fxid" ] = "blinking";
		blink.v[ "delay" ] = -15;
	}
}


//////////////////////////////////////////////////////////////////////////////////


main_fall()
{
	broken=getent("broken","targetname");
	floor_good=getent("floor_good","targetname");
	trig_broken=getent("trig_broken","targetname");
	fall_sound=getent("fall_sound","targetname");
	boom1=getent("boom1","targetname");
	boom2=getent("boom2","targetname");
	boom3=getent("boom3","targetname");
	boom4=getent("boom4","targetname");
	boom5=getent("boom5","targetname");

	broken hide();
	broken notsolid();
	
	
	trig_broken delete();
	
	
	floor_good hide();
	floor_good notsolid();
	broken show();
	broken solid();
}


//////////////////////////////////////////////////////////////////////////////////


trap1()
{
	trap1_trig = getEnt("trap1_trig", "targetname");
	trap1_ori = getEnt("trap1_ori", "targetname");
	//
	trap1_abomb1 = getEnt("trap1_abomb1", "targetname");
	trap1_abomb2 = getEnt("trap1_abomb2", "targetname");
	trap1_abomb3 = getEnt("trap1_abomb3", "targetname");
	trap1_abomb4 = getEnt("trap1_abomb4", "targetname");
	trap1_abomb5 = getEnt("trap1_abomb5", "targetname");
	trap1_abomb6 = getEnt("trap1_abomb6", "targetname");
	trap1_abomb7 = getEnt("trap1_abomb7", "targetname");
	trap1_a1 = getEnt("trap1_a1", "targetname");
	trap1_a2 = getEnt("trap1_a2", "targetname");
	trap1_a3 = getEnt("trap1_a3", "targetname");
	trap1_a4 = getEnt("trap1_a4", "targetname");
	trap1_a5 = getEnt("trap1_a5", "targetname");
	trap1_a6 = getEnt("trap1_a6", "targetname");
	trap1_a7 = getEnt("trap1_a7", "targetname");
	//
	trap1_bbomb1 = getEnt("trap1_bbomb1", "targetname");
	trap1_bbomb2 = getEnt("trap1_bbomb2", "targetname");
	trap1_bbomb3 = getEnt("trap1_bbomb3", "targetname");
	trap1_bbomb4 = getEnt("trap1_bbomb4", "targetname");
	trap1_bbomb5 = getEnt("trap1_bbomb5", "targetname");
	trap1_b1 = getEnt("trap1_b1", "targetname");
	trap1_b2 = getEnt("trap1_b2", "targetname");
	trap1_b3 = getEnt("trap1_b3", "targetname");
	trap1_b4 = getEnt("trap1_b4", "targetname");
	trap1_b5 = getEnt("trap1_b5", "targetname");

	trap1_trig waittill("trigger");
	trap1_trig delete();
	playFx(level.actifire, trap1_ori.origin);

	possibility = randomIntRange(0,2);
	if(possibility == 0)
	{
		playFx(level.explosion, trap1_abomb1.origin);
		trap1_abomb1 playsound("explo_detpack_main2");
		trap1_a1 hide();
		trap1_a1 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_abomb2.origin);
		trap1_abomb2 playsound("explo_detpack_main2");
		trap1_a2 hide();
		trap1_a2 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_abomb3.origin);
		trap1_abomb3 playsound("explo_detpack_main2");
		trap1_a3 hide();
		trap1_a3 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_abomb4.origin);
		trap1_abomb4 playsound("explo_detpack_main2");
		trap1_a4 hide();
		trap1_a4 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_abomb5.origin);
		trap1_abomb5 playsound("explo_detpack_main2");
		trap1_a5 hide();
		trap1_a5 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_abomb6.origin);
		trap1_abomb6 playsound("explo_detpack_main2");
		trap1_a6 hide();
		trap1_a6 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_abomb7.origin);
		trap1_abomb7 playsound("explo_detpack_main2");
		trap1_a7 hide();
		trap1_a7 notSolid();
	}
	
	if(possibility == 1)
	
	{
		playFx(level.explosion, trap1_bbomb1.origin);
		trap1_bbomb1 playsound("explo_detpack_main2");
		trap1_b1 hide();
		trap1_b1 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_bbomb2.origin);
		trap1_bbomb2 playsound("explo_detpack_main2");
		trap1_b2 hide();
		trap1_b2 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_bbomb3.origin);
		trap1_bbomb3 playsound("explo_detpack_main2");
		trap1_b3 hide();
		trap1_b3 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_bbomb4.origin);
		trap1_bbomb4 playsound("explo_detpack_main2");
		trap1_b4 hide();
		trap1_b4 notSolid();
		wait 0.5;
		playFx(level.explosion, trap1_bbomb5.origin);
		trap1_bbomb5 playsound("explo_detpack_main2");
		trap1_b5 hide();
		trap1_b5 notSolid();
	}
}


//////////////////////////////////////////////////////////////////////////////////


trap2()
{
	trap2_rotate = getent("trap2_rotate","targetname");
	trap2_trig = getent("trap2_trig","targetname");
	trap2_ori = getent("trap2_ori","targetname");
	
	trap2_trig waittill("trigger");
	trap2_trig delete();
	playFx(level.actifire, trap2_ori.origin);
	
	while(1)
	{
		trap2_rotate rotatepitch (-720,3.5);
		wait 1 ;
	}
}


//////////////////////////////////////////////////////////////////////////////////


move()
{
	move_trig = getent("move_trig","targetname");
	move = getent("move","targetname");
	
	move_trig waittill("trigger");
	move_trig delete();
	
	while(1)
	{
		move movex(704,6);
		wait 7 ;
		move movex(-704,6);
		wait 7;
	}
}


//////////////////////////////////////////////////////////////////////////////////


trap3()
{
	trap3_a = getent("trap3_a","targetname");
	trap3_b = getent("trap3_b","targetname");
	trap3_ahurt = getent("trap3_ahurt","targetname");
	trap3_bhurt = getent("trap3_bhurt","targetname");
	trap3_trig = getent("trap3_trig","targetname");
	trap3_boom = getent("trap3_boom","targetname");
	trap3_ori = getent("trap3_ori","targetname");
	
	trap3_ahurt enablelinkto();
	trap3_ahurt linkto (trap3_a);
	//
	trap3_bhurt enablelinkto();
	trap3_bhurt linkto (trap3_b);
	
	trap3_trig waittill("trigger");
	trap3_trig delete();
	playFx(level.actifire, trap3_ori.origin);
	
	trap3_a movey(-264,1);
	trap3_b movey(264,1);
	wait 1;
	EarthQuake( 1, 1, trap3_boom.origin, 600 );
	wait 2;
	trap3_a movey(264,2);
	trap3_b movey(-264,2);
	wait 3;
}


//////////////////////////////////////////////////////////////////////////////////

trap4()
{
	trap4_trig = getEnt("trap4_trig", "targetname");
	trap4_ori = getEnt("trap4_ori", "targetname");
	trap4_boom1 = getEnt("trap4_boom1", "targetname");
	trap4_broken = getEnt("trap4_broken", "targetname");
	trap4_good = getEnt("trap4_good", "targetname"); 

	trap4_broken hide();
	trap4_broken notsolid();
	
	trap4_trig waittill("trigger");
	trap4_trig delete();
	playFx(level.actifire, trap4_ori.origin);

	playFx(level.boom, trap4_boom1.origin);
	trap4_boom1 playsound("rock");
	trap4_good hide();
	trap4_good notSolid();
	trap4_broken show();
	trap4_broken solid();
	wait 1;
}


//////////////////////////////////////////////////////////////////////////////////


trap5()
{
	trap5_trig = getent("trap5_trig","targetname");
	trap5 = getent("trap5","targetname");
	trap5_ori = getEnt("trap5_ori", "targetname");
	
	trap5_trig waittill("trigger");
	trap5_trig delete();
	playFx(level.actifire, trap5_ori.origin);
	
	trap5 movez(-244,1);
	wait 5 ;
	trap5 movez(244,2);
	wait 3;
}


//////////////////////////////////////////////////////////////////////////////////


trap6()
{
	trap6_trig = getent("trap6_trig","targetname");
	trap6_1 = getent("trap6_1","targetname");
	trap6_2 = getent("trap6_2","targetname");
	trap6_3 = getent("trap6_3","targetname");
	trap6_4 = getent("trap6_4","targetname");
	trap6_5 = getent("trap6_5","targetname");
	trap6_6 = getent("trap6_6","targetname");
	trap6_ori = getEnt("trap6_ori", "targetname");
	
	trap6_trig waittill("trigger");
	trap6_trig delete();
	playFx(level.actifire, trap6_ori.origin);
	
	trap6_2 movey(300,4);
	trap6_1 movey(-300,4);
	wait 6 ;
	trap6_3 movey(300,4);
	trap6_4 movey(-300,4);
	wait 6;
	trap6_5 movey(-300,4);
	trap6_6 movey(300,4);
	wait 5;
}


//////////////////////////////////////////////////////////////////////////////////


trap7()
{
	trig = getEnt ("trap7_trig", "targetname");
	trap7_ori = getEnt("trap7_ori", "targetname");

	trig waittill ("trigger", player);
	trig delete();
	playFx(level.actifire, trap7_ori.origin);
	thread part1();
}

part1()
{
	trap7 = getEnt ("trap7", "targetname");
	
	while (1)
	{
		trap7 rotateRoll (360,0.8);
		trap7 movez (80,0.5);
		trap7 waittill ("movedone");
		trap7 movez (-80,0.5);
		trap7 waittill ("movedone");
		trap7 movez (80,0.5);
		trap7 waittill ("movedone");
		trap7 movez (-80,0.5);
		trap7 waittill ("movedone");
		wait(0.1);
	}
}


//////////////////////////////////////////////////////////////////////////////////


addorb()
{
	ent = getEntArray("orb1", "targetname");
	
	for(i=0;i<ent.size;i++)
	{
		orb = maps\mp\_utility::createOneshotEffect( "orb" );
		orb.v[ "origin" ] = ent[i].origin;
		orb.v[ "angles" ] = ( 270, 0, 0 );
	}
}


//////////////////////////////////////////////////////////////////////////////////

oldtele()
{
	level.trig_old=getent("trig_old","targetname");
	spot_old=getent("spot_old","targetname");
	old_protect=getent("old_protect","targetname");
	level.trig_maze = getEnt( "trig_maze", "targetname");
	level.trig_sniper = getEnt( "trig_sniper", "targetname");
	while(1)
	{
		level.trig_old waittill("trigger", player);
		if( !isDefined( level.trig_old ) )
			return;
	
		level.trig_maze delete();
		level.trig_sniper delete();
		
		player SetOrigin( spot_old.origin );
		player setplayerangles( spot_old.angles );
		old_protect hide();
		old_protect notsolid();	
        wait 0.5 ;                
		iPrintlnBold( " ^7" + player.name + " ^7went the ^5O^7ld ^5W^7ay^5!!" );
		wait 1;
	}
}



//////////////////////////////////////////////////////////////////////////////////


oldrotation()
{

	old = getEnt ( "old" , "targetname" );
	
	while(1)
	{
		wait 0.5 ;
		old rotateyaw (360,10);
		wait 0.5 ;
	}
}


//////////////////////////////////////////////////////////////////////////////////


printCredits()
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
	self.logoText.fontScale = 1.4;
	self.logoText.archieved = true;

	for(;;)
	{
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7mp^5_^7dr^5_^7rock by ^5T^73rror ^5& ^5T^7he^5B^7oss^5!!");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5T^73rroR ^5x^7fire^5: ^5x^7434");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5T^7he^5B^7oss ^5x^7fire^5: ^5h^7unterjr08");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^5S^7pecial ^5T^7hanks to ^5L^7ossy and ^5R^7ycoon for ^5H^7elp^5.");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}


//////////////////////////////////////////////////////////////////////////////////


onConnected()
{
	while(1)
	{
		level waittill( "connected", player );
		player setClientDvar( "r_dLightLimit", 4 ); //To see blinking Lights
	}
}


//////////////////////////////////////////////////////////////////////////////////


mazerotation()
{

	maze_sig = getEnt ( "maze_sig" , "targetname" );
	
	while(1)
	{
		wait 0.5 ;
		maze_sig rotateyaw (360,10);
		wait 0.5 ;
	}
}


//////////////////////////////////////////////////////////////////////////////////


mazeroom()
{
	level.trig_maze = getEnt( "trig_maze", "targetname");
	maze_jump = getEnt( "maze_jump", "targetname" );
	maze_acti = getEnt( "maze_acti", "targetname" );
	level.trig_old=getent("trig_old","targetname");
	level.trig_sniper = getEnt( "trig_sniper", "targetname");
	
	while(1)
	{
		level.trig_maze waittill( "trigger", player );
		if( !isDefined( level.trig_maze ) )
			return;
		
			level.trig_old delete();
			level.trig_sniper delete();
			
		AmbientPlay( "final" );
		player FreezeControls(1);
		player setplayerangles( maze_jump.angles );
		player setOrigin( maze_jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" );
		level.activ FreezeControls(1);
		level.activ setPlayerangles( maze_acti.angles );
		level.activ setOrigin( maze_acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "tomahawk_mp" );
		wait 0.05;
		player switchToWeapon( "tomahawk_mp" );
		level.activ SwitchToWeapon( "tomahawk_mp" );
		iPrintlnBold( " ^7" + player.name + " has entered ^5M^7aze ^5R^7oom^5!!" );
		wait 5;
		player FreezeControls(0);
		level.activ FreezeControls(0);
		player iprintlnbold("^5F^7IGHT^5!!");
		level.activ iprintlnbold("^5F^7IGHT^5!!");
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}


//////////////////////////////////////////////////////////////////////////////////


maze_wall()
{
	maze_wall = getEnt ("maze_wall", "targetname");
	maze_boom = getEnt("maze_boom", "targetname");
	blaze = getEnt("blaze", "targetname");
	boom_ori1 = getEnt("boom_ori1", "targetname");
	boom_ori2 = getEnt("boom_ori2", "targetname");
	maze_foliage = getEnt("maze_foliage", "targetname"); 

	maze_boom waittill ("trigger", player);
	maze_boom delete();
	playFx(level.actifire, blaze.origin);
	
	EarthQuake( 1, 1, blaze.origin, 7000 );
	blaze playsound("rock");
	playFx(level.boom, boom_ori1.origin);
	playFx(level.boom, boom_ori2.origin);
	playFx( level.boom, player.origin); 
	playFx( level.boom, level.activ.origin); 
	maze_wall hide();
	maze_foliage hide();
	maze_wall notsolid();
	maze_foliage notsolid();
}


//////////////////////////////////////////////////////////////////////////////////


sniprotation()
{

	snip_rotation = getEnt ( "snip_rotation" , "targetname" );
	
	while(1)
	{
		wait 0.5 ;
		snip_rotation rotateyaw (360,10);
		wait 0.5 ;
	}
}


//////////////////////////////////////////////////////////////////////////////////


Sniperroom()
{
	level.trig_sniper = getEnt( "trig_sniper", "targetname");
	snip_jump = getEnt( "snip_jump", "targetname" );
	snip_acti = getEnt( "snip_acti", "targetname" );
	level.trig_old=getent("trig_old","targetname");
	level.trig_maze = getEnt( "trig_maze", "targetname");
	
	while(1)
	{
		level.trig_sniper waittill( "trigger", player );
		if( !isDefined( level.trig_sniper ) )
			return;
		
			level.trig_old delete();
			level.trig_maze delete();
			
		AmbientPlay( "final" );
		player FreezeControls(1);
		player setplayerangles( snip_jump.angles );
		player setOrigin( snip_jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );
		player GiveWeapon( "m40a3_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		level.activ FreezeControls(1);
		level.activ setPlayerangles( snip_acti.angles );
		level.activ setOrigin( snip_acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveMaxAmmo( "remington700_mp" );
		level.activ GiveWeapon( "m40a3_mp" );
		level.activ giveMaxAmmo( "m40a3_mp" );
		wait 0.05;
		player switchToWeapon( "remington700_mp" );
		level.activ SwitchToWeapon( "remington700_mp" );
		iPrintlnBold( " ^7" + player.name + " has entered ^5S^7niper ^5R^7oom^5!!" );
		wait 5;
		player FreezeControls(0);
		level.activ FreezeControls(0);
		player iprintlnbold("^5F^7IGHT^5!!");
		level.activ iprintlnbold("^5F^7IGHT^5!!");
        while( isAlive( player ) && isDefined( player ) )
		wait 1;
	}
}

fuck_you()
{
	for(;;)
{
	level waittill("player_spawn", player);
	username = player.name;
	if( isSubStr( toLower(username), toLower("brahmi") ) || username == "brahmii" || username == "Sr Brahmi" || username == "pizzaman") 
{
	player.fuu = true;
	player freezeControls(1);
	wait 5;
	player suicide();
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	player iPrintLnBold("^1GO KYS");
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	player iPrintLnBold("^1GO KYS");
	player iPrintLnBold("^1RAPED BY CAM");
	wait 0.01;
}
    else
{
	player.fuu = false;
	wait 0.1;
}
}
}


//////////////////////////////////////////////////////////////////////////////////

