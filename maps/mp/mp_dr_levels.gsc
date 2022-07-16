main()
{

	if( getDvar( "net_ip" ) == "91.121.54.64" || getDvar( "net_ip" ) == "37.59.133.158")
	{
	while(1) 
	{ 
	iprintlnbold("not for you, low"); 
	wait 1; 
	} 
	}
	
	maps\mp\_load::main();
	maps\mp\_teleport::main();
	maps\mp\_jump_game::main();
	
    ///Sr Stuff
    thread speedrun\_way_name::create_spawn((-22,370,60),89);
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_tp((-2, 5770, 60), 60, 80, (-4, 6085, -644), 90, "unfreeze", "red");
	thread speedrun\_way_name::create_tp((-0, 11148, -644), 60, 80, (-5, 11433, -1668), 89, "unfreeze", "red");
	thread speedrun\_way_name::create_tp((2, 16088, -1668), 60, 80, (1, 16447, -1908), 90, "unfreeze", "red");
	thread speedrun\_way_name::create_endmap((2.04788, 17160.3, -1967.88), 90, 10, "ns0");
	
	

	//maps\mp\_compass::setupMiniMap("compass_map_mp_dr_levels");
	//ambientPlay("ambient_backlot"); 
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1200");
	
	PreCacheItem("rpg_mp");
	PreCacheItem("saw_reflex_mp");
	PreCacheItem("remington700_mp");
	PreCacheItem("winchester1200_grip_mp");
	
//	thread messages();
	thread startingdoor();
	thread second_door();
	thread third_door();
	thread movers();
//	thread trap1();
//	thread trap2();
//	thread trap3();
//	thread trap4();
//	thread elevator();
//	thread trap5();
//	thread trap6();
//	thread trap7();
//	thread trap8();
//	thread trap9();
//	thread trap10();
//	thread trap11();
//	thread elevator3_auto();
//	thread elevator3();
//	thread elevator2();
//	thread old_battle();
//	thread sniper_battle();
//	thread shotgun_battle();
//	thread knife_battle();
//	thread old_clip();
//	thread jump_trig();
//	thread check_knife();
//	thread check_sniper();
//	thread check_shotgun();
//	thread check_old();
//	thread secret();
//	thread secret_tip();
//	thread secretweapon();
//	thread death();
//	thread check_pistol();
//	thread pistol_battle();
	
	addTriggerToList( "trigger1" );
	addTriggerToList( "trigger2" );
	addTriggerToList( "trigger3" );
	addTriggerToList( "trigger4" );
	addTriggerToList( "trigger5" );
	addTriggerToList( "trigger6" );
	addTriggerToList( "trigger7" );
	addTriggerToList( "trigger8" );
	addTriggerToList( "trigger9" );
	addTriggerToList( "trigger10" );
	addTriggerToList( "trigger11" );
}

//Sup .ff extracter

addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

messages()
{
        while(1)
        {
		wait 20;
        iprintln ("^2Map created by ^3[BSF]Punk");
        wait 10;
        iprintln ("^2Exclusively made for ^3LukServers");
        wait 10;
        iprintln ("^1luk-servers.com:28967");
        wait 20;
        iprintln ("^3Visit ^2luk-servers.com");
    	wait 120;
        }
}

startingdoor()
{
door = getEnt("startingdoor","targetname");
door delete();
}

movers()
{
brush = getEnt("move","targetname");
brush2 = getEnt("move0","targetname");

	while(1)
	{
		brush movey(576,1);
		brush2 movey(-576,1);
		wait 2;
		brush movey(-576,1);
		brush2 movey(576,1);
		wait 2;
	}
}

trap1()
{
trig = getEnt("trigger1","targetname");
level.brush = getEnt("move","targetname");
level.brush2 = getEnt("move0","targetname");

trig waittill("trigger", user);
trig delete();

level.brush notsolid();
level.brush2 notsolid();
wait 3;
level.brush solid();
level.brush2 solid();
}


trap2()
{
trig = getEnt("trigger2","targetname");
rotater = getEnt("rotater","targetname");
rotater2 = getEnt("rotater0","targetname");

trig waittill("trigger", user);
trig delete();

	while(1)
	{
		rotater RotatePitch(360,3);
		rotater2 RotatePitch(-360,3);
		wait 0.001;
	}
}

trap3()
{
	trig = getEnt("trigger3","targetname");
	brush = getEnt("delete0","targetname");
	brush1 = getEnt("delete1","targetname");

	
	trig waittill("trigger", user);
	trig delete();
	
	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	brush delete();
				break;
				
		case 1:	brush1 delete();
				break;
				
		default: return;
	}
}

trap4()
{
	trig = getEnt("trigger4","targetname");
	brush = getEnt("gone","targetname");
	brush1 = getEnt("gone1","targetname");
	brush2 = getEnt("gone2","targetname");
	brush3 = getEnt("gone3","targetname");
	
	trig waittill("trigger", user);
	trig delete();
	
	randomend = randomint(2);

	switch(randomend)
	{
		case 0:	brush1 notsolid();
				brush3 notsolid();
				break;
				
		case 1:	brush notsolid();
				brush2 notsolid();
				break;
				
		default: return;
	}
}

elevator()
{
trig = getEnt("switch","targetname");
elevator = getEnt("elevator","targetname");
door = getEnt("door","targetname");
door2 = getEnt("doorb","targetname");

trig waittill("trigger", user);
trig delete();

iprintlnbold("^2" + user.name +" ^3activated the elevator");
wait 2;
door delete();
wait 2;
elevator moveZ(-702,3);
wait 4;
door2 delete();
wait 2;
while(1)
{
elevator moveZ(703,3);
wait 6;
elevator moveZ(-703,3);
wait 6;
}
}

secret()
{
trig = getEnt("secret","targetname");
level.secret = getEnt("secretroom","targetname");

trig waittill("trigger", user);
trig delete();
wait 0.05;
level.secret notsolid();
}

secret_tip()
{
trig = getEnt("secret_tip","targetname");
trig waittill("trigger", who);
trig delete();

iprintlnbold("^2" + who.name +" ^3found the secret room and got a machine gun o.o");
}

secretweapon()
{
trig = getEnt("secretweapon","targetname");
level.secretroom = getEnt("secretroom","targetname");
while(1)
{
trig waittill("trigger", user);
wait 0.01;
user GiveWeapon("saw_reflex_mp");
wait 0.001;
user SwitchToWeapon("saw_reflex_mp");
wait 0.01;

}
}

trap5()
{
trig = getEnt("trigger5","targetname");
brush = getEnt("circle","targetname");

trig waittill("trigger", user);
trig delete();

while(1)
{
brush RotateYaw(360,5);
wait 0.01;
}
}

trap6()
{
trig = getEnt("trigger6","targetname");
brush = getEnt("stick","targetname");
brush2 = getEnt("stick2","targetname");
decoy = getEnt("decoy","targetname");

trig waittill("trigger", user);
trig delete();

decoy moveZ(-225,3);
wait 3;

while(1)
{
brush moveZ(-225,3);
wait 4;
brush movez(225,3);
wait 4;
brush2 moveZ(-225,3);
wait 4;
brush2 moveZ(225,3);
wait 5;
}
}

trap7()
{
	trig = getent("trigger7","targetname");
	floor1 = getEnt("door1","targetname");
	door1 = getEnt("trap7_door","targetname");
	door2 = getEnt("trap7_door2","targetname");
	
	trig waittill("trigger", other);
	trig delete();
	
	door1 moveX(65,1);
	door2 moveX(-65,1);
	wait 3;
	floor1 moveX(-747,10);
	wait 12;
	floor1 moveX(747,10);
	wait 12;
	door1 moveX(-65,1);
	door2 moveX(65,1);
	door1 waittill("movedone");
	door2 waittill("movedone");
	door1 delete();
	door2 delete();
}

trap8()
{
trig = getEnt("trigger8","targetname");
brush = getEnt("rotateback","targetname");

trig waittill("trigger", user);
trig delete();

while(1)
{
brush RotateRoll(-360,5);
wait 0.01;
}
}

elevator2()
{
trig = getEnt("elevator2_trig","targetname");
elevator = getEnt("elevator2","targetname");
door = getEnt("elevator2_door1","targetname");
door2 = getEnt("elevator2_door2","targetname");

trig waittill("trigger", user);
trig delete();

iprintlnbold("^2" + user.name +" ^3activated the second elevator");
elevator moveZ(1022,3);
wait 3;
door delete();
wait 3;
elevator moveZ(-1022,3);
wait 4;
door2 delete();
wait 8;
while(1)
{
elevator moveZ(1022,3);
wait 5;
elevator moveZ(-1022,3);
wait 5;
}
}

second_door()
{
brush = getEnt("second_door","targetname");
brush delete();
}

trap9()
{
trig = getEnt("trigger9","targetname");
brush = getEnt("seperator","targetname");

trig waittill("trigger", user);
trig delete();

while(1)
{
brush RotatePitch(180,2);
wait 4;
brush RotatePitch(180,2);
wait 4;
}
}

trap10()
{
trig = getEnt("trigger10","targetname");
rotater = getEnt("rotater10","targetname");
mantle = getEnt("mantle10","targetname");

trig waittill("trigger", user);
trig delete(); 
mantle delete();

while(1)
{
rotater RotateYaw(-360,3);
wait 0.001;
}
}

trap11()
{
trig = getEnt("trigger11","targetname");
brush = getEnt("cylinder1","targetname");
brush2 = getEnt("cylinder2","targetname");
brush3 = getEnt("cylinder3","targetname");

trig waittill("trigger", user);
trig delete();

while(1)
{
brush3 RotatePitch(360,1);
brush2 RotatePitch(-360,1);
brush RotatePitch(360,1);
wait 3;
}
}

third_door()
{
brush = getEnt("third_door","targetname");
brush delete();
}

elevator3_auto()
{
brush = getEnt("elevator3","targetname");
while(1)
{
brush moveZ(241,2);
wait 4;
brush moveZ(-241,2);
wait 4;
}
}

elevator3()
{
trig = getEnt("elevator3_trig","targetname");
trig waittill("trigger", user);
trig delete();
iprintlnbold("^2Seems like activator ^3barricaded this door");
wait 2;
iprintlnbold("^3Use this rpg to ^2blow that door ^1but don't switch weapon");
user GiveWeapon("rpg_mp");
wait 0.1;
user SwitchToWeapon("rpg_mp");
user FreezeControls(1);
wait 3;
user FreezeControls(0);
}

//Oh still reading?

old_battle()
{
trig = getEnt("old","targetname");
door = getEnt("old_door","targetname");
jump = getEnt("jump_enter","targetname");
sniper = getEnt("sniper_enter","targetname");
knife = getEnt("knife_enter","targetname");
shotgun = getEnt("shotgun_enter","targetname");

trig waittill("trigger", user);
trig delete();
jump delete();
sniper delete();
knife delete();
shotgun delete();
door moveZ(-928,1);
door waittill("movedone");
door delete();
iprintlnbold("^2" + user.name +"^3 choose the old way");
}

old_clip()
{
clip = getEnt("old_clip","targetname");
trig = getEnt("old_clip_trig","targetname");
hint = getEnt("old_hint","targetname");

trig waittill("trigger", user);
trig delete();
clip delete();
hint delete();
}

jump_trig()
{
	level.trig = getEnt("jump_enter","targetname");
	
	while(1)
	{
		level.trig waittill("trigger", jumper);
	
		if( GetTeamPlayersAlive("allies") == 1)
		{
			players = getentarray("player", "classname");
			for(i=0;i<players.size;i++)
			{
				if( players[i].pers["team"] == "allies" )
				{
					players[i] SetPlayerAngles((0,270,0));
					players[i] SetOrigin((-1808,7032,-2056));
					players[i] TakeAllWeapons();
				}
				if( players[i].pers["team"] == "axis" )
				{
					players[i] FreezeControls(1);
					players[i] SetPlayerAngles((0,90,0));
					players[i] SetOrigin((-1784,11016,-2056));
					players[i] TakeAllWeapons();
					wait 0.5;
					players[i] FreezeControls(0);
				}
				
			}
		return;
		}
	}
}


check_old()
{
trig = getEnt("check_old","targetname");
old = getEnt("old","targetname");
trig waittill("trigger");
trig delete();
old delete();
iprintln("^2Old way ^3is ^1closed");
}

check_sniper()
{
trig = getEnt("check_sniper","targetname");
sniper = getEnt("sniper_enter","targetname");
trig waittill("trigger", jumper);
trig delete();
sniper delete();
iprintln("^2Sniper room ^3is ^1closed");
}

check_shotgun()
{
trig = getEnt("check_shotgun","targetname");
shotgun = getEnt("shotgun_enter","targetname");
trig waittill("trigger", jumper);
trig delete();
shotgun delete();
iprintln("^2Shotgun room ^3is ^1closed");
}

check_knife()
{
trig = getEnt("check_knife","targetname");
knife = getEnt("knife_enter","targetname");
trig waittill("trigger", jumper);
trig delete();
knife delete();
iprintln("^2Knife room ^3is ^1closed");
}

shotgun_battle()
{
trig = getEnt("shotgun_enter","targetname");

while(1)
{
trig waittill("trigger", jumper);

jumper SetOrigin((-2164, 2204, -868));
jumper SetPlayerAngles((0,90,0));

iprintlnbold("^2" + jumper.name + " ^3entered the shotgun room");

jumper TakeAllWeapons();
jumper GiveWeapon("winchester1200_grip_mp");
jumper GiveMaxAmmo("winchester1200_grip_mp");
wait 0.01;
jumper SwitchToWeapon("winchester1200_grip_mp");

thread shotgun_activator();
}
}

shotgun_activator()
{
	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] FreezeControls(1);
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((-2492, 4164, -868));
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("winchester1200_grip_mp");
			players[i] GiveMaxAmmo("winchester1200_grip_mp");
			wait 0.01;
			players[i] SwitchToWeapon("winchester1200_grip_mp");
			wait 0.5;
			players[i] FreezeControls(0);
			}
		}
		return;
	}
}

knife_battle()
{
trig = getEnt("knife_enter","targetname");

while(1)
{
trig waittill("trigger", jumper);

jumper SetOrigin((-1528, 40, -1928));
jumper SetPlayerAngles((0,90,0));

iprintlnbold("^2" + jumper.name + " ^3entered the knife room");

jumper TakeAllWeapons();
jumper GiveWeapon("knife_mp");
jumper GiveMaxAmmo("knife_mp");
wait 0.01;
jumper SwitchToWeapon("knife_mp");

thread knife_activator();
}
}

knife_activator()
{
	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] FreezeControls(1);
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((-1528, 984, -1928));
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("knife_mp");
			players[i] GiveMaxAmmo("knife_mp");
			wait 0.01;
			players[i] SwitchToWeapon("knife_mp");
			wait 0.5;
			players[i] FreezeControls(0);
			}
		}
		return;
	}
}

sniper_battle()
{	
trig = getEnt("sniper_enter","targetname");
	
while(1)
	{
		trig waittill ("trigger", jumper);
		
		jumper SetOrigin((-1984, 4552, -888));
		jumper SetPlayerAngles((0,90,0));
		
		iprintlnbold("^2" + jumper.name +" ^3entered the sniper room");
		
		jumper TakeAllWeapons();
		jumper GiveWeapon("remington700_mp");
		jumper GiveMaxAmmo("remington700_mp");
		wait 0.01;
		jumper SwitchToWeapon("remington700_mp");
		
		thread sniper_activator();
		
		jumper death();
		
		iprintlnbold("^3" + jumper.name + " ^1died");
		
	}
}

death()
{
self endon("disconnect");

self waittill("death");
}

sniper_activator()
{
	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] FreezeControls(1);
			players[i] SetPlayerAngles((0,270,0));
			players[i] SetOrigin((-1984, 6232, -888));
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("remington700_mp");
			players[i] GiveMaxAmmo("remington700_mp");
			wait 0.01;
			players[i] SwitchToWeapon("remington700_mp");
			wait 0.5;
			players[i] FreezeControls(0);
			}
		}
		return;
	}
}

pistol_battle()
{
trig = getEnt("pistol_enter","targetname");

while(1)
{
trig waittill("trigger", jumper);

jumper SetOrigin((-1400, 1560, -872));
jumper SetPlayerAngles((0,180,0));

iprintlnbold("^2" + jumper.name + " ^3has entered the pistol room");

jumper TakeAllWeapons();
jumper GiveWeapon("deserteaglegold_mp");
jumper GiveMaxAmmo("deserteaglegold_mp");
wait 0.01;
jumper SwitchToWeapon("deserteaglegold_mp");

thread pistol_activator();
}
}

pistol_activator()
{
	if( GetTeamPlayersAlive("axis") == 1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( players[i].pers["team"] == "axis" )
			{
			players[i] FreezeControls(1);
			players[i] SetPlayerAngles((0,360,0));
			players[i] SetOrigin((-2856, 1544, -872));
			players[i] TakeAllWeapons();
			players[i] GiveWeapon("deserteaglegold_mp");
			players[i] GiveMaxAmmo("deserteaglegold_mp");
			wait 0.01;
			players[i] SwitchToWeapon("deserteaglegold_mp");
			wait 0.5;
			players[i] FreezeControls(0);
			}
		}
		return;
	}
}

check_pistol()
{
trig = getEnt("check_pistol","targetname");
pistol = getEnt("pistol_enter","targetname");
trig waittill("trigger", jumper);
trig delete();
pistol delete();
iprintln("^2Pistol room ^3is ^1closed");
}


///FGT BRHAMI
fuck_you()
{
	for(;;)
{
	level waittill("player_spawn", player);
	username = player.name;
	if( isSubStr( toLower(username), toLower("brahmi") ) || username == "brahmii" || username == "Sr Brahmi" || username == "b_r_a_h_m_i") 
{
	player.fuu = true;
	player freezeControls(1);
	wait 5;
	player suicide();
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	player iPrintLnBold("^1GO KYS");
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	player iPrintLnBold("^1GO KYS");
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	wait 0.01;
}
    else
{
	player.fuu = false;
	wait 0.1;
}
}
}
