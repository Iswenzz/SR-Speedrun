// ___   ___  _   _____   __   ___    _____   ____  ____
// |  \ |  _|| | |_   _| /  \  |  \_ |  _  | |   _||   _|
// ||>| |  _|| |_  | |  / /\ \ |    || |_| | _\ \  _\ \
// |__/ |___||___| |_| |__||__||____||_____||____||____|
//
//wut, why are you looking into my script?
//hmpf, nvm. Just gimme credits if you use parts of it^^
//(C)+(r) DeltaBoss

main()
{
	thread way_connect();
	maps\mp\_load::main();
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	//setdvar( "r_specularcolorscale", "1" );
	
	//Precaching//
	level._effect["waterfall"] = LoadFX("misc/watersplash_small"); //"misc/waterfall_hunted"
	level._effect["clouds_big"] = LoadFX("custom/clouds_big_white");
	level._effect["dust1"] = LoadFX("dust/abrams_desk_dust");
	level._effect["dust2"] = LoadFX("dust/abrams_muzzle_dust");
	level._effect["water_splash_tiny"] = LoadFX("misc/watersplash_small_chtr");
	level._effect["water_splash_small"] = LoadFX("misc/watersplash_small");
	level._effect["jump_pad"] = loadFx("misc/ui_pickup_available");
	level._effect["leaves_single"] = loadFx("misc/leaves_va");
	level._effect["leaves_big"] = loadFx("misc/leaves_ground_gentlewind");
	// PreCacheItem("m21_mp");
	// PreCacheItem("dragunov_mp");
	// PreCacheItem("barrett_mp");
	// PreCacheItem("rpg_mp");
	//
	
	//Variables//
	level.end_active = false;
	level.end_old_chosen = false;
	level.end_not_old = false;
	//level.end_first = false;
	level.entered_end = false;
	level.end_jump_chosen = false;
	level.idiot_finisher = true;
	level.start_door_opened = false;
	level.ambient0 = 0;
	level.ambient1 = 0;
	level.ambient2 = 0;
	level.ambient3 = 0;
	//
	
	
	// addTriggerToList("trap1_trig");
	// addTriggerToList("trap2_trig");
	// addTriggerToList("trap3_trig");
	// addTriggerToList("trap4_trig");
	// addTriggerToList("trap5_trig");
	// addTriggerToList("trap6_trig");
	// addTriggerToList("trap7_trig");
	// addTriggerToList("trap8_trig");
	// addTriggerToList("trap9_trig");
	// addTriggerToList("trap10_trig");
	// addTriggerToList("trap11_trig");
	
	
	//Threading//
	thread doFX();
	thread windmill();
	thread fog();
	// thread secret_lumber();
	thread start_door();
	thread zipline1();
	thread zipline2();
	thread antiIdiotActi();
	thread fallDeath();
	// thread cleptomaniac();
	
	// thread musicVote0();
	// thread musicVote1();
	// thread musicVote2();
	// thread musicVote3();
	
	thread hp_regen1();
	thread hp_regen2();
	thread hp_regen3();
	
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	// thread trap10();
	// thread trap11();
	
	// thread end();
	// thread end_old();
	// thread end_sniper();
	// thread end_jump();
	// thread end_knife();
	// thread end_islands();
	// thread end_deagle();
	
	// thread end_append();
	//thread end_counter();
	// thread watch_players_death();
	// thread watch_players_dc();
	//
	

//	thread addTestClients();	



//	braxi\_common::mapAuthor("DeltaBoss","62e7143c"); Why doesnt this work? D:

}
////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	
    for(;;) 
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList(name)
{
	if( !isDefined( level.trapTriggers ) )
	{
		level.trapTriggers = [];
	}
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );	
}
doFX()
{
	//waterfall
	origs_waterfall = getEntArray("waterfall_orig","targetname");
	for(i=0;i<origs_waterfall.size;i++)
	{
		maps\mp\_fx::loopfx("waterfall",origs_waterfall[i].origin,0.05,(origs_waterfall[i].origin)+(0,0,90)); //orig delay = 1
	}
	//clouds -big
	origs_clouds = getEntArray("clouds1","targetname");
	for(i=0;i<origs_clouds.size;i++)
	{
		//maps\mp\_fx::loopfx("clouds_cover",origs_clouds[i].origin,1,(origs_clouds[i].origin)+(0,0,90));
	}
	//clouds mist
	origs_mists = getEntArray("clouds2","targetname");
	for(i=0;i<origs_mists.size;i++)
	{
		//maps\mp\_fx::loopfx("clouds_mist",origs_mists[i].origin,0.5,(origs_mists[i].origin)+(0,0,90));
		if(origs_mists[i].origin == (-3064,-3072,-1704) || origs_mists[i].origin == (-4080,-1552,-1704) || origs_mists[i].origin == (5120,-1552,-1704) || origs_mists[i].origin == (6136,-3072,-1704))
		{
			maps\mp\_fx::loopfx("clouds_big",origs_mists[i].origin-(0,0,100),1.5,(origs_mists[i].origin)+(0,0,90));
		}
		else if(origs_mists[i].origin[2] < 0)
			maps\mp\_fx::loopfx("clouds_big",origs_mists[i].origin-(0,0,100),1.4,(origs_mists[i].origin)+(0,0,90)); //orig delay = 0.5 / 0.7 / 0.8
		else
		{
			if(origs_mists[i].origin[0] < -7500 || origs_mists[i].origin[0] > 8000)
			{
				//maps\mp\_fx::loopfx("clouds_big",origs_mists[i].origin,0.7,(origs_mists[i].origin)+(0,-90,90));
				playLoopedFx(level._effect["clouds_big"],2,origs_mists[i].origin,0,(0,0,90),(0,90,0)); //orig delay = 0.7 / 0.85 / 1
			}
			else
			{
				maps\mp\_fx::loopfx("clouds_big",origs_mists[i].origin,2,(origs_mists[i].origin)+(0,0,90)); //orig delay look above
			}
		}
	}
	//leaves single trees
	origs_l1 = getEntArray("orig_leaves1","targetname");
	for(i=0;i<origs_l1.size;i++)
	{
		//playFx(level._effect["leaves_single"],origs_l1[i].origin);//,origs_l1[i].angles,origs_l1[i].origin+(0,0,90)
		maps\mp\_fx::loopfx("leaves_single",origs_l1[i].origin,1,(origs_l1[i].origin)+(0,0,90));
	}
	//leaves big
	origs_l2 = getEntArray("orig_leaves","targetname");
	for(i=0;i<origs_l2.size;i++)
	{
		//playFx(level._effect["leaves_big"],origs_l2[i].origin);//,origs_l2[i].angles,origs_l2[i].origin+(0,0,90)
		maps\mp\_fx::loopfx("leaves_big",origs_l1[i].origin,1,(origs_l1[i].origin)+(0,0,90));
	}
}
windmill()
{
	mill = GetEnt("windmill","targetname");
	while(1)
	{
		mill rotateroll(360,10);
		wait 10;
	}
}
fog()
{
	trig = GetEnt("trig_fog","targetname");
	trig setHintString("wuts dis?");
	/*
	trig waittill("trigger");
	trig delete();
	
	iprintlnbold("fog is coming up...");
	SetExpFog(1,250,0.9,0.9,0.9,30);
	//auch möglich überall clouds big zu loopen!
	//visionSetNaked("fog",5);
	*/
}

secret_lumber()
{
	trig = getEnt("secret_lumber_trig","targetname");
	tree = getEnt("secret_lumber_tree","targetname");
	brush = getEnt("secret_lumber_brush","targetname");
	
	i = 0;
	while(i!=10)
	{
		trig waittill("trigger");
		i++;
	}
	trig delete();
	
	tree rotatepitch(70,4,3,0);
	brush rotatepitch(70,4,3,0);
}
musicVote0()
{
	trig = getEnt("music_vote_0","targetname");
	while(!level.start_door_opened)
	{
		trig waittill("trigger",player);
		if(!isDefined(player.voted_for_music))
		{
			level.ambient0++;
			player.voted_for_music = true;
		}
		else
			wait 0.05;
	}
}
musicVote1()
{
	trig = getEnt("music_vote_1","targetname");
	while(!level.start_door_opened)
	{
		trig waittill("trigger",player);
		if(!isDefined(player.voted_for_music))
		{
			level.ambient1++;
			player.voted_for_music = true;
		}
		else
			wait 0.05;
	}
}
musicVote2()
{
	trig = getEnt("music_vote_2","targetname");
	while(!level.start_door_opened)
	{
		trig waittill("trigger",player);
		if(!isDefined(player.voted_for_music))
		{
			level.ambient2++;
			player.voted_for_music = true;
		}
		else
			wait 0.05;
	}
}
musicVote3()
{
	trig = getEnt("music_vote_3","targetname");
	while(!level.start_door_opened)
	{
		trig waittill("trigger",player);
		if(!isDefined(player.voted_for_music))
		{
			level.ambient3++;
			player.voted_for_music = true;
		}
		else
			wait 0.05;
	}
}

hp_regen1()
{
	trig = getEnt("health_restore1","targetname");
	trig setHintString("Eat a watermelon?");
	
	while(true)
	{
		trig waittill("trigger",player);
		player iprintlnbold("You ate a delicous watermelon and regained health!");
		player.health = 100;
		wait 0.05;
	}
}
hp_regen2()
{
	trig = getEnt("health_restore2","targetname");
	trig setHintString("Eat an orange?");
	
	while(true)
	{
		trig waittill("trigger",player);
		player iprintlnbold("You ate a delicous orange and regained health!");
		player.health = 100;
		wait 0.05;
	}
}
hp_regen3()
{
	trig = getEnt("health_restore3","targetname");
	trig setHintString("Drink from the spring?");
	
	while(true)
	{
		trig waittill("trigger",player);
		player iprintlnbold("You drank fresh water and regained health!");
		player.health = 100;
		wait 0.05;
	}
}
start_door()
{
	door_r = getEnt("start_door_right","targetname");
	door_l = getEnt("start_door_left","targetname");
	trig = getEnt("start_door_trig","targetname");
	trig setHintString("Press [USE] to open the doors!");
	
	// trig waittill("trigger");
	wait 1;
	trig delete();
	
	// iprintlnbold("Start door opening....");
	// iprintln("^2Map by DeltaBoss");
	// iprintln("^3Sponsored by Universal Alliance");
	// iprintln("^3visit www.universal-alliance.de");
	wait 2;
	door_r rotateyaw(-120,4);
	door_l rotateyaw(120,4);
	level.start_door_opened = true;
	
	// playVotedMusic();
}
playVotedMusic()
{
	//player_amount = getAllPlayers().size;
	if(level.ambient0 > level.ambient1 && level.ambient0 > level.ambient2 && level.ambient0 > level.ambient3)
	{	
		iprintln("Playing no ambient");
		return;
	}
	else if(level.ambient1 > level.ambient0 && level.ambient1 > level.ambient2 && level.ambient1 > level.ambient3)
	{
		ambientPlay("ambient1",1);
		iprintln("Now playing:");
		iprintln("E.S.Posthumus - Nara");
	}
	else if(level.ambient2 > level.ambient0 && level.ambient2 > level.ambient1 && level.ambient2 > level.ambient3)
	{
		ambientPlay("ambient2",1);
		iprintln("Now playing:");
		iprintln("Jum Guthrie - The Cloud");
	}
	else if(level.ambient3 > level.ambient0 && level.ambient3 > level.ambient1 && level.ambient3 > level.ambient2)
	{
		ambientPlay("ambient3",1);
		iprintln("Now playing:");
		iprintln("Battle of Kings - MachinimaSound");
	}
	else
	{
		ambientPlay("ambient1",1);
		iprintln("Votes tied, defaulting to:");
		iprintln("E.S.Posthumus - Nara");
	}
}
zipline1()
{
	trig = getent ("zipline1_trig","targetname");
	air1 = getent ("zipline1a","targetname");
	air2 = getent ("zipline1b","targetname");
	air3 = getent ("zipline1c","targetname");

	time = 1;
	for(;;)
	{
		trig waittill ("trigger",user);
		user thread zipline1_ng(user);
	}
}

zipline1_ng(user)
{
	trig = getent ("zipline1_trig","targetname");
	air1 = getent ("zipline1a","targetname");
	air2 = getent ("zipline1b","targetname");
	air3 = getent ("zipline1c","targetname");

	time = 1;
	
		//throw = user.origin + (100, 100, 0);
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		air moveto (air1.origin, time);
		wait 0.5;
		air moveto (air2.origin, time);
		wait 0.5;
		air moveto (air3.origin, time);
		wait time;
		user unlink();
		wait 0.1;
		air delete();
}

zipline2()
{
	trig = getent ("zipline2_trig","targetname");
	air1 = getent ("zipline2a","targetname");
	air2 = getent ("zipline2b","targetname");
	air3 = getent ("zipline2c","targetname");

	time = 1;
	for(;;)
	{
		trig waittill ("trigger",user);
		user thread zipline2_ng(user);
	}
}

zipline2_ng(user)
{
	trig = getent ("zipline2_trig","targetname");
	air1 = getent ("zipline2a","targetname");
	air2 = getent ("zipline2b","targetname");
	air3 = getent ("zipline2c","targetname");

	time = 1;
	
		//throw = user.origin + (100, 100, 0);
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		air moveto (air1.origin, time);
		wait 0.5;
		air moveto (air2.origin, time);
		wait 0.5;
		air moveto (air3.origin, time);
		wait time;
		user unlink();
		wait 0.1;
		air delete();
}

antiIdiotActi()
{
	trig = getEnt("antifall_trig","targetname");
	orig = getEnt("antifall_orig","targetname");
	while(true)
	{
		trig waittill("trigger",player);
		player setOrigin(orig.origin);
		player iprintlnbold("You moron");
	}
}
fallDeath()
{
	trig = getEnt("falldeath_trig","targetname");
	while(true)
	{
		trig waittill("trigger",player);
		player suicide();
	}
}

cleptomaniac()
{
	thread clepto_lawnmower();
	thread clepto_couch();
	thread clepto_pc();
	thread clepto_bag();
	thread clepto_cashier();
	thread clepto_ladder();
	thread clepto_wc();
	thread clepto_bike();
	
	trig_end = getEnt("secret_clepto_end","targetname");
	
	trig = getEnt("secret_clepto_chair","targetname");
	model = getEnt("secret_clepto_chair_m","targetname");
	
	for(i=0;i<42;i++)
	{
		trig waittill("trigger");
	}
	trig waittill("trigger",player);
	player.clepto = true;
	player.clepto_items = [];
	player.clepto_items[0] = model;
	player iprintlnbold("If you want it THAT bad, take it.");
	thread watch_clepto(player);
	model linkTo(player);
	
	while(isDefined(trig_end))
	{
		trig_end waittill("trigger",player);
		player notify("finished");
		if(isDefined(player.clepto))
		{
			player iprintlnbold("FFS, GIVE ME THAT JUNK, TAKE THIS XP FOR IT");
			for(i=0;i<player.clepto_items.size;i++)
			{
				player.clepto_items[i] delete();
				player braxi\_rank::giveRankXP("",10);
				wait 0.05;
			}
			trig_end delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
watch_clepto(who)
{
	who endon("finished");
	who endon("disconnect");
	who waittill("death");
	for(i=0;i<who.clepto_items.size;i++)
	{
		who.clepto_items[i] delete();
		wait 0.05;
	}
}
clepto_lawnmower()
{
	trig = getEnt("secret_clepto_lawnmower","targetname");
	model = getEnt("secret_clepto_lawnmower_m","targetname");
	
	while(isDefined(trig))
	{
		trig waittill("trigger",player);
		if(isDefined(player.clepto))
		{
			model linkTo(player);
			player iprintlnbold("What, you want this lawnmower too??");
			player.clepto_items[player.clepto_items.size] = model;
			trig delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
clepto_couch()
{
	trig = getEnt("secret_clepto_couch","targetname");
	model = getEnt("secret_clepto_couch_m","targetname");
	
	while(isDefined(trig))
	{
		trig waittill("trigger",player);
		if(isDefined(player.clepto))
		{
			model linkTo(player);
			player iprintlnbold("Oh come one, this is silly...");
			player.clepto_items[player.clepto_items.size] = model;
			trig delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
clepto_pc()
{
	trig = getEnt("secret_clepto_pc","targetname");
	model = getEnt("secret_clepto_pc_m","targetname");
	
	while(isDefined(trig))
	{
		trig waittill("trigger",player);
		if(isDefined(player.clepto))
		{
			model linkTo(player);
			player iprintlnbold("Congratz, you found an old, dirty, useless pc.");
			player.clepto_items[player.clepto_items.size] = model;
			trig delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
clepto_bag()
{
	trig = getEnt("secret_clepto_bag","targetname");
	model = getEnt("secret_clepto_bag_m","targetname");
	
	while(isDefined(trig))
	{
		trig waittill("trigger",player);
		if(isDefined(player.clepto))
		{
			model linkTo(player);
			player iprintlnbold("Amazing how you can still carry more...");
			player.clepto_items[player.clepto_items.size] = model;
			trig delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
clepto_cashier()
{
	trig = getEnt("secret_clepto_cashier","targetname");
	model = getEnt("secret_clepto_cashier_m","targetname");
	
	while(isDefined(trig))
	{
		trig waittill("trigger",player);
		if(isDefined(player.clepto))
		{
			model linkTo(player);
			player iprintlnbold("Will you stop this already?");
			player.clepto_items[player.clepto_items.size] = model;
			trig delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
clepto_ladder()
{
	trig = getEnt("secret_clepto_ladder","targetname");
	model = getEnt("secret_clepto_ladder_m","targetname");
	
	while(isDefined(trig))
	{
		trig waittill("trigger",player);
		if(isDefined(player.clepto))
		{
			model linkTo(player);
			player iprintlnbold("You got to be kidding me...");
			player.clepto_items[player.clepto_items.size] = model;
			trig delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
clepto_wc()
{
	trig = getEnt("secret_clepto_wc","targetname");
	model = getEnt("secret_clepto_wc_m","targetname");
	
	while(isDefined(trig))
	{
		trig waittill("trigger",player);
		if(isDefined(player.clepto))
		{
			model linkTo(player);
			player iprintlnbold("Seriously? A toilet????");
			player.clepto_items[player.clepto_items.size] = model;
			trig delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
clepto_bike()
{
	trig = getEnt("secret_clepto_bike","targetname");
	model = getEnt("secret_clepto_bike_m","targetname");
	
	while(isDefined(trig))
	{
		trig waittill("trigger",player);
		if(isDefined(player.clepto))
		{
			model linkTo(player);
			player iprintlnbold("STOP THIS ALREADY!!!!!");
			player.clepto_items[player.clepto_items.size] = model;
			trig delete();
		}
		else
		{
			wait 0.05;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////traps
////////////////////////////////////////////////////////////////////////////////////////////
trap1()
{
	rocks = getEntArray("trap1_rock","targetname");
	trig = getEnt("trap1_trig","targetname");
	
	trig waittill("trigger");
	trig delete();
	
	while(true)
	{
		wait 0.05;
		for(i=0;i<rocks.size;i++)
		{
			rocks[i].movement = randomintrange(-150,150);
			rocks[i] movez(rocks[i].movement,3,1,1);
			rocks[i].movement = rocks[i].movement * (-1);
			wait 0.05;
		}
		wait 4;
		for(i=0;i<rocks.size;i++)
		{
			rocks[i] movez(rocks[i].movement,3,1,1);
			wait 0.05;
		}
		wait 4;
	}
}
trap2()
{
	trig = getEnt("trap2_trig","targetname");
	bridge = getEnt("trap2_bridge","targetname");
	
	trig waittill("trigger");
	trig delete();
	
	while(1)
	{
		bridge rotateroll(80,2);
		wait 2;
		bridge rotateroll(-145,3.5);
		wait 3.5;
		bridge rotateroll(75,1.5);
		wait 1.5;
		bridge rotateroll(-10,0.5);
		
		wait 5;
	}
}
trap3()
{
	rock1 = getEnt("trap3_rock1","targetname");
	hurt1 = getEnt("trap3_hurt1","targetname");
	rock2 = getEnt("trap3_rock2","targetname");
	hurt2 = getEnt("trap3_hurt2","targetname");
	trig = getEnt("trap3_trig","targetname");	
	
	hurt1 enableLinkTo();
	hurt2 enableLinkTo();
	hurt1 linkTo(rock1);
	hurt2 linkTo(rock2);
	
	trig waittill("trigger");
	trig delete();
	
	rock1 movez(-434,1,0.5,0.25);
	rock2 movez(-434,1,0.5,0.25);
}
trap4()
{
	fall = 3;
	rock = getEnt("trap4_rocks","targetname");
	rock2 = getEnt("trap4_rocks2","targetname");
	trig = getEnt("trap4_trig","targetname");
	
	trig waittill("trigger");
	trig delete();
	
	rock movez(-3040*fall,5,5,0);
	rock2 movez(-3040*fall,5,5,0);
	
	wait 5;
	rock delete();
	rock2 delete();
}
trap5()
{
	rock = getEnt("trap5_rock","targetname");
	trig = getEnt("trap5_trig","targetname");
	quake = getEnt("trap5_quake","targetname");
	
	trig waittill("trigger");
	trig delete();
	
	earthquake(1,5,quake.origin,400);
	rock rotateroll(90,5,5,0);
	wait 10;
	rock rotateroll(-90,5,5,0);
}
trap6()
{
	log = getEnt("trap6_log","targetname");
	hurt = getEnt("trap6_hurt","targetname");
	brush = getEnt("trap6_brush","targetname");
	dest1 = getEnt("trap6_orig1","targetname");
	dest2 = getEnt("trap6_orig2","targetname");
	trig = getEnt("trap6_trig","targetname");
	hurt enableLinkTo();
	hurt LinkTo(log);
	hurt.dmg = 0;
	
	trig waittill("trigger");
	trig delete();
	
	hurt.dmg = 2000;
	log moveto(dest1.origin,7,6,0);
	log rotateroll(3600,9,7,2);
	brush moveto(dest1.origin,7,6,0);
	wait 7;
	log moveto(dest2.origin,2,0,2);
	brush moveto(dest2.origin,2,0,2);
	wait 2;	
	//earthquake(0.1,log.origin,50);
	hurt delete();
}

trap7()
{
	spike1 = getEnt("trap7_spikes1","targetname");
	hurt1 = getEnt("trap7_hurt1","targetname");
	spike2 = getEnt("trap7_spikes2","targetname");
	hurt2 = getEnt("trap7_hurt2","targetname");
	spike3 = getEnt("trap7_spikes3","targetname");
	hurt3 = getEnt("trap7_hurt3","targetname");
	spike4 = getEnt("trap7_spikes4","targetname");
	hurt4 = getEnt("trap7_hurt4","targetname");
	
	hurt1 enableLinkTo();
	hurt1 linkTo(spike1);
	hurt2 enableLinkTo();
	hurt2 linkTo(spike2);
	hurt3 enableLinkTo();
	hurt3 linkTo(spike3);
	hurt4 enableLinkTo();
	hurt4 linkTo(spike4);
	
	trig = getEnt("trap7_trig","targetname");
	
	trig waittill("trigger");
	trig delete();
	
	while(true)
	{
		spike1 movez(187,0.6);
		spike2 movez(187,0.6);
		spike3 movez(187,0.6);
		spike4 movez(187,0.6);
		
		wait 0.8;
		
		spike1 movez(-187,4);
		spike2 movez(-187,4);
		spike3 movez(-187,4);
		spike4 movez(-187,4);
		
		wait 5;
	}
}

trap8()
{
	bridge = getEnt("trap8_bridge","targetname");
	fx = getEnt("trap8_fx","targetname");
	trig = getEnt("trap8_trig","targetname");
	
	trig waittill("trigger");
	trig delete();
	
	//playSound();
	bridge movez(-9000,5,5,0);
	wait 5;
	bridge delete();
}

trap9()
{
	rock = getEnt("trap9_rock","targetname");
	hurt = getEnt("trap9_hurt","targetname");
	sound = getEnt("trap9_fx_top","targetname");
	fx = getEnt("trap9_fx_bottom","targetname");
	trig = getEnt("trap9_trig","targetname");
	
	hurt enableLinkTo();
	hurt linkTo(rock);
	hurt.dmg = 0;
	
	trig waittill("trigger");
	trig delete();
	
	//playSound();
	hurt.dmg = 2000;
	rock movez(-442,0.8,0.8,0);
	wait 1;
	playFx(level._effect["dust1"],fx.origin);//,(0,0,0)
	playFx(level._effect["dust1"],fx.origin,(0,315,0));
	playFx(level._effect["dust1"],fx.origin,(0,270,0));
	playFx(level._effect["dust1"],fx.origin,(0,225,0));
	earthquake(0.3,0.5,fx.origin,100);
	//playFx(level._effect["dust2"],fx.origin);
	hurt delete();
}

trap10()
{
	rock1 = getEnt("trap10_rock1","targetname");
	rock2 = getEnt("trap10_rock2","targetname");
	rock3 = getEnt("trap10_rock3","targetname");
	trig = getEnt("trap10_trig","targetname");
	
	trig waittill("trigger");
	
	rock1 movey(144,1);
	rock2 movey(-144,1);
	rock3 movey(144,1);
	wait 1;
	
	trig waittill("trigger");
	trig delete();
	
	rock1 movey(-144,1);
	rock2 movey(144,1);
	rock3 movey(-144,1);
}

trap11()
{
	rock1 = getEnt("trap11_rock1","targetname");
	rock2 = getEnt("trap11_rock2","targetname");
	rock3 = getEnt("trap11_rock3","targetname");
	rock4 = getEnt("trap11_rock4","targetname");
	rock5 = getEnt("trap11_rock5","targetname");
	rock6 = getEnt("trap11_rock6","targetname");
	trig = getEnt("trap11_trig","targetname");
	
	trig waittill("trigger");
	trig delete();
	
	while(true)
	{
		rock1 movex(336,2,0.8,0.8);
		rock2 movex(-336,2,0.8,0.8);
		rock3 movex(336,2,0.8,0.8);
		rock4 movex(-336,2,0.8,0.8);
		rock5 movex(336,2,0.8,0.8);
		rock6 movex(-336,2,0.8,0.8);
		wait 2;
		
		rock1 movex(-336,2,0.8,0.8);
		rock2 movex(336,2,0.8,0.8);
		rock3 movex(-336,2,0.8,0.8);
		rock4 movex(336,2,0.8,0.8);
		rock5 movex(-336,2,0.8,0.8);
		rock6 movex(336,2,0.8,0.8);
		wait 2;
	}
}
////////////////////////////////////////////////////////////////////////
//end///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
end()
{
	trig = getEnt("endmap_trig","targetname");
	
	trig waittill("trigger",player);
	iPrintLnBold("^5"+player.name+" ^6reached the end!");
	ambientStop(1);
	thread end_counter();
	iPrintLn("^2Map by DeltaBoss");
	iPrintLn("^3sponsored by Universal Alliance!");
}
finalRoom(tp,weap,health)
{
	self SetPlayerAngles(tp.angles);
	self SetOrigin(tp.origin);
	self TakeAllWeapons();
	self GiveWeapon(weap);
	self GiveMaxAmmo(weap);
	wait 0.05;
	self SwitchToWeapon(weap);
	self.health = health;
}

end_old() //old
{
	trig = getEnt("end_old_trig","targetname");
	brush = getEnt("end_old_brush","targetname");
	rock1 = getEnt("end_old_r1","targetname");
	rock2 = getEnt("end_old_r2","targetname");
	rock3 = getEnt("end_old_r3","targetname");
	rock4 = getEnt("end_old_r4","targetname");
	rock5 = getEnt("end_old_r5","targetname");
	rock6 = getEnt("end_old_r6","targetname");
	rock7 = getEnt("end_old_r7","targetname");
    
	while(isDefined(trig))
	{
		trig waittill("trigger", player );
		if(!isDefined(level.end_counter))
		{
			player iprintlnbold("Please cross the finish trigger first!");
			wait 0.1;
			continue;
		}
		if(isString(level.finishers[level.end_counter]))
		{
			continue;
		}
		if(player getEntityNumber() != level.finishers[level.end_counter])
		{
			continue;
		}
		if (!level.end_old_chosen && !level.end_not_old)
		{
		level.end_old_chosen = true;
		ambientPlay("ambient_end");
		level.entered_end = true;
		iPrintlnBold("^1" + player.name + " ^7prefers oldschool!");
		}
		else
		{
			iprintln("End old can't be chosen anymore!");
			wait 999;
		}
		trig delete();
	}
	
	brush delete();
	rock1 movez(272+160,3,1,1);
	rock2 movez(-128-64,4,1.5,1.5);
	rock3 movez(480,5,2,2);
	rock4 movez(-176-64,6,2.5,2.5);
	rock5 movez(272+160,7,3,3);
	rock6 movez(-128-64,8,3.5,3.5);
	rock7 movez(288,9,4,4);	
}
end_sniper()
{
	trig = GetEnt("end_sniper_trig","targetname");
	
	while(1)
	{
		trig waittill("trigger",player);
		if(!isDefined(level.end_counter))
		{
			player iprintlnbold("Please cross the finish trigger first!");
			wait 0.1;
			continue;
		}
		if(isString(level.finishers[level.end_counter]))
		{
			continue;
		}
		if(player getEntityNumber() != level.finishers[level.end_counter])
		{
			continue;
		}
		if(level.end_old_chosen)
		{
			wait 999;
			continue;
		}
		if(level.end_jump_chosen)
		{
			wait 999;
			continue;
		}
		if(!level.end_not_old)
		{
			level.end_not_old = true;
		}
		if(level.end_active)
		{
			wait 0.2;
			continue;
		}
		else
		{
			if(player getEntityNumber() == level.finishers[level.end_counter])
			{
				level.end_active = true;
				level.entered_end = true;
				ambientPlay("ambient_end");
				end_sniper_do(player);
			}
		}
	}
}
end_sniper_do(player)
{
	jump = getEnt("end_sniper_jumper","targetname");
	acti = getEnt("end_sniper_acti","targetname");
	
	finalJumper = player;
	
	rand = RandomInt(5);
	if (rand == 0)
	{
		weap = "m40a3_mp";
	}
	else if (rand == 1)
	{
		weap = "m21_mp";
	}
	else if (rand == 2)
	{
		weap = "dragunov_mp";
	}
	else if (rand == 3)
	{
		weap = "remington700_mp";
	}
	else
	{
		weap = "barrett_mp";
	}
	
	finalJumper finalRoom(jump,weap,100);
	if(isDefined(level.activ))
		level.activ finalRoom(acti,weap,100);

	finalJumper FreezeControls(1);
	if(isDefined(level.activ))
		level.activ FreezeControls(1);      
	
	wait 0.05;
	iPrintlnBold("^5" + player.name + " ^4picked a sniper fight!"); 
	wait 3;
	iPrintlnBold("^1 GET READY!");
	wait 1;
	iPrintlnBold("^1 3");
	wait 1;
	iPrintlnBold("^1 2");
	wait 1;
	iPrintlnBold("^1 1");
	wait 1;
	iPrintlnBold("^1 AIM!!!");
	finalJumper FreezeControls(0);
	if(isDefined(level.activ))
		level.activ FreezeControls(0);
}
end_deagle()
{
	trig = GetEnt("end_deagle_trig","targetname");
	
	while(1)
	{
		trig waittill("trigger",player);
		if(!isDefined(level.end_counter))
		{
			player iprintlnbold("Please cross the finish trigger first!");
			wait 0.1;
			continue;
		}
		if(isString(level.finishers[level.end_counter]))
		{
			continue;
		}
		if(player getEntityNumber() != level.finishers[level.end_counter])
		{
			continue;
		}
		if(level.end_old_chosen)
		{
			wait 999;
			continue;
		}
		if(level.end_jump_chosen)
		{
			wait 999;
			continue;
		}
		if(!level.end_not_old)
		{
			level.end_not_old = true;
		}
		if(level.end_active)
		{
			wait 0.2;
			continue;
		}
		else
		{
			if(player getEntityNumber() == level.finishers[level.end_counter])
			{
				level.end_active = true;
				level.entered_end = true;
				ambientPlay("ambient_end");
				end_deagle_do(player);
			}
		}
	}
}
end_deagle_do(player)
{
	jump = getEnt("end_deagle_jumper","targetname");
	acti = getEnt("end_deagle_acti","targetname");
	
	finalJumper = player;
	
	finalJumper finalRoom(jump,"deserteagle_mp",100);
	if(isDefined(level.activ))
		level.activ finalRoom(acti,"deserteagle_mp",100);

	finalJumper FreezeControls(1);
	if(isDefined(level.activ))
		level.activ FreezeControls(1);      
	
	wait 0.05;
	iPrintlnBold("^5" + player.name + " ^4is a deagle bro!"); 
	wait 3;
	iPrintlnBold("^1 GET READY!");
	wait 1;
	iPrintlnBold("^1 3");
	wait 1;
	iPrintlnBold("^1 2");
	wait 1;
	iPrintlnBold("^1 1");
	wait 1;
	iPrintlnBold("^1 DEAGLE!!!");
	finalJumper FreezeControls(0);
	if(isDefined(level.activ))
		level.activ FreezeControls(0);
}
end_knife()
{
	trig = GetEnt("end_knife_trig","targetname");
	
	while(1)
	{
		trig waittill("trigger",player);
		if(!isDefined(level.end_counter))
		{
			player iprintlnbold("Please cross the finish trigger first!");
			wait 0.1;
			continue;
		}
		if(isString(level.finishers[level.end_counter]))
		{
			continue;
		}
		if(player getEntityNumber() != level.finishers[level.end_counter])
		{
			continue;
		}
		if(level.end_old_chosen)
		{
			wait 999;
			continue;
		}
		if(level.end_jump_chosen)
		{
			wait 999;
			continue;
		}
		if(!level.end_not_old)
		{
			level.end_not_old = true;
		}
		if(level.end_active)
		{
			wait 0.2;
			continue;
		}
		else
		{
			if(player getEntityNumber() == level.finishers[level.end_counter])
			{
				level.end_active = true;
				level.entered_end = true;
				ambientPlay("ambient_end");
				end_knife_do(player);
			}
		}
	}
}
end_knife_do(player)
{
	jump = getEnt("end_knife_jumper","targetname");
	acti = getEnt("end_knife_acti","targetname");
	
	finalJumper = player;
	
	finalJumper finalRoom(jump,"knife_mp",100);
	if(isDefined(level.activ))
		level.activ finalRoom(acti,"knife_mp",100);

	finalJumper FreezeControls(1);
	if(isDefined(level.activ))
		level.activ FreezeControls(1);
	
	wait 0.05;
	iPrintlnBold("^5" + player.name + " ^4picked a knife fight!"); 
	wait 3;
	iPrintlnBold("^1GET READY!");
	wait 1;
	iPrintlnBold("^1 3");
	wait 1;
	iPrintlnBold("^1 2");
	wait 1;
	iPrintlnBold("^1 1");
	wait 1;
	iPrintlnBold("^1STAB!!!");
	finalJumper FreezeControls(0);
	if(isDefined(level.activ))
		level.activ FreezeControls(0);
}
end_islands()
{
	trig = GetEnt("end_islands_trig","targetname");
	
	jumps = [];
	
	trig1 = getEnt("end_islands_trig1","targetname");
	trig2 = getEnt("end_islands_trig2","targetname");
	trig3 = getEnt("end_islands_trig3","targetname");
	trig4 = getEnt("end_islands_trig4","targetname");
	trig5 = getEnt("end_islands_trig5","targetname");
	trig6 = getEnt("end_islands_trig6","targetname");
	trig7 = getEnt("end_islands_trig7","targetname");
	trig8 = getEnt("end_islands_trig8","targetname");
	trig9 = getEnt("end_islands_trig9","targetname");
	trig10 = getEnt("end_islands_trig10","targetname");
	trig11 = getEnt("end_islands_trig11","targetname");
	trig12 = getEnt("end_islands_trig12","targetname");
	trig13 = getEnt("end_islands_trig13","targetname");
	trig14 = getEnt("end_islands_trig14","targetname");
	trig15 = getEnt("end_islands_trig15","targetname");
	trig16 = getEnt("end_islands_trig16","targetname");
	trig17 = getEnt("end_islands_trig17","targetname");
	trig18 = getEnt("end_islands_trig18","targetname");
	trig19 = getEnt("end_islands_trig19","targetname");
	trig20 = getEnt("end_islands_trig20","targetname");
	trig21 = getEnt("end_islands_trig21","targetname");
	trig22 = getEnt("end_islands_trig22","targetname");
	trig23 = getEnt("end_islands_trig23","targetname");
	trig24 = getEnt("end_islands_trig24","targetname");
	trig25 = getEnt("end_islands_trig25","targetname");
	trig26 = getEnt("end_islands_trig26","targetname");
	trig27 = getEnt("end_islands_trig27","targetname");
	trig28 = getEnt("end_islands_trig28","targetname");
	trig29 = getEnt("end_islands_trig29","targetname");
	trig30 = getEnt("end_islands_trig30","targetname");
	trig31 = getEnt("end_islands_trig31","targetname");
	trig32 = getEnt("end_islands_trig32","targetname");
	trig33 = getEnt("end_islands_trig33","targetname");
	trig34 = getEnt("end_islands_trig34","targetname");
	trig35 = getEnt("end_islands_trig35","targetname");
	trig36 = getEnt("end_islands_trig36","targetname");
	trig37 = getEnt("end_islands_trig37","targetname");
	
	trig1.dest = (-5956, 4304, 1860);
	trig2.dest = (-5072, 3524, 1412);
	trig3.dest = (-3884, 2500, 1612);
	trig4.dest = (-4060, 4392, 1164);
	trig5.dest = (-6336, 2892, 1800);
	trig6.dest = (-5956, 4304, 1860);
	trig7.dest = (-4060, 4392, 1164);
	trig8.dest = (-6336, 2892, 1800);
	trig9.dest = (-3884, 2500, 1612);
	trig10.dest = (-4060, 4392, 1164);
	trig11.dest = (-5088, 2336, 1896);
	trig12.dest = (-4100, 992, 980);
	trig13.dest = (-5072, 3524, 1412);
	trig14.dest = (-5984, 1236, 1256);
	trig15.dest = (-5956, 4304, 1860);
	trig16.dest = (-5072, 3524, 1412);
	trig17.dest = (-5088, 2336, 1896);
	trig18.dest = (-5984, 1236, 1256);
	trig19.dest = (-5096, 2076, 1896);
	trig20.dest = (-6336, 2892, 1800);
	trig21.dest = (-4944, -32, 1656);
	trig22.dest = (-6312, -168, 1484);
	trig23.dest = (-3884, 2500, 1612);
	trig24.dest = (-5096, 2076, 1896);
	trig25.dest = (-4944, -32, 1656);
	trig26.dest = (-4100, 992, 980);
	trig27.dest = (-5984, 1236, 1256);
	trig28.dest = (-6312, -168, 1484);
	trig29.dest = (-3948, -928, 1336);
	trig30.dest = (-5984, 1236, 1256);
	trig31.dest = (-4944, -32, 1656);
	trig32.dest = (-5504, -1288, 1024);
	trig33.dest = (-4944, -32, 1656);
	trig34.dest = (-5504, -1288, 1024);
	trig35.dest = (-3948, -928, 1336);
	trig36.dest = (-4944, -32, 1656);
	trig37.dest = (-6312, -168, 1484);
	
	jumps[0] = trig1;
	jumps[1] = trig2;
	jumps[2] = trig3;
	jumps[3] = trig4;
	jumps[4] = trig5;
	jumps[5] = trig6;
	jumps[6] = trig7;
	jumps[7] = trig8;
	jumps[8] = trig9;
	jumps[9] = trig10;
	jumps[10] = trig11;
	jumps[11] = trig12;
	jumps[12] = trig13;
	jumps[13] = trig14;
	jumps[14] = trig15;
	jumps[15] = trig16;
	jumps[16] = trig17;
	jumps[17] = trig18;
	jumps[18] = trig19;
	jumps[19] = trig20;
	jumps[20] = trig21;
	jumps[21] = trig22;
	jumps[22] = trig23;
	jumps[23] = trig24;
	jumps[24] = trig25;
	jumps[25] = trig26;
	jumps[26] = trig27;
	jumps[27] = trig28;
	jumps[28] = trig29;
	jumps[29] = trig30;
	jumps[30] = trig31;
	jumps[31] = trig32;
	jumps[32] = trig33;
	jumps[33] = trig34;
	jumps[34] = trig35;
	jumps[35] = trig36;
	jumps[36] = trig37;
	
	
	while(1)
	{
		trig waittill("trigger",player);
		if(!isDefined(level.end_counter))
		{
			player iprintlnbold("Please cross the finish trigger first!");
			wait 0.1;
			continue;
		}
		if(isString(level.finishers[level.end_counter]))
		{
			continue;
		}
		if(player getEntityNumber() != level.finishers[level.end_counter])
		{
			continue;
		}
		if(level.end_old_chosen)
		{
			wait 999;
			continue;
		}
		if(level.end_jump_chosen)
		{
			wait 999;
			continue;
		}
		if(!level.end_not_old)
		{
			level.end_not_old = true;
		}
		if(level.end_active)
		{
			wait 0.2;
			continue;
		}
		else
		{
			if(player getEntityNumber() == level.finishers[level.end_counter])
			{
				level.end_active = true;
				level.entered_end = true;
				ambientPlay("ambient_end");
				if(!isDefined(level.lights_already_on))
				{
					thread end_islands_fx();
					level.lights_already_on = true;
				}
				thread end_islands_jumps(player,jumps);
				if(isDefined(level.activ))
					thread end_islands_jumps(level.activ,jumps);
				thread end_islands_reload();
				end_islands_do(player);
			}
		}
	}
}
end_islands_do(player)
{
	jump = getEnt("end_islands_jumper","targetname");
	acti = getEnt("end_islands_acti","targetname");
	
	finalJumper = player;
	
	finalJumper finalRoom(jump,"rpg_mp",100);
	if(isDefined(level.activ))
		level.activ finalRoom(acti,"rpg_mp",100);

	finalJumper FreezeControls(1);
	if(isDefined(level.activ))
		level.activ FreezeControls(1);      
	
	wait 0.05;
	iPrintlnBold("^5" + player.name + " ^4is an island-jumper!"); 
	wait 3;
	iPrintlnBold("^1 GET READY!");
	wait 1;
	iPrintlnBold("^1 3");
	wait 1;
	iPrintlnBold("^1 2");
	wait 1;
	iPrintlnBold("^1 1");
	wait 1;
	iPrintlnBold("^1JUMP!!!");
	finalJumper FreezeControls(0);
	if(isDefined(level.activ))
		level.activ FreezeControls(0);
}
end_islands_reload()
{
	trig = getEnt("end_islands_reload","targetname");
	while(true)
	{
		trig waittill("trigger",player);
		player giveMaxAmmo("rpg_mp");
		wait 0.05;
	}
}
end_islands_fx()
{
	origs = getEntArray("end_islands_fx","targetname");
	for(i=0;i<origs.size;i++)
	{
		playFx(level._effect["jump_pad"],origs[i].origin);
	}
}
end_islands_jumps(who,jumps)
{
	who endon("death");
	who endon("disconnect");
	
	who.isFlying = false;
	while(true)
	{
		for(i=0;i<jumps.size;i++)
		{
			if(who isTouching(jumps[i]) && !who.isFlying)
			{
				//who setOrigin(jumps[i].dest);
				end_islands_transport2(who, jumps[i].dest);
			}
		}
		wait 0.1;
	}
}
end_islands_transport(who, where)
{	
	who.isFlying = true;
	air = spawn ("script_model",(0,0,0));
	air.origin = who.origin;
	air.angles = who.angles;
	
	who linkTo(air);
	air moveTo(where+(0,0,25), 1.75);
	wait 1.75;
	who unlink();
	wait 0.05;
	air delete();
	who.isFlying = false;
}
end_islands_transport2(who, where)
{
	/*temp1 = (where-who.origin);
	temp1 = vector_scale(temp1, 0.33);
	temp2 = (where-who.origin);
	temp2 = vector_scale(temp2, 0.66);*/
	
	temp1 = who.origin + vector_scale(where-who.origin,0.33);
	temp2 = who.origin + vector_scale(where-who.origin,0.66);
	
	if(who.origin[2]>where[2])
	{
		temp1 = temp1 + (0,0,100);
		temp2 = temp2 + (0,0,200);
	}
	else
	{
		temp1 = temp1 + (0,0,100);
		temp2 = temp2 + (0,0,200);
	}
	
	
	time = 0.7;
	air = spawn ("script_model",(0,0,0));
	air.origin = who.origin;
	air.angles = who.angles;
	who linkTo(air);
	air moveTo(temp1, time);
	wait time;
	air moveTo(temp2, time);
	wait time;
	air moveTo(where, time);
	wait time;
	who unlink();
	wait 0.05;
	air delete();
}
vector_scale(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}
end_jump()
{
	trig = GetEnt("end_jump_trig","targetname");
	
	while(1)
	{
		trig waittill("trigger",player);
		if(!isDefined(level.end_counter))
		{
			player iprintlnbold("Please cross the finish trigger first!");
			wait 0.1;
			continue;
		}
		if(isString(level.finishers[level.end_counter]))
		{
			continue;
		}
		if(player getEntityNumber() != level.finishers[level.end_counter])
		{
			continue;
		}
		if(level.end_old_chosen)
		{
			wait 999;
			continue;
		}
		if(!level.end_not_old)
		{
			level.end_not_old = true;
		}
		if(level.end_active)
		{
			wait 0.2;
			continue;
		}
		else
		{
			if(player getEntityNumber() == level.finishers[level.end_counter])
			{
				//level.end_active = true;
				level.entered_end = true;
				level.end_jump_chosen = true;
				ambientPlay("ambient_end");
				end_jump_do(player);
				break;
			}
		}
	}
}
end_jump_do(player)
{
	pos1 = getEnt("end_jump_pos1","targetname");
	pos2 = getEnt("end_jump_pos2","targetname");
	pos3 = getEnt("end_jump_pos3","targetname");
	pos4 = getEnt("end_jump_pos4","targetname");
	pos5 = getEnt("end_jump_pos5","targetname");
	pos6 = getEnt("end_jump_pos6","targetname");
	pos7 = getEnt("end_jump_pos7","targetname");
	trig = getEnt("end_jump_trig","targetname");
	
	finalJumper = player;
	finalJumper finalRoom(pos1,"tomahawk_mp",100);
	if(isDefined(level.activ))
		level.activ finalRoom(pos5,"tomahawk_mp",100);
	iPrintlnBold("^1" + player.name + " ^2wants to jump for it!");
	thread end_jump_rot();
	thread end_jump_tp();
	thread end_jump_weap();
	while(1)
	{
		trig waittill( "trigger", player );
		tp = randomInt(7);
		if(tp==1)
			player finalRoom(pos1,"tomahawk_mp",100);
		else if(tp==2)
			player finalRoom(pos2,"tomahawk_mp",100);
		else if(tp==3)
			player finalRoom(pos3,"tomahawk_mp",100);
		else if(tp==4)
			player finalRoom(pos4,"tomahawk_mp",100);
		else if(tp==5)
			player finalRoom(pos5,"tomahawk_mp",100);
		else if(tp==6)
			player finalRoom(pos6,"tomahawk_mp",100);
		else
			player finalRoom(pos7,"tomahawk_mp",100);
		wait 0.05;
		iPrintlnBold( " ^1" + player.name + " ^2 has joined the jumping!" );
	}
}
end_jump_weap()
{
	trig = getEnt("end_jump_weaptrig","targetname");
	while(true)
	{
		trig waittill("trigger",player);
		player giveWeapon("m40a3_mp");
		player giveMaxAmmo("m40a3_mp");
		wait 0.05;
		player switchToWeapon("m40a3_mp");
	}
}
end_jump_tp()
{
	pos1 = getEnt("end_jump_pos1","targetname");
	pos2 = getEnt("end_jump_pos2","targetname");
	pos3 = getEnt("end_jump_pos3","targetname");
	pos4 = getEnt("end_jump_pos4","targetname");
	pos5 = getEnt("end_jump_pos5","targetname");
	pos6 = getEnt("end_jump_pos6","targetname");
	pos7 = getEnt("end_jump_pos7","targetname");
	trig = getEnt("end_jump_falltrig","targetname");
	
	while(true)
	{
		trig waittill("trigger",player);
		tp = randomInt(7);
		if(tp==1)
			player teleport(pos1);
		else if(tp==2)
			player teleport(pos2);
		else if(tp==3)
			player teleport(pos3);
		else if(tp==4)
			player teleport(pos4);
		else if(tp==5)
			player teleport(pos5);
		else if(tp==6)
			player teleport(pos6);
		else
			player teleport(pos7);
		wait 0.05;
	}
}
teleport(tp)
{
	self setPlayerAngles(tp.angles);
	self setOrigin(tp.origin);
}
end_jump_rot()
{
	rock1 = getEnt("end_jump_rocks1","targetname");
	rock2 = getEnt("end_jump_rocks2","targetname");
	rock3 = getEnt("end_jump_rocks3","targetname");
	rock4 = getEnt("end_jump_rocks4","targetname");
	rock5 = getEnt("end_jump_rocks5","targetname");
	weap = getEnt("end_jump_model","targetname");
	
	while(true)
	{
		rock1 rotateyaw(360,4);
		//rock2 rotateyaw(-180,4);
		rock3 rotateyaw(90,4);
		//rock4 rotateyaw(-45,4);
		rock5 rotateyaw(22.5,4);
		weap rotateyaw(-360,4);
		wait 4;
	}
}
//
//append
//
getPlayerByNr(nr) 
{
	players = getAllPlayers();
	for(i=0;i<players.size;i++)
	{
		if(players[i] getEntityNumber() == nr) //0 undef
		{
			return players[i];
		}
	}
}
getAllPlayers()
{
	return getEntArray("player","classname");
}

end_append()
{
	trig = getEnt("end_append_trig","targetname");
	level.finishers = [];
	i = 0;
	
	while(1)
	{
		trig waittill("trigger",player);
		if(!check_content(player getEntityNumber()))
		{
			level.finishers[i] = player getEntityNumber();
			player.place = i;
			iprintln(player.name+" came in "+i);
			i++;
		}
		else
		{
			wait 0.05;
		}
	}
}
check_content(nr)
{
	for(i=0;i<level.finishers.size;i++)
	{
		if(isString(level.finishers[i]))
		{
			continue;
		}
		if(nr==level.finishers[i])
		{
			return true;
		}
	}
	return false;
}
end_counter()
{
	level.end_counter = 0;
	while(1)
	{
		if(!level.idiot_finisher)
		{
			wait 0.05;
			continue;
		}
		if(level.end_active)
		{
			//iprintln("end is active");
			wait 0.1;
			continue;
		}
		if(isString(level.finishers[level.end_counter]) && level.end_counter < (level.finishers.size-1))
		{
			level.end_counter++;
			//continue;
			iprintln("Incrementing append counter");
		}
		else if(isString(level.finishers[level.end_counter]) && level.end_counter == (level.finishers.size-1))
		{
			wait 0.1;
			//iprintln("Waiting for new finisher");
			continue;
		}
		if(level.end_jump_chosen)
		{
			iprintln("jump chosen, terminating append");
			wait 999;
		}
		if(!isDefined(level.finishers[level.end_counter]))
		{
			wait 0.1;
			continue;
		}
		if(!level.end_old_chosen)
		{
			iprintln("A new challenger may enter the end");
			countdown(getPlayerByNr(level.finishers[level.end_counter]));
		}
		else
		{
			iprintln("old chosen, terminating append");
			wait 999;
		}
		wait 0.05;
	}
}
watch_players_death()
{
	while(1)
	{
		level waittill("player_killed",player);
		if(!isDefined(player.place))
		{
			player.place = "NA";
			continue;
		}
		if(!isDefined(level.end_counter))
		{
			continue;
		}
		if(isString(level.finishers[level.end_counter]))
		{
			continue;
		}
		if(isString(level.finishers[player.place]))
		{
			continue;
		}
		else if(player getEntityNumber() == level.finishers[level.end_counter])
		{
			level.end_active = false;
			player.countdown_dead = true;
			iprintln("Challenger died!");
		}
		if(check_content(player getEntityNumber()))
		{
			level.finishers[player.place] = "NA";
		}
		wait 0.05;
	}
}
watch_players_dc()
{
	while(1)
	{
		level waittill("disconnected",player);
		if(!isDefined(player.place))
		{
			player.place = "NA";
			continue;
		}
		if(!isDefined(level.end_counter))
		{
			continue;
		}
		if(isString(level.finishers[level.end_counter]))
		{
			continue;
		}
		if(isString(level.finishers[player.place]))
		{
			continue;
		}
		else if(player getEntityNumber() == level.finishers[level.end_counter])
		{
			level.end_active = false;
			player.countdown_dead = true;
			iprintln("Challenger disconnected!");
		}
		if(check_content(player getEntityNumber()))
		{
			level.finishers[player.place] = "NA";
		}
		wait 0.05;
	}
}
countdown(player)
{
	level.entered_end = false;
	player.countdown_dead = false;
	player iprintlnbold("You have 20 seconds to enter an endroom");
	wait 15;
	if(!level.entered_end && !player.countdown_dead)
	{
		player iprintlnbold("5 seconds left");
		wait 4.7;
		if(!level.entered_end && !player.countdown_dead)
		{
			player iprintlnbold("Too late :(");
			wait 0.3;
			if(player.sessionstate == "playing")
			{
				player suicide();
			}
		}
	}
}
/*
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
*/