/*
 .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| |  _________   | || | _____  _____ | || |     _____    | || |  ____  ____  | || |     ____     | |
| | |  _   _  |  | || ||_   _||_   _|| || |    |_   _|   | || | |_  _||_  _| | || |   .'    `.   | |
| | |_/ | | \_|  | || |  | | /\ | |  | || |      | |     | || |   \ \  / /   | || |  /  .--.  \  | |
| |     | |      | || |  | |/  \| |  | || |      | |     | || |    \ \/ /    | || |  | |    | |  | |
| |    _| |_     | || |  |   /\   |  | || |     _| |_    | || |    _|  |_    | || |  \  `--'  /  | |
| |   |_____|    | || |  |__/  \__|  | || |    |_____|   | || |   |______|   | || |   `.____.'   | |
| |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
 
	mp_dr_fallrun
	Map Made by tEASZY		xFire: nils1172
	Scripted by TwiYo		xFire: 1buzzz		
	
	Created for Braxi's Deathrun 1.2 mod for CoD4
	www.ix-treme.com

*/ 
#include braxi\_common;
#include common_scripts\utility;
main() {
	maps\mp\_load::main();
	
	///////////Precache
	precacheItem("ak74u_mp");
	precacheItem("remington700_mp");
	precacheItem("knife_mp");
	precacheItem("tomahawk_mp");
	precacheItem("deserteagle_mp");
	precacheItem("uzi_mp");
	precacheItem("m4_mp");
	precacheItem("ak47_mp");
	precacheItem("g3_mp");
	precacheItem("m60e4_mp");
	precacheItem("p90_mp");
	precacheItem("m40a3_mp");
	precacheItem("barrett_mp");
	precacheItem("g36c_silencer_mp");
	precacheItem("skorpion_silencer_mp");
	precacheItem("saw_grip_mp");
	precacheItem("m21_mp");
	precacheItem("barrett_mp");
	precacheItem("dragunov_mp");
	precacheItem("m40a3_mp");
	
	////////////Game
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	////////Other Things
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
		thread sr\api\_speedrun::createTeleporter((-1565.43, 159.92, 16.125), 85, 85, (3702, 2677, 1646), 177, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createEndMap((4417.32, -460.744, -8190.88), 130, 30);
	// thread printCredits();
	// thread setupServers();
	// thread mapmusic();
	
	////////Traps
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	addTriggerToList("trap1_trigger");
	addTriggerToList("trap2_trigger");
	addTriggerToList("trap3_trigger");
	addTriggerToList("trap4_trigger");
	addTriggerToList("trap5_trigger");
	addTriggerToList("trap6_trigger");
	
	/////Acti Teleports + Jumper End Teleport
	// thread actitele0();
	// thread actitele1();
	// thread actitele2();
	// thread actitele3();
	// thread actitele4();
	// thread actitele5();
	// thread actitele6();
	// thread actitele7();
	// thread actitele8();
	// thread actitele9();
	// thread actitele10();
	// thread jumperend();
	
	////// Endrooms + Queue
	endroomQueueSetup();
	// thread watchEndrooms();
	// thread SniperRoomTrigger();	
	// thread KnifeRoomTrigger();
	// thread BounceRoomTrigger();
	// thread RandomWeapRoomTrigger();
	// thread oldfight();	
	// thread bounceweap();
	// thread bouncerespawn();
	
	///// Secret
	thread enter();
	thread exit();
	// thread respawn0();
	// thread respawn1();
	// thread respawn2();
	// thread respawn3();
	// thread respawn4();

}


////////////Traps
addTriggerToList( name ){
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1() {
	trigger = getent ("trap1_trigger", "targetname");
	blue = getent ("trap1_blue", "targetname");
	red = getent ("trap1_red", "targetname");
	way = getent ("trap1_redway", "targetname");
	
	level.spikepack0 = getent ("trap1_spike_0", "targetname");	
	level.spikepack1 = getent ("trap1_spike_1", "targetname");	
	level.spikepack2 = getent ("trap1_spike_2", "targetname");	
	level.spikepack3 = getent ("trap1_spike_3", "targetname");	
	level.spikepack4 = getent ("trap1_spike_4", "targetname");	
	
	red hide();
	way hide();
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	
	blue hide();
	red show();
	way show();
	
	// thread spikepack0();
	// thread spikepack1();
	// thread spikepack2();
	// thread spikepack3();
	// thread spikepack4();

	
}

spikepack0() {
	trigger = getent ("trap1_spike_detect_0", "targetname");
	dmg = getent ("trap1_spike_0_dmg", "targetname");
	
	dmg enablelinkto();
	dmg linkto (level.spikepack0);
	
	while(1){
		trigger waittill ("trigger", player);
		
		level.spikepack0 moveZ (50, 0.5);
		level.spikepack0 waittill ("movedone");
		level.spikepack0 moveZ (-50, 0.5);
		level.spikepack0 waittill ("movedone");
	}
}
		

spikepack1() {
	trigger = getent ("trap1_spike_detect_1", "targetname");
	dmg = getent ("trap1_spike_1_dmg", "targetname");
	
	dmg enablelinkto();
	dmg linkto (level.spikepack1);
	
	while(1){
		trigger waittill ("trigger", player);
		
		level.spikepack1 moveZ (50, 0.5);
		level.spikepack1 waittill ("movedone");
		level.spikepack1 moveZ (-50, 0.5);
		level.spikepack1 waittill ("movedone");
	}
}
		

spikepack2() {
	trigger = getent ("trap1_spike_detect_2", "targetname");
	dmg = getent ("trap1_spike_2_dmg", "targetname");
	
	dmg enablelinkto();
	dmg linkto (level.spikepack2);
	
	while(1){
		trigger waittill ("trigger", player);
		
		level.spikepack2 moveZ (50, 0.5);
		level.spikepack2 waittill ("movedone");
		level.spikepack2 moveZ (-50, 0.5);
		level.spikepack2 waittill ("movedone");
	}
}
		

spikepack3() {
	trigger = getent ("trap1_spike_detect_3", "targetname");
	dmg = getent ("trap1_spike_3_dmg", "targetname");
	
	dmg enablelinkto();
	dmg linkto (level.spikepack3);
	
	while(1){
		trigger waittill ("trigger", player);
		
		level.spikepack3 moveZ (50, 0.5);
		level.spikepack3 waittill ("movedone");
		level.spikepack3 moveZ (-50, 0.5);
		level.spikepack3 waittill ("movedone");
	}
}
		

spikepack4() {
	trigger = getent ("trap1_spike_detect_4", "targetname");
	dmg = getent ("trap1_spike_4_dmg", "targetname");
	
	dmg enablelinkto();
	dmg linkto (level.spikepack4);
	
	while(1){
		trigger waittill ("trigger", player);
		
		level.spikepack4 moveZ (50, 0.5);
		level.spikepack4 waittill ("movedone");
		level.spikepack4 moveZ (-50, 0.5);
		level.spikepack4 waittill ("movedone");
	}
}
		
trap2() {
	trigger = getent ("trap2_trigger", "targetname");
	pusher = getent ("trap2_pusher", "targetname");
	door1 = getent ("trap2_door_1", "targetname");
	door2 = getent ("trap2_door_2", "targetname");
	blue = getent ("trap2_blue", "targetname");
	red = getent ("trap2_red", "targetname");
	dmg = getent ("trap2_dmg", "targetname");
	
	dmg enablelinkto();
	dmg linkto(pusher);
	
	red hide();
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	
	door1 movez (-130, 2);
	door2 moveY (-130, 2);
	
	wait 4;
	
	pusher movez (-414, 3.5);
	wait 4;
	
	pusher movez (414, 3.5);
	wait 3.5;
	door1 movez (130, 2);
	door2 movey (130, 2);	
}
		
trap3() {
	trigger = getent ("trap3_trigger", "targetname");
	roll0 = getent ("trap3_roll_0", "targetname");
	roll1 = getent ("trap3_roll_1", "targetname");
	blue = getent ("trap3_blue", "targetname");	
	red = getent ("trap3_red", "targetname");	
		
		
	red hide();
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();	
	
	while(1){
	roll0 rotateroll (360, 1.5);
	roll1 rotateroll (-360, 1.5);
	wait 4.5;
	}
}		
		
trap4() {
	trigger = getent ("trap4_trigger", "targetname");
	blue = getent ("trap4_blue", "targetname");
	red = getent ("trap4_red", "targetname");
	random1 = getent ("trap4_random_1", "targetname");
	random2 = getent ("trap4_random_2", "targetname");
	random3 = getent ("trap4_random_3", "targetname");
	
	red hide();
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();			
		
	random = randomint(3);
	switch(random){
		case 0: random1 notsolid(); break;
		case 1: random2 notsolid(); break;
		case 2: random3 notsolid(); break;
	}
}
	
trap5() {
	trigger = getent ("trap5_trigger", "targetname");
	red = getent ("trap5_red", "targetname");
	blue = getent ("trap5_blue", "targetname");
	plat1 = getent ("trap5_moveplat_1", "targetname");
	plat2 = getent ("trap5_moveplat_2", "targetname");
		
		
	red hide();
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();	
	
	while(1) {
		plat1 moveZ (75, 2);
		plat2 moveZ (-75, 2);
		plat1 waittill ("movedone");
		wait 0.2;
		plat1 moveZ (-150, 2);
		plat2 moveZ (150, 2);
		plat1 waittill ("movedone");
		wait 0.2;
		plat1 moveZ (150, 2);
		plat2 moveZ (-150, 2);
		plat1 waittill ("movedone");
		wait 0.2;
		plat1 moveZ (-75, 2);
		plat2 moveZ (75, 2);
		plat1 waittill ("movedone");
		wait 0.2;
	}
}

trap6() {
	trigger = getent ("trap6_trigger", "targetname");
	red = getent ("trap6_red", "targetname");
	blue = getent ("trap6_blue", "targetname");
	
	spike1 = getent ("trap6_movespike_1", "targetname");
	spike2 = getent ("trap6_movespike_2", "targetname");
	spike3 = getent ("trap6_movespike_3", "targetname");
	
	spike1_dmg = getent ("trap6_movespike_1_dmg", "targetname");
	spike2_dmg = getent ("trap6_movespike_2_dmg", "targetname");
	spike3_dmg = getent ("trap6_movespike_3_dmg", "targetname");
	
	spike1_dmg enablelinkto();
	spike1_dmg linkto(spike1);
	spike2_dmg enablelinkto();
	spike2_dmg linkto(spike2);
	spike3_dmg enablelinkto();
	spike3_dmg linkto(spike3);
	
	red hide();
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();		
	
	while(1) {
		spike1 movex (320, 2);
		spike2 movex (320, 2);
		spike3 movex (-320, 2);
		spike1 waittill ("movedone");
		spike1 movex (-320, 2);
		spike2 movex (-320, 2);
		spike3 movex (320, 2);
		spike1 waittill ("movedone");	
	}
}

//////Acti Teleports
actitele0() {
	trigger = getent ("actiteleport0", "targetname");
	target = getent ("actitarget0", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1next ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

actitele1() {
	trigger = getent ("actiteleport1", "targetname");
	target = getent ("actitarget1", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1previous ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}


actitele2() {
	trigger = getent ("actiteleport2", "targetname");
	target = getent ("actitarget2", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1next ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}


actitele3() {
	trigger = getent ("actiteleport3", "targetname");
	target = getent ("actitarget3", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1previous ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}


actitele4() {
	trigger = getent ("actiteleport4", "targetname");
	target = getent ("actitarget4", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1next ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

actitele5() {
	trigger = getent ("actiteleport5", "targetname");
	target = getent ("actitarget5", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1previous ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

actitele6() {
	trigger = getent ("actiteleport6", "targetname");
	target = getent ("actitarget6", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1next ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

actitele7() {
	trigger = getent ("actiteleport7", "targetname");
	target = getent ("actitarget7", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1previous ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}


actitele8() {
	trigger = getent ("actiteleport8", "targetname");
	target = getent ("actitarget8", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1next ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}


actitele9() {
	trigger = getent ("actiteleport9", "targetname");
	target = getent ("actitarget9", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1previous ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

actitele10() {
	trigger = getent ("actiteleport10", "targetname");
	target = getent ("actitarget10", "targetname");
	
	trigger sethintstring ("Press ^3[^7use^3]^7 to Teleport to the ^1next ^7Stage!");
	
	while(1) {
		trigger waittill ("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

jumperend() {
	trigger = getent ("teleport_jumper_end", "targetname");

	while(1) {
		trigger waittill ("trigger", player);
		player thread teleme();
	}
}

teleme(){
	target = getent ("teleport_jumper_end_target", "targetname");

	
	
		self setorigin (target.origin);
		self setplayerangles (target.angles);
	
}
/////////////////////////Queue

endroomQueueSetup(){
	level.sniper_endroom = getent ("sniper_trigger", "targetname");
	level.knife_trigger = getent ("knife_trigger", "targetname");
	level.bounce_trigger = getent ("bounce_trigger", "targetname");
	level.randomweap_trigger = getent ("randomweap_trigger", "targetname");
	
	players = getPlayingPlayers();
	for( i = 0; i < players.size; i++)
		players[i] thread removePlayerOnStuff();
	
	level.playerQueue = [];
	level.selectedEndroom = "";
	
}

watchEndrooms(){
	
	while(1){
		level waittill("start_endroom_fight", player);
		
		switch( level.selectedEndroom ){
			case "sniper": player thread SniperFight(); break;
			case "knife": player thread KnifeFight(); break;
			case "bounce": player thread BounceFight(); break;
			case "randomweap": player thread RandomWeapFight(); break;
			
		}
	}
}

sniperRoomTrigger(){
	level.sniper_endroom endon( "death" );
	self endon( "kill afk monitor" );

	while( 1 ){
		 level.sniper_endroom waittill("trigger", player);
		
		if( level.selectedEndroom != "" && level.selectedEndroom != "sniper" ){
			iprintlnbold("Other room was chosen and this text should not be visible!"); 
			return;
		}
		
		if( level.selectedEndroom == ""){
			level.knife_trigger delete();
			level.bounce_trigger delete();
			level.randomweap_trigger delete();
			level.oldway_trigger delete();
			level.selectedEndroom = "sniper";
		}
		
		if( arrayContains(level.playerQueue, player) ){
			continue;
		}
			
		if( level.playerQueue.size > 0 ){
			player notify("kill afk monitor");
			level.playerQueue[level.playerQueue.size] = player;
			player iprintlnbold("You are now on place " + level.playerQueue.size + " for the sniper room!");
		}
		else{
			level.playerQueue[level.playerQueue.size] = player;			
			level notify("start_endroom_fight", player);
		}		
	}
}


KnifeRoomTrigger(){
	level.knife_trigger endon("death");

	while( 1 ){
		level.knife_trigger waittill("trigger", player);
		
		if( level.selectedEndroom != "" && level.selectedEndroom != "knife" ){
			iprintlnbold("Other room was chosen and this text should not be visible!"); 
			return;
		}
		
		if( level.selectedEndroom == ""){
			level.sniper_endroom delete();
			level.bounce_trigger delete();	
			level.randomweap_trigger delete();
			level.oldway_trigger delete();
			level.selectedEndroom = "knife";
		}
		
		if( arrayContains(level.playerQueue, player) ){
			continue;
		}
			
		if( level.playerQueue.size > 0 ){
			player notify("kill afk monitor");
			level.playerQueue[level.playerQueue.size] = player;
			player iprintlnbold("You are now on place " + level.playerQueue.size + " for the knife room!");
		}
		else{
			level.playerQueue[level.playerQueue.size] = player;			
			level notify("start_endroom_fight", player);
		}		
	}
}

BounceRoomTrigger(){
	level.bounce_trigger endon("death");

	while( 1 ){
		level.bounce_trigger waittill("trigger", player);
		
		if( level.selectedEndroom != "" && level.selectedEndroom != "bounce" ){
			iprintlnbold("Other room was chosen and this text should not be visible!"); 
			return;
		}
		
		if( level.selectedEndroom == ""){
			level.sniper_endroom delete();
			level.knife_trigger delete();
			level.randomweap_trigger delete();
			level.oldway_trigger delete();
			level.selectedEndroom = "bounce";
		}
		
		if( arrayContains(level.playerQueue, player) ){
			continue;
		}
			
		if( level.playerQueue.size > 0 ){
			player notify("kill afk monitor");
			level.playerQueue[level.playerQueue.size] = player;
			player iprintlnbold("You are now on place " + level.playerQueue.size + " for the bounce room!");
		}
		else{
			level.playerQueue[level.playerQueue.size] = player;			
			level notify("start_endroom_fight", player);
		}		
	}
}

RandomWeapRoomTrigger(){
	level.randomweap_trigger endon("death");

	while( 1 ){
		level.randomweap_trigger waittill("trigger", player);
		
		if( level.selectedEndroom != "" && level.selectedEndroom != "randomweap" ){
			iprintlnbold("Other room was chosen and this text should not be visible!"); 
			return;
		}
		
		if( level.selectedEndroom == ""){
			level.sniper_endroom delete();
			level.knife_trigger delete();
			level.bounce_trigger delete();
			level.oldway_trigger delete();
			level.selectedEndroom = "randomweap";
		}
		
		if( arrayContains(level.playerQueue, player) ){
			continue;
		}
			
		if( level.playerQueue.size > 0 ){
			player notify("kill afk monitor");
			level.playerQueue[level.playerQueue.size] = player;
			player iprintlnbold("You are now on place " + level.playerQueue.size + " for the random weapons room!");
		}
		else{
			level.playerQueue[level.playerQueue.size] = player;			
			level notify("start_endroom_fight", player);
		}		
	}
}

///////////////////// Endrooms

SniperFight(){
	
	self endon("disconnect");
	self endon("player_spectator");

	level.actiorigin = getent ("snip_acti_teleport", "targetname");
	teleorigin = getent ("sniper_jumper_teleport", "targetname");
	
	
	self setorigin (teleorigin.origin);
	self setplayerangles (teleorigin.angles);
	
	wait(0.05);
	
	thread createSelectedRoom(self.name + " ^3 HAS ENTERED THE SNIPER ROOM^7!"); // change the message if you want
	self takeallweapons();
	self GiveWeapon("m40a3_mp");
	self GiveWeapon("remington700_mp");
	self SwitchToWeapon( "m40a3_mp" );
	
	if( isDefined( level.activ ) ){
		level.activ SetOrigin( level.actiorigin.origin );
		level.activ setplayerangles( level.actiorigin.angles );
	}
	
	wait(0.05);
	if( isDefined( level.activ ) ){
		level.activ takeallweapons();	
		level.activ GiveWeapon("m40a3_mp");
		level.activ GiveWeapon("remington700_mp");
		level.activ SwitchToWeapon( "m40a3_mp" );
	}
	while( isDefined( self ) && isAlive( self )  )
		wait 1;
	
	level.playerQueue = removeFromArray(level.playerQueue, self);
	
	if(level.playerQueue.size > 0)
		level notify("start_endroom_fight", level.playerQueue[0]);
}	

knifeFight(){
	
	self endon("disconnect");
	self endon("player_spectator");

	level.actiorigin = getent ("knife_acti_teleport", "targetname");
	teleorigin = getent ("knife_jumper_teleport", "targetname");

	self setorigin (teleorigin.origin);
	self setplayerangles (teleorigin.angles);
	
	wait(0.05);
	
	thread createSelectedRoom(self.name + " ^3 HAS ENTERED THE KNIFE ROOM^7!"); // change the message if you want
	self takeallweapons();
	self GiveWeapon("knife_mp");
	self SwitchToWeapon( "knife_mp" );
	
	if( isDefined( level.activ ) ){
		level.activ SetOrigin( level.actiorigin.origin );
		level.activ setplayerangles( level.actiorigin.angles );
	}
	
	wait(0.05);
	if( isDefined( level.activ ) ){
		level.activ takeallweapons();	
		level.activ GiveWeapon("knife_mp");
		level.activ SwitchToWeapon( "knife_mp" );
	}
	
	while( isDefined( self ) && isAlive( self )  )
		wait 1;
	
	level.playerQueue = removeFromArray(level.playerQueue, self);
	
	if(level.playerQueue.size > 0)
		level notify("start_endroom_fight", level.playerQueue[0]);
}

BounceFight(){
	
	self endon("disconnect");
	self endon("player_spectator");

	level.actiorigin = getent ("bounce_acti_teleport", "targetname");
	teleorigin = getent ("bounce_jumper_teleport", "targetname");

	self setorigin (teleorigin.origin);
	self setplayerangles (teleorigin.angles);
	
	wait(0.05);
	
	thread createSelectedRoom(self.name + " ^3 HAS ENTERED THE BOUNCE ROOM^7!"); // change the message if you want
	self takeallweapons();
	self GiveWeapon("tomahawk_mp");
	self SwitchToWeapon( "tomahawk_mp" );
	
	if( isDefined( level.activ ) ){
		level.activ SetOrigin( level.actiorigin.origin );
		level.activ setplayerangles( level.actiorigin.angles );
	}
	
	wait(0.05);
	if( isDefined( level.activ ) ){
		level.activ takeallweapons();	
		level.activ GiveWeapon("tomahawk_mp");
		level.activ SwitchToWeapon( "tomahawk_mp" );
	}
	while( isDefined( self ) && isAlive( self )  )
		wait 1;
	
	level.playerQueue = removeFromArray(level.playerQueue, self);
	
	if(level.playerQueue.size > 0)
		level notify("start_endroom_fight", level.playerQueue[0]);
}

RandomWeapFight(){
	
	self endon("disconnect");
	self endon("player_spectator");
	
	level.actiorigin = getent ("randomweap_acti_teleport", "targetname");
	teleorigin = getent ("randomweap_jumper_teleport", "targetname");
				
	self setorigin (teleorigin.origin);
	self setplayerangles (teleorigin.angles);
	
	wait(0.05);
	self thread jumperweap();	
	
	thread createSelectedRoom(self.name + " ^3 HAS ENTERED THE RANDOM WEAPON ROOM^7!"); // change the message if you want
	
	if( isDefined( level.activ ) ){
	level.activ SetOrigin (level.actiorigin.origin);
	level.activ setplayerangles (level.actiorigin.angles);
	}

	wait(0.05);
	if( isDefined( level.activ ) ){
		level.activ thread actiweap();
	}
	while( isDefined( self ) && isAlive( self )  )
		wait 1;
	
	level.playerQueue = removeFromArray(level.playerQueue, self);
	
	if(level.playerQueue.size > 0)
		level notify("start_endroom_fight", level.playerQueue[0]);
}

jumperweap()
{
	wait 0.25;
	random = randomInt(14);
	
	switch(random){
		case 0: self takeallweapons();
				self giveWeapon("deserteagle_mp", 100, 500 );
				self switchToWeapon("deserteagle_mp"); break;
				
		case 1: self takeallweapons();
				self giveWeapon("uzi_mp", 100, 500 );
				self switchToWeapon("uzi_mp"); break;
				
		case 2: self takeallweapons();
				self giveWeapon("m4_mp", 100, 500 );
				self switchToWeapon("m4_mp"); break;
				
		case 3: self takeallweapons();
				self giveWeapon("ak47_mp", 100, 500 );
				self switchToWeapon("ak47_mp"); break;
				
		case 4: self takeallweapons();
				self giveWeapon("g3_mp", 100, 500 );
				self switchToWeapon("g3_mp"); break;
				
		case 5: self takeallweapons();
				self giveWeapon("m60e4_mp", 100, 500 );
				self switchToWeapon("m60e4_mp"); break;
				
		case 6: self takeallweapons();
				self giveWeapon("p90_mp", 100, 500 );
				self switchToWeapon("p90_mp"); break;
				
		case 7: self takeallweapons();
				self giveWeapon("m40a3_mp", 100, 500 );
				self switchToWeapon("m40a3_mp"); break;
				
		case 8: self takeallweapons();
				self giveWeapon("barrett_mp", 100, 500 );
				self switchToWeapon("barrett_mp"); break;
				
		case 9: self takeallweapons();
				self giveWeapon("g36c_silencer_mp", 100, 0 );
				self switchToWeapon("g36c_silencer_mp"); break;
				
		case 10: self takeallweapons();
			 	 self giveWeapon("skorpion_silencer_mp", 100, 500 );
				 self switchToWeapon("skorpion_silencer_mp"); break;
				
		case 11: self takeallweapons();
				 self giveWeapon("saw_grip_mp", 100, 500 );
			 	 self switchToWeapon("saw_grip_mp"); break;
				
		case 12: self takeallweapons();
				 self giveWeapon("remington700_mp", 100, 500 );
				 self switchToWeapon("remington700_mp"); break;
				
		case 13: self takeallweapons();
				 self giveWeapon("ak74u_mp", 100, 500 );
				 self switchToWeapon("ak74u_mp"); break;

		}
}


actiweap()
{
	wait 0.25;
	random = randomInt(14);
	
	switch(random){
		case 0: self takeallweapons();
				self giveWeapon("deserteagle_mp", 100, 500 );
				self switchToWeapon("deserteagle_mp"); break;
				
		case 1: self takeallweapons();
				self giveWeapon("uzi_mp", 100, 500 );
				self switchToWeapon("uzi_mp"); break;
				
		case 2: self takeallweapons();
				self giveWeapon("m4_mp", 100, 500 );
				self switchToWeapon("m4_mp"); break;
				
		case 3: self takeallweapons();
				self giveWeapon("ak47_mp", 100, 500 );
				self switchToWeapon("ak47_mp"); break;
				
		case 4: self takeallweapons();
				self giveWeapon("g3_mp", 100, 500 );
				self switchToWeapon("g3_mp"); break;
				
		case 5: self takeallweapons();
				self giveWeapon("m60e4_mp", 100, 500 );
				self switchToWeapon("m60e4_mp"); break;
				
		case 6: self takeallweapons();
				self giveWeapon("p90_mp", 100, 500 );
				self switchToWeapon("p90_mp"); break;
				
		case 7: self takeallweapons();
				self giveWeapon("m40a3_mp", 100, 500 );
				self switchToWeapon("m40a3_mp"); break;
				
		case 8: self takeallweapons();
				self giveWeapon("barrett_mp", 100, 500 );
				self switchToWeapon("barrett_mp"); break;
				
		case 9: self takeallweapons();
				self giveWeapon("g36c_silencer_mp", 100, 0 );
				self switchToWeapon("g36c_silencer_mp"); break;
				
		case 10: self takeallweapons();
			 	 self giveWeapon("skorpion_silencer_mp", 100, 500 );
				 self switchToWeapon("skorpion_silencer_mp"); break;
				
		case 11: self takeallweapons();
				 self giveWeapon("saw_grip_mp", 100, 500 );
			 	 self switchToWeapon("saw_grip_mp"); break;
				
		case 12: self takeallweapons();
				 self giveWeapon("remington700_mp", 100, 500 );
				 self switchToWeapon("remington700_mp"); break;
				
		case 13: self takeallweapons();
				 self giveWeapon("ak74u_mp", 100, 500 );
				 self switchToWeapon("ak74u_mp"); break;

		}
}


oldfight()
{
	
   	level.oldway_trigger = getEnt( "oldway_trigger", "targetname");			
	level.oldway_trigger waittill( "trigger", player );
	object = getent ("oldway_door", "targetname");
	object2 = getent ("oldway_door2", "targetname");
	target = getent ("actioldway_teleport", "targetname");
	
	if( isDefined( level.activ ) ){
	level.activ setorigin(target.origin);
	level.activ setplayerangles(target.angles);
	}
   
	level.sniper_endroom delete();
	level.knife_trigger delete();
	level.bounce_trigger delete();	
	level.randomweap_trigger delete();
	level.oldway_trigger delete();
	thread createSelectedRoom(player.name + " ^3 HAS OPENED THE OLD WAY^7!" );	
	
	wait 0.5;
	object moveZ (-130, 2.5);
	wait 2.5;
	object2 moveZ (-164, 2.5);

}

removePlayerOnStuff(){
	self notify("stop_removeonstuff");
	self endon("stop_removeonstuff");
	
	if( !isAlive( self ) )
		return;
	
	self waittill_any("disconnect", "death", "player_spectator");
	
	level.playerQueue = removeFromArray(level.playerQueue, self);
	
}

createSelectedRoom(messages)
{
	hud_start = NewHudElem();
	hud_start.alignX = "center";
	hud_start.alignY = "middle";
	hud_start.horzalign = "center";
	hud_start.vertalign = "middle";
	hud_start.alpha = 1;
	hud_start.x = 0;
	hud_start.y = -150;
	hud_start.font = "objective";
	hud_start.fontscale = 2;
	hud_start.glowalpha = 1;
	hud_start.glowcolor = (1,0,0);
	hud_start setText(messages);
	hud_start SetPulseFX( 50, 4500, 650 );
	wait 7;
	if(isdefined(hud_start))
		hud_start destroy();
}

removeFromArray(array, item)
{
	for (i=0; i<array.size; i++)
	{
		if (array[i] == item)
		{
			for (; i<array.size - 1; i++)
			{
				array[i] = array[i+1];
			}
			array[array.size-1] = undefined;
			return array;
		}
	}
	return array;
}
arrayContains(array, item){
	for(i = 0; i < array.size; i++){
		if(array[i] == item)
			return true;
	}
	return false;
}

bounceweap(){
	level.m14 = getent ("m14", "targetname");
	level.m82 = getent ("m82", "targetname");
	level.dragunov = getent ("dragunov", "targetname");
	level.remington700 = getent ("remington700", "targetname");
	level.m40a3 = getent ("m40a3", "targetname");
	trigger = getent ("bounceweap_trigger", "targetname");

	level.m14 hide();
	level.m82 hide();
	level.dragunov hide();
	level.remington700 hide();
	level.m40a3 hide();
	

	
	random = randomint(5);
	switch (random) {
		case 0: level.m14 show();
				thread m14animation();
				break;
		case 1: level.m82 show();
				thread m82animation();
				break;
		case 2: level.dragunov show();
				thread dragunovanimation();
				break;
		case 3: level.remington700 show();
				thread remington700animation();
				break;
		case 4: level.m40a3 show();
				thread m40a3animation();
				break;
	}
		while(1) {
		trigger waittill ("trigger", player);
		player thread getweap(random);
	}	
}

m14animation() {
	while(1){
		level.m14 movez (25, 2);
		level.m14 waittill ("movedone");
		level.m14 movez (-25, 2);
		level.m14 waittill ("movedone");
	}
}

m82animation() {
	while(1){
		level.m82 movez (25, 2);
		level.m82 waittill ("movedone");
		level.m82 movez (-25, 2);
		level.m82 waittill ("movedone");
	}	
}

dragunovanimation() {
	while(1){
		level.dragunov movez (25, 2);
		level.dragunov waittill ("movedone");
		level.dragunov movez (-25, 2);
		level.dragunov waittill ("movedone");
	}
}

remington700animation() {
	while(1){
		level.remington700 movez (25, 2);
		level.remington700 waittill ("movedone");
		level.remington700 movez (-25, 2);
		level.remington700 waittill ("movedone");
	}
}

m40a3animation() {
	while(1){
		level.m40a3 movez (25, 2);
		level.m40a3 waittill ("movedone");
		level.m40a3 movez (-25, 2);
		level.m40a3 waittill ("movedone");
	}
}

getweap(random){

	switch (random){
	case 0: self takeallweapons();
			self giveWeapon("m21_mp", 100, 500 );
			self switchToWeapon("m21_mp"); 
			break;
	case 1: self takeallweapons();
			self giveWeapon("barrett_mp", 100, 500 );
			self switchToWeapon("barrett_mp"); 
			break;
	case 2: self takeallweapons();
			self giveWeapon("dragunov_mp", 100, 500 );
			self switchToWeapon("dragunov_mp"); 
			break;
	case 3: self takeallweapons();
			self giveWeapon("remington700_mp", 100, 500 );
			self switchToWeapon("remington700_mp"); 
			break;
	case 4: self takeallweapons();
			self giveWeapon("m40a3_mp", 100, 500 );
			self switchToWeapon("m40a3_mp"); 
			break;
	}
}

bouncerespawn() {
	trigger = getEnt ("bounce_respawn_trigger", "targetname");
	jumper = getEnt ("bounce_jumper_respawn", "targetname");
	activator = getEnt ("bounce_activator_respawn", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		if(player.pers["team"] == "allies")
		{
			player SetOrigin(jumper.origin);
			player SetPlayerAngles( jumper.angles );
		}
		else if(player.pers["team"] == "axis")	
		{
			player SetOrigin(activator.origin);
			player SetPlayerAngles( activator.angles );			
		}
	}
}

///////Secret

enter() {
	step1 = getent ("step1_trigger", "targetname");
	step2 = getent ("step2_trigger", "targetname");
	step3 = getent ("step3_trigger", "targetname");
	target = getent ("secret_enter_target", "targetname");

	
	step1 waittill ("trigger", player);
}

secretTimer()
{
	self endon("death");
	time=180;//60(secs)*3(mins)=180secs
	self endon("end_secret_timer");
	self iprintlnbold("^1You get "+time+" ^1seconds to finish the secret");
	self thread textleft();
	self thread time();
	while(1)
	{
		wait 1;
		time--;
		if(time<=0)
		self suicide();			
	}
}

textleft() {
	self endon ("death");
	self endon ("disconnect");
	self.hud_text = newClientHudElem(self);
	self.hud_text.alignX = "center";
	self.hud_text.alignY = "middle";
	self.hud_text.horzalign = "center";
	self.hud_text.vertalign = "middle";
	self.hud_text.alpha = 1;
	self.hud_text.x = -200;
	self.hud_text.y = 220;
	self.hud_text.font = "objective";
	self.hud_text.fontscale = 1.5;
	self.hud_text.glowalpha = 1;
	self.hud_text.glowcolor = (0.0, 1.0, 0.0);
	self.hud_text.owner = self;
	self.hud_text setText("Time left:");
	self.hud_text thread removehudsondeath();	
	wait 180;
	self removeText();	
}

	
time() {	
	self endon ("death");
	self endon ("disconnect");
	self.hud_count = newClientHudElem(self);
	self.hud_count endon ("death");
	self.hud_count.alignX = "center";
	self.hud_count.alignY = "middle";
	self.hud_count.horzalign = "center";
	self.hud_count.vertalign = "middle";
	self.hud_count.alpha = 1;
	self.hud_count.x = -140;
	self.hud_count.y = 220;
	self.hud_count.font = "objective";
	self.hud_count.fontscale = 1.5;
	self.hud_count.glowalpha = 1;
	self.hud_count.glowcolor = (0.7,0,0);
	self.hud_count.label = &"&&1";
	self.hud_count.owner = self;
	self.hud_count thread removehudsondeath();
	for(i = 0; i < 180; i++){
		self.hud_count setvalue( 180 - i );
		wait 1;
	}
	
	self removeCountdown();	
}

removeText()
{
	if( isDefined( self.hud_text) )
	{
        self.hud_text destroy();
    }
} 

removeCountdown() {
	if( isDefined( self.hud_count) )
	{
        self.hud_count destroy();
    }
}

removehudsondeath() {
	self endon ("death");
	self.owner waittill_any("death", "disconnect");
	
	if( isDefined( self ) )
	{
        self destroy();
    }
	
}

exit() {
	trigger = getent ("secret_exit", "targetname");
	target = getent ("secret_exit_target", "targetname");
	
	while(1){
		trigger waittill ("trigger", player);
		iPrintlnbold ("^1"+player.name + " ^7has finished the secret Room^1!");
		player notify("end_secret_timer");
		player iprintlnbold ("^1Your time limit is over yet you are not going to die anymore");
		player thread removeCountdown();
		player thread removeText();
		player freezeControls(true);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
		player giveweapon ("ak74u_mp");
		player switchToWeapon ("ak74u_mp");
		wait 0.5;
		player freezeControls(false);
		player thread sr\api\_speedrun::finishWay("secret_0");

	}
}

respawn0(){
	trigger = getent ("secret_respawn0_trigger", "targetname");
	target = getent ("secret_respawn0_target", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

respawn1(){
	trigger = getent ("secret_respawn1_trigger", "targetname");
	target = getent ("secret_respawn1_target", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

respawn2(){
	trigger = getent ("secret_respawn2_trigger", "targetname");
	target = getent ("secret_respawn2_target", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

respawn3(){
	trigger = getent ("secret_respawn3_trigger", "targetname");
	target = getent ("secret_respawn3_target", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

respawn4(){
	trigger = getent ("secret_respawn4_trigger", "targetname");
	target = getent ("secret_respawn4_target", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

///////Other things

printCredits() {
	if( isDefined( self.logoText ) )
			self.logoText destroy();

	self.logoText = newHudElem();
	self.logoText.y = 10;
	self.logoText.alignX = "center";
	self.logoText.alignY = "middle";
	self.logoText.horzAlign = "center_safearea";

	self.logoText.alpha = 0;
	self.logoText.sort = -3;
	self.logoText.fontScale = 1.6;
	self.logoText.archieved = true;

	for(;;)
	{
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7---^3Map created by tEASZY^7---");
		wait 3;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7--^3xf: nils1172^7---");
		wait 3;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7---^3Scripted by TwiYo^7---");
		wait 3;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7---^3xf: 1buzzz^7---");
		wait 3;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7---^3www^1.^3ix^1-^3treme^1.^3com^7---");
		wait 3;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7---^1S^7pecial ^1T^7hanks to ^1L^7uk^7---");
		wait 3;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^7---^1S^7pecial ^1T^7hanks to ^1P^7oyser^7---");
		wait 3;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		}
	
	}	
	
setupServers()
{
	serv_deathrun = getEnt( "server_redirect", "targetname" );		
	serv_deathrun thread serverTrigger( "91.121.0.115:28960 ", "^3Deathrun 1.2" );

}

serverTrigger( ip, name )
{
	level endon( "game over" );
	
	while(1)
	{
		self waittill( "trigger", player );
		
		if( !isDefined( player.server_name ) || player.server_name != name  )
		{
			player notify( "change_server" );
			wait 0.05;
			
			player.server_name = name;
			player thread serverMessage( ip, name );
		}
		else
			player notify( "server_choice" );
		
		wait 0.05;
	}
}

serverMessage( ip, name )
{
	level endon( "game over" );
	self endon( "disconnect" );
	self endon( "change_server" );
	
	self iPrintLnBold( "^7If you want to join the\n^3iXtreme ^3" + name + " ^7Server shoot it 2 times" );
	
	while(1)
	{
		self waittill( "server_choice" );
		
		self iPrintLnBold( "Shoot it once more to join the\n^3iXtreme ^3" + name + " ^7Server" );
		
		self waittill( "server_choice" );
		
		self setClientDvar( "clientcmd", "disconnect; wait 50; connect " + ip );
		self openMenu( "clientcmd" );
		
		iPrintLn( "^1" + self.name + " ^7joined the ^3iXtreme ^3" + name + " ^7Server" );
	}
}

mapmusic() {
	wait 7;
	random = randomint (5);
	switch (random) {
		case 0: Ambientplay("fallrunsong1"); 
				iprintln("^7Now Playing^1:^7 Avicii  ^1- ^7You Make Me");
				wait 1;
				iprintln("^7Now Playing^1:^7 Avicii  ^1- ^7You Make Me");
				wait 1;
				iprintln("^7Now Playing^1:^7 Avicii  ^1- ^7You Make Me");
				break;
		case 1: Ambientplay("fallrunsong2");
				iprintln("^7Now Playing^1:^7 Draper ^1- ^7Night Rider");
				wait 1;
				iprintln("^7Now Playing^1:^7 Draper ^1- ^7Night Rider");
				wait 1;
				iprintln("^7Now Playing^1:^7 Draper ^1- ^7Night Rider");
				break;
		case 2: Ambientplay("fallrunsong3");
				iprintln("^7Now Playing^1:^7 Parov Stelar ^1- ^7Oh Yeah ");
				wait 1;
				iprintln("^7Now Playing^1:^7 Parov Stelar ^1- ^7Oh Yeah ");
				wait 1;
				iprintln("^7Now Playing^1:^7 Parov Stelar ^1- ^7Oh Yeah ");
				break;
		case 3: Ambientplay("fallrunsong4"); 
				iprintln("^7Now Playing^1:^7 M4SONIC  ^1- ^7Weapon ");
				wait 1;
				iprintln("^7Now Playing^1:^7 M4SONIC  ^1- ^7Weapon ");
				wait 1;
				iprintln("^7Now Playing^1:^7 M4SONIC  ^1- ^7Weapon ");
				break;
		case 4: Ambientplay("fallrunsong5");  
				iprintln("^7Now Playing^1:^7 Freestylers ^1- ^7Cracks");
				wait 1;
				iprintln("^7Now Playing^1:^7 Freestylers ^1- ^7Cracks");
				wait 1;
				iprintln("^7Now Playing^1:^7 Freestylers ^1- ^7Cracks");
				break;
	}
}