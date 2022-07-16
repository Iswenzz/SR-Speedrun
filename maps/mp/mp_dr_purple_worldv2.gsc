main()
{
maps\mp\_load::main();
 
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";
	
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 10000 );

    thread speedrun\_way_name::create_spawn((1243,321,76),180);
    thread speedrun\_way_name::create_normal_way("Normal Way;");
    thread speedrun\_way_name::create_secret_way("Easy Secret;Hard Secret;");

	thread StartDoor();
	thread Collectables();
	thread movingplat();
	thread spinners();
	thread TeleToStage2();
	thread EasySecretTP();
	thread EasySecretFall();
	thread HardSecretTP();
	thread OpenSecret();
	thread SecretTeleport();
}

Startdoor()
{
door = getEnt("bm_startdoor", "targetname");
door2 = getEnt("bm_startdoor2", "targetname");

wait 0.1;	
door delete();
door2 delete();

}

Collectables()
{
brush1 = getEnt("collectable1", "targetname");
brush2 = getEnt("collectable2", "targetname");
brush3 = getEnt("collectable3", "targetname");
brush4 = getEnt("collectable4", "targetname");
brush5 = getEnt("collectable5", "targetname");
brush6 = getEnt("collectable6", "targetname");
brush7 = getEnt("collectable7", "targetname");
brush8 = getEnt("collectable8", "targetname");
brush9 = getEnt("collectable9", "targetname");
brush10 = getEnt("collectable10", "targetname");
brush11 = getEnt("collectable11", "targetname");
brush12 = getEnt("collectable12", "targetname");
brush13 = getEnt("collectable13", "targetname");
brush14 = getEnt("collectable14", "targetname");
brush15 = getEnt("collectable15", "targetname");
brush16 = getEnt("collectable16", "targetname");

wait 0.1;
brush1 delete();
brush2 delete();
brush3 delete();
brush4 delete();
brush5 delete();
brush6 delete();
brush7 delete();
brush8 delete();
brush9 delete();
brush10 delete();
brush11 delete();
brush12 delete();
brush13 delete();
brush14 delete();
brush15 delete();
brush16 delete();
}

movingplat()
{
plat = getEnt("trap3_plat", "targetname");

wait 0.1;
plat delete();

}

spinners()
{
part1 = getEnt("trap12_part1", "targetname");
part2 = getEnt("trap12_part2", "targetname");
	
wait 0.1;	
part1 delete();
part2 delete();

}

TeleToStage2()
{
	trig = getEnt("trig_level1end", "targetname");
	og = getEnt("og_level2start", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Teleport(trig, og);
	}
}

HardSecretTP()
{
	trig = getEnt("trig_hardEntrance", "targetname");
	og = getEnt("og_hardSecret1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Teleport(trig, og);
		player.secretPos = 1;
		player thread speedrun\_way_name::change_way("s1");
	}
}

EasySecretTP()
{
	trig = getEnt("trig_easyEntrance", "targetname");
	og = getEnt("og_easySecret", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Teleport(trig, og);
		player thread speedrun\_way_name::change_way("s0");
	}
}

EasySecretFall()
{
	trig = getEnt("trig_easySecretFall", "targetname");
	og = getEnt("og_easySecret", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Teleport(trig, og);
	}
}

Teleport(trig, og)
{
	self setPlayerAngles(og.angles);
	self setOrigin(og.origin);
	
	self freezeControls(1);
	wait 0.005;
	self freezeControls(0);
}


OpenSecret()
{
brush = getEnt("brush_secret", "targetname");

wait 0.1;
brush delete();

}

SecretTeleport()
{
	trig = getEnt("trig_enterSecret", "targetname");
	trig setHintString("^7Press [^6&&1^7] to Enter ^6Secret^7!");
	og = getEnt("og_secretSelection", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player Teleport(trig, og);
	}		
}

ezfinish()
{ 
   trig = getent("trig_secretEnd_easy", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);

    player thread speedrun\_way_name::finish_way("s0");
    }
}

hardfinish()
{ 
   trig = getent("trig_secretEnd_hard", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);

    player thread speedrun\_way_name::finish_way("s1");
    }
}  
