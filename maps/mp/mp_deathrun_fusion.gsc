/* 
 MM  MMM  MM IMM. MMM  MM   ~MMMMM  MMMMMM   MMMMMZ   MMMMMN                    
 MM. MMM MM  OMM  MMMM MM  MMM         MMM  MM~  MMM  MM .MM                    
  MMMMMM MM  MMM  MMMMMMM  MM  MMM   :MM    MM    MM .MMMMM                     
  MMM,DMMM   MMM  MM MMMM  MMM  MM  MMM     MM7  MMM  MM MM                     
  MMM  MMM   MMM  MM  MMM   NMMMMM  MMMMMM   NMMMM .  MM MMM                    
*/
//vehicle_mi17_woodland_fly_static
main()
{
	thread sr\api\_map::create_normal_way("Normal Way;");

	thread sr\api\_map::create_spawn((-632, -9, 3884), 180);
	thread sr\api\_map::create_endmap((1662, -274, 3772), 100, 150);

	maps\mp\_load::main();
	
	//setExpFog(600, 600, 1, 1, 1, 0);
	setExpFog(100, 1000, 0.2, 0.225, 0.24, 0.0);
	/* [AUTO DELETE] //ambientPlay("soundalias"); */

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	
	//////////dvars/////////////////////////////
	/* [AUTO DELETE] level.dvar["time_limit"]=4.5; */
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	SetDvar( "env_fog", "1" );
	SetDvar( "env_fog_start_distance", "200" );
	SetDvar( "env_fog_half_distance", "480" );
	
	///////////variable////////////////////

	level.lighting_fx = loadfx("weather/lightning");
	level._effect["lightning"] = loadfx("fusion/lightingrings");
	level.soulFX = loadfx("fusion/wp_spawnfx");
	level.lightzy = loadfx("misc/cgoshp_lights_cr");
	level.shiplight = loadfx("misc/aircraft_light_cockpit_red");
	level.shiplightblue = loadfx("misc/aircraft_light_cockpit_blue");
	level.impact_fx = loadfx("explosions/grenadeExp_concrete_1");
	level.blur = 1;
	
	//////////////caches////////////////
	precacheModel( "eliza_BR2" );
	
	
	
	
	//////////////threads////////////////
	//thread watchtime();
	thread shiplights();
	//thread startSpecialintro();
	thread startlift();
	// thread introbase();
	/* [AUTO DELETE] thread oldgame(); */
	//thread easydoor();
	/* [AUTO DELETE] thread secretdone(); */
	thread setacti_model();
	thread ropedown_chop1();
	thread ropedown_chop2();
	thread ropedown_chop3();
	
	
	////////////////traps//////////////////
	thread trap1_removeblocks();
	thread trap2_electro_rings();
	thread trap3();
	//thread rotatefloortrap_1();
	thread trap_pusher();
	thread trap_catapult();
	thread trap_rotatefloor();
	thread hardtrap();
	thread suxtrap();
	thread triggersux_trap();
	
	thread createRandomOrigin();
	thread createRandomOriginMoveTo();
	thread soulSpawn();
	thread demonotify();
	
	////////endgames/////////////
	/* thread aiminit();
	thread aimgamedoors();
	thread aimgameteleport();
	thread aimingtargets();
	thread unlockpart1(); */
	// thread scopegame();
	
}


///////////////////////////////////map-scripts////////////////////////////////////////

demonotify()
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
		self.logoText setText("^2---^1Map Made By Wingzor^2---");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2---^7BETA ^11.02^7 Report bugs please^2---");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2---^1Xfire^2=^1evilphinal^2---");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^2---^1REMEMBER THIS IS JUST A PUBLIC BETA^2---");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}


scopegame()
{
level.actispot = getent("activator_scopespot", "targetname");
jumpspot = getent("jumper_scopespot", "targetname");
firsttele=true;

level.snipertrigger = getEnt("trigger_gamedoor_sniper", "targetname");
	for(;;)
	{
	level.snipertrigger waittill("trigger", player);
	wait(0.05);
	player SetOrigin( jumpspot.origin );
	player setplayerangles( jumpspot.angles );
	wait(0.05);
	/* [AUTO DELETE] iPrintLnBold(player.name+ "^1 has entered the sniper room"); */
	/* [AUTO DELETE] player iPrintLnBold("Use ^2NightVision^7 if it is too dark."); *///Change the message if you want
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] player GiveWeapon("m40a3_mp"); */
	/* [AUTO DELETE] player GiveWeapon("remington700_mp"); */
	/* [AUTO DELETE] player GiveMaxAmmo( self.pers["m40a3_mp"] ); */
	/* [AUTO DELETE] player GiveMaxAmmo( self.pers["remington700_mp"] ); */
	/* [AUTO DELETE] player SwitchToWeapon( "m40a3_mp" ); */
		if(firsttele==true)
		{
			level.oldtrigger delete();
			wait(0.05);
			level.activ SetOrigin( level.actispot.origin );
			level.activ setplayerangles( level.actispot.angles );
			wait(0.05);
			/* [AUTO DELETE] level.activ takeallweapons(); */
			/* [AUTO DELETE] level.activ GiveWeapon("m40a3_mp"); */
			/* [AUTO DELETE] level.activ GiveWeapon("remington700_mp"); */
			/* [AUTO DELETE] level.activ GiveMaxAmmo( self.pers["m40a3_mp"] ); */
			/* [AUTO DELETE] level.activ GiveMaxAmmo( self.pers["remington700_mp"] ); */
			/* [AUTO DELETE] level.activ SwitchToWeapon( "m40a3_mp" ); */
			level.actispot delete();
			firsttele=false;
		}
	}
}



creatorcredit()
{
wait(1);
thread drawInformation( 800, 0.8, 1, "Fusion" );
wait(4);
thread drawInformation( 800, 0.8, 1, "� Wingzor Xfire:Evilphinal" );
wait(4);
}


drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 90 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
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

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (27/255, 191/255, 224/255);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}


setacti_model()
{
level waittill("round_started");
if( level.freeRun )
{

}
else
{
players = getentarray("player", "classname");

for(i=0;i<players.size;i++)
		{
			if(players[i]==level.acti)
			{
				players[i] detachall();
				players[i] setmodel("eliza_BR2");
			}
			else
			{
			wait(2);
			{
				if(players[i]==level.acti)
				{
					players[i] detachall();
					players[i] setmodel("eliza_BR2");
				}
			}
			}
		}
}
}


ropedown_chop1()
{
	startent = getent("sliding_start", "targetname");
	endent = getent("sliding_end", "targetname");
	start = startent.origin;
	end = endent.origin;
	
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			players[i].isSliding = false;
			if( Distance( start, players[i].origin ) <= 128 && isAlive(players[i]) && !players[i].isSliding )
			{
				if( players[i] UseButtonPressed() )
				{
					players[i] thread rope_chop1( start, end );
					wait 1.5;
				}
			}
		}
		wait 0.1;
	}
}


rope_chop1( start, end )
{
	if( !isDefined( self.linker ) )
		self.linker = Spawn("script_origin", self GetEye()+(0,0,20) );
	
	spot1= (1636,-4420,784);
	spot2= (1636,-4140,600);
	spot3= (1636,-3772,404);
	spot4= (1636,-2876,32);
	
	self.isSliding = true;
	self DisableWeapons();
	self LinkTo( self.linker );
	self.linker MoveTo( start, 1, 0.5, 0.5 );
	wait 1.2;
	self.linker MoveTo( spot1, 1);
	wait 0.95;
	self.linker MoveTo( spot2, 0.75);
	wait 0.7;
	self.linker MoveTo( spot3, 0.75);
	wait 0.7;
	self.linker MoveTo( spot4, 1);
	wait 0.95;
	self.linker MoveTo( end, 1);
	wait 1;
	self UnLink();
	self.linker delete();
	self EnableWeapons();
	self.isSliding = false;
}


ropedown_chop2()
{
	startent = getent("sliding_start2", "targetname");
	endent = getent("sliding_end2", "targetname");
	start = startent.origin;
	end = endent.origin;
	
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			players[i].isSliding2 = false;
			if( Distance( start, players[i].origin ) <= 128 && isAlive(players[i]) && !players[i].isSliding2 )
			{
				if( players[i] UseButtonPressed() )
				{
					players[i] thread rope_chop2( start, end );
					wait 1.5;
				}
			}
		}
		wait 0.1;
	}
}


rope_chop2( start, end )
{
	if( !isDefined( self.linker ) )
		self.linker = Spawn("script_origin", self GetEye()+(0,0,20) );
	
	spot1= (4104.22,-2799.69,593);
	spot2= (3546.45,-2515.49,263);
	spot3= (2973.54,-2223.57,16);
	spot4= (2513.78,-1989.31,-159);
	
	self.isSliding2 = true;
	self DisableWeapons();
	self LinkTo( self.linker );
	self.linker MoveTo( start, 1, 0.5, 0.5 );
	wait 1.2;
	self.linker MoveTo( spot1, 1);
	wait 0.95;
	self.linker MoveTo( spot2, 0.75);
	wait 0.7;
	self.linker MoveTo( spot3, 0.75);
	wait 0.7;
	self.linker MoveTo( spot4, 0.75);
	wait 0.7;
	self.linker MoveTo( end, 1);
	wait 1;
	self UnLink();
	self.linker delete();
	self EnableWeapons();
	self.isSliding2 = false;
}


ropedown_chop3()
{
	startent = getent("sliding_start3", "targetname");
	endent = getent("sliding_end3", "targetname");
	start = startent.origin;
	end = endent.origin;
	
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			players[i].isSliding3 = false;
			if( Distance( start, players[i].origin ) <= 200 && isAlive(players[i]) && !players[i].isSliding3 )
			{
				if( players[i] UseButtonPressed() )
				{
					players[i] thread rope_chop3( start, end );
					wait 1.5;
				}
			}
		}
		wait 0.1;
	}
}


rope_chop3( start, end )
{
	if( !isDefined( self.linker ) )
		self.linker = Spawn("script_origin", self GetEye()+(0,0,20) );
	
	spot1= (3920.73,1420.03,859);
	spot2= (3392.77,1083.69,529);
	spot3= (2850.46,738.211,282);
	spot4= (2415.27,460.97,107);
	
	self.isSliding3 = true;
	self DisableWeapons();
	self LinkTo( self.linker );
	self.linker MoveTo( start, 1, 0.5, 0.5 );
	wait 1.2;
	self.linker MoveTo( spot1, 1);
	wait 0.95;
	self.linker MoveTo( spot2, 0.75);
	wait 0.7;
	self.linker MoveTo( spot3, 0.75);
	wait 0.7;
	self.linker MoveTo( spot4, 0.75);
	wait 0.7;
	self.linker MoveTo( end, 1);
	wait 1;
	self UnLink();
	self.linker delete();
	self EnableWeapons();
	self.isSliding3 = false;
}


//self.linkObj = spawn("script_model", (0,0,0));
introbase()
{
		level waittill("round_started");
		
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
					players[i] FreezeControls( true );			
		}
		/* [AUTO DELETE] AmbientPlay("zor"); */
		thread creatorcredit();
		thread startSpecialintro();
		wait(15);
			if( level.freeRun )
			{
	
			}
			else
			{
				for(i=0;i<players.size;i++)
				{
							// if(players[i]==level.acti)
							// 	 [AUTO DELETE] players[i] iPrintlnbold( "^1Enemy troops inbound !" ); 	
							// else
							// 	/* [AUTO DELETE] players[i] iPrintlnbold( "Move in !" ); */
							
				}
			}
		for(i=0;i<players.size;i++)
		{
					players[i] FreezeControls( false );			
		}
}


watchtime()
{
	level.dvar["time_limit"]=4.5;
	ent = spawn( "script_model", (0,0,0));
	level waittill("round_started");
	if( level.freeRun )
	{
	
	}
	else
	{
	
		if(level.dvar["time_limit"]<4.5)
		level.dvar["time_limit"]=5;
		
		if(level.dvar["time_limit"]>4.5)
		level.dvar["time_limit"]=5;
		
			/* [AUTO DELETE] iPrintln("^1timer ok"); */
			for(i=level.dvar["time_limit"];i>0.1;i--)
			{
			if(i>1)
			{
			wait 60;
			/* [AUTO DELETE] iPrintln("^1" + (i - 1) + ":00 ^7remaining"); */
			if(i==5)
			ent PlaySound( "4mins" );
			if(i==4)
			ent PlaySound( "3mins" );
			if(i==3)
			ent PlaySound( "2mins" );
			if(i==2)
			ent PlaySound( "1mins" );
			}
			else
			{	
			wait 30;
			/* [AUTO DELETE] iPrintln("^1" + (i - 1) + ":30 ^7remaining"); */
			ent PlaySound( "30secs" );
			wait 15;
			/* [AUTO DELETE] iPrintln("^1" + (i - 1) + ":15 ^7remaining"); */
			ent PlaySound( "15secs" );
			wait 10;
			/* [AUTO DELETE] iPrintln("^1" + (i - 1) + ":10 ^7remaining"); */
			ent PlaySound( "10secs" );
			}
			}
	}
}


		/* if (timeLeft <= 240)
    playedAlready |= level.CDFLAG_4MIN;
  if (timeLeft <= 180)
    playedAlready |= level.CDFLAG_3MIN;
  if (timeLeft <= 120)
    playedAlready |= level.CDFLAG_2MIN;
  if (timeLeft <= 67)
    playedAlready |= level.CDFLAG_1MIN;
  if (timeLeft <= 33)
    playedAlready |= level.CDFLAG_30SEC;
  if (timeLeft <= 15)
    playedAlready |= level.CDFLAG_15SEC;
  if (timeLeft <= 10)
    playedAlready |= level.CDFLAG_FINAL; */


createRandomOrigin()
{
	level.spot = [];
	for(i=0;i<79;i++)
	level.spot[i] =  spawn( "script_model",(RandomIntRange( -8000, 8000 ), RandomIntRange( -8000, 8000 ), RandomIntRange( -2000, 8000 )) ); 	
}


createRandomOriginMoveTo()
{
	level.endspot = [];
	for(i=0;i<79;i++)
	level.endspot[i] =  spawn( "script_model",(RandomIntRange( -2000, 2000 ), RandomIntRange( -2000, 2000 ), RandomIntRange( -2000, 2000 )) );
}


soulSpawn()
{		
	for(i=0;i<79;i++)
	{	
		
		PlayLoopedFX( level.soulFX , 10, level.spot[i].origin);
		level.spot[i] MoveTo(level.endspot[i].origin ,20);//wont work :S
	}
	wait 20;
	for(i=0;i<79;i++)
		level.spot[i] delete();
}


shiplights()
{
x = (-4567);
for(i=0;i<71;i++)
	{	
		spot =(x,-2192,1720);
		PlayLoopedFX( level.shiplight , 10, spot);
		x+=100;
	}
	
x = (-4567);	
for(i=0;i<71;i++)
	{	
		spot =(x,4272,1720);
		PlayLoopedFX( level.shiplight , 10, spot);
		x+=100;
	}

x = (-4567);	
for(i=0;i<71;i++)
	{	
		spot =(x,1008,2552);
		PlayLoopedFX( level.shiplightblue , 10, spot);
		x+=100;
	}
	
x = (-4040);	
for(i=0;i<50;i++)
	{	
		spot =(x,1096,5112);
		PlayLoopedFX( level.lightzy , 10, spot);
		x+=100;
	}
	
	x = (-4000);	
for(i=0;i<57;i++)
	{	
		spot =(x,2696,4492);
		PlayLoopedFX( level.lightzy , 10, spot);
		x+=100;
	}

x = (-4000);	
for(i=0;i<30;i++)
	{	
		spot =(x,8,4500);
		PlayLoopedFX( level.lightzy , 10, spot);
		x+=100;
	}	
	
	
	x = (456);	
for(i=0;i<16;i++)
	{	
		spot =(-6008,x,4492);
		PlayLoopedFX( level.lightzy , 10, spot);
		x+=100;
	}
	
		x = (456);	
for(i=0;i<16;i++)
	{	
		spot =(-4216,x,4492);
		PlayLoopedFX( level.lightzy , 10, spot);
		x+=100;
	}
	
			x = (1096);	
for(i=0;i<16;i++)
	{	
		spot =(1736,x,4492);
		PlayLoopedFX( level.lightzy , 10, spot);
		x-=100;
	}

	//1736 1096 4492
	
	//-6008 2056 4492
	//-6008 456 4492
	
	//-4216 2056 4492

}


onPlayerConnect()
    {
       for(;;)
       {
          level waittill("connected", player);
          player thread onPlayerSpawned();
       }
    }

         
onPlayerSpawned()
    {
       for(;;)
       {
	  self setclientdvar("r_blur", level.blur);
		  
       }
    }


startSpecialintro()
{	
	level endon( "game_ended" );
	//level waittill("round_started");
	//trigger=getent("visiontrigger","targetname");
	//trigger waittill("trigger");
	/* [AUTO DELETE] iPrintln("Started"); */
	thread lightningFX();
	setBlur(6, 2);
	setVision("thunder", 2);
	fog = "";
	if (fog != "")
	setFog(fog, 2);

}


lightningFX()
{
	level endon("global_fx_end");
	while(1)
	{
		spawn = getRandomSpawn();
		playfx(level.lighting_fx, spawn.origin);
		r = randomint(4);
		for (i=0; i<level.players.size; i++)
		{
			if (r==0)
			{
			/* [AUTO DELETE] level playlocalsound("amb_thunder1"); */
			}
			if (r==1)
			{
			/* [AUTO DELETE] level playlocalsound("amb_thunder2"); */
			}
		}
		wait 1 + randomfloat(2);
	}
	
}


getRandomSpawn()
{
	currentSpawns = getentarray("mp_jumper_spawn", "classname");
	return currentSpawns[randomint(currentSpawns.size)];
}


setBlur(blur, time)
{
	change = ((blur - level.blur) / (time + 1));
	for (i=0; i<=time; i++)
	{
		updateBlur((level.blur + change));
		wait 1;
	}
}


updateBlur(blur)
{
	level.blur = blur;
	for (i=0; i<level.players.size; i++)
	{
		level.players[i] setclientdvar("r_blur", level.blur);
	}
}


setVision(name, time)
{
	level.vision = name;
	visionSetNaked( name, time );
}


setFog(name, time)
{
	
		if (level.dvar["env_fog"])
		{
			setExpFog( level.dvar["env_fog_start_distance"], level.dvar["env_fog_half_distance"], level.dvar["env_fog_red"]/255, level.dvar["env_fog_green"]/255, level.dvar["env_fog_blue"]/255, time);
		}
		else
		{
			setExpFog( 999999, 9999999, 0, 0, 0, time);
		}
			
}


oldgame()
{
door=getent("old_door","targetname");
level.oldtrigger=getent("oldway","targetname");
level.oldtrigger waittill("trigger");
level.snipertrigger delete();
wait(1);
door movez(-220,3);
door waittill ("movedone");
}


startlift()
{
lift=getent("startlift","targetname");
lift_trigger=getent("startlift_trigger","targetname");
level.first=true;
while(1)
{
lift_trigger waittill("trigger", player);
wait(3);
lift movez(3808,4);
lift waittill ("movedone");
wait(5);
lift movez(-3808,1);
lift waittill ("movedone");
}
}


easydoor()
{
trigger=getent("trigger_easydoor","targetname");
door=getent("easy_door","targetname");
trigger waittill("trigger", player);
/* [AUTO DELETE] iPrintln(player.name+ " Opened the door for all you slow people"); */
door delete();
trigger delete();
}


///////////////////////////////////traps//////////////////////////////////////////////
suxtrap()
{
	level endon("trigger");
trigger=getent("trigger_sux","targetname");
while(1)
{
trigger waittill("trigger", player);
player bounce( vectorNormalize( player.origin + ( player.origin + (150,0,50) ) ), 50 );
}
}


triggersux_trap()
{
	level endon("trigger");
level.sux=false;
trigger=getent("sux1","targetname");
trigger_trap=getent("acti_suxtrap","targetname");
trigger_trap waittill("trigger", player);
thread suxtimer();
level.sux=true;
while(level.sux==true)
{
trigger waittill("trigger", player);
player bounce( vectorNormalize( player.origin + ( player.origin + (150,0,150) ) ), 150 );
}
}


suxtimer()
{
wait(10);
level.sux=false;
}



bounce( pos, power )//This function doesnt require to thread it
{
	oldhp = self.health;
	self.health = self.health + power;
	self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
	self finishPlayerDamage( self, self, power, 0, "MOD_PROJECTILE", "none", undefined, pos, "none", 0 );
	self.health = oldhp;
	self thread bounce2();
}

bounce2()
{
	self endon( "disconnect" );
	wait .05;
	self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
}



rotatefloortrap_1()
{
	level endon("trigger");
//floor=getent("trap_rotatefloor1","targetname");
//trigger=getent("trigger_rotatefloor1","targetname");
//trigger waittill("trigger", player);
while(1)
{
//floor rotateRoll (360,1);
wait(4);
}
}


hardtrap()
{
	level endon("trigger");
spot=getent("tele_hardtrap","targetname");
trigger=getent("teleport_hard","targetname");
while(1)
{
trigger waittill("trigger", player);
player SetOrigin( spot.origin );
player setplayerangles( spot.angles );
}
}


trap1_removeblocks()
{
	level endon("trigger");
blocks=getent("blocks_trap1","targetname");
trigger=getent("blocks_trap1_trigger","targetname");
trigger waittill("trigger",player);
blocks notsolid();
blocks hide();
thread trap1_moveblocks();
}


trap1_moveblocks()
{
blocks_left=getent("blocks_trap1_left","targetname");
blocks_right=getent("blocks_trap1_right","targetname");
while(1)
{
blocks_left movey(-464,2);
blocks_right movey(400,2);
wait(2);
blocks_left movey(464,2);
blocks_right movey(-400,2);
wait(2);
}
}


trap2_electro_rings()
{
	level endon("trigger");
death_trigger=getent("deathtrigger_bouncerings","targetname");
trigger=getent("bouncerings_trigger","targetname");
death_trigger.dmg = 0;
electrotimer=15;

trigger waittill("trigger",player);
while(electrotimer>1)
{
death_trigger.dmg = 999;
electrotimer--;
playFx(level._effect["lightning"], (-2464,-256,3840));
playFx(level._effect["lightning"], (-2464,256,3840));
	if(electrotimer<=1)
	{
	death_trigger.dmg = 0;
	}
	wait(1.1);
}
}


trap3()
{
	level endon("trigger");
	trig3 = getent("trap3_trig", "targetname");
	rotate = getent( "rotate_trap3", "targetname" );

	trig3 waittill ("trigger");
	trig3 delete();
	
	while(1)
	{
		rotate rotateRoll (360,1);
		rotate movez (192,1);
		rotate waittill ("movedone");
		rotate movez (-192,1);
		rotate waittill ("movedone");
		rotate movez (192,1);
		rotate waittill ("movedone");
		rotate movez (-192,1);
		rotate waittill ("movedone");
		wait(2);
	}
}


 trap_pusher()
{
	level endon("trigger");
	spikepush_brush =getent("spikepush_brush","targetname");
	spikepush_brush hide();
	
	trigger =getent("trigger_spiketrap","targetname");

		
	trigger waittill("trigger");
	trigger delete();
		
		spikepush_brush show();
		spikepush_brush movez (384,2);
		spikepush_brush waittill ("movedone");
		wait 13 ;
		spikepush_brush movez (-384,2);
		spikepush_brush waittill ("movedone");
		wait 4.5 ;
		spikepush_brush hide();
	
}



trap_catapult()
{
	level endon("trigger");
catchplayer = getent("catapulttrap_multiple", "targetname");
trigger = getent("trigger_catapult", "targetname");
spot=getent("tele_hardtrap","targetname");
level.catchable=false;
	trigger waittill("trigger", who);
	thread catchcounter();
	level.catchable=true;
	
		while(1)
		{
			if ( level.catchable==true )
			{
			catchplayer waittill("trigger", player);
			player freezeControls( true );
			/* [AUTO DELETE] player iPrintlnbold("^1GOTCHA!"); */
			wait(2);
			player SetOrigin( spot.origin );
			player setplayerangles( spot.angles );
			player freezeControls( false );
			}
			if (level.catchable==false)
			{
			catchplayer delete();
			}
		}
}


catchcounter()
{
	for(level.icounter=0;level.icounter<10;level.icounter++)
	{
	wait(1.1);
		if(level.icounter==10)
		{
		level.catchable=false;
		}
	}
}


 trap_rotatefloor()
{
	level endon("trigger");
	rotatefloor_brush = getEnt ("rotatefloor_brush", "targetname");
	trigger = getEnt ("trigger_rotatefloor", "targetname");

	trigger waittill ("trigger");
	trigger delete();

	while (1)
	{
		rotatefloor_brush rotateroll (360, 4);
		rotatefloor_brush waittill("rotatedone");
		wait(1);
	}
}



secretdone()
{
trigger=getent("secretfinished","targetname");
spot=getent("secretdone","targetname");
while(1)
{
trigger waittill("trigger", player);
/* [AUTO DELETE] iPrintln(player.name+ " finished the secret !"); */
player SetOrigin( spot.origin );
player setplayerangles( spot.angles );
}
}


/////////////////////endgames////////////////
aiminit()
{
level.alpha_team_counter = 0;
level.alphascore=0;
thread trickroom1();
thread watchAlive();
}


aimgameteleport()
{
level.aimspot=getent("aimgame_teleporter","targetname");
trigger=getent("aimgametele","targetname");
for(;;)
{
	trigger waittill("trigger", player);
	if(level.alpha_team_counter<3)
		player setupteam();
		else
		/* [AUTO DELETE] player iPrintlnbold("AlphaTeam is full. Wait for a spot"); */
	wait .5;
}
}


setupteam()
{
		self.xteam = "AlphaTeam";
		level.alpha_team_counter++;
		/* [AUTO DELETE] iPrintlnbold(level.alpha_team_counter+ " in alpha team"); */
		/* [AUTO DELETE] iPrintlnbold(self.name+ " entered AIMGAME!"); */
		self SetOrigin( level.aimspot.origin );
		self setplayerangles( level.aimspot.angles );
		self scorehud();
}






watchAlive()
{
trigger=getent("watchalive_start","targetname");

while(1)
	{
		trigger waittill("trigger", player);
		if(!isDefined (player.onwatch))
		{
		player.onwatch = 1;
		player watchstat();
		}
		
		wait(1);
	}
}


watchstat()
{
while(self.onwatch==1)
{
	 if(self.sessionstate != "playing")
		{
		level.alpha_team_counter--;
		/* [AUTO DELETE] iPrintlnbold(level.alpha_team_counter+ " in alpha team"); */
		/* [AUTO DELETE] iPrintln(self.name +"^1has died. -5 points"); */
		level.alphascore -= 5;
		self.onwatch = 0;
		}
		else
		{
		wait(1);
		}
}
}


scorehud()
{
	for( i = 0; i < level.targets.size; i++ )
	{
	level.targetcount= ((i*10)-30);
	}
	
	self.aimscore = newHudElem();	
	self.aimscore.x = -20;	//position on the x-axis
	self.aimscore.y = 75;	//position on the <-axis
	self.aimscore.horzAlign = "right";	
	self.aimscore.vertAlign = "middle";
	self.aimscore.alignX = "right";
	self.aimscore.alignY = "middle";
	self.aimscore.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	self.aimscore.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	self.aimscore.archived = false;	//visible in killcam
	self.aimscore.alpha = 1;	//transparency	0 = invicible, 1 = visible
	self.aimscore.fontScale = 1.9;	//textsize
	self.aimscore.hidewheninmenu = false;	//will it be visble when a player is in a menu
	self.aimscore.color = (1,0,0);	//RGB color code
	self.aimscore.label = &"AlphaTeam score: &&1";	//The text for the hud & is required, &&1 is the value which will be added below
	
	self.teamcount = newHudElem();	
	self.teamcount.x = -20;	//position on the x-axis
	self.teamcount.y = 55;	//position on the <-axis
	self.teamcount.horzAlign = "right";	
	self.teamcount.vertAlign = "middle";
	self.teamcount.alignX = "right";
	self.teamcount.alignY = "middle";
	self.teamcount.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	self.teamcount.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	self.teamcount.archived = false;	//visible in killcam
	self.teamcount.alpha = 1;	//transparency	0 = invicible, 1 = visible
	self.teamcount.fontScale = 1.9;	//textsize
	self.teamcount.hidewheninmenu = false;	//will it be visble when a player is in a menu
	self.teamcount.color = (1,0,0);	//RGB color code
	self.teamcount.label = &"AlphaTeam Players: &&1 / 3";	//The text for the hud & is required, &&1 is the value which will be added below
	
	while(1)
	{
	wait 1;
		self.alphascore = level.alphascore;
		self.aimscore setValue(self.alphascore);	//if self.count is a integer
		self.aimscore setText(self.alphascore +" / " +(level.targetcount));	//if self.count is a string
		
		self.alphateamcount = level.alpha_team_counter;
		self.teamcount setValue(self.alphateamcount);	//if self.count is a integer
		self.teamcount setText(self.alphateamcount);	//if self.count is a string

	}
}



aimingtargets()
{

	wait(5);
	i = 0;
	while( isDefined( getEnt( "trigger_damage_" + i, "targetname" ) ) )
	{
		level.target_triggers[ i ] = getEnt( "trigger_damage_" + i, "targetname" );
		i++;
	}
	
	i = 0;
	while( isDefined( getEnt( "target_aim_" + i, "targetname" ) ) )
	{
		level.targets[ i ] = getEnt( "target_aim_" + i, "targetname" );
		i++;
	}
	
	 level.targetcount = i;
	 for(x=0;x<level.targetcount;x++)
	 {
	 thread targetmonitor(level.targets[ x ],level.target_triggers[ x ]);
	 }
	 
	 thread randomizetargets();
	 
	 

}


randomizetargets()
{
	for(i=0;i<level.targetcount/((level.targetcount/100)*25);i++)
	{
	rand = RandomIntRange(0, level.targetcount );
	level.targets[ rand ] delete();
	level.target_triggers[ rand ] delete();
	
	}
}


targetmonitor(target,trigger)
{
	trigger waittill("trigger",player);
	trigger delete();
	target delete();
	if(level.alphascore<200)
	{
	level.alphascore += 10;	
	}
	
}


aimgamedoors()
{
	wait(5);
	i = 0;
	while( isDefined( getEnt( "door_" + i, "targetname" ) ) )
	{
		level.endgamedoors[ i ] = getEnt( "door_" + i, "targetname" );
		i++;
	}
	
	i = 0;
	while( isDefined( getEnt( "trigger_door_" + i, "targetname" ) ) )
	{
		level.trigger_endgamedoors[ i ] = getEnt( "trigger_door_" + i, "targetname" );
		i++;
	}
	
	 max = i;
	 for(x=0;x<max;x++)
	 {
	 thread opendoor(level.endgamedoors[ x ],level.trigger_endgamedoors[ x ]);
	 }	
}


opendoor(door,trigger)
{
trigger waittill("trigger", player);
/* [AUTO DELETE] player iPrintln("^1Broke the door !"); */
wait(0.8);
door delete();
}


trickroom1()
{
trigger=getent("trickroom_1","targetname");
trigger waittill("trigger", other);
rand = RandomInt( 5 );
switch (rand)
	{
		case 0:
			other explosion();	
		break;
		case 1:
			other Xpreward();	
		break;
		case 2:
			other explosion();	
		break;
		case 3:
			other Xpreward();	
		break;
		case 4:
			other explosion();	
		break;
		case 5:
			other Xpreward();	
		break;
		
	}
}


explosion()
{
	explodeplace=getent("xplode","targetname");
	playFx(level.impact_fx, explodeplace.origin);
	self playSound( "artillery_impact" );
	radiusDamage( explodeplace.origin, 300, 200, 40  );
}


Xpreward()
{
iPrintln(self.name +"^1Found a Booster");
level.alphascore += 5;
}


unlockpart1()
{
trigger=getent("unlock_part1","targetname");
door=getent("door_part1","targetname");
locked = true;
while(locked==true)
{
trigger waittill("trigger", player);
	if(self.alphascore>=level.targetcount)
	{
	/* [AUTO DELETE] player iPrintln("^Unlocked the door !"); */
	/* [AUTO DELETE] iPrintlnbold("AlphaTeam has unlocked the next part !"); */
	wait(0.8);
	door delete();
	locked=false;
	}
	else
	{
	/* [AUTO DELETE] player iPrintlnbold("Your team has not been able to get enough points yet !"); */
	}
}
}
