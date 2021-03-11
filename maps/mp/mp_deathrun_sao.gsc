/*
_____________________________________________
  /   /  ___/    __ /   ___/\ ______//  ___  \
 /   /  /__     /___   /__ /\\ ____//  /  /  /
/   /  ___/  __    /  ___//  \\ __//  /  /  /
  _/  /__   /_/   /	 /__/_____\\__/  /__/  /
___\____/________/\____//	   \\/________/

I see... you really are a noob for decompiling my map..
This proves that you really are a noob and cant do anythink on your own..

HOW ABOUT LEARN TO SCRIPT YOUR SELF?

IF YOU WANT TO USE ANY OF THOSE SCRIPTS ASK FOR [PERMISSON]!
STEAM: 321legend123

Credits: VC'Blade - creator script help
		 Xplosive - some trap ideas

*/
main()
{
	level._effect["watersuicide"] = loadfx( "custome/watersuicide" );
	level._effect["explobell"] = loadfx( "explosions/aa_explosion" );
	level._effect["iron_sword"] = loadfx( "sao/iron_sword" );
	level._effect["crystal_sword"] = loadfx( "sao/crystal_sword" );
	level._effect["rock_sword"] = loadfx( "sao/rock_sword" );
	level._effect["torch"] = loadfx( "sao/torch" );
	level._changeofheart = loadfx( "sao/lightball" );

	// addTriggerToList("trap1_trig");
	// addTriggerToList("trap2_trig");
	// addTriggerToList("trap3_trig");
	// addTriggerToList("trap4_trig");
	// addTriggerToList("trap5_trig");
	// addTriggerToList("trap6_trig");
	// addTriggerToList("trap7_trig");
	// addTriggerToList("trap8_trig");
	// addTriggerToList("trap9_trig");
	// addTriggerToList("trap10_trig");
	// addTriggerToList("trap11_trig");
	// addTriggerToList("trap12_trig");
	// addTriggerToList("trap13_trig");
	// addTriggerToList("trap14_trig");
	// addTriggerToList("trap15_trig");
	// addTriggerToList("trap16_trig");
	// addTriggerToList("trap17_trig");
	// addTriggerToList("trap18_trig");
	// addTriggerToList("trap19_trig");
	// addTriggerToList("trap20_trig");
	// addTriggerToList("trap21_trig");

	maps\mp\_load::main();
	maps\mp\mp_deathrun_sao\legendchallange::main();
	// maps\createfx\mp_deathrun_sao_fx::main();

	precacheItem("deserteagle_mp");
	precacheItem("ak47_mp");
	precacheItem("remington700_acog_mp");
	precacheItem("sao_sword_mp");

	preCacheStatusIcon("sao_start");
	preCacheShader("sao_start");
	preCacheShader("black");

	preCacheModel("body_mp_usmc_cqb");
	preCacheModel("sao_sword");
	preCacheModel("viewmodel_sword");
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "2" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	// setdvar("g_speed","190");
	setdvar("bg_fallDamageMaxHeight","400");
	setdvar("bg_fallDamageMinHeight","200");


      ////////////////////////////
	 //////**DVARS FOR DR**//////
	////////////////////////////

	// level.dvar["bunnyhoop"] = 0; //disable bhoop
	// level.dvar["lastalive"] = 0; //disable last alive sound

	  ///////////////////////
	 //////**THREADS**//////
	///////////////////////

	// thread creator_entered();
	// thread blade_entered();
	// thread creator_menu_trig();

	thread door_on_edge();
	// thread partysong();
	thread arrows();
	thread watersuicide();
	thread d_t_crystal();
	thread d_t_crystal_tele_trig();
	level.arrow1 hide();
	level.arrow2 hide();
	level.arrow3 hide();
	thread dungenendtp();
	thread cityendtp();
	thread rubyendtp();
	thread crystal();
	// thread endgame_credits();

	thread sword_dance();
	thread sniper();
	// thread one_shot_victim();
	thread jump();
	thread failtele();
	thread sniper2();
	thread snipermodel();

	thread sr\api\_map::way_connect(1,1);

	box = getEnt("wepbox","targetname");
	box delete();

	secretorigin = getent("secretspot","targetname");
	thread sr\api\_map::create_secret((-561,562,53),100,150,secretorigin.origin,secretorigin.angles[1],"unfreeze");

	// wait 5;
	// iprintln("[^5Aincrad^7] - Welcome To Sword Art Online!");

	  /////////////////////
	 //////**TRAPS**//////
	/////////////////////
	// wait 6;
	// iprintln("[^5Aincrad^7] - Traps loaded");
	// thread d_trap1();
	// thread d_trap2();
	// thread d_trap3();
	// thread d_trap4();
	// thread d_trap5();

	// thread c_trap1();
	// thread c_trap2();
	// thread c_trap3();
	// thread c_trap4();
	// thread c_trap5();
	// thread c_trap6();
	// thread c_trap7();
	// thread c_trap8();

	// thread r_trap1();
	// thread r_trap2();
	// thread r_trap3();
	// thread r_trap4();
	// thread r_trap5();
	// thread r_trap6();
	// thread r_trap7();
	// thread r_trap8();

	// wait 2;
	thread randomroompick();
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

endgame_credits()
{
	level waittill( "game over" );
	{
		iprintlnbold("Thanks On Playing SAO Map by eBc|Legend");
		thread endicon();
	}
}

endicon()
{
	hud_image = newHudElem();
	hud_image.alignX = "center";
	hud_image.alignY = "middle";
	hud_image.horzalign = "center";
	hud_image.vertalign = "middle";
	hud_image.x = 0;
	hud_image.y = 0;
	hud_image.alpha = 0;
	wait .1;
	hud_image fadeovertime(2);
	hud_image.alpha = 1;
	hud_image setshader("sao_start", 100, 100);
	wait 3;
	hud_image fadeovertime(1);
	hud_image.alpha = 0;
	wait 1.1;
	hud_image destroy();
}

door_on_edge()
{
	trig = getent("door_trig","targetname");
	door1 = getent("door1","targetname");
	door2 = getent("door2","targetname");

		door1 rotateYaw(90, 1);
		door2 rotateYaw(-90, 1);
		trig delete();
}

creator_menu_trig()
{
	trig = getent("creator_menu_trig","targetname");
	self.used = 0;
	for(;;)
	{
		trig waittill("trigger", player );
		vip=getSubStr( player.guid, 24, 32 );
		if (vip == level.me /*|| vip == level.me1 */|| vip == level.blade)
		{
			player.statusicon = "sao_start";
			player iprintlnbold("^5* * ^1VIP ^3Menu ^2Executed^1! ^5* *");
			player TakeAllWeapons();
			player giveweapon("deserteagle_mp");
			player GiveMaxAmmo("deserteagle_mp");
			wait .1;
			player switchToWeapon("deserteagle_mp");
		}
		else
			{
			if( player.used == 4)
			{
				player iprintlnbold("Are you fucking retarded?! Acces denied what dont you understand?!");
				player suicide();
				wait .1;
				player iprintlnbold("Thats punishment!");
				player.used = 0;
			}
			player iprintlnbold("^1...^7Access Denied^1!...");
			player.used++;
			}
	}
}

creator_entered()
{
	level.me="c8d2d25c";
	//level.me1="Legend"; //local testing
	level.blade="c409ae43";
	for(;;)
	{
		level waittill("connected",player);
		if(isdefined(player.pers["legend"]))
			return;
		wait 1;

		connected=getSubStr( player.guid, 24, 32 );
		if(connected==level.me && !player.pers["legend"])
		{
			player.pers["legend"]=true;
			thread wayhud("^5* * ^2Creator ^3" + player.name + "(eBc|Legend) ^2has Joined^1!^5 * *");
		}
		/*else if(connected==level.me1 && !player.pers["legend"]) // local testing
		{
			player.pers["legend"]=true;
			thread wayhud("^5* * ^2Creator ^3" + player.name + " (eBc|Legend) ^2has Joined^1!^5 * *");
		}*/
	}
}

blade_entered()
{
	for(;;)
	{
		level waittill("connected", player);
		if (isDefined(player.pers["blade"]))
		return;

		wait 1;
		connected=getSubStr( player.guid, 24, 32 );
		if(connected==level.blade && !player.pers["blade"])
		{
			player.pers["blade"]=true;
			thread wayhud("^5* * ^2Helper ^3" + player.name + "(VC'Blade) ^2has Joined^1!^5 * *");
		}
	}
}

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

randomroompick()
{
	// x = randomint(3);

	// if (x == 0)
	// {
		level thread dungen();
		level thread arrow1();
		// thread wayhud("^0Dungen^7 Teleport Is Open!");
		// thread sao_music();
		thread removeglass();
	// }
	// if (x == 1)
	// {
		level thread rubypalace();
		level thread arrow2();
		// thread wayhud("^1Ruby Palace^7 Teleport Is Open!");
		// thread sao_music();
		// thread actitele1();
	// }
	// if (x == 2)
	// {
		// level thread city();
		// level thread arrow3();
		// thread wayhud("City Teleport Is Open!");
		// thread sao_music();
		// thread actitele2();
	// }
}

sao_music()
{
	x = randomint(3);
	if(x == 0)
	{
		ambientplay("sao1");
		thread musichud("Music: ^5Sword Art Online - Opening");
	}
	if(x == 1)
	{
		ambientplay("sao2");
		thread musichud("Music: ^4Sword Art Online II - Opening");
	}
	if (x == 2)
	{
		ambientplay("sao3");
		thread musichud("Music: ^3Sword Art Online II - 2nd Opening");
	}
}

partysong()
{
	partytrig = getent("partytrig","targetname");
	partytrig waittill("trigger", user );
	{
	x = randomint(3);

	switch(x)
	{
	case 0:
		ambientplay("voices");
		ambientstop("sao1");
		ambientstop("sao2");
		ambientstop("sao3");
		iprintlnbold("DJ ^3"+user.name+"^7 started the party!");
		level.music destroy();
		wait .1;
		thread musichud("Music: ^5Martin Garrix - Forbiten Voices");
		break;

	case 1:
		ambientplay("illuminati");
		ambientstop("sao1");
		ambientstop("sao2");
		ambientstop("sao3");
		iprintlnbold("DJ ^3"+user.name+"^7 started the party!");
		level.music destroy();
		wait .1;
		thread musichud("Music: ^5Illuminati");
		break;

	case 2:
		ambientplay("leanon");
		ambientstop("sao1");
		ambientstop("sao2");
		ambientstop("sao3");
		iprintlnbold("DJ ^3"+user.name+"^7 started the party!");
		level.music destroy();
		wait .1;
		thread musichud("Music: ^5Lean On");
		break;
	}
	//default: return;
	}
	partytrig delete();
	user giveweapon("ak47_mp");
	user SetWeaponAmmoClip( "ak47_mp", 2 );
	user SetWeaponAmmoStock( "ak47_mp", 0 );
	wait 0.1;
	user switchtoweapon("ak47_mp");
}

musichud(text)
{
	level.music = NewHudElem();
	level.music.alignX = "center";
	level.music.alignY = "bottom";
	level.music.horzalign = "center";
	level.music.vertalign = "bottom";
	level.music.alpha = 0;
	level.music.x = 0;
	level.music.y = -5;
	level.music.font = "objective";
	level.music.fontscale = 2;
	level.music.glowalpha = 1;
	level.music.glowcolor = (1,0,0);
	level.music fadeovertime( 2 );
	level.music.alpha = 1;
	level.music setText( text );
}

wayhud(text)
{
	level.wayhud = NewHudElem();
	level.wayhud.alignX = "center";
	level.wayhud.alignY = "middle";
	level.wayhud.horzalign = "center";
	level.wayhud.vertalign = "middle";
	level.wayhud.alpha = 1;
	level.wayhud.x = 0;
	level.wayhud.y = -150;
	level.wayhud.font = "default";
	level.wayhud.fontscale = 2;
	level.wayhud.glowalpha = 1;
	level.wayhud.glowcolor = (0.0, 1.0, 1.0);
	level.wayhud setText( text );
	level.wayhud.duration = 4;
	level.wayhud SetPulseFX( 10, 3000, 200 );
	wait 5;
	level.wayhud destroy();

}

removeglass()
{
	door = getent("glassdoor","targetname");
	{
		door moveX(144,2,1);
		door waittill("movedone");
		door delete();
	}
}

actitele1()
{	
	level.rubytele = getent("acti1","targetname");
	{
		level.activ setOrigin( level.rubytele.origin );
		level.activ setplayerangles( level.rubytele.angles );
	}
}

actitele2()
{
	level.citytele = getent("acti2","targetname");
	{
		level.activ setOrigin( level.citytele.origin );
		level.activ setplayerangles( level.citytele.angles );
	}
}

dungen()
{
	trig = getent("dungen_trig","targetname");
	spot = getent("dungen_tele_spot","targetname");
	while(true)
	{
		trig waittill("trigger", user);
		user setOrigin( spot.origin );
		user setplayerangles( spot.angles );
		wait 0.005;
	}
	wait 0.005;
}

rubypalace()
{
	trig = getent("rubypalace_trig","targetname");
	spot = getent("rubypalace_tele_spot","targetname");
	while(true)
	{
		trig waittill("trigger", user);
		user setOrigin( spot.origin );
		user setplayerangles( spot.angles );
		wait 0.005;
	}
	wait 0.005;
}

city()
{
	trig = getent("city_trig","targetname");
	spot = getent("city_tele_spot","targetname");
	while(true)
	{
		trig waittill("trigger", user);
		user setOrigin( spot.origin );
		user setplayerangles( spot.angles );
		wait 0.005;
	}
	wait 0.005;
}

arrows()
{
	level.arrow1 = getent("arow1","targetname");
	level.arrow2 = getent("arow2","targetname");
	level.arrow3 = getent("arow3","targetname");
}

arrow1()
{
	level.arrow1 = getent("arow1","targetname");
	level.arrow1 show();
}

arrow2()
{
	level.arrow2 = getent("arow2","targetname");
	level.arrow2 show();
}

arrow3()
{
	level.arrow3 = getent("arow3","targetname");
	level.arrow3 show();
}

watersuicide()
{
	trig = getent("watersuicide","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player suicide();
		PlayFX(level._effect["watersuicide"],( player.origin ));
	}
}

d_t_crystal()
{
	obj = getent("crystal1","targetname");
	for(;;)
	{
	obj rotateYaw(360, 2);
	obj moveZ(30,1);
	obj waittill("movedone");
	wait 1;
	obj moveZ(-30,1);
	obj waittill("movedone");
	wait 1;
	}	

}

d_t_crystal_tele_trig()
{
	trig = getent("d_t_crystal1","targetname");
	org = getent("tele_crystal","targetname");
	for(;;)
	{
		trig waittill("trigger", user);
		user setOrigin( org.origin );
		user setplayerangles( org.angles );
	}
}

dungenendtp()
{
	level.mapfinish = getent("origin_finish","targetname");
	trig = getent("endteleport_trig","targetname");
	while(true)
	{
		trig waittill("trigger", user );
		user setOrigin( level.mapfinish.origin );
		user setplayerangles( level.mapfinish.angles );
	}
}

  //////////////////////
 /////Dungen Traps/////
//////////////////////

crystal()
{
	crystal = getent("crystal_dungen","targetname");
	for(;;)
	{
		crystal rotateYaw( 360 , 2 );
		wait 2.05;
	}
}

d_trap1()
{
	trap1 = getent("trap1","targetname");
	trig = getent("trap1_trig","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", player);
	{
		trig delete();
		trap1 hide();
		trap1 notsolid();
		wait 3;
		trap1 show();
		trap1 solid();
	}
}

d_trap2()
{
	trap2_1 = getent("trap2_1","targetname");
	trap2_2 = getent("trap2_2","targetname");
	trig = getent("trap2_trig","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", player);
	{
		trig delete();
		for(;;)
		{
			trap2_1 moveZ(48,3);
			trap2_2 moveZ(-48,3);
			wait 4;
			trap2_1 moveZ(-48,3);
			trap2_2 moveZ(48,3);
			wait 4;
			trap2_1 moveZ(-48,3);
			trap2_2 moveZ(48,3);
			wait 4;
			trap2_1 moveZ(48,3);
			trap2_2 moveZ(-48,3);
			wait 4;
		}
	}
}

d_trap3()
{
	trig = getent("trap3_trig","targetname");
	bounce = getent("bounce_block","targetname");
	jump_pads = getent("jump_pads","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", player);
	{
		trig delete();
		 x = randomint(2);
		 if (x == 0)
		 {
		 	jump_pads delete();
		 }
		 else if (x == 1)
		 {
		 	bounce delete();
		 }
	}
}

d_trap4()
{
	trig = getent("trap4_trig","targetname");
	plat1 = getent("trap_plat1","targetname");
	plat2 = getent("trap_plat2","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", player);
	{
		trig delete();
		x = randomint(2);
		if (x == 0)
		{
			plat1 movey(320,1);
		}
		else if(x == 1)
		{
			plat2 movey(-416,1);
		}
	}
}

d_trap5()
{
	trig = getent("trap5_trig","targetname");
	stalagmit1 = getent("stalagmit1","targetname");
	stalagmit2 = getent("stalagmit2","targetname");
	stalagmit3 = getent("stalagmit3","targetname");
	mover1_1 = getent("mover1_1","targetname");
	mover2_1 = getent("mover2_1","targetname");
	mover3_1 = getent("mover3_1","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", player);
	{
		trig delete();
		stalagmit1 moveto( mover1_1.origin, 1);
		wait 0.2;
		stalagmit2 moveto( mover2_1.origin, 1.5);
		wait 0.7;
		stalagmit3 moveto( mover3_1.origin, 1.45);
		wait .1;
		RadiusDamage( mover1_1.origin, 100, 400, 150);
		Earthquake( 2, 1, mover1_1.origin, 500);
		wait .45;
		RadiusDamage( mover3_1.origin, 100, 400, 150);
		Earthquake( 2, 1, mover3_1.origin, 500);
		wait .05;
		RadiusDamage( mover2_1.origin, 100, 400, 150);
		Earthquake( 2, 1, mover2_1.origin, 500);			//fuck my logic hehe :P
	}
}

  //////////////////////
 //////City Traps//////
//////////////////////
c_trap1()
{
	trig = getent("trap6_trig","targetname");
	jump_pads = getent("part1","targetname");
	bounce = getent("part2","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", user);
	{
		x = randomint(2);
		if (x == 0)
		{
			jump_pads delete();
			trig delete();
		}
		else
			bounce delete();
			trig delete();
	}
}

c_trap2()
{
	level.bell = getent("bell","targetname");
	trig = getent("trap7_trig","targetname");
	moveto1 = getent("moveto1","targetname");
	moveto2 = getent("moveto2","targetname");
	moveto3 = getent("moveto3","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	{
		trig waittill("trigger",user);
		trig delete();
		level.bell rotatepitch(40,0.5);
		wait 0.5;
		level.bell rotatepitch(-140,1);
		wait 1;
		level.bell moveto(moveto1.origin, .5);
		wait .5;
		level.bell moveto(moveto2.origin, .5);
		wait .5;
		level.bell moveto(moveto3.origin, .5);
		wait .5;
		RadiusDamage( moveto3.origin, 100, 400, 150);
		Earthquake( 4, 2, moveto3.origin, 500);
		PlayFX(level._effect["explobell"],( moveto3.origin ));
	}
}

c_trap3()
{
	wall = getent("house_wall","targetname");
	ball = getent("trap3ball","targetname");
	trig = getent("trap8_trig","targetname");
	killtrig = getent("killtrig_c3","targetname");
	moveto1h = getent("moveto1_3","targetname");
	moveto2h = getent("moveto2_3","targetname");
	moveto3h = getent("moveto3_3","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	{
		trig waittill("trigger", user );
		trig delete();
		killtrig enablelinkto();
		killtrig linkto (ball);
		ball rotatepitch(360,2.9);
		wait .0001;
		ball moveto(moveto1h.origin, 1);
		wait .8;
		Earthquake( 2, 1, moveto1h.origin, 1000);
		wall delete();
		PlayFX(level._effect["explobell"],( moveto1h.origin ));
		ball moveto(moveto2h.origin, 1);
		wait 1;
		ball moveto(moveto3h.origin, 1);
		wait 1;
		killtrig delete();
	}
}

c_trap4()
{
	trigger = getent("trap9_trig","targetname");
	sword1 = getent("rock_sword","targetname");
	sword2 = getent("iron_sword","targetname");
	sword3 = getent("crystal_sword","targetname");
	org1 = getent("org1","targetname");
	org2 = getent("org2","targetname");
	org3 = getent("org3","targetname");
	org4 = getent("org4","targetname");
	org5 = getent("org5","targetname");
	org6 = getent("org6","targetname");
	org7 = getent("org7","targetname");
	org8 = getent("org8","targetname");
	org9 = getent("org9","targetname");
	wall = getent("swords_wall","targetname");
	trigger SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trigger waittill ("trigger" , player );
	{
		trigger delete();
		wall moveY(18, 0.5);
		wait .5;
		wall moveZ(-144, 0.5);
		wait 1;
		sword1 moveto(org1.origin, .5);
		sword2 moveto(org4.origin, .6);
		sword3 moveto(org7.origin, .7);
		wait .7;
		sword1 moveto(org2.origin, .4);
		sword2 moveto(org5.origin, .5);
		sword3 moveto(org8.origin, .6);
		wait .6;
		wall moveZ(144, 0.5);
		sword1 moveto(org3.origin, .3);
		sword1 rotateto(org3.angles, .3);
		wait .3;
		PlayFX(level._effect["rock_sword"],( org3.origin ));
		RadiusDamage( org3.origin, 100, 200, 100);
		sword2 moveto(org6.origin, .4);
		sword2 rotateto(org6.angles, .4);
		wait .4;
		PlayFX(level._effect["iron_sword"],( org6.origin ));
		RadiusDamage( org6.origin, 100, 200, 100);
		sword3 moveto(org9.origin, .5);
		sword3 rotateto(org9.angles, .5);
		wait .5;
		PlayFX(level._effect["crystal_sword"],( org9.origin ));
		RadiusDamage( org9.origin, 100, 200, 100);
		wait .5;
		wall moveY(-18, 0.5);
		wait 10;
		sword1 delete();
		sword2 delete();
		sword3 delete();
	}
}

c_trap5()
{
	trig = getent("trap10_trig","targetname");
	trap10_1 = getent("trap10_1","targetname");
	trap10_2 = getent("trap10_2","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", player );
	{
		trig delete();
		x = randomint(2);
		if(x == 1)
		{
			trap10_1 delete();
		}
		else
			trap10_2 delete();
	}
}

c_trap6()
{
	trig = getent("trap11_trig","targetname");
	trap11_1 = getent("trap11_1","targetname");
	trap11_2 = getent("trap11_2","targetname");
	trap11_3 = getent("trap11_3","targetname");
	trap11_4 = getent("trap11_4","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", player );
	{
		trig delete();
		x = randomint(4);
		if(x == 1)
		{
			trap11_1 delete();
			trap11_3 delete();
		}
		if(x == 2)
		{
			trap11_2 delete();
			trap11_4 delete();
		}
		if(x == 3)
		{
			trap11_1 delete();
			trap11_2 delete();
		}
		else if(x == 4)
		{
			trap11_3 delete();
			trap11_4 delete();
		}
	}
}

c_trap7()
{
	trig = getent("trap12_trig","targetname");
	obj = getent("flor","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	level.changeofheart = false;
	trig waittill("trigger", user );
	{
		thread trap7stuff();
		trig delete();
		obj delete();
		//iprintlnbold("^0Change ^7Of ^1Heart ^2Activated!");
		user sayall("^1Time to change you desteny! Change of Heart, Activate!");
		thread fxwork();
		level.changeofheart = true;
		wait 10;
		level.trig_trap delete();
		//iprintlnbold("^0Change ^7Of ^1Heart Deactivated!");
		level.changeofheart = false;
	}
}

fxwork()
{
	fxmover1 = getent("fxmover1","targetname");
	fxmover2 = getent("fxmover2","targetname");
	lightball = spawn("script_model",(2104, 7496, 440));
	lightball SetModel("tag_origin");
	wait .1;
	PlayFXOnTag ( level._changeofheart, lightball, "tag_origin" );
	wait .1;
	lightball moveto(fxmover1.origin, 4.9);
	wait 5;
	lightball moveto(fxmover2.origin, 4.9);
	wait 5;
	lightball delete();
}

trap7stuff()
{
level.trig_trap = getent("trigtrap_ct7","targetname");

 while (1)
 {
  level.trig_trap waittill ("trigger", user );
  if ( isPlayer( user ) && isAlive( user ) && !(isdefined( user.infected )) )
     {
    user thread changeofheart();
    iprintln("[^5Aincrad^7] - ^1"+user.name+" got Change of Heart!");
   
   user.infected = true;
     }
 
 wait .05;
 }
}

changeofheart()
{
	self.pers["team"] = "axis";
	self.team = "axis";
	self.sessionteam = "axis";
	self setmodel("body_mp_usmc_cqb");
	PlayFXOnTag ( level._changeofheart, self, "j_spineupper" );
}

c_trap8()
{
	obj1 = getent("trap13_1","targetname");
	obj2 = getent("trap13_2","targetname");
	trig = getent("trap13_trig","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", player );
	{
		trig delete();
		i = 0;
		while(i<2)
		{
			obj1 rotateroll(360 ,2);
			obj2 rotateroll(-360, 2);
			wait 4;
			obj1 rotateroll(-360, 2);
			obj2 rotateroll(360, 2);
			i++;
			wait 4;
		}
	}
}

cityendtp()
{
	trig = getent("cityendtp","targetname");
	for(;;)
	{
		trig waittill("trigger", user );
		user setOrigin(level.mapfinish.origin);
		user setplayerangles(level.mapfinish.angles);
		wait .1;
	}
}

  ///////////////////////////
 /////Ruby Palace Traps/////
///////////////////////////

r_trap1()
{
trigger = getent("trap14_trig","targetname");
level.roter = getent("roter","targetname");
killtrigger = getent ("killer" , "targetname");
trigger SetHintString("^1Press^7 [^4F^7] To ^1Activate");
trigger waittill ("trigger" , player );
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (level.roter);
thread rotate();
thread move();
}
}

rotate()
{
	for(;;)
	{
		level.roter rotateroll(360,1);
		level.roter waittill("rotatedone");
		level.roter rotateroll(-360,1);
		level.roter waittill("rotatedone");
		wait .00001;
	}
}
move()
{
	for(;;)
	{
		level.roter moveY(-496,1);
		level.roter waittill("movedone");
		level.roter moveY(496,1);
		level.roter waittill("movedone");
		wait .00001;
	}
}

r_trap2()
{
trig = getent("trap15_trig","targetname");
spikes = getent("trap15","targetname");
killtrigger = getent ("killer2" , "targetname");
trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
trig waittill ("trigger" , player );
trig delete();
{
killtrigger enablelinkto ();
killtrigger linkto (spikes);
spikes moveZ(-560, 0.5);
wait 2;
spikes moveZ(560, 1, 0.5);
}
}

r_trap3()
{
	trig = getEnt("trap16_trig","targetname");
	obj = getEnt("trap16","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	kill = getEnt("killt3","targetname");
	trig waittill("trigger", user );
	trig delete();
	{
		kill enablelinkto();
		kill linkto (obj);
		obj moveZ(-384, 1);
		obj waittill("movedone");
		wait .1;
		obj moveZ(384, 1, 0.5);
		obj waittill("movedone");
	}
}

r_trap4()
{
	trig = getEnt("trap17_trig","targetname");
	door1 = getEnt("trapdoor1","targetname");
	door2 = getEnt("trapdoor2","targetname");
	doorup1 = getEnt("doorup1","targetname");
	doorup2 = getEnt("doorup2","targetname");
	level.roter1 = getEnt("roter4_1","targetname");
	level.roter2 = getEnt("roter4_2","targetname");
	level.roter3 = getEnt("roter4_3","targetname");
	level.roter4 = getEnt("roter4_4","targetname");
	kill1 = getent ("killer4_1" , "targetname");
	kill2 = getent ("killer4_2" , "targetname");
	kill3 = getent ("killer4_3" , "targetname");
	kill4 = getent ("killer4_4" , "targetname");
	quaker = getEnt("trap4quaker","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", user );
	trig delete();
	{
		kill1 enablelinkto();
		kill1 linkto (level.roter1);
		kill2 enablelinkto();
		kill2 linkto (level.roter2);
		kill3 enablelinkto();
		kill3 linkto (level.roter3);
		kill4 enablelinkto();
		kill4 linkto (level.roter4);
		door1 moveZ(-160, 1, 0.5);
		door2 moveZ(-160, 1, 0.5);
		doorup1 rotateRoll(360, 1, 0.5);
		doorup2 rotateRoll(360, 1, 0.5);
		earthquake (1+randomint(2), 1.5+randomint(2), quaker.origin, 500);
		wait 3;
		thread roterstuff1();
		thread roterstuff2();
	}

}

roterstuff1()
{
	r = 0;
	while(r<3)
	{
		level.roter1 rotateYaw(360, 2);
		level.roter2 rotateYaw(-360, 2);
		level.roter3 rotateYaw(360, 2);
		level.roter4 rotateYaw(-360, 2);
		wait 2;
		r++;
	}
}

roterstuff2()
{
	m = 0;
	while(m<3)
	{
		level.roter1 moveX(432, 1);
		level.roter2 moveX(-432, 1);
		level.roter3 moveX(432, 1);
		level.roter4 moveX(-432, 1);
		wait 1;
		level.roter1 moveX(-432, 1);
		level.roter2 moveX(432, 1);
		level.roter3 moveX(-432, 1);
		level.roter4 moveX(432, 1);
		wait 1;
		m++;
	}
	thread r_trap4end();
}

r_trap4end()
{
	door1 = getEnt("trapdoor1","targetname");
	door2 = getEnt("trapdoor2","targetname");
	doorup1 = getEnt("doorup1","targetname");
	doorup2 = getEnt("doorup2","targetname");
	{
		door1 moveZ(160, 1, 0.5);
		door2 moveZ(160, 1, 0.5);
		doorup1 rotateRoll(-360, 1, 0.5);
		doorup2 rotateRoll(-360, 1, 0.5);
	}
}

r_trap5()
{
	flor = getEnt("trap18","targetname");
	trig = getEnt("trap18_trig","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", user );
	trig delete();
	{
		flor moveY(64, 1, 0.5);
		flor waittill("movedone");
		wait 3;
		flor moveY(-64, 1, 0.5);
		flor waittill("movedone");
	}
}

r_trap6()
{
	spear1 = getent("spear1","targetname");
	spear2 = getEnt("spear2","targetname");
	trig = getEnt("trap19_trig","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	spearkill1 = getEnt("speartrig1","targetname");
	spearkill2 = getEnt("speartrig2","targetname");
	trig waittill("trigger", user );
	trig delete();
	{
		spearkill1 enablelinkto();
		spearkill1 linkto (spear1);
		spearkill2 enablelinkto();
		spearkill2 linkto (spear2);
		wait .1;
		spear1 moveY(272, 2);
		spear2 moveY(-272, 2);
		wait 4;
		spear1 moveY(-272, 2);
		spear2 moveY(272, 2);
	}
}

r_trap7()
{
	spiner = getent("trap20","targetname");
	trig = getEnt("trap20_trig","targetname");
	killtrig = getEnt("trap20_killtrig","targetname");
	trig SetHintString("^1Press^7 [^4F^7] To ^1Activate");
	trig waittill("trigger", user );
	trig delete();
	spins = 0;
	{
		killtrig enablelinkto();
		killtrig linkto (spiner);
		while(spins<3)
		{
			spiner rotateYaw(360, 1 ,0.5, 0.75);
			wait 3;
			spiner rotateYaw(-360, 1 ,0.5, 0.75);
			wait 3;
			spins++;
			wait .5;
		}
	}

}

r_trap8()
{
	spiner1 = getent("spin8_1","targetname");
	spiner2 = getent("spin8_2","targetname");
	spiner3 = getent("spin8_3","targetname");
	spiner4 = getent("spin8_4","targetname");
	spiner5 = getent("spin8_5","targetname");
	spiner6 = getent("spin8_6","targetname");
	trig = getEnt("trap21_trig","targetname");
	trig waittill("trigger", user );
	trig delete();
	{
		while(1)
		{
			spiner1 rotateYaw(360, 1+randomint(3));
			spiner2 rotateYaw(-360, 1+randomint(3));
			spiner3 rotateYaw(360, 1+randomint(3));
			spiner4 rotateYaw(-360, 1+randomint(3));
			spiner5 rotateYaw(360, 1+randomint(3));
			spiner6 rotateYaw(-360, 1+randomint(3));
			wait 1.1+randomint(3);
		}
	}
}

rubyendtp()
{
	trig = getent("rubyendtp","targetname");
	for(;;)
	{
		trig waittill("trigger", user );
		user setOrigin(level.mapfinish.origin);
		user setplayerangles(level.mapfinish.angles);
		wait .1;
	}
}

  /////////////////////
 //////**Rooms**//////
/////////////////////

roomhud(text, y, x)
{
	roomhud = NewHudElem();
	roomhud.alignX = "center";
	roomhud.alignY = "top";
	roomhud.horzalign = "center";
	roomhud.vertalign = "top";
	roomhud.alpha = 0;
	roomhud.x = x;
	roomhud.y = y;
	roomhud.font = "default";
	roomhud.fontscale = 1.6;
	roomhud.glowalpha = 1;
	roomhud.glowcolor = (1,0,0);
	roomhud.sort = 2;
	roomhud fadeovertime( 2 );
	roomhud.alpha = 1;
	roomhud setText( text );
	wait 4;
	roomhud moveovertime( 2 );
	roomhud.y = -100;
	wait 2;
	roomhud destroy();
}

roomshader()
{
	black = newHudElem();
	black.alignX = "center";
	black.alignY = "top";
	black.horzalign = "center";
	black.vertalign = "top";
	black.x = 0;
	black.y = 105;
	black.alpha = 0;
	black.sort = 1;
	black fadeovertime(1);
	black.alpha = 0.5;
	black setshader("black", 280, 60);
	wait 4;
	black moveovertime( 2 );
	black.y = -100;
	wait 2;
	black destroy();
}

sword_dance()
{
    level.sword_trig = getEnt( "sword_dance_trig", "targetname");
    jump = getEnt( "jumper_sword", "targetname" );
    acti = getEnt( "acti_sword", "targetname" );
    
    while(1)
    {
        level.sword_trig waittill( "trigger", player );
        if( !isDefined( level.sword_trig ) )
            return;
        if(level.firstenter==true)
		{
        level.sniper_trig delete();
        level.oneshot_trig delete();
        level.jump_trig delete();
		level.firstenter=false;
		}
		
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "sao_sword_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "sao_sword_mp" ); 		
        wait 0.05;
        player switchToWeapon( "sao_sword_mp" );
        level.activ SwitchToWeapon( "sao_sword_mp" );

        thread roomhud("Sword Dance", 100, 0);
        thread roomhud(""+player.name+"", 130, -80);
        thread roomhud("^1VS", 130, 0);
        thread roomhud(""+level.activ.name+"", 130, 80);
        thread roomshader();

		wait 5;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait .01;
    }
}

sniper()
{
    level.sniper_trig = getEnt( "sniper_trig", "targetname");
    jump = getEnt( "jumper_sniper", "targetname" );
    acti = getEnt( "acti_sniper", "targetname" );
    
    while(1)
    {
        level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
            return;
        if(level.firstenter==true)
		{
 		level.sword_trig delete();
 		level.oneshot_trig delete();
 		level.jump_trig delete();
		level.firstenter=false;
		}
		
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
        player GiveMaxAmmo( "remington700_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" ); 
        level.activ GiveMaxAmmo( "remington700_mp" );		
        wait 0.05;
        player switchToWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );

        thread roomhud("Sniper Room", 100, 0);
        thread roomhud(""+player.name+"", 130, -80);
        thread roomhud("^1VS", 130, 0);
        thread roomhud(""+level.activ.name+"", 130, 80);
        thread roomshader();

		wait 5;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait .01;
    }
}

one_shot_victim()
{
    level.oneshot_trig = getEnt( "oneshot_trig", "targetname");
    jump = getEnt( "jumper_one", "targetname" );
    acti = getEnt( "acti_one", "targetname" );
    
    while(1)
    {
        level.oneshot_trig waittill( "trigger", player );
        if( !isDefined( level.oneshot_trig ) )
            return;
        if(level.firstenter==true)
		{
 		level.sword_trig delete();
 		level.sniper_trig delete();
 		level.jump_trig delete();
		level.firstenter=false;
		}
		
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
        player SetWeaponAmmoClip( "remington700_mp", 1 );
		player SetWeaponAmmoStock( "remington700_mp", 0 );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" ); 
        level.activ SetWeaponAmmoClip( "remington700_mp", 1 );
		level.activ SetWeaponAmmoStock( "remington700_mp", 0 );		
        wait 0.05;
        player switchToWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );

        thread roomhud("One Shot Victim", 100, 0);
        thread roomhud(""+player.name+"", 130, -80);
        thread roomhud("^1VS", 130, 0);
        thread roomhud(""+level.activ.name+"", 130, 80);
        thread roomshader();
        player thread suicide_jumper();

		wait 5;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait .01;
    }
}

suicide_jumper()
{
	wait 10;
	if(isAlive(level.activ))
	{
	self suicide();
	self iprintlnbold("^1Shot failed, room autokill");
	}
}

jump()
{
    level.jump_trig = getEnt( "jump_trig", "targetname");
    jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
    
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
        if(level.firstenter==true)
		{
 		level.sword_trig delete();
 		level.sniper_trig delete();
 		level.oneshot_trig delete();
		level.firstenter=false;
		}
		
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" ); 	
        wait 0.05;
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );

        thread roomhud("Jump Room", 100, 0);
        thread roomhud(""+player.name+"", 130, -80);
        thread roomhud("^1VS", 130, 0);
        thread roomhud(""+level.activ.name+"", 130, 80);
        thread roomshader();

		wait 5;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait .01;
    }
}

failtele()
{
	failjumper = getent("failjumper","targetname");
	failacti = getEnt("failacti","targetname");
	trigger = getEnt("failer","targetname");
	for(;;)
	{
		trigger waittill("trigger", player );
		if (player == level.activ)
		{
			player setOrigin(failacti.origin);
		}
		else if (player == player)
		{
			player setOrigin(failjumper.origin);
		}
		wait .05;
	}
}

sniper2()
{
	trig = getEnt("jump_scope","targetname");
	self.hassniper = 0;
	for(;;)
	{
		trig waittill("trigger", player );
		if (player.hassniper == 0)
		{
			player giveweapon("remington700_mp");
			player GiveMaxAmmo("remington700_mp");	
			wait .001;
			player switchtoweapon("remington700_mp");
			player.hassniper = 1;
		}
		else if (player.hassniper == 1)
		{
			player iprintlnbold("Sniper Token Already Used!");
		}
		wait .001;
	}
}

snipermodel()
{
	snipermodel = getent("snipermodel","targetname");
	for(;;)
	{
		snipermodel rotateYaw(360, 2);
		wait 2;
	}
}