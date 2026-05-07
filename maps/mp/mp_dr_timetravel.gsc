main()
{

	maps\mp\_load::main();
	//maps\mp\_teleport1::main();
	//maps\mp\_teleport2::main();
	//maps\mp\_teleport3::main();
	//maps\mp\_teleport4::main();
	//maps\mp\_teleport5::main();
	//maps\mp\_teleport6::main();
	//maps\mp\_teleport7::main();
	//level._effect["flareblue"] = loadfx( "misc/flareblue" );
	//level._effect["aa_explosion"] = loadfx( "explosions/aa_explosion" );
	//level.missile["trail"] = LoadFX("smoke/smoke_geotrail_javelin");
	//precacheitem("deserteagle_mp");
	//precacheitem("rpg_mp");
	//precacheitem("m40a3_mp");

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setdvar("bg_fallDamageMaxHeight","999999");
	setdvar("bg_fallDamageMinHeight","999998");

	thread sr\api\_map::createSpawn((-8, 269, 80), 90);
    thread sr\api\_speedrun::createNormalWays("^5Ice Way;Future Way;^3Egypt Way");
	thread sr\api\_speedrun::createWay((-530.075, 796.109, 100.125), 95, 175, "cyan", "normal_0");
	thread sr\api\_speedrun::createWay((556.104, 803.242, 100.125), 95, 175, "orange", "normal_2");
	thread sr\api\_speedrun::createEndMap((-2008.88, -2660.21, 64.125), 100,120, "normal_0");
	thread sr\api\_speedrun::createEndMap((-1572.31, -2088.67, 64.125), 100,120, "normal_1");
	thread sr\api\_speedrun::createEndMap((-1063.12, -2654.48, 64.125), 100,120, "normal_2");

	thread trap_adjustments();
	thread future_enter();

	//thread credit();
	//thread messages1();
	//thread messages2();
	thread door();
	//thread initMusic();
	//thread musictrig();
	//thread xploround();
	//thread randomroompick();
	thread iw_trap1();
	thread iw_trap2();
	thread iw_trap3();
	thread iw_trap4();
	thread noss();
	thread iw_trap5();
	thread iw_trap6();
	thread iw_trap7();
	thread iw_trap8();
	thread iwteletoroom();
	thread ew_trap1();
	thread ew_trap2();
	thread ew_trap3();
	thread maze();
	thread ew_trap4();
	thread ew_trap5();
	thread ew_trap6();
	thread ew_trap7();
	thread ew_trap8();
	thread ewteletoroom();
	thread fw_trap1();
	thread fw_trap2();
	thread fw_trap3();
	thread fw_trap4();
	thread fw_trap5();
	thread fw_trap6();
	thread fw_trap7();
	thread fw_trap8();
	thread futureefex();
	//thread endmap();
	//thread iceroom();
	//thread futureroom();
	//thread egyptr();
	//thread takesniper();
	//thread takerpg1();
   // thread takerpg2();

	level.term1 hide();
	level.term2 hide();
	level.term3 hide();
	level.term4 hide();
	level.term5 hide();
	level.term6 hide();
	level.term7 hide();
	level.term8 hide();
	level.term9 hide();
	level.term10 hide();
	level.term11 hide();
	level.term12 hide();

	level.laser1 hide();
	level.laser1 notsolid();
	level.laser2 hide();
	level.laser2 notsolid();

	level.blockertrig notsolid();

	entTransporter = getentarray( "enter5", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();


}
trap_adjustments()
{
brush_1 = getEnt("icedoor","targetname");
brush_2 = getEnt("egyptdoor","targetname");
brush_3 = getEnt("futureworld","targetname");


wait 0.1;

brush_1 delete();
brush_2 delete();
brush_3 delete();

}

future_enter()
{
	trig = getEnt("enter4","targetname");
	ori_t = getEnt("gohere4","targetname");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("normal_1");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}

transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player freeze_on_tps(0.1);
	}
}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^2Time Travel" );
wait(6);
thread drawInformation( 800, 0.8, 1, "^3Xplosive" );
wait(6);
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
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

messages1()
{
while (1)
	{
		{
		iprintln( "^1>>^7Map Creator ^5Xplosive");
		wait 30;
		}
	}
}

messages2()
{
while (1)
	{
		{
		iprintln( "^1>>^7Thanks eBc|Legend for assisting");
		wait 30;
		}
	}
}

door()
{
door1=getent("door1","targetname");
door2=getent("door2","targetname");

wait 0.1;

door1 delete();
door2 delete();
}

			initMusic()
{
		level.music = [];

        i = 0;
		level.music[i]["artist"] = "Charlie Puth ft.Meghan Trainor";
		level.music[i]["title"] = "Marvin Gaye";
		level.music[i]["alias"] = "music1";

		i++;
		level.music[i]["artist"] = "Nico & Vinz (Tr3ybeatz Remix)";
		level.music[i]["title"] = "Am I Wrong";
		level.music[i]["alias"] = "music2";

		i++;
		level.music[i]["artist"] = "Limp Bizkit";
		level.music[i]["title"] = "Rollin";
		level.music[i]["alias"] = "music3";

		i++;
		level.music[i]["artist"] = "Ellie Goulding (Codeko Dubstep Remix)";
		level.music[i]["title"] = "Burn";
		level.music[i]["alias"] = "music4";

		i++;
		level.music[i]["artist"] = "Years & Years";
		level.music[i]["title"] = "King";
		level.music[i]["alias"] = "music5";

		i++;
		level.music[i]["artist"] = "Jason Derullo";
		level.music[i]["title"] = "Want To Want Me";
		level.music[i]["alias"] = "music6";

		i++;
		level.music[i]["artist"] = "Måns Zelmerlöw";
		level.music[i]["title"] = "Hereoes";
		level.music[i]["alias"] = "music7";

		precacheShader( "black" );
		precacheShader( "white" );
}

musicMenu() //Music Menu by Blades's. :]
{

	self endon( "death" );

	self thread onDeath();
	self thread onDisconnect();

	self.hud_music = [];
	self.selection = 0;

	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );
	self.hud_music[i].sort = 883;
	self.hud_music[i] setText( ">^5>^7> Music ^5Menu ^7<^5<^7<" );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText( ">^5>^7> ^7Select ^7a ^7Song ^5<^7<^5<" );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );
	self.hud_music[i].sort = 885;
	self.hud_music[i] setText( "Press ^5[^7USE^5]^7: ^5Play ^7Song" );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 235, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText( "^5SuX ^7Lolz :]" );

	for( j = 0; j < level.music.size; j++ )
	{
		i++;
		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
		self.hud_music[i].sort = 882;
		self.hud_music[i].font = "objective";

		entry = level.music[j];
		self.hud_music[i] setText( entry["artist"] + " ^2-^7 " + entry["title"] );
	}

	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "white", 306, 17 );

	while( self.sessionstate == "playing" )
	{
		wait 0.1;

		if( self attackButtonPressed() )
		{
			self.hud_music[5+self.selection].alpha = 0.93;

			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;

			item = self.hud_music[5+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if( self useButtonPressed() )
		{
			iPrintln( "^5Now playing: ^7" + level.music[self.selection]["artist"]+" - ^2" +level.music[self.selection]["title"] );

			ambientPlay( level.music[self.selection]["alias"], 3 );
			self freezeControls(0);
			level notify ( "song_picked" );
			self braxi\_rank::giveRankXp( "trap_activation" );
			break;
		}
		else if( self meleeButtonPressed() )
		{
			self freezeControls(0);
			break;
		}
	}

	self cleanUp();
}

musictrig()
{
	trigger = getEnt ( "musicmenu", "targetname" );
	trigger setHintString( "Press ^5[^7USE^5]^7to ^5Choose ^7Music" );

	trigger waittill( "trigger", player );
	trigger delete();
	level endon ( "song_picked" );
	player thread musicMenu();
	player freezeControls(1);
}

cleanUp()
{
	if( !isDefined( self ) )
		return;

	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}

onDisconnect() //Music Term.
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}

onDeath() //Music Term.
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}

xploround()
{
object1 = getent("xplo","targetname");
while(1)
{
object1 rotateYaw(360, 2);
wait(2);
}
}

randomroompick()
{
	x = randomint(3);

	if (x == 0)
	{
		level thread iceworld();
		thread iceworldacti();
		thread wayhud("^0Ice^7 World Is Open!");
	}
	else if (x == 1)
	{
		level thread futureworld();
		thread futureworldacti();
		thread wayhud("^1Future^7 World Is Open!");
	}
	else if (x == 2)
	{
		level thread egyptworld();
		thread egyptworldacti();
		thread wayhud("^8Egypt ^7 World Is Open!");
	}
}

iceworld()
{
    object1 = getent("icedoor","targetname");
	wait 0.5;
	{
		object1 notsolid();
	object1 hide();
	}
	wait 1;
}

futureworld()
{
    object1 = getent("futureworld","targetname");
	wait 0.5;
	{
		object1 notsolid();
	object1 hide();
	}
	wait 1;
}

egyptworld()
{
    object1 = getent("egyptdoor","targetname");
	wait 0.5;
	{
		object1 notsolid();
	object1 hide();
	}
	wait 1;
}

iceworldacti()
{
    object1 = getent("icedooracti","targetname");
	wait 0.5;
	{
		object1 notsolid();
	object1 hide();
	}
	wait 1;
}

futureworldacti()
{
    object1 = getent("futuredooracti","targetname");
	wait 0.5;
	{
		object1 notsolid();
	object1 hide();
	}
	wait 1;
}

egyptworldacti()
{
    object1 = getent("egyptdooracti","targetname");
	wait 0.5;
	{
		object1 notsolid();
	object1 hide();
	}
	wait 1;
}

wayhud(text)
{
	level.wayhud = NewHudElem();
	level.wayhud.alignX = "center";
	level.wayhud.alignY = "middle";
	level.wayhud.horzalign = "center";
	level.wayhud.vertalign = "middle";
	level.wayhud.alpha = 1;
	level.wayhud.x = 0;
	level.wayhud.y = -150;
	level.wayhud.font = "default";
	level.wayhud.fontscale = 2;
	level.wayhud.glowalpha = 1;
	level.wayhud.glowcolor = (1,0.4,0.9);
	level.wayhud setText( text );
	level.wayhud SetPulseFX( 10, 3000, 200 );
	level.wayhud.duration = 4;
	wait 5;
	level.wayhud destroy();

}

iw_trap1()
{
trigger = getent("trig_iwtrap1","targetname");
object1 = getent("iwtrap1","targetname");
killtrigger = getent ("iwkilltrig_1" , "targetname");
trigger waittill ("trigger" , player );

}

iw_trap2()
{
trigger = getent("trig_iwtrap2","targetname");
object1 = getent("iwtrap2","targetname");
trigger waittill ("trigger" , player );

}

iw_trap3()
{
trigger = getent("trig_iwtrap3","targetname");
object1 = getent("iwtrap3","targetname");
trigger waittill ("trigger" , player );

}

iw_trap4()
{
trigger = getent("trig_iwtrap4","targetname");
object1 = getent("iwtrap4","targetname");
killtrigger = getent ("iwkilltrig_4" , "targetname");
trigger waittill ("trigger" , player );

}

noss()
{
object1 = getent("iwtrap5","targetname");

}

iw_trap5()
{
trigger = getent("trig_iwtrap5","targetname");
object1 = getent("iwtrap5","targetname");
trigger waittill ("trigger" , player );

}

iw_trap6()
{
trigger = getent("trig_iwtrap6","targetname");
object1 = getent("iwtrap6","targetname");
trigger waittill ("trigger" , player );

}

iw_trap7()
{
trigger = getent("trig_iwtrap7","targetname");
object1 = getent("iwtrap7","targetname");
trigger waittill ("trigger" , player );

}

iw_trap8()
{
trigger = getent("trig_iwtrap8","targetname");
object1 = getent("iwtrap8_1","targetname");
object2 = getent("iwtrap8_2","targetname");
trigger waittill ("trigger" , player );

}

iwteletoroom()
{
trigger = getent("iwtele_trig","targetname");
object1 = getent("iwtele","targetname");

object1 moveZ(144 ,0.1);

}

ew_trap1()
{
trigger = getent("trig_ewtrap1","targetname");
object1 = getent("ewtrap1","targetname");
trigger waittill ("trigger" , player );

}

ew_trap2()
{
	part1 = getentarray ("ewtrap2_1" ,"targetname");
	part2 = getentarray ("ewtrap2_2" ,"targetname");
	trig = getent ("trig_ewtrap2" , "targetname");

 	trig waittill( "trigger", user );

}

ew_trap3()
{
trigger = getent("trig_ewtrap3","targetname");
object1 = getent("ewtrap3","targetname");
trigger waittill ("trigger" , player );

}

maze()
{
object1 = getent("ewtrap4","targetname");

object1 notsolid();
object1 hide();

}

ew_trap4()
{
trigger = getent("trig_ewtrap4","targetname");
object1 = getent("ewtrap4","targetname");
trigger waittill ("trigger" , player );

}

ew_trap5()
{
trigger = getent("trig_ewtrap5","targetname");
object1 = getent("ewtrap5","targetname");
trigger waittill ("trigger" , player );

}

ew_trap6()
{
	part1 = getentarray ("ewtrap6_1" ,"targetname");
	part2 = getentarray ("ewtrap6_2" ,"targetname");
	trig = getent ("trig_ewtrap6" , "targetname");

 	trig waittill( "trigger", user );

}

ew_trap7()
{
	trig = getent("trig_ewtrap7","targetname");
	trig waittill("trigger", player );

}

returntrig()
{
	level.returntrigger = getent("ewtrap7","targetname");
	level.returns = 0;
	for(;;)
	{
		if (level.returns == 5)
		{
			level.returntrigger delete();
		}
		level.returntrigger waittill("trigger", player );
		player thread returntospawn();
		level.returns++;
		wait .1;
	}
}

returntospawn()
{
	jumperspawn = getentarray("mp_jumper_spawn","classname");
	for(i = 0 ;i < jumperspawn.size ; i++)
	{
	self setorigin( jumperspawn[i].origin );
	self setplayerangles( jumperspawn[i].angles );
	}
}

ew_trap8()
{
trig = getent("trig_ewtrap8","targetname");
trig waittill("trigger", user);

}



ew_trap8_rotator()
{
level.pusher = getEnt ( "pusher", "targetname" );
thread deletepusher();

while(1)
{
level.pusher waittill ( "trigger", who );

oldpos = who.origin;
strenght = 10;
for(i=0;i<strenght;i++)
{
who.health += 160;
who finishplayerdamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((0,270,0)), "none", 0);
}
}
}

deletepusher()
{
wait 10;
level.pusher delete();
}

ewteletoroom()
{
trigger = getent("ewtele_trig","targetname");
object1 = getent("ewtele","targetname");

object1 moveZ(144 ,0.1);
}

fw_trap1()
{
	plats = getent("fw_trap1","targetname");
	trig = getent("fw_trap1trig","targetname");
	trig sethintstring("Press [F] To Activate");

}

fw_trap2()
{
	level.laser1 = getent("laser1","targetname");
	level.laser2 = getent("laser2","targetname");
	triglaser1 = getent("triglaser1","targetname");
	triglaser2 = getent("triglaser2","targetname");
	trig = getent("fw_trap2trig","targetname");
	trig sethintstring("Press [F] To Activate");
	triglaser1 maps\mp\_utility::triggerOff();
	triglaser2 maps\mp\_utility::triggerOff();
	door3 = getent("door3","targetname");
	door4 = getent("door4","targetname");
	trig waittill("trigger", player );

}

fw_trap3()
{
	way1 = getent("way1","targetname");
	way2 = getent("way2","targetname");
	way3 = getent("way3","targetname");
	trig = getent("fw_trap3trig","targetname");
	trig sethintstring("Press [F] To Activate");
	trig waittill("trigger", player );

}

fw_trap4()
{
	fxorigin = getent("fxorigin","targetname");
	level.term1 = getent("term1","targetname");
	level.term2 = getent("term2","targetname");
	level.term3 = getent("term3","targetname");
	level.term4 = getent("term4","targetname");
	level.term5 = getent("term5","targetname");
	level.term6 = getent("term6","targetname");
	level.term7 = getent("term7","targetname");
	level.term8 = getent("term8","targetname");
	level.term9 = getent("term9","targetname");
	level.term10 = getent("term10","targetname");
	level.term11 = getent("term11","targetname");
	level.term12 = getent("term12","targetname");
	trig = getent("fw_trap4trig","targetname");
	level.blockertrig = getent("blockertrig","targetname");
	trig sethintstring("Press [F] To Activate");
	trig waittill("trigger", player );

}

fw_trap5()
{
	plats1 = getent("plats1","targetname");
	plats2 = getent("plats2","targetname");
	trig = getent("fw_trap5trig","targetname");
	trig sethintstring("Press [F] To Activate");
	trig waittill("trigger", player );

}

fw_trap6()
{
	rocket1 = getent("rocket1","targetname");
	rocket2 = getent("rocket2","targetname");
	trig = getent("fw_trap6trig","targetname");
	trig sethintstring("Press [F] To Activate");

	trace1_1 = getent("trace1_1","targetname");//origin
	trace1_2 = getent("trace1_2","targetname");
	trace1_3 = getent("trace1_3","targetname");

	trace2_1 = getent("trace2_1","targetname");//origin
	trace2_2 = getent("trace2_2","targetname");
	trace2_3 = getent("trace2_3","targetname");

	trig waittill("trigger", player );

}

fw_trap7()
{
	level.fan = getEnt("fan","targetname");
	trig = getent("fw_trap7trig","targetname");
	trig sethintstring("Press [F] To Activate");
	trig waittill("trigger", user);

}



fw_trap7_rotator()
{
	level.trap7pusher = getEnt ( "trap7pusher", "targetname" );
	thread deletepusher2();

	while(1)
	{
    	level.trap7pusher waittill ( "trigger", who );

	    oldpos = who.origin;
	    strenght = 10;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishplayerdamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	    }
	}
}

deletepusher2()
{
	wait 10;
	level.trap7pusher delete();
}

fw_trap8()
{
	bounce = getEnt("bounce","targetname");
	trig = getEnt("fw_trap8trig","targetname");
	trig sethintstring("Press [F] To Activate");
	trig waittill("trigger", player );

}

endmap()
{
	level waittill("game over");
	thread endmsg("^5Thanks On Playing ^3Timetravel ^5Map By ^2Xplosive");
}

endmsg(text)
{
	wayhud = NewHudElem();
	wayhud.alignX = "center";
	wayhud.alignY = "middle";
	wayhud.horzalign = "center";
	wayhud.vertalign = "middle";
	wayhud.alpha = 1;
	wayhud.x = 0;
	wayhud.y = -150;
	wayhud.font = "default";
	wayhud.fontscale = 2.5;
	wayhud.glowalpha = 1;
	wayhud.glowcolor = (0.0, 1.0, 1.0);
	wayhud setText( text );
	//wayhud.duration = 4;
	wayhud SetPulseFX( 10, 3000, 200 );
	wait 5;
	wayhud destroy();
}

futureefex()
{
	trig = getEnt("futurefx","targetname");
	trig waittill("trigger", player );
	{
	PlayFX(level._effect["flareblue"],(4968, 4440, 968));
	PlayFX(level._effect["flareblue"],(4968, 4104, 712));
	PlayFX(level._effect["flareblue"],(4968, 4440, 424));
	PlayFX(level._effect["flareblue"],(4968, 4776, 712));
	}
}

iceroom()
{
    level.ice_trig = getEnt( "iw_room", "targetname");
    jump = getEnt( "jump_ice", "targetname" );
    acti = getEnt( "acti_ice", "targetname" );

    while(1)
    {
        level.ice_trig waittill( "trigger", player );
        if( !isDefined( level.ice_trig ) )
            return;
        if(level.firstenter==true)
		{
        level.future_trig delete();
		level.egypt_trig delete();
		level.firstenter=false;
		}
		ambientplay("ice");
		iprintln("^1Playng:^7 R3HAB & KSHMR - Karate");
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );
		player givemaxammo("deserteagle_mp");
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" );
		level.activ givemaxammo("deserteagle_mp");
        wait 0.05;
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
        iPrintlnBold( "^7" + player.name + " ^2Chose ^3Ice^7!" );
		wait 2;
		iPrintlnBold("3");
		wait 1;
		iPrintlnBold("2");
		wait 1;
		iPrintlnBold("1");
		wait 1;
		iPrintlnBold("Fight!!");
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

futureroom()
{
    level.future_trig = getEnt( "fw_room", "targetname");
    jump = getEnt( "jump_future", "targetname" );
    acti = getEnt( "acti_future", "targetname" );


    while(1)
    {
        level.future_trig waittill( "trigger", player );
        if( !isDefined( level.future_trig ) )
            return;

		if(level.firstenter==true)
		{
        level.egypt_trig delete();
		level.ice_trig delete();
		level.firstenter=false;
		}
		ambientplay("future");
		iprintln("^1Playng:^7 Showtek ft. We Are Loud & Sonny Wilson - Booyah");
        iPrintlnBold( "^7" + player.name + " ^9Chose ^2Future^7!" );
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
	    player freezeControls(true);
		level.activ freezeControls(true);
		wait 2;
		iPrintlnBold("3");
		wait 1;
		iPrintlnBold("2");
		wait 1;
		iPrintlnBold("1");
		wait 1;
		iPrintlnBold("Fight!!");
	    wait 0.1;
        player GiveWeapon( "remington700_mp" );
        player GiveWeapon( "m40a3_mp" );
		player switchToWeapon( "remington700_mp" );
	    wait 0.1;
		level.activ GiveWeapon( "remington700_mp" );
                level.activ GiveWeapon( "m40a3_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );
	    player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

egyptr()
{
    level.egypt_trig = getEnt( "ew_room", "targetname");
    jump = getEnt( "jump_egypt", "targetname" );
    acti = getEnt( "acti_egypt", "targetname" );


    while(1)
    {
        level.egypt_trig waittill( "trigger", player );
        if( !isDefined( level.egypt_trig ) )
            return;

		if(level.firstenter==true)
		{
        level.future_trig delete();
		level.ice_trig delete();
		level.firstenter=false;
		}
		ambientplay("egypt");
		iprintln("^1Playng:^7 David Guetta feat. Nicki Minaj & Afrojack - Hey Mama (DISTO Remix)");
        iPrintlnBold( "^7" + player.name + " ^9Chose ^2Egypt^7!" );
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
		player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
	    player freezeControls(true);
		level.activ freezeControls(true);
		wait 2;
		iPrintlnBold("3");
		wait 1;
		iPrintlnBold("2");
		wait 1;
		iPrintlnBold("1");
		wait 1;
		iPrintlnBold("Fight!!");
	    wait 0.1;
        player GiveWeapon( "knife_mp" );
		player switchToWeapon( "knife_mp" );
	    wait 0.1;
		level.activ GiveWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
	    player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

takesniper()
{
	trig = getent("takesniper","targetname");
	for(;;)
	{
		trig waittill("trigger", player );
		player giveweapon("m40a3_mp");
		player givemaxammo("m40a3_mp");
		wait .1;
		player switchtoweapon("m40a3_mp");
	}
}

takerpg1()
{
	trig = getent("takerpg1","targetname");
	for(;;)
	{
		trig waittill("trigger", player );
		player giveweapon("rpg_mp");
		player givemaxammo("rpg_mp");
		wait .1;
		player switchtoweapon("rpg_mp");
	}
}

takerpg2()
{
	trig = getent("takerpg2","targetname");
	for(;;)
	{
		trig waittill("trigger", player );
		player giveweapon("rpg_mp");
		player givemaxammo("rpg_mp");
		wait .1;
		player switchtoweapon("rpg_mp");
	}
}