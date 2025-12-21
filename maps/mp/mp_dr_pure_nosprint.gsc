main()
{
	maps\mp\_load::main();

	//ambientPlay("ambient_backlot_ext");

	game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "urban";
    game["axis_soldiertype"] = "urban";

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	SetDvar("bg_falldamagemaxheight", 99999);
	SetDvar("bg_falldamageminheight", 99998);

	thread sr\api\_map::createSpawn((0,0,62), 0);
	thread sr\api\_speedrun::createNormalWays("Normal Way");

	//SetDvar("g_speed", 210);

	//level.snowfx = loadfx ("custom/snow");

	level thread no_sprint_spam();
	//level thread end();

	//fx = getent("snow_fx", "targetname");
	//PlayFX(level.snowfx, fx.origin);
}

no_sprint_spam() {
	for(;;) {
		wait 0.05;

        players = getEntArray( "player", "classname" );
        for(i=0;i<players.size;i++) {
            players[i] AllowSprint(false);
			if(isAlive(players[i])) {
				wep = players[i] getCurrentWeapon();
				players[i] SetWeaponAmmoStock(wep, 0);
				players[i] SetWeaponAmmoClip(wep, 0);
			}
        }

	}
}

end()
{
	trig = getEnt("endmap_trig", "targetname");
	door = getEnt("end_gate", "targetname");
	level.disableRoomPlugin = true;
	trig waittill("trigger", player);

	jumpers = getEntArray("player", "classname");
	if(player.pers["team"] == "axis")
	{
		iPrintLnBold("^1Activator won!");
		for(z = 0; z < jumpers.size; z++)
		{
			jumpers[z] freezeControls(1);
		}
		wait 2;
		for(i = 0; i < jumpers.size; i++)
		{
			if(jumpers[i].pers["team"] == "allies")
			{
				jumpers[i] freezeControls(0);
				jumpers[i] finishPlayerDamage( player, player, 1000, 0, "MOD_PROJECTILE_SPLASH", "none", self.origin, self.origin, "none", 0 );
			}
		}
	}
	else {
		iPrintLnBold("^2Jumpers won!");
		for(i = 0; i < jumpers.size; i++)
		{
			jumpers[i] takeAllWeapons();
			jumpers[i] giveWeapon("knife_mp");
			jumpers[i] switchToWeapon("knife_mp");
		}
		level thread gunChecker();
		wait 1.5;
		door delete();
	}
}

gunChecker()
{
	for(;;)
	{
		jumpers = getEntArray("player", "classname");
		for(i = 0; i < jumpers.size; i++){
			jumpers[i].gun = jumpers[i] getCurrentWeapon();
			if (isAlive(jumpers[i]) && jumpers[i].team == "allies" && jumpers[i].gun != "knife_mp")
			{
				jumpers[i] takeAllWeapons();
				jumpers[i] giveWeapon("knife_mp");
				jumpers[i] switchToWeapon("knife_mp");
			}
		}
		wait .05;
	}
}