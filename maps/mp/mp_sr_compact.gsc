main() {
thread sr\api\_map::createSpawnOrigin((0, 0, 0), 0);

	maps\mp\_load::main();


	setdvar( "r_specularcolorscale", "1"  );
	setdvar( "r_glowbloomintensity0",".1" );
	setdvar( "r_glowbloomintensity1",".1" );
	setdvar( "r_glowskybleedintensity",".1" );

	setdvar("bg_fallDamageMaxHeight","9999999");
    setdvar("bg_fallDamageMinHeight","9999998");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");

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
        player thread sr\api\_speedrun::changeWay("secret_0");
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
        player thread sr\api\_speedrun::finishWay("secret_0");
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