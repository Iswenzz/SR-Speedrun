#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;


main()
{
	// map version 1.0

	//maps\mp\mp_dr_flippery_fx::main();
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	//level.water_splash_player_fx = LoadFX( "custom/water_splash_player" );
	//level.bounce_fx = LoadFX( "custom/bounce_fx" );
	//level.sniper_room_fx = LoadFX( "custom/sniper_room_fx" );

	SetDvar("bg_falldamagemaxheight", 99999);
	SetDvar("bg_falldamageminheight", 99998);

	//guns
    precacheItem("m40a3_mp");
    precacheItem("remington700_mp");
    precacheItem("deserteagle_mp");
	precacheItem("h2_m79a_mp");
	precacheItem("h2_m79b_mp");

	precacheItem("m1014_mp");
	precacheItem("h1_bayonet_mp");
	precacheItem("ak74u_mp");
    precacheItem("deserteaglegold_mp");
	precacheItem("uzi_mp");
	precacheItem("codol_tacknife_mp");

	//traps for disabling on free run
    addTriggerToList("trap_1_trigger");
    addTriggerToList("trap_2_trigger");
    addTriggerToList("trap_3_trigger");
    addTriggerToList("trap_4_trigger");
    addTriggerToList("trap_5_trigger");
    addTriggerToList("trap_6_trigger");
    addTriggerToList("trap_7_trigger");
    addTriggerToList("trap_8_trigger");
    addTriggerToList("trap_9_trigger");
    addTriggerToList("trap_10_trigger");
    addTriggerToList("trap_11_trigger");

	thread sr\api\_map::createSpawn((-1488, 744, 388), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^3Medium Secret;^1Hard Secret");

	thread sr_easy_sec_enter();
	thread sr_hard_sec_enter();
	thread sr_arrows_remove();
	thread sr_traps_remove();
	//level thread setup_traps();


	level thread setup_secret();
	level thread ghost_secret();

	//level thread vip_check_jabait();

	//level thread setup_endroom_doors();
	//level thread acti_booster();
	//level thread acti_booster_2();
	//level thread water_splash_fx();



	songlist = [];
	songlist[songlist.size] = "starlight";
	songlist[songlist.size] = "hasel";
	songlist[songlist.size] = "rainynight";
	songlist[songlist.size] = "danceforme";
	// notify_message("^7Welcome to ^3Flippery^7!", "^7Map by ^3Clippy^7!", 5, (1, 0.74, 0.47), undefined, undefined );
	// ambientstop(2);
	// ambientplay(songlist[randomint(songlist.size)]);
}

sr_easy_sec_enter()
{
	trig = spawn("trigger_radius",(-1598.82, 743.858, 328.125), 0, 50, 120);
	trig.radius = 50;
	ori_t = getEnt("secret_easy","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}

sr_hard_sec_enter()
{
	trig = spawn("trigger_radius",(-1252.52, 1016.46, 328.125), 0, 60, 120);
	trig.radius = 60;
	ori_t = getEnt("secret_hard","targetname");

	thread sr\api\_map::createTriggerFx(trig, "orange");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_2");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}

sr_arrows_remove()
{
	arrows1 = getentArray("trap_1_arrow", "targetname");
	arrows2 = getentArray("trap_2_arrow", "targetname");
	arrows3 = getentArray("trap_3_arrow", "targetname");
	arrows4 = getentArray("trap_4_arrow", "targetname");
	arrows5 = getentArray("trap_5_arrow", "targetname");
	arrows6 = getentArray("trap_6_arrow", "targetname");
	arrows7 = getentArray("trap_7_arrow", "targetname");
	arrows8 = getentArray("trap_8_arrow", "targetname");
	arrows9 = getentArray("trap_9_arrow", "targetname");
	arrows10 = getentArray("trap_10_arrow", "targetname");
	arrows11 = getentArray("trap_11_arrow", "targetname");

    for(i=0;i<arrows1.size;i++) arrows1[i] delete();
    for(i=0;i<arrows2.size;i++) arrows2[i] delete();
    for(i=0;i<arrows3.size;i++) arrows3[i] delete();
    for(i=0;i<arrows4.size;i++) arrows4[i] delete();
    for(i=0;i<arrows5.size;i++) arrows5[i] delete();
    for(i=0;i<arrows6.size;i++) arrows6[i] delete();
    for(i=0;i<arrows7.size;i++) arrows7[i] delete();
    for(i=0;i<arrows8.size;i++) arrows8[i] delete();
    for(i=0;i<arrows9.size;i++) arrows9[i] delete();
    for(i=0;i<arrows10.size;i++) arrows10[i] delete();
    for(i=0;i<arrows11.size;i++) arrows11[i] delete();
}

sr_traps_remove()
{
	trap_9_1 = getent("trap_9_1", "targetname");
    trap_9_2 = getent("trap_9_2", "targetname");
    trap_9_3 = getent("trap_9_3", "targetname");
    trap_9_4 = getent("trap_9_4", "targetname");
    trap_9_5 = getent("trap_9_5", "targetname");
    trap_9_6 = getent("trap_9_6", "targetname");
    trap_9_7 = getent("trap_9_7", "targetname");
    trap_9_8 = getent("trap_9_8", "targetname");
    brush_1 = getent("ghost_secret_gate", "targetname");
    trap_8 = GetEnt("trap_8", "targetname");

    wait 0.1;

    trap_9_1 movex(-136,0.1);
    trap_9_2 movex(-136,0.1);
    trap_9_3 movex(-136,0.1);
    trap_9_4 movex(-136,0.1);
    trap_9_5 movex(-136,0.1);
    trap_9_6 movex(-136,0.1);
    trap_9_7 movex(-136,0.1);
    trap_9_8 movex(-136,0.1);
    brush_1 notsolid();

    trap_8 RotateTo ((0,-45,0),.1);
}

water_splash_fx() {
	trigger = getent("water_splash", "targetname");
	for(;;) {
		trigger waittill("trigger",player);
		if(!isdefined(player.gsdgsdhdgerdhd)) {
			player.gsdgsdhdgerdhd = true;
			player thread reset_var_splash_fx(trigger);
			PlayFX(level.water_splash_player_fx, player.origin);
		}
	}
}

reset_var_splash_fx(trigger) {
    self endon("disconnect");
	while(self istouching(trigger))
		wait 0.05;

	self.gsdgsdhdgerdhd = undefined;
}

acti_booster() {
	acti_velocity = getEnt ("acti_velocity", "targetname");
	for(;;) {
		acti_velocity waittill("trigger",player);
		if(player getvelocity()[2] < -15 && !isdefined(player.vsidjnvlsmnvlsj)) {
			player.vsidjnvlsmnvlsj = true;
			vel = player getvelocity();
			player setvelocity((vel[0], vel[1], -500));
			player thread reset_var_touching_sniper(acti_velocity);
		}
	}
}

acti_booster_2() {
	acti_velocity = getEnt ("acti_velocity_2", "targetname");
	for(;;) {
		acti_velocity waittill("trigger",player);
		if(!isdefined(player.jsnnbgvkdsfjbnvd)) {
			player.jsnnbgvkdsfjbnvd = true;
			player setvelocity((0, 0, 900));
			player thread reset_var_touching_sniper_2(acti_velocity);
		}
	}
}

vip_check_jabait() {
	trigger = getEnt ("vip_check", "targetname");
	for(;;) {
		trigger waittill("trigger",player);
		if(!isdefined(player.bsjfdnvklssdgvs)) {
			player.bsjfdnvklssdgvs = true;
			player iprintlnbold("^3VIP ^7Checks Are Gay");
			ang = player getplayerangles();
			player SetPlayerAngles((ang[0],ang[1],180));
			player thread reset_on_death_vip();
		}
	}
}
reset_on_death_vip() {
	self endon("disconnect");
	self waittill("death");
	if(isdefined(self.bsjfdnvklssdgvs))
		self.bsjfdnvklssdgvs = undefined;
}

sniper_insta_ele(coard, x) {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.dnmglkdjkfnbl)) {
			player.dnmglkdjkfnbl = true;
			player thread secret_ele(self, coard, x);
		}
	}
}

sniper_ele_velocity(velocity) {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.sgfsgdsdfvs)) {
			player.sgfsgdsdfvs = true;
			player thread sniper_ele_velocity_var_reset(self);
			player setvelocity(velocity);
		}
	}
}

sniper_ele_velocity_var_reset(trig) {
    self endon("disconnect");
	while(self istouching(trig))
			wait 0.05;

	wait .75; //fixes ability to stay at the top

	self.sgfsgdsdfvs = undefined;
}

sniper_fail() {
	midpoint = getent(self.target,"targetname");
	sniper_acti = getent("sniper_acti","targetname");
	sniper_jumper = getent("sniper_jumper","targetname");
	for(;;) {
		self waittill("trigger", player);

		PlayFX(level.water_splash_player_fx, player.origin);

		if(player.origin[0]>midpoint.origin[0]) {
			player setorigin(sniper_acti.origin);
			player setplayerangles((player getplayerangles()[0], sniper_acti.angles[1], 0));
		} else {
			player setorigin(sniper_jumper.origin);
			player setplayerangles((player getplayerangles()[0], sniper_jumper.angles[1], 0));
		}
	}
}

detect_stuck_in_sniper_reverser(center) {
	for(;;) {
		self waittill("trigger" , player);
		if(!isdefined(player.fljbndksjnvsl)) {
			player.fljbndksjnvsl = 1;
			player thread detect_stuck_in_sniper_reverser_timer(self, center);
		}
	}
}

detect_stuck_in_sniper_reverser_timer(trigger, center) {
    self endon("disconnect");
	while(self istouching(trigger)) {
		wait 0.1;
		self.fljbndksjnvsl++;
		if(self.fljbndksjnvsl > 10) {
			pp = vectornormalize((center.origin + (0,0,800)) - self.origin);
			self setvelocity(pp * 600);
			wait 1;
		}
	}
	self.fljbndksjnvsl = undefined;
}

sniper_room(trigger) {
	sniper_acti = GetEnt("sniper_acti", "targetname");
	sniper_jumper = GetEnt("sniper_jumper", "targetname");

	sniper_fail = getEnt ("sniper_fail", "targetname");
	sniper_fail thread sniper_fail();

	sniper_ele_1_top = getEnt ("sniper_ele_1_top", "targetname");
	sniper_ele_2_top = getEnt ("sniper_ele_2_top", "targetname");
	sniper_ele_1_top thread sniper_ele_velocity((-60, 0, 250));
	sniper_ele_2_top thread sniper_ele_velocity((60, 0, 250));

	sniper_ele_1 = getEnt ("sniper_ele_1", "targetname");
	sniper_ele_2 = getEnt ("sniper_ele_2", "targetname");
	sniper_ele_1 thread sniper_insta_ele(257, true);
	sniper_ele_2 thread sniper_insta_ele(-2033, true);

	sniper_velocity_1 = getEnt ("velocity_trigger1", "targetname");
	sniper_velocity_2 = getEnt ("velocity_trigger2", "targetname");

	mid_point = getent(sniper_fail.target,"targetname");
	sniper_velocity_1 thread snipervelocity();
	sniper_velocity_2 thread snipervelocity();

	sniper_velocity_1 thread detect_stuck_in_sniper_reverser(mid_point);
	sniper_velocity_2 thread detect_stuck_in_sniper_reverser(mid_point);

	for(;;)
    {
        trigger waittill ("trigger", player);

        activator = getactivator();
		if(!isdefined(activator)) {
			iprintln("^1No Activator Detected");
			continue;
		}
		if(player == activator) {
			iprintln("^1Activator Can't Enter Room");
			continue;
		}

        player thread disable_triggers_untill_death();
        thread fightHUD("Sniper Room", player, activator);

		player freeze_on_tps(4);
		activator freeze_on_tps(4);
		thread countdown_timer_string(4, "^1Fight", "^3");

		player setOrigin (sniper_jumper.origin);
        activator setOrigin (sniper_acti.origin);

        player setPlayerAngles (sniper_jumper.angles);
        activator setPlayerAngles (sniper_acti.angles);

        player takeAllWeapons();
        activator takeAllWeapons();

        player giveWeapon("m40a3_mp");
        activator giveWeapon("m40a3_mp");

		player giveWeapon("remington700_mp");
        activator giveWeapon("remington700_mp");

        player switchToWeapon("m40a3_mp");
        activator switchToWeapon("m40a3_mp");

        player.health = player.maxhealth;
        activator.health = activator.maxhealth;

		while(isDefined(player) && isAlive(player))
            wait .05;
    }
}

reset_var_touching_sniper(trig) {
    self endon("disconnect");
	while(self istouching(trig))
		wait 0.05;

	self.vsidjnvlsmnvlsj = undefined;
}
reset_var_touching_sniper_2(trig) {
    self endon("disconnect");
	while(self istouching(trig))
		wait 0.05;

	self.jsnnbgvkdsfjbnvd = undefined;
}

snipervelocity() {
	for(;;) {
		self waittill("trigger" , player);
		if(!isdefined(player.jsnnbgvkdsfjbnvd)) {
			player.jsnnbgvkdsfjbnvd = true;
			player thread reset_var_touching_sniper_2(self);
			player sniper_room_fx();
			player setvelocity(sniper_reverse_velocity(player getvelocity()));
		}
	}
}

sniper_reverse_velocity(velocity){
	return (velocity[0],velocity[1]*-1,velocity[2]);
}

notify_message(title, text, duration, color, wait_time, round_started)
{
	if(isdefined(round_started)) {
		level waittill("round_started");
	}
	if(isdefined(wait_time))
		wait wait_time;

	notif = SpawnStruct();
	notif.TitleText = title;
    notif.notifyText = text;
	notif.duration = duration;
	notif.color = color;
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( notif );

}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

special_bounce_fx() {
	fwrd = anglestoforward(VectortoAngles(self getvelocity()));
	PlayFX(level.bounce_fx, self.origin, fwrd);
	self playlocalsound("bounce_sound");
}
sniper_room_fx() {
	PlayFX(level.sniper_room_fx, self.origin + (0,0,30));
}

ghost_secret() {
	ghost_bounce_1 = getEnt ("ghost_bounce_1", "targetname");
	ghost_bounce_2 = getEnt ("ghost_bounce_2", "targetname");
	ghost_bounce_3 = getEnt ("ghost_bounce_3", "targetname");

	ghost_end = getEnt ("ghost_end", "targetname");

	ghost_org_1 = getEnt ("ghost_org_1", "targetname");
	ghost_org_2 = getEnt ("ghost_org_2", "targetname");
	ghost_org_3 = getEnt ("ghost_org_3", "targetname");

	ghost_fail_1 = getEnt ("ghost_fail_1", "targetname");
	ghost_fail_2 = getEnt ("ghost_fail_2", "targetname");
	ghost_fail_3 = getEnt ("ghost_fail_3", "targetname");

	ghost_fail_1 thread ghost_secret_fail(ghost_org_1);
	ghost_fail_2 thread ghost_secret_fail(ghost_org_2);
	ghost_fail_3 thread ghost_secret_fail(ghost_org_3);

	ghost_bounce_1 thread ghost_secret_bounce(ghost_org_1);
	ghost_bounce_2 thread ghost_secret_bounce(ghost_org_2);
	ghost_bounce_3 thread ghost_secret_bounce(ghost_org_3);

	ghost_secret_enter = getEnt ("ghost_secret_enter", "targetname");
	ghost_secret_protect = getEnt ("ghost_secret_protect", "targetname");
	ghost_secret_protect_org = getEnt ("ghost_secret_protect_org", "targetname");
	ghost_secret_open = getEnt ("ghost_secret_open", "targetname");
	ghost_secret_gate = getEnt ("ghost_secret_gate", "targetname");

	thread teleporter_logic(ghost_secret_enter, ghost_org_1, true, undefined, ::ghost_velocity_enter);

	//ghost_secret_protect thread ghost_secret_protect(ghost_secret_protect_org);
	//ghost_secret_open thread ghost_secret_gate(ghost_secret_gate);

	amount = 250;

	offset_01 = 4416;
	offset_2 = 1776;
	total_offset = (offset_01,offset_01,offset_2);
    max_streak_fin = 3;
	for(;;) {
		ghost_end waittill("trigger", player);
        if(!isdefined(player.ghost_secret_spree))
			player.ghost_secret_spree = 0;

		player.ghost_secret_spree++;

		player setorigin(player.origin - total_offset);

        if(player.ghost_secret_spree == max_streak_fin) {
		    player thread sr\api\_speedrun::finishWay("secret_1");
		    player iprintln("^2" + player.ghost_secret_spree + "/^2" + max_streak_fin);
        }
        else if(player.ghost_secret_spree < max_streak_fin) {
		    player iprintln("^1" + player.ghost_secret_spree + "/^2" + max_streak_fin);
        }
	}
}

ghost_velocity_enter() {
	self thread sr\api\_speedrun::changeWay("secret_1");
	self setvelocity((180,180,0));
	self.ghost_secret_spree = 0;
}

ghost_secret_protect(ent) {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.ghost)) {
			player setorigin(ent.origin);
			player setplayerangles((player getplayerangles()[0], ent.angles[1], 0));
		}
	}
}
ghost_secret_gate(gate) {
	for(;;) {
		wait 0.1;
		players = getentarray( "player", "classname" );
		cringe = false;
		for(i = 0;i < players.size;i++)
		{
			if(players[i] istouching(self) && isdefined(players[i].ghost)) {
				cringe = true;
				break;
			}
		}

		if(cringe)
			gate NotSolid();
		else
			gate Solid();
	}
}
ghost_secret_bounce(ent) {
	for(;;) {
		self waittill("trigger", player);
		if(player GetVelocity()[2] > 30) {
			player setorigin((ent.origin[0],ent.origin[1],ent.origin[2]));
			player special_bounce_fx();
		}
	}
}
ghost_secret_fail(ent) {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.ghost_secret_spree))
			player.ghost_secret_spree = 0;

		PlayFX(level.water_splash_player_fx, player.origin);

		if(player.ghost_secret_spree > 0)
			player iprintln("^2Final Streak: ^7" + player.ghost_secret_spree);
		player.ghost_secret_spree = 0;
		// player freeze_on_tps(0.05);
		player setvelocity((180,180,0));
		player setorigin(ent.origin);
		player setplayerangles((player getplayerangles()[0], ent.angles[1], 0));
	}
}

// end_doors


GetActivator()
{
	players = getentarray( "player", "classname" );

	for(i = 0;i < players.size;i++)
	{
		player = players[i];

		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}

	return undefined;
}

disable_triggers_untill_death()
{
    // activator = GetActivator();

    level.knife_trigger thread maps\mp\_utility::triggerOff();
    level.sniper_trigger thread maps\mp\_utility::triggerOff();
    level.jump_trigger thread maps\mp\_utility::triggerOff();
    level.launcher_trigger thread maps\mp\_utility::triggerOff();
    level.old_trigger thread maps\mp\_utility::triggerOff();

    self common_scripts\utility::waittill_any("death","disconnect");
    level notify ("reopen_room");

    level.knife_trigger thread maps\mp\_utility::triggerOn();
    level.sniper_trigger thread maps\mp\_utility::triggerOn();
    level.jump_trigger thread maps\mp\_utility::triggerOn();
    level.launcher_trigger thread maps\mp\_utility::triggerOn();
    //level.old_trigger thread maps\mp\_utility::triggerOn();
}

setup_endroom_doors() {
	level.knife_trigger = getEnt ("endroom_select_knife", "targetname");
	level.sniper_trigger = getEnt ("endroom_select_sniper", "targetname");
	level.jump_trigger = getEnt ("endroom_select_jump", "targetname");
	level.launcher_trigger = getEnt ("endroom_select_launcher", "targetname");
	level.old_trigger = getEnt ("endroom_select_old", "targetname");

	thread sniper_room(level.sniper_trigger);
	thread knife_room(level.knife_trigger);
	thread jump_room(level.jump_trigger);
	thread rpg_room(level.launcher_trigger);
	thread old_room(level.old_trigger);
}

old_room(trigger)
{
	old_door = getEnt ("endroom_select_old_door", "targetname");
	old_window = getEnt ("endroom_select_old_window", "targetname");
   	for(;;)
    {
        trigger waittill ("trigger", player);

        level.knife_trigger thread maps\mp\_utility::triggerOff();
		level.sniper_trigger thread maps\mp\_utility::triggerOff();
		level.jump_trigger thread maps\mp\_utility::triggerOff();
		level.launcher_trigger thread maps\mp\_utility::triggerOff();
		level.old_trigger thread maps\mp\_utility::triggerOff();
        thread notify_message("^3Old^7 Room Opened!", "^7No ^2Respect^7 In ^3Old^7!", 5, (0.87, 0.94, 1), undefined, undefined );
		old_door MoveTo(old_door.origin - (0,0,112), 3, 1, 0);
		old_window delete();
    }
}

jump_room_stuff(index) {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.jump_room_pos))
			player.jump_room_pos = 1;
		if(player.jump_room_pos < index) {
			player iprintln("^3Checkpoint ^2" + (index - 1));
			player.jump_room_pos = index;
		}
	}
}

jump_room_teleport_stuff(string) {
	fallback = getEnt ("bounce_" + string + "_1", "targetname");
	for(;;) {
		self waittill("trigger", player);
		PlayFX(level.water_splash_player_fx, player.origin);

		if(!isdefined(player.jump_room_pos))
			player.jump_room_pos = 1;

		ent = GetEnt("bounce_" + string + "_" + player.jump_room_pos, "targetname");
		if(isdefined(ent)) {
			player freeze_on_tps(0.05);
			player setorigin(ent.origin);
			player setplayerangles((player getplayerangles()[0], ent.angles[1], 0));
		} else {
			player freeze_on_tps(0.05);
			player setorigin(fallback.origin);
			player setplayerangles((player getplayerangles()[0], fallback.angles[1], 0));
		}
	}
}

jump_room_weapon(weapon) {
	for(;;) {
		self waittill("trigger", player);
		player GiveWeapon(weapon);
		player setweaponammostock(weapon, 100);
		if(player getcurrentweapon() != weapon)
			player switchtoweapon(weapon);
	}
}

jump_room(trigger)
{
    bounce_jumper_1 = getEnt ("bounce_jumper_1", "targetname");
    bounce_acti_1 = getEnt ("bounce_acti_1", "targetname");

	bounce_jumper_2_trig = getEnt ("bounce_jumper_2_trig", "targetname");
	bounce_jumper_3_trig = getEnt ("bounce_jumper_3_trig", "targetname");
	bounce_jumper_4_trig = getEnt ("bounce_jumper_4_trig", "targetname");

	bounce_jumper_2_trig thread jump_room_stuff(2);
	bounce_jumper_3_trig thread jump_room_stuff(3);
	bounce_jumper_4_trig thread jump_room_stuff(4);

	bounce_acti_2_trig = getEnt ("bounce_acti_2_trig", "targetname");
	bounce_acti_3_trig = getEnt ("bounce_acti_3_trig", "targetname");
	bounce_acti_4_trig = getEnt ("bounce_acti_4_trig", "targetname");

	bounce_acti_2_trig thread jump_room_stuff(2);
	bounce_acti_3_trig thread jump_room_stuff(3);
	bounce_acti_4_trig thread jump_room_stuff(4);

	bounce_fail_jumper = getEnt ("bounce_fail_jumper", "targetname");
	bounce_fail_acti = getEnt ("bounce_fail_acti", "targetname");

	bounce_fail_jumper thread jump_room_teleport_stuff("jumper");
	bounce_fail_acti thread jump_room_teleport_stuff("acti");

	room_bounce_weapon_1 = getEnt ("room_bounce_weapon_1", "targetname");
	room_bounce_weapon_2 = getEnt ("room_bounce_weapon_2", "targetname");

	room_bounce_weapon_1 thread jump_room_weapon("remington700_mp");
	room_bounce_weapon_2 thread jump_room_weapon("m40a3_mp");

   	for(;;)
    {
        trigger waittill ("trigger", player);

        activator = getactivator();
		if(!isdefined(activator)) {
			iprintln("^1No Activator Detected");
			continue;
		}
		if(player == activator) {
			iprintln("^1Activator Can't Enter Room");
			continue;
		}


        player thread disable_triggers_untill_death();
        thread fightHUD("Jump Room", player, activator);

		player freeze_on_tps(4);
		activator freeze_on_tps(4);
		thread countdown_timer_string(4, "^1Fight", "^3");

	    player setOrigin (bounce_jumper_1.origin);
        activator setOrigin (bounce_acti_1.origin);

        player setPlayerAngles (bounce_jumper_1.angles);
        activator setPlayerAngles (bounce_acti_1.angles);

        player takeAllWeapons();
        activator takeAllWeapons();

        player giveWeapon("h1_bayonet_mp");
        activator giveWeapon("h1_bayonet_mp");

        player switchToWeapon("h1_bayonet_mp");
        activator switchToWeapon("h1_bayonet_mp");

        player.health = player.maxhealth;
        activator.health = activator.maxhealth;

		while(isDefined(player) && isAlive(player))
            wait .05;
    }
}

knife_room(trigger)
{
    knife_jumper = getEnt ("knife_jumper", "targetname");
    knife_acti = getEnt ("knife_acti", "targetname");

   	for(;;)
    {
        trigger waittill ("trigger", player);

        activator = getactivator();
		if(!isdefined(activator)) {
			iprintln("^1No Activator Detected");
			continue;
		}
		if(player == activator) {
			iprintln("^1Activator Can't Enter Room");
			continue;
		}

        player thread disable_triggers_untill_death();
        thread fightHUD("Knife Room", player, activator);

		player freeze_on_tps(4);
		activator freeze_on_tps(4);
		thread countdown_timer_string(4, "^1Fight", "^3");

	    player setOrigin (knife_jumper.origin);
        activator setOrigin (knife_acti.origin);

        player setPlayerAngles (knife_jumper.angles);
        activator setPlayerAngles (knife_acti.angles);

        player takeAllWeapons();
        activator takeAllWeapons();

        player giveWeapon("h1_bayonet_mp");
        activator giveWeapon("h1_bayonet_mp");

        player switchToWeapon("h1_bayonet_mp");
        activator switchToWeapon("h1_bayonet_mp");

        player.health = player.maxhealth;
        activator.health = activator.maxhealth;

		while(isDefined(player) && isAlive(player))
            wait .05;
    }
}


rpg_room(trigger) {
	rpg_room_sur = GetEnt("rpg_room_sur", "targetname");
	rpg_bounce_sur = GetEnt("rpg_bounce_sur", "targetname");
	rpg_room_acti = GetEnt("rpg_room_acti", "targetname");
	rpg_bounce_acti = GetEnt("rpg_bounce_acti", "targetname");

	rpg_bounce_sur thread rpg_bounce_trigger(rpg_room_sur);
	rpg_bounce_acti thread rpg_bounce_trigger(rpg_room_acti);

	rpg_room_fall = GetEnt("rpg_room_fall", "targetname");
	rpg_room_midpoint = GetEnt("rpg_room_midpoint", "targetname");

	rpg_room_fall thread rpg_fall_trigger(rpg_room_midpoint, rpg_room_acti, rpg_room_sur);

	for(;;)
    {
        trigger waittill ("trigger", player);

        activator = getactivator();
		if(!isdefined(activator)) {
			iprintln("^1No Activator Detected");
			continue;
		}
		if(player == activator) {
			iprintln("^1Activator Can't Enter Room");
			continue;
		}

        player thread disable_triggers_untill_death();
        thread fightHUD("Grenade Launcher Room", player, activator);

		player freeze_on_tps(4);
		activator freeze_on_tps(4);
		thread countdown_timer_string(4, "^1Fight", "^3");

		player setOrigin (rpg_room_sur.origin);
        activator setOrigin (rpg_room_acti.origin);

        player setPlayerAngles (rpg_room_sur.angles);
        activator setPlayerAngles (rpg_room_acti.angles);

        player takeAllWeapons();
        activator takeAllWeapons();

        player giveWeapon("h2_m79a_mp");
        activator giveWeapon("h2_m79b_mp");

        player switchToWeapon("h2_m79a_mp");
        activator switchToWeapon("h2_m79b_mp");

		player thread unlimited_stock_ammo_end_death("h2_m79a_mp", 1);
		activator thread unlimited_stock_ammo_end_death("h2_m79b_mp", 1);

        player.health = player.maxhealth;
        activator.health = activator.maxhealth;

		while(isDefined(player) && isAlive(player))
            wait .05;
    }
}

countdown_timer_string(time, string, color) {
	for(i=time;i>0;i--) {

		if(isdefined(color))
			iprintlnbold(color + i);
		else
			iprintlnbold(i);
		wait 1;
	}
	iprintlnbold(string);
}

unlimited_stock_ammo_end_death(weapon, wait_time) {
	self notify("mnbdjkfnbkl");
	self endon("mnbdjkfnbkl");
	self endon("disconnect");
	self endon("death");
	for(;;)
    {
		self SetWeaponAmmoStock(weapon, 200);
		wait wait_time;
	}
}

fightHUD(room, jumper, activ)
{
	self endon("disconnect");
    self notify("newFhud");
    self endon("newFhud");

    if (!isDefined(room))
        room = "undefined";
    if (!isDefined(jumper))
        jumper = "undefined";
    else
        jumper = jumper.name;
    if (!isDefined(activ))
        activ = "undefined";
    else
        activ = activ.name;

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();

    level.hud_fight = createHUD( 0, 85, "center", "top", 1, "objective", 1.5 );
    level.hud_fight setText("^3" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^3" + jumper + " ^7VS^7 " + "^3" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}
/////////////////////////
createHUD( x, y, alignX, alignY, alpha, font, fontScale )
{
    hud = NewHudElem();
    hud.x = x;
    hud.y = y;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.horzalign = alignX;
    hud.vertalign = alignY;
    hud.alpha = alpha;
    hud.font = font;
    hud.fontscale = fontScale;
    hud.glowalpha = 0;
    hud.glowcolor = (1,1,1);

    return hud;
}

createClientHUD( x, y, alignX, alignY, alpha, font, fontScale )
{
    hud = NewclientHudElem(self);
    hud.x = x;
    hud.y = y;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.horzalign = alignX;
    hud.vertalign = alignY;
    hud.alpha = alpha;
    hud.font = font;
    hud.fontscale = fontScale;
    hud.glowalpha = 0;
    hud.glowcolor = (1,1,1);

    return hud;
}

rpg_fall_trigger(mid, acti, sur) {
	for(;;) {
		self waittill("trigger", player);
		PlayFX(level.water_splash_player_fx, player.origin);

		if(player.origin[1] > mid.origin[1]) {
			player setorigin(acti.origin);
			player setplayerangles((player getplayerangles()[0], acti.angles[1], 0));
		} else {
			player setorigin(sur.origin);
			player setplayerangles((player getplayerangles()[0], sur.angles[1], 0));
		}
	}
}


rpg_bounce_trigger(ent) {
	for(;;) {
		self waittill("trigger", player);
		if(player GetVelocity()[2] > 30) {
			player setorigin((player.origin[0],ent.origin[1],ent.origin[2]));
			player special_bounce_fx();
		}
	}
}

setup_secret() {

	secret_hard = GetEnt("secret_hard", "targetname");
	secret_hard_entry = GetEnt("secret_hard_entry", "targetname");
	secret_hard_end = GetEnt("secret_hard_end", "targetname");
	secret_hard_exit = GetEnt("secret_hard_exit", "targetname");
	secret_hard_fail = GetEnt("secret_hard_fail", "targetname");

	// hard_secret_secret = GetEnt("hard_secret_secret", "targetname");
	// hard_secret_secret thread hard_secret_secret();

	thread teleporter_logic(secret_hard, secret_hard_entry, undefined, undefined, ::enter_hard_secret_msg);
	thread teleporter_logic(secret_hard_fail, secret_hard_entry, true, 0.05);
	thread teleporter_logic(secret_hard_end, secret_hard_exit, true, 0.1, ::exit_hard_secret_msg);

	//teleporter_logic(trigger, exit_ent, angles, freeze, function)



	secret_easy = GetEnt("secret_easy", "targetname");
	secret_first = GetEnt("secret_easy_org_1", "targetname");
	secret_easy_end = GetEnt("secret_easy_end", "targetname");
	secret_easy_exit = GetEnt("secret_easy_exit", "targetname");
	thread teleporter_logic(secret_easy, secret_first, true, undefined, ::enter_easy_secret_msg);
	thread teleporter_logic(secret_easy_end, secret_easy_exit, true, 0.05, ::exit_easy_secret_msg);


	for(i=2;i<=8;i++) {
		ent = GetEnt("secret_easy_stage_" + (i), "targetname");
		ent thread easy_secret_stuff(i);
	}

	secret_easy_fail = GetEnt("secret_easy_fail", "targetname");
	secret_easy_fail thread easy_secret_teleport_logic();

	secret_ele = GetEnt("secret_ele", "targetname");
	secret_ele thread secret_insta_ele(679, true);
	secret_ele_2 = GetEnt("secret_ele_2", "targetname");
	secret_ele_2 thread secret_insta_ele(-1041, false);

	gun_secret_shot = GetEnt("gun_secret_shot", "targetname");
	gun_secret_uzi = GetEnt("gun_secret_uzi", "targetname");
	gun_secret_aku = GetEnt("gun_secret_aku", "targetname");
	gun_secret_shot thread gun_secret("Press ^3[&&1] ^7For a ^2M1014 ^7& ^2Bayonet", "m1014");
	gun_secret_uzi thread gun_secret("Press ^3[&&1] ^7For a ^1Uzi ^7& ^1Tactical Knife", "uzi");
	gun_secret_aku thread gun_secret("Press ^3[&&1] ^7For a ^6AK74-u ^7& ^6Gold Deagle", "ak74u");
}

secret_timer(label, time, ent, fail_string) {
	self endon("disconnect");
	self notify("new_secret");
	self endon("new_secret");
	self endon("finish_secret");

	if (isDefined(self.secret_timer)) self.secret_timer destroy();

    self.secret_timer = createClientHUD( 180, -10, "left", "bottom", 1, "objective", 1.4 );
    self.secret_timer.label = label;

	for(i=time;i>0;i--) {
		self.secret_timer setvalue(i);
		wait 1;
	}

	if(isdefined(fail_string))
		iprintln(fail_string);

	self freeze_on_tps(0.05);

	self setorigin(ent.origin);
	self setplayerangles((self getplayerangles()[0], ent.angles[1], 0));
	self.disallow_secret = true;
	self thread disallow_secret();
}

disallow_secret() {
	self endon("disconnect");
	self waittill("death");
	self.disallow_secret = undefined;
}

stop_secret_enter(ent) {
	wait 0.05;
	self iprintln("^1You Are Not Allowed In Secret!\n^1You Suck Too Much");
	self freeze_on_tps(0.05);
	self setorigin(ent.origin);
	self setplayerangles((self getplayerangles()[0], ent.angles[1], 0));
}

gun_secret(hintstring, weapon) {
	if(isdefined(hintstring))
		self SetHintString(hintstring);
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.olkbnfkmgnkfd)) {
			player.olkbnfkmgnkfd = true;
			player giving_weaps_secret(weapon);
			player thread wigglywoggly();
		}
	}
}

giving_weaps_secret(weapon) {
	self takeallweapons();
	if(weapon == "m1014") {
		self giveweapon("h1_bayonet_mp");
		if(!level.freerun) { // ????? check if good
			self giveweapon("m1014_mp", 6);
			self switchtoweapon("m1014_mp");
		} else
			self switchtoweapon("h1_bayonet_mp");

	} else if(weapon == "uzi") {
		self giveweapon("codol_tacknife_mp");
		if(!level.freerun) { // ????? check if good
			self giveweapon("uzi_mp", 6);
			self switchtoweapon("uzi_mp");
		} else
			self switchtoweapon("codol_tacknife_mp");

	} else if(weapon == "ak74u") {
		if(!level.freerun) { // ????? check if good
			self giveweapon("ak74u_mp");
			self switchtoweapon("ak74u_mp");
			self giveweapon("deserteaglegold_mp");
		} else {
			self giveweapon("codol_tacknife_mp");
			self switchtoweapon("codol_tacknife_mp");
		}

	}
}

hard_secret_secret() {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.dsfgbdfsdgfvdf)) {
			player.dsfgbdfsdgfvdf = true;
			player iprintlnbold("How did you find this?");
			if(!isdefined(player.ghost)){
				self braxi\_rank::giveRankXP("", 4000);
			}
		}
	}
}

wigglywoggly() {
	self endon("disconnect");
	self notify("hippityhoppity");
	self endon("hippityhoppity");
	self waittill("death");
	if(isdefined(self.olkbnfkmgnkfd))
		self.olkbnfkmgnkfd = undefined;
}

secret_insta_ele(coard, x) {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.dnmglkdjkfnbl) && player GetStance() == "crouch") {
			player.dnmglkdjkfnbl = true;
			player thread secret_ele(self, coard, x);
		}
	}
}

secret_ele(trig, coard, x) {
    self endon("disconnect");
	if(x)
		self setorigin((coard,self.origin[1],self.origin[2]));
	else
		self setorigin((self.origin[0],coard,self.origin[2]));

	while(self istouching(trig))
		wait 0.05;
	self.dnmglkdjkfnbl = undefined;
}

easy_secret_stuff(index) {
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.easy_secret_pos))
			player.easy_secret_pos = 1;
		if(player.easy_secret_pos < index) {
			player iprintln("^3Checkpoint ^2" + (index - 1));
			player.easy_secret_pos = index;
		}
	}
}

easy_secret_teleport_logic() {
	fallback = GetEnt("secret_easy_org_1", "targetname");
	for(;;) {
		self waittill("trigger", player);
		if(!isdefined(player.easy_secret_pos))
			player.easy_secret_pos = 1;

		ent = GetEnt("secret_easy_org_" + player.easy_secret_pos, "targetname");
		if(isdefined(ent)) {
			player freeze_on_tps(0.05);
			player setorigin(ent.origin);
			player setplayerangles((player getplayerangles()[0], ent.angles[1], 0));
		} else {
			player freeze_on_tps(0.05);
			player setorigin(fallback.origin);
			player setplayerangles((player getplayerangles()[0], fallback.angles[1], 0));
		}
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread dddasdasddd(time);
}
dddasdasddd(time) {
	wait time;
	self freezecontrols(false);
}

teleporter_logic(trigger, exit_ent, angles, freeze, function) {
	for(;;) {
		trigger waittill("trigger", player);
		if(isdefined(freeze))
			player freeze_on_tps(freeze);

		player setorigin(exit_ent.origin);
		if(isdefined(angles))
			player setplayerangles((player getplayerangles()[0], exit_ent.angles[1], 0));
		if(isdefined(function))
			player thread [[function]]();
	}
}

enter_hard_secret_msg() {
	if(isdefined(self.disallow_secret)) {
		wait 0.05;
		self thread stop_secret_enter(GetEnt("failed_hard_secret", "targetname"));
		return;
	}

	//self thread secret_timer(&"^1Hard ^7Secret Timer:^3 ", 60, GetEnt("failed_hard_secret", "targetname"), "^6" + self.name + " ^1Failed ^1Hard ^3Secret");
	iprintln("^6" + self.name + " ^7Entered ^1Hard ^3Secret");
}
enter_easy_secret_msg() {
	if(isdefined(self.disallow_secret)) {
		wait 0.05;
		self thread stop_secret_enter(GetEnt("failed_easy_secret", "targetname"));
		return;
	}
	self.easy_secret_pos = 1;
	//self thread secret_timer(&"^2Easy ^7Secret Timer:^3 ", 80, GetEnt("failed_easy_secret", "targetname"), "^6" + self.name + " ^1Failed ^2Easy ^3Secret");
	iprintln("^6" + self.name + " ^7Entered ^2Easy ^3Secret");
}
exit_hard_secret_msg()
{
	self notify("finish_secret");
	self thread sr\api\_speedrun::finishWay("secret_2");
}
exit_easy_secret_msg()
{
	self notify("finish_secret");
	self thread sr\api\_speedrun::finishWay("secret_0");
}


setup_traps() {

	//////////////////////////// Temp vvvvvvvvv

	trap_8 = GetEnt("trap_8", "targetname");

	trap_8 RotateTo ((0,-45,0),.1);

	trap_9_1 = GetEnt("trap_9_1", "targetname");
	trap_9_2 = GetEnt("trap_9_2", "targetname");
	trap_9_3 = GetEnt("trap_9_3", "targetname");
	trap_9_4 = GetEnt("trap_9_4", "targetname");
	trap_9_5 = GetEnt("trap_9_5", "targetname");
	trap_9_6 = GetEnt("trap_9_6", "targetname");
	trap_9_7 = GetEnt("trap_9_7", "targetname");
	trap_9_8 = GetEnt("trap_9_8", "targetname");

	trap_9_1 movex(-136,0.1);
	trap_9_2 movex(-136,0.1);
	trap_9_3 movex(-136,0.1);
	trap_9_4 movex(-136,0.1);
	trap_9_5 movex(-136,0.1);
	trap_9_6 movex(-136,0.1);
	trap_9_7 movex(-136,0.1);
	trap_9_8 movex(-136,0.1);

	/////////////////////////////////// temp ^^^^^

	thread trap_1();
	thread trap_2();
	thread trap_3();
	thread trap_4();
	thread trap_5();
	thread trap_6();
	thread trap_7();
	thread trap_8();
	thread trap_9();
	thread trap_10();
	thread trap_11();
}

trap_1() {
	trap_1_trigger = GetEnt("trap_1_trigger", "targetname");
	trap_1 = GetEnt("trap_1", "targetname");

	thread arrow_logic("trap_1", trap_1_trigger);

	trap_1_trigger setHintString("- Trap^1 1 ^7- ^7Press ^3[&&1] \n^7- Smaller Platform");
    trap_1_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_1_trigger.target, "targetname"));
    trap_1_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_1");

	trap_1 delete();
}

trap_2() {
	trap_2_trigger = GetEnt("trap_2_trigger", "targetname");
	trap_2 = GetEnt("trap_2", "targetname");

	thread arrow_logic("trap_2", trap_2_trigger);

	trap_2_trigger setHintString("- Trap^1 2 ^7- ^7Press ^3[&&1] \n^7- Remove Bounce");
    trap_2_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_2_trigger.target, "targetname"));
    trap_2_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_2");

	trap_2 RotateTo((0,0,-90), 3, 0.5, 1);
}

trap_3() {
	trap_3_trigger = GetEnt("trap_3_trigger", "targetname");
	trap_3 = GetEnt("trap_3", "targetname");

	thread arrow_logic("trap_3", trap_3_trigger);

	trap_3_trigger setHintString("- Trap^1 3 ^7- ^7Press ^3[&&1] \n^7- Remove Floor");
    trap_3_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_3_trigger.target, "targetname"));
    trap_3_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_3");

	trap_3 delete();
}

trap_4() {
	trap_4_trigger = GetEnt("trap_4_trigger", "targetname");
	trap_4 = GetEnt("trap_4", "targetname");

	thread arrow_logic("trap_4", trap_4_trigger);

	trap_4_trigger setHintString("- Trap^1 4 ^7- ^7Press ^3[&&1] \n^7- Rotate Platform");
    trap_4_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_4_trigger.target, "targetname"));
    trap_4_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_4");

	trap_4 RotateVelocity((0,-180,0), 1000000);
}

trap_5() {
	trap_5_trigger = GetEnt("trap_5_trigger", "targetname");
	trap_5_1 = GetEnt("trap_5_1", "targetname");
	trap_5_2 = GetEnt("trap_5_2", "targetname");
	trap_5_3 = GetEnt("trap_5_3", "targetname");

	thread arrow_logic("trap_5", trap_5_trigger);

	trap_5_trigger setHintString("- Trap^1 5 ^7- ^7Press ^3[&&1] \n^7- Make Ramps Disappear");
    trap_5_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_5_trigger.target, "targetname"));
    trap_5_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_5");

	trap_5_1.origin = trap_5_1.origin + (0,0,1000);
	trap_5_2.origin = trap_5_2.origin + (0,0,1000);
	trap_5_3.origin = trap_5_3.origin + (0,0,1000);

	wait 2;
	for(;;) {
		trap_5_1.origin = trap_5_1.origin - (0,0,1000);
		thread trap_5_deathcheck(trap_5_1);
		wait 1.5;
		trap_5_1.origin = trap_5_1.origin + (0,0,1000);
		trap_5_2.origin = trap_5_2.origin - (0,0,1000);
		thread trap_5_deathcheck(trap_5_2);
		wait 1.5;
		trap_5_2.origin = trap_5_2.origin + (0,0,1000);
		trap_5_3.origin = trap_5_3.origin - (0,0,1000);
		thread trap_5_deathcheck(trap_5_3);
		wait 1.5;
		trap_5_3.origin = trap_5_3.origin + (0,0,1000);
	}
}

trap_5_deathcheck(trap) {
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++) {
		if(players[i] IsTouching(trap)) {
			players[i] suicide();
		}
	}
}

trap_6() {
	trap_6_trigger = GetEnt("trap_6_trigger", "targetname");
	trap_6 = GetEnt("trap_6", "targetname");

	thread arrow_logic("trap_6", trap_6_trigger);

	trap_6_trigger setHintString("- Trap^1 6 ^7- ^7Press ^3[&&1] \n^7- Push off Ladder");
    trap_6_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_6_trigger.target, "targetname"));
    trap_6_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_6");

	initial_position = trap_6.origin;
	activated_position = initial_position - (76,0,0);
	for(;;) {
	trap_6 Moveto(activated_position, 1.5);
	wait 4;
	trap_6 Moveto(initial_position, 1.5);
	wait 4;
	}
}

trap_7() {
	trap_7_trigger = GetEnt("trap_7_trigger", "targetname");
	trap_7 = GetEnt("trap_7", "targetname");

	thread arrow_logic("trap_7", trap_7_trigger);

	trap_7_trigger setHintString("- Trap^1 7 ^7- ^7Press ^3[&&1] \n^7- Make Platform Disappear");
    trap_7_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_7_trigger.target, "targetname"));
    trap_7_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_7");

	initial_position = trap_7.origin;
	trap_7.origin = trap_7.origin + (0,0,1000);
	wait 2;
	trap_7.origin = initial_position;
}

trap_8() {
	trap_8 = GetEnt("trap_8", "targetname");
	trap_8_turn_1 = GetEnt("trap_8_turn_1", "targetname");
	trap_8_turn_2 = GetEnt("trap_8_turn_2", "targetname");
	trap_8_turn_3 = GetEnt("trap_8_turn_3", "targetname");
	trap_8_turn_4 = GetEnt("trap_8_turn_4", "targetname");

	trap_8_trigger = GetEnt("trap_8_trigger", "targetname");

	thread arrow_logic("trap_8", trap_8_trigger);

	trap_8_trigger setHintString("- Trap^1 8 ^7- ^7Press ^3[&&1] \n^7- Tilt First Platform\n^7- Rotate Second Platform\n^7- Flip Third Platform Down\n^7- Rotate Bounce");
    trap_8_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_8_trigger.target, "targetname"));
    trap_8_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_8");

	//trap_8.angles = (0,-45,0);

	trap_8 RotateVelocity((0,0,25), 1000000);
	trap_8_turn_1 RotateVelocity((0,0,15), 1000000);
	trap_8_turn_2 RotateVelocity((0,30,0), 1000000);

	trap_8_turn_3 RotateTo((0,0,90), 1);
	trap_8_turn_4 RotateTo((0,0,-90), 1);
	wait 2;

	for(;;) {
		trap_8_turn_3 RotateTo((0,0,0), 2);
		trap_8_turn_4 RotateTo((0,0,0), 2);
		wait 3;
		trap_8_turn_3 RotateTo((0,0,90), 2);
		trap_8_turn_4 RotateTo((0,0,-90), 2);
		wait 3;
	}

}

trap_9() {
	trap_9_1 = GetEnt("trap_9_1", "targetname");
	trap_9_2 = GetEnt("trap_9_2", "targetname");
	trap_9_3 = GetEnt("trap_9_3", "targetname");
	trap_9_4 = GetEnt("trap_9_4", "targetname");
	trap_9_5 = GetEnt("trap_9_5", "targetname");
	trap_9_6 = GetEnt("trap_9_6", "targetname");
	trap_9_7 = GetEnt("trap_9_7", "targetname");
	trap_9_8 = GetEnt("trap_9_8", "targetname");

	trap_9_trigger = GetEnt("trap_9_trigger", "targetname");

	thread arrow_logic("trap_9", trap_9_trigger);

	trap_9_trigger setHintString("- Trap^1 9 ^7- ^7Press ^3[&&1] \n^7- Push With Walls");
    trap_9_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_9_trigger.target, "targetname"));
    trap_9_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_9");

	waittime = 0.5;
	for(;;) {
		trap_9_1 movex(272,2);
		wait waittime;
		trap_9_2 movex(272,2);
		wait waittime;
		trap_9_3 movex(272,2);
		wait waittime;
		trap_9_4 movex(272,2);
		wait waittime;
		trap_9_5 movex(272,2);
		wait waittime;
		trap_9_6 movex(272,2);
		wait waittime;
		trap_9_7 movex(272,2);
		wait waittime;
		trap_9_8 movex(272,2);
		wait waittime;

		trap_9_1 movex(-272,2);
		wait waittime;
		trap_9_2 movex(-272,2);
		wait waittime;
		trap_9_3 movex(-272,2);
		wait waittime;
		trap_9_4 movex(-272,2);
		wait waittime;
		trap_9_5 movex(-272,2);
		wait waittime;
		trap_9_6 movex(-272,2);
		wait waittime;
		trap_9_7 movex(-272,2);
		wait waittime;
		trap_9_8 movex(-272,2);
		wait waittime;
	}
}

trap_10() {
	trap_10_top_origin = GetEnt("trap_10_top_origin", "targetname");
	trap_10_bot_origin = GetEnt("trap_10_bot_origin", "targetname");

	trap_10_start_origin = GetEnt("trap_10_start_origin", "targetname");
	trap_10_end_origin = GetEnt("trap_10_end_origin", "targetname");

	trap_10_1 = GetEnt("trap_10_1", "targetname");
	trap_10_2 = GetEnt("trap_10_2", "targetname");

	trap_10_1_hurt = GetEnt("trap_10_1_hurt", "targetname");
	trap_10_2_hurt = GetEnt("trap_10_2_hurt", "targetname");


	trap_10_1_hurt EnableLinkTo();
	trap_10_2_hurt EnableLinkTo();
	trap_10_1_hurt LinkTo(trap_10_1);
	trap_10_2_hurt LinkTo(trap_10_2);

	trap_10_trigger = GetEnt("trap_10_trigger", "targetname");

	thread arrow_logic("trap_10", trap_10_trigger);

	trap_10_trigger setHintString("- Trap^1 10 ^7- ^7Press ^3[&&1] \n^7- Hurt With Sweeper");
    trap_10_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_10_trigger.target, "targetname"));
    trap_10_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_10");

	movement_time = 2;
	return_time = 0.25;
	small_move_time = .7;
	offset = (movement_time + return_time + (small_move_time*2) + 0.2)/2;

	trap_10_1 thread trap_10_func(trap_10_start_origin, trap_10_end_origin, trap_10_bot_origin, trap_10_top_origin, movement_time, return_time, small_move_time);
	wait offset;
	trap_10_2 thread trap_10_func(trap_10_start_origin, trap_10_end_origin, trap_10_bot_origin, trap_10_top_origin, movement_time, return_time, small_move_time);
}

trap_10_func(trap_10_start_origin, trap_10_end_origin, trap_10_bot_origin, trap_10_top_origin, movement_time, return_time, small_move_time) {

	for(;;) {
		self moveto(trap_10_start_origin.origin,small_move_time);
		wait small_move_time + 0.05;
		self Rotateyaw(-180, movement_time);
		self moveto(trap_10_end_origin.origin,movement_time);
		wait movement_time + 0.05;
		self moveto(trap_10_bot_origin.origin,small_move_time);
		wait small_move_time + 0.05;
		// self RotateTo((0,270,0), return_time/2);
		// self moveto(trap_10_top_origin.origin,return_time);
		// wait return_time/2;
		// self RotateTo((0,0,0), return_time/2);
		// wait ((return_time/2) + 0.05);
		self.origin = trap_10_top_origin.origin;
		self.angles = (0,0,0);
	}
}

trap_11() {
	trap_11_a = GetEnt("trap_11_a", "targetname");
	trap_11_b = GetEnt("trap_11_b", "targetname");
	trap_11_c = GetEnt("trap_11_c", "targetname");
	trap_11_d = GetEnt("trap_11_d", "targetname");
	trap_11_e = GetEnt("trap_11_e", "targetname");
	trap_11_f = GetEnt("trap_11_f", "targetname");
	trap_11_g = GetEnt("trap_11_g", "targetname");

	trap_11_1 = GetEnt("trap_11_1", "targetname");
	trap_11_2 = GetEnt("trap_11_2", "targetname");
	trap_11_3 = GetEnt("trap_11_3", "targetname");
	trap_11_4 = GetEnt("trap_11_4", "targetname");
	trap_11_5 = GetEnt("trap_11_5", "targetname");
	trap_11_6 = GetEnt("trap_11_6", "targetname");

	trap_11_trigger = GetEnt("trap_11_trigger", "targetname");

	thread arrow_logic("trap_11", trap_11_trigger);

	trap_11_trigger setHintString("- Trap^1 11 ^7- ^7Press ^3[&&1] \n^7- Lower Walls And Sweep");
    trap_11_trigger waittill ("trigger");
	thread valve_rotate(GetEnt(trap_11_trigger.target, "targetname"));
    trap_11_trigger setHintString("- ^1Activated ^7-");

	arrow_kill_notify("trap_11");

	movement_time = 1;

	initial = 1.5;

	trap_11_1 moveto(trap_11_a.origin,initial, movement_time/4, movement_time/4);
	trap_11_2 moveto(trap_11_b.origin,initial, movement_time/4, movement_time/4);
	trap_11_3 moveto(trap_11_c.origin,initial, movement_time/4, movement_time/4);
	trap_11_4 moveto(trap_11_d.origin,initial, movement_time/4, movement_time/4);
	trap_11_5 moveto(trap_11_e.origin,initial, movement_time/4, movement_time/4);
	trap_11_6 moveto(trap_11_f.origin,initial, movement_time/4, movement_time/4);

	wait initial + 0.5;

	for(;;) {
		trap_11_1 moveto(trap_11_b.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_2 moveto(trap_11_c.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_3 moveto(trap_11_d.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_4 moveto(trap_11_e.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_5 moveto(trap_11_f.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_6 moveto(trap_11_g.origin,movement_time, movement_time/4, movement_time/4);

		wait movement_time*1.25;

		trap_11_1 moveto(trap_11_a.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_2 moveto(trap_11_b.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_3 moveto(trap_11_c.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_4 moveto(trap_11_d.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_5 moveto(trap_11_e.origin,movement_time, movement_time/4, movement_time/4);
		trap_11_6 moveto(trap_11_f.origin,movement_time, movement_time/4, movement_time/4);

		wait movement_time*1.25;
	}
}

valve_rotate(ent) {
	ent RotateRoll(1800, 4, 1, 1);
}

arrow_kill_notify(string) {
	level notify(string);
}

arrow_kill_on_freerun(string) {
	level waittill_any( "round_freerun", string );
	wait 0.25;
	self delete();
}

arrow_logic(string, trigger) {
	level endon(string);
	arrows = GetEntArray(string + "_arrow", "targetname");
	for(d=0;d<arrows.size;d++) {
		arrows[d] thread arrow_movement_logic();
		arrows[d] thread arrow_kill_on_freerun(string);
	}

	for(;;) {
		wait 0.05;
		players = getentarray("player", "classname");
		touching_players = [];
		for(i=0;i<players.size;i++) {
			if(players[i] istouching(trigger)) {
				touching_players[touching_players.size] = players[i];
			}
		}
		for(j=0;j<arrows.size;j++) {
			if(isdefined(arrows[j])) {
				arrows[j] Hide();
				for(k=0;k<touching_players.size;k++)
					arrows[j] ShowToPlayer(touching_players[k]);
			}
		}
	}
}

arrow_movement_logic() {
	self endon("death");

	forward = AnglesToForward(self.angles);
	initial_pos = self.origin;
	moveto_pos = self.origin + (forward*30);
	for(;;) {
		self MoveTo(moveto_pos, 1.5, 0.5, 0.5);
		wait 1.6;
		self MoveTo(initial_pos, 1.5, 0.5, 0.5);
		wait 1.6;
	}
}

// setvelocity(gay4x) {
// 	//fuck cod4x gay bithes
// }