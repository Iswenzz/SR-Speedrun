//////////////////////\\\\\\\\\\\\\\\\\\\\\\ Helper Crédits: Sheep Wizard / Blade:
//    __              ___                 \\ ~Script Help
//   /\ \            /\_ \                \\ SuX Stxly (Cold Coffee) / SuX AyPire:
//   \ \ \        ___\//\ \    ____       \\ ~ Helped with the beginning of some small Area.
//    \ \ \  __  / __`\\ \ \  /\_ ,`\     \\ VC'TheLixfe:
//     \ \ \L\ \/\ \L\ \\_\ \_\/_/  /_    \\ ~ Helped with the trap 7 (Wallrun)
//      \ \____/\ \____//\____\ /\____\   \\ 3xP' Viruz:
//       \/___/  \/___/ \/____/ \/____/   \\ ~ Helped with 1 FX for the trap 1.
// 								          \\ 3xP' Skazalien:
//////////////////////\\\\\\\\\\\\\\\\\\\\\\ ~ Helped with the Hard Secret of the map :P
//Map by Lolz      |      Scripted by Lolz\\ #FNRP#Aditya:
//        Nickname i have in game :       \\ ~ Gave a lot of idea :D
//   Lolz :] -SuX Lolz :] -#FNRP#Lolz :]  \\ .....................................
//    Steam:       SuX Lolz :]            \\ Other Crédits:
//////////////////////\\\\\\\\\\\\\\\\\\\\\\ ~Some Models are Copyright Electronic Arts © For The Models Resource only.

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include braxi\_common;

main()
{
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("^2Easy Secret;^1Hard Secret");
thread speedrun\_way_name::create_spawn((-84, -43, 9), 90);

thread speedrun\_way_name::create_tp((-336, -55, 9), 100, 150, 
	(-1892, 7650, -1647), 270, "freeze", "green", "s0");
thread speedrun\_way_name::create_tp((145, -37, 9), 100, 150, 
	(-3468, -383, 404), 180, "freeze", "darkred", "s1");

 maps\mp\_load::main();
 maps\mp\_compass::setupMiniMap("compass_map_mp_dr_mirrors_edge");
 
 level._effect[ "waterfall" ] = loadfx( "misc/custom_waterfall_1" );
 level._effect[ "waterfall_s" ] = loadfx( "misc/custom_waterfall_s" );
 level._effect[ "waterexp" ] = loadfx( "misc/custom_waterxp_1" );
 level._effect[ "red_pickup" ] = loadfx( "misc/ui_pickup_unavailable" );
 level._effect[ "redflash" ] = loadfx( "light/red_flash" );
 level._effect[ "blueflash" ] = loadfx( "light/blue_flash" );
 level._effect[ "fansmoke" ] = loadfx( "smoke/custom_fan_fx" );
 level._effect[ "rain_heavy_mist" ] = loadfx( "weather/rain_mp_farm" );
 level._effect[ "lightning" ] = loadfx( "weather/lightning_mp_farm" );
 level._effect[ "lightwindows" ] = loadfx( "light/whitelight" );
 level._effect[ "c4" ] = loadfx( "explosions/custom_explo_small" );
 level._effect[ "smokeroof" ] = loadfx( "smoke/custom_smoke_roof" );
 level._effect[ "watersplash" ] = LoadFX ( "misc/watersplash_large" );
 level._effect[ "waterbodydump" ] = LoadFX ( "impacts/water_splash_bodydump" );
 level._effect[ "electricsparks" ] = LoadFX ( "light/electric_sparks" );
 level._effect[ "lightningboltimpact" ] = LoadFX ( "viruzfx/lightning_bolt_impact_fl" );
 level._effect[ "bird" ] = LoadFX ( "misc/bird_seagull_flock_large" );
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
 level.trig1used=false;
 level.trig2used=false;
 level.trig3used=false;
 level.trig4used=false;
 level.trig5used=false;
 level.trig6used=false;
 level.trig7used=false;
 
 level.hint1 = getEnt("hint1","targetname");
 level.hint2 = getEnt("hint2","targetname");
 level.hint3 = getEnt("hint3","targetname");
 level.hint4 = getEnt("hint4","targetname");
 level.hint5 = getEnt("hint5","targetname");
 level.hint6 = getEnt("hint6","targetname");
 level.hint7 = getEnt("hint7","targetname");
 
 level.hint1 triggerOff();
 level.hint2 triggerOff();
 level.hint3 triggerOff();
 level.hint4 triggerOff();
 level.hint5 triggerOff();
 level.hint6 triggerOff();
 level.hint7 triggerOff();
 
 roofvent = getEntArray("roofpref_helice_turn","targetname");
 for(i = 0;i < roofvent.size;i++)
 roofvent[i] thread roofventil();
 
 roofvent2 = getEntArray("roofpref_helice_turn2","targetname");
 for(i = 0;i < roofvent2.size;i++)
 roofvent2[i] thread roofventil2();
 
 roofvent3 = getEntArray("roofpref_helice_turn3","targetname");
 for(i = 0;i < roofvent3.size;i++)
 roofvent3[i] thread roofventil3();
 
 roofvent4 = getEntArray("ventil2_sfx","targetname");
 for(i = 0;i < roofvent4.size;i++)
 roofvent4[i] thread roofventil4();
 
 ttl = getEntArray("turn_left","targetname");
 for(i = 0;i < ttl.size;i++)
 ttl[i] thread textturnl();
 
 ttr = getEntArray("turn_right","targetname");
 for(i = 0;i < ttr.size;i++)
 ttr[i] thread textturnr();
 
 rel = getEntArray("fx_end","targetname");
 for(i = 0;i < rel.size;i++)
 rel[i] thread finfxng();
 
 ac1sfx = getEntArray("ac1_sfx","targetname");
 for(i = 0;i < ac1sfx.size;i++)
 ac1sfx[i] playLoopSound("ac1");
 
 gassfx = getEntArray("gas_sfx","targetname");
 for(i = 0;i < gassfx.size;i++)
 gassfx[i] playLoopSound("gas");
 
 // level endon("mirror_start");
 // thread SetTimeLimit( 8 );

	//SETDVAR**
	setDvar("g_knockback", "1000"); //Default
	setDvar("r_specularcolorscale", "1");
	setDvar("compassmaxrange","1600");
	setDvar("r_glowbloomintensity0",".1");
	setDvar("r_glowbloomintensity1",".1");
	setDvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 300 ); //Don't change any falldamage value or the map will have alot of glitch
	setDvar("bg_falldamageminheight", 128 ); // --------------------------------------------------------------------
	//SETDVAR*

	//THREAD**
	level.day        = 0;
	level.night      = 0;
	level.pick       = 0;
	level.cranetrap  = 0;
	level.trap1      = 0;
	level.trap4wind  = 0;
	level.trap5n     = 0;
	level.cranetime  = 0;
	level.craneftime = 0;
	level.cranewtime = 0;
	level.trap5water = 0;
	level.trap5wacti = 0;
	thread onPlayerConnected();
	// thread onRound();
	thread ff();
	thread bags();
	thread giverpg();
	thread lightloop();
	thread rpg_remove();
	thread fxw1();
	thread fxw3();
	thread startdoor();
	thread wrun();
	thread xpbag();
	thread killsonground();
	thread killsonginterm();
	thread traptrigoff();
	thread gridsfx();
	thread music();
	thread zipline();
	thread crane1();
	// thread mapzor();
	// thread messages();
	thread secretp();
	thread doorsetup();
	thread cturn();
	// thread guidchecking();
	// thread credits();
	thread end();
	// thread games();
	// thread sniperroom2();
	// thread sniperroom();
	// thread sniperjumperfail();
	// thread shotgun();
	// thread weaponsroom();
	// thread bounceroom();
	// thread givesniper();
	// thread bouncejumperfail();
	// thread bounceactifail();
	// thread kniferoom();
	thread water_hud();
	// thread WatchHelicopterTrigger();
	//THREAD*

	//PRECACHE**
	precacheMenu  ("musicmenu");
	//precacheMenu  ("actimenu");
	precacheModel ("vehicle_mig29_desert");
	precacheShader("waypoint_defuse_b");
	PrecacheModel ("vehicle_blackhawk");
	PrecacheModel ("vehicle_mi24p_hind_desert");
	precacheItem  ("m40a3_mp");
	precacheItem  ("remington700_mp");
	precacheItem  ("ak74u_mp");
	precacheItem  ("m40a3_mp");
	precacheItem  ("remington700_mp");
	precacheItem  ("knife_mp");
	precacheItem  ("tomahawk_mp");
	precacheItem  ("uzi_silencer_mp");
	precacheItem  ("ak74u_mp");
	precacheItem  ("rpg_mp");
	precacheItem  ("winchester1200_mp");
	precacheItem  ("ak47_mp");
	precacheItem  ("rpd_mp");
	precacheItem  ("m1014_grip_mp");
	precacheItem  ("deserteaglegold_mp");
	precacheItem  ("p90_silencer_mp");
	precacheItem  ("saw_grip_mp");
	precacheShader("mtl_faith_body_lower");
    precacheShader("mtl_faith_body_upper");
    precacheShader("mtl_faith_eye");
    precacheShader("mtl_faith_eye_lashes");
    precacheShader("mtl_faith_face");
	precacheShader("mtl_faith_glove");
	precacheShader("mtl_faith_hair_darkbrown");
	precacheShader("mtl_faith_teeth");
    precacheModel ("faith_mirrors");
	precacheShader("mtl_sonic");
	precacheShader("mtl_corpo");
	precacheShader("mtl_sidney");
	precacheModel ("sonic");
	//PRECACHE*

	//ACTI**
	if(isDefined(level.trapsdisabled))
	{
		if(level.trapdisabled==true)
		{
		level.trig1used=true;
		level.trig2used=true;
		level.trig3used=true;
		level.trig4used=true;
		level.trig5used=true;
		level.trig6used=true;
		level.trig7used=true;
		}
	}
	//ACTI*

level.trap5ng = getEnt("trap5m","targetname");
nightsky = getEnt("night_sky","targetname");
pld = getEntArray("decal_pl","targetname");
random1 = 0;

if(random1 != 5)
{
nightsky delete();
level.day = 1;
level.night = 0;
thread lightstreetoff();
visionSetNaked( "mp_dr_mirrors_edge", 0 );
	for(i = 0; i < pld.size; i++)
	{
	pld[i] delete();
	}
}
if(random1 == 5)
{
thread nightmodesetup();
level.night = 1;
level.day = 0;

	for(;;)
	{
	level waittill("connecting", player);
	level common_scripts\utility::waittill_any("round_started","game started");
	visionSetNaked( "mirror_edge_night", 0 );
	}
}
else
{
wait 0.2;
}

	//THREAD NG**
	wait 1;
	thread roofsmokefx();
	thread ambientspawn();
	thread bspawn();
	//THREAD NG*

}


SetTimeLimit( time )
{
    wait 0.2; //ng
	if( level.dvar["time_limit"] <= time )
		level.dvar["time_limit"] = time;
}



addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = []; //Don't add the trap trigger to list on this map. trapdisabled and xp are in the trap script already.
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


bspawn()
{
	level waittill("round_started");
	playFX(level._effect[ "bird" ], (263,1568,125));
}


ff() //ng
{
	ft = getEnt("force_dvar","targetname");
	
	for(;;)
	{
		ft waittill("trigger",player);
		player thread forcelight( player );
		player thread forcedvar( player );
		wait 2;
	}
}


onPlayerConnected()
{
	for(;;)
	{
	level waittill("connected", player);
	player.musiclocal = 0;
	player.s1p = 0;
	player.s2p = 0;
	player.s3p = 0;
	player.s4p = 0;
	player.s5p = 0;
	player thread onPlayer();
	player thread forcelight( player ); //ng
	}
}


onRound()
{
	for(;;)
	{
	level waittill("round_started",player);
	player.timerstarted1 = undefined;
	player.timerstarted2 = undefined;
	player.hardfin = undefined;
	player.easyfin = undefined;
	player.secretonce1 = undefined;
	player.gridsfx = undefined;
	player.tiro = undefined;
	player.tiro2 = undefined;
	player thread forcelight( player ); //ng
	player thread onPlayer(); //ng
	}
}


onPlayer()
{
	for(;;)
	{
	level waittill("player_spawn",player);
	player.tiro = undefined;
	player.tiro2 = undefined;
	player.musiclocal = 0;
	player thread forcedvar( player ); //if not forced some traps / thing on the map will not work
	player thread forcelight( player ); //THIS thing is for the night/day cycle if you remove it, the map will look weird on day/night version
	}
}


forcelight( player )
{
	self endon("death");
	self endon("disconnect");

	while(1)
	{
		if( level.night == 1 )
		{
			player setClientDvar("r_filmtweakenable", "1");
			player setClientDvar("r_lighttweaksunlight", "0.6");
			wait 0.2;
			player setClientDvar("r_filmtweakenable", "0");
		}
		if( level.day == 1 )
		{
			player setClientDvar("r_filmtweakenable", "1");
			player setClientDvar("r_lighttweaksunlight", "1.3");
			wait 0.2;
			player setClientDvar("r_filmtweakenable", "0");
		}
	wait 1;
	}
}


forcedvar( p )
{
	self endon("death");
	self endon("disconnect");

	while(1)
	{
		p setClientDvar("dynent_active","1");
		p setClientDvar("r_detail","1");
		p setClientDvar("r_specular","1");
		p setClientDvar("r_normal","1");
		p setClientDvar("r_drawsun","0");
		wait 1;
	}
}


giverpg()
{
	rpg2give = getEnt("give_rpg2","targetname");

	for(;;)
	{
	rpg2give waittill("trigger", player);
	 player giveweapon("rpg_mp");
	player switchtoweapon("rpg_mp"); 
	player givemaxammo("rpg_mp"); 
	wait 0.2;
	}
}


xpbag()
{
thread xp1();
thread xp2();
thread xp3();
}


xp1()
{
x1 = getEnt("xpbag_1","targetname");
xt1 = getEnt("xpbag_trig_1","targetname");
level.ngpos = (-404, 20256, -20648);

xt1 waittill("trigger",player);
player playSound("health_pickup_large");
x1 delete();
xt1 delete();
/* [AUTO DELETE] player iPrintLnBold("^1You ^7won ^3400 ^7XP !"); */
/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 400); */
player braxi\_mod::giveLife();
wait 0.2;
}


xp2()
{
x2 = getEnt("xpbag_2","targetname");
xt2 = getEnt("xpbag_trig_2","targetname");

xt2 waittill("trigger",player);
player playSound("health_pickup_large");
x2 delete();
xt2 delete();
/* [AUTO DELETE] player iPrintLnBold("^1You ^7won ^3400 ^7XP !"); */
/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 400); */
player braxi\_mod::giveLife();
wait 0.2;
}


xp3()
{
x3 = getEnt("xpbag_3","targetname");
xt3 = getEnt("xpbag_trig_3","targetname");
xng3 = getEnt("xpbag_3_ng","targetname");
tp = spawn("script_origin", (-96, -8, -40));
tp.angles = (0,90,0);

xt3 waittill("trigger",player);
player playSound("health_pickup_large");
x3 delete();
xt3 delete();
/* [AUTO DELETE] player iPrintLnBold("^1You ^7won ^3400 ^7XP !"); */
/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 400); */
player braxi\_mod::giveLife();
player setOrigin(tp.origin);
player setPlayerAngles(tp.angles);
wait 1;
xng3 triggerOn();
thread xp3ng(tp);
}


xp3ng(tp)
{
xng3 = getEnt("xpbag_3_ng","targetname");

	for(;;)
	{
		xng3 waittill("trigger",player);
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
		/* [AUTO DELETE] wait 0.1; */
	}
}


gridsfx()
{
gtrig = getEnt("grid_sfx","targetname");

	for(;;)
	{
		gtrig waittill("trigger", player);
		player thread gridsfxng();
		wait .05;
	}
}


gridsfxng()
{
	if(!isDefined(self.gridsfx))
	{
	self.gridsfx = true;
	random = randomint(2);
	time = RandomIntRange( 0.2, 0.8 );
		if(random != 1)
		{
			wait time;
			self playSound("grid2");
			wait 3;
			self.gridsfx = undefined;
		}
		if(random == 1)
		{
			wait time;
			self playSound("grid1");
			wait 3;
			self.gridsfx = undefined;
		}
	}
}


rpg_remove()
{
    trig = getEnt("rpg_remove", "targetname");
    while(1)
    {
        trig waittill("trigger", player);
        currentwep = player getCurrentWeapon();
        currentnade = player GetCurrentOffhand();
        if(currentwep == "rpg_mp")
        {
            if(!isDefined(player.pers["weapon"]))
                player.pers["weapon"] = "deserteaglegold_mp";
            player takeWeapon();
            /* [AUTO DELETE] player giveWeapon(player.pers["weapon"]); */
            /* [AUTO DELETE] player switchToWeapon(player.pers["weapon"]); */
            /* [AUTO DELETE] player giveMaxAmmo(player.pers["weapon"]); */
        }
        if(currentnade == "frag_grenade_mp" && !isDefined(player.fragremoved))
        {
            if(!isDefined(player.pers["weapon"]))
                player.pers["weapon"] = "deserteaglegold_mp";
            /* [AUTO DELETE] player takeAllWeapons(); */
            /* [AUTO DELETE] player giveWeapon(player.pers["weapon"]); */
            /* [AUTO DELETE] player switchToWeapon(player.pers["weapon"]); */
            /* [AUTO DELETE] player giveMaxAmmo(player.pers["weapon"]); */
            player.fragremoved = true;
        }
    wait 0.05;
    }
}


countdown1()
{
    self endon ("finished");

    self.timelimit1 = 180;

    self.time_hud1 = newClientHudElem(self);
    self.time_hud1.x = 305;
    self.time_hud1.y = 15;
    //self.time_hud1.alignX = "middle";
    //self.time_hud1.alignY = "center";
    self.time_hud1.fontScale = 2.3;
    self.time_hud1.color = (40, 112, 222);
    self.time_hud1.font = "objective";
    self.time_hud1.glowColor = (40, 112, 222);
    self.time_hud1.glowAlpha = 1;
    self.time_hud1.hideWhenInMenu = false;
    self.time_hud1.owner = self;
    self.time_hud1 setText( self.timelimit1 );
    while(1)
    {
        wait 1;
        self.timelimit1 --;
        if(self.timelimit1 < 0)
        {
            self suicide();
            if(isDefined(self.time_hud1))
                self.time_hud1 destroy();
            self.timerstarted1 = undefined;
            self notify("finished");
            /* [AUTO DELETE] self iPrintLn("You failed secret"); */
        }
		
        self.time_hud1 setText( self.timelimit1 );
    }
}


on_death1()
{
    self waittill("death");
	self notify("finished");
    if(isDefined(self.time_hud1))
        self.time_hud1 destroy();
    self.timerstarted1 = undefined;
}


countdown2()
{
    self endon ("finished2");

	self.timer = getTime();
    self.timelimit2 = 180;

    self.time_hud2 = newClientHudElem(self);
    self.time_hud2.x = 305;
    self.time_hud2.y = 15;
    //self.time_hud2.alignX = "middle";
    //self.time_hud2.alignY = "center";
    self.time_hud2.fontScale = 2.3;
    self.time_hud2.color = (40, 112, 222);
    self.time_hud2.font = "objective";
    self.time_hud2.glowColor = (40, 112, 222);
    self.time_hud2.glowAlpha = 1;
    self.time_hud2.hideWhenInMenu = false;
    self.time_hud2.owner = self;
    self.time_hud2 setText( self.timelimit1 );
    while(1)
    {
        wait 1;
        self.timelimit2 --;
        if(self.timelimit2 < 0)
        {
            self suicide();
            if(isDefined(self.time_hud2))
                self.time_hud2 destroy();
            self.timerstarted2 = undefined;
            self notify("finished2");
            /* [AUTO DELETE] self iPrintLn("You failed secret"); */
        }
        self.time_hud2 setText( self.timelimit2 );
    }
}


on_death2()
{
    self waittill("death");
	self notify("finished2");
    if(isDefined(self.time_hud2))
        self.time_hud2 destroy();
    self.timerstarted2 = undefined;
}


secretp()
{
thread secretopen();
thread eztp0();
thread eztp1();
thread eztp2();
thread eztp3();
thread ezfin();
thread itp1();
thread intfin();
thread htp0();
thread htp1();
thread htp2();
thread htp3();
thread htp4();
thread htp5();
// thread easyfin(); //fin easy secret cc
thread hardfin(); //fin hard secret
}


secretopen()
{
trigo = getEnt("cjs_open","targetname");
ladero = getEnt("cjs_ladder","targetname");
entro = getEnt("cj_secret_ent","targetname");
entrori = getEnt("eztpori0","targetname");
thread trap1ng();
trigo waittill("trigger");
ladero moveZ(1000, .05);

	for(;;)
	{
	entro waittill("trigger", player);
	player thread secretentng(player, entrori);
	}
}


secretentng(player, entrori)
{
	// if(!isDefined(player.secretonce1))
	// {
	// 	if(!isdefined(player.timerstarted1))
 //        {
 //            player thread countdown1();
 //            player.timerstarted1 = true;
            
 //            player thread on_death1();
 //        }
	// player.secretonce1 = true;
	// player setOrigin(entrori.origin);
	// player setPlayerAngles(entrori.angles);
	// player freezeControls(true);
	// wait .1;
	// player freezeControls(false);
	// }
	// else
	// {
	// wait 0.2;
	// }
}


easyfin()
{
easyfinn = getEnt("a_finish_ez","targetname");
eefin = getEnt("ezfinish_ori","targetname");

	for(;;)
	{
	easyfinn waittill("trigger",player);
	player thread easyfinng(player, easyfinn, eefin);
	}
}


easyfinng(player, easyfinn, eefin)
{
	if( isDefined (player.easyfin) )
	{
		if(isDefined(player.timerstarted1))
        {
            if(isDefined(player.time_hud1))
               player.time_hud1 destroy();
            player.timerstarted1 = undefined;
        }
		player setOrigin(eefin.origin);
		player setPlayerAngles(eefin.angles);
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 1); */
		player notify("finished");
		player freezeControls(true);
		wait .1;
		player freezeControls(false);
	}
	
	if( !isDefined (player.easyfin) )
	{
        if(isDefined(player.timerstarted1))
        {
            if(isDefined(player.time_hud1))
               player.time_hud1 destroy();
            player.timerstarted1 = undefined;
        }
	player.easyfin = true;
	player setOrigin(eefin.origin);
	player setPlayerAngles(eefin.angles);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 400); */
	player notify("finished");
	player freezeControls(true);
	wait .1;
	player freezeControls(false);
	}
}


hardfin()
{
hardfinn = getEnt("a_finish_hard","targetname");
hhfin = getEnt("hardfinish_ori","targetname");

	for(;;)
	{
	hardfinn waittill("trigger",player);
	// player thread hardfinng(player, hardfinn, hhfin);
	player thread speedrun\_way_name::finish_way("s1");
	}
}


hardfinng(player, hardfinn, hhfin)
{
	
	if( isDefined (player.hardfin) )
	{
		if(isDefined(player.timerstarted2))
        {
            if(isDefined(player.time_hud2))
               player.time_hud2 destroy();
            player.timerstarted2 = undefined;
        }
		player setOrigin(hhfin.origin);
		player setPlayerAngles(hhfin.angles);
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 69); */
		player notify("finished2");
		player freezeControls(true);
		wait .1;
		player freezeControls(false);
	}
	
	if( !isDefined (player.hardfin) )
	{
		if(isDefined(player.timerstarted2))
        {
            if(isDefined(player.time_hud2))
               player.time_hud2 destroy();
            player.timerstarted2 = undefined;
        }
	player.hardfin = true;
	player setOrigin(hhfin.origin);
	player setPlayerAngles(hhfin.angles);
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 800); */
	player notify("finished2");
	timerres = (getTime() - self.timer) / 1000;
	/* [AUTO DELETE] iprintlnbold( player.name + " ^7Finished ^1HARD ^7Secret in^1 " + timerres + " ^7!"); */
	if(level.night == 1 && level.trap4wind == 1)
		level.ngpos = (-404, 20256, -2648);
	player freezeControls(true);
	wait .1;
	player freezeControls(false);
	}
}


intfin()
{
intfin = getEnt("hard_next_s","targetname");
hhtp = getEnt("tphardori1","targetname");

	for(;;)
	{
	intfin waittill("trigger",player);
	// 	if(!isdefined(player.timerstarted2))
 //        {
 //            player thread countdown2();
 //            player.timerstarted2 = true;
            
 //            player thread on_death2();
 //        }
	// 	if(isDefined(player.time_hud1))
	// 	{
	// 		player.time_hud1 destroy();
	// 	}
	// player notify("finished");
	player setOrigin(hhtp.origin);
	player setPlayerAngles(hhtp.angles);
	player freezeControls(true);
	player freezeControls(false);
	}
}


ezfin()
{
eztrig = getEnt("ez_finish_trig","targetname");
itp = getEnt("int_ori_tp","targetname");

	for(;;)
	{
	eztrig waittill("trigger",player);
	// player setOrigin(itp.origin);
	// player setPlayerAngles(itp.angles);
	// player freezeControls(true);
	//  [AUTO DELETE] wait .1; 
	// player freezeControls(false);
	player thread speedrun\_way_name::finish_way("s0");
	}
}


itp1()
{
itrig = getEnt("int_trig_tp","targetname");
itp = getEnt("int_ori_tp","targetname");

	for(;;)
	{
	itrig waittill("trigger",player);
	player setOrigin(itp.origin);
	player setPlayerAngles(itp.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


htp0()
{
htpo = getEnt("tphardori0","targetname");
hp = getEnt("tphard0","targetname");

	for(;;)
	{
	hp waittill("trigger",player);
	player setOrigin(htpo.origin);
	player setPlayerAngles(htpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


htp1()
{
htpo = getEnt("tphardori1","targetname");
hp = getEnt("tphard1","targetname");

	for(;;)
	{
	hp waittill("trigger",player);
	player setOrigin(htpo.origin);
	player setPlayerAngles(htpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


htp2()
{
htpo = getEnt("tphardori2","targetname");
hp = getEnt("tphard2","targetname");

	for(;;)
	{
	hp waittill("trigger",player);
	player setOrigin(htpo.origin);
	player setPlayerAngles(htpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


htp3()
{
htpo = getEnt("tphardori3","targetname");
hp = getEnt("tphard3","targetname");

	for(;;)
	{
	hp waittill("trigger",player);
	player setOrigin(htpo.origin);
	player setPlayerAngles(htpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


htp4()
{
htpo = getEnt("tphardori4","targetname");
hp = getEnt("tphard4","targetname");

	for(;;)
	{
	hp waittill("trigger",player);
	player setOrigin(htpo.origin);
	player setPlayerAngles(htpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


htp5()
{
htpo = getEnt("tphardori5","targetname");
hp = getEnt("tphard5","targetname");

	for(;;)
	{
	hp waittill("trigger",player);
	player setOrigin(htpo.origin);
	player setPlayerAngles(htpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


eztp0()
{
eztpo = getEnt("eztpori0","targetname");
ezp = getEnt("eztp0","targetname");

	for(;;)
	{
	ezp waittill("trigger",player);
	player setOrigin(eztpo.origin);
	player setPlayerAngles(eztpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


eztp1()
{
eztpo = getEnt("eztpori1","targetname");
ezp = getEnt("eztp1","targetname");

	for(;;)
	{
	ezp waittill("trigger",player);
	player setOrigin(eztpo.origin);
	player setPlayerAngles(eztpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


eztp2()
{
eztpo = getEnt("eztpori2","targetname");
ezp = getEnt("eztp2","targetname");

	for(;;)
	{
	ezp waittill("trigger",player);
	player setOrigin(eztpo.origin);
	player setPlayerAngles(eztpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


eztp3()
{
eztpo = getEnt("eztpori3","targetname");
ezp = getEnt("eztp3","targetname");

	for(;;)
	{
	ezp waittill("trigger",player);
	player setOrigin(eztpo.origin);
	player setPlayerAngles(eztpo.angles);
	player freezeControls(true);
	/* [AUTO DELETE] wait .1; */
	player freezeControls(false);
	}
}


bags()
{
    thread bagng();
    level.bag = [];
 
    level.bag[0]=getent("bag_script_0","targetname");
    level.bag[1]=getent("bag_script_1","targetname");
    level.bag[2]=getent("bag_script_2","targetname");
    level.bag[3]=getent("bag_script_3","targetname");
    level.bag[4]=getent("bag_script_4","targetname");
    level.bag[5]=getent("bag_script_5","targetname");
    level.bag[6]=getent("bag_script_6","targetname");
    level.bag[7]=getent("bag_script_7","targetname");
    level.bag[8]=getent("bag_script_8","targetname");
   
    level.bag_left = level.bag.size;
    level.bagtrig = [];
 
    level.bagtrig[0]=getent("bag_trig_script_0","targetname");
    level.bagtrig[1]=getent("bag_trig_script_1","targetname");
    level.bagtrig[2]=getent("bag_trig_script_2","targetname");
    level.bagtrig[3]=getent("bag_trig_script_3","targetname");
    level.bagtrig[4]=getent("bag_trig_script_4","targetname");
    level.bagtrig[5]=getent("bag_trig_script_5","targetname");
    level.bagtrig[6]=getent("bag_trig_script_6","targetname");
    level.bagtrig[7]=getent("bag_trig_script_7","targetname");
    level.bagtrig[8]=getent("bag_trig_script_8","targetname");


    rdn = randomInt(3);
    switch(rdn)
    {
        case 0:
            level.bagtrig[0] thread trigwait(0, 1);
            level.bagtrig[1] thread trigwait(1, 2);
            level.bagtrig[2] thread trigwait(2, 3);
            level.bagtrig[3] thread trigwait(3, 4);
            deletebag(4,5,6,7,8);
            break;
        case 1:
            level.bagtrig[4] thread trigwait(4, 1);
            level.bagtrig[5] thread trigwait(5, 2);
            level.bagtrig[6] thread trigwait(6, 3);
            level.bagtrig[7] thread trigwait(7, 4);
            deletebag(0,1,2,3,8);
            break;
        case 2:
            level.bagtrig[0] thread trigwait(0, 1);
            level.bagtrig[5] thread trigwait(5, 2);
            level.bagtrig[8] thread trigwait(8, 3);
            level.bagtrig[3] thread trigwait(3, 4);
            deletebag(1,2,4,6,7);
            break;
        case 3:
            level.bagtrig[8] thread trigwait(8, 1);
            level.bagtrig[4] thread trigwait(4, 2);
            level.bagtrig[3] thread trigwait(3, 3);
            level.bagtrig[1] thread trigwait(1, 4);
            deletebag(0,2,5,6,7);
            break;

    }
}


deletebag(bag1, bag2, bag3, bag4, bag5)
{
    level.bag[bag1] delete();
    level.bagtrig[bag1] delete();
    level.bag[bag2] delete();
    level.bagtrig[bag2] delete();
    level.bag[bag3] delete();
    level.bagtrig[bag3] delete();
    level.bag[bag4] delete();
    level.bagtrig[bag4] delete();
    level.bag[bag5] delete();
    level.bagtrig[bag5] delete();
}

 
trigwait(bag, bagnum)
{
    self waittill( "trigger", player );
    self delete();
	player playSound("health_pickup_large");
	/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 40); */
	level.bag[bag] delete();
    level.bag_left--;
    level.found++;
    /* [AUTO DELETE] iPrintLnBold( player.name + " found the bag ^1" + bagnum ); */
    wait 0.2;
}

 
bagng()
{
level.found = 0;
 
    while(level.found<4)
    {
    wait(5);
        if(level.found == 4)
        {
            thread allplayerxp();
            wait .2;
        }
        else
        {
            wait .2;
        }
    wait .02;
    }
}


allplayerxp()
{
players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
	wait 0.1;
		if(isAlive(players[i]))
		{
		wait(0.05);
		/* [AUTO DELETE] players[i] braxi\_rank::giveRankXp( "", 500 ); */
		}
	}
}


textturnl()
{
	while(1)
	{
	self rotateYaw(360,3);
	wait 3;
	}
}


textturnr()
{
	while(1)
	{
	self rotateYaw(360,3);
	wait 3;
	}
}


wrun()
{
wr1 = getEnt("wallruntest1","targetname");
wr2 = getEnt("wallruntest2","targetname");
wait 1;
wr1 rotatePitch(-110,1);
wr2 rotatePitch(-110,1);
}


lightloop()
{
wait 2;
thread redl();
wait .4;
thread bluel();
}


finfxng()
{
	wait 3;
	playFX(level._effect[ "red_pickup" ], self.origin);
}


redl()
{
rl = getEntArray("fx_redlight","targetname");

	for( i = 0; i < rl.size; i++ )
	{
	playFX(level._effect[ "redflash" ], rl[i].origin);
	wait .05;
	}
}


bluel()
{
bl = getEntArray("fx_bluelight","targetname");

	for( i = 0; i < bl.size; i++)
	{
	playFX(level._effect[ "blueflash" ], bl[i].origin);
	wait .05;
	}
}


startdoor()
{
	sdoor = getEnt("c_startdoor","targetname");
	sclip = getEnt("clip_startdoor","targetname");
	
	wait 13.6;
	sdoor moveZ(-500,4 ,1 ,0);
	wait 0.4;
	level notify("mirror_start");
	sclip delete();
	wait 3.6;
	sdoor delete();
}


ambientspawn()
{
	level waittill("mirror_start");
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		if( level.day == 1 && players[i].musiclocal == 0 )
		{
		 players[i] playLocalSound("ambient_daysp1"); 
		}
	}
}


killsonground()
{
	level waittill( "round_ended" );
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] stopLocalSound("music1");
		players[i] stopLocalSound("music2");
		players[i] stopLocalSound("music3");
		players[i] stopLocalSound("music4");
		players[i] stopLocalSound("music5");
	}
}


killsonginterm()
{
	level waittill( "intermission" );
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] stopLocalSound("music1");
		players[i] stopLocalSound("music2");
		players[i] stopLocalSound("music3");
		players[i] stopLocalSound("music4");
		players[i] stopLocalSound("music5");
	}
}


traptrigoff()
{
thread trigdelete();
trap1h = getEnt("trap1_hurt","targetname");
t2rh1 = getEnt("trap2_hurt_1","targetname");
t2rh2 = getEnt("trap2_hurt_2","targetname");
t2rh3 = getEnt("trap2_hurt_3","targetname");
t2rh4 = getEnt("trap2_hurt_4","targetname");
t2rh5 = getEnt("trap2_hurt_5","targetname");
t2rh6 = getEnt("trap2_hurt_6","targetname");
t2rh7 = getEnt("trap2_hurt_7","targetname");
t2rh8 = getEnt("trap2_hurt_8","targetname");
t2rh9 = getEnt("trap2_hurt_9","targetname");
ladero = getEnt("cjs_ladder","targetname");
xng3 = getEnt("xpbag_3_ng","targetname");
level.dmg1 = getEnt("trap2_dmg_fast","targetname");
wait 0.2;


ladero moveZ(-1000, .05);
t2rh1 triggerOff();
t2rh2 triggerOff();
t2rh3 triggerOff();
t2rh4 triggerOff();
t2rh5 triggerOff();
t2rh6 triggerOff();
t2rh7 triggerOff();
t2rh8 triggerOff();
t2rh9 triggerOff();
level.dmg1 triggerOff();
trap1h triggerOff();
xng3 triggerOff();
}


trigdelete()
{
	t7 = getEnt("trap7delete","targetname");
	t7ng = getEnt("trap7ng","targetname");
	t7 waittill("trigger");
	t7 delete();
	t7ng delete();
}


music()
{
    trig = getEnt("musicmenu", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);
        player thread openMusicMenu();
        wait 0.05;
    }
}


openMusicMenu()
{

    self openMenu("musicmenu");
 
    for(;;)
    {
        self waittill("menuresponse", menu, response);

        if(menu == "musicmenu")
        {
       
            if(!isDefined(self.musicon))
            {
                self stopLocalSound("ambient_daysp1");
                self.musiclocal = 1;
                self.musicon = 1;
                self.currentmusic = response;
                self loops(response);
            }
            else if(self.musicon == 1 && response != self.currentmusic) 
            {
                self stopLocalSound(self.currentmusic);
                self notify("musicstopped");
                self.currentmusic =  response;
                self loops(response);
            }
         }
       
        wait 0.05;
    }

}


 
loops(response)
{
    switch(response)
    {
        case "music1":
            self thread s1(278, response);
            break;
        case "music2":
            self thread s1(269, response);
            break;
        case "music3":
            self thread s1(212, response);
            break;
        case "music4":
            self thread s1(178, response);
            break;
        case "music5":
            self thread s1(230, response);
            break;
    }
   
}

 
s1(time,response)
{
    self endon("musicstopped");
    while(1)
    {
        self playLocalSound(response);

        wait time;
    }
}


nightmodesetup()
{

thread rainfx();
thread godrayoff();

}


lightstreetoff()
{
lsoff = getEntArray("lightstreet_on","targetname");

	for(i = 0;i < lsoff.size;i++)
	{
	lsoff[i] delete();
	wait 0.05;
	}
}


godrayoff()
{
sgray = getEnt("day_godray1","targetname");

	for(;;)
	{
	sgray delete();
	wait 0.2;
	}
}


rainfx()
{	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 0, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 0, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 0, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 2500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 2500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 2500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 5000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 5000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 5000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 7500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 7500, -2500);
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 7500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 10000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 10000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 10000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 12500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 12500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 12500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 15000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 15000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 15000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 17500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 17500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 17500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 20000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 20000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 20000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 0, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 0, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 0, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 2500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 2500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 2500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 5000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 5000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 5000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 7500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 7500, 2500);
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 7500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 10000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 10000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 10000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 12500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 12500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 12500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 15000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 15000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 15000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 17500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 17500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 17500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 20000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 20000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 20000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 0, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 0, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 0, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 2500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 2500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 2500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 5000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 5000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 5000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 7500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 7500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 7500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 10000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 10000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 10000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 12500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 12500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 12500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 15000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 15000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 15000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 17500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 17500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 17500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 0, 20000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 2500, 20000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 20000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 7500, 10000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 7500, 10000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 7500, 10000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 5000, 7500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 5000, 7500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 5000, 7500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( 5000, 10000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -5000, 2500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -5000, 2500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -5000, 2500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -5000, 5000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -5000, 5000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -5000, 5000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -10000, 2500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -10000, 2500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -10000, 2500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -10000, 0, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -10000, 0, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -10000, 0, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 15000, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 15000, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 15000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -2500, 15000, -5000 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -5000, 9000, 1000 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -5000, 9000, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -1300, 21000, -1000 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -1300, 21000, -3500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -1300, 21000, -4500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -1000, 21000, -2000 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -1000, 21000, -4500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "rain_heavy_mist" );
	ent.v[ "origin" ] = ( -3400, 18500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "rain_heavy_mist";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "lightning" );
	ent.v[ "origin" ] = ( -2500, 17500, 0 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "lightning";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "lightning" );
	ent.v[ "origin" ] = ( -2500, 17500, 2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "lightning";
	ent.v[ "delay" ] = -15;
	
	ent = maps\mp\_utility::createOneshotEffect( "lightning" );
	ent.v[ "origin" ] = ( -2500, 17500, -2500 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "lightning";
	ent.v[ "delay" ] = -15;
	
	rainfx = spawn("script_origin", (0, 0, 0));
	rainfx playLoopSound("ambient_ambush_ext0_sur");
}


cturn()
{
ct1 = getEnt("cturn_1","targetname");

	while(1)
	{
	ct1 rotateYaw(720, 4);
	wait 4;
	}
}


roofventil()
{
self playLoopSound("fan2");
	while(1)
	{
	self rotateYaw(720, 3);
	wait 3;
	}
}


roofventil2()
{
self playLoopSound("fan2");
	while(1)
	{
	self rotateRoll(720, 3);
	wait 3;
	}
}


roofventil3()
{
self playLoopSound("fan2");
	while(1)
	{
	self rotatePitch(720, 3);
	wait 3;
	}
}


roofventil4()
{
self playLoopSound("fan2");
	while(1)
	{
	self rotateYaw(720, 3);
	wait 3;
	}
}


trap1( user )
{
trap1h = getEnt("trap1_hurt","targetname");

if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
user braxi\_rank::giveRankXP("", 100);
/* [AUTO DELETE] user iprintlnbold("^2Activated"); */

	{
	thread trap1fx1();
	wait 1;
	trap1h triggerOn();
	trap1h playSound("electric");
	thread trap1fx2();
	wait 1;
	thread trap1fx2();
	wait 7;
	thread trap1fx2();
	wait 3;
	trap1h delete();
	wait 8;
	thread delfx1();
	thread delfx2();
	}
}


trap1ng()
{
	level endon("trigger");
ng1 = getEnt("trap1go","targetname");
ng2 = getEnt("trap1ng","targetname");
wait 0.2;
ng1 waittill("trigger");
ng1 delete();
wait 0.2;
ng2 waittill("trigger");
ng2 delete();
level.trap1 = 1;
}


delfx1()
{
del1 = getEntArray("fx_elects","targetname");

	for( i = 0; i < del1.size; i++)
	{
	del1[i] delete();
	wait .05;
	}
}


delfx2()
{
del2 = getEntArray("fx_lightbi","targetname");

	for( i = 0; i < del2.size; i++)
	{
	del2[i] delete();
	wait .05;
	}
}


trap1fx1()
{
elects = getEntArray("fx_elects","targetname");

	for( i = 0; i < elects.size; i++)
	{
	playFx( level._effect["lightningboltimpact"],elects[i].origin );
	wait 0.1;
	playFx( level._effect["electricsparks"],elects[i].origin );
	wait 0.1;
	}
}


trap1fx2()
{
lightb = getEntArray("fx_lightbi","targetname");

	for( i = 0; i < lightb.size; i++)
	{
	playFx( level._effect["electricsparks"],lightb[i].origin );
	wait 0.1;
	playFx( level._effect["electricsparks"],lightb[i].origin );
	wait 0.1;
	}
}


trap15( user )
{
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
user braxi\_rank::giveRankXP("", 100);
/* [AUTO DELETE] user iprintlnbold("^2Activated"); */
level.cranetrap = 1;
level.cranetime = 2;
level.craneftime = 0;
level.cranewtime = 0;
}


trap2( user )
{
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
user braxi\_rank::giveRankXP("", 100);
/* [AUTO DELETE] user iprintlnbold("^2Activated"); */
thread trap2ng();
wait 0.2;
thread trap2x1();
thread trap2ngd();
wait 1;
thread trap2x2();
thread trap2ngd2();
thread trap2dmg1();
wait 15;
thread deltrap2e1();
}


trap2dmg1()
{
level.dmg1 triggerOn();
wait .5;
level.dmg1 triggerOff();
wait .5;
level.dmg1 triggerOn();
wait .5;
level.dmg1 triggerOff();
wait .5;
level.dmg1 delete();
}


deltrap2e1()
{
t2rh1 = getEnt("trap2_hurt_1","targetname");
t2rh2 = getEnt("trap2_hurt_2","targetname");
t2rh3 = getEnt("trap2_hurt_3","targetname");
t2rh4 = getEnt("trap2_hurt_4","targetname");
t2rh5 = getEnt("trap2_hurt_5","targetname");
t2rh6 = getEnt("trap2_hurt_6","targetname");
t2rh7 = getEnt("trap2_hurt_7","targetname");
t2rh8 = getEnt("trap2_hurt_8","targetname");
t2rh9 = getEnt("trap2_hurt_9","targetname");
wait 0.2;
t2rh1 delete();
t2rh2 delete();
t2rh3 delete();
t2rh4 delete();
t2rh5 delete();
t2rh6 delete();
t2rh7 delete();
t2rh8 delete();
t2rh9 delete();
}


trap2ngd()
{
t2rh1 = getEnt("trap2_hurt_1","targetname");
t2rh2 = getEnt("trap2_hurt_2","targetname");
t2rh3 = getEnt("trap2_hurt_3","targetname");
t2rh5 = getEnt("trap2_hurt_5","targetname");
t2rh6 = getEnt("trap2_hurt_6","targetname");
t2rh8 = getEnt("trap2_hurt_8","targetname");
t2rh9 = getEnt("trap2_hurt_9","targetname");
time = randomIntRange( 0.6, 1.8 );

t2rh1 trap2ng2();
wait time;
t2rh2 trap2ng2();
wait time;
t2rh3 trap2ng2();
wait time;
t2rh5 trap2ng2();
wait time;
t2rh6 trap2ng2();
wait time;
t2rh8 trap2ng2();
wait time;
t2rh9 trap2ng2();
}


trap2ng2()
{
self triggerOn();
wait 0.6;
self triggerOff();
}


trap2ngd2()
{
t2rh4 = getEnt("trap2_hurt_4","targetname");
t2rh7 = getEnt("trap2_hurt_7","targetname");

t2rh4 trap2ng2();
wait 1;
t2rh7 trap2ng2();
}


trap2ng()
{
t2r = getEntArray("trap2random","targetname");
time = RandomIntRange( 0.1 , 0.3 );

	for( i = 0; i < t2r.size; i++ )
	{
		PhysicsJitter( t2r[i].origin, 200, 150, 1.0, 5.0 );
		wait time;
		PhysicsExplosionSphere( t2r[i].origin, 200, 160, 2 );
		t2r[i] playSound("mortar_impact_water_layer");
		playFx ( level._effect[ "watersplash" ], t2r[i].origin );
		wait time;
		PhysicsExplosionSphere( t2r[i].origin, 200, 160, 2 );
		wait time;
		PhysicsJolt( t2r[i].origin, 200, 150, (0.01, 0.01, 0.2) );
		wait time;
		PhysicsExplosionSphere( t2r[i].origin, 200, 160, 2 );
		wait time;
		PhysicsJitter( t2r[i].origin, 200, 150, 1.0, 5.0 );
		wait time;
		PhysicsExplosionSphere( t2r[i].origin, 200, 160, 2 );
		wait 0.2;
	}
}


trap2x2()
{
part2 = getEntArray("trap2b","targetname");

	for( i = 0; i < part2.size; i++ )
	{
		PhysicsExplosionSphere( part2[i].origin, 200, 160, 2 );
		part2[1] playSound("mortar_impact_water_layer");
		playFx ( level._effect[ "watersplash" ], part2[1].origin );
		PhysicsExplosionSphere( part2[i].origin, 200, 160, 2 );
		PhysicsExplosionSphere( part2[i].origin, 200, 160, 2 );
		PhysicsJolt( part2[i].origin, 200, 150, (0.01, 0.01, 0.2) );
		//PhysicsExplosionSphere( part2[i].origin, 200, 160, 2 );
		wait 0.2;
	}
}


trap2x1()
{
part1 = getEntArray("trap2a","targetname");

	for( i = 0; i < part1.size; i++ )
	{
		PhysicsExplosionSphere( part1[i].origin, 200, 160, 2 );
		part1[1] playSound("mortar_impact_water_layer");
		playFx ( level._effect[ "watersplash" ], part1[1].origin );
		PhysicsExplosionSphere( part1[i].origin, 200, 160, 2 );
		PhysicsExplosionSphere( part1[i].origin, 200, 160, 2 );
		PhysicsJolt( part1[i].origin, 200, 150, (0.01, 0.01, 0.2) );
		//PhysicsExplosionSphere( part1[i].origin, 200, 160, 2 );
		wait 0.2;
	}
}


trap4( user )
{
trap4w = getEnt("trap4trigwind","targetname");
trap4s = getEnt("trap4sfx","targetname");

if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
user braxi\_rank::giveRankXP("", 100);
/* [AUTO DELETE] user iprintlnbold("^2Activated"); */
level endon("trap4fin");
thread playertrig(trap4w);
	while(1)
	{
		wait 2;
		trap4w triggerOn();
		level.trap4wind = 1;
		thread trapcountdown(10,level.trap4wind,0,trap4w,8);
		wait .05;
		trap4s playsound("trapfan");
		thread trap4fx();
		wait 14;
	}
}


playertrig(trigger)
{
	for(;;)
	{
	    trigger waittill("trigger", player);
		player thread windpush( player, trigger );
		wait 0.05;
	}
}


windpush( player, trap )
{
	if(isDefined(player) && player isTouching(trap))
	{
		while(isDefined(player) && player isTouching(trap))
		{
			if( level.trap4wind == 1 )
			{
			player.health += 1000;
			player FinishPlayerDamage( player, player, 1000, 0, "MOD_PROJECTILE", "bh_mp", player.origin, AnglesToForward((0, 360, 0) + (0, 180, 0)), "none", 0 );
			}
			if( level.trap4wind == 0 )
				break;
		wait .2;
		}
	wait .05;
	}
}


trapcountdown(time,what,state,trig,ng)
{
	if(isDefined(time))
	{
		wait time;
		what = state;
		trig triggerOff();
		wait ng;
	}
}


trap4fx()
{
trap4f = getEntArray("trap4fxwind","targetname");

	for(i = 0;i < trap4f.size; i++)
	{
	playFX( level._effect[ "fansmoke" ], trap4f[i].origin);
	wait 0.2;
		if( level.trap4wind == 0 )
			break;
	}
}


trap5( user )
{
dynentp_t4_b = getEnt("dynentp_brush_trap4","targetname");
dp4 = getEnt("dynent_protect_4","targetname");

if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
user braxi\_rank::giveRankXP("", 100);
/* [AUTO DELETE] user iprintlnbold("^2Activated"); */

dp4 delete();
thread dp1();
thread ladderaccess();
thread laserset();
thread trap5fxp();
thread c4door3();
wait 1;
thread trap5fxp();
level.trap5water = 1;
thread trap5phy();
thread trap5wmove();
thread trap5ang();
wait 3;
level.trap5wacti = 1;
wait 15;
thread trap5del2();
thread trap5del3();
}


trap5del2()
{
tdel2 = getEntArray("fx_waterd1","targetname");

	for(i = 0; i < tdel2.size; i++)
	{
		tdel2[i] delete();
	}
}


trap5del3()
{
tdel3 = getEntArray("waterxp_phy","targetname");

	for(i = 0; i < tdel3.size; i++)
	{
		tdel3[i] delete();
	}
}


laserset()
{
	thread laser1();
	thread laser2();
	thread laser3();
}


laser1()
{
l1 = getEnt("trap5laser_ud_1","targetname");
l2 = getEnt("trap5laser_ud_2","targetname");
l3 = getEnt("trap5laser_ud_3","targetname");
l1h = getEnt("trap5laser_ud_1_h","targetname");
l2h = getEnt("trap5laser_ud_2_h","targetname");
l3h = getEnt("trap5laser_ud_3_h","targetname");

l1h enableLinkTo();
l2h enableLinkTo();
l3h enableLinkTo();
l1h linkTo(l1);
l2h linkTo(l2);
l3h linkTo(l3);
l2 moveZ(-40, 0.2);
wait 1;

	while(1)
	{
		l1 moveZ(-40, 2);
		l2 moveZ(40, 2);
		l3 moveZ(-40, 2);
		l3 waittill("movedone");
		l1 moveZ(40, 2);
		l2 moveZ(-40, 2);
		l3 moveZ(40, 2);
		l3 waittill("movedone");
	}
}


laser2()
{
l4 = getEnt("trap5laser_lf_1","targetname");
l5 = getEnt("trap5laser_lf_2","targetname");
l6 = getEnt("trap5laser_lf_3","targetname");
l7 = getEnt("trap5laser_lf_4","targetname");
l4h = getEnt("trap5laser_lf_1_h","targetname");
l5h = getEnt("trap5laser_lf_2_h","targetname");
l6h = getEnt("trap5laser_lf_3_h","targetname");
l7h = getEnt("trap5laser_lf_4_h","targetname");

l4h enableLinkTo();
l5h enableLinkTo();
l6h enableLinkTo();
l7h enableLinkTo();
l4h linkTo(l4);
l5h linkTo(l5);
l6h linkTo(l6);
l7h linkTo(l7);

	while(1)
	{
		l4 moveX(-50, 2);
		l5 moveX(-50, 2);
		l6 moveX(-50, 2);
		l7 moveX(-50, 2);
		l7 waittill("movedone");
		l4 moveX(50, 2);
		l5 moveX(50, 2);
		l6 moveX(50, 2);
		l7 moveX(50, 2);
		l7 waittill("movedone");
	}
}


laser3()
{
l8 = getEnt("trap5laser_la_1","targetname");
l9 = getEnt("trap5laser_la_2","targetname");
l8h = getEnt("trap5laser_la_1_h","targetname");
l9h = getEnt("trap5laser_la_2_h","targetname");

l8h enableLinkTo();
l9h enableLinkTo();
l8h linkTo(l8);
l9h linkTo(l9);

	while(1)
	{
		l8 moveZ(-150, 1);
		l9 moveX(-150, 1);
		l9 waittill("movedone");
		l8 moveZ(150, 1);
		l9 moveX(150, 1);
		l9 waittill("movedone");
	}
}


ladderaccess()
{
lad5 = getEnt("ladder_trap5","targetname");
lad5m = getEnt("ladder_model_trap5","targetname");
ladng = getEnt("trap5_trapon","targetname");

lad5 enableLinkTo();
lad5 linkto(lad5m);
ladng delete();

wait 3;
lad5m playSound("laddex");
lad5m moveZ(-140, 4, 0.6, 0.1);
wait 4;
}


dp1()
{
dp1_s = getEnt("dynent_protect_1","targetname");

	while(1)
	{
		if(level.trap5wacti == 1)
			dp1_s delete();
	wait .2;
	}

}


trap5ang()
{
rng = getEnt("trap5ng","targetname");
d1trig = getEnt("c4door1_trig","targetname");
d1ori = getEnt("c4door1_ori","targetname");

	{
	d1ori PlaySound("grenade_explode_metal");
	playFx(level._effect["c4"],d1ori.origin);
	PhysicsExplosionSphere( d1ori.origin, 200, 160, 2 );
	wait 0.2;
	PhysicsExplosionSphere( d1ori.origin, 200, 160, 2 );
	d1ori delete();
	d1trig delete();
	wait 0.3;
	rng moveZ(300, 1.2, 0, 0.4);
	}
}


trap5wmove()
{
trap5wat = getEnt("trap5water","targetname");
trap5hud = getEnt("trap5hud","targetname");
trap5hurt = getEnt("trap5hurt","targetname");
trap5wat2 = getEnt("trap5water2","targetname");
wait 0.2;

trap5hurt enablelinkto();
trap5hud enablelinkto();
trap5hurt linkto(trap5wat);
trap5hud linkto(trap5wat);

trap5hud thread water_hud2(trap5hud);

trap5wat playLoopSound("waterfall");
wait 0.5;
trap5wat moveZ(450, 13, 4, 4);
trap5wat2 moveZ(450, 13, 4, 4);
wait 8;
trap5wat2 delete();
}


fxw1()
{
fxw1 = getEntArray("fx_waterd1","targetname");
wait 3;

	for(i = 0;i < fxw1.size; i++)
	{
	fxw1[i] thread fxw1ng();
	wait 0.2;
		
		if(level.trap5water == 1)
			break;
	}
}


fxw1ng()
{
self playLoopSound("waterfall_small");

	while(1)
	{
	wait 1.4;
	playFX(level._effect[ "waterfall" ], self.origin);
	
		if(level.trap5water == 1)
			break;
	}
}


fxw3ng()
{
self playLoopSound("waterfall_small");

	while(1)
	{
	wait 1.4;
	playFX(level._effect[ "waterfall_s" ], self.origin);
	}
}


fxw2ng()
{
	wait 1;
	self stopLoopSound("waterfall_small");
	self playLoopSound("waterfall");
	playFX(level._effect[ "waterexp" ], self.origin);
	wait 1;
	playFX(level._effect[ "waterexp" ], self.origin);
	wait 1;
	playFX(level._effect[ "waterexp" ], self.origin);
		while(1)
		{
			if(level.trap5wacti == 1)
			{
				self stopLoopSound("waterfall");
				wait 1;
				break;
			}
		wait .2;
		}
}


trap5fxp()
{
fxp1 = getEntArray("fx_waterxp","targetname");

	for(i = 0;i < fxp1.size; i++)
	{
	playFX(level._effect[ "waterexp" ], fxp1[i].origin);
	fxp1[i] playLoopSound("waterfall");
		if(level.trap5wacti == 1)
		{
			fxp1[i] stopLoopSound("waterfall");
		}
	wait 0.2;
	}
}


trap5ng()
{
	level endon("trigger");
	level.trap5ng waittill("trigger");
	level.trap5n = 1;
	level.trap5ng delete();
}


trap5phy()
{
phyw = getEntArray("waterxp_phy","targetname");
wait 0.2;

	for(i = 0;i < phyw.size; i++)
	{
	PhysicsExplosionSphere( phyw[i].origin, 200, 160, 2 );
	phyw[3] playSound("brick");
	wait 0.2;
		if(level.trap5wacti == 1)
			break;
	}
}


trap6( user )
{
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
user braxi\_rank::giveRankXP("", 100);
/* [AUTO DELETE] user iprintlnbold("^2Activated"); */
if(level.night == 1 && level.trap5water == 1 && level.trap4wind != 1)
		level.ngpos = (-562, 20096, -2648);
thread pushh();
thread pushhurt();

}


fxw3()
{
fxw3 = getEntArray("fx_waterd_s","targetname");
wait 3;

	for(i = 0;i < fxw3.size; i++)
	{
	fxw3[i] thread fxw3ng();
	wait 0.2;
	}
}


pushhurt()
{
pusher1 = getEntArray("m_trap6_spike_array_1","targetname");
pusher2 = getEntArray("m_trap6_spike_array_2","targetname");
pusher3 = getEntArray("m_trap6_spike_array_3","targetname");
pusher4 = getEntArray("m_trap6_spike_array_4","targetname");
pusher5 = getEntArray("m_trap6_spike_array_5","targetname");
hurt1 = getEnt("m_trap6_spike_hurt_1","targetname");
hurt2 = getEnt("m_trap6_spike_hurt_2","targetname");
hurt3 = getEnt("m_trap6_spike_hurt_3","targetname");
hurt4 = getEnt("m_trap6_spike_hurt_4","targetname");
hurt5 = getEnt("m_trap6_spike_hurt_5","targetname");
hurt1 enableLinkTo();
hurt2 enableLinkTo();
hurt3 enableLinkTo();
hurt4 enableLinkTo();
hurt5 enableLinkTo();

wait 0.2;

for(i = 0; i < pusher1.size; i++)
hurt1 linkto(pusher1[i]);

for(i = 0; i < pusher2.size; i++)
hurt2 linkto(pusher2[i]);

for(i = 0; i < pusher3.size; i++)
hurt3 linkto(pusher3[i]);

for(i = 0; i < pusher4.size; i++)
hurt4 linkto(pusher4[i]);

for(i = 0; i < pusher5.size; i++)
hurt5 linkto(pusher5[i]);

}


pushh()
{
pusher1 = getEntArray("m_trap6_spike_array_1","targetname");
pusher2 = getEntArray("m_trap6_spike_array_2","targetname");
pusher3 = getEntArray("m_trap6_spike_array_3","targetname");
pusher4 = getEntArray("m_trap6_spike_array_4","targetname");
pusher5 = getEntArray("m_trap6_spike_array_5","targetname");

wait .05;
	
	while(1)
	{
	random = randomint(5);

		switch(random)
		{
			case 0:
					wait 0.5;
					pusher1[randomInt(pusher1.size)] moveZ(60, 0.5, 0.2, 0.2);
					pusher2[randomInt(pusher2.size)] moveZ(60, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher1[randomInt(pusher1.size)] moveZ(-60, 0.5, 0.2, 0.2);
					pusher2[randomInt(pusher2.size)] moveZ(-60, 0.5, 0.2, 0.2);
					break;
					
			case 1:
					wait 0.5;
					pusher2[randomInt(pusher2.size)] moveZ(60, 0.5, 0.2, 0.2);
					pusher4[randomInt(pusher4.size)] moveZ(60, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher2[randomInt(pusher2.size)] moveZ(-60, 0.5, 0.2, 0.2);
					pusher4[randomInt(pusher4.size)] moveZ(-60, 0.5, 0.2, 0.2);
					break;				
	
			case 2:
					wait 0.5;
					pusher3[randomInt(pusher3.size)] moveZ(60, 0.5, 0.2, 0.2);
					pusher1[randomInt(pusher1.size)] moveZ(60, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher3[randomInt(pusher3.size)] moveZ(-60, 0.5, 0.2, 0.2);
					pusher1[randomInt(pusher1.size)] moveZ(-60, 0.5, 0.2, 0.2);
					break;
					
			case 3:
					wait 0.5;
					pusher4[randomInt(pusher4.size)] moveZ(60, 0.5, 0.2, 0.2);
					pusher5[randomInt(pusher5.size)] moveZ(60, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher4[randomInt(pusher4.size)] moveZ(-60, 0.5, 0.2, 0.2);
					pusher5[randomInt(pusher5.size)] moveZ(-60, 0.5, 0.2, 0.2);
					break;
					
			case 4:
					wait 0.5;
					pusher5[randomInt(pusher5.size)] moveZ(60, 0.5, 0.2, 0.2);
					pusher3[randomInt(pusher3.size)] moveZ(60, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher5[randomInt(pusher5.size)] moveZ(-60, 0.5, 0.2, 0.2);
					pusher3[randomInt(pusher3.size)] moveZ(-60, 0.5, 0.2, 0.2);
					break;
		}
	wait 0.2;
	}
}


trap7( user )
{
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{

}
else
user braxi\_rank::giveRankXP("", 100);
/* [AUTO DELETE] user iprintlnbold("^2Activated"); */
if(level.cranetime == 2 && level.craneftime == 0 && level.trap5water == 1)
		level.ngpos = (-562, 19932, -2648);
thread rwallrun();
thread rwallmove();
}


rwallrun()
{
blockw = getEnt("trap6mwall","targetname");

blockw moveX(-80,1,0.2,0.2);
wait .2;
}


rwallmove()
{
wr1 = getEnt("wallruntest1","targetname");
wr2 = getEnt("wallruntest2","targetname");

wr1 delete();
wait 1;

	while(1)
	{
	wr2 moveY(560,1.8,0.14,0.14);
	wr2 waittill("movedone");
	wait 0.4;
	wr2 moveY(-560,1.8,0.14,0.14);
	wr2 waittill("movedone");
	wait 0.4;
	}
}


ngl()
{
	ng = getEnt("trap7ng","targetname");
	ng triggerOff();
	while(1)
	{
		if(level.trap5n == 1)
		{
			ng triggerOn();
			thread ng2(ng);
			break;
		}
	wait 4;
	}
}


ng2(ng)
{
	wait 2;
	ng.origin = level.ngpos;
	thread ngfinal(ng);
}


ngfinal(ng)
{
	t7o = getEnt("trap7o","targetname");
	ng waittill("trigger",user);
	user setOrigin(t7o.origin);
	user setPlayerAngles(t7o.angles);
	wait 5;
	tp = spawn("script_origin", (-96, -8, -40));
	tp.angles = (0,90,0);
	user setOrigin(tp.origin);
	user setPlayerAngles(tp.angles);
	tp delete();
}


checkactiprogress( chopper )
{
level.air1 = spawn("script_origin", chopper GetTagOrigin( "tag_guy4" ));
level.trig1 = spawn("trigger_radius", level.air1.origin, 1000, 1000, 1000 );
level.trig1 enableLinkTo();
wait .1;
level.trig1 linkTo(level.air1);
level.air1 linkTo( chopper );
wait .1;

	for(;;)
	{
	if(self istouching(level.trig1) && self useButtonPressed())
	{
		if(self.pers["team"] != "allies" && !isDefined (level.use1) && level.pick == 0)
			self thread trap1menu();
		if(isDefined (level.use1))
			level notify( "move1" ); //ng
	}
	wait 0.2;
	}
	//level endon ( "acti_picked" );
	//level waittill( "acti_picked" );
}


trap1menu()
{
	level endon("trigger");
level endon( "move1" );
/* [AUTO DELETE] self openMenu("actimenu"); */
self waittill("menuresponse", menu, response);
	wait 0.05;
	while( 1 )
	{
	if(!isDefined (level.use1))
	{
		level.use1 = true;
		if( response == "acti" )
		{
			thread trap1( self );
			level notify( "move1" );
			level.trig1 unlink();
			level.air1 unlink();
			level.air1 delete();
			level.trig1 delete();
			wait 0.5;
			level.trig1used=true;
			break;
		}
		if( response == "move" )
		{
			level notify( "move1" );
			level.trig1 unlink();
			level.air1 unlink();
			level.air1 delete();
			level.trig1 delete();
			wait 0.5;
			level.trig1used=true;
			break;
		}
	}
	wait .1;
	}
}


checkactiprogress2( chopper )
{
level.air2 = spawn("script_origin", chopper GetTagOrigin( "tag_guy4" ));
level.trig2 = spawn("trigger_radius", level.air2.origin, 1000, 1000, 1000 );
level.trig2 enableLinkTo();
wait .1;
level.trig2 linkTo(level.air2);
level.air2 linkTo( chopper );
wait .1;

	for(;;)
	{
	if(self istouching(level.trig2) && self useButtonPressed())
	{
		if(self.pers["team"] != "allies" && !isDefined (level.use2) && level.pick == 0)
			self thread trap2menu();
		if(isDefined (level.use2))
			level notify( "move2" ); //ng
	}
	wait 0.2;
	}
	//level endon ( "acti_picked" );
	//level waittill( "acti_picked" );
}


trap2menu()
{
	level endon("trigger");
level endon( "move2" );
/* [AUTO DELETE] self openMenu("actimenu"); */
self waittill("menuresponse", menu, response);
	wait 0.05;
	while( 1 )
	{
	if(!isDefined (level.use2))
	{
		level.use2 = true;
		if( response == "acti" )
		{
			thread trap15( self );
			level notify( "move2" );
			level.trig2 unlink();
			level.air2 unlink();
			level.air2 delete();
			level.trig2 delete();
			wait 0.5;
			level.trig2used=true;
			break;
		}
		if( response == "move" )
		{
			level notify( "move2" );
			level.trig2 unlink();
			level.air2 unlink();
			level.air2 delete();
			level.trig2 delete();
			wait 0.5;
			level.trig2used=true;
			break;
		}
	}
	wait .1;
	}
}


checkactiprogress3( chopper )
{
level.air3 = spawn("script_origin", chopper GetTagOrigin( "tag_guy4" ));
level.trig3 = spawn("trigger_radius", level.air3.origin, 1000, 1000, 1000 );
level.trig3 enableLinkTo();
wait .1;
level.trig3 linkTo(level.air3);
level.air3 linkTo( chopper );
wait .1;

	for(;;)
	{
	if(self istouching(level.trig3) && self useButtonPressed())
	{
		if(self.pers["team"] != "allies" && !isDefined (level.use3) && level.pick == 0)
			self thread trap3menu();
		if(isDefined (level.use3))
			level notify( "move3" ); //ng
	}
	wait 0.2;
	}
	//level endon ( "acti_picked" );
	//level waittill( "acti_picked" );
}


trap3menu()
{
	level endon("trigger");
level endon( "move3" );
/* [AUTO DELETE] self openMenu("actimenu"); */
self waittill("menuresponse", menu, response);
	wait 0.05;
	while( 1 )
	{
	if(!isDefined (level.use3))
	{
		level.use3 = true;
		if( response == "acti" )
		{
			thread trap2( self );
			level notify( "move3" );
			level.trig3 unlink();
			level.air3 unlink();
			level.air3 delete();
			level.trig3 delete();
			wait 0.5;
			level.trig3used=true;
			break;
		}
		if( response == "move" )
		{
			level notify( "move3" );
			level.trig3 unlink();
			level.air3 unlink();
			level.air3 delete();
			level.trig3 delete();
			wait 0.5;
			level.trig3used=true;
			break;
		}
	}
	wait .1;
	}
}


checkactiprogress4( chopper )
{
level.air4 = spawn("script_origin", chopper GetTagOrigin( "tag_guy4" ));
level.trig4 = spawn("trigger_radius", level.air4.origin, 1000, 1000, 1000 );
level.trig4 enableLinkTo();
wait .1;
level.trig4 linkTo(level.air4);
level.air4 linkTo( chopper );
wait .1;

	for(;;)
	{
	if(self istouching(level.trig4) && self useButtonPressed())
	{
		if(self.pers["team"] != "allies" && !isDefined (level.use4) && level.pick == 0)
			self thread trap4menu();
		if(isDefined (level.use4))
			level notify( "move4" ); //ng
	}
	wait 0.2;
	}
	//level endon ( "acti_picked" );
	//level waittill( "acti_picked" );
}


trap4menu()
{
	level endon("trigger");
level endon( "move4" );
/* [AUTO DELETE] self openMenu("actimenu"); */
self waittill("menuresponse", menu, response);
	wait 0.05;
	while( 1 )
	{
	if(!isDefined (level.use4))
	{
		level.use4 = true;
		if( response == "acti" )
		{
			thread trap4( self );
			level notify( "move4" );
			level.trig4 unlink();
			level.air4 unlink();
			level.air4 delete();
			level.trig4 delete();
			wait 0.5;
			level.trig4used=true;
			break;
		}
		if( response == "move" )
		{
			level notify( "move4" );
			level.trig4 unlink();
			level.air4 unlink();
			level.air4 delete();
			level.trig4 delete();
			wait 0.5;
			level.trig4used=true;
			break;
		}
	}
	wait .1;
	}
}


checkactiprogress5( chopper )
{
level.air5 = spawn("script_origin", chopper GetTagOrigin( "tag_guy4" ));
level.trig5 = spawn("trigger_radius", level.air5.origin, 1000, 1000, 1000 );
level.trig5 enableLinkTo();
wait .1;
level.trig5 linkTo(level.air5);
level.air5 linkTo( chopper );
wait .1;

	for(;;)
	{
	if(self istouching(level.trig5) && self useButtonPressed())
	{
		if(self.pers["team"] != "allies" && !isDefined (level.use5) && level.pick == 0)
			self thread trap5menu();
		if(isDefined (level.use5))
			level notify( "move5" ); //ng
	}
	wait 0.2;
	}
	//level endon ( "acti_picked" );
	//level waittill( "acti_picked" );
}


trap5menu()
{
	level endon("trigger");
level endon( "move5" );
/* [AUTO DELETE] self openMenu("actimenu"); */
self waittill("menuresponse", menu, response);
	wait 0.05;
	while( 1 )
	{
	if(!isDefined (level.use5))
	{
		level.use5 = true;
		if( response == "acti" )
		{
			thread trap5( self );
			level notify( "move5" );
			level.trig5 unlink();
			level.air5 unlink();
			level.air5 delete();
			level.trig5 delete();
			wait 0.5;
			level.trig5used=true;
			break;
		}
		if( response == "move" )
		{
			level notify( "move5" );
			level.trig5 unlink();
			level.air5 unlink();
			level.air5 delete();
			level.trig5 delete();
			wait 0.5;
			level.trig5used=true;
			break;
		}
	}
	wait .1;
	}
}


checkactiprogress6( chopper )
{
level.air6 = spawn("script_origin", chopper GetTagOrigin( "tag_guy4" ));
level.trig6 = spawn("trigger_radius", level.air6.origin, 1000, 1000, 1000 );
level.trig6 enableLinkTo();
wait .1;
level.trig6 linkTo(level.air6);
level.air6 linkTo( chopper );
wait .1;

	for(;;)
	{
	if(self istouching(level.trig6) && self useButtonPressed())
	{
		if(self.pers["team"] != "allies" && !isDefined (level.use6) && level.pick == 0)
			self thread trap6menu();
		if(isDefined (level.use6))
			level notify( "move6" ); //ng
	}
	wait 0.2;
	}
	//level endon ( "acti_picked" );
	//level waittill( "acti_picked" );
}


trap6menu()
{
	level endon("trigger");
level endon( "move6" );
/* [AUTO DELETE] self openMenu("actimenu"); */
self waittill("menuresponse", menu, response);
	wait 0.05;
	while( 1 )
	{
	if(!isDefined (level.use6))
	{
		level.use6 = true;
		if( response == "acti" )
		{
			thread trap6( self );
			level notify( "move6" );
			level.trig6 unlink();
			level.air6 unlink();
			level.air6 delete();
			level.trig6 delete();
			wait 0.5;
			level.trig6used=true;
			break;
		}
		if( response == "move" )
		{
			level notify( "move6" );
			level.trig6 unlink();
			level.air6 unlink();
			level.air6 delete();
			level.trig6 delete();
			wait 0.5;
			level.trig6used=true;
			break;
		}
	}
	wait .1;
	}
}


checkactiprogress7( chopper )
{
level.air7 = spawn("script_origin", chopper GetTagOrigin( "tag_guy4" ));
level.trig7 = spawn("trigger_radius", level.air7.origin, 1000, 1000, 1000 );
level.trig7 enableLinkTo();
wait .1;
level.trig7 linkTo(level.air7);
level.air7 linkTo( chopper );
wait .1;

	for(;;)
	{
	if(self istouching(level.trig7) && self useButtonPressed())
	{
		if(self.pers["team"] != "allies" && !isDefined (level.use7) && level.pick == 0)
			self thread trap7menu();
		if(isDefined (level.use7))
			level notify( "move7" ); //ng
	}
	wait 0.2;
	}
	//level endon ( "acti_picked" );
	//level waittill( "acti_picked" );
}


trap7menu()
{
	level endon("trigger");
level endon( "move7" );
/* [AUTO DELETE] self openMenu("actimenu"); */
self waittill("menuresponse", menu, response);
	wait 0.05;
	while( 1 )
	{
	if(!isDefined (level.use7))
	{
		level.use7 = true;
		if( response == "acti" )
		{
			thread trap7( self );
			level notify( "move7" );
			level.trig7 unlink();
			level.air7 unlink();
			level.air7 delete();
			level.trig7 delete();
			wait 0.5;
			level.trig7used=true;
			break;
		}
		if( response == "move" )
		{
			level notify( "move7" );
			level.trig7 unlink();
			level.air7 unlink();
			level.air7 delete();
			level.trig7 delete();
			wait 0.5;
			level.trig7used=true;
			break;
		}
	}
	wait .1;
	}
}


WatchHelicopterTrigger()
{
	helimodel=getent("heli_model","targetname");
	while(1)
	{
		wait 1;
		if( isDefined (level.activ) )
		{
		level.activ thread StartHelicopter();
		level.activ.chopperlink=true;
		level.activ thread godmode();
		/* [AUTO DELETE] iPrintlnBold( "^1" + level.activ.name + " ^7has entered the ^1heli ^7:]" ); */
		level.activ thread braxi\_common::clientCmd( "gocrouch" );
		helimodel delete();
		break;
		}
	wait 1;
	}
}


godmode()
{
self endon ( "disconnect" );
self endon ( "death" );
self.maxhealth = 900000;
self.health = self.maxhealth;
if(!isdefined(self.chopperlink))
	self.chopperlink=true;
	
	while(self.chopperlink)
	{
	wait .4;
	if ( self.health < self.maxhealth )
	self.health = self.maxhealth;
	}
	
if(self.chopperlink==false)
	self.health = 100;
}


pickng()
{
	while(1)
	{
		if(level.pick == 1)
			self thread pickng2();
		wait 1;
	}
}


pickng2()
{
		if(isDefined(level.air1) && isDefined(level.trig1))
		{
			level.air1 unlink();
			level.trig1 unlink();
			level.air1 delete();
			level.trig1 delete();
		}
		if(isDefined(level.air2) && isDefined(level.trig2))
		{
			level.air2 unlink();
			level.trig2 unlink();
			level.air2 delete();
			level.trig2 delete();
		}
		if(isDefined(level.air3) && isDefined(level.trig3))
		{
			level.air3 unlink();
			level.trig3 unlink();
			level.air3 delete();
			level.trig3 delete();
		}
		if(isDefined(level.air4) && isDefined(level.trig4))
		{
			level.air4 unlink();
			level.trig4 unlink();
			level.air4 delete();
			level.trig4 delete();
		}
		if(isDefined(level.air5) && isDefined(level.trig5))
		{
			level.air5 unlink();
			level.trig5 unlink();
			level.air5 delete();
			level.trig5 delete();
		}
		if(isDefined(level.air6) && isDefined(level.trig6))
		{
			level.air6 unlink();
			level.trig6 unlink();
			level.air6 delete();
			level.trig6 delete();
		}
		if(isDefined(level.air7) && isDefined(level.trig7))
		{
			level.air7 unlink();
			level.trig7 unlink();
			level.air7 delete();
			level.trig7 delete();
		}
}


StartHelicopter()
{
	if(level.pick == 1)
		return;
	
	heliclipfull = getEnt("heli_fly_fullclip","targetname");
	
	self endon( "disconnect" );
	self endon( "death" );
		
	if( !isDefined( self ) || !isAlive( self ) || !isPlayer( self ) )
		return;
	
	path = [];
	orig = getEntArray();
	if( self.pers["team"] == "allies" )
	{
		start = getEnt( "orig_heli_jumper_spawn", "targetname" );
		for(i=0;i<orig.size;i++)
		{
			if( isDefined( orig[i].targetname ) && IsSubStr( orig[i].targetname, "orig_heli_jumper"+path.size ) )
			{
				path[path.size] = orig[i];
				path[path.size-1].waittime = int( strTok( orig[i].targetname, "_" )[3] );
			}
		}
	}
	else
	{
		start = getEnt( "orig_heli_acti_spawn", "targetname" );
		for(i=0;i<orig.size;i++)
		{
			if( isDefined( orig[i].targetname ) && IsSubStr( orig[i].targetname, "orig_heli_acti"+path.size ) )
			{
				path[path.size] = orig[i];
				path[path.size-1].waittime = int( strTok( orig[i].targetname, "_" )[3] );
			}
		}
	}
	chopper = spawn_helicopter( self, start.origin, start.angles, "cobra_mp", "vehicle_blackhawk" );
	/* [AUTO DELETE] wait 0.05; */
	chopper.owner = self;
	chopper playLoopSound( "mp_cobra_helicopter" );
	chopper.linker = Spawn( "script_model", chopper GetTagOrigin( "tag_guy4" )-(0,0,20));
	chopper.linker LinkTo( chopper );
	heliclipfull LinkTo( chopper );
	chopper setDamageStage( 3 );
	chopper setCanDamage( 1 );
	chopper.maxhealth = 5000;
	chopper.health = chopper.maxhealth;
	chopper setSpeed( 40, 15 );
	chopper setYawSpeed( 50, 20, 20 );
	chopper SetMaxPitchRoll( 30, 30 );
	chopper setNearGoalNotifyDist( 96 );
	//chopper thread DamageMonitor();
	chopper endon( "crashed" );
	
	pathnum = 0;
	
	self setOrigin( chopper.linker.origin );
	self LinkTo( chopper.linker );
	/* [AUTO DELETE] self TakeAllWeapons(); */
	self thread pickng();
		
		//trap1
		chopper setVehGoalPos( (1904, 3168 ,-32), true );
		chopper waittill("goal");
		if(isDefined(level.trapsdisabled))
		{
			if(level.trig1used==false && level.trapsdisabled==false && level.pick == 0)
			{
				level.hint1 triggerOn();
				thread checkactiprogress( self );
				level waittill("move1");
			}
		}
		
		if(level.pick == 1)
			return;
		
		//trap15
		level.hint1 delete();
		/* [AUTO DELETE] wait 2; */
		chopper setYawSpeed( 50, 20, 20 );
		chopper setVehGoalPos( (1560, 3552, -304), false );
		chopper waittill("goal");
		chopper setVehGoalPos( (808, 5264, -1040), false );
		chopper waittill("goal");
		chopper setYawSpeed( 240, 60, 60 );
		chopper setVehGoalPos( (1440, 10656, -2136), false );
		chopper waittill("goal");
		chopper setVehGoalPos( (1416, 10656, -2136), true );
		chopper waittill("goal");
		chopper setYawSpeed( 50, 20, 20 );
		if(isDefined(level.trapsdisabled))
		{
			if(level.trig2used==false && level.trapsdisabled==false && level.pick == 0)
			{
				level.hint2 triggerOn();
				thread checkactiprogress2( self );
				level waittill("move2");
			}
		}
		
		if(level.pick == 1)
			return;
		
		//trap2
		level.hint2 delete();
		/* [AUTO DELETE] wait 2; */
		chopper setVehGoalPos( (48,10536,-1376), true );
		chopper waittill("goal");
		if(isDefined(level.trapsdisabled))
		{
			if(level.trig3used==false && level.trapsdisabled==false && level.pick == 0)
			{
				level.hint3 triggerOn();
				thread checkactiprogress3( self );
				level waittill("move3");
			}
		}
		
		if(level.pick == 1)
			return;
		
		//trap4
		level.hint3 delete();
		/* [AUTO DELETE] wait 2; */
		chopper setVehGoalPos( (-1928, 11032, -1040), true );
		chopper waittill("goal");
		if(isDefined(level.trapsdisabled))
		{
			if(level.trig4used==false && level.trapsdisabled==false && level.pick == 0)
			{
				level.hint4 triggerOn();
				thread checkactiprogress4( self );
				level waittill("move4");
			}
		}
		
		if(level.pick == 1)
			return;
		
		//trap5
		level.hint4 delete();
		/* [AUTO DELETE] wait 2; */
		chopper setVehGoalPos( (848, 14440, -216), false );
		chopper waittill("goal");
		chopper setSpeed( 20, 7 );
		chopper setVehGoalPos( (1312, 16344, -1856), true );
		chopper waittill("goal");
		chopper setSpeed( 40, 15 );
		if(isDefined(level.trapsdisabled))
		{
			if(level.trig5used==false && level.trapsdisabled==false && level.pick == 0)
			{
				level.hint5 triggerOn();
				thread checkactiprogress5( self );
				level waittill("move5");
			}
		}
		
		if(level.pick == 1)
			return;
		
		//trap6
		level.hint5 delete();
		/* [AUTO DELETE] wait 5; */
		chopper setVehGoalPos( (1336, 17424, -1280), true );
		chopper waittill("goal");
		if(isDefined(level.trapsdisabled))
		{
			if(level.trig6used==false && level.trapsdisabled==false && level.pick == 0)
			{
				level.hint6 triggerOn();
				thread checkactiprogress6( self );
				level waittill("move6");
			}
		}
		
		if(level.pick == 1)
			return;
		
		//trap7
		level.hint6 delete();
		/* [AUTO DELETE] wait 4; */
		chopper setVehGoalPos( (-1432, 17864, -1624), false );
		chopper waittill("goal");
		chopper setVehGoalPos( (-2912, 18360, -1624), true );
		chopper waittill("goal");
		if(isDefined(level.trapsdisabled))
		{
			if(level.trig7used==false && level.trapsdisabled==false && level.pick == 0)
			{
				level.hint7 triggerOn();
				thread checkactiprogress7( self );
				level waittill("move7");
			}
		}
		
		if(level.pick == 1)
			return;
		
		//END
		level.hint7 delete();
		/* [AUTO DELETE] wait 2; */
		
		if(level.pick == 1)
			return;
		
	if( !isDefined( self ) || !isAlive( self ) )
		chopper notify( "damage", 3000, undefined );
}


spawn_helicopter( owner, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	return chopper;
}


zipline()
{
    trigtiro = getEnt("trig_tiro1","targetname");
    for(;;)
    {
        trigtiro waittill("trigger",user);
			if(!isDefined (user.tiro))
			{
			user.tiro = true;
			user thread tiro();
			wait 0.05;
			}
    }
}


tiro()
{
ori1tiro = getEnt("ori1_tiro1","targetname");
ori3tiro = getEnt("ori3_tiro1","targetname");
ori4tiro = getEnt("ori4_tiro1","targetname");
ori5tiro = getEnt("ori5_tiro1","targetname");
ori6tiro = getEnt("ori6_tiro1","targetname");
ori7tiro = getEnt("ori7_tiro1","targetname");
ori8tiro = getEnt("ori8_tiro1","targetname");
ori9tiro = getEnt("ori9_tiro1","targetname");
ori10tiro = getEnt("ori10_tiro1","targetname");
ori11tiro = getEnt("ori11_tiro1","targetname");
ori12tiro = getEnt("ori12_tiro1","targetname");
ori13tiro = getEnt("ori13_tiro1","targetname");
self.disableAntiEle = true;
if(level.trap1 == 1)
	thread tirong();
	
	if(!isDefined(self.tiro2))
	{
	self.tiro2 = true;
    self endon("joined_spectators");
    self setOrigin( (-296, 4304, -528) );
    self setPlayerAngles( (20, 90, 0) );
   
    self disableWeapons();
    self freezeControls(true);
   
    self.linker = spawn("script_origin", self getOrigin());
    self linkTo(self.linker);
   
    self.linker moveto( ori1tiro.origin, 0.4);
    wait .2;
    self thread cameraYtiro1( self );
    self.linker moveto(ori3tiro.origin, .3);
    wait .5;
    self.linker moveto(ori4tiro.origin, .7);
    wait .7;
    self.linker moveto(ori5tiro.origin, .7);
    wait .7;
    self.linker moveto(ori6tiro.origin, .6);
    wait .6;
    self.linker moveto(ori7tiro.origin, 1);
    wait 1;
    self.linker moveto(ori8tiro.origin, .4);
    wait .4;
    self.linker moveto(ori9tiro.origin, .4);
    wait .4;
    self.linker moveto(ori10tiro.origin, .4);
    wait .4;
    self.linker moveto(ori11tiro.origin, .4);
    wait .4;
    self.linker moveto(ori12tiro.origin, .3);
    wait .3;
    self.linker moveto(ori13tiro.origin, .2);
    wait .1;
		self.linker unlink();
        self unlink();
		wait 0.05;
        self.linker delete();
        self enableWeapons();
        self freezeControls(false);
    wait 2;
	self.tiro = undefined;
	self.tiro2 = undefined;
	}
    self.disableAntiEle = undefined;
}


tirong()
{
tng = getEnt("tiro1ng","targetname");
tng waittill("trigger");
	if(!isDefined(level.tirou))
	{
		level.tirou = true;
		{
			tng delete();
			thread trap5ng();
		}
	}
}


cameraYtiro1( user )
{
	for(i = 0; i < 112; i++) {
		user changeAnglesTo(-0.15);
		wait .05;
	}
}


changeAnglesTo(angles) {
	self setPlayerAngles(self.angles + (20, angles, 0));
}


roofsmokefx()
{
rsmokefx = getEntArray("fx_smokeroof","targetname");

	for(i = 0;i < rsmokefx.size;i++)
	{
		playFx( level._effect["smokeroof"],rsmokefx[i].origin );
		wait 0.2;
	}
}


doorsetup()
{
	thread ngl();
	thread c4door1();
	thread c4door2();

}


c4door1()
{
d1trig = getEnt("c4door1_trig","targetname");
d1ori = getEnt("c4door1_ori","targetname");
dp2_s = getEnt("dynent_protect_2","targetname");

	{
	d1trig waittill("trigger");
	dp2_s delete();
	wait 0.2;
	d1ori PlaySound("grenade_explode_metal");
	playFx(level._effect["c4"],d1ori.origin);
	PhysicsExplosionSphere( d1ori.origin, 200, 160, 2 );
	wait 0.2;
	PhysicsExplosionSphere( d1ori.origin, 200, 160, 2 );
	wait 0.05;
	d1ori delete();
	d1trig delete();
	}
}


c4door3()
{
d3ori = getEnt("c4door3_ori","targetname");
dp3_s = getEnt("dynent_protect_3","targetname");

	{
	dp3_s delete();
	wait 0.2;
	d3ori PlaySound("grenade_explode_metal");
	playFx(level._effect["c4"],d3ori.origin);
	PhysicsExplosionSphere( d3ori.origin, 200, 160, 2 );
	PhysicsExplosionSphere( d3ori.origin, 200, 160, 2 );
	wait 0.2;
	d3ori delete();
	}
}


c4door2()
{
d2trig = getEnt("c4door2_trig","targetname");
d2ori = getEnt("c4door2_ori","targetname");
dp3_s = getEnt("dynent_protect_3","targetname");

	{
	d2trig waittill("trigger");
	if(level.night != 1 && level.trap5water == 1)
		level.ngpos = (-404, 19932, -2648);
	playFX(level._effect[ "bird" ], (-1816,17802,-1798));
	dp3_s delete();
	wait 0.2;
	d2ori PlaySound("grenade_explode_metal");
	playFx(level._effect["c4"],d2ori.origin);
	PhysicsExplosionSphere( d2ori.origin, 200, 160, 2 );
	PhysicsExplosionSphere( d2ori.origin, 200, 160, 2 );
	PhysicsExplosionSphere( d2ori.origin, 200, 160, 2 );
	wait 0.2;
	d2ori delete();
	d2trig delete();
	}
}


crane1()
{
cstun = getEnt("crane1_stun","targetname");
// crock = getEnt("crane1_rock","targetname");

// level.cranetime = 6;
// level.craneftime = 1;
// level.cranewtime = 4;

// 	while(1)
// 	{
// 	crock moveX(1400, level.cranetime, level.craneftime, level.craneftime);
// 	crock waittill("movedone");
// 	wait level.cranewtime;
// 	crock moveX(-1400, level.cranetime, level.craneftime, level.craneftime);
// 	crock waittill("movedone");
// 	wait level.cranewtime;
// 	}
}


guidchecking()
{
	thread guidcheckgod();
	thread guidcheckvip();
	wait 0.2;
}


messages()
{
wait 10;
/* [AUTO DELETE] iprintlnBold("^1Welcome ^7to ^1SuX ^7Lolz Map ^1:^7]"); */
wait 1;

while(1)
	{
	
		/* [AUTO DELETE] iPrintLn("^1Report any bugs"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^1Steam: ^7iswenzz1528 / SuX Lolz :]"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^1RIP ^2Raid-Gaming. xD"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^3Map Made By: ^5SuX ^7Lolz :]"); */
		wait 8;
	
	}
}


guidcheckgod() //CHECK GOD GUID :]
{
god1  = "5b7631e9"; //SuX Lolz
sanictrig = getent("sanic_check","targetname");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		tempGuid = getSubStr(user getGuid(), 24, 32);
		if(tempGuid == god1)
		{
		user detachAll();
		/* [AUTO DELETE] user TakeAllWeapons(); */
		user setModel("sonic");  //Model Here
		/* [AUTO DELETE] user GiveWeapon( "deserteaglegold_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "deserteaglegold_mp" ); */
		/* [AUTO DELETE] user switchtoweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] user GiveWeapon( "m40a3_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "m40a3_mp" ); */
		/* [AUTO DELETE] iPrintLnBold(user.name + " Map ^3Creator ^7is ^2Connected ^7!!"); */
		wait 3;
		}
			else
			{
			wait 3;
		}

	
}
}


guidcheckvip() //CHECK GOD VIP :]
{
god  = "5b7631e9"; //SuX Lolz
god1 = "9c8d844a"; //SuX PirE
god2 = "a26b44b3"; //SuX Trucker (Trucker0009)
god3 = "11b05456"; //Sheep Wizard
god4 = "38bf224a"; //#FNRP#Aditya
sanictrig = getent("sanic_check_2","targetname");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		tempGuid = getSubStr(user getGuid(), 24, 32);
		if((tempGuid == god))
		{
		user detachAll();
		/* [AUTO DELETE] user TakeAllWeapons(); */
		user setModel("sonic");  //Model Here
		/* [AUTO DELETE] user GiveWeapon( "deserteaglegold_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "deserteaglegold_mp" ); */
		/* [AUTO DELETE] user switchtoweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] user GiveWeapon( "m40a3_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "m40a3_mp" ); */
		/* [AUTO DELETE] iPrintLnBold(user.name + " Map ^3Creator ^7is ^2Connected ^7!!"); */
		wait 3;
		}
		if((tempGuid == god1) || (tempGuid == god2) || (tempGuid == god3) || (tempGuid == god4))
		{
		user detachAll();
		/* [AUTO DELETE] user TakeAllWeapons(); */
		user setModel("sonic");  //Model Here
		/* [AUTO DELETE] user GiveWeapon( "deserteaglegold_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "deserteaglegold_mp" ); */
		/* [AUTO DELETE] user switchtoweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] user GiveWeapon( "m40a3_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "m40a3_mp" ); */
		/* [AUTO DELETE] iPrintLnBold ("^3VIP " + user.name + " ^7is ^2Connected"); */
		wait 3;
		}
			else
			{
			wait 3;
		}

	
}
}


mapzor()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^1MP_DR_MIRRORS_EDGE" );
wait(6);
}


drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 60 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}


new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (40, 112, 222);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}


credits()
{
        self endon( "disconnect" );
 
        if( isDefined( self.credits_text ) )
                self.credits_text Destroy();
 
        self.credits_text = newHudElem();
        self.credits_text.y = 10;
        self.credits_text.alignX = "center";
        self.credits_text.alignY = "middle";
        self.credits_text.horzAlign = "center";
 
        self.credits_text.alpha = 0;
        self.credits_text.sort = -3;
        self.credits_text.fontScale = 1.6;
        self.credits_text.archieved = true;

		while(1)
        {
                self credit_roll( "^7Map by ^1SuX ^7Lolz :]", 5 );
				self credit_roll( "I accept any donation @ ^1Paypal : ^7suxlolz@outlook.fr", 5 );
				self credit_roll( "^1Thanks ^7to ^1Sheep Wizard ^7& ^1VC'^7Blade & ^1VC'^7TheLixfe for helping ^2me.", 3 );
				self credit_roll( "^1Thanks ^7to ^1SuX ^7Stxly & ^1SuX ^7AyPire for helping ^2me.", 3 );
				self credit_roll( "^1Thanks ^7to ^13xP' ^7Viruz & ^13xP' ^7Skazalien & ^1#^7FNRP^1#^7Aditya for helping ^2me.", 3 );
				self credit_roll( "Steam^1:^7 SuX Lolz ^1:^7]", 3); // SuX Lolz
				self credit_roll( "I accept any donation @ ^1Paypal : ^7suxlolz@outlook.fr", 5 );
				self credit_roll( "^7www^1.^7youtube^1.^7com^1/^7channel^1/^7UC1vxOXBzEF7W4g7TRU0C1rw", 5 ); // www.youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw
				wait 50;
        }
}


credit_roll( msg, time )
{
        self endon( "disconnect" );
 
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 1;
        self.credits_text setText( msg );
        wait( time );
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 0;
        wait 1;
}

water_hud()
{
    trig = getEnt("drown_water", "targetname");

    while(1)
    {
        trig waittill("trigger", player);

        if(!isDefined(self.water_trig))
        {
            player.water_trig = true;
            player thread water_hud_on(trig);
            player thread onwaterdeath();
        }

        wait 0.05;
    }
}


water_hud2(trig)
{

    while(1)
    {
        trig waittill("trigger", player);

        if(!isDefined(self.water_trig))
        {
            player.water_trig = true;
            player thread water_hud_on(trig);
            player thread onwaterdeath();
        }

        wait 0.05;
    }
}


water_hud_on(trig)
{
    self endon("out_of_water");

    while(1)
    {
        if(self isTouching(trig))
        {
            if(!isDefined(self.water_hud))
            {
                self.water_hud = true;
                self playSound("scn_body_splash");

                self.water_vision = newClientHudElem(self);
                self.water_vision setshader ("white", 640, 480);
                self.water_vision.x = 0;
                self.water_vision.y = 0;   
                self.water_vision.alignX = "left";
                self.water_vision.alignY = "top";
                self.water_vision.horzAlign = "fullscreen";
                self.water_vision.vertAlign = "fullscreen";
                self.water_vision.color = (.16, .38, .5);
                self.water_vision.alpha = .75;
            }
        }
        else if(!self isTouching(trig))
        {
            if(self.water_trig)
            {
                if(isDefined(self.water_vision))
                {
                    self.water_vision fadeOverTime(1);
                    self.water_vision.alpha = 0;
                    wait 1;
                    self.water_vision destroy();
                }
                self.water_hud = undefined;
                self.water_trig = undefined;
                self notify("out_of_water");
            }
        }

        wait 0.05;
    }
}


onwaterdeath()
{
    self waittill("death");
    /* [AUTO DELETE] //iPrintLn("dead m8"); */
    if(isDefined(self.water_vision))
        self.water_vision destroy();
    self.water_hud = undefined;
    self.water_trig = undefined;
    self notify("out_of_water");
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


endtrigantibug(trig)
{
self common_scripts\utility::waittill_any("death","disconnect");
level.jatekosend = 0;
trig SetHintString("^1Press &&1 !..");
}


end()
{
trigger = GetEnt( "end", "targetname" );
	{
	trigger waittill ("trigger", user);
		{
		/* [AUTO DELETE] iprintlnbold( "^7 " + user.name + " ^1Finished First^7 !!"); */
		wait 0.1;
		}
	}
}


games()
{
// level.games_trig = getEnt( "minigames", "targetname");
// games = getEnt( "minigames_ori", "targetname" );

// while(1)
// {
// level.games_trig waittill( "trigger", player );
// if( !isDefined( level.games_trig ) )
// return;

// player SetPlayerAngles( games.angles );
// player setOrigin( games.origin );
//  [AUTO DELETE] iPrintlnBold( " ^1" + player.name + " ^7has ^1entered ^7the ^1game ^7selection !" ); 
// /* [AUTO DELETE] player TakeAllWeapons(); */
// player antiglitch();


// while( isAlive( player ) && isDefined( player ) )
// if( isDefined( level.activ ) && isAlive( level.activ ) )
// /* [AUTO DELETE] wait 1; */
// }
}

antiglitch()
{ 
self common_scripts\utility::waittill_any("death","disconnect");
/* [AUTO DELETE] iPrintlnBold("^1"+self.name+" ^7is ^1dead"); */ 
/* [AUTO DELETE] iPrintlnBold("^1Selection ^7Room is now ^1open ^7!"); */ 
}


waitdead()
{
weapons = getent("weapons_trig","targetname");
bounce = getent("bounce_trig","targetname");
sniper = getent("sniper_trig","targetname");
sniper2 = getent("sniper_trig_2","targetname");
knife = getent("knife_trig","targetname");
shotgun = getent("shotgun_trig","targetname");
weapons triggerOff();
bounce triggerOff();
sniper triggerOff();
sniper2 triggerOff();
knife triggerOff();
shotgun triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
level.activ freezeControls(false);
weapons triggerOn();
bounce triggerOn();
sniper triggerOn();
sniper2 triggerOn();
knife triggerOn();
shotgun triggerOn();
}


sniperroom2()
{
sniper = getent("sniper_trig_2","targetname");
jumper = getent("sniper2_jumper_ori","targetname");
acti = getent("sniper2_activator_ori","targetname");
for(;;)
{
	sniper waittill("trigger", player);
	level.pick = 1;
	player thread waitdead();
	level.activ.chopperlink=false;
	level.activ.linker unlink();
	level.activ unlink();
	level.activ.health=100;
	player.health=100;
	wait 0.5;
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	level.activ freezeControls(true);
	level.activ setorigin(acti.origin);
	level.activ setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] level.activ takeallweapons(); */
	/* [AUTO DELETE] player giveweapon("m40a3_mp"); */
	/* [AUTO DELETE] level.activ giveweapon("m40a3_mp"); */
	/* [AUTO DELETE] player giveweapon("remington700_mp"); */
	/* [AUTO DELETE] level.activ giveweapon("remington700_mp"); */
	thread createhud(player.name + " ^1selected ^7snipah ^1war ^7!");
	wait 5;
	/* [AUTO DELETE] player iprintlnbold("^1FIGHT ^7!!!"); */
	/* [AUTO DELETE] level.activ iprintlnbold("^1FIGHT ^7!!!"); */
	player freezeControls(false);
	level.activ freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("m40a3_mp"); */
	/* [AUTO DELETE] level.activ switchtoweapon("m40a3_mp"); */
	/* [AUTO DELETE] player givemaxammo("m40a3_mp"); */
	/* [AUTO DELETE] level.activ givemaxammo("m40a3_mp"); */
	}
}


sniperroom()
{
sniper = getent("sniper_trig","targetname");
jumper = getent("origin_jumper_snip","targetname");
acti = getent("origin_acti_snip","targetname");
for(;;)
{
	sniper waittill("trigger", player);
	level.pick = 1;
	player thread waitdead();
	level.activ.chopperlink=false;
	level.activ.linker unlink();
	level.activ unlink();
	level.activ.health=100;
	player.health=100;
	wait 0.5;
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	level.activ freezeControls(true);
	level.activ setorigin(acti.origin);
	level.activ setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] level.activ takeallweapons(); */
	/* [AUTO DELETE] player giveweapon("m40a3_mp"); */
	/* [AUTO DELETE] level.activ giveweapon("m40a3_mp"); */
	/* [AUTO DELETE] player giveweapon("remington700_mp"); */
	/* [AUTO DELETE] level.activ giveweapon("remington700_mp"); */
	thread createhud(player.name + " ^1selected ^7snipah ^1war ^7!");
	wait 5;
	/* [AUTO DELETE] player iprintlnbold("^1FIGHT ^7!!!"); */
	/* [AUTO DELETE] level.activ iprintlnbold("^1FIGHT ^7!!!"); */
	player freezeControls(false);
	level.activ freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("m40a3_mp"); */
	/* [AUTO DELETE] level.activ switchtoweapon("m40a3_mp"); */
	/* [AUTO DELETE] player givemaxammo("m40a3_mp"); */
	/* [AUTO DELETE] level.activ givemaxammo("m40a3_mp"); */
	}
}


sniperjumperfail()
{
	sniperjumperfail = getEnt("trigger_jumper_fail_sniper", "targetname");
	tpsniperjumperfail = getEnt("origin_jumper_snip", "targetname");
	tpsniperactifail = getEnt("origin_acti_snip", "targetname");
	i = randomintrange(0, 1);
	
	for (;;)
	{
	sniperjumperfail waittill("trigger", player);
		if( i == 1 )
		{
		player setOrigin(tpsniperjumperfail.origin);
		player setPlayerAngles(tpsniperjumperfail.angles);
		}
		if( i != 1 )
		{
		player setOrigin(tpsniperactifail.origin);
		player setPlayerAngles(tpsniperactifail.angles);
		}
	wait .05;
	}
}


shotgun()
{
shotgun = getent("shotgun_trig","targetname");
jumper = getent("origin_jumper_shotgun","targetname");
acti = getent("origin_acti_shotgun","targetname");
for(;;)
{
	shotgun waittill("trigger", player);
	level.pick = 1;
	player thread waitdead();
	level.activ.chopperlink=false;
	level.activ.linker unlink();
	level.activ unlink();
	level.activ.health=100;
	player.health=100;
	wait 0.5;
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] level.activ takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	level.activ freezeControls(true);
	level.activ setorigin(acti.origin);
	level.activ setPlayerAngles(acti.angles);
	/* [AUTO DELETE] level.activ giveweapon("m1014_grip_mp"); */
	/* [AUTO DELETE] player giveweapon("m1014_grip_mp"); */
	/* [AUTO DELETE] player givemaxammo("m1014_grip_mp"); */
	/* [AUTO DELETE] level.activ givemaxammo("m1014_grip_mp"); */
	thread createhud(player.name + " ^1Selected ^7Shotgun ^1room ^7!");
	wait 5;
	player freezeControls(false);
	level.activ freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("m1014_grip_mp"); */
	/* [AUTO DELETE] level.activ switchtoweapon("m1014_grip_mp"); */
	}
}


weaponsroom()
{
weapons = getent("weapons_trig","targetname");
jumper = getent("origin_jumper_weapons","targetname");
acti = getent("origin_acti_weapons","targetname");
for(;;)
{
	weapons waittill("trigger", player);
	level.pick = 1;
	player thread waitdead();
	thread createhud(player.name + " ^1Selected ^7Weapons ^1Way ^7!");
	level.activ.chopperlink=false;
	level.activ.linker unlink();
	level.activ unlink();
	level.activ.health=100;
	player.health=100;
	wait 0.5;
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	level.activ freezeControls(true);
	level.activ setorigin(acti.origin);
	level.activ setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] level.activ takeallweapons(); */
	wait 5;
	/* [AUTO DELETE] IPrintLnbold("^2Fight!!!."); */
	i = randomintrange(0, 8);
	weapon = "rpg_mp";
	if(i == 0)
	{
		weapon = "rpg_mp";
	}
	else if(i == 1)
	{
		weapon = "winchester1200_mp";
	}
	else if(i == 2)
	{
		weapon = "mp44_mp";
	}
	else if(i == 3)
	{
		weapon = "ak47_mp";
	}
	else if(i == 4)
	{
		weapon = "ak74u_mp";
	}
	else if(i == 5)
	{
		weapon = "p90_silencer_mp";
	}
	else if(i == 6)
	{
		weapon = "saw_grip_mp";
	}
	else if(i == 7)
	{
		weapon = "uzi_silencer_mp";
	}
	/* [AUTO DELETE] player giveweapon("knife_mp"); */
	/* [AUTO DELETE] level.activ giveweapon("knife_mp"); */
	/* [AUTO DELETE] player giveweapon(weapon); */
	/* [AUTO DELETE] level.activ giveweapon(weapon); */
	/* [AUTO DELETE] level.activ givemaxammo(weapon); */
	/* [AUTO DELETE] player givemaxammo(weapon); */
	wait .1;
	/* [AUTO DELETE] player switchtoweapon(weapon); */
	/* [AUTO DELETE] level.activ switchtoweapon(weapon); */
	player freezeControls(false);
	level.activ freezeControls(false);
	}
}


bounceroom()
{
bounce = getent("bounce_trig","targetname");
jumper = getent("origin_jumper_bounce","targetname");
acti = getent("origin_acti_bounce","targetname");
for(;;)
{
	bounce waittill("trigger", player);
	level.pick = 1;
	player thread waitdead();
	level.activ.chopperlink=false;
	level.activ.linker unlink();
	level.activ unlink();
	level.activ.health=100;
	player.health=100;
	wait 0.5;
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] level.activ takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	level.activ freezeControls(true);
	level.activ setorigin(acti.origin);
	level.activ setPlayerAngles(acti.angles);
	/* [AUTO DELETE] level.activ giveweapon("knife_mp"); */
	/* [AUTO DELETE] player giveweapon("knife_mp"); */
	thread createhud(player.name + " ^1Selected ^7bounce ^1Room ^7!");
	wait 5;
	/* [AUTO DELETE] player iprintlnbold("GO^3!^7!^3!"); */
	/* [AUTO DELETE] level.activ iprintlnbold("GO^3!^7!^3!"); */
	player freezeControls(false);
	level.activ freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("knife_mp"); */
	/* [AUTO DELETE] level.activ switchtoweapon("knife_mp"); */
	}
}


givesniper()
{
givesnip = getEnt("givesnip_trig","targetname");

	for (;;)
	{
		givesnip waittill("trigger", player);
		/* [AUTO DELETE] player takeallweapons(); */
		wait 0.1;
		/* [AUTO DELETE] player giveweapon("m40a3_mp"); */
		/* [AUTO DELETE] player giveweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] player switchtoweapon("m40a3_mp"); */
		/* [AUTO DELETE] player givemaxammo("m40a3_mp"); */
		/* [AUTO DELETE] player givemaxammo("deserteaglegold_mp"); */
	}
}


bouncejumperfail()
{
	bouncejumperfail = getEnt("trigger_respawnjumper_bounce", "targetname");
	tpbouncejumperfail = getEnt("origin_jumper_bounce", "targetname");
	
	for (;;)
	{
		bouncejumperfail waittill("trigger", player);
		player setOrigin(tpbouncejumperfail.origin);
		player setPlayerAngles(tpbouncejumperfail.angles);
	}
}


bounceactifail()
{
	bounceactifail = getEnt("trigger_respawnacti_bounce", "targetname");
	tpbounceactifail = getEnt("origin_acti_bounce", "targetname");
	
	for (;;)
	{
		bounceactifail waittill("trigger", player);
		player setOrigin(tpbounceactifail.origin);
		player setPlayerAngles(tpbounceactifail.angles);
	}
}


kniferoom()
{
knife = getent("knife_trig","targetname");
jumper = getent("origin_jumper_knife","targetname");
acti = getent("origin_acti_knife","targetname");
for(;;)
{
	knife waittill("trigger", player);
	level.pick = 1;
	player thread waitdead();
	level.activ.chopperlink=false;
	level.activ.linker unlink();
	level.activ unlink();
	level.activ.health=100;
	player.health=100;
	wait 0.5;
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] level.activ takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	level.activ freezeControls(true);
	level.activ setorigin(acti.origin);
	level.activ setPlayerAngles(acti.angles);
	/* [AUTO DELETE] level.activ giveweapon("tomahawk_mp"); */
	/* [AUTO DELETE] player giveweapon("tomahawk_mp"); */
	thread createhud(player.name + " ^1Selected ^7Knife ^1room ^7!");
	wait 5;
	player freezeControls(false);
	level.activ freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("tomahawk_mp"); */
	/* [AUTO DELETE] level.activ switchtoweapon("tomahawk_mp"); */
	}
}
