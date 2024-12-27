main()
{
	//level.musicfx = loadfx("jungle/line");
	//level.musiclogo = loadfx("jungle/musiclogo");
	level.actitp = loadfx("jungle/teleport_acti");
	//level.c4exp = loadfx("explosions/grenadeexp_default");

	maps\mp\_load::main();
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((0, 0, 92), 180);
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	//thread musicfx();
	//thread roomselection();
	//thread room_setups();

	//thread trap1();
	//thread trap2();
	//thread trap3();
	thread trap4();
	//thread trap5();
	thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();

	for(i=1;i<10;i++)
		addTriggerToList("trap"+i+"trig");


	thread teleports();
	thread startdoor();
	//thread bounceroom_failtrigger();
	//thread bounce_won();
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

teleports()
{       
 	entTransporter = getentarray( "enter", "targetname" );

	for( i = 0; i < entTransporter.size; i++ )
	{
		entTransporter[i] thread transporter();
		PlayFX(level.actitp,entTransporter[i].origin);
	}
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		player thread sr_tp_safe(entTarget);
	}
}
sr_tp_safe(entTarget)
{   
	self endon("death");
	self endon("disconnect");
	
	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}
startdoor()
{
	door = getent("startdoor","targetname");


	door delete();
}

musicfx()
{
	roter = getent("roter_trig","targetname");
	fxorg = getent("fxorg_m","targetname");
	logo = getent("musiclogo","targetname");

	level waittill("round_started");

	roter notsolid();

	playFx(level.musiclogo,logo.origin);

	/*ef = spawn("script_model",fxorg.origin);

	ef enablelinkto();
	ef linkto(roter);
	ef setmodel("tag_origin");*/

	wait 0.5;

	/*playfxontag(level.musicfx,ef,"tag_origin");
	for(;;)
	{
		roter rotateyaw(360,4.5);
		wait 2;
	}*/
}

trap1()
{
	obj = getent("trap1","targetname");
	killtrig = getent("killtrig1","targetname");
	trig = getent("trap1trig","targetname");
	trig sethintstring("Press [^5&&1^7] To Raise ^5The Spikes");

	killtrig enablelinkto();
	killtrig linkto(obj);

	trig waittill("trigger",player);
	trig delete();

	obj movez(64,0.5);
	wait 3;
	obj movez(-64,2);
}

trap2()
{
	obj = getEnt("trap2","targetname");
	trig = getEnt("trap2trig","targetname");
	c4 = getEnt("trap2c4model","targetname");
	trig sethintstring("Press [^5&&1^7] To Detonate ^5The C4");
	trig waittill("trigger",player);
	trig delete();

	c4 playsound("detpack_explo_default");
	Earthquake( 0.7, 1, c4.origin, 850 );
	PlayFX(level.c4exp,c4.origin);
	RadiusDamage( c4.origin, 200, 200, 50 );

	c4 delete();
	obj delete();
}

trap3()
{
	planks = getentarray("trap3","targetname");
	trig = getEnt("trap3trig","targetname");
	trig sethintstring("Press [^5&&1^7] To Remove A ^5Plank");

	trig waittill("trigger",player);
	trig delete();

	x = randomint(planks.size);

	planks[x] delete();
}

trap4()
{
	movingplat = getEnt("moveingplat","targetname");

	movingplat movey(100,0.1);

}

trap4watchplayer()
{
	level endon("killtrap4");
	for(;;)
	{
		if(level.trap4rotatedone == true)
		{
			level.movingplat rotateto(level.trap4platang,0.5);
			level.trap4rotatedone = false;
		}

		if(distance(self.origin,level.movingplat.origin) < 128)
		{
			if(level.trap4rotatedone == false && self.sessionstate == "playing")
			{
				level.movingplat rotateroll(90,0.5);
				level.trap4rotatedone = true;
			}
		}
		wait 0.6;
	}	
}

moveplat_trap4()
{
	for(;;)
	{
		self movey(464,3);
		self waittill("movedone");
		self movey(-464,3);
		self waittill("movedone");
	}
}

trap5()
{
	killtrigs = getentarray("trap5killtrigs","targetname");
	objs = getentarray("trap5objs","targetname");
	for(i=0;i<killtrigs.size;i++)
	{
		killtrigs[i] enablelinkto();
		killtrigs[i] linkto(objs[i]);
		if(i == 0 || i == 1)
		{
			objs[i] rotatepitch(20,0.1);
		}
		else
		{
			objs[i] rotatepitch(-20,0.1);
		}
	}
	trig = getEnt("trap5trig","targetname");
	trig sethintstring("Press [^5&&1^7] To ^5Swing");
	trig waittill("trigger",player);
	trig delete();
	for(;;)
	{
		for(i=0;i<objs.size;i++)
		{
			if(i==0 || i == 1)
			{
				objs[i] rotatepitch(-40,1);
			}
			else
			{
				objs[i] rotatepitch(40,1);
			}
		}	

		wait 1;

		for(i=0;i<objs.size;i++)
		{
			if(i==0 || i == 1)
			{
				objs[i] rotatepitch(40,1);
			}
			else
			{
				objs[i] rotatepitch(-40,1);
			}
		}

		wait 1;
	}
}

trap6()
{
	objs = getentarray("trap6","targetname");
	trig = getEnt("trap6trig","targetname");
	
	objs[10] movey(-2000,0.1);
	wait 0.1;
    objs[10] moveX(-2070,0.1);
	wait 0.1;
	objs[10] moveZ(-250,0.1);
}

trap7()
{
	bounces = getEnt("trap7","targetname");
	trig = getEnt("trap7trig","targetname");
	trig sethintstring("Press [^5&&1^7] To Hide ^5The Bounces");
	trig waittill("trigger",player);
	bounces hide();
	bounces notsolid();
	wait 3;
	bounces show();
	bounces solid();
}

trap8()
{
	objs = getentarray("trap8","targetname");
	killtrigs = getentarray("trap8killtrig","targetname");
	trig = getEnt("trap8trig","targetname");
	trig sethintstring("Press [^5&&1^7] To ^5Crush Them");

	for(i=0;i<killtrigs.size;i++)
	{
		killtrigs[i] enablelinkto();
		killtrigs[i] linkto(objs[i]);
	}

	trig waittill("trigger",player);
	trig delete();

	for(;;)
	{
		for(i=0;i<objs.size;i++)
		{
			objs[i] movez(-142,0.5);
			wait .25;
		}
		wait 2;
		for(i=0;i<objs.size;i++)
		{
			objs[i] movez(142,0.5);
			wait .25;
		}
		wait 2;
	}
}

trap9()
{
	objs = [];
	trig = getEnt("trap9trig","targetname");
	trig sethintstring("Press [^5&&1^7] To ^2Move Platforms");

	objs[0] = getEnt("trap9_1","targetname");
	objs[1] = getEnt("trap9_2","targetname");
	objs[2] = getEnt("trap9_3","targetname");
	objs[3] = getEnt("trap9_4","targetname");
	objs[4] = getEnt("trap9_5","targetname");
	objs[5] = getEnt("trap9_6","targetname");
	objs[6] = getEnt("trap9_7","targetname");
	objs[7] = getEnt("trap9_8","targetname");
	objs[8] = getEnt("trap9_9","targetname");

	trig waittill("trigger",player);
	trig delete();

	for(i=0;i<objs.size;i++)
		objs[i] thread trap9funk();
}

trap9funk()
{
	orgpos = self.origin;
	for(;;)
	{
		pos = randomintrange(-200,200);
		time = randomfloatrange(0.5,2.0);

		self moveto(orgpos+(0,0,pos),time);
		wait time+1;
		self moveto(orgpos,time);
		wait time+1;
	}
}

roomselection()
{
	trig = getEnt("roomselection","targetname");
	org = getEnt( trig.target, "targetname" );
	trig sethintstring("Press [^5&&1^7] To Enter Room Selection");
	for(;;)
	{
		trig waittill("trigger",player);
 
		trig sethintstring("^1Wait Your Turn");
		player setOrigin(org.origin);
		player setplayerangles(org.angles);

		while(player.sessionstate == "playing")
			wait 0.01;

		trig sethintstring("Press [^5&&1^7] To Enter Room Selection");
	}
}

room_setups()
{
	room_trigs = getentarray("room_trigs","targetname");
	for(i=0;i<room_trigs.size;i++)
		thread room_logic(room_trigs[i]);
}

room_logic(trig)
{
	player_org = [];
	acti_org = [];
	title = [];

	room = int(trig.script_noteworthy);

	if(room == 0)
	{
		trig sethintstring("Sniper Room");
		player_org[room] = getEnt("player_sniper","targetname");
		acti_org[room] = getEnt("acti_sniper","targetname");
		title[room] = "Sniper Room";
	}
	else if(room == 1)
	{
		trig sethintstring("Knife Room");
		player_org[room] = getEnt("player_knife","targetname");
		acti_org[room] = getEnt("acti_knife","targetname");
		title[room] = "Knife Room";	
	}
	else if(room == 2)
	{
		trig sethintstring("Bounce Room");
		player_org[room] = getEnt("player_bounce","targetname");
		acti_org[room] = getEnt("acti_bounce","targetname");
		title[room] = "Bounce Room";
	}

	for(;;)
	{
		trig waittill("trigger",player);

	

		level.inroomplayer = player;
		player thread inroomremove_death();
		player thread inroomremove_dis();
		player thread inroomremove_spec();

		player setOrigin( player_org[room].origin );
		player setplayerangles( player_org[room].angles );
		player takeallweapons();
		player room_weapon(room);
		player freezeControls(true);

		if(isdefined(level.activ))
		{
			level.activ setOrigin( acti_org[room].origin );
			level.activ setplayerangles( acti_org[room].angles );
			level.activ takeallweapons();
			level.activ room_weapon(room);
			level.activ freezeControls(true);
		}

		wait 2;

		player freezeControls(false);
		if(isdefined(level.activ))
			level.activ freezeControls(false);

	}
}

inroomremove_death()
{
	self endon("disconnect");
	self endon("joined_spectators");

	self waittill("death");
	level.inroomplayer = undefined;
}

inroomremove_dis()
{
	self endon("death");
	self endon("joined_spectators");

	self waittill("disconnect");
	level.inroomplayer = undefined;
}

inroomremove_spec()
{
	self endon("disconnect");
	self endon("death");

	self waittill("joined_spectators");
	level.inroomplayer = undefined;
}

room_weapon(room)
{
	weapon = "";
	switch(room)
	{
		case 0:
			weapon = "remington700_mp";
			self giveweapon(weapon);
			self switchtoweapon(weapon);
			self givemaxammo(weapon);
		break;

		case 1:
			weapon = "knife_mp";
			self giveweapon(weapon);
			self switchtoweapon(weapon);
		break;

		case 2:
			weapon = "knife_mp";
			self giveweapon(weapon);
			self switchtoweapon(weapon);
		break;
	}
}

bounceroom_failtrigger()
{
	player_fail = getEnt("player_bounce","targetname");
	acti_fail = getEnt("acti_bounce","targetname");

	trig = getEnt("bounceroom_failtrig","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
		if(player.pers["team"] == "allies")
		{
			player setOrigin(player_fail.origin);
			player setplayerangles(player_fail.angles);
		}
		else if(player.pers["team"] == "axis")
		{
			player setOrigin(acti_fail.origin);
			player setplayerangles(acti_fail.angles);
		}
		wait 0.1;
	}
}

bounce_won()
{
	trig = getEnt("bounce_won","targetname");

	model = spawn("script_model",trig.origin);
	model setmodel("weapon_remington700");
	model thread rotateme();

	player_lost = getEnt("player_lost","targetname");
	acti_lost = getEnt("acti_lost","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		if(player.pers["team"] == "axis")
		{
			level.inroomplayer setOrigin(player_lost.origin);
			level.inroomplayer setplayerangles(player_lost.angles);
			level.inroomplayer freezeControls(true);
		}
		else if(player.pers["team"] == "allies")
		{
			level.activ setOrigin(acti_lost.origin);
			level.activ setplayerangles(acti_lost.angles);
			level.activ freezeControls(true);
		}

		weapon = "remington700_mp";
		player giveweapon(weapon);
		player switchtoweapon(weapon);
		player givemaxammo(weapon);
	}
}

rotateme()
{
	for(;;)
	{
		self rotateyaw(360,3);
		wait 3;
	}
}