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
    setdvar( "r_glowbloomintensity0", ".25" );
    setdvar( "r_glowbloomintensity1", ".25" );
    setdvar( "r_glowskybleedintensity0", ".3" );
	setdvar( "compassmaxrange", "1800" );
	setDvar("bg_falldamagemaxheight", 15000 );
	setDvar("bg_falldamageminheight", 10000 );
	
    thread startdoor();
	thread bounce_pad("bounce_trigger");
	thread death();

	thread sr\api\_map::createSpawn((-14,14,-132),359);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");

}


startdoor()
{
	start = getEnt("startdoor","targetname");
	trap1 = getEnt("trap_1_object","targetname");
	trap2 = getEnt("trap_2_object","targetname");
	trap3_1 = getEnt("trap_3_object_1","targetname");
	trap3_2 = getEnt("trap_3_object_2","targetname");
	trap6_1 = getEnt("trap_6_object_1","targetname");
	trap6_2 = getEnt("trap_6_object_2","targetname");
	trap6_3 = getEnt("trap_6_object_3","targetname");
	trap6_4 = getEnt("trap_6_object_4","targetname");
	trap6_5 = getEnt("trap_6_object_5","targetname");

	start delete();
	trap1 delete();
	trap2 delete();
	trap3_1 delete();
	trap3_2 delete();
	trap6_1 delete();
	trap6_2 delete();
	trap6_3 delete();
	trap6_4 delete();
	trap6_5 delete();

	
}

bounce_pad(trigger_entity)
{
	trigger = getEnt(trigger_entity, "targetname");
	
	for(;;)
	{
		trigger waittill("trigger", player);
		
		if(isDefined(player) && isAlive(player) && !player.isBouncing)
		{
			player.isBouncing = true;
			thread do_bounce(player, 180, 4, (-50, -180, 0), "none");
		}
		
		wait .05;
	}
}

do_bounce(player, strength, multiplyer, angle, pos)
{
	while(isDefined(player) && isAlive(player))
	{	
		if(player isOnGround())
		{			
			for(i = 0; i < multiplyer; i++)
			{
				player.health += strength;
				player finishPlayerDamage(player, level.jumpattacker, strength, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward(angle), pos, 0);
			}
			
			player.isBouncing = false;
			wait .05;
			
			while(isDefined(player) && isAlive(player))
			{
				if(player isOnGround())
					break;
				
				playFx(level.fx_bounce, player.origin);
				wait .05;
			}

			break;
		}

		wait .05;
	}
}

death()
{
   death= getent("trigger_death","targetname");
   
   for(;;)
   {
      death waittill("trigger",player);
      player suicide();
   }
}