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
	sr\api\_map::surf();

	thread sr\api\_map::createSpawn((9551, 15823, 7964), 0);
	thread sr\api\_map::swapTargetname("trigger_endmap", "endmap_trig");
	thread sr\api\_speedrun::createNormalWays("Normal Way; T1; T2; T3;");
	thread sr\api\_speedrun::createSecretWays("T4; T5; T6;");

	thread sr\api\_speedrun::createTeleporterToEntity((9698, 15505, 7964), 100, 150, "nyro_t1", "target", 0, "none", "blue", "normal_1");
	thread sr\api\_speedrun::createTeleporterToEntity((9493, 15505, 7964), 100, 150, "nyro_t2", "target", 0, "none", "green", "normal_2");
	thread sr\api\_speedrun::createTeleporterToEntity((9309, 15505, 7964), 100, 150, "nyro_t3", "target", 0, "none", "yellow", "normal_3");
	thread sr\api\_speedrun::createTeleporterToEntity((9698, 16130, 7964), 100, 150, "nyro_t4", "target", 0, "none", "orange", "secret_0");
	thread sr\api\_speedrun::createTeleporterToEntity((9493, 16130, 7964), 100, 150, "nyro_t5", "target", 0, "none", "red", "secret_1");
	thread sr\api\_speedrun::createTeleporterToEntity((9309, 16130, 7964), 100, 150, "nyro_t6", "target", 0, "none", "purple", "secret_2");

	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro2n", "target", 0, "normal_1");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro2s", "target", 0, "normal_1");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro3n", "target", 0, "normal_2");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro3s", "target", 0, "normal_2");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro4n", "target", 0, "normal_3");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro4s", "target", 0, "normal_3");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro5n", "target", 0, "secret_0");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro5s", "target", 0, "secret_0");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro6n", "target", 0, "secret_1");
	thread sr\api\_speedrun::createEndMapFromEntity("start_nyro6s", "target", 0, "secret_1");
	thread sr\api\_speedrun::createEndMapFromEntity("ending_core_tele_dest", "target", 0, "secret_2");
	thread sr\api\_speedrun::createEndMapFromEntity("ending_core_tele_dest", "target", 1, "secret_2");

	// FX ++
	level.spawn_geotrail_fx						= loadFx( "trails/fx_trail_pink" );
	level.trail_gloaming_mm						= loadFx( "trails/fx_trail_pink" );
	level.tess_flare							= loadFx( "surf/omni_flare" );
	level.lFX									= loadFx( "omni_light_cull" );
	level.map_creator							= loadFx( "omni_rot_sq" );
	//omni_rot_sq

	// PRECACHE ++
	preCacheModel ( "tag_origin" );
	preCacheModel ( "mapcreator" );

	// SURF ++
	level.surfDifficulty = "hard";
	level.creatorname = "#xoxo^2r4d";

	thread watchSpawn();

	// MAP SETUP ++
	thread spawn_logo();
	thread end_rotate();
	thread custom_tps();
	thread stg10_boost01();
	thread stg10_boost02();
	thread stg16plusY();
	thread stg16minusY();
	thread stg17();

	ambientPlay( "ambient" );

	ent_tesseract = getEntArray( "tesseract", "targetname" );
		for( i = 0; i < ent_tesseract.size; i++ )
			ent_tesseract[i] thread tesseract();

	ent_tp_trans = getEntArray( "tp_trans", "targetname" );
		for( i = 0; i < ent_tp_trans.size; i++ )
			ent_tp_trans[i] thread transition_tps();

	ent_tp_neg_z = getEntArray( "neg_z_vel_booster", "targetname" );
		for( i = 0; i < ent_tp_neg_z.size; i++ )
			ent_tp_neg_z[i] thread minus_z_booster();

	ent_speed = getEntArray( "trig_speed", "targetname" ); // 1.2
		for( i = 0; i < ent_speed.size; i++ )
			ent_speed[i] thread speedScale();

	ent_speedZ = getEntArray( "trig_speedZ", "targetname" ); // 1.2
		for( i = 0; i < ent_speedZ.size; i++ )
			ent_speedZ[i] thread speedScaleZ();

	stg16_booster01 = getEntArray( "stg16_zbooster01", "targetname" ); // 1.2
		for( i = 0; i < stg16_booster01.size; i++ )
			stg16_booster01[i] thread stg16_z01();

	stg16_yPlusBoost = getEntArray( "stg16_plusYboost", "targetname" );
		for( i = 0; i < stg16_yPlusBoost.size; i++ )
			stg16_yPlusBoost[i] thread stg16plusY();

	stg16_yMinusBoost = getEntArray( "stg16_minusYboost", "targetname" );
		for( i = 0; i < stg16_yMinusBoost.size; i++ )
			stg16_yMinusBoost[i] thread stg16minusY();

	///////////////////////////////////////////////////
}

spawn_logo()
{
	logo1 = getent( "spawn_logo01", "targetname" );
	logo2 = getent( "spawn_logo02", "targetname" );
	logo3 = getent( "spawn_logo03", "targetname" );
	logo4 = getent( "spawn_logo04", "targetname" );

	while( 1 )
	{
		logo1 RotateYaw( 360, 20 );
		logo2 RotateYaw( 360, 20 );
		logo3 RotateYaw( 360, 20 );
		logo4 RotateYaw( 360, 20 );

		wait 19.95; // remove delay of waittill movedone
	}
}

end_rotate()
{
	end01 = getent( "end1_l", "targetname" );	end02 = getent( "end2_r", "targetname" );
	end03 = getent( "end3_l", "targetname" );	end04 = getent( "end4_r", "targetname" );
	end05 = getent( "end5_l", "targetname" );	end06 = getent( "end6_r", "targetname" );
	end07 = getent( "end7_l", "targetname" );	end08 = getent( "end8_r", "targetname" );
	end09 = getent( "end9_l", "targetname" );	end10 = getent( "end10_r", "targetname" );

	while( 1 )
	{
		end01 RotateYaw( -360, 10 );	end03 RotateYaw( -360, 10 );
		end05 RotateYaw( -360, 10 );	end07 RotateYaw( -360, 10 );
		end09 RotateYaw( -360, 10 );

		end02 RotateYaw( 360, 10 );		end04 RotateYaw( 360, 10 );
		end06 RotateYaw( 360, 10 );		end08 RotateYaw( 360, 10 );
		end10 RotateYaw( 360, 10 );

		wait 9.95; // remove delay of waittill movedone
	}
}

stg16plusY()
{
	y_vel = 2800;

	while( 1 )
	{
		self waittill( "trigger", player );
		orgVel = player GetVelocity();

		if( ( orgVel[1] > 2000 ) && orgVel[1] < y_vel )
			player setVelocity( ( orgVel[0], y_vel, orgVel[2] ) );

		wait 1;
	}
}

stg16minusY()
{
	y_vel = -2800;

	while( 1 )
	{
		self waittill( "trigger", player );
		orgVel = player GetVelocity();

		if( ( orgVel[1] < -2000 ) && orgVel[1] > y_vel )
			player setVelocity( ( orgVel[0], y_vel, orgVel[2] ) );

		wait 1;
	}
}

watchSpawn()
{
	while(1)
	{
		level waittill( "player_spawn", player );

		player setClientDvars( "r_dof_tweak", 1 );
		player setClientDvars( "r_dof_viewmodelend", 12 );
		player setClientDvars( "r_dof_farblur", 0.3 );
		player setClientDvars( "r_dof_farstart", 700 );
		player setClientDvars( "r_dof_farend", 7000 );
		player setClientDvars( "r_dof_bias", 0.5 );

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
	PlayFXOnTag( level.map_creator, self.tag, "tag_origin" );
}

helpingHand()
{
	self endon( "disconnect" );

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

/*

// "Drawing" trails on scripted ents doesnt seem to work -> ref. airstrike killstreak.
// would make a nice start & endzone effect

spawn_geotrail()
{
	lf = getent( "spawn_geotrail_lf", "targetname" );
	rt = getent( "spawn_geotrail_rt", "targetname" );

	temp = spawn(  "script_model", rt.origin + ( 0, 0, 10 ) );
	temp.angles = ( 0, -90, 0 );
	temp   setModel( "tag_origin" );

	wait 1;
	PlayFXOnTag( level.spawn_geotrail_fx, temp, "tag_origin" );

	temp thread play_temp_fx();

	while( 1 )
	{
		temp MoveTo( lf.origin, 2, 0.5, 0.5 );
		wait 2.5;
		//IPrintLn( "Temp Trails @ " + temp.origin );

		temp MoveTo( rt.origin, 2, 0.5, 0.5 );
		wait 2.5;
		//IPrintLn( "Temp Trails @ " + temp.origin );
	}
}
*/

/*
play_temp_fx()
{
	while(1)
	{
		if( isdefined( self ) )
		{
			PlayFX( level.map_creator, self.origin );
			wait 0.1;
		}

		else
			wait 1;
	}
}
*/

speedScale()
{
	speed_multi = ( 1.2, 1.2, 1.2 );

	while( 1 )
	{
		self waittill( "trigger", player );
		player setVelocity( player getVelocity() * speed_multi );

		wait 1;
	}
}

speedScaleZ()
{
	speed_multi = ( 1, 1, 1.2 );

	while( 1 )
	{
		self waittill( "trigger", player );
		player setVelocity( player getVelocity() * speed_multi );

		wait 1;
	}
}

stg16_z01()
{
	if( isdefined( self.target ) )
		z_vel = int( self.target );
	else
		z_vel = 1400;

	while( 1 )
	{
		self waittill( "trigger", player );
		orgVel = player GetVelocity();

		if( ( orgVel[2] > ( z_vel / 2 ) ) && orgVel[2] < z_vel )
			player setVelocity( ( orgVel[0], orgVel[1], z_vel ) );

		wait 1;
	}
}

stg17()
{
	trig = getent( "stg17_boost", "targetname" );
	z_vel = 1400;

	while( 1 )
	{
		trig waittill( "trigger", player );
		orgVel = player GetVelocity();

		if( orgVel[2] < z_vel && orgVel[2] > 0 )
			player setVelocity( ( orgVel[0], orgVel[1], z_vel ) );

		wait 1;
	}
}

stg10_boost01()
{
	boost01 = getent( "stg10_boost01", "targetname" );

	while( 1 )
	{
		boost01 waittill( "trigger", player );
		orgVel = player GetVelocity();

		player setVelocity( ( -2000, 0, 0 ) );
		wait 0.5;
	}
}

stg10_boost02()
{
	boost02 = getent( "stg10_boost02", "targetname" );

	while( 1 )
	{
		boost02 waittill( "trigger", player );
		orgVel = player GetVelocity();

		player setVelocity( ( -2600, 0, 1200 ) );
		wait 0.5;
	}
}

minus_z_booster()
{
	if( isdefined( self.target ) )
		min_z_vel = int( self.target );
	else
		min_z_vel = -1800;

	while( 1 )
	{
		self waittill( "trigger", player );
		orgVel = player GetVelocity();

		if( orgVel[2] > min_z_vel )
			player setVelocity( ( orgVel[0], orgVel[1], min_z_vel ) );

		wait 0.05;
	}
}

transition_tps()
{
	if( !isDefined( self.target ) )
		return;

	targets = getEntArray( self.target, "targetname" );

	if( targets.size == 0 )
		return;

	while( 1 )
	{
		self waittill( "trigger", player );

		if( !isDefined( player.inTransition ) )
			player.inTransition = false;

		if( isDefined( player.inTransition ) && player.inTransition )
		{
			wait 0.05;
			continue;
		}

		target = targets[ randomInt( targets.size ) ];

		player.inTransition = true;
		player thread whiteShader( target );

		wait .05;
	}
}

whiteShader( dest, custom_tp )
{
	self.trans_white 			= newClientHudElem( self );
	self.trans_white.x 			= 0;
	self.trans_white.y 			= 0;
	self.trans_white.alignX 	= "left";
	self.trans_white.alignY 	= "top";
	self.trans_white.horzAlign 	= "fullscreen";
	self.trans_white.vertAlign 	= "fullscreen";
	self.trans_white.alpha 		= 0;
	self.trans_white 			setshader("white", 640, 480);

	wait 0.05;

	if( !isdefined( dest ) )
		return;

	if( isDefined( self ) && !isdefined( custom_tp ) )
	{
		//self PlaySoundToPlayer( "riser", self );

		self.trans_white fadeOverTime( 0.15 );
		self.trans_white.alpha = 1;

		orgVel = self GetVelocity();

		wait 0.2;

		self setOrigin( dest.origin );
		self setPlayerAngles( dest.angles );
		self setVelocity( orgVel );

		if( isDefined( self ) )
		{
		 	self.trans_white fadeOverTime( 0.15 );
			self.trans_white.alpha = 0;

			wait 0.2;

			if( isDefined( self ) && isDefined( self.trans_white ) )
				self.trans_white destroy();

			self thread whiteShader_timeout( 2 );
		}
	}

	else if( isDefined( self ) && custom_tp == "tp_stg2" )
	{
		self.trans_white fadeOverTime( 0.15 );
		self.trans_white.alpha = 1;

		orgVel = self GetVelocity();

		wait 0.2;

		self setOrigin( dest.origin );
		self setPlayerAngles( ( 70, 0, 0 ) );

		if( orgVel[2] > -1337 )
			self setVelocity( ( 0, 0, -1337 ) );
		else
			self setVelocity( ( 0, 0, orgVel[2] ) );

		if( isDefined( self ) )
		{
		 	self.trans_white fadeOverTime( 0.15 );
			self.trans_white.alpha = 0;

			wait 0.2;

			if( isDefined( self ) && isDefined( self.trans_white ) )
				self.trans_white destroy();

			self thread whiteShader_timeout( 2 );
		}
	}
}

whiteShader_timeout( time )
{
	if( !isDefined( time ) )
		time = 2;

	wait time;

	if( isDefined( self ) )
		self.inTransition = false;
}

custom_tps()
{
	stg02_t 		= getent( "tp_stg02", "targetname" );
	stg05_m_t 		= getent( "tp_stg05_m", "targetname" );
	stg06_m_t 	 	= getent( "tp_stg06_m", "targetname" );
	stg06_02_m_t 	= getent( "tp_stg06_02_m", "targetname" );
	stg08_t 		= getent( "tp_stg08", "targetname" );

	stg02_t thread tp_stg2();

	stg05_m_t thread velo_teleport_relative();
	stg06_m_t thread velo_teleport_relative();
	stg06_02_m_t thread velo_teleport_relative();
	stg08_t thread velo_teleport_relative();
}

velo_teleport_relative()
{
	target 	= getEnt( self.target, "targetname" );

	while(1)
	{
		self waittill( "trigger", player );

		p_pos = player.origin;
		tr_pos = self.origin;
		ta_pos = target.origin;

		rel_pos_to_target = (( ta_pos[0] + ( p_pos[0] - tr_pos[0] ) ), ( ta_pos[1] + ( p_pos[1] - tr_pos[1] ) ), ( ta_pos[2] + ( p_pos[2] - tr_pos[2] ) ));

		orgVel = player GetVelocity();
		player setOrigin( rel_pos_to_target );
		player setVelocity( orgVel );

		wait .05;
	}
}

tp_stg2()
{
	target 	= getEnt( self.target, "targetname" );

	while(1)
	{
		self waittill( "trigger", player );

		if( !isDefined( player.inTransition ) )
			player.inTransition = false;

		if( isDefined( player.inTransition ) && player.inTransition )
		{
			wait 0.05;
			continue;
		}

		player.inTransition = true;
		player thread whiteShader( target, "tp_stg2" );

		wait .05;
	}
}

velo_teleport()
{
	target 	= getEnt( self.target, "targetname" );

	while(1)
	{
		self waittill( "trigger", player );

		orgVel = player GetVelocity();
		player setOrigin( target.origin );
		player setVelocity( orgVel );

		wait .05;
	}
}

tesseract()
{
	org_pos = self.origin;

	//self.tag = spawn(  "script_model", self.origin + ( 0, 0, 40 ) ); // REMOVED DUE TO TOO MANY ENTS
	//self.tag   setModel( "tag_origin" );
	//self.tag   linkto( self );

	wait 0.5;

	//PlayFXOnTag( level.map_creator, self.tag, "tag_origin" );
	//PlayFX( level.tess_flare, self.origin );

	while( 1 )
	{
		PlayFX( level.tess_flare, org_pos );
		//PlayFXOnTag( level.tess_flare, self.tag, "tag_origin" );

		self RotateYaw( 180, 2.5 );
		self MoveZ( 20, 2.5, 0.5, 0.5 );
		wait 2.45;

		//PlayFXOnTag( level.tess_flare, self.tag, "tag_origin" );
		PlayFX( level.tess_flare, org_pos );
		self RotateYaw( 180, 2.5 );
		self MoveTo( org_pos, 2.5, 0.5, 0.5 );
		wait 2.45;
	}
}