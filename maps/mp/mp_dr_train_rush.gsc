/*

  _|_|_|            _|      _|      _|                  _|            
_|        _|    _|    _|  _|        _|          _|_|    _|  _|_|_|_|  
  _|_|    _|    _|      _|          _|        _|    _|  _|      _|    
	  _|  _|    _|    _|  _|        _|        _|    _|  _|    _|      
_|_|_|      _|_|_|  _|      _|      _|_|_|_|    _|_|    _|  _|_|_|_|  

Map and GSC Made By SuX Lolz.

Steam: http://steamcommunity.com/profiles/76561198163403316/
Discord: https://discord.gg/76aHfGF
Youtube: https://www.youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw
Paypal: suxlolz@outlook.fr
Email Pro: suxlolz@outlook.fr

*/
main()
{
level.masterSpawn = spawn("script_origin",(0, -19544, 192));
level.masterSpawn.angles = (0,90,0);
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_dr_train_rush");
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
 
	setdvar("r_specularcolorscale", "1");
	setdvar("compassmaxrange", "1600");
	setdvar("r_glowbloomintensity0", ".1");
	setdvar("r_glowbloomintensity1", ".1");
	setdvar("r_glowskybleedintensity0", ".1");
	setDvar("bg_falldamagemaxheight", 20000000);
	setDvar("bg_falldamageminheight", 15000000);
	setDvar("g_knockback", 1000);

	precacheitem("knife_mp");
	precacheitem("m40a3_mp");
	precacheitem("remington700_mp");
	precacheitem("p90_mp");
	precacheitem("p90_acog_mp");

	precacheModel("tag_origin");

	level.fx_fire = loadfx("ahatintime/fire");
	level.fx_smoke_dark = loadfx("ahatintime/black_smoke");
	level.fx_smoke_light = loadfx("ahatintime/o_light_smoke");
	level.fx_smoke_geotrail = loadfx("ahatintime/smoke_geotrail_rpg");
	level.fx_cannon_fire = loadfx("ahatintime/cannon_fire");
	level.fx_small_explosion = loadfx("ahatintime/small_explosion");
	level.fx_rift = loadfx("ahatintime/rift");
	level.fx_bubble = loadfx("ahatintime/bubble");
	level.fx_alert = loadfx("ahatintime/alert");

	thread maps\mp\mp_dr_train_rush\_teleport::main();
	thread maps\mp\mp_dr_train_rush\_timerift::main();
	thread maps\mp\mp_dr_train_rush\_traps::main();
	thread maps\mp\mp_dr_train_rush\_misc::main();
	// thread maps\mp\mp_dr_train_rush\_rooms::main();
	thread maps\mp\mp_dr_train_rush\_fx::main();

	thread way_connect();
	thread onConnect();
	thread spawn_settings_trigger();
	thread spawn_settings_activator();

	addTriggerToList("trap_1_trig");
	addTriggerToList("trap_2_trig");
	addTriggerToList("trap_3_trig");
	addTriggerToList("trap_4_trig");
	addTriggerToList("trap_5_trig");
	addTriggerToList("trap_6_trig");
	addTriggerToList("trap_7_trig");
	addTriggerToList("trap_8_trig");
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	sr\api\_map::createWay("secret", "Secret Way", "1");

	thread secret_1();

    for(;;) 
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}

secret_1()
{
	trigger = spawn( "trigger_radius", (150,-19371,253), 0, 30, 90 );
	ori = getEnt("rift_enter_ori","targetname");
	
	wait 1;
	// trigger.inAir = true;
	trigger.radius = 30;
	thread speedrun\_triggerfx::createTrigFx(trigger, "secret");

	for(;;)
	{
		trigger waittill("trigger",player);

		player setOrigin(ori.origin);
		player setPlayerAngles(ori.angles);
		player.secret = true;
		player thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
		player thread maps\mp\mp_dr_train_rush\_timerift::countdown();
		player thread maps\mp\mp_dr_train_rush\_timerift::getvel();
		player sr\api\_map::startSecret(); //Speedrun Copy Paste
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

// add trap trigger to a list for dr plugins
addTriggerToList(name)
{
	if (!isDefined(level.trapTriggers))
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt(name, "targetname");
}

// set player settings & vision & music
init_spawn()
{
	self endon("disconnect");

	if (isDefined(self.hud_time_secret))
		self.hud_time_secret Destroy();
	self.settings_tweaks = true;
	self.secret = false;
	self.bounced = false;
	self.boosted = false;
	self.secret_plat = [];
	for (i = 0; i < 5; i++) self.secret_plat[i] = false;
	self.secret_plat_count = 0;
	self thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
	self thread maps\mp\mp_dr_train_rush\_fx::dead_reset();
	self thread maps\mp\mp_dr_train_rush\_fx::spec_tweak();

	if (isDefined(self.settings_music))
		return;
	self thread maps\mp\mp_dr_train_rush\_misc::music_loop(level.picked_music);
	self.music_spawn = true;
	self.settings_music = true;
}

// on player connect callback
onConnect()
{
	while (true)
	{
		level waittill("connected", player);
		player thread spawn_settings();
	}
}

// init spawn settings
spawn_settings()
{
	while (true)
	{
		self waittill("spawned_player");
		if (isDefined(self.settings_tweaks))
		{
			wait 0.05;
			continue;
		}
		self thread init_spawn();
	}
}

// respawn the setting trigger fix a bug where the player didn't trigger it while being inside.
spawn_settings_trig_refresh()
{
	trig = getEnt("hint_1", "targetname");
	while (true)
	{
		trig triggerOff();
		wait 0.5;
		trig triggerOn();
		wait 0.5;
	}
}

// init spawn settings trigger
spawn_settings_trigger()
{
	thread spawn_settings_trig_refresh();
	trig = getEnt("hint_1", "targetname");
	while (true)
	{
		trig waittill("trigger", player);
		if (isDefined(player.settings_tweaks))
		{
			wait 0.05;
			continue;
		}
		player thread init_spawn();
		wait 0.05;
	}
}

// init activator spawn settings
spawn_settings_activator()
{
	level waittill("round_started");
	wait 5;
	player = getEntArray("player", "classname");

	for (i = 0; i < player.size; i++)
		if (isDefined(level.activ) && player[i] == level.activ)
			player[i] thread init_spawn();
}
