
//#include maps\mp\jr_util;
main()
{
thread sr\api\_map::createSpawn((64.125, -56, 16.125), 0);

maps\mp\_load::main();

//maps\mp\_compass::setupMiniMap("compass_map_mp_shipment");

//setExpFog(500, 3500, .5, 0.5, 0.45, 0);
// ambientPlay("ambience");
VisionSetNaked( "mp_dr_overgrown");

game["allies"] = "marines"; 
game["axis"] = "opfor"; 

game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert"; 
game["axis_soldiertype"] = "desert"; 
setdvar( "r_specularcolorscale", "1" );

setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
//setdvar("compassmaxrange","1500");
precacheModel( "viewhands_mohw_marines" );

thread way_connect();
thread bouncer1();
//thread bouncer2();
thread bouncer3();
thread bouncer4();
// thread trap1();
// thread trap2();
thread trap3();
thread trap4();
// thread trap5();
thread effects();
thread door();
// thread ViewHands();
thread water();
// thread announce();
//thread fansounds();
// thread badmusic();

// addTriggerToList( "trap1_trigger" );
// addTriggerToList( "trap2_trigger" );
// addTriggerToList( "trap3_trigger" );
// addTriggerToList( "trap4_trigger" ); 
// addTriggerToList( "trap5_trigger" );

//level._effect["water_fx"] = loadfx ("misc/cargoship_water_noise"); //load FIRE fx
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

ViewHands()

{
	while(1)
	{
		level waittill( "jumper", who ); 
		who setViewmodel( "viewhands_mohw_marines" ); // Changes default viewhands to the MoH ones.
	}

}
//Part from Rednose released scripts

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1()
{
	chunk = getent("trap1_chunk","targetname");
	trap1_trigger = getent("trap1_trigger","targetname");
	trap1_fxorigin = getent("trap1_blast_origin","targetname");
	level._effect["explosion"] = loadfx ("explosions/speedex_biggerexplosion"); 

	// Wachten tot op de knop wordt gedrukt
	trap1_trigger waittill("trigger");
	trap1_trigger delete();

	
	playfx (level._effect["explosion"], trap1_fxorigin.origin);
	radiusDamage (trap1_fxorigin.origin, 2000, 2000, 100);
	earthquake(0.3, 3, trap1_fxorigin.origin, 800);
	trap1_fxorigin playsound("explosion");

	chunk hide();
	chunk notsolid();
	wait 4;
}

trap2()
{
	link = getent("link","targetname"); //link for hurt brush
	trap2_trigger = getent("trap2_trigger","targetname"); //acti trigger
	trap2_hurt = getent("trap2_hurt","targetname"); //Kill trigger
	trap2_sound = getent("trap2_sound","targetname"); //Kill trigger
    fire = GetEntArray("trap2_orig","targetname"); //fx origin array
	level._effect["fire"] = loadfx ("fire/jet_afterburner"); //load FIRE fx

	trap2_hurt enableLinkTo();
	trap2_hurt linkTo(link);
	// Wachten tot op de knop wordt gedrukt
	trap2_trigger waittill("trigger");
	trap2_trigger delete();

	FX = undefined;
	//Start fire fx on all origins
	while(1)
    {
		for(i=0;i<fire.size;i++)
        {
			FX[i] = spawnFX( level._effect["fire"], fire[i].origin );    
			TriggerFx( FX[i] );
        }
		link moveZ (68,.1);
		//trap2_sound playsound("fire");
        wait 1;
		
		link moveZ (-68,.1);
        for(i=0;i<fire.size;i++)
        {
			FX[i] delete();
        }

        wait 1;
    }
}
//From mp_deathrun_cave by xFearz

trap3()
{
	trap3_blockage = getent("trap3_blockage","targetname");
	trap3_trigger = getent("trap3_trigger","targetname");
	trap3_fx_origin = getent("trap3_fx_origin","targetname");

	trap3_blockage moveZ(-228, 1);

}


trap4()
{
	trap4 = getent("trap4","targetname");
	trap4_trigger = getent("trap4_trigger","targetname");

	trap4 moveX(80, 1);
	//trap4a rotatePitch(90, 1);
	//trap4b rotatePitch(90, 1);
	// Wachten tot op de knop wordt gedrukt

}


trap5()
{
	trap5 = getent("trap5","targetname");
	trap5_trigger = getent("trap5_trigger","targetname");
	trap5_fx = getent("trap5_fx","targetname");
	// Wachten tot op de knop wordt gedrukt
	trap5_trigger waittill("trigger");
	trap5_trigger delete();

	trap5_fx linkTo(trap5);

	while(1)
	{
		trap5 moveX(-200, 1);
		//thread fx();
		wait 1;
		trap5 moveX(400, 2);
		//thread fx();
		wait 2;
		trap5 moveX(-200, 1);
		//thread fx();
		wait 1;
	}
}

announce()
{
	while(1)
	{
		level waittill("jumper", player);
		player iprintln ("^1Map made by Speedex");
		wait 2;
		player iprintln ("^1Thanks to Imtroll for the test server!");
		player iprintln ("^1Also thanks to all players who tested this map!");
		wait 20;
	}
}

badmusic()
{
	dem = getent("dem","targetname");

	dem waittill("trigger", player);
	dem delete();

	ambientStop();
	ambientPlay("sander");
	player iprintln ("^1Blame sander for the crappy music!");
}

fx()
{
	trap5_fx = getent("trap5_fx","targetname");

	playfx (level._effect["water_fx"], trap5_fx.origin);
	wait 0.3;
}

water()
{
	trig = getent("water", "targetname");
	level.splash_fx = loadfx ("explosions/grenadeExp_water"); 

	while(true)
	{
		trig waittill ("trigger", who);	
		who PlaySound ("splash");
		PlayFX( level.splash_fx, who.origin );
		wait 1;
	}
}
//Also from rednose's released scripts

bouncer1()
{
	trigger = getEnt ( "bounce1", "targetname" );
	
	
	while(1)
	{	
    	trigger waittill ("trigger",user);
		if (user istouching(trigger))
		{ 
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,0,1)) ), 500 );		
		}
	}
}
/*
bouncer2()
{
	trigger2 = getent ("bounce2","targetname");
	

	for(;;)
	{
		trigger2 waittill ("trigger",user);
		if (user istouching(trigger2))
		{ 
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,-1,15)) ), 1900 );		
		}
	}
}
*/

bouncer3()
{
	trigger3 = getEnt ( "bounce3", "targetname" );
	
	
	for(;;)
	{
		trigger3 waittill ("trigger",user);
		if (user istouching(trigger3))
		{ 
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,-1,15)) ), 3900 );		
		}
	}
}


bouncer4()
{
	trigger4 = getEnt ( "bounce4", "targetname" );
	
	
	while(1)
	{	
    	trigger4 waittill ("trigger",user);
		if (user istouching(trigger4))
		{ 
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,0,1)) ), 500 );		
		}
	}
}


effects()
{
	fan1 = getent ("fan1","targetname");
	//fan2 = getent ("fan2","targetname");
	fan3 = getent ("fan3","targetname");
	fan4 = getent ("fan4","targetname");
	level._effect["dust"] = loadfx ("treadfx/tread_dust_hunted");
	fxfan1 = getent ("fxfan1","targetname");
	//fxfan2 = getent ("fxfan2","targetname");
	fxfan3 = getent ("fxfan3","targetname");
	fxfan4 = getent ("fxfan4","targetname");

	while(1)
	{
		playfx (level._effect["dust"], fxfan1.origin);
		//playfx (level._effect["dust"], fxfan2.origin);
		playfx (level._effect["dust"], fxfan3.origin);
		playfx (level._effect["dust"], fxfan4.origin);
		fan1 rotateYaw(360, 1);
		//fan2 rotateYaw(360, 1);
		fan3 rotateYaw(360, 1);
		fan4 rotateYaw(360, 1);
		wait 1;
	}

}

fansounds()
{
	fxfan1 = getent ("fxfan1","targetname");
	//fxfan2 = getent ("fxfan2","targetname");
	fxfan3 = getent ("fxfan3","targetname");
	fxfan4 = getent ("fxfan4","targetname");

	fxfan1 playsound("fan_loop");
	fxfan3 playsound("fan_loop");
	fxfan4 playsound("fan_loop");
}

door()
{
	door_left = getent ("door_left","targetname");
	door_right = getent ("door_right","targetname");
	door_fx = getent ("door_fx","targetname");
	door_trig = getent ("door_trig","targetname");

	wait 1;

	door_fx PlaySound ("door");
	door_left moveX(-64, 2);
	door_right moveX(64, 2);
}


