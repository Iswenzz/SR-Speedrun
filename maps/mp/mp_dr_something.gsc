
/////////////////MAP MADE BY LOOTJE
////////////////////SCRIPTED BY LOOTJE (with help)
////////////////Thank you mom from bringing the snacks when I called for those..
//////////////Thanks Dark Bla for timerscripterino



#include maps\mp\gametypes\_hud_util;

main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
 maps\mp\_load::main();

 game["allies"] = "sas";
 game["axis"] = "russian";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";


	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");


	precacheItem( "ak47_mp" );
	precacheItem("tomahawk_mp");
	precacheItem("remington700_mp");
	precacheItem("m40a3_mp");
	precacheItem("rpg_mp");
	precacheItem("deserteaglegold_mp");
	precacheItem("ak74u_mp");

	thread way_connect();
	// thread messages();
	// thread spawn_credits();
	thread startteleporter();
	thread elevatorglitch();
	thread teleporter1();
	thread teleporter2();
	thread teleporterglitch();
	thread teleporteractivator1();
	thread teleporteractivator2();
	thread teleport_shortcut();
	thread teleport_secretstart();
	thread teleport_secretend();
	thread teleport_secretfail();
	thread open_secret();
	thread move_1();
	thread move_2();
	// thread trap1();
	// thread trap2();
	thread trap3();
	// thread trap3start();
	// thread trap4();
	// thread trap_rotate();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread old();
	// thread sniper();
	// thread bounce();
	// thread bounce_weapon();
	// thread ladder();
	// thread ladder_weapon();
	// thread knife();
	// thread bounce_teleport_a();
	// thread bounce_teleport_j();
	// thread ladder_teleport_a();
	// thread ladder_teleport_j();
	thread vip();
	// thread RandMusic();
	// thread endmap();



	// addTriggerToList( "trig_trap1" );
	// addTriggerToList( "trig_trap2" );
	// addTriggerToList( "trig_trap3" );
	// addTriggerToList( "trig_trap4" );
	// addTriggerToList( "trig_trap5" );
	// addTriggerToList( "trig_trap6" );
	// addTriggerToList( "trig_trap7" );
	// addTriggerToList( "trig_traprotate" );

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

RandMusic()
{
	x = randomInt(6);
	if(x == 0)
    {
		ambientplay("inspectornorse");
		wait 5;
		iprintlnbold("^8>>[^6Todd Terje - Inspector Norse^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Todd Terje - Inspector Norse^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Todd Terje - Inspector Norse^8]<<");
    }
    else if(x == 2)
    {
		ambientplay("lights");
		wait 5;
		iprintlnbold("^8>>[^6Lights - Beatbustlers^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Lights - Beatbustlers^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Lights - Beatbustlers^8]<<");
    }
    else if(x == 1)
    {
		ambientplay("receptor");
		wait 5;
		iprintlnbold("^8>>[^6Receptor - Beautifull lie^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Receptor - Beautifull lie^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Receptor - Beautifull lie^8]<<");
    }

	    else if(x == 4)
    {
		ambientplay("builtforlove");
		wait 5;
		iprintlnbold("^8>>[^6Kraak en Smaak - Built for love^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Kraak en Smaak - Built for love^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Kraak en Smaak - Built for love^8]<<");
    }

		    else if(x == 3)
    {
		ambientplay("ponponpon");
		wait 5;
		iprintlnbold("^8>>[^6Y//2//K - Ponponpon [remix]^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Y//2//K - Ponponpon [remix]^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6Y//2//K - Ponponpon [remix]^8]<<");
    }

		    else if(x == 5)
    {
		ambientplay("blue");
		wait 5;
		iprintlnbold("^8>>[^6William French - Blue Heron^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6William French - Blue Heron^8]<<");
		wait 0.2;
		iprintlnbold("^8>>[^6William French - Blue Heron^8]<<");
    }
}



vip()
{
trig = getEnt("are_u_lootje","targetname");
trig SetHintString("^4Press [USE] if u feel lucky!");

guidRobin = false;
guidDark = false;
guidLootje = false;
guidMroz = false;
guidNeck = false;

while(true)
{
trig waittill("trigger", player);
if (player getGuid() == "8aa64a938a604b0339453864d7227c3b" && guidLootje == false) // Hallo
{

iPrintlnBold("^6Lootje is here!");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidLootje = true;

}


else if (player getGuid() == "5f783dc7e863a84cd002257f3b16d6b1" && guidRobin == false) /// Hai
{
iPrintlnBold("^4Robin is a cool guy!");
player iPrintlnBold("^3Here take this");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidRobin = true;
}


else if (player getGuid() == "8dac71a52f5a77bee5ac0r1712ce8ccf" && guidRobin == false) /// Yes
{
iPrintlnBold("^4Robin is a cool guy!");
player iPrintlnBold("^3Here take this");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidRobin = true;
}


else if (player getGuid() == "da6c0c4832a50cd7e1598a17ef04f2e4" && guidDark == false)  /// <3
{
iPrintlnBold("^4 OH MY GOSH ^9Dark ^1Bla ^4is here! ");
player iPrintlnBold("^3Here take this");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidDark = true;
}

else if (player getGuid() == "e6dc4434ead7bcfc7263327c11ba6bad" && guidDark == false)  /// <3
{
iPrintlnBold("^4 OH MY GOSH ^9Dark ^1Bla ^4is here! ");
player iPrintlnBold("^3Here take this");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidDark = true;
}

else if (player getGuid() == "074bcda0f71bd0d430ea726d3a2faff5" && guidMroz == false)  /// MROZZZZ
{
iPrintlnBold("^5 Hello handsome Mroz");
player iPrintlnBold("^3Here take this");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidMroz = true;
}

else if (player getGuid() == "812e75cedc71fa1c9f44ab15d06d9848" && guidMroz == false)  /// MROZYYY
{
iPrintlnBold("^5 Hello handsome Mroz");
player iPrintlnBold("^3Here take this");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidMroz = true;
}

else if (player getGuid() == "0000000069eda27712776d16404b0ae1" && guidNeck == false)  /// LE NECK
{
iPrintlnBold("^7 Welcome ^2Sensei ^6Neck.");
player iPrintlnBold("^3Here take this");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidNeck = true;
}

else if (player getGuid() == "2c6e8b8569eda27712776d16404b0ae1" && guidNeck == false)  /// LE NECK
{
iPrintlnBold("^7 Welcome ^2Sensei ^6Neck.");
player iPrintlnBold("^3Here take this");
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon("deserteaglegold_mp");
player GiveMaxAmmo( self.pers["deserteaglegold_mp"] );
guidNeck = true;
}

else
{
player iPrintlnBold("^6Unlucky m8!");
wait 1;
}
}
}

spawn_credits()
{
	trig = getEnt("spawn_credits", "targetname");
	trig sethintstring("^8Map By: ^6Lootje");
	wait 0.1;
}


messages()
{
wait 8;
iprintlnbold("Something :>");
wait 1;
}

//////////////////////////////////////////////////////////////////////////////////// TELEPORTERS

startteleporter()
{
	trig = getEnt("start_teleporter","targetname");
	target = getEnt("start_teleporter_end","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

elevatorglitch()
{
	trig = getEnt("elevatorglitch","targetname");
	target = getEnt("elevatorglitch_end","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		// iPrintlnBold( " ^8" + player.name + " ^4 did D young elevator" );
		// player iPrintlnBold( "^4 I hope ur happy with this little shortcut^8..." );
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

teleporter1()
{
	trig = getEnt("map_teleporter_1","targetname");
	target = getEnt("teleporter_1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

teleporter2()
{
	trig = getEnt("map_teleporter_2","targetname");
	target = getEnt("teleporter_2","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

teleporteractivator1()
{
	trig = getEnt("activator_teleporter_1","targetname");
	target = getEnt("acti_teleporter_1","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

teleporteractivator2()
{
	trig = getEnt("activator_teleporter_2","targetname");
	target = getEnt("acti_teleporter_2","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}



teleporterglitch()
{
	trig = getEnt("map_teleporter_glitch","targetname");
	target = getEnt("teleporter_glitch","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player iPrintlnBold( " ^8You^4 Tried to glitch^8! ^6feggit!" );
		wait 4;
		player iPrintlnBold( "^4 Lets see how u do without sprinting^8..." );
		wait 2;
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
		player AllowSprint(false);
		wait 8;
		player iPrintlnBold("^8You don't even deserve to be here filthy ^2glitcher.");
		wait 1;
		player iPrintlnBold("^4Cya ^1m8");
		wait 2;
		player suicide();
	}
}

bounce_teleport_a()
{
	trig = getEnt("bounce_teleport_a","targetname");
	target = getEnt("bounce_activator","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

bounce_teleport_j()
{
	trig = getEnt("bounce_teleport_j","targetname");
	target = getEnt("bounce_jumper","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

ladder_teleport_a()
{
	trig = getEnt("ladder_teleport_a","targetname");
	target = getEnt("ladder_activator","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

ladder_teleport_j()
{
	trig = getEnt("ladder_teleport_j","targetname");
	target = getEnt("ladder_jumper","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}

////////////////////////////////////////////////////////////////////////SECRET / SHORTCUT

teleport_shortcut()
{
	trig = getEnt("map_teleporter_shortcut","targetname");
	target = getEnt("teleporter_shortcut","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
		// iprintlnbold ( " ^8" + player.name + " ^4 Found a shortcut!" );
	}
}


open_secret()
{
	trig = getEnt("secret_open","targetname");
	brush = getent("secret_brush","targetname");
		brush NotSolid();
}

teleport_secretstart()
{
	trig = getEnt("map_teleporter_secretstart","targetname");
	target = getEnt("teleporter_secretstart","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
		player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
	}
}

SecretTimer()
{
        self endon( "disconnect" );

        self.secret_timer = NewClientHudElem( self );
        self.secret_timer.y = 10;
        self.secret_timer.alignX = "center";
        self.secret_timer.alignY = "middle";
        self.secret_timer.horzAlign = "center";
        self.secret_timer.sort = -3;
        self.secret_timer.fontScale = 2.5;
        self.secret_timer.owner = self;
        self.secret_timer thread removehudifsuicide();

        self.secret_time_left = 120;
        self.secret_finished = false;

        while( self.secret_time_left > 0 && !self.secret_finished )
        {
                self.secret_timer setText( "^2Secret time left: ^0" + self.secret_time_left );
                self.secret_time_left--;
                wait 1;
        }

        if( !self.secret_finished )
        {
                self.secret_timer Destroy();
                self Suicide();
                self iPrintlnBold( "^2 You can't even make simple 125fps strafes, ^6noob." );
        }

}

removehudifsuicide()
{
        self endon ("death");
        self endon ("disconnect");
        self.owner waittill("death", player);
                player.secret_finished = true;
                player.secret_timer destroy();
                self destroy();

}

teleport_secretend()
{
	trig = getEnt("map_teleporter_secretend","targetname");
	target = getEnt("teleporter_secretend","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread braxi\_mod::endTimer();
	}
}


teleport_secretfail()
{
	trig = getEnt("map_teleporter_secretfail","targetname");
	target = getEnt("teleporter_secretstart","targetname");

	for(;;)
	{
		trig waittill("trigger",player);
		player setPlayerAngles(target.angles);
		player setOrigin(target.origin);
	}
}




/////////MOVABLES

move_1()
{
    target = getEnt ("move_1", "targetname");

	while (1)
	{
	    target rotateYaw (-180, 4);
		wait 4;
		target rotateYaw (-180, 4);
		wait 4;
	}
}

move_2()
{
    target = getEnt ("move_2", "targetname");

	while (1)
	{
	    target rotateYaw (180, 7);
		wait 7;
		target rotateYaw (180, 7);
		wait 7;
	}
}

///////////////////////////////////////////////////////////////////////////////TRAPS

trap1()
{
a = getent("trap1a","targetname");
b = getent("trap1b","targetname");
c = getent("trap1c","targetname");
d = getent("trap1d","targetname");
e = getent("trap1e","targetname");
f = getent("trap1f","targetname");
g = getent("trap1g","targetname");
h = getent("trap1h","targetname");
i = getent("trap1i","targetname");
j = getent("trap1j","targetname");
trig = getent("trig_trap1","targetname");
trig SetHintString( "^1Magic Tiles" );
trig waittill("trigger", player );
if(level.trapsdisabled)
{
	iprintlnbold(" ^6 user.name + ^3 pls dont acti on free !");
}
else
{
trig SetHintString("^4Activated");
{
a moveZ(-300, 3);
d moveZ(-300, 3);
e moveZ(-300, 3);
g moveZ(-300, 3);
j moveZ(-300, 3);
wait 3;
for(;;)
	{
	a moveZ(300, 3);
	d moveZ(300, 3);
	e moveZ(300, 3);
	g moveZ(300, 3);
	j moveZ(300, 3);
	b moveZ(-300, 3);
	c moveZ(-300, 3);
	f moveZ(-300, 3);
	h moveZ(-300, 3);
	i moveZ(-300, 3);
	wait 3;
	a moveZ(-300, 3);
	d moveZ(-300, 3);
	e moveZ(-300, 3);
	g moveZ(-300, 3);
	h moveZ(-300, 3);
	j moveZ(-300, 3);
	b moveZ(300, 3);
	c moveZ(300, 3);
	f moveZ(300, 3);
	h moveZ(300, 3);
	i moveZ(300, 3);
	wait 3;
	}
}
}
}

trap2()
{
gvddraaien = getent("trap2","targetname");
trig = getent("trig_trap2","targetname");
trig SetHintString( "^1Spin the bounce" );
trig waittill("trigger", player );
if(level.trapsdisabled)
{
	iprintlnbold(" ^6 user.name + ^3 pls dont acti on free !");
}
else
{
trig SetHintString("^4Activated");
{
for(;;)
	{
	gvddraaien rotateRoll (-360, 15);
	wait 0.01;
	}
}
}
}

trap3()
{
wall = getent("trap3wall","targetname");
aspike = getent("trap3a","targetname");
b = getent("trap3b","targetname");
c = getent("trap3c","targetname");
d = getent("trap3d","targetname");
e = getent("trap3e","targetname");
f = getent("trap3f","targetname");
g = getent("trap3g","targetname");
h = getent("trap3h","targetname");
i = getent("trap3i","targetname");
j = getent("trap3j","targetname");
k = getent("trap3k","targetname");
l = getent("trap3l","targetname");
m = getent("trap3m","targetname");
n = getent("trap3n","targetname");
o = getent("trap3o","targetname");
up = getent("trap3up","targetname");
killer = getent("3killer","targetname");
trig = getent("trig_trap3","targetname");
killer EnableLinkTo();
killer LinkTo(up);
trig SetHintString( "^1Kill them with spikes" );

wait 1;

trig delete();

	wall delete();
	aspike delete();
	b delete();
	c delete();
	d delete();
	e delete();
	f delete();
	g delete();
	h delete();
	i delete();
	j delete();
	k delete();
	l delete();
	m delete();
	n delete();
	o delete();
	up delete();

}

trap3start()
{
aspike = getent("trap3a","targetname");
b = getent("trap3b","targetname");
c = getent("trap3c","targetname");
d = getent("trap3d","targetname");
e = getent("trap3e","targetname");
f = getent("trap3f","targetname");
g = getent("trap3g","targetname");
h = getent("trap3h","targetname");
i = getent("trap3i","targetname");
j = getent("trap3j","targetname");
k = getent("trap3k","targetname");
l = getent("trap3l","targetname");
m = getent("trap3m","targetname");
n = getent("trap3n","targetname");
o = getent("trap3o","targetname");
{
	wait 2;
	aspike moveZ(-96,2);
	b moveZ(-96,2);
	c moveZ(-96,2);
	d moveZ(-96,2);
	e moveZ(-96,2);
	f moveZ(-96,2);
	g moveZ(-96,2);
	h moveZ(-96,2);
	i moveZ(-96,2);
	j moveZ(-96,2);
	k moveZ(-96,2);
	l moveZ(-96,2);
	m moveZ(-96,2);
	n moveZ(-96,2);
	o moveZ(-96,2);
	wait 2;
	aspike waittill ("movedone");
	b waittill ("movedone");
	c waittill ("movedone");
	d waittill ("movedone");
	e waittill ("movedone");
	f waittill ("movedone");
	g waittill ("movedone");
	h waittill ("movedone");
	i waittill ("movedone");
	j waittill ("movedone");
	k waittill ("movedone");
	l waittill ("movedone");
	m waittill ("movedone");
	n waittill ("movedone");
	o waittill ("movedone");
}
}


trap4()
{
a = getent("trap4","targetname");
b = getent("trap4b","targetname");
trig = getent("trig_trap4","targetname");
trig SetHintString( "^1Rotate" );
trig waittill("trigger", player );
if(level.trapsdisabled)
{
	iprintlnbold(" ^6 user.name + ^3 pls dont acti on free !");
}
else
{
trig SetHintString("^4Activated");
{
	for(;;)
	{
	a rotateYaw(360, 1.2);
	b rotateYaw(-360, 1.2);
	wait 0.01;

	}
}
}
}

trap_rotate()
{
pusher1 = getent("trap_rotate1","targetname");
pusher2 = getent("trap_rotate2","targetname");
pusher3 = getent("trap_rotate3","targetname");
trig = getent("trig_traprotate","targetname");
trig SetHintString( "^1Activate pushers" );
trig waittill("trigger", player );
if(level.trapsdisabled)
{
	iprintlnbold(" ^6 user.name + ^3 pls dont acti on free !");
}
else
{
trig SetHintString("^4Activated");
{
	for(;;)
	{
	pusher1 moveY(-100,2);
	pusher2 moveX(100,2);
	pusher3 moveY(100,2);
	wait 4;
	pusher1 moveY(100,4);
	pusher2 moveX(-100,4);
	pusher3 moveY(-100,4);
	wait 8;
	}
}
}
}

trap5()
{
a = getent("trap5","targetname");
trig = getent("trig_trap5","targetname");
trig SetHintString( "^1Move the brush" );
trig waittill("trigger", player );
if(level.trapsdisabled)
{
	iprintlnbold(" ^6 user.name + ^3 pls dont acti on free !");
}
else
{
trig SetHintString("^4Activated");
	{
	wait 0.1;
	a moveX(-300, 2);
	wait 10;
	a moveX(300, 2);
	a waittill ("movedone");
	}
}
}

trap6()
{
a = getent("trap6","targetname");
trig = getent("trig_trap6","targetname");
trig SetHintString( "^1Rotate the floor" );
trig waittill("trigger", player );
if(level.trapsdisabled)
{
	iprintlnbold(" ^6 user.name + ^3 pls dont acti on free !");
}
else
{
trig SetHintString("^4Activated");
{
	for(;;)
	{
	a rotatePitch(-360, 5);
	wait 0.01;
	}
}
}
}

trap7()
{
a = getent("trap7","targetname");
trig = getent("trig_trap7","targetname");
trig SetHintString( "^1Spin that" );
trig waittill("trigger", player );
if(level.trapsdisabled)
{
	iprintlnbold(" ^6 user.name + ^3 pls dont acti on free !");
}
else
{
trig SetHintString("^4Activated");
{
	for(;;)
	{
	a rotateYaw(-360, 4);
	wait 0.01;
	}
}
}
}


/////ROOMS

old()
{
		level.old_trigger = getEnt( "trig_old", "targetname");
		level.sniper_trigger = getEnt("trig_sniper","targetname");
		level.bounce_trigger = getEnt("trig_bounce","targetname");
		level.ladder_trigger = getEnt("trig_ladder","targetname");
		level.knife_trigger = getEnt("trig_knife","targetname");
		door = getEnt("old_door","targetname");
		level.old_trigger waittill( "trigger", player );

		{


		level.sniper_trigger delete();
		level.bounce_trigger delete();
		level.ladder_trigger delete();
		level.knife_trigger delete();
		level.old_trigger delete();

		iPrintlnBold( " ^8" + player.name + " ^4 has entered the old room^8!" );
		door moveZ (-160,2);
		wait 1;
		}
}


sniper()
{
		level.bounce_trigger = getEnt("trig_bounce", "targetname");
		level.sniper_trigger = getEnt("trig_sniper","targetname");
		level.old_trigger = getEnt("trig_old","targetname");
		level.ladder_trigger = getEnt("trig_ladder","targetname");
		level.knife_trigger = getEnt("trig_knife","targetname");
		level.teleactorigin = getEnt("sniper_activator", "targetname");
		telejumporigin = getEnt("sniper_jumper", "targetname");

		while(1)
		{
		level.sniper_trigger waittill("trigger", player);




		level.bounce_trigger delete();
		level.old_trigger delete();
		level.ladder_trigger delete();
		level.knife_trigger delete();


		if(!isDefined(level.sniper_trigger))
					return;
			if(level.firstenter==true)
		{
				//level.bounce_trigger delete();
				level.old_trigger delete();
				//level.weapon_trigger delete();
				level.firstenter=false;
				}
				wait(0.05);

		player SetOrigin( telejumporigin.origin );
		player setplayerangles( telejumporigin.angles );
		player TakeAllWeapons();
		player GiveWeapon("m40a3_mp");
		player GiveWeapon( "remington700_mp" );
		player GiveMaxAmmo("m40a3_mp");
		player GiveMaxAmmo( "remington700_mp" );
		wait .05;
		player SwitchToWeapon("m40a3_mp");
		wait(0.05);
		level.activ SetOrigin (level.teleactorigin.origin);
		level.activ setplayerangles (level.teleactorigin.angles);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "m40a3_mp" );
		level.activ GiveWeapon( "remington700_mp" );
		level.activ GiveMaxAmmo("m40a3_mp");
		level.activ GiveMaxAmmo( "remington700_mp" );
		wait .05;
		level.activ SwitchToWeapon("m40a3_mp");
		iPrintlnBold( " ^8" + player.name + " ^4 has entered the Sniper room^8!" );
		wait(0.05);
		player switchToWeapon( "m40a3_mp" );
		level.activ SwitchToWeapon( "m40a3_mp" );


		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Snipaah time^1!" );
		level.activ iPrintlnBold(  "^5Snipaah time^1!" );
		player freezecontrols(false);
		level.activ freezecontrols(false);

		player waittill( "death" );
		level.PlayerInRoom = false;


}
}



bounce()
{
     	level.bounce_trigger = getEnt( "trig_bounce", "targetname");
		level.sniper_trigger = getEnt("trig_sniper","targetname");
		level.old_trigger = getEnt("trig_old","targetname");
		level.ladder_trigger = getEnt("trig_ladder","targetname");
		level.knife_trigger = getEnt("trig_knife","targetname");
     	jump = getEnt( "bounce_jumper", "targetname" );
     	acti = getEnt( "bounce_activator", "targetname" );

		while(1)
     	{
         	level.bounce_trigger waittill( "trigger", player );



         	if( !isDefined( level.bounce_trigger ) )
         	return;
			if(level.firstenter==true)
		{
		level.sniper_trigger delete();
		level.old_trigger delete();
		level.ladder_trigger delete();
		level.knife_trigger delete();
		level.firstenter=false;
		}
		wait(0.05);

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
		player giveweapon( "knife_mp" );
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
		level.activ giveweapon( "knife_mp" );
		iPrintlnBold( " ^8" + player.name + " ^4 has entered the Bounce room^8!" );
         	wait 0.05;
		level.activ switchtoweapon( "knife_mp" );
		player switchtoweapon( "knife_mp" );


		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Bouncaaah^1!" );
		level.activ iPrintlnBold( "^5Bouncaaah^1!" );
		player freezecontrols(false);
		level.activ freezecontrols(false);

		player waittill( "death" );
		level.PlayerInRoom = false;

     	}
}

bounce_weapon()
{

        trig = getent("bounce_weapon","targetname");

        while(1)
        {
                trig waittill("trigger", player);
                player GiveWeapon( "ak47_mp" );
				player GiveMaxAmmo( "ak47_mp" );
                player switchToWeapon( "ak47_mp" );
				wait 1;
        }
}

knife()
		{

		level.bounce_trigger = getEnt("trig_bounce", "targetname");
		level.sniper_trigger = getEnt("trig_sniper","targetname");
		level.knife_trigger = getEnt("trig_knife","targetname");
		level.ladder_trigger = getEnt("trig_ladder","targetname");
		level.old_trigger = getEnt("trig_old","targetname");
		acti = getEnt("knife_activator", "targetname");
		jump = getEnt("knife_jumper", "targetname");

		while(1)
     	{
         	level.knife_trigger waittill( "trigger", player );



         	if( !isDefined( level.knife_trigger ) )
         	return;
			if(level.firstenter==true)
		{
		level.sniper_trigger delete();
		level.old_trigger delete();
		level.ladder_trigger delete();
		level.bounce_trigger delete();
		level.firstenter=false;
		}
		wait(0.05);

		player SetOrigin( jump.origin );
		player setplayerangles( jump.angles );
		player TakeAllWeapons();
		player GiveWeapon( "tomahawk_mp" );
		wait(0.05);
		level.activ SetOrigin (acti.origin);
		level.activ setplayerangles (acti.angles);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "tomahawk_mp" );
		wait(0.05);
		player switchToWeapon( "tomahawk_mp" );
		level.activ SwitchToWeapon( "tomahawk_mp" );
		iPrintlnBold( " ^8" + player.name + " ^4 has entered the Knife room^8!" );

		player waittill( "death" );
		level.PlayerInRoom = false;
		}
}

ladder()
		{

		level.bounce_trigger = getEnt("trig_bounce", "targetname");
		level.sniper_trigger = getEnt("trig_sniper","targetname");
		level.knife_trigger = getEnt("trig_knife","targetname");
		level.ladder_trigger = getEnt("trig_ladder","targetname");
		level.old_trigger = getEnt("trig_old","targetname");
		acti = getEnt("ladder_activator", "targetname");
		jump = getEnt("ladder_jumper", "targetname");

		while(1)
     	{
         	level.ladder_trigger waittill( "trigger", player );



         	if( !isDefined( level.ladder_trigger ) )
         	return;
			if(level.firstenter==true)
		{
		level.sniper_trigger delete();
		level.old_trigger delete();
		level.knife_trigger delete();
		level.bounce_trigger delete();
		level.firstenter=false;
		}
		wait(0.05);

		player SetOrigin( jump.origin );
		player setplayerangles( jump.angles );
		player TakeAllWeapons();
		player GiveWeapon( "knife_mp" );
		wait(0.05);
		level.activ SetOrigin (acti.origin);
		level.activ setplayerangles (acti.angles);
		level.activ TakeAllWeapons();
		level.activ GiveWeapon( "knife_mp" );
		wait(0.05);
		player switchToWeapon( "knife_mp" );
		level.activ SwitchToWeapon( "knife_mp" );
		iPrintlnBold( " ^8" + player.name + " ^4 has entered the LadderSlide room^8!" );

		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		level.activ iPrintlnBold( "^53" );
		player iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Laddaah Slideee^1!" );
		level.activ iPrintlnBold( "^5Laddaah Slideee^1!" );
		player freezecontrols(false);
		level.activ freezecontrols(false);

		player waittill( "death" );
		level.PlayerInRoom = false;
		}
}


ladder_weapon()
{

        trig = getent("ladder_weapon","targetname");

        while(1)
        {
                trig waittill("trigger", player);
                player GiveWeapon( "ak47_mp" );
				player GiveMaxAmmo( "ak47_mp" );
                player switchToWeapon( "ak47_mp" );
				wait 1;
        }
}



/////////////////OTHERSTUFF



 addTriggerToList( name, positionOfIconAboveTrap )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

    if( !isDefined( level.icon_origins ) )
        level.icon_origins = [];
    level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
}


endmap()
{
trig = getent("endmap_trig","targetname");
trig waittill ("trigger, player");
iPrintlnBold(" ^8 player.name ^2+  ^3Finished the map. Hooray!");

	wait 0.1;
	trig delete();

}
