//////////////////////\\\\\\\\\\\\\\\\\\\\\\
//    __              ___                 \\
//   /\ \            /\_ \                \\
//   \ \ \        ___\//\ \    ____       \\
//    \ \ \  __  / __`\\ \ \  /\_ ,`\     \\
//     \ \ \L\ \/\ \L\ \\_\ \_\/_/  /_    \\
//      \ \____/\ \____//\____\ /\____\   \\
//       \/___/  \/___/ \/____/ \/____/   \\
// 								          \\
//////////////////////\\\\\\\\\\\\\\\\\\\\\\
//Map by Lolz      |      Scripted by Lolz\\
//        Nickname i have in game :       \\
//   Lolz :] -SuX Lolz :] -#FNRP#Lolz :]  \\
//            xFire: alex1528             \\
//    Steam: iswenzz1528 / SuX Lolz :]    \\
//Ty To ColdCoffe & SheepWizard & TheLixfe\\
//             For Helping Me!            \\
//////////////////////\\\\\\\\\\\\\\\\\\\\\\

//////////////////////\\\\\\\\\\\\\\\\\\\\\\
//  LOSSY c'est le piiiiiiiireeeeeeeeeee  \\
//////////////////////\\\\\\\\\\\\\\\\\\\\\\

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	thread sr\api\_map::create_normal_way("^2Easy Way;^1Hard Way");
	thread sr\api\_map::create_secret_way("^2Easy Secret;^1Hard Secret");
	thread sr\api\_map::create_spawn((480, -234, 78), 180);
 maps\mp\_compass::setupMiniMap("compass_map_mp_dr_lolz");
 
thread sr\api\_map::create_tp((3135, 1674, -992), 100, 150, (8206, 1480, -992), 360, "freeze");
thread sr\api\_map::create_tp((410, -3385, 76), 100, 150, (409, -3562, 444), 270, "freeze");
thread sr\api\_map::create_endmap((817, -12816, -4852), 100, 150, "ns1");

tpeasyori = getEnt("origin_easy_secret_1", "targetname");
thread sr\api\_map::create_tp((193, 14, 76), 100, 150, 
	tpeasyori.origin, tpeasyori.angles[1], "freeze", "green", "s0");
tphardsecret = getEnt("hard_secret_ori", "targetname");
thread sr\api\_map::create_tp((193, -487, 76), 100, 150, 
	tphardsecret.origin, tphardsecret.angles[1], "freeze", "darkred", "s1");

thread hardsec_cod4x();

 level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 

	//SETDVAR**
	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","1600");

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 2000000000 );
	setDvar("bg_falldamageminheight", 1500000000 );
	//SETDVAR*

	//THREAD**
	/* [AUTO DELETE] thread guidchecking(); */
	thread mapzor();
	thread messages();
	thread lift();
	// thread elev1();
	// thread elev2();
	thread elev3();
	// thread elev4();
	// thread  [AUTO DELETE] initMusic(); 
	/* [AUTO DELETE] thread musictrig(); */
	thread credits();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	// thread end();
	// thread games();
	/* [AUTO DELETE] thread sniper(); */
	/* [AUTO DELETE] thread sniperjumperfail(); */
	/* [AUTO DELETE] thread sniperactifail(); */
	/* [AUTO DELETE] thread snipernoob(); */
	/* [AUTO DELETE] thread weapons(); */
	/* [AUTO DELETE] thread bounce(); */
	/* [AUTO DELETE] thread bounceactifail(); */
	/* [AUTO DELETE] thread bouncejumperfail(); */
	// thread  [AUTO DELETE] givesniper(); 
	// thread run();
	// thread runwaysetup();
	/* [AUTO DELETE] thread knife(); */
	/* [AUTO DELETE] thread kniferoomturn(); */
	/* [AUTO DELETE] thread shotgun(); */
	/* [AUTO DELETE] thread shotgunactifail(); */
	/* [AUTO DELETE] thread shotgunjumperfail(); */
	/* [AUTO DELETE] thread old(); */
	/* [AUTO DELETE] thread oldfakewall(); */
	thread tpsetup();
	thread watterFX();
	thread turnsetup();
	thread noobrespawn();
	/* [AUTO DELETE] thread secretwall(); */
	thread actitpsetup();
	thread traphardmodeoff();
	thread traphardmodeon();
	thread /* [AUTO DELETE] lolzsecret333setup(); */
	//THREAD*

	//PRECACHE**
	// precacheitem ("m40a3_mp");
	// precacheitem ("remington700_mp");
	// precacheitem ("knife_mp");
	// precacheitem ("raygun_mp");
	// precacheitem ("intervention_mp");
	// precacheitem ("tomahawk_mp");
	// precacheitem ("uzi_silencer_mp");
	// precacheItem ("ak74u_mp");
	// precacheItem ("rpg_mp");
	// precacheItem ("winchester1200_mp");
	// precacheItem ("ak47_mp");
	// precacheItem ("rpd_mp");
	// precacheItem ("m1014_grip_mp");
	// precacheItem ("deserteaglegold_mp");
	// precacheItem ("p90_silencer_mp");
	// precacheItem ("saw_grip_mp");
	// precacheModel("shadow");
	// precacheShader("mtl_shadow_fur");
	// precacheShader("mtl_shadow_clothes");
	// precacheShader("mtl_shadow_shoes");
	// precacheShader("mtl_shadow_body");
	// precacheShader("mtl_shadow_eyes");
	//PRECACHE*

	//ACTI TRIGGER
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
	//ACTI TRIGGER

}

hardsec_cod4x()
{
	trig = spawn("trigger_radius", (23007, -185, -6076), 0, 300, 30);
	trig.targetname = "hardsec_cod4x_trig";

	for (;;)
	{
		trig waittill("trigger", player);
		player setMoveSpeed(600);
		player setGravity(500);
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
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


guidchecking()
{
	wait 5.1;
	thread guidcheckgod();
	thread guidcheckvip();
	wait 0.2;
}


messages()
{
wait 10;
/* [AUTO DELETE] iprintlnBold("^5Welcome ^7to ^5SuX ^7Lolz ^5M^7ap ^5:^7]"); */
wait 1;

while(1)
	{
	
		/* [AUTO DELETE] iPrintLn("^1Report any bugs"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^1 xFire: ^7alex1528"); */
		wait 1;
		/* [AUTO DELETE] iPrintLn("^1Steam: ^7iswenzz1528 / SuX Lolz :]"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^5Visit: www.fnrp-servers.com !!"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^1RIP ^2Raid-Gaming. xD"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^3Map Made By: ^5SuX ^7Lolz :]"); */
		wait 8;
	
	}
}


guidcheckgod() //CHECK GOD GUID :]
{
god1 = "caa5eb5cf6bc6e1dadbcae1d5b7631e9";
sanictrig = getent("sanic_check","targetname");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		tempGuid = user getGUID();
		if(tempGuid == god1)
		{
		user detachAll();
		user setModel("shadow");  //Model Here
		/* [AUTO DELETE] user GiveWeapon( "raygun_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "raygun_mp" ); */
		/* [AUTO DELETE] iPrintLnBold(user.name + " Map ^5Creator ^7is ^2Connected ^7!!"); */
		wait 3;
		}
			else
			{
			wait 3;
		}

	
}
}


secretwall()
{
	susu2 = getEnt("wall_easy_secret", "targetname");
	susu3 = getEnt("open_secret_1", "targetname");
	
	{
		susu3 waittill("trigger", player);
		/* [AUTO DELETE] iprintlnbold("^2EASY ^5Secret Opened !!!"); */
		susu2 hide();
		susu2 notsolid();
	}
}


noobrespawn()
{
	trignoob = getEnt("respawn_noob", "targetname");
	tpnoob = getEnt("ori_noob", "targetname");
	
	for (;;)
	{
		trignoob waittill("trigger", player);
		player setOrigin(tpnoob.origin);
		player setPlayerAngles(tpnoob.angles);
	}
}


guidcheckvip() //CHECK GOD VIP :]
{
god1 = "2b496dc24a263701f20c7f209c8d844a";
god2 = "df7cd39f1d971b8986c9040e27e2c5f9";
god3 = "af61d705bd0d36655cd1197dd80650b9";
god4 = "2f5cd3bc8543ac4c5f629232e504a6e5";
sanictrig = getent("sanic_check_2","targetname");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		tempGuid = user getGUID();
		if((tempGuid == god1) || (tempGuid == god2) || (tempGuid == god3) || (tempGuid == god4))
		{
		user detachAll();
		user setModel("shadow");  //Model Here
		/* [AUTO DELETE] user GiveWeapon( "raygun_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "raygun_mp" ); */
		/* [AUTO DELETE] iPrintLnBold ("^5VIP ^7is ^2Connected"); */
		wait 3;
		}
			else
			{
			wait 3;
		}

	
}
}


mapzor()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^5mp_dr_lolz" );
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
                self credit_roll( "^7Mapped ^5& ^7scripted by ^5SuX ^7Lolz :]", 5 );
                self credit_roll( "Visit ^5www.fnrp-servers.com^7!!!", 5 );
                self credit_roll( "^5Thanks ^7to ^5 Stxly ^7 ^2& ^5Sheep Wizard ^7& ^5TheLixfe ^7for ^5helping ^7me", 3.5 );
				self credit_roll( "xFire:  alex1528  -  Steam: iswenzz1528 / SuX Lolz :]", 5);
				self credit_roll( "^7www.youtube^5.com/^7channel^5/^7UC1vxOXBzEF7W4g7TRU0C1rw", 5 );
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


initMusic()
{
		level.music = [];
 
        i = 0;
		level.music[i]["artist"] = "Mr FijiWiji(feat. CoMa)";
		level.music[i]["title"] = "Apathy";
		level.music[i]["alias"] = "music1";
		
		i++;
		level.music[i]["artist"] = "Headphone Activist";
		level.music[i]["title"] = "Cloud City";
		level.music[i]["alias"] = "music5";
		
		i++;
		level.music[i]["artist"] = "CMA";
		level.music[i]["title"] = "Beautiful Sunset";
		level.music[i]["alias"] = "music3";
		
		i++;
		level.music[i]["artist"] = "Kristy Hawkshaw";
		level.music[i]["title"] = "Reasons To Forgive (T-Mass Remix)";
		level.music[i]["alias"] = "music4";
		
		i++;
		level.music[i]["artist"] = "Jez Dior(feat. OnCue";
		level.music[i]["title"] = "Parachutes";
		level.music[i]["alias"] = "music2";

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
			/* [AUTO DELETE] iPrintln( "^5Now playing: ^7" + level.music[self.selection]["artist"]+" - ^2" +level.music[self.selection]["title"] ); */
 
			/* [AUTO DELETE] ambientPlay( level.music[self.selection]["alias"], 3 ); */
			self freezeControls(0);
			level notify ( "song_picked" );
			/* [AUTO DELETE] self braxi\_rank::giveRankXp( "trap_activation" ); */
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


onDeath() //Music Term.
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}


onDisconnect() //Music Term.
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}


lift() //Open the door + Start Button
{

lift=getent("lift","targetname");
lift delete();
}


elev1() // 1st Elevator in Hard way
{
elev1 = getent ("elev1","targetname");
while(1)
{
elev1 moveZ(365, 4, 0.3, 0.3);
elev1 waittill("movedone");
wait 3;
elev1 moveZ(-365, 4, 0.3, 0.3);
elev1 waittill("movedone");
wait 3;
}
}


elev2() // 2sd Elevator in Hard way
{
elev2 = getent ("elev2","targetname");
while(1)
{
elev2 moveZ(5000, 2, 0.5, 0.5);
elev2 waittill("movedone");
wait 3;
elev2 moveZ(-5000, 2, 0.5, 0.5);
elev2 waittill("movedone");
wait 3;
}
}


elev3() // 1st Elevator in Easy Way
{

elev3=getent("elev3","targetname");
elev3 movez (-1055, 2, 0.5, 0.5);
// trigger_elev3=getent("trigger_elev3","targetname");

// 	{
// 	trigger_elev3 waittill ("trigger");
// 	wait 0.2;
// 	}
// 		while(1)
// 		{
// 		elev3 movez (-1055, 2, 0.5, 0.5);
// 		elev3 waittill ("movedone");
// 		wait 3;
// 		elev3 movez (1055, 2, 0.5, 0.5);
// 		elev3 waittill ("movedone");
// 		wait 3;
// 		}
}


elev4() // 2sd Elevtor in Easy Way
{
elev4 = getent ("elev4","targetname");
while(1)
{
elev4 moveX(400, 4, 1, 0);
elev4 waittill ("movedone");
wait 0.05;
elev4 moveX(4600, 3, 0, 1);
elev4 waittill ("movedone");
wait 2;
elev4 moveX(-5000, 2, 0.5, 0.5);
elev4 waittill ("movedone");
wait 3;
}
}


watterFX()
{

	drown_waterage = getentarray("drown_water","targetname");
	if (isDefined("drown_waterage"))
	{
		precacheShader("black");
		precacheShader("white");



		level.barsize = 288;
		level.drown_watertime = 10;
		level.hurttime = 9;

		for(d = 0; d < drown_waterage.size; d++)
		{
			drown_waterage[d] thread water();
		}
	}
}


Water()
{
while (1)
	{
	self waittill("trigger", other);

	if(isPlayer(other) && other istouching(self))
		other thread drown_water(self);
	}
}
	
drown_water(trigger)
{
	dceiling = getent(trigger.target,"targetname");
	water_vision = undefined;
	while (self istouching(trigger) && !self istouching(dceiling))
	{
		wait .125;
		if(isDefined(self.drown_watering))
			return;		
		self.drown_watering = true;

	if(!isDefined(water_vision))
	{
		water_vision = newClientHudElem(self);
		water_vision.x = 0;
		water_vision.y = 0;
		water_vision setshader ("white", 640, 480);
		water_vision.alignX = "left";
		water_vision.alignY = "top";
		water_vision.horzAlign = "fullscreen";
		water_vision.vertAlign = "fullscreen";
		water_vision.color = (.16, .38, .5);
		water_vision.alpha = .75;
	}


	level.barincrement = (level.barsize / (20.0 * level.drown_watertime));
//	level.player allowProne(false);
	if(!isDefined(self.progressbackground))
	{
		self.progressbackground = newClientHudElem(self);				
		self.progressbackground.alignX = "center";
		self.progressbackground.alignY = "middle";
		self.progressbackground.x = 320;
		self.progressbackground.y = 385;
		self.progressbackground.alpha = 0.5;
	}
	self.progressbackground setShader("black", (level.barsize + 4), 14);		

	if(!isDefined(self.progressbar))
	{
		self.progressbar = newClientHudElem(self);				
		self.progressbar.alignX = "left";
		self.progressbar.alignY = "middle";
		self.progressbar.x = (320 - (level.barsize / 2.0));
		self.progressbar.y = 385;
	}
	self.progressbar setShader("white", 0, 8);			
	self.progressbar scaleOverTime(level.drown_watertime, level.barsize, 8);

	self.progresstime = 0;
	d = 0;
	f = 0;

	while(isalive(self) && self istouching(trigger) && !self istouching(dceiling) && (self.progresstime < level.drown_watertime))
	{		
		d ++;
		f ++;
		
		wait 0.05;
		self.progresstime += 0.05;


		if(self.progresstime >= level.hurttime)					
			{
			if(f >= 4)
				{
				radiusDamage(self.origin,9, 1, 1);
				f = 0;
				}
			}
	}

	if(isalive(self) && self istouching(trigger) && !self istouching(dceiling) && (self.progresstime >= level.drown_watertime))
	{

		self.progressbackground destroy();
		self.progressbar destroy();

		wait 0.025;
		radiusDamage(self.origin,22, 3000, 3000);

		self.drown_watering = undefined;
		self.sounder = undefined;



		randb = randomInt(2);
		deathmethod1 = " Drowned";	
		deathmethod2 = " That's water, It Kills.";
		deathmethod3 = " Swallowed Some Water";
		deathmethod4 = " That's water, It Kills.";
		
		if (randb == 0)
		/* [AUTO DELETE] iPrintLn( self.name, deathmethod1); */
		if (randb == 1)
		/* [AUTO DELETE] iPrintLn( self.name, deathmethod2); */
		if (randb == 2)
		/* [AUTO DELETE] iPrintLn( self.name, deathmethod3); */
		if (randb == 3)
		/* [AUTO DELETE] iPrintLn( self.name, deathmethod4); */
		wait .05;
		water_vision destroy();
	}
	else
	{
		water_vision.alpha = .5;
		water_vision fadeOverTime(3);
		water_vision.alpha = 0;
		wait 0.05;
		self.progressbackground destroy();
		self.progressbar destroy();
		self.drown_watering = undefined;
		self.sounder = undefined;
	}			
	wait .05;
	}
}


traphardmodeon() //Hard mod.
{
	level endon("trigger");
lazer1 = getent("hard_mode_1a","targetname");
lazertrig1 = getent("hard_mode_1b","targetname");
lazer2 = getent("hard_mode_2a","targetname");
lazertrig2 = getent("hard_mode_2b","targetname");
lazer3 = getent("hard_mode_3a","targetname");
lazertrig3 = getent("hard_mode_3b","targetname");
lazer4 = getent("hard_mode_4a","targetname");
lazertrig4 = getent("hard_mode_4b","targetname");
lazer5 = getent("hard_mode_5a","targetname");
lazertrig5 = getent("hard_mode_5b","targetname");
lazer6 = getent("hard_mode_6a","targetname");
lazertrig6 = getent("hard_mode_6b","targetname");
trig = getent("trig_trap8","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");
/* [AUTO DELETE] iPrintLnBold("^1HARD MODE ACTIVATED!!!"); */
	{
	lazer1 show();
	lazer1 solid();
	lazer2 show();
	lazer2 solid();
	lazer3 show();
	lazer3 solid();
	lazer4 show();
	lazer4 solid();
	lazer5 show();
	lazer5 solid();
	lazer6 show();
	lazer6 solid();
	lazertrig1 triggerOn();
	lazertrig2 triggerOn();
	lazertrig3 triggerOn();
	lazertrig4 triggerOn();
	lazertrig5 triggerOn();
	lazertrig6 triggerOn();
	wait 1;
	thread lazer1move();
	thread lazer2move();
	thread lazer3move();
	thread lazer4move();
	thread lazer5move();
	thread lazer6move();
	}
}


lazer1move()
{
lazer1 = getent("hard_mode_1a","targetname");
lazertrig1 = getent("hard_mode_1b","targetname");

lazertrig1 enablelinkto();
lazertrig1 linkto(lazer1);

	for(;;)
	{
		time = RandomIntRange( 2 , 6 );
		wait(0.1);
		lazer1 movex( 2000, time );
		lazer1 waittill("movedone");
		lazer1 movex( -2000, time );
		lazer1 waittill("movedone");
	}
}


lazer2move()
{
lazer2 = getent("hard_mode_2a","targetname");
lazertrig2 = getent("hard_mode_2b","targetname");

lazertrig2 enablelinkto();
lazertrig2 linkto(lazer2);

	for(;;)
	{
		time = RandomIntRange( 2 , 6 );
		wait(0.1);
		lazer2 movey( -900, time );
		lazer2 waittill("movedone");
		lazer2 movey( 900, time );
		lazer2 waittill("movedone");
	}
}


lazer3move()
{
lazer3 = getent("hard_mode_3a","targetname");
lazertrig3 = getent("hard_mode_3b","targetname");

lazertrig3 enablelinkto();
lazertrig3 linkto(lazer3);

	for(;;)
	{
		time = RandomIntRange( 1 , 3 );
		wait(0.1);
		lazer3 movez( 200, time );
		lazer3 waittill("movedone");
		lazer3 movez( -200, time );
		lazer3 waittill("movedone");
	}
}


lazer4move()
{
lazer4 = getent("hard_mode_4a","targetname");
lazertrig4 = getent("hard_mode_4b","targetname");

lazertrig4 enablelinkto();
lazertrig4 linkto(lazer4);

	for(;;)
	{
		time = RandomIntRange( 1 , 3 );
		wait(0.1);
		lazer4 movey( 200, time );
		lazer4 waittill("movedone");
		lazer4 movey( -200, time );
		lazer4 waittill("movedone");
	}
}


lazer5move()
{
lazer5 = getent("hard_mode_5a","targetname");
lazertrig5 = getent("hard_mode_5b","targetname");

lazertrig5 enablelinkto();
lazertrig5 linkto(lazer5);

	for(;;)
	{
		time = RandomIntRange( 1 , 3 );
		wait(0.1);
		lazer5 movez( -200, time );
		lazer5 waittill("movedone");
		lazer5 movez( 200, time );
		lazer5 waittill("movedone");
	}
}


lazer6move()
{
lazer6 = getent("hard_mode_6a","targetname");
lazertrig6 = getent("hard_mode_6b","targetname");

lazertrig6 enablelinkto();
lazertrig6 linkto(lazer6);

	for(;;)
	{
		time = RandomIntRange( 1 , 3 );
		wait(0.1);
		lazer6 movey( -200, time );
		lazer6 waittill("movedone");
		lazer6 movey( 200, time );
		lazer6 waittill("movedone");
	}
}


traphardmodeoff() //Hard mod off
{
lazer1 = getent("hard_mode_1a","targetname");
lazertrig1 = getent("hard_mode_1b","targetname");
lazer2 = getent("hard_mode_2a","targetname");
lazertrig2 = getent("hard_mode_2b","targetname");
lazer3 = getent("hard_mode_3a","targetname");
lazertrig3 = getent("hard_mode_3b","targetname");
lazer4 = getent("hard_mode_4a","targetname");
lazertrig4 = getent("hard_mode_4b","targetname");
lazer5 = getent("hard_mode_5a","targetname");
lazertrig5 = getent("hard_mode_5b","targetname");
lazer6 = getent("hard_mode_6a","targetname");
lazertrig6 = getent("hard_mode_6b","targetname");

	{
	lazer1 hide();
	lazer1 notsolid();
	lazer2 hide();
	lazer2 notsolid();
	lazer3 hide();
	lazer3 notsolid();
	lazer4 hide();
	lazer4 notsolid();
	lazer5 hide();
	lazer5 notsolid();
	lazer6 hide();
	lazer6 notsolid();
	lazertrig1 triggerOff();
	lazertrig2 triggerOff();
	lazertrig3 triggerOff();
	lazertrig4 triggerOff();
	lazertrig5 triggerOff();
	lazertrig6 triggerOff();
	}
}


trap1() //Trap 1
{
	level endon("trigger");
part1 = getentarray("trap01a","targetname");
part2 = getentarray("trap01b","targetname");
part3 = getentarray("trap01c","targetname");
part4 = getentarray("trap01d","targetname");
part5 = getentarray("trap01e","targetname");
part6 = getentarray("trap01f","targetname");
trig = getent("trig_trap1","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");
random = randomint(2);
	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part2[randomInt(part2.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();
				break;
				
		case 1:	
				part4[randomInt(part4.size)] notsolid();
				part5[randomInt(part5.size)] notsolid();
				part6[randomInt(part6.size)] notsolid();
                break;
				
		default: return;
	}
}


trap2() //Trap 2
{
	level endon("trigger");
cylinder1 = getent("trap02a","targetname");
cylinder2 = getent("trap02b","targetname");
cylinder3 = getent("trap02c","targetname");
trig = getent("trig_trap2","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");
	while(1)
	{
	cylinder1 rotatePitch(360 ,3);
	cylinder2 rotatePitch(360 ,3);
	cylinder3 rotatePitch(360 ,3);
	wait 6;
	cylinder1 rotatePitch(-360 ,3);
	cylinder2 rotatePitch(-360 ,3);
	cylinder3 rotatePitch(-360 ,3);
	wait 6;
	}
}


trap3() //Trap 3
{
	level endon("trigger");
rotate = getent("trap03a","targetname");
trig = getent("trig_trap3","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");
	while(1)
	{
	rotate rotateYaw(1800 ,2, 0.7);
	rotate waittill ("movedone");
	wait 2.3;
	rotate rotateYaw(-1800 ,2, 0.7);
	rotate waittill ("movedone");
	wait 2.3;
	}
}


trap4() //Trap 4
{
	level endon("trigger");
push = getent("trap04a","targetname");
pushfix = getent("trap04b","targetname");
trig = getent("trig_trap4","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");

pushfix enablelinkto();
pushfix linkto(push);

	{
	push movex(-910 ,0.4);
	wait 3;
	push movex(910 ,0.4);
	wait 1;
	}
}


trap5() //Trap 5
{
	level endon("trigger");
trap5a = getent("trap05a","targetname");
trap5b = getent("trap05b","targetname");
trig = getent("trig_trap5","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");
	while(1)
	{
	trap5a rotatePitch(-360, 1.8);
	trap5b rotatePitch(360, 1.8);
	wait 1.8;
	}
}


trap6() //Trap 6
{
	level endon("trigger");
bridge = getent("trap06a","targetname");
trig = getent("trig_trap6","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");
	{
	bridge hide();
	bridge notsolid();
	}
}


trap7() //Trap 7
{
	level endon("trigger");
rock1 = getent("trap07a","targetname");
rock2 = getent("trap07b","targetname");
trig = getent("trig_trap7","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");
	while(1)
	{
	rock1 moveZ(100,4);
	rock2 moveZ(-100,4);
	wait 6;
	rock1 moveZ(-100,4);
	rock2 moveZ(100,4);
	wait 6;
	}
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


endtrigantibug(trig)
{
self common_scripts\utility::waittill_any("death","disconnect");
level.jatekosend = 0;
trig SetHintString("^1Press &&1 !..");
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


end() //First D:
{
trigger = GetEnt( "end", "targetname" );
	{
	trigger waittill ("trigger", user);
		{
		/* [AUTO DELETE] iprintlnbold( "^7 " + user.name + " ^5Finished First^7!!"); */
		wait 0.1;
		}
	}
}


games() //Select Rooms
{
// level.games_trig = getEnt( "minigames", "targetname");
// games = getEnt( "minigames_ori", "targetname" );

// while(1)
// {
// level.games_trig waittill( "trigger", player );
// if( !isDefined( level.games_trig ) )
// return;

// player SetPlayerAngles( games.angles );
// player setOrigin( games.origin );
//  [AUTO DELETE] iPrintlnBold( " ^5" + player.name + " ^7has ^5entered ^7the ^5game ^7selection !^5!^7!" ); 
// /* [AUTO DELETE] player TakeAllWeapons(); */
// player antiglitch();


// while( isAlive( player ) && isDefined( player ) )
// if( isDefined( level.activ ) && isAlive( level.activ ) )
// /* [AUTO DELETE] wait 1; */
// }
}

antiglitch() //ng1
{ 
self common_scripts\utility::waittill_any("death","disconnect");
/* [AUTO DELETE] iPrintlnBold("^5"+self.name+" ^7is ^5dead"); */ 
/* [AUTO DELETE] iPrintlnBold("^5Selection ^7Room ^5is ^5now ^7open^5!!"); */ 
}


waitdead() //ng2
{
weapons = getent("weapons_trig","targetname");
bounce = getent("bounce_trig","targetname");
sniper = getent("sniper_trig","targetname");
knife = getent("knife_trig","targetname");
run = getent("run_trig","targetname");
shotgun = getent("shotgun_trig","targetname");
weapons triggerOff();
bounce triggerOff();
sniper triggerOff();
knife triggerOff();
run triggerOff();
shotgun triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
activator = GetActivator();
activator freezeControls(false);
weapons triggerOn();
bounce triggerOn();
sniper triggerOn();
knife triggerOn();
run triggerOn();
}


sniper() //Sniper Room
{
sniper = getent("sniper_trig","targetname");
old = getent("old_trigger","targetname");
jumper = getent("origin_jumper_snip","targetname");
acti = getent("origin_acti_snip","targetname");
noobsnip = getEnt("trigger_noob_snip", "targetname");
for(;;)
{
	sniper waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	/* [AUTO DELETE] player giveweapon("m40a3_mp"); */
	/* [AUTO DELETE] activator giveweapon("m40a3_mp"); */
	/* [AUTO DELETE] player giveweapon("intervention_mp"); */
	/* [AUTO DELETE] activator giveweapon("intervention_mp"); */
	thread createhud(player.name + " ^5selected ^7snipah ^4war!");
	noobsnip triggerOn();
	wait 5;
	/* [AUTO DELETE] player iprintlnbold("^5FIGHT ^7!!!"); */
	/* [AUTO DELETE] activator iprintlnbold("^5FIGHT ^7!!!"); */
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("m40a3_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("m40a3_mp"); */
	/* [AUTO DELETE] player givemaxammo("m40a3_mp"); */
	/* [AUTO DELETE] activator givemaxammo("m40a3_mp"); */
	}
}


snipernoob() //when u fall in sniper room
{
	noobsnip = getEnt("trigger_noob_snip", "targetname");
	noobsniptp = getEnt("origin_noob_snip", "targetname");

	noobsnip waittill("trigger", player);
	player setOrigin(noobsniptp.origin);
	player setPlayerAngles(noobsniptp.angles);
	player freezeControls(true);
	noobsnip triggerOff();
}


sniperactifail() //if acti fall after
{
	sniperactifail = getEnt("trigger_acti_fail_sniper", "targetname");
	tpsniperactifail = getEnt("origin_acti_snip", "targetname");
	
	for (;;)
	{
		sniperactifail waittill("trigger", player);
		player setOrigin(tpsniperactifail.origin);
		player setPlayerAngles(tpsniperactifail.angles);
	}
}


sniperjumperfail() //if jumper fall after
{
	sniperjumperfail = getEnt("trigger_jumper_fail_sniper", "targetname");
	tpsniperjumperfail = getEnt("origin_jumper_snip", "targetname");
	
	for (;;)
	{
		sniperjumperfail waittill("trigger", player);
		player setOrigin(tpsniperjumperfail.origin);
		player setPlayerAngles(tpsniperjumperfail.angles);
	}
}


weapons() //weapons room :)
{
weapons = getent("weapons_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_weapons","targetname");
acti = getent("origin_acti_weapons","targetname");
for(;;)
{
	weapons waittill("trigger", player);
	old delete();
	player thread waitdead();
	thread createhud(player.name + " ^5Selected ^7Weapons ^5Way ^7!^5!^7!");
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	wait 5;
	/* [AUTO DELETE] IPrintLnbold("^2Fight!!!."); */
	i = randomintrange(0, 8);
	weapon = "rpg_mp";
	if(i == 0)
	{
		weapon = "rpg_mp";
	}
	else if(i == 1)
	{
		weapon = "winchester1200_mp";
	}
	else if(i == 2)
	{
		weapon = "mp44_mp";
	}
	else if(i == 3)
	{
		weapon = "ak47_mp";
	}
	else if(i == 4)
	{
		weapon = "rpd_mp";
	}
	else if(i == 5)
	{
		weapon = "p90_silencer_mp";
	}
	else if(i == 6)
	{
		weapon = "saw_grip_mp";
	}
	else if(i == 7)
	{
		weapon = "uzi_silencer_mp";
	}
	/* [AUTO DELETE] player giveweapon("knife_mp"); */
	/* [AUTO DELETE] activator giveweapon("knife_mp"); */
	/* [AUTO DELETE] player giveweapon(weapon); */
	/* [AUTO DELETE] activator giveweapon(weapon); */
	/* [AUTO DELETE] activator givemaxammo(weapon); */
	/* [AUTO DELETE] player givemaxammo(weapon); */
	wait .1;
	/* [AUTO DELETE] player switchtoweapon(weapon); */
	/* [AUTO DELETE] activator switchtoweapon(weapon); */
	player freezeControls(false);
	activator freezeControls(false);
	}
}


bounce() //bounce room :p
{
bounce = getent("bounce_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_bounce","targetname");
acti = getent("origin_acti_bounce","targetname");
for(;;)
{
	bounce waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] activator giveweapon("knife_mp"); */
	/* [AUTO DELETE] player giveweapon("knife_mp"); */
	thread createhud(player.name + " ^5Selected 7bounce ^5Room ^7:]");
	wait 5;
	/* [AUTO DELETE] player iprintlnbold("^5GO^5!!!"); */
	/* [AUTO DELETE] activator iprintlnbold("^5GO^5!!!"); */
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("knife_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("knife_mp"); */
	}
}


givesniper() //bounce room s
{
givesnip = getEnt("givesnip_trig","targetname");

	for (;;)
	{
		givesnip waittill("trigger", player);
		/* [AUTO DELETE] player takeallweapons(); */
		wait 0.1;
		/* [AUTO DELETE] player giveweapon("intervention_mp"); */
		/* [AUTO DELETE] player giveweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] player switchtoweapon("intervention_mp"); */
		/* [AUTO DELETE] player givemaxammo("intervention_mp"); */
		/* [AUTO DELETE] player givemaxammo("deserteaglegold_mp"); */
	}
}


bouncejumperfail() // when jumper fail in jump room
{
	bouncejumperfail = getEnt("trigger_respawnjumper_bounce", "targetname");
	tpbouncejumperfail = getEnt("origin_jumper_bounce", "targetname");
	
	for (;;)
	{
		bouncejumperfail waittill("trigger", player);
		player setOrigin(tpbouncejumperfail.origin);
		player setPlayerAngles(tpbouncejumperfail.angles);
	}
}


bounceactifail() // when acti fail in jump room
{
	bounceactifail = getEnt("trigger_respawnacti_bounce", "targetname");
	tpbounceactifail = getEnt("origin_acti_bounce", "targetname");
	
	for (;;)
	{
		bounceactifail waittill("trigger", player);
		player setOrigin(tpbounceactifail.origin);
		player setPlayerAngles(tpbounceactifail.angles);
	}
}


run() //Speedrun room
{
run = getent("run_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_run","targetname");
acti = getent("origin_acti_run","targetname");
for(;;)
{
	run waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] activator giveweapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] player giveweapon("deserteaglegold_mp"); */
	thread createhud(player.name + " ^5Selected ^7spe^5ed ^7Ru^5n ^7Way !^5!^7!");
	/* [AUTO DELETE] wait 5; */
	/* [AUTO DELETE] player iprintlnbold("^5GO^5!!!"); */
	/* [AUTO DELETE] activator iprintlnbold("^5GO^5!!!"); */
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("deserteaglegold_mp"); */
	}
}


//RUNWAY\\

runwaysetup()
{

thread respawnactirun1();
thread respawnactirun2();
thread respawnactirun3();
thread respawnjumperrun1();
thread respawnjumperrun2();
thread respawnjumperrun3();
thread tpactirun1();
thread tpactirun2();
thread tpjumperrun1();
thread tpjumperrun2();
thread ifjumperwin();
thread ifactiwin();

}


respawnactirun1() // when acti fall lvl 1
{
	trigrespawnactirun1 = getEnt("trigger_acti_run_lvl1","targetname");
	tpactirun1 = getEnt("origin_acti_run", "targetname");
	
	for (;;)
	{
		trigrespawnactirun1 waittill("trigger", player);
		player setOrigin(tpactirun1.origin);
		player setPlayerAngles(tpactirun1.angles);
	}
}


respawnactirun2() // when acti fall lvl 2
{
	trigrespawnactirun2 = getEnt("trigger_acti_run_lvl2","targetname");
	tpactirun2 = getEnt("origin_acti_end_lvl2", "targetname");
	
	for (;;)
	{
		trigrespawnactirun2 waittill("trigger", player);
		player setOrigin(tpactirun2.origin);
		player setPlayerAngles(tpactirun2.angles);
	}
}


respawnactirun3() // when acti fall lvl 3
{
	trigrespawnactirun3 = getEnt("trigger_acti_run_lvl3","targetname");
	tpactirun3 = getEnt("origin_acti_end_lvl3", "targetname");
	
	for (;;)
	{
		trigrespawnactirun3 waittill("trigger", player);
		player setOrigin(tpactirun3.origin);
		player setPlayerAngles(tpactirun3.angles);
	}
}


respawnjumperrun1() // when jumper fall lvl 1
{
	trigrespawnjumperrun1 = getEnt("trigger_jumper_run_lvl1","targetname");
	tpjumperrun1 = getEnt("origin_jumper_run", "targetname");
	
	for (;;)
	{
		trigrespawnjumperrun1 waittill("trigger", player);
		player setOrigin(tpjumperrun1.origin);
		player setPlayerAngles(tpjumperrun1.angles);
	}
}


respawnjumperrun2() // when jumper fall lvl 2
{
	trigrespawnjumperrun2 = getEnt("trigger_jumper_run_lvl2","targetname");
	tpjumperrun2 = getEnt("origin_jumper_end_lvl2", "targetname");
	
	for (;;)
	{
		trigrespawnjumperrun2 waittill("trigger", player);
		player setOrigin(tpjumperrun2.origin);
		player setPlayerAngles(tpjumperrun2.angles);
	}
}


respawnjumperrun3() // when jumper fall lvl 3
{
	trigrespawnjumperrun3 = getEnt("trigger_jumper_run_lvl3","targetname");
	tpjumperrun3 = getEnt("origin_jumper_end_lvl3", "targetname");
	
	for (;;)
	{
		trigrespawnjumperrun3 waittill("trigger", player);
		player setOrigin(tpjumperrun3.origin);
		player setPlayerAngles(tpjumperrun3.angles);
	}
}


tpactirun1() // tp acti to the lvl 2
{
	trigactirun1 = getEnt("trigger_acti_end_lvl1", "targetname");
	tpactirun2 = getEnt("origin_acti_end_lvl2", "targetname");
	
	for (;;)
	{
		trigactirun1 waittill("trigger", player);
		player setOrigin(tpactirun2.origin);
		player setPlayerAngles(tpactirun2.angles);
	}
}


tpactirun2() // tp acti to the lvl 3
{
	trigactirun2 = getEnt("trigger_acti_end_lvl2", "targetname");
	tpactirun3 = getEnt("origin_acti_end_lvl3", "targetname");
	
	for (;;)
	{
		trigactirun2 waittill("trigger", player);
		player setOrigin(tpactirun3.origin);
		player setPlayerAngles(tpactirun3.angles);
	}
}


tpjumperrun1() // tp jumper to the lvl 2
{
	trigjumperrun1 = getEnt("trigger_jumper_end_lvl1", "targetname");
	tpjumperrun2 = getEnt("origin_jumper_end_lvl2", "targetname");
	
	for (;;)
	{
		trigjumperrun1 waittill("trigger", player);
		player setOrigin(tpjumperrun2.origin);
		player setPlayerAngles(tpjumperrun2.angles);
	}
}


tpjumperrun2() // tp jumper to the lvl 3
{
	trigjumperrun2 = getEnt("trigger_jumper_end_lvl2", "targetname");
	tpjumperrun3 = getEnt("origin_jumper_end_lvl3", "targetname");
	
	for (;;)
	{
		trigjumperrun2 waittill("trigger", player);
		player setOrigin(tpjumperrun3.origin);
		player setPlayerAngles(tpjumperrun3.angles);
	}
}


ifactiwin() //defined who win*
{
tpactirun4 = getEnt("origin_acti_end_lvl4", "targetname");
tpjumperrun4 = getEnt("origin_jumper_end_lvl4", "targetname");
actiwinrun = getEnt("trigger_acti_win_run","targetname");
definedjumper = getEnt("trigger_jumper_test_run","targetname");

for (;;)
{
	definedjumper waittill("trigger", player);
	actiwinrun waittill("trigger", activator);
	activator = GetActivator();
	/* [AUTO DELETE] wait 0.2; */
	activator setOrigin(tpactirun4.origin);
	activator setPlayerAngles(tpactirun4.angles);
	player setOrigin(tpjumperrun4.origin);
	player setPlayerAngles(tpjumperrun4.angles);
	/* [AUTO DELETE] wait 0.2; */
	/* [AUTO DELETE] activator giveweapon("intervention_mp"); */
	/* [AUTO DELETE] activator givemaxammo("intervention_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("intervention_mp"); */
	player freezeControls(true);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] wait 0.2; */
}
}


ifjumperwin() // defined who win**
{
tpactirun4 = getEnt("origin_acti_end_lvl4", "targetname");
tpjumperrun4 = getEnt("origin_jumper_end_lvl4", "targetname");
jumperwinrun = getEnt("trigger_jumper_win_run","targetname");

for (;;)
{
	jumperwinrun waittill("trigger", player);
	activator = GetActivator();
	/* [AUTO DELETE] wait 0.2; */
	player setOrigin(tpjumperrun4.origin);
	player setPlayerAngles(tpjumperrun4.angles);
	activator setOrigin(tpactirun4.origin);
	activator setPlayerAngles(tpactirun4.angles);
	/* [AUTO DELETE] wait 0.2; */
	/* [AUTO DELETE] player giveweapon("intervention_mp"); */
	/* [AUTO DELETE] player givemaxammo("intervention_mp"); */
	/* [AUTO DELETE] player switchtoweapon("intervention_mp"); */
	activator freezeControls(true);
	/* [AUTO DELETE] activator takeallweapons(); */
	/* [AUTO DELETE] wait 0.2; */
}
}


//RUNWAY\\

knife() //Knife room lel
{
knife = getent("knife_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_knife","targetname");
acti = getent("origin_acti_knife","targetname");
for(;;)
{
	knife waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] activator giveweapon("tomahawk_mp"); */
	/* [AUTO DELETE] player giveweapon("tomahawk_mp"); */
	thread createhud(player.name + " ^5Selected ^7Knife ^5ruum x^7D");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("tomahawk_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("tomahawk_mp"); */
	}
}


kniferoomturn()
{
    kniferoomturning = getent("knife_room_turn","targetname");
	
    while(1)
    {
		kniferoomturning rotateYaw(1800 ,4, 0.7);
		wait 8;
		kniferoomturning rotateYaw(-1800 ,4, 0.7);
		wait 8;
    }
}


shotgun() //Shot.G room
{
shotgun = getent("shotgun_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_shotgun","targetname");
acti = getent("origin_acti_shotgun","targetname");
for(;;)
{
	shotgun waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] activator giveweapon("m1014_grip_mp"); */
	/* [AUTO DELETE] player giveweapon("m1014_grip_mp"); */
	/* [AUTO DELETE] player givemaxammo("m1014_grip_mp"); */
	/* [AUTO DELETE] activator givemaxammo("m1014_grip_mp"); */
	thread createhud(player.name + " ^5Selected ^7Shotgun ^5room :^7D");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("m1014_grip_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("m1014_grip_mp"); */
	}
}


shotgunactifail() // when acti fail in shotgun room
{
	shotgunactifail = getEnt("trigger_acti_shotgun", "targetname");
	tpshotgunactifail = getEnt("origin_acti_shotgun", "targetname");
	
	for (;;)
	{
		shotgunactifail waittill("trigger", player);
		player setOrigin(tpshotgunactifail.origin);
		player setPlayerAngles(tpshotgunactifail.angles);
	}
}


shotgunjumperfail() // when jumper fail in shotgun room
{
	shotgunjumperfail = getEnt("trigger_jumper_shotgun", "targetname");
	tpshotgunjumperfail = getEnt("origin_jumper_shotgun", "targetname");
	
	for (;;)
	{
		shotgunjumperfail waittill("trigger", player);
		player setOrigin(tpshotgunjumperfail.origin);
		player setPlayerAngles(tpshotgunjumperfail.angles);
	}
}


old() //Old way ;D
{
fakewall = getent("old_wall","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_old","targetname");
acti = getent("origin_acti_old","targetname");
for(;;)
{
	old waittill("trigger", player);
	old delete();
	player thread waitdead();
	thread createhud(player.name + " ^5Selected ^1Old Way C;");
	fakewall show();
	fakewall solid();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player giveweapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] wait 5; */
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("deserteaglegold_mp"); */
	}
}


oldfakewall() //For old way
{
fakewall = getent("old_wall","targetname");
fakewall hide();
fakewall notsolid();
}


//OTHER TP HERE\\

actitpsetup() //TP ACTI & FX
{

thread actitp1();
thread actitp2();
thread actitp3();
thread actitpback1();
thread actitpback2();
thread actitpback3();

}


actitp1() // tp1acti
{
	trigacti1 = getEnt("trig_tpacti_1", "targetname");
	tpacti1 = getEnt("origin_tpacti_1", "targetname");
	glow1 = getEnt("glow1", "targetname");
	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow1.origin), 3, (glow1.origin) + (0, 0, 90));
	
	for (;;)
	{
		trigacti1 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpacti1.origin);
		player setPlayerAngles(tpacti1.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitp2() // tp2acti
{
	trigacti2 = getEnt("trig_tpacti_2", "targetname");
	tpacti2 = getEnt("origin_tpacti_2", "targetname");
	glow2 = getEnt("glow2", "targetname");
	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow2.origin), 3, (glow2.origin) + (0, 0, 90));
	
	for (;;)
	{
		trigacti2 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpacti2.origin);
		player setPlayerAngles(tpacti2.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitp3() // tp3acti
{
	trigacti3 = getEnt("trig_tpacti_3", "targetname");
	tpacti3 = getEnt("origin_tpacti_3", "targetname");
	glow3 = getEnt("glow3", "targetname");
	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow3.origin), 3, (glow3.origin) + (0, 0, 90));
	
	for (;;)
	{
		trigacti3 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpacti3.origin);
		player setPlayerAngles(tpacti3.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitpback1() // tp1actiback
{
	trigactiback1 = getEnt("trig_tpacti_1_back", "targetname");
	tpactiback1 = getEnt("origin_tpacti_1_back", "targetname");
	glow1back = getEnt("glow1back", "targetname");
	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow1back.origin), 3, (glow1back.origin) + (0, 0, 90));
	
	for (;;)
	{
		trigactiback1 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpactiback1.origin);
		player setPlayerAngles(tpactiback1.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitpback2() // tp2actiback
{
	trigactiback2 = getEnt("trig_tpacti_2_back", "targetname");
	tpactiback2 = getEnt("origin_tpacti_2_back", "targetname");
	glow2back = getEnt("glow2back", "targetname");
	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow2back.origin), 3, (glow2back.origin) + (0, 0, 90));
	
	for (;;)
	{
		trigactiback2 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpactiback2.origin);
		player setPlayerAngles(tpactiback2.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitpback3() // tp3actiback
{
	trigactiback3 = getEnt("trig_tpacti_3_back", "targetname");
	tpactiback3 = getEnt("origin_tpacti_3_back", "targetname");
	glow3back = getEnt("glow3back", "targetname");
	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow3back.origin), 3, (glow3back.origin) + (0, 0, 90));
	
	for (;;)
	{
		trigactiback3 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpactiback3.origin);
		player setPlayerAngles(tpactiback3.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


tpsetup() //tp susu
{

thread hardway();
thread easyway();
thread endway();
thread finhardway();

thread sanicsecret();
thread picksanicmate();

thread tpeasysecret();
thread endeasysecret();

thread tphardsecret(); //there is no end ://
thread respawnhard();
thread ggnore();
// thread speedon();
// thread speedoff();
thread giverpg();

}


giverpg()
{
	giverpg = getEnt("give_rpg", "targetname");
	
	for(;;)
	{
		giverpg waittill("trigger", player);
		/* [AUTO DELETE] player giveweapon("rpg_mp"); */
		/* [AUTO DELETE] player switchtoweapon("rpg_mp"); */
		/* [AUTO DELETE] player givemaxammo("rpg_mp"); */
		/* [AUTO DELETE] player iprintlnbold("GOOD ^5LUCK"); */
	}
}


respawnhard()
{
	trighardrespawn = getEnt("respawn_hard_secret", "targetname");
	tphardsecret1 = getEnt("hard_secret_ori", "targetname");
	
	for (;;)
	{
		trighardrespawn waittill("trigger", player);
		player setOrigin(tphardsecret1.origin);
		player setPlayerAngles(tphardsecret1.angles);
		player freezeControls(true);
		/* [AUTO DELETE] wait 2; */
		player freezeControls(false);
	}
}


tphardsecret()
{
	trighardsecret = getEnt("trigger_secret_hard_1", "targetname");
	tphardsecret = getEnt("hard_secret_ori", "targetname");
	
	// for (;;)
	// {
	// 	trighardsecret waittill("trigger", player);
	// 	/* [AUTO DELETE] iprintlnbold(player.name + " ^7entered the ^1HARD ^7Secret !!"); */
	// 	player setOrigin(tphardsecret.origin);
	// 	player setPlayerAngles(tphardsecret.angles);
	// 	player freezeControls(true);
	// 	wait 2;
	// 	player freezeControls(false);
	// }
}


ggnore() //Bad script for HARD SECRET. ://
{
ggnore = getEnt("trigger_hard_gg_no_re","targetname");

	for(;;)
	{
	ggnore waittill("trigger", player);
	player thread sr\api\_map::finish_way("s1");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 3000); */
	/* [AUTO DELETE] iprintlnbold(player.name + " ^2Ended ^7the ^1HARD SECRET ^7noice"); */
	// wait 2;
	// player antiglitch3();
	// wait 10;
	}
}

antiglitch3() //ng3
{ 
// self setClientDvar("g_gravity", 800 );
//  [AUTO DELETE] self iPrintlnBold("^1Anti Glitch System..."); 
// wait 0.2;
// self thread braxi\_common::clientCmd( "disconnect; wait 2; reconnect" );
}


speedon()
{
speedon = getEnt("trigger_hard_speed_on","targetname");

for(;;)
{
speedon waittill("trigger", player);
player endon("disconnect");
player setClientDvar("g_speed", 500 );
player setClientDvar("g_gravity", 500 );
player antiglitch2();

while( isAlive( player ) && isDefined( player ) )
if( isDefined( level.activ ) && isAlive( level.activ ) )
wait 1;
}
}

antiglitch2() //ng2
{ 
// self common_scripts\utility::waittill_any("death","disconnect");
// self setClientDvar("g_gravity", 800 );
//  [AUTO DELETE] self iPrintlnBold("^1Anti Glitch System..."); 
// wait 2;
// self thread braxi\_common::clientCmd( "disconnect; wait 2; reconnect" );
}


speedoff()
{
speedoff = getEnt("trigger_hard_speed_off","targetname");

for(;;)
{
speedoff waittill("trigger", player);
player endon("disconnect");
player setClientDvar("g_speed", 220 );
player setClientDvar("g_gravity", 800 );
player antiglitch1();

while( isAlive( player ) && isDefined( player ) )
if( isDefined( level.activ ) && isAlive( level.activ ) )
wait 1;
}
}

antiglitch1() //ng2
{ 
// self common_scripts\utility::waittill_any("death","disconnect");
// self setClientDvar("g_gravity", 800 );
//  [AUTO DELETE] self iPrintlnBold("^1Anti Glitch System..."); 
// wait 2;
// self thread braxi\_common::clientCmd( "disconnect; wait 2; reconnect" );
}


sanicsecret() //Sanic fast m8
{
	// trigsanicsecret = getEnt("trigger_sanic_secret", "targetname");
	// tpsanicsecret = getEnt("origin_sanic_secret", "targetname");
	
	// {
	// 	trigsanicsecret waittill("trigger", player);
	// 	player setOrigin(tpsanicsecret.origin);
	// 	player setPlayerAngles(tpsanicsecret.angles);
	// 	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 60); */
	// 	trigsanicsecret triggerOff();
	// }
}


picksanicmate() //gotta go fast lel
{
trigpicksanic = getEnt("trigger_pick_sanic", "targetname");
tpafterpick = getEnt("origin_end_sanic_secret", "targetname");

	{
	trigpicksanic waittill("trigger", player);
	/* [AUTO DELETE] iprintlnbold(player.name + " is ^5Sanic ^7! D:"); */
	player setModel("shadow");
	player setOrigin(tpafterpick.origin);
	player setPlayerAngles(tpafterpick.angles);
	}
}


finhardway() //finish hard D:
{
	finhardtrig = getEnt("trigger_finish_hard_way", "targetname");
	finhardori = getEnt("origin_finish_hard_way", "targetname");
	
	for (;;)
	{
		finhardtrig waittill("trigger", player);
		player setOrigin(finhardori.origin);
		player setPlayerAngles(finhardori.angles);
	}
}


hardway() //TP to Hard Way
{
	trighard = getEnt("trigger_hard_way", "targetname");
	tphard = getEnt("origin_hard_way", "targetname");
	
	for (;;)
	{
		trighard waittill("trigger", player);
		player setOrigin(tphard.origin);
		player setPlayerAngles(tphard.angles);
		player thread sr\api\_map::change_way("ns1");

	}
}


easyway() //TP to Easy Way
{
	trig = getEnt("trigger_easy_way", "targetname");
	tp = getEnt("origin_easy_way", "targetname");
	
	for (;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
		player thread sr\api\_map::change_way("ns0");
	}
}


endway() //TP to End Way
{
	trigend = getEnt("trigger_end_way", "targetname");
	tpend = getEnt("origin_end_way", "targetname");
	
	for (;;)
	{
		trigend waittill("trigger", player);
		player setOrigin(tpend.origin);
		player setPlayerAngles(tpend.angles);
	}
}


tpeasysecret()
{
	// tpeasytrig = getEnt("trigger_secret_easy_1", "targetname");
	// tpeasyori = getEnt("origin_easy_secret_1", "targetname");
	
	// for (;;)
	// {
	// 	tpeasytrig waittill("trigger", player);
	// 	player setOrigin(tpeasyori.origin);
	// 	player setPlayerAngles(tpeasyori.angles);
	// 	player thread sr\api\_map::change_way("s0");
	// }
}


endeasysecret()
{
	endeasytrig = getEnt("trigger_end_easy_secret", "targetname");
	endeasyori = getEnt("origin_end_easy_secret", "targetname");
	
	for (;;)
	{
		endeasytrig waittill("trigger", player);
		// player setOrigin(endeasyori.origin);
		// player setPlayerAngles(endeasyori.angles);
		player thread sr\api\_map::finish_way("s0");
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 666); */
	}
}


//OTHER TP HERE\\

//TURN\\

turnsetup()
{

thread lolzlogo1();
thread lolzlogo2();
thread lolzlogo3();
thread lolzlogo4();
thread lolzlogo5();
thread arrow1();
thread arrow2();
thread finturn();

}


arrow1()
{
    arrow1 = getent("arrow_1","targetname");
	
    while(1)
    {
        arrow1 moveY(60, 3, 0.5, 0);
		wait 3.06;
		arrow1 moveY(-60, 3, 0, 0.5);
		wait 3.06;
    }
}


arrow2()
{
    arrow2 = getent("arrow_2","targetname");
	
    while(1)
    {
        arrow2 moveZ(50, 3, 0.5, 0);
		wait 3.06;
		arrow2 moveZ(-50, 3, 0, 0.5);
		wait 3.06;
    }
}


lolzlogo1()
{
    lolz1 = getent("lolz_turn_1","targetname");
	
    while(1)
    {
        lolz1 rotateYaw(360, 5);
		wait 1;
    }
}


lolzlogo2()
{
    lolz2 = getent("lolz_turn_2","targetname");
	
    while(1)
    {
        lolz2 rotateRoll(360, 5);
		wait 1;
    }
}


lolzlogo3()
{
    lolz3 = getent("lolz_turn_3","targetname");
	
    while(1)
    {
        lolz3 rotateYaw(360, 5);
		wait 1;
    }
}


lolzlogo4()
{
    lolz4 = getent("lolz_turn_4","targetname");
	
    while(1)
    {
        lolz4 rotateYaw(360, 5);
		wait 1;
    }
}


lolzlogo5()
{
    lolz1 = getent("lolz_turn_5","targetname");
	
    while(1)
    {
        lolz1 rotateYaw(360, 5);
		wait 1;
    }
}


finturn()
{
    finturn = getent("fin_turn","targetname");
	
    while(1)
    {
        finturn rotateYaw(360, 5);
		wait 1;
    }
}


lolzsecret333setup()
{
	thread lolzsecrettp333();
	thread giverpg2();
	thread lolzsecret333win();
}


lolzsecrettp333()
{
	trig333 = getEnt("lolz_secret_trig", "targetname");
	tp333 = getEnt("lolz_secret_ori", "targetname");

	{
		trig333 waittill("trigger", player);
		player setOrigin(tp333.origin);
		player setPlayerAngles(tp333.angles);
		wait 1;
		/* [AUTO DELETE] iprintlnbold(player.name + " what are you doin HERE?? :o"); */
	}
}


giverpg2()
{
	giverpg2 = getEnt("give_rpg_2", "targetname");
	
	{
		giverpg2 waittill("trigger", player);
		/* [AUTO DELETE] player giveweapon("rpg_mp"); */
		/* [AUTO DELETE] player switchtoweapon("rpg_mp"); */
		/* [AUTO DELETE] player givemaxammo("rpg_mp"); */
	}
}


lolzsecret333win()
{
	trig333win = getEnt("lolz_secret_win", "targetname");
	tp333win = getEnt("lolz_secret_win_tp", "targetname");
	glow7 = getEnt("glow7", "targetname");
	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow7.origin), 3, (glow7.origin) + (0, 0, 90));
	
	{
		trig333win waittill("trigger", player);
		player setOrigin(tp333win.origin);
		player setPlayerAngles(tp333win.angles);
		/* [AUTO DELETE] player braxi\_rank::giveRankXp("", 420); */
	}
}
