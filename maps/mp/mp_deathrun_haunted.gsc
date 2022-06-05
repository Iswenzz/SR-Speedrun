//sup is ya boy jwofles i helped make this map yo yo was rly gud
main()
{
level.masterSpawn = spawn("script_origin", level.spawn["allies"][0].origin);
level.masterSpawn.angles = level.spawn["allies"][6].angles;
level.masterSpawn placeSpawnPoint();
maps\mp\_load::main();
 
 level.fog = loadFX("custom/mapfog2");
  level.trap2 = loadFX("custom/traptest");
   level.trap5 = loadFX("custom/fallingfarmer");
   level.trap8 = loadFX("custom/trap8");
   level.trap9 = loadFX("custom/trap9");

 
    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	
	PrecacheItem( "ak74u_mp" );
	PrecacheItem( "remington700_mp" );
	PrecacheItem( "m40a3_mp" );
	
	
	/////dvars\\\\\\\\	
	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1500");
	  setdvar("scr_fog_exp_halfplane", "808.57");
		setdvar("scr_fog_exp_halfheight", "100");
		 setdvar("scr_fog_nearplane", "200");
		 setdvar("scr_fog_red", "0.52");
		 setdvar("scr_fog_green", "0.49");
		 setdvar("scr_fog_blue", "0.384");
		 setdvar("scr_fog_baseheight", "50");
		 setDvar("bg_falldamagemaxheight", 20000 );
		 setDvar("bg_falldamageminheight", 15000 );

		 setdvar("visionstore_glowTweakEnable", "0");
		 setdvar("visionstore_glowTweakRadius0", "5");
		 setdvar("visionstore_glowTweakRadius1", "");
		 setdvar("visionstore_glowTweakBloomCutoff", "0.5");
		 setdvar("visionstore_glowTweakBloomDesaturation", "0");
		 setdvar("visionstore_glowTweakBloomIntensity0", "1");
		 setdvar("visionstore_glowTweakBloomIntensity1", "");
		 setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
		 setdvar("visionstore_glowTweakSkyBleedIntensity1", "");
		 
		 // setExpFog(1200, 1800, 0.4, 0.425, 0.44, 0.0);

thread way_connect();
// thread fog();	
thread platform();
thread startdoor();
// thread music();
// thread credits();
// thread trap1();
// thread trap2();
// thread trap3();
// thread trap4();
// thread trap5();
// thread trap6();
// thread trap7();
// thread trap8();
// thread trap8back();
thread secretscary();
// thread trap9();
thread treetrig();
thread house();
thread secret3();
thread secret4();
// thread trapextra();
// thread trap10();
// thread sniper();
// thread bounce();
// thread weapon();
// thread knife();
// thread sniperback();
// thread bouncebackacti();
// thread bouncebackjump();
// thread bounceweapon();
thread cjsecret();
thread secretback1();
thread secretback2();
thread secretback3();
thread secretback4();
thread secretback5();
thread secretfinish1();
thread secretfinish2();
// thread actitele1();
// thread leavesecret();
// thread notice();


	 // addTriggerToList( "trig1" );
	 // addTriggerToList( "trig2" );
	 // addTriggerToList( "trig3" );
	 // addTriggerToList( "trig4" );
	 // addTriggerToList( "trig5" );
	 // addTriggerToList( "trig6" );
	 // addTriggerToList( "trig7" );
	 // addTriggerToList( "trig8" );
	 // addTriggerToList( "trig9" );
	 // addTriggerToList( "trig10" );
	 // addTriggerToList( "trigextra" );
	 
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	sr\api\_map::createWay("secret", "Secret Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


notice()
{
    for(;;)
    {
        wait 5;
        iPrintln("Map By Synd, thanks to JWofles and Posiedon");
	    wait 10;
		iPrintln("^9If you notice any bugs let me know ASAP so I can fix them, thanks.");
		wait 10;
		iPrintln("^5This map has about 5 secrets");
		wait 5;
    }
}

fog()
{
fog1 = getent("fog1", "targetname");
fog2 = getent("fog2", "targetname");
fog3 = getent("fog3", "targetname");


 level waittill( "round_started" );
 
PlayFX( level.fog, fog1.origin );
PlayFX( level.fog, fog2.origin );
PlayFX( level.fog, fog3.origin );
}

platform()
	{
	platform = getEnt ("movingplat","targetname");
	platformmove = getEnt ("platformmove","targetname");
	platformmoveback = getEnt ("platformmoveback","targetname");
while(1)
{
			platform moveto (platformmove.origin , 6 , 5, 1);
		wait 8.5 ;
		platform moveto (platformmoveback.origin , 6 , 5, 1);
		wait 8.5 ; 
		
	}
}	

startdoor()
{
	startdoor = getEnt ("startdoor","targetname");


	level waittill( "round_started" );
		startdoor moveZ (-251, 5, 0.2);

}	

music()
{
	songs = [];
	songs[songs.size] = "song1";
	songs[songs.size] = "song2";
	songs[songs.size] = "song3";

	selected = songs[ Randomint( songs.size ) ];
	AmbientPlay( selected );
}

credits()
{
 
level.credits = newHudElem();
 
level.credits.alignX = "center";
level.credits.alignY = "middle";
level.credits.horzalign = "center";
level.credits.x = 0;
level.credits.y = 450;
level.credits.font = "objective";
level.credits.fontscale = 1.4;
level.credits.glowalpha = 1;
level.credits.glowcolor = (2, 1.2, 0.11);
level.credits.alpha = 1;
level.credits fadeOverTime(1);
level.credits.hidewheninmenu = true;

while(1)
{
	level.credits setText("Map by Synd");
	wait 3;
	level.credits setText("Thanks to Posiedon");
	wait 3;
	level.credits setText("Thanks to JWofles");
	wait 3;
}
}

 trap1()
{
        trap1_1	= getEnt("trap1_1","targetname");
		trap1_2	= getEnt("trap1_2","targetname");
		trap1_3	= getEnt("trap1_3","targetname");
		trig = getEnt("trig1","targetname");
        trig waittill ("trigger", player);
        trig delete();
		while(1)
        {
                trap1_1 rotatepitch (-360 , 2);
				trap1_2 rotatepitch (360 , 2);
				trap1_3 rotatepitch (-360 , 2);
		wait 1;		
		}
}

trap2()
{
origin = GetEnt("trap2_1","targetname");
origin2 = GetEnt("trap2_2","targetname");
kill = GetEnt("trap2kill","targetname");
trig = GetEnt("trig2","targetname");
trig waittill("trigger", player);
trig delete();
thread trap2_1();
PlayFX( level.trap2, origin.origin );
PlayFX( level.trap2, origin2.origin );

for(;;)
{
kill waittill("trigger", player);
wait 0.01;
player suicide();
}
}

trap2_1()
{
kill = GetEnt("trap2kill","targetname");
origin = GetEnt("trap2_1","targetname");
origin2 = GetEnt("trap2_2","targetname");
wait 2.5;
kill delete();
}

						trap3()
	{
	trap3 = getEnt ("trap3","targetname");
	kill3 = getEnt ("trap3kill","targetname");
	trig = getEnt ("trig3","targetname");
	trig waittill ("trigger", player);
	trig delete ();
	
			kill3 enablelinkto();
	kill3 linkto (trap3);

		trap3 moveZ(410, 4);
		wait 7;
		trap3 moveZ(-410, 4);
}

						trap4()
	{
	trap4 = getEnt ("trap4","targetname");
	trig = getEnt ("trig4","targetname");
	trig waittill ("trigger", player);
	trig delete ();

		trap4 moveZ(-200, 2);
		trap4 waittill("movedone");
		wait 3;
		trap4 moveZ(200, 1);
}

trap5()
{
origin = GetEnt("farmer","targetname");
kill = GetEnt("trap5kill","targetname");
trig = GetEnt("trig5","targetname");
trig waittill("trigger", player);
trig delete();
thread trap5_1();
PlayFX( level.trap5, origin.origin );

for(;;)
{
kill waittill("trigger", player);
wait 0.01;
player suicide();
}
}

trap5_1()
{
kill = GetEnt("trap5kill","targetname");
origin = GetEnt("farmer","targetname");
wait 5;
kill delete();
}		

		secretscary()
{
scarytrig = getEnt("scarytrig", "targetname");
scarytrig waittill("trigger", player);
scarytrig delete();
		ambientStop();
		ambientplay( "scary" );
		wait 0.5 ;
		iPrintLnBold("Scared?");
		}	
		
						trap6()
	{
	trap6 = getEnt ("trap6","targetname");
	trig = getEnt ("trig6","targetname");
	trig waittill ("trigger", player);
	trig delete ();
	
while(1)
{
		trap6 movex(480, 2);
		wait 2;
		trap6 movex(-480, 2);
		wait 2;
		trap6 movex(480, 2);
		wait 2; 
		trap6 movex(-480, 2);
		wait 2;
}
	}

 trap7()
{
        trap7 = getEnt("trap7","targetname");
		trig = getEnt("trig7","targetname");
        trig waittill ("trigger", player);
        trig delete();
		while(1)
        {
                trap7 rotateroll (360 , 2);
				wait 7;
				trap7 rotateroll (-360 , 2);
				

		wait 7;		
		}
}

trap8back()
{
	tele = GetEnt("trap8backtomap","targetname");
	origin = GetEnt("trap8backtomaporigin","targetname");
	while(1)
        {
	tele waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}

trap8()
{
origin = GetEnt("trap8","targetname");
teleportorigin = GetEnt("trap8origin","targetname");
teleport = GetEnt("trap8teleport","targetname");
trig = GetEnt("trig8","targetname");
trig waittill("trigger", player);
trig delete();
thread trap8_1();
PlayFX( level.trap8, origin.origin );

}


trap8_1()
{
teleportorigin = GetEnt("trap8origin","targetname");
teleport = GetEnt("trap8teleport","targetname");
	while(1)
        {
	teleport waittill("trigger", player);
	
			player SetPlayerAngles( teleportorigin.angles );
	        player setOrigin( teleportorigin.origin );
}	
}

 trap9()
{
        trap9 = getEnt("trap9","targetname");
		origin = getEnt("trap9origin","targetname");
		trig = getEnt("trig9","targetname");
        trig waittill ("trigger", player);
        trig delete();
                trap9 hide();
				trap9 notsolid();
				PlayFX( level.trap9, origin.origin );
}

	treetrig()
{
trig = getEnt("treetrig", "targetname");
while(1)
{
trig waittill("trigger", player);
		// player PlaySound("secret1");
		wait 20 ;

		}
		}	
		
	house()
{
trig = getEnt("housetrig", "targetname");

while(1)
{
trig waittill("trigger", player);
		// player PlaySound("secret2");
		wait 15 ;

		}
		}	
		
	secret3()
{
trig = getEnt("secret3", "targetname");

while(1)
{
trig waittill("trigger", player);
		// player PlaySound("secret3");
		wait 10 ;

		}
		}

	secret4()
{
trig = getEnt("secret4", "targetname");

while(1)
{
trig waittill("trigger", player);
		// player PlaySound("secret4");
		wait 4 ;

		}
		}

						trapextra()
	{
	trapextra = getEnt ("trapextra","targetname");
	trig = getEnt ("trigextra","targetname");
	trig waittill ("trigger", player);
	trig delete ();

		trapextra moveZ(200, 2);

}

						trap10()
	{
	trap10 = getEnt ("trap10","targetname");
	trig = getEnt ("trig10","targetname");
	trig waittill ("trigger", player);
	trig delete ();

		trap10 moveZ(-200, 2);
		trap10 waittill("movedone");
		wait 3;
		trap10 moveZ(200, 2);
}

sniper()
{
	level.sniper = GetEnt("sniper","targetname");
    jump = GetEnt( "sniperjumper", "targetname" );
    acti = GetEnt( "sniperacti", "targetname" );

	while(1)
	{
		level.sniper waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.PlayerInRoom = true;
			level.weaponroom delete();
			level.bounce delete();
			level.knife delete();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "remington700_mp" );
			player GiveMaxAmmo( "remington700_mp" );
			player GiveWeapon( "m40a3_mp" );
			player GiveMaxAmmo( "m40a3_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "remington700_mp" );
	        level.activ GiveMaxAmmo( "remington700_mp" );
			level.activ GiveWeapon( "m40a3_mp" );
	        level.activ GiveMaxAmmo( "m40a3_mp" );
	        wait .05;
	        player switchToWeapon( "remington700_mp" ); 
	        level.activ SwitchToWeapon( "remington700_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Sniper Room!";
					noti.notifyText = level.activ.name + " ^3VS^5 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

weapon()
{
	level.weaponroom = GetEnt("weapon","targetname");
    jump = GetEnt( "sniperjumper", "targetname" );
    acti = GetEnt( "sniperacti", "targetname" );

	while(1)
	{
		level.weaponroom waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.PlayerInRoom = true;
			level.sniper delete();
			level.bounce delete();
			level.knife delete();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "ak74u_mp" );
			player GiveMaxAmmo( "ak74u_mp" );
			player GiveWeapon( "deserteagle_mp" );
			player GiveMaxAmmo( "deserteagle_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "ak74u_mp" );
	        level.activ GiveMaxAmmo( "ak74u_mp" );
			level.activ GiveWeapon( "deserteagle_mp" );
	        level.activ GiveMaxAmmo( "deserteagle_mp" );
	        wait .05;
	        player switchToWeapon( "ak74u_mp" ); 
	        level.activ SwitchToWeapon( "ak74u_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Weapon Room!";
					noti.notifyText = level.activ.name + " ^3VS^5 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

bounce()
{
	level.bounce = GetEnt("bounce","targetname");
    jump = GetEnt( "bouncejump", "targetname" );
    acti = GetEnt( "bounceacti", "targetname" );

	while(1)
	{
		level.bounce waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.PlayerInRoom = true;
			level.sniper delete();
			level.weaponroom delete();
			level.knife delete();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "tomahawk_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "tomahawk_mp" );
	        wait .05;
	        player switchToWeapon( "tomahawk_mp" ); 
	        level.activ SwitchToWeapon( "tomahawk_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Bounce Room!";
					noti.notifyText = level.activ.name + " ^3VS^5 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

bouncebackjump()
{
	teleport = GetEnt("bouncebackjump","targetname");
	origin = GetEnt("bouncejump","targetname");
	while(1)
        {
	teleport waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}

bouncebackacti()
{
	teleport = GetEnt("bouncebackacti","targetname");
	origin = GetEnt("bounceacti","targetname");
	while(1)
        {
	teleport waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}

sniperback()
{
	teleport = GetEnt("sniperback","targetname");
	origin = GetEnt("sniperbackorigin","targetname");
	while(1)
        {
	teleport waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}

knife()
{
	level.knife = GetEnt("knife","targetname");
    jump = GetEnt( "knifejump", "targetname" );
    acti = GetEnt( "knifeacti", "targetname" );

	while(1)
	{
		level.knife waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.PlayerInRoom = true;
			level.sniper delete();
			level.weaponroom delete();
			level.bounce delete();

			player.health = player.maxhealth;
			level.activ.health = level.activ.maxhealth;
			player SetPlayerAngles( jump.angles );
	        player setOrigin( jump.origin );
	        player TakeAllWeapons();
	        player GiveWeapon( "tomahawk_mp" );
	        level.activ setPlayerangles( acti.angles );
	        level.activ setOrigin( acti.origin );
	        level.activ TakeAllWeapons();
	        level.activ GiveWeapon( "tomahawk_mp" );
	        wait .05;
	        player switchToWeapon( "tomahawk_mp" ); 
	        level.activ SwitchToWeapon( "tomahawk_mp" );
	        player FreezeControls(1);
			level.activ FreezeControls(1);
			noti = SpawnStruct();
					noti.titleText = "Knife Room!";
					noti.notifyText = level.activ.name + " ^3VS^5 " + player.name;
					noti.glowcolor = (1,0,0.9);
					noti.duration = 5;
					players = getentarray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					wait 5;
					player FreezeControls(0);
					level.activ FreezeControls(0);
			player waittill( "death" );
			level.PlayerInRoom = false;
		}
	}
}

cjsecret()
{
		thread cjsecrettele();
}

cjsecrettele()
{
	tele = GetEnt("cjsecret2","targetname");
	origin = GetEnt("secretenterorigin","targetname");
	tele SetHintString( "^5Press [USE] To Enter Secret!" );
	while(1)
        {
	tele waittill("trigger", player);
	
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
			player sr\api\_map::startSecret(); //Speedrun Copy Paste
			
}	
}

bounceweapon()
{

	weaptrig = getEnt ("bounceweapon","targetname");
	
	while(1)
	{
	
	weaptrig waittill ("trigger", player);
	
		
    player giveWeapon( "m40a3_mp" );
    player giveMaxAmmo( "m40a3_mp" );
    wait 0.5;
    player switchToWeapon( "m40a3_mp" );
    wait 0.6;
    player iPrintLnBold( "^5You grabbed a weapon!" ); 

	}
}

secretback1()
{
	tele = GetEnt("secretback1","targetname");
	origin = GetEnt("secretenterorigin","targetname");
	while(1)
        {
	tele waittill("trigger", player);
	
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
			
}	
}

secretback2()
{
	tele = GetEnt("secretback2","targetname");
	origin = GetEnt("secretback2origin","targetname");
	while(1)
        {
	tele waittill("trigger", player);
	
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
			
}	
}

secretback3()
{
	tele = GetEnt("secretback3","targetname");
	origin = GetEnt("secretback3origin","targetname");
	while(1)
        {
	tele waittill("trigger", player);
	
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
			
}	
}

secretback4()
{
	tele = GetEnt("secretback4","targetname");
	origin = GetEnt("secretback4origin","targetname");
	while(1)
        {
	tele waittill("trigger", player);
	
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
			
}	
}

secretback5()
{
	tele = GetEnt("secretback5","targetname");
	origin = GetEnt("secretback5origin","targetname");
	while(1)
        {
	tele waittill("trigger", player);
	
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
			
}	
}



secretfinish1()
{
        trig = GetEnt("secretfinishone","targetname");
        origin = GetEnt("secretfinishoneorigin","targetname");
 
        for(;;)
        {
                trig waittill("trigger", player);
 
 
                player thread braxi\_mod::endTimer();
 
        }
}

secretfinish2()
{
        trig = GetEnt("secretfinishtwo","targetname");
        origin = GetEnt("secretfinishtwoorigin","targetname");
 
        for(;;)
        {
                trig waittill("trigger", player);
 
 
                player thread braxi\_mod::endTimer();
 
        }
}

actitele1()
{
	tele = GetEnt("actitele1","targetname");
	origin = GetEnt("actiteleportorigin","targetname");
	while(1)
        {
	tele waittill("trigger", player);
	
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
			
}	
}

leavesecret()
{
	tele = GetEnt("leavesecret","targetname");
	origin = GetEnt("leavesecretorigin","targetname");
	while(1)
        {
	tele waittill("trigger", player);
	
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
			
}	
}
