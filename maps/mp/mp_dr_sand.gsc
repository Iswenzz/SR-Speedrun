main()
{
	maps\mp\_load::main();
	maps\mp\mp_dr_sand\_teleport::main();
	maps\mp\mp_dr_sand\moving::main();
	maps\mp\mp_dr_sand\effects::main();
	maps\mp\mp_dr_sand\traps::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar( "r_specular", "0" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 99999999 );
	setDvar("bg_falldamageminheight", 9999999 );
	
	thread sr\api\_speedrun::createEndMap((-10009,-8192,-2116), 250, 400);

	thread way_connect();
	// thread message();
	// thread message2();
	// thread First();
	// thread games();
	thread secret();
	// thread deagle();
	// thread knife();
	// thread sniper();
	
	// thread music();

	door1 = getEnt("doorright", "targetname");
	door1 delete();
	door2 = getEnt("doorleft", "targetname");
	door2 delete();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

	thread secret_1();
	
    for(;;)
    {
        level waittill( "connected", player );
        
        player thread onPlayerSpawn();
    }
}

onPlayerSpawn()
{
	for(;;)
	{
		self waittill("spawned_player");
		self thread secret_trig();
		self.roped = false;
	}
}

secret_trig()
{
	trig = getent("rpd2_trig","targetname");

	self endon("death");
	self endon("disconnect");

	while(isDefined(self) && !self isTouching(trig))
		wait .05;
	
	self sr\api\_speedrun::changeWay("secret_0");
}

secret_1()
{
	target = spawn("script_origin",(65,-11968,-964));
	target.angles = (0,270,360);
	trigger = spawn( "trigger_radius", (314,-408,76), 0, 70, 90 );
	
	wait 1;
	// trigger.inAir = true;
	trigger.radius = 70;
	thread sr\api\_map::createTriggerFx(trigger, "secret");
	
	while(1)
	{
		trigger waittill ("trigger", player);
	
	    player SetPlayerAngles( target.angles );
        player setOrigin( target.origin );
		player sr\api\_speedrun::changeWay("secret_0");
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

	onDisconnect()
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}
 
	onDeath()
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}

musicMenu()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );
	self endon( "joined_spectators" );
	self endon( "music thread terminated" );
 
	self thread onDeath();
	self thread onDisconnect();
	
	self.hud_music = [];
	self.selection = 0;
 
	// create huds
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText("Rainbow");
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
 
	while(self.sessionstate == "playing")
	{
		wait 0.1;
 
		if(self attackButtonPressed())
		{
			self.hud_music[3+self.selection].alpha = 0.93;
 
			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;
 
			item = self.hud_music[3+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if(self useButtonPressed())
		{
 			iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
			ambientPlay(level.music[self.selection]["alias"]);
			self freezecontrols(0);
			break;
		}
		else if(self fragButtonPressed())
		{
			self freezecontrols(0);
			break;
		}
	}
 
	self cleanUp();
}
 
	music()
{
	trig = getEnt ("musictrig", "targetname");
	trig setHintString("^7Press ^3[USE] ^7to choose Music");
 
	trig waittill("trigger",player);
	player freezecontrols(1);
	trig delete();
	player musicMenu();
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


message()
{
	while(1)
	{
		iprintln( "^1Map by ^43xP' UnNamed" );
		wait 5;
		iprintln( "^7Textures and script by ^43xP' UnNamed" );
		wait 10;
		iprintln( "THX TO TESTERS: ^4Agex^7, ^4Yuri ^9<3" );
		wait 10;
	}
}

message2()
{
	trig=getent("testers", "targetname");
	while(1)
	{
		trig waittill("trigger", player);
		iPrintlnbold(player.name + " says Thanks to Beta testers: ^4Agex^7 and ^4Yuri ^9 <3");
		wait 10;
	}
	
}


secret()
{
	thread secret_hard();
	thread secret_easy();
}

secret_hard()
{
	thread secret_hard_help();
	thread secret_hard_fail();
	thread secret_hard_finish();
}

secret_hard_help()
{
	trig0=getent("secret_0_help", "targetname");
	trig1=getent("secret_1_help", "targetname");
	trig2=getent("secret_2_help", "targetname");
	// trig0 SetHintString("321/32 | wa/wd-wa");
	// trig1 SetHintString("32/32 | wd-wa/wd-wa");
	// trig2 SetHintString("3212/2_2/21(3) | wa start");
}

secret_hard_fail()
{
	thread secret_hard_fail1();
	thread secret_hard_fail2();
	thread secret_hard_fail3();
}

secret_hard_fail1()
{
	trig=getent("secret_2_trig1", "targetname");
	ori=getent("secret_2_1", "targetname");
	while(1){
		trig waittill("trigger", player);
		player freezeControls(true);
		wait 0.05;
		player setplayerangles(ori.angles);
		player setorigin(ori.origin);
		player freezeControls(false);
		wait 0.05;
}
}

secret_hard_fail2()
{
	trig2=getent("secret_2_trig2", "targetname");
	ori=getent("secret_2_2", "targetname");
	while(1){
		trig2 waittill("trigger", player);
		player freezeControls(true);
		wait 0.05;
		player setplayerangles(ori.angles);
		player setorigin(ori.origin);
		wait 0.05;
		player freezeControls(false);
}
}

secret_hard_fail3()
{
	trig3=getent("secret_2_trig3", "targetname");
	ori=getent("secret_2_3", "targetname");
	while(1){
		trig3 waittill("trigger", player);
		player freezeControls(true);
		wait 0.05;
		player setplayerangles(ori.angles);
		player setorigin(ori.origin);
		player freezeControls(false);
		wait 0.05;
}
}

secret_hard_finish()
{
	trig=getent("secret_hard_end", "targetname");
	ori=getent("secret_hard_end_ori", "targetname");
	while(1){
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

	
secret_easy()
{
	thread secret_easy_finish();
}

secret_easy_finish()
{
	trig=getent("secret_easy_end", "targetname");
	ori=getent("secret_easy_end_origin", "targetname");
	while(1){
		trig waittill("trigger", player);
		player freezeControls(true);
		wait 0.05;
		player setplayerangles(ori.angles);
		player setorigin(ori.origin);
		player freezeControls(false);
		wait 0.05;
	}
	
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

First()
{
	trig = getEnt ("end", "targetname");
	trig waittill("trigger", player);
	iPrintlnBold("^4" + player.name + " ^7Has Finished ^4First");
	player braxi\_rank::giveRankXP("", 100);
	trig delete();
}

games()
{
	trig = getEnt("games", "targetname");
	ori = getEnt ("games_ori", "targetname");
	while (1)
	{
		trig waittill("trigger", player);
		iPrintlnBold("^4" + player.name + " ^7selects the room");
		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player Death();
		wait 0.1;
	}
}

Death()
{
        self endon("disconnect");
        self waittill("death");
		iprintlnbold("^4" + self.name + "^7 diededed");
}


sniper()
{
        trig = getEnt( "sniper_trig", "targetname"); 
		
        jumper = getEnt( "sniper1", "targetname" );
        acti = getEnt( "sniper2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		ambientPlay("knife");
		iprintlnbold("^4" + player.name + "^7 entered the sniper room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
		player GiveWeapon("remington700_mp");
		player GiveMaxAmmo("remington700_mp");
		player GiveWeapon("m40a3_mp");
		player GiveMaxAmmo("m40a3_mp");
		player SwitchToWeapon("m40a3_mp");
		activator = GetActivator();
		
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
			activator GiveWeapon( "m40a3_mp" ); 
			activator giveMaxAmmo( "m40a3_mp" ); 
			activator GiveWeapon( "remington700_mp" );
			activator giveMaxAmmo( "remington700_mp" );
            activator SwitchToWeapon( "m40a3_mp" );
         
		}
	}



knife()
{
        trig = getEnt( "knife_trig", "targetname"); 
		
		
        jumper = getEnt( "knife1", "targetname" );
        acti = getEnt( "knife2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
		ambientPlay("proluvies");

		iprintlnbold("^4" + player.name + "^7 entered the knife room");
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
        player GiveWeapon( "knife_mp" ); 
        player GiveWeapon( "deserteagle_mp" );
		player SetWeaponAmmoClip("deserteagle_mp", 0);
        player SetWeaponAmmoStock("deserteagle_mp", 0);
        player switchToWeapon( "deserteagle_mp" ); 
		
		activator = GetActivator();
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
		    activator GiveWeapon( "knife_mp" ); 
			activator GiveWeapon( "deserteagle_mp" );
			activator SetWeaponAmmoClip("deserteagle_mp", 0);
			activator SetWeaponAmmoStock("deserteagle_mp", 0);
			activator switchToWeapon( "deserteagle_mp" ); 
         
		}
	}



deagle()
{
        trig = getEnt( "deagle_trig", "targetname"); 

		
        jumper = getEnt( "deagle1", "targetname" );
        acti = getEnt( "deagle2", "targetname" ); 
	
	while(1)
	{
		trig waittill("trigger",player);
			ambientPlay("knife2");
		iprintlnbold("^4" + player.name + "^7 entered the deagle room");
		
		
		player SetOrigin(jumper.origin);
		player SetPlayerAngles(jumper.angles);
		player TakeAllWeapons(); 
        player GiveWeapon( "deserteaglegold_mp" ); 
        player GiveWeapon( "deserteagle_mp" );
        player switchToWeapon( "deserteagle_mp" ); 
		activator = GetActivator();
		
	
			activator setPlayerangles( acti.angles );
			activator setOrigin( acti.origin ); 
			activator TakeAllWeapons(); 
		    activator GiveWeapon( "deserteaglegold_mp" ); 
			activator GiveWeapon( "deserteagle_mp" );
			activator switchToWeapon( "deserteagle_mp" ); 
         
		
	}
}


