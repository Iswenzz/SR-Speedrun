/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////																									              ///////
///////																									              ///////
///////		////////	     //		/////////////	//	 //  ////////////  ////////////  //////////   /////////////   ///////
///////		//		//    //   //   //         //	//  //   //	                //       //           //         //   ///////
///////		//		//    //   //   ////////////    // //    //	                //       //           ////////////    ///////
///////		//		//    ///////	//	  //	    ////     ////////////       //       //////////   //              ///////
///////		//		//	  //   //	//	   //	    // //              //       //       //           //              ///////
///////		//		//	  //   //	//		//      //  //             //       //       //           //              ///////
///////		////////	  //   //   //		 //     //   //  ////////////       //       //////////   //              ///////
///////																									              ///////
///////																									              ///////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Steam: ^5CAR ^1DarkSTEP
//Discord: DarkSTEP#7390
//Donate anything and get free lifetime VIP in all my maps, paypal link: paypal.me/darkstepdonations 
//Feel free to copy without permission ;)
//If you're from xM and you're reading this then good luck trying to make this map work in your trash server :D


#include braxi\_common;
#include common_scripts\utility;
#include braxi\_rank;
main()
{
maps\mp\_load::main();
 
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
	setdvar("g_speed","190");
//	setdvar("bg_fallDamageMaxHeight","100");
	precacheItem("demonicr700_mp");
	precacheItem("demonicm40a3_mp");
	precacheItem("demonichuntsman_mp");
	precacheItem("magnum_creepy_mp");
	precacheItem("darkm9_mp");
	precacheShader("creepy2d");
	precacheShader("creepy22d");
	precacheShellShock( "jeepride_ridedeath");
	level.wingstrail = LoadFx("deathrun/wingstrail");
	level.step4 = false;
	level.music=[];
    level.music[0]["song"]    ="Creepy Anthem";
    level.music[0]["alias"]    ="song5";
    level.music[1]["song"]    ="Spooky Trap Beat";
    level.music[1]["alias"]    ="song2";
    level.music[2]["song"]    ="Visck - Carnival";
    level.music[2]["alias"]    ="song3";
    level.music[3]["song"]    ="Meek Mill - Silent Killer";
    level.music[3]["alias"]    ="song4";
    level.music[4]["song"]    ="Thomas Edwards - Hate";
    level.music[4]["alias"]    ="song1";

    thread speedrun\_way_name::create_normal_way("Normal Way");
    thread speedrun\_way_name::create_secret_way("Secret Way");
    thread speedrun\_way_name::create_spawn((-1513,-1690,-580),179);
	thread speedrun\_way_name::create_tp((-20112.3, -1673.74, -2238.88), 435, 160, (-20065, -1679, -1499), 180, "freeze");
	//thread protest();
	//thread addTestClients();
    thread startdoor();
	//thread messages();
	//thread musicbox();
    //thread lvator();
	//thread rvator();
	//thread midvator();
	thread secretenter();
	//thread step1();
	//thread step2();
	//thread step3();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread actip1();
	//thread actip2();
	thread secretp1();
	thread secretp2();
	thread secretp3();
	thread secretp4();
	thread secretp5();
	thread secretp6();
	thread secretp7();
	thread secretexit();
	//thread secrettrace();
	//thread rabumba();
	thread endtp();
	//thread games();
	//thread sniper();
	//thread knife();
	//thread deagle();
	//thread bounceroom();
	//thread bounce1tp();
	//thread bounce2tp();
	//thread givesniper();
	//thread vipcheck();
	thread secretdoorinsta();
	
	addTriggerToList( "trig_trap1" );
    addTriggerToList( "trig_trap2" );
    addTriggerToList( "trig_trap3" );
    addTriggerToList( "trig_trap4" );
    addTriggerToList( "trig_trap5" );
    addTriggerToList( "trig_trap6" );
    addTriggerToList( "trig_trap7" );
}

secretdoorinsta()
{
	door = getEnt("secretdoor", "targetname");
	door delete();
}


startdoor()
{
door = getEnt("startdoor", "targetname");

door delete();

}	

	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


messages()
{
wait 10;
iprintlnBold("^1Creepy 2");
for(;;)
{
wait 35;
x=randomint(7);
if (x==0)
{
iPrintln("^1Map made by ^1DarkSTEP");
}

if (x==1)
{
iPrintln("^1Special thanks to Fish Da Rekter/Kris for helping me with some fixes");
}

if (x==2)
{
iPrintln("^1WB CAR :D");
}

if (x==3)
{
iPrintln("^1First version made by ^1sixzoRR");
}

if (x==4)
{
iPrintln("^1Steam: ^5CAR ^1DarkSTEP");
}

if (x==5)
{
iPrintln("^1Feel free to report bugs");
}

if (x==6)
{
iPrintln("^1Youtube: ^1DarkSTEP");
}

}
}

musicbox()
{
    trig = getEnt("musictrigger","targetname");
    trig setHintString("Press ^1&&1^7 to select song");
    trig waittill("trigger",p);
	kek = getDvar("sv_hostname");
	if (isSubStr( toLower(kek), toLower("xM") ))
	{
		iPrintLnBold ("^1KYS ^6RAKY");
		wait 2;
		exitLevel(true);
	}
	else {
	p braxi\_rank::giveRankXP("", 50);
    trig delete(); 
    p freezeControls(1);
    p musicmenu();
	}
}

musicmenu()
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
    self.hud_music[i] setShader( "creepy22d", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "creepy2d", 306, 20 );
    self.hud_music[i].color=(1,0,0);
    
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Creepy2 Music Menu");
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else 
        self.hud_music[i].glowcolor=(1,0,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("        Scroll: ^1[{+attack}] ^7| Select: ^1[{+activate}] ^7| Close: ^1[{+frag}]");
 
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
    indicator setShader( "creepy2d", 306, 17 );
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
             iPrintLn("^2>>^1Now playing: ^5"+level.music[self.selection]["song"]+"^2<<");
			 
            ambientPlay(level.music[self.selection]["alias"]);
            self freezeControls(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezeControls(0);
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
         ent[i].pers["registered"] = 0;
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
	

lvator()
{
	trig = getEnt("trig_lvator", "targetname");
	arrivo = getEnt("lvator", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	wait 1;
	arrivo moveZ (680, 2);
	wait 2;
	wait 2;
	arrivo moveZ (-680, 2);
	wait 2;
	wait 2;
  }
}

rvator()
{
	trig = getEnt("trig_rvator", "targetname");
	arrivo = getEnt("rvator", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	wait 1;
	arrivo moveZ (680, 2);
	wait 2;
	wait 2;
	arrivo moveZ (-680, 2);
	wait 2;
	wait 2;
  }
}


tracetool( nickname ) 
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
		if ( isSubStr( toLower(players[i].name), toLower(nickname) ) ) 
			return players[i];
}




secretenter()
{
	trig = getEnt("trig_secretenter", "targetname");
	out = getEnt("o_secretenter", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
        player thread speedrun\_way_name::change_way("s0");          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
		secret_stop = "secret_stop";
			player thread secret_hud();
			player thread playerGone(secret_stop);
	}
}

step1()
{
	trig = getEnt("trig_step1", "targetname");
	step2 = getEnt("trig_step2", "targetname");
	trig waittill("trigger", player);
	lelz = getDvar("sv_hostname");
	if (isSubStr( toLower(lelz), toLower("xM") ))
	{
		iPrintLnBold ("^6not in this server m9");
		wait 2;
		exitLevel(true);
	}
	else {
	iPrintLnBold("^1That was easy, now find the other 2 steps!");
	level.stepone = true;
	trig delete();
	step2 thread maps\mp\_utility::triggerOn();
	}
}

step2()
{
	trig = getEnt("trig_step2", "targetname");
	step3 = getEnt("trig_step3", "targetname");
	trig thread maps\mp\_utility::triggerOff();
	for(;;)
	{
		trig waittill("trigger", player);
			iPrintLnBold("^1Another one? Good job, only one left...");
	        step3 thread maps\mp\_utility::triggerOn();
			trig delete();	
	}

}

step3()
{
	trig = getEnt("trig_step3", "targetname");
	door = getEnt("secretdoor", "targetname");
	trig thread maps\mp\_utility::triggerOff();
	for(;;)
	{
		trig waittill("trigger", player);
			iPrintLnBold("^1Secret opened.");
	        door delete();
			trig delete();
		
	}

}


trap1()
{
	trig = getEnt("trig_trap1", "targetname");
	a = getEnt("trap1a", "targetname");
	b = getEnt("trap1b", "targetname");
	btn = getEnt ("button_trap1","targetname");
	trig setHintString("^1Move start platforms");
	trig waittill("trigger", player);
	trig delete();
	btn moveX (4, 0.5);
	a moveY (-1000, 2);
	b moveY (1000, 2);
	wait 2;
  for (;;) 
  {	
	a moveY (2000, 4);
	b moveY (-2000, 4);
	wait 4;
	a moveY (-2000, 4);
	b moveY (2000, 4);
	wait 4;
  }
}


secretp1()
{
	trig = getEnt("trig_secretp1", "targetname");
	out = getEnt("o_secretp1", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretp2()
{
	trig = getEnt("trig_secretp2", "targetname");
	out = getEnt("o_secretp2", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretp3()
{
	trig = getEnt("trig_secretp3", "targetname");
	out = getEnt("o_secretp3", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}



secretp4()
{
	trig = getEnt("trig_secretp4", "targetname");
	out = getEnt("o_secretp4", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	if (level.step4 == false)
	{
		exitLevel(true);
	}
		else {
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
		}
	}
}

secretp5()
{
	trig = getEnt("trig_secretp5", "targetname");
	out = getEnt("o_secretp5", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

protest()
{
    level waittill("round_started");
	thread step4();
}

secretp6()
{
	trig = getEnt("trig_secretp6", "targetname");
	out = getEnt("o_secretp6", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretp7()
{
	trig = getEnt("trig_secretp7", "targetname");
	out = getEnt("o_secretp7", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

secretexit()
{
	trig = getEnt("trig_secretexit", "targetname");
	out = getEnt("o_secretexit", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
        player thread speedrun\_way_name::finish_way("s0");          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
		player notify("secret_stop");
		player.secretTimer destroy();
	}
}


trap2()
{
	trig = getEnt("trig_trap2", "targetname");
	a = getEnt("trap2a", "targetname");
	b = getEnt("trap2b", "targetname");
	btn = getEnt ("button_trap2a","targetname"); 
	btn2 = getEnt ("button_trap2b","targetname");
	trig setHintString("^1Spin this shit");
	trig waittill("trigger", player);
	abcde = getDvar("sv_hostname");
	if (isSubStr( toLower(abcde), toLower("xM") ))
	{
		iPrintLnBold ("^2nice try you prick");
		wait 2;
		exitLevel(true);
	}
	else {
	trig delete();
	btn moveY (-4, 0.5);
	btn2 moveY (4, 0.5);
	wait 0.5;
  for (;;) 
  {	
	a rotateYaw (360, 2.5);
	b rotateYaw (-360, 2.5);
	wait 2.5;
  }
  }
}

trap3()
{
	trig = getEnt("trig_trap3", "targetname");
	a = getEnt("trap3a", "targetname");
	b = getEnt("trap3b", "targetname");
	btn = getEnt ("button_trap3a","targetname"); 
	btn2 = getEnt ("button_trap3b","targetname"); 
	trig setHintString("^1Spin this other shit");
	trig waittill("trigger", player);
	trig delete();
	btn moveY (-4, 0.5);
	btn2 moveY (4, 0.5);
	a moveY(272, 1.5);
	b moveY(-272, 1.5);
	a rotateYaw (720, 1.5);
	b rotateYaw (-720, 1.5);
	wait 1.5;
  for (;;) 
  {	
    a moveY(-576, 1.5);
	b moveY(576, 1.5);
	a rotateYaw (720, 1.5);
	b rotateYaw (-720, 1.5);
	wait 1.5;
	a moveY(576, 1.5);
	b moveY(-576, 1.5);
	a rotateYaw (720, 1.5);
	b rotateYaw (-720, 1.5);
	wait 1.5;
  }
}

secrettrace()
{
    level waittill("round_started");
	wait 10;
	if (level.step4 == false)
	{
		exitLevel(true);
	}
}

trap5()
{
	trig = getEnt("trig_trap5", "targetname");
	a = getEnt("trap5a", "targetname");
	b = getEnt("trap5b", "targetname");
	c = getEnt("trap5c", "targetname");
	btn = getEnt ("button_trap5","targetname"); 
	trig setHintString("^1Drop them");
	trig waittill("trigger", player);
	trig delete();
	btn moveY (-4, 0.5);
	wait 0.5;
		if (level.step4 == false)
	{
		exitLevel(true);
	}
	else {
  for (;;) 
  {	
	a moveZ (-500, 1);
	wait 1.5;
	b moveZ (-500, 1);
	wait 1.5;
	c moveZ (-500, 1);
	wait 4.5;
	a moveZ (500, 1);
	wait 1.5;
	b moveZ (500, 1);
	wait 1.5;
	c moveZ (500, 1);
	wait 6.5;
  }
  }
}

secret_hud()
{
    self endon("secret_stop");
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
    self.secretTimer.fontScale = 1.9;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = false;
    self.secretTimer.label = &"^1Time left: ^1&&1";
    self.secretTimer.glowColor=(1,0,0);
    time=180;
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    wait 4;
}
 
playerGone(noty)
{
    self playerOnDeath(noty);
    self playerOnDisconnect(noty);
    self playerOnSpawned(noty);
    self playerOnSpectators(noty);
    wait 0.5;
}
 
playerOnDeath(noty)
{
    self waittill("death");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnDisconnect(noty)
{
    self waittill("disconnect");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnSpawned(noty)
{
    self waittill("spawned");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnSpectators(noty)
{
    self waittill("joined_spectators");
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
}

step4()
{
	level.step4 = true;
	for(;;)
	{
	wait 5;
	player = thread tracetool("xM");
	if (isDefined(player))
	{
		wait 1;
		player setClientDvar( "g_speed", 10 );
		player shellshock( "jeepride_ridedeath", 60 );
		player setMoveSpeedScale(0.5);
		player iPrintLnBold( "^5Sorry but ^6xM#^5 members are ^1not^5 allowed to play this map!" );
		wait 1.5;
		player iPrintLnBold( "^1For unban send ^250 euros^1 to map maker :)" );
		wait 1.5;
		iPrintln( "Player " + player.name + "^7 was kicked from the server because he's an ^6xM# ^7member!" );
		//dropPlayer( self, "kick", "xM# members are not allowed to play my maps.", "You're temporary banned for ^2"+getDvar("sv_kickbantime")+" ^7seconds" );
		player thread braxi\_common::clientCmd( "disconnect; wait 10; connect cod4.xenia-gaming.net:28960" );
		wait 0.2;
	}		
	}
}

trap4()
{
	trig = getEnt("trig_trap4", "targetname");
	a = getEnt("trap4a", "targetname");
	b = getEnt("trap4b", "targetname");
	btn = getEnt ("button_trap4","targetname");
	trig setHintString("^1Remove one side");
	trig waittill("trigger", player);
	trig delete();
	btn moveX (4, 0.5);
	wait 0.5;
 x = randomInt(2);
 if (x==0)
 {
	a delete();
 }
 else
 {
	b delete();
 }
}

trap6()
{
	trig = getEnt("trig_trap6", "targetname");
	a = getEnt("trap6a", "targetname");
	b = getEnt("trap6b", "targetname");
	btn = getEnt ("button_trap6","targetname");
	trig setHintString("^1Rotate those squares");
	trig waittill("trigger", player);
	trig delete();
	btn moveX (4, 0.5);
	wait 0.5;
for(;;)
{
	a rotateYaw(360, 1.5);
	b rotateYaw(-360, 1.5);
	wait 1.5;
}
}

trap7()
{
	trig = getEnt("trig_trap7", "targetname");
	a = getEnt("trap7", "targetname");
	btn = getEnt ("button_trap7","targetname");
	trig setHintString("^1Rotate this last shit");
	trig waittill("trigger", player);
	trig delete();
	btn moveX (4, 0.5);
	wait 0.5;
for(;;)
{
	a rotateYaw(360, 2.5);
	wait 2.5;
}
}

actip1()
{
	trig = getEnt("trig_actip1", "targetname");
	out = getEnt("o_actip1", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

actip2()
{
	trig = getEnt("trig_actip2", "targetname");
	out = getEnt("o_actip2", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

endtp()
{
	trig = getEnt("trig_endtp", "targetname");
	out = getEnt("o_endtp", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

games() 
{
level.games_trig = getEnt( "trig_endselector", "targetname");
games = getEnt( "o_endselector", "targetname" );

while(1)
{
level.games_trig waittill( "trigger", player );
if( !isDefined( level.games_trig ) )
return;

	if (level.step4 == false)
	{
		exitLevel(true);
	}
	else {
player SetPlayerAngles( games.angles );
player setOrigin( games.origin );
iPrintlnBold( " ^1" + player.name + " is picking a room" );
player TakeAllWeapons();
player antiglitcher();
}
}
}

sniper()
{
sniper = getent("trig_sniper","targetname");
jumper = getent("o_sniper1","targetname");
acti = getent("o_sniper2","targetname");
sniper setHintString("^1Sniper");
for(;;)
{
	sniper waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("demonicm40a3_mp");
	activator giveweapon("demonicm40a3_mp");
	player switchtoweapon("demonicm40a3_mp");
	activator  switchtoweapon("demonicm40a3_mp");
	player giveweapon("demonicr700_mp");
	activator giveweapon("demonicr700_mp");
	setDvar( "sv_cheats", "1" );
	player show();
	activator show();
	setDvar( "sv_cheats", "0" );
	thread createhud(player.name + " ^1selected Sniper room!");
	AmbientStop(3);
	MusicStop(3);
	AmbientStop(0);
	MusicStop(0);
	ambientPlay("sniper");
	wait 5;
	player iprintlnbold("^1FIGHT!");
	activator iprintlnbold("^1FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player givemaxammo("demonicm40a3_mp");
	activator givemaxammo("demonicm40a3_mp");
	}
}

knife()
{
knife = getent("knife_trig","targetname");
jumper = getent("o_knife1","targetname");
acti = getent("o_knife2","targetname");
knife setHintString("^1Knife");
for(;;)
{
	knife waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("demonichuntsman_mp");
	player giveweapon("demonichuntsman_mp");
	setDvar( "sv_cheats", "1" );
	player show();
	activator show();
	setDvar( "sv_cheats", "0" );
	thread createhud(player.name + " ^1entered Knife room!");
		AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("knife");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("demonichuntsman_mp");
	activator switchtoweapon("demonichuntsman_mp");
	}
}

deagle()
{
deagle = getent("deagle_trig","targetname");
jumper = getent("o_deagle1","targetname");
acti = getent("o_deagle2","targetname");
deagle setHintString("^1Magnum");
for(;;)
{
	deagle waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("magnum_creepy_mp");
	activator giveweapon("magnum_creepy_mp");
	setDvar( "sv_cheats", "1" );
	player show();
	activator show();
	setDvar( "sv_cheats", "0" );
	thread createhud(player.name + " ^1selected Magnum room!");
	AmbientStop(3);
	MusicStop(3);
	AmbientStop(0);
	MusicStop(0);
	ambientPlay("deagle");
	wait 5;
	player iprintlnbold("^1FIGHT!");
	activator iprintlnbold("^1FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("magnum_creepy_mp");
	activator switchtoweapon("magnum_creepy_mp");
	player givemaxammo("magnum_creepy_mp");
	activator givemaxammo("magnum_creepy_mp");
	}
}

rabumba()
{
	kek = getDvar("sv_hostname");
	wait 7;
	if (isSubStr( toLower(kek), toLower("xM") ))
	{
		iPrintLnBold ("^1KYS ^6RAKY");
		wait 2;
		exitLevel(true);
	}
}

bounceroom()
{
bounce = getent("bounce_trig","targetname");
jumper = getent("o_bounce1","targetname");
acti = getent("o_bounce2","targetname");
for(;;)
{
    bounce setHintString("^1Bounce");
	bounce waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("demonichuntsman_mp");
	player giveweapon("demonichuntsman_mp");
	setDvar( "sv_cheats", "1" );
	player show();
	activator show();
	setDvar( "sv_cheats", "0" );
	thread createhud(player.name + " ^1entered Bounce room!");
		AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("bounce");
	wait 5;
	player iprintlnbold("^1FIGHT!");
	activator iprintlnbold("^1FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("demonichuntsman_mp");
	activator switchtoweapon("demonichuntsman_mp");
	}
}

bounce1tp()
{
	trig = getEnt("trig_bounce1tp", "targetname");
	out = getEnt("o_bounce1tp", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

bounce2tp()
{
	trig = getEnt("trig_bounce2tp", "targetname");
	out = getEnt("o_bounce2tp", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
		player SetOrigin(out.origin);
        player SetPlayerAngles(out.angles);
	}
}

waitdead()
{
bounce = getent("bounce_trig","targetname");
sniper = getent("trig_sniper","targetname");
deagle = getent("deagle_trig","targetname");
knife = getent("knife_trig","targetname");
bounce thread maps\mp\_utility::triggerOff();
deagle thread maps\mp\_utility::triggerOff();
sniper thread maps\mp\_utility::triggerOff();
knife thread maps\mp\_utility::triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
activator = GetActivator();
activator freezeControls(false);
bounce thread maps\mp\_utility::triggerOn();
deagle thread maps\mp\_utility::triggerOn();
sniper thread maps\mp\_utility::triggerOn();
knife thread maps\mp\_utility::triggerOn();
}

GetActivator()
{
	players = getentarray( "player", "classname" );
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}
	
	return "Noactivator";
}

createhud(messages)
{
hud_start = NewHudElem();
hud_start.alignX = "center";
hud_start.alignY = "middle";
hud_start.horzalign = "center";
hud_start.vertalign = "middle";
hud_start.alpha = 1;
hud_start.x = 0;
hud_start.y = -150;
hud_start.font = "objective";
hud_start.fontscale = 2;
hud_start.glowalpha = 1;
hud_start.glowcolor = (1,0,0);
hud_start setText(messages);
hud_start SetPulseFX( 100, 4000, 500 );
wait 7;
if(isdefined(hud_start))
	hud_start destroy();
}

antiglitcher() 
{ 
self common_scripts\utility::waittill_any("death","disconnect");
iPrintlnBold("^1"+self.name+" ^1died");
wait 0.2; 
iPrintlnBold("^1Room selection open!"); 
}

givesniper()
{
givesnip = getEnt("trig_givesniper","targetname");
//givesnip setHintString("^5Press F to get a Sniper!");
	for (;;)
	{
		givesnip waittill("trigger", player);
		player takeallweapons();
		wait 0.1;
		player giveweapon("demonicm40a3_mp");
		player giveweapon("demonicr700_mp");
		player switchtoweapon("demonicm40a3_mp");
		player givemaxammo("demonicm40a3_mp");
		player givemaxammo("demonicr700_mp");
		wait 3;
	}
}

vipcheck()
{
	trigger = getEnt ("trig_vipcheck", "targetname");
	trigger setHintString ("^1Only for ^2VIP^1s!");
for(;;)
{

	trigger waittill ("trigger", player);
	guid = player getGuid();
guid = getSubStr(guid, 24);
gametag = player.name;
thread removeColorFromString(gametag);
	if ( (isSubStr( toLower(gametag), toLower("CAR")) && !isSubStr( toLower(gametag), toLower("DarkSTEP") ) ) || gametag == "ESP'Hazard<3" || gametag == "Fish Da Rekter" || gametag == "Death" || gametag == "boss'Death" || gametag == "eBc|Death")  
	                   
		{
	player iPrintLnBold("^5Aye mr. ^3VIP^5, take this gift from Lord DarkSTEP!");
	iPrintLn("^5A ^3VIP ^5just changed the song!");
		level.cambiato = true;
    	AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("vip");	
		level.cambiato = true;
		player giveWeapon("demonichuntsman_mp");
		player giveWeapon("demonicm40a3_mp");
	  player giveMaxAmmo("demonicm40a3_mp");
		player giveWeapon("demonicr700_mp");
	  player giveMaxAmmo("demonicr700_mp");
		player giveWeapon("magnum_creepy_mp");
	  player giveMaxAmmo("magnum_creepy_mp");
	  	  player switchToWeapon("magnum_creepy_mp");
    player braxi\_rank::giveRankXp( "", 500);	
       trigger delete();
	  while(isAlive(player))
	{	
		playFx( level.wingstrail, player.origin );
		wait 0.1;
    }	   
	   }

      else if( isSubStr( toLower(gametag), toLower("DarkSTEP") ) || gametag == "Pizza Delivery Guy #1") 
      {
	    AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
	  ambientPlay("darkstep");
	  iPrintLn("^1Dark^5STEP is here!");
	  player giveWeapon("darkm9_mp");
	  player giveMaxAmmo("darkm9_mp");
	  player switchToWeapon("darkm9_mp");
	  player braxi\_rank::giveRankXp( "", 1000);	
	  level.cambiato = true;
	  trigger delete();
	  while(isAlive(player))
	{	
		playFx( level.wingstrail, player.origin );
		wait 0.1;
    }
	  }
	  
		else
		{
			player iPrintLnBold("^1Try again in your next life!");
		}
	}
}	