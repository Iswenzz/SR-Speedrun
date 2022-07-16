/*
##############################################################################################
###|   _____   |######/    \#######|  |###|   _______|###|  |#######|  |###|  |######|  |#####
###|  |#####|  |#####/  __  \######|  |###|  |###########|  |#######|  |###|  |######|  |#####
###|  |#####|  |####/  /##\  \#####|  |###|  |###########|  |#######|  |###|  |######|  |#####
###|  |#####|  |###|  |####|  |####|  |###|  |###########|  |#######|  |###|  |######|  |#####
###|  |####/  /####|  |####|  |####|  |###|  |###########|  |#######|  |###|  |######|  |#####
###|  ___    /#####|  |####|  |####|  |###|  |###########|   _______   |###|  |######|  |#####
###|  |##\  \######|   ____   |####|  |###|  |###########|  |#######|  |###|  |######|  |#####
###|  |###\  \#####|  |####|  |####|  |###|  |###########|  |#######|  |###|  |######|  |#####
###|  |####\  \####|  |####|  |####|  |###|  |###########|  |#######|  |###|  |######|  |#####
###|__|#####\__|###|__|####|__|####|__|###|__________|###|__|#######|__|###|____________|#####
##############################################################################################

	Map created by: Raichu
	Xfire: hellovin
	Tested by: Raichu, Atggost, Nagyii
	Youtube channel: MetubeGames 
	Version: v1.1
	
	Coming soon: - Hard mode
				 - Jump room (like epicfail)
	
	If you find any bug please report it on xfire, thanks.
*/

#include maps\mp\_utility; /* necessary for simple trigger settings */
main()
{
	maps\mp\_load::main();
	
	/*Weapons*/
	precacheItem("ak47_mp");
	precacheItem("ak74u_mp");
	precacheItem("m4_mp");
	precacheitem("mp44_mp");
	precacheItem("winchester1200_mp");
	precacheItem("m1014_grip_mp");
	precacheItem("rpd_mp");
	precacheItem("p90_silencer_mp");
	precacheItem("deserteaglegold_mp");
	precacheItem("skorpion_mp");
	precacheitem("uzi_silencer_mp");
	precacheItem("rpg_mp");
	/*Snipers*/
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","2200");

		thread control();
}

	control()
	{

        thread way_connect();


		/*Some brush and trigger controll*/
		thread begin_door();
		// thread floor();
		//thread bounce_weapon_trig();
		//thread speedrun_weapon_trig();
		//thread sniper_freeze_trig();
		thread end_trig();
		//thread end_move();
		
		
		
		
		/*Final rooms*/
		//thread old();
		//thread weapons();
		//thread rand_weapons();
		//thread bounce();
		//thread sniper();
		//thread knife();
		//thread paper_scissors_rock();
		//thread speedrun();
		
		/*Secret*/
		//thread secret();
		//thread secret_end();
		//thread secret_weapon();
		//thread secret_music();
		//thread secret_lift_a();
		//thread secret_lift_b();
		//thread secret_fail();
		
		
		level waittill ("round_ended");
		AmbientStop();
	}

	way_connect()
{
    wait 0.05;
    
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
    for(;;) 
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
	
	
	
	
	
	begin_door()
	{
		trig = getEnt ("begin_door_trig","targetname");
		door = getEnt ("begin_door","targetname");
		door_activator = getEnt ("begin_door_activator","targetname");
		
		trig waittill ("trigger");
		trig delete();
		
		
		thread doormove( door_activator , 4 );
		thread doormove( door , 5 );
		
		wait 1;
		iPrintLnBold("^4Map created by: ^3Raichu");
		wait 1;
		iPrintLnBold("^4Have fun!");
	}
	
	doormove( door , time )
	{
		door moveZ (-244,time);
	}

	floor()
	{
		thread floor1();
		thread floor2();
		thread floor3();
		thread floor4();
	}
	
	floor1()
	{
		floor_a = getEnt ("floor_lift_a","targetname");
		while(1)
		{
			floor_a moveX (256,2); floor_a waittill("movedone");
			floor_a moveY (-256,2); floor_a waittill("movedone");
			floor_a moveX (-256,2); floor_a waittill("movedone");
			floor_a moveY (256,2); floor_a waittill("movedone");
		}
	}
	
	floor2()
	{
		floor_b = getEnt ("floor_lift_b","targetname");
		while(1)
		{
			floor_b moveY (-256,2); floor_b waittill("movedone");
			floor_b moveX (-256,2); floor_b waittill("movedone");
			floor_b moveY (256,2); floor_b waittill("movedone");
			floor_b moveX (256,2); floor_b waittill("movedone");
		}
	}
	
	floor3()
	{
		floor_c = getEnt ("floor_lift_c","targetname");
		while(1)
		{
			floor_c moveX (-256,2); floor_c waittill("movedone");
			floor_c moveY (256,2); floor_c waittill("movedone");
			floor_c moveX (256,2); floor_c waittill("movedone");
			floor_c moveY (-256,2); floor_c waittill("movedone");
		}
	}
	
	
	floor4()
	{
		floor_d = getEnt ("floor_lift_d","targetname");
		while(1)
		{
			floor_d moveY (256,2); floor_d waittill("movedone");
			floor_d moveX (256,2); floor_d waittill("movedone");
			floor_d moveY (-256,2); floor_d waittill("movedone");
			floor_d moveX (-256,2); floor_d waittill("movedone");
		}
	}
	
	GetActivator()
	{
		players = getentarray( "player", "classname" );
		for( i = 0 ; i < players.size ; i++)
		{
			player = players[i];
			if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis")
			return player;
		}
		return "Noactivator";
	}
	
	waitdead()
	{
		speedrun = getEnt("speedrun","targetname");
		weapons = getEnt("weapons","targetname");
		r_weapons = getEnt("rand_weap","targetname");
		bounce = getEnt("bounce","targetname");
		sniper = getEnt("sniper","targetname");
		knife = getEnt("knife","targetname");
		old = getEnt("old_trig","targetname");
		p_s_r = getEnt("paper_scissors_rock","targetname");
		trap01 = getEnt("trap1_trig","targetname");
		trap02 = getEnt("trap2_trig","targetname");
		trap03 = getEnt("trap3_trig","targetname");
		trap04 = getEnt("trap4_trig","targetname");
		trap05 = getEnt("trap5_trig","targetname");
		trap06 = getEnt("trap6_trig","targetname");
		trap07 = getEnt("trap7_trig","targetname");
		trap08 = getEnt("trap8_trig","targetname");
		trap09 = getEnt("trap9_trig","targetname");
		trap10 = getEnt("trap10_trig","targetname");
		trap11 = getEnt("trap11_trig","targetname");
		
		speedrun triggerOff();
		knife triggerOff();
		bounce triggerOff();
		sniper triggerOff();
		weapons triggerOff();
		r_weapons triggerOff();
		old triggerOff();
		p_s_r triggerOff();
		trap01 triggerOff();
		trap02 triggerOff();
		trap03 triggerOff();
		trap04 triggerOff();
		trap05 triggerOff();
		trap06 triggerOff();
		trap07 triggerOff();
		trap08 triggerOff();
		trap09 triggerOff();
		trap10 triggerOff();
		trap11 triggerOff();
		
		self common_scripts\utility::waittill_any("death","disconnect");
		activator = GetActivator();
		activator freezeControls(false);
		
		speedrun triggerOn();
		bounce triggerOn();
		sniper triggerOn();
		weapons triggerOn();
		r_weapons triggerOn();
		knife triggerOn();
		old triggerOn();
		p_s_r triggerOn();
		trap01 triggerOn();
		trap02 triggerOn();
		trap03 triggerOn();
		trap04 triggerOn();
		trap05 triggerOn();
		trap06 triggerOn();
		trap07 triggerOn();
		trap08 triggerOn();
		trap09 triggerOn();
		trap10 triggerOn();
		trap11 triggerOn();
	}
	
	waitdead_end()
	{
		trig = getEnt ("end_tele","targetname");		
		trig triggerOff();
		self common_scripts\utility::waittill_any("death","disconnect");
		activator = GetActivator();
		activator freezeControls(false);
		trig triggerOn();
	}
	
	old()
	{
		old = getent("old_trig","targetname");
		jumper = getent(old.target,"targetname");
		acti = getEnt(jumper.target,"targetname");
		while(1)
		{
			old waittill ("trigger",player);
			player thread waitdead();
			iPrintLnBold(player.name + " ^1 selected Classic way (OLD)!");
			activator = GetActivator();
			player setorigin(jumper.origin);
			player setPlayerAngles(jumper.angles);
			activator setorigin(acti.origin);
			activator setPlayerAngles(acti.angles);
		}
	}
	
	speedrun()
	{
		speedrun = getEnt("speedrun","targetname");
		jumper = getEnt(speedrun.target,"targetname");
		acti = getEnt(jumper.target,"targetname");
		
		while( 1 )
		{
			speedrun waittill ("trigger",player);
			player thread waitdead();
			iPrintLnBold(player.name + " ^1 selected Speedrun!");
			activator = GetActivator();
			player freezeControls(true);
			player setorigin(jumper.origin);
			player setPlayerAngles(jumper.angles);	
			activator freezeControls(true);
			activator setorigin(acti.origin);
			activator setPlayerAngles(acti.angles);
			player takeallweapons();
			activator takeallweapons();
			start_num_down(player,activator);
			activator giveweapon("tomahawk_mp");
			player giveweapon("tomahawk_mp");
			player freezeControls(false);
			activator freezeControls(false);
			player switchtoweapon("tomahawk_mp");
			activator switchtoweapon("tomahawk_mp");
		}
	}
	
	speedrun_weapon_trig()
	{
		weapon = getEnt("speedrun_weapon","targetname");
		while ( 1 )
		{
			weapon waittill ("trigger",faster);
			faster takeallweapons();
			faster giveweapon("ak74u_mp");
			faster switchtoweapon("ak74u_mp");
			iPrintLnBold(faster.name + " ^3Got a weapon!");
		}
	}
	
	rand_weapons()
	{
		weapons = getEnt("rand_weap","targetname");
		jumper = getEnt(weapons.target,"targetname");
		acti = getEnt(jumper.target,"targetname");
		weapon = "tomahawk_mp";
		while(1)
		{
			weapons waittill("trigger",player);
			player thread waitdead();
			iPrintLnBold(player.name + " ^1 selected Random-Weapons!");
			activator = GetActivator();
			
			r = randomintrange(1, 13);
			weap = strTok("tomahawk_mp;ak47_mp;ak74u_mp;m4_mp;mp44_mp;winchester1200_mp;m1014_grip_mp;rpd_mp;p90_silencer_mp;deserteaglegold_mp;skorpion_mp;uzi_silencer_mp;rpg_mp",";");
			weapon = weap[r];
		
			player freezeControls(true);
			player setorigin(jumper.origin);
			player setPlayerAngles(jumper.angles);
			activator freezeControls(true);
			activator setorigin(acti.origin);
			activator setPlayerAngles(acti.angles);
			player takeallweapons();
			activator takeallweapons();
			start_num_down(player,activator);
			player giveweapon(weapon);
			activator giveweapon(weapon);
			activator givemaxammo(weapon);
			player givemaxammo(weapon);
			wait .1;
			player switchtoweapon(weapon);
			activator switchtoweapon(weapon);
			player freezeControls(false);
			activator freezeControls(false);
		}
	}
	
	weapons()
	{
		weapons = getent("weapons","targetname");
		jumper = getent(weapons.target,"targetname");
		acti = getent(jumper.target,"targetname");

		weapon = "tomahawk_mp";
		level.weapon_pointer = 0;
		
		while( 1 )
		{
			weapons waittill("trigger",player);
			player thread waitdead();
			iPrintLnBold(player.name + " ^1 selected Weapons!");
			activator = GetActivator();
			
			if (level.weapon_pointer != 1)
				weapon = player select(weapons,player,activator);
			
			player freezeControls(true);
			player setorigin(jumper.origin);
			player setPlayerAngles(jumper.angles);
			activator freezeControls(true);
			activator setorigin(acti.origin);
			activator setPlayerAngles(acti.angles);
			player takeallweapons();
			activator takeallweapons();
			start_num_down(player,activator);
			player giveweapon(weapon);
			activator giveweapon(weapon);
			activator givemaxammo(weapon);
			player givemaxammo(weapon);
			wait .1;
			player switchtoweapon(weapon);
			activator switchtoweapon(weapon);
			player freezeControls(false);
			activator freezeControls(false);
		}
	}
	
	select(weapons,player,activator)
	{
		self endon("round_ended");
		self endon("death");
		self endon("disconected");
		
		weapons triggerOn();
		weapons SetHintString("Press ^1F^7 -> Choose Buttons: ^1Granade^7, ^1Shoot^7 -> Select: ^1Knife");
		
		weap = strTok("tomahawk_mp;ak47_mp;ak74u_mp;m4_mp;mp44_mp;winchester1200_mp;m1014_grip_mp;rpd_mp;p90_silencer_mp;deserteaglegold_mp;skorpion_mp;uzi_silencer_mp;rpg_mp;tomahawk_mp",";");
		weapname = strTok("TomaHawk;AK-47;AK74-U;M4;MP44;Winchester1200;M1014(grip);RPD;P90(silencer);DesertEagleGold;Skorpion;UZI(silencer);RPG;TomaHawk",";");
		
		w = 1;
		
		while ( level.weapon_pointer != 1 )
		{
			if ( player AttackButtonPressed() && player istouching( weapons ) )
			{
				w++;
				if ( w == 14 ) w = 1;
				player iPrintLnBold(weapname[w]);
				activator iPrintLnBold(weapname[w]);
			}
			if( player FragButtonPressed() && player istouching( weapons ) )
			{
				w--;
				if ( w == 0 ) w = 13;
				player iPrintLnBold(weapname[w]);
				activator iPrintLnBold(weapname[w]);
			}
			if (player MeleeButtonPressed() && player istouching( weapons ) )
			{
				level.weapon_pointer = 1;
			}
			wait .1;
		}
		iPrintLnBold(player.name + " ^1 selected ^3" + weapname[w] + "^1 fight!");
		weapons triggerOff();
		weapons SetHintString("Weapons room: ^1" + weapname[w]);
		return weap[w];
	}
	
	bounce()
	{
		bounce = getent("bounce","targetname");
		jumper = getent(bounce.target,"targetname");
		acti = getent(jumper.target,"targetname");
		while(1)
		{
			bounce waittill("trigger",player);
			player thread waitdead();
			iPrintLnBold(player.name + " ^1 selected Bounce!");
			activator = GetActivator();
			
			player freezeControls(true);
			player setorigin(jumper.origin);
			player setPlayerAngles(jumper.angles);
			
			activator freezeControls(true);
			activator setorigin(acti.origin);
			activator setPlayerAngles(acti.angles);
			
			player takeallweapons();
			activator takeallweapons();
			
			start_num_down(player,activator);
			
			activator giveweapon("tomahawk_mp");
			player giveweapon("tomahawk_mp");
			
			player freezeControls(false);
			activator freezeControls(false);
			
			player switchtoweapon("tomahawk_mp");
			activator switchtoweapon("tomahawk_mp");
			
			level.bounce_jumper = 1;
			level.bounce_activator = 1;
			thread bounce_fail(player,activator);
		}
	}
	
	bounce_weapon_trig()
	{	
		get_weapon_trigger = getEnt("bounce_weapon","targetname");
		while(1)
		{
			get_weapon_trigger waittill ("trigger",pro_jumper);
			pro_jumper takeallweapons();
			pro_jumper giveweapon("remington700_mp");
			pro_jumper switchtoweapon("remington700_mp");
			iPrintLnBold(pro_jumper.name + " ^3Got a sniper!");
		}
	}
	
	bounce_fail(jumper,activator)
	{
		self endon("round_ended");
		self endon("death");
		self endon("disconected");
		
		fail = getEnt ("bounce_fail_trig","targetname");
		jumper_to = getEnt (fail.target,"targetname");
		activator_to = getEnt (jumper_to.target,"targetname");
		jumper_low = getEnt (activator_to.target,"targetname");
		activator_low = getEnt (jumper_low.target,"targetname");
		
		once_knife = 0;
		once_acti_low = 0;
		once_jumper_low = 0;
		
		while ( 1 )
		{
			fail waittill ("trigger",player);
			if ( player == jumper )
			{
				jumper setorigin(jumper_to.origin);
				jumper setPlayerAngles(jumper_to.angles);
				jumper iPrintLnBold("^1You fail: ^3" + level.bounce_jumper + "/20");
				level.bounce_jumper++;
				if ( level.bounce_jumper == 21 )
				{
					jumper setorigin(jumper_low.origin);
					jumper setPlayerAngles(jumper_low.angles);
					jumper freezeControls(true);
				}
			}
			if ( player == activator )
			{
				activator setorigin(activator_to.origin);
				activator setPlayerAngles(activator_to.angles);
				activator iPrintLnBold("^1You fail: ^3" + level.bounce_activator + "/20");
				level.bounce_activator++;
				if ( level.bounce_activator == 21 )
				{
					activator setorigin(activator_low.origin);
					activator setPlayerAngles(activator_low.angles);
					activator freezeControls(true);
				}
			}
			if ( level.bounce_activator == 21 && once_acti_low == 0 )
			{
				once_acti_low = 1;
				player iPrintLnBold ("^1Go, Go, Go, activator now can't move!!!");
			}
			if ( level.bounce_jumper == 21 && level.bounce_activator < 21 && once_jumper_low == 0)
			{
				once_jumper_low = 1;
				activator iPrintLnBold ("^1Your current enemy is too low, he will die within 5 sec!");
				wait 5;
				player suicide();
			}
			if ( once_knife == 0 && level.bounce_jumper == 21 && level.bounce_activator == 21 )
			{
				once_knife = 1;
				knife_pointer = 1;
				player iPrintLnBold("^3Why choose bounce room if you didn't finish it?!?!");
				iPrintLnBold(activator.name + " ^1and " + player.name + "^1 are too low for bounce room!");
				knife = getent("knife","targetname");
				jumper_knife = getent(knife.target,"targetname");
				acti_knife = getent(jumper_knife.target,"targetname");

				player thread waitdead();
				iPrintLnBold(player.name + " ^1 selected Knife!");
				activator = GetActivator();
				player freezeControls(true);
				player setorigin(jumper_knife.origin);
				player setPlayerAngles(jumper_knife.angles);
					
				activator freezeControls(true);
				activator setorigin(acti_knife.origin);
				activator setPlayerAngles(acti_knife.angles);
				
				player takeallweapons();
				activator takeallweapons();
				
				start_num_down(player,activator);
				
				activator giveweapon("tomahawk_mp");
				player giveweapon("tomahawk_mp");
				
				player freezeControls(false);
				activator freezeControls(false);
				player switchtoweapon("tomahawk_mp");
				activator switchtoweapon("tomahawk_mp");
			}
			wait .1;
		}
	}
	
	start_num_down(player,activator)
	{
		player iPrintLnBold("^13");
		activator iPrintLnBold("^13");
		wait 1;
		player iPrintLnBold("^12");
		activator iPrintLnBold("^12");
		wait 1;
		player iPrintLnBold("^11");
		activator iPrintLnBold("^11");
		wait 1;
		player iPrintLnBold("^2Fight!!!.");
		activator iPrintLnBold("^2Fight!!!.");
	}
	
	sniper()
	{
		sniper = getent("sniper","targetname");
		jumper = getent(sniper.target,"targetname");
		acti = getent(jumper.target,"targetname");
		while(1)
		{
			sniper waittill("trigger",player);
			player thread waitdead();
			iPrintLnBold(player.name + " ^1 selected Sniper!");
			activator = GetActivator();
			
			player freezeControls(true);
			player setorigin(jumper.origin);
			player setPlayerAngles(jumper.angles);
				
			activator freezeControls(true);
			activator setorigin(acti.origin);
			activator setPlayerAngles(acti.angles);
			
			player takeallweapons();
			activator takeallweapons();
			
			start_num_down(player,activator);

			player giveweapon("m40a3_mp");
			activator giveweapon("m40a3_mp");
			player giveweapon("remington700_mp");
			activator giveweapon("remington700_mp");	
			
			activator givemaxammo("m40a3_mp");
			player givemaxammo("m40a3_mp");
			activator givemaxammo("remington700_mp");
			player givemaxammo("remington700_mp");
			wait .1;
			player switchtoweapon("m40a3_mp");
			activator switchtoweapon("m40a3_mp");
			
			player freezeControls(false);
			activator freezeControls(false);
		}
	}
	
	sniper_freeze_trig()
	{
		fail = getEnt("sniper_fail","targetname");
		fail_on = getEnt(fail.target,"targetname");
		fail_off = getEnt(fail_on.target,"targetname");
		
		while ( 1 )
		{
			fail waittill ("trigger", low);
			low freezeControls(true);
			low setorigin(fail_on.origin);
			low setPlayerAngles(fail_on.angles);
			low iPrintLnBold ("^4Wait 3 seconds!");
			wait 3;
			low setorigin(fail_off.origin);
			low setPlayerAngles(fail_on.angles);
			low iPrintLnBold ("^4You can move again!");
			low freezeControls(false);
		}
	}
	
	knife()
	{
		knife = getent("knife","targetname");
		jumper = getent(knife.target,"targetname");
		acti = getent(jumper.target,"targetname");
		while(1)
		{
			knife waittill("trigger",player);
			player thread waitdead();
			iPrintLnBold(player.name + " ^1 selected Knife!");
			activator = GetActivator();
			player freezeControls(true);
			player setorigin(jumper.origin);
			player setPlayerAngles(jumper.angles);	
			activator freezeControls(true);
			activator setorigin(acti.origin);
			activator setPlayerAngles(acti.angles);
			player takeallweapons();
			activator takeallweapons();
			start_num_down(player,activator);
			activator giveweapon("tomahawk_mp");
			player giveweapon("tomahawk_mp");
			player freezeControls(false);
			activator freezeControls(false);
			player switchtoweapon("tomahawk_mp");
			activator switchtoweapon("tomahawk_mp");
		}
	}
	
	paper_scissors_rock()
	{
		p_s_r = getent("paper_scissors_rock","targetname");
		jumper = getent(p_s_r.target,"targetname");
		acti = getent(jumper.target,"targetname");
		while(1)
		{
			p_s_r waittill("trigger",player);
			player thread waitdead();
			iPrintLnBold(player.name + " ^1 selected Paper-Scissors-Rock minigame!");
			activator = GetActivator();
			player freezeControls(true);
			player setorigin(jumper.origin);
			player setPlayerAngles(jumper.angles);	
			activator freezeControls(true);
			activator setorigin(acti.origin);
			activator setPlayerAngles(acti.angles);
			player takeallweapons();
			activator takeallweapons();
			start_num_down(player,activator);
			activator giveweapon("tomahawk_mp");
			player giveweapon("tomahawk_mp");
			player freezeControls(false);
			activator freezeControls(false);
			player switchtoweapon("tomahawk_mp");
			activator switchtoweapon("tomahawk_mp");
			
			thread p_s_r_minigame(player,activator,jumper,acti);
		}
	}

	p_s_r_minigame(player,activator,jumper,acti)
	{
		player endon("round_ended");
		player endon("death");
		player endon("disconected");
		
		activator endon("round_ended");
		activator endon("death");
		activator endon("disconected");
		
		/*
		1 - Paper
		2 - Scissors
		3 - Rock
		*/
		
		once_p_s_r = 0;
		get_weapon_acti = 0;
		get_weapon_jumper = 0;
		
		while( get_weapon_acti != 1 && get_weapon_jumper != 1 )
		{
			if ( once_p_s_r == 0 )
			{
				once_p_s_r = 1;
				level.p_s_r_p = 0;
				level.p_s_r_a = 0;
	
				player thread player_answer();
				activator thread activator_answer();
			}
			else if ( (level.p_s_r_p == 1 && level.p_s_r_a == 1) || (level.p_s_r_p == 2 && level.p_s_r_a == 2) || (level.p_s_r_p == 3 && level.p_s_r_a == 3) )
			{
				player iPrintlnBold("^2It's Draw! Try again");
				activator iPrintlnBold("^2It's Draw! Try again");
				
				level.p_s_r_p = 0;
				level.p_s_r_a = 0;
				get_weapon_acti = 0;
				get_weapon_jumper = 0;
				
				player thread player_answer();
				activator thread activator_answer();
			}
			else if ( ((level.p_s_r_p == 1  && level.p_s_r_a == 3) || (level.p_s_r_p == 2 && level.p_s_r_a == 1) || (level.p_s_r_p == 3 && level.p_s_r_a == 2)) && get_weapon_jumper == 0 )
			{
				get_weapon_jumper = 1;
				activator iPrintlnBold(player.name + "^1 win, prepare for the death!");
				player iPrintlnBold("^3You win!");
				player takeallweapons();
				player giveweapon("ak74u_mp");
				player switchtoweapon("ak74u_mp");
				
				activator freezeControls(true);
				activator setorigin(jumper.origin);
				activator setPlayerAngles(jumper.angles);
			}
			else if ( ((level.p_s_r_a == 1  && level.p_s_r_p == 3) || (level.p_s_r_a == 2 && level.p_s_r_p == 1) || (level.p_s_r_a == 3 && level.p_s_r_p == 2)) && get_weapon_acti == 0 )
			{
				get_weapon_acti = 1;
				player iPrintlnBold(activator.name + "^1 win, prepare for the death!");
				activator iPrintlnBold("^3You win!");
				activator takeallweapons();
				activator giveweapon("ak74u_mp");
				activator switchtoweapon("ak74u_mp");
				
				player freezeControls(true);
				player setorigin(acti.origin);
				player setPlayerAngles(acti.angles);
			}
			else wait .1;
		wait .1;
		}
	}
	
	player_answer()
	{
		self endon("round_ended");
		self endon("death");
		self endon("disconected");
		
		p = getEnt("paper_jumper","targetname");
		s = getEnt("scissors_jumper","targetname");
		r = getEnt("rock_jumper","targetname");
		
		while(1)
		{
			if ( self IsTouching(p) && self UseButtonPressed() )
			{
				self iPrintLnBold("^2You selected Paper!");
				level.p_s_r_p = 1;
				return;
			}
			if ( self IsTouching(s) && self UseButtonPressed() )
			{
				self iPrintLnBold("^2You selected Scissors!");
				level.p_s_r_p = 2;
				return;
			}
			if ( self IsTouching(r) && self UseButtonPressed() )
			{
				self iPrintLnBold("^2You selected Rock!");
				level.p_s_r_p = 3;
				return;
			}
			wait .1;
		}
	}
	
	activator_answer()
	{
		self endon("round_ended");
		self endon("death");
		self endon("disconected");
		
		p = getEnt("paper_activator","targetname");
		s = getEnt("scissors_activator","targetname");
		r = getEnt("rock_activator","targetname");
		
		while (1)
		{
			if ( self IsTouching(p) && self UseButtonPressed() )
			{
				self iPrintLnBold("^2You selected Paper!");
				level.p_s_r_a = 1;
				return;
			}
			if ( self IsTouching(s) && self UseButtonPressed() )
			{
				self iPrintLnBold("^2You selected Scissors!");
				level.p_s_r_a = 2;
				return;
			}
			if ( self IsTouching(r) && self UseButtonPressed() )
			{
				self iPrintLnBold("^2You selected Rock!");
				level.p_s_r_a = 3;
				return;
			}
			wait .1;
		}
	}
	
	end_move()
	{
		trig = getEnt ("end_tele","targetname");
		jumper = getent(trig.target,"targetname");
		while(1)
		{
			trig waittill ("trigger",player);
			player thread waitdead_end();
			player setorigin(jumper.origin);
		}
	}
	
	trap1()
	{
		level endon("traps_disabled");
		trig = getEnt ("trap1_trig","targetname");
		trap = getEnt ("trap1","targetname");
		trig waittill ("trigger");
		
	}

	trap2()
	{
		level endon("traps_disabled");
		trig = getEnt ("trap2_trig","targetname");
		trap1 = getEnt ("trap2_a","targetname");	
		trap2 = getEnt ("trap2_b","targetname");
		trig waittill ("trigger");
		
	}

	trap3()
	{
		level endon("traps_disabled");
		trig = getEnt ("trap3_trig","targetname");
		trig waittill ("trigger");
		
	}
	
	trap3_b()
	{
		trap = getEnt ("bounce_trap3","targetname");
		trap moveX (115,1);
		wait 1;
		while(1)
		{
			trap moveX(-230,2);
			trap waittill("movedone");
			
			trap waittill("movedone");
			
	}
}

end_trig()
	{
		trig = getEnt ("endmap_trig","targetname");
		while(1)
		{
			trig waittill("trigger",player);
			if( !player.end == 1) 
			{
				player.end = 1;
				iPrintLn(player.name + " ^4reached the final door! ^3Congrat!");
			}
			wait .1;
		}
	}


	
	
	
	