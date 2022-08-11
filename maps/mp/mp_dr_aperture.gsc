#include braxi\_common;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	maps\mp\_load::main();

 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//setExpFog(500, 2200, 0.81, 0.75, 0.63, 0.5);
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	
	 precacheModel("portal_big_button");
	 precacheModel("portal_button");
	 precacheModel("portal_cake");
	 precacheModel("portal_companion_cube");
	 precacheModel("portal_cube");
	 precacheModel("portal_glados_p1_p1");
	 precacheModel("portal_glados_p1_p2");
	 precacheModel("portal_glados_p2");
	 precacheModel("portal_glados_p3");
	 precacheModel("portal_radio"); 
	 precacheModel("portal_turret");

	precacheItem("remington700_mp");
	precacheItem("knife_mp");
	precacheItem("tomahawk_mp");
	precacheItem("ak47_mp");
	precacheItem("m40a3_mp");
	precacheItem("saw_mp");

thread sr\api\_map::createSpawn((-474,511,60),360);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((-293.189, 130.523, 0.125001), 85, 50, (5398, 4005, -16), 270, "freeze", "yellow", "secret_0");
thread sr\api\_speedrun::createTeleporter((4254.86, 5532.23, 196.125), 90, 50, (4929, 5540, 1404), 360, "freeze", "blue", "normal_0");
thread sr\api\_speedrun::createEndMap((6474.92, 5535.5, 1344.13), 75, 50, "normal_0");

/////////////////////JUMPPADS/////////////////
	setupJumppads();
if( isDefined( level.jumppads ) && level.jumppads.size )
{
for( i = 0 ; i < level.jumppads.size ; i++ )
{
pad = level.jumppads[i];
if( !isDefined( pad ) )
continue;
spawnJumppad( pad.origin , pad.angles , pad.height , pad.radius , pad.dirPos , pad.model , pad.power , pad.sound );

jumppads = getEntArray( "jumppad" , "targetname" ); 
if( isDefined( jumppads ) && jumppads.size )
{
for( i = 0 ; i < jumppads.size ; i++ )
{
pad = jumppads[i];
if( !isDefined( pad ) )
continue; 
pad thread monitorUsage(); 
}
}
}
}

/////////////////////MISC/////////////////
thread start();
thread portal();
thread enddoor();
/////////////////////SECRET/////////////////
thread secretfail();
thread secretexit();

}

start()
{
	cube = getEnt( "comp_cube", "targetname" );
	door = getEnt( "startdoor", "targetname" );	
	clip = getEnt( "secret_clip", "targetname" );	
	turret = getEnt( "secret_turret", "targetname" );	
	
	
	cube delete();
	door delete();
	clip moveY(-700,0.1);
	turret moveY(-700,0.1);
	wait 0.2;
	clip moveZ(-50,0.1);
	turret moveZ(-50,0.1);
}

portal()
{
	tp_origin = getent ("blue_portal","targetname");
	tp_portal_trig = getent ("red_portal","targetname");

	for(;;)
	{  
		tp_portal_trig waittill("trigger", player);
		player SetPlayerAngles( tp_origin.angles );
		player setOrigin(tp_origin.origin);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

enddoor()
{
	cube = getent ("end_cube","targetname");
	doorleft = getent("endleft","targetname");
	doorright = getent("endright","targetname");
	hurt = getent("endhurt","targetname");
	cubedoor = getent("cubedoorleft","targetname");
	
   cube delete();
   doorleft delete();
   doorright delete();
   hurt delete();
   cubedoor delete();
	
}

secretfail()
{
	trigger = getent("secret_fail","targetname");
	
	for(;;)
	{   
		trigger waittill("trigger", player);
		player Suicide();
	}
	
}

secretexit()
{
	trigger = getent("secret_exit","targetname");
	
	for(;;)
	{   
		trigger waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}
	
}
////////////////////////// JUMPPADS ///////////////////////
setupJumppads() //3 als beispiel
{
//precacheModel( "xmodel/serthy_buildzone" );                         //falls model erwünscht, unbeding precachen! sonst crasht der server
 
level.jumppads = [];                                            // ganz wichtig! muss zuerst stehen!
 
level.jumppads[level.jumppads.size] = spawnStruct();                        //muss immer zuerst stehen bei jedem neuen jumppad
level.jumppads[level.jumppads.size - 1].origin = ( 2800,1296, 30 );        //wo?          
level.jumppads[level.jumppads.size - 1].angles = ( 0 , 0 , 0 );             //winkel?
level.jumppads[level.jumppads.size - 1].height =  20;                       //trigger höhe
level.jumppads[level.jumppads.size - 1].radius = 80;                        //trigger radius
level.jumppads[level.jumppads.size - 1].dirPos = ( 2800 , 1326 , 150 );           //richtung, sollte im bereich von +/- 50 neben dem origin sich befinden: origin + ( 50 , -30 , 32 )   
//level.jumppads[level.jumppads.size - 1].model = "xmodel/serthy_buildzone";      //damit man es erkennt? muss precached werden!!!
level.jumppads[level.jumppads.size - 1].power = 75000;                      //wie stark das jumppad ist
//level.jumppads[level.jumppads.size - 1].sound = "minefield_click";          //sound welcher abgespielt wird
}


spawnJumppad( origin , angles , height , radius , dirPos , model , power , sound )
{
if( !isDefined( radius ) )      radius = 5;
if( !isDefined( height ) )      height = 1;
if( !isDefined( angles ) )      angles = ( 0 , 0 , 0 );
 
jumppad = spawn( "trigger_radius" , origin , 0 , radius , height );
jumppad.angles = angles;
jumppad.targetname = "jumppad";
jumppad.jumpSound = sound;
jumppad.power = power;
 
if( isDefined( model ) )
{
jumppad.vis = spawn( "script_model" , origin );
jumppad.vis setmodel( model );
}
 
if( isDefined( dirPos ) )
jumppad.dir = vectorNormalize( dirPos - origin );
}
 
monitorUsage()
{
if( isDefined( self.target ) )
{
target = getEnt( self.target , "targetname" );
 
if( isDefined( target ) )
{
self.dir = vectorNormalize( self.target.origin - self.origin );
self.target delete();
}
}
 
if( isDefined( self.script_noteworthy ) )
{
tokens = strTok( self.script_noteworthy , "," );
self.power = tokens[0];
self.jumpSound = tokens[1];
}
 
while( isDefined( self ) )
{
 
self waittill( "trigger" , player );
 
if( !isDefined( player.isOnJumppad ) )
self bouncePlayer( player , self.power , self.dir );
}
}
 
bouncePlayer( player , power , dir )
{
player endon( "disconnect" );
 
player.isOnJumppad = undefined;
 
if( isDefined( self.jumpSound ) && self.jumpSound != "" )
self playSound( self.jumpSound );
 
if( !isDefined( dir ) )
dir = ( 0 , 0 , 1 );
 
if( !isDefined( power ) )
power = 150000;
 
//player iPrintLnBold( "Yippieeeh!" );
 
while( isDefined( self ) && isDefined( player ) )
{
if( player.sessionstate != "playing" )
break;
else if( !player isTouching( self ) )
break;
 
power = int( player.maxhealth * power );
health = player.health;
player.health += power;
 
player finishPlayerDamage( self , self , power , 0 , "MOD_PROJECTILE" , "none" , self.origin , dir , "none" , 0 );
 
player.health = health;
 
wait( 0.05 );
}
 
player.isOnJumppad = undefined;
}	