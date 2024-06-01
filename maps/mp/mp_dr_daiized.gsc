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
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");
	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setdvar("bg_fallDamageMinHeight", "99998");
	setdvar( "r_specular", "0" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;");
	thread sr\api\_map::createSpawn((2, -81, 76), 90);


    thread startdoor();
	thread tp1();
	thread tp2();
	thread tp3();	
	thread tp4();	
	thread easy();
	thread hard();
	thread hardsecret_end();
	thread easysecret_end();
	
	

}


startdoor()
{
	door = getent("startdoor","targetname");

	door delete();

}


tp1()
{
	og = getent ("og_part2","targetname");
	trig = getent ("tp_jumper_1","targetname");
	trig setHintString("^2>^7 Press ^2[USE] ^7to teleport to the next area !");

	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(og.origin);
    	player setplayerangles(og.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}	

tp2()
{
	og = getent ("og_part3","targetname");
	trig = getent ("tp_jumper_2","targetname");
	trig setHintString("^2>^7 Press ^2[USE] ^7to teleport to the next area !");

	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(og.origin);
    	player setplayerangles(og.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	
	}
}	

tp3()
{
	og = getent ("og_part4","targetname");
	trig = getent ("tp_jumper_3","targetname");
	trig setHintString("^2>^7 Press ^2[USE] ^7to teleport to the next area !");
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(og.origin);
    	player setplayerangles(og.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	
	}
}

tp4()
{
	og = getent ("og_part5","targetname");
	trig = getent ("tp_jumper_4","targetname");
	trig setHintString("^2>^7 Press ^2[USE] ^7to teleport to the end !");
	for(;;)
	{
		trig waittill("trigger", player);
		player setorigin(og.origin);
    	player setplayerangles(og.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	
	}
}	


easy()
{
	thread easy_enter();
	thread easy_checkpoint_system();
	thread easy_checkpoints();
}

easy_enter()
{
	trig = getent("easy_trigger","targetname");
	targ = getent("easy_enter_targ","targetname");

	for(;;)
	{
		trig sethintstring("Press ^5&&1^7 to enter the ^2Easy ^7Secret");
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player setorigin(targ.origin);
		player setplayerangles(targ.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);

		player.easy_checkpoint = 0;
	}
}

easy_checkpoint_system()
{
	trig = getent("easy_fail_trig","targetname");

	for(;;)
	{
		trig waittill("trigger",player);

		if(player.easy_checkpoint == 0)
			targ = getent("easy_enter_targ","targetname");
		else 
			targ = getent("easy_cp_"+ player.easy_checkpoint,"targetname");

		player iprintln("Checkpoint: "+ player.easy_checkpoint);

		player setorigin(targ.origin);
		player setplayerangles(targ.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

easy_checkpoints()
{
	cp_limit = 1;

	for(i=1;i<cp_limit+1;i++)
	{
		trig = getent("easy_cp_trig"+i,"targetname");

		trig thread check_cp_usage("easy",i);

		wait .05;
	}
}

hard()
{
	thread hard_enter();
	thread hard_checkpoint_system();
	thread hard_checkpoints();
}

hard_enter()
{
	trig = getent("hard_trigger","targetname");
	targ = getent("hard_enter_targ","targetname");

	for(;;)
	{
		trig sethintstring("Press ^5&&1^7 to enter the ^1Hard ^7Secret");
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1");  

		player setorigin(targ.origin);
		player setplayerangles(targ.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);

		player.hard_checkpoint = 0;
	}
}

hard_checkpoint_system()
{
	trig = getent("hard_fail_trig","targetname");

	for(;;)
	{
		trig waittill("trigger",player);

		if(player.hard_checkpoint == 0)
			targ = getent("hard_enter_targ","targetname");
		else 
			targ = getent("hard_cp_"+ player.hard_checkpoint,"targetname");

		player iprintln("Checkpoint: "+ player.hard_checkpoint);

		player setorigin(targ.origin);
		player setplayerangles(targ.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

hard_checkpoints()
{
	cp_limit = 4;

	for(i=1;i<cp_limit+1;i++)
	{
		trig = getent("hard_cp_trig"+i,"targetname");

		trig thread check_cp_usage("hard",i);

		wait .05;
	}
}

check_cp_usage(way,num)
{
    for(;;)
    {
        self waittill("trigger",player);
        if(way == "easy")
        {
            if(player.easy_checkpoint < num)
            {
                player.easy_checkpoint += 1;
                player iprintln("You've reached Checkpoint #"+player.easy_checkpoint);
            }
        }
        else if(way == "inter")
        {
            if(player.inter_checkpoint < num)
            {
                player.inter_checkpoint += 1;
                player iprintln("You've reached Checkpoint #"+player.inter_checkpoint);
            }
        }
        else if(way == "hard")
        {
            if(player.hard_checkpoint < num)
            {
                player.hard_checkpoint += 1;
                player iprintln("You've reached Checkpoint #"+player.hard_checkpoint);
            }
        }
    }
}

hardsecret_end()
{
	trig = getent("trig_hardend","targetname");
	og = getent("og_part5","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_1");
	}
}

easysecret_end()
{
	trig = getent("trig_easyend","targetname");
	og = getent("og_part4","targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);

		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}