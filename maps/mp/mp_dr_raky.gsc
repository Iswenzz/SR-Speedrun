main() 
{
    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar("r_specularcolorscale","1");
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );

    thread sr\api\_map::createSpawn((-106,139,81),270);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^1Hard Way;^2Easy Way;");

    thread startdoor();
    thread elevator();
    thread secrethenter();
    thread secrethexit();
    thread secreteenter();
    thread secreteexit();

}

startdoor()
{
door =getEnt("startdoor", "targetname");
plat =getEntArray("moving_ori", "targetname");

door delete();
plat[0] delete();
plat[1] moveX(-200,0.1);
plat[2] moveX(-200,0.1);
wait 0.3;
plat[1] moveY(100,0.1);

}

elevator()
{
ele =getEnt("elevator", "targetname");

ele moveZ(-655,0.1);
wait 0.1;
ele moveY(-35,0.1);
wait 0.3;
ele RotateRoll(300,0.1);

}

secrethenter()
{
trig = getEnt("hard_enter", "targetname");
tele1 = getEnt("hard_ori", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player thread sr\api\_speedrun::changeWay("secret_0");
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);		
        
		}
}

secrethexit()
{
trig = getEnt("hard_finish", "targetname");
tele1 = getEnt("hard_finish_ori", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player thread sr\api\_speedrun::finishWay("secret_0");
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);		
        
		}
}

secreteenter()
{
trig = getEnt("easy_enter", "targetname");
tele1 = getEnt("easy_ori", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player thread sr\api\_speedrun::changeWay("secret_1");
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);		
        
		}
}

secreteexit()
{
trig = getEnt("easy_finish", "targetname");
tele1 = getEnt("easy_finish_ori", "targetname");

	for(;;)
		{
		trig waittill("trigger", player);

        player thread sr\api\_speedrun::finishWay("secret_1");
		player setOrigin(tele1.origin);
		player setPlayerAngles(tele1.angles);		
        
		}
}
