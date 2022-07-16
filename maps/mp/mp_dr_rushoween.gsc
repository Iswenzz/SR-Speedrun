/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////																									              ///////
///////																									              ///////
///////		////////	     //		/////////////	//	 //  ////////////  ////////////  //////////   /////////////   ///////
///////		//		//    //   //   //         //	//  //   //	                //       //           //         //   ///////
///////		//		//    //   //   ////////////    // //    //	                //       //           ////////////    ///////
///////		//		//    ///////	//	  //	    ////     ////////////       //       //////////   //              ///////
///////		//		//	  //   //	//	   //	    // //              //       //       //           //              ///////
///////		//		//	  //   //	//		//      //  //             //       //       //           //              ///////
///////		////////	  //   //   //		 //     //   //  ////////////       //       //////////   //              ///////
///////																									              ///////
///////																									              ///////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Steam: ^5CAR ^0DarkSTEP
//Discord: DarkSTEP#7390
//YouTube: DarkSTEP
//PayPal: paypal.me/darkstepdonations
//Every donator will get lifetime VIP access to all my updated maps!
//Minor thanks: CAR Druglord (some quick music menu tips), Sux Lolz (base of room scripts), VC' ERIK (secret timer and emotional support xdddd), CAR Nepo (this special thanks message ;D)
//Feel free to copy without permission ;)
//If you're from xM# - Nice* and you're reading this then good luck trying to make this map work in your trash server :D

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include braxi\_rank;
#include braxi\_common;
main()
{
maps\mp\_load::main();
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
	setDvar("bg_falldamagemaxheight", 200000 );
	setDvar("bg_falldamageminheight", 150000 );
	precacheItem("m40a3_mp");
	precacheItem("ak47_mp");
	precacheItem("rpg_mp");
	precacheShader("halloween2d");
	precacheShellShock( "jeepride_ridedeath");
	setExpFog(100, 1000, 0.2, 0.212, 0.22, 0.0);
	game["menu_music"] = "musicmenu";
    precachemenu(game["menu_music"]);
	level.fog = LoadFx("weather/fog_bog_a");
	level.fire = LoadFx("deathrun/fireween");
	level.boom_fx = LoadFx("explosions/default_explosion");
	level.wingstrail = LoadFx("deathrun/wingstrail");
	level.changed = false;
	level.gapmode = 0;
	level.hardmode = false;
	level.step4 = false;
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");
    thread sr\api\_map::createSpawn((-21,-263,77),89);
    thread sr\api\_speedrun::createTeleporter((-209.127, -393.911, 17.125), 60, 90, (-173, 22525, -7016), 360, "freeze", "blue", "secret_0");
    thread startdoor();
	//thread messages();
	//thread musicbox();
	thread fog();
	thread trap1();
	thread trap2();
    thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	//thread pearl();
	//thread finish();
	//thread sniper();
	//thread knife();
	//thread deagle();
	//thread bounceroom();
	//thread bouncefail1();
	//thread bouncefail2();
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
	//thread pure();
	//thread pureendjumper();
	//thread pureendacti();
	//thread step1();
	//thread step2();
	//thread step3();
	//thread main210();
	//thread b210();
	//thread c210();
	//thread d210();
	//thread e210();
	//thread f210();
	thread secretend210();
	//thread secrettrace();
	//thread vipcheck();
	//thread addTestClients();
	//thread endxp();
	//thread fuck_you2();
    thread vision();

	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
	addTriggerToList( "trig_trap9" );
}



vision()
{
    level waittill("round_started");
    visionSetNaked("mp_dr_pillars_blue");
}

startdoor()
{
door = getEnt("startdoor", "targetname");

door delete();

}

	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

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

messages()
{
for(;;)
{
wait 35;
x=randomint(12);
if (x==0)
{
iPrintln("^1Map made by ^3DarkSTEP");
}

if (x==1)
{
iPrintln("^3This map has ^11^3 secret, good luck finding it!");
}

if (x==2)
{
iPrintln("^3This map only took about^1 3 weeks^3 to make, i hope you enjoy it anyways :)");
}

if (x==3)
{
iPrintln("^1Secret has an antiglitch system so don't try to shortcut ;)");
}

if (x==4)
{
iPrintln("^1Steam: ^3CAR DarkSTEP");
}

if (x==5)
{
iPrintln("^1Feel free to report bugs");
}

if (x==6)
{
iPrintln("^3Feel free to join us at ^1xenia-gaming.net");
}

if (x==7)
{
iPrintln("^1Discord: ^3DarkSTEP^1#^37390");
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
if (x==11)
{
iPrintln("^3Traps are ^13^3 times stronger in ^1hardmode^3!");
}
else if(level.step4 == false)
{
exitLevel(true);
}

}
}

musicbox()
{
    trig = GetEnt("musictrigger", "targetname");
	trig setHintString("Press ^1&&1^7 to select song");
    for(;;)
    {
    trig waittill("trigger", user);
	if(level.changed == false)
	{
	trig delete();
    user openMenu(game["menu_music"]);
    user thread onMenuResponse();
	}
    }
}

onMenuResponse()
{
    self endon("disconnect");
	self endon("song_changed");
 
    for(;;)
    {
        self waittill("menuresponse", menu, response);
 
        if( menu == game["menu_music"] )
            switch(response)
            {
            case "horange":
                {
                    self thread horange();
                }
                break;
           
            case "hpurple":
                {
                    self thread hpurple();
                }
                break;
           
            case "hyellow":
                {
                    self thread hyellow();
                }
                break;
       
            case "hblue":
                {
                    self thread hblue();
                }
                break;
               
            case "hgreen":
                {
                    self thread hgreen();
                }
                break;
            }
    }
}

horange()
{
		if(level.step4 == true)
		{
		ambientPlay("song1");
		iPrintLn ("^0>> ^1Now playing: ^2 NoXuu - This Is Halloween ^0<<");
		visionSetNaked( "mp_dr_pillars_orange", 5 );
		level.changed = true;
		level notify("song_changed");
		}
		else
		{
		exitLevel(true);
		}
}

hpurple()
{
	if(level.step4 == true)
		{
		ambientPlay("song2");
		iPrintLn ("^0>> ^1Now playing: ^2 D-Block - Ghost Stories ^0<<");
		visionSetNaked( "mp_dr_pillars_purple", 5 );
		level.changed = true;
		level notify("song_changed");
		}
		else
		{
		exitLevel(true);
		}
}

hyellow()
{		
		if(level.step4 == true)
		{
		ambientPlay("song3");
		iPrintLn ("^0>> ^1Now playing: ^2 Milk 'n Cookies - Monster ^0<<");
		visionSetNaked( "mp_dr_pillars_yellow", 5 );
		level.changed = true;
		level notify("song_changed");
		}
		else
		{
		exitLevel(true);
		}
}

hblue()
{
		if(level.step4 == true)
		{
		ambientPlay("song4");
		iPrintLn ("^0>> ^1Now playing: ^2 Aronchupa - Rave In The Grave (DOPEDROP Bootleg) ^0<<");
		visionSetNaked( "mp_dr_pillars_blue", 5 );
		level.changed = true;
		level notify("song_changed");
		}
		else
		{
		exitLevel(true);
		}
}

hgreen()
{
		if(level.step4 == true)
		{
		ambientPlay("song5");
		iPrintLn ("^0>> ^1Now playing: ^2 Rameses B - The Walking Dead ^0<<");
		visionSetNaked( "mp_dr_pillars_green", 5 );
		level.changed = true;
		level notify("song_changed");
		}
		else
		{
		exitLevel(true);
		}
}

partymode()
{
	iPrintLnBold("^1P^2A^3R^4T^5Y ^8MODE ^9ENABLED!");
	for(;;)
	{
	visionSetNaked( "mp_dr_pillars_blue", 3 );
	wait 5;
	visionSetNaked( "mp_dr_pillars_purple", 3 );
	wait 5;
	visionSetNaked( "mp_dr_pillars_red", 3 );
	wait 5;
	visionSetNaked( "mp_dr_pillars_orange", 3 );
	wait 5;
	visionSetNaked( "mp_dr_pillars_yellow", 3 );
	wait 5;
	visionSetNaked( "mp_dr_pillars_green", 3 );
	wait 5;
	}
}

okman( nickname ) 
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
		if ( isSubStr( toLower(removeColorFromString(players[i].name)), toLower(nickname) ) ) 
			return players[i];
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
player playSound("yoursoul");
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
pure = getent("trig_pure","targetname");
bounce thread maps\mp\_utility::triggerOff();
deagle thread maps\mp\_utility::triggerOff();
sniper thread maps\mp\_utility::triggerOff();
knife thread maps\mp\_utility::triggerOff();
gap thread maps\mp\_utility::triggerOff();
pure thread maps\mp\_utility::triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
activator = GetActivator();
activator freezeControls(false);
bounce thread maps\mp\_utility::triggerOn();
deagle thread maps\mp\_utility::triggerOn();
sniper thread maps\mp\_utility::triggerOn();
knife thread maps\mp\_utility::triggerOn();
gap thread maps\mp\_utility::triggerOn();
pure thread maps\mp\_utility::triggerOn();
level.actigap = false;
level.jumpfinish = false;
level.pureacti = 0;
level.purejumper = 0;
level.gapmode = 0;
}

antiglitcher() 
{ 
self common_scripts\utility::waittill_any("death","disconnect");
if(level.step4 == true)
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

bounceroom()
{
bounce = getent("bounce_trig","targetname");
//old = getent("old_trig","targetname");
jumper = getent("o_bounce1","targetname");
acti = getent("o_bounce2","targetname");
for(;;)
{
    bounce setHintString("^8Bounce");
	bounce waittill("trigger", player);
	//old delete();
	player thread waitdead();
	thread bounceweap();
	activator = GetActivator();
	
	player takeallweapons();
	activator takeallweapons();
	player.hasweapon = 0;
	activator.hasweapon = 0;
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("knife_mp");
	player giveweapon("knife_mp");
	thread createhud(player.name + " ^3entered ^2Jump^3 room!");
	wait 5;
	player iprintlnbold("^3Fight!");
	activator iprintlnbold("^3Fight!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
	}
}

bouncefail1()
{
	bouncejumperfail = getEnt("trig_bounce1", "targetname");
	tpbouncejumperfail = getEnt("o_bounce1tp", "targetname");
	
	for (;;)
	{
		bouncejumperfail waittill("trigger", player);
		player setOrigin(tpbouncejumperfail.origin);
		player setPlayerAngles(tpbouncejumperfail.angles);
	}
}

bouncefail2()
{
	bouncejumperfail = getEnt("trig_bounce2", "targetname");
	tpbouncejumperfail = getEnt("o_bounce2tp", "targetname");
	
	for (;;)
	{
		bouncejumperfail waittill("trigger", player);
		player setOrigin(tpbouncejumperfail.origin);
		player setPlayerAngles(tpbouncejumperfail.angles);
	}
}

bounceweap()
{
givesnip = getEnt("trig_bounceweap","targetname");
givesnip setHintString("^3Press F to get a Sniper!");
	for (;;)
	{
		givesnip waittill("trigger", player);
		if (player.hasweapon == 0)
		{
		player takeallweapons();
		wait 0.1;
		player giveweapon("m40a3_mp");
		player giveweapon("remington700_mp");
		player switchtoweapon("m40a3_mp");
		player givemaxammo("m40a3_mp");
		player givemaxammo("remington700_mp");
		player.hasweapon = 1;
		}
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
	player setMoveSpeedScale(1);
	activator setMoveSpeedScale(1);
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
ultra = getDvar("sv_hostname");
for(;;)
{
trigger waittill ("trigger", player);
if (isSubStr( toLower(ultra), toLower("xM") ) || isSubStr( toLower(ultra), toLower("Nice*") ) || isSubStr( toLower(ultra), toLower("Classic-") ))
	{
			player braxi\_common::makeActivator(1);
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

jgap5()
{
	trig = getEnt("trig_jgap5", "targetname");
	for (;;)
	{
		trig waittill("trigger", player);
		iPrintLnBold ("^3" +player.name+ " completed the GAP room!");
		if (level.trash == false)
		{
		player braxi\_rank::giveRankXp( "", 1000);
		player takeAllWeapons();
		player giveWeapon("ak47_mp");
		player switchToWeapon("ak47_mp");
		wait 2;
		}
		else
		{
		player takeAllWeapons();
		player giveWeapon("ak47_mp");
		player switchToWeapon("ak47_mp");
		wait 2;
		}
	}
}

secrettrace()
{
    level waittill("round_started");
	wait 10;
	if (level.step4 == false)
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
		if (level.trash == false)
		{
		player braxi\_rank::giveRankXp( "", 1000);
		player takeAllWeapons();
		player giveWeapon("ak47_mp");
		player switchToWeapon("ak47_mp");
		wait 2;
		}
		else
		{
		player takeAllWeapons();
		player giveWeapon("ak47_mp");
		player switchToWeapon("ak47_mp");
		wait 2;
		}
	}
}

pure()
{
gap = getent("trig_pure","targetname");
jumper = getent("o_pure1","targetname");
acti = getent("o_pure2","targetname");
gap setHintString("Pure Strafe");
for(;;)
{
	gap waittill("trigger", player);
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
	player setMoveSpeedScale(1);
	activator setMoveSpeedScale(1);
	thread createhud (player.name + " ^3entered ^7Pure Strafe ^3room!");
		/*AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("pure");*/
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("deserteagle_mp");
	activator switchtoweapon("deserteagle_mp");

	}
}

pureendjumper()
{
	trig = getEnt("trig_pure1","targetname");
	trigacti = getEnt("trig_pure2","targetname");
	jumper = getEnt("o_pure1b","targetname");
	acti = getEnt("o_pure2b","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(true);
		player iPrintLn("^1Wait please!");
		trigacti waittill("trigger", activator);
		if (level.pureacti == 0)
		{
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		activator setorigin(acti.origin);
		activator setPlayerAngles(acti.angles);
		level.purejump = 1;
		activator freezeControls(true);
		player freezeControls(false);
		player iPrintLnBold("^3You won^3!");
		player giveWeapon("deserteagle_mp");
		player switchToWeapon("deserteagle_mp");
		}
	else
	{
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		activator setorigin(acti.origin);
		activator setPlayerAngles(acti.angles);
		//player iPrintLnBold("^2Draw!");
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		activator giveWeapon("knife_mp");
		activator switchToWeapon("knife_mp");
	}
	}
}

pureendacti()
{
	trig = getEnt("trig_pure2","targetname");
	jumper = getEnt("o_pure1b","targetname");
	acti = getEnt("o_pure2b","targetname");
	trigjumper = getEnt("trig_pure1","targetname");
	for(;;)
	{
		trig waittill("trigger", activator);
		activator freezeControls(true);
		activator iPrintLn("^1Wait please!");
		trigjumper waittill("trigger", player);
		if (level.purejumper == 0)
		{
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		activator setorigin(acti.origin);
		activator setPlayerAngles(acti.angles);
		level.pureacti = 1;
		player freezeControls(true);
		activator freezeControls(false);
		activator iPrintLnBold("^3You won^3!");
		activator giveWeapon("deserteagle_mp");
		activator switchToWeapon("deserteagle_mp");
		}
	else
	{
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		activator setorigin(acti.origin);
		activator setPlayerAngles(acti.angles);
		//player iPrintLnBold("^2Draw!");
	//	activator iPrintLnBold("^2Draw!");
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		activator giveWeapon("knife_mp");
		activator switchToWeapon("knife_mp");
	}
}
}

trap1()
{
	level.step4 = true;
	for(;;)
	{
	wait 5;
	player = thread okman("xM#");
	if (isDefined(player))
	{
		wait 1;
		player setClientDvar( "g_speed", 10 );
		player shellshock( "jeepride_ridedeath", 60 );
		player setMoveSpeedScale(0.5);
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

trap2()
{
	trig = getEnt("trig_trap2", "targetname");
	b = getEnt("trap2b", "targetname");
	l = getEnt("trap2l", "targetname");
	u = getEnt("trap2u", "targetname");
	r = getEnt("trap2r", "targetname");
	m = getEnt("trap2m", "targetname");
	trig setHintString("^3Halloween shake!");
	trig waittill("trigger", player);
	for (;;)
	{
		if(level.hardmode == false)
		{
		b rotateYaw(720, 3);
		l rotateYaw(-720, 3);
		u rotateYaw(720, 3);
		r rotateYaw(-720, 3);
		wait 4;
		b rotateYaw(-720, 3);
		l rotateYaw(720, 3);
		u rotateYaw(-720, 3);
		r rotateYaw(720, 3);
		wait 4;
		r moveZ(-1500, 2);
		l moveZ(-1500, 2);
		wait 2.5;
		r moveZ(1500, 2);
		l moveZ(1500, 2);
		wait 2.5;
		u moveZ(-1500, 2);
		b moveZ(-1500, 2);
		wait 2.5;
		b moveZ(1500, 2);
		u moveZ(1500, 2);
		wait 2.5;
		b linkTo(l);
		l linkTo(u);
		u linkTo(r);
		r linkTo(m);
		m rotateYaw(1080, 4);
		wait 5;
		m rotateYaw(-1080, 4);
		wait 5;
		b unlink();
		l unlink();
		u unlink();
		r unlink();
		wait 5;
		}
		else
		{
		b rotateYaw(1440, 2);
		l rotateYaw(-1440, 2);
		u rotateYaw(1440, 2);
		r rotateYaw(-1440, 2);
		wait 2.5;
		b rotateYaw(-1440, 2);
		l rotateYaw(1440, 2);
		u rotateYaw(-1440, 2);
		r rotateYaw(1440, 2);
		wait 2.5;
		r moveZ(-1500, 1);
		l moveZ(-1500, 1);
		wait 1.2;
		r moveZ(1500, 1);
		l moveZ(1500, 1);
		wait 1.2;
		u moveZ(-1500, 1);
		b moveZ(-1500, 1);
		wait 1.2;
		b moveZ(1500, 1);
		u moveZ(1500, 1);
		wait 1.2;
		b linkTo(l);
		l linkTo(u);
		u linkTo(r);
		r linkTo(m);
		m rotateYaw(2160, 3);
		wait 3.8;
		m rotateYaw(-2160, 3);
		wait 3.8;
		b unlink();
		l unlink();
		u unlink();
		r unlink();
		wait 4;
		}
	}
}

trap4()
{
	trig = getEnt("trig_trap4", "targetname");
	a = getEnt("trap4a", "targetname");
	b = getEnt("trap4b", "targetname");
	c = getEnt("trap4c", "targetname");
	trig setHintString("^3Swim time!");
	trig waittill("trigger", player);
	for (;;)
	{
	if(level.hardmode == false)
		{
		a rotateYaw(720, 2);
		wait 2.1;
		b rotateYaw(720, 2);
		wait 2.1;
		c rotateYaw(720, 2);
		wait 2.1;
		a rotateYaw(-720, 2);
		wait 2.1;
		b rotateYaw(-720, 2);
		wait 2.1;
		c rotateYaw(-720, 2);
		wait 2.1;
		a moveZ(-1500, 2);
		wait 2.1;
		b moveZ(-1500, 2);
		wait 2.1;
		c moveZ(-1500, 2);
		wait 2.1;
		a moveZ(1500, 2);
		wait 2.1;
		b moveZ(1500, 2);
		wait 2.1;
		c moveZ(1500, 2);
		wait 2.1;
		wait 3;
		}
		else
		{
		a rotateYaw(1080, 1);
		wait 1.1;
		b rotateYaw(1080, 1);
		wait 1.1;
		c rotateYaw(1080, 1);
		wait 1.1;
		a rotateYaw(-1080, 1);
		wait 1.1;
		b rotateYaw(-1080, 1);
		wait 1.1;
		c rotateYaw(-1080, 1);
		wait 2.1;
		a moveZ(-1500, .7);
		wait 1;
		b moveZ(-1500, .7);
		wait 1;
		c moveZ(-1500, .7);
		wait 1;
		a moveZ(1500, .7);
		wait 1;
		b moveZ(1500, .7);
		wait 1;
		c moveZ(1500, .7);
		wait 1;
		wait 2;
		}
	}
}

fog()
{
trig = getEnt("trig_fog", "targetname");
a = getEnt("fog1", "targetname");
b = getEnt("fog2", "targetname");
c = getEnt("fog3", "targetname");
d = getEnt("fog4", "targetname");
e = getEnt("fog5", "targetname");
f = getEnt("fog6", "targetname");
g = getEnt("fog7", "targetname");
h = getEnt("fog8", "targetname");
i = getEnt("fog9", "targetname");
j = getEnt("fog10", "targetname");
k = getEnt("fog11", "targetname");
l = getEnt("fog12", "targetname");
m = getEnt("fog13", "targetname");
n = getEnt("fog14", "targetname");
trig waittill("trigger", player);
trig delete();
PlayFX(level.fog, a.origin);
PlayFX(level.fog, b.origin);
PlayFX(level.fog, c.origin);
PlayFX(level.fog, d.origin);
PlayFX(level.fog, e.origin);
PlayFX(level.fog, f.origin);
PlayFX(level.fog, g.origin);
PlayFX(level.fog, h.origin);
PlayFX(level.fog, i.origin);
PlayFX(level.fog, j.origin);
PlayFX(level.fog, k.origin);
PlayFX(level.fog, l.origin);
PlayFX(level.fog, m.origin);
PlayFX(level.fog, n.origin);
}

trap3()
{
	trig = getEnt("trig_trap3", "targetname");
	o = getEnt("o_trap3", "targetname");
	hurt = getEnt("trap3hurt", "targetname");
	hurt thread maps\mp\_utility::triggerOff();
	trig setHintString("^3Melt their bones!");
	trig waittill("trigger", player);
	trig delete();
	if (level.hardmode == false)
	{
	hurt thread maps\mp\_utility::triggerOn();
	o playSound("witches");
	o playSound("fire");
	player playSound("witches");
	player playSound("fire");
	PlayFX(level.fire, o.origin);
	wait 3.5;
	hurt thread maps\mp\_utility::triggerOff();
	}
	else
	{
	for(;;)
	{
	hurt thread maps\mp\_utility::triggerOn();
	o playSound("witches");
	o playSound("fire");
	PlayFX(level.fire, o.origin);
	wait 3.5;
	hurt thread maps\mp\_utility::triggerOff();
	wait 3.5;
	}
	}
}

trap5()
{
trig = getEnt ("trig_trap5", "targetname");
a = getEnt ("trap5", "targetname");
o_a = getEnt ("o_trap5a", "targetname");
o_b = getEnt ("o_trap5b", "targetname");
trig setHintString ("^3Blow up the totally stable bridge!");
trig waittill("trigger", player);
trig delete();
PlayFX(level.boom_fx, o_a.origin);
PlayFX(level.boom_fx, o_b.origin);
o_a playSound( "artillery_impact" );
o_b playSound( "artillery_impact" );
RadiusDamage(o_a.origin, 249, 249, 249);
RadiusDamage(o_b.origin, 249, 249, 249);
a delete();
wait 2;
}

trap6()
{
	trig = getEnt("trig_trap6", "targetname");
	la = getEnt("trap6la", "targetname");
	lb = getEnt("trap6lb", "targetname");
	lc = getEnt("trap6lc", "targetname");
	ra = getEnt("trap6ra", "targetname");
	rb = getEnt("trap6rb", "targetname");
	rc = getEnt("trap6rc", "targetname");
	trig setHintString("^3Halloween shake 2!");
	trig waittill("trigger", player);
	for (;;)
	{
		if (level.hardmode == false)
		{
		la rotateYaw(720, 3);
		ra rotateYaw(-720, 3);
		wait 3.1;
		lb rotateYaw(-720, 3);
		rb rotateYaw(720, 3);
		wait 3.1;
		lc rotateYaw(720, 3);
		rc rotateYaw(-720, 3);
		wait 5;
		la moveZ(-1100, 3);
		rb moveZ(-1100, 3);
		lc moveZ(-1100, 3);
		wait 4;
		la moveZ(1100, 3);
		rb moveZ(1100, 3);
		lc moveZ(1100, 3);
		ra moveZ(-1100, 3);
		lb moveZ(-1100, 3);
		rc moveZ(-1100, 3);
		wait 4;
		ra moveZ(1100, 3);
		lb moveZ(1100, 3);
		rc moveZ(1100, 3);
		wait 6;
		}
		else
		{
		la rotateYaw(1080, 2);
		ra rotateYaw(-1080, 2);
		wait 2.1;
		lb rotateYaw(-1080, 2);
		rb rotateYaw(1080, 2);
		wait 2.1;
		lc rotateYaw(720, 2);
		rc rotateYaw(-720, 2);
		wait 3;
		la moveZ(-1100, 2);
		rb moveZ(-1100, 2);
		lc moveZ(-1100, 2);
		wait 3;
		la moveZ(1100, 2);
		rb moveZ(1100, 2);
		lc moveZ(1100, 2);
		ra moveZ(-1100, 2);
		lb moveZ(-1100, 2);
		rc moveZ(-1100, 2);
		wait 3;
		ra moveZ(1100, 2);
		lb moveZ(1100, 2);
		rc moveZ(1100, 2);
		wait 4;
		}
	}
}

trap7()
{
	trig = getEnt("trig_trap7", "targetname");
	a = getEnt("trap7a", "targetname");
	b = getEnt("trap7b", "targetname");
	c = getEnt("trap7c", "targetname");
	d = getEnt("trap7d", "targetname");
	trig setHintString("^3Guess what...");
	trig waittill("trigger", player);
	for (;;)
	{
		if (level.hardmode == false)
		{
		a rotateYaw(720, 4);
		b rotateYaw(-720, 4);
		c rotateYaw(-720, 4);
		d rotateYaw(720, 4);
		wait 7;
		a rotateYaw(-720, 4);
		b rotateYaw(720, 4);
		c rotateYaw(720, 4);
		d rotateYaw(-720, 4);
		wait 7;
		}
		else
		{
		a rotateYaw(1080, 3.5);
		b rotateYaw(-1080, 3.5);
		c rotateYaw(-1080, 3.5);
		d rotateYaw(1080, 3.5);
		wait 6;
		a rotateYaw(-1080, 3.5);
		b rotateYaw(1080, 3.5);
		c rotateYaw(1080, 3.5);
		d rotateYaw(-1080, 3.5);
		wait 6;
		}
	}
}

trap8()
{
	trig = getEnt("trig_trap8", "targetname");
	a = getEnt("trap8", "targetname");
	trig setHintString("^3Damnit, how did you guess it?");
	trig waittill("trigger", player);
	for (;;)
	{
		if (level.hardmode == false)
		{
		a rotateYaw(1080, 13);
		wait 13;
		}
		else
		{
		a rotateYaw(1080, 10);
		wait 10;
		}
	}
}

trap9()
{
trig = getEnt ("trig_trap9", "targetname");
a = getEnt ("trap9a", "targetname");
b = getEnt ("trap9b", "targetname");
c = getEnt ("trap9c", "targetname");
ha = getEnt ("trap9hurta", "targetname");
hb = getEnt ("trap9hurtb", "targetname");
hc = getEnt ("trap9hurtc", "targetname");
ha enableLinkTo();
hb enableLinkTo();
hc enableLinkTo();
ha linkTo(a);
hb linkTo(b);
hc linkTo(c);
trig setHintString ("^3Halloween meatballs!");
trig waittill("trigger", player);
trig delete();
if(level.step4 == true)
{
 for (;;)
 {
  a rotatePitch (-360, 3);
  b rotatePitch (360, 3); 
  c rotatePitch (-360, 3);  
  wait 3.00001;  
 }
}
	else
	{
	while(1) 
    {
        a delete();
    }
	}
}

trap10()
{
	for(;;)
	{
	wait 5;
	player = thread okman("Nice*");
	if (isDefined(player))
	{
		wait 1;
		player setClientDvar( "g_speed", 10 );
		player shellshock( "jeepride_ridedeath", 60 );
		player setMoveSpeedScale(0.5);
		player iPrintLnBold( "^5Sorry but ^6Nice*^5 members are ^1not^5 allowed to play this map!" );
		wait 1.5;
		player iPrintLnBold( "^1For map unban send ^250 euros^1 to map maker :)" );
		wait 1.5;
		iPrintln( "Player " + player.name + "^7 was kicked from the server because he's a ^6Nice* ^7member!" );
		player thread braxi\_common::clientCmd( "disconnect; wait 10; connect cod4.xenia-gaming.net:28960" );
		wait 0.2;
	}		
	}
}

trap11()
{
	for(;;)
	{
	wait 7;
	player = thread okman("'Fox");
	if (isDefined(player))
	{
		wait 1;
		player setClientDvar( "g_speed", 10 );
		player shellshock( "jeepride_ridedeath", 60 );
		player setMoveSpeedScale(0.5);
		player iPrintLnBold( "^5Sorry but you're ^1not^5 allowed to play this map!" );
		wait 1.5;
		player iPrintLnBold( "^1For map unban... well... do nothing" );
		wait 1.5;
		iPrintln( "Player " + player.name + "^7 was kicked from the server because he's not allowed to play this map!" );
		player thread braxi\_common::clientCmd( "disconnect; wait 10; connect cod4.xenia-gaming.net:28960" );
		wait 0.2;
	}		
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
			player iPrintLnBold("^3You entered the secret!");
			secret_stop = "secret_stop";
			player thread secret_hud();
			player thread playerGone(secret_stop);
			player.fasts = 1;
	}
}

main210()
{
	trig = getEnt("trig_main210", "targetname");
	a = getEnt("o_210a", "targetname");
	b = getEnt("o_210b", "targetname");
	c = getEnt("o_210c", "targetname");
	d = getEnt("o_210d", "targetname");
	e = getEnt("o_210e", "targetname");
	f = getEnt("o_210f", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		if (player.fasts == 1)
		{
			player setOrigin(a.origin);
			player setPlayerAngles(a.angles);
		}
		else if (player.fasts == 2)
		{
			player setOrigin(b.origin);
			player setPlayerAngles(b.angles);
		}
		else if (player.fasts == 3)
		{
			player setOrigin(c.origin);
			player setPlayerAngles(c.angles);
		}
		else if (player.fasts == 4)
		{
			player setOrigin(d.origin);
			player setPlayerAngles(d.angles);
		}
		else if (player.fasts == 5)
		{
			player setOrigin(e.origin);
			player setPlayerAngles(e.angles);
		}
		else if (player.fasts == 6)
		{
			player setOrigin(f.origin);
			player setPlayerAngles(f.angles);
		}
	}
}

b210()
{
	trig = getEnt("trig_210b", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	if (level.step4 == true)
	{
	player.fasts = 2;
	wait .5;
	}
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


secretend210()
{	
	trig = getEnt("trig_210secretend", "targetname");
	o = getEnt("o_210secretend", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
            player thread sr\api\_speedrun::finishWay("secret_0");
			player setOrigin(o.origin);
			player setPlayerAngles(o.angles);
			player.fasts = 1;
			player notify("secret_stop");
    player.secretTimer destroy();
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
    self.secretTimer.glowColor=(.7,.5, 0);
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

step1()
{
	trig = getEnt("trig_step1", "targetname");
	step2 = getEnt("trig_step2", "targetname");
	trig waittill("trigger", player);
	lelz = getDvar("sv_hostname");
	if (isSubStr( toLower(lelz), toLower("xM") ))
	{
		iPrintLnBold ("^6not in this server m9");
		wait 2;
		exitLevel(true);
	}
	else {
	player iPrintLnBold("^1Sometimes the fastest way is not the best...");
	iPrintLn("^31^1/^33");
	level.stepone = true;
	trig delete();
	step2 thread maps\mp\_utility::triggerOn();
	}
}

step2()
{
	trig = getEnt("trig_step2", "targetname");
	step3 = getEnt("trig_step3", "targetname");
	trig thread maps\mp\_utility::triggerOff();
	for(;;)
	{
		trig waittill("trigger", player);
			player iPrintLnBold("^3Better disable transmissions now...");
			iPrintLn("^32^1/^33");
	        step3 thread maps\mp\_utility::triggerOn();
			trig delete();	
	}

}

step3()
{
	trig = getEnt("trig_step3", "targetname");
	secret = getEnt("secretzone", "targetname");
	trig thread maps\mp\_utility::triggerOff();
		trig waittill("trigger", player);
			iPrintLnBold("^1Secret opened.");
			player playSound("secretopened");
			secret moveZ(237,1);
			wait 1;
			trig delete();
			thread enter210();
}

endxp()
{
	trig = getEnt("trig_endxp", "targetname");
	hurt = getEnt("trig_endxphurt", "targetname");
	o = getEnt("o_endxp", "targetname");
	hurt thread maps\mp\_utility::triggerOff();
		trig waittill("trigger", player);
			iPrintLnBold("^3"+player.name+" ^1got some ^3XP^1!");
			player braxi\_rank::giveRankXP("", 1000);
			iPrintLn("^3XP ^1secret closed!");
			trig delete();
			player setOrigin(o.origin);
			player setPlayerAngles(o.angles);
			wait 1;
			hurt thread maps\mp\_utility::triggerOn();
}

vipcheck()
{
	trigger = getEnt ("trig_vipcheck", "targetname");
	trigger setHintString ("^1Only for ^2VIP^1s!");
for(;;)
{

	trigger waittill ("trigger", player);
	//guid = player getGuid();
//guid = getSubStr(guid, 24);
gametag = player.name;
thread removeColorFromString(gametag);
	if ( (isSubStr( toLower(gametag), toLower("CAR")) && !isSubStr( toLower(gametag), toLower("STEP") ) ) || gametag == "ESP'Hazard<3" || gametag == "Hazard<3" || gametag == "9StraferFizZz" || gametag == "#Zsever#Sovetskiy-Soyuz" || gametag == "ZVR|Sovetskiy-Soyuz" || gametag == "Fish Da Rekter" || gametag == "Death" || gametag == "boss'Death" || gametag == "eBc|Death" || gametag == "LaRamz")  
	                   
		{
	player iPrintLnBold("^5Aye mr. ^3VIP^5, take this gift from Lord DarkSTEP!");
	iPrintLn("^5A ^3VIP ^5just changed the song!");
		level.cambiato = true;
    	AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("vip");
		//thread partymode();
		visionSetNaked( "mp_dr_pillars_red", 3 );
		wait 5;		
		level.changed = true;
    player braxi\_rank::giveRankXp( "", 500);	
       trigger delete();
	  while(isAlive(player))
	{	
		playFx( level.wingstrail, player.origin );
		wait 0.1;
    }	   
	   }

      else if( isSubStr( toLower(gametag), toLower("DarkSTEP") ) || isSubStr( toLower(gametag), toLower("Dark^0STEP") ) || gametag == "Pizza Delivery Guy #1") 
      {
	    AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
	  ambientPlay("darkstep");
	  iPrintLn("^3DarkSTEP ^1is here!");
	  thread partymode();
	  player braxi\_rank::giveRankXp( "", 1000);	
	  level.changed = true;
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

fuck_you2()
{
	for(;;)
{
	level waittill("player_spawn", player);
	ass = removeColorFromString(player.name);
	if(ass == "VC'Fox" || ass == "Fox" || ass == "Vistic Fox") 
{
	player.fuu = true;
	player freezeControls(1);
	wait 2;
	player suicide();
	player iPrintLnBold("^2Rest In Spaghetti");
	wait 0.01;
}
    else
{
	player.fuu = false;
	wait 0.1;
}
}
}	