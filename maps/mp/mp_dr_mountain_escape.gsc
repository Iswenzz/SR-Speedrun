#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

/*
 ÛÛÛÛÛÛ   ÛÛÛÛÛ             ÛÛÛÛÛ        ÛÛÛÛÛ ÛÛÛÛ                 ÛÛÛÛÛÛÛÛÛÛ  
°°ÛÛÛÛÛÛ °°ÛÛÛ            ÛÛÛ°°°ÛÛÛ     °°ÛÛÛ °°ÛÛÛ                °°ÛÛÛ°°°°ÛÛÛ 
 °ÛÛÛ°ÛÛÛ °ÛÛÛ   ÛÛÛÛÛÛ  ÛÛÛ   °°ÛÛÛ  ÛÛÛÛÛÛÛ  °ÛÛÛ   ÛÛÛÛÛÛ     ÛÛ °ÛÛÛ   °°ÛÛÛ
 °ÛÛÛ°°ÛÛÛ°ÛÛÛ  ÛÛÛ°°ÛÛÛ°ÛÛÛ    °ÛÛÛ ÛÛÛ°°ÛÛÛ  °ÛÛÛ  ÛÛÛ°°ÛÛÛ   °°  °ÛÛÛ    °ÛÛÛ
 °ÛÛÛ °°ÛÛÛÛÛÛ °ÛÛÛ °ÛÛÛ°ÛÛÛ    °ÛÛÛ°ÛÛÛ °ÛÛÛ  °ÛÛÛ °ÛÛÛÛÛÛÛ        °ÛÛÛ    °ÛÛÛ
 °ÛÛÛ  °°ÛÛÛÛÛ °ÛÛÛ °ÛÛÛ°°ÛÛÛ   ÛÛÛ °ÛÛÛ °ÛÛÛ  °ÛÛÛ °ÛÛÛ°°°         °ÛÛÛ    ÛÛÛ 
 ÛÛÛÛÛ  °°ÛÛÛÛÛ°°ÛÛÛÛÛÛ  °°°ÛÛÛÛÛ°  °°ÛÛÛÛÛÛÛÛ ÛÛÛÛÛ°°ÛÛÛÛÛÛ     ÛÛ ÛÛÛÛÛÛÛÛÛÛ  
°°°°°    °°°°°  °°°°°°     °°°°°°    °°°°°°°° °°°°°  °°°°°°     °° °°°°°°°°°°   

*/

main()
{	  
	maps\mp\_load::main();
	maps\mp\_teleport::main();
	
	setdvar("bg_fallDamageMaxHeight", "9999"); 
	setdvar("bg_fallDamageMinHeight", "9998");
	 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//precache
	precacheModel("shark");
	precacheMenu("music");
	precacheShader( "black" );
	precacheShader( "white" );

	ent = getEnt("endmap_trig","targetname");
    ent delete();

    trigger = spawn( "trigger_radius", (-1656.06, 4811.74, -0.875), 0, 155, 80 );
    trigger.targetname = "endmap_trig";
    trigger.radius = 155;
	
	//threads

    thread way_connect();

	//thread songTrig();
	thread removeDebris();
	thread movePlatform1();
	//thread movePlatform2();
	//thread moveFinalPlatform();
	//thread moveRiverRocks1();
	//thread moveRiverRocks2();
	//thread moveRiverRocks3();
	//thread escapedMountain();
	//thread foundTreasure(); 
	//thread noobBounce();
	//thread proBounce();
	//thread rotateM4();
	//thread giveM4(); 
    thread activatorFailed();
	//thread moveThings();
	//thread seashark("seashark",0);
	//thread seashark("seashark2",7);
	//thread seashark("seashark3",14);
	//thread seashark("seashark4",21);
	
	//trigerlist
	//addTriggerToList("trap1_trigger");
	//addTriggerToList("trap2trig");
	//addTriggerToList("trap3trig");
	//addTriggerToList("trap4trig");
	//addTriggerToList("trap5trig");
	//addTriggerToList("trap6trig");
	//addTriggerToList("trap7trig");
	//addTriggerToList("trap8trig");
	//addTriggerToList("trap9trig");
	//addTriggerToList("trap10trig");

	//traps
	thread trap_1();
	thread trap_2();
	thread trap_3();
	thread trap_4a();
	thread trap_5();
	thread trap_6();
	thread trap_7();
	thread trap_8a();
	thread trap_9();
	thread trap_10();
	
	//rooms
	//thread bounceroom();
	//thread sniperroom();
	//thread kniferoom();
	//thread oldroom();
	 
}

way_connect()
{
    wait 0.05;
    
    level.masterSpawn = spawn("script_origin",(37,-3616,66-60));
	level.masterSpawn.angles = (0,90,0);

    sr\api\_map::createWay("normal", "Normal Way", "1");
    
    for(;;) 
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}

moveThings()
{
	oldbridge = getent("oldbridge","targetname");
	oldbridge RotateRoll(90,3);
	noodle = getent("noodle","targetname");
	while(1){		
		noodle rotateyaw(360,4);
		wait 4;
	}
	
}

activatorFailed()
{
	trigger = getent("activatorfailed","targetname");
	while(1){		
	trigger waittill("trigger",player);
	iPrintLnBold("Activator ^4"+player.name+"^1 Failed his bounce!");
	wait 1;
	}
	
}
seashark(name,pointattmp){ //DarkFollower
    
    seashark = getent(name,"targetname");
    
    pointat = 0;
    point[0] = (-1943,542,-314);
    point[1] = (-1054 , 543 , -314);
    point[2] = (-671 , 676 , -314);
    point[3] = (-384 , 960 , -314);
    point[4] = (-384 , 1391 , -314);
    point[5] = (-74 , 1680 , -314);
    point[6] = (-76 , 2000 , -314);
    point[7] = (-458 , 1966 , -314);
    point[8] = (-677 , 2144 , -314);
    point[9] = (-654 , 2908 , -314);
    point[10] = (-850 , 3890 , -314);
    point[11] = (-445 , 3920 , -314);
    point[12] = (-352 , 4256 , -314);
    point[13] = (-51 , 4384 , -314);
    point[14] = (-12 , 4947 , -314);
    point[15] = (-267 , 5312 , -314);
    point[16] = (-991 , 5360 , -314);
    point[17] = (-912 , 4727 , -314);
    point[18] = (-980 , 4340 , -314);
    point[19] = (-1134 , 4096 , -314);
    point[20] = (-1381 , 3852 , -314);
    point[21] = (-1805 , 3791 , -314);
    point[22] = (-1891 , 3327 , -314);
    point[23] = (-1521 , 3078 , -314);
    point[24] = (-1091 , 2816 , -314);
    point[25] = (-1314 , 1925 , -314);
    point[26] = (-1668 , 1269 , -314);
	
	seashark moveto(point[pointattmp],1);

    
    sharkpos = seashark.origin;
    sharkangles = seashark.angles;
    targetpos = (0,0,0);
    tomove = (0,0,0);
	tojmove = (0,0,0);
    speed = 6;
	
	jumpat = 0;
	jumpon = 0;	
    jumpheight = 100;
    
    while(1){
        
        
        sharkpos = seashark.origin;
        if(Distance(sharkpos, point[pointat]) < speed+2)
            pointat++;
			
		//Check if safe to jump
		jumpcan = 0;
		if(Distance(sharkpos, point[pointat]) > 40*speed)
			jumpcan = 1;
        
        if(pointat > 26) 
            pointat = 0;
        
        //Jumping
		
		
		if(jumpcan && jumpon == 0){
			if(RandomIntRange(0,500) == 420){
				jumpon = 1;
				speed *= 1.5;
			}
		}
		
		
		if(jumpon == 1)
			jumpat += 3;
		
		if(jumpat >= 180){
			jumpat = 0;
			jumpon = 0;
			speed /= 1.5;
		}
		
		
        //Movement
        targetpos = (point[pointat][0],point[pointat][1],point[pointat][2]);
		
		//Add jumping
        tomove = targetpos-sharkpos;
		tomove = speed*VectorNormalize(tomove);
		tomove = (tomove[0],tomove[1],tomove[2]+jumpon*(jumpheight*(Sin(jumpat)-Sin(jumpat-3))));		
		
		//Calculate Angles
        angto = VectorToAngles((tomove[0],tomove[1],tomove[2]));
        angto = (angto[2],angto[1]+90,angto[0]);
		
		//Fix for problem
		
		angtoz = angto[0];
		angtoo = angto[1];
		angtot = angto[2];
		
		if(Abs(angto[0]-seashark.angles[0]) >= 180) if(angto[0] < seashark.angles[0]) angtoz += 360; else angtoz -= 360;
		if(Abs(angto[1]-seashark.angles[1]) >= 180) if(angto[1] < seashark.angles[1]) angtoo += 360; else angtoo -= 360;
		if(Abs(angto[2]-seashark.angles[2]) >= 180) if(angto[2] < seashark.angles[2]) angtot += 360; else angtot -= 360;
		
		angto = (angtoz,angtoo,angtot);
        angto = seashark.angles*0.9+ angto*0.1;
		
		
        seashark rotateTo(angto,0.016);
        seashark moveTo(tomove + seashark.origin+tojmove,0.016);
    
        
        //Peimenei 1/60 sec
        wait 0.016;
        
    }
    
}

addTriggerToList( name )
{
   if(!isDefined( level.trapTriggers ))
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}


trap_1(){
	trigger = getent("trap1_trigger","targetname");
	brush = getent("trap1_brush","targetname");	
	trigger waittill("trigger",player);
	
}

trap_2(){
	trigger = getent("trap2trig","targetname");
	brush = getent("trap2","targetname");	
	trigger waittill("trigger",player);
	
}

trap_3(){
	trigger = getent("trap3trig","targetname");
	brush = getent("trap3","targetname");	
	trigger waittill("trigger",player);
	
}

trap_4a(){
	
	trigger = getent("trap4trig","targetname");
	brush = getent("trap4a","targetname");	
	trigger waittill("trigger",player);
	
}

trap_4b(){
	
	brush = getent("trap4b","targetname");	
	wait 2.5;
	
	while(1){		
		brush movez(-100,2.5);		
		wait 2.5;	
		brush movez(100,2.5);
		wait 2.5;
	}
	
}

trap_5(){
	
	trigger = getent("trap5trig","targetname");
	brush = getent("trap5","targetname");	
	trigger waittill("trigger",player);
	
}

trap_6(){
	
	trigger = getent("trap6trig","targetname");
	brush = getent("trap6","targetname");	
	trigger waittill("trigger",player);
	
}

trap_7(){
	trigger = getent("trap7trig","targetname");
	brush = getent("trap7","targetname");	
	trigger waittill("trigger",player);
	
}

trap_8a(){
	
	trigger = getent("trap8trig","targetname");
	brush = getent("trap8a","targetname");	
	trigger waittill("trigger",player);
	
}

trap_8b()
{	
	brush = getent("trap8b","targetname");
	wait 1;
	thread trap_8c();
	
	while(1){		
		brush rotateYaw(360,1);
		wait 4;
	}
}

trap_8c()
{	
	brush = getent("trap8c","targetname");
	wait 1;
	thread trap_8d();
	
	while(1){		
		brush rotateYaw(360,1);
		wait 4;
	}
}

trap_8d()
{	
	brush = getent("trap8d","targetname");
	wait 1;
	
	while(1){		
		brush rotateYaw(360,1);
		wait 4;
	}
}

trap_9()
{
	trigger = getent("trap9trig","targetname");
	brush = getent("trap9","targetname");	
	trigger waittill("trigger",player);
	
}

trap_10()
{
	trigger = getent("trap10trig","targetname");
	brush1 = getent("trap10a","targetname");	
	brush2 = getent("trap10b","targetname");	
	brush3 = getent("trap10c","targetname");
	hurt1  = getent("hurt1","targetname");
	hurt2  = getent("hurt2","targetname");
	hurt3  = getent("hurt3","targetname");
	
	
	trigger waittill("trigger",player);
	
}

movePlatform1()
{	
	platform1 = getent("platform1","targetname");
		
		platform1 moveX (-533,4);
		
	}
	


movePlatform2()
{	
	platform2 = getent("platform2","targetname");
	
	while(1){
		platform2 moveX (533,4);
		wait 4;
		platform2 moveX(-533,4);
		wait 4;
		
	}
}

noobBounce()
{
	noobtrig = getent("noobtrig","targetname");
	noobtrig waittill("trigger",player);
	iPrintlnBold( "^2" + player.name +" is a ^1Noob :/");
}

proBounce()
{
	protrig = getent("protrig","targetname");
	protrig waittill("trigger",player);
	iPrintlnBold( "^2" + player.name +" is a ^1Pro!!!");
	protrig delete();
}

moveFinalPlatform()
{
	finalplatformtrig = getent("finalplatformtrig","targetname");
	finalplatform = getent("finalplatform","targetname");
	finalplatformtrig waittill ("trigger",player);
	finalplatformtrig delete();
	
	while(1){
		finalplatform moveY(950,4);
		wait 4.5;
		finalplatform moveY(-950,4);
		wait 4.5;
	}
	
}

rotateM4()
{
		rotatingm4 = getent("rotatingm4","targetname");
		while(1){
			rotatingm4 rotateYaw(360,2);
			wait 2;
		}
}

giveM4()
{
	m4trig = getent("m4trig","targetname");
	while(1){
		m4trig waittill("trigger",player);
		iPrintLnBold("^1"+player.name +" ^6got his ^4 m40a3!");
		player giveweapon("m40a3_mp");
		player giveMaxAmmo("m40a3_mp");
		player SwitchtoWeapon( "m40a3_mp" );
	}

}

removeDebris()
{	
	debris1 = getent("debris1","targetname");
	debris2 = getent("debris2","targetname");
	debris1 delete();
	debris2 delete();
}

moveRiverRocks1()
{
	rocks = getent("riverrocks1","targetname");
		
	while(1){
		rocks moveZ (10,2);
			wait 2;
		rocks moveZ (-10,2);
			wait 2;
	}
		
}	

moveRiverRocks2()
{
	rocks = getent("riverrocks2","targetname");
		
	while(1){
		rocks moveZ (-10,2);
			wait 2;
		rocks moveZ (10,2);
			wait 2;
	}
		
}	

moveRiverRocks3()
{
	rocks = getent("riverrocks3","targetname");
	
	while(1){
		rocks moveZ (-5,1.6);
			wait 3;
		rocks moveZ (5,1.6);
			wait 3;
	}
		
}	

escapedMountain(){
	trig = getent("escaped","targetname");	
	trig waittill ("trigger",player);
	trig delete();
	iPrintLnBold("^1"+ player.name + " " + "^3 escaped the mountain  ^1first!");
	player braxi\_rank::giveRankXP("", 150);
}

foundTreasure(){
	 trig = getent("treasure","targetname");
	 treasure = getent("treasurechest","targetname");
	 gotoorigin = getent("treasureshark","targetname");
	 greedyorigin = getent("greedyorigin","targetname");
	 shark = getent("shark","targetname");
	 shark hide();
	 trig waittill ("trigger",player);	 
	 trig delete();
	 shark show();
	 iPrintLnBold("^4"+ player.name + " " + "I said ^1don't ^5open the treasue!");
	 player setPlayerAngles(gotoorigin.angles);
	 player FreezeControls(1);
	 wait 0.5;
	 iPrintLnBold("^1Oh no! ^2"+ player.name + " " + "^5is getting attacked by ^1shark!");
	 shark moveZ(170,1); 
	 wait 1;
	 shark moveTo(player.origin,3);
	 wait 3;
	 shark moveTo(gotoorigin.origin,3);
	 wait 2.9;
	 player setOrigin(greedyorigin.origin);	 
	 player FreezeControls(0);
	 iPrintLnBold("^2" +player.name+" ^1got greedy :/!");
	 shark moveZ (-170,1);
	 shark delete();
	 treasure delete();
	 thread sinkIsland();
}

sinkIsland()
{
	island = getent("island","targetname");
	watermelon = getent("watermelon","targetname");
	palmtree = getent("palmtree","targetname");
	earthquake(0.5,5,island.origin,5000);
	island moveZ(-400,5);
	watermelon moveZ(-400,5);
	palmtree moveZ(-400,5);
	island waittill("movedone");	
	island delete();
	palmtree delete();
	watermelon delete();	
	iPrintLnBold("^1Rip^2 island :/");
}

bounceroom()
{
	level.bouncetrig = getEnt( "bouncetrig", "targetname");
	bjumper = getEnt( "bounce1", "targetname" );
	bacti = getEnt( "bounce2", "targetname" );
		 
	if( !isDefined( level.bouncetrig ))
		 return;
				 
	while(1)
	{
			level.bouncetrig waittill( "trigger", player );
		   
				if(!isdefined(level.firstenter))
					level.firstenter=false;
				   
			if(level.firstenter==false)
			{
				 level.snipertrig delete();
				 level.knifetrig delete();
				 level.oldtrig delete();
				 level.firstenter=true;
			}
			
			level.activ freezeControls(1);
			player FreezeControls(1);				   
			player setOrigin(bjumper.origin);
			player setPlayerAngles(bjumper.angles );
			level.activ setOrigin(bacti.origin);
			level.activ setPlayerAngles(bacti.angles);
					
			player takeallweapons();
			player GiveWeapon( "knife_mp" );
			player SwitchtoWeapon( "knife_mp" );
			
			level.activ takeallweapons();
			level.activ GiveWeapon( "knife_mp" );
			level.activ SwitchtoWeapon( "knife_mp" );
				  
				   
			noti = SpawnStruct();
			noti.titleText = ("^5 "+player.name + " ^2Has Chosen Bounce Room!");
			noti.notifyText = "^4 "+level.activ.name + " ^1VS^2 " + player.name;
			noti.duration = 6;
			noti.glowcolor = (0, 0, 1.0);
								   
			players = getEntArray("player", "classname");
			
			for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
								   
			wait 2;
				   
			level.activ FreezeControls(0);
			player FreezeControls(0);
				   				 
			self waittill("death");

		}
}


sniperroom() 
{
     level.snipertrig = getEnt( "snipertrig", "targetname");
     sjump = getEnt( "sniper1", "targetname" );
     sacti = getEnt( "sniper2", "targetname" );
	 
	 if( !isDefined( level.snipertrig ) )
         return;
		 
	 while(1)
	 {
		level.snipertrig waittill("trigger", player );
		
		if(!isdefined(level.firstenter))
			level.firstenter=false;
			
		if(level.firstenter==false){
			
			level.knifetrig delete();
			level.bouncetrig delete();
			level.oldtrig delete();
			level.firstenter=true;
		}
		
		level.activ freezeControls(1);
		player FreezeControls(1);
			
		player SetPlayerAngles( sjump.angles );
		player setOrigin( sjump.origin );
		level.activ setPlayerangles( sacti.angles );
		level.activ setOrigin( sacti.origin );
		level.activ TakeAllWeapons();
		player TakeAllWeapons();
			
		level.activ giveweapon( "m40a3_mp");
		player giveweapon( "m40a3_mp");
		player switchToWeapon( "m40a3_mp" );
		level.activ SwitchToWeapon( "m40a3_mp" );
		player giveMaxAmmo( "m40a3_mp" );
		level.activ giveMaxAmmo( "m40a3_mp" );
		
		level.activ giveweapon( "remington700_mp");
		player giveweapon( "remington700_mp");
		player switchToWeapon( "remington700_mp" );
		level.activ SwitchToWeapon( "remington700_mp" );
		player giveMaxAmmo( "remington700_mp" );
		level.activ giveMaxAmmo( "remington700_mp" );
		
		level.activ freezeControls(1);
		player FreezeControls(1);
			
		noti = SpawnStruct();
		noti.titleText = ("^4 "+player.name + "^3 Entered ^5Sniper room ^2Fight!");
		noti.notifyText = level.activ.name + " ^1VS^5 " + player.name;
		noti.duration = 6;
		noti.glowcolor = (0, 0, 1.0);
		
		players = getEntArray("player", "classname");
		
		for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(noti);
					
		wait 2;
		
		level.activ FreezeControls(0);
		player FreezeControls(0);
		
		wait 0.1;
                     
		self waittill("death");

	}
}

kniferoom() 
{
     level.knifetrig = getEnt( "knifetrig", "targetname");
     kjump = getEnt( "knife1", "targetname" );
     kacti = getEnt( "knife2", "targetname" );
	 
	if( !isDefined( level.knifetrig ) )
         return;
		 
	 while(1)
	 {
		level.knifetrig waittill( "trigger", player );
		
		if(!isdefined(level.firstenter))
			level.firstenter=false;
			
		if(level.firstenter==false)
		{
		 level.snipertrig delete();
		 level.bouncetrig delete();
		 level.oldtrig delete();
		 level.firstenter=true;
		}
		
		level.activ freezeControls(1);
		player FreezeControls(1);
			
		player SetPlayerAngles( kjump.angles );
		player setOrigin( kjump.origin );
		level.activ setPlayerangles( kacti.angles );
		level.activ setOrigin( kacti.origin );
		level.activ TakeAllWeapons();
		player TakeAllWeapons();
		
		level.activ giveweapon( "knife_mp");
		player giveweapon( "knife_mp");
		player switchToWeapon( "knife_mp" );
		level.activ SwitchToWeapon( "knife_mp" );
		
		level.activ freezeControls(1);
		player FreezeControls(1);
		
		noti = SpawnStruct();
		noti.titleText = ("^4 " + player.name + "^3 Entered ^5Knife room ^2Fight!");
		noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
		noti.duration = 6;
		noti.glowcolor = (0, 0, 1.0);
				
		players = getEntArray("player", "classname");
		
		for(i=0;i<players.size;i++)
			players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
				
		wait 2;
		
		level.activ FreezeControls(0);
		player FreezeControls(0);
		
		wait 0.1;
				 
		self waittill("death");

	}
}

oldroom()
{
	oldtrig = getent("oldtrig","targetname");
	oldbridge = getent("oldbridge","targetname");
	clipoff = getent("clipoff","targetname");
	outside = getent("outside","targetname");	
	oldtrig waittill("trigger",player);
	
	level.snipertrig delete();
	level.bouncetrig delete();
	level.knifetrig delete();
	oldtrig delete();
	clipoff delete();
	level.activ setPlayerangles(outside.angles);
	level.activ setOrigin(outside.origin);
	
	oldbridge RotateRoll(-90,3);

	//fancy letters
	
	noti = SpawnStruct();
	noti.titleText = ("^4" + player.name + "^3 has chosen ^5Old room!");
	noti.duration = 6;
	noti.glowcolor = (0, 0, 1.0);
			
	players = getEntArray("player", "classname");
	
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage(noti);
			
	wait 2;
	
	
		 
}


songTrig()
{
	trigger = getEnt ( "songtrig", "targetname" );
	trigger waittill( "trigger", player );
	trigger setHintString( "Press ^2[^7USE^2] ^7to choose Music" );
	trigger delete();
	player endon ( "song_picked" );
	player thread songMenu();
	player freezeControls(1);
}

songMenu()
{
	
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "song_picked" );
 
	self openMenu("music");
	
	self thread cleanUpOnPick();
	self thread cleanUpOnDeath();
 
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 360, 200 );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 358, 1, "center", "top", 1.4 );
	self.hud_music[i].sort = 885;
	self.hud_music[i].font = "objective";
	self.hud_music[i] setText( "\n                 Press ^5[^71^5/^72^5/^73^5/^74^5/^75^5/^76^5/^77^5/^78^5]^7 To Play The Song." );
	
	j = 0;
	self.hud_music_s[j] = braxi\_mod::addTextHud( self, 172, 230+(0*16), 0.93, "left", "top", 1.4 );
	self.hud_music_s[j].sort = 900;
	self.hud_music_s[j].font = "objective";
	self.hud_music_s[j] setText("^21.^5Camila Cabello ^1-^7 Havana\n^22.^5Marshmello ^1-^7 Silence\n^23.^5Zedd ^1-^7 Stay\n^24.^5The CS & CP ^1-^7 Something just like this\n^25.^5MGK ^1-^7 Home\n^26.^5Era Istrefi ^1-^7 Bonbon\n^27.^5Major Lazer ^1-^7 Light it Up\n^28.^5NF ^1-^7 Let you down");
 
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		if( menu == "music")
		{
			music = "";
			
			if(response == "song1")
			{
				ambientPlay("song1");
				iprintln("^2Now Playing: ^5Camila Cabello ^1-^7 Havana");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
			
			if(response == "song2")
			{
				ambientPlay("song2");
				iprintln("^2Now Playing: ^5Marshmello ^1-^7 Silence");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
			
			if(response == "song3")
			{
				ambientPlay("song3");
				iprintln("^2Now Playing: ^5Zedd ^1-^7 Stay");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
			
			if(response == "song4")
			{
				ambientPlay("song4");
				iprintln("^2Now Playing: ^5The CS & CP ^1-^7 Something just like this");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
			
			if(response == "song5")
			{
				ambientPlay("song5");
				iprintln("^2Now Playing: ^5MGK ^1-^7 Home");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
			
			if(response == "song6")
			{
				ambientPlay("song6");
				iprintln("^2Now Playing: ^5Era Istrefi ^1-^7 Bonbon");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
			
			if(response == "song7")
			{
				ambientPlay("song7");
				iprintln("^2Now Playing: ^5Major Lazer ^1-^7 Light it Up");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
			
			if(response == "song8")
			{
				ambientPlay("song8");
				iprintln("^2Now Playing: ^5NF ^1-^7 Let you down");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
			
			else
			{
				ambientPlay("song1");
				iprintln("^2Now Playing: ^5Camila Cabello ^1-^7 Havana");
				self freezeControls(0);
				self setClientDvar("song_picked",music);
				self notify("song_picked");
				break;
			}
		}
	}
}

cleanUpOnDeath()
{
	self waittill("death");
	
	if(isDefined(self.hud_music))
	{
		for(i=0; i<self.hud_music.size; i++)	
			if(isDefined(self.hud_music[i]))
				self.hud_music[i] Destroy();
	}
	
	if(isDefined(self.hud_music_s))
	{
		for(i=0; i<self.hud_music_s.size; i++)	
			if(isDefined(self.hud_music_s[i]))
				self.hud_music_s[i] Destroy();
	}
}

cleanUpOnPick()
{
	self waittill("song_picked");
	
	if(isDefined(self.hud_music))
	{
		for(i=0; i<self.hud_music.size; i++)	
			if(isDefined(self.hud_music[i]))
				self.hud_music[i] Destroy();
	}
	
	if(isDefined(self.hud_music_s))
	{
		for(i=0; i<self.hud_music_s.size; i++)	
			if(isDefined(self.hud_music_s[i]))
				self.hud_music_s[i] Destroy();
	}
}

