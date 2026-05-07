//map by #FNRP#Brotter //

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
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	//precacheItem( "m1014_mp" );
	//precacheShader( "rm_rick" );
	//precacheShader( "rm_eye" );
	//precacheModel( "rick_model" );
	//precacheshader("mtl_chucky_head");
	//precacheshader("mtl_chucky_eyes");
	//precacheshader("mtl_chucky_body");
	//precacheModel("plr_terry_chucky");

	//Music
	if(!isdefined(level.music))
	level.music=[];
	level.music[0]["song"] = "Smash Mouth by Justus";
	level.music[0]["alias"] = "song1";
	level.music[1]["song"] = "Believer by Aya";
	level.music[1]["alias"] = "song2";
	level.music[2]["song"] = "Porque Special by Bangzor";
	level.music[2]["alias"] = "song3";
	level.music[3]["song"] = "Deez Nuts by MAXIMVS";
	level.music[3]["alias"] = "song4";
	level.music[4]["song"] = "Rumble by Emily";
	level.music[4]["alias"] = "song5";
	level.music[5]["song"] = "The Coconut Song by MAXIMVS";
	level.music[5]["alias"] = "song6";

	thread sr\api\_map::createSpawn((606, -190, 1100),90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((-3786.44, 7631.68, 778.125), 165,120, "normal_0");  

	thread jumper_startdoor();
	
	// Traps
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	//thread trap11();
	//thread trapxp();

	addTriggerToList( "trig1" );
	addTriggerToList( "trig2" );
	addTriggerToList( "trig3" );
	addTriggerToList( "trig4" );
	addTriggerToList( "trig5" );
	addTriggerToList( "trig6" );
	addTriggerToList( "trig7" );
	addTriggerToList( "trig8" );
	addTriggerToList( "trig9" );
	addTriggerToList( "trig10" );

	//thread deagle();
	//thread sniper();
	//thread knife();
	//thread shotgun();

	//thread acti_startdoor();
	//thread musicBox();
	//thread start_messages();
	//thread mover();
	//thread sniperroomtele();

	//thread jumperskin();
	//thread actiskin();
	//thread messages1(); 
	//thread leftmessages();
}

//credits

leftmessages()
{
	while(1)
	{
		wait 20;
		iprintln("^3 Map Made by ^2#FNRP#Brotter");
		wait 3;
		iprintln("^3 Special Thanks to ^1#FNRP#Adam For Scripts");
		wait 3;
		iprintln("^3 Special Thanks to ^1#FNRP#Blu For Skins");
		wait 3;
		iprintln("^3 Special Thanks to ^1Glenbob For Earthquake");
		wait 3;
		iprintln("^3 Special Thanks to ^1Speedex For Script/Design");
		wait 3;
		iprintln("^3 Special Thanks to ^6#FNRP#Aya For Textures");
		wait 3;
		iprintln("^3 Thanks to ^1#FNRP#Macbook For Support");
		wait 3;
		iprintln("^3 Thanks to ^5FNRP-Muffinator For Support");
	}
}

//trigger for points or xps whatever.

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

//skins

jumperskin()
{
	for(;;)
	{
		level waittill( "player_spawn", player );
		player detachAll();
		player setmodel("plr_terry_chucky");
	}
}

actiskin()
{ 
	while(1)
	{
		wait 0.05;
		if(isDefined(level.activ) && isAlive(level.activ))
		{
			level.activ detachAll();
			level.activ setmodel("rick_model");
		}
	}
}

acti_startdoor()
{
    level waittill("round_started");
    wait 1;

    door = getEnt("startdoor_acti", "targetname");
    door moveZ(-500, 2);
    wait 1;
    door delete();
}

jumper_startdoor()
{
    door = getEnt("startdoor_jumper", "targetname");
   
    door delete();
}

start_messages()
{
    level waittill("round_started");
    wait 3;

	players = getentarray("player","classname");
	for(i=0;i<=players.size -1;i++)
	{
		if(players[i].team == "axis"){
			players[i] iPrintLnBold("^2Go ^1Kill ^4Em ^5Boi");
		} 
        else {
			players[i] iPrintLnBold("^1Run ^2You ^0Lab Rats"); 
		}
	}
}

trap1()
{
	trap1_trig= getEnt( "trig1", "targetname"); //trigger
	trap1_trig SetHintString("^1pssst ^2press ^3the ^0BUTTON ^4I ^6DARE ^9YOU");
	trap1_trig waittill ("trigger", player);
	
}

trap2()
{
	trap2_trig= getEnt( "trig2", "targetname"); //trigger
	trap2_trig SetHintString("^1This ^2Time ^3It'll ^5Work");
	trap2_trig waittill ("trigger", player);
	
}

trap3()
{
	trap3_trig= getEnt( "trig3", "targetname"); //trigger
	trapplatform = getEnt( "trap3", "targetname"); //the platform
	trap3_trig SetHintString("^1K ^2This ^3Time ^5For ^6Real, ^9It'll ^7Work");
	trap3_trig waittill ("trigger", player);
	
}

trap4()
{
	trap4_trig= getEnt( "trig4", "targetname"); //trigger

	hurt_trig= getEnt( "hurttrig", "targetname"); //the platform
	leftdoor = getEnt( "lefttrig", "targetname"); //the platform
	rightdoor = getEnt( "righttrig", "targetname"); //the platform
	earthquake = getEnt("og_earthquake", "targetname");

	trap4_trig SetHintString("^1They ^2See ^3Me ^9Squishin ^7They ^0Hatin");
	trap4_trig waittill ("trigger", player);

}

trap5()
{
	trap5_trig= getEnt( "trig5", "targetname"); //trigger
	platform= getEnt( "platform1", "targetname"); //the platform
	trap5_trig SetHintString("^2Make ^3Em ^4Fall");
	trap5_trig waittill ("trigger", player);
	
}

trap6()
{
	trap6_trig= getEnt( "trig6", "targetname"); //trigger
	platform= getEnt( "platform2", "targetname"); //the platform
	trap6_trig SetHintString("^2They ^3All ^4Go ^5Round");
	trap6_trig waittill ("trigger", player);
	
}

trap7()
{
	trap7_trig= getEnt( "trig7", "targetname"); //trigger
	trap7_trig SetHintString("^2You ^4Just ^3Have ^5To ^6Press ^8Me :3");
	trap7_trig waittill ("trigger", player);
	
}

trap8()
{
	trap8_trig= getEnt( "trig8", "targetname"); //trigger
	platform= getEnt( "platform4", "targetname"); //the platform
	trap8_trig SetHintString("^2Acti ^5Spin ^3That ^4Shit");
	trap8_trig waittill ("trigger", player);

}

trap9()
{
	trap9_trig= getEnt( "trig9", "targetname"); //trigger
	mover1= getent("mover1","targetname");
	mover1trig = getent("movertrig1","targetname");
	trapplatform = getEnt( "trap9", "targetname"); //the platform
	mover1 hide();
	mover1 notsolid();
	trap9_trig SetHintString("^1pst ^2Pwess ^3Da ^5:3");
	trap9_trig waittill ("trigger", player);
	
}



trap10()
{
	trap8_trig= getEnt( "trig10", "targetname"); //trigger
	platform1= getEnt( "plat1", "targetname"); //the platform
	platform2= getEnt( "plat2", "targetname"); //the platform
	platform3= getEnt( "plat3", "targetname"); //the platform
	platform4= getEnt( "plat4", "targetname"); //the platform
	platform5= getEnt( "plat5", "targetname"); //the platform
	platform6= getEnt( "plat6", "targetname"); //the platform
	trap8_trig SetHintString("^2They ^3All ^4Go ^5Round");
	trap8_trig waittill ("trigger", player);
	
}

//trigger xp

trapxp()
{
	trapxp= getEnt( "trig11", "targetname"); //trigger
	trapxp SetHintString("^1pssst ^2press ^3the ^0BUTTON ^4I ^6DARE ^9YOU ^6HeHe");
	trapxp waittill ("trigger", player);
	trapxp delete();
	player braxi\_rank::giveRankXP("", 2000);
	iPrintLnBold("^1Activator ^3got 2k ^5for ^8doing ^3NOTHING");
}

//trap 11

trap11()
{
	platform1= getEnt( "mplat1", "targetname"); //the platform
	platform2= getEnt( "mplat2", "targetname"); //the platform
	platform3= getEnt( "mplat3", "targetname"); //the platform
	platform4= getEnt( "mplat4", "targetname"); //the platform
	platform5= getEnt( "mplat5", "targetname"); //the platform
	platform6= getEnt( "mplat6", "targetname"); //the platform
	platform7= getEnt( "mplat7", "targetname"); //the platform
	while(1)
	{
		platform1 moveX(544, 3);
		platform2 moveX(-544, 3);
		platform3 moveX(544, 3);
		platform4 moveX(-544, 3);
		platform5 moveX(544, 3);
		platform6 moveX(-544, 3);
		platform7 moveX(544, 3);
		wait(3);
		platform1 moveX(-544, 3);
		platform2 moveX(544, 3);
		platform3 moveX(-544, 3);
		platform4 moveX(544, 3);
		platform5 moveX(-544, 3);
		platform6 moveX(544, 3);
		platform7 moveX(-544, 3);
		wait(3);
	}
}


//platform to the room selection area

mover()
{
	mover= getent("mover","targetname");
	movertrig = getent("movertrig","targetname");
	movertrig waittill ("trigger", player);
	while(1)
	{ 
		mover moveY(-2912, 0.5);
		wait(3);
		mover moveY(2912, 0.5);
		wait(3);
	}
}

//Music

musicBox()
{
	trig = getEnt("trig_musicbox","targetname");
	trig setHintString("Press &&1^7 to select Music");
	trig waittill("trigger",p);
	p braxi\_rank::giveRankXP("", 50);
	trig delete();

	p freezeControls(1);
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
	self.hud_music[i] setText("Porque!");
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
			
			iPrintLn("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
			//thread jumper_startdoor();
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

//rooms

//deagle

deagle()
{
        level.deagle_trig = getEnt( "deagle", "targetname"); //trigger
        jump = getEnt( "deagle_jumper_orig", "targetname" ); //jumper origin
        acti = getEnt( "deagle_acti_orig", "targetname" ); //acti origin
        level.deagle_trig SetHintString("^2 Press F to Enter Knife Room");
        while(1)
{
                level.deagle_trig waittill( "trigger", player );
                if( !isDefined( level.deagle_trig ) )
                return;
           
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "deserteagle_mp" ); //Gives player weapon
                player giveMaxAmmo( "deserteagle_mp" ); //Gives player ammo
            player switchToWeapon( "deserteagle_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.
               
               
                if( isDefined( level.activ ) && isAlive( level.activ ) )
{
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "deserteagle_mp" );
                    level.activ giveMaxAmmo( "deserteagle_mp" );
               level.activ SwitchToWeapon( "deserteagle_mp" );
                    level.activ.maxhealth = 100;
                   
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4deagle ^7Room!" );
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^6Fight^7!" );
            level.activ iPrintlnBold( "^6Fight^6!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
}
}


//sniper room teleport

sniper()
{
	level.sniper_trig = getEnt( "sniper", "targetname"); //trigger
	jump = getEnt( "sniper_jumper_orig", "targetname" ); //jumper origin
	acti = getEnt( "sniper_acti_orig", "targetname" ); //acti origin
	level.sniper_trig SetHintString("^3 Press F to Enter Shotgun Room");
	while(1)
	{
		level.sniper_trig waittill( "trigger", player );
		if( !isDefined( level.sniper_trig ) )
			return;

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "m40a3_mp" ); //Gives player weapon
		player giveMaxAmmo( "m40a3_mp" ); //Gives player ammo
		player GiveWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );  
		player switchToWeapon( "m40a3_mp" ); //Makes player switch to weapon.
		player.maxhealth = 100; //Sets players health to normal.

		if( isDefined( level.activ ) && isAlive( level.activ ) )
		{
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon( "m40a3_mp" );
			level.activ giveMaxAmmo( "m40a3_mp" );
			level.activ GiveWeapon( "remington700_mp" );
			level.activ giveMaxAmmo( "remington700_mp" );
			level.activ SwitchToWeapon( "m40a3_mp" );
			level.activ.maxhealth = 100;
		}

		wait 0.05;

		iPrintLnBold( " ^4" + player.name + " ^7has gotten ^3TROOOOOLLLEEDD !" );
		player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^13" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ iPrintlnBold( "^13" );
		wait 1;
		player iPrintlnBold( "^32" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ iPrintlnBold( "^32" );
		wait 1;
		player iPrintlnBold( "^51" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^6Deal ^3With ^2It^7!" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ iPrintlnBold( "^6Fight^6!" );
		player freezecontrols(false); //Disables the freeze.
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ freezecontrols(false);
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

sniperroomtele()
{
	sniperroomtele_trig = getEnt( "sniperroomtele", "targetname"); //trigger
	jump = getEnt( "sniper_jumper_orig", "targetname" ); //jumper origin
	acti = getEnt( "sniper_acti_orig", "targetname" ); //acti origin
	while(1)
	{
		sniperroomtele_trig waittill( "trigger", player );
		if(isDefined(level.activ) && player == level.activ)
			player setOrigin( acti.origin );
		else
			player setOrigin( jump.origin );
		wait 0.05;
	}
}

//shotgun 

shotgun()
{
	level.shotgun_trig = getEnt( "shotgun", "targetname"); //trigger
	jump = getEnt( "shotgun_jumper_orig", "targetname" ); //jumper origin
	acti = getEnt( "shotgun_acti_orig", "targetname" ); //acti origin
	level.shotgun_trig SetHintString("^2 Press F to Enter Sniper Room");
	while(1)
	{
		level.shotgun_trig waittill( "trigger", player );
		if( !isDefined( level.shotgun_trig ) )
			return;

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "m1014_mp" );
		player giveMaxAmmo( "m1014_mp" );
		player switchToWeapon( "m1014_mp" );
		player.maxhealth = 100;

		if( isDefined( level.activ ) && isAlive( level.activ ) )
		{
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon( "m1014_mp" );
			level.activ giveMaxAmmo( "m1014_mp" );
			level.activ SwitchToWeapon( "m1014_mp" );
			level.activ.maxhealth = 100;
		}

		wait 0.05;

		iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4Shotgun ^7Room!" );
		player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^13" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ iPrintlnBold( "^13" );
		wait 1;
		player iPrintlnBold( "^32" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ iPrintlnBold( "^32" );
		wait 1;
		player iPrintlnBold( "^51" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^6Fight^7!" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ iPrintlnBold( "^6Fight^6!" );
		player freezecontrols(false);
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ freezecontrols(false);
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

//knife

knife()
 {
    level.knife_trig = getEnt( "knife", "targetname");
    jump = getEnt( "knife_jumper_orig", "targetname" );
    acti = getEnt( "knife_acti_orig", "targetname" );
    level.knife_trig SetHintString("^2 Press F to Enter Deagle Room");
    while(1)
    {
		level.knife_trig waittill( "trigger", player );
		if( !isDefined( level.knife_trig ) )
			return;

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "knife_mp" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
		{
			level.activ setPlayerangles( acti.angles );
			level.activ setOrigin( acti.origin );
			level.activ TakeAllWeapons();
			level.activ GiveWeapon( "knife_mp" );
		}
		wait 0.05;
		player switchToWeapon( "knife_mp" );
		if(isDefined( level.activ ) && isAlive( level.activ ))
			level.activ SwitchToWeapon( "knife_mp" );
		iPrintlnBold( " ^4" + player.name + " ^7IT'S ^1A ^4TROLLLLLL ^7MAP ^4!" );
        while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

createHUD( x, y, alignX, alignY, alpha, font, fontScale )
{
    hud = NewHudElem();
    hud.x = x;
    hud.y = y;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.horzalign = alignX;
    hud.vertalign = alignY;
    hud.alpha = alpha;
    hud.font = font;
    hud.fontscale = 2;
    hud.glowalpha = 1;
    hud.glowcolor = (0.5,0.5,0.5);

    return hud;
}

messages1()
{
	wait 5;
	level.hud = createHUD( 500, 0, "center", "middle", 1, "objective", 1.5 );
	level.hud setText ( "^5Map Made by ^1#FNRP#Brotter" );
	level.hud MoveOverTime( 1.0 );
	level.hud.x = 0;
	level.hud.y = 0;
	wait (5);
	level.hud destroy();
}