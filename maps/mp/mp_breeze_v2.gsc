main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "allies";
    game["defenders"] = "axis";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 2000000000 );
    setDvar("bg_falldamageminheight", 1500000000 );
    setDvar("r_specularcolorscale", "8");

	thread sr\api\_speedrun::cj();

	thread sr\api\_speedrun::createNormalWays("Easy Way;");
	thread sr\api\_speedrun::createSecretWays("Overbounce Way;");

    thread sr\api\_speedrun::createTeleporter((2621, -5793, -1540), 60, 90, (1938, -47067, 19108), 270, "freeze", "blue", "secret_0");
    thread sr\api\_speedrun::createEndMap((1944, -47984, 17880), 120, 80, "secret_0");

    //thread teleport();
}

teleport()
{
    entTransporter = getentarray( "enter", "targetname" );
    if(isdefined(entTransporter))
        for( i = 0; i < entTransporter.size; i++ )
            entTransporter[i] thread transporter();
}

transporter()
{
    for(;;)
    {
        self waittill( "trigger", player );
        entTarget = getEnt( self.target, "targetname" );
        player setOrigin( entTarget.origin );
        player setplayerangles( entTarget.angles );
        wait 0.05;
    }
}
