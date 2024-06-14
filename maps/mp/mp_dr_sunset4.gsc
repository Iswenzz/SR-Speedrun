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

//Steam: ^5CAR ^0DarkSTEP
//Discord: Tortellini#7390
//YouTube: Tortellini
//PayPal: paypal.me/darktest
//Every donator will get lifetime VIP access to all my updated maps!
//Minor thanks: Nobody :)
//Feel free to copy without permission ;)

#include braxi\_common;
#include common_scripts\utility;
#include braxi\_rank;


main()
{
thread sr\api\_map::createSpawnOrigin((17.125, -64, 17.125), 0);
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	precacheShader("loadscreen_mp_dr_sunset4");
	precacheMenu("sunsetmusic");

	setDvar( "r_specularcolorscale", "1" );

	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","2500");
	setDvar("bg_fallDamageMinHeight","1000000");
	setDvar("bg_fallDamageMaxHeight","10000000");

	level.room = true;
	level.trig_old = getEnt("trig_old", "targetname");
	level.cambiato = false;

	level.trap6hurt = getEnt("trap6hurt", "targetname");
	level.trap6hurt thread maps\mp\_utility::triggerOff();
	level.oldx = getEnt("oldx", "targetname");
	level.oldx hide();
	level.oldx notSolid();

	level.music=[];
    level.music[0]["song"]    ="Krewella - Lights And Thunder";
    level.music[0]["alias"]    ="song1";
    level.music[1]["song"]    ="Illenium - Take You Down";
    level.music[1]["alias"]    ="song2";
    level.music[2]["song"]    ="Blasterjaxx - Narco";
    level.music[2]["alias"]    ="song3";
    level.music[3]["song"]    ="KSHMR & Sonu Nigam - Underwater";
    level.music[3]["alias"]    ="song4";
    level.music[4]["song"]    ="KSHMR x Sak Noel - Bruk It Down";
    level.music[4]["alias"]    ="song5";
	level.music[5]["song"]    ="Dope Arcade - Ascension";
    level.music[5]["alias"]    ="song6";
	level.music[6]["song"]    ="Krewella - Alibi";
    level.music[6]["alias"]    ="song7";

	level.boom_fx = loadFX("explosions/default_explosion");

	//thread addTestClients();
	//thread joinsetter();
	//thread musicbox();
	thread startdoor();
	//thread bounceroom();
	//thread btp();
	//thread bouncesniper();
	//thread old();
	//thread knife();
	//thread sniper();
	//thread stp();

	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();

	//thread hardenter();
	thread hardtp1();
	thread hardend();

	thread b210();
	thread c210();
	thread d210();
	thread e210();
	thread f210();
	thread g210();

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_speedrun::createTeleporter((435.431, 182.389, 16.125), 105, 125, (-4489, 13254, 2371), 355, "freeze", "red", "secret_0");

	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
}

	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
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


joinsetter()
{

	for(;;)
	{
		level waittill( "connected", player );
			player.hasWeapon = 0;
			player.hc = 0;
	}

}

musicbox()
{
	trig = getEnt("musictrigger", "targetname");
	trig waittill("trigger", player);
	trig setHintString("Press ^3&&1^7 to select song");
	trig delete();
	player endon("song_picked");
	player freezeControls(1);
	//player thread musicMenu();
}

musicMenu()
{
	/*
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "song_picked" );

	self openMenu("sunsetmusic");

	self thread cleanUpOnPick();
	self thread cleanUpOnDeath();

	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "loadscreen_mp_dr_sunset4", 360, 200 );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 358, 1, "center", "top", 1.4 );
	self.hud_music[i].sort = 885;
	self.hud_music[i].font = "objective";
	self.hud_music[i] setText( "\n                 Press ^1[^71^1/^72^1/^73^1/^74^1/^75^1/^76^1/^77]^7 to choose a song" );

	j = 0;
	self.hud_music_s[j] = braxi\_mod::addTextHud( self, 172, 230+(0*16), 0.93, "left", "top", 1.4 );
	self.hud_music_s[j].sort = 900;
	self.hud_music_s[j].font = "objective";
	self.hud_music_s[j] setText("\n^11 ^3Krewella - Lights And Thunder\n^12 ^3Illenium - Take You Down\n^13 ^3Blasterjaxx - Narco\n^14 ^3KSHMR & Sonu Nigam - Underwater\n^15 ^3KSHMR x Sak Noel - Bruk It Downn\n^16 ^3Dope Arcade - Ascension\n^17 ^3Krewella - Alibi");

	for(;;)
	{
		self waittill("menuresponse", menu, response);

		if( menu == "sunsetmusic")
		{
			if(response == "song1")
			{
				ambientPlay("song1");
				iprintln("^1Now Playing: ^3Krewella - Lights And Thunder");
				self freezeControls(0);
				self notify("song_picked");
				break;
			}

			if(response == "song2")
			{
				ambientPlay("song2");
				iprintln("^1Now Playing: ^3Illenium - Take You Down");
				self freezeControls(0);
				self notify("song_picked");
				break;
			}

			if(response == "song3")
			{
				ambientPlay("song3");
				iprintln("^1Now Playing: ^3Blasterjaxx - Narco");
				self freezeControls(0);
				self notify("song_picked");
				break;
			}

			if(response == "song4")
			{
				ambientPlay("song4");
				iprintln("^1Now Playing: ^3KSHMR & Sonu Nigam - Underwater");
				self freezeControls(0);
				self notify("song_picked");
				break;
			}

			if(response == "song5")
			{
				ambientPlay("song5");
				iprintln("^1Now Playing: ^3KSHMR x Sak Noel - Bruk It Down");
				self freezeControls(0);
				self notify("song_picked");
				break;
			}

			if(response == "song6")
			{
				ambientPlay("song6");
				iprintln("^1Now Playing: ^3Dope Arcade - Ascension");
				self freezeControls(0);
				self notify("song_picked");
				break;
			}

			if(response == "song7")
			{
				ambientPlay("song7");
				iprintln("^1Now Playing: ^3Krewella - Alibi");
				self freezeControls(0);
				self notify("song_picked");
				break;
			}
			else
			{
				self waittill("menuresponse", menu, response2);
				ambientPlay("song1");
				iprintln("^1Now Playing: ^3Krewella - Lights And Thunder");
				self freezeControls(0);

				songs = strTok(saveSongs(response+response2), "|");

				self notify("song_picked");
				break;
			}
		}
	}
    */
}


saveSongs(songs)
{
	songs2 = strTok(songs, "8");
	output = "";

	for (i = 0; i < songs2.size; i++)
	{
		if (i < (songs2.size-1))
		output = output + songs2[i] + ";";
		else
		output = output + songs2[i];
	}

	songs2 = strTok(output, "9");
	output = "";

	for (i = 0; i < songs2.size; i++)
	{
		if (i < (songs2.size-1))
		output = output + songs2[i] + "\"";
		else
		output = output + songs2[i];
	}

	songs2 = strTok(output, "7");
	output = "";

	for (i = 0; i < songs2.size; i++)
	{
		if (i < (songs2.size-1))
		output = output + songs2[i] + " ";
		else
		output = output + songs2[i];
	}

	return output;
}

cleanUpOnDeath()
{
	self waittill("death");

	if(isDefined(self.hud_music))
	{
		for(i=0; i<self.hud_music.size; i++)
			if(isDefined(self.hud_music[i]))
				self.hud_music[i] Destroy();
	}

	if(isDefined(self.hud_music_s))
	{
		for(i=0; i<self.hud_music_s.size; i++)
			if(isDefined(self.hud_music_s[i]))
				self.hud_music_s[i] Destroy();
	}
}

cleanUpOnPick()
{
	self waittill("song_picked");

	if(isDefined(self.hud_music))
	{
		for(i=0; i<self.hud_music.size; i++)
			if(isDefined(self.hud_music[i]))
				self.hud_music[i] Destroy();
	}

	if(isDefined(self.hud_music_s))
	{
		for(i=0; i<self.hud_music_s.size; i++)
			if(isDefined(self.hud_music_s[i]))
				self.hud_music_s[i] Destroy();
	}
}

startdoor() {
	door = getEnt("startdoor", "targetname");
		/*if(game["roundsplayed"] > 0) {
			thread games();
		}
		else {
			trig = getEnt("trig_freehint","targetname");
			trig setHintString("^1Room selection disabled on Free Run!");
		}*/
	//thread credits();
	door moveZ(-324, 1.5);
}


credits()
{
wait 2;
	noti = SpawnStruct();
	noti.titleText = "^1Sunset ^34";
	noti.notifyText = "^1Map made by ^3DarkSTEP";
	noti.duration = 6;
	noti.glowcolor = (1,.2,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	wait 8;
	noti.titleText = "^3Start opening...";
	noti.notifyText = "";
	noti.glowcolor = (1,.2,0);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
}

antiglitcher()
{
self common_scripts\utility::waittill_any("death","disconnect");
wait 0.05;
if (level.room == true)
{
		iPrintlnBold("^3"+self.name+" ^1died");
		wait 0.2;
		iPrintlnBold("^3Room selection open!");
}
}

waitdead()
{
activator = GetActivator();
bounce = getent("trig_bounce","targetname");
sniper = getent("trig_sniper","targetname");
knife = getent("trig_knife","targetname");

bounce thread maps\mp\_utility::triggerOff();
sniper thread maps\mp\_utility::triggerOff();
knife thread maps\mp\_utility::triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
activator freezeControls(false);
self freezeControls(false);

activator.health = activator.maxhealth;
bounce thread maps\mp\_utility::triggerOn();
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
hud_start.glowcolor = (0,.2,.8);
hud_start setText(messages);
//hud_start setPulseFX( 100, 4000, 500 );
hud_start setPulseFX( 70, 4000, 500 );
wait 7;
if(isdefined(hud_start))
	hud_start destroy();
}

bounceroom()
{
bounce = getent("trig_bounce","targetname");
jumper = getent("o_bounce1","targetname");
acti = getent("o_bounce2","targetname");
bounce setHintString("^2Bounce");
for(;;)
{
	bounce waittill("trigger", player);
	//old delete();
	level.trig_old setHintString("^1OUT OF SERVICE");
	level.trig_old thread maps\mp\_utility::triggerOff();
	player thread waitdead();
	player thread antiglitcher();
	activator = GetActivator();
	player.hasWeapon = 0;
	activator.hasWeapon = 0;

	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("knife_mp");
	player giveweapon("knife_mp");
	thread createhud(player.name + " ^5entered ^2Bounce^5 room!");
	wait 5;
	player iprintlnbold("^5FIGHT!");
	activator iprintlnbold("^5FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
	}
}

btp()
{
		trig = getEnt("trig_btp", "targetname");
		jumper = getEnt("o_bounce1","targetname");
		acti = getEnt("o_bounce2","targetname");
		for(;;)
		{
			trig waittill("trigger", player);
			if(player.pers["team"] == "axis")
			{
				player setOrigin(acti.origin);
				player setPlayerAngles(acti.angles);
			}
			else
			{
				player setOrigin(jumper.origin);
				player setPlayerAngles(jumper.angles);
			}
		}
}

bouncesniper()
{
givesnip = getEnt("trig_bsniper","targetname");
givesnip setHintString("^3Press ^1F ^3to get a Sniper!");
	for (;;)
	{
		givesnip waittill("trigger", player);
		if (player.hasWeapon == 0)
		{
		player takeallweapons();
		player giveweapon("m40a3_mp");
		player giveweapon("remington700_mp");
		player switchtoweapon("remington700_mp");
		player givemaxammo("m40a3_mp");
		player givemaxammo("remington700_mp");
		player.hasWeapon = 1;
		}
		else player iPrintLnBold("^1You already got a Sniper!");
	}
}

old()
{
	bounce = getent("trig_bounce","targetname");
	sniper = getent("trig_sniper","targetname");
	knife = getent("trig_knife","targetname");
	old = getent("trig_old","targetname");
	oldoor = getent("oldoor","targetname");
		old setHintString("OLD");

		old waittill("trigger", player);
	/*	player giveWeapon(level.firstgun);
		player giveMaxAmmo(level.firstgun);
		player switchToWeapon(level.firstgun);  	*/
		bounce thread maps\mp\_utility::triggerOff();
		sniper thread maps\mp\_utility::triggerOff();
		knife thread maps\mp\_utility::triggerOff();
		old delete();
		thread createhud(player.name + " ^3opened ^1OLD ^3way!");
		level.room = false;
		/*if(level.room == true)
		{
			activator = GetActivator();
			activator freezeControls(true);
			activator setOrigin(oa.origin);
			activator setPlayerAngles(oa.angles);
			activator iPrintLn("^3Antiglitch");
			wait 1;
			activator freezeControls(true);
		}*/
		wait 2;
		oldoor moveZ(-170 , 1);
		wait 1;
		level.oldx show();
		level.oldx solid();
}

knife()
{
knife = getent("trig_knife","targetname");
jumper = getent("o_knife1","targetname");
acti = getent("o_knife2","targetname");
knife setHintString("^3Knife");
for(;;)
{
	knife waittill("trigger", player);

	level.trig_old setHintString("^1OUT OF SERVICE");
	level.trig_old thread maps\mp\_utility::triggerOff();
	player thread waitdead();
	player thread antiglitcher();
	activator = GetActivator();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("knife_mp");
	player giveweapon("knife_mp");
	thread createhud(player.name + " ^3entered Knife room!");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
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
	level.trig_old setHintString("^1OUT OF SERVICE");
	level.trig_old thread maps\mp\_utility::triggerOff();
	player thread waitdead();
	player thread antiglitcher();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("m40a3_mp");
	activator giveweapon("m40a3_mp");
	player giveweapon("remington700_mp");
	activator giveweapon("remington700_mp");
	thread createhud(player.name + " ^3selected ^1Sniper ^3room!");
	wait 5;
	player iprintlnbold("^8FIGHT!");
	activator iprintlnbold("^9FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("m40a3_mp");
	activator switchtoweapon("m40a3_mp");
	player givemaxammo("m40a3_mp");
	activator givemaxammo("m40a3_mp");
	}
}

stp()
{
		trig = getEnt("trig_stp", "targetname");
		jumper = getEnt("o_sniper1","targetname");
		acti = getEnt("o_sniper2","targetname");
		for(;;)
		{
			trig waittill("trigger", player);
			if(player.pers["team"] == "axis")
			{
				player setOrigin(acti.origin);
				player setPlayerAngles(acti.angles);
			}
			else
			{
				player setOrigin(jumper.origin);
				player setPlayerAngles(jumper.angles);
			}
		}
}

trap1()
{
	trig = getEnt("trig_trap1","targetname");
	a = getEnt("trap1a","targetname");
	b = getEntArray("trap1b","targetname");
	trig setHintString("^3Press ^1F ^3to activate!");
	trig waittill("trigger", player);
	trig delete();
	a moveZ(-400, 1.5);
	wait 1.5;
	for(;;)
	{
		b[0] rotateYaw(720,3);
		b[1] rotateYaw(-720,3);
		wait 6;
		b[0] rotateYaw(-720,3);
		b[1] rotateYaw(720,3);
		wait 6;
	}
}

trap2()
{
	trig = getEnt("trig_trap2","targetname");
	a = getEnt("trap2a","targetname");
	b = getEnt("trap2b","targetname");
	c = getEnt("trap2c","targetname");
	am = getEntArray("trap2am","targetname");
	bm = getEntArray("trap2bm","targetname");
	cm = getEntArray("trap2cm","targetname");
	for(i = 0; i < am.size; i++)
	{
		am[i] linkTo(a);
		bm[i] linkTo(b);
		cm[i] linkTo(c);
	}
	trig setHintString("^3Press ^1F ^3to activate!");
	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
		a moveZ(-500,1);
		wait 1.2;
		b moveZ(-500,1);
		wait 1.2;
		c moveZ(-500,1);
		wait 3.5;
		a moveZ(500, .7);
		wait 1;
		b moveZ(500,.7);
		wait 1;
		c moveZ(500,.7);
		wait 4;
	}
}

trap3()
{
	brush = getEnt("trap3a", "targetname");
	brush2 = getEnt("trap3b", "targetname");
	am = getEntArray("trap3am", "targetname");
	bm = getEntArray("trap3bm", "targetname");
	trig = getEnt("trig_trap3", "targetname");

	for(i = 0; i < am.size; i++)
	{
		am[i] linkTo(brush);
		bm[i] linkTo(brush2);
	}

	trig setHintString("^3Press ^1F ^3to activate!");

	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
	brush moveZ(-500, 1.5);
	wait 2;
	brush moveZ(500, 1.5);
	wait 2;
	brush2 moveZ(-500, 1.5);
	wait 2;
	brush2 moveZ(500, 1.5);
	wait 2;
	}
}

trap4()
{
	a = getEnt("trap4", "targetname");
	trig = getEnt("trig_trap4", "targetname");
	trig setHintString("^3Press ^1F ^3to activate!");

	trig waittill("trigger", player);
	trig delete();
	a moveZ(-500, 1);
	wait 1;
}

trap5()
{
	a = getEnt("trap5", "targetname");
	trig = getEnt("trig_trap5", "targetname");
	trig setHintString("^3Press ^1F ^3to activate!");

	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
		a rotateYaw(720, 3);
		wait 6;
		a rotateYaw(-720, 3);
		wait 6;
	}
}

trap6()
{
	a = getEnt("trap6", "targetname");
	trig = getEnt("trig_trap6", "targetname");
	o = getEnt("fx_explosion", "targetname");
	a moveZ(-208, 1);
	wait 1;
	trig setHintString("^3Press ^1F ^3to activate!");

	trig waittill("trigger", player);
	trig delete();
	a moveZ(208, 1);
	wait 3;
	playFX(level.boom_fx, o.origin);
	o playSound( "artillery_impact" );
	level.trap6hurt thread maps\mp\_utility::triggerOn();
	wait .3;
	level.trap6hurt thread maps\mp\_utility::triggerOff();
	wait 4.7;
	a moveZ(-208, 1);
}

trap7()
{
	a = getEnt("trap7a", "targetname");
	b = getEnt("trap7b", "targetname");
	ar = getEntArray("trap7ar", "targetname");
	br = getEntArray("trap7br", "targetname");
	trig = getEnt("trig_trap7", "targetname");


	trig setHintString("^3Press ^1F ^3to activate!");

	trig waittill("trigger", player);
	trig delete();

		/*for(i = 0; i < ar.size; i++)
	{
		ar[i] linkTo(a);
		br[i] linkTo(b);
	}*/
	for(i = 0; i < ar.size; i++)
	{
		ar[i] thread modelRotator();
		br[i] thread modelRotator2();
	}

	//a linkTo(ar);
	//b linkTo(br);
	a moveZ(-64, .75);
	b moveZ(64, .75);
	for(i = 0; i < ar.size; i++)
	{
	ar[i] moveZ(-64, .75);
	br[i] moveZ(64, .75);
	}
	wait .75;
	for(;;)
	{
		a moveZ(128, 1.5);
		b moveZ(-128, 1.5);
		for(i = 0; i < ar.size; i++)
		{
		ar[i] moveZ(128, 1.5);
		br[i] moveZ(-128, 1.5);
		}
		wait 1.5;
		a moveZ(-128, 1.5);
		b moveZ(128, 1.5);
		for(i = 0; i < ar.size; i++)
		{
		ar[i] moveZ(-128, 1.5);
		br[i] moveZ(128, 1.5);
		}
		wait 1.5;
	}
}

modelRotator()
{
	while(isDefined(self))
	{
		self rotatePitch(360, 2.5);
		wait 2.5;
	}
}

modelRotator2()
{
	while(isDefined(self))
	{
		self rotatePitch(-360, 2.5);
		wait 2.5;
	}
}

hardenter()
{
	spawn = getEnt("o_secretenter","targetname");
	trig1 = getEnt("trig_secretenter","targetname");
	{
	for(;;)
	{
	trig1 waittill("trigger",player);
		{
			player setplayerangles(spawn.angles);
			player setorigin(spawn.origin);
			player iPrintLnBold("^3Welcome to Secret");
			player.hc = 1;
		}
	}
}
}

hardtp1()
{
	trig = getEnt("trig_main190", "targetname");
	target = getEnt("o_secretenter", "targetname");
	hc1 = getEnt("o_hc1", "targetname");
	hc2 = getEnt("o_hc2", "targetname");
	hc3 = getEnt("o_hc3", "targetname");
	hc4 = getEnt("o_hc4", "targetname");
	hc5 = getEnt("o_hc5", "targetname");
	hc6 = getEnt("o_hc6", "targetname");

	while(1)
	{
		trig waittill("trigger", player);
		if(player.hc == 1)
		{
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
		}
		else if(player.hc == 2)
		{
			player setOrigin( hc1.origin );
			player setPlayerAngles( hc1.angles );
		}
		else if(player.hc == 3)
		{
			player setOrigin( hc2.origin );
			player setPlayerAngles( hc2.angles );
		}
		else if(player.hc == 4)
		{
			player setOrigin( hc3.origin );
			player setPlayerAngles( hc3.angles );
		}
		else if(player.hc == 5)
		{
			player setOrigin( hc4.origin );
			player setPlayerAngles( hc4.angles );
		}
		else if(player.hc == 6)
		{
			player setOrigin( hc5.origin );
			player setPlayerAngles( hc5.angles );
		}
		else if(player.hc == 7)
		{
			player setOrigin( hc6.origin );
			player setPlayerAngles( hc6.angles );
		}
	}
}

b210()
{
	trig = getEnt("trig_hc1", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.hc = 2;
	wait .5;
	}
}

c210()
{
	trig = getEnt("trig_hc2", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.hc = 3;
	wait .5;
	}
}

d210()
{
	trig = getEnt("trig_hc3", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.hc = 4;
	wait .5;
	}
}

e210()
{
	trig = getEnt("trig_hc4", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.hc = 5;
	wait .5;
	}
}

f210()
{
	trig = getEnt("trig_hc5", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.hc = 6;
	wait .5;
	}
}

g210()
{
	trig = getEnt("trig_hc6", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.hc = 7;
	wait .5;
	}
}



hardend()
{
	trig = getEnt("secretend", "targetname");
	target = getEnt("o_secretexit", "targetname");

	while(1)
	{
		trig waittill("trigger", player);

		{
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
			 player thread sr\api\_speedrun::finishWay("secret_0");
			player.hc = 0;
		}
	}
}

