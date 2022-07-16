#include braxi\_common;
#include common_scripts\utility;
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
	//setdvar("r_fullbright","1");
	setdvar("bg_fallDamageMinHeight","1000000000");
	setdvar("bg_fallDamageMaxHeight","1000000000");
	level.music=[];
    level.music[0]["song"]    ="JETFIRE - LIVING ON THE EDGE";
    level.music[0]["alias"]    ="song1";
    level.music[1]["song"]    ="Minoru - 187";
    level.music[1]["alias"]    ="song2";
    level.music[2]["song"]    ="Capo - Ndakakumirira";
    level.music[2]["alias"]    ="song3";
    level.music[3]["song"]    ="ANA ARABY - I AM AN ARAB";
    level.music[3]["alias"]    ="song4";
	level.music[4]["song"]    ="PakisTRAP";
    level.music[4]["alias"]    ="song5";
    
    thread speedrun\_way_name::create_normal_way("Normal Way");
    thread speedrun\_way_name::create_secret_way("Secret Way");
    thread speedrun\_way_name::create_spawn((-3021,-120,76),360);
    thread startdoor();
	//thread messages();
	//thread musicbox();
    //thread onPlayerConnect();
	//thread addTestClients();
	thread tp1();
	thread endtp();
	//thread spinner();
	//thread actip1();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	thread trap7();
	//thread bounce_room();
	//thread bounce_wep();
	//thread bouncetp1();
	//thread bouncetp2();
	//thread sniper_room();
	//thread knife_room();
	thread secretstep();
	thread secretexit();
	thread secretp1();
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
iprintlnBold("^3Map by ^6PrOmar21!!!");
for(;;)
{
wait 35;
x=randomint(7);
if (x==0)
{
iPrintln("^4Map by ^6PrOmar21!!!R");
}

if (x==1)
{
iPrintln("^6Special thankk me friend mustafa :DDD");
}

if (x==2)
{
iPrintln("^5Hey");
}

if (x==3)
{
iPrintln("^3me first map enjoy ok");
}

if (x==4)
{
iPrintln("^4sorry i dont have steam");
}

if (x==5)
{
iPrintln("^3i think this no bug but say me ok");
}

if (x==6)
{
iPrintln("^2map done for pakistan plese no steal");
}

}
}

musicbox()
{
    trig = getEnt("musictrigger","targetname");
    trig setHintString("^6chose song");
    trig waittill("trigger",p);
	//p braxi\_rank::giveRankXP("", 50);
    trig delete();
    
    p freezeControls(1);
    p musicmenu();
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
    self.hud_music[i] setShader( "white", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(1,1,0);
    
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("^6Omar pakistan sounds :DDD");
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else 
        self.hud_music[i].glowcolor=(0,1,1);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("        ^!you read this you are gay ahahahahahahhahaha");
 
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
            self.hud_music[i].glowcolor=(0,0,1);
 
        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }
 
    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(0,1,0);
 
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

onPlayerConnect()
{
	level endon("game_ended");

	for(;;)
	{
		level waittill("connecting", player);

		player thread hud_website();
	}
}

hud_website()
{
v = "Map";
x = "by";
w = "PrOmar21";

	self.hud_web = newClientHudElem(self);
	self.hud_web.alignX = "center";
	self.hud_web.alignY = "top";
	self.hud_web.horzAlign = "center";
	self.hud_web.vertAlign = "top";
	self.hud_web.fontScale = 2;
	self.hud_web.sort = 10;
	self.hud_web.alpha = 1;
   	self.hud_web.color = ( 0, .1, .1);
   	self.hud_web.font = "objective";
   	self.hud_web.glowColor = (.1, .0, 1);
   	self.hud_web.glowAlpha = 1;
   	self.hud_web.hideWhenInMenu = true;	
	while(1)
	{
	self.hud_web setText("^5" + v + "^4 " + x + "^3 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^4" + v + "^3 " + x + "^2 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^3" + v + "^2 " + x + "^1 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^2" + v + "^1 " + x + "^9 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^1" + v + "^9 " + x + "^8 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^9" + v + "^8 " + x + "^7 " + w + " ");
	wait ( 0.1	);
	self.hud_web setText("^8" + v + "^7 " + x + "^6 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^7" + v + "^6 " + x + "^5 " + w + " ");
	wait ( 0.1 );
	self.hud_web setText("^6" + v + "^5 " + x + "^4 " + w + " ");
	wait ( 0.1 );
	}
}

endtp()
{
	bouncejumperfail = getEnt("trig_endtp", "targetname");
	tpbouncejumperfail = getEnt("o_endtp", "targetname");
	
	for (;;)
	{
		bouncejumperfail waittill("trigger", player);
		player setOrigin(tpbouncejumperfail.origin);
		player setPlayerAngles(tpbouncejumperfail.angles);
	}
}

tp1()
{
	bouncejumperfail = getEnt("trig_tp1", "targetname");
	tpbouncejumperfail = getEnt("o_tp1", "targetname");
	
	for (;;)
	{
		bouncejumperfail waittill("trigger", player);
		player setOrigin(tpbouncejumperfail.origin);
		player setPlayerAngles(tpbouncejumperfail.angles);
	}
}

spinner()
{
	a = getEnt("spinner1", "targetname");
	b = getEnt("spinner2", "targetname");
	c = getEnt("spinner3", "targetname");
	d = getEnt("spinner4", "targetname");
	e = getEnt("spinner5", "targetname");
	f = getEnt("spinner6", "targetname");
	
	for (;;)
	{
		a rotateRoll(-1080, 8);
		b rotateRoll(-1080, 8);
		c rotateRoll(-1080, 8);
		d rotateRoll(-1080, 8);
		e rotateRoll(-1080, 8);
		f rotateRoll(-1080, 8);
		wait 8;
	}
}

sniper_room()
{
	while(1)
	{
	level.trigsniper = getEnt("trig_sniper", "targetname");
	
	jumporigin = getEnt("o_sniper2", "targetname");
	actiorigin = getEnt("o_sniper1", "targetname");
	
	level.trigsniper setHintString("snipeur room");
	
	level.trigsniper waittill("trigger", player);
	
	level.trigknife delete();
	level.trigrace delete();
	level.trigbounce delete();
	
	iPrintLnBold(" " + player.name + " ^7Entered The Snipeur ^7Room");
	ambientPlay("room");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("m40a3_mp");
	player giveWeapon("remington700_mp");
	player giveMaxAmmo("remington700_mp");
	player giveMaxAmmo("m40a3_mp");
	level.activ giveWeapon("m40a3_mp");
	level.activ giveWeapon("remington700_mp");
	level.activ giveMaxAmmo("remington700_mp");
	level.activ giveMaxAmmo("m40a3_mp");
	
	
	player switchToWeapon("m40a3_mp");
	player switchToWeapon("remington700_mp");
	level.activ switchToWeapon("m40a3_mp");
	player switchToWeapon("remington700_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	player iPrintLnBold("^23");
	level.activ iPrintLnBold("^23");
	wait 1;
	player iPrintLnBold("^72");
	level.activ iPrintLnBold("^72");
	wait 1;
	player iPrintLnBold("^21");
	level.activ iPrintLnBold("^21");
	wait 1;
	player iPrintLnBold("^7FIGHT^2!");
	level.activ iPrintLnBold("^7FIGHT^2!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	while( isAlive( player ) && isDefined( player ) )
    wait 1;
	

	}
}

knife_room()
{
	while(1)
	{
	level.trigknife = getEnt("trig_knife", "targetname");
	
	jumporigin = getEnt("o_knife1", "targetname");
	actiorigin = getEnt("o_knife2", "targetname");
	
	level.trigknife setHintString("knife room");
	
	level.trigknife waittill("trigger", player);
	
	level.trigbounce delete();
	level.trigrace delete();
	level.trigsniper delete();

	
	iPrintLnBold("^3" + player.name + " ^7Entered The Knife ^7Room");
	ambientPlay("room");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("knife_mp");
	level.activ giveWeapon("knife_mp");
	
	player switchToWeapon("knife_mp");
	level.activ switchToWeapon("knife_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	player iPrintLnBold("^23");
	level.activ iPrintLnBold("^23");
	wait 1;
	player iPrintLnBold("^72");
	level.activ iPrintLnBold("^72");
	wait 1;
	player iPrintLnBold("^21");
	level.activ iPrintLnBold("^21");
	wait 1;
	player iPrintLnBold("^7FIGHT^2!");
	level.activ iPrintLnBold("^7FIGHT^2!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	while( isAlive( player ) && isDefined( player ) )
    wait 1;
	}
}

bounce_room()
{
	while(1)
	{
	level.trigbounce = getEnt("trig_bounce", "targetname");
	
	jumporigin = getEnt("o_bounce1", "targetname");
	actiorigin = getEnt("o_bounce2", "targetname");
	
	level.trigbounce setHintString("bounce room");
	
	level.trigbounce waittill("trigger", player);
	
	level.trigrace delete();
	level.trigsniper delete();
	level.trigknife delete();

	
	iPrintLnBold("^3" + player.name + " ^7Entered The Bounce ^7Room");
	ambientPlay("room");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("knife_mp");
	level.activ giveWeapon("knife_mp");
	
	player switchToWeapon("knife_mp");
	level.activ switchToWeapon("knife_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	player iPrintLnBold("^23");
	level.activ iPrintLnBold("^23");
	wait 1;
	player iPrintLnBold("^72");
	level.activ iPrintLnBold("^72");
	wait 1;
	player iPrintLnBold("^21");
	level.activ iPrintLnBold("^21");
	wait 1;
	player iPrintLnBold("^7FIGHT^2!");
	level.activ iPrintLnBold("^7FIGHT^2!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	while( isAlive( player ) && isDefined( player ) )
    wait 1;
	

	}
}

bounce_wep()
{
	trig = getEnt("trig_b_wep", "targetname");
	
	trig setHintString("Press ^6use^5 For M40A3");
	
	while(1)
	{
	trig waittill("trigger", player);
	
	player giveWeapon("m40a3_mp");
	player giveMaxAmmo("m40a3_mp");
	player switchToWeapon("m40a3_mp");
	wait 0.1;
	}
}

bouncetp1()
{
	trig = getEnt("trig_bouncetp1", "targetname");
	tele1 = getEnt("o_bouncetp1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

bouncetp2()
{
	trig = getEnt("trig_bouncetp2", "targetname");
	tele1 = getEnt("o_bouncetp2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

race_room()
{
	while(1)
	{
	level.trigrace = getEnt("trig_race", "targetname");
	
	jumporigin = getEnt("o_race1", "targetname");
	actiorigin = getEnt("o_race2", "targetname");
	
	level.trigrace setHintString("race room");
	
	level.trigrace waittill("trigger", player);
	
	level.trigbounce delete();
	level.trigsniper delete();
	level.trigknife delete();
	
	thread race_ends();
	level.race_jumper = player;

	
	iPrintLnBold("^3" + player.name + " ^7Entered The Race ^7Room");
	ambientPlay("room");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;
	
	
	player takeAllWeapons();
	level.activ takeAllWeapons();
	
	player giveWeapon("knife_mp");
	level.activ giveWeapon("knife_mp");
	
	player switchToWeapon("knife_mp");
	level.activ switchToWeapon("knife_mp");
	
	player freezeControls(1);
	level.activ freezeControls(1);
	
	player setOrigin (jumporigin.origin);
	player setPlayerAngles (jumporigin.angles);

	level.activ setOrigin (actiorigin.origin);
	level.activ setPlayerAngles (actiorigin.angles);
	wait 2;
	
	player iPrintLnBold("^23");
	level.activ iPrintLnBold("^23");
	wait 1;
	player iPrintLnBold("^72");
	level.activ iPrintLnBold("^72");
	wait 1;
	player iPrintLnBold("^21");
	level.activ iPrintLnBold("^21");
	wait 1;
	player iPrintLnBold("^7FIGHT^2!");
	level.activ iPrintLnBold("^7FIGHT^2!");
	
	player freezeControls(0);
	level.activ freezeControls(0);
	while( isAlive( player ) && isDefined( player ) )
    wait 1;
	

	}
}

race_ends()
{
	level.race_winner = getent("race_winner","targetname");
	level.race_loser = getent("race_looser","targetname");
	
	wait 1;

	thread ifactiwin();
	thread ifjumperwin();
}

ifactiwin() 
{
	trig = getent("race_end_acti","targetname");
	
	for(;;)
	{
		trig waittill("trigger",who);
		
		if(who.pers["team"] == "axis")
		{
			level.activ setorigin(level.race_winner.origin);
			level.activ setplayerangles(level.race_winner.angles);
			
			level.activ giveWeapon("m40a3_mp");
			level.activ switchToWeapon("m40a3_mp");
			level.activ giveMaxAmmo("m40a3_mp");
			wait .2;
			
			level.race_jumper setorigin(level.race_loser.origin);
			level.race_jumper setplayerangles(level.race_loser.angles);
			level.race_jumper freezecontrols(1);
		}
	}
}

ifjumperwin() 
{
	trig = getent("race_end_jumper","targetname");
	
	for(;;)
	{
		trig waittill("trigger",who);
		
		if(who.pers["team"] == "allies")
		{
			level.race_jumper setorigin(level.race_winner.origin);
			level.race_jumper setplayerangles(level.race_winner.angles);

				level.race_jumper giveWeapon("m40a3_mp");
				level.race_jumper switchToWeapon("m40a3_mp");
				level.race_jumper giveMaxAmmo("m40a3_mp");
			wait .2;
			
			level.activ setorigin(level.race_loser.origin);
			level.activ setplayerangles(level.race_loser.angles);
			level.activ freezecontrols(1);
		}
	}
}

racetp1()
{
	trig = getEnt("trig_racetp1", "targetname");
	tele1 = getEnt("o_racetp1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

racetp2()
{
	trig = getEnt("trig_racetp2", "targetname");
	tele1 = getEnt("o_racetp2", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

trap1()
{
	brush = getEnt("trap11", "targetname");
	trig = getEnt("trig_trap1", "targetname");
	trig setHintString("Press ^6use^5 To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	wait 0.1;
	brush hide();
	brush notSolid();
	wait 4;
	brush show();
	brush solid();
}

trap2()
{
	brush = getEnt("trap2a", "targetname");
	brush2 = getEnt("trap2b", "targetname");
	trig = getEnt("trig_trap2", "targetname");
	
	trig setHintString("Press ^6use^5 To Activate");
	
	trig waittill("trigger", player);
	x = randomInt(2);
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	if (x==0)
	{
	brush delete();
	}
	if (x==1)
	{
	brush2 delete();
	}
}

trap3()
{
    trig = getEnt ("trig_trap3", "targetname");
	trap_1 = getEnt ("trap3a", "targetname");
	trap_2 = getEnt ("trap3b", "targetname");
	trap_3 = getEnt ("trap3c", "targetname");
	
	trig setHintString("Press ^6use^5 To Activate");
	trig waittill ("trigger", player );
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	
	while (1)
	{
	    trap_1 rotatePitch (360, 1.5);
		wait 1;
		trap_2 rotatePitch (360, 1.5);
		wait 1;
		trap_3 rotatePitch (360, 1.5);
		wait 1;
		wait 5;
	}
}

trap4()
{
	brush = getEnt("trap4a", "targetname");
	brush2 = getEnt("trap4b", "targetname");
	trig = getEnt("trig_trap4", "targetname");
	
	trig setHintString("Press ^6use^5 To Activate");
	
	trig waittill("trigger", player);
	x = randomInt(2);
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	if (x==0)
	{
	brush delete();
	}
	if (x==1)
	{
	brush2 delete();
	}
}

trap5()
{
	brush = getEnt("trap5", "targetname");
	trig = getEnt("trig_trap5", "targetname");
	
	trig setHintString("Press ^6use^5 To Activate");
	
	trig waittill("trigger", player);
	
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	
	for(;;)
	{
	wait 0.1;
	brush rotatePitch(360, 2);
	wait 5;
	}
}

trap6()
{
	brush = getEnt("trap6a", "targetname");
	brush2 = getEnt("trap6b", "targetname");
	trig = getEnt("trig_trap6", "targetname");
	
	trig setHintString("Press ^6use^5 To Activate");
	
	trig waittill("trigger", player);
	x = randomInt(2);
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	if (x==0)
	{
	brush delete();
	}
	if (x==1)
	{
	brush2 delete();
	}
}

trap7()
{
plat = getEnt("trap7", "targetname");
h = getEnt("trap7hurt", "targetname");
trig = getEnt("trig_trap7", "targetname");
h thread maps\mp\_utility::triggerOff();
plat hide();
plat notSolid();
trig setHintString("Press ^6use^5 To Activate");
trig waittill("trigger",player);
player braxi\_rank::giveRankXP( "", 500 );
trig delete();

plat show();
plat solid();
h thread maps\mp\_utility::triggerOn();
wait 4;
plat hide();
plat notSolid();
h thread maps\mp\_utility::triggerOff();
}

actip1()
{
	trig = getEnt("trig_actip1", "targetname");
	tele1 = getEnt("o_actip1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

secretstep()
{
plat = getEnt("nnn", "targetname");
trig = getEnt("trig_secretstep", "targetname");
trig delete();
plat show();
plat solid();
thread secretenter();
}

secretenter()
{
	trig = getEnt("trig_secretenter", "targetname");
	tele1 = getEnt("o_secretenter", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
            player thread speedrun\_way_name::change_way("s0");
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

secretexit()
{
	trig = getEnt("trig_secretexit", "targetname");
	tele1 = getEnt("o_secretexit", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
            player thread speedrun\_way_name::finish_way("s0");
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

secret_timer()
{
	self endon("sec1_done");

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
        self.secretTimer.fontScale = 1.7;
        self.secretTimer.font = "default";
        self.secretTimer.glowAlpha = 1;
        self.secretTimer.hidewheninmenu = true;
        self.secretTimer.label = &"^6time in secert: ^5&&1";
        if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else 
	self.secretTimer.glowColor=(1,0,.6);

	time = 50;
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


secretp1()
{
	trig = getEnt("trig_secretp1", "targetname");
	tele1 = getEnt("o_secretp1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}