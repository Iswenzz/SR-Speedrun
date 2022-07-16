#include common_scripts\utility;
#include braxi\_common;
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
	
	setDvar("r_gamma","1");
	setDvar("r_specularcolorscale", "1");
	setDvar("r_glowbloomintensity0","1");
	setDvar("r_glowbloomintensity1","1");
	setDvar("r_glowskybleedintensity0","1");
	setDvar("compassmaxrange","1800");
	setDvar("bg_fallDamageMaxHeight", "99999");
	setDvar("bg_fallDamageMinHeight", "99998");

	precacheModel("link");
	precacheModel("link_outset");
	precacheModel("link_house");
	precacheModel("island");
	precacheModel("w_boat");
	precacheModel("rupee");
	precacheModel( "viewmodel_hands_zombie" );

	precacheItem("rpg_mp");
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("deserteaglegold_mp");
	precacheItem("deserteagle_mp");
	precacheItem("knife_mp");
	precacheItem("tomahawk_mp");

	addTriggerToList("trig_trap1");
    addTriggerToList("trig_trap2");
    addTriggerToList("trig_trap3");
    addTriggerToList("trig_trap4");
    addTriggerToList("trig_trap5");
    addTriggerToList("trig_trap6");
    addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");

	//musicArray
	level.music=[];
    level.music[0]["song"]    ="^5Outset Island";
    level.music[0]["alias"]    ="song1";
	level.music[0]["length"]	=250;
    level.music[1]["song"]    ="^5Kid Cudi^7 - ^4Day 'N' Nite";
    level.music[1]["alias"]    ="song2";
	level.music[1]["length"]	=187;
	level.music[2]["song"]    ="^5G-Eazy^7 - ^4I Mean It";
    level.music[2]["alias"]    ="song3";
	level.music[2]["length"]	=237;
	//roomsongs
	level.music[3]["song"]    ="^5Hollywood Undead^7 - ^4Whatever It Takes";
    level.music[3]["alias"]    ="knife";
	level.music[3]["length"]	=195;
	level.music[4]["song"]    ="^5Post Malone, Swae Lee^7 - ^4Sunflower";
    level.music[4]["alias"]    ="sniper";
	level.music[4]["length"]	=158;
	level.music[5]["song"]    ="^5Red Hot Chili Peppers^7 - ^4Snow";
    level.music[5]["alias"]    ="bounce";
	level.music[5]["length"]	=335;
	level.music[6]["song"]    ="^5BEACH HOUSE^7 // ^4Space Song";
    level.music[6]["alias"]    ="space";
	level.music[6]["length"]	=335;
	//mainMessagesArray
	level.mainMessages=[];
	level.mainMessages[0]["msg"]	= "^7Map made by: ^4quaK";
	level.mainMessages[1]["msg"]	= "^4STEAM: ^7https://steamcommunity.com/id/Joelrau/";
	level.mainMessages[2]["msg"]	= "^4DISCORD: ^7Joel#0426";
	//subMessagesArray
	level.subMessages=[];
	level.subMessages[0]["msg"]		="There are ^2Easy^7 and ^1Hard^7 secret rooms, try finding them!";
	level.subMessages[1]["msg"]		="Try finding all the ^4secrets^7 in this map!";
	level.subMessages[2]["msg"]		="^2Someone^7 is looking at you from ^4Outset Island^7?";
	level.subMessages[3]["msg"]		="After a room ^1fight^7 your ^2health^7 will be restored";
	level.subMessages[4]["msg"]		="^4Special^7 Thanks to ^0Dark^5STEP ^7for helping me as always^4!";
	level.subMessages[5]["msg"]		="Check out ^4Bashee Jump^7 on ^2Play Store^7!";
	level.subMessages[6]["msg"]		="^4Torilla^7 tavataan";
	//VIPArray
	level.vips=[];
	level.vips[0]["name"]	="quaK";
	level.vips[1]["name"]	="DarkSTEP";
	level.vips[2]["name"]	="Asimakis";
	level.vips[3]["name"]	="MikeZz";
	level.vips[4]["name"]	="Lazzy";
	level.vips[5]["name"]	="Rmp";
	//fx
	level.expbullt		= loadfx("explosions/grenadeExp_concrete_1");
	level.flame			= loadfx("fire/tank_fire_engine");
	level.watersplash	= loadfx("misc/water_gush");
	level.quak 			= loadfx("quak");
	//definitions
	level.firstenter = true;
	level.playingMusic = "none";
	level.activKills = 0;

	//miscs------------------------
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^1Hard Way;^2Easy Way;");
	thread sr\api\_map::createSpawn((667,581,68),0);
	thread sr\api\_speedrun::createTeleporter((591.033, 346.256, 8.125), 70, 40, (-37892, -8888, 1100), 90, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createTeleporter((796.85, 336.657, 8.125), 70, 40, (-23551, -6691, 1260), 90, "freeze", "yellow", "secret_1");
	thread sr\api\_speedrun::createTeleporter((6660.33, 4146.93, 320.125), 60, 60, (6564, 6750, 59), 180, "freeze");
	// thread whenPlayerConnected();
	// thread whenSpawned();
	// thread whenRoundStarted();
	// thread whenRoundEnded();
	// thread messages();
	// thread credits();
	//-----------------------------

	//musicbox---------------------
	// thread musicbox();
	//-----------------------------

	//rupees-----------------------
	// thread rupees();
	//-----------------------------

	//jumper-----------------------
	thread startFence();
	// thread jdeagle();
	// thread rollTheDice();
    thread water();
	thread teleport01();
	thread teleport_out_hidden();
	thread sling();
	// thread link();
	// thread linkHouse();
	// thread VIP();
	// thread outsetIsland();
	//-----------------------------

	//secret-----------------------
	thread secret1();
	thread secret2();
	//-----------------------------

	//activator--------------------
	// thread acti();
	//-----------------------------

	//end--------------------------
	// thread endReached();
	
	// thread old_room();
	// thread knife_room();
	// thread sniper_room();
	// thread bounce_room();
	// thread space_room();
	//-----------------------------

	//debug------------------------
	// thread debug();
	//-----------------------------
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

//misc TABLE//{
whenPlayerConnected()
{
	level waittill( "round_started" );
    for(;;)
    {
        level waittill( "connected", player );
       // player iPrintLnBold("Welcome ^4"+player.name);
    }
}

whenSpawned()
{
	for(;;)
	{
		level waittill ("player_spawn", player);
		
		// if (!isDefined(player.isVIP))
		// player.isVIP = false;
		// if (!isDefined(player.hasRolled))
		// player.hasRolled = false;
		
		// player.isLink = false;
		// player.forceOldModel = false;
		// player.isSlinging = false;
		// player.hasNukeBullets = false;
		// player.bounce_failPosition = 0;
		// player.hasGottenBounceWeapon = false;
		
		// player.transporting = false;
	}
}

whenRoundStarted()
{
	level waittill ("round_started");
	
	x = randomIntRange(0,7);
	jumpers = getEntArray("player", "classname");
	for (i=0;i<jumpers.size;i++)
	{
		jumper = jumpers[i];
		if (x == 6)
		{
			// jumper braxi\_rank::giveRankXP("", 250);
			// jumper iPrintLnBold("^4You^7 have been ^3blessed^7 by a ^5fairy^7!");
			// jumper playSoundToPlayer ("w_fairy", jumper );
		}
	}
}

whenRoundEnded()
{
	level waittill( "round_ended" );
	// AmbientStop();
}

messages()
{
	mainTime = 5;
	subTime = 30;
	
	level waittill ("round_started");
	
	for (i=0;;)
	{
		while (i < level.mainMessages.size)
		{
			wait mainTime;
			iPrintLn (level.mainMessages[i]["msg"]);
			i++;
		}
		while (1)
		{
			wait subTime;
			x = randomIntRange( 0, level.subMessages.size );
			iPrintLn (level.subMessages[x]["msg"]);
		}
	}
}

credits()
{
	creditsArray=[];
	creditsArray[0]["text"] = "^5Windwaker";
	creditsArray[1]["text"] = "^7Map made by: ^4quaK";
	waitTime = 5;
	
	level waittill("round_started");
		
	for (i=0;i<creditsArray.size;i++)
	{
		hud_credits = NewHudElem();
		hud_credits.alignX = "center";
		hud_credits.alignY = "middle";
		hud_credits.horzalign = "center";
		hud_credits.vertalign = "middle";
		hud_credits.alpha = 1;
		hud_credits.x = 0;
		hud_credits.y = -50;
		hud_credits.font = "objective";
		hud_credits.fontscale = 1.5;
		hud_credits.glowalpha = 1;
		hud_credits.glowcolor = (0.5,0.5,0.5);
		hud_credits setText (creditsArray[i]["text"]);
		hud_credits SetPulseFX( 40, waitTime*1000, 200 );	
			
		wait waitTime;
		hud_credits destroy();
		}
}

//}

//music TABLE//{
musicbox()
{
    trig = getEnt("musictrigger","targetname");
    trig setHintString("^7Press ^4[ ^5&&1 ^4]^7 to select song");
    trig waittill("trigger", p);
    p braxi\_rank::giveRankXP("", 50); //remove this if you still got braxi issues
	trig delete();
    p freezeControls(1);
	level.playingMusic = "choosing";
    p musicmenu();
}

musicmenu()
{
    //self endon( "disconnect" );
    //self endon( "death" );
    //self endon( "spawned" );
    //self endon( "joined_spectators" );
    self endon( "music thread terminated" );

    self.hud_music = [];
    self.selection = 0;

    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "white", 320, 160 ); //background image
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 ); //should be bar image, i suggest to not change cuz your texture will be stretched
    self.hud_music[i].color=(0,0,1);

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Wind Waker Music Menu"); //title
    self.hud_music[i].glowalpha=1;
    self.hud_music[i].glowcolor=(0,0,1); //title text color
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("                                            Scroll: ^4[{+attack}] ^7| Select: ^4[{+activate}]"); //just change numbers of colors here if you need different ones

    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        self.hud_music[i].glowcolor=(0,0,1);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 ); //another bar image that will most likely stretch, i suggest to only change colors
    indicator.color=(0,0,1);

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
			thread playMusic(level.music[self.selection]["alias"], level.music[self.selection]["length"], level.music[self.selection]["song"], true);
            self freezeControls(0);
            break;
        }
		else if (!isAlive(self))
		{
			thread playMusic(level.music[self.selection]["alias"], level.music[self.selection]["length"], level.music[self.selection]["song"], true);
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

playMusic(music, time, print, default_styling) //music = alias, time = length, print = song, default_styling = styling or not (true/false)
{
if (isDefined(level.playingMusic) && level.playingMusic == music)
	return 0;
	
level.playingMusic = music;

level notify ("newmusic"); //tells new music is here
level endon ("newmusic"); //ends if new music comes

AmbientStop();
wait 0.5;
for(;;)
{
	if (isDefined(default_styling) && default_styling == true)
		iPrintLn("^2>>^1Now playing: ^5" +print+ "^2<<");
	else
		iPrintLn(print);

	AmbientPlay(music);
	wait time;
	AmbientStop();
	wait 1;
	}
}
//}

//rupees TABLE//{
rupees()
{
	thread rupee("rupee1", "trig_rupee1", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee2", "trig_rupee2", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee3", "trig_rupee3", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee4", "trig_rupee4", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee5", "trig_rupee5", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee6", "trig_rupee6", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee7", "trig_rupee7", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee8", "trig_rupee8", 360, 2, "jumper_died", "You got a ^2Rupee^7!");

	thread rupee("rupee_hidden1", "trig_rupee_hidden1", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_hidden2", "trig_rupee_hidden2", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_hidden3", "trig_rupee_hidden3", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_hidden4", "trig_rupee_hidden4", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_hidden5", "trig_rupee_hidden5", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_hidden6", "trig_rupee_hidden6", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	
	thread rupee("rupee_island1", "trig_rupee_island1", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_island2", "trig_rupee_island2", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_island3", "trig_rupee_island3", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_island4", "trig_rupee_island4", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_island5", "trig_rupee_island5", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_island6", "trig_rupee_island6", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_island7", "trig_rupee_island7", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
	thread rupee("rupee_island8", "trig_rupee_island8", 360, 2, "jumper_died", "You got a ^2Rupee^7!");
}

rupee(targetname, trigger_targetname, rotation, time, xp, text)
{
	rupee = getEnt (targetname, "targetname");
	trig = getEnt (trigger_targetname, "targetname");

	thread rupeespin(targetname,rotation,time);

	trig waittill ("trigger", player);
	player braxi\_rank::giveRankXP(xp);
	player iPrintLnBold(text);
	player playSound("w_rupee");

	rupee delete();
	trig delete();

}

rupeespin(targetname, rotation, time)
{
	rupee = getEnt (targetname, "targetname");
	while (isDefined(rupee))
	{
		rupee rotateYaw(rotation,time);
		wait time;
	}
}

//}

//jumper TABLE//{

startFence()
{
    fence = getEnt ("starting_fence", "targetname");
    fence delete();

}

jdeagle()
{
	trig = getEnt ("trig_jdeagle", "targetname");
	trig setHintString ("^5Deagle");
	
	while (1)
	{
		trig waittill ("trigger", player);
		
		if(isDefined( level.trapsDisabled ) && level.trapsDisabled)
		{
			player iPrintLnBold("^1What the ....!");
			trig setHintString("Not in freerun");
			return;
		}
		else
		{
			player giveWeapon("deserteagle_mp");
			player giveMaxAmmo("deserteagle_mp");
			player switchToWeapon("deserteagle_mp");
		}
	}
}

rollTheDice()
{
	trig = getEnt ("trig_roll_the_dice", "targetname");
	trig setHintString ("^3Roll ^2the ^1Dice");

	while (1)
	{
		trig waittill ("trigger", player);
		player thread rollTheDiceContent();
	}
}

rollTheDiceContent()
{
	targetInt = 33;
	rand = randomIntRange( 1, 34 );

	if (self.hasRolled == false)
	{
		self.hasRolled = true;

		if (rand == targetInt)
		{
			self thread superpower(100, 5, 2, false);
			self braxi\_rank::giveRankXP("", 1500);
			self iPrintLnBold ("You ^2won!^7 Enjoy your gift!");
			wait 1;
			iPrintLnBold ("^4" + self.name + "^7 has ^2won^7 in ^3Roll ^2the ^1dice^7!");
		}
		else
		{
			self iPrintLnBold ("You ^1lost!^7");
			self iPrintLn (rand + " / " + targetInt);
		}
	}
	else
	{
		self iPrintLnBold("You have already rolled the dice!");
	}
}

water()
{
	trig = getEnt ("trig_water", "targetname");
	while (1)
	{
		trig waittill ("trigger", player);
		player playSound ("w_drown");
		playFX( level.watersplash, player.origin );
		player suicide();
	}
}

teleport01()
{
	trig = getEnt ("trig_teleport1", "targetname");
	tele = getEnt ("orig_teleport1", "targetname");

	while(1)
	{
		trig waittill ("trigger", player);
		player setOrigin (tele.origin);
		player setPlayerAngles (tele.angles);
		player thread resetVelocity();
		player iPrintLn("^9Teleported!");
	}
}

teleport_out_hidden()
{
	trig = getEnt ("trig_hidden_teleport", "targetname");
	tele = getEnt ("orig_hidden_teleport", "targetname");

	trig setHintString("^4Teleport ^7Out");
	trig waittill ("trigger", player);

	player setOrigin (tele.origin);
	player setPlayerAngles (tele.angles);
	player thread resetVelocity();

	ent = spawn( "script_model", (0,0,0));
	ent playSound("mp_enemy_obj_captured");
	iPrintLnBold("^1Dafuq?");

	trig delete();
	ent delete();
}

sling()
{
	trig = getEnt ("trig_sling", "targetname");
	trig setHintString("^7Press ^4[ ^5&&1 ^4]^7");

	while (1)
	{
		trig waittill ("trigger", player);

		if (isDefined(player.isSlinging) && player.isSlinging == false)
			player thread slingContent();
	}
}

slingContent()
{
	self.isSlinging = true;

	start = (6674,4264,360);
	end = (6674,6680,50);

	air = spawn ("script_origin",(0,0,0));
	air.origin = self.origin;
	air.angles = self.angles;

	self linkTo (air);

	air moveTo(start, 1);
	wait 1.1;
	air moveTo(end, 2);
	wait 2.1;
	self unlink();

	air delete();

	self.isSlinging = false;
}

link()
{
	thread linkOldModelForce();
	thread linkGamble();

	trig = getEnt ("trig_link", "targetname");
	while (1)
	{
		trig waittill ("trigger", player);
		player thread linkSetModel();
	}
}
linkSetModel()
{
	if (self.isLink == false)
	{
		rand = randomIntRange(0,69);
		if (self.forceOldModel == true)
			rand = 68;
		if (rand == 68)
		{
			self.isLink = true;
			self detachAll();
			self setModel("link");
			self iPrintLn("You are now ^1retarded ^2Link.");
			self waittill ("death");
			self.isLink = false;
		}
		else
		{
			self.isLink = true;
			self detachAll();
			self setModel("link_outset");
			self iPrintLn("You are now ^2Link.");
			self waittill ("death");
			self.isLink = false;
		}
	}
	else
	{
		self iPrintLn ("^2[Link]:^7 Get out of my house!");
	}
}
linkOldModelForce()
{
	trig = getEnt ("trig_forceOLDModel", "targetname");
	while(1)
	{
		trig waittill ("trigger", player);
		if (player.forceOldModel == true)
			player.forceOldModel = false;
		else
			player.forceOldModel = true;

		player iPrintLn("don't shoot the loli");
	}
}
linkGamble()
{
	x = randomIntRange(0,11);
	
	if (x == 6)
	{
		for(;;)
		{
			level waittill ("jumper", player);
			player thread linkSetModel();
		}
	}
}

linkHouse()
{
	thread linkHouseSoup();

	thread linkHouseEnter();
	thread linkHouseLeave();
}

linkHouseEnter()
{
	orig = getEnt ("orig_link_house_enter", "targetname");
	trig = getEnt ("trig_link_house_enter", "targetname");

	while (1)
	{
		trig waittill ("trigger", player);
		player setOrigin (orig.origin);
		player setPlayerAngles (orig.angles);
		player thread resetVelocity();

		player playSoundToPlayer ("w_secret2", player );
	}
}
linkHouseLeave()
{
	orig = getEnt ("orig_jumperspawn", "targetname");
	origOutset = getEnt ("orig_outset_island", "targetname");
	trig = getEnt ("trig_link_house_leave", "targetname");

	while (1)
	{
		trig waittill ("trigger", player);
		
		if (player getStance() == "crouch" && player isOnGround())
		{
			player setOrigin (origOutset.origin);
			player setPlayerAngles (origOutset.angles);
			player thread resetVelocity();
		}
		else
		{
			player setOrigin (orig.origin);
			player setPlayerAngles (orig.angles);
			player thread resetVelocity();
			
			x = randomIntRange(0,5);
			if (x == 1)
				iPrintLn("Next time try ^3crouching^7 while leaving the house ;)");
		}
	}
}

linkHouseSoup()
{
	trig = getEnt("trig_soup", "targetname");

	while(1)
	{
		trig waittill ("trigger", player);
		if(player.health < 100)
		{
			player.maxhealth = 100;
			player.health = player.maxhealth;
			player iPrintLn("TASTY ^3SOUP");
		}
	}
}

VIP()
{
	trig = getEnt("trig_vip", "targetname");
	trig setHintString("^6V^5I^3P ^7only!");

	for(;;)
	{
		trig waittill ("trigger", player);
		player.isVIP = false;

		for (i=0;i<level.vips.size;i++)
		{
			if (toLower(player.name) == toLower(level.vips[i]["name"]) || stringContains(player.name, level.vips[i]["name"]))
			{
				player.isVIP = true;
				break;
			}
		}
		if (isDefined(player.isVIP) && player.isVIP == true)
		{
			vip = player;
			thread VIPcontent(vip);
			trig delete();
		}
		else
		{
			player iPrintLnBold("Not for you!");
			player playSoundToPlayer("denied", player);
		}
	wait 2;
	}
}

VIPcontent(vip)
{
	players = getEntArray( "player", "classname" );

	if (toLower(vip.name) == "quak" || stringContains(vip.name, "quak"))
	{
		iPrintLnBold("^5quaK^7 is the ^4MAP^7 Maker!");

		for(i=0;i<players.size;i++)
		{
			player = players[i];
			player braxi\_rank::giveRankXp( "", 1000);
			player iPrintLnBold("^2You^7 got a ^3gift^7 from the ^4MAP^7 Maker!");
		}
		vip braxi\_rank::giveRankXp( "", 500);
		vip thread quack();
	}
	else
	{
		iPrintLnBold(vip.name + " ^1i^2s ^6V^5I^3P");

		for(i=0;i<players.size;i++)
		{
			player = players[i];
			player braxi\_rank::giveRankXp( "", 500);
			player iPrintLnBold("^2You^7 got a ^3gift^7 from the ^6V^5I^3P^7");
		}
		vip braxi\_rank::giveRankXp( "", 500);
		vip iPrintLnBold ("As a ^6V^5I^3P^7 ^2you^7 got an extra ^3500xp^7");
	}
}

outsetIsland()
{
	thread outsetIslandLeave1();
	thread outsetIslandLeave2();
	thread outsetIslandXP();
	thread outsetIslandTransporter();
}

outsetIslandLeave1()
{
	trig = getEnt ("trig_outset_island_leave1", "targetname");
	orig = getEnt ("orig_link_house_enter", "targetname");
	
	for (;;)
	{
		trig waittill ("trigger", player);

		player setOrigin (orig.origin);
		player setPlayerAngles (orig.angles);
		player thread resetVelocity();
	}
}
outsetIslandLeave2()
{
	trig = getEnt ("trig_outset_island_leave2", "targetname");
	orig = getEnt ("orig_jumperspawn", "targetname");
	
	trig setHintString ("^7Press ^9[ ^1&&1 ^9]^7 to travel back");
	for (;;)
	{
		trig waittill ("trigger", player);

		player setOrigin (orig.origin);
		player setPlayerAngles (orig.angles);
		player thread resetVelocity();
	}
}

outsetIslandXP()
{
	trig = getEnt ("trig_outset_xp", "targetname");
	orig = getEnt ("orig_outset_island", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		if (isDefined(level.outsetxp) == false)
		{
			player braxi\_rank::giveRankXp( "", 500);
			player iPrintLnBold("^4You^7 have found the ^1secret^7 ^3XP^7!");
			level.outsetxp = true;
		}
		else
			player iPrintLnBold("^3XP^7 already taken!");
			
		player setOrigin(orig.origin);
		player setPlayerAngles(orig.angles);
	}
}

outsetIslandTransporter()
{
	level.i_transporter_trigBottom = getEnt ("trig_island_transporter_bottom", "targetname");
	level.i_transporter_trigTop = getEnt ("trig_island_transporter_top", "targetname");
	level.i_transporter_origBottom = getEnt ("orig_transporter_bottom", "targetname");
	level.i_transporter_origTop = getEnt ("orig_transporter_top", "targetname");
	level.i_transporter_orig1 = getEnt ("orig_transporter_1", "targetname");
	level.i_transporter_orig2 = getEnt ("orig_transporter_2", "targetname");
	level.i_transporter_orig3 = getEnt ("orig_transporter_3", "targetname");
	level.i_transporter_orig4 = getEnt ("orig_transporter_4", "targetname");
	level.i_transporter_orig5 = getEnt ("orig_transporter_5", "targetname");
	level.i_transporter_orig6 = getEnt ("orig_transporter_6", "targetname");
	level.i_transporter_orig7 = getEnt ("orig_transporter_7", "targetname");
	level.i_transporter_orig8 = getEnt ("orig_transporter_8", "targetname");
	level.i_transporter_orig9 = getEnt ("orig_transporter_9", "targetname");
	level.i_transporter_orig10 = getEnt ("orig_transporter_10", "targetname");
	level.i_transporter_orig11 = getEnt ("orig_transporter_11", "targetname");
	level.i_transporter_orig12 = getEnt ("orig_transporter_12", "targetname");
	level.i_transporter_orig13 = getEnt ("orig_transporter_13", "targetname");
	
	thread islandTransporterBottom();
	thread islandTransporterTop();
}

islandTransporterBottom()
{
	for(;;)
	{
		level.i_transporter_trigBottom waittill ("trigger", player);
		
		if (isDefined(player.transporting) && player.transporting == false)
			player thread islandTransporter("top");
	}
}

islandTransporterTop()
{
	for(;;)
	{
		level.i_transporter_trigTop waittill ("trigger", player);
		
		if (isDefined(player.transporting) && player.transporting == false)
			player thread islandTransporter("bottom");
	}
}

islandTransporter(direction) //string direction = "top" or "bottom"
{	
	self.transporting = true;
	
	waitTime = 0.3;
	
	switch (direction)
	{
		case "top":
			air = spawn ("script_origin",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkTo (air);
			
			air moveTo(level.i_transporter_orig1.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig2.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig3.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig4.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig5.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig6.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig7.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig8.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig9.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig10.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig11.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig12.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig13.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_origTop.origin, waitTime);
			wait waitTime + 0.1;
			
			self unlink (air);
			air delete();
			break;
			
		case "bottom":
			air = spawn ("script_origin",(0,0,0));
			air.origin = self.origin;
			air.angles = self.angles;
			self linkTo (air);
			
			air moveTo(level.i_transporter_orig13.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig12.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig11.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig10.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig9.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig8.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig7.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig6.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig5.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig4.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig3.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig2.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_orig1.origin, waitTime);
			wait waitTime;
			air moveTo(level.i_transporter_origBottom.origin, waitTime);
			wait waitTime + 0.1;
			
			self unlink (air);
			air delete();
			break;
			
		default:
			self iPrintLnBold("Something went wrong!");
			break;
	}
	self.transporting = false;
}

//}

//secret TABLE//{

secretTimer(time)
{
	self endon ("disconnect");
	self endon ("joined_spectators");
	self endon ("death");
	self endon ("secret_stop");
	
	self thread secretTimerStop("death");
	
	if (isDefined(self.hud_secretTimer))
		self.hud_secretTimer destroy();
	
	self.hud_secretTimer=newclienthudelem(self);
	self.hud_secretTimer.foreground = true;
	self.hud_secretTimer.alignX = "center";
	self.hud_secretTimer.alignY = "bottom";
	self.hud_secretTimer.horzAlign = "center";
	self.hud_secretTimer.vertAlign = "bottom";
	self.hud_secretTimer.x = 0;
	self.hud_secretTimer.y = -7;
	self.hud_secretTimer.sort = 5;
	self.hud_secretTimer.fontScale = 1.6;
	self.hud_secretTimer.font = "default";
	self.hud_secretTimer.glowAlpha = 0;
	self.hud_secretTimer.glowColor=(5,6,2);
	self.hud_secretTimer.hidewheninmenu = true;
	
	for(timer=0;timer<time;timer++)
	{
		self.hud_secretTimer setText ("Secret timer: ^5" + timer + "^7 / ^1" + time);
		wait 1;
	}
	if (timer >= time)
	{
		self iPrintLn("You were too slow!");
		self suicide();
	}
	self.hud_secretTimer destroy();
}
secretTimerStop(waitill)
{	
	if (isDefined(waitill))
		self waittill(waitill);
	
	self notify ("secret_stop");
	
	if (isDefined(self.hud_secretTimer))
		self.hud_secretTimer destroy();
}

secret1()
{
    thread secret1Finish();
}

secret1Finish()
{
	trig = getEnt ("trig_secret_easy_finish", "targetname");
	location = getEnt ("orig_secret_finish", "targetname");

	while (1)
	{
		trig waittill ("trigger", player);

		player setOrigin (location.origin);
		player setPlayerAngles (location.angles);
		player thread resetVelocity();

		
		if (isDefined( level.trapsDisabled ) && level.trapsDisabled == false)
		{
			player giveWeapon ("deserteaglegold_mp");
			player giveMaxAmmo ("deserteaglegold_mp");
			player switchToWeapon ("deserteaglegold_mp");
		}
		player thread sr\api\_speedrun::finishWay("secret_1");
	}
}

secret2()
{
	thread secret2Enter();

	thread secret2CheckpointDefault();
	thread secret2Checkpoint("trig_secret_hard_checkpoint1", "orig_secret_hard_checkpoint1");
	thread secret2Checkpoint("trig_secret_hard_checkpoint2", "orig_secret_hard_checkpoint2");
	thread secret2Checkpoint("trig_secret_hard_checkpoint3_1", "orig_secret_hard_checkpoint3_1");
	thread secret2Checkpoint("trig_secret_hard_checkpoint3_2", "orig_secret_hard_checkpoint3_2");

	thread secret2Weapon();

	thread secret2Finish();
}

secret2Enter()
{
	trig = getEnt ("trig_secret_hard", "targetname");
	secret = getEnt ("orig_secret_hard", "targetname");

	while (1)
	{
		trig waittill ("trigger", player);

	}
}

secret2CheckpointDefault()
{
	trig = getEnt ("trig_secret_hard_checkpoint_default", "targetname");
	checkpoint = getEnt ("orig_secret_hard", "targetname");

	while (1)
	{
		trig waittill ("trigger", player);

		player setOrigin (checkpoint.origin);
		player setPlayerAngles (checkpoint.angles);
		player thread resetVelocity();
	}
}

secret2Checkpoint(trigger, checkpoint)
{
	trig = getEnt (trigger, "targetname");
	checkpoint = getEnt (checkpoint, "targetname");

	while (1)
	{
		trig waittill ("trigger", player);

		player setOrigin (checkpoint.origin);
		player setPlayerAngles (checkpoint.angles);
		player thread resetVelocity();
	}
}

secret2Weapon()
{
	trig = getEnt ("trig_secret_hard_weapon", "targetname");
	trig setHintString ("^1&&1^7 for ^4RPG");

	while (1)
	{
		trig waittill ("trigger", player);

		player giveWeapon("rpg_mp");
		player giveMaxAmmo( "rpg_mp" );
		player switchToWeapon( "rpg_mp" );
	}
}

secret2Finish()
{
	trig = getEnt ("trig_secret_hard_finish", "targetname");
	location = getEnt ("orig_secret_finish", "targetname");

	while (1)
	{
		trig waittill ("trigger", player);

		player setOrigin (location.origin);
		player setPlayerAngles (location.angles);
		player thread resetVelocity();
		
		player takeWeapon("rpg_mp");
		if (isDefined( level.trapsDisabled ) && level.trapsDisabled == false)
		{
			player giveWeapon ("deserteaglegold_mp");
			player giveMaxAmmo ("deserteaglegold_mp");
			player switchToWeapon ("deserteaglegold_mp");
		}
		player thread sr\api\_speedrun::finishWay("secret_0");

	}
}

//}

//activator TABLE//{
acti()
{
	thread actikillstreak();
	thread freeround_check();
	thread actirespawnfix();

	acti_cg = getEnt ("acti_cage", "targetname");
	acti_bt = getEnt ("acti_boat", "targetname");
	
	acti_antiglitch = getEnt ("acti_antiglitch_hurt", "targetname");
	acti_antiglitch enableLinkTo();
	acti_antiglitch linkTo(acti_cg);

	trig_trap1 = getEnt ("trig_trap1", "targetname");
	trig_trap2 = getEnt ("trig_trap2", "targetname");
	trig_trap3 = getEnt ("trig_trap3", "targetname");
	trig_trap4 = getEnt ("trig_trap4", "targetname");
	trig_trap5 = getEnt ("trig_trap5", "targetname");
	trig_trap6 = getEnt ("trig_trap6", "targetname");
	trig_trap7 = getEnt ("trig_trap7", "targetname");
	trig_trap8 = getEnt ("trig_trap8", "targetname");

	
	level waittill ("round_started");
	//trap1
	thread trap01();
	trig_trap1 waittill ("trigger", player);
	boatMove(2, 2, 90, player);
	//trap2
	thread trap02();
	trig_trap2 waittill ("trigger", player);
	boatMove(3, 2, 0, player);
	//trap3
	thread trap03();
	trig_trap3 waittill ("trigger", player);
	boatMove(4, 12, 3600, player);
	//trap4
	thread trap04();
	trig_trap4 waittill ("trigger", player);
	boatMove(5, 2, -90, player);
	//trap5
	thread trap05();
	trig_trap5 waittill ("trigger", player);
	boatMove(6, 10, 90, player);
	//trap6
	thread trap06();
	trig_trap6 waittill ("trigger", player);
	boatMove(7, 8, 90, player);
	//trap7
	thread trap07();
	trig_trap7 waittill ("trigger", player);
	boatMove(8, 3, 0, player);
	//trap8
	thread trap08();
}

freeround_check()
{
	acti_cg = getEnt ("acti_cage", "targetname");
	acti_bt = getEnt ("acti_boat", "targetname");
	
	trig = getEnt ("trig_freerunacti", "targetname");
	trig enableLinkTo();
	trig linkTo(acti_cg);
	
	level waittill("round_started");
	wait 6;
	if(isDefined( level.trapsDisabled ) && level.trapsDisabled == false){ trig delete();return 0; }
	
	trig setHintString ("^7Press ^9[ ^1&&1 ^9]^7 to ^2move^7!");
	//trap1
	trig waittill ("trigger", player);
	boatMove(2, 2, 90, player, trig, "^7Press ^9[ ^1&&1 ^9]^7 to ^2move^7!");
	//trap2
	trig waittill ("trigger", player);
	boatMove(3, 2, 0, player, trig, "^7Press ^9[ ^1&&1 ^9]^7 to ^2move^7!");
	//trap3
	trig waittill ("trigger", player);
	boatMove(4, 12, 3600, player, trig, "^7Press ^9[ ^1&&1 ^9]^7 to ^2move^7!");
	//trap4
	trig waittill ("trigger", player);
	boatMove(5, 2, -90, player, trig, "^7Press ^9[ ^1&&1 ^9]^7 to ^2move^7!");
	//trap5
	trig waittill ("trigger", player);
	boatMove(6, 10, 90, player, trig, "^7Press ^9[ ^1&&1 ^9]^7 to ^2move^7!");
	//trap6
	trig waittill ("trigger", player);
	boatMove(7, 8, 90, player, trig, "^7Press ^9[ ^1&&1 ^9]^7 to ^2move^7!");
	//trap7
	trig waittill ("trigger", player);
	boatMove(8, 3, 0, player, trig, "^7Press ^9[ ^1&&1 ^9]^7 to ^2move^7!");
}

boatMove(trap, duration, rotation, who, trigger, triggerText) // trigger is only used for freerun
{
	level endon ("endreached");
	level notify("boatMoved");
	
	acti_cg = getEnt ("acti_cage", "targetname");
	acti_bt = getEnt ("acti_boat", "targetname");
	
	acti_cg_loc = (0, 0, 64);
	acti_bt_loc = (0, 0, -16);
	
	acti_cg_rotate = true;
	acti_bt_rotate = true;
	
	allowLinking = false;
	allowJumping = false;
	
	trigDelBool = false;
	
	movingBool = true;
	
	offset = 0.1;
	offset2 = 0.2;
	
	while (movingBool)
	{
		switch(trap)
		{
			case 2:
				acti_cg_loc = (2192, 1472, 64);
				acti_bt_loc = (2192, 1472, -16);
				movingBool = false;
				break;
			case 3:
				acti_cg_loc = (2192, 2048, 64);
				acti_bt_loc = (2192, 2048, -16);
				movingBool = false;
				break;
			case 4:
				acti_cg_loc = (2192, 2048, 700);
				acti_bt_loc = (2192, 2048, 620);
				duration = duration/3;
				rotation = rotation/2;
				acti_cg_rotate = false;
				trap = 401;
				break;
			case 401:
				acti_cg_loc = (6208, 1568, 700);
				acti_bt_loc = (6208, 1568, 620);
				rotation = rotation*2;
				trap = 402;
				break;
			case 402:
				acti_cg_loc = (6208, 1568, 64);
				acti_bt_loc = (6208, 1568, -16);
				rotation = rotation/2;
				movingBool = false;
				break;
			case 5:
				acti_cg_loc = (6240, 2640, 64);
				acti_bt_loc = (6240, 2640, -16);
				movingBool = false;
				break;
			case 6:
				acti_cg_loc = (7384, 2640, 64);
				acti_bt_loc = (7384, 2640, -16);
				duration = duration/3;
				trap = 601;
				break;
			case 601:
				acti_cg_loc = (7384, 8224, 64);
				acti_bt_loc = (7384, 8224, -16);
				trap = 602;
				break;
			case 602:
				acti_cg_loc = (5048, 8224, 64);
				acti_bt_loc = (5048, 8224, -16);
				rotation = 0;
				movingBool = false;
				break;
			case 7:
				acti_cg_loc = (1504, 8224, 64);
				acti_bt_loc = (1504, 8224, -16);
				duration = duration/2;
				trap = 701;
				break;
			case 701:
				acti_cg_loc = (1504, 6040, 64);
				acti_bt_loc = (1504, 6040, -16);
				rotation = -90;
				movingBool = false;
				break;
			case 8:
				acti_cg_loc = (-160, 6040, 64);
				acti_bt_loc = (-160, 6040, -16);
				movingBool = false;
				trigDelBool = true;
				break;
			default:
				iPrintLnBold("boat fukd");
				movingBool = false;
				break;
		}
		if (isDefined(trigger) && isDefined(triggerText)) trigger setHintString("");
		if (allowLinking == true) who linkTo(acti_cg);
		if (allowJumping == false) who allowJump(false);
	
		acti_cg moveto(acti_cg_loc, duration);
		acti_bt moveto(acti_bt_loc, duration);
		if (acti_cg_rotate)
			acti_cg rotateYaw(rotation, duration);
		if (acti_bt_rotate)
			acti_bt rotateYaw(rotation, duration);
		wait duration+offset;
	}
	
	wait offset2;
	if (allowLinking == true) who unlink();
	if (allowJumping == false) who allowJump(true);
	if (isDefined(trigger) && isDefined(triggerText)) trigger setHintString(triggerText);
	if (isDefined(trigger) && trigDelBool == true) trigger delete();
}

actirespawnfix()
{
	respawn_cage = getEnt ("actirespawn_cage", "targetname");
	respawn_cage notSolid();
	
	level waittill ("boatMoved");
	wait 5;
	respawn_cage solid();
}

actikillstreak()
{
	level waittill("activator", activ);
	
	oldkillamount = activ.kills;
	level.activKills = 0;
	killsteakamount = 3;
	
	while (level.activKills<killsteakamount)
	{
		if (activ.kills > oldkillamount)
		{
			level.activKills++;
			oldkillamount = activ.kills;
		}
		
		wait .1;
	}
	if (isDefined(level.activ) && isAlive(level.activ) && level.activKills == 3)
	{
		iPrintLnBold ("^1Activator^7 got ^23^1 kills^7!");
		
		Obj = spawn("script_model", activ.origin);
		Obj setModel("tag_origin");
		Obj playSound ("triplekill");
		Obj delete();
		
		level.activKills = 0;
	}
}

//traps TABLE//{
trap01()
{
	trap1_1 = getEnt ("trap1_1", "targetname");
	trap1_2 = getEnt ("trap1_2", "targetname");
	trap1_3 = getEnt ("trap1_3", "targetname");
	trap1_4 = getEnt ("trap1_4", "targetname");
	trap1_1_hurt = getEnt ("trap1_1_hurt", "targetname");
	trap1_2_hurt = getEnt ("trap1_2_hurt", "targetname");
	trap1_3_hurt = getEnt ("trap1_3_hurt", "targetname");
	trap1_4_hurt = getEnt ("trap1_4_hurt", "targetname");
	trig = getEnt ("trig_trap1", "targetname");
	trig setHintString("^7Press ^9[ ^1&&1 ^9]^7 to ^1activate^7!");
	trig waittill ("trigger", player);
	iPrintLn("^1Trap 1 Activated!");
	trig delete();

	trap1_1_hurt enableLinkTo();
	trap1_2_hurt enableLinkTo();
	trap1_3_hurt enableLinkTo();
	trap1_4_hurt enableLinkTo();
	trap1_1_hurt linkTo(trap1_1);
	trap1_2_hurt linkTo(trap1_2);
	trap1_3_hurt linkTo(trap1_3);
	trap1_4_hurt linkTo(trap1_4);

	while(1)
	{
		trap1_1 rotateRoll (360,1);
		trap1_2 rotateRoll (360,1);
		trap1_3 rotateRoll (360,1);
		trap1_4 rotateRoll (360,1);
		wait 1.6;
	}
}

trap02()
{
	trap2 = getEnt ("trap2", "targetname");
	trig = getEnt ("trig_trap2", "targetname");
	trig setHintString("^7Press ^9[ ^1&&1 ^9]^7 to ^1activate^7!");
	trig waittill ("trigger", player);
	iPrintLn("^1Trap 2 Activated!");
	trig delete();

	while (1)
	{
		trap2 rotateYaw (360,2);
		wait 3;
	}
}

trap03()
{
	trap3 = getEnt ("trap3", "targetname");
	trap3_1 = getEnt ("trap3_1", "targetname");
	trig = getEnt ("trig_trap3", "targetname");
	trig setHintString("^7Press ^9[ ^1&&1 ^9]^7 to ^1activate^7!");
	trig waittill ("trigger", player);
	iPrintLn("^1Trap 3 Activated!");
	trig delete();

	r = randomIntRange(0, 2);
	if (r == 0)
	{
		trap3 notSolid();
		trap3 hide();
		wait 10;
		trap3 solid();
		trap3 show();
	}
	else
	{
		trap3_1 notSolid();
		trap3_1 hide();
		wait 10;
		trap3_1 solid();
		trap3_1 show();
	}
}

trap04()
{
	trap4_notSolid = getEnt ("trap4_notsolid", "targetname");
	trap4_1 = getEnt ("trap4_1", "targetname");
	trap4_2 = getEnt ("trap4_2", "targetname");
	trig = getEnt ("trig_trap4", "targetname");
	trig setHintString("^7Press ^9[ ^1&&1 ^9]^7 to ^1activate^7!");
	trig waittill ("trigger", player);
	iPrintLn("^1Trap 4 Activated!");
	trig delete();

	r = randomIntRange(0, 2);
	if (r == 1)
	{
		trap4_notSolid notSolid();
		trap4_1 notSolid();
	}
	else
	{
		trap4_notSolid notSolid();
		trap4_2 notSolid();
	}
}

trap05()
{
	trap5 = getEnt ("trap5", "targetname");
	trap5_hurt = getEnt ("trap5_hurt", "targetname");
	trig = getEnt ("trig_trap5", "targetname");
	trig setHintString("^7Press ^9[ ^1&&1 ^9]^7 to ^1activate^7!");
	trig waittill ("trigger", player);
	iPrintLn("^1Trap 5 Activated!");
	trig delete();

	trap5_hurt enableLinkTo();
	trap5_hurt linkTo(trap5);

	while (1)
	{
		trap5 rotatePitch (360,2);
		wait 2;
	}
}

trap06()
{
	trap6 = getEnt ("trap6", "targetname");
	trig = getEnt ("trig_trap6", "targetname");
	trig setHintString("^7Press ^9[ ^1&&1 ^9]^7 to ^1activate^7!");
	trig waittill ("trigger", player);
	iPrintLn("^1Trap 6 Activated!");
	trig delete();

	trap6 moveZ (-400, 2);
	wait 4;
	trap6 moveZ (400, 2);
}

trap07()
{
	trap7_1 = getEnt ("trap7_1", "targetname");
	trap7_2 = getEnt ("trap7_2", "targetname");
	trig = getEnt ("trig_trap7", "targetname");
	trig setHintString("^7Press ^9[ ^1&&1 ^9]^7 to ^1activate^7!");
	trig waittill ("trigger", player);
	iPrintLn("^1Trap 7 Activated!");
	trig delete();

	while(1)
	{
		trap7_1 moveY (90, 0.1);
		wait 1;
		trap7_1 moveY (-90, 0.1);
		wait 0.5;
		trap7_2 moveY (90, 0.1);
		wait 1;
		trap7_2 moveY (-90, 0.1);
		wait 0.5;
	}
}

trap08()
{
	trap8 = getEnt ("trap8", "targetname");
	trig = getEnt ("trig_trap8", "targetname");
	trig setHintString("^7Press ^9[ ^1&&1 ^9]^7 to ^1activate^7!");
	trig waittill ("trigger", player);
	iPrintLn("^1Trap 8 Activated!");
	trig delete();

	while (1)
	{
		trap8 rotateYaw(360, 1);
		wait 1.5;
		trap8 rotateYaw(-360, 1);
		wait 1.5;
	}
}
//}

//}

//end TABLE//{
endReached()
{
	trig = getEnt ("trig_endreached", "targetname");
	orig = getEnt ("orig_actiend", "targetname");
	
	trig waittill ("trigger", player);
	level notify("endreached");
	
	if (isDefined(level.activ) && isAlive(level.activ))
	{
		level.activ unlink();
		level.activ allowJump(true);
		
		level.activ setOrigin (orig.origin);
		level.activ setPlayerAngles (orig.angles);
		level.activ thread resetVelocity();
		
		level.activ iPrintLnBold ("^3Wait^7 here while the ^2Jumper^7 chooses the ^4room^7...");
	}
	thread endRoomsReached();
}

endRoomsReached()
{
	trig = getEnt ("endmap_trig", "targetname");
	
	trig waittill ("trigger", player);
	
	hud_end = NewHudElem();
	hud_end.alignX = "center";
	hud_end.alignY = "top";
	hud_end.horzalign = "center";
	hud_end.vertalign = "top";
	hud_end.alpha = 1;
	hud_end.x = 0;
	hud_end.y = 75;
	hud_end.font = "objective";
	hud_end.fontscale = 2;
	hud_end.glowalpha = 0;
	hud_end.glowcolor = (0,0,0);
	hud_end setText ("^7Congratz, ^4" + player.name + "^7 has finished ^31^7st!");
	hud_end SetPulseFX( 20, 3000, 200 );
	wait 3;
	hud_end destroy();
}

endTimer(text, duration, extra)
{
	self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );

	self freezeControls(1);

	wait extra;

	while (duration > 0)
	{
		self iPrintLnBold (duration);
		wait 1;
		duration--;
	}
	self iPrintLnBold(text);
	self freezeControls(0);
}

//old TABLE//{
old_room()
{
	level.trigger_old = getEnt ("trig_teleport_old", "targetname");

	oldjumper = getEnt ("orig_teleport_old_jumper", "targetname");
	oldacti = getEnt ("orig_teleport_old_activator", "targetname");

	while (1)
	{
		level.trigger_old setHintString ("^4Old ^7Room");
		level.trigger_old waittill ("trigger", player);
		level.trigger_old setHintString ("^4" + player.name + "^7 in room!");

		if(level.firstenter==true) {

			//level.trigger_old delete();
			level.trigger_knife delete();
			level.trigger_sniper delete();
			level.trigger_bounce delete();
			level.trigger_space delete();

			level.firstenter = false;
		}

		player setOrigin (oldjumper.origin);
		player setPlayerAngles (oldjumper.angles);
		player.maxhealth = 100;
		player thread endTimer("^1Fight!", 0, 0);
		
		if( isDefined(level.activ) && isAlive(level.activ))
		{
			level.activ setOrigin (oldacti.origin);
			level.activ setPlayerAngles (oldacti.angles);
			level.activ.maxhealth = 100;
			level.activ thread endTimer("^1Fight!", 0, 0);
		}
		iPrintLnBold( " ^4" + player.name + " ^7has chosen the ^4Old ^7Room!" );

		while( isAlive( player ) && isDefined( player ) )
            wait .05;

		iPrintLnBold ("^4" + player.name + " ^7has ^1died!" );
	}
	level.PlayerInRoom = false;
}
//}

//knife TABLE//{
knife_room()
{
	level.trigger_knife = getEnt ("trig_teleport_knife", "targetname");

	knifejumper = getEnt ("orig_teleport_knife_jumper", "targetname");
	knifeacti = getEnt ("orig_teleport_knife_activator", "targetname");

	while (1)
	{
		level.trigger_knife setHintString ("^4Knife ^7Room");
		level.trigger_knife waittill ("trigger", player);
		level.trigger_knife setHintString ("^4" + player.name + "^7 in room!");

		if(level.firstenter==true) {

			level.trigger_old delete();
			//level.trigger_knife delete();
			level.trigger_sniper delete();
			level.trigger_bounce delete();
			level.trigger_space delete();

			music = GetMusicFromArray("alias", "knife");
			music["song"] = "^3Knife song: " + music["song"];
			thread playMusic (music["alias"], music["length"], music["song"], false);
			//thread endmusic("knife", 195, "^3Knife Song: ^4Hollywood Undead - Whatever It Takes");
			level.firstenter = false;
		}

		player setOrigin (knifejumper.origin);
		player setPlayerAngles (knifejumper.angles);
		player takeAllWeapons();
		player giveWeapon( "knife_mp" );
		player giveWeapon("tomahawk_mp");
		player switchToWeapon("tomahawk_mp");
		player.maxhealth = 100;
		player thread endTimer("^1Fight!", 3, 0);

		if( isDefined(level.activ) && isAlive(level.activ))
		{
			level.activ setOrigin (knifeacti.origin);
			level.activ setPlayerAngles (knifeacti.angles);
			level.activ takeAllWeapons();
			level.activ giveWeapon( "knife_mp" );
			level.activ giveWeapon("tomahawk_mp");
			level.activ switchToWeapon("tomahawk_mp");
			level.activ.maxhealth = 100;
			level.activ thread endTimer("^1Fight!", 3, 0);
		}
		iPrintLnBold( " ^4" + player.name + " ^7has chosen the ^4Knife ^7Room!" );

		while( isAlive( player ) && isDefined( player ) )
            wait .05;

		iPrintLnBold ("^4" + player.name + " ^7has ^1died!" );
	}
	level.PlayerInRoom = false;
}
//}

//sniper TABLE//{
sniper_room()
{
	level.trigger_sniper = getEnt ("trig_teleport_sniper", "targetname");

	sniperjumper = getEnt ("orig_teleport_sniper_jumper", "targetname");
	sniperacti = getEnt ("orig_teleport_sniper_activator", "targetname");

	while (1)
	{
		level.trigger_sniper setHintString ("^4Sniper ^7Room");
		level.trigger_sniper waittill ("trigger", player);
		level.trigger_sniper setHintString ("^4" + player.name + "^7 in room!");

		if(level.firstenter==true) {

			level.trigger_old delete();
			level.trigger_knife delete();
			//level.trigger_sniper delete();
			level.trigger_bounce delete();
			level.trigger_space delete();

			music = GetMusicFromArray("alias", "sniper");
			music["song"] = "^3Sniper song: " + music["song"];
			thread playMusic (music["alias"], music["length"], music["song"], false);
			//thread endmusic("sniper", 213, "^3Sniper Song: ^4Happoradio - Che Guevara");
			thread NukeTrigger();
			level.firstenter = false;
		}

		player setOrigin (sniperjumper.origin);
		player setPlayerAngles (sniperjumper.angles);
		player takeAllWeapons();
		player giveWeapon( "m40a3_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		player giveWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );
		player switchToWeapon( "m40a3_mp" );
		player.maxhealth = 100;
		player thread endTimer("^1Fight!", 3, 0);

		player.hasNukeBullets = false;
		player notify("nukeSTOP");

		if( isDefined(level.activ) && isAlive(level.activ))
		{
			level.activ setPlayerAngles(sniperacti.angles);
			level.activ setOrigin(sniperacti.origin);
			level.activ takeAllWeapons();
			level.activ giveWeapon( "m40a3_mp" );
			level.activ giveMaxAmmo( "m40a3_mp" );
			level.activ giveWeapon( "remington700_mp" );
			level.activ giveMaxAmmo( "remington700_mp" );
			level.activ switchToWeapon( "m40a3_mp" );
			level.activ.maxhealth = 100;
			level.activ thread endTimer("^1Fight!", 3, 0);

			level.activ.hasNukeBullets = false;
			level.activ notify("nukeSTOP");
		}
		iPrintLnBold( " ^4" + player.name + " ^7has chosen the ^4Sniper ^7Room!" );

		while( isAlive( player ) && isDefined( player ) )
            wait .05;

		iPrintLnBold ("^4" + player.name + " ^7has ^1died!" );
	}
	level.PlayerInRoom = false;
}

NukeTrigger()
{
	trig = getEnt ("trig_sniper_nuke", "targetname");
	trig setHintString ("^1Nuke bullets");

	while (1)
	{
		trig waittill ("trigger", player);
		if (player.hasNukeBullets == false)
		{
			player thread NukeBullets();
			player iPrintLnBold ("You got ^1Nuke^7 Bullets!");

			player.hasNukeBullets = true;
		}
		else
		{
			player iPrintLnBold ("You already got ^1Nuke^7 Bullets!");
		}
	}
}

NukeBullets()
{
self endon("death");
self endon("nukeSTOP");

	for (;;)
	{
		self waittill("weapon_fired");

		my = self gettagorigin("j_head");
		trace=bullettrace(my, my + anglestoforward(self getplayerangles())*100000,true,self)["position"];

		Obj = spawn("script_model", trace);
		Obj setModel("tag_origin");
		Obj playSound("artillery_impact");
		playFX(level.expbullt,obj.origin);
		playFX( level.flame, obj.origin );
		radiusDamage( obj.origin, 100, 200, 100, self );
		earthquake( 1, 1, obj.origin, 200 );

		obj delete();

		wait 0.5;
	}
}


//}

//bounce TABLE//{
bounce_room()
{
	level.trigger_bounce = getEnt ("trig_teleport_bounce", "targetname");

	bouncejumper = getEnt ("orig_teleport_bounce_jumper", "targetname");
	bounceacti = getEnt ("orig_teleport_bounce_activator", "targetname");

	while (1)
	{
		level.trigger_bounce setHintString ("^4Bounce ^7Room");
		level.trigger_bounce waittill ("trigger", player);
		level.trigger_bounce setHintString ("^4" + player.name + "^7 in room!");

		if(level.firstenter==true) {

			level.trigger_old delete();
			level.trigger_knife delete();
			level.trigger_sniper delete();
			//level.trigger_bounce delete();
			level.trigger_space delete();

			music = GetMusicFromArray("alias", "bounce");
			music["song"] = "^3Bounce song: " + music["song"];
			thread playMusic (music["alias"], music["length"], music["song"], false);
			//thread endmusic("bounce", 335, "^3Bounce Song: ^4Red Hot Chili Peppers - Snow");
			thread bounce_fail();
			thread bounce_weapon();
			level.firstenter = false;
		}

		player setOrigin (bouncejumper.origin);
		player setPlayerAngles (bouncejumper.angles);
		player takeAllWeapons();
		player giveWeapon( "knife_mp" );
		player switchToWeapon ( "knife_mp" );
		player.maxhealth = 100;
		player thread endTimer("^1Go!", 3, 0);

		player notify ("bounce_checkpointSTOP"); //stops old checkpoint threads
		player thread bounce_failCheckpoints();
		player.hasGottenBounceWeapon = false;

		if( isDefined(level.activ) && isAlive(level.activ))
		{
			level.activ setPlayerAngles(bounceacti.angles);
			level.activ setOrigin(bounceacti.origin);
			level.activ takeAllWeapons();
			level.activ giveWeapon( "knife_mp" );
			level.activ switchToWeapon( "knife_mp" );
			level.activ.maxhealth = 100;
			level.activ thread endTimer("^1Go!", 3, 0);

			level.activ notify ("bounce_checkpointSTOP"); //stops old checkpoint threads
			level.activ thread bounce_failCheckpoints();
			level.activ.hasGottenBounceWeapon = false;
		}
		iPrintLnBold( " ^4" + player.name + " ^7has chosen the ^4Bounce ^7Room!" );

		level notify("Bouncehudstop"); //stops old bouncehud threads
		thread bouncehud(player, level.activ);

		while( isAlive( player ) && isDefined( player ) )
            wait .05;

		iPrintLnBold ("^4" + player.name + " ^7has ^1died!" );
	}
	level.PlayerInRoom = false;
}

bounce_fail()
{
	trig = getEnt ("trig_bounce_fail", "targetname");

	while (1)
	{
		trig waittill ("trigger", player);

		player thread bounce_failTeleport(player.bounce_failPosition);
	}
}

bounce_failCheckpoints()
{
	self endon("death");
	self endon("disconnect");
	self endon("bounce_checkpointSTOP");

	//JUMPER
	jumperTrigger0 = getEnt ("trig_teleport_bounce_jumper", "targetname");
	jumperTrigger1 = getEnt ("trig_teleport_bounce_jumper1", "targetname");
	jumperTrigger2 = getEnt ("trig_teleport_bounce_jumper2", "targetname");
	jumperTrigger3 = getEnt ("trig_teleport_bounce_jumper3", "targetname");
	jumperTrigger4 = getEnt ("trig_teleport_bounce_jumper4", "targetname");
	jumperTrigger5 = getEnt ("trig_teleport_bounce_jumper5", "targetname");

	//ACTIVATOR
	activatorTrigger0 = getEnt ("trig_teleport_bounce_activator", "targetname");
	activatorTrigger1 = getEnt ("trig_teleport_bounce_activator1", "targetname");
	activatorTrigger2 = getEnt ("trig_teleport_bounce_activator2", "targetname");
	activatorTrigger3 = getEnt ("trig_teleport_bounce_activator3", "targetname");
	activatorTrigger4 = getEnt ("trig_teleport_bounce_activator4", "targetname");
	activatorTrigger5 = getEnt ("trig_teleport_bounce_activator5", "targetname");

	if (!isDefined(level.activ) || self != level.activ) //checks if self is not activator
	{
		self.bounce_failPosition = 10;
		while (1)
		{
			switch(self.bounce_failPosition)
			{
				case 10:
					jumperTrigger1 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 11;
					player iPrintLn("Position 1 saved");
					break;
				case 11:
					jumperTrigger2 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 12;
					player iPrintLn("Position 2 saved");
					break;
				case 12:
					jumperTrigger3 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 13;
					player iPrintLn("Position 3 saved");
					break;
				case 13:
					jumperTrigger4 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 14;
					player iPrintLn("Position 4 saved");
					break;
				case 14:
					jumperTrigger5 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 15;
					player iPrintLn("Position 5 saved");
					break;
				default:
					jumperTrigger0 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 10;
					player iPrintLn("Position 0 saved");
					break;
			}
		}
	}
	else if (isDefined(level.activ) && self == level.activ) //checks if self is activator
	{
		self.bounce_failPosition = 20;
		while (1)
		{
			switch(self.bounce_failPosition)
			{
				case 20:
					activatorTrigger1 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 21;
					player iPrintLn("Position 1 saved");
					break;
				case 21:
					activatorTrigger2 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 22;
					player iPrintLn("Position 2 saved");
					break;
				case 22:
					activatorTrigger3 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 23;
					player iPrintLn("Position 3 saved");
					break;
				case 23:
					activatorTrigger4 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 24;
					player iPrintLn("Position 4 saved");
					break;
				case 24:
					activatorTrigger5 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 25;
					player iPrintLn("Position 5 saved");
					break;
				default:
					activatorTrigger0 waittill ("trigger", player);
					if(player != self){player iPrintLnBold("^1Come back through the front door next time! >:o");player suicide();break;}
					player.bounce_failPosition = 20;
					player iPrintLn("Position 0 saved");
					break;
			}
		}
	}
}

bounce_failTeleport(value)
{
	//JUMPER
	jumperOrigin0 = getEnt ("orig_teleport_bounce_jumper", "targetname");
	jumperOrigin1 = getEnt ("orig_teleport_bounce_jumper1", "targetname");
	jumperOrigin2 = getEnt ("orig_teleport_bounce_jumper2", "targetname");
	jumperOrigin3 = getEnt ("orig_teleport_bounce_jumper3", "targetname");
	jumperOrigin4 = getEnt ("orig_teleport_bounce_jumper4", "targetname");
	jumperOrigin5 = getEnt ("orig_teleport_bounce_jumper5", "targetname");

	//ACTIVATOR
	activatorOrigin0 = getEnt ("orig_teleport_bounce_activator", "targetname");
	activatorOrigin1 = getEnt ("orig_teleport_bounce_activator1", "targetname");
	activatorOrigin2 = getEnt ("orig_teleport_bounce_activator2", "targetname");
	activatorOrigin3 = getEnt ("orig_teleport_bounce_activator3", "targetname");
	activatorOrigin4 = getEnt ("orig_teleport_bounce_activator4", "targetname");
	activatorOrigin5 = getEnt ("orig_teleport_bounce_activator5", "targetname");

	if (!isDefined(level.activ) || self != level.activ) //checks if self is not activator
	{
		switch(value)
		{
			case 10:
				self setOrigin (jumperOrigin0.origin);
				self setPlayerAngles (jumperOrigin0.angles);
				self thread resetVelocity();
				break;
			case 11:
				self setOrigin (jumperOrigin1.origin);
				self setPlayerAngles (jumperOrigin1.angles);
				self thread resetVelocity();
				break;
			case 12:
				self setOrigin (jumperOrigin2.origin);
				self setPlayerAngles (jumperOrigin2.angles);
				self thread resetVelocity();
				break;
			case 13:
				self setOrigin (jumperOrigin3.origin);
				self setPlayerAngles (jumperOrigin3.angles);
				self thread resetVelocity();
				break;
			case 14:
				self setOrigin (jumperOrigin4.origin);
				self setPlayerAngles (jumperOrigin4.angles);
				self thread resetVelocity();
				break;
			case 15:
				self setOrigin (jumperOrigin5.origin);
				self setPlayerAngles (jumperOrigin5.angles);
				self thread resetVelocity();
				break;
			default:
				self iPrintLn ("No position is saved!");
				iPrintLnBold ("There is a ^1bug^7 within jump room! ^1Executing...");
				self suicide();
				break;
		}
	}
	else if (isDefined(level.activ) && self == level.activ) //checks if self is activator
	{
		switch(value)
		{
			case 20:
				self setOrigin (activatorOrigin0.origin);
				self setPlayerAngles (activatorOrigin0.angles);
				self thread resetVelocity();
				break;
			case 21:
				self setOrigin (activatorOrigin1.origin);
				self setPlayerAngles (activatorOrigin1.angles);
				self thread resetVelocity();
				break;
			case 22:
				self setOrigin (activatorOrigin2.origin);
				self setPlayerAngles (activatorOrigin2.angles);
				self thread resetVelocity();
				break;
			case 23:
				self setOrigin (activatorOrigin3.origin);
				self setPlayerAngles (activatorOrigin3.angles);
				self thread resetVelocity();
				break;
			case 24:
				self setOrigin (activatorOrigin4.origin);
				self setPlayerAngles (activatorOrigin4.angles);
				self thread resetVelocity();
				break;
			case 25:
				self setOrigin (activatorOrigin5.origin);
				self setPlayerAngles (activatorOrigin5.angles);
				self thread resetVelocity();
				break;
			default:
				self iPrintLn ("No position is saved!");
				iPrintLnBold ("There is a ^1bug^7 within jump room! ^1Executing...");
				self suicide();
				break;
		}
	}
}

bounce_weapon()
{
	trig = getEnt ("trig_bounce_weapon", "targetname");
	trig setHintString ("^7Press ^9[ ^1&&1 ^9]^7 to get a weapon!");

	while (1)
	{
	trig waittill ("trigger", player);
	player takeAllWeapons();
	player giveWeapon( "m40a3_mp" );
	player giveMaxAmmo( "m40a3_mp" );
	player giveWeapon( "deserteagle_mp" );
	player giveMaxAmmo ( "deserteagle_mp" );
	player switchToWeapon( "m40a3_mp" );

	if (isDefined(level.activ) && player == level.activ && player.hasGottenBounceWeapon == false)
		{
			iPrintLnBold ("The ^1Activator^7 has gotten the ^1weapon!");
			player.hasGottenBounceWeapon = true;
		}
		else if (player.hasGottenBounceWeapon == false)
		{
			iPrintLnBold ("The ^2Jumper^7 has gotten the ^1weapon!");
			player.hasGottenBounceWeapon = true;
		}
		wait 0.1;
	}
}

bouncehud(jumper, activator)
{
level endon("Bouncehudstop");

if (isDefined(level.jumperbouncehud))
	level.jumperbouncehud destroy();
if (isDefined(level.actibouncehud))
	level.actibouncehud destroy();

level.jumperbouncehud = createhud(-20, -100, "Right", "Bottom");
level.actibouncehud = createhud(-20, -80, "Right", "Bottom");

thread bouncehudcounter(jumper, activator);
}

bouncehudcounter(jumper, activator)
{
	level endon("Bouncehudstop");

	jcounter_canproceed = true;
	acounter_canproceed = true;

	jumperOffset = -10;
	actiOffset = -20;

	while(jcounter_canproceed || acounter_canproceed)
	{
		//JUMPER
		if (jcounter_canproceed)
		{
			if (isDefined(jumper) && jcounter_canproceed)
			{
				if (isAlive(jumper))
				{
					if (isDefined(jumper.hasGottenBounceWeapon) && jumper.hasGottenBounceWeapon == true)
						level.jumperbouncehud setText("Jumper^2(" + jumper.name + ")^1 has gotten the weapon!");
					else if (isDefined(jumper.bounce_failPosition))
						level.jumperbouncehud setText("Jumper^2(" + jumper.name + ")^1 Position:^5 " + (jumper.bounce_failPosition + jumperOffset));
				}
				else if (isAlive(jumper) == false)
				{
					level.jumperbouncehud setText("Jumper^2(" + jumper.name + ")^1 is Dead!");
					jcounter_canproceed = false;
				}
			}
			else
			{
				level.jumperbouncehud setText("Jumper^2(" + jumper.name + ")^1 not defined!");
				jcounter_canproceed = false;
			}
		}

		//ACTIVATOR
		if (acounter_canproceed)
		{
			if (isDefined(activator))
			{
				if (isAlive(activator))
				{
					if (isDefined(activator.hasGottenBounceWeapon) && activator.hasGottenBounceWeapon == true)
						level.actibouncehud setText("Activator^2(" + activator.name + ")^1 has gotten the weapon!");
					else if (isDefined(activator.bounce_failPosition))
						level.actibouncehud setText("Activator^2(" + activator.name + ")^1 Position:^5 " + (activator.bounce_failPosition + actiOffset));
				}
				else if (isAlive(activator) == false)
				{
					level.actibouncehud setText("Activator^2(" + activator.name + ")^1 is Dead!");
					acounter_canproceed = false;
				}
			}
			else
			{
				level.actibouncehud setText("Activator^2(not defined!)");
				acounter_canproceed = false;
			}
		}
		wait .05;
	}
	level notify("Bouncehudstop");
}

//}

//space TABLE//{
space_room()
{
	level.trigger_space = getEnt ("trig_teleport_space", "targetname");

	spacejumper = getEnt ("orig_teleport_space_jumper", "targetname");
	spaceacti = getEnt ("orig_teleport_space_activator", "targetname");

	while (1)
	{
		level.trigger_space setHintString ("^4Space ^7Room");
		level.trigger_space waittill ("trigger", player);
		level.trigger_space setHintString ("^4" + player.name + "^7 in room!");

		if(level.firstenter==true) {

			level.trigger_old delete();
			level.trigger_knife delete();
			level.trigger_sniper delete();
			level.trigger_bounce delete();
			//level.trigger_space delete();

			music = GetMusicFromArray("alias", "space");
			music["song"] = "^3Space song: " + music["song"];
			thread playMusic (music["alias"], music["length"], music["song"], false);
			//thread endmusic("space", 335, "^3Space Song: ^4BEACH HOUSE // Space Song");
			level.firstenter = false;
		}

		player setOrigin (spacejumper.origin);
		player setPlayerAngles (spacejumper.angles);

		player thread superpower(500, 10, 3, true);

		if( isDefined(level.activ) && isAlive(level.activ))
		{
			level.activ setPlayerAngles(spaceacti.angles);
			level.activ setOrigin(spaceacti.origin);

			level.activ thread superpower(500, 10, 3, true);
		}
		iPrintLnBold( " ^4" + player.name + " ^7has chosen the ^4Space ^7Room!" );

		while( isAlive( player ) && isDefined( player ) )
            wait .05;

		iPrintLnBold ("^4" + player.name + " ^7has ^1died!" );
	}
	level.PlayerInRoom = false;
}

superpower(s_maxhealth, s_jumpheight, s_movespeed, s_endgame)
{
	self.maxhealth = s_maxhealth;
	self.health = self.maxhealth;
	self notify("jumpheight_stop"); //stops old jumpheight threads
	self thread jumpheight( s_jumpheight );
	self SetMoveSpeedScale( s_movespeed );

	if (s_endgame == true)
	{
		self thread shoot();

		weapon = "knife_mp";
		self takeAllWeapons();
		self giveWeapon( weapon );
		self giveMaxAmmo( weapon );
		self switchToWeapon( weapon );
		wait(0.05);
		self setViewModel( "viewmodel_hands_zombie" );
		wait(0.05);
		self iPrintLnBold("Hold ^1Fire ^7to use your powers !"); //Change the message if you want
	}
}

jumpheight( strength )
{
	self endon("disconnect");
	self endon("death");
	self endon("jumpheight_stop");
	level endon("game over");

	oldpos = self.origin;
	jumped = false;

	if( isDefined( strength ) == false || strength < 1 )
		strength = 1;

	while(1)
	{
		if((self.origin[2] - oldpos[2] ) > 10  && self IsOnGround() == false && jumped == false)
		{
			if(jumped)
				continue;
			for(i=0;i<strength;i++)
			{
				self.health += 100;
				self finishPlayerDamage(self, level.jumpattacker, 100, 0, "MOD_FALLING", "shock_mp", self.origin, AnglesToForward((-90,0,0)), "none", 0);
			}
			jumped = true;
		}
		else if(oldpos[2] > self.origin[2] && self IsOnGround() && jumped)
			jumped = false;
		oldpos = self.origin;
		wait 0.1;
	}
}


shoot()
{
	self endon("disconnect");
	self endon("death");
	level endon("game over");

	delay = 0.5;

	while(1)
	{
		if( self AttackButtonPressed())
		{
			self thread PsionicExplosion02();
		}
		wait delay;
	}
}

PsionicExplosion01()//NOT IN USE
{
	Obj = spawn("script_model", self GetEye()+AnglesToForward( self GetPlayerAngles() )*30 );
	Obj setModel("tag_origin");
	Obj.angles = self GetPlayerAngles();
	wait 0.05;

	//obj playSound("fire_cast");
	//obj playLoopSound("firewall");

	while(1)
	{
		target = obj.origin+AnglesToForward( obj.angles )*550;
		obj MoveTo( target, 0.1);
		if( !BulletTracePassed( obj.origin, target, true, self ) )
			break;
		wait 0.1;
	}
	Obj playSound("explo_metal_rand");

	playFX( level.expbullt, obj.origin );
	playFX( level.flame, obj.origin );

	earthquake( 1, 1, obj.origin, 600 );
	radiusDamage( obj.origin, 400, 100, 30, self );
	obj delete();
}

PsionicExplosion02()
{
self endon("death");

my = self gettagorigin("j_head");
trace=bullettrace(my, my + anglestoforward(self getplayerangles())*100000,true,self)["position"];

Obj = spawn("script_model", trace);
Obj setModel("tag_origin");
Obj playSound("artillery_impact");
playFX(level.expbullt,obj.origin);
playFX( level.flame, obj.origin );
dis=distance(self.origin, obj.origin);
if (dis>101)
radiusDamage( obj.origin, 150, 50, 25, self );
else
radiusDamage( obj.origin, 150, 75, 50, self );
earthquake( 0.25, 1, obj.origin, 600 );

obj delete();
}
//}

//}

//custom function TABLE//{
GetActivator()
{
	players = getEntArray( "player", "classname" );

	for(i = 0;i < players.size;i++)
	{
		player = players[i];

		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}

	return "Noactivator";
}

GetPlayer(gamertag)
{
	players = getEntArray( "player", "classname" );

	for(i = 0;i < players.size;i++)
	{
		player = players[i];

		if( isdefined( player ) && isplayer( player ) && isSubStr( toLower(player.name), toLower(gamertag) ))
			return player;
	}

	return "Noplayer";
}

GetPlayerGuid(target)
{
	guid = target getGuid();
	guid = getSubStr( guid, 24, 32 );
	return guid;
}

GetMusicFromArray(searchBy, search)
{
	for(i=0;i<level.music.size;i++)
	{
		if (level.music[i][searchBy] == search)
		{
			music = level.music[i];
			return music;
		}
	}
	return "Nomusic";
}

iPrintCustom(content,bold,waitTime) //content = string to print, bold = true/false, waitTime = wait amount (int)
{
	wait waitTime;
	if (bold == true)
		iPrintLnBold(content);
	else
		iPrintLn(content);
}

resetVelocity()
{
	self freezeControls(true);
	wait 0.05;
	self freezeControls(false);
}

createhud(x,y,alignX,alignY)
{
hud = newHudElem();
hud.x = x;
hud.y = y;
hud.alignX = alignX;
hud.alignY = alignY;
hud.horzAlign = alignX;
hud.vertAlign = alignY;
hud.font = "default";
hud.archived = false;
hud.fontScale = 1.6;
hud.color = (1,0,0);
return hud;
}

quack()
{
	air = spawn ("script_model",(0,0,0));
	air.origin = self.origin;
	air.angles = self.angles;

	air linkTo (self);

	air playLoopSound("quack");

	self iPrintLn ("Press [G] to stop quacking");

	for (;;)
	{
		if (self FragButtonPressed())
		{
			air delete();
			break;
		}
		playFX (level.quak, air.origin);

		wait .1;
	}
}

stringContains(player, target)
{
	boolean = false;
	
	for (i=0; i<player.size; i++)
	{
		if (toLower(player[i]) == toLower(target[0]))
		{
			if (player.size - i >= target.size)
			{
				for(o=0; o<target.size; o++)
				{
					if (toLower(player[i+o]) == toLower(target[o]))
					{
						boolean = true;
					}
					else
					{
						boolean = false;
					}
				}
			}
		}
	}
	return boolean;
}

//}

//debug TABLE//{
debug()
{
	//thread debug1();
}

debug1()
{
	trig = getEnt ("trig_debug1", "targetname");
	trig setHintString ("DEBUG1");
	for (;;)
	{
		wait .5;
		trig waittill ("trigger", player);

		//content
		orig = getEnt ("orig_outset_island", "targetname");
		player setOrigin (orig.origin);
		player setPlayerAngles (orig.angles);
	}
}

//}
