main()
{
	maps\mp\_load::main();
	thread startdoor();
	thread sr\api\_map::createSpawn((-129, -78, 64), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");

 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar( "r_specularcolorscale", "1" );
	
	//precacheItem("m40a3_mp");
	//precacheItem("ak47_mp");
	//precacheItem("g36c_mp");
	//precacheItem("mp44_mp");

	thread sr\api\_map::createSpawn((-129, -78, 64), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	
	
	//thread trap1();
	//thread trap2();
	//thread startdoor();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();
	//thread jumper();
	//thread huds();
	//thread teleport1();
	//thread addTestClients();
	//thread sniper();
	//thread old();
	//thread knife();
	//thread secretweapon();
	
	//The below threads have been scripted by Pixel =)
	//thread onSpawn();
	//thread guidroom();
	//thread guidroomxp();
	//thread guidjump1();
	//thread guidjump2();
	//thread srtele1();
	//thread srtele2();
	//thread srtele3();
	//thread srtele4();
	//thread guidexit();
	//thread ak47();
	//thread g36c();
	//thread mp44();
	//thread m40a3();
	//thread fall();
	
	addTriggerToList("trap1_trig");
	addTriggerToList("trap2_trig");
	addTriggerToList("trap3_trig");
	addTriggerToList("trap4_trig");
	addTriggerToList("trap6_trig");
	addTriggerToList("ryan_trig");
	addTriggerToList("trap9_trig");
	addTriggerToList("ryan1_trig");
	addTriggerToList("ryan2_trig");
	addTriggerToList("guidbounce");
}
addTriggerToList( name )
{
if( !isDefined( level.trapTriggers ) )
level.trapTriggers = [];
level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


trap1()
{
	brush = getent("trap1","targetname");
	trigger = getent("trap1_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	while(1)
	{
		brush rotateYaw(360,1);
		wait 1;
		brush rotateYaw(360,1);
		wait 1;
	}
	
	trigger delete();
}

trap2()
{
	brush = getent("trap2","targetname");
	trigger = getent("trap2_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	brush NotSolid();
	
	trigger delete();
}

startdoor()
{
	brush = getent("door","targetname");

	wait 0.1;

	brush delete();
}

playIt()
{
	x = randomInt( 3 );
		if(x==1)
		{
		ambientPlay( "agile1" );
		}
		else if(x==2)
		{
		ambientPlay( "agile2" );
		}
		else
		{
		ambientPlay( "agile3" );
		}
}

trap3()
{
	brush = getent("trap3","targetname");
	trigger = getent("trap3_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	while(1)
	{
		brush moveX(-200,1.5);
		brush waittill("movedone");
		brush moveX(200,1.5);
		brush waittill("movedone");
		
	}
	
	trigger delete();
}

trap4()
{
	brush = getent("trap4","targetname");
	trigger = getent("trap4_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	while(1)
	{
		brush rotateRoll(360,9);
		wait 1;
		
	}
	
	trigger delete();
}

trap5()
{
	brush = getent("trap5","targetname");
	trigger = getent("trap5_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	brush moveZ(-300,.2);
	brush waittill("movedone");
	wait 1.5;
	brush moveZ(300,3);
	
	trigger delete();
}

trap6()
{	
	brush = getent("trap6","targetname");
	trigger = getent("trap6_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	while(1)
	{
		brush rotateRoll(-360,3);
		wait 1;
		brush rotateRoll(-360,3);
		wait 1;
	}
	
	trigger delete();
}

jumper()
{
	jumpx = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");

	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

trap7()
{
	brush = getent("ryan","targetname");
	trigger = getent("ryan_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	while(1)
	{
		brush rotatePitch(360,1);
		brush waittill("rotatedone");
		wait 4;
		brush rotatePitch(360,1);
		brush waittill("rotatedone");
		wait 4;
	}
	
	trigger delete();
}

trap8()
{
trigger = getent("trap9_trig","targetname");
brush = getent("trap9","targetname");
killtrigger = getent ("killtrig" , "targetname");
trigger waittill ("trigger");
trigger setHintString("^5ACTIVATED!");
trigger delete();
{
killtrigger enablelinkto ();
killtrigger linkto (brush);
brush movez(44, 3, 1, 2);
brush waittill("movedone");
wait(2);
brush movez(-44, 3, 1, 2);
brush waittill("movedone");
wait(1);
}
}

trap9()
{
	brush = getent("ryan1","targetname");
	trigger = getent("ryan1_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	brush notsolid();
	
	trigger delete();
}

trap10()
{
	brush = getent("ryan2","targetname");
	trigger = getent("ryan2_trig","targetname");
	trigger waittill("trigger");
	trigger setHintString("^5ACTIVATED!");
	
	brush moveZ(300,.01);
	brush waittill("movedone");
	brush moveZ(-300,2);
	
	trigger delete();
}

huds() 
{ 
level.ryan_hud = newHudElem(); 
level.ryan_hud.x = 550; 
level.ryan_hud.y = 400; 
level.ryan_hud.alignX = "center"; 
level.ryan_hud.alignY = "middle"; 
level.ryan_hud.fontScale = 1.5; 
level.ryan_hud.color = (205, 0, 205); 
level.ryan_hud.font = "objective"; 
level.ryan_hud.glowColor = (205, 0, 205); 
level.ryan_hud.glowAlpha = 1; 
level.ryan_hud.hideWhenInMenu = true; 
level.ryan_hud setText("Map By #FNRP#Ryan"); 
}

teleport1()
{
	trig = getEnt("trigger_teleport1", "targetname");
	tele1 = getEnt("origin_teleport1", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}

addTestClients()
{
    setDvar("scr_testclients", "");
    wait 1;
    for(;;)
    {
        if(getdvarInt("scr_testclients") > 0)
            break;
        wait 1;
    }
    testclients = getdvarInt("scr_testclients");
    setDvar( "scr_testclients", 0 );
    for(i=0;i<testclients;i++)
    {
        ent[i] = addtestclient();

        if (!isdefined(ent[i]))
        {
            println("Could not add test client");
            wait 1;
            continue;
        }
        ent[i].pers["isBot"] = true;
        ent[i] thread TestClient("autoassign");
    }
    thread addTestClients();
}
TestClient(team)
{
    self endon( "disconnect" );

    while(!isdefined(self.pers["team"]))
        wait .05;
        
    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}

sniper()
{
        level.sniper_trig = getEnt( "sniper1", "targetname");
        jump = getEnt( "sniper2", "targetname" );
        acti = getEnt( "sniper3", "targetname" );
 
 
        while(1)
        {
                level.sniper_trig waittill( "trigger", player );
                if( !isDefined( level.sniper_trig ) )
                        return;
 
                level.old_trig delete();
                level.knife_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "m40a3_mp" ); //jumper weapon  
                player switchToWeapon( "m40a3_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "m40a3_mp" );
                        level.activ SwitchToWeapon( "m40a3_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^3 Has Chosen sniper room!" );     //change to what you want it to be
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

 knife()
{
        level.knife_trig = getEnt( "knife", "targetname");
        jump = getEnt( "knife1", "targetname" );
        acti = getEnt( "knife2", "targetname" );
 
 
        while(1)
        {
                level.knife_trig waittill( "trigger", player );
                if( !isDefined( level.knife_trig ) )
                        return;
 
                level.sniper_trig delete();
                level.old_trig delete();
              
				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" ); //jumper weapon  
                player switchToWeapon( "knife_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "knife_mp" );
                        level.activ SwitchToWeapon( "knife_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^3 Has Chosen knife room!" );     //change to what you want it to be
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}
 
 old()
{
        level.old_trig = getEnt( "old1", "targetname");
        jump = getEnt( "old2", "targetname" );
 
 
        while(1)
        {
                level.old_trig waittill( "trigger", player );
                if( !isDefined( level.old_trig ) )
                        return;
 
                level.sniper_trig delete();
                level.knife_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^3 Has Chosen old room!" );     //change to what you want it to be
                        while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}

secretweapon()
{
trigger = getent("m40a3_weap","targetname");
trigger waittill("trigger" , player );

player GiveWeapon( "m40a3_mp" );
player GiveMaxAmmo( "m40a3_mp" );
player switchToWeapon( "m40a3_mp" );
}

//The below scripts have been scripted by Pixel =)

guidroom()
{
tp = getent("guidroomtele","targetname");
org = getEnt("guidteletarget", "targetname");
while( 1 )
{
tp waittill("trigger", player);
if( getSubStr( player.guid, 24, 32 ) == "0a9aa5a2" || "92fba429" ||"a26b44b3")
{
player setOrigin( org.origin );
player setplayerangles( org.angles );
player iprintlnbold ("^5Welcome to the ^1GUID ^5room " + player.name + "!");
}
else
return;
}
}

guidroomxp()
{
	trigger = getent("guidbounce","targetname");
	trigger waittill("trigger", player );
	
	iPrintLnBold("^3Damn " + player.name + "^3 you're a pro!");
}

guidjump1()
{
	brush = getent ("jump1","targetname");
	air1 = getent ("g1","targetname");
	air2 = getent ("g2","targetname");
	air3 = getent ("g3","targetname");
	air4 = getent ("g4","targetname");
	air5 = getent ("g5","targetname");
	air6 = getent ("g6","targetname");
	air7 = getent ("g7","targetname");

	time = 1;
	for(;;)
	{
		brush waittill ("trigger",user);
		if (user istouching(brush))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait .5;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			air moveto (air5.origin, time);
			wait 1;
			air moveto (air6.origin, time);
			wait 1;
			air moveto (air7.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

guidjump2()
{
	brush = getent ("jump2","targetname");
	air1 = getent ("p1","targetname");
	air2 = getent ("p2","targetname");
	air3 = getent ("p3","targetname");
	air4 = getent ("p4","targetname");
	air5 = getent ("p5","targetname");
	air6 = getent ("p6","targetname");
	air7 = getent ("p7","targetname");

	time = 1;
	for(;;)
	{
		brush waittill ("trigger",user);
		if (user istouching(brush))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait .5;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			air moveto (air5.origin, time);
			wait 1;
			air moveto (air6.origin, time);
			wait 1;
			air moveto (air7.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}

srtele1()
{

entTransporter = getentarray("sr1","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter2();
  }


}

transporter2()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   other iprintlnbold ("^1You can get killed in there!");
   wait(0.10);
  }
}

srtele2()
{

entTransporter = getentarray("sr2","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter3();
  }


}

transporter3()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   other iprintlnbold ("^1You can get killed in there!");
   wait(0.10);
  }
}

srtele3()
{

entTransporter = getentarray("sr3","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter4();
  }


}

transporter4()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   other iprintlnbold ("^1You can get killed in there!");
   wait(0.10);
  }
}

srtele4()
{

entTransporter = getentarray("sr4","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter5();
  }


}

transporter5()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   wait(0.10);
  }
}

guidexit()
{

entTransporter = getentarray("guidexit","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter6();
  }


}

transporter6()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   wait(0.10);
  }
}

ak47()
{

	trigger = getent("ak47","targetname");
	trigger waittill("trigger" , player );
	
	player GiveWeapon( "ak47_mp" );
	player GiveMaxAmmo( "ak47_mp" );
	player switchToWeapon( "ak47_mp" );

}

g36c()
{

	trigger = getent("g36c","targetname");
	trigger waittill("trigger" , player );
	
	player GiveWeapon( "g36c_mp" );
	player GiveMaxAmmo( "g36c_mp" );
	player switchToWeapon( "g36c_mp" );
	
}

mp44()
{

	trigger = getent("mp44","targetname");
	trigger waittill("trigger" , player );
	
	player GiveWeapon( "mp44_mp" );
	player GiveMaxAmmo( "mp44_mp" );
	player switchToWeapon( "mp44_mp" );

}

m40a3()
{

	trigger = getent("barrett","targetname");
	trigger waittill("trigger" , player );
	
	player GiveWeapon( "m40a3_mp" );
	player GiveMaxAmmo( "m40a3_mp" );
	player switchToWeapon( "m40a3_mp" );

}

fall()
{

entTransporter = getentarray("fall","targetname");
  if(isdefined(entTransporter))
  {
    for(lp=0;lp<entTransporter.size;lp=lp+1)
      entTransporter[lp] thread Transporter1337();
  }


}

transporter1337()
{
  while(true)
  {
   self waittill("trigger",other);
   entTarget = getent(self.target, "targetname");
   wait(0.10);
   other setorigin(entTarget.origin);
   other setplayerangles(entTarget.angles);
   other iprintlnbold ("^1You can't go down there!");
   wait(0.10);
  }
}