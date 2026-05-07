#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
   maps\mp\_load::main();

//precacheItem( "ak47_mp" );

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

    thread sr\api\_map::createSpawn((2, -221, 60), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((562.575, 12153.8, -1559.88), 170,120, "secret_0");

	thread sr_sec_enter();
 
 //level.expbullt = loadfx("explosions/grenadeExp_concrete_1");
 
 //thread sniper();
 //thread elev1();
 //thread elev2();
 //thread elev3();
 
 //thread choo1();
 //thread choo2();
 //thread choo3();
 //thread choo4();
 //thread choo5();
 //thread choo6();
 //thread choo7();
 //thread choo8();
 
 //thread rpg1();
 //thread rpg2();
 //thread rpg3();
 //thread rpg4();
 //thread rpg5();
 //thread rpg6();
 //thread rpg7();
 //thread rpg8();
 //thread rpg9();
 //thread rpg10();
 //thread rpg11();
 //thread rpg12();
 
 //thread autosong();
 
 //thread licznik();
 
 //thread soundmenu();
 
 //thread rpg();
 
 //thread end();
 //thread sound();
 
 thread deathzone1();
 //thread deathzone2();
 //thread deathzone3();
 
 thread jump1();
 thread jump2();
 thread jump3();
 //thread secret();
 
 thread part2();
 thread brama1();

 //thread onPlayerConnect();
 //thread onPlayerConnect2();
 
 //thread ufoleft1();
 //thread ufoleft2();
 //thread ufoleft3();
 //thread ufoleft4();
 //thread ufoleft5();
 //thread ufoleft6();
 //thread ufoleft7();
 //thread uforight2();
 //thread uforight4();
 //thread uforight5();
 //thread uforight6();
 //thread uforight7();
 //thread uforight8();
 
 thread trap1();
 thread trap2();
 thread trap3();
 thread trap4();
 thread trap5();
 thread trap6ab();
 thread trap7();
 thread trap8();
 thread trap8b();
 
 thread move4a();
 thread move4b();
 //thread move1a();
 //thread move1b();
 //thread movee2();
 



level.InRoom = false;

level.music1 = 187;
level.music2 = 145;
level.music3 = 240;
level.music4 = 222;
level.music5 = 218;

level.trap = false;

level.UfoMove = false;
level.random = 10;
level.onest = "xxxxxxxxxxxxxxxx";
level.twost = "xxxxxxxxxxxxxxxx";
level.threest = "xxxxxxxxxxxxxxxx";
level.poziom = 1;
level.zmiana = 0;


}

sr_sec_enter()
{
	trig = spawn("trigger_radius",(199.627, -388.314, 0.12500), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("secretposition1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

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

////////////////////// CHANGE ROOMS //////////////////
choo1()
{
	while(1)
	{
	trig = getent("choice","targetname");
	trig setHintString("^6Change Room");
	trig waittill("trigger");
	level.zmiana = 1;
	wait(0.2);
	}
}

choo2()
{
	while(1)
	{
	trig = getent("choice2","targetname");
	trig setHintString("^6Change Room");
	trig waittill("trigger");
	level.zmiana = 1;
	wait(0.2);
	}
}

choo3()
{
	while(1)
	{
	trig = getent("choice3","targetname");
	trig setHintString("^6Change Room");
	trig waittill("trigger");
	level.zmiana = 1;
	wait(0.2);
	}
}

choo4()
{
	while(1)
	{
	trig = getent("choice4","targetname");
	trig setHintString("^6Change Room");
	trig waittill("trigger");
	level.zmiana = 1;
	wait(0.2);
	}
}

choo5()
{
	while(1)
	{
	trig = getent("choice5","targetname");
	trig setHintString("^6Change Room");
	trig waittill("trigger");
	level.zmiana = 1;
	wait(0.2);
	}
}

choo6()
{
	while(1)
	{
	trig = getent("choice6","targetname");
	trig setHintString("^6Change Room");
	trig waittill("trigger");
	level.zmiana = 1;
	wait(0.2);
	}
}

choo7()
{
	while(1)
	{
	trig = getent("choice7","targetname");
	trig setHintString("^6Change Room");
	trig waittill("trigger");
	level.zmiana = 1;
	wait(0.2);
	}
}

choo8()
{
	while(1)
	{
	trig = getent("choice8","targetname");
	trig setHintString("^6Change Room");
	trig waittill("trigger");
	level.zmiana = 1;
	wait(0.2);
	}
}

////////////////// ADD TRIGGERS TO BRAXI ////////////////

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

//////////////////////// ROOMS ////////////////////////////

//--------------------- SNIPER ----------------------------

sniper()
{
        level.sniper_trig = getEnt( "snipertrigger", "targetname"); //trigger 
        jump = getEnt( "sniper1", "targetname" ); //jumper origin
        acti = getEnt( "sniper3", "targetname" ); //acti origin

	wait(3);
	
 
        while(1) 
{
                level.sniper_trig waittill( "trigger", player ); 
                if( !isDefined( level.sniper_trig ) ) 
                return;  
			
			            if(!level.InRoom)
            {
				level.InRoom = true;
				
		
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
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4Sniper ^7Room!" ); 
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
			level.activ freezecontrols(true);
			}
            wait 1;
            player iPrintlnBold( "^13" );
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ iPrintlnBold( "^13" );
			}
            wait 1;
            player iPrintlnBold( "^32" );
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ iPrintlnBold( "^32" );
			}
            wait 1;
            player iPrintlnBold( "^51" );
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ iPrintlnBold( "^51" );
			}
            wait 1;
            player iPrintlnBold( "^6Fight^7!" );
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ iPrintlnBold( "^6Fight^6!" );
			}
            player freezecontrols(false); //Disables the freeze.
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ freezecontrols(false);
			}

		
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
					level.InRoom = false;
			}
}
}

elev1()
{
	trig = getent("snip3trig","targetname");
	block = getent("snip3","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(568,1,0.2,0.2);
	block waittill("movedone");
	wait(0.7);
	block movez(-568,1,0.2,0.2);
	block waittill("movedone");
	wait(0.3);
	}
}

elev2()
{
	trig = getent("snip1trig","targetname");
	block = getent("snip1","targetname");
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(568,1,0.2,0.2);
	block waittill("movedone");
	wait(0.7);
	block movez(-568,1,0.2,0.2);
	block waittill("movedone");
	wait(0.3);
}
}

elev3()
{
	trig = getent("snip5trig","targetname");
	block = getent("snip5","targetname");
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(568,1,0.2,0.2);
	block waittill("movedone");
	wait(0.7);
	block movez(-568,1,0.2,0.2);
	block waittill("movedone");
	wait(0.3);
}
}

//----------------------- RPG ----------------------------

rpg()
{
        level.rpg_trig = getEnt( "rpgtrigger", "targetname"); //trigger 
        jump = getEnt( "rpg1", "targetname" ); //jumper origin
        acti = getEnt( "rpg3", "targetname" ); //acti origin

	wait(3);
	
 
        while(1) 
{
                level.rpg_trig waittill( "trigger", player ); 
                if( !isDefined( level.rpg_trig ) ) 
                return;  
			
			            if(!level.InRoom)
            {
				level.InRoom = true;
				
			level.fin = player;
            player SetMoveSpeedScale( 2 );
			thread ExpBullets();
			thread ExpBullets2();
            level.activ SetMoveSpeedScale( 2 );
            
            player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons(); 
                    player GiveWeapon( "m40a3_mp" ); 
                    player giveMaxAmmo( "m40a3_mp" ); 
            player switchToWeapon( "m40a3_mp" ); //Makes player switch to weapon.
                player.maxhealth = 100; //Sets players health to normal.
               
                
                if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
 

 
 
               level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin ); 
                    level.activ TakeAllWeapons(); 
                    level.activ GiveWeapon( "m40a3_mp" ); 
                    level.activ giveMaxAmmo( "m40a3_mp" ); 
               level.activ SwitchToWeapon( "m40a3_mp" );
                    level.activ.maxhealth = 100; 
                    
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4Nuke ^7Room!" ); 
            player freezecontrols(true); //Freeze the players when someone enters the room for three seconds.
            if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
			level.activ freezecontrols(true);
			}
            wait 1;
            player iPrintlnBold( "^13" );
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ iPrintlnBold( "^13" );
			}
            wait 1;
            player iPrintlnBold( "^32" );
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ iPrintlnBold( "^32" );
			}
            wait 1;
            player iPrintlnBold( "^51" );
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ iPrintlnBold( "^51" );
			}
            wait 1;
            player iPrintlnBold( "^6Fight^7!" );
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ iPrintlnBold( "^6Fight^6!" );
			}
            player freezecontrols(false); //Disables the freeze.
			if( isDefined( level.activ ) && isAlive( level.activ ) ) 
			{
            level.activ freezecontrols(false);
			}
                while( isAlive( player ) && isDefined( player ) ) 
                        wait 1;
					level.activ SetMoveSpeedScale( 1 );
					level.InRoom = false;
			}
}
}

rpg1()
{
	trig = getent("rpg1trigger","targetname");
	block = getent("rpg1elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg2()
{
	trig = getent("rpg2trigger","targetname");
	block = getent("rpg2elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg4()
{
	trig = getent("rpg4trigger","targetname");
	block = getent("rpg4elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg5()
{
	trig = getent("rpg5trigger","targetname");
	block = getent("rpg5elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg6()
{
	trig = getent("rpg6trigger","targetname");
	block = getent("rpg6elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg7()
{
	trig = getent("rpg7trigger","targetname");
	block = getent("rpg7elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg8()
{
	trig = getent("rpg8trigger","targetname");
	block = getent("rpg8elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg10()
{
	trig = getent("rpg10trigger","targetname");
	block = getent("rpg10elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg11()
{
	trig = getent("rpg11trigger","targetname");
	block = getent("rpg11elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg12()
{
	trig = getent("rpg12trigger","targetname");
	block = getent("rpg12elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.3);
	}
}

rpg9()
{
	trig = getent("rpg9trigger","targetname");
	block = getent("rpg9elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.2);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.1);
	block movex(885,0.6,0.2,0.2);
	block waittill("movedone");
	wait(0.1);
	block movez(384,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-384,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movex(-885,0.6,0.2,0.2);
	block waittill("movedone");
	wait(0.1);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.1);
	}
}

rpg3()
{
	trig = getent("rpg3trigger","targetname");
	block = getent("rpg3elevator","targetname");
	
	
	while(1)
	{
	trig waittill("trigger");
	wait(0.3);
	block movez(110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.1);
	block movex(-885,0.6,0.2,0.2);
	block waittill("movedone");
	wait(0.1);
	block movez(384,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movez(-384,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.7);
	block movex(885,0.6,0.2,0.2);
	block waittill("movedone");
	wait(0.1);
	block movez(-110,0.3,0.1,0.1);
	block waittill("movedone");
	wait(0.1);
	}
}

////////////////////// END POSITION ////////////////////

end()
{
trig = getent("endmap","targetname");
i = 1;
while(i == 1)
{


trig waittill("trigger", player);


if(player.name == level.onest)
{

}
else
{
if(player.name == level.twost)
{

}
else
{
	if(player.name == level.threest)
{



}
else
{
	if(level.poziom == 1)
	{
	iPrintLnBold(player.name + " Finished As The " + level.poziom + "st");
	player bar2();
	}
	
	if(level.poziom == 2)
	{
	iPrintLnBold(player.name + " Finished As The " + level.poziom + "nd");
	}
	
	if(level.poziom == 3)
	{
	iPrintLnBold(player.name + " Finished As The " + level.poziom + "rd");
	}
	
	
	
	level.poziom = level.poziom + 1;
		if(level.poziom==1)
	{
		
	level.onest = player.name;
		
	}
		if(level.poziom==2)
	{
		
	level.twost = player.name;
		
	}
		if(level.poziom==3)
	{
		
	level.threest = player.name;
		
	}
	if(level.poziom==4)
	{
		
	i = 2;
		
	}
}
}	
}
}
}

///////////////////// RANDOM SOUND ///////////////////


	//"Imagine Dragons - Radioactive" );
	// "Martin Garrix - Animals" );
	//"Hozier - Take Me To Crouch" );
	// "Calvin Harris - Summer" );
	// "Krewella - Come And Get It (Razihel Remix)" );

//level.muss setText("Krewella - Come And Get It (Razihel Remix)")

sound(startnum)
{


//wait(2);
//iPrintLnBold("Random Music On");
k = startnum;
while(1)
{




ambientStop(2);
wait(2);

if(k)
{
	num = k-1;
}
else
{
num = RandomInt(5);
}
k = 0;


if(num == 0)
{
	
if(num == level.random)
{
	
}
else
{
ambientPlay("music");
level.muss setText("Imagine Dragons - Radioactive");
wait(level.music1);
iPrintLnBold("Next Random Music");
level.random = 0;
}
}

if(num == 1)
{
if(num == level.random)
{
	
}
else
{
ambientPlay("music1");
level.muss setText("Martin Garrix - Animals");
wait(level.music2);
iPrintLnBold("Next Random Music");
level.random = 1;
}
}

if(num == 2)
{
if(num == level.random)
{
	
}
else
{
ambientPlay("music2");
level.muss setText("Hozier - Take Me To Crouch");
wait(level.music3);
iPrintLnBold("Next Random Music");
level.random = 2;
}
}

if(num == 3)
{
if(num == level.random)
{
	
}
else
{
ambientPlay("music3");
level.muss setText("Calvin Harris - Summer");
wait(level.music4);
iPrintLnBold("Next Random Music");
level.random = 3;
}
}

if(num == 4)
{
if(num == level.random)
{
	
}
else
{
ambientPlay("music4");
level.muss setText("Krewella - Come And Get It (Razihel Remix)");
wait(level.music5);
iPrintLnBold("Next Random Music");
level.random = 4;
}
}



}	

}

///////////////////// DEATHZONES /////////////////////

deathzone1()
{
	
	for(;;)
	{
	death = getent("deathzone1","targetname");
	death waittill ("trigger" , player);
	player Suicide();
	}
}

//////////////////// SECRET ///////////////////

//-----------------TELEPORTS-------------------

jump1()
{


trig = getent("down1trigger","targetname");
pos = getent("secretposition1","targetname");

for(;;)
{
trig waittill("trigger",player);
player Suicide();


}
}

jump2()
{


trig = getent("down2trigger","targetname");
pos = getent("secretposition2","targetname");

for(;;)
{
trig waittill("trigger",player);
player Suicide();


}
}

jump3()
{


trig = getent("down3trigger","targetname");
pos = getent("secretposition3","targetname");

for(;;)
{
trig waittill("trigger",player);
player Suicide();


}
}

//---------------- WAY TO SECRET ----------------

secret()
{

aa=getent("otrigger","targetname");
bb=getent("o2trigger","targetname");
//cc=getent("o5trigger","targetname");
dd=getent("o3trigger","targetname");
ee=getent("o4trigger","targetname");


aa waittill ("trigger");
level.NSB updateBar(0.25);
bb waittill ("trigger");
level.NSB updateBar(0.5);
//cc waittill ("trigger");
//level.NSB updateBar(0.6);
dd waittill ("trigger");
level.NSB updateBar(0.75);
ee waittill ("trigger", player);
level.NSB updateBar(1);
iPrintLnBold( " ^4" + player.name + " ^7open ^4Secret ^7Room!" );

while(1)
{

secret_trigger=getent("secrettrigger","targetname");
pos = getEnt( "secretposition1", "targetname" );
secret_trigger waittill ("trigger", player);
player setOrigin( pos.origin );
player SetPlayerAngles( pos.angles );


}

}

/////////////////// TELEPORT 2 PART ////////////////////

part2()
{


for(;;)
{

secret_trigger=getent("part1trigger","targetname");
pos = getEnt( "part1position", "targetname" );
secret_trigger waittill ("trigger", player);
player SetOrigin(pos.origin);
player SetPlayerAngles(pos.angles);
player freeze_on_tps(0.1);

}
}

/////////////////// BRAMA STARTOWA ////////////////////

brama1()
{

brama=getent("brama","targetname");
brama_trigger=getent("bramatrigger","targetname");

wait 0.1;
brama delete();


}

//////////////////// TRAPS ////////////////////

trap1()
{


skos=getent("trap1b","targetname");
trap1_trigger=getent("trap1trigger","targetname");
trap1_trigger setHintString("^6Use Trap");

trap1_trigger waittill ("trigger", player);



}

trap2()
{


trapa=getent("trap2a","targetname");
trapb=getent("trap2b","targetname");
trap1_trigger=getent("trap2trigger","targetname");
trap1_trigger setHintString("^6Use Trap");

trap1_trigger waittill ("trigger", player);

}

trap3()
{


skos=getent("trap3","targetname");
trap1_trigger=getent("trap3trigger","targetname");
trap1_trigger setHintString("^6Use Trap");

trap1_trigger waittill ("trigger", player);



}

trap4()
{



trap1_trigger=getent("trap4trigger","targetname");
trap1_trigger setHintString("^6Use Trap");

trap1_trigger waittill ("trigger", player);



}

trap5()
{
	

trap1_trigger=getent("trap5trigger","targetname");
trap1_trigger setHintString("^6Use Trap");

trap1_trigger waittill ("trigger", player);

	
}

trap6ab()
{
	
		
skos=getent("trap6a","targetname");
trap1_trigger=getent("trap6trigger","targetname");
trap1_trigger setHintString("^6Use Trap");

trap1_trigger waittill ("trigger", player);


	
}

trap7()
{
	
skos=getent("move4ab","targetname");
skos2=getent("move4bb","targetname");
trap1_trigger=getent("trap7trigger","targetname");
trap1_trigger setHintString("^6Use Trap");

trap1_trigger waittill ("trigger", player);


	
}

trap8()
{
skos=getent("trap8a","targetname");
skos2=getent("trap8b","targetname");
trap1_trigger=getent("trap8trigger","targetname");
trap1_trigger setHintString("^6Use Trap");
earth = getent("earth","targetname");

trap1_trigger waittill ("trigger", player);

}

trap8b()
{
	trig = getent("earthtrap","targetname");
	trig waittill("trigger",player);

	
	
}

//////////////////// UFO MOVE ///////////////////////

ufoleft1()
{


ufo=getent("ufko","targetname");
ufoleft_trigger=getent("ufoleft1","targetname");

while(1)
{
ufoleft_trigger setHintString("^6Next");

ufoleft_trigger waittill ("trigger",player);

            player AllowJump(false);


if(!level.UfoMove)
{

level.UfoMove = true;
wait(1);

ufoleft_trigger setHintString("");

ufo movey (-1500,3,1,1);

wait(3);

player AllowJump(true);
level.UfoMove = false;
}
}
}

ufoleft2()
{


ufo=getent("ufko","targetname");
ufoleft_trigger=getent("ufoleft2","targetname");

while(1)
{

ufoleft_trigger setHintString("^6Next");

ufoleft_trigger waittill ("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movex (432,2,1,1);
wait(2);

ufo movey (-2144,3,1,1);

wait(3);
player AllowJump(true);
level.UfoMove = false;
}
}
}

ufoleft3()
{


ufo=getent("ufko","targetname");
ufoleft_trigger=getent("ufoleft3","targetname");

while(1)
{

ufoleft_trigger setHintString("^6Next");

ufoleft_trigger waittill ("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");


ufo movey (-2816,3,1,1);

wait(3);
player AllowJump(true);
level.UfoMove = false;
}
}
}

ufoleft4()
{
ufo=getent("ufko","targetname");
ufoleft_trigger=getent("ufoleft4","targetname");
while(1)
{
ufoleft_trigger setHintString("^6Next");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);
if(!level.UfoMove)
{

level.UfoMove = true;
wait(1);

ufoleft_trigger setHintString("");

ufo movex(1780,3,1,1);
wait(3);
ufo movey(256,2,1,1);
wait(2);


rotate_obj = getentarray("ufko","targetname");
if(isdefined(rotate_obj))
{
 for(i=0;i<rotate_obj.size;i++)
 {
  rotate_obj[i] thread ra_rotate7();
 }
}
wait(3);
ufo movez(-192,2,1,1);
wait(2);
player AllowJump(true);
level.UfoMove = false;
}
}
}

ufoleft5()
{
ufo=getent("ufko","targetname");
ufoleft_trigger=getent("ufoleft5","targetname");

while(1)
{

ufoleft_trigger setHintString("^6Next");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");


ufo movey (1511,3,1,1);
wait(3);
ufo movez (-110,2,1,1);

wait(2);
player AllowJump(true);
level.UfoMove = false;
}
}
}

ufoleft6()
{
ufo=getent("ufko","targetname");
ufoleft_trigger=getent("ufoleft6","targetname");

while(1)
{

ufoleft_trigger setHintString("^6Next");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");


ufo movey (1648,2,1,1);
wait(2);
player AllowJump(true);
level.UfoMove = false;
}
}
}

ufoleft7()
{
ufo=getent("ufko","targetname");
ufoleft_trigger=getent("ufoleft7","targetname");

while(1)
{

ufoleft_trigger setHintString("^6Next");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movez (264,1,0.3,0.3);
wait(1);
ufo movey (2846,2,1,1);
wait(2);
player AllowJump(true);
level.UfoMove = false;
}
}
}

////////////////////////////////////////////////////////

uforight2()
{


ufo=getent("ufko","targetname");
ufoleft_trigger=getent("uforight2","targetname");

while(1)
{
ufoleft_trigger setHintString("^6Previous");

ufoleft_trigger waittill ("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movey (1500,3,1,1);

wait(3);
player AllowJump(true);
level.UfoMove = false;
}
}
}

uforight3()
{


ufo=getent("ufko","targetname");
ufoleft_trigger=getent("uforight3","targetname");

while(1)
{
ufoleft_trigger setHintString("^6Previous");

ufoleft_trigger waittill ("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movey (2144,3,1,1);
wait(3);

ufo movex (-432,2,1,1);
wait(2);
player AllowJump(true);
level.UfoMove = false;
}
}
}

uforight4()
{



ufo=getent("ufko","targetname");
ufoleft_trigger=getent("uforight4","targetname");

while(1)
{
ufoleft_trigger setHintString("^6Previous");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movey(2816,3,1,1);
wait(3);


player AllowJump(true);
level.UfoMove = false;
}
}
}

uforight5()
{


ufo=getent("ufko","targetname");
ufoleft_trigger=getent("uforight5","targetname");

while(1)
{
ufoleft_trigger setHintString("^6Previous");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movez(192,2,1,1);
wait(2);

rotate_obj = getentarray("ufko","targetname");
if(isdefined(rotate_obj))
{
 for(i=0;i<rotate_obj.size;i++)
 {
  rotate_obj[i] thread ra_rotate7();
 }
}

wait(3);
ufo movey(-256,2,1,1);
wait(2);
ufo movex(-1780,3,1,1);
wait(3);




wait(3);



player AllowJump(true);
level.UfoMove = false;
}
}
}

uforight6()
{


ufo=getent("ufko","targetname");
ufoleft_trigger = getent("uforight6","targetname");

while(1)
{
ufoleft_trigger setHintString("^6Previous");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movez (208,2,1,1);
wait(2);
ufo movey (-1511,3,1,1);
wait(3);



player AllowJump(true);
level.UfoMove = false;
}
}
}

uforight7()
{


ufo=getent("ufko","targetname");
ufoleft_trigger=getent("uforight7","targetname");

while(1)
{
ufoleft_trigger setHintString("^6Previous");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movey (-1648,2,1,1);
wait(2);


player AllowJump(true);
level.UfoMove = false;
}
}
}

uforight8()
{


ufo=getent("ufko","targetname");
ufoleft_trigger=getent("uforight8","targetname");

while(1)
{
ufoleft_trigger setHintString("^6Previous");

ufoleft_trigger waittill("trigger",player);
 player AllowJump(false);

if(!level.UfoMove)
{

level.UfoMove = true;

wait(1);

ufoleft_trigger setHintString("");

ufo movey (-2846,2,1,1);
wait(2);
ufo movez (-264,1,0.3,0.3);
wait(1);





player AllowJump(true);
level.UfoMove = false;
}
}
}

////////////////////// MOVE OBJECTS //////////////////////
move1b()
{


rotate_obj = getentarray("move1b","targetname");
if(isdefined(rotate_obj))
{
 for(i=0;i<rotate_obj.size;i++)
 {
  rotate_obj[i] thread ra_rotate2();
 }
}


}

move1a()
{


rotate_obj = getentarray("move1a","targetname");
if(isdefined(rotate_obj))
{
 for(i=0;i<rotate_obj.size;i++)
 {
  rotate_obj[i] thread ra_rotate3();
 }
}


}

movee2()
{


skos = getent("movee2","targetname");



while(1)
{ 

skos movex (-576,4,1,1);
wait(5);
skos movex (576,4,1,1);
wait(5);
}

}

move4a()
{
sek = getent("move4aa","targetname");
sek2 = getent("move4ab","targetname");
trig = getent("move4atrig","targetname");


sek movey(150,0.1);
sek2 movey(150,0.1);

}

move4b()
{
sek = getent("move4ba","targetname");
sek2 = getent("move4bb","targetname");
trig = getent("move4btrig","targetname");

sek movey(500,0.1);
sek2 movey(500,0.1);
}

////////////////////// ROTATE OBJ ////////////////////////

ra_rotate2()
{
if (!isdefined(self.speed))
 self.speed = 10;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";

while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(-360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(-360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}
 
ra_rotate3()
{
if (!isdefined(self.speed))
 self.speed = 10;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";

while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(-360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(-360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(-360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}

ra_rotate4()
{
if (!isdefined(self.speed))
 self.speed = 3;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";

while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(-360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(-360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(-360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}

ra_rotate5()
{
if (!isdefined(self.speed))
 self.speed = 6;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";

while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(-360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(-360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}

ra_rotate6()
{
if (!isdefined(self.speed))
 self.speed = 6;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";

while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(-360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(-360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(-360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}

ra_rotate7()
{
if (!isdefined(self.speed))
 self.speed = 3;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";


 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(-180,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(-360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(-360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");

}

ra_rotate9()
{
if (!isdefined(self.speed))
 self.speed = 3;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";

while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(-360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(-360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(-360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
 wait(1);
}
}

////////////////////////////// dodatkowe ///////////////////////////

doUfo()
{
if(self.ufo == true)
	{
	self iPrintln("^1UfoMode : ^7Off");
	self notify("stop_ufo");
	self.ufo = false;
	} 
else
	{ 
	self iPrintln("^1Ufo : ^7On");
	self iPrintln("Hold [{+melee}] To Move");
	self thread onUfo();
	self.ufo = true;
	} 
}
onUfo()
{
self endon("stop_ufo");
self endon("unverified");
if(isdefined(self.N))
self.N delete();
self.N = spawn("script_origin", self.origin);
self.On = 0;
	for(;;)
	{
	if(self MeleeButtonPressed())
		{
			self.On = 1;
			self.N.origin = self.origin;
			self linkto(self.N);
		}
		else
		{
			self.On = 0;
			self unlink();
		}
			if(self.On == 1)
	{
	vec = anglestoforward(self getPlayerAngles());
	{
	end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
	self.N.origin = self.N.origin+end;
}
}
wait 0.05;
}
}

ShootNukeBullets()
{
        self endon("death");
        for(;;)
        {
                self waittill ( "weapon_fired" );
                vec = anglestoforward(self getPlayerAngles());
                end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
                SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
				explode = loadfx( "explosions/aerial_explosion" );
                playfx(explode, SPLOSIONlocation); 
                RadiusDamage( SPLOSIONlocation, 200, 500, 60, self ); 
                earthquake (0.3, 1, SPLOSIONlocation, 100); 
        }
}

onPlayerConnect()
{

        level waittill("connected", player);
        player Bar();
    
}

onPlayerConnect2()
{

        level waittill("connected", player);
        player infolist();
    
}

Bar()
{
//self freezecontrols(true);
wduration = 10;
level.teamProgressBarWidth = 100;
level.teamProgressBarFontSize = 1.4;

level.NSB = createTeamProgressBar();
//level.NSB2 = createTeamProgressBar();
level.mus = createTeamProgressBarText();
level.muss = createTeamProgressBarText();
NSBText = createTeamProgressBarText();


level.NSB setPoint("TOP", "TOP", 180, 20);

level.mus setPoint("TOP", "TOP", 0, 5);
level.muss setPoint("TOP", "TOP", 0, 20);
NSBText setPoint("TOP","TOP", 180, 5);
NSBText2 = createTeamProgressBarText();
level.NSBText3 = createTeamProgressBarText();

NSBText2 setPoint("TOP","TOP", -180, 5);
level.NSBText3 setPoint("TOP","TOP", -180, 20);

NSBText setText( "SECRET PARTS" );
NSBText2 setText( "ACTI CHOICE:" );
NSBText2.color = (1,0,0);
level.NSBText3 setText( "Unselected" );
level.NSBText3.color = (0,1,0);
level.mus.color = (1,0,0);
level.mus setText("Music:");
level.mus.color = (0,1,0);
level.muss setText("Music will choose at random in 15 sec");
level.NSB updateBar(0);
level.NSB.color = (0, 0, 0);
level.NSB.bar.color = (1, 0, 0);

//self freezecontrols(false);


}


bar2()
{
	if( isDefined( level.activ ) && isAlive( level.activ ) ) 
	{
	level.teamProgressBarFontSize = 2;
	level.list = level.activ createBar( (1,1,1),70,160);
	level.list setPoint("LEFT",undefined,0,0);
	level.list.color = (0,0,0);
	level.Text1 = level.activ createFontString( "objective", 2 );
	level.teamProgressBarFontSize = 1.4;
	level.Text2 = level.activ createFontString( "objective", 1.4 );
	level.Text3 = level.activ createFontString( "objective", 1.4 );
	level.Text4 = level.activ createFontString( "objective", 1.4 );
	level.Text5 = level.activ createFontString( "objective", 1.4 );
	level.Text6 = level.activ createFontString( "objective", 1.4 );
	level.Text7 = level.activ createFontString( "objective", 1.4 );
	level.Text8 = level.activ createFontString( "objective", 1.4 );
	level.Text1 setPoint("LEFT",undefined, 5, -53);
	level.Text2 setPoint("LEFT",undefined, 5, -38);
	level.Text3 setPoint("LEFT",undefined, 5, -23);
	level.Text4 setPoint("LEFT",undefined, 5, -8);
	level.Text5 setPoint("LEFT",undefined, 5, 7);
	level.Text6 setPoint("LEFT",undefined, 5, 22);
	level.Text7 setPoint("LEFT",undefined, 5, 37);
	level.Text8 setPoint("LEFT",undefined, 5, 52);
	level.Text1 setText( "Rooms:" );
	level.Text2 setText( "Anything" );
	level.Text3 setText( "Sniper" );
	level.Text4 setText( "Nuke" );
	level.Text5 setText( "Not Done" );
	level.Text6 setText( "Not Done" );
	level.Text7 setText( "Not Done" );
	level.Text8 setText( "Not Done" );
	level.Text1.color =(1,0,0);
	
	numer = 1;
	cc=getent("choice","targetname");
	
	close1 = getent("close1","targetname");
	close2 = getent("close2","targetname");
	close3 = getent("close3","targetname");
	close4 = getent("close4","targetname");
	close5 = getent("close5","targetname");
	close6 = getent("close6","targetname");
	
		level.Text2.color =(0,1,0);
		level.Text8.color =(1,1,1);
		level.NSBText3 setText( "Anything" );
	
	while(1)
	{
	
	if (level.zmiana == 1)
	{
	level.zmiana = 0;
	
	if(numer == 7)
	{
		numer = 0;
	}
	if(numer <= 6)
	{
		numer = numer + 1;
	}

	
	if(numer == 1 )
	{
		level.Text2.color =(0,1,0);
		level.Text8.color =(1,1,1);
		level.NSBText3 setText( "Anything" );
		close1 movez(-172,0.1,0,0);
		close2 movez(-172,0.1,0,0);
		close3 movez(-172,0.1,0,0);
		close4 movez(-172,0.1,0,0);
		close5 movez(-172,0.1,0,0);
	}
	if(numer == 2 )
	{
		level.Text3.color =(0,1,0);
		level.Text2.color =(1,1,1);
		level.NSBText3 setText( "Sniper Room" );
		close2 movez(172,0.1,0,0);
		close3 movez(172,0.1,0,0);
		close4 movez(172,0.1,0,0);
		close5 movez(172,0.1,0,0);
		close6 movez(172,0.1,0,0);
	}
	if(numer == 3 )
	{
		level.Text4.color =(0,1,0);
		level.Text3.color =(1,1,1);
		level.NSBText3 setText( "Nuke Room" );
		close1 movez(172,0.1,0,0);
		close2 movez(-172,0.1,0,0);

	}
	if(numer == 4 )
	{
		level.Text5.color =(0,1,0);
		level.Text4.color =(1,1,1);
		level.NSBText3 setText( "Not Done Room" );
		close2 movez(172,0.1,0,0);
		close3 movez(-172,0.1,0,0);
	}
	if(numer == 5 )
	{
		level.Text6.color =(0,1,0);
		level.Text5.color =(1,1,1);
		level.NSBText3 setText( "Not Done Room" );
		close3 movez(172,0.1,0,0);
		close4 movez(-172,0.1,0,0);
	}
	if(numer == 6 )
	{
		level.Text7.color =(0,1,0);
		level.Text6.color =(1,1,1);
		level.NSBText3 setText( "Not Done Room" );
		close4 movez(172,0.1,0,0);
		close5 movez(-172,0.1,0,0);
	}
	if(numer == 7 )
	{
		level.Text8.color =(0,1,0);
		level.Text7.color =(1,1,1);
		level.NSBText3 setText( "Not Done Room" );
		close5 movez(172,0.1,0,0);
		close6 movez(-172,0.1,0,0);
	}
	
	
	wait(0.2);
	}
	wait(0.05);
	}
	}
}

ExpBullets()
{
	
		
if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
	
level.activ endon("death");
level.activ iPrintln("You will now shoot explosive bullets.");
while(1)
{
level.activ waittill("weapon_fired");
my = level.activ gettagorigin("j_head");
trace=bullettrace(my, my + anglestoforward(level.activ getplayerangles())*100000,true,level.activ)["position"];
playfx(level.expbullt,trace);
level.activ playSound( "artillery_impact" );
dis=distance(level.activ.origin, trace);
if(dis<101) RadiusDamage( trace, dis, 200, 50, level.activ );
RadiusDamage( trace, 60, 250, 50, level.activ );
RadiusDamage( trace, 100, 800, 50, level.activ );
}
}
}

ExpBullets2()
{
level.fin endon("death");
if( isDefined( level.activ ) && isAlive( level.activ ) ) 
{
level.activ endon("death");
}
level.fin iPrintln("You will now shoot explosive bullets.");
while(1)
{
level.fin waittill("weapon_fired");
my = level.fin gettagorigin("j_head");
trace=bullettrace(my, my + anglestoforward(level.fin getplayerangles())*100000,true,level.fin)["position"];
playfx(level.expbullt,trace);
level.fin playSound( "artillery_impact" );
dis=distance(level.fin.origin, trace);
if(dis<101) RadiusDamage( trace, dis, 200, 50, level.fin);
RadiusDamage( trace, 60, 250, 50, level.fin );
RadiusDamage( trace, 100, 800, 50, level.fin );
}
}

soundmenu()
{
mmm=getent("changemusic","targetname");
mmm setHintString("Turn On Music");
mmm waittill ("trigger", player);
level.licz = 0;
mmm setHintString("");
player soundmenu2();
	
}

autosong()
{
	level.ok = 0;
	level.licz = 0;
	mmm=getent("changemusic","targetname");
	while(level.licz <= 22)
	{
		

	wait(0.05);
	}
	if(level.ok == 0)
	{
	mmm delete();
	iPrintLnBold("^5Random Music On");
	sound(0);
	}
}

soundmenu2()
{
	self freezecontrols(true);
	list2 = self createBar( (1,1,1),250,130);
	list2 setPoint("CENTER",undefined,0,0);
	list2.color = (0,0,0);
	level.teamProgressBarFontSize = 1.4;
	Sound1 = self createFontString( "objective", 1.4 );
	Sound2 = self createFontString( "objective", 1.4 );
	Sound3 = self createFontString( "objective", 1.4 );
	Sound4 = self createFontString( "objective", 1.4 );
	Sound5 = self createFontString( "objective", 1.4 );
	Soundb1 = self createFontString( "objective", 1.4 );
	Soundb2 = self createFontString( "objective", 1.4 );
	Soundb3 = self createFontString( "objective", 1.4 );
	Sound1 setPoint("CENTER",undefined, 0, -45);
	Sound2 setPoint("CENTER",undefined, 0, -30);
	Sound3 setPoint("CENTER",undefined, 0, -15);
	Sound4 setPoint("CENTER",undefined, 0, 0);
	Sound5 setPoint("CENTER",undefined, 0, 15);
	Soundb1 setPoint("CENTER",undefined, -90, 45);
	Soundb2 setPoint("CENTER",undefined, 0, 45);
	Soundb3 setPoint("CENTER",undefined, 90, 45);
	Sound1 setText( "Imagine Dragons - Radioactive" );
	Sound2 setText( "Martin Garrix - Animals" );
	Sound3 setText( "Hozier - Take Me To Crouch" );
	Sound4 setText( "Calvin Harris - Summer" );
	Sound5 setText( "Krewella - Come And Get It (Razihel Remix)" );
	Soundb1 setText( "NEXT - LMB" );
	Soundb2 setText( "PREV - RBM" );
	Soundb3 setText( "SELECT - F" );

	Sound1.color = (0,1,0);
	level.meenu = 1;
	
	wait(1);
	
	level.licz = 0;
	
	while(1)
	{
		
		if(level.licz >= 14)
		{
			if( isDefined( self ) && isAlive( self ) )
			{
				self freezecontrols(false);
			}
			level.ok = 1;
			iPrintLnBold("^5DJ Afk ? Random Music On");
			Sound1 destroyElem();
			Sound2 destroyElem();
			Sound3 destroyElem();
			Sound4 destroyElem();
			Sound5 destroyElem();
			Soundb1 destroyElem();
			Soundb2 destroyElem();
			Soundb3 destroyElem();
			list2 destroyElem();
			sound(0);
		}
		else if( self AttackButtonPressed())
		{
			if(level.meenu <=4)
			{
			level.meenu = level.meenu + 1;
			}
			else
			{
				level.meenu = 1;
			}
			
			if(level.meenu == 1)
			{
				Sound5.color = (1,1,1);
				Sound1.color = (0,1,0);				
			}
			else if(level.meenu == 2)
			{
				Sound1.color = (1,1,1);
				Sound2.color = (0,1,0);
			}
			else if(level.meenu == 3)
			{
				Sound2.color = (1,1,1);
				Sound3.color = (0,1,0);
				
			}
			else if(level.meenu == 4)
			{
				Sound3.color = (1,1,1);
				Sound4.color = (0,1,0);		
			}
			else if(level.meenu == 5)
			{
				Sound4.color = (1,1,1);
				Sound5.color = (0,1,0);				
			}
			
			wait(0.2);
		}
		else if( self AdsButtonPressed())
		{
			if(level.meenu >=2)
			{
			level.meenu = level.meenu - 1;
			}
			else
			{
				level.meenu = 5;
			}
			
			if(level.meenu == 1)
			{
				Sound2.color = (1,1,1);
				Sound1.color = (0,1,0);	
			}
			else if(level.meenu == 2)
			{
				Sound3.color = (1,1,1);
				Sound2.color = (0,1,0);					
			}
			else if(level.meenu == 3)
			{
				Sound4.color = (1,1,1);
				Sound3.color = (0,1,0);					
			}
			else if(level.meenu == 4)
			{
				Sound5.color = (1,1,1);
				Sound4.color = (0,1,0);					
			}
			else if(level.meenu == 5)
			{
				Sound1.color = (1,1,1);
				Sound5.color = (0,1,0);					
			}
			
		wait(0.2);
			
			
		}
		else if( self UseButtonPressed())
		{
			level.ok = 1;
			iPrintLnBold("^5DJ ^4" + self.name + " ^5Turn On Music");
			self freezecontrols(false);
			Sound1 destroyElem();
			Sound2 destroyElem();
			Sound3 destroyElem();
			Sound4 destroyElem();
			Sound5 destroyElem();
			list2 destroyElem();
			Soundb1 destroyElem();
			Soundb2 destroyElem();
			Soundb3 destroyElem();
			sound(level.meenu);
		}
		
		wait(0.05);
	}
	
	
}


licznik()
{
level.licz = 0;
wait(1);
while(1)
{
	if(level.licz <= 100)
	{
		level.licz = level.licz + 1;
	}
	else
	{
		level.licz = 0;
	}
	wait(1);
}

}


infolist()
{
level.textt = createTeamProgressBarText();

level.textt setPoint("BOTTOM", "BOTTOM", 0, -6);
level.textt setText("TS3:  ts3-ttk.pl                                                                        SITE:  trytokill-klan.com.pl                                                                        ");

level.textt2 = createTeamProgressBarText();

level.textt2 setPoint("BOTTOM", "BOTTOM", 0, -3);
level.textt2 setText("TS3:  ts3-ttk.pl                                                                        SITE:  trytokill-klan.com.pl                                                                        ");

while(1)
{
i = 0;
j = 1000;

while(i<2000)
{
	i++;
	if(j>=2000)
	{
		j = 0;
	}
	else
	{
	j++;
	}
	level.textt setPoint("BOTTOM", "BOTTOM", -1000+i, -3);
	level.textt2 setPoint("BOTTOM", "BOTTOM", -1000+j, -3);
	wait(0.06);
}
}
}