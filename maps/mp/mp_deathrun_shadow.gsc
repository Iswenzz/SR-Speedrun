main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::createSpawnOrigin(auto_spawn[int(auto_spawn.size / 2)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]); 
maps\mp\_load::main();
/* [AUTO DELETE] ambientPlay("jump3"); */

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

precacheItem("m4_mp");
precacheShader( "deathrun" );
precacheShader( "white" );

 // thread Juggernautact();
 // thread snipmove();
 thread trap1();
 thread trap2();
 thread trap3();
 thread trap4();
 thread trap5();
 thread trap8();
 thread trap9();
 thread trap10();
 thread trap11();
 thread trap12();
 thread trap13();
 thread teleport1();
 thread teleport2();
 thread snipback1();
 thread snipback2();
 thread mus();
 thread mus1();
 thread mus2();
 thread mus3();
 thread finalroom2();
 // thread creator();
 /* [AUTO DELETE] thread printCredits(); */
 // thread jumper();
 /* [AUTO DELETE] thread musictrig(); */
 // thread  [AUTO DELETE] initMusic(); 


level.fire = loadFX("deathrun/myfire");
level.room = loadFX("deathrun/ui_pickup_available");
 playLoopedFX(level.fire, 0.1, (91,173,-120));
 playLoopedFX(level.fire, 0.12, (-148.5,188.5,-120));
 playLoopedFX(level.room, 999.0, (2864,10888,-815));
 playLoopedFX(level.room, 999.1, (2925,10977,-418));
 playLoopedFX(level.room, 999.2, (2093,11280,-471));

 addTriggerToList( "trap1trig" );
 addTriggerToList( "trap2trig" );
 addTriggerToList( "trap3trig" );
 addTriggerToList( "trap4trig" );
 addTriggerToList( "trap5trig" ); 
 addTriggerToList( "trap7trig" ); 
 addTriggerToList( "trap8trig" ); 
 addTriggerToList( "trap8trig" ); 
 addTriggerToList( "trap9trig" ); 
 addTriggerToList( "trap10trig" ); 
 addTriggerToList( "trap11trig" ); 
 addTriggerToList( "trap12trig" );
 addTriggerToList( "trap13trig" );
 addTriggerToList( "juggernaut_trigger" );

}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}



Juggernautact()
{
trigger=getent("juggernaut_trigger","targetname");
trigger waittill ("trigger", player);
{
player DarkMode();
}
}


DarkMode()
{
self endon("death");
wait 0.1;
/* [AUTO DELETE] iPrintLnBold("^5Dark Mode ^7[^2ON^7]"); */
wait(0.5);
thread partymode();
}


trap1()
{
	level endon("trigger");
 
trig = getEnt( "trap1trig", "targetname" );
down = getEnt( "trap1", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
{

down movez( -300, 4 );
wait 4;
down movez( 300, 4 );

}
}


snipmove()
{
 
up = getEnt( "movesnip1", "targetname" );
down = getEnt( "movesnip2", "targetname" );

while( 1 )
{

up movez( -50, 2 );
down movez( 50, 2 );
wait 2;
up movez( 50, 2 );
down movez( -50, 2 );
wait 2;

}
}


trap2()
{
	level endon("trigger");
 
trig = getEnt( "trap2trig", "targetname" );
trap21 = getEnt( "trap21", "targetname" );
trap22 = getEnt( "trap22", "targetname" );
trap23 = getEnt( "trap23", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
while( 1 )
{

trap21 movez( -300, 3 );
wait 5;
trap21 movez( 300, 3 );
wait 5;
trap22 movez( -300, 3 );
trap23 movez( -300, 3 );
wait 5;
trap23 movez( 300, 3 );
trap22 movez( 300, 3 );
trap21 movez( -300, 3 );
wait 5;
trap22 movez( -300, 3 );
trap23 movez( -300, 3 );
wait 5;
trap23 movez( 300, 3 );
trap22 movez( 300, 3 );
trap21 movez( 300, 3 );
wait 5;

}
}


trap3()
{
	level endon("trigger");
 
trig = getEnt( "trap3trig", "targetname" );
trap3 = getEnt( "trap3", "targetname" );
killtrigger = getent ("trap3hurt" , "targetname");
 
trig waittill ("trigger");
trig delete();
 
while( 1 )
{

killtrigger enablelinkto ();
killtrigger linkto (trap3);
trap3 movey( 600, 3 );
wait 3;
trap3 movey( -600, 3 );
wait 3;
}
}


trap4()
{
	level endon("trigger");

trig = getEnt( "trap4trig", "targetname" );
trap4 = getEnt( "trap4", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
{

trap4 movez( -200, 2 );
}
}


trap5()
{
	level endon("trigger");
 
trig = getEnt( "trap5trig", "targetname" );
trap51 = getEnt( "trap51", "targetname" );
trap52 = getEnt( "trap52", "targetname" );
 
trig waittill ("trigger");
trig delete();

while( 1 )
{

trap51 movex( -280, 2 );
wait 2;
trap51 movex( 280, 2 );
trap52 movex( -280, 2 );
wait 2;
trap52 movex( 280, 2 );
}
}


trap6()
{
	level endon("trigger");
 
trig = getEnt( "trap7trig", "targetname" );
trap6 = getEnt( "trap6666", "targetname" );
 
trig waittill ("trigger");
trig delete();

while( 1 )
{

trap6 movez( -200, 2 );
}
}


trap8()
{
	level endon("trigger");
 
trig = getEnt( "trap8trig", "targetname" );
trap81 = getEnt( "trap81", "targetname" );
trap82 = getEnt( "trap82", "targetname" );
 
trig waittill ("trigger");
trig delete();

while( 1 )
{

trap81 rotatepitch( 360, 2 );
wait 2;
trap82 rotatepitch( 360, 2 );
wait 2;
}
}


trap9()
{
	level endon("trigger");
 
trig = getEnt( "trap9trig", "targetname" );
trap9 = getEnt( "trap9", "targetname" );
 
trig waittill ("trigger");
trig delete();

while( 1 )
{

trap9 rotateroll( 360, 2 );
wait 4;

}
}



trap10()
{
	level endon("trigger");
 
trig = getEnt( "trap10trig", "targetname" );
trap10 = getEnt( "trap10", "targetname" );
 
trig waittill ("trigger");
trig delete();

while( 1 )
{

trap10 rotateyaw( 360, 2 );
wait 2;

}
}


trap11()
{
	level endon("trigger");
 
trig = getEnt( "trap11trig", "targetname" );
trap11 = getEnt( "trap11", "targetname" );
trap111 = getEnt( "trap111", "targetname" );
 
trig waittill ("trigger");
trig delete();

while( 1 )
{

trap11 movez( 180, 1 );
trap111 movez( -180, 1 );
wait 1;
trap11 movez( -360, 1 );
trap111 movez( 360, 1 );
wait 1;
trap11 movez( 180, 1 );
trap111 movez( -180, 1 );
wait 1;

}
}


trap12()
{
	level endon("trigger");
 
trig = getEnt( "trap12trig", "targetname" );
trap12 = getEnt( "trap12", "targetname" );
 
trig waittill ("trigger");
trig delete();

{

trap12 movez( -999, 3 );
wait 3;
trap12 movez( 999, 3 );
wait 3;


}
}


trap13()
{
	level endon("trigger");
 
trig = getEnt( "trap13trig", "targetname" );
trap13 = getEnt( "trap13", "targetname" );
trap133 = getEnt( "trap133", "targetname" );
 
trig waittill ("trigger");
trig delete();

while( 1 )
{

trap13 movez( 90, 1 );
trap133 movez( -90, 1 );
wait 1;
trap13 movez( -180, 3 );
trap133 movez( 180, 3 );
wait 3;
trap13 movez( 90, 1 );
trap133 movez( -90, 1 );
wait 1;

}
}


partymode()
{
	for(;;)
	{	
		SetExpFog(256, 200, 0, 0, 0, 0.1);
        wait .5; 
                SetExpFog(256, 200, 0, 0, 0, 0.1);
	}
}



partymode1()
{
	for(;;)
	{	
		SetExpFog(256, 900, 1, 0, 0, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0, 1, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 1, 0.1); 
		wait .5; 
        SetExpFog(256, 900, 0.4, 1, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.8, 0, 0.6, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 0.6, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.2, 1, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.4, 0.4, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.4, 0.2, 0.2, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.4, 1, 1, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.6, 0, 0.4, 0.1); 
       wait .5; 
        SetExpFog(256, 900, 1, 0, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.6, 1, 0.6, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 0, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 1, 0, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0, 0, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.4, 1, 0.8, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.8, 0, 0.6, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 0.6, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 1, 1, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.2, 1, 0.8, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.4, 0.4, 1, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0, 0, 0, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.4, 0.2, 0.2, 0.1); 
       wait .5; 
        SetExpFog(256, 900, 0.4, 1, 1, 0.1); 
        wait .5; 
        SetExpFog(256, 900, 0.6, 0, 0.4, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 0, 0.8, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 1, 1, 0, 0.1); 
         wait .5; 
        SetExpFog(256, 900, 0.6, 1, 0.6, 0.1); 
	}
}


teleport1()
{
  trig = getEnt( "oldroom", "targetname"); 
  target = getEnt( "oldentered", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport2()
{
  trig = getEnt( "actijump", "targetname"); 
  target = getEnt( "actijumped", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


snipback1()
{
  trig = getEnt( "snipback1", "targetname"); 
  target = getEnt( "sniptpd1", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


snipback2()
{
  trig = getEnt( "snipback2", "targetname"); 
  target = getEnt( "sniptpd2", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


mus()
{
    level.mus_trig = getEnt( "mus", "targetname" );
    tele_activator = getEnt( "jumperacti", "targetname" );
    tele_jumper = getEnt( "jumperjump", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        level.mus_trig waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;


        level.mus_trig3 delete();
        level.mus_trig2 delete();
        level.mus_trig1 delete();

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "knife_mp", 100 );
	    level.activ finalRoom( tele_activator, "knife_mp", 100 );
		
	noti = SpawnStruct();
				noti.titleText = "Knife";
				noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
				noti.glowcolor = (0,0.9,0.7);
				noti.duration = 4;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);
    level.finalJumper thread OnDeath();
    level.activ thread OnDeath();


    }
    // code never gets here
}


mus1()
{
    level.mus_trig1 = getEnt( "mus1", "targetname" );
    tele_activator = getEnt( "jumpacti", "targetname" );
    tele_jumper = getEnt( "jumpjump", "targetname" );
                
    level.finalJumper = undefined; 

    while( 1 )
    {
        level.mus_trig1 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;


        level.mus_trig3 delete();
        level.mus_trig2 delete();
        level.mus_trig delete();

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom1( tele_jumper, "knife_mp", 100 );
	    level.activ finalRoom1( tele_activator, "knife_mp", 100 );
		
	noti = SpawnStruct();
				noti.titleText = "Crazy Knife";
				noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
				noti.glowcolor = (0,0.9,0.7);
				noti.duration = 4;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);
    level.finalJumper thread OnDeath();
    level.activ thread OnDeath();



    }
    // code never gets here
}


mus2()
{
    level.mus_trig2 = getEnt( "mus2", "targetname" );
    tele_activator = getEnt( "snipacti", "targetname" );
    tele_jumper = getEnt( "snipjump", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        level.mus_trig2 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;


        level.mus_trig3 delete();
        level.mus_trig1 delete();
        level.mus_trig delete();

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "m40a3_mp", 100 );
	    level.activ finalRoom( tele_activator, "m40a3_mp", 100 );
		
	noti = SpawnStruct();
				noti.titleText = "Sniper Room";
				noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
				noti.glowcolor = (0,0.9,0.7);
				noti.duration = 4;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);
    level.finalJumper thread OnDeath();
    level.activ thread OnDeath();


    }
    // code never gets here
}


mus3()
{
    level.mus_trig3 = getEnt( "mus3", "targetname" );
    tele_activator = getEnt( "dogacti", "targetname" );
    tele_jumper = getEnt( "dogjump", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        level.mus_trig3 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;

        level.mus_trig2 delete();
        level.mus_trig1 delete();
        level.mus_trig delete();

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom3( tele_jumper, "dog_mp", 100 );
	    level.activ finalRoom3( tele_activator, "dog_mp", 100 );

		
	noti = SpawnStruct();
				noti.titleText = "Dog Fight";
				noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
				noti.glowcolor = (0,0.9,0.7);
				noti.duration = 4;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);
    level.finalJumper thread OnDeath();
    level.activ thread OnDeath();


    }
    // code never gets here
}


finalMonitor()
{
    self endon( "disconnect" );
    self thread monitorDisconnect();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}


finalMonitor1()
{
    self endon( "disconnect" );
    self thread monitorDisconnect();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}


finalMonitor2()
{
    self endon( "disconnect" );
    self thread monitorDisconnect();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}


finalMonitor3()
{
    self endon( "disconnect" );
    self thread monitorDisconnect();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;

}


monitorDisconnect()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}


finalRoom( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
    
    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */

}


finalRoom1( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
    
    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */
	/* [AUTO DELETE] self SetMoveSpeedScale (3.2); */
    self thread jumpheight( 4 );



}


finalroom2()
{
    self waittill( "spawned_player" );
    /* [AUTO DELETE] self SetMoveSpeedScale (1.0); */


}


onDeath()
{
        self endon("disconnect");

        self waittill("death");
		
		/* [AUTO DELETE] iprintlnbold("^5>>>^7" + self.name + "^1 died^5<<<"); */
 
}


finalRoom3( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
    
    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    self detachAll();
    self setModel("german_sheperd_dog");
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */

}


jumpheight( strenght )
{
	self endon("disconnect");
	self endon("death");
	level endon("game over");
	
	oldpos = self.origin;
	jumped = false;
	
	if( !isDefined( strenght ) || strenght < 1 )
		strenght = 1;
	
	while(1)
	{
		if((self.origin[2] - oldpos[2] ) > 10  && !self IsOnGround() && !jumped)
		{
			if(jumped)
				continue;
			for(i=0;i<strenght;i++)
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


creator1()
{
players = getentarray("player", "classname");
for(i=0;i<=players.size;i++)
            {
            wait 0.1;
                {	
self.hud_music = [];
i = 0;	
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 360, 1, "left", "top", 1.6 );
	self.hud_music[i].sort = 885;
	self.hud_music[i] setText( "^5Map made by ^3MadLion" );
}
}
}


creator()
{
wait(5);
thread braxi\_mod::drawInformation( 800, 0.8, 1, "SHADOW" );
while( 1 )
{
self setClientDvar( "r_specular 1", "1" ); 
/* [AUTO DELETE] iPrintLn("^4Map made by ^5MadLion"); */
wait(60);
/* [AUTO DELETE] iPrintLn("^4xfire: ^5madlion3"); */
}
}


printCredits()
    {
            if( isDefined( self.logoText ) )
                    self.logoText destroy();
     
            self.logoText = newHudElem();
            self.logoText.y = 10;
            self.logoText.alignX = "center";
            self.logoText.alignY = "middle";
            self.logoText.horzAlign = "center_safearea";
     
            self.logoText.alpha = 0;
            self.logoText.sort = -3;
            self.logoText.fontScale = 1.6;
            self.logoText.archieved = true;
     
            for(;;)
            {
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^5---^3Map made by MadLion^5---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^5---^3xf: madlion3^5---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^5---^3Credits: Twiyo(xf: 1buzzz)^5---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^5---^3Shadow 1.2^5---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
		}
	
	}


jumper()
{
	level.jumpx1 = getent ("finishair","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");
	

	time = 2;
	for(;;)
	{
		level.jumpx1 waittill ("trigger",user);
		wait(0.05);
		if (user istouching(level.jumpx1))
		{		
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 2;
			air moveto (air2.origin, time);
			wait 2.3;
			air moveto (air3.origin, time);
			wait 2;
			air moveto (air4.origin, time);
                        user unlink();
		}
	}
}


initMusic()

{

	level.music = [];

 

	i = 0;

	level.music[i]["artist"] = "AfroWhitey & Sporty-O";

	level.music[i]["title"] = "Down For Whatever";

	level.music[i]["length"] = "06:27";

	level.music[i]["alias"] = "jump";


	i++;

	level.music[i]["artist"] = "Random";

	level.music[i]["title"] = "Random";

	level.music[i]["length"] = "Random";

	level.music[i]["alias"] = "jump5";

	i++;

	level.music[i]["artist"] = "Manian";

	level.music[i]["title"] = "Welcome to the club";

	level.music[i]["length"] = "03:10";

	level.music[i]["alias"] = "jump4";

	i++;

	level.music[i]["artist"] = "Danny McCarthy";

	level.music[i]["title"] = "Silver Scrapes";

	level.music[i]["length"] = "03:02";

	level.music[i]["alias"] = "musicmap";

	i++;

	level.music[i]["artist"] = "Robokids";

	level.music[i]["title"] = "Kids";

	level.music[i]["length"] = "03:42";

	level.music[i]["alias"] = "jump2";

	i++;

	level.music[i]["artist"] = "Nero";

	level.music[i]["title"] = "Promises";

	level.music[i]["length"] = "04:28";

	level.music[i]["alias"] = "jump";

 


 

	precacheShader( "deathrun" );

	precacheShader( "white" );

}


musicMenu()

{

	self endon( "disconnect" );

	self endon( "death" );

	self endon( "spawned" );

	self endon( "joined_spectators" );

	self endon( "music thread terminated" );

 

	self thread onDeathm();

	self thread onDisconnect();

 

	self.hud_music = [];

	// self cleanUp();

	self.selection = 0;

 

	// create huds

	i = 0;

	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );	// Background

	self.hud_music[i].sort = 880;

	self.hud_music[i] setShader( "deathrun", 320, 160 );

 

	i++;

	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );

	self.hud_music[i].sort = 883;

	self.hud_music[i] setText( "^3-^7 Select Music ^3-^7" );

 

	i++;

	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );

	self.hud_music[i].sort = 884;

	self.hud_music[i] setText( "Artist ^3-^7 Title ^3-^7 Length" );

 

	i++;

	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );

	self.hud_music[i].sort = 885;

	self.hud_music[i] setText( "Press ^3[LMB]^7: Next Song    Press ^3[USE]^7: Play Song    Press ^3[Nade]^7: Close Menu" );


 

	for( j = 0; j < level.music.size; j++ )

	{

		i++;

		// Artist - Title [lenght]

		////////////////////braxi\_mod::addTextHud(self, x, y, transparency, "x allignment", "y allignment", size(can't go below 1.3))

		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );

		self.hud_music[i].sort = 882;

		self.hud_music[i].font = "objective";

 

		entry = level.music[j];

		self.hud_music[i] setText( entry["artist"] + " ^3-^7 " + entry["title"] + " ^3[^7" + entry["length"] + "^3]^7" );

	}

 

	i++;

	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );	// Selection indicator

	self.hud_music[i].sort = 881;

	indicator = self.hud_music[self.hud_music.size-1];

	indicator setShader( "white", 306, 17 );

 

	while( self.sessionstate == "playing" )

	{

		wait 0.1;

 

		if( self attackButtonPressed() )	/* select next song */

		{

			self.hud_music[5+self.selection].alpha = 0.93; //unfocus previous item

 

			self.selection++;

			if( self.selection >= level.music.size )

				self.selection = 0;

 

			item = self.hud_music[5+self.selection];

			item.alpha = 1;

			indicator.y = item.y; // change indicator position

		}

		else if( self useButtonPressed() )	/* play selected song */

		{

			/* [AUTO DELETE] iPrintlnBold( "^3Song Changed"); */

 

			/* [AUTO DELETE] ambientPlay( level.music[self.selection]["alias"], 3 ); */

			break;

		}

		else if( self fragButtonPressed() )	/* close menu */

		{

			break; // close menu

		}

	}

 

	self cleanUp();

}


 

musictrig()

{

	trig = getEnt ("musictrig", "targetname");

 

	while(1)

	{

		trig waittill("trigger", player);

		player musicMenu();
                trig delete();

	}

}


 

onDisconnect()

{

	self endon( "music thread terminated" );

	self waittill( "disconnect" );

	self cleanUp();

}


 

onDeathm()

{

	self endon( "disconnect" );

	self endon( "music thread terminated" );

	self waittill( "death" );

	self cleanUp();

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
