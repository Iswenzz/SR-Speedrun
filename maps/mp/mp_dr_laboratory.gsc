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
 
	mp_dr_laboratory
	Map Made by TwiYo	
	Scripted by TwiYo			
	xFire: 1buzzz
	
	Created for Braxi's Deathrun 1.2 mod for CoD4
	www.ix-treme.com
	
	Credits: 
	Thanks to
	Luk
	rednose
	rabbit
*/ 
#include braxi\_common;
#include common_scripts\utility;
main()
 {
	maps\mp\_load::main();
	//////////////////// Precache
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
	precacheItem("rpg_mp");
	precachestring(&"&&1"); // Countdown
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";	
	setdvar( "r_specularcolorscale", "1" );	
	setdvar("r_glowbloomintensity0", ".25");
	setdvar("r_glowbloomintensity1", ".25");
	setdvar("r_glowskybleedintensity0", ".3");
	setdvar("compassmaxrange","1800");
	setdvar("bg_falldamageminheight",1280000);
	setdvar("bg_falldamagemaxheight",3000000);
	
	//////// FX
	level.blue= loadFX("labor/orb_up");	
	playLoopedFX(level.blue, 0.3, (54, 210, 48)); 
	playLoopedFX(level.blue, 0.3, (54, -146, 48)); 
	level.blue2= loadFX("labor/orb_up2");	
	playLoopedFX(level.blue2, 0.3, (-5186, -5456, -4064)); 
	playLoopedFX(level.blue2, 0.3, (-5966, -5456, -4064)); 	
	level.cube= loadFX("labor/cube_lila");	
	playLoopedFX(level.cube, 0.3, (-576, -400, 112)); 
	playLoopedFX(level.cube, 0.3, (-576, 456 ,112)); 	
	level.cubedown= loadFX("labor/cube_lilablue_down");	
	playLoopedFX(level.cubedown, 0.3, (-576, -400, 260)); 
	playLoopedFX(level.cubedown, 0.3, (-576, 456, 256)); 		
	level.tank_particles= loadFX("labor/water-tank_particles");	
	playLoopedFX(level.tank_particles, 0.3, (1420, 34, -268)); 
	level.tank_particles1= loadFX("labor/water-tank_particles1");
	playLoopedFX(level.tank_particles1, 0.3, (1186, 326, -956)); 	
	level.tank_particles2= loadFX("labor/water-tank_particles2");
	playLoopedFX(level.tank_particles2, 0.3, (484, 344, -952)); 
	level.tank_particles3= loadFX("labor/water-tank_particles3");
	playLoopedFX(level.tank_particles3, 0.3, (-206, 330, -952)); 		
	level.tank_particles4= loadFX("labor/water-tank_particles4");
	playLoopedFX(level.tank_particles4, 0.3, (-5154, -1540, -1764)); 
	playLoopedFX(level.tank_particles4, 0.3, (-5980, -1540, -1764)); 
	level.tank_particles5= loadFX("labor/water-tank_particles5");
	playLoopedFX(level.tank_particles5, 0.3, (-5154, -4262, -1766)); 
	playLoopedFX(level.tank_particles5, 0.3, (-5982, -4246, -1766)); 	
	level.smoke = loadfx ("labor/smoke");	
	level.fire = loadFX("labor/fire_falling");
	level.tail = loadFX("labor/train_particle_tail");

		thread way_connect();
	
	////////////////Multi Bounce
	level.knockback = getDvarInt("g_knockback");	// script by  DanTheMan
    bounce   = getEntArray("bounce", "targetname");    
    for(i = 0;i < bounce.size;i++)
    bounce[i] thread doublebounce();
	
	////////////// Elevators and other things
	//thread mapmusic();
	thread shit();
	thread door1();
	thread jumppad();
	thread lifjumper1();
	thread lifjumper2();
	thread lifjumper3();
	thread lifacti1();
	thread lifacti2();
	thread lifacti3();
	thread jumpernodmg1();
	thread jumpernodmg2();
	thread jumpernodmg3();
	// thread getlift1();
	// thread getlift2();
	// thread getlift3();
	thread moveingplat();	
	thread bouncerespawn();
	thread wepicon();
	thread bounceweapon();
	// thread onPlayerConnected();
	// thread onPlayerSpawned();
	thread addTestClients();
	// thread setupServers();
	// thread text();

	thread sr_tp();

	///////////////Traps
	//thread trap1();
	//thread trap2();
	thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();
	// addTriggerToList("trap1_trigger");
	// addTriggerToList("trap2_trigger");
 //    addTriggerToList("trap3_trigger");
	// addTriggerToList("trap4_trigger");
	// addtriggerTolist("trap5_trigger");
	// addtriggerTolist("trap6_trigger");
	// addtriggerTolist("trap7_trigger");
	// addtriggerTolist("trap8_trigger");
	// addtriggerTolist("trap9_trigger");
	// addtriggerTolist("trap10_trigger");
	
	///////////////Secrets
	thread owh();
	thread spiningrpg();
	thread jumpsecret();
	thread respawn0();
	thread respawn1();
	thread respawn2();
	thread respawn3();
	thread respawn4();
	thread respawn5();
	thread respawn6();
	thread respawn7();
	thread respawn8();
	thread giverpg0();
	thread giverpg1();
	thread giverpg2();
	thread giverpg3();
	thread giverpg4();
	thread giverpg5();
	thread backtomap();
	thread backtomap2();	
	
	///////////////////////Endroom Queue
	//endroomQueueSetup();
	//thread watchEndrooms();
	//thread SniperRoomTrigger();	
	//thread KnifeRoomTrigger();
	//thread BounceRoomTrigger();
	//thread RandomWeapRoomTrigger();
	//thread oldfight();
}

sr_tp()
{
	ori = spawn("script_origin",(-5566,-246,-1984));
	ori.angles = (0,270,0);
	trig = spawn("trigger_radius",(-1302,34,-1472),0,50,50);
	trig.radius = 50;
	wait 1;
	thread speedrun\_triggerfx::createTrigFx(trig, "red");

	for(;;)
	{
		trig waittill("trigger",player);
		player thread safe_tp(ori);
	}
}

safe_tp(ori)
{
	self endon("death");
	self endon("disconnect");

	self setOrigin(ori.origin);
	self setplayerangles(ori.angles);
	self freezecontrols(1);
	wait 0.05;
	self freezecontrols(0);
}

////////////////////////// Multi Bounce

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	sr\api\_map::createWay("secret", "Secret Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

doublebounce()	// script by  DanTheMan
{
    for(;;)
    {
    self waittill("trigger", player);
    
    if(!isDefined(player.bouncing))
    player thread player_bounce(self);
    }
}

player_bounce(trigger)
{
    self.bouncing = true;
    vel = self getVelocity();
    temp0 = (((vel[0] < 350 && vel[0] > 0) || (vel[0] > -350 && vel[0] < 0)));
    temp1 = (((vel[1] < 350 && vel[1] > 0) || (vel[1] > -350 && vel[1] < 0)));

    if((!temp0 && !temp1) || vel[2] > -350)
    {
        wait 1;
        self.bouncing = undefined;
        return;
    }

    health    = self.health;
    maxHealth = self.maxHealth;
    self.health    = 1000000;
    self.maxhealth = 1000000;
    setDvar("g_knockback", (vel[2]*-9)-500);
    self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", self.origin, (0,0,1) , "none", 0);
    wait 0.05;
    setDvar("g_knockback", level.knockback);
    self.health    = health;
    self.maxhealth = maxHealth;
    while(self isTouching(trigger))
    wait 0.05;
    self.bouncing = undefined;
}	

/////////////////// Elevators and other things
mapmusic() {
	wait 7;
	random = randomint (5);
	switch (random) {
		case 0: Ambientplay("title1");
				iprintln("^7Now Playing^1:^7 Little Moment ^1- ^7Omar LinX");
				wait 1;
				iprintln("^7Now Playing^1:^7 Little Moment ^1- ^7Omar LinX");
				wait 1;
				iprintln("^7Now Playing^1:^7 Little Moment ^1- ^7Omar LinX");
				break;
		case 1: Ambientplay("title2");
				iprintln("^7Now Playing^1:^7 One Republic ^1- ^7Counting Stars (SirensCeol Remix)");
				wait 1;
				iprintln("^7Now Playing^1:^7 One Republic ^1- ^7Counting Stars (SirensCeol Remix)");
				wait 1;
				iprintln("^7Now Playing^1:^7 One Republic ^1- ^7Counting Stars (SirensCeol Remix)");
				break;
		case 2: Ambientplay("title3");
				iprintln("^7Now Playing^1:^7 Young London ^1- ^7Broken");
				wait 1;
				iprintln("^7Now Playing^1:^7 Young London ^1- ^7Broken");
				wait 1;
				iprintln("^7Now Playing^1:^7 Young London ^1- ^7Broken");
				break;
		case 3: Ambientplay("title4");
				iprintln("^7Now Playing^1:^7 Throttle ^1- ^7Next Big Thing");
				wait 1;
				iprintln("^7Now Playing^1:^7 Throttle ^1- ^7Next Big Thing");
				wait 1;
				iprintln("^7Now Playing^1:^7 Throttle ^1- ^7Next Big Thing");
				break;
		case 4: Ambientplay("title5");
				iprintln("^7Now Playing^1:^7 F.O.O.L ^1- ^7Afraid");
				wait 1;
				iprintln("^7Now Playing^1:^7 F.O.O.L ^1- ^7Afraid");
				wait 1;
				iprintln("^7Now Playing^1:^7 F.O.O.L ^1- ^7Afraid");
				break;
	}
}

moveingplat() {
	plat1 = getent ("moving_plat1", "targetname");
	thread moveingplat1();
	plat1 delete();
}
moveingplat1() {
	plat3 = getent ("moving_plat3", "targetname");
	plat3 delete();
}
		
lifjumper1() {
	trigger = getent ("lift_1_trigger", "targetname");
	lift = getent ("lift_1", "targetname");
	
	lift delete();
}

jumpernodmg1() {
	lift = getent ("jumperlift_no_dmg_1", "targetname");
	
	lift delete();
}

lifjumper2() {
	trigger = getent ("lift_2_trigger", "targetname");
	lift = getent ("lift_2", "targetname");
	
	lift delete();
}

jumpernodmg2() {
	lift = getent ("jumperlift_no_dmg_2", "targetname");
	
	lift delete();
}

lifjumper3() {
	trigger = getent ("lift_3_trigger", "targetname");
	lift = getent ("lift_3", "targetname");
	
	lift delete();
}

jumpernodmg3() {
	lift = getent ("jumperlift_no_dmg_3", "targetname");
	
	lift delete();
}

lifacti1() {
	trigger = getent ("lift_1_acti_trigger", "targetname");
	lift = getent ("lift_1_acti", "targetname");
	
	
	lift delete();
}

lifacti2() {
	trigger = getent ("lift_2_acti_trigger", "targetname");
	lift = getent ("lift_2_acti", "targetname");
	
	lift delete();
}

lifacti3() {
	trigger = getent ("lift_3_acti_trigger", "targetname");
	lift = getent ("lift_3_acti", "targetname");
	
	lift delete();
}

lifacti1nodmg() {
	nodmg = getent ("lift_1_acti_nodmg", "targetname");
	
	nodmg delete();
}

lifacti2nodmg() {
	nodmg = getent ("lift_2_acti_nodmg", "targetname");
	
	nodmg delete();
}

lifacti3nodmg() {
	nodmg = getent ("lift_3_acti_nodmg", "targetname");
	
	nodmg delete();
}

getlift1() {
	level.getlift1_trigger = getent ("getlift1", "targetname");
	trigger = getent ("lift_1_acti_trigger", "targetname");
	lift = getent ("lift_1_acti", "targetname");
	
	lift delete();
}

getlift2() {
	level.getlift2_trigger = getent ("getlift2", "targetname");
	trigger = getent ("lift_2_acti_trigger", "targetname");
	lift = getent ("lift_2_acti", "targetname");
	
	lift delete();
		
}


getlift3() {
	level.getlift3_trigger = getent ("getlift3", "targetname");
	trigger = getent ("lift_3_acti_trigger", "targetname");
	lift = getent ("lift_3_acti", "targetname");
	
	lift delete();
}


shit() {
	object = getent ("spawn_ring_1", "targetname");
	thread shit2();
	thread shit1a();
	thread shit2a();
	thread shit3();
	thread shit4();
	thread shit5();
	thread shit6();
	thread endshit1();
	thread endshit2();
	thread endshit3();
	thread endshit4();
		
	object delete();
		
}

endshit1() {
	object = getent ("end_ring1", "targetname");
	
	object delete();
		
}

endshit2() {
	object = getent ("end_ring2", "targetname");
	
	object delete();	
}

endshit3() {
	object = getent ("end_ring3", "targetname");
	
	object delete();
		
}

endshit4() {
	object = getent ("end_ring4", "targetname");
	
	object delete();
}

shit2() {
	object = getent ("spawn_ring_2", "targetname");

object delete();
		
}

shit2a() {
	object = getent ("spawn_ring_2a", "targetname");

	
	object delete();
		
}

shit1a() {
	object = getent ("spawn_ring_1a", "targetname");

	
	object delete();
		
}

shit3() {
	object = getent ("ring_1", "targetname");

	
	object delete();
		
}

shit4() {
	object = getent ("ring_2", "targetname");

	
	object delete();
		
}

shit5() {
	object = getent ("ring_3", "targetname");

	object delete();
		
}

shit6() {
	object = getent ("ring_4", "targetname");
object delete();
		
}

door1() {
	left = getent ("door_left", "targetname");
	right = getent ("door_right", "targetname");
	
	wait 1;

	
	left movey (135, 2.5);
	right movey (-132, 2.5);
	wait 2.6;
	left hide();
	right hide();
}

jumppad(who)
{
	trigger = getEnt ("jump", "targetname" );
	
	while(1)
	{
    	trigger waittill ( "trigger", who );
		// iprintlnbold ("Yipi");
	    oldpos = who.origin;
	    strenght = 3.6;
	    for(i=0;i<strenght;i++)
	    {
	        who.health += 220;
            who finishPlayerDamage(who, level.jumpattacker, 220, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
	    }
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

wepicon() {
	object = getent ("bounce_weap_icon", "targetname");
	object notsolid();
	while(1) {
		object rotateyaw (360, 5);
		object moveZ (20, 5);
		object waittill ("movedone");
		object rotateyaw (360, 5);
		object movez (-20, 5);
		wait 5;
	}
}

bounceweapon()
{
	trigger = getent ("bounce_weap_trigger", "targetname");
	
	random = randomInt(14);
	while(1){
	trigger waittill ("trigger", player);
	switch(random){
		case 0: player takeallweapons();
				player giveWeapon("deserteagle_mp", 100, 500 );
				player switchToWeapon("deserteagle_mp"); break;
				
		case 1: player takeallweapons();
				player giveWeapon("uzi_mp", 100, 500 );
				player switchToWeapon("uzi_mp"); break;
				
		case 2: player takeallweapons();
				player giveWeapon("m4_mp", 100, 500 );
				player switchToWeapon("m4_mp"); break;
				
		case 3: player takeallweapons();
				player giveWeapon("ak47_mp", 100, 500 );
				player switchToWeapon("ak47_mp"); break;
				
		case 4: player takeallweapons();
				player giveWeapon("g3_mp", 100, 500 );
				player switchToWeapon("g3_mp"); break;
				
		case 5: player takeallweapons();
				player giveWeapon("m60e4_mp", 100, 500 );
				player switchToWeapon("m60e4_mp"); break;
				
		case 6: player takeallweapons();
				player giveWeapon("p90_mp", 100, 500 );
				player switchToWeapon("p90_mp"); break;
				
		case 7: player takeallweapons();
				player giveWeapon("m40a3_mp", 100, 500 );
				player switchToWeapon("m40a3_mp"); break;
				
		case 8: player takeallweapons();
				player giveWeapon("barrett_mp", 100, 500 );
				player switchToWeapon("barrett_mp"); break;
				
		case 9: player takeallweapons();
				player giveWeapon("g36c_silencer_mp", 100, 0 );
				player switchToWeapon("g36c_silencer_mp"); break;
				
		case 10: player takeallweapons();
			 	 player giveWeapon("skorpion_silencer_mp", 100, 500 );
				 player switchToWeapon("skorpion_silencer_mp"); break;
				
		case 11: player takeallweapons();
				 player giveWeapon("saw_grip_mp", 100, 500 );
			 	 player switchToWeapon("saw_grip_mp"); break;
				
		case 12: player takeallweapons();
				 player giveWeapon("remington700_mp", 100, 500 );
				 player switchToWeapon("remington700_mp"); break;
				
		case 13: player takeallweapons();
				 player giveWeapon("ak74u_mp", 100, 500 );
				 player switchToWeapon("ak74u_mp"); break;

		}
	}
}

onPlayerConnected() {
	while(1) {
		level waittill( "connected", player );
		player setClientDvars( 	"fx_drawclouds" 	, 1,
								"fx_draw"			, 1,
								"fx_marks"			, 1,
								"fx_marks_ents"		, 1,
								"fx_marks_smodels"	, 1,
								"fx_cull_elem_draw"	, 1,
								"fx_cull_elem_spawn", 1,
								"fx_vismintracedist", 80);
	}
}

onPlayerSpawned() {
	while(1){
	level waittill( "player_spawn", player );
	
	// player thread showcredits();
	}
}

text()
{
	hud_clock = newhudelem();
	hud_clock.alignX = "center";
	hud_clock.alignY = "middle";
	hud_clock.horzalign = "center";
	hud_clock.vertalign = "middle";
	hud_clock.alpha = 1;
	hud_clock.x = 250;
	hud_clock.y = 220;
	hud_clock.font = "objective";
	hud_clock.fontscale = 1.5;
	hud_clock.glowalpha = 1;
	hud_clock.glowcolor = (0.0, 1.0, 0.0);
	while(1){
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 1;
		hud_clock setText("Map by TwiYo");
		wait 10;
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 0;
		wait 1;	
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 1;
		hud_clock setText("xFire: 1buzzz");
		wait 10;
		hud_clock fadeOverTime(1);
		hud_clock.alpha = 0;
		wait 1;
	}
} 

showcredits() {
	self thread removeafter();
	howto = createText("Press [{+activate}] while crouching for credits.");
	
	while(!isDefined( self.hasSeenCredits )){		
		if(self useButtonpressed() && self getStance() == "crouch"){
			self thread getcredits();
			
			break;
		}		
		wait .1; 
	}

}
removeafter() {
	wait 10;
	if(isdefined(self.hud_start))
		self.hud_start destroy();
}
createText(messages)
{
	self endon ("death");
	self endon ("disconnect");
	self.hud_start = newClientHudElem(self);
	self.hud_start.alignX = "center";
	self.hud_start.alignY = "middle";
	self.hud_start.horzalign = "center";
	self.hud_start.vertalign = "middle";
	self.hud_start.alpha = 1;
	self.hud_start.x = 0;
	self.hud_start.y = 220;
	self.hud_start.font = "objective";
	self.hud_start.fontscale = 1.4;
	self.hud_start.glowalpha = 1;
	self.hud_start.glowcolor = (1,0,0);
	self.hud_start.owner = self;
	self.hud_start thread removehudsondeath();
	self.hud_start setText(messages);
}

getcredits() {
	
	level.creditTime = 6;
		self.hasSeenCredits = true;
	self thread showCredit( "Special Thanks to:", 2.4);
	wait 0.5;
	self thread showCredit( "Luk", 1.8);
	wait 0.5;
	self thread showCredit( "rednose", 1.8);
	wait 0.5;
	self thread showCredit( "        rabbit\nxfire: eiskiller95", 1.8);
	wait 1;
	self thread showCredit( "www.ix-treme.com", 1.8);
}


showCredit( text, scale )
{
	self.credit_text = newClientHudElem(self);
	self.credit_text.font = "objective";
	self.credit_text.fontScale = scale;
	self.credit_text.owner = self;
	self.credit_text thread removehudsondeath();
	self.credit_text SetText(text);
	self.credit_text.alignX = "center";
	self.credit_text.alignY = "top";
	self.credit_text.horzAlign = "center";
	self.credit_text.vertAlign = "top";
	self.credit_text.x = 0;
	self.credit_text.y = 540;
	self.credit_text.sort = -1; //-3
	self.credit_text.alpha = 1;
	self.credit_text.glowColor = (.1,.8,0);
	self.credit_text.glowAlpha = 1;
	self.credit_text moveOverTime(level.creditTime);
	self.credit_text.y = -60;
	self.credit_text.foreground = true;
	wait level.creditTime;
	wait 2;
	self thread removeendtext();
}

removeendtext()
{
	if( isDefined( self.credit_text) )
	{
        self.credit_text destroy();
    }
} 

addTestClients()
{
	setDvar("scr_testclients", "");
	wait 1;
	for(;;)
	{
		if(getdvarInt("scr_testclients") > 0)
			break;
		wait 1;
	}
	testclients = getdvarInt("scr_testclients");
	setDvar( "scr_testclients", 0 );
	for(i=0;i<testclients;i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i]))
		{
			println("Could not add test client");
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread TestClient("autoassign");
	}
	thread addTestClients();
}

TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;
		
	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;
}

setupServers()
{
	serv_deathrun = getEnt( "server_redirect", "targetname" );		
	serv_deathrun thread serverTrigger( "91.121.0.115:28960 ", "^3Deathrun 1.2" );

}

serverTrigger( ip, name )
{

}

serverMessage( ip, name )
{

}

//////////////////////////////// Traps

addTriggerToList( name ){
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

trap1() {
	trigger = getent ("trap1_trigger", "targetname");
	klappe1 = getent ("trap1_lucke_1", "targetname");
	klappe2 = getent ("trap1_lucke_2", "targetname");
	rolle1 = getent ("trap1_lucke_1_rolle", "targetname");
	rolle2 = getent ("trap1_lucke_2_rolle", "targetname");
	newway1 = getent ("trap1_newway_1" , "targetname");
	newway2 = getent ("trap1_newway_2" , "targetname");
	spinner = getent ("trap1_spinner", "targetname");
	blue = getent ("trap1_blue", "targetname");
	red = getent ("trap1_red", "targetname");
	rolle1 hide();
	rolle2 hide();
	
	klappe1 linkto(rolle1);
	klappe2 linkto(rolle2);
	red hide();
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	rolle1 rotatepitch (90, 1);
	rolle2 rotatepitch (-90, 1);
	wait 1;
	klappe1 hide();
	klappe1 notsolid();
	klappe2 hide();
	klappe2 notsolid();
	spinner moveZ (290, 1);
	wait 1;
	newway1 moveX (-380, 1);
	newway2 moveX (-380, 1);
	
	while(1) {
		spinner rotateyaw (360, 1.5);
		wait 1.5;
	}

}
		
trap2() {
	trigger = getent ("trap2_trigger", "targetname");
	
	//Spinner
	level.spinner = getent ("trap2_spin_platform", "targetname");
	level.luckeL = getent ("trap2_spin_lucke_links", "targetname");
	level.luckeR = getent ("trap2_spin_lucke_rechts", "targetname");	
	level.stangeL = getent ("trap2_spin_stange_links", "targetname");
	level.stangeR = getent ("trap2_spin_stange_rechts", "targetname");
	level.stangeU = getent ("trap2_spin_stange_unten", "targetname");
	
	//Roller
	level.roll1 = getent ("trap2_roll_1", "targetname");
	level.roll2 = getent ("trap2_roll_2", "targetname");
	level.roll3 = getent ("trap2_roll_3", "targetname");
	level.door1 = getent ("trap2_roll_door1", "targetname");
	level.door2 = getent ("trap2_roll_door2", "targetname");
	level.door3 = getent ("trap2_roll_door3", "targetname");
	
	//Pusher
	level.pusher = getent ("trap2_psuher_platform", "targetname");
	level.stangepU1 = getent ("trap2_psuher_stangeu1", "targetname");
	level.stangepU2 = getent ("trap2_psuher_stangeu2", "targetname");
	blue = getent ("trap2_blue", "targetname");
	red = getent ("trap2_red", "targetname");
	
	red hide();
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	
	random = randomInt(3);	
	switch(random){
		//Spinner
		case 0: thread spinner();				
				break;
		//Roller		
		case 1: thread roller();
				break;
		//Pusher		
		case 2: thread pusher();
				break;
	}
}	
	
spinner() {
	//Door Opened
	level.pusher moveZ (-280, 1.5);
	level.stangepU1 moveZ (-284, 1.5);
	level.stangepU2 moveZ (-284, 1.5);	
	wait 2.5;
	level.luckeL movey (-24, 2);
	level.luckeR movey (24, 2);
	wait 2;
	level.stangeL moveZ (-224, 1.5);
	level.stangeR moveZ (-224, 1.5);
	wait 1.5;
	level.stangeU moveZ (284, 1.5);
	level.spinner moveZ (288, 1.5);
	wait 1.5;
	level.stangeU moveZ (-284, 1.5);
		
	thread spinit();
}
spinit() {
	while(1) {
		level.spinner rotatepitch (-360, 2.5);
		level.spinner waittill ("rotatedone");
	}
}
	
roller() {
	//Door Opened
	level.pusher moveZ (-280, 1.5);
	level.stangepU1 moveZ (-284, 1.5);
	level.stangepU2 moveZ (-284, 1.5);	
	wait 2.5;	
	
	level.door1 moveZ (-64, 1.5);
	level.door2 moveZ (-64, 1.5);
	level.door3 moveZ (-64, 1.5);
	wait 1.5;
	level.roll1 movex (320, 1.5);
	level.roll2 movex (320, 1.5);
	level.roll3 movex (320, 1.5);
		
	thread rollit();
}
rollit(){
	while(1) {
		level.roll1 rotateroll (-360, 4);
		level.roll2 rotateroll (360, 4);
		level.roll3 rotateroll (-360, 4);
		wait 4.5;
	}
}

pusher() {
	level.pusher movez (216, 0.2);
	level.stangepU1 moveZ (280, 0.2);
	level.stangepU2 moveZ (280, 0.2);
	
	wait 2.5;
	
	level.pusher movez (-216, 0.2);
	level.stangepU1 moveZ (-284, 0.2);
	level.stangepU2 moveZ (-284, 0.2);
}	
	
trap3() {
	trigger = getent ("trap3_trigger", "targetname");
	level.trap3_laser0 = getent ("trap3_laser0", "targetname");	
	level.trap3_laser1 = getent ("trap3_laser1", "targetname");	
	level.trap3_laser2 = getent ("trap3_laser2", "targetname");	
	level.trap3_laser3 = getent ("trap3_laser3", "targetname");
	red = getent ("trap3_red", "targetname");
	blue = getent ("trap3_blue", "targetname");
	
	level.trap3_laser0 delete();
	level.trap3_laser1 delete();
	level.trap3_laser2 delete();
	level.trap3_laser3 delete();
	red delete();
	blue delete();
	
}
trap3_smoke1() {
	smoke = getent ("smoke_0", "targetname");
	trigger = getent ("trap3_smoke1_trigger", "targetname");
	
	while(1) {
		trigger waittill ("trigger", player);
		playfx (level.smoke, smoke.origin);
		level.smoke1_active = getTime();
		wait 15;
		level.smoke1_active = undefined;
		wait 5;
	}
}
trap3_smoke2() {
	smoke = getent ("smoke_1", "targetname");
	trigger = getent ("trap3_smoke2_trigger", "targetname");
	
	while(1) {
		trigger waittill ("trigger", player);
		playfx (level.smoke, smoke.origin);
		level.smoke2_active = getTime();
		wait 15;
		level.smoke2_active = undefined;
		wait 5;
	}
}
		
monitorSmokeActivity(){

	hidden = true;
	
	latest = 0;

	while(1){
		
		if( hidden && (isDefined( level.smoke1_active ) || isDefined( level.smoke2_active )) ){
			
			level.trap3_laser0 show();
			wait 0.5;
			level.trap3_laser1 show();
			wait 1;
			level.trap3_laser2 show();
			wait 0.2;
			level.trap3_laser3 show();
			
			hidden = false;
		}
		
		if( !isDefined( level.smoke1_active ) && isDefined( level.smoke2_active ) ) // Smoke 1 is the only one
			latest = level.smoke2_active;
		else if( !isDefined( level.smoke2_active ) && isDefined( level.smoke1_active ) ) // Smoke 2 is the only one
			latest = level.smoke1_active;
		else if( isDefined( level.smoke1_active ) && isDefined( level.smoke2_active ) ) // Get latest smoke of both if both are active
			if( level.smoke1_active > level.smoke2_active )
				latest = level.smoke1_active;
			else
				latest = level.smoke2_active;
			
		if( (getTime() - latest) > 15000 && !hidden && !isDefined( level.smoke1_active ) && !isDefined( level.smoke2_active ) ){
			
			level.trap3_laser0 hide();
			wait 0.5;
			level.trap3_laser1 hide();
			wait 1;
			level.trap3_laser2 hide();
			wait 0.2;
			level.trap3_laser3 hide();
			
			hidden = true;
		}
		wait 0.05;
	}

}

laser0Rotate(){

	self rotateroll(-60, 2.3); // First initial rotation upwards
	wait 2.3;
	
	while(1){
		self rotateroll(60, 2.3);
		wait 2.3;
		self rotateroll(-60, 2);
		wait 2;
	}


}

laser1Rotate(){

	self rotateroll(40, 2); // First initial rotation upwards
	wait 2;
	
	while(1){
		self rotateroll(-50, 2);
		wait 2;
		self rotateroll(50, 2.2);
		wait 2.2;
	}


}

laser2Rotate(){

	self rotatepitch(45, 1.0); // First initial rotation upwards
	wait 1;
	
	while(1){
		self rotatepitch(-90, 2.1);
		wait 2.1;
		self rotatepitch(90, 1.8);
		wait 1.8;
	}


}

laser3Rotate(){

	self rotatepitch(-45, 1.0); // First initial rotation upwards
	wait 1;
	
	while(1){
		self rotatepitch(90, 1.7);
		wait 1.7;
		self rotatepitch(-90, 2.4);
		wait 2.4;
	}


}




trap4() {
	trigger = getent ("trap4_trigger", "targetname");
	lucke = getent ("trap4_lucke", "targetname");
	spikes = getent ("trap4_spikes", "targetname");
	dmg = getent ("trap4_dmg", "targetname");
	blue = getent ("trap4_blue", "targetname");
	red = getent ("trap4_red", "targetname");
	dmg enablelinkto();
	dmg linkto (spikes);
	
	red hide();
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 	
	blue hide();
	red show();
	
	lucke moveZ (-20, 1);
	wait 1;
	spikes moveY (-820, 1);
	wait 5;
	spikes moveY (820, 2.5);
	wait 2.5;
	lucke moveZ (20, 3);
}

trap5() {
	trigger = getent ("trap5_trigger", "targetname");
	rolle = getent ("trap5_rolle", "targetname");
	wall = getent ("trap5_wall", "targetname");
	decke = getent ("trap5_decke", "targetname");
	blue = getent ("trap5_blue", "targetname");
	red = getent ("trap5_red", "targetname");
	rolle hide();
	wall linkto (rolle);
	
	red hide();
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	
	decke moveX (-315, 1.5);
	wait 1.5;	
	rolle rotatepitch (-180, 1);
	wait 1;
	decke moveX (315, 1.5);
}

trap6() {
	trigger = getent ("trap6_trigger", "targetname");
	fire1 = getent ("trap6_fire_1", "targetname");
	fire2 = getent ("trap6_fire_2", "targetname");
	fire3 = getent ("trap6_fire_3", "targetname");
	fire4 = getent ("trap6_fire_4", "targetname");
	fire5 = getent ("trap6_fire_5", "targetname");
	fire6 = getent ("trap6_fire_6", "targetname");
	fire7 = getent ("trap6_fire_7", "targetname");
	fire8 = getent ("trap6_fire_8", "targetname");
	fire9 = getent ("trap6_fire_9", "targetname");
	fire10 = getent ("trap6_fire_10", "targetname");
	fire11 = getent ("trap6_fire_11", "targetname");
	fire12 = getent ("trap6_fire_12", "targetname");
	dmg = getent ("trap6_dmg", "targetname");
	setdmg = getent ("trap6_setdmg", "targetname");
	sound = getent ("trap6_sound", "targetname");
	blue = getent ("trap6_blue", "targetname");
	red = getent ("trap6_red", "targetname");
	oldposition = dmg.origin;
	
	red hide();
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	
	dmg.origin =  setdmg.origin;
	sound playsound ("fire_trap"); 
	playFx(level.fire, fire1.origin);
	playFx(level.fire, fire2.origin);
	playFx(level.fire, fire3.origin);
	playFx(level.fire, fire4.origin);
	playFx(level.fire, fire5.origin);
	playFx(level.fire, fire6.origin);
	playFx(level.fire, fire7.origin);
	playFx(level.fire, fire8.origin);
	playFx(level.fire, fire9.origin);
	playFx(level.fire, fire10.origin);
	playFx(level.fire, fire11.origin);
	playFx(level.fire, fire12.origin);
	wait 8;
	dmg.origin = oldposition;

}	

trap7() {
	trigger = getent ("trap7_trigger", "targetname");
	luckeO = getent ("trap7_lucke_oben", "targetname");
	luckeU = getent ("trap7_lucke_unten", "targetname");
	pusher = getent ("trap7_pusher", "targetname");
	blue = getent ("trap7_blue", "targetname");
	red = getent ("trap7_red", "targetname");
	red hide();
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	luckeO moveZ (8, 1.5);
	luckeU moveZ (-12, 1.5);
	
	wait 1.5;
	while(1){
		pusher moveY (-820, 1);	
		pusher waittill ("movedone");
		wait 1.5;
		pusher moveY (820, 1);
		pusher waittill ("movedone");
		wait 1.5;
		
	}
}

trap8() {
	trigger = getent ("trap8_trigger", "targetname");
	spinner = getent ("trap8_spinner", "targetname");
	blue = getent ("trap8_blue", "targetname");
	red = getent ("trap8_red", "targetname");
	
	red hide();
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	
	while(1) {
		spinner rotatepitch (360, 8.5);
		wait 8.5;
	}
}

trap9() {
	trigger = getent ("trap9_trigger", "targetname");
	
	level.trap9_plat1 = getent ("trap9_plat1", "targetname");
	level.trap9_plat2 = getent ("trap9_plat2", "targetname");
	level.trap9_plat3 = getent ("trap9_plat3", "targetname");
	level.trap9_plat4 = getent ("trap9_plat4", "targetname");
	level.trap9_plat5 = getent ("trap9_plat5", "targetname");
	level.trap9_plat6 = getent ("trap9_plat6", "targetname");
	level.trap9_plat7 = getent ("trap9_plat7", "targetname");
	level.trap9_plat8 = getent ("trap9_plat8", "targetname");
	level.trap9_plat9 = getent ("trap9_plat9", "targetname");
	
	level.bouncelucke1 = getent ("stopbounce_lucke1", "targetname");
	level.bouncelucke2 = getent ("stopbounce_lucke2", "targetname");
	level.bounceplatform = getent ("stopbounce_platform", "targetname"); 
	
	level.klappe1 = getent ("klappe1", "targetname");
	level.klappe2 = getent ("klappe2", "targetname");
	level.klappe3 = getent ("klappe3", "targetname");
	level.klappe4 = getent ("klappe4", "targetname");
	level.klappe5 = getent ("klappe5", "targetname");
	level.klappe6 = getent ("klappe6", "targetname");
	level.klappe7 = getent ("klappe7", "targetname");
	level.klappe8 = getent ("klappe9", "targetname");
	level.klappe10 = getent ("klappe10", "targetname");
	level.klappe11 = getent ("klappe11", "targetname");
	level.klappe12 = getent ("klappe12", "targetname");
	level.klappe13 = getent ("klappe13", "targetname");
	level.klappe14 = getent ("klappe14", "targetname");
	level.klappe15 = getent ("klappe15", "targetname");
	level.klappe16 = getent ("klappe16", "targetname");
	level.klappe17 = getent ("klappe17", "targetname");
	level.klappe18 = getent ("klappe18", "targetname");
	level.klappe19 = getent ("klappe19", "targetname");
	level.klappe20 = getent ("klappe20", "targetname");
	level.klappe21 = getent ("klappe21", "targetname");
	level.klappe22 = getent ("klappe22", "targetname");
	level.klappe23 = getent ("klappe23", "targetname");
	level.klappe24 = getent ("klappe24", "targetname");
	level.klappe25 = getent ("klappe25", "targetname");
	level.klappe26 = getent ("klappe26", "targetname");
	level.klappe27 = getent ("klappe27", "targetname");
	level.klappe28 = getent ("klappe28", "targetname");
	level.klappe29 = getent ("klappe29", "targetname");
	level.klappe30 = getent ("klappe30", "targetname");
	level.klappe31 = getent ("klappe31", "targetname");
	level.klappe32 = getent ("klappe32", "targetname");
	level.klappe33 = getent ("klappe33", "targetname");
	level.klappe34 = getent ("klappe34", "targetname");
	level.klappe35 = getent ("klappe35", "targetname");
	level.klappe36 = getent ("klappe36", "targetname");
	level.klappe37 = getent ("klappe37", "targetname");
	level.klappe38 = getent ("klappe38", "targetname");
	level.klappe39 = getent ("klappe39", "targetname");
	level.klappe40 = getent ("klappe40", "targetname");
	level.klappe41 = getent ("klappe41", "targetname");
	level.klappe42 = getent ("klappe42", "targetname");
	level.klappe43 = getent ("klappe43", "targetname");
	level.klappe44 = getent ("klappe44", "targetname");
	level.klappe45 = getent ("klappe45", "targetname");
	level.klappe46 = getent ("klappe46", "targetname");
	level.klappe47 = getent ("klappe47", "targetname");
	level.klappe48 = getent ("klappe48", "targetname");
	level.klappe49 = getent ("klappe49", "targetname");
	level.klappe50 = getent ("klappe50", "targetname");
	level.klappe51 = getent ("klappe51", "targetname");
	level.klappe52 = getent ("klappe52", "targetname");
	level.klappe53 = getent ("klappe53", "targetname");
	level.klappe54 = getent ("klappe54", "targetname");
	level.klappe55 = getent ("klappe55", "targetname");
	level.klappe56 = getent ("klappe56", "targetname");
	level.klappe57 = getent ("klappe57", "targetname");
	level.klappe58 = getent ("klappe58", "targetname");
	level.klappe59 = getent ("klappe59", "targetname");
	level.klappe60 = getent ("klappe60", "targetname");
	level.klappe61 = getent ("klappe61", "targetname");
	level.klappe62 = getent ("klappe62", "targetname");
	level.klappe63 = getent ("klappe63", "targetname");
	level.klappe64 = getent ("klappe64", "targetname");
	level.klappe65 = getent ("klappe65", "targetname");
	level.klappe66 = getent ("klappe66", "targetname");
	level.klappe67 = getent ("klappe67", "targetname");
	level.klappe68 = getent ("klappe68", "targetname");
	level.klappe69 = getent ("klappe69", "targetname");
	level.klappe70 = getent ("klappe70", "targetname");
	level.klappe71 = getent ("klappe71", "targetname");
	level.klappe72 = getent ("klappe72", "targetname");
	level.klappe73 = getent ("klappe73", "targetname");
	level.klappe74 = getent ("klappe74", "targetname");
	level.klappe75 = getent ("klappe75", "targetname");
	level.klappe76 = getent ("klappe76", "targetname");
	level.klappe77 = getent ("klappe77", "targetname");
	level.klappe78 = getent ("klappe78", "targetname");
	level.klappe79 = getent ("klappe79", "targetname");
	level.klappe80 = getent ("klappe80", "targetname");
	level.klappe81 = getent ("klappe81", "targetname");
	
	level.star1 = getent ("star1", "targetname");
	level.star2 = getent ("star2", "targetname");
	level.star3 = getent ("star3", "targetname");
	level.star4 = getent ("star4", "targetname");
	level.star5 = getent ("star5", "targetname");
	level.star6 = getent ("star6", "targetname");
	level.star7 = getent ("star7", "targetname");
	level.star8 = getent ("star8", "targetname");
	level.star9 = getent ("star9", "targetname");
	level.star10 = getent ("star10", "targetname");
	level.star11 = getent ("star11", "targetname");
	level.star12 = getent ("star12", "targetname");
	level.star13 = getent ("star13", "targetname");
	level.star14 = getent ("star14", "targetname");
	level.star15 = getent ("star15", "targetname");
	level.star16 = getent ("star16", "targetname");
	level.star17 = getent ("star17", "targetname");
	level.star18 = getent ("star18", "targetname");
	level.star19 = getent ("star19", "targetname");
	level.star20 = getent ("star20", "targetname");
	level.star21 = getent ("star21", "targetname");
	level.star22 = getent ("star22", "targetname");
	level.star23 = getent ("star23", "targetname");
	level.star24 = getent ("star24", "targetname");
	level.star25 = getent ("star25", "targetname");
	level.star26 = getent ("star26", "targetname");
	level.star27 = getent ("star27", "targetname");
	level.star28 = getent ("star28", "targetname");
	level.star29 = getent ("star29", "targetname");
	level.star30 = getent ("star30", "targetname");
	level.star31 = getent ("star31", "targetname");
	level.star32 = getent ("star32", "targetname");
	level.star33 = getent ("star33", "targetname");
	level.star34 = getent ("star34", "targetname");
	level.star35 = getent ("star35", "targetname");
	level.star36 = getent ("star36", "targetname");
	level.star37 = getent ("star37", "targetname");
	level.star38 = getent ("star38", "targetname");
	level.star39 = getent ("star39", "targetname");
	level.star40 = getent ("star40", "targetname");
	
	level.stardmg1 = getent ("stardmg1", "targetname");
	level.stardmg2 = getent ("stardmg2", "targetname");
	level.stardmg3 = getent ("stardmg3", "targetname");
	level.stardmg4 = getent ("stardmg4", "targetname");
	level.stardmg5 = getent ("stardmg5", "targetname");
	level.stardmg6 = getent ("stardmg6", "targetname");
	level.stardmg7 = getent ("stardmg7", "targetname");
	level.stardmg8 = getent ("stardmg8", "targetname");
	level.stardmg9 = getent ("stardmg9", "targetname");
	level.stardmg10 = getent ("stardmg10", "targetname");
	level.stardmg11 = getent ("stardmg11", "targetname");
	level.stardmg12 = getent ("stardmg12", "targetname");
	level.stardmg13 = getent ("stardmg13", "targetname");
	level.stardmg14 = getent ("stardmg14", "targetname");
	level.stardmg15 = getent ("stardmg15", "targetname");
	level.stardmg16 = getent ("stardmg16", "targetname");
	level.stardmg17 = getent ("stardmg17", "targetname");
	level.stardmg18 = getent ("stardmg18", "targetname");
	level.stardmg19 = getent ("stardmg19", "targetname");
	level.stardmg20 = getent ("stardmg20", "targetname");
	level.stardmg21 = getent ("stardmg21", "targetname");
	level.stardmg22 = getent ("stardmg22", "targetname");
	level.stardmg23 = getent ("stardmg23", "targetname");
	level.stardmg24 = getent ("stardmg24", "targetname");
	level.stardmg25 = getent ("stardmg25", "targetname");
	level.stardmg26 = getent ("stardmg26", "targetname");
	level.stardmg27 = getent ("stardmg27", "targetname");
	level.stardmg28 = getent ("stardmg28", "targetname");
	level.stardmg29 = getent ("stardmg29", "targetname");
	level.stardmg30 = getent ("stardmg30", "targetname");
	level.stardmg31 = getent ("stardmg31", "targetname");
	level.stardmg32 = getent ("stardmg32", "targetname");
	level.stardmg33 = getent ("stardmg33", "targetname");
	level.stardmg34 = getent ("stardmg34", "targetname");
	level.stardmg35 = getent ("stardmg35", "targetname");
	level.stardmg36 = getent ("stardmg36", "targetname");
	level.stardmg37 = getent ("stardmg37", "targetname");
	level.stardmg38 = getent ("stardmg38", "targetname");
	level.stardmg39 = getent ("stardmg39", "targetname");
	level.stardmg40 = getent ("stardmg40", "targetname");
	
	blue = getent ("trap9_blue", "targetname");
	red = getent ("trap9_red", "targetname");
	
	level.stardmg1 enablelinkto();
	level.stardmg1 linkto (level.star1);
	level.stardmg2 enablelinkto();
	level.stardmg2 linkto (level.star2);
	level.stardmg3 enablelinkto();
	level.stardmg3 linkto (level.star3);
	level.stardmg4 enablelinkto();
	level.stardmg4 linkto (level.star4);
	level.stardmg5 enablelinkto();
	level.stardmg5 linkto (level.star5);
	level.stardmg6 enablelinkto();
	level.stardmg6 linkto (level.star6);
	level.stardmg7 enablelinkto();
	level.stardmg7 linkto (level.star7);
	level.stardmg8 enablelinkto();
	level.stardmg8 linkto (level.star8);
	level.stardmg9 enablelinkto();
	level.stardmg9 linkto (level.star9);
	level.stardmg10 enablelinkto();
	level.stardmg10 linkto (level.star10);
	level.stardmg11 enablelinkto();
	level.stardmg11 linkto (level.star11);
	level.stardmg12 enablelinkto();
	level.stardmg12 linkto (level.star12);
	level.stardmg13 enablelinkto();
	level.stardmg13 linkto (level.star13);
	level.stardmg14 enablelinkto();
	level.stardmg14 linkto (level.star14);
	level.stardmg15 enablelinkto();
	level.stardmg15 linkto (level.star15);
	level.stardmg16 enablelinkto();
	level.stardmg16 linkto (level.star16);
	level.stardmg17 enablelinkto();
	level.stardmg17 linkto (level.star17);
	level.stardmg18 enablelinkto();
	level.stardmg18 linkto (level.star18);
	level.stardmg19 enablelinkto();
	level.stardmg19 linkto (level.star19);
	level.stardmg20 enablelinkto();
	level.stardmg20 linkto (level.star20);
	level.stardmg21 enablelinkto();
	level.stardmg21 linkto (level.star21);
	level.stardmg22 enablelinkto();
	level.stardmg22 linkto (level.star22);
	level.stardmg23 enablelinkto();
	level.stardmg23 linkto (level.star23);
	level.stardmg24 enablelinkto();
	level.stardmg24 linkto (level.star24);
	level.stardmg25 enablelinkto();
	level.stardmg25 linkto (level.star25);
	level.stardmg26 enablelinkto();
	level.stardmg26 linkto (level.star26);
	level.stardmg27 enablelinkto();
	level.stardmg27 linkto (level.star27);
	level.stardmg28 enablelinkto();
	level.stardmg28 linkto (level.star28);
	level.stardmg29 enablelinkto();
	level.stardmg29 linkto (level.star29);
	level.stardmg30 enablelinkto();
	level.stardmg30 linkto (level.star30);
	level.stardmg31 enablelinkto();
	level.stardmg31 linkto (level.star31);
	level.stardmg32 enablelinkto();
	level.stardmg32 linkto (level.star32);
	level.stardmg33 enablelinkto();
	level.stardmg33 linkto (level.star33);
	level.stardmg34 enablelinkto();
	level.stardmg34 linkto (level.star34);
	level.stardmg35 enablelinkto();
	level.stardmg35 linkto (level.star35);
	level.stardmg36 enablelinkto();
	level.stardmg36 linkto (level.star36);
	level.stardmg37 enablelinkto();
	level.stardmg37 linkto (level.star37);
	level.stardmg38 enablelinkto();
	level.stardmg38 linkto (level.star38);
	level.stardmg39 enablelinkto();
	level.stardmg39 linkto (level.star39);
	level.stardmg40 enablelinkto();
	level.stardmg40 linkto (level.star40);
	
	red hide();
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	
	thread bouncestop();
	thread randomplat();
	random = randomInt(4);	
	switch(random){
		case 0: thread starattack1(); break;		 
		case 1: thread starattack2(); break;	
		case 2: thread starattack3(); break;		
		case 3: thread starattack4(); break;
}		
}

bouncestop() {
	level.bouncelucke1 movey (37, 0.5);
	level.bouncelucke2 movey (-28, 0.5);
	wait 0.5;
	level.bounceplatform movez (264, 0.5);
	wait 5.5;
	level.bounceplatform movez (-264, 0.5);
	wait 0.5;
	level.bouncelucke1 movey (-37, 2);
	level.bouncelucke2 movey (28, 2);
}
	

randomplat() {
	random = randomint(4);
	switch(random){
		case 0: thread random1(); break;
		case 1: thread random2(); break;
		case 2: thread random3(); break;
		case 3: thread random4(); break;
	}
}
random1() {
	level.trap9_plat1 notsolid();
	level.trap9_plat4 notsolid();
	level.trap9_plat8 notsolid();
}
random2() {
	level.trap9_plat2 notsolid();
	level.trap9_plat9 notsolid();
	level.trap9_plat5 notsolid();
}
random3() {
	level.trap9_plat3 notsolid();
	level.trap9_plat7 notsolid();
}
random4() {
	level.trap9_plat6 notsolid();
	level.trap9_plat9 notsolid();
}
starattack1() {
	level.klappe1 moveZ (16, 1);
	level.klappe2 moveZ (-16, 1);
	level.klappe50 moveZ (24, 1);
	level.klappe51 moveZ (-20, 1);
	level.klappe20 moveZ (16, 1);
	level.klappe21 moveZ (-16, 1);
	level.klappe80 moveZ (24, 1);
	level.klappe81 moveZ (-20, 1);
	level.klappe40 moveZ (16, 1);
	level.klappe41 moveZ (-16, 1);
	level.klappe56 moveZ (24, 1); 
	level.klappe57 moveZ (-20, 1);
	level.klappe7 moveZ (16, 1);
	level.klappe8 moveZ (-16, 1);
	level.klappe12 moveZ (16, 1);
	level.klappe13 moveZ (-16, 1);
	level.klappe14 moveZ (16, 1);
	level.klappe15 moveZ (-16, 1);
	level.klappe42 moveZ (24, 1); 
	level.klappe43 moveZ (-20, 1);	
	wait 1.5;	
	level.star1 movex (880, 1);
	level.star1 rotateyaw (360, 1);
	level.star25 movex (450, 1);
	level.star25 rotateyaw (360, 1);
	level.star10 movex (310, 1);
	level.star10 rotateyaw (360, 1);
	level.star40 movex (650, 1);
	level.star40 rotateyaw (360, 1);
	level.star20 movex (200, 1);
	level.star20 rotateyaw (360, 1);
	level.star28 movex (721, 1);
	level.star28 rotateyaw (360, 1);
	level.star4 movex (490, 1);
	level.star4 rotateyaw (360, 1);
	level.star6 movex (280, 1);
	level.star6 rotateyaw (360, 1);
	level.star7 movex (555, 1);
	level.star7 rotateyaw (360, 1);
	level.star21 movex (390, 1);
	level.star21 rotateyaw (360, 1);
	wait 1;
	level.star1 movex (-880, 1);
	level.star1 rotateyaw (-360, 1);
	level.star25 movex (-450, 1);
	level.star25 rotateyaw (-360, 1);
	level.star10 movex (-310, 1);
	level.star10 rotateyaw (-360, 1);
	level.star40 movex (-650, 1);
	level.star40 rotateyaw (-360, 1);
	level.star20 movex (-200, 1);
	level.star20 rotateyaw (-360, 1);
	level.star28 movex (-721, 1);
	level.star28 rotateyaw (-360, 1);
	level.star4 movex (-490, 1);
	level.star4 rotateyaw (-360, 1);
	level.star6 movex (-280, 1);
	level.star6 rotateyaw (-360, 1);
	level.star7 movex (-555, 1);
	level.star7 rotateyaw (-360, 1);
	level.star21 movex (-390, 1);
	level.star21 rotateyaw (-360, 1);
	wait 1;
	level.star1 movex (880, 1);
	level.star1 rotateyaw (360, 1);
	level.star25 movex (450, 1);
	level.star25 rotateyaw (360, 1);
	level.star10 movex (310, 1);
	level.star10 rotateyaw (360, 1);
	level.star40 movex (650, 1);
	level.star40 rotateyaw (360, 1);
	level.star20 movex (200, 1);
	level.star20 rotateyaw (360, 1);
	level.star28 movex (721, 1);
	level.star28 rotateyaw (360, 1);
	level.star4 movex (490, 1);
	level.star4 rotateyaw (360, 1);
	level.star6 movex (280, 1);
	level.star6 rotateyaw (360, 1);
	level.star7 movex (555, 1);
	level.star7 rotateyaw (360, 1);
	level.star21 movex (390, 1);
	level.star21 rotateyaw (360, 1);
	wait 1;
	level.star1 movex (-880, 1);
	level.star1 rotateyaw (-360, 1);
	level.star25 movex (-450, 1);
	level.star25 rotateyaw (-360, 1);
	level.star10 movex (-310, 1);
	level.star10 rotateyaw (-360, 1);
	level.star40 movex (-650, 1);
	level.star40 rotateyaw (-360, 1);
	level.star20 movex (-200, 1);
	level.star20 rotateyaw (-360, 1);
	level.star28 movex (-721, 1);
	level.star28 rotateyaw (-360, 1);
	level.star4 movex (-490, 1);
	level.star4 rotateyaw (-360, 1);
	level.star6 movex (-280, 1);
	level.star6 rotateyaw (-360, 1);
	level.star7 movex (-555, 1);
	level.star7 rotateyaw (-360, 1);
	level.star21 movex (-390, 1);
	level.star21 rotateyaw (-360, 1);
	wait 1;
	level.star1 movex (880, 1);
	level.star1 rotateyaw (360, 1);
	level.star25 movex (450, 1);
	level.star25 rotateyaw (360, 1);
	level.star10 movex (310, 1);
	level.star10 rotateyaw (360, 1);
	level.star40 movex (650, 1);
	level.star40 rotateyaw (360, 1);
	level.star20 movex (200, 1);
	level.star20 rotateyaw (360, 1);
	level.star28 movex (721, 1);
	level.star28 rotateyaw (360, 1);
	level.star4 movex (490, 1);
	level.star4 rotateyaw (360, 1);
	level.star6 movex (280, 1);
	level.star6 rotateyaw (360, 1);
	level.star7 movex (555, 1);
	level.star7 rotateyaw (360, 1);
	level.star21 movex (390, 1);
	level.star21 rotateyaw (360, 1);
	wait 1;
	level.star1 movex (-880, 1);
	level.star1 rotateyaw (-360, 1);
	level.star25 movex (-450, 1);
	level.star25 rotateyaw (-360, 1);
	level.star10 movex (-310, 1);
	level.star10 rotateyaw (-360, 1);
	level.star40 movex (-650, 1);
	level.star40 rotateyaw (-360, 1);
	level.star20 movex (-200, 1);
	level.star20 rotateyaw (-360, 1);
	level.star28 movex (-721, 1);
	level.star28 rotateyaw (-360, 1);
	level.star4 movex (-490, 1);
	level.star4 rotateyaw (-360, 1);
	level.star6 movex (-280, 1);
	level.star6 rotateyaw (-360, 1);
	level.star7 movex (-555, 1);
	level.star7 rotateyaw (-360, 1);
	level.star21 movex (-390, 1);
	level.star21 rotateyaw (-360, 1);
	wait 1;
	level.star1 movex (880, 1);
	level.star1 rotateyaw (360, 1);
	level.star25 movex (450, 1);
	level.star25 rotateyaw (360, 1);
	level.star10 movex (310, 1);
	level.star10 rotateyaw (360, 1);
	level.star40 movex (650, 1);
	level.star40 rotateyaw (360, 1);
	level.star20 movex (200, 1);
	level.star20 rotateyaw (360, 1);
	level.star28 movex (721, 1);
	level.star28 rotateyaw (360, 1);
	level.star4 movex (490, 1);
	level.star4 rotateyaw (360, 1);
	level.star6 movex (280, 1);
	level.star6 rotateyaw (360, 1);
	level.star7 movex (555, 1);
	level.star7 rotateyaw (360, 1);
	level.star21 movex (390, 1);
	level.star21 rotateyaw (360, 1);
	wait 1;
	level.star1 movex (-880, 1);
	level.star1 rotateyaw (-360, 1);
	level.star25 movex (-450, 1);
	level.star25 rotateyaw (-360, 1);
	level.star10 movex (-310, 1);
	level.star10 rotateyaw (-360, 1);
	level.star40 movex (-650, 1);
	level.star40 rotateyaw (-360, 1);
	level.star20 movex (-200, 1);
	level.star20 rotateyaw (-360, 1);
	level.star28 movex (-721, 1);
	level.star28 rotateyaw (-360, 1);
	level.star4 movex (-490, 1);
	level.star4 rotateyaw (-360, 1);
	level.star6 movex (-280, 1);
	level.star6 rotateyaw (-360, 1);
	level.star7 movex (-555, 1);
	level.star7 rotateyaw (-360, 1);
	level.star21 movex (-390, 1);
	level.star21 rotateyaw (-360, 1);
	wait 1.5;
	level.klappe1 moveZ (-16, 1);
	level.klappe2 moveZ (16, 1);
	level.klappe50 moveZ (-24, 1);
	level.klappe51 moveZ (20, 1);
	level.klappe20 moveZ (-16, 1);
	level.klappe21 moveZ (16, 1);
	level.klappe80 moveZ (-24, 1);
	level.klappe81 moveZ (20, 1);
	level.klappe40 moveZ (-16, 1);
	level.klappe41 moveZ (16, 1);
	level.klappe56 moveZ (-24, 1); 
	level.klappe57 moveZ (20, 1);
	level.klappe7 moveZ (-16, 1);
	level.klappe8 moveZ (16, 1);
	level.klappe12 moveZ (-16, 1);
	level.klappe13 moveZ (16, 1);
	level.klappe14 moveZ (-16, 1);
	level.klappe15 moveZ (16, 1);
	level.klappe42 moveZ (-24, 1); 
	level.klappe43 moveZ (20, 1);	
}

starattack2() {
	level.klappe3 moveZ (16, 1);
	level.klappe4 moveZ (-16, 1);
	level.klappe30 moveZ (24, 1);
	level.klappe31 moveZ (-20, 1);
	level.klappe44 moveZ (16, 1);
	level.klappe45 moveZ (-16, 1);
	level.klappe64 moveZ (24, 1);
	level.klappe65 moveZ (-20, 1);
	level.klappe16 moveZ (16, 1);
	level.klappe17 moveZ (-16, 1);
	level.klappe48 moveZ (24, 1);
	level.klappe49 moveZ (-20, 1);	
	level.klappe78 moveZ (24, 1);
	level.klappe79 moveZ (-20, 1);	
	level.klappe66 moveZ (24, 1);
	level.klappe67 moveZ (-20, 1);
	level.klappe52 moveZ (24, 1);
	level.klappe53 moveZ (-20, 1);	
	level.klappe24 moveZ (16, 1);
	level.klappe25 moveZ (-16, 1);	
	wait 1.5;	
	level.star2 movex (880, 1);
	level.star2 rotateyaw (360, 1);
	level.star15 movex (450, 1);
	level.star15 rotateyaw (360, 1);
	level.star22 movex (310, 1);
	level.star22 rotateyaw (360, 1);
	level.star32 movex (650, 1);
	level.star32 rotateyaw (360, 1);
	level.star8 movex (200, 1);
	level.star8 rotateyaw (360, 1);
	level.star24 movex (810, 1);
	level.star24 rotateyaw (360, 1);
	level.star39 movex (733, 1);
	level.star39 rotateyaw (360, 1);
	level.star12 movex (312, 1);
	level.star12 rotateyaw (360, 1);
	level.star33 movex (576, 1);
	level.star33 rotateyaw (360, 1);
	level.star26 movex (255, 1);
	level.star26 rotateyaw (360, 1);
	wait 1;
	level.star2 movex (-880, 1);
	level.star2 rotateyaw (-360, 1);
	level.star15 movex (-450, 1);
	level.star15 rotateyaw (-360, 1);
	level.star22 movex (-310, 1);
	level.star22 rotateyaw (-360, 1);
	level.star32 movex (-650, 1);
	level.star32 rotateyaw (-360, 1);
	level.star8 movex (-200, 1);
	level.star8 rotateyaw (-360, 1);
	level.star24 movex (-810, 1);
	level.star24 rotateyaw (-360, 1);
	level.star39 movex (-733, 1);
	level.star39 rotateyaw (-360, 1);
	level.star12 movex (-312, 1);
	level.star12 rotateyaw (-360, 1);
	level.star33 movex (-576, 1);
	level.star33 rotateyaw (-360, 1);
	level.star26 movex (-255, 1);
	level.star26 rotateyaw (-360, 1);
	wait 1;
	level.star2 movex (880, 1);
	level.star2 rotateyaw (360, 1);
	level.star15 movex (450, 1);
	level.star15 rotateyaw (360, 1);
	level.star22 movex (310, 1);
	level.star22 rotateyaw (360, 1);
	level.star32 movex (650, 1);
	level.star32 rotateyaw (360, 1);
	level.star8 movex (200, 1);
	level.star8 rotateyaw (360, 1);
	level.star24 movex (810, 1);
	level.star24 rotateyaw (360, 1);
	level.star39 movex (733, 1);
	level.star39 rotateyaw (360, 1);
	level.star12 movex (312, 1);
	level.star12 rotateyaw (360, 1);
	level.star33 movex (576, 1);
	level.star33 rotateyaw (360, 1);
	level.star26 movex (255, 1);
	level.star26 rotateyaw (360, 1);
	wait 1;
	level.star2 movex (-880, 1);
	level.star2 rotateyaw (-360, 1);
	level.star15 movex (-450, 1);
	level.star15 rotateyaw (-360, 1);
	level.star22 movex (-310, 1);
	level.star22 rotateyaw (-360, 1);
	level.star32 movex (-650, 1);
	level.star32 rotateyaw (-360, 1);
	level.star8 movex (-200, 1);
	level.star8 rotateyaw (-360, 1);
	level.star24 movex (-810, 1);
	level.star24 rotateyaw (-360, 1);
	level.star39 movex (-733, 1);
	level.star39 rotateyaw (-360, 1);
	level.star12 movex (-312, 1);
	level.star12 rotateyaw (-360, 1);
	level.star33 movex (-576, 1);
	level.star33 rotateyaw (-360, 1);
	level.star26 movex (-255, 1);
	level.star26 rotateyaw (-360, 1);
	wait 1;
	level.star2 movex (880, 1);
	level.star2 rotateyaw (360, 1);
	level.star15 movex (450, 1);
	level.star15 rotateyaw (360, 1);
	level.star22 movex (310, 1);
	level.star22 rotateyaw (360, 1);
	level.star32 movex (650, 1);
	level.star32 rotateyaw (360, 1);
	level.star8 movex (200, 1);
	level.star8 rotateyaw (360, 1);
	level.star24 movex (810, 1);
	level.star24 rotateyaw (360, 1);
	level.star39 movex (733, 1);
	level.star39 rotateyaw (360, 1);
	level.star12 movex (312, 1);
	level.star12 rotateyaw (360, 1);
	level.star33 movex (576, 1);
	level.star33 rotateyaw (360, 1);
	level.star26 movex (255, 1);
	level.star26 rotateyaw (360, 1);
	wait 1;
	level.star2 movex (-880, 1);
	level.star2 rotateyaw (-360, 1);
	level.star15 movex (-450, 1);
	level.star15 rotateyaw (-360, 1);
	level.star22 movex (-310, 1);
	level.star22 rotateyaw (-360, 1);
	level.star32 movex (-650, 1);
	level.star32 rotateyaw (-360, 1);
	level.star8 movex (-200, 1);
	level.star8 rotateyaw (-360, 1);
	level.star24 movex (-810, 1);
	level.star24 rotateyaw (-360, 1);
	level.star39 movex (-733, 1);
	level.star39 rotateyaw (-360, 1);
	level.star12 movex (-312, 1);
	level.star12 rotateyaw (-360, 1);
	level.star33 movex (-576, 1);
	level.star33 rotateyaw (-360, 1);
	level.star26 movex (-255, 1);
	level.star26 rotateyaw (-360, 1);
	wait 1;
	level.star2 movex (880, 1);
	level.star2 rotateyaw (360, 1);
	level.star15 movex (450, 1);
	level.star15 rotateyaw (360, 1);
	level.star22 movex (310, 1);
	level.star22 rotateyaw (360, 1);
	level.star32 movex (650, 1);
	level.star32 rotateyaw (360, 1);
	level.star8 movex (200, 1);
	level.star8 rotateyaw (360, 1);
	level.star24 movex (810, 1);
	level.star24 rotateyaw (360, 1);
	level.star39 movex (733, 1);
	level.star39 rotateyaw (360, 1);
	level.star12 movex (312, 1);
	level.star12 rotateyaw (360, 1);
	level.star33 movex (576, 1);
	level.star33 rotateyaw (360, 1);
	level.star26 movex (255, 1);
	level.star26 rotateyaw (360, 1);
	wait 1;
	level.star2 movex (-880, 1);
	level.star2 rotateyaw (-360, 1);
	level.star15 movex (-450, 1);
	level.star15 rotateyaw (-360, 1);
	level.star22 movex (-310, 1);
	level.star22 rotateyaw (-360, 1);
	level.star32 movex (-650, 1);
	level.star32 rotateyaw (-360, 1);
	level.star8 movex (-200, 1);
	level.star8 rotateyaw (-360, 1);
	level.star24 movex (-810, 1);
	level.star24 rotateyaw (-360, 1);
	level.star39 movex (-733, 1);
	level.star39 rotateyaw (-360, 1);
	level.star12 movex (-312, 1);
	level.star12 rotateyaw (-360, 1);
	level.star33 movex (-576, 1);
	level.star33 rotateyaw (-360, 1);
	level.star26 movex (-255, 1);
	level.star26 rotateyaw (-360, 1);
	wait 1.5;
	level.klappe3 moveZ (-16, 1);
	level.klappe4 moveZ (16, 1);
	level.klappe30 moveZ (-24, 1);
	level.klappe31 moveZ (20, 1);
	level.klappe44 moveZ (-16, 1);
	level.klappe45 moveZ (16, 1);
	level.klappe64 moveZ (-24, 1);
	level.klappe65 moveZ (20, 1);
	level.klappe16 moveZ (-16, 1);
	level.klappe17 moveZ (16, 1);
	level.klappe48 moveZ (-24, 1);
	level.klappe49 moveZ (20, 1);	
	level.klappe78 moveZ (-24, 1);
	level.klappe79 moveZ (20, 1);	
	level.klappe66 moveZ (-24, 1);
	level.klappe67 moveZ (20, 1);
	level.klappe52 moveZ (-24, 1);
	level.klappe53 moveZ (20, 1);	
	level.klappe24 moveZ (-16, 1);
	level.klappe25 moveZ (16, 1);	
}
starattack3() {
	level.klappe5 moveZ (16, 1);
	level.klappe6 moveZ (-16, 1);
	level.klappe26 moveZ (24, 1);
	level.klappe27 moveZ (-20, 1);
	level.klappe36 moveZ (16, 1);
	level.klappe37 moveZ (-16, 1);
	level.klappe54 moveZ (24, 1);
	level.klappe55 moveZ (-20, 1);
	level.klappe70 moveZ (24, 1);
	level.klappe71 moveZ (-20, 1);
	level.klappe18 moveZ (16, 1);
	level.klappe19 moveZ (-16, 1);
	level.klappe60 moveZ (24, 1);
	level.klappe61 moveZ (-20, 1);
	level.klappe68 moveZ (24, 1);
	level.klappe69 moveZ (-20, 1);
	level.klappe32 moveZ (16, 1);
	level.klappe33 moveZ (-16, 1);
	level.klappe72 moveZ (24, 1);
	level.klappe73 moveZ (-20, 1);
	wait 1.5;	
	level.star3 movex (880, 1);
	level.star3 rotateyaw (360, 1);
	level.star9 movex (715, 1);
	level.star9 rotateyaw (360, 1);
	level.star30 movex (575, 1);
	level.star30 rotateyaw (360, 1);
	level.star34 movex (800,  1);
	level.star34 rotateyaw (360, 1);
	level.star16 movex (180, 1);
	level.star16 rotateyaw (360, 1);
	level.star36 movex (680, 1);
	level.star36 rotateyaw (360,1);
	level.star13 movex (450, 1);
	level.star13 rotateyaw (360, 1);
	level.star18 movex (310, 1);
	level.star18 rotateyaw (360, 1);
	level.star27 movex (650, 1);
	level.star27 rotateyaw (360, 1);
	level.star35 movex (200, 1);
	level.star35 rotateyaw (360, 1);
	wait 1;
	level.star3 movex (-880, 1);
	level.star3 rotateyaw (-360, 1);
	level.star9 movex (-715, 1);
	level.star9 rotateyaw (-360, 1);
	level.star30 movex (-575, 1);
	level.star30 rotateyaw (-360, 1);
	level.star34 movex (-800,  1);
	level.star34 rotateyaw (-360, 1);
	level.star16 movex (-180, 1);
	level.star16 rotateyaw (-360, 1);
	level.star36 movex (-680, 1);
	level.star36 rotateyaw (-360,1);
	level.star13 movex (-450, 1);
	level.star13 rotateyaw (-360, 1);
	level.star18 movex (-310, 1);
	level.star18 rotateyaw (-360, 1);
	level.star27 movex (-650, 1);
	level.star27 rotateyaw (-360, 1);
	level.star35 movex (-200, 1);
	level.star35 rotateyaw (-360, 1);
	wait 1;
	level.star3 movex (880, 1);
	level.star3 rotateyaw (360, 1);
	level.star9 movex (715, 1);
	level.star9 rotateyaw (360, 1);
	level.star30 movex (575, 1);
	level.star30 rotateyaw (360, 1);
	level.star34 movex (800,  1);
	level.star34 rotateyaw (360, 1);
	level.star16 movex (180, 1);
	level.star16 rotateyaw (360, 1);
	level.star36 movex (680, 1);
	level.star36 rotateyaw (360,1);
	level.star13 movex (450, 1);
	level.star13 rotateyaw (360, 1);
	level.star18 movex (310, 1);
	level.star18 rotateyaw (360, 1);
	level.star27 movex (650, 1);
	level.star27 rotateyaw (360, 1);
	level.star35 movex (200, 1);
	level.star35 rotateyaw (360, 1);
	wait 1;
	level.star3 movex (-880, 1);
	level.star3 rotateyaw (-360, 1);
	level.star9 movex (-715, 1);
	level.star9 rotateyaw (-360, 1);
	level.star30 movex (-575, 1);
	level.star30 rotateyaw (-360, 1);
	level.star34 movex (-800,  1);
	level.star34 rotateyaw (-360, 1);
	level.star16 movex (-180, 1);
	level.star16 rotateyaw (-360, 1);
	level.star36 movex (-680, 1);
	level.star36 rotateyaw (-360,1);
	level.star13 movex (-450, 1);
	level.star13 rotateyaw (-360, 1);
	level.star18 movex (-310, 1);
	level.star18 rotateyaw (-360, 1);
	level.star27 movex (-650, 1);
	level.star27 rotateyaw (-360, 1);
	level.star35 movex (-200, 1);
	level.star35 rotateyaw (-360, 1);
	wait 1;
	level.star3 movex (880, 1);
	level.star3 rotateyaw (360, 1);
	level.star9 movex (715, 1);
	level.star9 rotateyaw (360, 1);
	level.star30 movex (575, 1);
	level.star30 rotateyaw (360, 1);
	level.star34 movex (800,  1);
	level.star34 rotateyaw (360, 1);
	level.star16 movex (180, 1);
	level.star16 rotateyaw (360, 1);
	level.star36 movex (680, 1);
	level.star36 rotateyaw (360,1);
	level.star13 movex (450, 1);
	level.star13 rotateyaw (360, 1);
	level.star18 movex (310, 1);
	level.star18 rotateyaw (360, 1);
	level.star27 movex (650, 1);
	level.star27 rotateyaw (360, 1);
	level.star35 movex (200, 1);
	level.star35 rotateyaw (360, 1);
	wait 1;
	level.star3 movex (-880, 1);
	level.star3 rotateyaw (-360, 1);
	level.star9 movex (-715, 1);
	level.star9 rotateyaw (-360, 1);
	level.star30 movex (-575, 1);
	level.star30 rotateyaw (-360, 1);
	level.star34 movex (-800,  1);
	level.star34 rotateyaw (-360, 1);
	level.star16 movex (-180, 1);
	level.star16 rotateyaw (-360, 1);
	level.star36 movex (-680, 1);
	level.star36 rotateyaw (-360,1);
	level.star13 movex (-450, 1);
	level.star13 rotateyaw (-360, 1);
	level.star18 movex (-310, 1);
	level.star18 rotateyaw (-360, 1);
	level.star27 movex (-650, 1);
	level.star27 rotateyaw (-360, 1);
	level.star35 movex (-200, 1);
	level.star35 rotateyaw (-360, 1);
	wait 1;
	level.star3 movex (880, 1);
	level.star3 rotateyaw (360, 1);
	level.star9 movex (715, 1);
	level.star9 rotateyaw (360, 1);
	level.star30 movex (575, 1);
	level.star30 rotateyaw (360, 1);
	level.star34 movex (800,  1);
	level.star34 rotateyaw (360, 1);
	level.star16 movex (180, 1);
	level.star16 rotateyaw (360, 1);
	level.star36 movex (680, 1);
	level.star36 rotateyaw (360,1);
	level.star13 movex (450, 1);
	level.star13 rotateyaw (360, 1);
	level.star18 movex (310, 1);
	level.star18 rotateyaw (360, 1);
	level.star27 movex (650, 1);
	level.star27 rotateyaw (360, 1);
	level.star35 movex (200, 1);
	level.star35 rotateyaw (360, 1);
	wait 1;
	level.star3 movex (-880, 1);
	level.star3 rotateyaw (-360, 1);
	level.star9 movex (-715, 1);
	level.star9 rotateyaw (-360, 1);
	level.star30 movex (-575, 1);
	level.star30 rotateyaw (-360, 1);
	level.star34 movex (-800,  1);
	level.star34 rotateyaw (-360, 1);
	level.star16 movex (-180, 1);
	level.star16 rotateyaw (-360, 1);
	level.star36 movex (-680, 1);
	level.star36 rotateyaw (-360,1);
	level.star13 movex (-450, 1);
	level.star13 rotateyaw (-360, 1);
	level.star18 movex (-310, 1);
	level.star18 rotateyaw (-360, 1);
	level.star27 movex (-650, 1);
	level.star27 rotateyaw (-360, 1);
	level.star35 movex (-200, 1);
	level.star35 rotateyaw (-360, 1);
	wait 1.5;
	level.klappe5 moveZ (-16, 1);
	level.klappe6 moveZ (16, 1);
	level.klappe26 moveZ (-24, 1);
	level.klappe27 moveZ (20, 1);
	level.klappe36 moveZ (-16, 1);
	level.klappe37 moveZ (16, 1);
	level.klappe54 moveZ (-24, 1);
	level.klappe55 moveZ (20, 1);
	level.klappe70 moveZ (-24, 1);
	level.klappe71 moveZ (20, 1);
	level.klappe18 moveZ (-16, 1);
	level.klappe19 moveZ (16, 1);
	level.klappe60 moveZ (-24, 1);
	level.klappe61 moveZ (20, 1);
	level.klappe68 moveZ (-24, 1);
	level.klappe69 moveZ (20, 1);
	level.klappe32 moveZ (-16, 1);
	level.klappe33 moveZ (16, 1);
	level.klappe72 moveZ (-24, 1);
	level.klappe73 moveZ (20, 1);
}
starattack4() {
	level.klappe10 moveZ (16, 1);
	level.klappe11 moveZ (-16, 1);
	level.klappe46 moveZ (24, 1);
	level.klappe47 moveZ (-20, 1);
	level.klappe76 moveZ (24, 1);
	level.klappe77 moveZ (-20, 1);
	level.klappe38 moveZ (24, 1);
	level.klappe39 moveZ (-20, 1);
	level.klappe28 moveZ (16, 1);
	level.klappe29 moveZ (-16, 1);
	level.klappe74 moveZ (24, 1);
	level.klappe75 moveZ (-20, 1);
	level.klappe58 moveZ (24, 1);
	level.klappe59 moveZ (-20, 1);
	level.klappe62 moveZ (24, 1);
	level.klappe63 moveZ (-20, 1);
	level.klappe22 moveZ (16, 1);
	level.klappe23 moveZ (-16, 1);	
	level.klappe34 moveZ (16, 1);
	level.klappe35 moveZ (-16, 1);		
	wait 1.5;	
	level.star5 movex (880, 1);
	level.star5 rotateyaw (360, 1);
	level.star23 movex (450, 1);
	level.star23 rotateyaw (360, 1);
	level.star38 movex (310, 1);
	level.star38 rotateyaw (360, 1);
	level.star19 movex (650, 1);
	level.star19 rotateyaw (360, 1);
	level.star14 movex (200, 1);
	level.star14 rotateyaw (360, 1);
	level.star37 movex (555, 1);
	level.star37 rotateyaw (360, 1);
	level.star29 movex (800, 1);
	level.star29 rotateyaw (360, 1);
	level.star11 movex (180, 1);
	level.star11 rotateyaw (360, 1);
	level.star31 movex (720, 1);
	level.star31 rotateyaw (360, 1);
	level.star17 movex (490, 1);
	level.star17 rotateyaw (360, 1);
	wait 1;
	level.star5 movex (-880, 1);
	level.star5 rotateyaw (-360, 1);
	level.star23 movex (-450, 1);
	level.star23 rotateyaw (-360, 1);
	level.star38 movex (-310, 1);
	level.star38 rotateyaw (-360, 1);
	level.star19 movex (-650, 1);
	level.star19 rotateyaw (-360, 1);
	level.star14 movex (-200, 1);
	level.star14 rotateyaw (-360, 1);
	level.star37 movex (-555, 1);
	level.star37 rotateyaw (-360, 1);
	level.star29 movex (-800, 1);
	level.star29 rotateyaw (-360, 1);
	level.star11 movex (-180, 1);
	level.star11 rotateyaw (-360, 1);
	level.star31 movex (-720, 1);
	level.star31 rotateyaw (-360, 1);
	level.star17 movex (-490, 1);
	level.star17 rotateyaw (-360, 1);
	wait 1;
	level.star5 movex (880, 1);
	level.star5 rotateyaw (360, 1);
	level.star23 movex (450, 1);
	level.star23 rotateyaw (360, 1);
	level.star38 movex (310, 1);
	level.star38 rotateyaw (360, 1);
	level.star19 movex (650, 1);
	level.star19 rotateyaw (360, 1);
	level.star14 movex (200, 1);
	level.star14 rotateyaw (360, 1);
	level.star37 movex (555, 1);
	level.star37 rotateyaw (360, 1);
	level.star29 movex (800, 1);
	level.star29 rotateyaw (360, 1);
	level.star11 movex (180, 1);
	level.star11 rotateyaw (360, 1);
	level.star31 movex (720, 1);
	level.star31 rotateyaw (360, 1);
	level.star17 movex (490, 1);
	level.star17 rotateyaw (360, 1);
	wait 1;
	level.star5 movex (-880, 1);
	level.star5 rotateyaw (-360, 1);
	level.star23 movex (-450, 1);
	level.star23 rotateyaw (-360, 1);
	level.star38 movex (-310, 1);
	level.star38 rotateyaw (-360, 1);
	level.star19 movex (-650, 1);
	level.star19 rotateyaw (-360, 1);
	level.star14 movex (-200, 1);
	level.star14 rotateyaw (-360, 1);
	level.star37 movex (-555, 1);
	level.star37 rotateyaw (-360, 1);
	level.star29 movex (-800, 1);
	level.star29 rotateyaw (-360, 1);
	level.star11 movex (-180, 1);
	level.star11 rotateyaw (-360, 1);
	level.star31 movex (-720, 1);
	level.star31 rotateyaw (-360, 1);
	level.star17 movex (-490, 1);
	level.star17 rotateyaw (-360, 1);
	wait 1;
	level.star5 movex (880, 1);
	level.star5 rotateyaw (360, 1);
	level.star23 movex (450, 1);
	level.star23 rotateyaw (360, 1);
	level.star38 movex (310, 1);
	level.star38 rotateyaw (360, 1);
	level.star19 movex (650, 1);
	level.star19 rotateyaw (360, 1);
	level.star14 movex (200, 1);
	level.star14 rotateyaw (360, 1);
	level.star37 movex (555, 1);
	level.star37 rotateyaw (360, 1);
	level.star29 movex (800, 1);
	level.star29 rotateyaw (360, 1);
	level.star11 movex (180, 1);
	level.star11 rotateyaw (360, 1);
	level.star31 movex (720, 1);
	level.star31 rotateyaw (360, 1);
	level.star17 movex (490, 1);
	level.star17 rotateyaw (360, 1);
	wait 1;
	level.star5 movex (-880, 1);
	level.star5 rotateyaw (-360, 1);
	level.star23 movex (-450, 1);
	level.star23 rotateyaw (-360, 1);
	level.star38 movex (-310, 1);
	level.star38 rotateyaw (-360, 1);
	level.star19 movex (-650, 1);
	level.star19 rotateyaw (-360, 1);
	level.star14 movex (-200, 1);
	level.star14 rotateyaw (-360, 1);
	level.star37 movex (-555, 1);
	level.star37 rotateyaw (-360, 1);
	level.star29 movex (-800, 1);
	level.star29 rotateyaw (-360, 1);
	level.star11 movex (-180, 1);
	level.star11 rotateyaw (-360, 1);
	level.star31 movex (-720, 1);
	level.star31 rotateyaw (-360, 1);
	level.star17 movex (-490, 1);
	level.star17 rotateyaw (-360, 1);
	wait 1;
	level.star5 movex (880, 1);
	level.star5 rotateyaw (360, 1);
	level.star23 movex (450, 1);
	level.star23 rotateyaw (360, 1);
	level.star38 movex (310, 1);
	level.star38 rotateyaw (360, 1);
	level.star19 movex (650, 1);
	level.star19 rotateyaw (360, 1);
	level.star14 movex (200, 1);
	level.star14 rotateyaw (360, 1);
	level.star37 movex (555, 1);
	level.star37 rotateyaw (360, 1);
	level.star29 movex (800, 1);
	level.star29 rotateyaw (360, 1);
	level.star11 movex (180, 1);
	level.star11 rotateyaw (360, 1);
	level.star31 movex (720, 1);
	level.star31 rotateyaw (360, 1);
	level.star17 movex (490, 1);
	level.star17 rotateyaw (360, 1);
	wait 1;
	level.star5 movex (-880, 1);
	level.star5 rotateyaw (-360, 1);
	level.star23 movex (-450, 1);
	level.star23 rotateyaw (-360, 1);
	level.star38 movex (-310, 1);
	level.star38 rotateyaw (-360, 1);
	level.star19 movex (-650, 1);
	level.star19 rotateyaw (-360, 1);
	level.star14 movex (-200, 1);
	level.star14 rotateyaw (-360, 1);
	level.star37 movex (-555, 1);
	level.star37 rotateyaw (-360, 1);
	level.star29 movex (-800, 1);
	level.star29 rotateyaw (-360, 1);
	level.star11 movex (-180, 1);
	level.star11 rotateyaw (-360, 1);
	level.star31 movex (-720, 1);
	level.star31 rotateyaw (-360, 1);
	level.star17 movex (-490, 1);
	level.star17 rotateyaw (-360, 1);
	wait 1.5;
	level.klappe10 moveZ (-16, 1);
	level.klappe11 moveZ (16, 1);
	level.klappe46 moveZ (-24, 1);
	level.klappe47 moveZ (20, 1);
	level.klappe76 moveZ (-24, 1);
	level.klappe77 moveZ (20, 1);
	level.klappe38 moveZ (-24, 1);
	level.klappe39 moveZ (20, 1);
	level.klappe28 moveZ (-16, 1);
	level.klappe29 moveZ (16, 1);	
	level.klappe74 moveZ (-24, 1);
	level.klappe75 moveZ (20, 1);
	level.klappe58 moveZ (-24, 1);
	level.klappe59 moveZ (20, 1);
	level.klappe62 moveZ (-24, 1);
	level.klappe63 moveZ (20, 1);
	level.klappe22 moveZ (-16, 1);
	level.klappe23 moveZ (16, 1);	
	level.klappe34 moveZ (-16, 1);
	level.klappe35 moveZ (16, 1);		
	
}

trap10() {
	trigger = getent ("trap10_trigger", "targetname");
	spikeL = getent ("trap10_spikes_l", "targetname");
	spikeR = getent ("trap10_spikes_r", "targetname");
	dmgL = getent ("trap10_spikes_dmg_l", "targetname");
	dmgR = getent ("trap10_spikes_dmg_r", "targetname");
	blue = getent ("trap10_blue", "targetname");
	red = getent ("trap10_red", "targetname");
	
	red hide();
	dmgL enablelinkto();
	dmgL linkto(spikeL);
	dmgR enablelinkto();
	dmgR linkto(spikeR);
	
	trigger setHintString ("^7Press ^3[Use] ^7to Activate!");
	trigger waittill ("trigger", Player);
	trigger setHintString ("^1Trap Activated!"); 
	blue hide();
	red show();
	
	while(1) {
	spikeL movez (115, 0.5);	
	spikeR movez (115, 0.5);	
	wait 4;
	spikeL movez (-115, 0.5);	
	spikeR movez (-115, 0.5);	
	wait 6;
	}
}
	
////////////////////Secrets

owh() {
	trigger = getent ("owh_trigger", "targetname");
	thread owh1();
	thread owh2();
	thread owh3();
	thread owh4();
	thread owh5();
	
	trigger waittill ("trigger", player);
	player iprintlnbold("^7owh^1, ^7that hurts" + "^1 :'(");
	trigger delete();
}

owh1() {
	trigger = getent ("owh1_trigger", "targetname");
	
	trigger waittill ("trigger", player);
	player iprintlnbold ("Stop searching for Secrets^1!");
	trigger delete();
}

owh2() {
	trigger = getent ("owh2_trigger", "targetname");
	
	trigger waittill ("trigger", player);
	player iprintlnbold ("Stop it^1!");
	trigger delete();
}

owh3() {
	trigger = getent ("owh3_trigger", "targetname");
	
	trigger waittill ("trigger", player);
	player iprintlnbold ("Give up^1!");
	trigger delete();
}

owh4() {
	trigger = getent ("owh4_trigger", "targetname");
	
	trigger waittill ("trigger", player);
	player iprintlnbold ("Do you think a Wall has no Feeling^1?");
	trigger delete();
}

owh5() {
	step1 = getent ("owh5_trigger", "targetname");
	step2 = getent ("owh6_trigger", "targetname");
	step3 = getent ("owh7_trigger", "targetname");
	step4 = getent ("owh8_trigger", "targetname");

	
	step1 waittill ("trigger", player);
	player iprintlnbold ("You just found Step ^11");
	step1 delete();
	step2 waittill ("trigger", player);
	player iprintlnbold ("You just found Step ^12");
	step2 delete();
	step3 waittill ("trigger", player);
	player iprintlnbold ("You just found Step ^13");
	step3 delete();
	while (1){
	step4 waittill ("trigger", player);
	player iprintlnbold ("You just found Step ^14");	
	wait 1;
	player thread gosecret();
	}


}

gosecret() {
	target = getent ("owh_target", "targetname");
	target1 = getent ("owh_target1", "targetname");
	
	self setOrigin (target.origin);	
	self setplayerangles (target.angles);
	wait 5.5;
	self setOrigin (target1.origin);
	self setplayerangles (target.origin);
	self iprintlnbold ("Have fun^1!");	
}


spiningrpg() {
	object = getent ("secret_rpg_spin0", "targetname");
	thread spiningrpg1();
	thread spiningrpg2();
	thread spiningrpg3();
	thread spiningrpg4();
	thread spiningrpg5();
	while(1) {
		object moveZ (20, 5);
		object waittill ("movedone");
		object movez (-20, 5);
		wait 5;
	}
}

spiningrpg1() {
	object = getent ("secret_rpg_spin1", "targetname");
	
	while(1) {
		object moveZ (20, 5);
		object waittill ("movedone");
		object movez (-20, 5);
		wait 5;
	}
}

spiningrpg2() {
	object = getent ("secret_rpg_spin2", "targetname");
	
	while(1) {
		object moveZ (20, 5);
		object waittill ("movedone");
		object movez (-20, 5);
		wait 5;
	}
}

spiningrpg3() {
	object = getent ("secret_rpg_spin3", "targetname");
	
	while(1) {
		object moveZ (20, 5);
		object waittill ("movedone");
		object movez (-20, 5);
		wait 5;
	}
}

spiningrpg4() {
	object = getent ("secret_rpg_spin4", "targetname");
	
	while(1) {
		object moveZ (20, 5);
		object waittill ("movedone");
		object movez (-20, 5);
		wait 5;
	}
}

spiningrpg5() {
	object = getent ("secret_rpg_spin5", "targetname");
	
	while(1) {
		object moveZ (20, 5);
		object waittill ("movedone");
		object movez (-20, 5);
		wait 5;
	}
}
///////////////////////// Jump Secret
jumpsecret() {
	trigger = getent ("jump_secret_trigger", "targetname");
	target = getent ("jump_secret_target", "targetname");
	
	while(1) {
		trigger waittill("trigger", player);
		player sr\api\_map::startSecret(); //Speedrun Copy Paste
		player setorigin (target.origin);
		player setplayerangles (target.angles);
		//player iprintlnbold("Good luck, little Friend^1!");
		
		//player thread secretTimer();
	}
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

respawn0() {
	trigger = getent ("jump_secret_respawn0", "targetname");
	target = getent ("jump_secret_respawn0_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

respawn1() {
	trigger = getent ("jump_secret_respawn1", "targetname");
	target = getent ("jump_secret_respawn1_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

respawn2() {
	trigger = getent ("jump_secret_respawn2", "targetname");
	target = getent ("jump_secret_respawn2_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

respawn3() {
	trigger = getent ("jump_secret_respawn3", "targetname");
	target = getent ("jump_secret_respawn3_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

respawn4() {
	trigger = getent ("jump_secret_respawn4", "targetname");
	target = getent ("jump_secret_respawn4_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

respawn5() {
	trigger = getent ("jump_secret_respawn5", "targetname");
	target = getent ("jump_secret_respawn5_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

respawn6() {
	trigger = getent ("jump_secret_respawn6", "targetname");
	target = getent ("jump_secret_respawn6_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}
	
respawn7() {
	trigger = getent ("jump_secret_respawn7", "targetname");
	target = getent ("jump_secret_respawn7_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}
	
respawn8() {
	trigger = getent ("jump_secret_respawn8", "targetname");
	target = getent ("jump_secret_respawn8_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}
	
giverpg0() {
	trigger = getent ("secret_giverpg0", "targetname");
	
	while(1) {
		trigger waittill ("trigger", player);
		
		player giveWeapon("rpg_mp", 100, 500 );
		player givemaxammo ("rpg_mp");
		player switchToWeapon("rpg_mp");
	}
}	

giverpg1() {
	trigger = getent ("secret_giverpg1", "targetname");
	
	while(1) {
		trigger waittill ("trigger", player);
		
		player giveWeapon("rpg_mp", 100, 500 );
		player givemaxammo ("rpg_mp");
		player switchToWeapon("rpg_mp");
	}
}

giverpg2() {
	trigger = getent ("secret_giverpg2", "targetname");
	
	while(1) {
		trigger waittill ("trigger", player);
		
		player giveWeapon("rpg_mp", 100, 500 );
		player givemaxammo ("rpg_mp");
		player switchToWeapon("rpg_mp");
	}
}

giverpg3() {
	trigger = getent ("secret_giverpg3", "targetname");
	
	while(1) {
		trigger waittill ("trigger", player);
		
		player giveWeapon("rpg_mp", 100, 500 );
		player givemaxammo ("rpg_mp");
		player switchToWeapon("rpg_mp");
	}
}

giverpg4() {
	trigger = getent ("secret_giverpg4", "targetname");
	
	while(1) {
		trigger waittill ("trigger", player);
		
		player giveWeapon("rpg_mp", 100, 500 );
		player givemaxammo ("rpg_mp");
		player switchToWeapon("rpg_mp");
	}
}

giverpg5() {
	trigger = getent ("secret_giverpg5", "targetname");
	
	while(1) {
		trigger waittill ("trigger", player);
		
		player giveWeapon("rpg_mp", 100, 500 );
		player givemaxammo ("rpg_mp");
		player switchToWeapon("rpg_mp");
	}
}

backtomap() {
	trigger = getent ("backtomap_trigger", "targetname");
	target = getent ("backtomap_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		player notify("end_secret_timer");
		player unsetperk("specialty_fastreload");
		player thread removeCountdown();
		player thread removeText();
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		iprintlnbold ("^3"+player.name + " ^7is such a pro jumper and finished the Secret^1!");
		player braxi\_rank::giveRankXp( "", 500);
	}
}

backtomap2() {
	trigger = getent ("backtomap2_trigger", "targetname");
	target = getent ("backtomap2_target", "targetname");
	
	for(;;)
	{
		trigger waittill ("trigger", player);
		player notify("end_secret_timer");
		player unsetperk("specialty_fastreload");
		player thread removeCountdown();
		player thread removeText();
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		iprintlnbold ("^3"+player.name + " ^7finished the Secret^1!");
		player braxi\_rank::giveRankXp( "", 250);
	}
}
	
/////////////////////////Endrooms + Queue

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
			warteraum = getent ("warteschlange_eins", "targetname");
			player setOrigin(warteraum.origin);
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
			warteraum = getent ("warteschlange_zwei", "targetname");
			player setOrigin(warteraum.origin);
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
			warteraum = getent ("warteschlange_drei", "targetname");
			player setOrigin(warteraum.origin);
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
			warteraum = getent ("warteschlange_vier", "targetname");
			player setOrigin(warteraum.origin);
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
	object = getent ("old_door", "targetname");
			
		level.oldway_trigger waittill( "trigger", player );
       
		level.sniper_endroom delete();
		level.knife_trigger delete();
		level.bounce_trigger delete();	
		level.randomweap_trigger delete();
		level.oldway_trigger delete();
		thread createSelectedRoom(player.name + " ^3 HAS OPENED THE OLD WAY^7!" );		
		object moveZ (-185, 2.5);
		object waittill ("movedone");
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