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

	thread speedrun\_way_name::create_endmap((3607, -1532, -1916), 60, 15);

	// visionSetNaked("mp_dr_portal",0);

	//SetExpFog( 768, 1500, 123/255, 155/255, 175/255, 3 );

	thread way_connect();
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
	speedrun\_way_name::createWay("normal", "Normal Way", "1");
	// speedrun\_way_name::createWay("secret", "Secret Way", "1");
	
    for(;;) 
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
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
////////////////////////////////////////////////////////////////////////////////////////////////
