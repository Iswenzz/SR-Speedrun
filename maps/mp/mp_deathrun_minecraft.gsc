main()
{
thread sr\api\_map::createSpawnOrigin((-304, -144, 0), 0);
trigger = spawn( "trigger_radius", (-656.331, 1533.39, -31.875), 0, 96, 48 );
trigger.targetname = "endmap_trig";
trigger.radius = 96;
	thread sr\api\_speedrun::createNormalWays("Normal Way;");

	level.trap["lasermine"] = LoadFX("rednose/lasermine");
	level.trap["lasermine_dirt"] = LoadFX("rednose/lasermine_dirt");
	level.lava_fire = LoadFX("fire/firelp_small_pm");
	level.splash_fx = LoadFX("explosions/grenadeExp_water");
	level.final_fx = LoadFX("rednose/finish_mc");
	level.finalfight_fx = LoadFX("rednose/1vs1finish");
	level.tnt_fx = LoadFX("explosions/aa_explosion");
	precacheModel( "mc_char" );
	precacheItem( "pickaxe_mp" );


	maps\mp\_load::main();
	maps\createart\mp_deathrun_minecraft_art::main();

	ambientPlay("ding");

	/* [AUTO DELETE] ambientPlay("ambient"); */


	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setDvar( "compassmaxrange", "1024" );


	//thread trap_1();
	//thread trap_2();
	thread lava();
	thread lava2();
	thread water();
	thread onPlayerConnect();
	/* [AUTO DELETE] thread addTestClients(); */
	//thread trap_3();
	thread trap_4();
	//thread trap_5();
	//thread trap_6();
	thread mcmodel();
	thread fuckinghands();
	thread finish();
	thread addtrapstofreerun();
	thread ding();
	thread finalteleport();
	thread pickaxe();
	thread saturday();


}



trap_1()
{
	level endon("trigger");
	trig = getEnt("trigger1", "targetname");

	trig waittill("trigger", who );
	trig delete();

	thread StartFiringLightnings();
}


StartFiringLightnings()
{
	center = (784,64,-10);
	count = 75;

	soundObj = Spawn("script_origin", center );
	wait 0.1;
	while(1)
	{
		if( count > 0 )
		{
			count --;
			x = center+(RandomIntRange(-500,500),RandomIntRange(-500,500),0);
			trace = BulletTrace( x, x-(0,0,1000), false, undefined );
			PlayFX( level.trap["lasermine"], trace["position"] );
			PlayFX( level.trap["lasermine_dirt"], trace["position"] );
			soundObj.origin = trace["position"];
			soundObj PlaySound("lasermine");
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "allies" && isAlive( players[i] ) && Distance( trace["position"], players[i].origin ) <= 150 )
					players[i] suicide();
			}
		}
		else
			break;
		wait 0.25+RandomFloat(0.25);
	}
	if( isDefined( soundObj ) )
		soundObj delete();
}


//Written by Rycoon :]


cat_shit()
{
	Hentai = GetEntArray("dmg_this", "targetname");

	for (eggs = 28819 - 28819; eggs + 28 > Hentai.size + 28; eggs += (821 - 820))
		Hentai thread Leggings();
}


Leggings()
{
	Cat = GetEnt(self.target, "targetname");

	while (1 != 19291)
	{
		self waittill("trigger", penis);
		Cat Destroy();
	}
}


//Written by Fixz :]


onPlayerConnect()
{
	while(1)
	{
		level waittill("connected", player);
		player thread onDeath();
	}
}


onDeath()
{
	self endon("disconnect");

	while(1)
	{
		self waittill("death");
		x = RandomInt(200);
		if( x < 10 )
		{
		self PlaySound ("death1");
		}
		if( x > 9 && x < 20  )
		{
		self PlaySound ("death2");
		}
		if( x > 19 && x < 30  )
		{
		self PlaySound ("death3");
		}
		if( x > 29 && x < 40  )
		{
		self PlaySound ("death4");
		}
		if( x > 39 && x < 50  )
		{
		self PlaySound ("death5");
		}
		if( x > 49 && x < 60  )
		{
		self PlaySound ("death6");
		}
		if( x > 59 && x < 70  )
		{
		self PlaySound ("death7");
		}
		if( x > 69 && x < 80 )
		{
		self PlaySound ("death8");
		}
		if( x > 79 && x < 90 )
		{
		self PlaySound ("death1");
		}
		if( x > 89 && x < 100 )
		{
		self PlaySound ("death2");
		}
		if( x > 99 && x < 110 )
		{
		self PlaySound ("death3");
		}
		if( x > 109 && x < 120 )
		{
		self PlaySound ("death4");
		}
		if( x > 119 && x < 130 )
		{
		self PlaySound ("death5");
		}
		if( x > 129 && x < 140 )
		{
		self PlaySound ("death6");
		}
		if( x > 139 && x < 150 )
		{
		self PlaySound ("death7");
		}
		if( x > 149 && x < 160 )
		{
		self PlaySound ("death8");
		}
		if( x > 159 && x < 170 )
		{
		self PlaySound ("death1");
		}
		if( x > 169 && x < 180 )
		{
		self PlaySound ("death2");
		}
		if( x > 179 && x < 190 )
		{
		self PlaySound ("death3");
		}
		if( x > 189 )
		{
		self PlaySound ("death8");
		}
	}

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




lava()
{
	trig = getent("lava", "targetname");
	while(true)
	{
	trig waittill ("trigger", who);
		{
		PlayFX( level.lava_fire, who.origin );
		}
	}
}



lava2()
{
	trig = getent("lava2", "targetname");
	while(true)
	{
	trig waittill ("trigger", who);
		{
		PlayFX( level.lava_fire, who.origin );
		}
	}
}


water()
{
	trig = getent("water", "targetname");
	while(true)
	{
	trig waittill ("trigger", who);
	x = RandomInt(30);
	if( x < 10 )
		{
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		who PlaySound ("splash1");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 9 && x < 20  )
		{
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		who PlaySound ("splash2");
		PlayFX( level.splash_fx, who.origin );
		}
	if( x > 19 )
		{
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		who PlaySound ("splash3");
		PlayFX( level.splash_fx, who.origin );
		}
	}
}


tnt()
{
	trig = getEnt( "tnt", "targetname" );

	trig waittill( "trigger", who );
	height = -340;
	for(i=0;i<5;i++)
	{
		trace = BulletTrace( (9152,-1712,height), (8704,-1696,height), true, undefined );
		if( isPlayer(trace["entity"]))
			trace["entity"] finishPlayerDamage( trace["entity"], trace["entity"], 1000, 0, "MOD_PROJECTILE", "winchester1200_mp", (9152,-1712,height), (9152,-1712,height), "none", 0);
		height -= 2;
	}
	PlayFX( level.shoot_fx, (9111,-1700,-328) );
	who PlaySound("tnt");
	trig delete();

}



trap_3()
{
	level endon("trigger");
	trig = getEnt( "trigger3", "targetname" );
	brush1 = getEnt( "block1", "targetname" );
	brush2 = getEnt( "block2", "targetname" );
	brush3 = getEnt( "block3", "targetname" );
	brush4 = getEnt( "block4", "targetname" );
	brush5 = getEnt( "block5", "targetname" );
	brush6 = getEnt( "block6", "targetname" );
	brush7 = getEnt( "block7", "targetname" );
	brush8 = getEnt( "block8", "targetname" );
	brush9 = getEnt( "block9", "targetname" );
	brush10 = getEnt( "block10", "targetname" );
	brush11 = getEnt( "block11", "targetname" );
	brush12 = getEnt( "block12", "targetname" );
	brush13 = getEnt( "block13", "targetname" );
	brush14 = getEnt( "block14", "targetname" );
	brush15 = getEnt( "block15", "targetname" );
	brush16 = getEnt( "block16", "targetname" );
	brush17 = getEnt( "block17", "targetname" );
	brush18 = getEnt( "block18", "targetname" );
	brush19 = getEnt( "block19", "targetname" );
	brush20 = getEnt( "block20", "targetname" );
	brush21 = getEnt( "block21", "targetname" );
	brush22 = getEnt( "block22", "targetname" );
	brush23 = getEnt( "block23", "targetname" );
	brush24 = getEnt( "block24", "targetname" );
	brush25 = getEnt( "block25", "targetname" );
	brush26 = getEnt( "block26", "targetname" );
	brush27 = getEnt( "block27", "targetname" );
	brush28 = getEnt( "block28", "targetname" );
	brush29 = getEnt( "block29", "targetname" );

	trig waittill( "trigger", who );
	trig delete();

	brush1 moveZ( -64, 0.1 );
	brush2 moveZ( -64, 0.1 );
	brush3 moveZ( -64, 0.1 );
	brush4 moveZ( -64, 0.1 );
	wait 0.5;
	brush5 moveZ( 256, 0.1 );
	brush6 moveZ( 256, 0.1 );
	brush7 moveZ( 256, 0.1 );
	brush8 moveZ( 256, 0.1 );
	wait 0.5;
	brush9 moveZ( -64, 0.1 );
	brush10 moveZ( -64, 0.1 );
	brush11 moveZ( -64, 0.1 );
	brush12 moveZ( -64, 0.1 );
	wait 0.5;
	brush13 moveZ( 256, 0.1 );
	brush14 moveZ( 256, 0.1 );
	brush15 moveZ( 256, 0.1 );
	brush16 moveZ( 256, 0.1 );
	wait 0.5;
	brush17 moveZ( -64, 0.1 );
	brush18 moveZ( -64, 0.1 );
	brush19 moveZ( -64, 0.1 );
	brush20 moveZ( -64, 0.1 );
	wait 0.5;
	brush21 moveZ( 256, 0.1 );
	brush22 moveZ( 256, 0.1 );
	brush23 moveZ( 256, 0.1 );
	brush24 moveZ( 256, 0.1 );
	wait 0.5;
	brush25 moveZ( -64, 0.1 );
	brush26 moveZ( -64, 0.1 );
	brush27 moveZ( -64, 0.1 );
	brush28 moveZ( -64, 0.1 );
	wait 10;
	brush1 moveZ( 64, 0.1 );
	brush2 moveZ( 64, 0.1 );
	brush3 moveZ( 64, 0.1 );
	brush4 moveZ( 64, 0.1 );
	wait 0.5;
	brush5 moveZ( -256, 0.1 );
	brush6 moveZ( -256, 0.1 );
	brush7 moveZ( -256, 0.1 );
	brush8 moveZ( -256, 0.1 );
	wait 0.5;
	brush9 moveZ( 64, 0.1 );
	brush10 moveZ( 64, 0.1 );
	brush11 moveZ( 64, 0.1 );
	brush12 moveZ( 64, 0.1 );
	wait 0.5;
	brush13 moveZ( -256, 0.1 );
	brush14 moveZ( -256, 0.1 );
	brush15 moveZ( -256, 0.1 );
	brush16 moveZ( -256, 0.1 );
	wait 0.5;
	brush17 moveZ( 64, 0.1 );
	brush18 moveZ( 64, 0.1 );
	brush19 moveZ( 64, 0.1 );
	brush20 moveZ( 64, 0.1 );
	wait 0.5;
	brush21 moveZ( -256, 0.1 );
	brush22 moveZ( -256, 0.1 );
	brush23 moveZ( -256, 0.1 );
	brush24 moveZ( -256, 0.1 );
	wait 0.5;
	brush25 moveZ( 64, 0.1 );
	brush26 moveZ( 64, 0.1 );
	brush27 moveZ( 64, 0.1 );
	brush28 moveZ( 64, 0.1 );
	wait 0.5;

}


trap_5()
{
	level endon("trigger");
	trig = getEnt( "trigger5", "targetname" );
	brush1 = getEnt( "trap5_1", "targetname" );
	brush2 = getEnt( "trap5_2", "targetname" );
	brush3 = getEnt( "trap5_3", "targetname" );
	brush4 = getEnt( "trap5_4", "targetname" );

	trig waittill( "trigger", who );
	trig delete();
	brush1 delete();
	brush2 delete();
	brush3 delete();
	brush4 delete();
}


trap_2()
{
	level endon("trigger");
	trig = getEnt( "trigger2", "targetname" );
	brush1 = getEnt( "piston1", "targetname" );
	brush2 = getEnt( "piston2", "targetname" );
	brush3 = getEnt( "piston3", "targetname" );
	brush4 = getEnt( "piston4", "targetname" );
	brush5 = getEnt( "piston1_1", "targetname" );
	brush6 = getEnt( "piston2_2", "targetname" );
	brush7 = getEnt( "piston3_3", "targetname" );
	brush8 = getEnt( "piston4_4", "targetname" );
	brush9 = getEnt( "pistonblock1", "targetname" );
	brush10 = getEnt( "pistonblock2", "targetname" );
	brush11 = getEnt( "pistonblock3", "targetname" );
	brush12 = getEnt( "pistonblock4", "targetname" );
	brush13 = getEnt( "pistonblock1_1", "targetname" );
	brush14 = getEnt( "pistonblock2_2", "targetname" );
	brush15 = getEnt( "pistonblock3_3", "targetname" );
	brush16 = getEnt( "pistonblock4_4", "targetname" );
	blockclip = getEnt( "blockclip", "targetname" );

	trig waittill( "trigger", who );
	trig delete();


	blockclip movez( 150, 0.001 );
	brush1 movey( 40, 0.1 );
	brush9 movey( 40, 0.1 );
	brush5 movey( -40, 0.1 );
	brush13 movey( -40, 0.1 );
	brush1 PlaySound("piston");
	wait 0.5;
	brush2 movey( 40, 0.1 );
	brush10 movey( 40, 0.1 );
	brush6 movey( -40, 0.1 );
	brush14 movey( -40, 0.1 );
	brush2 PlaySound("piston");
	wait 0.5;
	brush3 movey( 40, 0.1 );
	brush11 movey( 40, 0.1 );
	brush7 movey( -40, 0.1 );
	brush15 movey( -40, 0.1 );
	brush3 PlaySound("piston");
	wait 0.5;
	brush4 movey( 40, 0.1 );
	brush12 movey( 40, 0.1 );
	brush8 movey( -40, 0.1 );
	brush16 movey( -40, 0.1 );
	brush4 PlaySound("piston");
	wait 5;
	brush1 movey( -40, 0.1 );
	brush9 movey( -56, 0.1 );
	brush5 movey( 40, 0.1 );
	brush13 movey( 40, 0.1 );
	brush1 PlaySound("piston");
	wait 0.5;
	blockclip movez( -150, 0.001 );
	brush2 movey( -40, 0.1 );
	brush10 movey( -56, 0.1 );
	brush6 movey( 40, 0.1 );
	brush14 movey( 40, 0.1 );
	brush2 PlaySound("piston");
	wait 0.5;
	brush3 movey( -40, 0.1 );
	brush11 movey( -56, 0.1 );
	brush7 movey( 40, 0.1 );
	brush15 movey( 40, 0.1 );
	brush3 PlaySound("piston");
	wait 0.5;
	brush4 movey( -40, 0.1 );
	brush12 movey( -56, 0.1 );
	brush8 movey( 40, 0.1 );
	brush16 movey( 40, 0.1 );
	brush4 PlaySound("piston");
	wait 5;


}


mcmodel()

{
	while(1)
	{
		level waittill( "jumper", who );
		who setModel( "mc_char" ); // adds the mc_char model
	}

}


//thx to braxi for that one :*




fuckinghands()
{
	trig = getEnt( "fuckinghands", "targetname" );
	trig waittill( "trigger", who );
	who PlaySound("fuckinghands");
	trig delete();
}



finish()
{
	trig = getEnt( "finish", "targetname" );
	finishdoor = getEnt( "finishdoor", "targetname" );
	player = getentarray("player", "classname");

	trig waittill( "trigger", player );
	/* [AUTO DELETE] iprintlnbold("Uh yeah " + " " + "^1"+ player.name + " "+ "^7finished the map!"); */
	trig delete();

	finishdoor movez( -200, 10 );
	/* [AUTO DELETE] AmbientPlay( "finish" ); */
	PlayFX( level.final_fx, (-656,1524,-32) );
	/* [AUTO DELETE] player TakeAllWeapons(); */
	/* [AUTO DELETE] player giveWeapon("pickaxe_mp"); */
	wait 0.01;
	/* [AUTO DELETE] player SwitchToWeapon("pickaxe_mp"); */

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
}



trap_6()
{
	level endon("trigger");
	trig = getEnt( "trigger6", "targetname" );
	brush = getEnt( "trap_6", "targetname" );


	trig waittill( "trigger", who );
	trig delete();



	brush movez( -32, 0.1 );
	wait 0.5;
	brush movex( -200, 1 );


}



ding()
{
	trig = getEnt( "ding", "targetname" );
	pedo = getEnt( "pedo", "targetname" );


	trig waittill( "trigger", player );
	/* [AUTO DELETE] iprintlnbold("^2OooOoOoh" + " " + "^1"+ player.name + " "+ "^7touched my tralala!"); */
	trig delete();
	/* [AUTO DELETE] AmbientPlay( "ding" ); */
	pedo movez( 1500, 25 );
	wait 30;
	/* [AUTO DELETE] iprintlnbold("And now " + " " + "^1"+ player.name + " "+ "^7is my lovetoy!!!"); */
	wait 15;
	/* [AUTO DELETE] iprintlnbold("Gunther is looking for:" + " " + "^1"+ player.name + " "+ "^7....where is he?"); */
	wait 15;
	/* [AUTO DELETE] iprintlnbold("I miss you:" + " " + "^1"+ player.name + " "+ "^7xoxo Gunther"); */
	wait 15;
	/* [AUTO DELETE] iprintlnbold("Gunther is hoping: " + " " + "^1"+ player.name + " "+ "^7is CUMMING soon!"); */
	wait 15;
	/* [AUTO DELETE] iprintlnbold("Whow" + " " + "^1"+ player.name + " "+ "^7your are SO HOT!!!!"); */
	wait 15;
	/* [AUTO DELETE] iprintlnbold("" + " " + "^1"+ player.name + " "+ "^7you make Gunther very horny! Watch out!"); */
	wait 15;
	/* [AUTO DELETE] iprintlnbold("Hehee" + " " + "^1"+ player.name + " "+ "^7has some HUGE Pen... eh problems!"); */
	wait 15;
	/* [AUTO DELETE] iprintlnbold("Oh" + " " + "^1"+ player.name + " "+ "^7is pretty much fucked...REALLY fucked..by Gunther"); */

}





finalteleport()
{
	trig = getent ("finalteleport","targetname");
	while(1)
	{
		trig waittill("trigger", who );
		if( getTeamPlayersAlive("axis") < 1 )
			return;
		if( getTeamPlayersAlive("allies") == 1 )
		{
			trig thread final();
			break;
		}
	}
}



final()
{
	acti = undefined;
	jumper = undefined;
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "axis" && isAlive(players[i]) )
		{
			acti = players[i];
			break;
		}
	}
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["team"] == "allies" && isAlive(players[i]) )
		{
			jumper = players[i];
			break;
		}
	}


	startj = getent("wep_jump_start", "targetname");
	starta = getent("wep_acti_start", "targetname");


	jumper SetPlayerAngles( startj.angles );
	jumper SetOrigin( startj.origin );
	/* [AUTO DELETE] jumper TakeAllWeapons(); */
	jumper.maxhealth = 100;
	jumper.health = jumper.maxhealth;
	acti SetPlayerAngles( starta.angles );
	acti SetOrigin( starta.origin );
	/* [AUTO DELETE] acti TakeAllWeapons(); */
	acti.maxhealth = 100;
	acti.health = acti.maxhealth;

	x = RandomInt(60);
	if( x < 10 )
		{
		/* [AUTO DELETE] acti GiveWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper GiveWeapon( "pickaxe_mp" ); */
		wait 0.01;
		/* [AUTO DELETE] acti SwitchToWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper SwitchToWeapon( "pickaxe_mp" ); */
		}
	if( x > 9 && x < 20 )
		{
		/* [AUTO DELETE] acti GiveWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper GiveWeapon( "pickaxe_mp" ); */
		wait 0.01;
		/* [AUTO DELETE] acti SwitchToWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper SwitchToWeapon( "pickaxe_mp" ); */
		}
	if( x > 19 && x < 30 )
		{
		/* [AUTO DELETE] acti GiveWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper GiveWeapon( "pickaxe_mp" ); */
		wait 0.01;
		/* [AUTO DELETE] acti SwitchToWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper SwitchToWeapon( "pickaxe_mp" ); */
		}
	if( x > 29 && x < 40  )
		{
		/* [AUTO DELETE] acti GiveWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper GiveWeapon( "pickaxe_mp" ); */
		wait 0.01;
		/* [AUTO DELETE] acti SwitchToWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper SwitchToWeapon( "pickaxe_mp" ); */
		}
	if( x > 39 && x < 50  )
		{
		/* [AUTO DELETE] acti GiveWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper GiveWeapon( "pickaxe_mp" ); */
		wait 0.01;
		/* [AUTO DELETE] acti SwitchToWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper SwitchToWeapon( "pickaxe_mp" ); */
		}
	if( x > 49  )
		{
		/* [AUTO DELETE] acti GiveWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper GiveWeapon( "pickaxe_mp" ); */
		wait 0.01;
		/* [AUTO DELETE] acti SwitchToWeapon( "pickaxe_mp" ); */
		/* [AUTO DELETE] jumper SwitchToWeapon( "pickaxe_mp" ); */
		}

	wait 0.1;
	jumper FreezeControls(1);
	acti FreezeControls(1);


	wait 2;


	noti = SpawnStruct();
	noti.titleText = "1 vs. 1";
	noti.notifyText = acti.name + " ^1VS ^7" + jumper.name;
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );


	wait 5;
	jumper FreezeControls(0);
	acti FreezeControls(0);

	PlayFX( level.finalfight_fx, (-192,3032,-24) );
}




trap_4()
{
	level endon("trigger");
	trig = getent ("trigger4","targetname");
	dmg = getent ("trap4_dmg","targetname");
	tnt1 = getEnt( "tnt1", "targetname" );
	tnt2 = getEnt( "tnt2", "targetname" );
	tnt3 = getEnt( "tnt3", "targetname" );
	tnt4 = getEnt( "tnt4", "targetname" );
	tnt5 = getEnt( "tnt5", "targetname" );
	tnt6 = getEnt( "tnt6", "targetname" );
	tnt7 = getEnt( "tnt7", "targetname" );
	tnt8 = getEnt( "tnt8", "targetname" );
	tnt9 = getEnt( "tnt9", "targetname" );
	tnt10 = getEnt( "tnt10", "targetname" );
	tnt11 = getEnt( "tnt11", "targetname" );
	tnt12 = getEnt( "tnt12", "targetname" );
	tnt13 = getEnt( "tnt13", "targetname" );
	tnt14 = getEnt( "tnt14", "targetname" );
	tnt15 = getEnt( "tnt15", "targetname" );
	tnt16 = getEnt( "tnt16", "targetname" );
	tnt17 = getEnt( "tnt17", "targetname" );
	tnt18 = getEnt( "tnt18", "targetname" );
	tnt19 = getEnt( "tnt19", "targetname" );
	tnt20 = getEnt( "tnt20", "targetname" );
	tnt21 = getEnt( "tnt21", "targetname" );
	tnt22 = getEnt( "tnt22", "targetname" );
	tnt23 = getEnt( "tnt23", "targetname" );
	tnt24 = getEnt( "tnt24", "targetname" );
	tnt25 = getEnt( "tnt25", "targetname" );
	tnt26 = getEnt( "tnt26", "targetname" );
	tnt27 = getEnt( "tnt27", "targetname" );
	tnt28 = getEnt( "tnt28", "targetname" );
	tnt29 = getEnt( "tnt29", "targetname" );
	tnt30 = getEnt( "tnt30", "targetname" );



	dmg maps\mp\_utility::triggerOff();

	trig waittill( "trigger", player );
	trig delete();
	/*
	dmg maps\mp\_utility::triggerOn();

	PlayFX( level.tnt_fx, (2227,1328,-15) );
		tnt15 PlaySound("tnt");
			wait 0.1;
	PlayFX( level.tnt_fx, (2227,1712,-15) );
		tnt15 PlaySound("tnt");
			wait 0.1;
	PlayFX( level.tnt_fx, (2413,1521,-15) );
		tnt15 PlaySound("tnt");
			wait 0.1;
	PlayFX( level.tnt_fx, (1939,1518,-15) );
		tnt15 PlaySound("tnt");
			wait 0.1;
	PlayFX( level.tnt_fx, (2173,1524,-15) );
		tnt15 PlaySound("tnt");




	wait 0.1;
	tnt1 delete();
	tnt2 delete();
	tnt3 delete();
	tnt4 delete();
	tnt5 delete();
	tnt6 delete();
	tnt7 delete();
	tnt8 delete();
	tnt9 delete();
	wait 0.1;
	tnt10 delete();
	tnt11 delete();
	tnt12 delete();
	tnt13 delete();
	tnt14 delete();
	tnt15 delete();
	tnt16 delete();
	tnt17 delete();
	tnt18 delete();
	tnt19 delete();
	tnt20 delete();
	tnt21 delete();
	tnt22 delete();
	tnt23 delete();
	tnt24 delete();
	tnt25 delete();
	wait 0.1;
	tnt26 delete();
	tnt27 delete();
	tnt28 delete();
	tnt29 delete();
	tnt30 delete();
	wait 0.1;
	dmg delete();*/


}


pickaxe()
{
	trig = getEnt( "pickaxe", "targetname" );

	trig waittill( "trigger", player );
	trig delete();

	/* [AUTO DELETE] player TakeAllWeapons(); */
	/* [AUTO DELETE] player giveWeapon("pickaxe_mp"); */
	wait 0.01;
	/* [AUTO DELETE] player SwitchToWeapon("pickaxe_mp"); */

}



saturday()
{
	trig = getEnt( "saturday", "targetname" );


	trig waittill( "trigger", player );
	trig delete();
	/* [AUTO DELETE] AmbientPlay( "saturday" ); */
	/* [AUTO DELETE] iprintlnbold("OMFG" + " " + "^1"+ player.name + " "+ "^7found Rebecca Black!"); */

}
