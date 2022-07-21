//map my Sheep Wizard
//Xfire paap15
//Youtube paap15
//mp_deathrun_fluxx
//Enjoy
main()
{
thread sr\api\_map::createSpawnOrigin((-140, -96, -240), 90);
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
trigger = spawn( "trigger_radius", (-1663.35, 16682.4, -143.875), 0, 210, 75 );
trigger.targetname = "endmap_trig";
trigger.radius = 210;
	thread way_connect();
     maps\mp\_load::main();
	 level.blood = loadFX("deathrun/blood");
	 level.orangesmoke = loadFX("deathrun/orangesmoke");
	 level.glow = loadFX("deathrun/glow");
	 level.boom = loadFX("deathrun/boom");
	 level.flash = loadFX("deathrun/flash");
	 level.spark2 = loadFX("deathrun/spark2");

	 game["allies"] = "marines";
     game["axis"] = "opfor";
     game["attackers"] = "axis";
     game["defenders"] = "allies";
     game["allies_soldiertype"] = "desert";
     game["axis_soldiertype"] = "desert";

	 precacheItem( "colt45_silencer_mp" );
	 PrecacheShellShock("frag_grenade_mp");

	 //setDvar("bg_falldamagemaxheight", 20000 );
	 //setDvar("bg_falldamageminheight", 15000 );
	 setdvar( "r_specularcolorscale", "1" );
	 setdvar("r_glowbloomintensity0",".25");
	 setdvar("r_glowbloomintensity1",".25");

     // thread start();
	 // thread activatorlift();
	 // thread failsafe();
	 // thread scream();
	 // thread actiplatform();
	 // thread credits();
	 thread platform();
	 // thread gone();
	 thread platform2();
	 // thread hud();
	 // thread fog();
	 thread stairs();
	 // thread trap1();
	 // thread trap2();
	 // thread trap3();
	 // thread trap4();
	 // thread trap5();
	 // thread trap6();
	 // thread trap7();
	 // thread trap8();
	 // thread trap9();
	 // thread sniper();
	 // thread knife();
	 // thread hitman();
	 thread secret();
	 thread secretend();

	//  addTriggerToList( "trap1_trig" );
	// addTriggerToList( "trap2_trig" );
	// addTriggerToList( "trap3_trig" );
	// addTriggerToList( "trap4_trig" );
	// addTriggerToList( "trap5_trig" );
	// addTriggerToList( "trap6_trig" );
	// addTriggerToList( "trap7_trig" );
	// addTriggerToList( "trap8_trig" );
	// addTriggerToList( "trap9_trig" );
	 thread sr_tp();

}

sr_tp()
{
	ori = spawn("script_origin",(-1684,11788,-260));
	trig = spawn("trigger_radius",(-1667,8608,-276),0,150,150);
	trig.radius = 150;
	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player setOrigin(ori.origin);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    thread tp_1();

    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}

tp_1()
{
	ori = spawn("script_origin",(366,9399,-734));
	ori.angles = (0,90,0);
	trig = spawn("trigger_radius",(97,6,-180),0,75,150);
	trig.radius = 75;
	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "secret");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread tp_1_safe(ori);
	}
}

tp_1_safe(ori)
{
	self endon("death");
	self endon("disconnect");

	self sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
	self setOrigin(ori.origin);
	self setPlayerangles(ori.angles);
	self freezeControls(1);
	wait 0.05;
	self freezeControls(0);
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

credits()
{
     for(;;)
	 {
	 iPrintLn ("^3>>^1Map By Sheep Wizard");
	 wait 7;
	 iPrintLn ("^3>>^1Youtube paap15");
	 wait 7;
	 iPrintLn ("^3>>^1Xfire paap15");
	 wait 7;
	 iPrintLn ("^3>>^1FeZe Clan");
	 wait 7;
	 iPrintLn ("^3>>^2Thanks to all the people who helped test the map^6<3^2!");
	 wait 7;
	 iPrintLn ("^3>>^1Thanks for playing ^3mp_deathrun_Fluxx, ^1Hope you enjoy!");
	 wait 14;
	 }
}

start()
{
     wait 6;
	 musicPlay("meow");
	 iPrintLn ("^3>>^1<<^6Now playing: ^2sayCet - Dinofly^1>>");
}

activatorlift()
{
     brush = getent("brush100", "targetname");
	 trig = getent("tiger", "targetname");
	 trig waittill("trigger", player);
	 wait 0.2;
	 player FreezeControls(1);
	 brush movez(410,3,1,1);
	 brush waittill("movedone");
	 brush movey(128,1);
	 brush waittill("movedone");
	 brush movez(-10,1);
	 brush waittill("movedone");
	 brush movey(-128,1);
	 brush waittill("movedone");
	 brush rotateroll(90,0.1);
	 brush waittill("rotatedone");
	 brush movez(20,0.1);
	 brush waittill("movedone");
	 brush movey(70,0.1);
	 brush waittill("movedone");
	 player FreezeControls(0);
}

failsafe()
{
     trig = getent("failsafe", "targetname");
	 target = getent("fail", "targetname");
	 for(;;)
     {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
	 player FreezeControls(1);
	 wait 3;
	 player FreezeControls(0);
	 }
}

scream()
{
     trig = getent("head", "targetname");
	 trig waittill("trigger", player);
	 trig delete();
	 player ShellShock("frag_grenade_mp", 10 );
	 ambientPlay("screen");
	 SetExpFog(200, 500, 1,0,0,3);
}

actiplatform()
{
     brush = getent("actiplat", "targetname");
	 trig = getent("actitrig", "targetname");
	 brush2 = getent("brush20", "targetname");
	 trig waittill("trigger");
	 wait 0.4;
	 level.activ freezeControls(1);
	 brush movey (3072,4,1,1);
	 brush waittill("movedone");
	 wait 0.1;
	 brush2 movez (-200,2);
	 brush2 waittill("movedone");
	 wait 0.1;
	 level.activ freezeControls(0);
}

platform()
{
     plat = getent("platform", "targetname");
	 hold = getent("hold", "targetname");
	 hold2 = getent("hold2", "targetname");
	 // for(;;)
	 // {
	 // plat movey (2000,1);
	 // plat waittill ("movedone");
	 // wait 1;
	 // plat movez (-500,2);
	 // plat waittill ("movedone");
	 // hold2 movex (24,1);
	 // hold2 waittill ("movedone");
	 // wait 2;
	 // hold2 movex (-24,1);
	 // hold2 waittill ("movedone");
	 // plat movey (-2000,1);
	 // plat waittill ("movedone");
	 // wait 1;
	 // plat movez (500,1);
	 // plat waittill ("movedone");
	 // hold movex (24,1);
	 // hold waittill ("movedone");
	 // wait 2;
	 // hold movex (-24,3);
	 // hold waittill ("movedone");

	 // }
}

gone()
{
     thread aaa();
	 wait 4;
	 thread aab();
	 wait 4;
	 thread aac();
}

aaa()
{
     gone = getent("gone", "targetname");
     for(;;)
	 {
	 gone movey (464, 1);
	 gone waittill ("movedone");
	 gone movez (-160, 0.1);
	 gone waittill ("movedone");
	 gone movey (-464, 0.1);
	 gone waittill ("movedone");
	 gone movez (160, 0.1);
	 gone waittill ("movedone");
	 }
}

aab()
{
     gone2 = getent("gone2", "targetname");
     for(;;)
	 {
	 gone2 movey (464, 1);
	 gone2 waittill ("movedone");
	 gone2 movez (-160, 0.1);
	 gone2 waittill ("movedone");
	 gone2 movey (-464, 0.1);
	 gone2 waittill ("movedone");
	 gone2 movez (160, 0.1);
	 gone2 waittill ("movedone");
	 }
}

aac()
{
     gone3 = getent("gone3", "targetname");
     for(;;)
	 {
	 gone3 movey (464, 1);
	 gone3 waittill ("movedone");
	 gone3 movez (-160, 0.1);
	 gone3 waittill ("movedone");
	 gone3 movey (-464, 0.1);
	 gone3 waittill ("movedone");
	 gone3 movez (160, 0.1);
	 gone3 waittill ("movedone");
	 }
}

platform2()
{
     platform = getent("platforn2", "targetname");
	 // for(;;)
	 // {
	 // platform movey (3072,6,2,1);
	 // platform waittill ("movedone");
	 // wait 3;
	 // platform movey (-3072,6,2,1);
	 // platform waittill ("movedone");
	 // wait 3;
	 // }
}

hud()
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
	 level.xxx2 = newHudElem();
	 level.xxx2.x = 10;
	 level.xxx2.y = -186;
	 level.xxx2.horzAlign = "left";
	 level.xxx2.vertAlign = "middle";
	 level.xxx2.alignX = "left";
	 level.xxx2.alignY = "middle";
	 level.xxx2.sort = 102;
	 level.xxx2.foreground = 1;
	 level.xxx2.archived = true;
	 level.xxx2.alpha = 1;
	 level.xxx2.fontScale = 1.4;
	 level.xxx2.hidewheninmenu = false;
	 level.xxx2.color = (255,0,154);
	 level.xxx2.glowColor = (0.3, 0.6, 0.3);
	 level.xxx2.glowAlpha = 1;
	 while(1)
	 {
	 level.xxx.color = (255,128,0);
	 level.xxx2.color = (255,0,154);
	 level.xxx2.x = 25;
	 level.xxx.label = &"Map by Sheep Wizard";	//The text for the hud & is required, &&1 is the value which will be added below
	 level.xxx2.label = &"Have Fun!";
	 wait 10;
	 level.xxx.color = (0,50,255);
	 level.xxx2.color = (255,0,150);
	 level.xxx2.x = 25;
	 level.xxx.label = &"Xfire: Paap15";
	 level.xxx2.label = &"Have Fun!";
	 wait 5;
	}
}

fog()
{
     for(;;)
	 {
	 SetExpFog(2000, 3000, 0.5,0.2,0.01,3);
	 wait 8;
	 SetExpFog(2000, 3000, 0.4,0.2,0.22,3);
	 wait 8;
	 }
}

stairs()
{
     trig = getent("stairs", "targetname");
	 brush1 = getent("brush12", "targetname");
	 brush2 = getent("brush13", "targetname");
	 brush3 = getent("brush14", "targetname");
	 brush4 = getent("brush15", "targetname");
	 brush5 = getent("brush16", "targetname");
	 // trig waittill("trigger", player);
	 thread fx();
	 brush1 movez (32,2);
	 wait 0.1;
	 brush2 movez (48,2);
	 wait 0.1;
	 brush3 movez (64,2);
	 wait 0.1;
	 brush4 movez (80,2);
	 wait 0.1;
	 brush5 movez (96,2);
	 brush5 waittill("movedone");
}

fx()
{
     glow = getent("glow", "targetname");
	 glow2 = getent("glow2", "targetname");
	 glow3 = getent("glow3", "targetname");
	 glow4 = getent("glow4", "targetname");
	 boom= getent("boom", "targetname");
     PlayFX( level.glow, glow.origin );
	 PlayFX( level.glow, glow2.origin );
	 PlayFX( level.glow, glow3.origin );
	 PlayFX( level.glow, glow4.origin );
	 PlayFX( level.boom, boom.origin );
	 wait 0.5;
	 PlayFX( level.boom, boom.origin );
	 wait 0.5;
	 PlayFX( level.boom, boom.origin );

}


//Traps

trap1()
{
     trig = getent("trap1_trig", "targetname");
	 spinner = getent("spinner", "targetname");
	 trig waittill("trigger", player);
	 trig delete();
	 while(1)
	 {
	     spinner rotatepitch (360,6);
		 wait 6;
		}
}

trap2()
{
     trig = getent("trap2_trig", "targetname");
	 trig waittill("trigger", player);
	 trig delete();
	 thread trap2a();
	 thread trap2b();
}
trap2a()
{
     conf = getent("conf", "targetname");
  //    while(1)
	 // {
  //    conf movex (64,0.4);
	 // conf waittill("movedone");
	 // conf movex (-64,0.4);
	 // conf waittill("movedone");
	 // conf movex (-64,0.4);
	 // conf waittill("movedone");
	 // conf movex (64,0.4);
	 // conf waittill("movedone");
	 // }
}

trap2b()
{
     conf2 = getent("conf2", "targetname");
  //    while(1)
	 // {
  //    conf2 movey (64,0.4);
	 // conf2 waittill("movedone");
	 // conf2 movey (-64,0.4);
	 // conf2 waittill("movedone");
	 // conf2 movey (-64,0.4);
	 // conf2 waittill("movedone");
	 // conf2 movey (64,0.4);
	 // conf2 waittill("movedone");
	 // }
}

trap3()
{
     trig = getent("trap3_trig", "targetname");
	 bounce = getent("bounce", "targetname");
	 trig waittill("trigger", player);
	 trig delete();
     while(1)
	 {
	 bounce rotateroll (180,11);
	 wait 11;
	 }
}

trap4()
{
     trig = getent("trap4_trig", "targetname");
	 brush = getent("brush1", "targetname");
	 trig waittill("trigger");
	 trig delete();
	 while(1)
	 {
	 brush movex (1408,1.4);
	 brush waittill("movedone");
	 wait 2;
	 brush movex (-1408,1.4);
	 brush waittill("movedone");
	 wait 2;
	 }
}

trap5()
{
     trig = getent("trap5_trig", "targetname");
 	 trig waittill("trigger", player);
	 trig delete();
	 thread trap5a();
	 thread trap5b();
}

trap5a()
{
     while(1)
	 {
	 brush3 = getent("brush3", "targetname");
     brush3 rotatepitch (720, 5);
	 brush3 waittill("rotatedone");
	 wait 5;
	 }
}

trap5b()
{
     while(1)
	 {
	 brush4 = getent("brush4", "targetname");
     brush4 rotatepitch (-720, 5);
	 brush4 waittill("rotatedone");
	 wait 5;
	 }
}

trap6()
{
     trig = getent("trap6_trig", "targetname");
	 brush5 = getent("brush5", "targetname");
	 trig waittill("trigger", player);
	 trig delete();
	 while(1)
	 {
	 brush5 rotateroll (-360, 2);
	 wait 2;
	 }
}

trap7()
{
     trig = getent("trap7_trig", "targetname");
	 trig waittill("trigger", player);
	 trig delete();
	 thread trap7a();
	 thread trap7b();
}

trap7a()
{
     brush7a = getent("brush7a", "targetname");
	 brush7 = getent("brush7", "targetname");
	 quake = getent("quake", "targetname");
	 smoke = getent("smoke", "targetname");
	 brush7a enablelinkto ();
     brush7a linkto (brush7);
	 while(1)
	 {
	 brush7 movex (-448,0.5);
	 brush7 waittill("movedone");
	 Earthquake( 1, 3, quake.origin, 700 ); // (magnitude of the earthquake, length, at what origin, and the radius)
	 PlayFX( level.orangesmoke, smoke.origin );
	 wait 4;
	 brush7 movex (448,3,1,0.5);
	 brush7 waittill("movedone");
	 wait 2;
	 }
}

trap7b()
{
     brush8a = getent("brush8a", "targetname");
	 brush8 = getent("brush8", "targetname");
	 brush8a enablelinkto ();
     brush8a linkto (brush8);
	 while(1)
	 {
	 brush8 movex (448,0.5);
	 brush8 waittill("movedone");
	 wait 4;
	 brush8 movex (-448,3,1,0.5);
	 brush8 waittill("movedone");
	 wait 2;
	 }
}

trap8()
{
     trig = getent("trap8_trig", "targetname");
	 brush = getent("brush10", "targetname");
	 trig waittill("trigger", player);
	 trig delete();
	 while(1)
	 {
	 brush movez (-10,0.1);
	 brush waittill("movedone");
	 brush movez (10,0.1);
	 brush waittill("movedone");
	 }
}

trap9()
{
     trig = getent("trap9_trig", "targetname");
	 trig waittill("trigger");
	 trig delete();
	 thread trap9a();
	 thread trap9b();
}

trap9a()
{
     brush = getent("brush22", "targetname");
	 brush movex(128,1);
	 brush waittill("movedone");
	 while(1)
	 {
	 brush rotatepitch (-360,7);
	 wait 7;
	 }
}

trap9b()
{
     brush2 = getent("brush23", "targetname");
	 brush2 movex(-128,1);
	 brush2 waittill("movedone");
	 while(1)
	 {
	 brush2 rotatepitch (360,7);
	 wait 7;
	 }
}

sniper()
{
     level.sniper_trig = getEnt( "sniper", "targetname");
     sjump = getEnt( "jumps", "targetname" );
     sacti = getEnt( "actis", "targetname" );

	 level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
         return;
        if(level.firstenter==true)
		{
		 level.knife_trig delete();
		 level.hitman_trig delete();
		 level.firstenter=false;
		}
     player SetPlayerAngles( sjump.angles );
	 player setOrigin( sjump.origin );
	 level.activ setPlayerangles( sacti.angles );
	 level.activ setOrigin( sacti.origin );
	 level.activ TakeAllWeapons();
	 player TakeAllWeapons();
	 level.activ giveweapon( "m40a3_mp");
	 player giveweapon( "m40a3_mp");
	 player switchToWeapon( "m40a3_mp" );
	 level.activ SwitchToWeapon( "m40a3_mp" );
	 player setWeaponAmmoClip( "m40a3_mp", 5 );
     player setweaponammostock( "m40a3_mp", 50 );
	 level.activ setWeaponAmmoClip( "m40a3_mp", 5 );
     level.activ setweaponammostock( "m40a3_mp", 50 );
	 level.activ freezeControls(1);
	 player FreezeControls(1);
	 wait 2;
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
	 player thread onDeath_sniper();
     wait 0.1;

     for(;;)
     {
     wait .1;
     while(isAlive(player))
     {
     wait 1;
     }
     }
}
onDeath_sniper()
{
     self endon("disconnect");
     self waittill("death");
     thread sniper();
}

knife()
{
     level.knife_trig = getEnt( "knife", "targetname");
     kjump = getEnt( "jumpk", "targetname" );
     kacti = getEnt( "actik", "targetname" );

	 level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
         return;
         if(level.firstenter==true)
		{
		 level.sniper_trig delete();
		 level.hitman_trig delete();
		 level.firstenter=false;
		}
     player SetPlayerAngles( kjump.angles );
	 player setOrigin( kjump.origin );
	 level.activ setPlayerangles( kacti.angles );
	 level.activ setOrigin( kacti.origin );
	 level.activ TakeAllWeapons();
	 player TakeAllWeapons();
	 level.activ giveweapon( "tomahawk_mp");
	 player giveweapon( "tomahawk_mp");
	 player switchToWeapon( "tomahawk_mp" );
	 level.activ SwitchToWeapon( "tomahawk_mp" );
	 level.activ FreezeControls(1);
	 player FreezeControls(1);
	 wait 5;
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
	 player thread onDeath_knife();
     wait 0.1;

     for(;;)
     {
     wait .1;
     while(isAlive(player))
     {
     wait 1;
     }
     }
}
onDeath_knife()
{
     self endon("disconnect");
     self waittill("death");
	 thread knife();

}

hitman()
{
     level.hitman_trig = getEnt( "hitman", "targetname");
     hjump = getEnt( "jumph", "targetname" );
     hacti = getEnt( "actih", "targetname" );

	 level.hitman_trig waittill( "trigger", player );
        if( !isDefined( level.hitman_trig ) )
         return;
         if(level.firstenter==true)
		{
		 level.sniper_trig delete();
		 level.knife_trig delete();
		 level.firstenter=false;
		}
     player SetPlayerAngles( hjump.angles );
	 player setOrigin( hjump.origin );
	 level.activ setPlayerangles( hacti.angles );
	 level.activ setOrigin( hacti.origin );
	 level.activ TakeAllWeapons();
	 player TakeAllWeapons();
	 level.activ giveweapon( "colt45_silencer_mp");
	 player giveweapon( "colt45_silencer_mp");
	 player switchToWeapon( "colt45_silencer_mp" );
	 level.activ SwitchToWeapon( "colt45_silencer_mp" );
	 player giveMaxAmmo( "colt45_silencer_mp" );
	 level.activ giveMaxAmmo( "colt45_silencer_mp" );
	 player setWeaponAmmoClip( "colt45_silencer_mp", 0 );
     player setweaponammostock( "colt45_silencer_mp", 100 );
	 level.activ setWeaponAmmoClip( "colt45_silencer_mp", 0 );
     level.activ setweaponammostock( "colt45_silencer_mp", 100 );
	 level.activ FreezeControls(1);
	 player FreezeControls(1);
	 wait 1;
	 level.activ FreezeControls(0);
	 player FreezeControls(0);
	 player thread onDeath_hitman();
     wait 0.1;

     for(;;)
     {
     wait .1;
     while(isAlive(player))
     {
     wait 1;
     }
     }
}
onDeath_hitman()
{
     self endon("disconnect");
     self waittill("death");
	 thread hitman();
}

secret()
{
trig = getEnt ("secret", "targetname");
target = getEnt ("secrettarget", "targetname");

for(;;)
{
trig waittill ("trigger", player);

player SetOrigin(target.origin);
player SetPlayerAngles( target.angles );
player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
}
}

secretend()
{
trig = getEnt ("secretend", "targetname");
target = getEnt ("secretendtarget", "targetname");

for(;;)
{
trig waittill ("trigger", player);

player SetOrigin(target.origin);
player SetPlayerAngles( target.angles );
player thread sr\api\_speedrun::finishWay("secret_0");
}
}














