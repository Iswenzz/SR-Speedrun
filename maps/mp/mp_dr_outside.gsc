main()
{
    maps\mp\_load::main();
	
    	thread speedrun\_way_name::create_normal_way("Normal Way;");
    thread speedrun\_way_name::create_secret_way("Secret Way;");
    thread speedrun\_way_name::create_spawn((69,-18,76),91);
    thread speedrun\_way_name::create_tp((303.32, 215.723, 16.125), 65, 80, (-539, 9578, 833), 270, "freeze", "blue", "s0");
    thread speedrun\_way_name::create_endmap((116.598, 7702.53, 65.1656), 215, 185, "s0");
    thread speedrun\_way_name::create_endmap((-3719.03, 15167.9, 13.125), 125, 95, "ns0");

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";   

    addTriggerToList( "trig_trap1" );
    addTriggerToList( "trig_trap2" );
    addTriggerToList( "trig_trap3" );
    addTriggerToList( "trig_trap4" );
    addTriggerToList( "trig_trap5" );
    addTriggerToList( "trig_trap6" );
    addTriggerToList( "trig_trap7" );
    addTriggerToList( "trig_trap8" );
    addTriggerToList( "trig_trap9" );
    addTriggerToList( "trig_trap10" );
    addTriggerToList( "trig_trap11" );
	addTriggerToList( "trig_trap12" );
    addTriggerToList( "trig_trap13" );
    addTriggerToList( "trig_trap14" );
	addTriggerToList( "trig_trap15" );
	addTriggerToList( "trig_trap16" );
	addTriggerToList( "trig_trap17" );
	addTriggerToList( "trig_trap18" );

	thread startdoor();
	thread startdoor2();
	thread startdoor3();
	//thread sixzor();
	//thread vrata();
	//thread vrata2();
	//thread vrtuljak();
	//thread vrtuljak2();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread lift();
	//thread lift2();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread lift3();
	//thread trap8();
	//thread trap9();
	///thread trap10();
	//thread lift4();
	///thread trap11();
	//thread trap12();
	//thread trap13();
	//thread trap14();
	///thread trap15();
	//thread trap16();
	//thread trap17();
	//thread trap18();
	//thread printcredits();
	//thread creator();
	//thread snip();
	//thread knife();
	//thread jump();
	//thread deagle();

}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

startdoor()
{
	door=getent("startdoor","targetname");
	door movez(-250,5);
    door delete();
}

startdoor2()
{
	door=getent("startdoor2","targetname");
	door movez(-260,5);
	door delete();
}

startdoor3()
{
	door=getent("startdoor3","targetname");
	door movez(-400,5);
	//thread randomodabir();
	door delete();
}

sixzor()
{
	object1 = getent("sixzor","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 5);
		wait 5;
    }
}

okretanje1()
{
	object1 = getent("okretanje1","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 2);
		wait 2;
    }
}

okretanje2()
{
	object1 = getent("okretanje2","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 2);
		wait 2;
    }
}

okretanje3()
{
	object1 = getent("okretanje3","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 2);
		wait 2;
    }
}

okretanje4()
{
	object1 = getent("okretanje4","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 2);
		wait 2;
    }
}

vrata()
{
	object1 = getent("vrata","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 5);
		wait 5;
    }
}

vrata2()
{
	object1 = getent("vrata2","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 5);
		wait 5;
    }
}

vrtuljak()
{
	object1 = getent("vrtuljak","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 2);
		wait 2;
    }
}

vrtuljak2()
{
	object1 = getent("vrtuljak2","targetname");
       
     while(1)
    {
	    object1 rotateYaw(360, 2);
		wait 2;
    }
}

randomodabir()
{
        x = randomIntRange( 1, 4 );
       
        if( x == 1 )
        {
        // ambientplay("ambient5");
        }
        else if( x == 2 )
        {
       // ambientplay("ambient7");
        }
        else if( x == 3 )
        {
        // ambientplay("ambient8");
        }
}

trap1()
{
    trig = getEnt( "trig_trap1", "targetname" );
	object1 = getent("trap1a","targetname");
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 2);
		wait 2;
		object1 rotateYaw(360,2);
		wait 2;
    }
}

trap2()
{
    trig = getEnt( "trig_trap2", "targetname" );
    object1 = getent("trap2a","targetname");
	object2 = getent("trap2b","targetname");
	object3 = getent("trap2c","targetname");
    trig waittill ("trigger");
       
     while(1)
    {
		object1 rotateYaw(180, 1);
		wait 1;
		object2 rotateYaw(180, 1);
		wait 1;
		object3 rotateYaw(180, 1);
		wait 1;
    }
}

trap3()
{
    trig = getEnt( "trig_trap3", "targetname" );
    object1 = getEnt( "trap3a", "targetname" );

    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
		object1 movez(-120, 2);
        wait 2;
		object1 movez(120, 2);
        wait 2;
		object1 movez(-120, 2);
        wait 2;
		object1 movez(120, 2);
		wait 2;
		object1 movez(-120, 2);
        wait 2;
		object1 movez(120, 2);
        wait 2;
		object1 movez(-120, 2);
        wait 2;
		object1 movez(120, 2);
		wait 2;
    }
}

lift()
{

object1 = getent("lift","targetname");

while(1)
{
object1 movey(494, 2);
object1 waittill("movedone");
wait(2);
object1 movey(-494, 2);
object1 waittill("movedone");
wait(2);
}
}

lift2()
{
object1 = getent("lift2","targetname");

while(1)
{
object1 movex(783, 2);
object1 waittill("movedone");
wait(2);
object1 movex(-783, 2);
object1 waittill("movedone");
wait(2);
}
}

trap4()
{
    trig = getEnt( "trig_trap4", "targetname" );
    object1 = getent("trap4a","targetname");
	object2 = getent("trap4b","targetname");
	object3 = getent("trap4c","targetname");
 
    trig waittill ("trigger");
    trig delete();
	
    while(1) 
    {
        object1 rotateroll(360, 2);
		wait 2;
		object2 rotateroll(360, 2);
		wait 2;
		object3 rotateroll(360, 2);
		wait 2;
		object1 rotateroll(360, 2);
		wait 2;
		object2 rotateroll(360, 2);
		wait 2;
		object3 rotateroll(360, 2);
		wait 2;
    }
}

trap5()
{
    trig = getEnt( "trig_trap5", "targetname" );
    object1 = getEnt( "trap5a", "targetname" );
	object2 = getEnt( "trap5b", "targetname" );

    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 movez(47, 0.5);
		object2 movez(-47, 0.5);
		wait 1;
		object1 movez(-47, 0.5);
		object2 movez(47, 0.5);
		wait 1;
    }
}

trap6()
{
    trig = getEnt( "trig_trap6", "targetname" );
    object1 = getent("trap6","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateYaw(360, 5);
		wait 5;
    }
}

trap7()
{
    trig = getEnt( "trig_trap7", "targetname" );
    object1 = getent("trap7a","targetname");
	object2 = getent("trap7b","targetname");
	object3 = getent("trap7c","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateYaw(360, 1);
		wait 1;
		object2 rotateYaw(360, 1);
		wait 1;
		object3 rotateYaw(360, 1);
		wait 1;
    }
}

lift3()
{
object1 = getent("lift3","targetname");
trigger = getent("lift3_trigger","targetname"); 
trigger waittill ("trigger", player );
trigger delete();
while(1)
{
object1 movey(520, 2);
object1 waittill("movedone");
wait(2);
object1 movey(-520, 2);
object1 waittill("movedone");
wait(2);
}
}

trap8()
{
    trig = getEnt( "trig_trap8", "targetname" );
	object1 = getent("trap8","targetname");
	
    trig waittill ("trigger");
	trig delete();
       
     while(1)
    {
	    object1 rotateYaw(360, 0.5);
		wait 2;
		object1 rotateYaw(360, 0.5);
		wait 2;
		object1 rotateYaw(360, 0.5);
		wait 2;
		object1 rotateYaw(360, 0.5);
		wait 2;
    }
}

trap9()
{
    trig = getEnt( "trig_trap9", "targetname" );
	object1 = getent("trap9","targetname");

	
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 0.5);
		wait 2;
    }
}

trap10()
{
    trig = getEnt( "trig_trap10", "targetname" );
    object1 = getent("trap10","targetname");
 
    trig waittill ("trigger");
    trig delete();
       
     while(1)
    {
        object1 movez(86, 2);
		wait 2;
		object1 movez(-86, 2);
		wait 2;
		object1 movez(86, 2);
		wait 2;
		object1 movez(-86, 2);
		wait 2;
    }
}

lift4()
{
object1 = getent("lift4","targetname");
trigger = getent("lift4_trigger","targetname"); 
trigger waittill ("trigger", player );
trigger delete();
while(1)
{
object1 movey(647, 2);
object1 waittill("movedone");
wait(2);
object1 movey(-647, 2);
object1 waittill("movedone");
wait(2);
}
}

trap11()
{
    trig = getEnt( "trig_trap11", "targetname" );
	object1 = getent("trap11","targetname");
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 5);
		wait 5;
    }
}

trap12()
{
    trig = getEnt( "trig_trap12", "targetname" );
    object1 = getEnt( "trap12", "targetname" );

    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 movez(-197, 2);
		wait 10;
		object1 movez(197, 2);
		wait 10;
		object1 movez(-197, 2);
		wait 10;
		object1 movez(197, 2);
		wait 10;
    }
}

trap13()
{
    trig = getEnt( "trig_trap13", "targetname" );
    object1 = getent("trap13","targetname");
 
    trig waittill ("trigger");
    trig delete();
	
    while(1) 
    {
		object1 rotateYaw(360, 5);
		wait 5;
    }
}

trap14()
{
    trig = getEnt( "trig_trap14", "targetname" );
	object1 = getent("trap14","targetname");
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 5);
		wait 5;
    }
}

trap15()
{
    trig = getEnt( "trig_trap15", "targetname" );
    object1 = getEnt( "trap15", "targetname" );

    trig waittill ("trigger");
    trig delete();
 
    while(1)
    {
        object1 movez(-116, 0.5);
		wait 2;
		object1 movez(116, 0.5);
		wait 2;
		object1 movez(-116, 0.5);
		wait 2;
		object1 movez(116, 0.5);
		wait 2;
    }
}

trap16()
{
    trig = getEnt( "trig_trap16", "targetname" );
	object1 = getent("trap16","targetname");
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 0.5);
		wait 2;
		object1 rotateYaw(360, 0.5);
		wait 2;
		object1 rotateYaw(360, 0.5);
		wait 2;
		object1 rotateYaw(360, 0.5);
		wait 2;
    }
}

trap17()
{
    trig = getEnt( "trig_trap17", "targetname" );
	object1 = getent("trap17","targetname");

	
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 0.5);
		wait 2;
      }
}

trap18()
{
    trig = getEnt( "trig_trap18", "targetname" );
	object1 = getent("trap18","targetname");

	
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 5);
		wait 5;
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
                    self.logoText setText("^2--->^7Map Created ^1'sixzoRR- ^7xFire:^1dinac777^2<---");
                    wait 10;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 5;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^2--->^1MP^7_^1DR^7_^1OUTSIDE^2<---");
                    wait 10;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 5;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^2--->^7Special Thanks ^1MadLion ^7xFire:^1madlion3 ^7And ^1Matty ^7xFire:^1teebag038^2<---");
                    wait 10;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 5;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^2--->^7Any bugs xFire:^1dinac777^2<---");
                    wait 10;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 5;

		}
	
	}
	
creator()
{
wait(5);
thread braxi\_mod::drawInformation( 800, 0.8, 1, "^2--->^1MP^7_^1DR^7_^1OUTSIDE^2<---" );
while( 1 )
{
iPrintLn("^2--->^7Map Created ^1'sixzoRR- ^7xFire:^1dinac777^2<---");
wait(10);
iPrintLn("^2--->^1MP^7_^1DR^7_^1OUTSIDE^2<---");
wait(10);
iPrintLn("^2--->^7Special Thanks ^1MadLion ^7xFire:^1madlion3 ^7And ^1Matty ^7xFire:^1teebag038^2<---");
}
}

snip()
{
    level.mus_trig3 = getEnt( "sniproom", "targetname" );
    tele_jumper = getEnt( "snip", "targetname" );
	tele_activator = getEnt( "acti_snip", "targetname" );
               
    level.finalJumper = undefined;
 
    while( 1 )
    {
        level.mus_trig3 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;
		
		//AmbientPlay( "ambient2" );
 
        level.mus_trig1 delete();
        level.mus_trig2 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
		
		level.finalJumper finalroom2( tele_jumper, "remington700_mp", 100 );
        level.activ finalroom2( tele_activator, "remington700_mp", 100 );
       
        level.finalJumper TakeAllWeapons();
        level.finalJumper GiveWeapon( "m40a3_mp" );
        level.finalJumper giveMaxAmmo( "m40a3_mp" );
		level.finalJumper GiveWeapon( "remington700_mp" );
        level.finalJumper giveMaxAmmo( "remington700_mp" );
        level.finalJumper SwitchToWeapon( "m40a3_mp" );
        wait 0.05;
		
		level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );
        level.activ giveMaxAmmo( "m40a3_mp" );
		level.activ GiveWeapon( "remington700_mp" );
        level.activ giveMaxAmmo( "remington700_mp" );
        level.activ SwitchToWeapon( "m40a3_mp" );

		
        noti = SpawnStruct();
                                noti.titleText = "^1--->^7Snip Room^1<---";
                                noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
                                noti.glowcolor = (0,0.9,0.7);
                                noti.duration = 4;
                                players = getentarray("player", "classname");
                                for(i=0;i<players.size;i++)
                                        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
 
    iPrintlnBold( " ^1" + player.name + "^7 Has Chosen ^1Sniper Room^2!!" );  
    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
	        player iPrintlnBold( "^1---^7>^23^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^23^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^22^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^22^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^21^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^21^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^2Fight!^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^2Fight!^7<^1---" );
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
    self SwitchToWeapon( weap );
 
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
		
		//AmbientPlay( "ambient1" );
 
        level.mus_trig1 delete();
        level.mus_trig3 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
       
        level.finalJumper finalroom1( tele_jumper, "knife_mp", 100 );
        level.activ finalroom1( tele_activator, "knife_mp", 100 );
       
               
        noti = SpawnStruct();
                                noti.titleText = "^1--->^7Knife Room^1<---";
                                noti.notifyText = level.activ.name + " ^1VS^0 " + player.name;
                                noti.glowcolor = (0,0.9,0.7);
                                noti.duration = 4;
                                players = getentarray("player", "classname");
                                for(i=0;i<players.size;i++)
                                        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
    
    iPrintlnBold( " ^1" + player.name + "^7 Has Chosen ^1Knife Room^2!!" ); 	
    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
	        player iPrintlnBold( "^1---^7>^23^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^23^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^22^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^22^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^21^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^21^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^2Fight!^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^2Fight!^7<^1---" );
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);
 
 
 
    }
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

jump()
{
    level.mus_trig3 = getEnt( "jumproom", "targetname" );
    tele_jumper = getEnt( "jump", "targetname" );
	tele_activator = getEnt( "acti_jump", "targetname" );
               
    level.finalJumper = undefined;
 
    while( 1 )
    {
        level.mus_trig3 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;
		
		//AmbientPlay( "ambient6" );
 
        level.mus_trig1 delete();
        level.mus_trig2 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
       
        level.finalJumper finalroom2( tele_jumper, "knife_mp", 100 );
        level.activ finalroom2( tele_activator, "knife_mp", 100 );
       
               
        noti = SpawnStruct();
                                noti.titleText = "^1--->^7Jump Room^1<---";
                                noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
                                noti.glowcolor = (0,0.9,0.7);
                                noti.duration = 4;
                                players = getentarray("player", "classname");
                                for(i=0;i<players.size;i++)
                                        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
 
    iPrintlnBold( " ^1" + player.name + "^7 Has Chosen ^1Jump Room^2!!" );  
    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
            player iPrintlnBold( "^1---^7>^23^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^23^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^22^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^22^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^21^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^21^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^2Fight!^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^2Fight!^7<^1---" );
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);
 
 
 
    }
    // code never gets here
}
 
finalroom5( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
   
    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    self GiveWeapon( weap );
    self GiveMaxAmmo( weap );
    self SwitchToWeapon( weap );
 
}

deagle()
{
    level.mus_trig3 = getEnt( "deagleroom", "targetname" );
    tele_jumper = getEnt( "deagle", "targetname" );
	tele_activator = getEnt( "acti_deagle", "targetname" );
               
    level.finalJumper = undefined;
 
    while( 1 )
    {
        level.mus_trig3 waittill( "trigger", player );
   
        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;
		
		//AmbientPlay( "ambient4" );
 
        level.mus_trig1 delete();
        level.mus_trig2 delete();
 
        level.finalJumper = player;
        level.finalJumper thread finalMonitor();
       
        level.finalJumper finalroom2( tele_jumper, "deserteagle_mp", 100 );
        level.activ finalroom2( tele_activator, "deserteagle_mp", 100 );
       
               
        noti = SpawnStruct();
                                noti.titleText = "^1--->^7Deagle Room^1<---";
                                noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
                                noti.glowcolor = (0,0.9,0.7);
                                noti.duration = 4;
                                players = getentarray("player", "classname");
                                for(i=0;i<players.size;i++)
                                        players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

	iPrintlnBold( " ^1" + player.name + "^7 Has Chosen ^1Deagle Room^2!!" ); 									
    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
	        player iPrintlnBold( "^1---^7>^23^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^23^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^22^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^22^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^21^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^21^7<^1---" );
            wait 2;
            player iPrintlnBold( "^1---^7>^2Fight!^7<^1---" );
            level.activ iPrintlnBold( "^1---^7>^2Fight!^7<^1---" );
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);
 
 
 
    }
    // code never gets here
}
 
finalroom4( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );
   
    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    self GiveWeapon( weap );
    self GiveMaxAmmo( weap );
    self SwitchToWeapon( weap );
 
}