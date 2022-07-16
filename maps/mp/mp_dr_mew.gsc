main()
{

thread speedrun\_way_name::create_normal_way("^2Easy Way;^1Hard Way");
thread speedrun\_way_name::create_secret_way("^2Easy Secret;^1Hard Secret");
thread speedrun\_way_name::create_spawn((-1069, -1034, 121), 90);

	thread speedrun\_way_name::create_tp((-818, -851, 121), 100, 150, 
		(-3550, -4793, 1486), 270, "freeze", "green", "s0");

	thread speedrun\_way_name::create_tp((-1314, -777, 121), 100, 150, 
		(5180, -8305, 1948), 90, "freeze", "darkred", "s1");

thread speedrun\_way_name::create_tp((13476, -1683, 572), 100, 150, 
	(14853, -1680, 572), 360, "freeze");

 maps\mp\_load::main();
 //maps\mp\mews\menu::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 

setdvar("r_specularcolorscale", "1");
setdvar("r_specular", "0");
setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");

setdvar("compassmaxrange", "1800");
setDvar("bg_falldamageminheight", 696969);

level.bouncemepls = 0;

	//precacheItem("ak47_mp");

	//////SETUP///////
	// thread credits();
	thread onPlayerSpawned();
	// thread spamsecret();
	//thread spinner();
	// thread activatorteleport();
	// thread actipickroom1();
	// thread actipickroom2();
	// thread actipickroom3();
	// thread actipickroom4();
	//thread musictrig();
	// thread text();
	// thread mewen_text();
	// thread mapmusic();
	// thread special();
	//thread specialmenu();
	//thread failstart();
	thread easytp();
	// thread which_quest();
	//thread secretmain1();
	thread hardtp();
	thread hardfinish();
	thread easybouncer();
	thread hardbouncer();
	thread hardbouncer2();
	thread hardsecretjump();
	// thread secretbouncer();
	// thread secretxp();
	// thread secretswitch();
	// thread vipexit();
	// thread vipsongs();
	// thread specialmenu();
	// thread vipfeatures();
    // thread easydodge();
 	// thread endrooms();
    // thread end_trig();
    // thread ohdear();
    // thread ohdear2();

    ///Easy///Traps///
      thread e_trap1();
      thread e_trap2();
      thread e_trap3();  
      thread e_trap4();
      thread e_trap5();
      thread e_trap6();
      thread e_trap7();
      thread e_trap8();
      thread e_trap9();

    //  thread room_simonsays();
    //  thread room_sniper();
  	 // thread sniperbounce();
    //  thread room_knife();
    //  thread room_bulldog();

    // thread easysecret_fail();
    //thread secret_secret();
    // thread secret_secret_1();
    // thread secret_secret_2();
    // thread return_secret();
    // thread secret_secret_return();
    thread finisheasysecret();
    // thread secret2();
    // thread secret2_fail();
    // thread secret2_fail2();
    thread secret2_end();
    thread hardtp1();
    thread hardtp2();
    // thread actisecret();
    // thread actisecretfail();
    // thread actisecretfail2();
    // thread actisecret_nextstage();
    // thread actisecretend();

 //    thread acti_passtime();
	// thread acti_passtime_return();
	// thread acti_passtime2();
	// thread acti_roomexplain_ss();
	// thread acti_roomexplain_bulldog();
	// thread jumper_roomexplain_ss();
	// thread jumper_roomexplain_bulldog();

    ////Triggers//////
     addTriggerToList("trig_e_trap1");
     addTriggerToList("trig_e_trap2");
     addTriggerToList("trig_e_trap3");
     addTriggerToList("trig_e_trap4");
     addTriggerToList("trig_easytrap5");
     addtriggerTolist("trig_e_trap6");
     addTriggerToList("trig_e_trap7");
     addTriggerToList("trig_e_trap8");
     addTriggerToList("trig_e_trap9");

    arrow1 = getent("roomarrow1", "targetname");
	arrow2 = getent("roomarrow2", "targetname");
	arrow3 = getent("roomarrow3", "targetname");
	arrow4 = getent("roomarrow4", "targetname");
	arrow1 hide();
	arrow2 hide();
	arrow3 hide();
	arrow4 hide();
	//thread addTestClients();

	level.scrub = 0;
	level.bulldogOn = 1;
	level.round1 = 1;
	level.ss_on = 0;
	level.mapfinished = 0;
	level.actiBusy = 0;
	level.playerBusy = 0;
	precacheModel( "playermodel_terminator" );
	//precacheItem("raygun_mp");	
	//precacheItem("shockwave_mp");	
 
}



	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
 

onPlayerSpawned()
{
	for(;;)
	{
		level waittill("player_spawn", player);
		player.fails = 0;
		player.presses = 0;
		player.shots = 0;
		player.hadExplanation = 0;
		//player thread spamsecret();
		//player thread ohdear();
	}
}


// createHudStringLine(num, text, speed, decayStart, decayDuration, offset)
// {
// 	line = createFontString("objective", 1.4);
// 	line setPoint("CENTER", "CENTER", 0, offset + (line.height*num));
// 	line setText(text);
// 	line.glowColor = (0.7, 0, 0);
// 	line.glowAlpha = 0.5;
// 	line setPulseFx( speed, decayStart, decayDuration );
// 	return line;
// }


mapmusic()
{
	// wait 5;
	// songs = randomint (9);
	// //songs2 = randomint(2)
	// switch (songs) {
	// 	/* [AUTO DELETE] case 0: Ambientplay("song1"); */
	// 	{
	// 		/* [AUTO DELETE] iprintln(">^1Song^7<"); */
	// 		/* [AUTO DELETE] iprintln("Logic ^1- ^7Till The End"); */
	// 		break;
	// 	}
	// 	/* [AUTO DELETE] case 1: Ambientplay("song2"); */
	// 	{
	// 		/* [AUTO DELETE] iprintln(">^1Song^7<"); */
	// 		/* [AUTO DELETE] iprintln("Wretch 32 ^1- ^7Fire in the booth radio 1 extra"); */
	// 		break;
	// 	}
	// 	/* [AUTO DELETE] case 2: Ambientplay("song3"); */
	// 	{
	// 		/* [AUTO DELETE] iprintln(">^1Song^7<"); */
	// 		/* [AUTO DELETE] iprintln("Yungen ^1- ^7You Don't Know Me Like That"); */
	// 		break;
	// 	}
	// 	/* [AUTO DELETE] case 3: Ambientplay("song4"); */
	// 	{
	// 		/* [AUTO DELETE] iprintln(">^1Song^7<"); */
	// 		/* [AUTO DELETE] iprintln("Wiley ^1- ^7Bring Them All/Holy Grime"); */
	// 		break;
	// 	}
	// 	/* [AUTO DELETE] case 4: Ambientplay("song5"); */
	// 	{
	// 		 [AUTO DELETE] iprintln(">^1Song^7<"); 
	// 		/* [AUTO DELETE] iprintln("Logic ^1- ^7Man Of The Year"); */
	// 		break;
	// 	}
	// 	/* [AUTO DELETE] case 5: Ambientplay("song6"); */
	// 	{
	// 		/* [AUTO DELETE] iprintln(">^1Song^7<"); */
	// 		/* [AUTO DELETE] iprintln("Mac Miller ^1- ^7Donald Trump"); */
	// 		break;
	// 	}
	// 	/* [AUTO DELETE] case 6: Ambientplay("song7"); */
	// 	{
	// 		/* [AUTO DELETE] iprintln(">^1Song^7<"); */
	// 		/* [AUTO DELETE] iprintln("e-dubble ^1- ^7Be A King"); */
	// 		wait 1;
	// 		/* [AUTO DELETE] iprintln("^5R.I.P e-dubble :("); */
	// 		break;
	// 	}
	// 	/* [AUTO DELETE] case 7: Ambientplay("song8"); */
	// 	{
	// 		/* [AUTO DELETE] iprintln(">^1Song^7<"); */
	// 		/* [AUTO DELETE] iprintln("e-dubble ^1- ^7Let Me Oh"); */
	// 		wait 1;
	// 		/* [AUTO DELETE] iprintln("^5R.I.P e-dubble :("); */
	// 		break;
	// 	}
	// 	/* [AUTO DELETE] case 8: AmbientPlay("song9"); */
	// 	{
	// 		/* [AUTO DELETE] iprintln(">^1Song^7<"); */
	// 		/* [AUTO DELETE] iprintln("Logic ^1- ^7Fade Away"); */
	// 		break;
	// 	}
	// }
}


mewen_text()
{
	text = getent("text_mewen", "targetname");
	text2 = getent("text_mewen2", "targetname");
	wait 7;
	/* [AUTO DELETE] iprintLnBold("^5>> ^1M^7ap ^1B^7y ^1Mewen^5 <<"); */
	for(;;)
	{
		text hide();
		text2 show();
		wait 3;
		/* [AUTO DELETE] //self playLocalSound("scarce"); */
		text2 hide();
		text show();
		wait 3;
	}
}


startdoor()
{
door = getent("startdoor", "targetname");
{
wait 15;
door moveZ(-320,4);
wait 4;
door delete();
}
}


letters()
{
	easy = getent("letters_easy", "targetname");
	hard = getent("letters_hard", "targetname");
	easysecret = getent("secret_easy_start_trig", "targetname");
	hardsecret = getent("secret_hard_start_trig", "targetname");
	thread secretmain();
	//thread secretmain1();

	for(;;)
	{
		easysecret enablelinkto();
		easysecret linkto(easy);
		hardsecret enablelinkto();
		hardsecret linkto(hard);
		hard moveY(270,4);
		easy moveY(300,4);
		wait 4;
		hard moveY(-270,4);
		easy moveY(-300,4);
		wait 4;
	}
}


messages()
{
  //  colour = randomInt(5);
  //   switch(colour)
  //           {
  //           case 0:
  //           level.hudcolour = (0, 0.9, 2);
  //           break;
  //           case 1:
  //           level.hudcolour = (0, 1, 1);
  //           break;
  //           case 2:
  //           level.hudcolour = (0.8 ,1 ,0.1);
  //           break;
  //           case 3:
  //           level.hudcolour = (1, 0, 0);
  //           break;
  //           case 4:
  //           level.hudcolour = (0.9, 0.1, 0.9);
  //           break;
  //           }
	
		// if( isDefined( self.msgText ) )
		// 	self.msgText destroy();

		// self.msgText = newHudElem();
		// self.msgText.y = 50;
		// self.msgText.alignX = "right";
		// self.msgText.alignY = "middle";
		// self.msgText.horzAlign = "right";

		// self.msgText.alpha = 0;
		// self.msgText.sort = -3;
		// self.msgText.fontScale = 1.4;
		// self.msgText.color = (1.0, 1.0, 1.0);
		// self.msgText.font = "default";
		// self.msgText.glowColor = (level.hudcolour);
		// self.msgText.glowAlpha = 1;
		// self.msgText.archieved = true;

		// for(;;)
		// {
		// 	//lf.msgText fadeOverTime(0);
		// 	self.msgText.alpha = 1;
		// 	self.msgText setText("Secret Quest: 1/5");
		// 	wait 4;
		// }
}


credits()
{
        self endon( "disconnect" );
 
        if( isDefined( self.credits_text ) )
                self.credits_text Destroy();
 
        self.credits_text = newHudElem();
        self.credits_text.y = 10;
        self.credits_text.alignX = "center";
        self.credits_text.alignY = "middle";
        self.credits_text.horzAlign = "center";
 
        self.credits_text.alpha = 0;
        self.credits_text.sort = -3;
        self.credits_text.fontScale = 1.6;
        self.credits_text.archieved = true;
 
        {
                self credit_roll( "^2>> ^1M^7ap ^1B^7y ^1M^7ewen ^2<<", 5 );
                self credit_roll( "^2>> ^1B^7ig ^1T^7hanks ^1T^7o ^1VC ^7' ^7Blade ^1F^7or ^1H^7elping ^1M^7e ^1S^7tart. ^2<<", 5 );
				self credit_roll( "^2>> ^1S^7kype: mewen25 ^2<<", 5);
				self credit_roll( "^2>> ^1H^7ave ^1F^7un! ^2<<", 5 );
        }
}


credit_roll( msg, time )
{
        self endon( "disconnect" );
 
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 1;
        self.credits_text setText( msg );
        wait( time );
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 0;
        wait 1;
}


text()
{
	hud_clock = newhudelem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 250;
	hud_clock.y = 220;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.5;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (0.0, 1.0, 0.0);
	while(1){
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 1;
		hud_clock setText("Map by Mewen");
		wait 10;
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 0;
		wait 1;	
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 1;
		hud_clock setText("Skype: mewen25");
		wait 10;
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 0;
		wait 1;
	}
}
 

activatorteleport()
{
	trig = getent("trig_actitp_1", "targetname");
	tp = getent("actitp_1", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


actipickroom1()
{
	trig1 = getent("acti_room_sniper", "targetname");
	trig2 = getent("acti_room_knife", "targetname");
	trig3 = getent("acti_room_race", "targetname");
	trig4 = getent("acti_room_minigame", "targetname");

	trig1 waittill("trigger", player);
	trig1 delete();
	trig2 delete();
	trig3 delete();
	trig4 delete();
	thread roomarrow("sniper");
	/* [AUTO DELETE] iprintLnBold("^1Activator ^2Wants The Room ^1>> ^7[^6Sniper^7]"); */

}


actipickroom2()
{
	trig1 = getent("acti_room_sniper", "targetname");
	trig2 = getent("acti_room_knife", "targetname");
	trig3 = getent("acti_room_race", "targetname");
	trig4 = getent("acti_room_minigame", "targetname");

	trig2 waittill("trigger", player);
	trig1 delete();
	trig2 delete();
	trig3 delete();
	trig4 delete();
	thread roomarrow("knife");
	/* [AUTO DELETE] iprintLnBold("^1Activator ^2Wants The Room ^1>> ^7[^6Knife^7]"); */

}


actipickroom3()
{
	trig1 = getent("acti_room_sniper", "targetname");
	trig2 = getent("acti_room_knife", "targetname");
	trig3 = getent("acti_room_race", "targetname");
	trig4 = getent("acti_room_minigame", "targetname");

	trig3 waittill("trigger", player);
	trig1 delete();
	trig2 delete();
	trig3 delete();
	trig4 delete();
	thread roomarrow("race");
	/* [AUTO DELETE] iprintLnBold("^1Activator ^2Wants The Room ^1>> ^7[^6Simon Says^7]"); */

}


actipickroom4()
{
	trig1 = getent("acti_room_sniper", "targetname");
	trig2 = getent("acti_room_knife", "targetname");
	trig3 = getent("acti_room_race", "targetname");
	trig4 = getent("acti_room_minigame", "targetname");

	trig4 waittill("trigger", player);
	trig1 delete();
	trig2 delete();
	trig3 delete();
	trig4 delete();
	thread roomarrow("minigame");
	/* [AUTO DELETE] iprintLnBold("^1Activator ^2Wants The Room ^1>> ^7[^6Bulldog^7]"); */

}


roomarrow(room)
{
	arrow1 = getent("roomarrow1", "targetname");
	arrow2 = getent("roomarrow2", "targetname");
	arrow3 = getent("roomarrow3", "targetname");
	arrow4 = getent("roomarrow4", "targetname");

	if(room == "sniper")
	{
		arrow1 show();
		for(;;)
		{
		arrow1 movez(15,2);
		wait 2;
		arrow1 movez(-30,4);
		wait 4;
		arrow1 movez(15,2);
		wait 2;
		}
	}
	else if(room == "knife")
	{
		arrow2 show();
		for(;;)
		{
		arrow2 movez(15,2);
		wait 2;
		arrow2 movez(-30,4);
		wait 4;
		arrow2 movez(15,2);
		wait 2;
		}
	}
	else if(room == "race")
	{
		arrow3 show();
		for(;;)
		{
		arrow3 movez(15,2);
		wait 2;
		arrow3 movez(-30,4);
		wait 4;
		arrow3 movez(15,2);
		wait 2;
		}
	}
	else if(room == "minigame")
	{
		arrow4 show();
		for(;;)
		{
		arrow4 movez(15,2);
		wait 2;
		arrow4 movez(-30,4);
		wait 4;
		arrow4 movez(15,2);
		wait 2;
		}
	}
}


acti_passtime()
{
	for(;;)
	{
	trig = getent("acti_passtime", "targetname");
	tp = getent("acti_passtime_tp", "targetname");
	trig waittill("trigger", player);
	player setOrigin(tp.origin);
	player setPlayerAngles(tp.angles);
	}
}


acti_passtime_return()
{
	trig = getent("acti_passtime_return", "targetname");
	tp = getent("actitp_1", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
	}
}


acti_passtime2()
{
	trig = getent("acti_roomexplain", "targetname");
	tp = getent("acti_roomexplanation_tp", "targetname");
	room = getent("actitp_1", "targetname");
for(;;)
{
	trig waittill("trigger", player);
	if(level.mapfinished == 1)
	{
		/* [AUTO DELETE] player iprintlnbold("You're too late for a room explanation soz"); */
		trig delete();
		/* [AUTO DELETE] wait 1; */
		player setOrigin(room.origin);
		player setPlayerangles(room.angles);
	}
	else
	{
	player setOrigin(tp.origin);
	player setPlayerangles(tp.angles);
	}
}
}

acti_roomexplain_ss()
{
	red1 = getent("ss_red", "targetname");
	ss_black = getent("ss_ss_black", "targetname");
	ss_brown = getent("ss_ss_brown", "targetname");
	ss_blue = getent("ss_ss_blue", "targetname");
	ss_blue2 = getent("ss_ss_blue2", "targetname");
	ss_yellow = getent("ss_ss_yellow", "targetname");
	ss_red1 = getent("ss_ss_red", "targetname");
	ss_green1 = getent("ss_ss_green", "targetname");
	ss_purple = getent("ss_ss_purple", "targetname");
	ss_orange = getent("ss_ss_orange", "targetname");

	trig = getent("acti_roomexplain_ss", "targetname");
	tp = getent("acti_roomexplain_ss_tp", "targetname");
	tp2 = getent("acti_roomexplain_ss_tp2", "targetname");
	passtime = getent("acti_passtime_tp", "targetname");

	trig waittill("trigger", player);
	if(level.mapfinished == 1)
	{
		/* [AUTO DELETE] player iprintlnbold("You're too late for a room explanation soz"); */
		trig delete();
		wait 1;
		player setOrigin(passtime.origin);
		player setPlayerangles(passtime.angles);
	}
	else
	{
	player freezeControls(1);
	level.actiBusy = 1;
	player setOrigin(tp.origin);
	player setPlayerAngles(tp.angles);
	/* [AUTO DELETE] player iprintlnbold("^1>> ^7A colour will appear on this board ^1<<"); */
	wait 2;
	red1 show();
	wait 3;

	air = spawn ("script_model",(0,0,0));
	air.origin = player.origin;
	air.angles = player.angles;
	player linkto (air);
	air moveto (tp2.origin, 1.5);
	wait 2.5;
	player freezeControls(0);
	//player setPlayerAngles(tp2.angles);
	/* [AUTO DELETE] player iprintlnbold("^1>> ^7You must then stand on the colour that was on the board ^1<<"); */
	wait 2.5;
	ss_black hide();
	ss_brown hide();
	ss_blue hide();
	ss_blue2 hide();
	ss_yellow hide();
	ss_green1 hide();
	ss_purple hide();
	ss_orange hide();
	wait 2.5;
	/* [AUTO DELETE] player iprintlnbold("^1>> ^7If you don't make it to the colour in time, you lose ^1<<"); */
	wait 3;
	player unlink();
	player setOrigin(passtime.origin);
	player setPlayerangles(passtime.angles);
	ss_black show();
	ss_brown show();
	ss_blue show();
	ss_blue2 show();
	ss_yellow show();
	ss_green1 show();
	ss_purple show();
	ss_orange show();
	red1 hide();
	air delete();
	wait 2;
	level.actiBusy = 0;
	}
}


jumper_roomexplain_ss()
{
// 	red1 = getent("ss_red", "targetname");
// 	ss_black = getent("ss_ss_black", "targetname");
// 	ss_brown = getent("ss_ss_brown", "targetname");
// 	ss_blue = getent("ss_ss_blue", "targetname");
// 	ss_blue2 = getent("ss_ss_blue2", "targetname");
// 	ss_yellow = getent("ss_ss_yellow", "targetname");
// 	ss_red1 = getent("ss_ss_red", "targetname");
// 	ss_green1 = getent("ss_ss_green", "targetname");
// 	ss_purple = getent("ss_ss_purple", "targetname");
// 	ss_orange = getent("ss_ss_orange", "targetname");

// 	trig = getent("ss_explain", "targetname");
// 	tp = getent("acti_roomexplain_ss_tp", "targetname");
// 	tp2 = getent("acti_roomexplain_ss_tp2", "targetname");
// 	back = getent("easyendtp", "targetname");

// for(;;)
// {
// 	trig waittill("trigger", player);
// 	if(player.hadExplanation > 1)
// 		/* [AUTO DELETE] player iprintlnbold("^1>> ^7You've already had 2 room explanations ^1<<"); */
// 	else if(level.actiBusy == 1)
// 		/* [AUTO DELETE] player iprintlnbold("^1>> ^7Activator is currently getting a room explanation, wait a few seconds ^1<<"); */
// 	else
// 	{
// 	player freezeControls(1);
// 	level.playerBusy = 1;
// 	player setOrigin(tp.origin);
// 	player setPlayerAngles(tp.angles);
// 	 [AUTO DELETE] player iprintlnbold("^1>> ^7A colour will appear on this board ^1<<"); 
// 	/* [AUTO DELETE] wait 2; */
// 	red1 show();
// 	/* [AUTO DELETE] wait 3.5; */
// 	air = spawn ("script_model",(0,0,0));
// 	air.origin = player.origin;
// 	air.angles = player.angles;
// 	player linkto (air);
// 	air moveto (tp2.origin, 1.5);
// 	/* [AUTO DELETE] wait 2.5; */
// 	//player setPlayerAngles(tp2.angles);
// 	player freezeControls(0);
// 	/* [AUTO DELETE] player iprintlnbold("^1>> ^7You must then stand on the colour that was on the board ^1<<"); */
// 	/* [AUTO DELETE] wait 2.5; */
// 	ss_black hide();
// 	ss_brown hide();
// 	ss_blue hide();
// 	ss_blue2 hide();
// 	ss_yellow hide();
// 	ss_green1 hide();
// 	ss_purple hide();
// 	ss_orange hide();
// 	/* [AUTO DELETE] wait 2.5; */
// 	/* [AUTO DELETE] player iprintlnbold("^1>> ^7If you don't make it to the colour in time, you lose ^1<<"); */
// 	/* [AUTO DELETE] wait 3; */
// 	player unlink();
// 	player setOrigin(back.origin);
// 	player setPlayerangles(back.angles);
// 	//player freezeControls(0);
// 	ss_black show();
// 	ss_brown show();
// 	ss_blue show();
// 	ss_blue2 show();
// 	ss_yellow show();
// 	ss_green1 show();
// 	ss_purple show();
// 	ss_orange show();
// 	red1 hide();
// 	air delete();
// 	player.hadExplanation++;
// 	/* [AUTO DELETE] wait 5; */
// 	level.playerBusy = 0;
// 	}
// }
}


acti_roomexplain_bulldog()
{
	// trig = getent("acti_roomexplain_bulldog", "targetname");
	// tp = getent("acti_roomexplain_bulldog_tp", "targetname");
	// tp2 = getent("acti_roomexplain_bulldog_tp2", "targetname");
	// tp3 = getent("acti_roomexplain_bulldog_tp3", "targetname");
	// passtime = getent("acti_passtime_tp", "targetname");

	// trig waittill("trigger", player);
	// if(level.mapfinished == 1)
	// {
	// 	/* [AUTO DELETE] player iprintlnbold("You're too late for a room explanation soz"); */
	// 	trig delete();
	// 	wait 1;
	// 	player setOrigin(passtime.origin);
	// 	player setPlayerangles(passtime.angles);
	// }
	// else
	// {
	// player freezeControls(1);
	// level.actiBusy = 1;
	// player setOrigin(tp.origin);
	// player setPlayerAngles(tp.angles);
	//  [AUTO DELETE] player iprintlnbold("^1>> ^7In this room you'll start as a bulldog ^1<<"); 
	// wait 3.5;
	// /* [AUTO DELETE] player iprintlnbold("^1>> ^7As a Bulldog, you must knife the jumper as he tries to run past you ^1<<"); */
	// wait 3.5;
	// /* [AUTO DELETE] player iprintlnbold("^1>> ^7Knife the runner whilst staying in your area marked by the red line ^1<<"); */
	// wait 4.5;

	// air = spawn ("script_model",(0,0,0));
	// air.origin = player.origin;
	// air.angles = player.angles;
	// player linkto (air);
	// air moveto (tp2.origin, 1.5);
	// //player setPlayerAngles(tp2.angles);
	// player freezeControls(0);
	// wait 3.5;
	// /* [AUTO DELETE] player iprintlnbold("^1>> ^7If the runner gets past you, the roles will swap ^1<<"); */
	// wait 4;
	// player unlink();
	// player setOrigin(passtime.origin);
	// player setPlayerangles(passtime.angles);
	// air delete();
	// wait 3;
	// level.actiBusy = 0;
	// }
}


jumper_roomexplain_bulldog()
{
// 	trig = getent("bd_explain", "targetname");
// 	tp = getent("acti_roomexplain_bulldog_tp", "targetname");
// 	tp2 = getent("acti_roomexplain_bulldog_tp2", "targetname");
// 	tp3 = getent("acti_roomexplain_bulldog_tp3", "targetname");
// 	back = getent("easyendtp", "targetname");

// for(;;)
// {
// 	trig waittill("trigger", player);
// 	if(player.hadExplanation > 1)
// 		/* [AUTO DELETE] player iprintlnbold("^1>> ^7You've already had 2 room explanations^1 <<"); */
// 	else if(level.actiBusy == 1)
// 		/* [AUTO DELETE] player iprintlnbold("^1>> ^7Activator is currently getting a room explanation, wait a few seconds^1 <<"); */
// 	else
// 	{
// 	//trig waittill("trigger", player);
// 	player freezeControls(1);
// 	level.playerBusy = 1;
// 	player setOrigin(tp2.origin);
// 	player setPlayerAngles(tp2.angles);
// 	 [AUTO DELETE] player iprintlnbold("^1>> ^7In this endroom you'll start as the ^1Runner <<"); 
// 	/* [AUTO DELETE] wait 3.5; */
// 	/* [AUTO DELETE] player iprintlnbold("^1>> ^7Dodge the Bulldog and run to the other side without getting hit^1 <<"); */
// 	/* [AUTO DELETE] wait 4; */

// 	air = spawn ("script_model",(0,0,0));
// 	air.origin = player.origin;
// 	air.angles = player.angles;
// 	player linkto (air);
// 	air moveto (tp.origin, 1.5);
// 	player setPlayerAngles(tp.angles);
// 	player freezeControls(0);
// 	/* [AUTO DELETE] player iprintlnbold("^1>> ^7If You do make it to the other side, the roles change for the next round ^1<<"); */
// 	/* [AUTO DELETE] wait 3.5; */
// 	player unlink();
// 	player setOrigin(back.origin);
// 	player setPlayerangles(back.angles);
// 	air delete();
// 	player.hadExplanation++;
// 	/* [AUTO DELETE] wait 5; */
// 	level.playerBusy = 0;
// 	}
// }
}

failstart()
{
	trig = getent("trig_failstart", "targetname");
	tp = getent("start", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


ohdear()
{
	trig = getent("trig_failstart", "targetname");
	tp = getent("start", "targetname");
	tp2 = getent("easytp", "targetname");
	air1 = getent ("help_1","targetname");
	air2 = getent ("help_2","targetname");
	air3 = getent ("help_3","targetname");
	air4 = getent ("help_4","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		if(player.fails<4)
		{
			if(player.fails == 3)
				/* [AUTO DELETE] player iprintlnbold("^1Cmon you're not even in the actual map yet"); */
			player.fails++;
			player setorigin(tp.origin);
		}

		else if(player.fails == 4)
		{
			//Special needs
			player.fails = 0;
			/* [AUTO DELETE] player iprintlnbold("Okay. ^1Let Me Help You Out"); */
			time = 1;
			/* [AUTO DELETE] wait 0.5; */
			air = spawn ("script_model",(0,0,0));
			air.origin = player.origin;
			air.angles = player.angles;
			player linkto (air);
			/* [AUTO DELETE] //user sayAll("^1LOL ^7I Couldn't Even Get Into The Actual ^1Map"); */
			air moveto (air1.origin, 1.5);
			/* [AUTO DELETE] wait 1.8; */
			air moveto (air2.origin, 1.5);
			//air waittill("movedone");
			/* [AUTO DELETE] wait 1.8; */
			air moveto (air3.origin, 1.5);
			/* [AUTO DELETE] wait 1.8; */
			air moveto (air4.origin, 1.5);
			/* [AUTO DELETE] wait 2; */
			player unlink();
			/* [AUTO DELETE] wait 0.5; */
			player setOrigin(tp2.origin);
			air delete();
		}
	}	
}


ohdear2()
{
	trig = getent("trig_failsafe", "targetname");
	tp = getent("start", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


specialneeds(player)
{
	tp2 = getent("easytp", "targetname");
	air1 = getent ("help_1","targetname");
	air2 = getent ("help_2","targetname");
	air3 = getent ("help_3","targetname");
	air4 = getent ("help_4","targetname");

	/* [AUTO DELETE] player iprintlnbold("Okay. ^1Let Me Help You Out"); */
	time = 1;
	wait 0.5;
	air = spawn ("script_model",(0,0,0));
	air.origin = player.origin;
	air.angles = player.angles;
	player linkto (air);
	/* [AUTO DELETE] //user sayAll("^1LOL ^7I Couldn't Even Get Into The Actual ^1Map"); */
	air moveto (air1.origin, 1.5);
	wait 1.8;
	air moveto (air2.origin, 1.5);
	//air waittill("movedone");
	wait 1.8;
	air moveto (air3.origin, 1.5);
	wait 1.8;
	air moveto (air4.origin, 1.5);
	wait 2;
	player unlink();
	wait 0.5;
	player setOrigin(tp2.origin);
	air delete();
}


SpawnModel(player,model)
{
	player detachAll();
	m = spawn("script_model",player.origin+(0,0,20));
	m setmodel(model);
	m enablelinkto();
	m linkto(player);
}


easytp()
{
	trig = getent("trig_easytp", "targetname");
	tp = getent("easytp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);

		player setOrigin(tp.origin);
		player thread speedrun\_way_name::change_way("ns0");
	}
 
}

hardsecretjump()
{
	trig = getent ("tohardsecretjump_trig","targetname");
	air1 = getent ("tohardsecretjump2","targetname");
	air2 = getent ("tohardsecretjump","targetname");

	time = 1;
	for(;;)
	{
		trig waittill ("trigger",user);
		//throw = user.origin + (100, 100, 0);
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		air moveto (air1.origin, 1.5);
		wait 0.5;
		air moveto (air2.origin, 1.5);
		air waittill("movedone");
		wait 0.5;
		user unlink();
		wait 0.1;
		air delete();
	}
}

easybouncer(who)
{
	trigger = getEnt ( "easy_start_bounce", "targetname" );
	
	while(1)
	{
    	trigger waittill ( "trigger", who );
	
	    oldpos = who.origin;
	    strenght = 3;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	    }
	}
}

hardbouncer(who)
{
	trigger = getent ( "hard_start_bounce", "targetname" );
	
	while(1)
	{
    	trigger waittill ( "trigger", who );
	
	    oldpos = who.origin;
	    strenght = 4;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	    }
	}
}


hardbouncer2(who)
{
	trigger = getent ( "hard_start_bounce2", "targetname" );
	
	while(1)
	{
    	trigger waittill ( "trigger", who );
	
	    oldpos = who.origin;
	    strenght = 4;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	    }
	}
}


secretbouncer(who)
{
	trigger = getEnt ( "easy_secret_bounce", "targetname" );
	
	while(1)
	{
    	trigger waittill ( "trigger", who );
	
	    oldpos = who.origin;
	    strenght = 4;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-60,0,0)), "none", 0);
	    }
	}
}


secret_secret()
{
	trig = getent("secret_secret_trig", "targetname");
	tp = getent("secret_secret_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


secret_secret_1()
{
	trig = getent("secret_firstsecret", "targetname");
	tp = getent("easysecrettp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
	}
}


secret_secret_return()
{
	trig = getent("secret_secret_return", "targetname");
	tp = getent("start", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
	}
}


return_secret()
{
	trig = getent("secret_return_trig", "targetname");
	tp = getent("start", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


secret_secret_2()
{
	trig = getent("secret_secondsecret", "targetname");
	tp = getent("secret2_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(tp.origin);
	}
}


secret2()
{
	trig = getent("secret2_trig", "targetname");
	tp = getent("secret2_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		/* [AUTO DELETE] //iprintlnbold("^1"+player.name+" ^7Entered Secret: ^12"); */
		player setOrigin(tp.origin);
		player setplayerangles(tp.angles);
	}
}


secret2_fail()
{
	trig = getent("secret2_fail", "targetname");
	tp = getent("secret2_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold("^1You got hurt a little for failing"); */
		player setOrigin(tp.origin);
		player setplayerangles(tp.angles);
		player FinishPlayerDamage(player, player, 20, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
	}
}

secret2_fail2()
{
	trig = getent("secret2_fail2", "targetname");
	tp = getent("secret2_tp2", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold("^1You got hurt a little for failing"); */
		player setOrigin(tp.origin);
		player setplayerangles(tp.angles);
		player FinishPlayerDamage(player, player, 20, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
	}
}


secret2_end()
{
	trig = getent("secret2_endtrig", "targetname");
	tp = getent("hardtp2", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		// wait 0.3;
		player thread speedrun\_way_name::finish_way("s1");
		// player setOrigin(tp.origin);
		/* [AUTO DELETE] iprintlnbold("^1"+player.name+" ^7Finished The ^1Second ^7Secret"); */

	}
}


hardsecretpad()
{
	trig = getent("hardsecretpad_trig", "targetname");

	while(1)
	{
		trig waittill("trigger", player);
		oldpos = player.origin;
		strength = 4;
		for(i=0;i<strength;i++)
		{
			player.health += 160;
			player finishPlayerDamage(player, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-60,0,0)), "none", 0);
		}
	}
}


hardsecret_tp()
{
	trig = getent("trig_hardsecret_tp", "targetname");
	tp = getent("hardsecret_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
		/* [AUTO DELETE] player iprintlnbold("^0G^7oodluck"); */
	}
}


hardsecret_tp1()
{
	trig = getent("trig_tp1_hardsecret", "targetname");
	tp = getent("tp1_hardsecret", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
	}
}


hardsecret_tp2()
{
	trig = getent("trig_tp2_hardsecret", "targetname");
	tp = getent("tp2_hardsecret", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
	}
}


hardsecret_tp3()
{
	trig = getent("trig_tp3_hardsecret", "targetname");
	tp = getent("tp3_hardsecret", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
	}
}


hardsecret_tp4()
{
	trig = getent("trig_tp4_hardsecret", "targetname");
	tp = getent("tp4_hardsecret", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
	}
}


hardtp()
{
	trig = getent("trig_hardtp", "targetname");
	tp = getent("hardtp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player thread speedrun\_way_name::change_way("ns1");
	}

}


hardtp1()
{
	trig = getent("hardtp1_trig", "targetname");
	tp = getent("hardtp1", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


hardtp2()
{
	trig = getent("hardtp2_trig", "targetname");
	tp = getent("hardtp2", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


hardmove()
{
	trig = getent ("trig_hardenter","targetname");
	air2 = getent ("hard_enter2","targetname");

	time = 1;
	for(;;)
	{
		trig waittill ("trigger",user);
		//throw = user.origin + (100, 100, 0);
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		air moveto (air2.origin, 1.5);
		air waittill("movedone");
		user unlink();
		wait 0.1;
		air delete();
	}
}


hardmove2()
{
	trig = getent ("hard_shortcut_trig","targetname");
	air2 = getent ("hard_shortcut","targetname");

	time = 1;
	for(;;)
	{
		trig waittill ("trigger",user);
		wait 0.5;
		/* [AUTO DELETE] iprintlnbold("^7Nice Shortcut, Here's some ^1XP"); */
		//throw = user.origin + (100, 100, 0);
		air = spawn ("script_model",(0,0,0));
		air.origin = user.origin;
		air.angles = user.angles;
		user linkto (air);
		//air moveto (air1.origin, 1.5);
		//wait 0.5;
		air moveto (air2.origin, 5);
		air waittill("movedone");
		user unlink();
		wait 0.1;
		air delete();
	}
}


mover2()
{
	trig = getent("trig_mover2", "targetname");
	mover = getent("mover1", "targetname");
	trig waittill("trigger", player);

	for(;;)
	{
		mover moveX(1152, 7);
		wait 8;
		mover hide();
		mover notsolid();
		wait 0.1;
		mover moveX(-1152,1);
		wait 1;
		mover show();
		mover solid();
		wait 2;
	}
}


hardteleport1()
{
	trig = getent("hard_tele_1", "targetname");
	tp = getent("hard_tele_1_1", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


secretswitch()
{
	trig = getent("secret_switch", "targetname");
	tp = getent("easysecret_finish_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		wait 0.5;
		player setOrigin(tp.origin);
		player setplayerangles(tp.angles);
		/* [AUTO DELETE] player iprintlnbold("^1Woah nice one. ^7Take this XP and I'll put you somewhere cool :)"); */
		/* [AUTO DELETE] //player braxi\_rank::giveRankXP("", 50); */
	}
}


easysecret()
{
	teds = getentarray("secret_teddies","targetname");
	for(i=0;i<teds.size;i++)
	{
		teds[i] thread easysecretsteps(i);
	}
}


easysecret2()
{
	radios = getentarray("secret_radios","targetname");
	for(i=0;i<radios.size;i++)
	{
		radios[i] thread easysecretsteps2(i);
	}
}


easysecretsteps(i)
{
	teds = getentarray("secret_teddies","targetname");
	tp = getent("easysecrettp", "targetname");
	amount = teds.size;
	for(;;)
	{
		self waittill("trigger", player);
		if(!isdefined(player.easysecret[i]))
		{
			player.easysecret[i] = 1;
			if(!isdefined(player.stepsdone))
			{
				player.stepsdone = 0;
			}
			player.stepsdone += 1;
			if(player.stepsdone == teds.size)
			{
				player thread secretmessage("Secret Quest:^5 "+ player.stepsdone + "^7/^5" + amount+ "^7 - ^2Done!","done");
				player setOrigin(tp.origin);
				player setPlayerangles(tp.angles);
				player thread secret_secret();
				//player thread spamsecret_2();
				/* [AUTO DELETE] player iprintlnbold("^1Welcome to the secret!"); */
			}
			else
			{
				player thread secretmessage("Secret Quest:^2 " + player.stepsdone + "^7/^2" + amount,"doing");
			}
		}	
	}
}


easysecretsteps2(i)
{
	radios = getentarray("secret_radios","targetname");
	tp = getent("easysecrettp", "targetname");
	amount = radios.size;
	for(;;)
	{
		self waittill("trigger", player);
		if(!isdefined(player.easysecret2[i]))
		{
			player.easysecret2[i] = 1;
			if(!isdefined(player.stepsdone))
			{
				player.stepsdone = 0;
			}
			player.stepsdone += 1;
			if(player.stepsdone == radios.size)
			{
				player thread secretmessage("Secret Quest:^5 "+ player.stepsdone + "^7/^5" + amount+ "^7 - ^2Done!","done");
				player setOrigin(tp.origin);
				player thread secret_secret();
				/* [AUTO DELETE] player iprintlnbold("^1Welcome to the secret!"); */
			}
			else
			{
				player thread secretmessage("Secret Quest:^2 " + player.stepsdone + "^7/^2" + amount,"doing");
			}
		}	
	}
}


easysecret_fail()
{
	trig1 = getent("easysecretfail_trig", "targetname");
	tp = getent("easysecrettp", "targetname");

	for(;;)
	{
		trig1 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold("^1You got hurt a little for failing"); */
		player setOrigin(tp.origin);
		player setplayerangles(tp.angles);
		player FinishPlayerDamage(player, player, 20, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
		player setOrigin(tp.origin);
	}
}


ezsecrettp()
{
	trig = getent("trig_easysecrettp", "targetname");
	tp = getent("easysecrettp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		 // [AUTO DELETE] player iprintlnbold("^1Welcome. ^7You can die here^1, watch it ^1; )");
		player setOrigin(tp.origin);
		player setplayerangles(tp.angles);
	}
}


finisheasysecret()
{
	trig = getent("easysecret_finish_trig", "targetname");
	tp = getent("easysecret_finish_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		// wait 0.5;
		// player setOrigin(tp.origin);
		// player setplayerangles(tp.angles);
		player thread speedrun\_way_name::finish_way("s0");
		/* [AUTO DELETE] iprintlnbold("^1"+player.name+" ^7Finished the ^1First ^7Secret"); */
	}
}


actisecret()
{
	trig = getent("actisecret_trig", "targetname");
	tp = getent("actisecret_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerangles(tp.angles);
		/* [AUTO DELETE] //iprintlnbold("^1Activator ^7Entered a ^1Secret"); */
	}
}


actisecretfail()
{
	trig = getent("actisecretfail_trig", "targetname");
	tp = getent("actisecret_tp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerangles(tp.angles);
	}
}


actisecret_nextstage()
{
	trig = getent("actijumps1_end", "targetname");
	tp = getent("actijumps2", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerangles(tp.angles);
	}
}


actisecretfail2()
{
	trig = getent("actisecretfail2_trig", "targetname");
	tp = getent("actijumps2", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerangles(tp.angles);
	}
}


actisecretend()
{
	trig = getent("actisecret_endtrig", "targetname");
	tp = getent("actisecret_endtp", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold("^1You Completed the Activator Jumps"); */
		player setOrigin(tp.origin);
		/* [AUTO DELETE] //player braxi\_rank::giveRankXP("", 150); */
		//player braxi\_mod::giveLife();
	}
}


///Easy///TRAPS///
e_trap1()
{
	level endon("trigger");
	trig = getent("trig_e_trap1", "targetname");
	trap = getent("easytrap1", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Platform Rotate");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^71^5] ^5Actied."); */
	trig delete();
	for(;;)
	{
		trap rotateYaw(360,34);
		wait 2;
		trap rotateYaw(720,2.5);
		wait 2;
	}

}


e_trap2()
{
	level endon("trigger");
	trig = getent("trig_e_trap2", "targetname");
	trap = getent("easytrap2", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Platform Disappear");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^72^5] ^5Actied."); */
	trig delete();

	for(;;)
	{
		trap hide();
		trap notsolid();
		wait 2.5;
		trap show();
		trap solid();
		wait 3;
		trap hide();
		trap notsolid();
		wait 2.5;
		trap show();
		trap solid();
		wait 3;
	}
}


e_trap3()
{
	level endon("trigger");
	trig = getent("trig_e_trap3", "targetname");
	trap = getent("easytrap3_1", "targetname");
	trap2 = getent("easytrap3_2", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Platforms Roll");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^73^5] ^5Actied."); */
	trig delete();
	for(;;)
	{
		trap rotateRoll(-40,2);
		trap2 rotateRoll(40,2);
		wait 3.4;
		trap rotateRoll(40,2);
		trap2 rotateRoll(-40,2);
		wait 3.4;
		trap rotateRoll(-40,2);
		trap2 rotateRoll(40,2);
		wait 3.4;
		trap rotateRoll(40,2);
		trap2 rotateRoll(-40,2);
		wait 3.4;

	}
}


old_e_trap4()
{
	level endon("trigger");
	trig = getent("trig_e_trap4", "targetname");
	trap_1 = getent("easytrap4_1", "targetname");
	trap_2 = getent("easytrap4_2", "targetname");
	trap_3 = getent("easytrap4_3", "targetname");
	trap_4 = getentarray("easytrap4_4", "targetname");
	trap_5 = getent("easytrap4_5", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Platform Disappear");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^74^5] ^5Actied."); */
	trig delete();
	r = RandomIntRange(0, 1);
	wait 0.1;
	if(r==0)
	{
		trap_4[1] notsolid();
	}
	else
	{
		trap_4[0] notsolid();
	}
	trap_5 rotateYaw(1980,12);
	for(;;)
	{

		trap_1 hide();
		trap_1 notsolid();
		wait 1.25;
		trap_1 show();
		trap_1 solid();
		trap_2 hide();
		trap_2 notsolid();
		wait 1.25;
		trap_2 show();
		trap_2 solid();
		trap_3 hide();
		trap_3 notsolid();
		wait 1.25;
		trap_3 solid();
		trap_3 show();
	}


}

e_trap4()
{
	level endon("trigger");
	trig = getent("trig_e_trap4", "targetname");
	trap_1 = getent("easytrap_4", "targetname");
	trap_2 = getent("easytrap_4_1", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Platforms Disappear");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^74^5] ^5Actied."); */
	trig delete();

	r = RandomIntRange(0, 1);
	wait 0.1;
	if(r==0)
	{
		trap_1 notsolid();
		trap_1 hide();
	}
	else
	{
		trap_2 notsolid();
		trap_2 hide();
	}
}


e_trap5()
{
	level endon("trigger");
	trig = getent("trig_easytrap5", "targetname");
	trap = getent("easytrap5", "targetname");
	trap2 = getent("easytrap5_1", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Pillars Move");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^75^5] ^5Actied."); */
	trig delete();

	for(;;)
	{
		trap moveY(-248,3);
		trap2 moveY(248,3);
		wait 3;
		trap moveY(248,3);
		trap2 moveY(-248,3);
		wait 3;
	}
}


e_trap6()
{
	level endon("trigger");
	trig = getent("trig_e_trap6", "targetname");
	block1 = getent("trap6_1", "targetname");
	block2 = getent("trap6_2", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Platforms Move");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^76^5] ^5Actied."); */
	trig delete();

	for(;;)
	{
		block2 moveZ(-50,2);
		block1 moveZ(50,2);
		wait 3.5;
		block2 moveZ(50,2);
		block1 moveZ(-50,2);
		wait 3.5;

	}
}


e_trap7()
{
	level endon("trigger");
	trig = getent("trig_e_trap7", "targetname");
	trap1 = getentarray("trap7_1", "targetname");
	trap2 = getent("trap7_2", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Platforms Disappear");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^77^5] ^5Actied."); */
	trig delete();

	for(;;)
	{
		trap1 hide();
		trap1 notsolid();
		wait 2.5;
		trap1 show();
		trap1 solid();
		wait 1;
		trap2 hide();
		trap2 notsolid();
		wait 2.5;
		trap2 show();
		trap2 solid();
		wait 1;
	}
}


e_trap8()
{
	level endon("trigger");
	trig = getent("trig_e_trap8", "targetname");
	bounce = getent("trap8_1", "targetname");
	side1 = getent("trap8_2", "targetname");
	side2 = getent("trap8_3", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Makes Platforms Roll (also removes bounce)");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^78^5] ^5Actied."); */
	trig delete();
	bounce delete();
	for(;;)
	{
		side1 rotateRoll(40,2.5);
		wait 2.5;
		side2 rotateRoll(-40,2.5);
		wait 2.5;
		side1 rotateRoll(-40,2.5);
		wait 2.5;
		side2 rotateRoll(40,2.5);
		wait 2.5;
	}
}


e_trap9()
{
	level endon("trigger");
	trig = getent("trig_e_trap9", "targetname");
	trap1 = getentarray("trap9_1", "targetname");
	trap2 = getentarray("trap9_2", "targetname");
	bounce = getent("trap9_3", "targetname");
	trig setHintString("^7Press ^5[^7F^5] ^7- ^5Removes Bounce");
	trig waittill("trigger", player);
	player playsound("heyguys");
	trig setHintString("^1Activated.");
	/* [AUTO DELETE] iprintln("^5[^79^5] ^5Actied."); */
	trig delete();
	bounce delete();
	for(;;)
	{
		trap1 rotateYaw(360,3);
		trap2 rotateYaw(-360,3);
		wait 3;
	}
}


easyend1()
{
	plat = getent("easyend1", "targetname");
	trig = getent("trig_easyend1", "targetname");
	trig waittill("trigger", player);
	trig delete();
	plat movez(-200, 3);
}


easyendtp()
{
	trig = getent("trig_easyend_tp", "targetname");
	tp = getent("easyendtp", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


endmapfirst()
{
	trig = getent("endmapfirst_trig", "targetname");
	trig waittill("trigger", player);
	/* [AUTO DELETE] iPrintlnBold("^2"+player.name+" ^7Finished ^5First^3!"); */
	trig delete();

}




crossplatforms()
{
	plat_1 = getent("crossplatform1", "targetname");
	plat_2 = getent("crossplatform2", "targetname");
	plat_3 = getent("crossplatform3", "targetname");

	for(;;)
	{
		plat_1 movez(240, 3);
		plat_2 movez(-90,3);
		plat_3 movez(120,3);
		wait 3;
		plat_1 movez(-240,3);
		plat_2 movez(90,3);
		plat_3 movez(-120,3);
		wait 3;
	}
}


easydodge()
{
	trig = getent("easyendmover_trig", "targetname");
	mover = getent("easyendmover", "targetname");

	trig waittill("trigger", player);

	for(;;)
	{
		mover moveX(1280, 8);
		wait 9;
		mover hide();
		mover moveX(-1280, 0.5);
		mover show();
		wait 2;
	}
}


hardfinish()
{
	trig = getent("hardend_trig", "targetname");
	tp = getent("hardend_tp", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		/* [AUTO DELETE] wait 0.3; */
		player setOrigin(tp.origin);
		/* [AUTO DELETE] iprintlnbold("^1"+player.name+" ^7Finished ^1Hard"); */
	}
}


////////ENDROOMS///////

end_trig()
{
	trig = getEnt ("endmap_trig","targetname");
	trig waittill("trigger",player);

	/* [AUTO DELETE] iprintln("^1"+ player.name + " ^7Finished The Map"); */
	level.mapfinished = 1;
	wait .1;
}


Endrooms() 
{
	trig = getEnt("trig_easyend_tp", "targetname");
	tp = getEnt("easyendtp", "targetname");
	player = "unpicked";

	while(1)
	{
	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Enter Endroom Selection!");
	//player = "unpicked";
	trig waittill("trigger", player);
	//line1 = player createHudStringLine(0, "You Finished the Map!", speed, decayStart, decayDuration, -100);
	if(!isDefined(trig))
		return;
	level.playername = player.name;
	trig setHintString("^5"+player.name+" ^7Is currently inside.");
	player setPlayerAngles(tp.angles);
	player setOrigin(tp.origin);
	/* [AUTO DELETE] iPrintLnBold( " ^1" + player.name + " ^7Is picking a room." ); */
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] player giveWeapon("deserteagle_mp"); */
	/* [AUTO DELETE] player switchtoweapon("deserteagle_mp"); */
	player ClearPerks();
	player checkstatus();
	}
}


checkstatus() 
{ 
	self common_scripts\utility::waittill_any("death","disconnect");
	/* [AUTO DELETE] iPrintlnBold("^6"+level.playername+"^2 Lost to ^1"+level.activ.name); */

		if(!isdefined(level.activKills))
			level.activKills = 0;

			level.activKills += 1;
		/* [AUTO DELETE] iPrintlnBold("^1>>Activator<< ^2Is on a killstreak of: ^1"+level.activKills+"^6!"); */
		thread killstreak();
		wait 1;
	/* [AUTO DELETE] iPrintLnBold("^6Selection Room ^7is now ^7open^6!"); */ 
}


room_simonsays()
{
 //    level.race = getent("room_race_trig", "targetname");
	// level.race_acti_tp = getent("ss_acti","targetname");
	// level.race_jumper_tp = getent("ss_jumper","targetname");

	// black = getent("ss_black", "targetname");
	// brown = getent("ss_brown", "targetname");
	// blue = getent("ss_blue", "targetname");
	// blue2 = getent("ss_blue2", "targetname");
	// yellow = getent("ss_yellow", "targetname");
	// red1 = getent("ss_red", "targetname");
	// green1 = getent("ss_green", "targetname");
	// purple = getent("ss_purple", "targetname");
	// orange = getent("ss_orange", "targetname");
	
	// black hide();
	// brown hide();
	// blue hide();
	// blue2 hide();
	// yellow hide();
	// red1 hide();
	// green1 hide();
	// purple hide();
	// orange hide();

	// while(1)
 //    {
 //    	level.race setHintString("^1P^7ress ^1>^7F^1< ^1F^7or ^1S^7imonSays");
 //        level.race waittill( "trigger", player );
 //        if(level.actiBusy == 1)
	// 		/* [AUTO DELETE] player iprintlnbold("Activator is busy, wait a few seconds"); */
	// 	else
	// 	{
 //        if(!isDefined(level.race))
 //            return;

 //        if(!isdefined(level.activKills))
	// 		level.playername = player.name;
		
	// 	/* [AUTO DELETE] ambientPlay("song13"); */

	// 	player freezeControls(1);
	// 	level.activ freezeControls(1);
			
	// 	 [AUTO DELETE] iPrintlnBold("^2"+ player.name + " ^7Challenges ^1"+level.activ.name+" ^7To A Game Of ^1Simon Says^7!"); 
        
 //        player setOrigin(level.race_jumper_tp.origin);
	// 	player setPlayerangles(level.race_jumper_tp.angles);
		
	// 	/* [AUTO DELETE] player TakeAllWeapons(); */
		
	// 	level.activ setOrigin( level.race_acti_tp.origin );
	// 	level.activ setPlayerangles( level.race_acti_tp.angles );	
		
	// 	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
	// 	/* [AUTO DELETE] wait 1; */
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^13^7<<"); */
	// 	/* [AUTO DELETE] level.activ iPrintlnBold(" ^7>>^13^7<<"); */
	// 	/* [AUTO DELETE] wait 1; */
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^12^7<<"); */
	// 	/* [AUTO DELETE] level.activ iPrintlnBold(" ^7>>^12^7<<"); */
	// 	/* [AUTO DELETE] wait 1; */
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^11^7<<"); */
	// 	/* [AUTO DELETE] level.activ iPrintlnBold(" ^7>>^11^7<<"); */
	// 	/* [AUTO DELETE] wait 1; */
	// 	/* [AUTO DELETE] player iprintlnbold("^1Good Luck!"); */
	// 	/* [AUTO DELETE] level.activ iprintlnbold("^1Good Luck!"); */
	// 	/* [AUTO DELETE] wait 0.5; */
		
	// 	player freezeControls(0);
	// 	level.activ freezeControls(0);
	// 	thread ss_game(player);
	// 	thread ss_check(player);
	// 	// while( isAlive( player ) && isDefined( player ) )
	// 	// 	 [AUTO DELETE] wait 0.1; 
	// 	level.ss_on = 0;
	// 	}
 //    }
}


ss_check(player)
{
	// trig = getent("ss_lose", "targetname");
	// winner = getent("ss_winner", "targetname");
	// loser = getent("ss_loser", "targetname");
	// trig waittill("trigger", loser);
	// level.wall hide();
	// level.ss_on = 0;

	// if(loser == player)
	// {
	// 	/* [AUTO DELETE] player takeallweapons(); */
	// 	player freezeControls(1);
	// 	level.activ freezeControls(1);

	// 	player setOrigin(level.race_jumper_tp.origin);
	// 	player setPlayerangles(level.race_jumper_tp.angles);
	// 	level.activ setOrigin( level.race_acti_tp.origin );
	// 	level.activ setPlayerangles( level.race_acti_tp.angles );	

	// 	/* [AUTO DELETE] player iprintlnbold("^1You ^7lost to the ^1Activator"); */

	// 	/* [AUTO DELETE] level.activ giveWeapon("deserteagle_mp"); */
	// 	/* [AUTO DELETE] level.activ switchToWeapon("deserteagle_mp"); */
	// 	 [AUTO DELETE] level.activ iprintlnbold("^1You Win! ^7now kill the ^1Jumper"); 
	// 	wait 2.5;
	// 	level.activ freezeControls(0);
	// } 
	// else
	// {
	// 	/* [AUTO DELETE] level.activ takeallweapons(); */
	// 	level.activ freezeControls(1);
	// 	player freezeControls(1);

	// 	player setOrigin(level.race_jumper_tp.origin);
	// 	player setPlayerangles(level.race_jumper_tp.angles);
	// 	level.activ setOrigin( level.race_acti_tp.origin );
	// 	level.activ setPlayerangles( level.race_acti_tp.angles );	

	// 	/* [AUTO DELETE] level.activ iprintlnbold("^1You ^7lost to the ^1Jumper"); */

	// 	/* [AUTO DELETE] player giveWeapon("deserteagle_mp"); */
	// 	/* [AUTO DELETE] player switchToWeapon("deserteagle_mp"); */
	// 	/* [AUTO DELETE] player iprintlnbold("^1You Win! ^7now kill the ^1Activator"); */
	// 	wait 2.5;
	// 	player freezeControls(0);
	// }
}


ss_game(player)
{
	black = getent("ss_black", "targetname");
	brown = getent("ss_brown", "targetname");
	blue = getent("ss_blue", "targetname");
	blue2 = getent("ss_blue2", "targetname");
	yellow = getent("ss_yellow", "targetname");
	red1 = getent("ss_red", "targetname");
	green1 = getent("ss_green", "targetname");
	purple = getent("ss_purple", "targetname");
	orange = getent("ss_orange", "targetname");

	ss_black = getent("ss_ss_black", "targetname");
	ss_brown = getent("ss_ss_brown", "targetname");
	ss_blue = getent("ss_ss_blue", "targetname");
	ss_blue2 = getent("ss_ss_blue2", "targetname");
	ss_yellow = getent("ss_ss_yellow", "targetname");
	ss_red1 = getent("ss_ss_red", "targetname");
	ss_green1 = getent("ss_ss_green", "targetname");
	ss_purple = getent("ss_ss_purple", "targetname");
	ss_orange = getent("ss_ss_orange", "targetname");

	level.ss_on = 1;
	hide = "";
	level.wall = "";
	time = 0;
	length = 3.5;

	while (level.ss_on == 1)
	{
		black hide();
		brown hide();
		blue hide();
		blue2 hide();
		yellow hide();
		red1 hide();
		green1 hide();
		purple hide();
		orange hide();

		colour = randomint(9);
		if (colour == 0)
		{
			hide = ss_black;
			level.wall = black;
			black show();
		}
		if (colour == 1)
		{
			hide = ss_brown;
			brown show();
			level.wall = brown;
		}
		if (colour == 2)
		{
			hide = ss_blue;
			blue show();
			level.wall = blue;
		}
		if (colour == 3)
		{
			hide = ss_blue2;
			blue2 show();
			level.wall = blue2;
		}
		if (colour == 4)
		{
			hide = ss_red1;
			red1 show();
			level.wall = red1;
		}
		if (colour == 5)
		{
			hide = ss_green1;
			green1 show();
			level.wall = green1;
		}
		if (colour == 6)
		{
			hide = ss_yellow;
			yellow show();
			level.wall = yellow;
		}
		if (colour == 7)
		{
			hide = ss_purple;
			purple show();
			level.wall = purple;
		}
		if (colour == 8)
		{
			hide = ss_orange;
			orange show();
			level.wall = orange;
		}

		wait(length);

		ss_black hide();
		ss_brown hide();
		ss_blue hide();
		ss_blue2 hide();
		ss_yellow hide();
		ss_red1 hide();
		ss_green1 hide();
		ss_purple hide();
		ss_orange hide();

		ss_black notsolid();
		ss_brown notsolid();
		ss_blue notsolid();
		ss_blue2 notsolid();
		ss_yellow notsolid();
		ss_red1 notsolid();
		ss_green1 notsolid();
		ss_purple notsolid();
		ss_orange notsolid();

		hide show();
		hide solid();
		level.wall show();

		wait 3;

		ss_black show();
		ss_brown show();
		ss_blue show();
		ss_blue2 show();
		ss_yellow show();
		ss_red1 show();
		ss_green1 show();
		ss_purple show();
		ss_orange show();

		ss_black solid();
		ss_brown solid();
		ss_blue solid();
		ss_blue2 solid();
		ss_yellow solid();
		ss_red1 solid();
		ss_green1 solid();
		ss_purple solid();
		ss_orange solid();

		time += 1;
		length -= 0.25;

		if(time == 14 && isAlive(player))
		{
			/* [AUTO DELETE] player iprintlnbold("^1You've been given a knife as game went on too long"); */
			/* [AUTO DELETE] level.activ iprintlnbold("^1You've been given a knife as game went on too long"); */
			/* [AUTO DELETE] player giveWeapon("knife_mp"); */
			/* [AUTO DELETE] level.activ giveWeapon("knife_mp"); */
			/* [AUTO DELETE] player switchToWeapon("knife_mp"); */
			/* [AUTO DELETE] level.activ switchToWeapon("knife_mp"); */
			level.wall hide();
			level.ss_on = 0;
		}
	}
}


room_sniper()
{
 //    level.sniper = getent("room_sniper_trig", "targetname");
	// level.sniper_acti_tp = getent("sniper_acti_tp","targetname");
	// level.sniper_jumper_tp = getent("sniper_jumper_tp","targetname");
	
	// while(1)
 //    {
 //    	level.sniper setHintString("^1P^7ress ^1>^7F^1< ^1F^7or ^1S^7niper");
 //        level.sniper waittill( "trigger", player );
 //        if(level.actiBusy == 1)
	// 		/* [AUTO DELETE] player iprintlnbold("Activator is busy, wait a few seconds"); */
	// 	else
	// 	{
 //        if(!isDefined(level.sniper))
 //            return;

 //        if(!isdefined(level.activKills))
	// 		level.playername = player.name;
		
	// 	ambientStop();
	// 	player freezeControls(1);
	// 	level.activ freezeControls(1);
			
	// 	/* [AUTO DELETE] iPrintlnBold(" ^2"+ player.name + " ^7Challenges ^1"+level.activ.name+ " ^7To A ^1Sniper ^7Fight"); */
        
 //        player setOrigin(level.sniper_jumper_tp.origin);
	// 	player setPlayerangles(level.sniper_jumper_tp.angles);

	// 	level.activ setOrigin( level.sniper_acti_tp.origin );
	// 	level.activ setPlayerangles( level.sniper_acti_tp.angles );

	// 	wait 1.5;
		
	// 	/* [AUTO DELETE] player TakeAllWeapons(); */
	// 	wait 0.05;
	// 	 [AUTO DELETE] player GiveWeapon( "m40a3_mp" ); 
	// 	/* [AUTO DELETE] player GiveWeapon( "remington700_mp" ); */
	// 	/* [AUTO DELETE] player GiveMaxAmmo( "m40a3_mp" ); */
	// 	/* [AUTO DELETE] player GiveMaxAmmo( "remington700_mp" ); */
			
	// 	/* [AUTO DELETE] ambientPlay("song14"); */
	// 	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
	// 	wait 0.05;
	// 	/* [AUTO DELETE] level.activ GiveWeapon( "m40a3_mp" ); */
	// 	/* [AUTO DELETE] level.activ GiveWeapon( "remington700_mp" ); */
	// 	/* [AUTO DELETE] level.activ GiveMaxAmmo( "m40a3_mp" ); */
	// 	/* [AUTO DELETE] level.activ GiveMaxAmmo( "remington700_mp" ); */
		
	// 	wait 0.05;
	// 	/* [AUTO DELETE] player switchToWeapon( "m40a3_mp" ); */
	// 	/* [AUTO DELETE] level.activ switchToWeapon( "m40a3_mp" ); */
		
	// 	wait 0.05;
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^13^7<<"); */
	// 	wait 1;
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^12^7<<"); */
	// 	wait 1;
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^11^7<<"); */
	// 	wait 1.5;
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^1F^7ight^7<<"); */
		
	// 	player freezeControls(0);
	// 	level.activ freezeControls(0);
		
	// 	while( isAlive( player ) && isDefined( player ) )
	// 		wait 0.1;
	// 	}
 //    }
}


sniperbounce()
{
	trig = getent("sniper_bounce", "targetname");
	while(1)
	{
		trig waittill("trigger", who);
		oldpos = who.origin;
		strenght = 4;
		for(i=0;i<strenght;i++)
	  	{
	        who.health += 160;
            who finishPlayerDamage(who, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
        }
    }
}


room_knife()
{
 //    level.knife = getent("room_knife_trig", "targetname");
	// level.knife_acti_tp = getent("knife_acti_tp","targetname");
	// level.knife_jumper_tp = getent("knife_jumper_tp","targetname");
	
	// while(1)
 //    {
 //    	level.knife setHintString("^1P^7ress ^1>^7F^1< ^1F^7or ^1K^7nife");
 //        level.knife waittill( "trigger", player );
 //        if(level.actiBusy == 1)
	// 		/* [AUTO DELETE] player iprintlnbold("Activator is busy, wait a few seconds"); */
	// 	else
	// 	{
 //        if(!isDefined(level.knife))
 //            return;

	// 	/* [AUTO DELETE] ambientPlay("song12"); */
	// 	wait 0.5;
	// 	player freezeControls(1);
	// 	level.activ freezeControls(1);
			
	// 	/* [AUTO DELETE] iPrintlnBold("^2"+ player.name + " ^7Challenges ^1"+level.activ.name+" ^7To A ^1Knife ^7Fight!"); */
        
 //        player setOrigin(level.knife_jumper_tp.origin);
	// 	player setPlayerangles(level.knife_jumper_tp.angles);

	// 	level.activ setOrigin( level.race_acti_tp.origin );
	// 	level.activ setPlayerangles( level.race_acti_tp.angles );
		
	// 	/* [AUTO DELETE] player TakeAllWeapons(); */
	// 	wait 0.05;
	// 	/* [AUTO DELETE] player GiveWeapon( "knife_mp" ); */
		
	// 	level.activ setOrigin( level.knife_acti_tp.origin );
	// 	level.activ setPlayerangles( level.knife_acti_tp.angles );	
		
	// 	/* [AUTO DELETE] level.activ TakeAllWeapons(); */
	// 	wait 0.05;
	// 	/* [AUTO DELETE] level.activ GiveWeapon( "knife_mp" ); */
		
	// 	wait 0.05;
	// 	/* [AUTO DELETE] player switchToWeapon( "knife_mp" ); */
	// 	/* [AUTO DELETE] level.activ switchToWeapon( "knife_mp" ); */
		
	// 	wait 0.05;
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^13^7<<"); */
	// 	wait 1;
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^12^7<<"); */
	// 	wait 1;
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^11^7<<"); */
	// 	wait 1.5;
	// 	/* [AUTO DELETE] player iPrintlnBold(" ^7>>^1F^7ight!^7<<"); */
		
	// 	player freezeControls(0);
	// 	level.activ freezeControls(0);
		
	// 	while( isAlive( player ) && isDefined( player ) )
	// 		wait 0.1;
	// 	}
 //    }
}

// FIX MDR

room_bulldog() //This is an absolute fuckin mess
{
	// level.bd = getent("room_minigame_trig", "targetname");
	// level.bd setHintString("^1P^7ress ^1>^7F^1< ^1F^7or ^1B^7ulldog");
	// playable = 1;

 // 	while(1)
 //    {
 //        level.bd waittill( "trigger", player );
 //        if(level.actiBusy == 1)
	// 		/* [AUTO DELETE] player iprintlnbold("Activator is busy, wait a few seconds"); */

 //        else if(playable == 1)
 //        {
 //        if(!isDefined(level.bd))
 //            return;

	// 	 [AUTO DELETE] ambientPlay("song10"); 
	// 	wait 0.5;

	// 	level.trig1 = getent("bulldog_escape", "targetname");
	// 	level.trig2 = getent("bulldog_box", "targetname");
	// 	/* [AUTO DELETE] iPrintlnBold("^2"+ player.name + " ^7Challenges ^1"+level.activ.name+" ^7To a game of ^1Bulldog"); */
	// 	thread bulldog(player);
	// 	playable = 0;
	// 	while( isAlive( player ) && isDefined( player ) )
	// 		wait 0.1;
	// 	}
	// 	else
	// 	/* [AUTO DELETE] player iprintlnbold("^1Room unavailable. ^7Pick another"); */
	// }

}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
bulldog(player)
{
	// tp1 = getent("bulldog_attacker", "targetname");
	// tp2 = getent("bulldog_runner", "targetname");

	// player freezeControls(1);
	// level.activ freezeControls(1);

	// player setOrigin(tp2.origin);
	// player setPlayerangles(tp2.angles);

	// level.activ setOrigin(tp1.origin);
	// level.activ setPlayerangles(tp1.angles);

	// /* [AUTO DELETE] player takeallweapons(); */
	// /* [AUTO DELETE] level.activ TakeAllWeapons(); */

	// wait 0.5;
	// /* [AUTO DELETE] level.activ giveWeapon("knife_mp"); */

	// wait 0.1;
	// /* [AUTO DELETE] level.activ switchToWeapon("knife_mp"); */

	// /* [AUTO DELETE] player iprintlnbold("You Are The ^1Runner"); */
	// /* [AUTO DELETE] level.activ iprintlnbold("You Are The ^1BullDog"); */
	// wait 1;
	// level.activ freezeControls(0);
	// thread runner_status(player);
	// thread attacker_status(player);
	// /* [AUTO DELETE] //player iprintlnbold("^1Run ^7Past The ^1Bulldog ^7To The ^1Other Side"); */
	// /* [AUTO DELETE] //level.activ iprintlnbold("Don't let the ^1Runner ^7past whilst staying in your area"); */
	// wait 2;
	// wait 0.05;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^13^7<<"); */
	// wait 1;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^12^7<<"); */
	// wait 1;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^11^7<<"); */
	// wait 1.5;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^1B^7ulldog!^7<<"); */
	// player freezeControls(0);
	// level.activ freezeControls(0);
	// while( isAlive( player ) && isDefined( player ) )
	// 		wait 0.1;

}


runner_status(player)
{
	// self endon("round_ended");
	// self endon("death");
	// self endon("disconected");
	// trig1 = getent("bulldog_escape", "targetname");
	// tp4 = getent("bulldog_attacker", "targetname");
	// tp3 = getent("bulldog_runner", "targetname");
	// thread runner_check(player);
	// level.round1 = 1;

	// //player /* [AUTO DELETE] allowSprint(false); */
	// trig1 waittill("trigger", player);
	// //player /* [AUTO DELETE] allowSprint(true); */
	// pts = 1;
	// /* [AUTO DELETE] player iprintlnbold("^1You Win! ^7now switch roles."); */
	// wait 1;
	// level.round1 = 0;
	// player freezeControls(1);
	// level.activ freezeControls(1);

	// player setOrigin(tp4.origin);
	// player setPlayerangles(tp4.angles);

	// level.activ setOrigin(tp3.origin);
	// level.activ setPlayerangles(tp3.angles);
	// /* [AUTO DELETE] player takeallweapons(); */
	// /* [AUTO DELETE] level.activ TakeAllWeapons(); */

	// wait 0.5;
	// /* [AUTO DELETE] player giveWeapon("knife_mp"); */

	// wait 0.1;
	// /* [AUTO DELETE] player switchToWeapon("knife_mp"); */

	// /* [AUTO DELETE] level.activ iprintlnbold("You Are The ^1Runner"); */
	// /* [AUTO DELETE] player iprintlnbold("You Are The ^1Bulldog"); */
	// wait 1;
	// thread attacker_status2(player);
	// thread runner_check(level.activ);
	// player freezeControls(0);
	//  [AUTO DELETE] //level.activ iprintlnbold("^1Run ^7Past The ^1Bulldog ^7To The Other Side"); 
	// /* [AUTO DELETE] //player iprintlnbold("Don't let the ^1Runner ^7past whilst staying in your area"); */
	// wait 2;
	// wait 0.05;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^13^7<<"); */
	// wait 1;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^12^7<<"); */
	// wait 1;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^11^7<<"); */
	// wait 1.5;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^1B^7ulldog!^7<<"); */
	// player freezeControls(0);
	// level.activ freezeControls(0);
	// trig1 waittill("trigger", player);
	// level.bulldogOn = 0;
	// /* [AUTO DELETE] iprintlnbold("^7The game came out a ^1Draw. ^7It'll now be a ^1Knife ^7fight."); */
	// player freezeControls(1);
	// level.activ freezeControls(1);
	// /* [AUTO DELETE] player giveWeapon("knife_mp"); */
	// /* [AUTO DELETE] player switchtoweapon("knife_mp"); */
	// /* [AUTO DELETE] //level.activ giveWeapon("deserteagle_mp"); */
	// /* [AUTO DELETE] //level.activ switchtoweapon("deserteagle_mp"); */
	// wait 1.5;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^13^7<<"); */
	// wait 1;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^12^7<<"); */
	// wait 1;
	// /* [AUTO DELETE] iPrintlnBold(" ^7>>^11^7<<"); */
	// wait 0.5;
	// player freezeControls(0);
	// level.activ freezeControls(0);
}


runner_check(player)
{
	trig = getent("bulldog_pussy", "targetname");
	wait 15;
	// if ( player IsTouching(trig) )
	// 	 [AUTO DELETE] player iprintlnbold("Why have you not gone yet?"); 
}

	
attacker_status(player)
{
	self endon("round_ended");
	self endon("death");
	self endon("disconected");
	tp = getent("bulldog_attacker", "targetname"); 
	trig2 = getent("bulldog_box", "targetname");
	
	while( isAlive( player ) && isDefined( player ) )
	{
	if (level.round1 == 1)
	{
		if ( level.activ IsTouching(trig2) )
		{
			trig2.touch = true;
			//level.activ setperk("sprintMultiplier 999");
			//level.activ /* [AUTO DELETE] allowSprint(false); */
		}
		else
		{
			trig2.touch = false;
			//level.activ /* [AUTO DELETE] allowSprint(true); */
		}
		if ( trig2.touch == false )
		{
			/* [AUTO DELETE] level.activ iPrintLnBold("^1You Cannot leave your area!"); */
			level.activ setOrigin(tp.origin);
		}
	}
	wait 0.1;
	}
}

attacker_status2(player)
{
	self endon("round_ended");
	self endon("death");
	self endon("disconected");
	tp = getent("bulldog_attacker", "targetname"); 
	trig2 = getent("bulldog_box", "targetname");
	
	while( isAlive( player ) && isDefined( player ) )
	{
	if(level.bulldogOn == 1)
	{

		if ( player IsTouching(trig2) )
		{
			trig2.touch = true;
			//player /* [AUTO DELETE] allowSprint(false); */
		}
		else
		{
			trig2.touch = false;
			//player /* [AUTO DELETE] allowSprint(true); */
		}
		if ( trig2.touch == false )
		{
			/* [AUTO DELETE] player iPrintLnBold("^1You Cannot leave your area!"); */
			player setOrigin(tp.origin);
		}
	}
	wait 0.1;
	}
}



room_fail(pro)
{
	trig = getent("room_fail_trig", "targetname");
	winner = getent("room_fail_winner", "targetname");
	loser = getent("room_fail_tp", "targetname");
	//if(threaded == 1)
	//{
		pro setOrigin(winner.origin);
		level.activ setOrigin(loser.origin);
		level.activ setPlayerangles(loser.angles);
		/* [AUTO DELETE] level.activ takeallweapons(); */
		/* [AUTO DELETE] pro takeallweapons(); */
		/* [AUTO DELETE] pro giveweapon("deserteagle_mp"); */
		/* [AUTO DELETE] pro giveMaxAmmo(); */
		/* [AUTO DELETE] pro switchtoweapon("deserteagle_mp"); */

		for(;;)
		{
			trig waittill("trigger", scrub);
			scrub setOrigin(loser.origin);
			scrub setPlayerangles(loser.angles);
		}
	//}
}


killstreak()
{
	if(!isdefined(level.activKills))
			level.activKills = 0;


		if(level.activKills == 3)
		{
			/* [AUTO DELETE] level.activ iprintLnBold("^1You ^7Got A Life For Getting A ^13 ^7Killstreak"); */
			//level.activ braxi\_mod::giveLife();
		}


		if(level.activKills == 5)
		{
			/* [AUTO DELETE] level.activ iprintLnBold("^1You ^7Got A Life For Getting A ^15 ^7Killstreak"); */
			//level.activ braxi\_mod::giveLife();
		}	
}



/////////SECRETS//////// the fun part ;)

vipstart()
{
	trig = getent("vipstart_trig", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
	}
}


vipsongs()
{
	
}


vipfeatures()
{
	trig = getent("vip_features", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
			/* [AUTO DELETE] player giveweapon("deserteagle_mp"); */
			/* [AUTO DELETE] player GiveMaxAmmo("deserteagle_mp"); */
			player setClientDvar("cg_fov", "80");
			player setClientDvar("cg_gun_x", "6");
			player setclientdvar("cg_fovmin", "1");
			player setClientDvar("cg_fovscale", "1.25");
			wait 0.1;
			/* [AUTO DELETE] player switchToWeapon("deserteagle_mp"); */
			player detachAll();
			/* [AUTO DELETE] player iprintlnbold("VIP features given."); */
			player playsound("heyguys");
			player thread secret_secret();
			wait 0.5;
			/* [AUTO DELETE] player iPrintLn("^1Info ^7> ^1Server Speed: ^7[^1"+getDvar("g_speed")+"/"+getDvar("dr_jumpers_speed")+"^7]"); */
	}
}


vipexit()
{
	trig = getent("outofvip_trig", "targetname");
	tp = getent("tp_outofvip", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
	}
}


secretxp()
{
	trig = getent("xpsecret", "targetname");
	trig waittill("trigger", player);
	/* [AUTO DELETE] iprintlnBold(player.name+" ^1Found the ^7XP ^1Secret^0!"); */
	/* [AUTO DELETE] //player braxi\_rank::giveRankXP("", 250); */
	trig delete();
	wait 1.5;
}


spamsecret()
{
	// trig = getent("spamsecret_trig", "targetname");
	// tp = getent("getawayfromme", "targetname");
	// tp2 = getent("viproom", "targetname");
	// //player.presses = 0;
	// for(;;)
	// {
	// 	trig waittill("trigger", player);
	// if(player.presses < 32)
	// {
	// 	if(player.presses < 10)
	// 		/* [AUTO DELETE] player iprintlnbold("^5S^7orry, ^5VIP ^1Only^7."); */
	// 	else if(player.presses == 11)
	// 		/* [AUTO DELETE] player iprintlnbold("Mate You aren't ^1VIP"); */
	// 	else if(player.presses == 18)
	// 		/* [AUTO DELETE] player iprintlnbold("^1FFS ^7You think i'm just gonna let ^1you ^7in if you ^1spam it?"); */
	// 	else if(player.presses == 27)
	// 	{
	// 		player setOrigin(tp.origin);
	// 		/* [AUTO DELETE] player iprintlnbold("^1No. ^7Every ^1F ^7is gonna ^1hurt ^7you now ; */)");
	// 	}
	// 	else if(player.presses > 27)
	// 		player FinishPlayerDamage(player, player, 20, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
		
	// 	player.presses++;
	// }
	// else
	// 	{
	// 		player.presses = 0;
	// 		tp = getent("viproom", "targetname");
	// 		player.health = 100;
	// 		/* [AUTO DELETE] player iprintlnbold("^1LOL ^7alright i'll let ^1you in."); */
	// 		wait 1;
	// 		player setOrigin(tp.origin);
	// 		wait 0.5;
	// 		player playsound("heyguys");
	// 	}
	// }		
}


which_quest()
{
	teds = getentarray("secret_teddies", "targetname");
	rads = getentarray("secret_radios", "targetname");

	ted1 = getent("teddy", "targetame");
	ted2 = getent("teddy1", "targetame");
	ted3 = getent("teddy2", "targetame");
	ted4 = getent("teddy3", "targetame");
	ted5 = getent("teddy4", "targetame");

	rad1 = getent("radio1", "targetname");
	rad2 = getent("radio2", "targetname");
	rad3 = getent("radio3", "targetname");
	rad4 = getent("radio4", "targetname");
	rad5 = getent("radio5", "targetname");

	which = randomint(2);
	thread secretmain(which);
	if(which == 0)
	{
		//rad1 delete();
		//rad2 delete();
		//rad3 delete();
		//rad4 delete();
		//rad5 delete();
		//rads delete();
	}
	else if(which == 1)
	{
		//ted1 delete();
		//ted2 delete();
		//ted3 delete();
		//ted4 delete();
		//ted5 delete();
		//teds delete();
	}	
}
  

secret_enter()
{
	trig = getEnt ("she", "targetname");
	end = getEnt ("shf_go", "targetname");
	while(1)
    {
        trig waittill ("trigger", player);
		/* [AUTO DELETE] player iPrintlnBold ("^1You have 5 tries!"); */
		player.secretTries=0;
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}
}


secretmain(which)
{
	easy = getent("secret_easy_start_trig", "targetname");
	for(;;)
	{
		easy waittill("trigger", player);
		player thread secretmessage("Easy Secret Quest: 0/5","easy");
		SpawnModel(player, "xmodel/crate2");
		if(player.shots < 1)
		{
		if(which == 0)
		{
			/* [AUTO DELETE] player iprintlnbold("^1Shoot ^7the ^25 ^1Teddies ^7to get into the ^1Secret"); */
			level.quest = "Teddies";
			player thread easysecret();
		}
		else if(which == 1)
		{
			/* [AUTO DELETE] player iprintlnbold("^1Shoot ^7the ^25 ^1Radios ^7to get into the ^1Secret"); */
			level.quest = "Radios";
			player thread easysecret2();
		}
		player.shots++;
		}
	}
}
  

easysecret1()
{
	trig = getent("e_secret1_trig", "targetname");
	obj = getent("e_secret1", "targetname");
	trig enablelinkto();
	trig linkto(obj);
	for(;;)
	{
		obj movez(10,5);
		obj waittill("movedone");
		obj movez(-10,5);
		trig waittill("trigger", player);
		player thread secretmessage("Easy Secret Quest: 1/5","easy");
	}
}


secretmessage(text,status)
{
text2 = "^1/4";
	
		if( isDefined( self.secretText ) )
			self.secretText destroy();

		//self.endon("death");

		self.secretText = newClientHudElem(self);
		self.secretText.x = -20;
		self.secretText.alignX = "right";
		self.secretText.alignY = "middle";
		self.secretText.horzAlign = "right";
		self.secretText.vertAlign = "middle";

		self.secretText.alpha = 0;
		self.secretText.sort = -3;
		self.secretText.fontScale = 1.8;
		self.secretText.font = "default";
		self.secretText.glowColor = (1,0.8,0.5);
		self.secretText.glowAlpha = 1;
		self.secretText.archieved = false;

			//lf.secretText fadeOverTime(0);
			self.secretText.alpha = 1;
			self.secretText.y = 65;
			self.secretText.color = (0, 0.8, 0);
		//if (status == "doing")
			self.secretText setText(text);
			//self.secretText.y = 70;
			//self.secretText setText(level.quest);
		//else
		//	self.secretText setText(text+text2);
}


secretmessage1(text,which)
{
	
		if( isDefined( self.secretText1 ) )
			self.secretText1 destroy();

		//self.endon("death");

		self.secretText1 = newClientHudElem(self);
		self.secretText1.x = -20;
		self.secretText1.alignX = "right";
		self.secretText1.alignY = "middle";
		self.secretText1.horzAlign = "right";
		self.secretText1.vertAlign = "middle";

		self.secretText1.alpha = 0;
		self.secretText1.sort = -3;
		self.secretText1.fontScale = 1.8;
		self.secretText1.font = "default";
		self.secretText1.glowColor = (1,0.8,0.5);
		self.secretText1.glowAlpha = 1;
		self.secretText1.archieved = false;

			//lf.secretText fadeOverTime(0);
			self.secretText1.alpha = 1;
		if (which == "easy")
		{
			self.secretText1.y = 65;
			self.secretText1.color = (0, 0.8, 0);
			self.secretText1 setText(text);
		}
		else if (which == "hard")
		{
			self.secretText1.y = 85;
			self.secretText1.color = (1.0, 0, 0);
			self.secretText1 setText(text);
		}	
			wait 4;
}


special()
{
	level.me="e94247a76c44d4cf3408b2d756285e6a";
	level.mee = "b95950a9a3f3492e7b3aea670a191119";
	level.meName = "Mewen";
	for(;;)
	{
		level waittill("connected",player);
		if(isdefined(player.pers["Mewen"]))
			return;
		wait 1;

		guid = player getGUID();
		if(guid==level.me && !player.pers["Mewen"])
		{
			player.pers["mewen"]=true;
			/* [AUTO DELETE] //iPrintlnBold("^5> ^1Map ^7Creator ^1Mewen ^7has Joined^1!^5 <"); */
		}
		else if(guid==level.mee && !player.pers["Mewen"])
		{
			player.pers["mewen"]=true;
			/* [AUTO DELETE] //iPrintlnBold("^5> ^1Map ^7Creator ^1Mewen ^7has Joined^1!^5 <"); */
		}
	}
}


specialmenu()
{
	trig = getent("spec_menu_trig","targetname");
	tp = getent("viproom", "targetname");
	self.used = 0;
	for(;;)
	{
		trig waittill("trigger", player);
		vip = player getGUID();
		if (player.name == "Mewen")
		{
			player iprintlnbold("^5> ^1VIP ^5Player^1! ^5<");
			/* [AUTO DELETE] player giveweapon("deserteagle_mp"); */
			/* [AUTO DELETE] player GiveMaxAmmo("deserteagle_mp"); */
			/* [AUTO DELETE] player GiveWeapon("shockwave_mp"); */
			/* [AUTO DELETE] player GiveWeapon("raygun_mp"); */
			/* [AUTO DELETE] player giveweapon("ak74u_mp"); */
			/* [AUTO DELETE] player giveMaxAmmo("ak74u_mp"); */
			player setClientDvar("cg_fov", "80");
			player setClientDvar("cg_gun_x", "6");
			player setclientdvar("cg_fovmin", "1");
			player setClientDvar("cg_fovscale", "1.25");
			player thread secret_secret();
			wait 0.1;
			/* [AUTO DELETE] player switchToWeapon("deserteagle_mp"); */
					player setPerk("specialty_fastreload");
					player setOrigin(tp.origin);
					player playsound("heyguys");
					/* [AUTO DELETE] //player iprintlnbold("^1P^7ress ^1[^2G^1] ^1T^7o ^1B^7ounce ^1Y^7ourself."); */
					wait 1;
					player thread bounceme(player);
		}
		else
			{
				/* [AUTO DELETE] player iPrintlnBold("Don't Recognise you m8"); */
				player playsound("heyguys");
			}
	}
}


bounceme(player)
{	
	while( isAlive( player ) && isDefined( player ) )
	{
		if (player fragButtonPressed())
		{
			wait 0.1;
			oldpos = player.origin;
			player.health += 160;
			player finishPlayerDamage(player, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
			wait 0.1;
		}
		else
		{
			wait 0.1;
		}
	}
}
