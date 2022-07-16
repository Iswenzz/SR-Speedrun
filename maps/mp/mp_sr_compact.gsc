main() {

	maps\mp\_load::main();

	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
    if(auto_spawn.size > 0)
        thread speedrun\_way_name::create_spawn_auto(auto_spawn[int(auto_spawn.size / 2)].origin,
            auto_spawn[int(auto_spawn.size / 2)].angles[1]);

	setdvar( "r_specularcolorscale", "1"  );
	setdvar( "r_glowbloomintensity0",".1" );
	setdvar( "r_glowbloomintensity1",".1" );
	setdvar( "r_glowskybleedintensity",".1" );

	setdvar("bg_fallDamageMaxHeight","9999999");
    setdvar("bg_fallDamageMinHeight","9999998");

    thread speedrun\_way_name::create_normal_way("Normal Way;");
    thread speedrun\_way_name::create_secret_way("Secret Way;");

	thread teleport();
	thread secret_enter();
	thread secret_fail();
	thread secret_finish();

	// Other
	// thread credits();

}

teleport() {
    trig = getEnt( "jump_tele1", "targetname" );
    dest = getEnt( "jump_origin1", "targetname" );

    while( 1 ) {
        trig waittill("trigger", player);
        player SetPlayerAngles( dest.angles );
        player setOrigin( dest.origin );
    }    
}

secret_enter() {
    trig = getEnt( "secret_start", "targetname" );
    dest = getEnt( "secret_start_origin", "targetname" );

    while( 1 ) {
        trig waittill("trigger", player);
        player thread speedrun\_way_name::change_way("s0");
        player SetPlayerAngles( dest.angles );
        player setOrigin( dest.origin );
    }    
}

secret_fail() {
    trig = getEnt( "secret_fail", "targetname" );
    dest = getEnt( "secret_start_origin", "targetname" );

    while( 1 ) {
        trig waittill("trigger", player);
        player SetPlayerAngles( dest.angles );
        player setOrigin( dest.origin );
    }    
}

secret_finish() {
    trig = getEnt( "secret_finish", "targetname" );
    dest = getEnt( "secret_finish_origin", "targetname" );

    while( 1 ) {
        trig waittill("trigger", player);
        player thread speedrun\_way_name::finish_way("s0");
        player SetPlayerAngles( dest.angles );
        player setOrigin( dest.origin );
    }    
}

credits() {
	while( 1 ) {
		wait 5;
		iPrintLn( "^7Thanks to ^8*time* ^7& ^8Liserd" );
		wait 15;
	}
}