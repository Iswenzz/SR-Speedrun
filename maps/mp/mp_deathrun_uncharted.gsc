
main()
{
level.masterSpawn = spawn("script_origin",(-161, 1547, 95));
level.masterSpawn.angles = (0,360,0);
	maps\mp\_load::main();
	
	
	level.water = loadFX("custom/sentrex-gushingwater");
	level.fog = loadFX("custom/prisonrunfog");
	level.trap6fx = loadFX("custom/trap3fx");
	
	
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	PrecacheItem( "syndcarnage_mp" );
	PrecacheItem( "ak74u_mp" );
	PrecacheItem( "remington700_mp" );
	PrecacheItem( "m40a3_mp" );
	
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
		 
		 playLoopedFX(level.water, 0.05, (20376, -88, 88));
		 playLoopedFX(level.water, 0.05, (18304, -64, 80));

		 trigger = spawn( "trigger_radius", (599.455, 9164.22, -1879.88), 0, 120, 80 );
trigger.targetname = "endmap_trig";
trigger.radius = 120;

thread way_connect();	 

thread caveteleport();	
//thread creds();	
thread trap1();
thread trap2();
thread trap3();
thread trap4();
thread trap5();
thread trap6();
//thread sniper();
//thread weapon();
//thread bounce();
//thread bounceweapon();
// thread secret();
thread secretback1();
thread secretback2();
thread secretback3();
thread secretback4();
thread secretback5();
thread secretback6();
thread secretend();
thread actitele1();
thread actitele2();
//thread music();
thread synd();
thread jump_respawn_acti();
thread jump_respawn_jumper();
thread snipe_respawn_jumper();
thread snipe_respawn_acti();


	 //addTriggerToList( "trig1" );
	 //addTriggerToList( "trig2" );
	 //addTriggerToList( "trig3" );
	// addTriggerToList( "trig4" );
	 //addTriggerToList( "trig5" );
	 //addTriggerToList( "trap6trig" );
 
}

way_connect()
{
    wait 0.05;
    
    sr\api\_speedrun::createNormalWays("Normal Way;");
    sr\api\_speedrun::createSecretWays("Secret Way;");

    thread secret_1();
    
    for(;;) 
    {
        level waittill( "connected", player );
        
    }
}

secret_1()
{
	secret = spawn("trigger_radius",(178,1813,102), 0, 100, 250);
	origin = GetEnt("secrettele","targetname");

	wait 1;
	secret.radius = 100;
	thread speedrun\_triggerfx::createTrigFx(secret, "secret");

	while(1)
    {
		secret waittill("trigger", player);
		player sr\api\_speedrun::changeWay("secret_0");
		player SetPlayerAngles( origin.angles );
	    player setOrigin( origin.origin );
	}
}

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

caveteleport()
{
	teleport1 = GetEnt("caveteleport","targetname");
	origin1 = GetEnt("cavetarget","targetname");
	while(1)
        {
	teleport1 waittill("trigger", player);
	
			player SetPlayerAngles( origin1.angles );
	        player setOrigin( origin1.origin );
}	
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

actitele1()
{
	teleport1 = GetEnt("actitele1","targetname");
	origin1 = GetEnt("actitele1_origin","targetname");
	while(1)
        {
	teleport1 waittill("trigger", player);
	
			player SetPlayerAngles( origin1.angles );
	        player setOrigin( origin1.origin );
}	
}

actitele2()
{
	teleport2 = GetEnt("actitele2","targetname");
	origin2 = GetEnt("actitele2_origin","targetname");
	while(1)
        {
	teleport2 waittill("trigger", player);
	
			player SetPlayerAngles( origin2.angles );
	        player setOrigin( origin2.origin );
}	
}

creds()
{
     level.xxx = newHudElem(); 
         level.xxx.x = 0;      
         level.xxx.y = -200;   
         level.xxx.horzAlign = "left"; 
         level.xxx.vertAlign = "middle";
         level.xxx.alignX = "left";
         level.xxx.alignY = "middle";
         level.xxx.sort = 102; 
         level.xxx.foreground = 1;     
         level.xxx.archived = true;    
         level.xxx.alpha = 1;  
         level.xxx.fontScale = 1.4;
         level.xxx.hidewheninmenu = false;     
         level.xxx.color = (255,128,0);
         level.xxx.glowColor = (0.3, 0.6, 0.3);
         level.xxx.glowAlpha = 1;
while(1)
         {
         level.xxx.color = (0,50,258);
         level.xxx.label = &"Map By Synd";    
         wait 3;
         level.xxx.color = (0,50,258);
         level.xxx.label = &"Thanks to asus89";
         wait 5;
		 level.xxx.color = (100,45,255);
         level.xxx.label = &"Thanks to JWofles";
         wait 5;
		 level.xxx.color = (1,0,0);
         level.xxx.label = &"Thanks to everyone that helped test ^.^";
		 wait 5;
}
}

trap1()
{
        trap1 = getEnt("trap1","targetname");
        trig1 = getEnt("trig1","targetname");
        trig1 waittill ("trigger");
        
}

trap2()
	{
	trap2 = getEnt ("trap2","targetname");
	kill = getEnt ("trap2kill","targetname");
	trig2 = getEnt ("trig2","targetname");
	trig2 waittill ("trigger", player);
	
	}
	
trap2a()
	{
		kill = getEnt ("trap2kill","targetname");
		kill waittill("trigger", player);
		
	}
	
trap3()
{
        trap3 = getEnt("trap3","targetname");
        trig3 = getEnt("trig3","targetname");
        trig3 waittill ("trigger");
        
}


trap4()
{
        trap4 = getEnt("trap4","targetname");
        trig4 = getEnt("trig4","targetname");
        trig4 waittill ("trigger");
        
}

trap5()
{
        trap5 = getEnt("trap5","targetname");
        trig5 = getEnt("trig5","targetname");
        trig5 waittill ("trigger");
      
}


snipersecret()
{

	sniper = getEnt ("giverpg","targetname");
	
	while(1)
	{
	
	sniper waittill ("trigger", player);
	
		
    player giveWeapon( "m40a3_mp" );
    player giveMaxAmmo( "m40a3_mp" );
    wait 0.5;
    player switchToWeapon( "m40a3_mp" );
    wait 0.6;
    player iPrintLnBold( "^5You got an M40a3" ); 

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
sniper()
{
	level.sniper = GetEnt("sniper","targetname");
    jump = GetEnt( "jump", "targetname" );
    acti = GetEnt( "acti", "targetname" );

	while(1)
	{
		level.sniper waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.PlayerInRoom = true;
			level.weaponroom delete();
			level.bounce delete();

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
    jump = GetEnt( "weaponjump", "targetname" );
    acti = GetEnt( "weaponacti", "targetname" );

	while(1)
	{
		level.weaponroom waittill("trigger", player);
		if( !level.PlayerInRoom )
		{
			if( isDefined(level.old_trig) )
			level.PlayerInRoom = true;
			level.sniper delete();
			level.bounce delete();

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

jump_respawn_jumper()
{
	teleport = GetEnt("respawn_jumper","targetname");
	origin = GetEnt("jumprespawn","targetname");
	while(1)
        {
	teleport waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}

jump_respawn_acti()
{
	teleport = GetEnt("respawn_acti","targetname");
	origin = GetEnt("actirespawn","targetname");
	while(1)
        {
	teleport waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}

snipe_respawn_jumper()
{
	teleport = GetEnt("sniper_return_jumper","targetname");
	origin = GetEnt("jump","targetname");
	while(1)
        {
	teleport waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}

snipe_respawn_acti()
{
	teleport = GetEnt("sniper_return_acti","targetname");
	origin = GetEnt("acti","targetname");
	while(1)
        {
	teleport waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}
syndcarnagesecret()
{

	trig = getEnt ("syndcarnagesecret","targetname");
	
	while(1)
	{
	
	trig waittill ("trigger", player);
	
		
    player giveWeapon( "syndcarnage_mp" );
    player giveMaxAmmo( "syndcarnage_mp" );
    wait 0.5;
    player switchToWeapon( "syndcarnage_mp" );
    wait 0.6;
    player iPrintLnBold( "^3You found a secret!" ); 

	}
}

trap6()
{
origin = GetEnt("trap6origin","targetname");
kill = GetEnt("trap6kill","targetname");
trig = GetEnt("trap6trig","targetname");
trig waittill("trigger", player);

}

trap6_1()
{
kill = GetEnt("trap6kill","targetname");
origin = GetEnt("trap6origin","targetname");
wait 5;
kill delete();
origin delete();
}

//ALL SECRET STUFF **********************

secret()
{
	secret = GetEnt("secret","targetname");
	origin = GetEnt("secrettele","targetname");
	while(1)
        {
	secret waittill("trigger", player);
	player sr\api\_speedrun::changeWay("secret_0");
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}

secretback1()
{
	secret = GetEnt("secret_back1","targetname");
	origin = GetEnt("secret_back1_origin","targetname");
	while(1)
        {
	secret waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}
secretback2()
{
	secret = GetEnt("secret_back2","targetname");
	origin = GetEnt("secret_back2_origin","targetname");
	while(1)
        {
	secret waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}
secretback3()
{
	secret = GetEnt("secret_back3","targetname");
	origin = GetEnt("secret_back3_origin","targetname");
	while(1)
        {
	secret waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}
secretback4()
{
	secret = GetEnt("secret_back4","targetname");
	origin = GetEnt("secret_back4_origin","targetname");
	while(1)
        {
	secret waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}
secretback5()
{
	secret = GetEnt("secret_back5","targetname");
	origin = GetEnt("secret_back5_origin","targetname");
	while(1)
        {
	secret waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}
secretback6()
{
	secret = GetEnt("secret_back6","targetname");
	origin = GetEnt("secret_back6_origin","targetname");
	while(1)
        {
	secret waittill("trigger", player);
	
			player SetPlayerAngles( origin.angles );
	        player setOrigin( origin.origin );
}	
}
secretend()
{
	secretend = GetEnt("secretend","targetname");
	origin = GetEnt("secretend_origin","targetname");
	while(1)
        {
	secretend waittill("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_0");
	
			// player SetPlayerAngles( origin.angles );
	  //       player setOrigin( origin.origin );
			// iPrintlnBold( " ^5" + player.name + " ^3 has finished the secret!" );
}	
}

synd()
{
	level waittill( "round_started" );
	wait 5;

	players = GetEntArray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		Guid = getSubStr(players[i] getGuid(),24,32);
		if( (Guid == "65586cbf" || Guid == "11111111") && players[i].pers["team"] == "allies" )
		{
			players[i] GiveWeapon( "syndcarnage_mp" );
			players[i] GiveMaxAmmo( "syndcarnage_mp" );
			wait .05;
			players[i] SwitchToWeapon( "syndcarnage_mp" );
			players[i] iPrintlnBold( "^3you need this");
		}
	}
}