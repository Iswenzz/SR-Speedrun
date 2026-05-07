main()//Map and Script By Phill580
{

     maps\mp\_load::main();
     
     //ambientPlay("eudora");

     //precacheitem("brick_blaster_mp");
     //precacheitem("m1014_reflex_mp");
     //preCacheItem("ak74u_silencer_mp");
     //preCacheItem("rpg_mp");
     //preCacheItem("frag_grenade_mp");
      
     /*thread trap1();
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
     thread trap12mech();
     thread secretdoor1beg();
     thread secretdoor1end();
     thread enddoor11();
     thread enddoor21();
     thread secret1plat();
     thread stableship();
     thread GoldBoltMove();
     thread GoldBoltmech();
     thread Actipod1();
     thread Actipod2();
     thread Actipod3();
     thread Actipod4();
     thread Actipod5();
     thread Actipod6();
     thread Actipod7();
     thread hc1();
     thread hc2();
     thread hc3();
     thread crate();
     thread SniperRoom();
     thread TomaRoom();
     thread games();
     thread game1();
     thread game1mech();
     thread game2();
     thread game2mech();
     thread game3();
     thread game3mech();
     thread game3ammomech();
     thread rpgroom();
     thread rpgammo();
     thread addTestClients();  */  

     thread sr\api\_map::createSpawn((-2609, -288, 76), 180);
     thread sr\api\_speedrun::createNormalWays("Normal Way");
     thread sr\api\_speedrun::createSecretWays("Secret Way");
     thread sr\api\_speedrun::createEndMap((1524.07, 698.942, -63.875), 320,420, "normal_0");    
     thread sr\api\_speedrun::createEndMap((-3114.23, -3841.47, -7.8755), 175,150, "secret_0");

     thread trap_adjustments();
     thread secret_enter();

            addTriggerToList("trigger1");
            addTriggerToList("trigger2");
            addTriggerToList("trigger3");
            addTriggerToList("trigger4");
            addTriggerToList("trigger5");           
            addTriggerToList("trigger7");
            addTriggerToList("trigger8");
            addTriggerToList("trigger9");
            addTriggerToList("trigger10");
            
}
trap_adjustments()
{
brush_1 = getEnt("enddoor1.1","targetname");
brush_2 = getEnt("enddoor2","targetname");


wait 0.1;

brush_1 delete();
brush_2 delete();

			

}
secret_enter()
{
	trig = spawn("trigger_radius",(-2592.07, -460.649, 16.125), 0, 60, 120);
	trig.radius = 60;
	
	ori_t = spawn("script_origin",(-5531,-813,156));
	ori_t.angles = (0,179,0);

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

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

trap1()
{
                   trig = getEnt("trigger1","targetname");
                   brush = getEnt("block","targetname");
                   copter = getEnt("helitrap1","target");

                   trig waittill("trigger");
                   trig delete();
                   {
                    copter moveY(-2400,0.1);
                    wait 0.1;
                    brush moveZ(264,0.1);
                    wait 1;
                    brush notsolid();
                    copter moveY(-8000,2);
                    brush moveY(-8000,2);
                    wait 5;
                    copter delete();
                    brush delete();
                   }
}


trap2()
{
                   trig = getEnt("trigger2","targetname");
                   brush = getEnt("trap2","targetname");

                   trig waittill("trigger");
                   trig delete();
                   {
                    brush delete();
                   }
}

trap3()
{
                   trig = getEnt("trigger3","targetname");
                   brushGroup1 = getEntArray( "3.1", "targetname" );
                   brushGroup2 = getEntArray( "3.2", "targetname" );

                   trig waittill("trigger");
                   trig delete();
                   {
                    brushGroup1[randomInt(brushGroup1.size)] delete();
                    brushGroup2[randomInt(brushGroup2.size)] delete();
                   }
}

trap4()
{
                   trig = getEnt("trigger4","targetname");
                   brushGroup1 = getEntArray( "trap4.1", "targetname" );
                   brushGroup2 = getEntArray( "trap4.2", "targetname" );

                   trig waittill("trigger");
                   trig delete();
                   {
                    brushGroup1[randomInt(brushGroup1.size)] notSolid();
                    brushGroup2[randomInt(brushGroup2.size)] notSolid();
                   }
}

trap5()
{
                   trig = getEnt("trigger5","targetname");
                   brush = getEnt("trap5","targetname");
                   
                   trig waittill("trigger");
                   trig delete();
                   {
                    brush moveZ(-400,1.5);
                    wait 4;
                    brush moveZ(400,1.5);
                    wait 4;
                   }
}

trap6()
{
                   brush = getEnt("trap6","targetname");
                   
                  
                   while(1)
                   {
                    brush rotateYaw(360,1);
                    wait 1;
                   }
}

trap7()
{
                   trig = getEnt("trigger7","targetname");
                   brush1 = getEnt("trap7.1","targetname");
                   brush2 = getEnt("trap7.2","targetname");
                   brush3 = getEnt("trap7.3","targetname");
                   brush4 = getEnt("trap7.4","targetname");
                   trig waittill("trigger");
                   trig delete();
                   while(1)
                   {
                   brush1 RotatePitch(360,3);
                   brush2 RotatePitch(360,3);
                   brush3 RotatePitch(360,3);
                   brush4 RotatePitch(360,3);
                   wait 1;
                   }
}

trap8()
{
                   trig = getEnt("trigger8","targetname");
                   brush1 = getEnt("trap8.1","targetname");
                   brush2 = getEnt("trap8.2","targetname");                 
                   hurt1 = getent("hurt8.1","targetname");
                   hurt2 = getent("hurt8.2","targetname");
                

                   hurt1 enablelinkto();
                   hurt2 enablelinkto();
                   hurt1 linkto(brush1);                 
                   hurt2 linkto(brush2);
                  
                   trig waittill("trigger");
                   trig delete();
                   while(1)
                   {
                   brush1 moveY(-1040,4);
                   brush1 rotateYaw(-360,1.5);
                   brush2 moveY(1040,4);
                   brush2 rotateYaw(360,1.5);
                   wait 5;
                   brush1 moveY(1040,4);
                   brush1 rotateYaw(360,1.5);
                   brush2 moveY(-1040,4);
                   brush2 rotateYaw(-360,1.5);
                   wait 5;
                   }
}

trap9()
{
                   trig = getEnt("trigger9","targetname");
                   brush1 = getEnt("trap9.1","targetname");
                   brush2 = getEnt("trap9.2","targetname");
                   brush3 = getEnt("trap9.3","targetname");
                   
                   trig waittill("trigger");
                   trig delete();
                   while(1)
                   {
                   brush1 rotateYaw(360,2);
                   brush2 rotateYaw(-360,2);
                   brush3 rotateYaw(360,2);
                   wait 3;
                   Brush2 rotateYaw(360,2);
                   wait 3;
                   }
}
trap10()
{
                   trig = getEnt("trigger10","targetname");
                   brush = getEnt("trap10","targetname");
                   
                   trig waittill("trigger");
                   trig delete();
                   while(1)
                   {
                   brush rotatePitch(360,4);
                   wait 6;
                   brush rotatePitch(-360,4);
                   wait 6;
                   }
}

trap11()
{
                   brush = getEnt("trap11","targetname");
                   
                   
                   while(1)
                   {
                    brush RotateYaw(360,3);
                    wait 5;
                    brush RotateYaw(360,3);
                    wait 5;
                   }
}

trap12()
{
                   brush1 = getEnt("spinnerhold","targetname");
                   brush2 = getEnt("spinnertrap","targetname");
                   
                   
                   while(1)
                   {
                   brush1 moveY(864,5);
                   brush2 moveY(864,5);
                   wait 5;
                   brush1 moveY(-864,5);
                   brush2 moveY(-864,5);                   
                   wait 5;
                   }                                 
}
trap12mech()
{
                  brush = getEnt("spinnerhold","targetname");
                  brush3 = getEnt("spinnertrap","targetname");

                  while(1)
                  {
                   brush rotateYaw(360,1);
                   brush3 rotateYaw(360,1);
                   wait 0.5;
                  }
}
                   
                   

secretdoor1beg()
{
            trig = getEnt("secretdoor1beg","targetname");
            brush = getEnt("secretdoor1.1","targetname");
            
            trig waittill("trigger");
            trig delete();
            {
            brush moveZ(100,3);
            }
}

secretdoor1end()
{
            trig = getEnt("secretdoor1end","targetname");
            brush = getEnt("secretdoor1.2","targetname");

            trig waittill("trigger");
            trig delete();
            {
            brush moveZ(100,3);
            }
}

enddoor11()
{
            trig = getEnt("enddoor1","targetname");
            brush = getEnt("enddoor1.1","targetname");

            trig waittill("trigger");
            trig delete();
            {
            brush moveZ(240,3);
            }
}

enddoor21()
{
            trig = getEnt("enddoor2.1","targetname");
            brush = getEnt("enddoor2","targetname");

            trig waittill("trigger", player );
            trig delete();
            {
            brush moveZ(240,3);
            iPrintlnBold( " ^5" + player.name + " has finished the map!" );
            }
}
secret1plat()
{
            trig = getEnt("splattrig","targetname");
            brush = getEnt("splat","targetname");

            trig waittill("trigger");
            trig delete();
            while(1)
            {
             brush movex(600,3);
             wait 5;
             brush moveY(1100,3);
             wait 6;
             brush moveY(-1100,3);
             wait 6;
             brush movex(-600,3);
             wait 5;
            }
}

stableship()
{
            trig = getEnt("stableshiptrig","targetname");
            heli = getEnt("heliship","target");
           
             trig waittill("trigger");
             trig delete();
             {
             heli moveZ(152,4);
             heli rotateYaw(100,4);
             wait 6;
             heli moveX(8000,8);
             wait 10;
             heli rotateYaw(90,4);
             wait 6;
             heli moveY(10000,10);
             wait 12;
             heli delete();
             }
}
GoldBoltMove()
{
             bolt = getEnt("Goldbolt","targetname");
             
             while(1)
             {
             bolt rotateYaw(360,4);
             wait 1;
             }
}

Actipod1()
{
            trig1 = getEnt("pod1","targetname");          
            brush = getEnt("Actipod","targetname");
            
            trig1 waittill("trigger");
            trig1 delete();
            {
             brush moveX(-750,1);
             brush rotateYaw(-90,1);
             wait 2;
            }
}

Actipod2()
{
            trig1 = getEnt("pod2","targetname");          
            brush = getEnt("Actipod","targetname");
            
            trig1 waittill("trigger");
            trig1 delete();
            {
             wait 1;             
             brush moveX(3000,2);
             wait 2.5;
             brush moveY(1520,2);
             wait 2.5;
             brush moveZ(300,2);
             wait 2.5;
             brush moveX(-480,2);
             wait 2.5;
            }
}

Actipod3()
{
            trig1 = getEnt("pod3","targetname");          
            brush = getEnt("Actipod","targetname");
            
            trig1 waittill("trigger");
            trig1 delete();
            {    
             wait 1;         
             brush moveX(480,2);
             wait 2.5;
             brush moveY(1780,2);
             wait 2.5;
             brush moveX(-2200,2);
             brush rotateYaw(90,1);
             wait 2.5;
             brush moveZ(-150,1);
             wait 1.5;
            }
}
             
Actipod4()
{
            trig1 = getEnt("pod4","targetname");          
            brush = getEnt("Actipod","targetname");
            
            trig1 waittill("trigger");
            trig1 delete();
            {
             wait 1;    
             brush moveY(850,2);
             wait 2.5;
             brush MoveZ(-120,2);
             wait 2.5;
             brush RotateYaw(180,2);
             wait 2.5;
             brush moveX(835,2);
             wait 2.5;
            }
}

Actipod5()
{
            trig1 = getEnt("pod5","targetname");          
            brush = getEnt("Actipod","targetname");
            
            trig1 waittill("trigger");
            trig1 delete();
            {
             wait 1;
             brush moveZ(120,2);
             wait 2.5;
             brush moveY(-280,2);
             wait 2.5;
             brush moveX(1900,2);
             wait 2.5;
             }
}


Actipod6()
{
            trig1 = getEnt("pod6","targetname");          
            brush = getEnt("Actipod","targetname");
            
            trig1 waittill("trigger");
            trig1 delete();
            {
             brush moveX(2600,2);
             wait 3;
            }
}
 
Actipod7()
{
            trig1 = getEnt("pod7","targetname");          
            brush = getEnt("Actipod","targetname");
            
            trig1 waittill("trigger");
            trig1 delete();
            { 
             wait 1;                
             brush moveY(-880,2);
             brush rotateYaw(-90,1);
             wait 2;             
             brush moveZ(-120,2);
             wait 2.5;
             brush moveX(2050,1);
             wait 2.5;
            }
}

hc1()
{
hc1 = getEnt("hc1","target");

    while(1)
   {
    hc1 moveY(-3600,4);
    wait 4;
    hc1 rotateYaw(90,1);
    wait 1;
    hc1 moveX(200,1);
    wait 1;
    hc1 rotateYaw(90,1);
    wait 1;
    hc1 moveY(3600,4);
    wait 4;    
    hc1 rotateYaw(90,1);
    wait 1;
    hc1 moveX(-200,1);
    wait 1;
    hc1 rotateYaw(90,1);
    wait 1;
   }
     
}

hc2()
{
hc2 = getEnt("hc2","target");
   
   {
    hc2 moveX(10000,20);
    wait 20;
    hc2 delete();
    }
}

hc3()
{
hc3 = getEnt("hc3","target");
   
   {
    hc3 moveY(-10000,20);
    wait 20;
    hc3 delete();
    }
}

SniperRoom()
{
	level.snip_trig = getEnt( "trigger_sniper", "targetname");
	jump = getEnt( "sniper_jumper", "targetname" );
	acti = getEnt( "sniper_activator", "targetname" );
	
	while(1)
	{
		level.snip_trig waittill( "trigger", player );
		if( !isDefined( level.snip_trig ) )
			return;
		level.toma_trig delete();
                level.games_trig delete();
                level.rpg_trig delete();

		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveMaxAmmo( "remington700_mp" );
		wait 0.05;
		player switchToWeapon( "remington700_mp" );
		level.activ SwitchToWeapon( "remington700_mp" );
		iPrintlnBold( " ^1" + player.name + " has chosen Sniper room!" );			
                                     while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

TomaRoom()
{
	level.toma_trig = getEnt( "trigger_toma", "targetname");
	jump = getEnt( "toma_jumper", "targetname" );
	acti = getEnt( "toma_activator", "targetname" );
	
	while(1)
	{
		level.toma_trig waittill( "trigger", player );
		if( !isDefined( level.toma_trig ) )
			return;
		level.snip_trig delete();
                level.games_trig delete();
                level.rpg_trig delete();
                    
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" );		
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "tomahawk_mp" );		
		wait 0.05;
		player switchToWeapon( "tomahawk_mp" );
		level.activ SwitchToWeapon( "tomahawk_mp" );
		iPrintlnBold( " ^2" + player.name + " has chosen Tomahawk room!" );		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

games()
{
	level.games_trig = getEnt( "trigger_games", "targetname");
	jump = getEnt( "multigame_jumper", "targetname" );
	acti = getEnt( "multigame_activator", "targetname" );
	
	while(1)
	{
		level.games_trig waittill( "trigger", player );
		if( !isDefined( level.games_trig ) )
			return;
		level.snip_trig delete();
                level.toma_trig delete();
                level.rpg_trig delete();                
                                    
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "knife_mp" );		
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "knife_mp" );		
		wait 0.05;
		player switchToWeapon( "knife_mp" );
		level.activ SwitchToWeapon( "knife_mp" );
		iPrintlnBold( " ^2" + player.name + " has chosen Games room!" );		 
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}

game1()
{
	level.game1_trig = getEnt( "game1_trigger", "targetname");
	jump = getEnt( "game1_jumper", "targetname" );
	acti = getEnt( "game1_activator", "targetname" );
        

	while(1)
	{
		level.game1_trig waittill( "trigger", player );
		if( !isDefined( level.game1_trig ) )
			return;
                level.game2_trig delete();
                level.game3_trig delete();
                		                                                                          
      		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "brick_blaster_mp" );		
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "brick_blaster_mp" );		
		wait 0.05;
		player switchToWeapon( "brick_blaster_mp" );
		level.activ SwitchToWeapon( "brick_blaster_mp" );                                                		                                            
		iPrintlnBold( " ^4" + player.name + " has chosen Game1!" );		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}
game1mech()
{
        level.game1_trig = getEnt( "game1_trigger", "targetname");
        brush1 = getEnt( "game1prop1", "targetname" );
	brush2 = getEnt( "game1trap1", "targetname" );
 while(1)
	{
		level.game1_trig waittill( "trigger", player );
		if( !isDefined( level.game1_trig ) )
			return;
                
                {
                brush1 moveZ(304,0.5);
                brush2 moveZ(304,0.5);
                wait 1;
                }
                while(1)
                {
                wait 2;
                brush2 rotateYaw(360,10);
                wait 1;
                }
         }
}


game2()
{
	level.game2_trig = getEnt( "game2_trigger", "targetname");
	jump = getEnt( "game2_jumper", "targetname" );
	acti = getEnt( "game2_activator", "targetname" );
        

	while(1)
	{
		level.game2_trig waittill( "trigger", player );
		if( !isDefined( level.game2_trig ) )
			return;
                 level.game1_trig delete();
                 level.game3_trig delete();
                		                                                                          
      		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "m1014_reflex_mp" );		
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "m1014_reflex_mp" );		
		wait 0.05;
		player switchToWeapon( "m1014_reflex_mp" );
		level.activ SwitchToWeapon( "m1014_reflex_mp" );                                                		                                            
		iPrintlnBold( " ^4" + player.name + " has chosen Game2!" );		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}
game2mech()
{
        level.game2_trig = getEnt( "game2_trigger", "targetname");
        brush = getEnt( "game2prop1", "targetname" );
	{
		level.game2_trig waittill( "trigger", player );
		if( !isDefined( level.game2_trig ) )
			return;
                               
                {
                brush moveZ(304,0.5);
                wait 1;
                }

         }
}


game3()
{
	level.game3_trig = getEnt( "game3_trigger", "targetname");
	jump = getEnt( "game3_jumper", "targetname" );
	acti = getEnt( "game3_activator", "targetname" );
        

	while(1)
	{
		level.game3_trig waittill( "trigger", player );
		if( !isDefined( level.game3_trig ) )
			return;
                 level.game1_trig delete();
                 level.game2_trig delete();
		                                                                          
      		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "frag_grenade_mp" );		
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "frag_grenade_mp" );		
		wait 0.05;
		player switchToWeapon( "frag_grenade_mp" );
		level.activ SwitchToWeapon( "frag_grenade_mp" );                                                		                                            
		iPrintlnBold( " ^5" + player.name + " has chosen Game3!" );		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}
game3mech()
{
        level.game3_trig = getEnt( "game3_trigger", "targetname");
        shell = getEnt( "game3modelshell", "targetname" );
        prop = getEnt( "game3prop1", "targetname" );
        tank = getEnt( "game3tank", "target" );
        car1 = getEnt( "game3car1", "target" );
        car2 = getEnt( "game3car2", "target" );
        car3 = getEnt( "game3car3", "target" );
        car4 = getEnt( "game3car4", "target" );
        car5 = getEnt( "game3car5", "target" );
        car6 = getEnt( "game3car6", "target" );
	{
		level.game3_trig waittill( "trigger", player );
		if( !isDefined( level.game3_trig ) )
			return;
                               
                {
                shell moveZ(204,0.5);
                prop moveZ(860,0.5);
                tank moveZ(204,0.5);
                car1 moveZ(204,0.5);
                car2 moveZ(204,0.5);
                car3 moveZ(204,0.5);
                car4 moveZ(204,0.5);
                car5 moveZ(204,0.5);
                car6 moveZ(204,0.5);
                wait 1;
                }
         }
}
game3ammomech()
{
              level.game3_trig = getEnt( "game3_trigger", "targetname");
              {
		level.game3_trig waittill( "trigger", player );
		if( !isDefined( level.game3_trig ) )
			return;
                while (1)               
                {
                player giveMaxAmmo( "frag_grenade_mp" );
                level.activ giveMaxAmmo( "frag_grenade_mp" );                 
                 wait 0.5;
                }
              }
}
                                
             
GoldBoltmech()
{
            trig = getEnt("goldbolttrigger","targetname");          
            brush  = getEnt("Goldbolt","targetname");

            trig waittill("trigger", player );
            trig delete();
            {
            iPrintlnBold( " ^5" + player.name + " has found the ^3 GoldBolt!" );
             wait 3;
             {
                   hud_clock = NewHudElem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 0;
	hud_clock.y = 0;
	hud_clock.font = "objective";
	hud_clock.fontscale = 2;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (0,0,9);
	hud_clock.label = &" ^4 Map By Phill580";
                   hud_clock SetPulseFX( 40, 5400, 200 );
                   wait 4;
               player Giveweapon("deserteaglegold_mp");
               player GiveMaxAmmo( "deserteaglegold_mp" );
               player SwitchToWeapon("deserteaglegold_mp");
               wait 1;              
             }
            }
}

crate()
{
 trig = getEnt("cratetrig","targetname");
 brush = getEnt("cratetele","targetname");

     while(1)
     {
             trig waittill("trigger", player );
             wait 0.1;
             {
             player setPlayerangles( brush.angles );
             player setOrigin( brush.origin );
             wait 1;
             }
     }
}
rpgroom()
{
	level.rpg_trig = getEnt( "trigger_rpg", "targetname");
	jump = getEnt( "rpg_jumper", "targetname" );
	acti = getEnt( "rpg_activator", "targetname" );
	
	while(1)
	{
		level.rpg_trig waittill( "trigger", player );
		if( !isDefined( level.rpg_trig ) )
			return;
		level.snip_trig delete();
                level.games_trig delete();
                level.toma_trig delete();
                    
		player SetPlayerAngles( jump.angles );
		player setOrigin( jump.origin );
		player TakeAllWeapons();
		player GiveWeapon( "rpg_mp" );		
		level.activ setPlayerangles( acti.angles );
		level.activ setOrigin( acti.origin );
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "rpg_mp" );		
		wait 0.05;
		player switchToWeapon( "rpg_mp" );
		level.activ SwitchToWeapon( "rpg_mp" );
		iPrintlnBold( " ^2" + player.name + " has chosen Tomahawk room!" );		
		while( isAlive( player ) && isDefined( player ) )
			wait 1;
	}
}
rpgammo()
{
              level.rpg_trig = getEnt( "trigger_rpg", "targetname");
              {
		level.rpg_trig waittill( "trigger", player );
		if( !isDefined( level.rpg_trig ) )
			return;
                while (1)               
                {
                player giveMaxAmmo( "rpg_mp" );
                level.activ giveMaxAmmo( "rpg_mp" );                 
                 wait 0.5;
                }
              }
}