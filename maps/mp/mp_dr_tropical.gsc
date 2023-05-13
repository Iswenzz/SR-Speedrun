#include maps\mp\_utility;
#include common_scripts\utility;
main()
{
	///External scripts///
	maps\mp\_load::main();
	
	
	///Team Setup///
	game["allies"] = "sas";
	game["axis"] = "spetsnaz";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	
	///Set Dvars///
	VisionSetNaked( "mp_dr_tropical");
	setdvar( "r_gamma", "1" );
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0","1");
	setdvar("r_glowbloomintensity1","1");
	setdvar("r_glowskybleedintensity0","1");
	setdvar("compassmaxrange","1800");
	setDvar("bg_fallDamageMinHeight", "9999");
	setDvar("bg_fallDamageMaxHeight", "99999");
 
    thread sr\api\_map::createSpawn((-200, 96, 76), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread startdoor();
	thread secret_enter();
	thread secret_exit();
	thread secret_respawn();

}


trap2()
{
	trap2_trigger = getent("trap2_trigger","targetname");
	level.trap2_laptop = getent("trap2_laptop","targetname");

	trap2_ground = getent("trap2_ground","targetname");
	trap2_crater = getent("trap2_crater","targetname");
	trap2_fx = getent("trap2_fx","targetname");
	trap2_hurt = getent("trap2_hurt","targetname");

	trap2_hurt delete();

}

trap3()
{
	level.trap3_laptop = getent("trap3_laptop","targetname");
	trap3_trigger = getent("trap3_trigger","targetname");

	trap3_hurt = getent("trap3_hurt","targetname"); //Kill trigger
    trap3_fire = GetEntArray("trap3_fx","targetname"); //fx origin array

    trap3_sound = getent("trap3_sound","targetname"); //Sound orig

    trap3_hurt delete();


}

trap4()
{
	trap4_trigger = getent("trap4_trigger","targetname"); 
	level.trap4_laptop = getent("trap4_laptop","targetname");

	level.trap4_laptop SetModel("com_laptop_generic_open_obj");

	level.plane_start2 = getent("trap4_jet_node2","targetname"); 
	level.plane_end2 = getent("trap4_jet_node1","targetname"); 
	level.strikecoord2 = getent("strike_coord2","targetname"); 
	level.trap4_airstrike_hurt = getent("trao4_airstrike_hurt","targetname"); 

	level.trap4_airstrike_hurt delete();
	
}


trap5()
{
	trap5_trigger = getent("trap5_trigger","targetname"); 
	level.trap5_laptop = getent("trap5_laptop","targetname");

	level.trap5_laptop SetModel("com_laptop_generic_open_obj");

	trap3_spikes1 = getEnt("trap3_spikes1", "targetname");
	trap3_spikes1_hurt = getEnt("trap3_spikes_hurt1", "targetname");

	trap3_spikes1_hurt delete();

	trap3_spikes1 delete();

}

trap6()
{
	trap6_trigger = getent("trap6_trigger","targetname"); 
	level.trap6_laptop = getent("trap6_laptop","targetname");

	level.trap6_laptop SetModel("com_laptop_generic_open_obj");

	trap3_spikes2 = getEnt("trap3_spikes2", "targetname");
	trap3_spikes2_hurt = getEnt("trap3_spikes_hurt2", "targetname");

	trap3_spikes2_hurt delete();

	trap3_spikes2 delete();

	
}

trap7()
{
	trap7_trigger = getent("trap7_trigger","targetname"); 
	level.trap7_laptop = getent("trap7_laptop","targetname");

	level.trap7_laptop SetModel("com_laptop_generic_open_obj");

	trap3_spikes3 = getEnt("trap3_spikes3", "targetname");
	trap3_spikes3_hurt = getEnt("trap3_spikes_hurt3", "targetname");

	trap3_spikes3_hurt delete();

	trap3_spikes3 delete();

}

startdoor()
{
	start_door = getent("start_door","targetname");

	start_door delete();
}

secret_enter()
{
	level.secret_enter_trig = getent("secret_enter_trig", "targetname");
	secret_enter_orig = getent("secret_enter_orig", "targetname");

	level.secret_enter_trig SetHintString("^2Press ^3&&1 ^2to enter the secret!");
	level.secret_enter_trig waittill ("trigger", player);	

	player thread sr\api\_speedrun::changeWay("secret_0");

	player.checkpoint = 0;
	player SetPlayerAngles(secret_enter_orig.angles);
	player SetOrigin(secret_enter_orig.origin);
	wait 0.1;
	thread secret_enter();
}


secret_exit()
{
	level.secret_exit_trig = getent("secret_exit", "targetname");
	level.secret_exit_orig = getent("secret_exit_orig", "targetname");

	while(true)
	{
		level.secret_exit_trig waittill ("trigger", player);	
		if(player.checkpoint == 6)
		{
			player.checkpoint = 0;
		}
		player.checkpoint = 0;
		player notify("secret_exit");
		
		player thread sr\api\_speedrun::finishWay("secret_0");

		player SetPlayerAngles(level.secret_exit_orig.angles);
		player SetOrigin(level.secret_exit_orig.origin);
		wait 0.1;
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

	secret_checkpoint4 = getent("secret_checkpoint4", "targetname");
	secret_checkpoint4_orig = getent("secret_checkpoint4_orig", "targetname");

	secret_checkpoint5 = getent("secret_checkpoint5", "targetname");
	secret_checkpoint5_orig = getent("secret_checkpoint5_orig", "targetname");

	secret_checkpoint6 = getent("secret_checkpoint6", "targetname");
	secret_checkpoint6_orig = getent("secret_checkpoint6_orig", "targetname");

	secret_enter_trig = getent("secret_enter_trig", "targetname");
	secret_enter_orig = getent("secret_enter_orig", "targetname");

	secret_checkpoint1 thread checkpoint1_check();
	secret_checkpoint2 thread checkpoint2_check();
	secret_checkpoint3 thread checkpoint3_check();
	secret_checkpoint4 thread checkpoint4_check();
	secret_checkpoint5 thread checkpoint5_check();
	secret_checkpoint6 thread checkpoint6_check();

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
		if(player.checkpoint == 4)
		{
			player SetPlayerAngles(secret_checkpoint4_orig.angles);
			player SetOrigin(secret_checkpoint4_orig.origin);
			wait 0.2;
		}
		if(player.checkpoint == 5)
		{
			player SetPlayerAngles(secret_checkpoint5_orig.angles);
			player SetOrigin(secret_checkpoint5_orig.origin);
			wait 0.2;
		}
		if(player.checkpoint == 6)
		{
			player SetPlayerAngles(secret_checkpoint6_orig.angles);
			player SetOrigin(secret_checkpoint6_orig.origin);
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

checkpoint4_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 4;	
		wait 0.2;
	}
}

checkpoint5_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 5;	
		wait 0.2;
	}
}

checkpoint6_check()
{
	while(true)
	{
		self waittill ("trigger", player);
		player.checkpoint = 6;	
		wait 0.2;
	}
}
