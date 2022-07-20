//////////////////////\\\\\\\\\\\\\\\\\\\\\\
//    __              ___                 \\
//   /\ \            /\_ \                \\
//   \ \ \        ___\//\ \    ____       \\
//    \ \ \  __  / __`\\ \ \  /\_ ,`\     \\
//     \ \ \L\ \/\ \L\ \\_\ \_\/_/  /_    \\
//      \ \____/\ \____//\____\ /\____\   \\
//       \/___/  \/___/ \/____/ \/____/   \\
// 								          \\
//////////////////////\\\\\\\\\\\\\\\\\\\\\\
//Map by Lolz      |      Scripted by Lolz\\
//        Nickname i have in game :       \\
//   Lolz :] -SuX Lolz :] -#FNRP#Lolz :]  \\
//            xFire: alex1528             \\
//    Steam: iswenzz1528 / SuX Lolz :]    \\
//////////////////////\\\\\\\\\\\\\\\\\\\\\\

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
level.masterSpawn = spawn("script_origin",(-6512,824,1144));
level.masterSpawn.angles = (0,270,0);
trigger = spawn( "trigger_radius", (-3883,8317,6316), 0, 150, 400 );
trigger.targetname = "endmap_trig";
trigger.radius = 150;
 maps\mp\_load::main();
 maps\mp\_compass::setupMiniMap("compass_map_mp_surf_nighty");

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

	//SETDVAR**
	setdvar( "r_specularcolorscale", "1" );
	setdvar("compassmaxrange","1600");
	setDvar("bg_falldamagemaxheight", 2000000000 );
	setDvar("bg_falldamageminheight", 1500000000 );
	setDvar("g_knockback","4000");
	//SETDVAR*

	//THREAD**
	thread way_connect();
	thread onPlayerConnected();
	thread lift();
	//thread nr_tp();
	thread turnbox();
	thread rift();
	thread tp();
	// thread boost();
	//THREAD*

	//PRECACHE**
	precacheitem ("m40a3_mp");
	precacheitem ("remington700_mp");
	precacheitem ("uzi_silencer_mp");
	precacheItem ("ak74u_mp");
	precacheItem ("rpg_mp");
	precacheItem ("winchester1200_mp");
	precacheItem ("ak47_mp");
	precacheItem ("rpd_mp");
	precacheItem ("m1014_grip_mp");
	precacheItem ("deserteaglegold_mp");
	precacheItem ("p90_silencer_mp");
	precacheItem ("saw_grip_mp");
	//PRECACHE*

	//NG**
	thread lvl1rollsetup();
	thread lvl1pitchsetup();
	//NG*

	//TURN**

	trip_1 = getEntArray("brush_turn_1_array","targetname");
	for(i=0;i<trip_1.size;i++)
	trip_1[i] thread trip1();

	trl = getEntArray("rift_rotate_l_array","targetname");
	for(i=0;i<trl.size;i++)
	trl[i] thread rt_l();

	trr = getEntArray("rift_rotate_r_array","targetname");
	for(i=0;i<trr.size;i++)
	trr[i] thread rt_r();

	t1 = getEntArray("c1_turn_l","targetname");
	for(i=0;i<t1.size;i++)
	t1[i] thread turnpitch();

	t2 = getEntArray("c1_turn_r","targetname");
	for(i=0;i<t2.size;i++)
	t2[i] thread turnpitch2();

	c1 = getEntArray("c1","targetname");
	for(i=0;i<c1.size;i++)
	c1[i] thread turnpitch();

	//wp = getEntArray("while_pitch","targetname");
	//for(i=0;i<wp.size;i++)
	//wp[i] thread pitchloop();

	push1 = getEntArray("push_1","targetname");
	for(i=0;i<push1.size;i++)
	push1[i] thread playertrig();

	tlogo = getEntArray("turn","targetname");
	for(i=0;i<tlogo.size;i++)
	tlogo[i] thread turnlogo();
	//TURN*

	visionSetNaked("mp_dr_nighty_v2", 0);

}

boost()
{
	b = getEnt("speed_boost","targetname");

	for(;;)
	{
		b waittill("trigger",p);
		p thread boostng();
	}
}

boostng()
{
	if(self.boosted)
		return;

	self.boosted = true;
	self sr\api\_player::setPlayerSpeedScale(5);
	wait 5;
	self sr\api\_player::setPlayerSpeedScale(1);
	self.boosted = false;
}

tp()
{
	thread tp1();
}

tp1()
{
	o = getEnt("tp_1_o","targetname");
	t = getEnt("tp_1_t","targetname");

	for(;;)
	{
	t waittill("trigger",player);
	player setOrigin(o.origin);
	player setPlayerAngles(o.angles);
	player freezeControls(true);
	wait .1;
	player freezeControls(false);
	}
}

rift()
{
	thread rift1();
	//thread rift2();
	thread rift3();
}

rift1()
{
	r = getEnt("rift_1","targetname");
	rb = getEnt("rift_1_b","targetname");

	while(1){
		r rotatePitch(360,16);
		rb rotatePitch(-360,16);
		wait 15;
	}
}

rift3()
{
	r = getEnt("rift_3","targetname");
	rb = getEnt("rift_3_b","targetname");

	while(1){
		r rotatePitch(360,16);
		rb rotatePitch(-360,16);
		wait 15;
	}
}

trip1()
{
	while(1){
		self rotateRoll(360,6);
		wait 5;
	}
}

turnbox()
{
	thread turnbox1();
}

turnbox1()
{
	t = getEnt("turn_box","targetname");
	o = spawn("script_origin", (-6528.5, 4674.5, 1248));

	level waittill("round_started");
	// t enableLinkTo();
	t linkTo(o);

	ang = 0;

	wait .05;

	while(isDefined(o.origin)){
		o.angles = (o.angles + (0,ang,0));
		ang += -0.002;
		wait 0.02;
		//iprintlnbold(o.angles);
	}
}

lift()
{
lift=getent("lift","targetname");
lift_trigger=getent("lift_trigger","targetname");
lift_trigger waittill ("trigger");
iprintlnbold("^1Start door opened :]");
wait 2;
lift movez (241,4,1,1);
wait 2;
}

nr_tp()
{
	//thread nr_tp_1();
}

nr_tp_1()
{
	t = getEnt("nw_tp_trig_1", "targetname");
	o = getEnt("nw_tp_ori_1", "targetname");

	for (;;)
	{
		t waittill("trigger", player);
		player freezeControls(true);
		wait 0.05;
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
		player freezeControls(false);
	}
}

playertrig(trigger)
{
	for(;;)
	{
	    self waittill("trigger", player);
		if(!isDefined (player.push))
			player thread push(player);
		wait .05;
	}
}

push(player)
{
	player.push = true;
	wait 0.2;
	player.health += 1000;
	player FinishPlayerDamage( player, player, 1000, 0, "MOD_PROJECTILE", "bh_mp", player.origin, AnglesToForward((0, 360, 0) + (0, 90, 0)), "none", 0 );
	wait 0.1;
	player.push = undefined;
}

pitchloop()
{
	while(1)
	{
		self rotatePitch(360, 2);
		wait 1;
	}
}

lvl1pitchsetup()
{
pitch1 = getEntArray("pitch_1","targetname");

num_1 = -50;

wait 1;

	for(i=0;i<pitch1.size;i++)
	{
		pitch1[i] rotatePitch(180, 0.2);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

lvl1rollsetup()
{
roll1 = getEntArray("roll_1","targetname");
// ng1 = getEnt("roll_1_ng","targetname");
// num_1 = -20;

wait 1;

// ng1 rotateRoll(180 + num_1, 0.2);

	for(i=0;i<roll1.size;i++)
	{
		roll1[i] rotateRoll(180, 0.2);
	}
}

onPlayerConnected()
{
	for(;;)
	{
	level waittill("connected", player);
	player thread onPlayer();
	}
}

onPlayer()
{
	for(;;)
	{
	level waittill("player_spawn",player);
	player thread forcedvar( player );
	}
}

forcedvar( p )
{
	p endon("death");
	p endon("disconnect");

	while(1)
	{
		p setClientDvar("dynent_active","1");
		p setClientDvar("r_detail","1");
		p setClientDvar("r_specular","1");
		p setClientDvar("r_normal","1");
		p setClientDvar("r_glow","1");
		p setClientDvar("r_drawdecals","1");
		wait 1;
	}
}

turnlogo()
{
	while(1)
	{
		self rotatePitch(360, 14);
		wait 12;
	}
}

turnpitch()
{
	while(1)
	{
		self rotatePitch(360, 14);
		wait 12;
	}
}

turnpitch2()
{
	while(1)
	{
		self rotatePitch(-360, 14);
		wait 12;
	}
}

rt_l()
{
	while(1)
	{
		self rotateYaw(-360, 16);
		wait 15;
	}
}

rt_r()
{
	while(1)
	{
		self rotateYaw(-360, 16);
		wait 15;
	}
}

//END\\


