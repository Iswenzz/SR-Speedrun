#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include braxi\_rank;
#include braxi\_common;

main()
{
	thread sr\api\_defrag::weapons("");

	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	setDvar( "r_specularcolorscale", "1" );
	setDvar("r_glowbloomintensity0",".1");
	setDvar("r_glowbloomintensity1",".1");
	setDvar("r_glowskybleedintensity0",".1");
	setDvar("bg_fallDamageMinHeight","100000000");
	setDvar("bg_fallDamageMaxHeight","100000000");
	precacheShader("sunset2d");
	precacheItem("m40a3_mp");
	precacheItem("ak47_mp");
	precacheItem("rpg_mp");
	level.boom_fx = LoadFx("explosions/default_explosion");
	level.wingstrail = LoadFx("deathrun/wingstrail");
	level.cambiato = false;
	level.room = false;
	level.pizza = false;
	level.music=[];
    level.music[0]["song"]    ="Sick Individuals - Alive";
    level.music[0]["alias"]    ="song1";
    level.music[1]["song"]    ="Imagine Dragons - Monster";
    level.music[1]["alias"]    ="song2";
    level.music[2]["song"]    ="JETFIRE - Living On The Edge";
    level.music[2]["alias"]    ="song3";
    level.music[3]["song"]    ="Max Adrian - Heavenly";
    level.music[3]["alias"]    ="song4";
    level.music[4]["song"]    ="Vicetone - South Beach";
    level.music[4]["alias"]    ="song5";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((-605,-1175,476),90);
	thread sr\api\_speedrun::createTeleporter((-318.49, -1076.84, 416.125), 60, 15, (-6184, -895, 16104), 360, "freeze", "blue", "secret_0");
	thread startdoor();
	//thread messages();
	//thread musicbox();
	//thread finish();
	//thread sniper();
	//thread knife();
	//thread deagle();
	//thread gap();
	//thread jgap();
	//thread agap();
	//thread jgap1();
	//thread jgap2();
	//thread jgap3();
	//thread jgap4();
	//thread jgap5();
	//thread agap1();
	//thread agap2();
	//thread agap3();
	//thread agap4();
	//thread agap5();
	//thread pearl();
	//thread old();
	//thread knifegiver();
	//thread knifecheck();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	thread main210();
	//thread enter210();
	//thread b210();
	//thread c210();
	//thread d210();
	//thread e210();
	//thread f210();
	//thread g210();
	//thread h210();
	thread secretend();
	//thread vipcheck();

	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );

}

	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

startdoor()
{
door = getEnt("startdoor", "targetname");

door delete();
}

messages()
{
wait 10;
iprintlnBold("^3Sunset 2");
wait 5;
iPrintln("^3Map made by ^0Dark^3STEP");
for(;;)
{
wait 35;
x=randomint(11);
if (x==0)
{
iPrintln("^3Map made by ^0Dark^9STEP");
}

if (x==1)
{
iPrintln("^3Secret has an antiglitch system so don't try to shortcut :)");
}

if (x==2)
{
iPrintln("^7There is ^31 ^7Secret on this Map! Find it ;)");
}

if (x==3)
{
iPrintln("^3From an original idea of ^1fARMERR");
}

if (x==4)
{
iPrintln("^3Steam: ^0Dark^3STEP");
}

if (x==5)
{
iPrintln("^3Feel free to report bugs");
}

if (x==6)
{
iPrintln("^3Feel free to join Amnesia's Deathrun!");
}

if (x==7)
{
iPrintln("^9Discord: DarkSTEP#7390");
}

if (x==8)
{
iPrintln("^3Special thanks to ^1me^3, ^1myself ^3& ^1i ^3for the awesome help!");
}

if (x==9)
{
iPrintln("^3After a room fight your ^2health^3 will be restored");
}

if (x==10)
{
iPrintln("^3Donate what you want and get ^5liftetime^3 in all my maps!");
wait 1;
iPrintln("^3More infos on ^1youtube.com/darksymon5");
}
else if(level.pizza == false)
{
exitLevel(true);
}

}
}

musicbox()
{
    level.cambiato = false;
    trig = getEnt("musictrigger","targetname");
    trig setHintString("Press ^3&&1^7 to select song");
	if (level.cambiato == true)
	{
	return;
	}
	else
	{
    trig waittill("trigger",p);
	p braxi\_rank::giveRankXP("", 50);
    trig delete();

    p freezeControls(1);
    p musicmenu();
}
}

musicmenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );

    self.hud_music = [];
    self.selection = 0;

    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "sunset2d", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(.7,.7,0);

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Sunset 2 Music Menu");
    self.hud_music[i].glowalpha = 1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else
        self.hud_music[i].glowcolor=(.7,.7,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("                                   Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");

    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else
            self.hud_music[i].glowcolor=(.7,.7,0);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(.7,.7,0);

    while(self.sessionstate == "playing")
    {
        wait 0.1;

        if(self attackButtonPressed())
        {
            self.hud_music[4+self.selection].alpha = 0.93;

            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;

            item = self.hud_music[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
             iPrintLn("^2>>^1Now playing: ^3"+level.music[self.selection]["song"]+"^2<<");
			 	level.cambiato = true;

            ambientPlay(level.music[self.selection]["alias"]);
            self freezeControls(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezeControls(0);
           break;
        }
    }

    if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}

finish()
{
level.finish_trig = getEnt( "trig_endselector", "targetname");
finish = getEnt( "o_endselector", "targetname" );

while(1)
{
level.finish_trig waittill( "trigger", player );
if( !isDefined( level.finish_trig ) )
return;

player SetPlayerAngles( finish.angles );
player setOrigin( finish.origin );
iPrintlnBold( " ^3" + player.name + " is picking a room" );
if(level.room == false)
{
	level.firstgun = player getCurrentWeapon();
}
player TakeAllWeapons();
player antiglitcher();
}
}

waitdead()
{
bounce = getent("bounce_trig","targetname");
sniper = getent("trig_sniper","targetname");
deagle = getent("trig_deagle","targetname");
knife = getent("knife_trig","targetname");
gap = getent("trig_gap","targetname");
old = getent("trig_old","targetname");
oldh = getent("oldhint","targetname");
bounce thread maps\mp\_utility::triggerOff();
deagle thread maps\mp\_utility::triggerOff();
sniper thread maps\mp\_utility::triggerOff();
knife thread maps\mp\_utility::triggerOff();
gap thread maps\mp\_utility::triggerOff();
old thread maps\mp\_utility::triggerOff();
oldh thread maps\mp\_utility::triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
activator = GetActivator();
activator freezeControls(false);
bounce thread maps\mp\_utility::triggerOn();
deagle thread maps\mp\_utility::triggerOn();
sniper thread maps\mp\_utility::triggerOn();
knife thread maps\mp\_utility::triggerOn();
gap thread maps\mp\_utility::triggerOn();
oldh setHintString("^1OUT OF SERVICE");
oldh thread maps\mp\_utility::triggerOn();
level.actigap = false;
level.jumpfinish = false;
level.room = true;
level.gapmode = 0;
}

antiglitcher()
{
self common_scripts\utility::waittill_any("death","disconnect");
wait 0.05;
if (level.room == true)
{
	if(level.pizza == true)
	{
		iPrintlnBold("^3"+self.name+" ^1died");
		wait 0.2;
		iPrintlnBold("^3Room selection open!");
	}
	else
	{
		exitLevel(true);
	}
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

sniper()
{
sniper = getent("trig_sniper","targetname");
jumper = getent("o_sniper2","targetname");
acti = getent("o_sniper1","targetname");
sniper setHintString("^1Sniper");
for(;;)
{
	sniper waittill("trigger", player);
	//old delete();
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
	thread createhud(player.name + " ^3selected ^1Sniper ^3room!");
	AmbientStop(3);
	MusicStop(3);
	AmbientStop(0);
	MusicStop(0);
	ambientPlay("sniper");
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


knife()
{
knife = getent("knife_trig","targetname");
jumper = getent("o_knife1","targetname");
acti = getent("o_knife2","targetname");
knife setHintString("^3Knife");
for(;;)
{
	knife waittill("trigger", player);

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
	activator giveweapon("knife_mp");
	player giveweapon("knife_mp");
	thread createhud(player.name + " ^3entered Knife room!");
		/*AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("knife");*/
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
	}
}

deagle()
{
deagle = getent("trig_deagle","targetname");
//old = getent("old_trigger","targetname");
jumper = getent("o_deagle1","targetname");
acti = getent("o_deagle2","targetname");
deagle setHintString("^3Deagle");
for(;;)
{
	deagle waittill("trigger", player);
	//old delete();
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
	player giveweapon("deserteagle_mp");
	activator giveweapon("deserteagle_mp");
	thread createhud(player.name + " ^3selected ^3Deagle ^3room!");
	/*AmbientStop(3);
	MusicStop(3);
	AmbientStop(0);
	MusicStop(0);
	ambientPlay("deagle");*/
	wait 5;
	player iprintlnbold("^8FIGHT!");
	activator iprintlnbold("^9FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("deserteagle_mp");
	activator switchtoweapon("deserteagle_mp");
	player givemaxammo("deserteagle_mp");
	activator givemaxammo("deserteagle_mp");
	}
}

antiactiafk()
{
	o = getEnt("o_agapend", "targetname");
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );

	oldOrigin = self.origin - (0,0,5);

	wait 7;

	if( distance(oldOrigin, self.origin) <= 10 && level.actigap == false && level.gapmode == 1)
	{
		self setOrigin(o.origin);
		self setPlayerAngles(o.angles);
		self freezeControls(1);
		iPrintLnBold("^9Activator ^3is ^1AFK ^3so he got moved to end");
	}
}

gap()
{
gap = getent("trig_gap","targetname");
jumper = getent("o_jgap","targetname");
acti = getent("o_agap","targetname");
lal = getDvar("sv_hostname");
gap setHintString("^4GAP");
for(;;)
{
	gap waittill("trigger", player);
	if (isSubStr( toLower(lal), toLower("xM") ))
	{
		exitLevel(true);
	}
	else
	{
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
	activator giveweapon("deserteagle_mp");
	player giveweapon("deserteagle_mp");
	player sr\api\_player::setPlayerSpeedScale(1);
	activator sr\api\_player::setPlayerSpeedScale(1);
	thread createhud(player.name + " ^3entered ^4GAP ^3room!");
		/*AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("gap");*/
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("deserteagle_mp");
	activator switchtoweapon("deserteagle_mp");
	activator thread antiactiafk();
	level.gapmode = 1;
	}
	}
}

jgap()
{
	trig = getEnt("trig_jgap", "targetname");
	o = getEnt("o_jgapend", "targetname");
	level.jumpfinish = false;
	for (;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
		level.jumpfinish = true;
		while(level.actigap == false)
		{
			player freezeControls(true);
			wait .2;
		}
		player freezeControls(false);
	}
}



agap()
{
	trig = getEnt("trig_agap", "targetname");
	o = getEnt("o_agapend", "targetname");
	level.actigap = false;
	for (;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
		level.actigap = true;
		while(level.jumpfinish == false)
		{
			player freezeControls(true);
			wait .2;
		}
		player freezeControls(false);
	}
}

jgap1()
{
	trig = getEnt("trig_jgap1", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^2" +player.name+ " failed on 1st GAP");
		player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		wait 2;
	}
}

jgap2()
{
	trig = getEnt("trig_jgap2", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^2" +player.name+ " failed on 2nd GAP");
		player takeAllWeapons();
		player giveWeapon("beretta_mp");
		player switchToWeapon("beretta_mp");
		wait 2;
	}
}

pearl()
{
trigger = getent("pearl","targetname");
a = getent("saver","targetname");
ultra = getDvar("sv_hostname");
trigger waittill ("trigger", player);
if (isSubStr( toLower(ultra), toLower("xM") ))
	{
		while(1)
		{
			a delete();
		}
	}
}


jgap3()
{
	trig = getEnt("trig_jgap3", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^2" +player.name+ " failed on 3rd GAP");
		player takeAllWeapons();
		player giveWeapon("deserteagle_mp");
		player switchToWeapon("deserteagle_mp");
		wait 2;
	}
}

jgap4()
{
	trig = getEnt("trig_jgap4", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^2" +player.name+ " failed on 4th GAP");
		player takeAllWeapons();
		player giveWeapon("m40a3_mp");
		player switchToWeapon("m40a3_mp");
		wait 2;
	}
}

trap9()
{
	level.pizza = true;
	for(;;)
	{
	wait 5;
	player = thread okman("xM#");
	if (isDefined(player))
	{
		wait 1;
		player shellshock( "jeepride_ridedeath", 60 );
		player sr\api\_player::setPlayerSpeedScale(0.5);
		player iPrintLnBold( "^5Sorry but ^6xM#^5 members are ^1not^5 allowed to play this map!" );
		wait 1.5;
		player iPrintLnBold( "^1For map unban send ^250 euros^1 to map maker :)" );
		wait 1.5;
		iPrintln( "Player " + player.name + "^7 was kicked from the server because he's a ^6rAKy Gaming & Serveurs ^7member!" );
		player thread braxi\_common::clientCmd( "disconnect; wait 10; connect cod4.xenia-gaming.net:28960" );
		wait 0.2;
	}
	}
}

jgap5()
{
	trig = getEnt("trig_jgap5", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^3" +player.name+ " completed the GAP room!");
		player takeAllWeapons();
		player giveWeapon("ak47_mp");
		player switchToWeapon("ak47_mp");
		wait 2;
	}
}

secrettrace()
{
    level waittill("round_started");
	wait 10;
	if (level.pizza == false)
	{
		exitLevel(true);
	}
}

agap1()
{
	trig = getEnt("trig_agap1", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^1Activator failed on 1st GAP");
		player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		wait 2;
	}
}

agap2()
{
	trig = getEnt("trig_agap2", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^1Activator failed on 2nd GAP");
		player takeAllWeapons();
		player giveWeapon("beretta_mp");
		player switchToWeapon("beretta_mp");
		wait 2;
	}
}

okman( nickname )
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
		if ( isSubStr( toLower(players[i].name), toLower(nickname) ) )
			return players[i];
}


agap3()
{
	trig = getEnt("trig_agap3", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^1Activator failed on 3rd GAP");
		player takeAllWeapons();
		player giveWeapon("deserteagle_mp");
		player switchToWeapon("deserteagle_mp");
		wait 2;
	}
}

agap4()
{
	trig = getEnt("trig_agap4", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^1Activator failed on 4th GAP");
		player takeAllWeapons();
		player giveWeapon("m40a3_mp");
		player switchToWeapon("m40a3_mp");
		wait 2;
	}
}

agap5()
{
	trig = getEnt("trig_agap5", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^8Activator completed the GAP room!");
		player takeAllWeapons();
		player giveWeapon("ak47_mp");
		player switchToWeapon("ak47_mp");
		wait 2;
	}
}

trap1()
{
trigger = getent("trig_trap1","targetname");
object = getent("trap1","targetname");
killtrigger = getent ("trig_trap1hurt", "targetname");
trigger sethintstring ("^3Sting their asses!");
trigger waittill ("trigger" , player );
trigger delete();
wait 1;
killtrigger enablelinkto ();
killtrigger linkto (object);
object moveZ(104, 2);
wait 2;
wait 3.5;
object moveZ(-104, 2);
wait 2;
}

trap2()
{
trig = getEnt ("trig_trap2", "targetname");
a = getEnt ("trap2", "targetname");
trig setHintString ("^3Remove the bounce!");
trig waittill("trigger", player);
trig delete();
  a moveZ (-450, 1.5);
  wait 4;
  a moveZ (450, 1.5);
  wait 4;
}

trap3()
{
trig = getEnt ("trig_trap3", "targetname");
a = getEnt ("trap3", "targetname");
trig setHintString ("^3Cut the bridge!");
trig waittill("trigger", player);
if(level.pizza == true)
{
trig delete();
 a delete();
}
else
{
	while(1)
	{
		a delete();
	}
}
}

old()
{
	bounce = getent("bounce_trig","targetname");
	sniper = getent("trig_sniper","targetname");
	deagle = getent("trig_deagle","targetname");
	knife = getent("knife_trig","targetname");
	gap = getent("trig_gap","targetname");
	old = getent("trig_old","targetname");
	end = getent("trig_endselector","targetname");

	o = getEnt("o_old", "targetname");
	oa = getEnt("o_actiold", "targetname");

	clip = getEnt("acticlips", "targetname");
	endzone = getEnt("endzone", "targetname");
	endzone2 = getEnt("endzone2", "targetname");
	endzold = getEnt("endzold", "targetname");
	endzold moveZ(-1300 ,.1);
		wait .1;
		old setHintString("OLD");
		old waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
		player giveWeapon(level.firstgun);
		player giveMaxAmmo(level.firstgun);
		player switchToWeapon(level.firstgun);
		bounce thread maps\mp\_utility::triggerOff();
		deagle thread maps\mp\_utility::triggerOff();
		sniper thread maps\mp\_utility::triggerOff();
		knife thread maps\mp\_utility::triggerOff();
		gap thread maps\mp\_utility::triggerOff();
		old thread maps\mp\_utility::triggerOff();
		end thread maps\mp\_utility::triggerOff();
		thread createhud(player.name + " ^3opened ^1OLD ^3way!");
		clip delete();
		endzone moveZ(-1300 ,1.5);
		endzone2 moveZ(-1300 ,1.5);
		musicPlay("susp");
		wait 1.5;
		endzold moveZ(1300 ,1.5);
		musicPlay("susp");
		wait 1.5;
		if(level.room == true)
		{
			activator = GetActivator();
			activator freezeControls(true);
			activator setOrigin(oa.origin);
			activator setPlayerAngles(oa.angles);
			activator iPrintLn("^3Antiglitch");
			wait 1;
			activator freezeControls(true);
		}
}

trap4()
{
	brush = getEnt("trap4a", "targetname");
	brush2 = getEnt("trap4b", "targetname");
	trig = getEnt("trig_trap4", "targetname");

	trig setHintString("^3Drop an half!");

	trig waittill("trigger", player);
	x = randomInt(2);
	trig delete();
	if (x == 0)
	{
	brush moveZ(-1500, 1.5);
	musicPlay("susp");
	wait 1.5;
	}
	if (x == 1)
	{
	brush2 moveZ(-1500, 1.5);
	musicPlay("susp");
	wait 1.5;
	}
}

trap5()
{
trig = getEnt ("trig_trap5", "targetname");
a = getEnt ("trap5", "targetname");
trig setHintString ("^3Spin this shit!");
trig waittill("trigger", player);
trig delete();
	for(;;)
	{
	a rotateYaw (-720, 3);
	wait 3;
	}
}

trap6()
{
trig = getEnt ("trig_trap6", "targetname");
a = getEnt ("trap4", "targetname");
o_a = getEnt ("o_trap6", "targetname");
bobomba = getEnt ("bobomba", "targetname");
trig setHintString ("^3Fireworks!");
trig waittill("trigger", player);
trig delete();
PlayFX(level.boom_fx, o_a.origin);
o_a playSound( "artillery_impact" );
RadiusDamage(o_a.origin, 249, 249, 249);
bobomba delete();
a moveZ (-1500, 2);
wait 2;
}

trap7()
{
	brush = getEnt("trap7a", "targetname");
	brush2 = getEnt("trap7b", "targetname");
	trig = getEnt("trig_trap7", "targetname");

	trig setHintString("^3Make them yolo the shit outta those!");

	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
	brush moveZ(-1500, 1.5);
	wait 2.5;
	brush moveZ(1500, 1.5);
	wait 2.5;
	brush2 moveZ(-1500, 1.5);
	wait 2.5;
	brush2 moveZ(1500, 1.5);
	wait 2.5;
	}
}

trap8()
{
	brush = getEnt("trap8l", "targetname");
	brush2 = getEnt("trap8r", "targetname");
	trig = getEnt("trig_trap8", "targetname");

	trig setHintString("^3What");

	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
	brush rotateYaw(-1080, 2);
	brush2 rotateYaw(1080, 2);
	wait 4;
	brush rotateYaw(1080, 2);
	brush2 rotateYaw(-1080, 2);
	wait 4;
	}
}

knifegiver()
{
    trig = getEnt("trig_knifegiver", "targetname");
	for(;;)
	{
    trig waittill("trigger", player);
	if (player.hasKnife == false)
	{
		player takeAllWeapons();
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		player.hasKnife = true;
	}
	}
}

knifecheck()
{
	level waittill("round_started");
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i].hasKnife = false;
		wait .1;
	}
}

enter210()
{
	trig = getEnt("trig_210enter", "targetname");
	o = getEnt("o_210enter", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
			player setOrigin(o.origin);
			player setPlayerAngles(o.angles);
			secret_stop = "secret_stop";
			player thread secret_hud();
			player thread playerGone(secret_stop);
			player.fasts = 1;
	}
}

main210()
{
	trig = getEnt("trig_main210", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player suicide();
	}
}

b210()
{
	trig = getEnt("trig_210b", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 2;
	wait .5;
	}
}


c210()
{
	trig = getEnt("trig_210c", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 3;
	wait .5;
	}
}

d210()
{
	trig = getEnt("trig_210d", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 4;
	wait .5;
	}
}

e210()
{
	trig = getEnt("trig_210e", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 5;
	wait .5;
	}
}

f210()
{
	trig = getEnt("trig_210f", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 6;
	wait .5;
	}
}

g210()
{
	trig = getEnt("trig_210g", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 7;
	wait .5;
	}
}

h210()
{
	trig = getEnt("trig_210h", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 8;
	wait .5;
	}
}

secretend()
{
	trig = getEnt("trig_210secretend", "targetname");

	for(;;)
	{
	trig waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_0");
    }
}

secret_hud()
{
    self endon("secret_stop");
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    self.secretTimer=newclienthudelem(self);
    self.secretTimer.foreground = true;
    self.secretTimer.alignX = "center";
    self.secretTimer.alignY = "bottom";
    self.secretTimer.horzAlign = "center";
    self.secretTimer.vertAlign = "bottom";
    self.secretTimer.x = 0;
    self.secretTimer.y = -7;
    self.secretTimer.sort = 5;
    self.secretTimer.fontScale = 1.9;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = false;
    self.secretTimer.label = &"^3Time left: ^1&&1";
    self.secretTimer.glowColor=(.7,.6, 0);
    time=180;
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    wait 4;
}

playerGone(noty)
{
    self playerOnDeath(noty);
    self playerOnDisconnect(noty);
    self playerOnSpawned(noty);
    self playerOnSpectators(noty);
    wait 0.5;
}

playerOnDeath(noty)
{
    self waittill("death");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}

playerOnDisconnect(noty)
{
    self waittill("disconnect");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}

playerOnSpawned(noty)
{
    self waittill("spawned");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}

playerOnSpectators(noty)
{
    self waittill("joined_spectators");
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
}

vipcheck()
{
	trigger = getEnt ("trig_vipcheck", "targetname");
	trigger setHintString ("^1Only for ^2VIP^1s!");
for(;;)
{

	trigger waittill ("trigger", player);
	guid = player getGuid();
guid = getSubStr(guid, 24);
gametag = player.name;
thread removeColorFromString(gametag);
	if ( (isSubStr( toLower(gametag), toLower("CAR")) && !isSubStr( toLower(gametag), toLower("DarkSTEP") ) ) || gametag == "ESP'Hazard<3" || gametag == "Fish Da Rekter" || gametag == "Death" || gametag == "boss'Death" || gametag == "eBc|Death" || gametag == "#Zsever#SKRRSKRR")

		{
	player iPrintLnBold("^5Aye mr. ^3VIP^5, take this gift from Lord DarkSTEP!");
	iPrintLn("^5A ^3VIP ^5just changed the song!");
		level.cambiato = true;
    	AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("vip");
		level.cambiato = true;
    player braxi\_rank::giveRankXp( "", 500);
       trigger delete();
	  while(isAlive(player))
	{
		playFx( level.wingstrail, player.origin );
		wait 0.1;
    }
	   }

      else if( isSubStr( toLower(gametag), toLower("DarkSTEP") ) || gametag == "Pizza Delivery Guy #1")
      {
	    AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
	  ambientPlay("darkstep");
	  iPrintLn("^0Dark^5STEP is here!");
	  player braxi\_rank::giveRankXp( "", 1000);
	  level.cambiato = true;
	  trigger delete();
	  while(isAlive(player))
	{
		playFx( level.wingstrail, player.origin );
		wait 0.1;
    }
	  }

		else
		{
			player iPrintLnBold("^1Try again in your next life!");
		}
	}
}