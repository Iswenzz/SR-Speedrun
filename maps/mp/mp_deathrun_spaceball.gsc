main()
{
	thread sr\api\_map::create_normal_way("Normal Way;");
  thread sr\api\_map::create_secret_way("Secret Way;");

  thread sr\api\_map::create_spawn((-1244, -59, 4065), 0);

maps\mp\_load::main();
/* [AUTO DELETE] ambientPlay("fullmap"); */

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 thread teleport1();
 thread teleport2();
 thread teleport3();
 thread teleport4();
 thread teleport5();
 thread teleport6();
 thread teleport7();
 thread teleport8();
 thread teleport9();
 thread teleport10();
 // thread start();
 // thread creator();
 thread move11();
 thread trap1();
 thread trap2();
 thread trap3();
 thread trap4();
 thread trap5();
 thread trap6();
 thread trap7();
 // thread finalFight1();
 // thread finalFight2();
 // thread finalFight3();
 // thread finalFight4();
 // thread  [AUTO DELETE] moveknife(); 
 thread teleportacti();
 thread teleportacti2();
 thread teleportacti3();
 thread ballrotate1();
 thread ballrotate2();
 thread ballrotate3();
 thread ballrotate4();
 thread secretroom();

preCacheItem( "winchester1200_mp" );
preCacheItem( "mp5_mp" );

 addTriggerToList( "trap1trig" );
 addTriggerToList( "trap2trig" );
 addTriggerToList( "trap3trig" );
 addTriggerToList( "trap4trig" );
 addTriggerToList( "trap5trig" ); 
 addTriggerToList( "trap6trig" ); 
 addTriggerToList( "trap7trig" ); 

}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


teleport1()
{
  trig = getEnt( "spawn", "targetname"); 
  target = getEnt( "spawned", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport2()
{
  trig = getEnt( "lifespawn", "targetname"); 
  target = getEnt( "lifespawned", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport3()
{
  trig = getEnt( "act2", "targetname"); 
  target = getEnt( "acti2", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport4()
{
  trig = getEnt( "act3", "targetname"); 
  target = getEnt( "acti3", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}

teleport5()
{
  trig = getEnt( "act4", "targetname"); 
  target = getEnt( "acti4", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport6()
{
  trig = getEnt( "rpgback1", "targetname"); 
  target = getEnt( "rpgbacked1", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport7()
{
  trig = getEnt( "rpgback2", "targetname"); 
  target = getEnt( "rpgbacked2", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport8()
{
  trig = getEnt( "secretenter", "targetname"); 
  target = getEnt( "secretentered", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );

player thread sr\api\_map::change_way("s0");
      }
}


teleport9()
{
  trig = getEnt( "secretback", "targetname"); 
  target = getEnt( "secretbacked", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
     }
}


teleport10()
{
  trig = getEnt( "secretfinish", "targetname"); 
  target = getEnt( "secretfinished", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
    player thread sr\api\_map::finish_way("s0");
      }
}


start()
{
wait(5);
thread braxi\_mod::drawInformation( 800, 0.8, 1, "^5SPACEBALL" );
wait(4);
thread braxi\_mod::drawInformation( 800, 0.8, 1, "^4Map by ^5Madlion ^4xFire: ^5madlion3" );
wait(4);
thread braxi\_mod::drawInformation( 800, 0.8, 1, "^5Let's go" );
}


creator()
{
while( 1 )
{
iPrintLn( "^5Map made by ^4MadLion ^5xfire: ^4madlion3");
wait(60);
}
}


move11()
{
 
move11 = getEnt( "move11", "targetname" );
 
 
{
// wait 13;
move11 movex( 4700, 0.05 );

}
}



move2()
{
 
move2 = getEnt( "move2", "targetname" );
 
 
{
wait 13;
move2 movex( 4700, 5 );
wait 5;
move2 movez( 150, 2 );

}
}


trap1()
{
	level endon("trigger");
 
trig = getEnt( "trap1trig", "targetname" );
rotate1 = getEnt( "trap1", "targetname" );
rotate2 = getEnt( "trap11", "targetname" );
rotate3 = getEnt( "trap111", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
while( 1 )
{

rotate1 rotateyaw( 720, 4 );
rotate2 rotateyaw( 720, 4 );
rotate3 rotateyaw( 720, 4 );
wait 4;
rotate1 rotateyaw( -720, 4 );
rotate2 rotateyaw( -720, 4 );
rotate3 rotateyaw( -720, 4 );
wait 4;

}
}


trap2()
{
	level endon("trigger");
 
trig = getEnt( "trap2trig", "targetname" );
left = getEnt( "trap2", "targetname" );
right = getEnt( "trap22", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
while( 1 )
{

left movex( 128, 1 );
right movex( -128, 1 );
wait 1;
right movex( 128, 1 );
left movex( -128, 1 );
wait 1;
right movex( 128, 1 );
left movex( -128, 1 );
wait 1;
left movex( 128, 1 );
right movex( -128, 1 );
wait 1;

}
}


trap3()
{
	level endon("trigger");
 
trig = getEnt( "trap3trig", "targetname" );
rotate = getEnt( "trap3", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
while( 1 )
{

rotate rotatepitch( 720, 3 );
wait 5;
rotate rotatepitch( -720, 3 );
wait 5;

}
}


trap4()
{
	level endon("trigger");
 
trig = getEnt( "trap4trig", "targetname" );
ham1 = getEnt( "trap4", "targetname" );
ham2 = getEnt( "trap44", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
while( 1 )
{

ham1 rotatepitch( 70, 1 );
ham2 rotatepitch( -70, 1 );
wait 1;
ham1 rotatepitch( -140, 2 );
ham2 rotatepitch( 140, 2 );
wait 2;
ham1 rotatepitch( 70, 1 );
ham2 rotatepitch( -70, 1 );
wait 1;

}
}


trap5()
{
	level endon("trigger");
 
trig = getEnt( "trap5trig", "targetname" );
hamm1 = getEnt( "trap5", "targetname" );
hamm2 = getEnt( "trap55", "targetname" );
hamm3 = getEnt( "trap555", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
while( 1 )
{

hamm1 rotatepitch( 720, 3 );
wait 2;
hamm2 rotatepitch( 720, 3 );
wait 2;
hamm3 rotatepitch( 720, 3 );
wait 2;

}
}


trap6()
{
	level endon("trigger");
 
trig = getEnt( "trap6trig", "targetname" );
hammm1 = getEnt( "trap6", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
while( 1 )
{

hammm1 rotateyaw( 720, 4 );
wait 6;

}
}



trap7()
{
	level endon("trigger");
 
trig = getEnt( "trap7trig", "targetname" );
hammmm1 = getEnt( "trap7", "targetname" );
 
trig waittill ("trigger");
trig delete();
 
{

hammmm1 rotateyaw( 360, 3 );
wait 3;

}
}



old()
{
 
oldmove = getEnt( "oldmove", "targetname" );
 
 
{

oldmove movez( -10, 1 );
wait 1;

}
}


finalFight1()
{
    trig = getEnt( "kniferoom", "targetname" );
    tele_activator = getEnt( "knife_activator", "targetname" );
    tele_jumper = getEnt( "knife_jumper", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        trig waittill( "trigger", player );

        // this will be blocked if jumper is currently in room and while its free run round
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "knife_mp", 100 );
        /* [AUTO DELETE] iPrintLnBold(player.name+ "^4 has entered the ^2Knife Room"); */
        level.activ finalRoom( tele_activator, "knife_mp", 100 );

    }
    // code never gets here
}



finalFight2()
{
    trig = getEnt( "rpgroom", "targetname" );
    tele_activator = getEnt( "rpg_activator", "targetname" );
    tele_jumper = getEnt( "rpg_jumper", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        trig waittill( "trigger", player );

        // this will be blocked if jumper is currently in room and while its free run round
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "winchester1200_mp", 100 );
        /* [AUTO DELETE] iPrintLnBold(player.name+ "^4 has entered the ^2Shotgun Room"); */
        level.activ finalRoom( tele_activator, "winchester1200_mp", 100 );

    }
    // code never gets here
}


finalFight3()
{
    trig = getEnt( "sniperroom", "targetname" );
    tele_activator = getEnt( "snip_activator", "targetname" );
    tele_jumper = getEnt( "snip_jumper", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        trig waittill( "trigger", player );

        // this will be blocked if jumper is currently in room and while its free run round
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "m40a3_mp", 100 );
        /* [AUTO DELETE] iPrintLnBold(player.name+ "^4 has entered the ^2Sniper Room"); */
        level.activ finalRoom( tele_activator, "m40a3_mp", 100 );

    }
    // code never gets here
}


finalFight4()
{
    trig = getEnt( "jumproom", "targetname" );
    tele_activator = getEnt( "jump_activator", "targetname" );
    tele_jumper = getEnt( "jump_jumper", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        trig waittill( "trigger", player );

        // this will be blocked if jumper is currently in room and while its free run round
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
            continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom( tele_jumper, "mp5_mp", 100 );
        /* [AUTO DELETE] iPrintLnBold(player.name+ "^4 has entered the ^2Crazy Weapon Room"); */
        level.activ finalRoom( tele_activator, "mp5_mp", 100 );

    }
    // code never gets here
}


finalFight5()
{
    trig = getEnt( "oldroom", "targetname" );
    tele_activator = getEnt( "oldactivator", "targetname" );
    tele_jumper = getEnt( "oldjumper", "targetname" );
                
    level.finalJumper = undefined;

    while( 1 )
    {
        trig waittill( "trigger", player );
   
        if (player.pers["team"] != "allies" ) 
        continue;

        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
        
        level.finalJumper finalRoom1( tele_jumper, "tomahawk_mp", 100 );
        /* [AUTO DELETE] iPrintLnBold(player.name+ "^4 has entered the ^2OLD Room"); */
        level.activ finalRoom( tele_activator, "tomahawk_mp", 100 );

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
    
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */

}


partymode()
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


moveknife()
{
 
moveknife = getEnt( "knifemove", "targetname" );
 
 
{
wait 1;
moveknife rotateroll( 180, 1 );

}
}


teleportacti()
{
  trig = getEnt( "actback2", "targetname"); 
  target = getEnt( "actbacked", "targetname");


  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleportacti2()
{
  trig = getEnt( "actback3", "targetname"); 
  target = getEnt( "actbacked3", "targetname");


  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleportacti3()
{
  trig = getEnt( "actback5", "targetname"); 
  target = getEnt( "actbacked5", "targetname");


  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleportold()
{
  trig = getEnt( "oldenter", "targetname"); 
  target = getEnt( "oldentered", "targetname");


  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
     /* [AUTO DELETE] iPrintLnBold(player.name+ "^4 has entered the ^2OLD Room"); */
      }
}


ballrotate1()
{
 
ballrotate1 = getEnt( "rotateball1", "targetname" );

 
while( 1 )
{

ballrotate1 rotateyaw( 360, 2 );
wait 2;

}
}


ballrotate2()
{
 
ballrotate2 = getEnt( "rotateball2", "targetname" );

 
while( 1 )
{

ballrotate2 rotateyaw( 360, 2 );
wait 2;

}
}


ballrotate3()
{
 
ballrotate3 = getEnt( "rotateball3", "targetname" );

 
while( 1 )
{

ballrotate3 rotateyaw( 360, 2 );
wait 2;

}
}


ballrotate4()
{
 
ballrotate4 = getEnt( "rotateball4", "targetname" );

 
while( 1 )
{

ballrotate4 rotateyaw( 360, 4 );
wait 4;

}
}


secretroom()
{
 
trig = getEnt( "secretdoortrig", "targetname" );
secretdoor = getEnt( "secretdoor", "targetname" );
 
// trig waittill ("trigger");
// trig delete();
 
{

/* [AUTO DELETE] ambientPlay("secret"); */
/* [AUTO DELETE] iPrintLn( "^4Secret is open" ); */
secretdoor movez( 272, 2 );
wait 2;

}
}


 
new_ending_hud( align, fade_in_time, x_off, y_off )
{
        hud = newClientHudElem( self );
        hud.foreground = true;
        hud.x = x_off;
        hud.y = y_off;
        hud.alignX = align;
        hud.alignY = "middle";
        hud.horzAlign = align;
        hud.vertAlign = "middle";
 
        hud.fontScale = 1.6;
 
        hud.color = (1, 1, 1);
        hud.font = "objective";
        hud.glowColor = (0.8, 0.3, 0.8);
        hud.glowAlpha = 0.5;
 
        hud.alpha = 1;
        hud fadeovertime( fade_in_time );
        hud.alpha = 1;
        hud.hidewheninmenu = true;
        hud.sort = 10;
        return hud;
}

 
drawInformationUp( start_offset, movetime, mult, text )
{
        start_offset *= mult;
        hud = new_ending_hud( "center", 0.1, start_offset, -15 );
        hud setText( text );
        hud moveOverTime( movetime );
        hud.x = -100;
        wait( movetime );
        hud moveOverTime( 5 );
        hud.x = 100;
        wait 5;
        hud moveOverTime( movetime );
        hud.x = start_offset * -1;
 
        wait movetime;
        hud destroy();
}

 
drawInformationDown( start_offset, movetime, mult, text )
{
        start_offset *= mult;
        hud = new_ending_hud( "center", 0.1, start_offset, 15 );
        hud setText( text );
        hud moveOverTime( movetime );
        hud.x = 100;
        wait( movetime );
        hud moveOverTime( 5 );
        hud.x = -100;
        wait 5;
        hud moveOverTime( movetime );
        hud.x = start_offset * -1;
 
        wait movetime;
        hud destroy();
}
