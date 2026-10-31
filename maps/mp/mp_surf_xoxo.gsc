/*
	-+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-

	  ## ##   ##     ##  #######  ##     ##  #######  ########  ##        ########
	  ## ##    ##   ##  ##     ##  ##   ##  ##     ## ##     ## ##    ##  ##     ##
	#########   ## ##   ##     ##   ## ##   ##     ## ##     ## ##    ##  ##     ##
	  ## ##      ###    ##     ##    ###    ##     ## ########  ##    ##  ##     ##
	#########   ## ##   ##     ##   ## ##   ##     ## ##   ##   ######### ##     ##
	  ## ##    ##   ##  ##     ##  ##   ##  ##     ## ##    ##        ##  ##     ##
	  ## ##   ##     ##  #######  ##     ##  #######  ##     ##       ##  ########

	-+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-

	+MAPPER:	#xoxor4d // www.bouncepatch.com 	+ORGMAP: 	 nyro, qr, checkem
	+MAPNAME:			surf_omnifiCc				+CONSOLE-NAME: mp_surf_omnific
	+GAMETYPES:				surf 					+DIFFICULTY:		hard

	-+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-

*/

#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	sr\api\_map::swapTargetname("trigger_endmap", "endmap_trig");
	sr\api\_speedrun::createNormalWays("Normal Way;");
	// FX ++
	level.trail_gloaming_mm						= loadFx( "trails/fx_trail_pink" );

	// PRECACHE ++
	preCacheModel ( "tag_origin" );

	// SURF ++
	level.surfDifficulty = "easy";
	level.creatorname = "#xoxo^2r4d";

	thread watchSpawn();

	ambientPlay( "ambient" );

}

watchSpawn()
{
	while(1)
	{
		level waittill( "player_spawn", player );

		player setClientDvars( "r_specular", 1 );

		currentname = player.name;
		if( currentname == level.creatorname )
		{
			if( !isdefined( player.tag ) )
			{
				player.tag = spawn(  "script_model", player.origin + ( 0, 0, 50 ) );
				player.tag.angles = ( 0, 90, 0 );
				player.tag   setModel( "tag_origin" );
				player.tag   linkto( player );
			}

			else if( isdefined( player.tag ) )
			{
				player.tag Unlink();
				player.tag Delete();

				player.tag = spawn(  "script_model", player.origin + ( 0, 0, 50 ) );
				player.tag   setModel( "tag_origin" );
				player.tag.angles = ( 0, 90, 0 );
				player.tag   linkto( player );
			}

			player thread helpingHand();

			if( isdefined( player.tag ) )
			{
				player thread trail_fx_mm();

				if( !isdefined( player.acc_mm ) )
				{
					player.acc_mm = true;
					player IPrintLnBold( "Welcome XOXO!" );
				}
			}
		}
	}

	wait 0.05;
}

trail_fx_mm()
{
	wait 1;
	PlayFXOnTag( level.trail_gloaming_mm, self.tag, "tag_origin" );
}

helpingHand()
{
	self endon( "disconnect" );
	self endon( "spawned" );

    while(1)
    {
        while( !self sprintButtonPressed() )
            wait 0.05;

    	self IPrintLn( "tracing . . " );

    	start 	= self getEye();
    	end 	= start + maps\mp\_utility::vector_scale( anglesToForward( self getPlayerAngles() ), 999999 );
    	trace 	= bulletTrace( start, end, true, self );
    	dist 	= distance( start, trace[ "position" ] );

        ent = trace[ "entity" ];

 		if( isDefined( ent ) && ent.classname == "player" )
		{
    		if( isPlayer( ent ) )
            	ent IPrintLn( "^1You've been picked up by ^2" + self.name + "^1!" );

        	self IPrintLn( "^1You've picked up ^2" + ent.name + "^1!" );

       		linker = spawn( "script_origin", trace[ "position" ] );
        	ent linkto( linker );

            while( self sprintButtonPressed() )
                wait 0.05;

            while( !self sprintButtonPressed() && isDefined( ent ) )
            {
                start 	= self getEye();
                end 	= start + maps\mp\_utility::vector_scale( anglesToForward( self getPlayerAngles() ), dist );
                trace 	= bulletTrace(start, end, false, ent);
                dist 	= distance(start, trace[ "position" ] );

                if( self fragButtonPressed() && !self adsButtonPressed() )
                    dist -= 15;
                else if( self fragButtonPressed() && self adsButtonPressed() )
                    dist += 15;

                end 	= start + maps\mp\_utility::vector_Scale( anglesToForward( self getPlayerAngles() ), dist );
                trace 	= bulletTrace( start, end, false, ent );
                linker.origin = trace[ "position" ];

                wait 0.05;
            }

            if( isDefined( ent ) )
            {
                ent unlink();

                if( isPlayer( ent ) )
                    ent IPrintLn("^1You've been dropped by ^2" + self.name + "^1!");

                self IPrintLn( "^1You've dropped ^2" + ent.name + "^1!" );
            }

            linker delete();
        }

        while( self sprintButtonPressed() )
            wait 0.05;
    }
}