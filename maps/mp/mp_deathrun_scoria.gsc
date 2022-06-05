//Most scripts big help from Sheep Wizard


main()
{
level.masterSpawn = spawn("script_origin", level.spawn["allies"][0].origin);
level.masterSpawn.angles = level.spawn["allies"][0].angles;
level.masterSpawn placeSpawnPoint();

	maps\mp\_load::main();
	
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	     
		 precacheItem( "brick_blaster_mp" );
		 precacheItem( "uzi_mp" );
	     setdvar( "r_specularcolorscale", "1" );
         setdvar("r_glowbloomintensity0",".25");
         setdvar("r_glowbloomintensity1",".25");
		 setdvar( "bg_falldamagemaxheight", "9999" );
         setdvar( "bg_falldamageminheight", "9998" );
		 
		 // ambientPlay("mp_deathrun_scoria");
		 


////threads////
thread way_connect();
thread elevator();
// thread trap1();
// thread trap2();
// thread trap3();
// thread trap3_2();
// thread trap3_3();
// thread trap4();
// thread trap5();
// thread trap6();
// thread trap7();
thread Luke();
// thread skert();
thread vip();
// thread hud();
// thread snipegame();
// thread knifegame();
// thread addTestClients();

// addTriggerToList( "trap1" );
// addTriggerToList( "trap2" );
// addTriggerToList( "trap3" );
// addTriggerToList( "trap3_2" );
// addTriggerToList( "trap3_3" );
// addTriggerToList( "trap4" );
// addTriggerToList( "trap5" );
// addTriggerToList( "trap6" );
// addTriggerToList( "trap7" );
	

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////



addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
} 


 
elevator(){
elevator=getent("elevator","targetname");


for(;;)
{

elevator movez (-610,3,0.5,0.5);
elevator waittill("movedone");
elevator movez (610,3,0.5,0.5);
elevator waittill("movedone");
}
}



trap1()
{
trig = getent("trap1", "targetname");
damage = getent("spikesdmg", "targetname");
brush = getent("spikes","targetname");

damage enablelinkto();
damage linkto (brush);

 
trig waittill("trigger", player); 
trig delete(); 
 

     {
             brush movex(-96,1);
			 brush waittill("movedone");
			 wait 4;
			 brush movex(96,3);
			 brush waittill("movedone");
              
         }
 
}

trap2()
{
trig2 = getent("trap2", "targetname");
brush2 = getent("spinpillar1","targetname");
brush3 = getent("spinpillar2","targetname");
 
trig2 waittill("trigger", player); 
trig2 delete(); //deletes the trigger
 
for(;;)
     {
            brush2 rotateYaw (360,3);
			wait 0.1;
			brush3 rotateYaw (-360,3);
			
 }
			 
			 
			 
              
         }
 
 
 
 
trap3()
{
trig = getent("trap3", "targetname");
brush4 = getent("killball","targetname");

 
trig waittill("trigger", player); 
trig delete(); //deletes the trigger
 
while(1)
     {
             brush4 rotateRoll (-150,1,0.5,0.5);
			 brush4 waittill("rotatedone");
			 brush4 rotateRoll (150,1,0.5,0.5);
			 brush4 waittill("rotatedone");
		}	 
			

 
}

trap3_2()
{
trig = getent("trap3_2", "targetname");
brush5 = getent("killball2","targetname");

 
trig waittill("trigger", player); 
trig delete(); //deletes the trigger
 
while(1)
     {
             brush5 rotateRoll (150,1,0.5,0.5);
			 brush5 waittill("rotatedone");
			 brush5 rotateRoll (-150,1,0.5,0.5);
			 brush5 waittill("rotatedone");
		}	 
			
 
}

trap3_3()
{
trig = getent("trap3_3", "targetname");
brush6 = getent("killball3","targetname");

 
trig waittill("trigger", player); 
trig delete(); //deletes the trigger
 
while(1)
     {
             brush6 rotateRoll (-150,1,0.5,0.5);
			 brush6 waittill("rotatedone");
			 brush6 rotateRoll (150,1,0.5,0.5);
			 brush6 waittill("rotatedone");
		}	 
			
 
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
while(1)
         {
         level.xxx.color = (255,128,0);
         level.xxx.label = &"Map by Bumba <3";    
         wait 10;
         level.xxx.color = (0,50,255);
         level.xxx.label = &"xfire: bumbaftw";
         wait 5;
		 level.xxx.color = (100,45,255);
         level.xxx.label = &"Thanks to Sheep Wizard for help with scripting";
         wait 5;
		 level.xxx.color = (1,0,0);
         level.xxx.label = &"The sand is hot :)";
		 wait 5;
}
}

Luke()
{
trig = getent("luke", "targetname");
for(;;)
{
trig waittill("trigger", player);
player setClientDvar( "r_specularmap", 2 );
}
}

trap4()
{
trig = getent("trap4", "targetname");
snap = getent("snap","targetname");
snapdmg = getent("dmgsnap","targetname");

snapdmg enablelinkto();
snapdmg linkto (snap);

 
trig waittill("trigger", player); 
trig delete(); //deletes the trigger
 
     {
			 snap rotatePitch (90,1,0.5,0.5);
			 wait 3;
			 snap rotatePitch (-90,1,0.5,0.5);
			
		}	 
			

 
}

skert() 
{
trig = getent("secretdude", "targetname"); 
target = getent("secretm8", "targetname");
target2 = getent("secretback", "targetname"); 
for(;;)
{
trig waittill("trigger", player);
player setOrigin(target.origin);
player setPlayerAngles(target.angles);
player giveweapon( "deserteaglegold_mp");
player switchToWeapon( "deserteaglegold_mp" );
player setweaponammostock( "deserteaglegold_mp", 40 );
player iprintlnbold ("^2Behold, ^1Luke AKA ^2Sc|Muscle");
player iprintlnbold ("^4Le master trole!");
wait 5;
player setOrigin(target2.origin);
player setPlayerAngles(target2.angles);
}
}


trap5()
{
trigdude = getent("trap5", "targetname");
elevate = getent("elevator","targetname");



 
trigdude waittill("trigger", player); 
trigdude delete(); //deletes the trigger
 
     {
			 elevate rotateRoll (-90,1,0.5,0.5);
			 wait 4;
			 elevate rotateRoll (90,1,0.5,0.5);
			 
			
		}	 
			

 
}

trap6()
{
trigm8 = getent("trap6", "targetname");
slats1 = getent("slats1","targetname");
slats2 = getent("slats2","targetname");



 
trigm8 waittill("trigger", player); 
trigm8 delete(); //deletes the trigger
 
    x = randomInt(2); 
    if(x == 0)
    {
        slats1 notsolid(); 
        wait 5;
        slats1 solid();		
    }
    else if(x == 1)
    {
        slats2 notsolid();
		wait 5;
		slats2 solid();
    }

}

trap7()
{
swagm8 = getent("trap7", "targetname");

swagm8 waittill("trigger", player);
swagm8 delete();
 
thread spinner1a();
thread spinner1b();
thread spinner2a();
thread spinner2b();
thread spinner3a();
thread spinner3b();
 
}
 
spinner1a()
{
for(;;)
{

 spinner1 = getent("spinner1","targetname");
 spinner2 = getent("spinner2","targetname");
 spinner3 = getent("spinner3","targetname");

 spinner1 rotateYaw (360,1);
 spinner1 waittill("rotatedone");
}
}
spinner1b()
{
for(;;)
{
 
 spinner1 = getent("spinner1","targetname");
 spinner2 = getent("spinner2","targetname");
 spinner3 = getent("spinner3","targetname");
 
 spinner1 moveY (-724,2);
 spinner1 waittill("movedone");
 spinner1 moveY (724,2);
 spinner1 waittill("movedone");
}
}
spinner2a()
{
for(;;)
{
 
 spinner1 = getent("spinner1","targetname");
 spinner2 = getent("spinner2","targetname");
 spinner3 = getent("spinner3","targetname");
 
 spinner2 rotateYaw (360,1);
 spinner2 waittill("rotatedone");
}
}
spinner2b()
{
for(;;)
{
 
 spinner1 = getent("spinner1","targetname");
 spinner2 = getent("spinner2","targetname");
 spinner3 = getent("spinner3","targetname");
 
 spinner2 moveX (-1000,3);
 spinner2 waittill("movedone");
 spinner2 moveX (1000,3);
 spinner2 waittill("movedone");
}
}
spinner3a()
{
for(;;)
{
 
 spinner1 = getent("spinner1","targetname");
 spinner2 = getent("spinner2","targetname");
 spinner3 = getent("spinner3","targetname");
 
 spinner3 rotateYaw (360,1);
 spinner3 waittill("rotatedone");
}
}
spinner3b()
{
for(;;)
{
 
 spinner1 = getent("spinner1","targetname");
 spinner2 = getent("spinner2","targetname");
 spinner3 = getent("spinner3","targetname");
 
 spinner3 moveY (800,2);
 spinner3 waittill("movedone");
 spinner3 moveY (-800,2);
 spinner3 waittill("movedone");
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

vip()
{      
        level.accepted1 = "b6211f4f"; //Bumba
		level.accepted2 = "1033e38e"; //Luke
		level.accepted3 = "11b05456"; //Sheep
        level.accepted4 = "6d10208c"; //Calum       
	    level.accepted5 = "fdb75f8f"; //Jack
	   
        while (1)
        {
                level waittill( "player_spawn", player );
               
                friend = getSubStr(player getGuid(), 24, 32);
               
                if((friend == level.accepted1))
                {      
						player giveweapon( "brick_blaster_mp");
                }
				
				if((friend == level.accepted2))
                {      
						player giveweapon( "brick_blaster_mp");
                }
				
				if((friend == level.accepted3))
                {      
						player giveweapon( "brick_blaster_mp");
                }
				
				if((friend == level.accepted4))
                {      
						player giveweapon( "brick_blaster_mp");
                }
				
				if((friend == level.accepted5))
                {      
						player giveweapon( "brick_blaster_mp");
                }
				
               
        }
}

knifegame()
{
    level.knife_trig = getEnt( "knife", "targetname");
    jump = getEnt( "knifejumper", "targetname" );
    acti = getEnt( "knifeacti", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        
        level.snip_trig delete();

        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );        
        wait 0.05;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN KNIFE^1!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

snipegame()
{
    level.snipe_trig = getEnt( "snipe", "targetname");
    jumper = getEnt( "snipejumper", "targetname" );
    activator = getEnt( "snipeacti", "targetname" );
    
    while(1)
    {
        level.snipe_trig waittill( "trigger", player );
        if( !isDefined( level.snipe_trig ) )
            return;
        
        level.knife_trig delete();

        player SetPlayerAngles( jumper.angles );
        player setOrigin( jumper.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" ); //jumper weapon        
        level.activ setPlayerangles( activator.angles );
        level.activ setOrigin( activator.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );        
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon
        level.activ SwitchToWeapon( "m40a3_mp" );
        iPrintlnBold( " ^6" + player.name + " ^5 HAS CHOSEN SNIPE^1!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

//Minigame scripts by Lossy


