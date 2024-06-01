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


    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-235, 575, 148), 0);
    thread sr\api\_speedrun::createEndMap((-97.6435, 1509.75, 72.125), 200, 100);

    hurt = getEnt ("b7hurt" , "targetname");
    hurt delete();

}
