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

	+MAPPER:	#xoxor4d // www.bouncepatch.com 	+ORGMAP: 	   juxtapo
	+MAPNAME:			surf_andromeda				+CONSOLE-NAME: mp_surf_andromeda
	+GAMETYPES:				surf 					+DIFFICULTY:   easy

	-+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-

*/
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	sr\api\_map::swapTargetname("trigger_endmap", "endmap_trig");
	sr\api\_speedrun::createNormalWays("Normal Way;");
	// FX ++
	level.trail_gloaming_mm						= loadFx( "trail_gloaming_mm" );

	// PRECACHE ++
	preCacheModel ( "tag_origin" );

	preCacheModel( "vehicle_80s_sedan1_red_destructible_mp" ); //portal_cake
	preCacheModel( "portal_cake" );
	preCacheModel( "portal_companion_cube" );
	preCacheModel( "sphere_dist" );
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

		player setClientDvars( "r_glowTweakEnable", 1 );
		player setClientDvars( "r_glowUseTweaks", 1 );
		player setClientDvars( "r_glowTweakRadius0", 22 );
		player setClientDvars( "r_glowTweakBloomIntensity0", 4 );
		player setClientDvars( "r_glowTweakBloomDesaturation", 0 );
		player setClientDvars( "r_glowTweakBloomCutoff", 0.24 );
		player setClientDvars( "r_glow_allowed", 1 );
		player setClientDvars( "r_glow_allowed_script_forced", 1 );
		player setClientDvars( "r_glow", 1 );

		player setClientDvars( "r_dof_tweak", 1 );
		player setClientDvars( "r_dof_bias", 0.5 );
		player setClientDvars( "r_dof_farblur", 0.7 );
		player setClientDvars( "r_dof_farstart", 2000 );
		player setClientDvars( "r_dof_farend", 8000 );
		player setClientDvars( "r_dof_nearstart", 0 );
		player setClientDvars( "r_dof_nearend", 0 );

		player setClientDvars( "r_filmusetweaks", 1 );
		player setClientDvars( "r_filmtweakenable", 1 );
		player setClientDvars( "r_filmtweakdarktint", "1.2 1 1.4" );
		player setClientDvars( "r_filmtweaklighttint", "0.7 0.5 0.3" );
		player setClientDvars( "r_filmtweakcontrast", 1.1 );
		player setClientDvars( "r_filmtweakBrightness", 0.02 );
		player setClientDvars( "r_filmtweakdesaturation", 0 );

		//player setClientDvars( "r_specularmap", 2 );
		player setClientDvars( "r_specularcolorscale", 5 );


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

			if( isdefined( player.tag ) )
			{
				player thread trail_fx_mm();
				player thread doModelChange();
				Earthquake( 0.5, 1, player.origin, 3000 );

				if( !isdefined( player.acc_mm ) )
				{
					player.acc_mm = true;
					player IPrintLnBold( "Welcome XOXO!" );
					//Earthquake( 0.5, 1, player.origin, 3000 );
				}
			}
		}
	}

	wait 0.05;
}

doModelChange()
{
	self endon( "spawned" );
    self endon( "death" );
    self endon( "disconnect" );

    for (;;)
    {
 		if ( self GetStance() == "prone")
 		{

	        self waittill( "weapon_change" );
            	self setModel( "vehicle_80s_sedan1_red_destructible_mp" );
            	self IPrintLnBold( "Car" );

            self waittill( "weapon_change" );
            if ( self GetStance() == "prone" )
            {
            	self setModel( "portal_cake" );
            	self IPrintLnBold( "Cake" );
            }

            self waittill( "weapon_change" );
            if ( self GetStance() == "prone" )
            {
            	self setModel( "portal_companion_cube" );
            	self IPrintLnBold( "Companion Cube" );
            }

            self waittill( "weapon_change" );
            if ( self GetStance() == "prone" )
            {
            	self setModel( "sphere_dist" );
            	self IPrintLnBold( "Sphere" );
            }
        }

        wait 1;
    }
}

trail_fx_mm()
{
	wait 1;
	PlayFXOnTag( level.trail_gloaming_mm, self.tag, "tag_origin" );
}