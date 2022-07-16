//Map by Pro Master
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
maps\mp\_load::main();
//otherstuff
thread sr\api\_map::createSpawn((94,-71,78),269);
thread sr\api\_speedrun::createNormalWays("Normal Way");
thread sr\api\_speedrun::createSecretWays("Secret Way");
thread sr\api\_speedrun::createTeleporter((340.535, -496.931, 18.125), 80, 120, (-2638, 3827, 8318), 93, "freeze", "blue", "secret_0");
thread teleport1();
thread teleport2();
thread startdoor();
//thread startmessages();
//thread actiteleport1();
thread trap6door();
thread hardsecretteleports();
//thread ezsecretteleports();
//thread endrooms();
//thread musictrig();
//thread shortcut();
thread endmaptrig();
//traps
addTriggerToList( "trig_trap1" );
addTriggerToList( "trig_trap2" );
addTriggerToList( "trig_trap3" );
addTriggerToList( "trig_trap4" );
addTriggerToList( "trig_trap5" );
addTriggerToList( "trig_trap6" );
addTriggerToList( "trig_trap7" );
addTriggerToList( "trig_trap8" );
addTriggerToList( "trig_trap9" );
//thread trap1();
//thread trap2();
//thread trap3();
//thread trap4();
//thread trap5();
//thread trap6();
//thread trap7();
//thread trap8();
//thread trap9();


if(!isdefined(level.music))
		level.music=[];

	level.music[0]["song"]	="Goblins from Mars - Cold Blooded";
	level.music[0]["alias"]	="coldblooded";
	level.music[1]["song"]	="Aero Chord - Break Them";
	level.music[1]["alias"]	="breakthem";
    level.music[2]["song"]	="Tristam & Braken - Frame of Mind";
	level.music[2]["alias"]	="frameofmind";
	level.music[3]["song"]	="Tristam - Till Its Over";
	level.music[3]["alias"]	="tillitsover";
	
game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

precacheshader("musicmenu");
}





//Other Stuff


//By Blade
musicMenu()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );
	self endon( "joined_spectators" );
	self endon( "music thread terminated" );
 
	self thread onDeath();
	self thread onDisconnect();
 
	self.hud_music = [];
	self.selection = 0;
 
	// create huds
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "musicmenu", 320, 160 );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText("^5CM Clan");
	self.hud_music[i].glowalpha=1;
	if(isdefined(level.randomcolor))
		self.hud_music[i].glowcolor=level.randomcolor;
	else 
		self.hud_music[i].glowcolor=(0,1,0);

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");
 
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
			self.hud_music[i].glowcolor=(0,1,0);
 
		entry = level.music[j];
		self.hud_music[i] setText(entry["song"]);
	}
 
	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "black", 306, 17 );
 
	while(self.sessionstate == "playing")
	{
		wait 0.1;
 
		if(self attackButtonPressed())
		{
			self.hud_music[3+self.selection].alpha = 0.93;
 
			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;
 
			item = self.hud_music[3+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if(self useButtonPressed())
		{
 			iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
			ambientPlay(level.music[self.selection]["alias"]);
			self freezecontrols(0);
			break;
		}
		else if(self fragButtonPressed())
		{
			self freezecontrols(0);
			break;
		}
	}
 
	self cleanUp();
}
 
	musictrig()
{
	trig = getEnt ("music_trig", "targetname");
	trig setHintString("Press [^5&&1^7] to choose Music");
 
	trig waittill("trigger",player);
	player freezecontrols(1);
	trig delete();
	player musicMenu();
	thread secretpart1();
}
 
	onDisconnect()
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}
 
	onDeath()
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}
 
	cleanUp()
{
	if( !isDefined( self ) )
		return;

	
 
	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}

startmessages()
{
level waittill( "round_started" );
wait 5;
iPrintlnBold("^5This map is Dedicated to CM Clan");
wait 3;
iPrintlnBold("^5Made By Pro Master");
}
addTriggerToList( name, positionOfIconAboveTrap )
{
if( !isDefined( level.trapTriggers ) )
level.trapTriggers = [];
level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

if( !isDefined( level.icon_origins ) )
level.icon_origins = [];
level.icon_origins[level.icon_origins.size] = positionOfIconAboveTrap;
}
startdoor()
{
startdoorp1=getent("startdoorp1", "targetname");
startdoorp2=getent("startdoorp2", "targetname");
startdoorp1 delete();
startdoorp2 delete();
}
teleport1()
{
trig=getent("trig_tele1", "targetname");
tele1door1=getent("tele1door1", "targetname");
tele1door2=getent("tele1door2", "targetname");
thread tele1p1();
tele1door2 delete();
tele1door1 delete();
}
shortcut()
{
trig=getent("trig_shortcutend", "targetname");
short=getent("shortcutend", "targetname");
wall=getent("shortcutwall", "targetname");

wall notsolid();
for(;;)
{
trig waittill("trigger", player);
player setorigin (short.origin);
player setplayerangles(short.angles);
player braxi\_rank::giveRankXP( "", 1500 );
}
}
tele1p1()
{
trig=getent("trig_tele1p1", "targetname");
origin1=getent("origin_tele1", "targetname");
for(;;)
{
trig waittill("trigger", player);
player setorigin (origin1.origin);
player setplayerangles(origin1.angles);
}
}
teleport2()
{
trig=getent("trig_tele2", "targetname");
tele2door1=getent("tele2door1", "targetname");
tele2door2=getent("tele2door2", "targetname");
tele2door2 delete();
tele2door1 delete();
}


trap6door()
{
trig=getent("trig_trap6door", "targetname");
trap6door=getent("trap6door", "targetname");
trap6doorp2=getent("trap6doorp2", "targetname");
trap6doorp2 delete();
trap6door delete();
}
actiteleport1()
{
trig=getent("trig_actitele1p1", "targetname");
actitele1door1=getent("actitele1door2", "targetname");
trig setHintString("^5Press Use To Open The Door!");
thread actitele1p1();
trig waittill("trigger");
actitele1door1 rotateyaw(-100, 4);
}
actitele1p1()
{
trig=getent("trig_actitele1", "targetname");
actiorigin1=getent("origin_actitele1", "targetname");
trig setHintString("^5Press Use To Open The Door!");
for(;;)
{
trig waittill("trigger", player);
player setorigin (actiorigin1.origin);
player setplayerangles(actiorigin1.angles);
}

}
endmaptrig()
{

trig=getent("endmap_trig","targetname");
trig waittill("trigger", player);
}            


//Traps
trap1()
{
trig=getent("trig_trap1", "targetname");
notactivated1=getent("notactivated1", "targetname");
activated1=getent("activated1", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
activated1 hide();
trig waittill("trigger", activ);
activ braxi\_rank::giveRankXP( "", 40 );
activated1 show();
notactivated1 hide();
trig setHintString("^5Trap Activated!");
thread trap1activ();
thread lazers();
thread lazers2();
thread trap1tele();
}
trap1tele()
{
trig=getent("trap1trig_origin2", "targetname");
origin2=getent("trap1origin2", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (origin2.origin);
                player setplayerangles(origin2.angles);
				
				
				}
}
trap1activ()
{
trap1=getent("trap1", "targetname");

origin1=getent("trap1origin1", "targetname");
origin2=getent("trap1origin2", "targetname");
 for(;;)
  {
               trap1 waittill("trigger", player);
                player setorigin (origin1.origin);
                player setplayerangles(origin1.angles);
				
				
				}
}
lazers()
{
lazer1=getent("trap1lazer1", "targetname");
trig_lazer1=getent("trap1trig_lazer1", "targetname");
trig_lazer1 enablelinkto ();
trig_lazer1 linkto (lazer1);
while(1)
{
                lazer1 movey(709, 1.8);
				 lazer1 waittill("movedone");
				lazer1 movey(-709, 1.8);
                lazer1 waittill("movedone");
}				
				}
lazers2()
{				
lazer2=getent("trap1lazer2", "targetname");	
trig_lazer2=getent("trap1trig_lazer2", "targetname");
trig_lazer2 enablelinkto ();	
trig_lazer2 linkto (lazer2);
	while(1)
{
  lazer2 movey(-709, 1.8);
  lazer2 waittill("movedone");
  lazer2 movey(709, 1.8);
  lazer2 waittill("movedone");
  }
  }
trap2()
{
trig=getent("trig_trap2", "targetname");
activated2=getent("activated2", "targetname");
notactivated2=getent("notactivated2", "targetname");
trap2=getent("trap2", "targetname");
trap2up=getent("trap2up", "targetname");
trap2down=getent("trap2down", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
activated2 hide();
notactivated2 show();
trap2 hide();
trap2 notsolid();
trap2up hide();
trap2up notsolid();
trap2down hide();
trap2down notsolid();
trig waittill ("trigger", player);
player braxi\_rank::giveRankXP( "", 40 );
trig setHintString("^5Trap Activated!");
activated2 show();
notactivated2 hide();
 trap2 show();
trap2 solid();
trap2up show();
trap2up solid();
trap2down show();
trap2down solid();
while(1)
{
trap2up rotateyaw(360, 3.5);
trap2down rotateyaw(-350, 3.5);
wait 0.1;
}
}
trap3()
{
trig=getent("trig_trap3", "targetname");
activated3=getent("activated3", "targetname");
notactivated3=getent("notactivated3", "targetname");
spikes1=getent("spikes1", "targetname");
spikeswall1=getent("spikeswall1", "targetname");
spikeswall1back=getent("spikeswall1back", "targetname");
trig_spikes=getent("trig_spikes", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
activated3 hide();
notactivated3 show();
trig waittill("trigger", player);
player braxi\_rank::giveRankXP( "", 40 );
trig setHintString("^5Trap Activated!");
activated3 show();
notactivated3 hide();
trig_spikes enablelinkto ();
trig_spikes linkto (spikeswall1);
spikeswall1back enablelinkto ();
spikeswall1back linkto (spikeswall1);
spikes1 enablelinkto ();
spikes1 linkto (spikeswall1);
spikeswall1 movex(220, 0.2);
wait 4;
spikeswall1 movex(-220, 0.2);
}
trap4()
{
trig=getent("trig_trap4", "targetname");
activated4=getent("activated4", "targetname");
notactivated4=getent("notactivated4", "targetname");
trap4=getent("trap4p", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
activated4 hide();
notactivated4 show();
trig waittill ("trigger", player);
player braxi\_rank::giveRankXP( "", 40 );
trig setHintString("^5Trap Activated!");
activated4 show();
notactivated4 hide();
trap4 movey(-124, 0.1);
}
trap5()
{
trig=getent("trig_trap5", "targetname");
activated5=getent("activated5", "targetname");
notactivated5=getent("notactivated5", "targetname");
trap5=getent("trap5", "targetname");
hider=getent("trap5hider", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
hider hide();
activated5 hide();
trig waittill("trigger", player);
player braxi\_rank::giveRankXP( "", 40 );
trig setHintString("^5Trap Activated!");
hider show();
activated5 show();
notactivated5 hide();
trap5 delete();
}
trap6()
{
trig=getent("trig_trap6", "targetname");
activated6=getent("activated6", "targetname");
notactivated6=getent("notactivated6", "targetname");
trap6door=getent("trap6door", "targetname");
trap6doorp2=getent("trap6doorp2", "targetname");
spikes2=getent("spikes2", "targetname");
trig_spikes2=getent("trig_spikes2", "targetname");
spikeswall2=getent("spikeswall2", "targetname");
spikesp2=getent("spikes2p2", "targetname");
trig_spikesp2=getent("trig_spikes2p2", "targetname");
spikeswallp2=getent("spikeswall2p2", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
activated6 hide();
trig waittill("trigger", player);
player braxi\_rank::giveRankXP( "", 40 );
trig setHintString("^5Trap Activated!");
activated6 show();
notactivated6 hide();
trap6door rotateyaw(-100, 0.5);
trap6doorp2 rotateyaw(-100, 0.5);
spikes2 enablelinkto();
spikes2 linkto(spikeswall2);
trig_spikes2 enablelinkto();
trig_spikes2 linkto(spikeswall2);
spikesp2 enablelinkto();
spikesp2 linkto(spikeswallp2);
trig_spikesp2 enablelinkto();
trig_spikesp2 linkto(spikeswallp2);
spikeswall2 movex(228, 4);
spikeswallp2 movex(-228, 4);
wait 4.5;
spikeswall2 movex(-228, 4);
spikeswallp2 movex(228, 4);
wait 4;
trap6door rotateyaw(100, 1);
trap6doorp2 rotateyaw(100, 1);
}
trap7()
{
trig=getent("trig_trap7", "targetname");
activated7=getent("activated7", "targetname");
notactivated7=getent("notactivated7", "targetname");
trap71=getent("trap71", "targetname");
trap72=getent("trap72", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
activated7 hide();
trig waittill("trigger", player);
player braxi\_rank::giveRankXP( "", 40 );
trig setHintString("^5Trap Activated!");
activated7 show();
notactivated7 hide();
random = randomintrange( 0, 2);
if(random == 0)
{
trap71 delete();
}
else if(random == 1)
{
trap72 delete();
}
}
trap8()
{
trig=getent("trig_trap8", "targetname");
activated8=getent("activated8", "targetname");
notactivated8=getent("notactivated8", "targetname");
trap8p1=getent("trap8p1", "targetname");
trap8p2=getent("trap8p2", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
activated8 hide();
trig waittill("trigger", player);
player braxi\_rank::giveRankXP( "", 40 );
trig setHintString("^5Trap Activated!");
activated8 show();
notactivated8 hide();
trap8p1 rotatepitch(100, 1.5);
trap8p2 rotatepitch(-100, 1.5);
wait 2;
trap8p1 rotatepitch(-100, 1);
trap8p2 rotatepitch(100, 1);
}
trap9()
{
trig=getent("trig_trap9", "targetname");
activated9=getent("activated9", "targetname");
notactivated9=getent("notactivated9", "targetname");
trap9p1=getent("trap9p1", "targetname");
trap9p2=getent("trap9p2", "targetname");
trap9p3=getent("trap9p3", "targetname");
trig setHintString("^5Press Use To Activate The Trap!");
activated9 hide();
trig waittill("trigger", player);
player braxi\_rank::giveRankXP( "", 40 );
trig setHintString("^5Trap Activated!");
activated9 show();
notactivated9 hide();
trap9p1 delete();
trap9p2 delete();
trap9p3 movey(-255, 1);
trap9p3 waittill("movedone");
trap9p3 movez(-50, 1);
}
secretpart1()
{
trig=getent("secretentrance", "targetname");
trig waittill("trigger");
iprintln("^5Secret Opened");
thread secrettele();
}
secrettele()
{
trig=getent("trig_secrettele", "targetname");
secrettele=getent("origin_secrettele", "targetname");
secretwall=getent("secretwall", "targetname");
secretwall notsolid();
thread secrets();
for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (secrettele.origin);
                player setplayerangles(secrettele.angles);
				
				
				}
}
secrets()
{
trig=getent("trig_secrettele", "targetname");
secrettele=getent("origin_secrettele", "targetname");
secretwall=getent("origin_secretwall", "targetname");
secretwall notsolid();
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (secrettele.origin);
                player setplayerangles(secrettele.angles);
				
				
				}
}
//hard secret teleports
hardsecretteleports()
{
thread hardsectp1();
thread hardsectp2();
thread hardsectp3();
thread hardsectp4();
thread hardsectele();
thread hardsecend();
}
hardsectele()
{
trig=getent("trig_hardtele", "targetname");
hard=getent("origin_hardsecstart", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (hard.origin);
                player setplayerangles(hard.angles);
				player thread hardsecret_timer();
				
				}
}
hardsectp1()
{
trig=getent("trig_hardsectp1", "targetname");
hardtp1=getent("origin_hardsectp1", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (hardtp1.origin);
                player setplayerangles(hardtp1.angles);
				
				
				}
}
hardsectp2()
{
trig=getent("trig_hardsectp2", "targetname");
hardtp2=getent("origin_hardsectp2", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (hardtp2.origin);
                player setplayerangles(hardtp2.angles);
				
				
				}
}
hardsectp3()
{
trig=getent("trig_hardsectp3", "targetname");
hardtp3=getent("origin_hardsectp3", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (hardtp3.origin);
                player setplayerangles(hardtp3.angles);
				
				
				}
}
hardsectp4()
{
trig=getent("trig_hardsectp4", "targetname");
hardtp4=getent("origin_hardsectp4", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (hardtp4.origin);
                player setplayerangles(hardtp4.angles);
				
				
				}
}
hardsecend()
{
trig=getent("trig_hardsecend", "targetname");
hardend=getent("origin_hardsecend", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player thread sr\api\_speedrun::finishWay("secret_0");
				player.secretTimer2 destroy();
				player notify("hardsecret_done");
				}
}
//ez secret teleports
ezsecretteleports()
{
thread ezsecfalltele();
thread ezsecstart();
thread ezsecend();
}
ezsecfalltele()
{
trig=getent("trig_ezsecfall", "targetname");
ezsecfall=getent("origin_ezsecfall", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (ezsecfall.origin);
                player setplayerangles(ezsecfall.angles);
				
				
				}
}
ezsecstart()
{
trig=getent("trig_eztele", "targetname");
ezsectele=getent("origin_ezsecfall", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (ezsectele.origin);
                player setplayerangles(ezsectele.angles);
				player thread ezsecret_timer();
				
				}
}
ezsecend()
{
trig=getent("trig_ezsecend", "targetname");
ezsecend=getent("origin_ezsecend", "targetname");
 for(;;)
  {
               trig waittill("trigger", player);
                player setorigin (ezsecend.origin);
                player setplayerangles(ezsecend.angles);
				iPrintlnBold( " ^8" + player.name + " ^4 has Finished ^2Easy Secret^8!" );
				player.secretTimer destroy();
				   player notify("ezsecret_done");
				   player braxi\_rank::giveRankXP( "", 200 );
				
				}
}
hardsecret_timer()
{
	self endon("hardsecret_done");
    self endon("suicide");
	if(isdefined(self.secretTimer2))
	self.secretTimer2 destroy();

	self.secretTimer2=newclienthudelem(self);
        self.secretTimer2.foreground = true;
	self.secretTimer2.alignX = "center";
	self.secretTimer2.alignY = "bottom";
	self.secretTimer2.horzAlign = "center";
        self.secretTimer2.vertAlign = "bottom";
        self.secretTimer2.x = 0;
        self.secretTimer2.y = -7;
        self.secretTimer2.sort = 5;
        self.secretTimer2.fontScale = 1.6;
	self.secretTimer2.font = "default";
	self.secretTimer2.glowAlpha = 1;
 	self.secretTimer2.hidewheninmenu = true;
 	self.secretTimer2.label = &"Time in left: &&1";
 	if(isdefined(level.randomcolor))
	self.secretTimer2.glowColor=level.randomcolor;
	else 
	self.secretTimer2.glowColor=(1,0,0);

	time=200;
	for(i=0;i<time;i++)
		{
		self.secretTimer2 setvalue(time-i);
		wait 1;
		}
	self.secretTimer2 setvalue(0);

	self suicide();

	if(isdefined(self.secretTimer2))
	self.secretTimer2 destroy();
}
ezsecret_timer()
{
	self endon("ezsecret_done");
    self endon("suicide");
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
        self.secretTimer.fontScale = 1.6;
        self.secretTimer.font = "default";
        self.secretTimer.glowAlpha = 1;
        self.secretTimer.hidewheninmenu = true;
        self.secretTimer.label = &"Time in left: &&1";
        if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else 
	self.secretTimer.glowColor=(0,1,0);

	time=70;
	for(i=0;i<time;i++)
		{
		self.secretTimer setvalue(time-i);
		wait 1;
		}
	self.secretTimer setvalue(0);
	self suicide();

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();
}


//endrooms
endrooms()
{
thread sniper();
thread bounce();
thread knife();

thread bouncesniper();
thread bouncejumperfall();
thread bounceactifall();

}
sniper()
{

level.bounce_trigger = getEnt( "trig_bounce", "targetname");
level.sniper_trigger = getEnt( "trig_sniper", "targetname");
level.knife_trigger = getEnt( "knife_trig", "targetname");
level.teleactorigin = getEnt( "origin_sniperactifall", "targetname" ); 
telejumporigin = getEnt( "origin_sniperplayerfall", "targetname" );

while(1)
{

level.sniper_trigger waittill( "trigger", splayer );
level.bounce_trigger delete();
level.knife_trigger delete();
thread sniperfall(splayer);
    
iprintln("Now Playing<<PIXL - Sugar Rush [Monstercat EP Release]>>");    
ambientstop();
ambientPlay( "sugarrush" );



if( !isDefined( level.sniper_trigger ) )
return;
if(level.firstenter==true)
{

level.firstenter=false;
} 
wait(0.05);

splayer SetOrigin( telejumporigin.origin );
splayer setplayerangles( telejumporigin.angles );
splayer TakeAllWeapons();
splayer GiveWeapon("m40a3_mp");
splayer GiveWeapon( "remington700_mp" ); 
splayer GiveMaxAmmo("m40a3_mp");
splayer GiveMaxAmmo( "remington700_mp" );
wait .05;
splayer SwitchToWeapon("m40a3_mp"); 
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
iPrintlnBold( " ^8" + splayer.name + " ^4 has entered the Sniper room^8!" ); 
splayer iPrintlnBold( "^13" );
            splayer freezecontrols(true);
			level.activ freezecontrols(true);
            level.activ iPrintlnBold( "^13" );
            wait 1;
            splayer iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            splayer iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            splayer iPrintlnBold( "^6Fight^7!" );
            level.activ iPrintlnBold( "^6Fight^6!" );
            splayer freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
wait(0.02);
splayer switchToWeapon( "m40a3_mp" );
level.activ SwitchToWeapon( "m40a3_mp" );




splayer waittill( "death" );
level.PlayerInRoom = false;

}
}
knife()
{
level.knife_trigger = getEnt( "knife_trig", "targetname");
level.kteleactorigin = getEnt( "origin_knifeacti", "targetname" ); 
ktelejumporigin = getEnt( "origin_knifejumper", "targetname" );

while(1)
{
level.knife_trigger waittill( "trigger", player );
level.bounce_trigger delete();
level.sniper_trigger delete();
    
iprintln("Now Playing<<Carbon Airways - Black Sun (Kill Paris Remix)>>");    

ambientPlay( "notalone" );



if( !isDefined( level.knife_trigger ) )
return;
if(level.firstenter==true)
{

level.firstenter=false;
} 
wait(0.05);

player SetOrigin( ktelejumporigin.origin );
player setplayerangles( ktelejumporigin.angles );
player TakeAllWeapons();
player GiveWeapon("knife_mp");
wait .05;
player SwitchToWeapon("knife_mp"); 
wait(0.05);
level.activ SetOrigin (level.kteleactorigin.origin);
level.activ setplayerangles (level.kteleactorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" );
wait .05;
level.activ SwitchToWeapon("knife_mp"); 
iPrintlnBold( " ^8" + player.name + " ^4 has entered the Knife room^8!" ); 
player iPrintlnBold( "^13" );
            player freezecontrols(true);
			level.activ freezecontrols(true);
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^6Fight^7!" );
            level.activ iPrintlnBold( "^6Fight^6!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
wait(0.02);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );




player waittill( "death" );
level.PlayerInRoom = false;

}
}
bounce()
{

level.sniper_trigger = getEnt( "trig_sniper", "targetname");
level.bounce_trigger = getEnt( "trig_bounce", "targetname");
level.knife_trigger = getEnt( "knife_trig", "targetname");
level.bactiorigin = getEnt( "origin_bactifall", "targetname" ); 
btelejumporigin = getEnt( "origin_bjumperfall", "targetname" );

while(1)
{
level.bounce_trigger waittill( "trigger", player );

level.knife_trigger delete();
level.sniper_trigger delete();
iprintln("Now Playing<<Rootkit - Against the Sun (feat. Anna Yvette)>>");    
    
ambientPlay( "rootkit" );



if( !isDefined( level.bounce_trigger ) )
return;
if(level.firstenter==true)
{

level.firstenter=false;
} 
wait(0.05);

player SetOrigin( btelejumporigin.origin );
player setplayerangles( btelejumporigin.angles );
player TakeAllWeapons();
player GiveWeapon("knife_mp");
wait .05;
player SwitchToWeapon("knife_mp"); 
wait(0.05);
level.activ SetOrigin (level.bactiorigin.origin);
level.activ setplayerangles (level.bactiorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" );
wait .05;
level.activ SwitchToWeapon(""); 
iPrintlnBold( " ^8" + player.name + " ^4 has entered the bounce room^8!" ); 
player iPrintlnBold( "^13" );
            player freezecontrols(true);
			level.activ freezecontrols(true);
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^6GO^7!" );
            level.activ iPrintlnBold( "^6GO^6!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
wait(0.02);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );




player waittill( "death" );
level.PlayerInRoom = false;

}
}
bouncesniper()
{
trig = getEnt( "trig_snipersniper", "targetname");
trig setHintString("^5Press Use To Get Sniper!");
while(1)
{
trig waittill("trigger", player);
player GiveWeapon( "remington700_mp" );
player SwitchToWeapon("remington700_mp"); 
player givemaxammo("remington700_mp"); 
}
}
bouncejumperfall()
{
trig = getEnt( "trig_bjumperfall", "targetname");
jumperfall = getEnt( "origin_bjumperfall", "targetname");
while(1)
{
trig waittill("trigger", player);
player SetOrigin( jumperfall.origin );
player setplayerangles( jumperfall.angles );
}
}
bounceactifall()
{
trig = getEnt( "trig_bactifall", "targetname");
actifall = getEnt( "origin_bactifall", "targetname");
while(1)
{
trig waittill("trigger", player);
player SetOrigin( actifall.origin );
player setplayerangles( actifall.angles );
}
}
sniperfall(splayer)
{
trig = getEnt( "trig_sniperfall", "targetname");
sniperplayerfall = getEnt( "origin_sniperplayerfall", "targetname");
sniperactifall = getEnt( "origin_sniperactifall", "targetname");
while(1)
{
trig waittill("trigger", player);
activator = GetActivator();
if (player == splayer)
{
player SetOrigin( sniperplayerfall.origin );
player setplayerangles( sniperplayerfall.angles );
}
else if (player == activator)
{
player SetOrigin( sniperactifall.origin );
player setplayerangles( sniperactifall.angles );
}
}
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