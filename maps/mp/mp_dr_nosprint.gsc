main()
{
	maps\mp\_load::main();
	// thread maps\saveload::main();
	
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

	thread sr\api\_map::createSpawn((480,448, 60), 180);
    thread sr\api\_speedrun::createNormalWays("Normal Way");

	trigger = getent("ladder_launch", "targetname");
	trigger thread upshaft_3();

	trigger = getent("upshaft", "targetname");
	trigger thread upshaft();

	sideslide = getent("sideslide", "targetname");
	sideslide thread sideslide();
	
	trigger2 = getent("upshaft_2", "targetname");
	trigger2 thread upshaft_2();

	secret_trigger = getent("secret_fail", "targetname");
	secret_org = getent(secret_trigger.target, "targetname");
	secret_trigger thread secret(secret_org);

    main_fall_trigger = getent("main_fall", "targetname");
	main_fall_org = getent(main_fall_trigger.target, "targetname");
	main_fall_trigger thread main_fall(main_fall_org);

	flipper = getent("flipper", "targetname");
	flipper.angles = (180,180,0);
	flipper.origin = getent(flipper.target, "targetname").origin;

	//old_enter = getent("old_enter", "targetname");
	//old_enter thread old_enter();

	//strafe_master_trigger = getent("strafe_master", "targetname");
	//strafe_master_trigger thread strafe_master();

	//finish_line = getent("endmap_trig", "targetname");
	//finish_line_tppos = getent(finish_line.target, "targetname");
	//finish_line thread finish_stagger(finish_line_tppos);
	
	level thread no_sprint_spam();
}

strafe_master() {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.jkaofjnlajkgnlsad)) {
			player.jkaofjnlajkgnlsad = true;
			//iprintln("^3" + player.name + " ^7Is Pretty Good At Strafing");
			//player braxi\_rank::giveRankXP("", 600);
		}
	}
}

no_sprint_spam() {
	for(;;) {
		wait 0.05;
        
        players = getEntArray( "player", "classname" );
        for(i=0;i<players.size;i++) {
            players[i] AllowSprint(false);
        }
	}
}

secret(secret_org) {
	for(;;) {
		self waittill("trigger", player);
		player Suicide();
	}
}

main_fall(main_fall_org) {
    for(;;) {
        self waittill("trigger", player);
        player Suicide();
    }
}

player_reset_deathcount_die() {
    self endon("disconnect");
    self waittill("death");
    self.deathcount_nosprint = undefined;
}

finish_stagger(target_pos) {
	for(;;) {
		self waittill("trigger", player);
		player setvelocity((0,0,0));
		player setorigin(target_pos.origin);
        player TakeAllWeapons();
        player giveweapon("knife_mp");
        player switchtoweapon("knife_mp");
		wait 1.5;
	}
}

old_enter() {
	for(;;) {
		self waittill("trigger", player);
		if(player getvelocity()[2] > 15 && !isdefined(player.dafvdsbxhdbd)){
			player.dafvdsbxhdbd = true;
			player thread old_enter_maintain(self);
		}
	}
}

old_enter_maintain(trigger) {
	self endon("disconnect");

	vel = self GetVelocity();
	self setvelocity((vel[0], vel[1], 600));

	while(self istouching(trigger)) {
		wait 0.1;
	}
	self.dafvdsbxhdbd = undefined;
}

upshaft_2() {
	for(;;) {
		self waittill("trigger",player);
		if(!isdefined(player.gsdgsdfgbdfbvs)) {
			player.gsdgsdfgbdfbvs = true;
			player thread upshaft_maintain_2(self, player getvelocity()[2]);
		}
	}
}

upshaft_maintain_2(trigger, two_vel) {
	self endon("disconnect");

	while(self istouching(trigger)) {
		velocity = self getvelocity();
		self SetVelocity((velocity[0], velocity[1], two_vel));
		wait 0.05;
	}
	self.gsdgsdfgbdfbvs = undefined;
}

upshaft() {
	for(;;) {
		self waittill("trigger",player);
		if(!isdefined(player.gsdgsdfgbdfbvs)) {
			player.gsdgsdfgbdfbvs = true;
			player thread upshaft_maintain(self, player getvelocity()[1]);
		}
	}
}

sideslide() {
	for(;;) {
		self waittill("trigger",player);
		vel = player getvelocity();
		if(vel[1] < 500 && vel[1] > 15) {
			player setvelocity(vel + (0,10,0));
		}
	}
}

upshaft_maintain(trigger, two_vel) {
	self endon("disconnect");

	while(self istouching(trigger)) {
		velocity = self getvelocity();
		self SetVelocity((velocity[0], velocity[1], two_vel));
		wait 0.05;
	}
	self.gsdgsdfgbdfbvs = undefined;
}

upshaft_3() {
	for(;;) {
		self waittill("trigger",player);
		velocity = player getvelocity();
		player SetVelocity((velocity[0], velocity[1], 400));
	}
}

// setvelocity() {
//     //testink
// }