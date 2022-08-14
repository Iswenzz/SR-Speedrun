/*

  _|_|_|            _|      _|      _|                  _|            
_|        _|    _|    _|  _|        _|          _|_|    _|  _|_|_|_|  
  _|_|    _|    _|      _|          _|        _|    _|  _|      _|    
      _|  _|    _|    _|  _|        _|        _|    _|  _|    _|      
_|_|_|      _|_|_|  _|      _|      _|_|_|_|    _|_|    _|  _|_|_|_|  

Map and GSC Made By SuX Lolz. Car destruction fixed by CM'death.

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
	maps\mp\_compass::setupMiniMap("compass_mp_backlot");
 
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

	thread sr\api\_map::createSpawn((-650, 1939, 124), 314);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Glitch Way;");
	thread sr\api\_speedrun::createEndMap((-549, -2428, 126), 120, 100);
	thread sr\api\_speedrun::createEndMap((143, -1418, 364), 120, 100, "secret_0");

	thread car();
}

car()
{
car=getEntArray("destructible","targetname");

level waittill ("round_started");

car[0] notsolid();
car[1] notsolid();
car[2] notsolid();
car[3] notsolid();
car[4] notsolid();
car[5] notsolid();
car[6] notsolid();
car[7] notsolid();
car[8] notsolid();
car[9] notsolid();
car[10] notsolid();
car[11] notsolid();
car[12] notsolid();
car[13] notsolid();
car[14] notsolid();
car[15] notsolid();
car[16] notsolid();
}