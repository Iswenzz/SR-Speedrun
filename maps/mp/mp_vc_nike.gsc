main()
{
        maps\mp\_load::main();
 
        game["allies"] = "sas";
        game["axis"] = "opfor";
        game["attackers"] = "axis";
        game["defenders"] = "allies";
        game["allies_soldiertype"] = "woodland";
        game["axis_soldiertype"] = "woodland";

        setDvar("bg_falldamagemaxheight", 99999);
        setDvar("bg_falldamageminheight", 99998);

        thread sr\api\_speedrun::createNormalWays("Normal Way;");
        thread sr\api\_speedrun::createSecretWays("Secret Way;");
        thread sr\api\_map::createSpawn((289, -505, 60), 360);
        thread sr\api\_speedrun::createTeleporter((288.989, -660.368, 0.125001), 60, 100, (-290, -185, 76), 270, "freeze", "yellow", "secret_0");
        thread sr\api\_speedrun::createEndMap((1699.85, -4630.98, -15.875), 165, 100);

        thread start();
        thread sec0_fail1();
        thread sec0_fail2();
        thread sec0_fail3();
        thread sec0_finish();
        thread bouncepad();
}

start()
{
    door = getent("startdoor","targetname");
    hurta = getent("trap_5_hurt_a","targetname");
    hurtb = getent("trap_5_hurt_b","targetname");
    hurtc = getent("trap_5_hurt_c","targetname");
    hurtd = getent("trap_5_hurt_d","targetname");
    hurte = getent("trap_5_hurt_e","targetname");
    hurtf = getent("trap_5_hurt_f","targetname");
    trap5a = getent("trap_5_target_a","targetname");
    trap5b = getent("trap_5_target_b","targetname");
    trap5c = getent("trap_5_target_c","targetname");
    trap5d = getent("trap_5_target_d","targetname");
    trap5e = getent("trap_5_target_e","targetname");
    trap5f = getent("trap_5_target_f","targetname");
    trap7a = getent("trap_7_target_a","targetname");
    trap7b = getent("trap_7_target_b","targetname");
   
    hurta delete();
    hurtb delete();
    hurtc delete();
    hurtd delete();
    hurte delete();
    hurtf delete();
    door delete();
    trap5a delete();
    trap5b delete();
    trap5c delete();
    trap5d delete();
    trap5e delete();
    trap5f delete();
    trap7a delete();
    trap7b delete();
    
}

sec0_fail1()
{
trig = getEnt ("secret_trigger_1", "targetname");
	
	for(;;)
    	{
        trig waittill ("trigger", player);    

        player Suicide();     
	

	}

}

sec0_fail2()
{
trig = getEnt ("secret_trigger_2", "targetname");
	
	for(;;)
    	{
        trig waittill ("trigger", player);    

        player Suicide();     
	

	}

}

sec0_fail3()
{
trig = getEnt ("secret_trigger_3", "targetname");
	
	for(;;)
    	{
        trig waittill ("trigger", player);    

        player Suicide();     
	

	}

}

sec0_finish()
{
trig = getEnt ("secret_trigger_4", "targetname");
	
	for(;;)
    	{
        trig waittill ("trigger", player);    

        player thread sr\api\_speedrun::finishWay("secret_0");      
	

	}

}

bouncepad()
{
	trig = getent("bouncer", "targetname");
	
	for(;;)
	{
    	trig waittill ( "trigger", player );
    	 
	    player thread bounce();
	}
}

bounce()
{	
    for(i = 0; i < 3; i++)
	{
	    self.health += 250;
        self finishPlayerDamage(self, level.jumpattacker, 250, 0, "MOD_FALLING", "jump_mp", self.origin, AnglesToForward((-90,0,0)), "head", 0);
	}
}