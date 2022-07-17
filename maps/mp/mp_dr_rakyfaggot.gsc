

#include braxi\_common;
#include common_scripts\utility;
#include braxi\_rank;


main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");

	setDvar( "r_specularcolorscale", "1" );
	setDvar("r_glowbloomintensity0",".25");
	setDvar("r_glowbloomintensity1",".25");
	setDvar("r_glowskybleedintensity0",".3");
	setDvar("compassmaxrange","2500");
	setDvar("bg_fallDamageMinHeight","1000000");
	setDvar("bg_fallDamageMaxHeight","10000000");

	precacheItem("rpd_mp");

	thread startdoor();
	thread messages();
	thread knife();
	thread sniper();
	thread weapon();

	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();


	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );

}

	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

messages()
{
wait 10;
for(;;)
{
wait 35;
x=randomint(7);
if (x==0)
{
iPrintln("^4Map by ^6PrOmar21!!!R");
}

if (x==1)
{
iPrintln("^6Special thankk me friend mustafa :DDD");
}

if (x==2)
{
iPrintln("^5Hey");
}

if (x==3)
{
iPrintln("^3me third map enjoy ok");
}

if (x==4)
{
iPrintln("^4sorry i dont have steam");
}

if (x==5)
{
iPrintln("^3i think this no bug but say me ok");
}

if (x==6)
{
iPrintln("^2map done for pakistan plese no steal");
}

}
}

startdoor() {
	door = getEnt("startdoor", "targetname");
	level waittill("round_started");
	thread credits();
	wait 12;
	door moveZ(-324, 1.5);
	wait 1.5;
}


credits()
{
iPrintLnBold("^1Now Playing^3: ^6rAKy^5's official theme song");
ambientPlay("music1");
wait 2;
	noti = SpawnStruct();
	noti.titleText = "^5rAKy ^6Faggot";
	noti.notifyText = "^1Map made by ^3PrOmar21";
	noti.duration = 6;
	noti.glowcolor = (1,.2,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	wait 8;
	noti.titleText = "^3Start opening...";
	noti.notifyText = "";
	noti.glowcolor = (1,.2,0);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
}

antiglitcher()
{
self common_scripts\utility::waittill_any("death","disconnect");
wait 0.05;
if (level.room == true)
{
		iPrintlnBold("^3"+self.name+" ^1died");
		wait 0.2;
		iPrintlnBold("^3Room selection open!");
}
}

waitdead()
{
activator = GetActivator();
bounce = getent("trig_weapon","targetname");
sniper = getent("trig_sniper","targetname");
knife = getent("trig_knife","targetname");

bounce thread maps\mp\_utility::triggerOff();
sniper thread maps\mp\_utility::triggerOff();
knife thread maps\mp\_utility::triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
activator freezeControls(false);
self freezeControls(false);

activator.health = activator.maxhealth;
bounce thread maps\mp\_utility::triggerOn();
sniper thread maps\mp\_utility::triggerOn();
knife thread maps\mp\_utility::triggerOn();
}

GetActivator()
{
	players = getentarray( "player", "classname" );

	for(i = 0;i < players.size;i++)
	{
		player = players[i];

		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}

	return "Noactivator";
}

createhud(messages)
{
hud_start = NewHudElem();
hud_start.alignX = "center";
hud_start.alignY = "middle";
hud_start.horzalign = "center";
hud_start.vertalign = "middle";
hud_start.alpha = 1;
hud_start.x = 0;
hud_start.y = -150;
hud_start.font = "objective";
hud_start.fontscale = 2;
hud_start.glowalpha = 1;
hud_start.glowcolor = (0,.2,.8);
hud_start setText(messages);
//hud_start setPulseFX( 100, 4000, 500 );
hud_start setPulseFX( 70, 4000, 500 );
wait 7;
if(isdefined(hud_start))
	hud_start destroy();
}

knife()
{
knife = getent("trig_knife","targetname");
jumper = getent("o_sniper1","targetname");
acti = getent("o_sniper2","targetname");
knife setHintString("^3Knife");
for(;;)
{
	knife waittill("trigger", player);

	player thread waitdead();
	player thread antiglitcher();
	activator = GetActivator();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("knife_mp");
	player giveweapon("knife_mp");
	thread createhud(player.name + " ^3entered Knife room!");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
	}
}

sniper()
{
sniper = getent("trig_sniper","targetname");
jumper = getent("o_sniper1","targetname");
acti = getent("o_sniper2","targetname");
sniper setHintString("^1Sniper");
for(;;)
{
	sniper waittill("trigger", player);

	player thread waitdead();
	player thread antiglitcher();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("m40a3_mp");
	activator giveweapon("m40a3_mp");
	player giveweapon("remington700_mp");
	activator giveweapon("remington700_mp");
	thread createhud(player.name + " ^3selected ^1Sniper ^3room!");
	wait 5;
	player iprintlnbold("^8FIGHT!");
	activator iprintlnbold("^9FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("m40a3_mp");
	activator switchtoweapon("m40a3_mp");
	player givemaxammo("m40a3_mp");
	activator givemaxammo("m40a3_mp");
	}
}

weapon()
{
sniper = getent("trig_weapon","targetname");
jumper = getent("o_sniper1","targetname");
acti = getent("o_sniper2","targetname");
sniper setHintString("^3Weapon");
for(;;)
{
	sniper waittill("trigger", player);

	player thread waitdead();
	player thread antiglitcher();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("rpd_mp");
	activator giveweapon("rpd_mp");
	thread createhud(player.name + " ^3selected ^1Weapon ^3room!");
	wait 5;
	player iprintlnbold("^8FIGHT!");
	activator iprintlnbold("^9FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("rpd_mp");
	activator switchtoweapon("rpd_mp");
	player givemaxammo("rpd_mp");
	activator givemaxammo("rpd_mp");
	}
}


trap1()
{
	trig = getEnt("trig_trap1","targetname");
	a = getEnt("trap1","targetname");
	trig setHintString("^3Press ^1F ^3to activate!");
	trig waittill("trigger", player);
	trig delete();
	a delete();
}

trap2()
{
	trig = getEnt("trig_trap2","targetname");
	a = getEnt("trap2","targetname");
	trig setHintString("^3Press ^1F ^3to activate!");
	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
		a rotateRoll(360, 1);
		wait 4;
	}
}

trap3()
{
	trig = getEnt("trig_trap3","targetname");
	a = getEnt("trap3a","targetname");
	b = getEnt("trap3b","targetname");
	trig setHintString("^3Press ^1F ^3to activate!");
	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
		a rotatePitch(360, 1);
		b rotatePitch(-360, 1);
		wait 4;
	}
}

trap4()
{
	trig = getEnt("trig_trap4","targetname");
	a = getEnt("trap4","targetname");
	trig setHintString("^3Press ^1F ^3to activate!");
	trig waittill("trigger", player);
	trig delete();
	a delete();
}

