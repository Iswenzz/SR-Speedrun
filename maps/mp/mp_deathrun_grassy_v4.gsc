main()
{

	PrecacheModel("vehicle_mig29_desert");
	PrecacheModel("projectile_cbu97_clusterbomb");
	PrecacheModel("vehicle_mi24p_hind_mp");
	PrecacheModel("vehicle_mi17_woodland");
	precacheModel( "mw2_vehicle_apache_fly" );
	precacheItem( "ak47_mp" );
	precacheItem( "brick_blaster_mp" );
	precacheItem( "barrett_mp" );
	precacheItem( "deserteagle_mp" );
	precacheItem( "deserteaglegold_mp" );
	precacheItem( "uzi_mp" );
	precacheItem( "rpg_mp" );
	precacheItem( "mp44_mp" );
	precacheItem( "dragunov_acog_mp" );
    precacheItem( "m60e4_grip_mp" );
	level.trig = getent( "ufotrig", "targetname" );

	maps\mp\_load::main();
	//maps\mp\_effectsounds::main();
	//maps\mp\mp_deathrun_grassy_v4_sound_fx::main();
	//maps\mp\mp_deathrun_grassy_v4_fx::main();
	//maps\mp\_secret_grassy::main();
	//maps\mp\_secret_grassy_2::main();
	//maps\mp\_secret_grassy_3::main();
	//maps\mp\_ac130_moving::main();
	//maps\mp\_door::main();
	//maps\mp\_rotateufo::main();
	//maps\mp\_deathsound::main();
	//maps\mp\_dynamic_foliage2::initdfs();
	
	
	thread sr\api\_map::createSpawn((520, -1773, 124),87);

	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

        trigger = spawn( "trigger_radius", (2918.76, -1943.2, 64.125), 0, 210, 100 );
        trigger.targetname = "endmap_trig";
        trigger.radius = 210;




	 thread way_connect();

	//thread trap_1();
	//thread trap_2();
	//thread trap_3();
	//thread trap_4();
	//thread trap_5();
	//thread trap_6();
	//thread trap_7();
	//thread trap_8();
	//thread trap_9();
	//thread nyancat();
	//thread finaldoor();
	//thread addtrapstofreerun();
	//thread mainscreen();
	//thread nyanmove();
	//thread FlyingHelicopter();
	//thread FlyingHelicopter2();
	//thread camera1();
	//thread camera2();
	//thread fuckinghands();
	//thread finaltele();
	//thread ufo();
	//thread snake();
    thread firstblock();
	//thread mannequin();
	//thread fake21();
	//thread ammorestock();
	//thread ammorestock1();
	//thread ammorestock2();
	//thread ammorestock3();
	//thread horseplay();
	//thread trolo1();
	//thread trolo2();
	//thread troloplay();
	//thread elena();
	//thread clips();
}


way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    for(;;) 
    {
        level waittill( "connected", player );

    }
}



trap_1()
{
	trig = getEnt( "trigger1", "targetname" );

	brush1 = getEnt( "trap4_1", "targetname" );
	brush2 = getEnt( "trap4_2", "targetname" );

	oldOrigin1 = brush1.origin;
	oldOrigin2 = brush2.origin;

	trig waittill( "trigger", who );

}

trap_2()
{
	trig = getEnt( "trigger2", "targetname" );
	brush = getEnt( "trap1", "targetname" );

	trig waittill( "trigger", who );
	
	
}

trap_3()
{
	trig = getEnt( "trigger3", "targetname" );
	
	trig waittill("trigger", who );
	
}

trap_4()
{
	trig = getEnt( "trigger4", "targetname" );
	brush = getEnt( "trap8", "targetname" );

	trig waittill( "trigger", who );

}

trap_5()
{
	trig = getEnt( "trigger5", "targetname" );
	brush = getEnt( "trap9", "targetname" );

	trig waittill( "trigger", who );
	
}

trap_6()
{
	trig = getEnt( "trigger6", "targetname" );
	brushGroup1 = getEntArray( "trap11_1", "targetname" );
	brushGroup2 = getEntArray( "trap11_2", "targetname" );

	trig waittill( "trigger", who );
	
}

trap_7()
{
	trig = getEnt( "trigger7", "targetname" );
	brush = getEnt( "trap13", "targetname" );

	trig waittill( "trigger", who );
	
}

trap_8()
{
	trig = getEnt( "trigger8", "targetname" );
	brush = getEnt( "trap12", "targetname" );

	trig waittill( "trigger", who );
	
}


trap_9()
{
	trig = getEnt( "trigger9", "targetname" );
	brush1 = getEnt( "movinupndown1", "targetname" );
	brush2 = getEnt( "movinupndown2", "targetname" );
	brush3 = getEnt( "movinupndown3", "targetname" );
	brush4 = getEnt( "movinupndown4", "targetname" );

	trig waittill( "trigger", who );
	
}


nyancat()
{
	trig = getEnt( "nyancattrig", "targetname" );
	brush = getEnt( "nyancat", "targetname" );

	trig waittill( "trigger", who );
	

}

trigger_init()
{
	soundtriggers = getentarray( "sound_trigger", "targetname" );

	for( i = 0; i < soundtriggers.size; i++ )
		soundtriggers[i] thread trigger_sound();
}

trigger_sound()
{
	self.wait_for_retrigger = false;
	soundpos = getent( self.target, "targetname" );

	while( 1 )
	{
		if( !self.wait_for_retrigger )
		{
			self waittill( "trigger" );
			self.wait_for_retrigger = true;
			soundpos thread play_the_sound( self, soundpos.script_noteworthy );
		}
		wait 0.1;
	}
}

play_the_sound( used_trigger, sound )
{
		self playsound( sound );
		wait 30000;
		used_trigger.wait_for_retrigger = false;
}




addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
addtrapstofreerun()
{
	addTriggerToList("trigger1");
	addTriggerToList("trigger2");
	addTriggerToList("trigger3");
	addTriggerToList("trigger4");
	addTriggerToList("trigger5");
	addTriggerToList("trigger6");
	addTriggerToList("trigger7");
	addTriggerToList("trigger8");
	addTriggerToList("trigger9");
}


finalDoor()
{
	trig = getEnt( "finaldoortrig", "targetname" );
	brush = getEnt( "finaldoor", "targetname" );

	trig waittill( "trigger", who );
	trig delete();
	brush moveZ( -200, 10 );
}

mainscreen()

{

   first = getent ("first","targetname");
   first hide(); 
     wait 0.5;
    
   second = getent ("second","targetname");
   second hide();
    wait 0.5;
	

    

		while(1)
	{
		first show();
		wait 0.1;
		first hide();
		second show();
		wait 0.1;
		second hide();

	}
}





nyanmove()
{
	trig = getEnt( "nyanmovetrig", "targetname" );
	brush = getEnt( "nyanmove", "targetname" );

	trig waittill( "trigger", who );
	iprintlnbold("^2NYAN CATTY ^1INCOMING!!!");
	trig delete();

	brush movex( -2250, 20 );

}

FlyingHelicopter()
{
	while(1)
	{
		players = getentarray("player", "classname");
		if( players.size > 0 )
			break;
		wait 1;
	}
	players = getentarray("player", "classname");
	player = players[RandomInt(players.size)];
	
	targets = getEntArray("choppa_path", "targetname");
	chopper = spawn_helicopter( player, targets[RandomInt(targets.size)].origin, (0,0,0), "cobra_mp", "vehicle_mi17_woodland" );
	chopper playLoopSound( "mp_cobra_helicopter" );
	chopper.owner = undefined;
	chopper.maxhealth = 1;
	chopper.health = chopper.maxhealth;
	chopper setDamageStage( 3 );
	chopper setSpeed( 25, 15 );
	wait 1;
	
	while(1)
	{
		chopper setVehGoalPos( targets[RandomInt(targets.size)].origin, true );
		chopper waittill("goal");
		chopper setGoalYaw( RandomInt(361) );
		wait 3+RandomInt(5);
	}
}

spawn_helicopter( owner, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	return chopper;
}

FlyingHelicopter2()
{
	while(1)
	{
		players = getentarray("player", "classname");
		if( players.size > 0 )
			break;
		wait 1;
	}
	players = getentarray("player", "classname");
	player = players[RandomInt(players.size)];
	
	targets = getEntArray("choppa_path2", "targetname");
	chopper = spawn_helicopter( player, targets[RandomInt(targets.size)].origin, (0,0,0), "cobra_mp", "mw2_vehicle_apache_fly" );
	chopper playLoopSound( "mp_cobra_helicopter" );
	chopper.owner = undefined;
	chopper.maxhealth = 1;
	chopper.health = chopper.maxhealth;
	chopper setDamageStage( 3 );
	chopper setSpeed( 25, 15 );
	wait 1;
	
	while(1)
	{
		chopper setVehGoalPos( targets[RandomInt(targets.size)].origin, true );
		chopper waittill("goal");
		chopper setGoalYaw( RandomInt(361) );
		wait 3+RandomInt(5);
	}
}



camera1()
{
	trig = getEnt( "camera1", "targetname" );
	
		trig waittill( "trigger", who );
		who PlaySound("camera");
		trig delete ();

}

camera2()
{
	trig = getEnt( "camera2", "targetname" );
	
		trig waittill( "trigger", who );
		who PlaySound("camera");
		trig delete ();


}



ufo()
{
	level.trig waittill("trigger");
	level.trig delete();
	level.plat = getEnt( "ufo", "targetname" );
	points = [];
	if( isDefined( level.plat.target ) )
		points[points.size] = getEnt( level.plat.target, "targetname" );

	ENDED = false;
	while( !ENDED )
	{
		level.plat moveTo( points[points.size-1].origin, 2 );
		wait 2;
		
		// find another target, otherwise quit
		if( isDefined( points[points.size-1].target ) )
			points[points.size] = getEnt( points[points.size-1].target, "targetname" );
		else
			ENDED = true;
	}

}

//Script by Brax :3 <3

fuckinghands()
{
	trig = getEnt( "fuckinghands", "targetname" );
	trig waittill( "trigger", who );
	who PlaySound("fuckinghands");
	trig delete();
}

firstblock()
{
	trig = getEnt( "firstblocktrig", "targetname" );
	brush = getEnt( "firstblock", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	brush movez( -184, 10 );

}

snake()
{
	trig = getEnt( "snaketrig", "targetname" );
	snake = getEnt( "snake", "targetname" );

	trig waittill( "trigger", who );
	iprintlnbold("^1Oh a snake!");
	trig delete();

	snake movez( 8, 2 );

}

mannequin()
{
	trig = getEnt( "mannequintrig", "targetname" );
	mannequin1 = getEnt( "mannequin1", "targetname" );
	mannequin2 = getEnt( "mannequin2", "targetname" );
	mannequin3 = getEnt( "mannequin3", "targetname" );

	trig waittill( "trigger", who );
	iprintlnbold("^0Mannequins? ^2wtf");
	trig delete();

	mannequin1 movez( 77, 10 );
	mannequin2 movez( 77, 8 );
	mannequin3 movez( 77, 5 );

}


fake21()
{
	trig = getEnt( "killtrigger", "targetname" );
	trig waittill( "trigger", player );
	iprintlnbold("" + " " + "^1"+ player.name + " "+ "^7is a ^1NOOB");
	wait 1;
	player suicide();
	trig delete();

}

finaltele()
{
	trig = getEnt("finaltele", "targetname");
	
	trig waittill("trigger", player);
	trig delete();
	
	if( GetTeamPlayersAlive("allies") > 1 && !level.freeRun )
		return;
	
	x = 1+RandomInt(3);
	porterA = getEnt("porter_activator_"+x, "targetname");
	porterJ = getEnt("porter_jumper_"+x, "targetname");
	
	gun = GetRandomWeapon( x );
	
	players = getEntArray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( IsAlive(players[i]))
		{
			if( players[i].pers["team"] == "allies" )
			{
				players[i] SetPlayerAngles( porterJ.angles );
				players[i] SetOrigin( porterJ.origin );
				players[i] TakeAllWeapons();
				players[i] GiveWeapon( gun );
				wait 0.01;
				players[i] SwitchToWeapon( gun );
		        player.maxhealth = 500;
		        player.health = player.maxhealth;
			}
			if( players[i].pers["team"] == "axis" )
			{
				players[i] SetPlayerAngles( porterA.angles );
				players[i] SetOrigin( porterA.origin );
				players[i] TakeAllWeapons();
				players[i] GiveWeapon( gun );
				wait 0.01;
				players[i] SwitchToWeapon( gun );
		        player.maxhealth = 500;
		        player.health = player.maxhealth;
			
			}
		}
	}
}

GetRandomWeapon( num )
{
	if( num == 2 )
		return "barrett_mp";
	else
	{
		x = RandomInt( 51 );
		if( x < 10 )
			return "brick_blaster_mp";
		if( x > 9 && x < 20 )
			return "deserteagle_mp";
		if( x > 20 && x < 30 )
			return "rpg_mp";
		if( x > 30 && x < 40 )
			return "m60e4_grip_mp";
		if( x > 40 && x < 50 )
			return "dragunov_acog_mp";
		if( x == 50 )
			return "ak47_mp";
	}
}



ammorestock()
{
	trig = getEnt( "ammorestock", "targetname" );
	while(isDefined(trig))
	{
		trig waittill( "trigger", player );
    	player SetWeaponAmmoStock( "uzi_mp", 300 );
		player SetWeaponAmmoStock( "deserteagle_mp", 300 );
	    player SetWeaponAmmoStock( "ak47_mp", 300 );
        player SetWeaponAmmoStock( "barrett_mp", 300 );
	    player SetWeaponAmmoStock( "rpg_mp", 300 );
	    player SetWeaponAmmoStock( "dragunov_acog_mp", 300 );
	    player SetWeaponAmmoStock( "m60e4_grip_mp", 300 );
		wait 5;
	}

}


ammorestock1()
{
	trig = getEnt( "ammorestock1", "targetname" );
	while(isDefined(trig))
	{
		trig waittill( "trigger", player );
    	player SetWeaponAmmoStock( "uzi_mp", 300 );
		player SetWeaponAmmoStock( "deserteagle_mp", 300 );
	    player SetWeaponAmmoStock( "ak47_mp", 300 );
        player SetWeaponAmmoStock( "barrett_mp", 300 );
	    player SetWeaponAmmoStock( "rpg_mp", 300 );
	    player SetWeaponAmmoStock( "dragunov_acog_mp", 300 );
	    player SetWeaponAmmoStock( "m60e4_grip_mp", 300 );
	    player SetWeaponAmmoStock( "brick_blaster_mp", 300 );
		wait 5;
	}


}


ammorestock2()
{
	trig = getEnt( "ammorestock2", "targetname" );
	while(isDefined(trig))
	{
		trig waittill( "trigger", player );
    	player SetWeaponAmmoStock( "uzi_mp", 300 );
		player SetWeaponAmmoStock( "deserteagle_mp", 300 );
	    player SetWeaponAmmoStock( "ak47_mp", 300 );
        player SetWeaponAmmoStock( "barrett_mp", 300 );
	    player SetWeaponAmmoStock( "rpg_mp", 300 );
	    player SetWeaponAmmoStock( "dragunov_acog_mp", 300 );
	    player SetWeaponAmmoStock( "m60e4_grip_mp", 300 );
	    player SetWeaponAmmoStock( "brick_blaster_mp", 300 );
		wait 5;
	}


}


ammorestock3()
{
	trig = getEnt( "ammorestock3", "targetname" );
	while(isDefined(trig))
	{
		trig waittill( "trigger", player );
    	player SetWeaponAmmoStock( "uzi_mp", 300 );
		player SetWeaponAmmoStock( "deserteagle_mp", 300 );
	    player SetWeaponAmmoStock( "ak47_mp", 300 );
        player SetWeaponAmmoStock( "barrett_mp", 300 );
	    player SetWeaponAmmoStock( "rpg_mp", 300 );
	    player SetWeaponAmmoStock( "dragunov_acog_mp", 300 );
	    player SetWeaponAmmoStock( "m60e4_grip_mp", 300 );
	    player SetWeaponAmmoStock( "brick_blaster_mp", 300 );
		wait 5;
	}


}


trolo1()
{
	trig = getEnt( "trolo1trig", "targetname" );
	brush = getEnt( "trolo1", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	brush movey( -960, 25 );

}


trolo2()
{
	trig = getEnt( "trolo2trig", "targetname" );
	brush = getEnt( "trolo2", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	brush movey( 960, 25 );

}

horseplay()
{
	trig = getEnt( "horse", "targetname" );
	
	trig waittill( "trigger", who );
	trig delete();
	


}


troloplay()
{
	trig = getEnt( "trolo", "targetname" );
	
	trig waittill( "trigger", who );
	trig delete();
	

}


elena()
{
	trig = getEnt( "115", "targetname" );
	
	trig waittill( "trigger", who );
	trig delete();
	

}



clips()
{
	trig = getEnt( "cliptrig", "targetname" );
	brush1 = getEnt( "clip1", "targetname" );
	brush2 = getEnt( "clip2", "targetname" );

	trig waittill( "trigger", who );
	trig delete();
	
	wait 5;
	brush1 movez( -500, 1 );
	brush2 movez( -500, 1 );

}
