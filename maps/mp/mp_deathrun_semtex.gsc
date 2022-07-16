						//////////////////////////////////////////////////////////
						//	 ____  _____    _  _____ _   _ ____  _   _ _   _ 	//	
						//	|  _ \| ____|  / \|_   _| | | |  _ \| | | | \ | |	//
						//	| | | |  _|   / _ \ | | | |_| | |_) | | | |  \| |	//
						//	| |_| | |___ / ___ \| | |  _  |  _ <| |_| | |\  |	//
						//	|____/|_____/_/   \_\_| |_| |_|_| \_\\___/|_| \_|	//
						//		 ____  _____ __  __ _____ _______  __			//
						//		/ ___|| ____|  \/  |_   _| ____\ \/ /			//
						//		\___ \|  _| | |\/| | | | |  _|  \  / 			//
						//		 ___) | |___| |  | | | | | |___ /  \ 			//
						//		|____/|_____|_|  |_| |_| |_____/_/\_\			//
						//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////////////////////////////
		//		 __  __           _        _             _  __             _  __    	//
		//		|  \/  |         | |      | |           | |/ /            | |/ /    	//
		//		| \  / | __ _  __| | ___  | |__  _   _  | ' / ___  ___ ___| ' / ___ 	//
		//		| |\/| |/ _` |/ _` |/ _ \ | '_ \| | | | |  < / _ \/ __/ __|  < / _ \	//
		//		| |  | | (_| | (_| |  __/ | |_) | |_| | | . \  __/ (__\__ \ . \  __/	//
		//		|_|  |_|\__,_|\__,_|\___| |_.__/ \__, | |_|\_\___|\___|___/_|\_\___|	//
		//										__/ |                             		//
		//										|___/                              		//
		//						_  __      __  __    _ 									//
		//					   | | \ \    / /  | |  (_)									//
		//		 __ _ _ __   __| |  \ \  / /_ _| | ___ 									//
		//		/ _` | '_ \ / _` |   \ \/ / _` | |/ / |									//
		//	   | (_| | | | | (_| |    \  / (_| |   <| |									//
		//		\__,_|_| |_|\__,_|     \/ \__,_|_|\_\_|									//
		//////////////////////////////////////////////////////////////////////////////////

/*
		Map name: mp_deathrun_semtex
		Creators: Vaki&KecsKe
		Date: 2013. 06. 10.
		Xfire: rohatapad & vakihun
		Website: www.semtex.tk
		
		Update 1.1
		Fixed some litle bug
		Removed Bounce After C4 Trap
		Changed Main Music:Swedish House Mafia Don't You Worry Child
		No Longer activate the frist trap in Free Round (Added Start Door For The Activator)
		Date: 2013. 06. 18.
*/


		
#include maps\mp\_utility;
main()
{
	maps\mp\_load::main();
	precacheitem("usp_silencer_mp");
	precacheitem("uzi_silencer_mp");
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("ak74u_mp");
	precacheItem("deserteaglegold_mp");
	precacheItem("rpg_mp");
	precacheItem("g3_mp");
	precacheItem("winchester1200_mp");
	precacheItem("ak47_mp");
	precacheItem("rpd_mp");
	thread maps\mp\mp_deathrun_semtex_fx::main();
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	thread way_connect();
	thread map_setup();
}

map_setup()
{
thread slidek_t();
thread secretweapon();
thread secretunlcoker();
thread finaldoor();
thread bouncew();
thread frist_door();
//thread trap01();
//thread trap02();
//thread trap03();
//thread trap04();
//thread trap05();
//thread trap06();
//thread trap07();
//thread trap08();
//thread trap09();
//thread trap10();
thread tele();
thread nyilt();
// thread mover();
// thread finalmover();
//thread old();
//thread sniper();
//thread weapons();
thread endtrig();
//thread lava();
//thread knife();
//thread fakesecret();
thread bounce();
thread creators();
level waittill("round_ended");
AmbientStop();
}

slidek_t()
{
trig = getent("slideknife_t","targetname");
acti = getent(trig.target,"targetname");
jumper = getent(acti.target,"targetname");
for(;;)
{
	trig waittill("trigger", player);
	activator = GetActivator();
	if(player == activator)
	{
		player setorigin(acti.origin);
		player setPlayerAngles(acti.angles);
	}
	else
	{
		player setPlayerAngles(jumper.angles);
		player setorigin(jumper.origin);
	}
}
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	
    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

bouncesniper(jumper)
{
level endon("Bouncehudstop");
orig = getent("bouncesniper","targetname");
trig = getent(orig.target,"targetname");
orig thread sniperrotate();
for(;;)
{
	trig waittill("trigger", player);
	if(player == jumper)
	{
		level.jumperbouncehud setText("Jumper^2(" + Player.name + ")^5 Has Sniper");
		level.bouncejumperhasniper = 1;
	}
	else if(player == GetActivator())
	{
		level.actibouncehud setText("Activator^2(" + Player.name + ")^5 Has Sniper");
		level.bounceactihasniper = 1;
	}
	else
	{
		player suicide();
	}
	player takeallweapons();
	player giveweapon("remington700_mp");
	player switchtoweapon("remington700_mp");
	wait 1;
	}
}

sniperrotate()
{
level endon("Bouncehudstop");
model = spawn("script_model",self.origin);
model setmodel("weapon_remington700");
for(;;)
{
	model rotateyaw(360, 5);
	wait 5;
	}
}
bouncehud(jumper)
{
level endon("Bouncehudstop");
level.bouncejumperhasniper = 0;
level.bounceactihasniper = 0;
level.actibouncehud = createbouncehud(-80);
level.jumperbouncehud = createbouncehud(-100);
thread bouncesniper(jumper);
Acti = GetActivator();
if(!isdefined(acti))
{
	acti = jumper;
}
if(!isdefined(jumper))
{
	jumper.name = "NOJUMPER!";
}
level.actibouncehud setText("Activator^2(" + acti.name + ")^1 Fail:^5 0");
level.jumperbouncehud setText("Jumper^2(" + jumper.name + ")^1 Fail:^5 0");
thread bouncefailcounting(jumper);
}

aktilow()
{
if(!level.bounceactifail == 15)
{
	self freezeControls(true);
	ClientAnnouncement( self, "^1Do not jump down deliberately!");
	wait 5;
	ClientAnnouncement( self, "^1Move!");
	self freezeControls(false);
	}
}

aktiantilow()
{
level.aktiantilow = 1;
wait 4;
level.aktiantilow = 0;
}

bouncefailcounting(jumper)
{
level endon("Bouncehudstop");
trig = getent("bouncefail","targetname");
knifejump = getent("37","targetname");
knifeacti = getent(knifejump.target,"targetname");
jumperorigin = getent("bouncejumper","targetname");
actiorigin = getent(jumperorigin.target,"targetname");
level.bouncejumperfail = 0;
level.bounceactifail = 0;
level.aktiantilow = 0;
for(;;)
{
	acti = GetActivator();
	trig waittill("trigger", player);
	if(player == jumper)
	{
	if(level.bouncejumperhasniper == 0)
	{
		level.bouncejumperfail ++;
		level.jumperbouncehud setText("Jumper^2(" + player.name + ")^1 Fail: ^5" + level.bouncejumperfail);
	}
	if(level.bouncejumperfail == 15 && level.bounceactihasniper == 0)
	{
		jumper suicide();
		iprintlnbold("^2Jumper ^1Killed ^2He's Noob (Failed 15 Times)");
	}
	else
	{
		jumper setorigin(jumperorigin.origin);
		jumper setPlayerAngles(jumperorigin.angles);
	}	
	}
	else if(player == acti)
	{
	if(level.bounceactihasniper == 0)
	{
		level.bounceactifail ++;
		level.actibouncehud setText("Activator^2(" + player.name + ")^1 Fail: ^5" + level.bounceactifail);
		if(level.aktiantilow == 1)
		{
			player thread aktilow();
		}
		thread aktiantilow();
	}
	if(level.bounceactifail == 15 && level.bouncejumperhasniper == 0)
	{
		iprintlnbold("^2Activator Failed 15 Times!! Teleported to Knife Fight");
		jumper setorigin(knifejump.origin);
		jumper setPlayerAngles(knifejump.angles);
		acti setorigin(knifeacti.origin);
		acti setPlayerAngles(knifeacti.angles);
		level notify("Bouncehudstop");
	}
	else
	{
		acti setorigin(actiorigin.origin);
		acti setPlayerAngles(actiorigin.angles);
		}
	}
	else
	{
		player suicide();
		iprintlnbold("^1Bad Player In Bounce Room");
	}
	wait .1;
}
}

createbouncehud(y)
{
hud = newHudElem();
hud.x = -20;
hud.y = y;
hud.horzAlign = "Right";
hud.vertAlign = "Bottom";
hud.alignX = "Right";
hud.alignY = "Bottom";
hud.font = "default";
hud.archived = false;
hud.fontScale = 1.6;
hud.color = (1,0,0);
return hud;
}

bounce()
{
bounce = getent("bounce","targetname");
old = getent("old","targetname");
jumper = getent(bounce.target,"targetname");
acti = getent(jumper.target,"targetname");
for(;;)
{
	bounce waittill("trigger", player);
	old delete();
	if(!isdefined(level.roommusic))
	{
		thread endmusic("lava", 215, "^1<<< ^3Now playing ^2[[^5 Find You (Clark Kent Remix) ^2]] ^1>>>");
		level.roommusic = 1;
	}
	player thread waitdead();
	activator = GetActivator();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("tomahawk_mp");
	player giveweapon("tomahawk_mp");
	thread createhud(player.name + " ^2Selected Bounce Room^1!..");
	wait 5;
	thread bouncehud(player);
	player iprintlnbold("^2Jump");
	activator iprintlnbold("^2Jump");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("tomahawk_mp");
	activator switchtoweapon("tomahawk_mp");
	}
}

fakesecret()
{
s = getentarray("fakesecret","targetname");
for(i=0;i<s.size;i++)
{
	s[i] thread fakesecretsetup(i);
	}
}

fakesecretsetup(i)
{
s = getentarray("fakesecret","targetname");
k = s.size + 2;
for(;;)
{
	self waittill("trigger", idiot);
	if(!isdefined(idiot.fakesecret[i]))
	{
		idiot.fakesecret[i] = 1;
		if(!isdefined(idiot.secretnumber))
		{
			idiot.secretnumber = 0;
		}
		idiot.secretnumber += 1;
		if(idiot.secretnumber == s.size)
		{
			idiot iprintlnbold("^2You win:^1 10 XP^3 :D");
			idiot thread braxi\_rank::giveRankXP("", 10);
			idiot suicide();
		}
		else
		{
			idiot iprintlnbold("^2Secret Step^3:^1 " + idiot.secretnumber + "^5/^1" + k + " ^2Complet!");
		}
	}	
}
}

endtrig()
{
level.jatekosend = 0;
door = getent("utcsodoor","targetname");
org = getent("end_org","targetname");
org1 = getent(org.target,"targetname");
org2 = getent(org1.target,"targetname");
trig = getent("end_trig","targetname");
hurt = getent("end_hurt","targetname");
}

endtrigantibug(trig)
{
self common_scripts\utility::waittill_any("death","disconnect");
level.jatekosend = 0;
trig SetHintString("^1Press &&1 !..");
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

lavadmg()
{
orig = getent("bocsma","targetname");
for(;;)
{
	self waittill("trigger", player);
	if(player == GetActivator())
	{
		iPrintLnBold("^1Activator Failed In Lava But Didn't Die!..");
		player freezeControls(true);
		player setorigin(orig.origin);
		player setPlayerAngles(orig.angles);
		player iPrintLnBold("^1Wait The Jumper Kill You");
	}
	else
	{
		player suicide();
	}
	wait .1;
	}
}

lava()
{
level.lavadown = 1;
old = getent("old","targetname");
lava = getent("lava","targetname");
lavak = getent("lavak","targetname");
dmg = getent("lava_damage","targetname");
jumper = getent(lava.target,"targetname");
acti = getent(jumper.target,"targetname");
dmg enablelinkto();
dmg linkto(lavak);
dmg thread lavadmg();
for(;;)
{
	lava waittill("trigger", player);
	old delete();
	player thread waitdead();
	if(!isdefined(level.roommusic))
	{
		thread endmusic("lava", 215, "^1<<< ^3Now playing ^2[[^5 Find You (Clark Kent Remix) ^2]] ^1>>>");
	}
	level.roommusic = 1;
	thread createhud(player.name + " ^1Selected Lava Jump Way^7!!");
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	player takeallweapons();
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator takeallweapons();
	activator giveweapon("tomahawk_mp");
	player giveweapon("tomahawk_mp");
	wait 5;
	player switchtoweapon("tomahawk_mp");
	activator switchtoweapon("tomahawk_mp");
	IPrintLnbold("^2 3");
	wait 1;
	IPrintLnbold("^3 2");
	wait 1;
	IPrintLnbold("^1 1");
	wait 1;
	iPrintLnBold("^1Lava Is Rising....");
	player freezeControls(false);
	activator freezeControls(false);
	lavak moveto((-2560, 1536, 256), 17);
	level.lavadown = 0;
	lavak waittill("movedone");
	wait 2;
	iPrintLnBold("^1Lava Is Lowering ....");
	lavak moveto((-2560, 1536, -280), 10);
	lavak waittill("movedone");
	level.lavadown = 1;
	while( isAlive( player ) && isDefined( player ) )
            wait .1;
	lava triggerOn();
	}
}
weapons()
{
weapons = getent("weapons","targetname");
old = getent("old","targetname");
jumper = getent(weapons.target,"targetname");
acti = getent(jumper.target,"targetname");
for(;;)
{
	weapons waittill("trigger", player);
	old delete();
	player thread waitdead();
	thread createhud(player.name + " ^1Selected Weapons Way^7!!");
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	wait 5;
	IPrintLnbold("^2Fight!!!.");
	i = randomintrange(0, 11);
	weapon = "rpg_mp";
	if(i == 0)
	{
		weapon = "saw_grip_mp";
	}
	else if(i == 1)
	{
		weapon = "rpg_mp";
	}
	else if(i == 2)
	{
		weapon = "winchester1200_mp";
	}
	else if(i == 3)
	{
		weapon = "m1014_grip_mp";
	}
	else if(i == 4)
	{
		weapon = "saw_grip_mp";
	}
	else if(i == 5)
	{
		weapon = "g3_mp";
	}
	else if(i == 6)
	{
		weapon = "mp44_mp";
	}
	else if(i == 7)
	{
		weapon = "ak47_mp";
	}
	else if(i == 8)
	{
		weapon = "rpd_mp";
	}
	else if(i == 9)
	{
		weapon = "p90_silencer_mp";
	}
	else if(i == 10)
	{
		weapon = "uzi_silencer_mp";
	}
	player giveweapon(weapon);
	activator giveweapon(weapon);
	activator givemaxammo(weapon);
	player givemaxammo(weapon);
	wait .1;
	player switchtoweapon(weapon);
	activator switchtoweapon(weapon);
	player thread ammo();
	activator thread ammo();
	player freezeControls(false);
	activator freezeControls(false);
	}
}

ammo()
{
self endon("round_ended");
self endon("death");
self endon("disconected");
wait 1;
for(;;)
{
	weapon = self GetCurrentWeapon();
	ammo = self GetWeaponAmmoStock(weapon);
	if(weapon == "none")
	{
		wait 1;
	}
	else if(0 >= ammo)
	{
		self IPrintLnbold("^2Max Ammo!");
		self givemaxammo(weapon);
		}
	wait .1;
	}
}
old()
{
old = getent("old","targetname");
jumper = getent(old.target,"targetname");
acti = getent(jumper.target,"targetname");
for(;;)
{
	old waittill("trigger", player);
	old delete();
	player thread waitdead();
	thread createhud(player.name + " ^1Selected Old Way^7!!");
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	}
}

sniper()
{
sniper = getent("sniper","targetname");
old = getent("old","targetname");
jumper = getent(sniper.target,"targetname");
acti = getent(jumper.target,"targetname");
for(;;)
{
	sniper waittill("trigger", player);
	old delete();
	if(!isdefined(level.roommusic))
	{
		thread endmusic("sniper", 235, "^5<<< ^3Now playing ^2((^1Lullaby of a Deadman^2)) ^5>>>");
	}
	level.roommusic = 1;
	player thread waitdead();
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
	thread createhud(player.name + " ^5select sniper fight!");
	wait 5;
	player iprintlnbold("^5FIGHT");
	activator iprintlnbold("^5FIGHT");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("m40a3_mp");
	activator switchtoweapon("m40a3_mp");
	player givemaxammo("m40a3_mp");
	activator givemaxammo("m40a3_mp");
	}
}

knife()
{
knife = getentarray("knife","targetname");
for(i=0;i<knife.size;i++)
{
	knife[i] thread knifesetuping();
	}
}

knifesetuping()
{
old = getent("old","targetname");
jumper = getent(self.target,"targetname");
acti = getent(jumper.target,"targetname");
for(;;)
{
	self waittill("trigger", player);
	old delete();
	if(!isdefined(level.roommusic))
	{
		thread endmusic("sniper", 235, "^5<<< ^3Now playing ^2((^1Lullaby of a Deadman^2)) ^5>>>");
	}
	level.roommusic = 1;
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	activator giveweapon("tomahawk_mp");
	player giveweapon("tomahawk_mp");
	thread createhud(player.name + " ^2Selected Knife Fight^1!..");
	wait 5;
	player iprintlnbold("^1FIGHT");
	activator iprintlnbold("^1FIGHT");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("tomahawk_mp");
	activator switchtoweapon("tomahawk_mp");
	}
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
hud_start.glowcolor = (1,0,0);
hud_start setText(messages);
hud_start SetPulseFX( 100, 4000, 500 );
wait 7;
if(isdefined(hud_start))
	hud_start destroy();
}

waitdead()
{
weapons = getent("weapons","targetname");
bounce = getent("bounce","targetname");
sniper = getent("sniper","targetname");
lava = getent("lava","targetname");
knife = getentarray("knife","targetname");
knife[0] triggerOff();
knife[1] triggerOff();
bounce triggerOff();
sniper triggerOff();
weapons triggerOff();
lava triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
thread createhud("[[" + self.name + "]] ^1K.I.A");
activator = GetActivator();
activator freezeControls(false);
level notify("Bouncehudstop");
level.jumperbouncehud destroy();
level.actibouncehud destroy();
bounce triggerOn();
sniper triggerOn();
weapons triggerOn();
knife[0] triggerOn();
knife[1] triggerOn();
if(level.lavadown == 1)
{
	lava triggerOn();
}	
level.jatekosend = 0;
}

finaldoor()
{
door = getent("finaldoor","targetname");
trig = getent("endmap_trig","targetname");
trig waittill("trigger", player);
thread createhud("^2Final Door Is Open By: ^1" + player.name);
door movez(180, 3, 2);
}

finalmover()
{
mover = getentarray("finalmover","targetname");
for(i=0;i<mover.size;i++)
{
	mover[i] thread finalmovers();
	wait 3;
	}
}

finalmovers()
{
path1 = getent("auto21","targetname");
path2 = getent(path1.target,"targetname");
path3 = getent(path2.target,"targetname");
path4 = getent(path3.target,"targetname");
for(;;)
{
	self moveto(path1.origin, 3);
	self waittill ("movedone");
	self moveto(path2.origin, 3);
	self waittill ("movedone");
	self moveto(path3.origin, 3);	
	self waittill ("movedone");
	self moveto(path4.origin, 3);
	self waittill ("movedone");
}
}

secretweapon()
{
trig = getent("eagle_trig","targetname");
for(;;)
{
	trig waittill("trigger", player);
	if(!player.fegyo == 1 && !level.secretweaponinuse == 1)
	{
		player thread secret_w_setup();
		level.secretweaponinuse = 1;
		}
	}
	wait .1;
	
}

secret_w_setup()
{
ori = getent("secret_dessert","targetname");
weapon_m = spawn("script_model",ori.origin + (0,0,40));
weapon_m setmodel("tag_origin");
self.fegyo = 1;
time = .1;
weapon_m moveto(ori.origin + (0,0,20), 4);
weapon = "none";
k = 9;
for(u=0;u<16;u++)
{
	i = randomintrange(0, 10);
	if(i == k)
	{
		if(i == 9)
		{
			i -= 1;
		}
		else
		{
			i += 1;
		}
	}
	k = i;
	if(i == 0)
	{
		weapon_m setmodel("weapon_saw");
		weapon = "Saw_grip_mp";
	}
	else if(i == 1)
	{
		weapon_m setmodel("weapon_rpg7");
		weapon = "rpg_mp";
	}
	else if(i == 2)
	{
		weapon_m setmodel("weapon_p90_sd");
		weapon = "p90_silencer_mp";
	}
	else if(i == 3)
	{
		weapon_m setmodel("weapon_mini_uzi_silencer");
		weapon = "uzi_silencer_mp";
	}
	else if(i == 4)
	{
		weapon_m setmodel("weapon_dragunov");
		weapon = "dragunov_acog_mp";
	}
	else if(i == 5)
	{
		weapon_m setmodel("weapon_g3");
		weapon = "g3_mp";
	}
	else if(i == 6)
	{
		weapon_m setmodel("weapon_benelli_super_90");
		weapon = "m1014_grip_mp";
	}
	else if(i == 7)
	{
		weapon_m setmodel("weapon_ak47");
		weapon = "ak47_mp";
	}
	else if(i == 8)
	{
		weapon_m setmodel("weapon_rpd");
		weapon = "rpd_mp";
	}
	else if(i == 9)
	{
		weapon_m setmodel("weapon_mp44");
		weapon = "mp44_mp";
	}
	wait time;
	time += .025;
	}
if(400 >= Distance2D(weapon_m.origin, self.origin))
{
	weapon_m moveto(self.origin + (0,0,40), .5);
	wait .5;
	weapon_m delete();
	self iPrintlnBold("^2Your weapon: ^1" + weapon);
	self giveweapon(weapon);
	wait .1;
	self givemaxammo(weapon);
	self switchtoweapon(weapon);
	level.secretweaponinuse = 0;
}
else
{
	self iPrintlnBold("^1What are you waiting for? ^2Do you expect it to fly to you?");
	weapon_m delete();
	level.secretweaponinuse = 0;
	}
}

secretunlcoker()
{

}

secretopen1()
{
}

secretopen()
{

}

tele()
{
tele = getentarray("tele","targetname");
for(i=0;i<tele.size;i++)
{
	target = getentarray(tele[i].target,"targetname");
	tele[i] thread telesetup(target);
	}
}

telesetup(target)
{
for(;;)
{
	self waittill("trigger", user);
	i = 0;
	user setorigin(target[i].origin);
	user setPlayerAngles(target[i].angles);
	wait .01;
	}
}

bouncew()
{
level endon("bounced");
b1 = getent("bounce01","targetname");
for(;;)
{
	b1 waittill("trigger", player);
	player thread bounce_watch();
	}
}

bounce_watch()
{
}

endmusic(music, time, playing)
{
level notify("endmusic");
AmbientStop();
wait 1;
for(;;)
{
	AmbientPlay(music);
	iprintln(playing);
	iprintln(playing);
	iprintln(playing);
	wait time;
	AmbientStop();
	wait 1;
	}
}

music()
{

}
creators()
{
wait 20;
iprintln("Map made by ^5KecsKe & Vaki");
wait 30;
iprintln("If you found any bug please report it");
wait 0.5;
iprintln("x^5F^7ire: ^7rohatapad^5, ^7vakihun");
wait 30;
iprintln("Visit:^5www.semtex.tk");
}
mover()
{
mover = getent("mover","targetname");
p1 = getent("move01","targetname");
p2 = getent("move02","targetname");
for(;;)
{
	mover moveto(p2.origin, 4.2, 1, 1);
	mover waittill ("movedone");
	wait 1;
	mover moveto(p1.origin, 4.2, 1, 1);
	mover waittill ("movedone");
	wait 1;
	}
}

nyilt()
{
nyil = getentarray("nyil","targetname");
nyily = getentarray("nyily","targetname");
for(i=0;i<nyil.size;i++)
{
	nyil[i] thread nyil_setup("movez");
	wait .3;
}
for(u=0;u<nyily.size;u++)
{
	nyily[u] thread nyil_setup("movey");
	}
}

nyil_setup(where)
{
for(;;)
{
	if(where == "movey")
	{
		self movey(-40, 2, .9, .9);
		self waittill ("movedone");
		wait .5;
		self movey(40, 2, .9, .9);
		self waittill ("movedone");
		wait .5;
	}
	else if(where == "movez")
	{
		self movez(-20, 2, .9, .9);
		self waittill ("movedone");
		wait .5;
		self movez(20, 2, .9, .9);
		self waittill ("movedone");
		wait .5;
		}
	}
}

frist_door()
{
trig = getent("frist_door_t","targetname");
door = getentarray("frist_door","targetname");
door_c = getent("frist_door_c","targetname");
door_c linkto(door[0]);
for(u=0;u<door.size;u++)
{
	door[u] delete();
	}
door_c delete();
wait 4;
thread welcomecucc();
}

welcomecucc()
{
wait 2;
thread welcomecuc("DeathRun SemteX" );
wait 6;
thread welcomecuc("Made by KecsKe & Vaki" );
}

welcomecuc(text)
{
	welcomehud = new_hud( "center", 0.1, 1000, 100 );
	welcomehud setText( text );
	welcomehud moveOverTime( 2 );
	welcomehud.x = 0;
	wait( 4 );
	welcomehud moveOverTime( 2 );
	welcomehud.x = 1000 * -1;
	wait 1;
	welcomehud destroy();
}
new_hud( align, fade_in_time, x_off, y_off )
{
	welcomehud2 = newHudElem();
    welcomehud2.foreground = true;
	welcomehud2.x = x_off;
	welcomehud2.y = y_off;
	welcomehud2.alignX = align;
	welcomehud2.alignY = "middle";
	welcomehud2.horzAlign = align;
	welcomehud2.vertAlign = "middle";
 	welcomehud2.fontScale = 3;
	welcomehud2.color = (1, 1, 1);
	welcomehud2.font = "objective";
	welcomehud2.glowColor = (0, 0.5, 1);
	welcomehud2.glowAlpha = 1;
	welcomehud2.alpha = 0;
	welcomehud2 fadeovertime( fade_in_time );
	welcomehud2.alpha = 1;
	welcomehud2.hidewheninmenu = true;
	welcomehud2.sort = 10;
	return welcomehud2;
}

trap01()
{
level endon("traps_disabled");
trap1 = getentarray("trap01a","targetname");
trap2 = getentarray("trap01b","targetname");
trap3 = getentarray("trap01c","targetname");
but = getent("trap01trig","targetname");
but waittill ("trigger", who);
but SetHintString("^1Activated");
r = RandomIntRange(0, 3);
if(r == 0)
{
	trap1[0] notsolid();
	trap1[1] notsolid();
}
else if(r == 1)
{
	trap2[0] notsolid();
	trap2[1] notsolid();
}
else
{
	trap1[0] notsolid();
	trap2[1] notsolid();
}
r = RandomIntRange(0, 2);
if(r == 1)
{
	trap3[0] notsolid();
	trap3[1] notsolid();
	}
}

trap02()
{
level endon("traps_disabled");
trap = getentarray("trap02","targetname");
trap[0] movey(16, 1);
trap[1] movey(16, 1);
but = getent("trap02trig","targetname");
but waittill ("trigger", who);
but SetHintString("^1Activated");
i = RandomIntRange(0, trap.size);
trap[i] movey(-688, 1.5);
trap[i] waittill ("movedone");
wait RandomIntRange(2, 5);
trap[i] movey(688, 1.5);
}

trap03()
{
level endon("traps_disabled");
but = getent("trap03trig","targetname");
trap = getent("trap03","targetname");
trap_d = getent("dmg01","targetname");
but waittill ("trigger", who);
but SetHintString("^1Activated");
trap movez(-160, 1);
wait .7;
trap_d thread suicide_setup();
trap waittill ("movedone");
wait 2;
trap movez(160, 1);
}

suicide_setup()
{
players = getEntArray("player","classname");	
for(k = 0; k < players.size; k++)
{
	if(players[k] isTouching(self))
		players[k] suicide();
	}
}

trap04()
{
level endon("traps_disabled");
trap1 = getent("trap04a","targetname");
trap2 = getent("trap04b","targetname");
trap3 = getent("trap04c","targetname");
but = getent("trap04trig","targetname");
but waittill ("trigger", who);
but SetHintString("^1Activated");
r = RandomIntRange(0, 2);
if(r == 0)
{
	trap1 movez(-217, 1);
}
else
{
	trap2 notsolid();
}
r = RandomIntRange(0, 2);
if(r == 1)
{
	trap3 movez(-217, 1);
	}
}

trap05()
{
level endon("traps_disabled");
trap = getent("trap05","targetname");
but = getent("trap05trig","targetname");
but waittill ("trigger", who);
but SetHintString("^1Activated");
trap rotateyaw(1440, 4);
wait 5;
trap rotateyaw(-1440, 4);
}

trap06()
{
level endon("traps_disabled");
trap = getent("trap06","targetname");
but = getent("trap06trig","targetname");
but waittill ("trigger", who);
level notify("aktivalva");
but SetHintString("^1Activated");
trap PlaySound("grenade_explode_metal");
playFx(level._effect["c4"],trap.origin);
trap hide();
players = getEntArray("player","classname");	
for(k=0;k<players.size;k++)
{
	dist = Distance2D(players[k].origin, trap.origin);
	if(dist < 200)
	{
		players[k] suicide();
	}
	else if(dist < 240)
	{
		RadiusDamage( players[k].origin, 10, 60, 40);
	}
	else if(dist < 280)
	{
		RadiusDamage( players[k].origin, 10, 30, 10);
		}
	}
}

trap07()
{
level endon("traps_disabled");
trap = getent("trap07","targetname");
but = getent("trap07trig","targetname");
but waittill ("trigger");
but SetHintString("^1Activated");
trap RotatePitch(360, 3);
wait 7;
trap RotatePitch(-360, 3);
}

trap08()
{
level endon("traps_disabled");
trap = getent("trap08","targetname");
but = getent("trap08trig","targetname");
but waittill ("trigger");
but SetHintString("^1Activated");
trap movex(256, 1);
wait 5;
trap movex(-256, 1);
}

trap09()
{
level endon("traps_disabled");
trap = getentarray("felle","targetname");
but = getent("trap09trig","targetname");
but waittill ("trigger", who);
if(who.pers["team"] == "allies")
{
	who suicide();
	iprintlnbold(who.name + " ^1is a Gay! Tried activate trap and He is Jumper!!");
}
else
{
but SetHintString("^1Activated");
for(k=0;k<trap.size;k++)
{
	trap[k] thread felle();
}
}
}

felle()
{
for(;;)
{
	i = randomintrange(1,3);
	self movez(-150, i);
	self waittill ("movedone");
	wait randomintrange(1,4);
	self movez(150, i);
	self waittill ("movedone");
	wait randomintrange(1,4);
	}
}

trap10()
{
level endon("traps_disabled");
trap = getentarray("trap10","targetname");
but = getent("trap10trig","targetname");
but waittill ("trigger", who);
if(who.pers["team"] == "allies")
{
	who suicide();
	iprintlnbold(who.name + " ^1is a Gay! Tried activate trap and He is Jumper!!");
}
else
{
but SetHintString("^1Activated");
for(k=0;k<trap.size;k++)
{
	trap[k] thread fellenormal();
	wait .5;
}
}
}
fellenormal()
{
for(;;)
{
	self movez(-150, 1);
	self waittill ("movedone");
	wait 1.5;
	self movez(150, 1);
	self waittill ("movedone");
	wait 1.5;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////		 ______           _          __    __ _ _     			////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////		|  ____|         | |        / _|  / _(_) |    			////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////		| |__   _ __   __| |   ___ | |_  | |_ _| | ___ 			////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////		|  __| | '_ \ / _` |  / _ \|  _| |  _| | |/ _ \			////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////		| |____| | | | (_| | | (_) | |   | | | | |  __/			////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////		|______|_| |_|\__,_|  \___/|_|   |_| |_|_|\___|			////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////                                              				////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////// __                 .   ,   .  .         .               .  .  .   .   //////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////  ` _ ._   .._.* _ |_ -+-  |_/  _  _. __;_/ _    _.._  _|  \  / _.;_/*//////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////\__.(_)[_)\_|[  |(_][ ) |   |  \(/,(_._) | \(/,  (_][ )(_]   \/ (_]| \| /////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////      |  ._|    ._|                                                     /////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////