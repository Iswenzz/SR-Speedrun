main()
{
maps\mp\_load::main();
	  
game["allies"] = "sas";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "woodland";
game["axis_soldiertype"] = "woodland";

setDvar("bg_falldamagemaxheight", 99999);
setDvar("bg_falldamageminheight", 99998);

thread sr\api\_map::createSpawn((-6,-560,92),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;Fuse Way;Tunnel Way;Curve Way;");
thread sr\api\_speedrun::createTeleporter((-2927.08, -192.194, 112.125), 100, 50, (-4112, -192, 172), 180, "freeze", "blue");
thread sr\api\_speedrun::createTeleporter((-7201.94, -301.349, 64.125), 60, 50, (-7409, -190, 176), 180, "freeze", "blue");
thread sr\api\_speedrun::createTeleporter((4834.64, -412.507, 32.125), 90, 50, (6217, -412, -52), 360, "freeze", "blue");
thread sr\api\_speedrun::createTeleporter((816.681, 576.309, 32.125), 130, 200, "red", "normal_1");
thread sr\api\_speedrun::createTeleporter((766.699, 191.616, 32.125), 130, 200, "yellow", "normal_2");
thread sr\api\_speedrun::createTeleporter((866.965, -190.814, 32.125), 110, 200, "cyan", "normal_3");
thread sr\api\_speedrun::createEndMap((-9928.84, -186.562, 16.125),190,50, "normal_0");
thread sr\api\_speedrun::createEndMap((7627.67, 578.121, 32.125),120,50, "normal_1");
thread sr\api\_speedrun::createEndMap((8883.1, 186.969, -1423.88),115,50, "normal_2");
thread sr\api\_speedrun::createEndMap((10306.2, -416.024, -111.875),145,50, "normal_3");
	 
}