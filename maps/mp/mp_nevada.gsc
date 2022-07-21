main()
{
thread sr\api\_map::createSpawn((-2789, -1452, -368), 0);

	maps\mp\_load::main();
	maps\mp\mp_nevada\_teleport::main();

	trig = spawn("trigger_radius",(1820,-3623,-132),0,150,150);
	trig.radius = 150;
	trig.targetname = "endmap_trig";


        trigger_init();
        thread killSuspenseMusic();

        thread way_connect();

  	thread sr\api\_speedrun::cj();


	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("compassmaxrange","1800");

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
	
	thread secret_1();

    sr\api\_speedrun::createNormalWays("Easy Way;");
	sr\api\_speedrun::createSecretWays("Hard Way;");
	
    for(;;) 
    {
        level waittill( "connected", player );

    }
}

secret_1()
{
	trig = spawn("trigger_radius",(-2764,-1741,-308),0,50,50);
	ori = spawn("script_origin",(-11529,-4805,10595-60));
	ori.angles = (0,180,0);

	thread secret_1_end();

	wait 1;
	trig.radius = 50;
	thread sr\api\_map::createTriggerFx(trig, "secret");

	for(;;)
	{
		trig waittill("trigger",player);
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
		player setOrigin(ori.origin);
		player setPlayerAngles(ori.angles);
	}
}

secret_1_end()
{
	trig = spawn("trigger_radius",(-7711,-966,10903),0,50,50);

	wait 1;
	trig.radius = 50;
	thread sr\api\_map::createTriggerFx(trig, "secret");

	for(;;)
	{
		trig waittill("trigger",player);
		
player thread sr\api\_speedrun::finishWay("secret_0");
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

trigger_init()
{
	soundtriggers = getentarray( "sound_trigger", "targetname" );

	for( i = 0; i < soundtriggers.size; i++ )
		soundtriggers[i] thread trigger_sound();
}

trigger_sound()
{
	soundpos = getent( self.target, "targetname" );

	for(;;)
	{
		self waittill( "trigger", user );

		if(!isDefined(user.sound) || user.sound != soundpos.script_noteworthy)
		{
			if(isDefined(user.sound))
				user stoplocalsound(user.sound);

			user.sound = soundpos.script_noteworthy;
			user thread play_the_sound(soundpos.script_noteworthy);
		}
		wait 0.25;
	}
}

play_the_sound( sound )
{
	self endon("disconnect");
	self notify("music_change");
	self endon("music_change");

	self playlocalsound( sound );
	wait 500;
	self.sound = undefined;
}
killSuspenseMusic()
{
	wait 1;

	if(isDefined(game) && isDefined(game["music"]) && isDefined(game["music"]["suspense"]))
		for(i = 0;i < game["music"]["suspense"].size;i++)
			game["music"]["suspense"][i] = "null";
}

