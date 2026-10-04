/*	 _    ___      __  _                               ______  
	| |  / (_)____/ /_(_)____                         / _____\ 
	| | / / / ___/ __/ / ___/                        / / ___/ |
	| |/ / (__  ) /_/ / /__                         / / /__  / 
	|___/_/____/\__/_/\___/  __    ____            |  \___/ /  
	   / __ \___  ____ _/ /_/ /_  / __ \__  ______  \______/   
	  / / / / _ \/ __ `/ __/ __ \/ /_/ / / / / __ \            
	 / /_/ /  __/ /_/ / /_/ / / / _, _/ /_/ / / / /            
	/_____/\___/\__,_/\__/_/ /_/_/ |_|\__,_/_/ /_/             
	                                                           
	Code:
	Mapping:
	Desgin: 
			blfxtr (Blade #6504)

	Vistic Clan ©
*/

main()
{
	// ================ Game Settings ================ //
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	level.bay_glow=(randomint(100)/100,randomint(100)/100,randomint(100)/100);
	level.musicchosen = false;

	// ==================== Dvars ==================== //
	setdvar("bg_falldamagemaxheight", 20000 );
	setdvar("bg_falldamageminheight", 15000 );

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setDvar( "compassmaxrange", "1024" );

	// ================== Precache =================== //
	precacheModel("mil_lightstick_on");
	precacheModel("vistic_logo");
	precacheItem("ak47_mp");
	precacheItem("remington700_mp");
	precacheItem("knife_mp");


	// =================== Effects =================== //
	level.roomShard = loadfx("vistic/shardEmber");
	level.jukeeffect = loadfx("vistic/rainbow_funken");
	level.statue = loadfx("vistic/orange_light");
	level.lvlup = loadfx("vistic/lvl_up");

	startdoor = getent("startdoor","targetname");
	startdoor delete();
	sec = getent("secret_orig","targetname");
	thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");
	thread sr\api\_speedrun::createTeleporter((-300, 622, 20), 70, 100, sec.origin, 0, "freeze", "blue", "secret_0");
	thread leaveSecret();
	thread failSecret();
}

leaveSecret()
{
	trig = getent("secret_leave","targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

failSecret()
{
	trig = getent("fail_trig","targetname");
	port = getent("secret_orig","targetname");

	for(;;)
	{
		trig waittill("trigger",who);
		who thread teleport_player(port,undefined);
	}
}

teleport_player(port,msg)
{
	if(isdefined(msg))
		iprintlnbold(msg);

	self freezecontrols(1);
	self setorigin(port.origin);
	self setplayerangles(port.angles);
	wait .05; 
	self freezecontrols(0);
}