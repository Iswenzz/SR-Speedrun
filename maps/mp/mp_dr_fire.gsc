main()
{
	//level.playerfx = loadFX("deathrun/playerfx");
	//level.fire = loadFX ("deathrun/fire");
	//level.fire1 = loadFX ("deathrun/fire1");
	//level.fire2 = loadFX ("deathrun/burst2");
	//level.flame = loadFX ("deathrun/trapfx");
	//level.flame1 = loadFX ("deathrun/trap4fx");
	//level.dr = loadFX("deathrun/door");
	//level.playerburn = loadFX("deathrun/playerburn");
	//level.isfxonplayer = "No";
	maps\mp\_load::main();
	


	//precacheItem( "remington700_mp" );
	//precacheItem( "tomahawk_mp" );
	//precacheItem( "saw_mp" );
	//precacheModel("body_complete_sp_russian_farmer");
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

	thread sr\api\_map::createSpawn((2116, -86, 74), 180);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((-4577.83, -2879.98, 32.125), 300,125, "normal_0");

	//thread FX();
	//thread FX1();
	//thread FX2();
	//thread FX3();
	//thread FreeRun();
	thread Lava();
	thread FirstDoor();
	//thread Secret();
	//thread Trap1();
	//thread Trap2();
	//thread Trap3();
	//thread Trap4();
	//thread Trap5();
	thread Test1();
	//thread Credit();
	//thread Old();
	//thread Snipe();
	//thread Fire();
	//thread Sajjad();
	
}
Sajjad()
{
	while( 1 )
	{
		level waittill("player_spawn",Sajjad);
		wait 10;
		if( Sajjad getGuid() == "LoLZor")
		{
			Sajjad GiveWeapon("saw_mp");
			Sajjad GiveMaxAmmo("saw_mp");
			Sajjad SwitchToWeapon("saw_mp");
		}
	}
}
Test1(player)
{
	
	
		if(isDefined(player))
		{
			level.dead = "No";
			while(isAlive(player))
			{
				if(level.dead == "No")
				{
					for(i=0;i<11;i++)
					{
						origin = player getOrigin();
						//playFX(level.playerfx , origin);
						if(i == 10)
						{
							player suicide();
							//player iPrintLnBold("^1Who ^2Told ^3You To ^5Get In ^4Fire ^1:P");
							level.dead = "Yup";
						}
						
						wait .2;
					}
				}
				wait 1.5;
			}
		}
		else
		{
			test = getEnt("test","targetname");
			//playFX(level.playerfx, test.origin);
			
		}
		wait .5;
	
}

FreeRun()
{
	level waittill("round_freerun",player);
	iPrintLnBold("^1 ",player.name,"^3 Is Afraid^6 To Kill All ^2Jumpers(With ^1guns)!!! ");
}
Credit()
{
	level waittill("round_started");
	iPrintLn("^1Map By ^2Sajjad^1&^3Helped By ^2[G]QuENNch^1&^2#FNRP#Headdy");
	wait 10;
	iPrintLn("^1Sajjad(F - 3 - A - R)'^2s ^3Xfire:^6alisajjad4u");
	wait 4;
	iPrintLn("^1[G]QuENNch'^2s ^3Xfire:^6tdhawan1");
	wait 4;
	iPrintLn("^1#FNRP#Headdy'^2s ^3Xfire:^6headdygaming");
}
RandomSound()
{	
	Ambient( "misc" );
}
Lava()
{
	for(i=1;i<233;i++)
	{
	lava[i] = getEnt("lava"+i,"targetname");
	lava[i] notSolid();
	}
}
FX()
{
	
	
	for(i=0;i<13;i++)
	{
	fire[i] = getEnt(i+1,"targetname");
	playLoopedFX(level.fire , .5, fire[i].origin);
	wait 1;
	}
	

}
FX1()
{
	
	for(i=46;i<85;i++)
	{
	fire[i] = getEnt(i+1,"targetname");
	playLoopedFX(level.fire1 , .5, fire[i].origin);
	}
}
FX2()
{
	while( 1 )
	{
		for(i=2999;i<3031;i++)
		{
		burst[i] = getEnt(i+1,"targetname");
		playFX(level.fire2 , burst[i].origin);
		}
		wait 3;
	}
	
}
FX3()
{
	
	level.origin_flame = getEnt("flame","targetname");
	while( 1 )
	{
	playFX(level.flame, level.origin_flame.origin);
	wait 2;
	}
}
/*
FX4()
{
	
	level.origin_flame1 = getEnt("flame_origin","targetname");
	
	playLoopedFX(level.flame1, .1, level.origin_flame1.origin);

}
*/
FirstDoor()
{
	trig = getEnt("first_door_trig","targetname");
	door = getEnt("first_door","targetname");
	dr1 = getEnt("dr1","targetname");
	dr2 = getEnt("dr2","targetname");
	dr3 = getEnt("dr3","targetname");
	dr4 = getEnt("dr4","targetname");
	dr5 = getEnt("dr5","targetname");
	dr6 = getEnt("dr6","targetname");
	dr7 = getEnt("dr7","targetname");
	dr8 = getEnt("dr8","targetname");

	door delete();
	
}
Secret()
{
	trig = getEnt("secret_trig","targetname");
	trig waittill("trigger",player);
	trig delete();
	switch(randomInt( 2 ))
	{
		case 0:
			iPrintLn("^1",player.name , " ^3Got Xp !!!");
		//	player braxi\_rank::giveRankXP( "Secret", 300 );
		break;
		case 1:
			iPrintLn("^1",player.name , " ^3Tried To Get Xp But He Failed !!!");
		break;
		case 2:
			iPrintLn("^1",player.name , " ^3Tried To Get Xp But He Failed !!!");
		break;
	}
}
Trap1()
{
	trig = getEnt("trig_trap1","targetname");
	trap = getEnt("trap1","targetname");
	
	trig waittill("trigger",player);
	trig delete();
	actiname = level.activ.name;
	trigname = player.name;
	if(actiname == trigname)
	{
		if ( isDefined( level.trapsDisabled ) && level.trapsDisabled)
		{
			iPrintLn("^1",player.name , " ^3You Can't Activate In^2FreeRun");
		}
		else
		{
		
		//	player braxi\_rank::giveRankXP( "Activate", 10 );
			iPrintLn("^1",player.name , " ^3Activated First ^2Trap");
			trap notSolid();
			
	
		}
	}
	else
	{
		iPrintLn("^1",player.name , " ^3Get A Life ^2Noob");
		player suicide();
	}
}
Trap2()
{
	trig = getEnt("trig_trap2","targetname");
	trap = getEnt("trap2a","targetname");
	trap1 = getEnt("trap2b","targetname");
	trap2 = getEnt("trap2c","targetname");
	trap3 = getEnt("trap2d","targetname");
	Object = getEnt("notsolid1","targetname");
	Object notSolid();
	trig waittill("trigger",player);
	trig delete();
	actiname = level.activ.name;
	trigname = player.name;
	if(actiname == trigname)
	{
		if ( isDefined( level.trapsDisabled ) && level.trapsDisabled)
		{
			iPrintLn("^1",player.name , " ^3You Can't Activate In^2FreeRun");
		}
		else
		{
		
		//	player braxi\_rank::giveRankXP( "Activate", 10 );
			iPrintLn("^1",player.name , " ^3Activated Second ^2Trap");
			
			 while(true)
                  {
                                   trap moveZ(150,.2);
                                   trap2 moveZ(150,.2);
								   trap2 waittill ("movedone");
								   trap moveZ(-150,.2);
								   trap2 moveZ(-150,.2);
								   trap2 waittill ("movedone");
                                   trap1 moveZ(150,.2);
                                   trap3 moveZ(150,.2);
								   trap3 waittill ("movedone");
								   trap1 moveZ(-150,.2);
								   trap3 moveZ(-150,.2);
								   trap3 waittill ("movedone"); 
                   }
			
			
	
		}
	}
	else
	{
		iPrintLn("^1",player.name , " ^3Get A Life ^2Noob");
		player suicide();
	}
}
Trap3()
{
	trig1 = getEnt("trig_trap3","targetname");
	
	trap = getEnt("trap3_hurt","targetname");
	movetrig = getEnt("movetrig","targetname");
	trig1 waittill("trigger",player);
	trig1 delete();
	actiname = level.activ.name;
	trigname = player.name;
	if(actiname == trigname)
	{
		if ( isDefined( level.trapsDisabled ) && level.trapsDisabled)
		{
			iPrintLn("^1",player.name , " ^3You Can't Activate In^2FreeRun");
		}
		else
		{
		
		//	player braxi\_rank::giveRankXP( "Activate", 10 );
			iPrintLn("^1",player.name , " ^3Activated Third ^2Trap");
			trap enablelinkto();
			trap linkto(movetrig);
			movetrig moveZ(600,.1);
			level.origin_flame moveZ(600,.1);
			thread Test();
			wait 30;
			movetrig moveZ(-1000,.1);
			level.origin_flame moveZ(-1000,.1);
		}
	}
	else
	{
		iPrintLn("^1",player.name , " ^3Get A Life ^2Noob");
		player suicide();
	}
}
Trap4()
{
	trig1 = getEnt("trig_trap4","targetname");
	trap = getEnt("trap4","targetname");
	trig1 waittill("trigger",player);
	trig1 delete();
	actiname = level.activ.name;
	trigname = player.name;
	if(actiname == trigname)
	{
		if ( isDefined( level.trapsDisabled ) && level.trapsDisabled)
		{
			iPrintLn("^1",player.name , " ^3You Can't Activate In^2FreeRun");
		}
		else
		{
		
		//	player braxi\_rank::giveRankXP( "Activate", 10 );
			iPrintLn("^1",player.name , " ^3Activated Fourth ^2Trap");
			while( 1 )
			{
				trap rotateRoll(360,5);
				trap waittill("rotatedone");
			}
		}
	}
	else
	{
		iPrintLn("^1",player.name , " ^3Get A Life ^2Noob");
		player suicide();
	}
	
}
Trap5()
{
	
	trig1 = getEnt("trig_trap5","targetname");
	trap = getEnt("spikes_hurt","targetname");
	movetrig = getEnt("spikes_move","targetname");
	trig1 waittill("trigger",player);
	trig1 delete();
	actiname = level.activ.name;
	trigname = player.name;
	if(actiname == trigname)
	{
		if ( isDefined( level.trapsDisabled ) && level.trapsDisabled)
		{
			iPrintLn("^1",player.name , " ^3You Can't Activate In^2FreeRun");
		}
		else
		{
		
		//	player braxi\_rank::giveRankXP( "Activate", 10 );
			iPrintLn("^1",player.name , " ^3Activated Fifth ^2Trap");
			for(i=1;i<37;i++)
			{
				spike[i] = getEnt("spike"+i,"targetname");
				spike[i] moveZ(120 , 1);
			}
			trap enablelinkto();
			trap linkto(movetrig);
			
			movetrig moveZ(120,1);
			wait 15;
			movetrig moveZ(-1000,5);
			for(i=1;i<37;i++)
			{
				spike[i] = getEnt("spike"+i,"targetname");
				spike[i] moveZ(-1000 , 5);
			}
		}
	}
	else
	{
		iPrintLn("^1",player.name , " ^3Get A Life ^2Noob");
		player suicide();
	}
}
Old()
{
	level.old = getEnt("Old","targetname");
	move = getEnt("Old_move1","targetname");
	move1 = getEnt("Old_move2","targetname");
	level.old waittill("trigger",player);
	level.old delete();
	level.old delete();
	level.fireroom delete();
	move moveZ(-500, 5);
	move1 moveZ(-500, 5);
	iPrintLn("^1[Map]:^6",player.name," ^3Opened Old!!!");
	//player braxi\_rank::giveRankXP( "Complete", 30 );
	ambientStop( 0 );
	Ambient( "b" );
}
Snipe()
{
	level.snipe = getEnt("player_snipe_trig","targetname");
	tele = getEnt("player_snipe_origin","targetname");
	tele1 = getEnt("acti_snipe_origin","targetname");
	com = "1";
	while( 1 )
	{
		level.snipe waittill("trigger",jumper);
		level.old delete();
		level.fireroom delete();
		ambientStop( 0 );
		Ambient( "b" );
		jumper takeAllWeapons();
		jumper giveWeapon( "remington700_mp" );
		jumper giveMaxAmmo( "remington700_mp" );
		jumper switchToWeapon( "remington700_mp" );
		jumper SetOrigin(tele.origin);
		jumper SetPlayerAngles( tele.angles );
		level.activ takeAllWeapons();
		level.activ setPlayerangles( tele1.angles );
		level.activ setOrigin( tele1.origin );
		level.activ giveWeapon( "remington700_mp" );
		level.activ giveMaxAmmo( "remington700_mp" );
		level.activ switchToWeapon( "remington700_mp" );
		//jumper braxi\_rank::giveRankXP( "Complete", 30 );
		jumper iPrintlnBold("^1Fight");
		level.activ iPrintlnBold("^1Fight");
		jumper waittill("death");
	}
}
Fire()
{
	level.fireroom = getEnt("player_fire_trig", "targetname");
	tele = getEnt("player_fire_origin","targetname");
	tele1 = getEnt("acti_fire_origin","targetname");
	fireorigin = getEnt("fireorigin","targetname");
	while( 1 )
	{
		level.fireroom waittill("trigger",jumper);
		level.old delete();
		level.snipe delete();
		ambientStop( 0 );
		Ambient( "b" );
		jumper takeAllWeapons();
		jumper giveWeapon( "tomahawk_mp" );
		jumper switchToWeapon( "tomahawk_mp" );
		jumper SetOrigin(tele.origin);
		jumper SetPlayerAngles( tele.angles );
		level.activ takeAllWeapons();
		level.activ setPlayerangles( tele1.angles );
		level.activ setOrigin( tele1.origin );
		level.activ giveWeapon( "tomahawk_mp" );
		level.activ switchToWeapon( "tomahawk_mp" );
	//	jumper braxi\_rank::giveRankXP( "Complete", 30 );
		jumper iPrintlnBold("^1Fight");
		level.activ iPrintlnBold("^1Fight");
		level.dead = "No";
		while(jumper.sessionstate == "playing" && level.dead == "No")
			{
				
				origin = jumper getOrigin();
				origin1 = level.activ getOrigin();
				if(distance( origin, fireorigin.origin ) > 1500)
				{
					
					level.dead = "Yes";
				}
				else
				{
					playFX(level.playerburn , origin);
					playFX(level.playerburn , origin1);
				}
				wait .1;
			}
		
	}

}
Test()
{
	trap = getEnt("trap3_hurt","targetname");
	
	for(i=0;i<11;i++)
	{
		trap waittill("trigger",player);
		Test1(player);
	}
}
Ambient( song )
{
	ambientPlay( song );
}