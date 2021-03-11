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

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	maps\mp\_load::main();
	maps\mp\enter_teleport\_teleport::main();
	maps\mp\_compass::setupMiniMap("compass_mp_sr_pure_strafe_v2");
 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
 
	setdvar("r_specularcolorscale","1");
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );

	visionSetNaked("mp_dr_portal",0);

	//SetExpFog( 768, 1500, 123/255, 155/255, 175/255, 3 );

	thread way_connect();
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
        player tweak_once();
    }
}

tweak_once()
{
	self setClientDvar("r_specular","1");
	self setClientDvar("r_glow","0");
	self setClientDvar("r_specularmap","1");
	self setClientDvar("r_filmusetweaks","1");
	self setClientDvar("r_fog","1");
	self setClientDvar("r_lighttweaksunlight","0.8");
	self setClientDvar("r_filmtweakcontrast","1");
	self setClientDvar("r_filmtweakbrightness","0");
	self setClientDvar("r_filmtweakdarktint","1.3 1.3 1.7");
	self setClientDvar("r_filmtweaklighttint","1 1 1");
	self setClientDvar("r_filmtweakenable","1");
	self setClientDvar("r_filmtweakdesaturation","0");
}

secret_1()
{
	trig = spawn("trigger_radius",(6976,9149,-757.5),0,80,512);
	ori = getEnt("secret_1_ori","targetname");

	thread secret_1_end();

	wait 1;
	trig.radius = 80;
	thread speedrun\_triggerfx::createTrigFx(trig, "secret");

	for(;;)
	{
		trig waittill("trigger",player);

		player setOrigin(ori.origin);
		player setPlayerAngles(ori.angles);
		player sr\api\_map::startSecret(); //Speedrun Copy Paste
	}
}

secret_1_end()
{
	trig = getEnt("secret_end","targetname");

	for(;;)
	{
		trig waittill("trigger",player);

		if(isDefined(player.sr_secret) && player.sr_secret)
			player thread braxi\_mod::endTimer();
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////
