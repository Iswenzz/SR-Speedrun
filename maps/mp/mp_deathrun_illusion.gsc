main()
{
trigger = spawn( "trigger_radius", (1537.73, 19611.5, 671.113), 0, 150, 20 );
trigger.targetname = "endmap_trig";
trigger.radius = 150;
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

thread sr\api\_map::createSpawn((1533,735,124),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread start();
thread twisters();
}

start()
{
brush1 = getEnt("startdoor", "targetname");

wait 0.1;
brush1 delete();
}

twisters()
{
epica = getEnt("twister1a", "targetname");
epicb = getEnt("twister1b", "targetname");

wait 0.1;
epica movex(400,0.1);
epicb movex(-400,0.1);
}