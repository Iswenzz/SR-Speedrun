//   ad88888ba                                 88           88           
//  d8"     "8b  ,d                            88    ,d     88           
//  Y8,          88                            88    88     88           
//  `Y8aaaaa,  MM88MMM  ,adPPYba,  ,adPPYYba,  88  MM88MMM  88,dPPYba,   
//    `"""""8b,  88    a8P_____88  ""     `Y8  88    88     88P'    "8a  
//          `8b  88    8PP"""""""  ,adPPPPP88  88    88     88       88  
//  Y8a     a8P  88,   "8b,   ,aa  88,    ,88  88    88,    88       88  
//   "Y88888P"   "Y888  `"Ybbd8"'  `"8bbdP"Y8  88    "Y888  88       88  

////////////////////////////////////                         
// Email: mich4e1@hotmail.co.uk	  //
// Xfire: madstealth			  //									
// map:   frosty deathrun		  //
//								  //
//	   AfterLifeGaming.net		  //
//////////////////////////////////// 

main()
{
	maps\mp\_load::main();
	
	//ambientPlay("mp_crash_snow");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	
	//visionSetNaked( "cobra_sunset2", 2 );

	thread sr\api\_map::createSpawn((-608, 519, 76), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((2773.64, 3619.44, -627.875), 115,120, "normal_0"); 
	
	//thread printCredits();
	//thread BlueFires();
	//thread snow();
	
	//thread trap_one();
	//thread trap_two();
	//thread trap_three();
	//thread trap_four();
	//thread trap_five();
	thread trap_six();
	
	//thread teleport_down();
	//thread teleport_up();
	//thread finaldoor();

	//thread whoot();
	//thread disco();
	//thread playerDvars();
}



// =============================================================================//
//  Printed credits at top of screen											//
// =============================================================================//
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
		self.logoText setText("^5Frosty Deathrun ^1by ^7 [aL]STEALTH");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2visit ^5 AfterlifeGaming.net!");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^3xfire^0: ^7madstealth");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}



// =============================================================================//
//  Blue flames																	//
// =============================================================================//
BlueFires()
{
fireblue = getentarray("fireblue","targetname");
level._effect[ "fires" ] = loadfx( "custom/blue_fire" );
for(i=0;i<fireblue.size;i++)
maps\mp\_fx::loopfx("fires", (fireblue[i].origin), 3, (fireblue[i].origin) + (0, 0, 90));
}



// =============================================================================//
//  Ambient snow fx																//
// =============================================================================//
snow()
{
snow = getentarray("snow","targetname");
level._effect[ "snow" ] = loadfx( "weather/snow_light_mp_bloc" );
for(i=0;i<snow.size;i++)
maps\mp\_fx::loopfx("snow", (snow[i].origin), 3, (snow[i].origin) + (0, 0, 0));
}



// =============================================================================//
//  Falling stalagmites Trap (trap 1)											//
// =============================================================================//
trap_one()
{
trigger = getent("trigger_trap1", "targetname");

trap_1_array = getentarray("trap_1_array","targetname");
trap_1_kill = getentarray("trap_1_kill", "targetname");

trap_1_move = getent("trap_1_move", "targetname");

trap_1_fx1 = getent("trap_1_fx1", "targetname");
trap_1_fx2 = getent("trap_1_fx2", "targetname");
trap_1_fx3 = getent("trap_1_fx3", "targetname");
trap_1_fx4 = getent("trap_1_fx4", "targetname");
trap_1_fx5 = getent("trap_1_fx5", "targetname");
trap_1_fx6 = getent("trap_1_fx6", "targetname");

fx = loadfx( "explosions/grenadeExp_snow" );

while(1)
	{
	trigger waittill("trigger", user );
		{
		wait 0.01;		
		for(i=0;i<trap_1_array.size;i++)
		for(i=0;i<trap_1_kill.size;i++)
			{
			trigger delete();
			user iprintlnbold("Trap Activated");
			trap_1_kill[i] enablelinkto();
			trap_1_array[i] linkto( trap_1_move );
			trap_1_kill[i] linkto( trap_1_move );
			trap_1_move moveZ(-244, 0.7, 0.01, 0.001);
			wait 0.7;
			trap_1_fx2 playsound("boom2");
			playfx(fx, trap_1_fx1.origin);
			playfx(fx, trap_1_fx2.origin);
			playfx(fx, trap_1_fx3.origin);
			playfx(fx, trap_1_fx4.origin);
			playfx(fx, trap_1_fx5.origin);
			playfx(fx, trap_1_fx6.origin);
			
			Earthquake( 0.3, 2, trap_1_fx2.origin, 1000);	
			wait 1;			
			}
		}
	}
}



// =============================================================================//
//  Bobbing ice Trap (trap 2)													//
// =============================================================================//
trap_two()
{
	thread floating_ice_1();
	thread floating_ice_3();
	thread floating_ice_4();
	thread floating_ice_5();
	thread freeze_killer();
}

floating_ice_1()
{
plat = getent("trap_2_ice1", "targetname");

	while (1)
	{	
			plat rotateyaw (4, 1, 0.5, 0.5);
			plat rotatepitch (4, 1, 0.5, 0.5);
			wait 1;
			plat rotateyaw (-4, 1, 0.5, 0.5);
			plat rotatepitch (-4, 1, 0.5, 0.5);
			wait 1;
	}
}

floating_ice_3()
{
plat = getent("trap_2_ice3", "targetname");

	while (1)
	{
			plat rotateyaw (4, 1, 0.5, 0.5);
			plat rotatepitch (4, 1, 0.5, 0.5);
			wait 1;
			plat rotateyaw (-4, 1, 0.5, 0.5);
			plat rotatepitch (-4, 1, 0.5, 0.5);
			wait 1;
	}
}

floating_ice_4()
{
plat = getent("trap_2_ice4", "targetname");

	while (1)
	{
			plat rotateyaw (-4, 1, 0.5, 0.5);
			plat rotatepitch (-4, 1, 0.5, 0.5);
			wait 1;
			plat rotateyaw (4, 1, 0.5, 0.5);
			plat rotatepitch (4, 1, 0.5, 0.5);
			wait 1;
	}
}

floating_ice_5()
{
plat = getent("trap_2_ice5", "targetname");

	while (1)
	{
			plat rotateyaw (4, 1, 0.5, 0.5);
			plat rotatepitch (4, 1, 0.5, 0.5);
			wait 1;
			plat rotateyaw (-4, 1, 0.5, 0.5);
			plat rotatepitch (-4, 1, 0.5, 0.5);
			wait 1;
	}
}

freeze_killer()
{
	trig = getEnt ("trap_2_kill", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", who);
		who shellshock( "default", 3 );
		who iprintlnbold("Arrgghh.... im drowning!");
		wait 3;
		who suicide();
	}
}



// =============================================================================//
//  parting ice sheets (trap 3)													//
// =============================================================================//
trap_three()
{
trigger = getent("trigger_trap3", "targetname");
left = getent("trap_3_left", "targetname");
right = getent("trap_3_right", "targetname");
thread trap_3_kill();
while (1)
	{
	trigger waittill("trigger", user);
		{
		
		user iprintLnBold("trap activated!");
		left movey(265, 1, 0.1, 0.1);
		right movey(-265, 1, 0.1, 0.1);
		wait 6;
		left movey(-265, 1, 0.01, 0.01);
		right movey(265, 1, 0.01, 0.01);	
		wait 6;
		}
	}
}

trap_3_kill()
{
	trig = getEnt ("trap_3_kill", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", who);
		who shellshock( "default", 3 );
		who iprintlnbold("A stalagtite penetrated your skull!");
		wait 3;
		who suicide();
	}
}



// =============================================================================//
//  falling floor (trap 4)   													//
// =============================================================================//
trap_four()
{
left_door = getentarray("left_door", "targetname");
right_door = getentarray("right_door", "targetname");
trigger = getent("trigger_trap4", "targetname");
while(1)
	{
	trigger waittill("trigger", user);
		{
		trigger delete();
		for(i=0;i<left_door.size;i++)
		for(i=0;i<right_door.size;i++)
		{
		left_door[i] rotatepitch(90, 1, 0.1, 0.1);
		right_door[i] rotatepitch(-90, 1, 0.1, 0.1);
		wait 10;
		left_door[i] rotatepitch(-90, 1, 0.1, 0.1);
		right_door[i] rotatepitch(90, 1, 0.1, 0.1);		
		}
		}
	}
}



// =============================================================================//
//  exploding snowman (trap 5)													//
// =============================================================================//
trap_five()
{
trigger = getent("trigger_trap5", "targetname");
while(1)
	{
	trigger waittill("trigger", user);
		{
		iprintln( user.name + " Has activated the exploding ^5snowmen" );
		wait 0.1;
		thread snowman1();
		thread snowman2();
		thread snowman3();
		thread snowman4();
		thread snowman5();
		thread snowman6();
		thread snowman7();
		thread snowman8();
		thread snowman9();
		trigger delete();
		}
	}
}
		

snowman1()
{
origin = getent("snowman1_origin", "targetname");
trigger = getent("snowman1_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman1_model", "targetname");
brush = getent("sb1", "targetname");


while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}
}
}

snowman2()
{
origin = getent("snowman2_origin", "targetname");
trigger = getent("snowman2_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman2_model", "targetname");
brush = getent("sb2", "targetname");


while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}
}
}

snowman3()
{
origin = getent("snowman3_origin", "targetname");
trigger = getent("snowman3_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman3_model", "targetname");
brush = getent("sb3", "targetname");


while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}
}
}

snowman4()
{
origin = getent("snowman4_origin", "targetname");
trigger = getent("snowman4_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman4_model", "targetname");
brush = getent("sb4", "targetname");


while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}
}
}

snowman5()
{
origin = getent("snowman5_origin", "targetname");
trigger = getent("snowman5_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman5_model", "targetname");
brush = getent("sb5", "targetname");


while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}
}
}

snowman6()
{
origin = getent("snowman6_origin", "targetname");
trigger = getent("snowman6_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman6_model", "targetname");
brush = getent("sb6", "targetname");


while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}
}
}

snowman7()
{
origin = getent("snowman7_origin", "targetname");
trigger = getent("snowman7_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman7_model", "targetname");
brush = getent("sb7", "targetname");


while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}
}
}

snowman8()
{
origin = getent("snowman8_origin", "targetname");
trigger = getent("snowman8_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman8_model", "targetname");
brush = getent("sb8", "targetname");


while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}
}
}

snowman9()
{
origin = getent("snowman9_origin", "targetname");
trigger = getent("snowman9_trigger", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
snowman = getent("snowman9_model", "targetname");
brush = getent("sb9", "targetname");

while(1)
{
	trigger waittill("trigger", user);
		{
		playfx(fx, origin.origin);
		origin playsound( "exp_suitcase_bomb_main" );
		wait 0.1;
		snowman hide();
		user suicide();
		trigger delete();
		brush delete();
		}	
}	
}



// =============================================================================//
//  Freezing Water (trap 6)														//
// =============================================================================//
trap_six()
{
precacheShader("white");
trigger = getent("trigger_trap6", "targetname");
fall = getentarray("six_fall", "targetname");
solidwater = getent("six_solidwater", "targetname");
fx1 = getent("six_fx1", "targetname");
fx2 = getent("six_fx2", "targetname");
fx = loadfx( "explosions/grenadeExp_snow" );
level.trap6activated = undefined;

solidwater notsolid();


}

sixkill()
{
frozen_vision = undefined;
trigger = getent("six_kill", "targetname");
while(1)
	{
	trigger waittill("trigger", user);
	{
		if( isDefined(level.trap6activated))
		{
		frozen_vision = newClientHudElem(user);
		frozen_vision.x = 0;
		frozen_vision.y = 0;
		frozen_vision setshader ("white", 640, 480);
		frozen_vision.alignX = "left";
		frozen_vision.alignY = "top";
		frozen_vision.horzAlign = "fullscreen";
		frozen_vision.vertAlign = "fullscreen";
		frozen_vision.color = (.16, .38, .5);
		frozen_vision.alpha = 0;
		frozen_vision fadeOverTime(2);
		frozen_vision.alpha = 0.5;
		user iprintlnbold("Arrgghh.... the water froze! I'm drowning!");
		wait 3;
		frozen_vision.alpha = 0.5;
		frozen_vision fadeOverTime(3);
		frozen_vision.alpha = 0;
		wait 0.5;
		user shellshock( "default", 1.6 );
		wait 1.5;
		frozen_vision destroy();
		user suicide();
		}
	}
	}
}



// =============================================================================//
//  Activator teleports															//
// =============================================================================//
teleport_down()
{
trigger = getent("teleport_down_trigger", "targetname");
origin = getent("teleport_down", "targetname");
while(1)
	{
	trigger waittill("trigger", user);
		{
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		user setplayerangles(origin.angles);
		user linkto (air);
		time = 1;
        air moveto (origin.origin, 0.0001);
		air waittill ("movedone");
		user unlink();
		air delete();
		wait 1;
		user IprintLnBold("Teleported down Sucessfully");
		}
	}
}

teleport_up()
{
trigger = getent("teleport_up_trigger", "targetname");
origin = getent("teleport_up", "targetname");
while(1)
	{
	trigger waittill("trigger", user);
		{
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		user setplayerangles(origin.angles);
		user linkto (air);
		time = 1;
        air moveto (origin.origin, 0.0001);
		air waittill ("movedone");
		user unlink();
		air delete();
		wait 1;
		user IprintLnBold("Teleported up Sucessfully");
		}
	}
}





whoot()
{
thread flake();
thread sacrifice();
thread datmove();
}

flake()
{
flake = getent("snowman_halo", "targetname");
level._effect[ "halo" ] = loadfx( "custom/halo" );
maps\mp\_fx::loopfx("halo", (flake.origin), 3, (flake.origin) + (0, 0, 0));
}

sacrifice()
{
trigger = getent("snowman_sacrifice", "targetname");
while(1)
	{
	trigger waittill("trigger", user);
		{
			iprintln(user.name + " ^5Sacrificed their life to the ^7Snowman");
			user suicide();
		}
	}
}
	
datmove()
{
trigger = getent("movetogay", "targetname");
place = getent("datorgy", "targetname");
while(1)
{
trigger waittill("trigger", user);
	{
	if( (user.name == "[aL]Lossy") || (user.name == "[aL]Fearz") || (user.name == "[aL]iMtroll") || (user.name == "[aL]Techno") || (user.name == "[aL]Dog") || (user.name == "techno") || (user.name == "aL.Lossy") || (user.name == "aL.Lossy"))
		{
		user IprintLnBold("you were selected to sacrifice your life to the snowman, ^5mad^7?");
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		user setplayerangles(place.angles);
		user linkto (air);
		time = 1;
        air moveto (place.origin, 0.0001);
		air waittill ("movedone");
		user unlink();
		air delete();
		wait 1;
		user IprintLnBold("have fun xDDDDDDDDDDDDDD");
		}
	}
}
}

// =============================================================================//
//  Everything to do with disco													//
// =============================================================================//
disco()
{
thread discoBrush();
thread discoSound();
thread discoFx();
thread telein();
thread teleout();

jumpPads = getEntArray( "disco_jump", "targetname" );
	for( i = 0; i < jumpPads.size; i++ )
		jumpPads[i] thread MonitorTrigger();
}

discoBrush()
{
	image = [];
	image[0] = getEnt( "brush1", "targetname" );
	image[0] Show();
	image[1] = getEnt( "brush2", "targetname" );
	image[1] Hide();
	image[2] = getEnt( "brush3", "targetname" );
	image[2] Hide();
	image[3] = getEnt( "brush4", "targetname" );
	image[3] Hide();
	image[4] = getEnt( "brush5", "targetname" );
	image[4] Hide();
	
	while(1)
	{
		image[0] Hide();
		image[1] Show();
		wait ( ( 0.1 / 20 ) * getDvarInt( "sv_fps" ) );
		image[1] Hide();
		image[2] Show();
		wait ( ( 0.1 / 20 ) * getDvarInt( "sv_fps" ) );
		image[2] Hide();
		image[3] Show();
		wait ( ( 0.1 / 20 ) * getDvarInt( "sv_fps" ) );
		image[3] Hide();
		image[4] Show();
		wait ( ( 0.1 / 20 ) * getDvarInt( "sv_fps" ) );
		image[4] Hide();
		image[0] Show();
		wait ( ( 0.1 / 20 ) * getDvarInt( "sv_fps" ) );
	}
}

discoSound()
{
maps\mp\_fx::loopSound("boobies", (-1160, 200, 64), 1);
}

discoFx()
{
discos = getentarray("discofx","targetname");
level._effect[ "gay" ] = loadfx( "custom/sparkle" );
for(i=0;i<discos.size;i++)
maps\mp\_fx::loopfx("gay", (discos[i].origin), 3, (discos[i].origin) + (0, 0, 90));
}

MonitorTrigger()
{
damage = randomIntRange(1000, 4000);
    while(1)
    {
        self waittill( "trigger", player );
        
        if( isPlayer( player ) && isAlive( player ) )
            player thread Boost(damage);
    }
}
Boost( damage )
{
    eInflictor = self;
    eAttacker = self;
    iDamage = damage;
    iDFlags = 0;
    sMeansOfDeath = "MOD_PROJECTILE";
    sWeapon = "rpg_mp";
    vPoint = ( self.origin + (0,0,-1) );
    vDir = vectornormalize( self.origin - vPoint );
    sHitLoc = "none";
    psOffsetTime = 0;
    self.health += iDamage;
    self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
}

telein()
{
trigger = getent("disco_out_trigger", "targetname");
origin = getent("disco_out", "targetname");
while(1)
	{
	trigger waittill("trigger", user);
		{
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		user setplayerangles(origin.angles);
		user linkto (air);
		time = 1;
        air moveto (origin.origin, 0.0001);
		air waittill ("movedone");
		user unlink();
		air delete();
		wait 1;
		user IprintLnBold("Teleported Sucessfully");
		}
	}
}

teleout()
{
trigger = getent("disco_in_trigger", "targetname");
origin = getent("disco_in", "targetname");
while(1)
	{
	trigger waittill("trigger", user);
		{
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		user setplayerangles(origin.angles);
		user linkto (air);
		time = 1;
        air moveto (origin.origin, 0.0001);
		air waittill ("movedone");
		user unlink();
		air delete();
		wait 1;
		user IprintLnBold("Teleported Sucessfully");
		}
	}
}

playerDvars()
{
level waittill( "connected", player );
level endon ( "game_ended" );
players = getEntArray( "player", "classname" );

	for(i=0;i<player.size;i++)
	{
		players[i] setclientDvar("r_drawdecals", "1");
		players[i] setclientDvar("r_distorion", "1");
		players[i] setclientDvar("fx_draw", "1");
		players[i] setclientDvar("r_specular", "0");
		players[i] setclientDvar("r_gamma", "1.5");

	}
}

finaldoor()
{
trigger = getent("finaltrigger", "targetname");
door = getent("finaldoor", "targetname");
while (1)
	{
	trigger waittill("trigger", user);
		{
		iprintLnBold(user.name + " Has finished the map first");
		door moveZ(132, 2, 1, 0.1);
		trigger delete();
		}
	}
}





