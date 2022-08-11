/*
   ___________   _  __
  / __/ __/ _ | / |/ /
 _\ \/ _// __ |/    /
/___/___/_/ |_/_/|_/

Map by Sean
Scripting by Glenbob
*/

main(){
	maps\mp\_load::main();

	//Teams
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	//Dvars//
	setdvar("r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 3000000 );
	setDvar("bg_falldamageminheight", 1280000 );
	setDvar("r_fullbright", "1");

	//Weapon precache//
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("knife_mp");
	preCacheItem("mp5_silencer_mp");
	preCacheItem("rpg_mp");
	preCacheItem("m60e4_mp");
	preCacheItem("m1014_mp");
	preCacheItem("deserteaglegold_mp");

	thread sr\api\_map::createSpawn((182,2,61), 360);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createTeleporter((457.319, 294.898, 0.625001), 60, 30, (-641, 4357, 540), 90, "freeze", "blue", "secret_0");

	//Secret//
	// thread secret();
	thread secret_finish();

	//Misc//
	thread startdoor();

}

secret_finish()
{

	trigger = getEnt("trig_secretEnd_Hard", "targetname");
	trigger setHintString("Press ^1&&1 ^7to finish secret^1!");

	for(;;)
	{
		trigger waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}

}

startdoor()
{
	level waittill("round_started");
	startdoor = getent("startdoor","targetname");

	startdoor delete();
}
