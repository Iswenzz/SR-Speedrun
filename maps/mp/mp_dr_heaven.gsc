///////////////////////////////////////////////////////////////////////////
//  ______  __              __                      ___                 //
// /\__  _\/\ \            /\ \       __          /'___\               //
// \/_/\ \/\ \ \___      __\ \ \     /\_\   __  _/\ \__/   __         //
//    \ \ \ \ \  _ `\  /'__`\ \ \  __\/\ \ /\ \/'\ \ ,__\/'__`\      //
//     \ \ \ \ \ \ \ \/\  __/\ \ \L\ \\ \ \\/>  </\ \ \_/\  __/     //
//      \ \_\ \ \_\ \_\ \____\\ \____/ \ \_\/\_/\_\\ \_\\ \____\   //
//       \/_/  \/_/\/_/\/____/ \/___/   \/_/\//\/_/ \/_/ \/____/  //
//                                                               //
//////////////////////////////////////////////////////////////////                                                        

main()
{
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_secret_way("Secret Way;");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread speedrun\_way_name::create_spawn_auto(auto_spawn[int(auto_spawn.size / 2)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]);
	maps\mp\_load::main();	

	end = getEnt ("secret_enter_go", "targetname");
	thread speedrun\_way_name::create_tp((60, -649, 76), 100, 150, 
		end.origin, end.angles[1], "freeze", "blue", "s0");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_bounce2");
	addTriggerToList("trig_trap10");
	addTriggerToList("trig_trap11");

	// if(!isdefined(level. [AUTO DELETE] music))
	// level.music=[]; 
	/* [AUTO DELETE] level.music[0]["song"]    ="Kiiara - Gold"; */
	/* [AUTO DELETE] level.music[0]["alias"]    ="kiiaragold"; */
	/* [AUTO DELETE] level.music[1]["song"]    ="Lenno - Good thing (Re-Edit)"; */
	/* [AUTO DELETE] level.music[1]["alias"]    ="lennogood"; */
	/* [AUTO DELETE] level.music[2]["song"]    ="Hoodie Allen & Ed Sheeran - All about it"; */
	/* [AUTO DELETE] level.music[2]["alias"]    ="edall"; */
	/* [AUTO DELETE] level.music[3]["song"]    ="G-Eazy - I mean it"; */
	/* [AUTO DELETE] level.music[3]["alias"]    ="imeanit"; */
	/* [AUTO DELETE] level.music[4]["song"]    ="Madden & 6AM - Golden light"; */
	/* [AUTO DELETE] level.music[4]["alias"]    ="madden"; */
	/* [AUTO DELETE] level.music[5]["song"]    ="JVG - Hehkuu ^5(gr8 finnish song I r8 8/8)"; */
	/* [AUTO DELETE] level.music[5]["alias"]    ="hehkuu"; */
	/* [AUTO DELETE] thread musicBox(); */
	
	// thread  [AUTO DELETE] trap_bounce2(); 
	// thread map_mover();
	// thread map_mover2();
	thread start_door();
	thread acti_tele1();
	thread acti_tele1back();
	thread acti_mover1();
	// thread /* [AUTO DELETE] acti_secret(); */
	thread secret_end();
	// thread /* [AUTO DELETE] dbl_secret_end(); */
	// thread rooms();
	// thread creators();
	thread s_shoot1();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6_1();
	thread trap7();
	thread trap8();
	thread trap10();
	thread trap11();
	/* [AUTO DELETE] thread secretwep(); */
	/* [AUTO DELETE] thread sniper_logo(); */
	/* [AUTO DELETE] thread knife_logo(); */
	// thread rpg_logo();
	/* [AUTO DELETE] thread bounce_logo(); */
	/* [AUTO DELETE] thread secret_enter(); */
	thread act0();
	thread act1();
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

musicBox()
{
    trig=getent("vcmusic","targetname");
    trig sethintstring("Press ^1&&1^7 to select Music");
    trig waittill("trigger",p);
    trig delete();
    
    p freezecontrols(1);
    p musicMenu();
}

musicMenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );
 
    self.hud_music = [];
    self.selection = 0;
 
    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(1,0,0);
    
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Heaven's musicbox");
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else 
        self.hud_music[i].glowcolor=(1,0,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;
    self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");
 
    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else 
            self.hud_music[i].glowcolor=(1,0,0);
 
        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }
 
    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(1,0,0);
 
    while(self.sessionstate == "playing")
    {
        wait 0.1;
 
        if(self attackButtonPressed())
        {
            self.hud_music[4+self.selection].alpha = 0.93;
 
            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;
 
            item = self.hud_music[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
             /* [AUTO DELETE] iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]); */
            /* [AUTO DELETE] ambientPlay(level.music[self.selection]["alias"]); */
            self freezecontrols(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezecontrols(0);
            break;
        }
    }
    
    if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}

trap_bounce2()
{
	level endon("trigger");
	trigger = getEnt ("trig_bounce2","targetname");
	clip = getEnt ("clip_bounce2","targetname");
	object1 = getEnt ("bounce2_1","targetname");
	ladder = getEnt ("ladder_bounce2","targetname");
	object2 = getEnt ("bounce2_2","targetname");
	clip notSolid();
	clip hide();
	object2 notSolid();
	object2 hide();
	trigger waittill ("trigger", player);
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	ladder delete();
	object1 rotateroll (-72, 1);
	object1 waittill ("rotatedone");
	object2 Solid();
	object2 show();
	object1 delete();
	clip Solid();
	clip show();
	clip enablelinkto ();
	clip linkto (object2);
	object2 movez(380,3);
	object2 waittill ("movedone");
	object2 movey(-413,2,1,0.5);
	object2 waittill ("movedone");
	wait 2;

	while(1)
	{
		object2 movey(654,4,3,0.5);
		object2 waittill ("movedone");
		wait 2;
		object2 movey(-654,4,3,0.5);
		object2 waittill ("movedone");
		wait 2;
	}
}

map_mover()
{
	object = getEnt ("map_mover","targetname");
	wait 1;
	object movey(-136,1,0.25);
	object waittill ("movedone");
	while (1)
	{
		object movey(272,2,0.5);
		object waittill ("movedone");
		object movey(-272,2,0.5);
		object waittill ("movedone");
	}
}

map_mover2()
{
	object = getEnt ("map_mover2","targetname");
	wait 1;
	while (1)
	{
		object movez(128,2,0.5);
		object waittill ("movedone");
		object movez(-128,2,0.5);
		object waittill ("movedone");
	}
}

start_door()
{
	object = getent("start_door","targetname");
	// wait 15;
	object rotateroll(100,4,0.5,1);
}

acti_tele1()
{
	trig = getEnt ("acti_tele1", "targetname");
	end = getEnt ("acti_tele1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}


acti_tele1back()
{
	trig = getEnt ("acti_tele1back", "targetname");
	end = getEnt ("acti_tele1back_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

acti_mover1()
{
	object = getEnt ("acti_mover1","targetname");
	wait 1;
	while (1)
	{
		object movez(248,2,0.5);
		object waittill ("movedone");
		object movez(-248,2,0.5);
		object waittill ("movedone");
	}
}

acti_secret()
{
	trig = getEnt ("acti_secret_enter", "targetname");
	end = getEnt ("acti_secret_enter_go", "targetname");
	object = getEnt ("acti_secret_clip","targetname");
	object notSolid();
        trig waittill ("trigger", player);
	/* [AUTO DELETE] player iprintlnbold ("You Entered the ^3secret^7!"); */
	thread acti_secret_fail();
	thread acti_dbl_secret();
	thread acti_dbl_secret_fail();
	thread acti_secret_end();
	thread acti_dbl_secret_end();
	/* [AUTO DELETE] player giveweapon("deserteagle_mp"); */
	/* [AUTO DELETE] player givemaxammo("deserteagle_mp"); */
	/* [AUTO DELETE] player switchtoweapon("deserteagle_mp"); */
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	wait 1;
	object Solid();

}

acti_secret_fail()
{
	trig = getEnt ("acti_secret_fail", "targetname");
	end = getEnt ("acti_secret_fail_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player); 
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

acti_dbl_secret()
{
	trig = getEnt ("acti_dbl_secret_enter", "targetname");
	end = getEnt ("acti_dbl_secret_enter_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	/* [AUTO DELETE] player iprintlnbold ("^6Wut ^5is ^2this^3?"); */ 
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

acti_dbl_secret_fail()
{
	trig = getEnt ("acti_dbl_secret_fail", "targetname");
	end = getEnt ("acti_dbl_secret_fail_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player); 
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

acti_secret_end()
{
	trig = getEnt ("acti_secret_end", "targetname");
	end = getEnt ("acti_secret_end_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player); 
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	/* [AUTO DELETE] iPrintlnBold (" ^1Activator ^7 Finished the secret!"); */
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 500); */
	}

}

acti_dbl_secret_end()
{
	trig = getEnt ("acti_dbl_secret_end", "targetname");
	end = getEnt ("acti_secret_end_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player); 
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	/* [AUTO DELETE] iPrintlnBold (" ^1Activator ^7 Finished the secret inside of the secret!"); */
	player braxi\_rank::giveRankXP("", 1000); //change amount of xp if you really think that is too high, Finishing the double secret is not easy.
	}

}

secret_enter()
{
	trig = getEnt ("secret_enter", "targetname");
	end = getEnt ("secret_enter_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	/* [AUTO DELETE] player iprintlnbold ("You Entered the ^3secret^7!"); */
	player thread jump_secrettimer();
	thread secret_fail();
	thread dbl_secret_enter();
	thread dbl_secret_fail();
	/* [AUTO DELETE] player giveweapon("deserteagle_mp"); */
	/* [AUTO DELETE] player givemaxammo("deserteagle_mp"); */
	/* [AUTO DELETE] player switchtoweapon("deserteagle_mp"); */
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

secret_fail()
{
	trig = getEnt ("secret_fail", "targetname");
	end = getEnt ("secret_fail_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player); 
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

dbl_secret_enter()
{
	trig = getEnt ("dbl_secret_enter", "targetname");
	end = getEnt ("dbl_secret_enter_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	/* [AUTO DELETE] player iprintlnbold ("^6Wut ^5is ^2this^3?"); */  
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

dbl_secret_fail()
{
	trig = getEnt ("dbl_secret_fail", "targetname");
	end = getEnt ("dbl_secret_fail_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player); 
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

secret_end()
{
	trig = getEnt ("secret_end", "targetname");
	end = getEnt ("secret_end_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	// player notify("secret_done");
	// player.secretTimer destroy(); 
	// player SetOrigin(end.origin);
 //        player SetPlayerAngles( end.angles );
        player thread speedrun\_way_name::finish_way("s0");
	/* [AUTO DELETE] iPrintlnBold (" ^5" + player.name + " ^7 Finished the secret"); */
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 500); */
	}

}

dbl_secret_end()
{
	trig = getEnt ("dbl_secret_end", "targetname");
	end = getEnt ("dbl_secret_end_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	player notify("secret_done");
	player.secretTimer destroy(); 
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	/* [AUTO DELETE] iPrintlnBold (" ^5" + player.name + " ^7 Finished the secret inside of the secret!"); */
	player braxi\_rank::giveRankXP("", 1000); //change amount of xp if you really think that is too high, Finishing the double secret is not easy.
	}

}

jump_secrettimer()
{
    self endon("secret_done");
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    self.secretTimer=newclienthudelem(self);
    self.secretTimer.foreground = true;
    self.secretTimer.alignX = "center";
    self.secretTimer.alignY = "bottom";
    self.secretTimer.horzAlign = "center";
    self.secretTimer.vertAlign = "bottom";
    self.secretTimer.x = 0;
    self.secretTimer.y = -7;
    self.secretTimer.sort = 5;
    self.secretTimer.fontScale = 1.6;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = true;
       self.secretTimer.label = &"Time in left: &&1";
        
    if(isdefined(level.randomcolor))
        self.secretTimer.glowColor=level.randomcolor;
    else 
        self.secretTimer.glowColor=(1,0,0);
    time=120;
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
}


creators()
{
	wait 9;
	/* [AUTO DELETE] iPrintlnBold("^7Map by ^5TheLixfe"); */
	wait 2;
	/* [AUTO DELETE] iprintln("^7Thanks to ^5Vistic Clan"); */
	wait 15;
	/* [AUTO DELETE] iprintln("^6steam: TheLixfe"); */
	wait 5;
	/* [AUTO DELETE] iprintln("^7Map by ^5TheLixfe"); */
}

s_shoot1()
{
	trigger = getEnt ("s_shoot1","targetname");
	// trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	/* [AUTO DELETE] iprintln( "AH" ); */
	thread s_shoot2();
}

s_shoot2()
{
	trigger = getEnt ("s_shoot2","targetname");
	object = getEnt ("s_wall","targetname");
	// trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	/* [AUTO DELETE] iprintln( "UH" ); */
	object notSolid();
	thread t_deck1();
	thread t_deck2();
	thread t_deck3();
}

trap1()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap1","targetname");
	trigger waittill ("trigger", player);
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	thread trap1_1();
	thread trap1_2();
	thread trap1_3();
	thread trap1_4();
	thread trap1_5();
	thread trap1_6();
	thread trap1_7();
	thread trap1_8();
	thread trap1_9();
	thread trap1_10();
	thread trap1_11();
}

trap1_1()
{
	level endon("trigger");
	object = getEnt ("trap1_1","targetname");
	while(1)
	{
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_2()
{
	level endon("trigger");
	object = getEnt ("trap1_2","targetname");
	while(1)
	{
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_3()
{
	level endon("trigger");
	object = getEnt ("trap1_3","targetname");
	while(1)
	{
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_4()
{
	level endon("trigger");
	object = getEnt ("trap1_4","targetname");
	while(1)
	{
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_5()
{
	level endon("trigger");
	object = getEnt ("trap1_5","targetname");
	while(1)
	{
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_6()
{
	level endon("trigger");
	object = getEnt ("trap1_6","targetname");
	while(1)
	{
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_7()
{
	level endon("trigger");
	object = getEnt ("trap1_7","targetname");
	while(1)
	{
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_8()
{
	level endon("trigger");
	object = getEnt ("trap1_8","targetname");
	while(1)
	{
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_9()
{
	level endon("trigger");
	object = getEnt ("trap1_9","targetname");
	while(1)
	{
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_10()
{
	level endon("trigger");
	object = getEnt ("trap1_10","targetname");
	while(1)
	{
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}

trap1_11()
{
	level endon("trigger");
	object = getEnt ("trap1_11","targetname");
	while(1)
	{
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
		object rotateyaw(-90,1,0.5,0.5);
		object waittill ("rotatedone");
		wait 2;
	}
}
				
trap2()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap2","targetname");
	object = getEnt ("trap2","targetname");
	kill = getEnt ("kill_trap2","targetname");
	kill maps\mp\_utility::triggeroff();
	trigger waittill ("trigger", player );
	kill maps\mp\_utility::triggeron();
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	object movez(120,0.2);
	object waittill ("movedone");
	wait 2;
	kill maps\mp\_utility::triggeroff();
	object movez(-120,5);
}

trap3()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap3","targetname");
	object = getEnt ("trap3","targetname");
	trigger waittill ("trigger", player );
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	object movex(480,1);
	object waittill ("movedone");
	while(1)
	{
		object rotateyaw(-90,1.5);
		object waittill ("rotatedone");
		wait 1.5;
		object rotateyaw(90,1.5);
		object waittill ("rotatedone");
		wait 1.5;
	}
}

trap4()
{
	level endon("trigger");
	
	trigger = getEnt ("trig_trap4","targetname");
	object1 = getEnt ("trap4_1","targetname");
	object2 = getEnt ("trap4_2","targetname");
	object3 = getEnt ("trap4_3","targetname");
	object4 = getEnt ("trap4_4","targetname");
	trigger waittill ("trigger", player );
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	trigger SetHintString("^5Activated");
	object1 rotateroll (-360, 2);
	object2 rotateroll (-360, 2);
	object3 rotatepitch (-360, 2);
	object4 rotatepitch (-360, 2);
	object4 waittill ("rotatedone");
	while(1)
	{
		object1 rotateroll (-360, 1);
		object1 waittill ("rotatedone");
		object2 rotateroll (-360, 1);
		object2 waittill ("rotatedone");
		object3 rotatepitch (-360, 1);
		object3 waittill ("rotatedone");
		object4 rotatepitch (-360, 1);
		object4 waittill ("rotatedone");
	}
}

trap5()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap5","targetname");
	object = getEnt ("trap5","targetname");
	pilars = getEnt ("trap5_pilars","targetname");
	trigger waittill ("trigger", player );
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	pilars movez(144,0.5);
	while(1)
	{
		object rotatepitch (-720,4);
		object waittill ("rotatedone");
		wait 4;
		object rotatepitch (-720,4);
		object waittill ("rotatedone");
		wait 4;
	}
}

trap6_1()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap6","targetname");
	object1 = getEnt ("trap6_1","targetname");
	trigger waittill ("trigger", player );
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	thread trap6_2();
	object1 movez(108,0.5);
	object1 waittill ("movedone");
	while(1)
	{
		object1 movez(-216,1);
		object1 waittill ("movedone");
		object1 movez(216,1);
		object1 waittill ("movedone");
	}
}

trap6_2()
{
	level endon("trigger");
	object2 = getEnt ("trap6_2","targetname");
	object2 movez(-108,0.5);
	object2 waittill ("movedone");
	while(1)
	{
		object2 movez(216,1);
		object2 waittill ("movedone");
		object2 movez(-216,1);
		object2 waittill ("movedone");
	}
}

trap7()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap7","targetname");
	object = getEnt ("trap7","targetname");
	trigger waittill ("trigger",player);
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	object delete();
}

trap8()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap8","targetname");
	object1 = getEnt ("trap8_1","targetname");
	object2 = getEnt ("trap8_2","targetname");
	object3 = getEnt ("trap8_3","targetname");
	object4 = getEnt ("trap8_4","targetname");
	clip1 = getEnt ("trap8_c1","targetname");
	clip2 = getEnt ("trap8_c2","targetname");
	clip3 = getEnt ("trap8_c3","targetname");
	clip4 = getEnt ("trap8_c4","targetname");
	clip1 notSolid();
	clip2 notSolid();
	clip3 notSolid();
	clip4 notSolid();
	trigger waittill ("trigger",player);
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */

	i = randomintrange( 0, 6 );
	if(i == 0)
	{
		object1 notSolid();
		object3 notSolid();
	}
	else if(i == 1)
	{
		object2 notSolid();
		object4 notSolid();
	}
	else if(i == 2)
	{
		object1 notSolid();
		object4 notSolid();
	}
	else if(i == 3)
	{
		object2 notSolid();
		object3 notSolid();
	}
	else if(i == 4)
	{
		object1 delete();
		object2 delete();
		clip1 Solid();
	}
	else if(i == 5)
	{
		object1 delete();
		object2 delete();
		clip2 Solid();
	}
	else if(i == 6)
	{
		object3 delete();
		object4 delete();
		clip4 Solid();
	}
	else if(i == 7)
	{
		object3 delete();
		object4 delete();
		clip3 Solid();
	}
	else if(i == 8)
	{
		object1 notSolid();
		object2 delete();
		clip2 Solid();
		object3 notSolid();
	}
	else if(i == 9)
	{
		object1 notSolid();
		object2 delete();
		clip2 Solid();
		object4 notSolid();
	}
	else if(i == 10)
	{
		object1 notSolid();
		object2 delete();
		clip2 Solid();
		object4 delete();
		clip4 Solid();
	}
	else if(i == 11)
	{
		object2 notSolid();
		object1 delete();
		clip1 Solid();
		object3 notSolid();
	}
	else if(i == 12)
	{
		object2 notSolid();
		object1 delete();
		clip1 Solid();
		object4 notSolid();
	}
	else if(i == 13)
	{
		object1 notSolid();
		object2 notSolid();
		object3 notSolid();
		object4 notSolid();
		clip1 Solid();
		clip2 Solid();
		clip3 Solid();
		clip4 Solid();
	}
	else if(i == 14)
	{
		object3 delete();
		object4 delete();
		object2 notSolid();
		clip3 Solid();
	}
	else if(i == 15)
	{
		object3 delete();
		object4 delete();
		object1 notSolid();
		clip4 Solid();
	}
	else if(i == 16)
	{
		object3 delete();
		object4 notSolid();
		object1 notSolid();
		object2 delete();
		clip3 Solid();
		clip2 Solid();
	}
	else if(i == 17)
	{
		object1 delete();
		object2 delete();
		clip1 Solid();
		clip2 Solid();
		object3 notSolid();
	}
}

trap10()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap10","targetname");
	object = getEnt ("trap10","targetname");
	trigger waittill ("trigger",player);
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	while(1)
	{
		object movez(-160,2.5);
		object waittill ("movedone");
		wait 1;
		object movez(688,1,0.9,0.1);
		object waittill ("movedone");
		object movez(-528,2,1.9,0.1);
		object waittill ("movedone");
		wait 5;
	}
}

trap11()
{
	level endon("trigger");
	trigger = getEnt ("trig_trap11","targetname");
	object = getEnt ("trap11","targetname");
	trigger waittill ("trigger",player);
	trigger SetHintString("^5Activated");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 20); */
	object movez (-450,1);
	object waittill ("movedone");
	wait 1;
	object movez(450,6);
	thread trap11_2();
}

trap11_2()
{
	level endon("trigger");
	object = getEnt ("trap11","targetname");
	wait 2;
	while(1)
	{
		object rotateyaw(720,6);
		object waittill ("rotatedone");
		object rotateyaw(720,6);
		object waittill ("rotatedone");
	}
}



rooms()
{
	thread jump_room();
	thread rpg_room();
	thread knife_room();
	thread sniper_room();
}


jump_room()
{
	level.jump=getent("jumproom_ent","targetname");
	jump=getent("jumproom_go","targetname");
	acti=getent("jumproom_acti","targetname");

	while(1)
	{
		level.jump waittill("trigger",player);
		if(!isdefined(level.jump)) return;

		if(!isdefined(level.entertext)||!level.entertext)
		{
			level.entertext=true;

			ambientstop();
			/* [AUTO DELETE] ambientplay("bheart"); */
			level.canplaysound=false;

			thread fail_trigger("jump");
			thread bounce_gun();

			level.knife delete();
			level.sniper delete();
			level.rpg delete();

			/* [AUTO DELETE] iprintlnbold("^1"+player.name+"^7 entered Bounce Room"); */
			/* [AUTO DELETE] iprintln("^1Now playing: ^7Brennan Heart & TNT ^5- ^7It's my style"); */
		}

		if(!isdefined(level.activ))
		{
			/* [AUTO DELETE] player iprintlnbold("^1Activator^7 is required for Endfight"); */
			return;
		}

		player createroomport("knife_mp",undefined,1,jump,100);
        level.activ createroomport("knife_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
	}
}


rpg_room()
{
	level.rpg=getent("rpgroom_ent","targetname");
	jump=getent("rpgroom_go","targetname");
	acti=getent("rpgroom_acti","targetname");

	while(1)
	{
		level.rpg waittill("trigger",player);
		if(!isdefined(level.rpg)) return;

		if(!isdefined(level.entertext)||!level.entertext)
		{
			level.entertext=true;

			ambientstop();
			/* [AUTO DELETE] ambientplay("illenium"); */
			level.canplaysound=false;

			thread fail_trigger("rpg");

			level.knife delete();
			level.sniper delete();
			level.jump delete();

			/* [AUTO DELETE] iprintlnbold("^1"+player.name+"^7 entered RPG Room"); */
			/* [AUTO DELETE] iprintln("^1Now playing: ^7Illenium ^5- ^7It's All On U"); */
		}

		if(!isdefined(level.activ))
		{
			/* [AUTO DELETE] player iprintlnbold("^1Activator^7 is required for Endfight"); */
			return;
		}

		player createroomport("rpg_mp",undefined,1,jump,100);
        level.activ createroomport("rpg_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();

        player thread refreshAmmo();
        level.activ thread refreshAmmo();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
	}
}


knife_room()
{
	level.knife=getent("kniferoom_ent","targetname");
	jump=getent("kniferoom_go","targetname");
	acti=getent("kniferoom_acti","targetname");

	while(1)
	{
		level.knife waittill("trigger",player);
		if(!isdefined(level.knife)) return;

		if(!isdefined(level.entertext)||!level.entertext)
		{
			level.entertext=true;

			ambientstop();
			/* [AUTO DELETE] ambientplay("panda"); */
			level.canplaysound=false;

			level.rpg delete();
			level.sniper delete();
			level.jump delete();

			/* [AUTO DELETE] iprintlnbold("^1"+player.name+"^7 entered Knife Room"); */
			/* [AUTO DELETE] iprintln("^1Now playing: ^7Desiigner ^5- ^7Panda"); */
		}

		if(!isdefined(level.activ))
		{
			/* [AUTO DELETE] player iprintlnbold("^1Activator^7 is required for Endfight"); */
			return;
		}

		player createroomport("knife_mp",undefined,1,jump,100);
        level.activ createroomport("knife_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
	}
}


sniper_room()
{
	level.sniper=getent("sniproom_ent","targetname");
	jump=getent("sniproom_go","targetname");
	acti=getent("sniproom_acti","targetname");

	while(1)
	{
		level.sniper waittill("trigger",player);
		if(!isdefined(level.sniper)) return;

		if(!isdefined(level.entertext)||!level.entertext)
		{
			level.entertext=true;

			ambientstop();
			/* [AUTO DELETE] ambientplay("flight"); */
			level.canplaysound=false;

			thread snip_mover();

			level.rpg delete();
			level.knife delete();
			level.jump delete();

			/* [AUTO DELETE] iprintlnbold("^1"+player.name+"^7 entered Sniper Room"); */
			/* [AUTO DELETE] iprintln("^1Now playing: ^7Tristam & Braken ^5- ^7Flight"); */
		}

		if(!isdefined(level.activ))
		{
			/* [AUTO DELETE] player iprintlnbold("^1Activator^7 is required for Endfight"); */
			return;
		}

		player createroomport("remington700_mp","m40a3_mp",1,jump,100);
        level.activ createroomport("remington700_mp","m40a3_mp",1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();

        player thread snip_mover();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        /* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7died^1!"); */
	}
}


snip_mover()
{
	what=getent("snip_mover","targetname");
	while(1)
	{
		wait 3;
		what movez(-130,5);
		what waittill("movedone");
		wait 3;
		what movez(130,5);
		what waittill("movedone");
	}
}


createroomport(weapon,weapon2,freeze,where,health)
{
    self takeallweapons();
    /* [AUTO DELETE] self giveweapon(weapon); */
    if(isdefined(weapon2))
    	/* [AUTO DELETE] self giveweapon(weapon2); */
    /* [AUTO DELETE] self switchtoweapon(weapon); */
 
    self freezecontrols(freeze);
    self setorigin(where.origin);
    self setplayerangles(where.angles);
 
    self.health=health;
}

countdown()
{
    self iprintlnbold("^33");
    wait 1;
    self iprintlnbold("^32");
    wait 1;
    self iprintlnbold("^31");
    wait 1;
    self iprintlnbold("^5Fight!");
    self freezecontrols(0);
}


fail_trigger(what)
{
	if(what=="jump")
	{
		trig=getent("bounce_alltp","targetname");
		acti=getent("bounce_at_go","targetname");
		jump=getent("bounce_jt_go","targetname");

		for(;;)
		{
			trig waittill("trigger",who);
			if(who.pers["team"]!="spectator")
			{
				if(who.pers["team"]=="allies")
				{
					who setorigin(jump.origin);
					who setplayerangles(jump.angles);
				}
				else 
				{
					who setorigin(acti.origin);
					who setplayerangles(acti.angles);
				}
			}
		}
	}
	else if(what=="rpg")
	{
		trig=getent("rpgroom_alltp","targetname");
        acti=getent("rpgroom_at_go","targetname");
        jump=getent("rpgroom_jt_go","targetname");

		for(;;)
		{
			trig waittill("trigger",who);
			if(who.pers["team"]!="spectator")
			{
				if(who.pers["team"]=="allies")
				{
					who setorigin(jump.origin);
					who setplayerangles(jump.angles);
				}
				else 
				{
					who setorigin(acti.origin);
					who setplayerangles(acti.angles);
				}
			}
		}
	}
}


bounce_gun()
{
	trig=getent("bounce_gun","targetname");
	thread gun_rotate();

	for(;;)
	{
		trig waittill("trigger",who);
		/* [AUTO DELETE] who giveweapon("remington700_mp"); */
		/* [AUTO DELETE] who givemaxammo("remington700_mp"); */
		/* [AUTO DELETE] who switchtoweapon("remington700_mp"); */
		/* [AUTO DELETE] iprintlnbold("^1"+who.name+"^7 got the ^1Sniper^7!"); */
		wait 1;
	}
}


gun_rotate()
{
	what=getent("bounce_gspin","targetname");
	what thread hover();

	while(isdefined(what))
	{
		what rotateyaw(720,6);
		what waittill("rotatedone");
	}
}


hover()
{
	self movez(4,1.5);
	while(isdefined(self))
	{
		self movez(-8,1.5);
		self waittill("movedone");
		self movez(8,1.5);
		self waittill("movedone");
	}
}


refreshAmmo()
{
	while(isalive(self)&&isdefined(self))
	{
		self givemaxammo("rpg_mp");
		wait 4;
	}
}

secretwep()
{
	trig=getent("secretwep","targetname");
	for(;;)
	{
		trig waittill("trigger",who);
		/* [AUTO DELETE] who giveweapon("remington700_mp"); */
		/* [AUTO DELETE] who givemaxammo("remington700_mp"); */
		/* [AUTO DELETE] who switchtoweapon("remington700_mp"); */
		/* [AUTO DELETE] who iprintlnbold("You got ^6r700!"); */
		wait 1;
	}
}

sniper_logo()
{
	object = getEnt ("sniper_logo","targetname");
	thread sniper_logomve();
	while(1)
	{
		object rotateyaw(1440,20,1,2);
		object waittill ("rotatedone");
		object rotateyaw(-1440,20,1,2);
		object waittill ("rotatedone");
	}
}

sniper_logomve()
{
	object = getEnt ("sniper_logo","targetname");
	while(1)
	{
		object movez(280,5,1,2);
		object waittill ("movedone");
		object movez(-280,5,1,2);
		object waittill ("movedone");
	}
}

knife_logo()
{
	object = getEnt ("knife_logo","targetname");
	thread knife_logomve();
	while(1)
	{
		object rotateyaw(1440,20,1,2);
		object waittill ("rotatedone");
		object rotateyaw(-1440,20,1,2);
		object waittill ("rotatedone");
	}
}

knife_logomve()
{
	object = getEnt ("knife_logo","targetname");
	while(1)
	{
		object movez(280,5,1,2);
		object waittill ("movedone");
		object movez(-280,5,1,2);
		object waittill ("movedone");
	}
}

rpg_logo()
{
	object = getEnt ("rpg_logo","targetname");
	thread rpg_logomve();
	while(1)
	{
		object rotateyaw(1440,20,1,2);
		object waittill ("rotatedone");
		object rotateyaw(-1440,20,1,2);
		object waittill ("rotatedone");
	}
}

rpg_logomve()
{
	object = getEnt ("rpg_logo","targetname");
	while(1)
	{
		object movez(280,5,1,2);
		object waittill ("movedone");
		object movez(-280,5,1,2);
		object waittill ("movedone");
	}
}

bounce_logo()
{
	object = getEnt ("bounce_logo","targetname");
	thread bounce_logomve();
	while(1)
	{
		object rotateyaw(1440,20,1,2);
		object waittill ("rotatedone");
		object rotateyaw(-1440,20,1,2);
		object waittill ("rotatedone");
	}
}

bounce_logomve()
{
	object = getEnt ("bounce_logo","targetname");
	while(1)
	{
		object movez(280,5,1,2);
		object waittill ("movedone");
		object movez(-280,5,1,2);
		object waittill ("movedone");
	}
}

t_deck1()
{
	trigger = getEnt ("t_deck1","targetname");
	object = getEnt ("deck1","targetname");
	trigger waittill ("trigger",player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 100); */
	/* [AUTO DELETE] iPrintlnBold("^5"+player.name+" ^6Loves dicks<3"); */
	object delete();
}

t_deck2()
{
	trigger = getEnt ("t_deck2","targetname");
	object = getEnt ("deck2","targetname");
	trigger waittill ("trigger",player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 100); */
	/* [AUTO DELETE] iPrintlnBold("^5"+player.name+" ^7sucks ^6dicks ^5for xp^7!"); */
	object delete();
}

t_deck3()
{
	trigger = getEnt ("t_deck3","targetname");
	object = getEnt ("deck3","targetname");
	trigger waittill ("trigger",player);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 100); */
	/* [AUTO DELETE] iPrintlnBold("^5"+player.name+" ^6wants it hard^5<3"); */
	object delete();
}

act0()
{
	object2 = getEnt ("act3","targetname");
	object2 hide();
	object2 notSolid();
}

act1()
{
	trigger = getEnt ("trig_act1","targetname");
	// trigger waittill ("trigger",player);
	thread act2();
}

act2()
{
	trigger = getEnt ("trig_act2","targetname");
	// trigger waittill ("trigger",player);
	thread act3();
}

act3()
{
	trigger = getEnt ("trig_act3","targetname");
	// trigger waittill ("trigger",player);
	thread act4();
}

act4()
{
	object1 = getEnt ("act2","targetname");
	object2 = getEnt ("act3","targetname");
	trigger = getEnt ("trig_act4","targetname");
	// trigger waittill ("trigger",player);
	object1 notSolid();
	object2 show();
	object2 Solid();
}
