main()
{
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	
	thread sr\api\_map::createSpawn((-753,3,-148),360);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createTeleporter((222.701, -3.30322, 16.125), 60, 10, (4571, 2, -212), 360, "freeze", "cyan", "normal_0");
	thread sr\api\_speedrun::createTeleporter((-316.303, 176.797, -207.875), 60, 10, (-21712, 384, 68), 360, "freeze", "blue", "secret_0");

	thread skiiele();
	thread startdoor();
	thread tele1();
	thread ele1();
	thread ele2();
	thread bouncemove();
	thread bouncemove2();
	thread secret();

}

skiiele()
{
brush=getent("skiiele", "targetname");
trig=getent("skiiele_trig", "targetname");

wait 0.1;
trig delete();

}

startdoor()
{
door=getent("startdoor", "targetname");

wait 0.1;
door delete();
}

tele1()
{
    trig = getEnt("tele1", "targetname");
    target = getEnt("tele1_orig", "targetname");
           
    for(;;)
    {
		trig waittill("trigger", player);
                   
            {
                player setOrigin( target.origin );
                player setPlayerAngles( target.angles );

            }
    }
}

ele1()
{
	ele1=getent("ele2", "targetname");
	ele2=getent("ele3", "targetname");
	ele3=getent("ele4", "targetname");
	
	wait 0.1;
	ele1 movex(-110,0.1);
	ele2 movex(-280,0.1);
	ele3 movex(-110,0.1);
		
}

ele2()
{
	ele4=getent("ele5", "targetname");
	ele5=getent("ele6", "targetname");
	ele6=getent("ele7", "targetname");
		
	wait 0.1;
	ele4 movex(1230,0.1);
	ele5 movex(-550,0.1);
	ele6 movex(1230,0.1);

}

bouncemove()
{
bounce1=getent("spinbounce1", "targetname");

wait 0.1;
bounce1 rotateyaw(330,0.1);
wait 0.1;
bounce1 moveX(3850,0.1);
wait 0.1;
bounce1 moveY(485,0.1);
		
}

bouncemove2()
{
bounce2=getent("spinbounce2", "targetname");

wait 0.1;
bounce2 rotateyaw(30,0.1);
wait 0.1;
bounce2 moveX(-650,0.1);
wait 0.1;
bounce2 moveY(-500,0.1);
		
}

secret()
{
	thread respawn1();
	thread respawn2();
	thread secretend();
}

respawn1()
{
	trig = getEnt("respawn1", "targetname");
	target = getEnt("respawn1_origin", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
		}
	}
}

respawn2()
{
	trig = getEnt("respawn2", "targetname");
	target = getEnt("respawn2_origin", "targetname");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		{
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
		}
	}
}

secretend()
{
	trig = getEnt("secretend", "targetname");
	target = getEnt("secretend_origin", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		
		{
		    player thread sr\api\_speedrun::finishWay("secret_0");
			player setOrigin( target.origin );
			player setPlayerAngles( target.angles );
		
		}
	}
}