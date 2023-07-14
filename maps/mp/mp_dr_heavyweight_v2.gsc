main()
{
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
    thread sr\api\_speedrun::createSecretWays("Easy Secret;Hard Secret;");
	thread sr\api\_map::createSpawn((0, 152, 76), 0);
	thread sr\api\_speedrun::createTeleporter((-0.0181323, 277.078, 16.125), 100, 150, (-2828, 2013, -194), 90, "freeze", "green", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-0.014903, -3.79865, 16.125), 100, 150, (8715, 3870, -130), 270, "freeze", "orange", "secret_1");

	thread startdoor();
	thread trap5a();
	thread secreteasyend();
	thread secrethardend();
	
}

startdoor()
{
door = getent("startdoor","targetname");
lift = getent("trap6", "targetname");
block = getent("trap2", "targetname");

door delete();
lift moveZ (320, 0.1);
block moveY (-256, 0.1);

}
	

trap5a()
{
	mover = getent("trap5a", "targetname");
	mover2 = getent("trap5b", "targetname");
	
	mover2 moveY (608, 0.1);
	
}



secreteasyend()
{
trig = getent("trigger_secreteasydone", "targetname");

for(;;)
{
trig waittill ("trigger", player);

player thread sr\api\_speedrun::finishWay("secret_0");

}

}	


secrethardend()
{
trig = getent("trigger_secretend", "targetname");
	
for(;;)
{
trig waittill("trigger", player);
		
player thread sr\api\_speedrun::finishWay("secret_1");
		
}
}
