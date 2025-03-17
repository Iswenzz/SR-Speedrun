main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("r_specularcolorscale", "1");
    setdvar("r_glowbloomintensity0", ".25");
    setdvar("r_glowbloomintensity1", ".25");
    setdvar("r_glowskybleedintensity0", ".3");

    setdvar("compassmaxrange", "1800");

	setDvar("bg_falldamagemaxheight", 15000);
	setDvar("bg_falldamageminheight", 10000);


    thread sr\api\_map::createSpawn((-103,12,-68),358);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");

	thread startdoor();
	thread setup_bounce_1("bounce_1_trigger", "bounce_1_object");
	thread setup_bounce_2("bounce_2_trigger", "bounce_2_object");
	thread death();

}

startdoor()
{
startdoor = getEnt("startdoor_object","targetname");
trap2 = getEnt("trap_2_object","targetname");
trap3 = getEnt("trap_3_object","targetname");
trap7 = getEnt("trap_7_object","targetname");

startdoor delete();
trap2 delete();
trap3 delete();
trap7 delete();

}

setup_bounce_1(trigger_entity, object_entity)
{
	trigger = getEnt(trigger_entity, "targetname");
	level.bounce_1 = getEnt(object_entity, "targetname");

	trigger enableLinkTo();
	trigger linkTo(level.bounce_1);

	for(;;)
	{
		trigger waittill("trigger", player);

		if(!player.isBounced)
		{
			player.isBounced = true;
			thread do_bounce(player, 500, 3, (-65, 180, 0), "none");
		}

		wait .05;
	}
}

setup_bounce_2(trigger_entity, object_entity)
{
	trigger = getEnt(trigger_entity, "targetname");
	level.bounce_2 = getEnt(object_entity, "targetname");

	trigger enableLinkTo();
	trigger linkTo(level.bounce_2);

	for(;;)
	{
		trigger waittill("trigger", player);

		if(!player.isBounced)
		{
			player.isBounced = true;
			thread do_bounce(player, 545, 3, (-80, 180, 0), "none");
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
			if(player GetStance() == "crouch" || player GetStance() == "prone") // to avoid sound spamming
			{
				player iPrintLnBold("^1Do not crouch!");
				player setOrigin((2304, -1664, -120));

				player.isBounced = false;
				break;
			}

			for(i = 0; i < multiplyer; i++)
			{
				player.health += strength;
				player finishPlayerDamage(player, level.jumpattacker, strength, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward(angle), pos, 0);
			}

			player playSound("launch");

			wait .1;
			player.isBounced = false;
			break;
		}

		wait .05;
	}
}

death()
{
   death= getent("ground_trigger_1","targetname");

   for(;;)
   {
      death waittill("trigger",player);
      player suicide();
   }
}