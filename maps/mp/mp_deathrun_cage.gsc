/*
    A WILD BLADE SCRIPT PRO APPEARED XD
*/
main()
{
thread sr\api\_map::createSpawn((13, -1, -20), 360);
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    //ambientPlay("mapsong");
    thread sr\api\_speedrun::createNormalWays("Normal Way");
        thread sr\api\_speedrun::createTeleporter((-171.481, -2849.31, 542.125), 35, 105, (-252, -1436, 964), 360, "freeze");  
    thread sr\api\_speedrun::createTeleporter((871.995, -727.389, 902.125), 95, 110, (483, -775, 1468), 90, "freeze");    
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread trap6();
    //thread trap7();
    //thread trap8();
    //thread trap9();
    //thread bridge();
    //thread automove1();
    //thread automove2();
    //thread automove4();
    //thread automove5();
    //thread lift2();
    //thread printcredits();
    //thread old();
    //thread snip();
    //thread knife();
    //thread pistol();
	
	// FX
	level.explosion = LoadFX ( "explosions/tanker_explosion" );
}

trap1()
{
    trig = getEnt( "trig_trap1", "targetname" );
    object1 = getent("trap1a","targetname");
    object2 = getent("trap1b","targetname");
    object3 = getent("trap1c","targetname");
 
    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 movey(112, 5);
        object2 movey(-112, 5);
        object3 movey(112, 5);
        wait(5.5);
        object1 movey(-112, 5);
        object2 movey(112, 5);
        object3 movey(-112, 5);
        wait(5.5);
    }
}

trap2()
{
    trig = getEnt( "trig_trap2", "targetname" );
    trap2 = getEnt( "trap2", "targetname" );
    killtrigger = getent ("trap2_hurt" , "targetname");

    trig waittill ("trigger");
    trig delete();

    killtrigger enablelinkto ();
    killtrigger linkto (trap2);
 
    while( 1 )
    {
        trap2 movex(-112, 5);
        wait 5;
        trap2 movex(112, 5);
        wait 5;
    }
}

trap3()
{
    trig = getEnt( "trig_trap3", "targetname" );
    object1 = getent("trap3a","targetname");
    object2 = getent("trap3b","targetname");
    object4 = getent("trap3d","targetname");
    object5 = getent("trap3e","targetname");

    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 rotatepitch(900, 5);
        object2 rotatepitch(900, 5);
        object4 rotatepitch(900, 5);
        object5 rotatepitch(900, 5);
        wait(9);
        object1 rotatepitch(-900, 5);
        object2 rotatepitch(-900, 5);
        object4 rotatepitch(-900, 5);
        object5 rotatepitch(-900, 5);
        wait(9);
    }
}

trap4()
{
    trig = getEnt( "trig_trap4", "targetname" );
    trap4 = getEnt( "trap4", "targetname" );
    killtrigger = getent ("trap4_hurt" , "targetname");

    trig waittill ("trigger");
    trig delete();

    killtrigger enablelinkto ();
    killtrigger linkto (trap4);
 
    while( 1 )
    {
        trap4 movez(45, 5);
        wait 5;
        trap4 movez(-45, 5);
        wait 5;
    }
}

trap5()
{
    trig = getEnt( "trig_trap5", "targetname" );
    object1 = getent("trap5a","targetname");
    object2 = getent("trap5b","targetname");
    object3 = getent("trap5c","targetname");
    object4 = getent("trap5d","targetname");
    object5 = getent("trap5e","targetname");
    object6 = getent("trap5f","targetname");
    object7 = getent("trap5g","targetname");
    object8 = getent("trap5h","targetname");
    object9 = getent("trap5i","targetname");

    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 rotatepitch(900, 1);
        wait(1);
        object2 rotatepitch(-900, 1);
        wait(1);
        object3 rotatepitch(900, 1);
        wait(1);
        object4 rotatepitch(-900, 1);
        wait(1);
        object5 rotatepitch(900, 1);
        wait(1);
        object6 rotatepitch(-900, 1);
        wait(1);
        object7 rotatepitch(900, 1);
        wait(1);
        object8 rotatepitch(-900, 1);
        wait(1);
        object9 rotatepitch(900, 1);
        wait(1);
        object1 rotatepitch(-900, 1);
        wait(1);
        object2 rotatepitch(900, 1);
        wait(1);
        object3 rotatepitch(-900, 1);
        wait(1);
        object4 rotatepitch(900, 1);
        wait(1);
        object5 rotatepitch(-900, 1);
        wait(1);
        object6 rotatepitch(900, 1);
        wait(1);
        object7 rotatepitch(-900, 1);
        wait(1);
        object8 rotatepitch(900, 1);
        wait(1);
        object9 rotatepitch(-900, 1);
        wait(1);
    }
}

trap6()
{
    trig = getEnt( "trig_trap6", "targetname" );
    object1 = getent("trap6a","targetname");
    object2 = getent("trap6b","targetname");
    object3 = getent("trap6c","targetname");
    object4 = getent("trap6d","targetname");
    object5 = getent("trap6e","targetname");
    object6 = getent("trap6f","targetname");
 
    trig waittill ("trigger");
    trig delete();

    while(1)
    {
        object1 rotateroll(720, 5);
        object2 rotateroll(-720, 5);
        object3 rotateroll(720, 5);
        object4 rotateroll(-720, 5);
        object5 rotateroll(720, 5);
        object6 movey(-192, 5);
        wait(1);
        object1 rotateroll(-720, 5);
        object2 rotateroll(720, 5);
        object3 rotateroll(-720, 5);
        object4 rotateroll(720, 5);
        object5 rotateroll(-720, 5);
        object6 movey(192, 5);
        wait(1);
    }
}

trap7()
{
    trig = getEnt( "trig_trap7", "targetname" );
    object1 = getent("trap7a","targetname");
    object2 = getent("trap7b","targetname");
    object3 = getent("trap7c","targetname");
    object4 = getent("trap7d","targetname");
    object5 = getent("trap7e","targetname");
    object6 = getent("trap7f","targetname");
    object7 = getent("trap7g","targetname");
    object8 = getent("trap7h","targetname");

    trig waittill ("trigger");
    trig delete();

    while(1)
    {
        object8 movez(-184, 1);
        wait(1);
        object8 rotatepitch(900, 1);
        wait(1);
        object7 movez(-184, 1);
        wait(1);
        object7 rotatepitch(900, 1);
        wait(1);
        object6 movez(-184, 1);
        wait(1);
        object6 rotatepitch(900, 1);
        wait(1);
        object5 movez(-184, 1);
        wait(1);
        object5 rotatepitch(900, 1);
        wait(1);
        object4 movez(-184, 1);
        wait(1);
        object4 rotatepitch(900, 1);
        wait(1);
        object3 movez(-184, 1);
        wait(1);
        object3 rotatepitch(900, 1);
        wait(1);
        object2 movez(-184, 1);
        wait(1);
        object2 rotatepitch(900, 1);
        wait(1);
        object1 movez(-184, 1);
        wait(1);
        object1 rotatepitch(900, 1);
        wait(1);
        object1 movez(184, 1);
        wait(1);
        object1 rotatepitch(900, 1);
        wait(1);
        object2 movez(184, 1);
        wait(1);
        object2 rotatepitch(900, 1);
        wait(1);
        object3 movez(184, 1);
        wait(1);
        object3 rotatepitch(900, 1);
        wait(1);
        object4 movez(184, 1);
        wait(1);
        object4 rotatepitch(900, 1);
        wait(1);
        object5 movez(184, 1);
        wait(1);
        object5 rotatepitch(900, 1);
        wait(1);
        object6 movez(184, 1);
        wait(1);
        object6 rotatepitch(900, 1);
        wait(1);
        object7 movez(184, 1);
        wait(1);
        object7 rotatepitch(900, 1);
        wait(1);
        object8 movez(184, 1);
        wait(1);
        object8 rotatepitch(900, 1);
        wait(1);
        object1 movez(184, 1);
        wait(1);
        object1 rotatepitch(900, 1);
        wait(1);
        object2 movez(184, 1);
        wait(1);
        object2 rotatepitch(900, 1);
        wait(1);
        object3 movez(184, 1);
        wait(1);
        object3 rotatepitch(900, 1);
        wait(1);
        object4 movez(184, 1);
        wait(1);
        object4 rotatepitch(900, 1);
        wait(1);
        object5 movez(184, 1);
        wait(1);
        object5 rotatepitch(900, 1);
        wait(1);
        object6 movez(184, 1);
        wait(1);
        object6 rotatepitch(900, 1);
        wait(1);
        object7 movez(184, 1);
        wait(1);
        object7 rotatepitch(900, 1);
        wait(1);
        object8 movez(184, 1);
        wait(1);
        object8 rotatepitch(900, 1);
        wait(1);
        object8 movez(-184, 1);
        wait(1);
        object8 rotatepitch(900, 1);
        wait(1);
        object7 movez(-184, 1);
        wait(1);
        object7 rotatepitch(900, 1);
        wait(1);
        object6 movez(-184, 1);
        wait(1);
        object6 rotatepitch(900, 1);
        wait(1);
        object5 movez(-184, 1);
        wait(1);
        object5 rotatepitch(900, 1);
        wait(1);
        object4 movez(-184, 1);
        wait(1);
        object4 rotatepitch(900, 1);
        wait(1);
        object3 movez(-184, 1);
        wait(1);
        object3 rotatepitch(900, 1);
        wait(1);
        object2 movez(-184, 1);
        wait(1);
        object2 rotatepitch(900, 1);
        wait(1);
        object1 movez(-184, 1);
        wait(1);
        object1 rotatepitch(900, 1);
        wait(1);
    }
}

trap8()
{
    trig = getEnt( "trig_trap8", "targetname" );
    object1 = getent("trap8a","targetname");
    object2 = getent("trap8b","targetname");
    object3 = getent("trap8c","targetname");
    object4 = getent("trap8d","targetname");
    object5 = getent("trap8e","targetname");
    object6 = getent("trap8f","targetname");
    object7 = getent("trap8g","targetname");
    object8 = getent("trap8h","targetname");

    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 rotateroll(900, 5);
        wait(1);
        object2 rotateroll(900, 5);
        wait(1);
        object3 rotateroll(900, 5);
        wait(1);
        object4 rotateroll(900, 5);
        wait(1);
        object5 rotateroll(900, 5);
        wait(1);
        object6 rotateroll(900, 5);
        wait(1);
        object7 rotateroll(900, 5);
        wait(1);
        object8 rotateroll(900, 5);
        wait(7);
        object1 rotateroll(-900, 5);
        wait(1);
        object2 rotateroll(-900, 5);
        wait(1);
        object3 rotateroll(-900, 5);
        wait(1);
        object4 rotateroll(-900, 5);
        wait(1);
        object5 rotateroll(-900, 5);
        wait(1);
        object6 rotateroll(-900, 5);
        wait(1);
        object7 rotateroll(-900, 5);
        wait(1);
        object8 rotateroll(-900, 5);
        wait(7);
    }
}

trap9()
{
    trig = getEnt( "trig_trap9", "targetname" );
    object1 = getent("trap9","targetname");
 
    trig waittill ("trigger");
    trig delete();

    object1 movez(700, 5);
}

trap10()
{
    trig = getEnt( "trig_trap10", "targetname" );
    trap10 = getEnt( "trap10", "targetname" );
    killtrigger = getent ("trap10_hurt" , "targetname");
    killtrigger2 = getent ("trap10a_hurt" , "targetname");

    trig waittill ("trigger");
    trig delete();

    killtrigger enablelinkto ();
    killtrigger2 enablelinkto (); 

    killtrigger linkto (trap10);
    killtrigger2 linkto (trap10);
 
    while( 1 )
    {
        trap10 movez(304, 5);
        wait(8);
        trap10 movez(-304, 5);
        wait(8);
    }
}

bridge()
{
    trig = getEnt( "trap_bridge", "targetname" );
    object1 = getent("bridge","targetname");
    object2 = getent("heli_bridge","targetname");
 
    trig waittill ("trigger");
    trig delete();

    object1 movez(700, 5);
    object2 movez(700, 5);
}

automove1()
{
    object1 = getent("automove1a","targetname");

    while(1)
    {
        object1 movey(1088, 5);
        wait(7);
        object1 movey(-1088, 5);
        wait(7);
    }
}

automove2()
{
    object1 = getent("automove1b","targetname");

    while(1)
    {
        object1 movez(360, 5);
        wait(7);
        object1 movez(-360, 5);
        wait(7);
    }
}

automove3()
{
    object1 = getent("automove3","targetname");

    while(1)
    {
        object1 movez(504, 5);
        wait(5);
        object1 movey(830, 5);
        wait(5);
        object1 movex(-192, 5);
        wait(5);
        object1 movez(-504, 5);
        wait(5);
        object1 movey(-830, 5);
        wait(5);
        object1 movex(192, 5);
        wait(5);
    }
}

automove4()
{
    trap11 = getEnt( "automove4", "targetname" );
    killtrigger = getent ("trap11_hurt" , "targetname");

    killtrigger enablelinkto ();
    killtrigger linkto (trap11);

    while( 1 )
    {
        trap11 movez(-40, 5);
        wait(1);
        trap11 movez(40, 5);
        wait(1);
    }
}

automove5()
{
    object1 = getent("shit1a","targetname");
    object2 = getent("shit1b","targetname");

    while(1)
    {
        object1 rotateyaw(720, 5);
        object2 rotateyaw(720, 5);
        wait(5);
        object1 rotateyaw(-720, 5);
        object2 rotateyaw(-720, 5);
        wait(5);
    }
}

automove6()
{
    trap12a = getEnt( "glupost1a", "targetname" );

    while( 1 )
    {
        trap12a rotateroll(-720, 5);
        trap12a movex(200, 5);
        wait(5);
        trap12a rotateroll(720, 5);
        trap12a movex(-200, 5);
        wait(5);
    }
}

automove7()
{
    trap13 = getEnt( "glupost1b", "targetname" );
    killtrigger = getent ("glupost1c" , "targetname");

    killtrigger enablelinkto ();
    killtrigger linkto (trap13);
 
    while( 1 )
    {
        trap13 movey(-176, 5);
        wait(1);
        trap13 movey(176, 5);
        wait(1);
    }
}

trap2x12()
{
	trig = getEnt("trap_bridgeg", "targetnamet");
	brush = getEnt("bridge", "targetname");
	fx = getEnt("trap_shit_fx", "targetname");
	
	trig setHintString("Press USE to activate");
	trig waittill("trigger");
	trig delete();
	
	playFx ( level.explosion, fx.origin );
	wait 0.1;
	earthquake ( 1, 1, fx.origin, 500 );
	wait 0.1;
	brush delete();	
}

lift1()
{
    trig = getEnt( "acti_lift", "targetname" );
    object1 = getent("lift","targetname");
    object2 = getent("lift_vrata1","targetname");
    object3 = getent("lift_vrata2","targetname");
    object4 = getent("lift_vrata3","targetname");
    object5 = getent("lift_vrata4","targetname");
    object6 = getent("lift_vrata5","targetname");
    object7 = getent("lift_vrata6","targetname");

    trig waittill ("trigger");
    trig delete();

    {
        object2 movey(-56, 5);
        object3 movey(56, 5);
        object4 movey(-56, 5);
        object5 movey(56, 5);
        wait 7;
        object2 movey(56, 5);
        object3 movey(-56, 5);
        object4 movey(56, 5);
        object5 movey(-56, 5);
        wait 7;
        object1 movez(384, 5);
        object2 movez(384, 5);
        object3 movez(384, 5);
        wait 1;
        object1 movex(-192, 5);
        object2 movex(-192, 5);
        object3 movex(-192, 5);
        wait 1;
        object1 movey(2016, 5);
        object2 movey(2016, 5);
        object3 movey(2016, 5);
        wait 9;
        object6 movey(56, 5);
        object7 movey(-56, 5);
        wait 1;
    }
}

lift2()
{
    trig = getEnt( "jumper_lift", "targetname" );
    object1 = getent("jumper_podizac","targetname");
    object2 = getent("jumper_vrata1","targetname");
    object3 = getent("jumper_vrata2","targetname");
    object4 = getent("jumper_vrata3","targetname");
    object5 = getent("jumper_vrata4","targetname");
         
    trig waittill ("trigger");

    {
        object2 movey(-48, 5);
        object3 movey(48, 5);
        object4 movey(48, 5);
        object5 movey(-48, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
        object1 movez(496, 5);
        wait(7);
        object1 movez(-496, 5);
        wait(7);
    }
}

heli1()
{
    heli = getent("heli","targetname");

    {	
        wait 5;
	    heli movex(10000,25);	
	    wait 25;
	    heli rotatepitch(-15,1);
        wait 1;
	    heli rotateyaw(180,2.5);
        wait 5;
        heli rotatepitch(15,1);
	    heli movex(-15000,30);	
	    wait 25;
	    heli delete();
    }
}

heli2()
{
    heli = getent("heli2","targetname");

    {	
        wait 5;
	    heli movex(10000,25);	
	    wait 25;
	    heli rotatepitch(-15,1);
        wait 1;
	    heli rotateyaw(180,2.5);
        wait 5;
        heli rotatepitch(15,1);
	    heli movex(-15000,30);	
	    wait 25;
	    heli delete();
    }
}

heli3()
{
    heli = getent("heli3","targetname");

    {	
        wait 5;
	    heli movex(10000,25);	
	    wait 25;
	    heli rotatepitch(-15,1);
        wait 1;
	    heli rotateyaw(180,2.5);
        wait 5;
        heli rotatepitch(15,1);
	    heli movex(-15000,30);	
	    wait 25;
	    heli delete();
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
        self.logoText setText("^5---^3Cage -=(Beta)=-^5---");
        wait 3;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 0;
        wait 1;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 1;
        self.logoText setText("^5---^3Additional Help : Madlion,VC'BLADE^5---");
        wait 3;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 0;
        wait 1;
        self.logoText fadeOverTime(1);
        self.logoText.alpha = 1;
        self.logoText setText("^5---^3xfire:MadLion^5(^3madlion3^5)^3,VC'BLADE^5(^3bladetk17^5)^5---");
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
    tele_jumper = getEnt( "kreten", "targetname" );
               
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
    self GiveWeapon( weap );
    self GiveMaxAmmo( weap );
    self SwitchToWeapon( weap );
}
 
knife()
{
    level.mus_trig2 = getEnt( "kniferoom", "targetname" );
    tele_activator = getEnt( "actiknife", "targetname" );
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
 
pistol()
{
    level.mus_trig2 = getEnt( "pistolroom", "targetname" );
    tele_activator = getEnt( "actipistol", "targetname" );
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
 
old()
{
    level.mus_trig1 = getEnt( "oldroom", "targetname" );
    tele_activator = getEnt( "acti_old", "targetname" );
    tele_jumper = getEnt( "old", "targetname" );
               
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
       
        level.finalJumper finalroom( tele_jumper, "knife_mp", 100 );
        level.activ finalroom( tele_activator, "knife_mp", 100 );
       
               
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
    self GiveWeapon( weap );
    self GiveMaxAmmo( weap );
    self SwitchToWeapon( weap );
}
 
monitorDisconnect()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}