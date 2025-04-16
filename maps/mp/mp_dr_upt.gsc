main() {
        maps\mp\_load::main(); 

    game["allies"] = "sas";
    game["axis"] = "russian";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-37, 30, 92), 90);

    thread start_door();
}

start_door()
	{
		door = getent("startdoor" , "targetname");

		door delete();
	}