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

	+MAPPER:	#xoxor4d // www.bouncepatch.com 	+ORGMAP: 	 juxtapo
	+MAPNAME:			surf_ace					+CONSOLE-NAME: mp_surf_ace
	+GAMETYPES:				surf 					+DIFFICULTY:		easy

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

		player setClientDvars( "r_dof_tweak", 1 );
		player setClientDvars( "r_dof_bias", 0.5 );
		player setClientDvars( "r_dof_farblur", 1 );
		player setClientDvars( "r_dof_farstart", 2000 );
		player setClientDvars( "r_dof_farend", 7000 );
		player setClientDvars( "r_dof_nearstart", 0 );
		player setClientDvars( "r_dof_nearend", 0 );

		player setClientDvars( "r_filmusetweaks", 1 );
		player setClientDvars( "r_filmtweakenable", 1 );
		player setClientDvars( "r_filmtweakdarktint", "1.3 1.1 1.5" );
		player setClientDvars( "r_filmtweaklighttint", "1.5 2 2" );
		player setClientDvars( "r_filmtweakcontrast", 1 );
		player setClientDvars( "r_filmtweakdesaturation", 0 );


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

				if( !isdefined( player.acc_mm ) )
				{
					player.acc_mm = true;
					player IPrintLnBold( "Welcome XOXO!" );
					Earthquake( 1.3, 2, player.origin, 3000 );
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