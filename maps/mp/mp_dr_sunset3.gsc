main()
{
	///External scripts///
	maps\mp\_load::main();
	
	///Team Setup///
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_gamma", "1" );
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0","1");
	setdvar("r_glowbloomintensity1","1");
	setdvar("r_glowskybleedintensity0","1");
	setdvar("compassmaxrange","1800");
	setDvar("bg_fallDamageMinHeight", "9999");
	setDvar("bg_fallDamageMaxHeight", "99999");

        thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");

	thread startdoor();
	thread secret_enter();
	thread secret_exit();
	thread secret_respawn();
	thread traphurt();
}

startdoor()
{
	start_door = getent("startdoor","targetname");
	start_door_trig = getent("startdoor_open","targetname");
	
    wait 0.1;
	start_door Delete();
 	start_door_trig Delete();

 	
}

secret_enter()
{
	secret_enter_trig = getent("secret_enter_trig", "targetname");
	secret_enter_orig = getent("secret_enter_orig", "targetname");

	while(true)
	{
		secret_enter_trig waittill ("trigger", player);	
		player thread sr\api\_speedrun::changeWay("secret_0");
		player.checkpoint = 0;
		player SetPlayerAngles(secret_enter_orig.angles);
		player SetOrigin(secret_enter_orig.origin);
		wait 0.2;
	}
}

secret_exit()
{
	secret_exit_trig = getent("secret_exit", "targetname");
	secret_exit_orig = getent("secret_exit_orig", "targetname");

	while(true)
	{
		secret_exit_trig waittill ("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");	
		player.checkpoint = 0;
		player SetPlayerAngles(secret_exit_orig.angles);
		player SetOrigin(secret_exit_orig.origin + (-100,0,0));
		wait 0.2;
	}
}

secret_respawn()
{
	secret_respawn_trig = getent("secret_reset", "targetname");

	secret_checkpoint1 = getent("secret_checkpoint1", "targetname");
	secret_checkpoint1_orig = getent("secret_checkpoint1_orig", "targetname");

	secret_checkpoint2 = getent("secret_checkpoint2", "targetname");
	secret_checkpoint2_orig = getent("secret_checkpoint2_orig", "targetname");

	secret_checkpoint3 = getent("secret_checkpoint3", "targetname");
	secret_checkpoint3_orig = getent("secret_checkpoint3_orig", "targetname");

	secret_enter_trig = getent("secret_enter_trig", "targetname");
	secret_enter_orig = getent("secret_enter_orig", "targetname");

	secret_checkpoint1 thread checkpoint1_check();
	secret_checkpoint2 thread checkpoint2_check();
	secret_checkpoint3 thread checkpoint3_check();

	while(true)
	{
		secret_respawn_trig waittill ("trigger", player);	
		if(player.checkpoint == 0)
		{
			player SetPlayerAngles(secret_enter_orig.angles);
			player SetOrigin(secret_enter_orig.origin);
			wait 0.2;
		}
		if(player.checkpoint == 1)
		{
			player SetPlayerAngles(secret_checkpoint1_orig.angles);
			player SetOrigin(secret_checkpoint1_orig.origin);
			wait 0.2;
		}
		if(player.checkpoint == 2)
		{
			player SetPlayerAngles(secret_checkpoint2_orig.angles);
			player SetOrigin(secret_checkpoint2_orig.origin);
			wait 0.2;
		}
		if(player.checkpoint == 3)
		{
			player SetPlayerAngles(secret_checkpoint3_orig.angles);
			player SetOrigin(secret_checkpoint3_orig.origin);
			wait 0.2;
		}
	}
}

checkpoint1_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 1;	
		wait 0.2;
	}
}

checkpoint2_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 2;	
		wait 0.2;
	}
}

checkpoint3_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 3;	
		wait 0.2;
	}
}

traphurt()
{
trap5_hurt = getent("trap5_hurt","targetname");
trap6_hurt = getent("trap6_hurt","targetname");
trap7_hurt = getent("trap7_hurt","targetname");

wait 0.1;

trap5_hurt delete();
trap6_hurt delete();
trap7_hurt delete();

}