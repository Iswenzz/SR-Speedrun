main()
{
    maps\mp\_load::main();
 
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

	//Dvars//
	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 10000 );
	
	thread sr\api\_map::createSpawn((-136,743,76),270);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");

	thread FirstTele();
	thread SecondTele();

	thread StartDoor();

	thread OtherTraps();

	
}

OtherTraps()
{
	hurt1 = getEnt("hurt_trap7a","targetname");
	hurt2 = getEnt("hurt_trap7b","targetname");
	spinnerhurt = getEnt("hurt_spinner", "targetname");
	circle1hurt = getEnt("hurt_circle1", "targetname");
	circle2hurt = getEnt("hurt_circle2", "targetname");
	
	hurt1 delete();
	hurt2 delete();
    spinnerhurt delete();
    circle1hurt delete();
    circle2hurt delete();

}
 
Startdoor()
{
door = getEnt("startdoor", "targetname");
	
door delete();
}
 
 

FirstTele()
{
trig = getEnt("trig_firstfloor", "targetname");
tele1 = getEnt("origin_secondfloor", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}

SecondTele()
{
trig = getEnt("trig_secondfloor", "targetname");
tele1 = getEnt("origin_thirdfloor", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
			player freezeControls(1);
			wait 0.01;
			player freezeControls(0);
		}
}