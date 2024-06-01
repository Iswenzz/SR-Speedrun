main()
{

maps\mp\_load::main();
 
 

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-336, 1047, 72), 90);
    thread sr\api\_speedrun::createEndMap((4984.03, 5819.45, -63.875), 210, 100);


	thread deleteweap();
}

deleteweap()
{
    weapons = getEntArray("weapon_m60e4_mp", "classname");
    for (i = 0; i < weapons.size; i++)
        weapons[i] delete();
}
