/*
mp_dr_owl Script (Fixed by Blade) - Please ask me if you want to use this (xFire: bladetk17) c:
*/
main()
{
    maps\mp\_load::main();
	
	//ambientPlay("owlsong");


	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";


	thread sr\api\_map::createSpawn((526, 92, -544), 0);
    thread sr\api\_speedrun::createNormalWays("Normal Way");

	
	//thread printCredits();
	//thread secret();
	//thread creator();
	//thread credits();
	thread startdoor();
	//thread music();
	//thread sniperroom();
	//thread kniferoom();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();

	addTriggerToList( "trap1_trig" );
	addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
	addTriggerToList( "trap4_trig" );
	addTriggerToList( "trap5_trig" );
}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


secret()
{
	trigger = getEnt("secret", "targetname");
	object = getEnt("dooropen", "targetname");
	trigger waittill ("trigger" , player );
	player iprintlnbold ("^7You got ^1useless ^7Activator ^1Weapon");
	wait(0.5);
	player giveWeapon("colt45_mp");
	wait 0.1;
	player switchToWeapon("colt45_mp");
	wait 0.5;
	object moveZ(200,3);
	object waittill("movedone");
	trigger delete();

}

trap1()
{
        trigger = getEnt ("trap1_trig", "targetname");
        object = getEnt ("movedown", "targetname");
       
        trigger waittill("trigger");
	
}

credits()
{
		trigger = getEnt ("credits", "targetname");
		
		trigger waittill("trigger");
		iPrintLnBold("^1Thanks to ^4Phelix^1 and ^4Xenon^1 for the help");
		wait 1;
		iPrintLnBold("^1Kiss to ^4Blade ^7:^9*");
		trigger delete();

}

trap2() 
{ 
random1 = getEnt("random1", "targetname"); 
random2 = getEnt("random2", "targetname"); 
random3 = getEnt("random3", "targetname"); 
random4 = getEnt("random4", "targetname"); 
trigger = getEnt("trap2_trig", "targetname"); 
trigger waittill("trigger");


}

trap3()
{	
	trig = getEnt ("trap3_trig", "targetname");	
	hurt = getEnt ("trap3_spikeshurt", "targetname");	
	spikes = getEnt ("spikes", "targetname"); 

	hurt enablelinkto(); 
	hurt linkto (spikes); 

	trig waittill ("trigger");

}

trap4() 
{ 
trigger = getEnt("trap4_trig", "targetname"); 
random1 = getEnt("trap4a", "targetname"); 
random2 = getEnt("trap4b", "targetname"); 
trigger waittill("trigger");

}

startdoor()
{
	trigger = getEnt("openstart", "targetname");
	object = getEnt("startdoor", "targetname");

	object delete();
}

music()
{
	trigger = getEnt ("teleport_trigger", "targetname");
	trigger waittill("trigger");
	iprintlnbold("^7What happend to the ^1Song? ^7:o");
	trigger delete();

}

creator()
{
trigger = getEnt ("Creator", "targetname");
trigger waittill("trigger");
iprintlnbold("^1y^2S^3k^4i^5l^6l^0y^7 is in this server !");
trigger delete();
}


trap5()
{
	trigger = getEnt ("trap5_trig", "targetname");
	object = getEnt ("roll1", "targetname");
	
	trigger waittill("trigger");

}

sniperroom()
{
    level.activ = undefined;

	level.sniper_trigger = getEnt("sniper_room","targetname");
	actiorigin = getEnt("sniperspawn_acti","targetname");
	jumperorigin = getEnt("sniperspawn_jumper","targetname");
	level.sniper_trigger setHintString("^7Press ^1USE ^7to enter the ^1Sniper");
	level.sniper_trigger waittill("trigger", player);
	level.knife_trigger delete();
	
	while(1)
	{
        
		level.sniper_trigger setHintString("^7Press ^1USE ^7to enter the ^1Sniper");
		
        if(player.pers["team"] == "axis")
        {
        	player iprintlnbold("^7You cant fight ^1against ^7yourself");
        	return;
		}

        if( getTeamPlayersAlive("axis") < 1 )
		{
			player iprintlnbold("^7You can't fight ^1alone");
			return;
		}
		else
		
		player SetPlayerAngles( jumperorigin.angles );
		player SetOrigin( jumperorigin.origin );
		level.activ SetPlayerAngles( actiorigin.angles );
		level.activ  SetOrigin( actiorigin.origin );

		player FreezeControls(1);
		level.activ FreezeControls(1);

		wait 0.5;

		player takeallweapons();
		player GiveWeapon( "remington700_mp" );
		player GiveWeapon( "m40a3_mp" );
		player GiveMaxAmmo( "remington700_mp" );
		player GiveMaxAmmo( "m40a3_mp" );
        player SwitchtoWeapon( "remington700_mp" );

        level.activ takeallweapons();
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveMaxAmmo( "remington700_mp" );
		level.activ GiveMaxAmmo( "m40a3_mp" );
        level.activ SwitchtoWeapon( "remington700_mp" );

        player FreezeControls(0);
		level.activ FreezeControls(0);

		iprintlnbold("^1" + player.name + " ^7choose ^1Sniper");
		while(isAlive(player) && isDefined(player))
		{
			wait 0.1;
		}
		level.sniper_trigger waittill("trigger", player);
	}
	
}

kniferoom()
{
    level.activ = undefined;

	level.knife_trigger = getEnt("knife_room","targetname");
	actiorigin = getEnt("knifespawn_acti","targetname");
	jumperorigin = getEnt("knifespawn_jumper","targetname");
	level.knife_trigger setHintString("^7Press ^1USE ^7to enter the ^1Knife");
	level.knife_trigger waittill("trigger", player);
	level.sniper_trigger delete();
	
	while(1)
	{
        
		level.knife_trigger setHintString("^7Press ^1USE ^7to enter the ^1Knife");
		
        if(player.pers["team"] == "axis")
        {
        	player iprintlnbold("^7You cant fight ^1against ^7yourself");
        	return;
		}

        if( getTeamPlayersAlive("axis") < 1 )
		{
			player iprintlnbold("^7You can't fight ^1alone");
			return;
		}
		else
		
		player SetPlayerAngles( jumperorigin.angles );
		player SetOrigin( jumperorigin.origin );
		level.activ SetPlayerAngles( actiorigin.angles );
		level.activ  SetOrigin( actiorigin.origin );

		player FreezeControls(1);
		level.activ FreezeControls(1);

		wait 0.5;

		player takeallweapons();
		player GiveWeapon( "knife_mp" );
        player SwitchtoWeapon( "knife_mp" );

        level.activ takeallweapons();
		level.activ GiveWeapon( "knife_mp" );
        level.activ SwitchtoWeapon( "knife_mp" );

        player FreezeControls(0);
		level.activ FreezeControls(0);

		iprintlnbold("^1" + player.name + " ^7choose ^1Knife");
		while(isAlive(player) && isDefined(player))
		{
			wait 0.1;
		}
		level.knife_trigger waittill("trigger", player);
	}
	
}

printCredits() 
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
self.logoText.fontScale = 1.5; 
self.logoText.archieved = true; 

for(;;) 
{ 
self.logoText fadeOverTime(1); 
self.logoText.alpha = 1; 
self.logoText setText("^7---------------"); 
wait 5; 
self.logoText fadeOverTime(1); 
self.logoText.alpha = 0; 
wait 1; 
self.logoText fadeOverTime(1); 
self.logoText.alpha = 1; 
self.logoText setText("^7-- ^1Deathrun Owl ^7--"); 
wait 5; 
self.logoText fadeOverTime(1); 
self.logoText.alpha = 0; 
wait 1; 
self.logoText fadeOverTime(1); 
self.logoText.alpha = 1; 
self.logoText setText("^7-- ^1Made by ySkilly ^7--"); 
wait 5; 
self.logoText fadeOverTime(1); 
self.logoText.alpha = 0; 
wait 1; 
self.logoText fadeOverTime(1); 
self.logoText.alpha = 1; 
self.logoText setText("^7-- ^1Script made by ySkilly ^3(Fix by Blade) ^7--"); 
wait 5; 
self.logoText fadeOverTime(1); 
self.logoText.alpha = 0; 
wait 1; 
} 
}