/*
	Triumph - mp_dr_smg
	Created by: #FNRP#Arfy
	
	Map NO: 3

	Super Mario Galaxy themed map based on the Melty Molten Galaxy level.
	Feel free to use anything from this script file but I may warn you that
	without adding the custom animations directly to the mod you will be
	unable to load this map.
*/

#include common_scripts\utility;

main(){
	
	//Precaching
	//precacheModel("galaxy_luma");
	//precacheModel("galaxy_rock");
	//precacheModel("galaxy_starbit_purple_m");
	//precacheModel("galaxy_starbit_yellow_m");
	//precacheModel("galaxy_starbit_red_m");
	//precacheModel("galaxy_starbit_blue_m");
	//precacheModel("galaxy_starbit_grey_m");
	//precacheModel("galaxy_starbit_green_m");
	//precacheModel("galaxy_coin");
	
	//precacheItem("galaxy_luma_idle_mp");
	//precacheMenu( "smg_music_menu" );
	//precacheItem( "remington700_mp" );
	//precacheItem( "m40a3_mp" );
	//precacheItem( "knife_mp" );
	//precacheItem( "wii_remote_mp" );
	
	maps\mp\_load::main();

	thread sr\api\_map::createSpawn((1152, -1808, 10323), 240);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread custom_tp();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	addTriggerToList( "trap1_trig" );
	addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
	addTriggerToList( "trap4_trig" );
	
	//LoadFX
	//level.fx_steam = loadFx("galaxy/air_steam");
	//level.fx_lp_1 = loadFX("galaxy/lava_particle_1");

	// Launch Star Setup
	//thread smallLaunchStar("launchstar_small_1","ls_trig_1",(824, 1896, 11144),(624, 896, 10456),(400, 400, 1000),3.2);
	//thread smallLaunchStar("launchstar_small_2","ls_trig_2",(624, 896, 10456),(848, 392, 10992),(415, 415, 1040),2);
	//thread smallLaunchStar("launchstar_small_3","ls_trig_3",(848, 392, 10992),(1128, -274, 11784),(465, 465, 1275),2.45);
	//thread smallLaunchStar("launchstar_small_4","ls_trig_4",(1128, -274, 10450),(1128, -274, 11784),(0, 0, 1475),2);
	//thread largeLaunchStar("launchstar_inner_1", "launchstar_outer_1");

	// Moving Objects
	//thread movingPlat1("movingplat_1", "movingplat_1_trig_1", "movingplat_1_trig_2");
	//thread movingPlat2("movingplat_2", "movingplat_2_trig", "movingplat_2_collision");
	//thread movingPlat3("movingplat_3", "movingplat_3_trig", "movingplat_3_collision");

	// Coins
	coins = getEntArray("coins", "targetname");
	for( i = 0; i < coins.size; i++)
		coins[i] delete();
	
	// StarBits
	starbits = getentarray("starbit", "targetname");
	for(i = 0; i < starbits.size; i++)
		starbits[i] delete();
	
	// OneUps
	oneups = getEntArray("oneup", "targetname");
	for(i = 0; i < oneups.size; i++)
		oneups[i] delete();
	
	//thread questionblock("questionblock_1", "questionblock_1_trig");
	//thread questionblock("questionblock_2", "questionblock_2_trig");
	
	// Steam Sprayers
	steam = getEntArray("steam_hurt", "targetname");
	for(i = 0; i < steam.size; i++)
		steam[i] delete();
	
	// Lava Geysers
	//thread lavaGeyserGroup1();*/
	
	// Wall Jumps
	thread wall_jump("wall_jump_1", 200, -120, -45);
	thread wall_jump("wall_jump_2", 200, -60, -45);
	//#3 activated on rock_drop
	thread wall_jump("wall_jump_4", 180, -60, -45);
	thread wall_jump("wall_jump_5", 180, -120, -45);
	thread wall_jump("wall_jump_6", 180, -60, -45);
	thread wall_jump("wall_jump_3", 200, -120, -45);
	thread wall_jump("wall_jump_7", 200, -120, -45);
	thread wall_jump("wall_jump_8", 200, -60, -45);
	thread wall_jump("wall_jump_9", 180, -60, 90);
	thread wall_jump("wall_jump_10", 180, -120, 90);
	//#7 activated on rock_drop
	//#8 activated on rock_drop
	
	// Rock Drop
	thread rock_drop();
	thread stage2_rock_drop_2();
	
	// Star Bit Oval Stage 1
	//thread starbit_oval();

	// Miscellaneous 
	//thread music_luma();
	//thread credits();
	
	//End Rooms
	//thread sniper_room();
	//thread knife_room();
	//thread wiimote_room();
	
	thread startdoor();
	
	// Traps
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	
	// Trap Teleports
	//thread next_trap_teleport("trap_next_1", "trap_next_1_origin");
	//thread next_trap_teleport("trap_next_2", "trap_next_2_origin");
	//thread next_trap_teleport("trap_next_3", "trap_next_3_origin");
	//thread next_trap_teleport("trap_next_4", "trap_next_4_origin");
	
	//h3 = getent("launch_hint", "targetname");
	//h3 setHintString("Press ^5[Use] ^7to Launch");
}
custom_tp()
{
	trig = spawn("trigger_radius",(840.693, 1926.64, 11100.9), 0,145, 120);
	trig.radius = 145;
	
	ori_t = spawn("script_origin",(-3762,360,-10780));
	ori_t.angles = (0,331,0);

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);


		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
		player freeze_on_tps(0.1);
	}
}

freeze_on_tps(time) {
	self freezecontrols(true);
	self thread freeze_on_tps_repeat(time);
}
freeze_on_tps_repeat(time) {
	wait time;
	self freezecontrols(false);
}
removeBots(){
	players = getAllPlayers();
	
	for(i = 0; i < players.size; i++){
		if(isDefined(players[i].pers["isBot"]) && players[i].pers["isBot"])
			kick(players[i] getEntityNumber());
	}
}

startdoor(){
	door = getent("startdoor", "targetname");

	wait 0.1;

	door delete();
}

addTriggerToList(name)
{
    if(!isDefined( level.trapTriggers ))
        level.trapTriggers = [];
	
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

credits(){
	level waittill("round_started");
	while(1){
		iprintln("Map Made by ^2#FNRP#Arfy");
		wait 5;
		iprintln("Map Still Semi ^8WIP ^7Expect Some Bugs");
		wait 5;
		iprintln("Thanks to ^2xoxor4d^7 for shader help");
		wait 5;
		iprintln("Thanks to ^5kej^7 for model conversion tools");
		wait 5;
		iprintln("Thanks to ^6FNRP-Muffinator^7 for testing");
		wait 45;
	}
}

/////////////////////////////////////////////////////////////////
/////////////////////////////EndRooms////////////////////////////
/////////////////////////////////////////////////////////////////

sniper_room(){
	trig = getent("sniper_room_trig", "targetname");
	trig setHintString("^3Sniper");
	jumper_dest = getent("endroom_jumper","targetname");
	acti_dest = getent("endroom_acti","targetname");	
	
	level endon("knife_chosen");
	level endon("wiimote_chosen");
	
	trig waittill("trigger", p);
	level notify("sniper_chosen");
	
	while(1){
		if(isDefined(p)){
			p give_weaponS();
			p setOrigin(jumper_dest.origin);
			p setplayerangles(jumper_dest.angles);
			p freezeControls(1);
		}
		
		if(isDefined(level.activ)){
			level.activ give_weaponS();
			level.activ setOrigin(acti_dest.origin);
			level.activ setplayerangles(acti_dest.angles);
			level.activ freezeControls(1);
		}
		
		if(isDefined(p) && isDefined(level.activ))
			p endRoomCountdown();
		
		if(isDefined(level.activ))
			level.activ freezeControls(0);
		if(isDefined(p))
			p freezeControls(0);
		
		
		p waittill_any("death", "disconnect");
		if(isDefined(p))
			iprintlnbold(p.name + " has been killed Sniper room open.");
		
		wait 0.25;
		
		trig waittill("trigger", p);
	}
}

give_weaponS()
{
	self takeallweapons();
	self GiveWeapon( "remington700_mp" );
	self GiveWeapon( "m40a3_mp" );
	self GiveMaxAmmo( "remington700_mp" );
	self GiveMaxAmmo( "m40a3_mp" );
    self SwitchtoWeapon( "remington700_mp" );
}

knife_room(){
	trig = getent("knife_room_trig", "targetname");
	trig setHintString("^3Knife");
	jumper_dest = getent("endroom_jumper","targetname");
	acti_dest = getent("endroom_acti","targetname");	

	level endon("sniper_chosen");
	level endon("wiimote_chosen");
	
	trig waittill("trigger", p);
	level notify("knife_chosen");
	
	while(1){
		if(isDefined(p)){
			p takeallweapons();
			p giveweapon("knife_mp");
			wait 0.05;
			p switchtoweapon("knife_mp");
			p setOrigin(jumper_dest.origin);
			p setplayerangles(jumper_dest.angles);
			p freezeControls(1);
		}
		
		if(isDefined(level.activ)){
			level.activ takeallweapons();
			level.activ giveweapon("knife_mp");
			wait 0.05;
			level.activ switchtoweapon("knife_mp");
			level.activ setOrigin(acti_dest.origin);
			level.activ setplayerangles(acti_dest.angles);
			level.activ freezeControls(1);
		}
		
		if(isDefined(p) && isDefined(level.activ))
			p endRoomCountdown();
		
		if(isDefined(level.activ))
			level.activ freezeControls(0);
		if(isDefined(p))
			p freezeControls(0);
		
		
		p waittill_any("death", "disconnect");
		if(isDefined(p))
			iprintlnbold(p.name + " has been killed Knife room open.");
		
		wait 0.25;
		
		trig waittill("trigger", p);
	}

}

wiimote_room(){
	trig = getent("wiimote_room_trig", "targetname");
	trig setHintString("^3Starbitz");
	jumper_dest = getent("endroom_jumper","targetname");
	acti_dest = getent("endroom_acti","targetname");	

	level endon("sniper_chosen");
	level endon("knife_chosen");

	trig waittill("trigger", p);
	level notify("wiimote_chosen");
	
	while(1){
		if(isDefined(p)){
			p takeallweapons();
			p giveweapon("wii_remote_mp");
			p givemaxammo("wii_remote_mp");
			wait 0.05;
			p switchtoweapon("wii_remote_mp");
			p setOrigin(jumper_dest.origin);
			p setplayerangles(jumper_dest.angles);
			p freezeControls(1);
		}
		
		if(isDefined(level.activ)){
			level.activ takeallweapons();
			level.activ giveweapon("wii_remote_mp");
			level.activ givemaxammo("wii_remote_mp");
			wait 0.05;
			level.activ switchtoweapon("wii_remote_mp");
			level.activ setOrigin(acti_dest.origin);
			level.activ setplayerangles(acti_dest.angles);
			level.activ freezeControls(1);
		}
		
		if(isDefined(p) && isDefined(level.activ))
			p endRoomCountdown();
		
		if(isDefined(level.activ))
			level.activ freezeControls(0);
		if(isDefined(p))
			p freezeControls(0);
		
		
		p waittill_any("death", "disconnect");
		if(isDefined(p))
			iprintlnbold(p.name + " has been killed StarBitz room open.");
		
		wait 0.25;
		
		trig waittill("trigger", p);
	}
}

endRoomCountdown(){
	self endon("death");
	level.activ endon("death");
	self endon("disconnect");
	level.activ endon("disconnect");
	
	self iprintlnbold("Starting in...");
	level.activ iprintlnbold("Starting in...");
	wait 1;
	self iprintlnbold("3");
	level.activ iprintlnbold("3");
	wait 1;
	self iprintlnbold("2");
	level.activ iprintlnbold("2");
	wait 1;
	self iprintlnbold("1");
	level.activ iprintlnbold("1");
	wait 1;
	self iprintlnbold("G0!");
	level.activ iprintlnbold("G0!");
}

/////////////////////////////////////////////////////////////////
///////////////////////////Collectables//////////////////////////
/////////////////////////////////////////////////////////////////

coin(){
	self endon("collected");
	self thread coinCollection();
	while(1){
		self rotateYaw(360, 1);
		wait 1;
	}
}

coinCollection(){
	trigger = spawn("trigger_radius", self.origin, 0, 40, 50);
	trigger waittill("trigger", player);
	player playLocalSound("coin_collected");
	self notify("collected");
	player thread braxi\_rank::giveRankXp("", 50 );
	trigger delete();
	self delete();
}

starbit(){
	trigger = spawn("trigger_radius", self.origin, 0, 30, 30);
	trigger waittill("trigger", player);
	player thread braxi\_rank::giveRankXp("", 25 );
	player playLocalSound("starbit");
	trigger delete();
	self delete();
}

oneup(){
	trigger = spawn("trigger_radius", self.origin, 0, 40, 50);
	trigger waittill("trigger", player);
	player braxi\_mod::giveLife();
	player playLocalSound("oneup");
	trigger delete();
	self delete();
}

questionblock(ent_name, ent_trig_name){
	ent = getent(ent_name, "targetname");
	trig = getent(ent_trig_name, "targetname");

	for(i = 0; i < 5; i++){
		trig waittill("trigger", player);
		
		coin = spawn("script_model", ent.origin + (0,0,32));
		coin setModel("galaxy_coin");
		
		player playLocalSound("coin_collected");
		coin moveZ(64, .75);
		wait .75;
		
		player thread braxi\_rank::giveRankXp("", 50 );
		
		coin delete();
	}
	ent delete();
}

starbit_oval(){
	pathid = [];
	for(i = 1; i <= 14; i++){
		pathid[i-1] = getent("starbit_path_"+i, "targetname");
	}
	
	starbits = [];
	for(i=0; i < pathid.size; i++){
		ran = randomInt(6);
		color = "purple";
		switch(ran){
			case 0:
				color = "purple";
				break;
			case 1:
				color = "yellow";
				break;
			case 2:
				color = "grey";
				break;
			case 3:
				color = "red";
				break;
			case 4:
				color = "blue";
				break;
			case 5:
				color = "green";
				break;
		}
		starbits[i] = spawn("script_model", pathid[i].origin);
		starbits[i] setModel("galaxy_starbit_"+color+"_m");
	}
	
	wait 0.01;
	
	while(1){
		for(i=0; i < starbits.size; i++){
			for(j=0; j < starbits.size; j++){
				pathNumber = i + j;
				if(pathNumber >= 14){
					pathNumber -= 14;
				}
				starbits[j] moveTo(pathid[pathNumber].origin,5);
			}
			wait 5;
		}
	}
}

/////////////////////////////////////////////////////////////////
//////////////////////////////Traps//////////////////////////////
/////////////////////////////////////////////////////////////////

next_trap_teleport(trig_name, origin_name){
	trig = getent(trig_name, "targetname");
	trig setHintString("^5Next Trap");
	origin = getent(origin_name, "targetname");
	
	while(1){
		trig waittill("trigger", player);
		player setOrigin(origin.origin);
		player setplayerangles(origin.angles);
		wait 0.1;
	}
}

trap1(){
	trig = getent("trap1_trig", "targetname");
	trig setHintString("Press ^5[Use] ^7to Speed up Lava Geysers");
	trig waittill("trigger");

}

trap2(){
	origins = getentarray("trap2_origin", "targetname");
	trig = getent("trap2_trig", "targetname");
	trig setHintString("Press ^5[Use] ^7to Activate Wall Steam");
	trig waittill("trigger");

}

trap3(){
	model = getent("trap3_model", "targetname");
	coll = getent("trap3_collision", "targetname");
	hurt = getent("trap3_hurt", "targetname");
	trig = getent("trap3_trig", "targetname");
	trig setHintString("Press ^5[Use] ^7to Drop Rock");
	trig waittill("trigger");
	
}

trap4(){
	trig = getent("trap4_trig", "targetname");
	trig setHintString("Press ^5[Use] ^7to Start Rolling Boulders");

	rock1 = getent("trap4_rock_model_1", "targetname");
	rock2 = getent("trap4_rock_model_2", "targetname");
	rock3 = getent("trap4_rock_model_3", "targetname");
	
	rock1_hurt = getent("rock1_hurt", "targetname");
	rock2_hurt = getent("rock2_hurt", "targetname");
	rock3_hurt = getent("rock3_hurt", "targetname");

	rock1_hurt enablelinkto();
	rock2_hurt enablelinkto();
	rock3_hurt enablelinkto();
	
	rock1_hurt linkto(rock1);
	rock2_hurt linkto(rock2);
	rock3_hurt linkto(rock3);

	rock1_origin = rock1.origin;
	rock2_origin = rock2.origin;
	rock3_origin = rock3.origin;

	trig waittill("trigger");

}

roll_rock1(origin){
	self rotateVelocity((0, 0, -180), 3.75);

	self moveTo((406,588,-9781), 1);
	wait 1;
	self moveTo((438, 636, -9974),0.75);
	wait 0.75;
	self moveTo((554, 780, -9973),1);
	wait 1;
	self moveTo((710, 1004, -10581),1);
	wait 1;
	
	self moveTo(origin, 0.01);
}

roll_rock2(origin){
	self rotateVelocity((0, 0, -180), 3.75);

	self moveTo((-10,700,-9813), 1);
	wait 1;
	self moveTo((-10, 732, -9915),0.5);
	wait 0.5;
	self moveTo((-25, 876, -9909),0.75);
	wait 0.75;
	self moveTo((-73, 1260, -10629),1.25);
	wait 1.25;
	
	self moveTo(origin, 0.01);
}

roll_rock3(origin){
	self rotateVelocity((0, 0, -180), 3.75);

	self moveTo((-377,604,-9773), 1);
	wait 1;
	self moveTo((-393, 620, -9853),0.5);
	wait 0.5;
	self moveTo((-473, 748, -9869),0.75);
	wait 0.75;
	self moveTo((-665, 1020, -10573),1.5);
	wait 1.5;
	
	self moveTo(origin, 0.01);
}

music_luma(){
	thread music_menu();
	
	removeBots();
	
	level waittill("round_started");
	
	wait 1;
	ent = addtestclient();
	ent.pers["isBot"] = true;
	ent.pers["registered"] = 0;
	orig = getent("luma_spawn", "targetname");

	while(!isdefined(ent.pers["team"]))
		wait .05;
	
	ent notify("menuresponse", game["menu_team"], "autoassign");
	wait 0.25;
	ent setOrigin(orig.origin);
	ent setPlayerAngles((0,-45,0));
	ent setModel("galaxy_luma");
	ent.pers["weapon"] = "galaxy_luma_idle_mp";
	ent thread botWeapons();
	
	while(1){
		players = getplayingplayers();
	
		ignorePlayers = [];
		
		for(i = 0; i < players.size; i++){
			if(isDefined(players[i].pers["isBot"]) && players[i].pers["isBot"] == true || (isDefined(level.activ) && players[i] == level.activ) || isDefined(players[i].ghost) && players[i].ghost){
				continue;
			}
			ignorePlayers[ignorePlayers.size] = players[i]; 
		}
		
		if(ignorePlayers.size < 1){
			kick(ent getEntityNumber());
			return;
		}
		
		player = compareSizes(ent getOrigin(), ignorePlayers, 400);
		if(isDefined(player)){
			po = player getOrigin();
			angleYaw = vectorToAngles(po - ent getOrigin());
			ent setPlayerAngles((0,angleYaw[1]+90,0));
		}else
			ent setPlayerAngles((0,-45,0));
		wait 0.05;
	}
}

music_menu(){
	level endon("force_music");
	thread playMusicAnyway();

	trig = getent("music_trig", "targetname");
	trig setHintString("Press ^6[Use] ^7to Pick a Song");
	
	trig waittill("trigger", player);
	level notify("music_picked");
	
	trig playSound("luma_talk");
	trig delete();
	player openMenu( "smg_music_menu" );
	player waittill("menuresponse", menu, response);
	
	if( menu == "smg_music_menu" ){
		if(response == "random")
			ambientPlay("ambient"+(randomInt(5)+1));
		else
			ambientPlay(response);
	}else{
		ambientPlay("ambient"+(randomInt(5)+1));
	}
}

playMusicAnyway(){
	level endon("music_picked");
	level waittill("round_started");
	wait 10;
	level notify("force_music");
	ambientPlay("ambient"+(randomInt(5)+1));
}

botWeapons() {
	self endon("disconnect");
	for(;;) {
		self freezecontrols(true);
		self setspawnweapon( "galaxy_luma_idle_mp" );
		self giveWeapon( "galaxy_luma_idle_mp" );
		self switchToWeapon( "galaxy_luma_idle_mp" );
	
		wait 0.05;
	}
}

lavaGeyserGroup1(){
	geysers = getentarray("lavageyser_group1", "targetname");
	hurt = getent("geyser_hurt", "targetname");
	
	hurt enablelinkto();
	hurt linkto(geysers[0]);
	
	level.geyserWait = 5;
	
	while(1){
		wait level.geyserWait;
		for(i = 0; i < geysers.size; i++)
			geysers[i] moveZ(400, 1);
		geysers[geysers.size-1] waittill("movedone");
		
		geysers geyserBob();
		geysers geyserBob();
		geysers geyserBob();
		geysers geyserBob();
		geysers geyserBob();
		geysers geyserBob();
		geysers geyserBob();
		geysers geyserBob();
	
		for(i = 0; i < geysers.size; i++)
			geysers[i] moveZ(-400, 1);
	}
}

geyserBob(){
	for(i = 0; i < self.size; i++){
		self[i] moveZ(-50, 0.25);
		playFX(level.fx_lp_1, self[i].origin);
	}
	self[self.size-1] waittill("movedone");
	
	for(i = 0; i < self.size; i++)
		self[i] moveZ(50, 0.25);
	self[self.size-1] waittill("movedone");
}

wall_jump(trig_name, strength, angle, direction){
	level endon("disable_"+trig_name);
	trigger = getent(trig_name, "targetname");
	
	trigger setHintString("^5Press [Use] When Next to Wall To WallJump");
	
	multiplier = 3;

	while(1){
		trigger waittill("trigger", player);
	
		if(!isDefined(player.wall_jumped) || player.wall_jumped == false){
			if (isalive(player) && isdefined(player))
			{
				player.wall_jumped = true;
				player thread jump_cooldown();
			
				oldpos = player.origin;
				
				for(i = 0; i < multiplier; i++)
				{
					player.health += strength;
					player finishPlayerDamage(player, level.jumpattacker, strength, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((angle,direction,0)), "none", 0);
				}
			}
		}
	}
}

jump_cooldown(){
	self endon("death");
	self endon("disconnect");
	wait 0.5;
	self.wall_jumped = false;
}	

rock_drop(){
	ent1 = getent("rock_drop_1","targetname");
	coll1 = getent("rock_drop_1_collision", "targetname");
	
	ent2 = getent("rock_drop_2","targetname");
	coll2 = getent("rock_drop_2_collision", "targetname");
	
	moveTrig = getent("wall_jump_3", "targetname");

	wait 0.1;
	
	ent1 movez(-220,0.1);
	coll1 movez(-220,0.1);
	ent2 movez(-580,0.1);
	coll2 movez(-580,0.1);
}

steam(){
	self maps\mp\_utility::triggerOff();
	while(1){
		wait 2+randomInt(4);
		self maps\mp\_utility::triggerOn();
		playfx(level.fx_steam, self.realOrigin - (0,0,35));
		wait 1.5;
		self maps\mp\_utility::triggerOff();
	}
}

movingPlat1(ent_name, trig1_name, trig2_name){
	plat = getent(ent_name, "targetname");
	trig1 = getent(trig1_name, "targetname");
	trig2 = getent(trig2_name, "targetname");
	collision = getent("movingplat_1_collision", "targetname");
	
	trig1 enablelinkto();
	trig2 enablelinkto();
	
	trig1 linkto(plat);
	trig2 linkto(plat);
	//collision linkto(plat);

	collision rotateTo((0,125,0), 0.05);
	wait 0.05;
	
	if(1){
		return;
	}
	while(1){
		
		balance = 0;
	
		players = getPlayingPlayers();
		for(i = 0; i < players.size; i++){
			if(!isDefined(players[i]) || players[i].ghost == true)
				continue;
			if(players[i] isTouching(trig1))
				balance++;
			if(players[i] isTouching(trig2))
				balance--;
		}
		
		if(balance == 0){
			plat rotateTo((0,125,0), 5);
			collision rotateTo((0,125,0), 5);
		}else if(balance < 0){
			plat rotateVelocity((10,0,0), .1);
			collision rotateVelocity((10,0,0), .1);
		}else if(balance > 0){
			plat rotateVelocity((-10,0,0), 10);
			collision rotateVelocity((-10,0,0), .1);
		}
	
		wait 0.1;
	}
}

movingPlat2(ent_name, trig_name, collision_name){
	plat = getent(ent_name, "targetname");
	trig = getent(trig_name, "targetname");
	collision = getent(collision_name, "targetname");
	
	trig enablelinkto();
	trig linkto(plat);
	
	while(1){
		touching = false;
	
		players = getPlayingPlayers();
		for(i = 0; i < players.size; i++){
			if(players[i] isTouching(trig)){
				touching = true;
				break;
			}
		}
		
		if(touching == true){
			plat moveTo((-640,256,9840), 5);
			collision moveTo((-640,256.5,9840), 5);
		}else{
			plat moveTo((-640, 256, 10044), 1);
			collision moveTo((-640,256,10044), 1);
		}
		
		wait 0.1;
	}
	
	
}

movingPlat3(ent_name, trig_name, collision_name){
	plat = getent(ent_name, "targetname");
	trig = getent(trig_name, "targetname");
	collision = getent(collision_name, "targetname");
	
	trig enablelinkto();
	trig linkto(plat);
	
	while(1){
		touching = false;
	
		players = getPlayingPlayers();
		for(i = 0; i < players.size; i++){
			if(players[i] isTouching(trig)){
				touching = true;
				break;
			}
		}
		
		if(touching == true){
			plat moveTo((-566,1493,9696), 5);
			collision moveTo((-722.5,1025,9915), 5);
		}else{
			plat moveTo((-566, 1493, 10196), 1);
			collision moveTo((-722.5,1025,10415), 1);
		}
		
		wait 0.5;
	}
}

stage2_rock_drop_2(){
	drop = getent("stage2_rock_drop_2", "targetname");
	model = getent("stage2_rock_drop_2_model", "targetname");
	ladder = getent("stage2_rock_drop_2_ladder", "targetname");
	trigger = getent("stage2_rock_drop_2_trigger", "targetname");
	
	ladder delete();
	
	drop moveZ(-599, 0.1);
	model moveZ(-599, 0.1);
	
}

/////////////////////////////////////////////////////////////////
///////////////////////////Launch Stars//////////////////////////
/////////////////////////////////////////////////////////////////

smallLaunchStar(ent_name, trigger_name, orig1, orig2, magnitude, time){
	thread launcher(trigger_name, orig1, orig2, magnitude, time);
	ls = getent(ent_name, "targetname");
	ls rotateTo((10, 0, 0), 1);
	wait 1;
	ls playLoopSound("launch_aura");
	while(1){
		ls rotateTo((-10,0,-10), 0.625,0 ,0);
		wait 0.625-0.1;
		ls rotateTo((-10,0,10), 0.625,0 ,0);
		wait 0.625-0.1;
		ls rotateTo((10,0,10), 0.625,0 ,0);
		wait 0.625-0.1;
		ls rotateTo((10,0,-10), 0.625,0 ,0);
		wait 0.625-0.1;
	}
}

launcher(trigger_name, orig1, orig2, magnitude, time){
	trig = getent(trigger_name, "targetname");
	trig setHintString("^5Press [Use] to Launch");
	while(1){
		trig waittill("trigger", player);
		if(isDefined(player.launching) && player.launching)
			continue;
		player.launching = true;
		player thread launchStarLaunch(orig1, orig2, magnitude, time);
	}
}

large_Launcher(){
	trig = getent("ls_trig_5", "targetname");
	
	origins = [];
	for(i = 0; i < 7; i++){
		origin = getent("launch_origin_"+(i+1), "targetname");
		origins[i] = origin.origin;
	}
	
	landingOrigins = [];
	for(i = 0; i < 5; i++){
		origin = getent("land_origin_"+(i+1),"targetname");
		landingOrigins[i] = origin.origin;
	}
	
	while(1){
		trig waittill("trigger", player);
		if(isDefined(player.launching) && player.launching)
			continue;
		player.launching = true;
		player thread large_LaunchStarLaunch(origins, landingOrigins);
	}
}

large_LaunchStarLaunch(origins, landingOrigins){
	self endon("death");
	self endon("disconnect");
	
	link = spawn ( "script_model", self getOrigin());
	self linkto(link);
	
	self playLocalSound("launch");
	link moveTo(origins[0], 0.25);
	wait 0.25;
	
	self playSound("launch_large_star");
	self playLocalSound("launch_star_flying");
	
	//visionSetNaked("mp_dr_smg_launch", 6);
	
	for(i = 1; i < origins.size; i++){
		link moveTo(origins[i], 1);
		wait 1;
	}
	
	link moveTo(landingOrigins[0], 0.01);
	wait 1;
	
	//visionSetNaked("mp_dr_smg", 3.5);
	
	for(i = 1; i < landingOrigins.size; i++){
		link moveTo(landingOrigins[i], 1);
		wait 1;
	}
	
	self stopLocalSound("launch_star_flying");	
	self playLocalSound("launch_star_land");

	self unlink();
	link delete();
	wait 0.01;
	self.launching = false;
}

launchStarLaunch(orig1, orig2, magnitude,time){
	self endon("death");
	self endon("disconnect");
	
	link = spawn ( "script_model", self getOrigin());
	self linkto(link);
	
	self playLocalSound("launch");
	
	link moveTo(orig1, 0.25);
	wait 0.25;
	
	normal = vectorNormalize(orig2 - orig1);
	force = (normal[0]*magnitude[0], normal[1]*magnitude[1], magnitude[2]);
	link movegravity(force, time);
	
	wait time-0.085;
	self unlink();
	link delete();
	wait 0.01;
	self.launching = false;
}

largeLaunchStar(ent_in, ent_out){
	ls_in = getent(ent_in, "targetname");
	ls_out = getent(ent_out, "targetname");
	thread large_Launcher();
	ls_in thread moveInnerStar();
	ls_out thread moveOuterStar();
}

moveOuterStar(){
	self rotateTo((5.5, 0, 8.5), 1);
	wait 1;
	while(1){	
		self rotateTo((9.25, 0, 6.25), 0.25);
		wait 0.25;
		self rotateTo((10, 0, 0.75), 0.25);
		wait 0.25;
		self rotateTo((7.25, 0, -5.5), 0.25);
		wait 0.25;
		self rotateTo((1.5, 0, -17), 0.25);
		wait 0.25;
		self rotateTo((-4.75, 0, -8.75), 0.25);
		wait 0.25;
		self rotateTo((-9, 0, -4.25), 0.25);
		wait 0.25;
		self rotateTo((-9.25, 0, 2), 0.25);
		wait 0.25;
		self rotateTo((-3.75, 0, 7.5), 0.25);
		wait 0.25;
		self rotateTo((2.25, 0, 10), 0.25);
		wait 0.25;
		self rotateTo((5, 0, 8.5), 0.25);
		wait 0.25;
	}
}

moveInnerStar(){
	self rotateTo((16.5, 0, 9.25), 1);
	wait 1;
	while(1){
		self rotateTo((19.25, 0, 3.5), 0.25);
		wait 0.25;
		self rotateTo((14.5, 0, -9.5), 0.25);
		wait 0.25;
		self rotateTo((4, 0, -18.75), 0.25);
		wait 0.25;
		self rotateTo((-7.75, 0, -17), 0.25);
		wait 0.25;
		self rotateTo((-16.75, 0, -8.5), 0.25);
		wait 0.25;
		self rotateTo((-19, 0, 3), 0.25);
		wait 0.25;
		self rotateTo((-11.5, 0, 13.25), 0.25);
		wait 0.25;
		self rotateTo((0.75, 0, 19), 0.25);
		wait 0.25;
		self rotateTo((12, 0, 15), 0.25);
		wait 0.25;
		self rotateTo((16.5, 0, 9.25), 0.25);
		wait 0.25;
	}
}

/*
	Common commands so I don't have to include a large amount of scripts
*/
getPlayingPlayers()
{
  players = getAllPlayers();
  array = [];
  for( i = 0; i < players.size; i++ )
  {
    if( players[i] isReallyAlive() && players[i].pers["team"] != "spectator" ) 
      array[array.size] = players[i];
  }
  return array;
}

isReallyAlive()
{
  if( self.sessionstate == "playing" )
    return true;
  return false;
}

getAllPlayers()
{
  return getEntArray( "player", "classname" );
}

compareSizes( org, array, dist)
{
	if( !array.size )
		return undefined;
	if( isdefined( dist ) )
	{
		ent = undefined;
		keys = getArrayKeys( array );
		for( i = 0; i < keys.size; i ++ )
		{
			newdist = distance( array[ keys[ i ] ].origin, org );
			if( newDist >= dist  )
				continue;
			dist = newdist;
			ent = array[ keys[ i ] ];
		}
		return ent;
	}

	keys = getArrayKeys( array );
	ent = array[ keys[ 0 ] ];
	dist = distance( ent.origin, org );
	for( i = 1; i < keys.size; i ++ )
	{
		newdist = distance( array[ keys[ i ] ].origin, org );
		if( newDist >= dist )
			continue;
		dist = newdist;
		ent = array[ keys[ i ] ];
	}
	return ent;
}