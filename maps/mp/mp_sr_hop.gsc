main()
{
thread sr\api\_map::createSpawnOrigin((-12, 356, 0), 266);
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
	setdvar("bg_fallDamageMaxHeight", "99999");
    setdvar("bg_FallDamageMinHeight","99998");

    thread sr\api\_speedrun::createNormalWays("Normal Way;Pure Strafe");
	thread sr\api\_speedrun::createSecretWays("Inter Secret;Hard Secret;");
	thread sr\api\_speedrun::createEndMap((4352.06, -16433, -4095.88),260,10,"normal_0");
	thread sr\api\_speedrun::createEndMap((-2.44038, 5108.88, -439.123),180,10,"normal_1");
	thread sr\api\_speedrun::createEndMap((12725.7, 33183.3, 12456.1),70,10,"secret_0");
	thread sr\api\_speedrun::createEndMap((-14934.6, 103.061, 21277.1),120,10,"secret_1");


	precacheModel("iw_zapper_view");
	precacheModel("iw_zapper_world");
	precacheshader("mtl_iw_zapper");
	precacheItem("usp_silencer_mp");
	precacheItem("change_mp");
	precacheItem("rpg_mp");
	precacheItem("beretta_silencer_mp");
	precacheModel("ww2_bat_view");
	precacheshader("mtl_ww2_bat");
	precacheshader("mtl_johnwick_hair");
    precacheshader("mtl_johnwick_head");
    precacheshader("mtl_johnwick_suit");
    precacheModel("plr_terry_johnwick");
	precacheshader("mtl_peely_full");
    precacheModel("plr_terry_peely");
	precacheshader("mtl_chucky_head");
    precacheshader("mtl_chucky_eyes");
    precacheshader("mtl_chucky_body");
	precacheModel("plr_terry_chucky");
	precacheModel("plr_terry_hitler");
	precacheshader("mtl_hitler_head");
	precacheshader("mtl_hitler_body");
	precacheshader("mtl_hitler_teeth");
	precacheshader("mtl_hitlerhead");
	precacheshader("mtl_hitlerbody");
	precacheshader("mtl_hulk_endgame");
    precacheModel("plr_terry_hulk");


	thread pure_strafe();
	//thread pure_end();
	thread onPlayerSpawned();
	thread stage1fail();
	thread rpg_hard1();
	thread rpg_take1();
    thread hard_enter();
    thread inter_enter();
	thread MrWick();
	thread peely();
	thread chuck();
	thread hitler();
	thread hulk();


}

onPlayerSpawned()
{
    self endon("disconnect");

    self waittill("player_spawned");
    self setClientDvar("r_filmTweakContrast", "2");
	self setClientDvar("r_filmTweakBrightness", "0.05");
}

MrWick()
{
    trig = getEnt("trig_wick", "targetname");
    trig setHintString("^3VIP");
	Trig waittill("trigger", player);
	name = getDvar("name");
	if (name == "Cammy" || name== "Luey" || name== "Sr- kLeiN" || name== "Hidan" ||  name=="Sr- Kagero")
	player iprintlnBold ( "^5Access granted ");


    {
	player detachAll();
	player setModel("plr_terry_johnwick");
    player giveWeapon("change_mp");
    player switchToWeapon("change_mp");
    wait 1;
    }
}

peely()
{
    trig = getEnt("trig_peely", "targetname");
    trig setHintString("^3Press F To Change Peely");


    while(1)
    {
    Trig waittill("trigger", player);
	player detachAll();
	player setModel("plr_terry_peely");
    player giveWeapon("usp_silencer_mp");
    player switchToWeapon("usp_silencer_mp");
    wait 0.1;
    }
}

chuck()
{
    trig = getEnt("trig_chucky", "targetname");
    trig setHintString("^3Press F To Change To Chucky");


    while(1)
    {
    Trig waittill("trigger", player);
	player detachAll();
	player setModel("plr_terry_chucky");
    player giveWeapon("usp_silencer_mp");
    player switchToWeapon("usp_silencer_mp");
    wait 0.1;
    }
}

hitler()
{
    trig = getEnt("trig_hitler", "targetname");
    trig setHintString("^3Press F To Change To Hitler");


    while(1)
    {
    Trig waittill("trigger", player);
	player detachAll();
	player setModel("plr_terry_hitler");
    player giveWeapon("usp_silencer_mp");
    player switchToWeapon("usp_silencer_mp");
    wait 0.1;
    }
}

hulk()
{
    trig = getEnt("trig_hulk", "targetname");
    trig setHintString("^3Press F To Change To Hulk");


    while(1)
    {
    Trig waittill("trigger", player);
	player detachAll();
	player setModel("plr_terry_hulk");
    player giveWeapon("usp_silencer_mp");
    player switchToWeapon("usp_silencer_mp");
    wait 0.1;
    }
}





rpg_hard1()
{
	trig = getEnt("rpg_hard1", "targetname");

	     while ( true )
		{
			trig waittill("trigger", player);
			player giveWeapon("rpg_mp");
            player giveMaxAmmo("rpg_mp");
            player switchToWeapon("rpg_mp");
		}
}

rpg_take1()
{
	trig = getEnt("rpg_take1", "targetname");

	     while ( true )
		{
			trig waittill("trigger", player);
			player giveWeapon("beretta_silencer_mp");
            player giveMaxAmmo("beretta_silencer_mp");
            player switchToWeapon("beretta_silencer_mp");
		}
}


stage1fail()
{
	trig = getEnt("stage_1_tele", "targetname");
	tele1 = getEnt("stage_1_ori", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

pure_strafe()
{
	trig = getEnt("pure_strafe", "targetname");
	tele1 = getEnt("pure_start", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player thread sr\api\_speedrun::changeWay("normal_1");
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}






hard_enter()
{
    trig = getent ("secret_trig","targetname");
    target = getent ("super_secret_target1","targetname");
	thread super_secret();
    while(true)
    {
    trig waittill("trigger",player);
	player thread sr\api\_speedrun::changeWay("secret_1");
    player.secret = 0;
    player setPlayerangles( target.angles );
    player setOrigin( target.origin );
    }

}


super_secret()
{
    trig = getent ("super_secret_teleport","targetname");
    target1 = getent ("super_secret_target1","targetname");
    target2 = getent ("super_secret_target2","targetname");
    target3 = getent ("super_secret_target3","targetname");
    target4 = getent ("super_secret_target4","targetname");


    thread super_part1();
    thread super_part2();
    thread super_part3();


    while(true)
    {
    trig waittill("trigger",player);

        if(player.secret == 0 )
        {
        player setPlayerangles( target1.angles );
        player setOrigin( target1.origin );
        }
        else if(player.secret == 1 )
        {
        player setPlayerangles( target2.angles );
        player setOrigin( target2.origin );
        }
        else if(player.secret == 2 )
        {
        player setPlayerangles( target3.angles );
        player setOrigin( target3.origin );
        }
        else if(player.secret == 3 )
        {
        player setPlayerangles( target4.angles );
        player setOrigin( target4.origin );
        }

      wait 0.05;
    }
}



super_part1()
{
	trig = getent ("hard_check1","targetname");
	while(true)
	{
	trig waittill("trigger",player);
	if(player.secret == 0 )
	{
    player.secret = 1;
	player iprintln("^9Saved");
	wait 0.05;
	}
	}
}

super_part2()
{
	trig = getent ("hard_check2","targetname");
	while(true)
	{
	trig waittill("trigger",player);
	if(player.secret == 1 )
	{
    player.secret = 2;
	player iprintln("^9Saved");
	wait 0.05;
	}
	}
}

super_part3()
{
	trig = getent ("hard_check3","targetname");
	while(true)
	{
	trig waittill("trigger",player);
	if(player.secret == 2 )
	{
    player.secret = 3;
	player iprintln("^9Saved");
	wait 0.05;
	}
	}
}

inter_enter()
{
    trig = getent ("inter_trig","targetname");
    target = getent ("secret_target1","targetname");
	thread inter_super_secret();
    while(true)
    {
    trig waittill("trigger",player);
	player thread sr\api\_speedrun::changeWay("secret_0");
    player.secret = 0;
    player setPlayerangles( target.angles );
    player setOrigin( target.origin );
    }

}

inter_super_secret()
{
    trig = getent ("secret_teleport","targetname");
    target1 = getent ("secret_target1","targetname");
    target2 = getent ("secret_target2","targetname");
    target3 = getent ("secret_target3","targetname");
    target4 = getent ("secret_target4","targetname");


    thread inter_part1();
    thread inter_part2();
    thread inter_part3();


    while(true)
    {
    trig waittill("trigger",player);

        if(player.secret == 0 )
        {
        player setPlayerangles( target1.angles );
        player setOrigin( target1.origin );
        }
        else if(player.secret == 1 )
        {
        player setPlayerangles( target2.angles );
        player setOrigin( target2.origin );
        }
        else if(player.secret == 2 )
        {
        player setPlayerangles( target3.angles );
        player setOrigin( target3.origin );
        }
        else if(player.secret == 3 )
        {
        player setPlayerangles( target4.angles );
        player setOrigin( target4.origin );
        }

      wait 0.05;
    }
}

inter_part1()
{
	trig = getent ("inter_check1","targetname");
	while(true)
	{
	trig waittill("trigger",player);
	if(player.secret == 0 )
	{
    player.secret = 1;
	player iprintln("^9Saved");
	wait 0.05;
	}
	}
}

inter_part2()
{
	trig = getent ("inter_check2","targetname");
	while(true)
	{
	trig waittill("trigger",player);
	if(player.secret == 1 )
	{
    player.secret = 2;
	player iprintln("^9Saved");
	wait 0.05;
	}
	}
}

inter_part3()
{
	trig = getent ("inter_check3","targetname");
	while(true)
	{
	trig waittill("trigger",player);
	if(player.secret == 2 )
	{
    player.secret = 3;
	player iprintln("^9Saved");
	wait 0.05;
	}
	}
}









