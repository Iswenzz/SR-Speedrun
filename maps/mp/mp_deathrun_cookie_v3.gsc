main()
{
thread sr\api\_map::createSpawnOrigin((-190, 939, 160), 270);
maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread startdoor();
thread door();


}

startdoor()
{
door = getent("startdoor", "targetname");

door show();
door solid();

while(1)
{
wait 0.1;
door hide();
door notsolid();
}

}


door()
{
door = getent ("finaldoor", "targetname");

door show();
door solid();

while(1)
{
wait 0.1;

door hide();
door notsolid();
}

}