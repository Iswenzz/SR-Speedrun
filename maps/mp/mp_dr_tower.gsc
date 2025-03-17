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
	thread setup_bounce_pad("bounce_pad_1", (-60, -90, 0), 280, 4);
	thread setup_bounce_pad("bounce_pad_2", (-85, -90, 0), 165, 4);
	thread setup_bounce_pad("bounce_pad_3", (-90, -90, 0), 170, 4);
	thread setup_bounce_pad("bounce_pad_4", (-80, 180, 0), 170, 3);

	thread sr\api\_map::createSpawn((896,-413,-68),90);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
}

startdoor()
{
start = getEnt("startdoor","targetname");
trap1_1 = getEnt("trap_1_pusher_1","targetname");
trap1_2 = getEnt("trap_1_pusher_2","targetname");
trap2_1 = getEnt("trap_4_object","targetname");
trap2_2 = getEnt("trap_5_object","targetname");
trap2_3 = getEnt("trap_6_object","targetname");
trap2_4 = getEnt("trap_7_object","targetname");

start delete();
trap1_1 delete();
trap1_2 delete();
trap2_1 delete();
trap2_2 delete();
trap2_3 delete();
trap2_4 delete();

}

setup_bounce_pad(trigger_entity, angles, strength, multiplyer)
{
	trigger = getEnt(trigger_entity, "targetname");

	for(;;)
	{
		trigger waittill("trigger", player);

		if(isDefined(player) && isAlive(player) && !player.isBouncing)
		{
			player.isBouncing = true;
			player playSound("beam");
			thread do_bounce(player, strength, multiplyer, angles, "none");
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

			if(player GetStance() == "crouch" || player GetStance() == "prone") // to avoid sound spamming
			{
				player iPrintLnBold("^1Do not Crouch!");
				wait 3;
			}

			wait .1;
			player.isBouncing = false;
			break;
		}

		wait .05;
	}
}
