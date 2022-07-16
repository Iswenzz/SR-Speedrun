main()
{
maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
	
thread sr\api\_map::createSpawn((93,-762,-793),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createEndMap((-4249.65, 1669.53, -269.375), 135, 10, "normal_0");
thread sr\api\_speedrun::createTeleporter((-103.304, -711.028, -852.875), 60, 10, (5723, 3297, -3534), 360, "freeze", "blue", "secret_0");

thread bridge();
thread lightningtrap();
thread trap3();
thread secretrespawn();
thread secretend();
	 
}

bridge()
{
bridge = GetEnt("bridge", "targetname");
bridgedoor = GetEnt("bridgedoor", "targetname");

wait 0.1;
bridgedoor moveZ (156,0.1);
bridge moveX (849,0.1);
}

lightningtrap()
{

lightning1 = getent("lightning1", "targetname");
lightning2 = getent("lightning2", "targetname");
trap3damage = getent("trap3damage", "targetname");
trap3link = getent("trap3link", "targetname");

wait 0.1;
lightning1 delete();
lightning2 delete();
trap3damage delete();
trap3link delete();

}

trap3()
{ 
lasers = getEnt( "syndkys", "targetname" );

wait 0.1;
lasers hide();
lasers notsolid();
	
}

secretrespawn()
{
secretrespawn= GetEnt("secrettrigger","targetname");
origin = GetEnt("secretrespawn","targetname");

while(1)
{
secretrespawn waittill("trigger", player);
player SetPlayerAngles( origin.angles );
player setOrigin( origin.origin );
}	
}

secretend()
{
secretend = GetEnt("secretend","targetname");

	for(;;)
	{
    secretend waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_0");
	}
}