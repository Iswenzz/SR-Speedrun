main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("compassmaxrange","3000");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((495, 1326, 60), 270);
	thread sr\api\_speedrun::createEndMap((484.485, 1281.26, 640.125), 135, 100);

	hammer = getEnt( "hammer", "targetname" );
	hammer_hurt1 = getEnt( "hammerhurt1", "targetname" );
	hammer_hurt2 = getEnt( "hammerhurt2", "targetname" );
	badwalls_hurt = getEnt( "badwallshurt", "targetname" );

	hammer delete();
	hammer_hurt1 delete();
	hammer_hurt2 delete();
	badwalls_hurt delete();

	
}