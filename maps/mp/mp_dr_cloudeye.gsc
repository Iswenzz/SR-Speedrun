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
	setDvar("bg_falldamagemaxheight", 650 );
	setDvar("bg_falldamageminheight", 550 );

	thread sr\api\_map::createSpawn((-168,-26,-196),1);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_speedrun::createTeleporter((-57.2562, 419.89, -255.875), 85, 50, (18495, 12197, 1086), 360, "freeze", "yellow", "secret_0");
	
	thread startdoor();
	thread door();
	thread platform1();
	thread trap1();
	thread trap2();
	thread trap4();
	thread trap8();
    thread rope();
	thread jump_pad();
	thread secret_end();
}

startdoor()
{
	door_fragment_01 = getEnt("door_fragment_01", "targetname");
	door_fragment_02 = getEnt("door_fragment_02", "targetname");
	door_fragment_03 = getEnt("door_fragment_03", "targetname");
	door_fragment_04 = getEnt("door_fragment_04", "targetname");
	door_fragment_05 = getEnt("door_fragment_05", "targetname");
	door_fragment_06 = getEnt("door_fragment_06", "targetname");
	door_fragment_07 = getEnt("door_fragment_07", "targetname");
	door_fragment_08 = getEnt("door_fragment_08", "targetname");
	door_fragment_09 = getEnt("door_fragment_09", "targetname");
	door_fragment_10 = getEnt("door_fragment_10", "targetname");
	door_fragment_11 = getEnt("door_fragment_11", "targetname");
	door_fragment_12 = getEnt("door_fragment_12", "targetname");
	door_fragment_13 = getEnt("door_fragment_13", "targetname");
	door_fragment_14 = getEnt("door_fragment_14", "targetname");
	
	door_fragment_01 delete();
	door_fragment_02 delete();
	door_fragment_03 delete();
	door_fragment_04 delete();
	door_fragment_05 delete();
	door_fragment_06 delete();
	door_fragment_07 delete();
	door_fragment_08 delete();
	door_fragment_09 delete();
	door_fragment_10 delete();
	door_fragment_11 delete();
	door_fragment_12 delete();
	door_fragment_13 delete();
	door_fragment_14 delete();

}

door()
{
object = getEnt ( "door_eye", "targetname" );
	
object delete();
}

platform1()
{
platform = getEnt ( "platform_01", "targetname" );
	
platform moveY(-380,0.1);
wait 0.1;
platform rotateYaw(-90,0.1);
wait 0.1;
platform moveZ(-50,0.1);

}

trap1()
{
spikes_1 = getEnt("trap_01_spikes_01", "targetname");
spikes_2 = getEnt("trap_01_spikes_02", "targetname");
spikes_3 = getEnt("trap_01_spikes_03", "targetname");
dmg_1 = getEnt("trap_01_spikes_01_dmg", "targetname");
dmg_2 = getEnt("trap_01_spikes_02_dmg", "targetname");
dmg_3 = getEnt("trap_01_spikes_03_dmg", "targetname");
	
spikes_1 delete();
spikes_2 delete();
spikes_3 delete();
dmg_1 delete();
dmg_2 delete();
dmg_3 delete();
	

}

trap2()
{
object = getEnt("trap_02_object", "targetname");
dmg = getEnt("trap_02_dmg", "targetname");
	
object delete();
dmg delete();
	
}

trap4()
{
spinner_1 = getEnt("trap_04_spinner_01", "targetname");
spinner_2 = getEnt("trap_04_spinner_02", "targetname");
spinner_3 = getEnt("trap_04_spinner_03", "targetname");
spinner_4 = getEnt("trap_04_spinner_04", "targetname");
spinner_5 = getEnt("trap_04_spinner_05", "targetname");
dmg_1 = getEnt("trap_04_dmg_01", "targetname");
dmg_2 = getEnt("trap_04_dmg_02", "targetname");
dmg_3 = getEnt("trap_04_dmg_03", "targetname");
dmg_4 = getEnt("trap_04_dmg_04", "targetname");
dmg_5 = getEnt("trap_04_dmg_05", "targetname");
		
spinner_1 delete();
spinner_2 delete();
spinner_3 delete();
spinner_4 delete();
spinner_5 delete();
dmg_1 delete();
dmg_2 delete();
dmg_3 delete();
dmg_4 delete();
dmg_5 delete();
	
}

trap8()
{
object_1 = getEnt("trap_08_object_01", "targetname");
object_2 = getEnt("trap_08_object_02", "targetname");
dmg_1 = getEnt("trap_08_dmg_01", "targetname");
dmg_2 = getEnt("trap_08_dmg_02", "targetname");
	
object_1  delete();
object_2 delete();
dmg_1 delete();
dmg_2 delete();
	
}

rope()
{
	trigger = getEnt ( "trigger_rope", "targetname" );
	start_origin = getEnt ( "origin_rope_start", "targetname" );
	end_origin = getEnt ( "origin_rope_end", "targetname" );
	
	trigger setHintString("Press ^1USE^7 to rope" );
	
	for(;;)
	{
		trigger waittill ( "trigger", player );
		thread exec_rope(player, start_origin, end_origin, 6, 5, 1);
		wait .7;
	}
}


exec_rope(player, src, dest, time, time_start, time_end)
{
    player sr\api\_player::antiElevator(false);
	player disableWeapons();
	
	src_model = spawn ( "script_model", (5, 7, 1));
	src_model.origin = player.origin;
	src_model.angles = player.angles;
	
	player LinkTo(src_model);
	src_model moveTo(src.origin, 1, .3, .7);
	wait 1;
	
	src_model moveTo(dest.origin, time, time_start, time_end);
	wait time;
	
	player sr\api\_player::antiElevator(true);
	player enableWeapons();
	player UnLink();
	src_model delete();
}

jump_pad()
{
	trigger = getEnt ( "trigger_jump_pad", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger", player );
		thread exec_bounce(player, 4, 175);
	}
}

exec_bounce(player, multiplyer, strenght)
{
	if (isAlive(player) && isDefined(player))
	{
		oldpos = player.origin;
		
		for(i = 0; i < multiplyer; i++)
		{
			player.health += strenght;
			player finishPlayerDamage(player, level.jumpattacker, strenght, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((-90, 180, 0)), "none", 0);
		}
		
		wait .5;
	}
}

secret_end()
{
        trig = getEnt ("trigger_secret_area_finish", "targetname");
       
        for(;;)
        {
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");
        }
}