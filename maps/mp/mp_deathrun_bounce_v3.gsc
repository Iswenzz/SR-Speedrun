main()
{
	thread speedrun\_way_name::create_normal_way("^2Easy Way; ^9Training Way; ^1Hard Way");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread speedrun\_way_name::create_spawn_auto(auto_spawn[int(auto_spawn.size / 2)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]);
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread speedrun\_way_name::create_endmap((9572, -487, 988), 100, 150);

    /* [AUTO DELETE] ambientPlay("mapsong2"); */

    thread door();
    thread trap1();
    thread trap2();
    thread trap3();
    thread trap4();
    thread trap5();
    thread trap6();
    thread trap7();
    thread trap8();
    thread trap9();
    thread trap10();
    thread trap11();
    thread trap12();
    thread trap13();
    thread trap14();
    thread teleport();
    thread teleport_e();
    thread teleport_h();
    thread teleport_t();
    thread treaning_finish();
    thread hard_finish();
    thread pod();
    thread pod2();
    thread pod3();
    /* [AUTO DELETE] thread printcredits(); */
    thread snip();
    /* [AUTO DELETE] thread knife(); */
    thread pistol();
    thread RPD();
    thread jump();
}


door()
{
    trig = getEnt( "trap_door", "targetname" );
    object1 = getent("door","targetname");
    object2 = getent("door1","targetname");
    object3 = getent("door2","targetname");
    object4 = getent("door3","targetname");

 
    trig waittill ("trigger");
    trig delete();
 
    {
        object1 movez(-256, 5);
        wait 1;

        object2 delete();
        object3 delete();
        object4 delete();
    }
}


trap1()
{
	level endon("trigger");
    trig = getEnt( "trig_trap1", "targetname" );
    object1 = getent("trap1a","targetname");
    object2 = getent("trap1b","targetname");
 
    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 movey(496, 3);
        object2 movey(-496, 3);
        wait(9.9);
        object1 movey(-496, 3);
        object2 movey(496, 3);
        wait(9.9);
    }
}


trap2()
{
	level endon("trigger");
    trig = getEnt( "trig_trap2", "targetname" );
    object1 = getent("trap2","targetname");
 
    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 movey(496, 3);
        wait(9.9);
        object1 movey(-496, 3);
        wait(9.9);
    }
}


trap3()
{
	level endon("trigger");
    trig = getEnt( "trig_trap3", "targetname" );
    object1 = getent("trap3","targetname");
 
    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 movex(272, 3);
        wait(9.9);
        object1 movex(-272, 3);
        wait(9.9);
    }
}


trap4()
{
	level endon("trigger");
    trig = getEnt( "trig_trap4", "targetname" );
    object1 = getent("trap4a","targetname");
    object2 = getent("trap4b","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        object2 movez(72, 3);
        wait(1);
        
    }
}


trap5()
{
	level endon("trigger");
    trig = getEnt( "trig_trap5", "targetname" );
    object1 = getent("trap5a","targetname");
    object2 = getent("trap5b","targetname");
    object3 = getent("trap5c","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        object2 rotateyaw(2880, 25);
        object3 rotateyaw(-2880, 25);
        wait(1);
        
    }
}


trap6()
{
	level endon("trigger");
    trig = getEnt( "trig_trap6", "targetname" );
    object1 = getent("trap6","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        
    }
}


trap7()
{
	level endon("trigger");
    trig = getEnt( "trig_trap7", "targetname" );
    object1 = getent("trap7","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        
    }
}


trap8()
{
	level endon("trigger");
    trig = getEnt( "trig_trap8", "targetname" );
    object1 = getent("trap8","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        
    }
}


trap9()
{
	level endon("trigger");
    trig = getEnt( "trig_trap9", "targetname" );
    object1 = getent("trap9","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        
    }
}


trap10()
{
	level endon("trigger");
    trig = getEnt( "trig_trap10", "targetname" );
    object1 = getent("trap10_a","targetname");
    object2 = getent("trap10_b","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(5.5);
        object2 movey(-880, 5);
        wait(5.5);
        object2 movey(880, 5);
        wait(5.5);
        
    }
}


trap11()
{
	level endon("trigger");
    trig = getEnt( "trig_trap11", "targetname" );
    object1 = getent("trap11","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        
    }
}


trap12()
{
	level endon("trigger");
    trig = getEnt( "trig_trap12", "targetname" );
    object1 = getent("trap12","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        
    }
}


trap13()
{
	level endon("trigger");
    trig = getEnt( "trig_trap13", "targetname" );
    object1 = getent("trap13_a","targetname");
    object2 = getent("trap13_b","targetname");
    object3 = getent("trap13_c","targetname");
    object4 = getent("trap13_d","targetname");
    object5 = getent("trap13_e","targetname");
    object6 = getent("trap13_f","targetname");
    object7 = getent("trap13_g","targetname");
    object8 = getent("trap13_h","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(35);
        object2 delete();
        wait(35);
        object3 delete();
        wait(35);
        object4 delete();
        wait(35);
        object5 delete();
        wait(35);
        object6 delete();
        wait(35);
        object7 delete();
        wait(35);
        object8 delete();
        wait(35);
        
    }
}


trap14()
{
	level endon("trigger");
    trig = getEnt( "trig_trap14", "targetname" );
    object1 = getent("trap14","targetname");
 
    trig waittill ("trigger");
    trig delete();

    {
        object1 delete();
        wait(1);
        
    }
}



teleport()
{
  trig = getEnt( "teleport1", "targetname"); 
  target = getEnt( "teleport1_a", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}



teleport_e()
{
  trig = getEnt( "teleport_easy", "targetname"); 
  target = getEnt( "teleport_easy_1", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
     player thread speedrun\_way_name::change_way("ns0");
      }
}


teleport_t()
{
  trig = getEnt( "teleport_treaning", "targetname"); 
  target = getEnt( "teleport_treaning_1", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
     player thread speedrun\_way_name::change_way("ns1");
      }
}


teleport_h()
{
  trig = getEnt( "teleport_hard", "targetname"); 
  target = getEnt( "teleport_hard_1", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
     player thread speedrun\_way_name::change_way("ns2");
      }
}


treaning_finish()
{
  trig = getEnt( "treaning_finish", "targetname"); 
  target = getEnt( "treaning_finish_1", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
     player thread speedrun\_way_name::finish_way("ns1");
      }
}


hard_finish()
{
  trig = getEnt( "hard_finish", "targetname"); 
  target = getEnt( "hard_finish_1", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
     player thread speedrun\_way_name::finish_way("ns2");
      }
}


pod()
{
  trig = getEnt( "pod", "targetname"); 
  target = getEnt( "pod_1", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


pod2()
{
  trig = getEnt( "pod2", "targetname"); 
  target = getEnt( "pod2_2a", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


pod3()
{
  trig = getEnt( "pod2_a", "targetname"); 
  target = getEnt( "pod2_1a", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player); 
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


printcredits()
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
        self.logoText setText("^5---^3Map made by Mr.Xx^5---");
        wait 3;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 0;
        wait 1;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 1;
        self.logoText setText("^5---^3xfire: dragec1997^5---");
        wait 3;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 0;
        wait 1;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 1;
        self.logoText setText("^5---^3Bounce_v3~Beta~^5---");
        wait 3;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 0;
        wait 1;

	}
}


snip()
{
    level.mus_trig3 = getEnt( "sniproom", "targetname" );
    tele_activator = getEnt( "acti_snip", "targetname" );
    tele_jumper = getEnt( "snip", "targetname" );
               
    level.finalJumper = undefined;
 
    while( 1 )
    {
        level.mus_trig3 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;
 
        level.mus_trig1 delete();
        level.mus_trig2 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
       
        level.finalJumper finalroom2( tele_jumper, "m40a3_mp", 100 );
        level.activ finalroom2( tele_activator, "m40a3_mp", 100 );
       
               
        noti = SpawnStruct();
                                noti.titleText = "Snip Fight";
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
 
 
 
    }
    // code never gets here
}

 
finalroom2( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
   
    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */
}

 
knife()
{
    level.mus_trig2 = getEnt( "kniferoom", "targetname" );
    tele_activator = getEnt( "acti_knife", "targetname" );
    tele_jumper = getEnt( "knife", "targetname" );
               
    level.finalJumper = undefined;
 
    while( 1 )
    {
        level.mus_trig2 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;
 
        level.mus_trig1 delete();
        level.mus_trig3 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
       
        level.finalJumper finalroom1( tele_jumper, "knife_mp", 100 );
        level.activ finalroom1( tele_activator, "knife_mp", 100 );
       
               
        noti = SpawnStruct();
                                noti.titleText = "Knife Fight";
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
 
 
 
    }
    // code never gets here
}

 
jump()
{
    level.mus_trig2 = getEnt( "jumproom", "targetname" );
    tele_activator = getEnt( "acti_jump", "targetname" );
    tele_jumper = getEnt( "jump", "targetname" );
               
    level.finalJumper = undefined;
 
    while( 1 )
    {
        level.mus_trig2 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;
 
        level.mus_trig1 delete();
        level.mus_trig3 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
       
        level.finalJumper finalroom1( tele_jumper, "knife_mp", 100 );
        level.activ finalroom1( tele_activator, "knife_mp", 100 );
       
               
        noti = SpawnStruct();
                                noti.titleText = "jump Fight";
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
 
 
 
    }
    // code never gets here
}


pistol()
{
    level.mus_trig2 = getEnt( "pistolroom", "targetname" );
    tele_activator = getEnt( "acti_pistol", "targetname" );
    tele_jumper = getEnt( "pistol", "targetname" );
               
    level.finalJumper = undefined;
 
    while( 1 )
    {
        level.mus_trig2 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;
 
        level.mus_trig1 delete();
        level.mus_trig3 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
       
        level.finalJumper finalroom1( tele_jumper, "deserteagle_mp", 100 );
        level.activ finalroom1( tele_activator, "deserteagle_mp", 100 );
       
               
        noti = SpawnStruct();
                                noti.titleText = "Pistol Fight";
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
 
 
 
    }
    // code never gets here
}

 
RPD()
{
    level.mus_trig1 = getEnt( "rpdroom", "targetname" );
    tele_activator = getEnt( "acti_shotgun", "targetname" );
    tele_jumper = getEnt( "shotgun", "targetname" );
               
    level.finalJumper = undefined;
 
    while( 1 )
    {
        level.mus_trig1 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;
 
        level.mus_trig2 delete();
        level.mus_trig3 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
       
        level.finalJumper finalroom( tele_jumper, "rpd_mp", 100 );
        level.activ finalroom( tele_activator, "rpd_mp", 100 );
       
               
        noti = SpawnStruct();
                                noti.titleText = "FIGHT";
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

 
finalroom( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );  
}

 
finalroom1( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
   
    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */
}

 
monitorDisconnect()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}
