#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
  
   maps\mp\_load::main();
   
   game["allies"] = "marines";
   game["axis"] = "opfor";
   game["attackers"] = "axis";
   game["defenders"] = "allies";
   game["allies_soldiertype"] = "desert";
   game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((-261, -1, -644), 180);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((-3324.54, -6626.13, -614.875), 160,120, "normal_0");

    thread custom_tp();
   
   
   //thread mover1();
   thread start();
   //thread secret();
   //thread mover2();
   //thread Activator();
   //thread old();
   //thread sniper();
   //thread bounceent();
   //thread bouncetp();
   //thread bounceweapon();
   //thread bouncetp2();
   //thread Chicks();
   //thread titi();
   //thread hide();
   //thread music();
   //thread credits();
   


 
   addTriggerToList( "trig_one" );
   addTriggerToList( "trig_two" );
   addTriggerToList( "trig_three" );
   addTriggerToList( "trig_four" );
   addTriggerToList( "trig_five" );
   addTriggerToList( "trig_six" );
   addTriggerToList( "trig_seven" );
   addTriggerToList( "trig_aight" );
   addTriggerToList( "trig_nine" );
   addTriggerToList( "trig_ten" );
   addTriggerToList( "trig_eleven" );
   addTriggerToList( "trig_twelve" );
   addTriggerToList( "trig_thirteen" );
   addTriggerToList( "trig_fourteen" );
 
}
custom_tp()
{
	trig = spawn("trigger_radius",(-3247.76, -2031.76, -703.8755), 0, 105, 120);
	trig.radius = 105;
	
	ori_t = spawn("script_origin",(-1164,-2333,-644));
	ori_t.angles = (0,18,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}  
credits()
{


while(1)
{
wait 10;
iPrintln("^2Map made by Hechsler");
wait 4;
iPrintln("^3Thanks to Jumpy for his Tutorial on FNRP");
wait 4;
iPrintln("^4Thanks to SHoT for helping me with scripting and bugs");
wait 4;
iPrintln("^5Thanks to Lossy for helping me with a compile problem and releasing his scripts");
wait 4;
iPrintln("^6Thanks to Pixel for being awesome <3");
wait 4;
iPrintln("^7SONG PLAYING: Red hot chilli peppers - around the world");
wait 1500;


   }
}
secret()
{
thread weapon();
thread open();
thread close();
thread tp1();
thread enter();
thread leave();
thread respawn();
}
start()
{
   plat = getEnt("startplat","targetname");
   credits = getEnt("credits","targetname");

   wait 0.1;

   plat delete();
 
   
}
mover1()
{
   mover1 = getEnt("mover1","targetname");
   while(1)
   {
   mover1 movex(1384,0.2);
   wait 0.2;
   wait 2;
   mover1 movex(-1384,0.2);
   wait 0.2;
   wait 2;
   }
} 
mover2()
{
   mover2 = getEnt("mover2","targetname");
   while(1)
   {
   mover2 movey(1664,3);
   wait 3;
   wait 2;
   mover2 movey(-1664,1);
   wait 1;
   wait 2;
   }
}  
weapon()
{
   weapon = getEnt("wepsec","targetname");
   weapon waittill ("trigger", player);
   
   
   
   player GiveWeapon( "m40a3_mp" );
   player giveMaxAmmo( "m40a3_mp" );
   player switchToWeapon( "m40a3_mp");

}
open()
{
   secretent = getEnt("secretent","targetname");
   open = getEnt("opensec","targetname");
   open waittill ("trigger");
   wait 0.1;
   iPrintlnBold( "^5Secret is Open. ^1Nice shot brah!" );
   secretent delete();
   open delete();
}
close()
{
   close = getEnt("close","targetname");
   close_trig = getEnt("cloose","targetname");
   close_trig waittill ("trigger", player);
   close_trig delete();
   close movex (-64,0.5);
   wait 0.5;
}
tp1()
{
   plungtp_trig = getEnt("plungtp","targetname");
   plungori = getEnt("pungori","targetname");
   for(;;)
   {
   plungtp_trig waittill ("trigger", player);
   player setOrigin(plungori.origin);
   iPrintlnBold("^5If you can read this, you are ^1stupid");
   player braxi\_rank::giveRankXP("", 300);
    }
}
   

enter()
{
   trig_enter = getEnt("trigsecent","targetname");
   ori_enter = getEnt("orisecent","targetname");
   for(;;)
   {
   trig_enter waittill ("trigger", player);
   player setOrigin(ori_enter.origin);
 
   }
}  
leave()
{
   trig_leave = getEnt("trigsecleave","targetname");
   ori_leave = getEnt("orisecleave","targetname");
   for(;;)
   {
   trig_leave waittill ("trigger", player);
   player setOrigin(ori_leave.origin);
   iPrintlnBold (player.name+" ^5Finished the secret");
   player braxi\_rank::giveRankXP("", 500);
   }
}
respawn()
{
   trig_respawn = getEnt("respawn_trig","targetname");
   ori_respawn = getEnt("respawn","targetname");
   for(;;)
   {
   trig_respawn waittill ("trigger", player);
   player setOrigin(ori_respawn.origin);
   }
} 
Activator()
{
   thread actitp1();
   thread actitp2();
   thread actitp3();
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
   thread actisecret();
   thread actisecret2();
   thread actisecret3();
   thread actisecret4();
   
}
actitp1()
{
   actitp1_trigger = getEnt("actitp1","targetname");
   actitp1_ori = getEnt("actitp4","targetname");
   for(;;)
   {
   actitp1_trigger waittill ("trigger", player);
   player setOrigin(actitp1_ori.origin);
   }
}
actitp2()
{
   actitp2_trigger = getEnt("actitp2","targetname");
   actitp2_ori = getEnt("actitp5","targetname");
   for(;;)
   {
   actitp2_trigger waittill ("trigger", player);
   player setOrigin(actitp2_ori.origin);
   }
}
actitp3()
{
   actitp3_trigger = getEnt("actitp3","targetname");
   actitp3_ori = getEnt("actitp6","targetname");
   for(;;)
   {
   actitp3_trigger waittill ("trigger", player);
   player setOrigin(actitp3_ori.origin);
   }
}
trap1()
{
    ore = getEnt("ore","targetname");
    oli = getEnt("oli","targetname");
    ure = getEnt("ure","targetname");
    uli = getEnt("uli","targetname");
    trig_one = getEnt("trap1","targetname");
	trig_one sethintstring("^5>> ^3Press[USE]to activate ^5<<");
    trig_one waittill ("trigger");
    trig_one delete();

      while(1)
      {
      ore movey(-64,0.1);
      oli movex(64,0.1);
      uli movey(64,0.1);
      ure movex(-64,0.1);
      wait 0.5;
      
      ure movey(-64,0.1);
      ore movex(64,0.1);
      oli movey(64,0.1);
      uli movex(-64,0.1);
      wait 0.5;
      
      uli movey(-64,0.1);
      ure movex(64,0.1);
      ore movey(64,0.1);
      oli movex(-64,0.1);
      wait 0.5;
      
      oli movey(-64,0.1);
      uli movex(64,0.1);
      ure movey(64,0.1);
      ore movex(-64,0.1);
      wait 0.5;
      }
}
trap2()
{
    trig_two = getEnt("trap2","targetname");
	delete1 = getEnt("delete1","targetname");
	trig_two sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	while(1)
	{
	trig_two waittill ("trigger");
	trig_two delete();
	delete1 delete();
	}
}
trap3()
{
     trig_three = getEnt("trap3","targetname");
	 bounce = getEnt("bouncerot","targetname");
	 trig_three sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	 trig_three waittill ("trigger");
	 trig_three delete();
	 while(1)
	 {
	 bounce rotateYaw(360,4);
	 wait 4;
	 }
} 
trap4()
{
    trig_four = getEnt("trap4","targetname");
	lefts = getEnt("lefts","targetname");
	rights = getEnt("rights","targetname");
	trig_four sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	trig_four waittill ("trigger");
	trig_four delete();
	while(1)
	{
	lefts movex(-64,1);
	rights movex(64,1);
	wait 1;
	wait 0.5;
	lefts movex(64,1);
	rights movex(-64,1);
	wait 1;
	wait 0.5;
	}
}
trap5()
{
    trig_five = getEnt("trap5","targetname");
	closeit = getEnt("closeit","targetname");
	trig_five sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	
	while(1)
	{
	trig_five waittill ("trigger");
	trig_five delete();
	closeit movez(-128,1);
	wait 1;
	wait 6;
	closeit movez(128,1);
	}
}	
trap6()
{
    trig_six = getEnt("trap6","targetname");
	bouncerot2 = getEnt("bouncerot2","targetname");
	trig_six sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	trig_six waittill ("trigger");
	trig_six delete();
	while(1)
	{
	bouncerot2 rotateYaw (360,3);
	wait 3;

	}
}
trap7()
{
    trig_seven = getEnt("trap7","targetname");
	cube = getEnt("cube","targetname");
	trig_seven sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	trig_seven waittill ("trigger");
	trig_seven delete();
	while(1)
	{
	cube movez (-190,0.1);
	wait 0.1;
	cube rotateYaw (2000,4);
	wait 4;
	cube movez(190,2);
	wait 2;
	wait 3;
	}
}	
trap8()
{
    trig_aight = getEnt("trap8","targetname");
	platrot = getEnt("rotplat","targetname");
	trig_aight sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	trig_aight waittill ("trigger");
	trig_aight delete();
	while(1)
	{
	platrot rotateYaw(360,1.5);
	wait 1.5;

	}
}
trap9()
{
    trig_nine = getEnt("trap9","targetname");
	delete3 = getEnt("delete3","targetname");
	schnapp = getEnt("schnapp","targetname");
	trig_nine sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	trig_nine waittill ("trigger");
	trig_nine delete();
	while(1)
	{
	delete3 delete();
	schnapp movez(-72,0.2);
	wait 0.2;
	wait 0.5;
	schnapp movez (72,2);
	wait 2;
	wait 1;
	}
}	
trap10()
{
    trig_ten = getEnt("trap10","targetname");
	standart = getEnt("standart","targetname");
	trig_ten sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	trig_ten waittill ("trigger");
	trig_ten delete();
	while(1)
	{
	standart rotateRoll(360,2.5);
	wait 2.5;
	}
}
trap11()
{
    trig_eleven = getEnt("trap11","targetname");
	reihe1 = getEnt("reihe1","targetname");
	reihe2 = getEnt("reihe2","targetname");
	reihe3 = getEnt("reihe3","targetname");
	trig_eleven sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	trig_eleven waittill ("trigger");
	trig_eleven delete();
	while(1)
	{
	reihe1 rotateRoll(180,0.5);
	wait 0.5;
	reihe2 rotateRoll(180,0.5);
	wait 0.5;
	reihe3 rotateRoll(180,0.5);
	wait 0.5;
	wait 1;
	}
}
trap12()
{
    trig_twelve = getEnt("trap12","targetname");
	rolle = getEnt("rolle","targetname");
	trig_twelve sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	trig_twelve waittill ("trigger");
	trig_twelve delete();
	while(1)
	{
	rolle rotateRoll(360,5);
	wait 5;
	
	}
}	
trap13()
{
    trig_thirteen = getEnt("trap13","targetname");
	delete4 = getEnt("delete4","targetname");
	trig_thirteen sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	while(1)
	{
	trig_thirteen waittill ("trigger");
	trig_thirteen delete();
	delete4 delete();
	}
}	
trap14()
{
    trig_fourteen = getEnt("trap14","targetname");
	oben = getEnt("oben","targetname");
	unten = getEnt("unten","targetname");
	schieber = getEnt("schieber","targetname");
	trig_fourteen sethintstring("^5>> ^3Press[USE]to activate ^5<<");
	while(1)
	{
	trig_fourteen waittill("trigger");
	trig_fourteen delete();
	oben movez(-34,2.5);
	unten movez(34,2.5);
	wait 2.5;
	wait 2;
	schieber movex(-174,2);
	wait 2;
	schieber movex(174,1);
	oben movez(34,1);
	unten movez(-34,1);
	}
}	
old()
{
    level.old_trig = getEnt("oldent","targetname");
	olddoor = getEnt("olddoor","targetname");
	olddoor2 = getEnt("olddoor2","targetname");
	actiold = getEnt("actiold","targetname");
	while(1)
	{
	level.old_trig waittill( "trigger", player ); 
                if( !isDefined( level.old_trig ) ) 
                return;  
				
	    level.sniper_trig delete();
        level.hide_trig delete();
        level.bounce_trig delete(); 
	
	
    
	
	olddoor2 delete();
	olddoor movez(120,3);
	iPrintlnBold(player.name+ "^3Opened the final door!");
	
	
	if( isDefined( level.activ ) && isAlive( level.activ ) ) 
	{
	level.activ setPlayerangles( actiold.angles );
    level.activ setOrigin( actiold.origin ); 
	}
	}	
}
sniper()
{
    level.sniper_trig = getEnt( "snipent", "targetname"); //trigger 
        jump = getEnt( "snipjumpi", "targetname" ); //jumper origin
        acti = getEnt( "snipacti", "targetname" ); //acti origin
 
        while(1) 
{
                level.sniper_trig waittill( "trigger", player ); 
                if( !isDefined( level.sniper_trig ) ) 
                return;  
            
        level.old_trig delete();
        level.hide_trig delete();
        level.bounce_trig delete(); 
            
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin ); 
                player TakeAllWeapons(); 
                player GiveWeapon( "m40a3_mp" ); //Gives player weapon
                player giveMaxAmmo( "m40a3_mp" ); //Gives player ammo
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );   
            player switchToWeapon( "m40a3_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "m40a3_mp" ); 
                    level.activ giveMaxAmmo( "m40a3_mp" ); 
                    level.activ GiveWeapon( "remington700_mp" );
                    level.activ giveMaxAmmo( "remington700_mp" );
               level.activ SwitchToWeapon( "m40a3_mp" );
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
                iPrintlnBold( " ^4" + player.name + " ^7has chosen ^4Sniper ^7Room!" ); 
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^6Fight^7!" );
            level.activ iPrintlnBold( "^6Fight^6!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
}
}	
actisecret()
{
    entrancetrig = getEnt("actisecret3","targetname");
    trigger = getEnt("actisecret","targetname");
	entrance = getEnt("actisecret2","targetname");
	entrancetrig = getEnt("actisecret3","targetname");
	actisecretori = getEnt("aso","targetname");
	while(1)
	{
	trigger waittill ("trigger");
	trigger delete();
	entrance movez(120,3);
	entrancetrig movez(120,3);
	}
}	
actisecret2()
{
    entrancetrig2 = getEnt("actisecret3","targetname");
	actisecretori = getEnt("aso","targetname");	
	while(1)
	{
	entrancetrig2 waittill ("trigger" ,player);
	player setOrigin(actisecretori.origin);
	entrancetrig2 delete();
	}
}	
actisecret3()
{
    res = getEnt("actirespawn","targetname");
	aso = getEnt("actitp6","targetname");
	for(;;)
	{
	
	res waittill ("trigger" ,player);
	player setOrigin(aso.origin);
	}
}	
actisecret4()
{
    tpout = getEnt("tpout","targetname");
	atp = getEnt("actitp6","targetname");
	while(1)
	{
	tpout waittill ("trigger",player);
	player setOrigin(atp.origin);
	player braxi\_rank::giveRankXP("", 100);
	}
}
bounceent()
{
    level.bounce_trig = getEnt("bounceenttrig","targetname");
	A = getEnt("actibounce","targetname");	
	J = getEnt("jumpibounce","targetname");
	while(1)
    {
        level.bounce_trig waittill( "trigger", player );
        if( !isDefined( level.bounce_trig ) )
            return;
        
        
        level.old_trig delete();
        level.sniper_trig delete();
        level.hide_trig delete();
		
        player SetPlayerAngles( J.angles );
        player setOrigin( J.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon  
        player switchToWeapon( "tomahawk_mp" );
		
        if( isDefined( level.activ ) && isAlive( level.activ ) )
{
        level.activ setPlayerangles( A.angles );
        level.activ setOrigin( A.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );
        level.activ SwitchToWeapon( "tomahawk_mp" );        
        wait 0.05;
		player.maxhealth = 100;
		level.activ.maxhealth = 100;
 }       
       wait 0.05;
               
                iPrintlnBold( " ^4" + player.name + " ^7has chosen ^4Jump ^7Room!" ); 
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^6Fight^7!" );
            level.activ iPrintlnBold( "^6Fight^6!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
  }
}
bouncetp()
{
        resp = getEnt("actirespawnbounce","targetname");
		respo = getEnt("actibounce","targetname");
		for(;;)
        {
        resp waittill ("trigger", player);
        player setOrigin(respo.origin);
		}
}		
bouncetp2()
{
        re = getEnt("jumpirespawnbounce","targetname");
		respa = getEnt("jumpibounce","targetname");
		for(;;)
        {
        re waittill ("trigger", player);
        player setOrigin(respa.origin);
		}
}
Chicks()
{
    chickentrig = getEnt("chicktrigger","targetname");
	chick = getEnt("chick","targetname");
	link = getEnt("tata","targetname");
	link enablelinkto();
	link linkto(chick);
	chickentrig waittill ("trigger" ,player);
	chickentrig delete();
	iPrintlnBold("^5DID YOU HURT MY CHICKEN??^1NOW THEY ARE MAD!!");
	while(1)
	{
	chick movey(-2126,1.5);
	wait 1.5;
	chick rotateYaw(180,1);
	wait 1;
	chick movex(360,0.5);
	wait 0.5;
	chick movey(2126,1.5);
	wait 1.5;
	chick rotateYaw(180,1);
	wait 1;
	chick movex(-720,0.5);
	wait 0.5;
	chick movey(-2126,1.5);
	wait 1.5;
	chick rotateYaw(180,1);
	wait 1;
	chick movex(1040,0.5);
	wait 0.5;
	chick movey(2126,1.5);
	wait 1.5;
    chick rotateYaw(180,1);
	wait 1;
	chick movex(-720,0.5);
	wait 0.5;
	
	}
}	
titi()
{
    tata = getEnt("tata","targetname");
	toto = getEnt("toto","targetname");
	while(1)
	{
	tata waittill ("trigger");
	iPrintlnBold("^3OK OK stop hurting them, I'll open the door... ^9Find it ...");
	tata delete();
	toto notsolid();
	}
}	

		

					
bounceweapon()
{
        weptrig = getEnt("givesniper","targetname");
		weptrig waittill ("trigger", who);
   
   
   
   who GiveWeapon( "m40a3_mp" );
   who giveMaxAmmo( "m40a3_mp" );
   who switchToWeapon( "m40a3_mp");
   
}
hide()
{
    level.hide_trig = getEnt("hidetrig","targetname");
	Act = getEnt("hideacti","targetname");	
	Jum = getEnt("hidejumper","targetname");
	while(1)
    {
        level.hide_trig waittill( "trigger", player );
        if( !isDefined( level.hide_trig ) )
            return;
        
        
        level.old_trig delete();
        level.sniper_trig delete();
        level.bounce_trig delete();
		
        player SetPlayerAngles( Jum.angles );
        player setOrigin( Jum.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon  
        player switchToWeapon( "tomahawk_mp" );
		player hide();
        if( isDefined( level.activ ) && isAlive( level.activ ) )
{
        level.activ setPlayerangles( Act.angles );
        level.activ setOrigin( Act.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );
        level.activ SwitchToWeapon( "tomahawk_mp" );  
        level.activ hide();		
        wait 0.05;
		player.maxhealth = 100;
		level.activ.maxhealth = 100;
		iPrintlnBold( " ^4" + player.name + " ^7has chosen ^4Hide ^7Room!" ); 
         
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
       }
	}
}
music()
{
    while(1)
    {
    wait 1;
    
    ambientPlay( "song1" );
	}
}
