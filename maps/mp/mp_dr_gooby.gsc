main()
{
thread sr\api\_map::createSpawnOrigin((-89.475, -24, 16.125), 0);
trigger = spawn( "trigger_radius", (328, 1018, -211), 0, 300, 300 );
trigger.targetname = "endmap_trig";
trigger.radius = 300;

/*
MAP CREATED AND SCRIPTED BY CHUBBS317
*/

maps\mp\_load::main();

// ambientPlay("ambient1");

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

// precacheItem("m40a3_mp");
// precacheItem("deserteagle_mp");
// precacheItem("m4_reflex_mp");
// precacheItem("rpg_mp");
// precacheItem("winchester1200_grip_mp");
// precacheItem("remington700_mp");
// precacheItem("knife_mp");
// precacheItem("ak47_reflex_mp");
// precacheItem("m14_acog_mp");
// precacheItem("skorpion_silencer_mp");
// precacheItem("g36c_silencer_mp");
// precacheItem("rpd_acog_mp");
// precacheItem("m40a3_acog_mp");

setdvar( "r_specularcolorscale", "1" );

setdvar("r_glowbloomintensity0",".25");
setdvar("r_glowbloomintensity1",".25");
setdvar("r_glowskybleedintensity0",".3");
setdvar("compassmaxrange","1800");

	thread onConnect();
	thread way_connect();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	thread trap7a();
	thread trap7b();
	thread teleport();
	// thread addTestClients();
	thread SWJ();
	// thread sniper_tele();
	// thread weapon_tele();
	// thread weapon_room_gun();
	// thread jump_tele();
	// thread jump_wep();

	// addTriggerToList( "trap1_trig" );
    // addTriggerToList( "trap2_trig" );
    // addTriggerToList( "trap3_trig" );
    // addTriggerToList( "trap4_trig" );
    // addTriggerToList( "trap5_trig" );
    // addTriggerToList( "trap6_trig" );
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

onConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self.sec = undefined;
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

///testbots///
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

///end///

teleport()
{
	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
}

transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
		if(!isDefined(player.sec))
		{
			player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
			player.sec = true;
		}
	}
}

SWJ()
{
S = getent ("S", "targetname");
W = getent ("W", "targetname");
J = getent ("J", "targetname");

	for(;;)
	{
		S rotateYaw (-360, 3);
		W rotateYaw (360, 3);
		J rotateYaw (-360, 3);
		wait 3;
	}
}

trap1()
{
    trig1 = getEnt("trap1_trig", "targetname");
    trap1a = getEnt("trap1a", "targetname");
    trap1b = getEnt("trap1b", "targetname");
    trap1c = getEnt("trap1c", "targetname");

    trig1 waittill("trigger");
    trig1 delete();

	for(;;)
    {
		trap1a rotateRoll (360, 2);
		trap1c rotateRoll (360, 2);
		trap1b rotateRoll (-360, 2);
		wait 3;
	}
}

trap2()
{
trap2a = getent ("trap2a", "targetname");
trap2b = getent ("trap2b", "targetname");
trig2 = getent ("trap2_trig", "targetname");

trig2 waittill ("trigger");
trig2 delete();

	for(;;)
	{
		trap2a rotateRoll (-360, 3);
		trap2b rotateRoll (360, 3);
		wait 3;
	}
}

trap3()
{
trap3a = getent ("trap3a", "targetname");
trap3b = getent ("trap3b", "targetname");
trap3c = getent ("trap3c", "targetname");
trap3d = getent ("trap3d", "targetname");
trig3 = getent ("trap3_trig", "targetname");

trig3 waittill ("trigger");
trig3 delete();

	for(;;)
	{
		trap3a rotateYaw (1800, 5);
		trap3b rotateYaw (-1800, 5);
		trap3c rotateYaw (1800, 5);
		trap3d rotateYaw (-1800, 5);
		wait 6;
	}
}

trap4()
{
trap4a = getent ("trap4a", "targetname");
trap4b = getent ("trap4b", "targetname");
trap4c = getent ("trap4c", "targetname");
trap4f = getent ("trap4f", "targetname");
trig4 = getent ("trap4_trig", "targetname");

trig4 waittill ("trigger");
trig4 delete();

	for(;;)
	{
		trap4a rotateYaw (90, 4);
		trap4b rotateYaw (90, 4);
		trap4c rotateYaw (90, 4);
		trap4f rotateYaw (90, 4);
		wait 10;
		trap4a rotateYaw (-90, 4);
		trap4b rotateYaw (-90, 4);
		trap4c rotateYaw (-90, 4);
		trap4f rotateYaw (-90, 4);
		wait 10;
	}
}

trap5()
{
trap5a = getent ("trap5a", "targetname");
trap5b = getent ("trap5b", "targetname");
trig5 = getent ("trap5_trig", "targetname");

trig5 waittill ("trigger");
trig5 delete();

	for(;;)
	{
		trap5a movez (-88, 1);
		trap5b movez (88, 1);
		wait 1;
		trap5a movez (88, 1);
		trap5b movez (-88, 1);
		wait 1;
		trap5a movez (88, 1);
		trap5b movez (-88, 1);
		wait 1;
		trap5a movez (-88, 1);
		trap5b movez (88, 1);
		wait 1;
	}
}

trap6()
{
trap6a = getent ("trap6a", "targetname");
trap6b = getent ("trap6b", "targetname");
trap6c = getent ("trap6c", "targetname");
trap6d = getent ("trap6d", "targetname");
trig6 = getent ("trap6_trig", "targetname");

trig6 waittill ("trigger");
trig6 delete();

	for(;;)
	{
		trap6a movey (-384, 1);
		trap6a rotateYaw (360, 1);
		trap6b movey (384, 1);
		trap6b rotateYaw (-360, 1);
		trap6c movey (-384, 1);
		trap6c rotateYaw (360, 1);
		trap6d movey (384, 1);
		trap6d rotateYaw (-360, 1);
		wait 1;
		trap6a movey (384, 1);
		trap6a rotateYaw (360, 1);
		trap6b movey (-384, 1);
		trap6b rotateYaw (-360, 1);
		trap6c movey (384, 1);
		trap6c rotateYaw (360, 1);
		trap6d movey (-384, 1);
		trap6d rotateYaw (-360, 1);
		wait 1;
	}
}

trap7a()
{
trap7a = getent ("trap_7a", "targetname");

	trap7a delete();
}

trap7b()
{
trap7b = getent ("trap_7b", "targetname");

	trap7b delete();
}

sniper_tele()
{
weapontrig = getent ("weapon_trigger", "targetname");
snipertrig = getent ("sniper_trigger", "targetname");
sniperactitele = getent ("sniper_acti_tele", "targetname");
sniperjumpertele = getent ("sniper_jumper_tele", "targetname");
jumptrig = getent ("jump_trigger", "targetname");

	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

snipertrig waittill("trigger", player);
weapontrig delete();
jumptrig delete();
wait(0.05);

player SetOrigin (sniperjumpertele.origin);
player setplayerangles (sniperjumpertele.angles);
player TakeAllWeapons();
player GiveWeapon ("m40a3_mp");
player GiveWeapon ("remington700_mp");
wait(0.05);

level.activ SetOrigin (sniperactitele.origin);
level.activ setplayerangles (sniperactitele.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon ("m40a3_mp");
level.activ GiveWeapon ("remington700_mp");
player GiveWeapon ("m40a3_mp");
player GiveWeapon ("remington700_mp");
wait(0.05);

player switchToWeapon ("m40a3_mp");
level.activ SwitchToWeapon ("m40a3_mp");
iPrintLnBold(player.name+ "^4 has entered the ^1Sniper Room");
wait 0.4;

player thread onDeath_sniper();
wait 0.1;

    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

onDeath_sniper()
{
	self endon("disconnect");

	self waittill("death");
	thread sniper_tele();
}

weapon_tele()
{
snipertrig = getent ("sniper_trigger", "targetname");
weapontrig = getent ("weapon_trigger", "targetname");
weaponactitele = getent ("weapon_acti_tele", "targetname");
weaponjumpertele = getent ("weapon_jumper_tele", "targetname");
jumptrig = getent ("jump_trigger", "targetname");

	self endon("death");
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

weapontrig waittill ("trigger", player);
snipertrig delete();
jumptrig delete();
wait 0.05;
player SetOrigin (weaponjumpertele.origin);
player setplayerangles (weaponjumpertele.angles);
level.activ SetOrigin (weaponactitele.origin);
level.activ setplayerangles (weaponactitele.angles);
iPrintLnBold(player.name+ "^4 has entered the ^1Weapon Room");
wait 0.01;
thread weapon_room_gun();
thread onDeath_weapon();
wait 0.1;

    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

Weapon_room_gun()
{
weapon = getent ("weapon_trigger" , "targetname");
weapon waittill("trigger", player);
weaponactitele = getent ("weapon_acti_tele", "targetname");
weaponjumpertele = getent ("weapon_jumper_tele", "targetname");

self endon("death");
self endon( "disconnect" );
self endon( "joined_team" );
self endon( "joined_spectators" );

player SetOrigin (weaponjumpertele.origin);
player setplayerangles (weaponjumpertele.angles);
level.activ SetOrigin (weaponactitele.origin);
level.activ setplayerangles (weaponactitele.angles);
wait 0.01;

x = 1+RandomInt(3);
gun = GetRandomWeapon( x );

player TakeAllWeapons();
level.activ TakeAllWeapons();
player GiveWeapon( gun );
level.activ GiveWeapon( gun );
wait 0.1;
player SwitchToWeapon( gun );
level.activ SwitchToWeapon( gun );
wait 0.01;
thread onDeath_weapon();
thread weapon_tele();
wait 0.01;
}

GetRandomWeapon( num )

{
	if( num == 2 )
		return "winchester1200_grip_mp";
	else
	{
		x = RandomInt( 51 );
		if( x < 10 )
			return "winchester1200_grip_mp";
		if( x > 9 && x < 20 )
			return "skorpion_silencer_mp";
		if( x > 20 && x < 30 )
			return "m4_reflex_mp";
		if( x > 30 && x < 40 )
			return "g36c_silencer_mp";
		if( x > 40 && x < 50 )
			return "ak47_reflex_mp";
		if( x == 50 )
			return "m14_acog_mp";
	}
}

onDeath_weapon()
{
	self endon("disconnect");

	self waittill("death");
	thread weapon_tele();
	thread weapon_room_gun();
}

jump_tele()
{
weapontrig = getent ("weapon_trigger", "targetname");
snipertrig = getent ("sniper_trigger", "targetname");
knifetrig = getent ("old_trigger", "targetname");
jumptrig = getent ("jump_trigger", "targetname");
jumpactitele = getent ("jump_acti_tele", "targetname");
jumpjumpertele = getent ("jump_jumper_tele", "targetname");

self endon("death");
self endon( "disconnect" );
self endon( "joined_team" );
self endon( "joined_spectators" );

jumptrig waittill("trigger", player);
snipertrig delete();
weapontrig delete();
wait(0.05);
player SetOrigin (jumpjumpertele.origin);
player setplayerangles (jumpjumpertele.angles);
player TakeAllWeapons();
player GiveWeapon ("knife_mp");
wait(0.05);
level.activ SetOrigin (jumpactitele.origin);
level.activ setplayerangles (jumpactitele.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon ("knife_mp");
wait(0.05);
player switchToWeapon ("knife_mp");
level.activ SwitchToWeapon ("knife_mp");
iPrintLnBold(player.name+ "^4 has entered the ^1Jump Room");
wait 0.4;
player thread onDeath_jump();
wait 0.1;

    for(;;)
    {
		wait .1;
		while(isAlive(player))
		{
			wait 1;
		}

    }
}

onDeath_jump()
{
	self endon("disconnect");

	self waittill("death");
	thread jump_tele();
}


jump_wep()
{
trigger = getent ("give_wep_trig", "targetname");
trigger waittill ("trigger", user);
trigger delete();
user iPrintLnBold(user.name+ "^4 has gotten the Jump Room ^1weapon!");
wait 0.01;
user giveWeapon ("m40a3_acog_mp");
wait 0.1;
user switchToWeapon ("m40a3_acog_mp");

}