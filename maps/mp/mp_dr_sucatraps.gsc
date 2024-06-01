main()
{
maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar("compassmaxrange","1400");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;");
	thread sr\api\_map::createSpawnOrigin((-262, 9, 16), 358);
    thread sr\api\_speedrun::createTeleporter((-205.708, -300.847, 16.125), 85, 75, (31, 21893, 1869), 322, "freeze", "green", "secret_0");
    thread sr\api\_speedrun::createTeleporter((-169.452, 297.767, 16.125), 85, 75, (8645, 22208, 3997), 319, "freeze", "red", "secret_1");


	thread start_door ();
	thread exitsecret_easy();
	thread exitsecret_hard();

	thread esp0();
    thread esp1();
    thread esp2();
    thread esp3();
    thread esp4();
    thread esFail0();

	thread hsp0();
    thread hsp1();
    thread hsp2();
    thread hsp3();
    thread hsf();


	entTransporter = getentarray( "teleport", "targetname" );
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
	}
}

transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}

start_door()
{
polka1 = getent("dvere_polka1","targetname");
polka2 = getent("dvere_polka2","targetname");

polka1 delete();
polka2 delete();
}

exitsecret_easy()
{
	trig = getent("exitsecret_trig_e","targetname");
	exitorigin = getent("exitsecret_origin_e","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
			
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

exitsecret_hard()
{
	trig = getent("exitsecret_trig_h","targetname");
	exitorigin = getent("exitsecret_origin_h","targetname");
	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::finishWay("secret_1");

	}
}


esp0()
{
	esp0 = getent("esp0", "targetname");
	for(;;)
	{
		esp0 waittill("trigger", player);
		player.fail = 0;


	}

}

esp1()
{
	esp1 = getent("esp1", "targetname");
	for(;;)
	{
		esp1 waittill("trigger", player);
		player.fail = 1;


	}
	
}

esp2()
{
	esp2 = getent("esp2", "targetname");
	for(;;)
	{
		esp2 waittill("trigger", player);
		player.fail = 2;


	}
	
}
esp3()
{
	esp3 = getent("esp3", "targetname");
	for(;;)
	{
		esp3 waittill("trigger", player);
		player.fail = 3;


	}

	
}

esp4()
{
	esp4 = getent("esp4", "targetname");
	for(;;)
	{
		esp4 waittill("trigger", player);
		player.fail = 4;


	}	




}



esFail0()
{
	esFail0 = getent("esFail", "targetname");
	orig0 = getent("esop0", "targetname");
	orig1 = getent("esop1", "targetname");
	orig2 = getent("esop2", "targetname");
	orig3 = getent("esop3", "targetname");
	orig4 = getent("esop4", "targetname");	

	for(;;)
{
	esFail0 waittill("trigger", player);
	if(player.fail == 0)
	{
		player setOrigin(orig0.origin);

	}
	else if(player.fail == 1)
	{
		player setOrigin(orig1.origin);

	}
	else if(player.fail == 2)
	{
		player setOrigin(orig2.origin);
		
	}
	else if(player.fail == 3)
	{
		player setOrigin(orig3.origin);
		
	}
	else if(player.fail == 4)
	{
	player setOrigin(orig4.origin);
		
	}
	else
	{
		player setOrigin(orig0.origin);
	}

}


	
}


hsp0()
{
	hsp0 = getent("hsp0", "targetname");
	for(;;)
	{
		hsp0 waittill("trigger", player);
		player.fail = 0;


	}

}

hsp1()
{
	hsp1 = getent("hsp1", "targetname");
	for(;;)
	{
		hsp1 waittill("trigger", player);
		player.fail = 1;


	}
	
}

hsp2()
{
	hsp2 = getent("hsp2", "targetname");
	for(;;)
	{
		hsp2 waittill("trigger", player);
		player.fail = 2;


	}
	
}
hsp3()
{
	hsp3 = getent("hsp3", "targetname");
	for(;;)
	{
		hsp3 waittill("trigger", player);
		player.fail = 3;


	}

	
}


hsf()
{
	hsf = getent("hsfail", "targetname");
	orig0 = getent("hsop0", "targetname");
	orig1 = getent("hsop1", "targetname");
	orig2 = getent("hsop2", "targetname");
	orig3 = getent("hsop3", "targetname");


	for(;;)
{
	hsf waittill("trigger", player);
	if(player.fail == 0)
	{
		player setOrigin(orig0.origin);

	}
	else if(player.fail == 1)
	{
		player setOrigin(orig1.origin);

	}
	else if(player.fail == 2)
	{
		player setOrigin(orig2.origin);
		
	}
	else if(player.fail == 3)
	{
		player setOrigin(orig3.origin);
		
	}
	else
	{
		player setOrigin(orig0.origin);
	}

}


	
}
