main()
{
	maps\mp\_load::main(); 
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

    	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^1Hard Secret;^2Easy Secret;");
	thread sr\api\_speedrun::createTeleporter((-674.764, 5227.39, 448.125), 75, 20, (-675, 5543, 1020), 90, "freeze", "blue");
	thread sr\api\_speedrun::createTeleporter((-668.802, 8806.43, 960.125), 75, 20, (-671, 8530, 1596), 270, "freeze", "blue");
	thread sr\api\_speedrun::createTeleporter((828.968, 294.663, 0.125), 60, 15, (7332, 8383, 1020), 90, "freeze", "yellow", "secret_1");
   
    thread startdoor();
	thread ele();
	thread hardsec();
	thread hardend();
	thread ezend();
	thread bouncepad1();
	thread bouncepad2();
	thread bouncepad3();

}

startdoor()
{
door = getEnt("startdoor","targetname");

level waittill("round_started");

door delete();

}

ele()
{
ele1 = getEnt("ele1","targetname");
ele2 = getEnt("ele2","targetname");
block = getEnt("trap4","targetname");

level waittill("round_started");

ele1 rotateYaw(90,0.1);
block delete();
ele2 moveY(-200,0.1);
wait 0.2;
ele1 moveX(-400,0.1);
wait 0.5;
ele1 moveZ(-30,0.1);

}

hardsec()
{
trig = getEnt("trig_sec_tp", "targetname");
tele1 = getEnt("here4", "targetname");

    for(;;)
	{

	trig waittill("trigger", player);

	player thread sr\api\_speedrun::changeWay("secret_0");

	player setOrigin(tele1.origin);

	player setPlayerAngles(tele1.angles);

	player freezeControls(1);

	wait 0.05;

	player freezeControls(0);

	}

}

hardend()
{
trig = getEnt("sec_finish", "targetname");
tele1 = getEnt("here5", "targetname");

    for(;;)
	{

	trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");

	player setOrigin(tele1.origin);

	player setPlayerAngles(tele1.angles);

	}

}

ezend()
{
trig = getEnt("sec_exit2", "targetname");
tele1 = getEnt("here7", "targetname");

	for(;;)
    {

	trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_1");

	player setOrigin(tele1.origin);

	player setPlayerAngles(tele1.angles);

	}

}

bouncepad1()
{
trig = getent("bouncepad1", "targetname");

	for(;;)
	{

    trig waittill ( "trigger", player );

	player thread bounce();

	}

}

bouncepad2()
{
trig = getent("bouncepad2", "targetname");

	for(;;)
	{

    trig waittill ( "trigger", player );

	player thread bounce();

	}

}

bouncepad3()
{
trig = getent("bouncepad3", "targetname");

	for(;;)
	{

    trig waittill ( "trigger", player );

	player thread bounce();

	}

}

bounce()

{	

    for(i = 0; i < 4; i++)

	{

	    self.health += 160;

        self finishPlayerDamage(self, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", self.origin, AnglesToForward((-90,0,0)), "head", 0);

	}

}