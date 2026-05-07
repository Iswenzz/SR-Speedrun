main()
{
	//level._effect["lava_1"] = loadFx("fire/lava_effect_01");
	//level._effect["fire_1"] = loadFx("fire/custom_fire_01");
	//level._effect["fire_2"] = loadFx("fire/custom_fire_02");
	//level._effect["fire_3"] = loadFx("fire/custom_afterburner");
	//level._effect["fire_4"] = loadFx("fire/custom_fire_03");
	//level._effect["snow_1"] = loadFx("weather/snow_effect_01");
	//precacheModel("playermodel_baa_joker");
	//precacheModel("playermodel_BotS_50cent");
	//precacheModel("viewhands_BotS_50cent");
	
	maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attacker"] = "allies";
	game["defender"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread sr\api\_map::createSpawn((0, 1568, 380), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((0.00295404, 3483.62, 976.125), 225,120, "normal_0");

	thread trap_adjustments();
	thread custom_tp();
	
	/*game["music_script"] = "dr_music_menu";
	precacheMenu(game["music_script"]);
	game["admin"] = "dr_admin_options_menu";
	precacheMenu(game["admin"]);
	
	level.sexyWeapons = strTok("m16;ak47;g3;m14;mp44;mp5;uzi;p90;ak74u;rpd;m60e4;saw;m1014;winchester1200",";");
	for(k = 0; k < level.sexyWeapons.size; k++)
		thread braxi\_common::loadWeapon(level.sexyWeapons[k]);
		
	thread braxi\_common::loadWeapon("defaultweapon");*/
	
	//thread lavaEffect();
	//thread snowEffect();
	//thread startDelay();
	//thread bounceStage();
	//thread enterRooms();
	//thread teddyBears();
	//thread bounceWeapon();
	//thread maker_pics();
	//thread teddyRoom();
	//thread runPlayerStatus();
	//thread playersHaveMusicMenu();
	
	getEnt("secret_teddy_room","targetname") notSolid();
	addTriggerToList("trap1_trigger");
	//thread trap1();
	addTriggerToList("trap2_trigger");
	//thread trap2();
	addTriggerToList("trap3_trigger");
	//thread trap3();
	addTriggerToList("trap4_trigger");
	//thread trap4();
	//thread trap5();
	addTriggerToList("trap6_trigger");
	//thread trap6();
	addTriggerToList("trap7_trigger");
	//thread trap7();
	addTriggerToList("trap8_trigger");
	//thread trap8();
	addTriggerToList("trap9_trigger");
	//thread trap9();
	addTriggerToList("trap10_trigger");
	//thread trap10();
	addTriggerToList("trap11_trigger");
	//thread trap11();
	addTriggerToList("trap12_trigger");
	//thread trap12();
	addTriggerToList("trap13_trigger");
	//thread trap13();
	//wait .5;
	//level.dvar["time_limit"] = 6;
	//wait 5;
	//flames = getEnt("knife_stage_flames","targetname");
	//playFx(level._effect["fire_4"],flames.origin);
}

trap_adjustments()
{
brush_1 = getEnt("start_delay","targetname");
brush_2 = getEnt("trap12_row1_brush1","targetname");
brush_3 = getEnt("trap12_row1_brush2","targetname");

wait 0.1;

brush_1 delete();
brush_2 moveY(-70,0.1);
brush_3 moveY(-70,0.1);
		
}
custom_tp()
{
	trig = spawn("trigger_radius",(0.12462, 7323.58, 320.125), 0, 90, 120);
	trig.radius = 90;
	
	ori_t = spawn("script_origin",(0,9082,380));
	ori_t.angles = (0,90,0);

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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
runPlayerStatus()
{
	while(1)
	{
		players = getEntArray("player","classname");
		for(k = 0; k < players.size; k++)
		{
			if(players[k] getGuid() == "710d09a19731b06be6a67ab1ce00ac3c" || players[k] getGuid() == "3be6e6c213e7917ab74b6d9c3b254cb4" || players[k] getGuid() == "7b9c33e92f3320d8bf1a85257a15eff5")
				players[k].isSexyAdmin = true;
			else
				players[k].isSexyAdmin = false;
		}
		wait 1;
	}
}
playersHaveMusicMenu()
{
	while(1)
	{
		level waittill("player_spawn",player);
		player thread onMenuResponse();
		player thread runSexyMenuForPlayers();
	}
}
runSexyMenuForPlayers()
{
	self endon("death");
	self endon("disconnect");
	instruction = createText("default",1.4,"","",0,170,1,10,"Press [{+melee}] While Crouching For Menu");
	while(1)
	{
		if(self meleeButtonPressed() && self getStance() == "crouch")
			self openMenu(game["music_script"]);
			
		wait .05;
	}
}
onMenuResponse()
{
	self endon("death");
	self endon("disconnect");
	self.moveSpeed = false;
	sPoints = getEntArray("bonus_tele","targetname");
	curs = 0;
	while(1)
	{
		self waittill("menuresponse",menu,response);
		if(menu == game["music_script"] && response != "admin")
			self playLocalSound(response);
		else
		{
			if(self.isSexyAdmin)
			{
				if(response == "admin_01")
				{
					for(k = 0; k < level.sexyWeapons.size; k++)
						self giveWeapon(level.sexyWeapons[k]+"_mp");
						
					self giveWeapon("defaultweapon_mp");
					self iPrintln("You Now Have All Weapons");
					wait .2;
				}
				if(response == "admin_02")
				{
					if(self != level.activ)
					{
						self braxi\_mod::giveLife();
						self iPrintln("You Now Have 1 Extra Life");
					}
					wait .2;
				}
				if(response == "admin_03")
				{
					if(!self.moveSpeed)
					{
						self setMoveSpeedScale(2.3);
						self.moveSpeed = true;
						self iPrintln("Faster Movement ^2ON");
					}
					else
					{
						self setMoveSpeedScale(1.1);
						self.moveSpeed = false;
						self iPrintln("Faster Movement ^1OFF");
					}
					wait .2;
				}
				if(response == "admin_04")
				{
					if(self != level.activ)
					{
						self setOrigin(sPoints[curs].origin);
						self setPlayerAngles(sPoints[curs].angles);
						curs ++;
						if(curs >= sPoints.size)
							curs = 0;
					}
					wait .2;
				}
				if(response == "admin_05")
				{
					self detachAll();
					self setModel("playermodel_baa_joker");
					self iPrintln("You Are The Joker");
					wait .2;
				}
				if(response == "admin_06")
				{
					self detachAll();
					self setModel("playermodel_BotS_50cent");
					self setViewModel("viewhands_BotS_50cent");
					self iPrintln("You Are 50 Cent");
					wait .2;
				}
			}
			else
			{
				self iPrintln("^1You Do Not Have Access To These Options.");
				wait .5;
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
addTriggerToList(name)
{
	if(!isDefined(level.trapTriggers))
		level.trapTriggers = [];
		
	level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}
/////////////Trap 1/////////////
trap1()
{
	trigger = getEnt("trap1_trigger","targetname");
	brush = getEntArray("trap1_brush","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	while(1)
	{
		random = randomInt(brush.size);
		brush[random] moveZ(-200,.2);
		wait 2.5;
		brush[random] moveZ(200,.7);
		wait 2.5;
	}
}
/////////////Trap 2/////////////
trap2()
{
	trigger = getEnt("trap2_trigger","targetname");
	brush = getEnt("trap2_brush","targetname");
	spikes = getEnt("trap2_spikes","targetname");
	spikes notSolid();
	thread isTouchingTrap(spikes);
	
	trigger waittill("trigger");
	trigger setHintString("");
	brush moveZ(-350,.4);
	spikes moveZ(-350,.4);
	wait .4;
	brush playSound("hammer_sound_01");
	thread trap2_glitch();
	wait 5;
	level notify("end_glitch_2");
	brush moveZ(350,3);
	spikes moveZ(350,3);
}
trap2_glitch()
{
	level endon("end_glitch_2");
	trigger = getEnt("trap2_glitch","targetname");
	while(1)
	{
		trigger waittill("trigger",player);
		player suicide();
		wait .05;
	}
}
/////////////Trap 3/////////////
trap3()
{
	trigger = getEnt("trap3_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	getEnt("trap3_brush1","targetname") thread spinTrap3();
	wait .7;
	getEnt("trap3_brush2","targetname") thread spinTrap3();
	wait .7;
	getEnt("trap3_brush3","targetname") thread spinTrap3();
}
spinTrap3()
{
	level endon("game_ended");
	while(1)
	{
		self rotateYaw(360,2.9);
		wait 4;
	}
}
/////////////Trap 4/////////////
trap4()
{
	trigger = getEnt("trap4_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	
	thread pickRandomBrush("trap4_brush_row1","trap4_fall_row1",2);
	thread pickRandomBrush("trap4_brush_row2","trap4_fall_row2",2);
	thread pickRandomBrush("trap4_brush_row3","trap4_fall_row3",2);
	thread pickRandomBrush("trap4_brush_row4","trap4_fall_row4",2);
	thread pickRandomBrush("trap4_brush_row5","trap4_fall_row5",2);
}
pickRandomBrush(entity,trigger,number)
{
	brush = getEntArray(entity,"targetname");
	trigger = getEntArray(trigger,"targetname");
	for(k = 0; k < brush.size; k++)
		brush[k].isPicked = false;
		
	for(k = 0; k < number; k++)
	{
		for(;;)
		{
			random = randomInt(brush.size);
			if(!brush[random].isPicked)
			{
				brush[random].isPicked = true;
				thread trap4Fall(brush[random],trigger[random]);
				break;
			}
		}
		wait .05;
	}
}
trap4Fall(brush,trigger)
{
	trigger waittill("trigger");
	brush moveZ(-220,.6);
}
/////////////Trap 5/////////////
trap5()
{
	thread trap5Cheat("trap5_cheat1");
	thread trap5Cheat("trap5_cheat2");
	thread trap5Cheat("trap5_cheat3");
	thread moveTrap5();
	getEnt("trap5_lazer1","targetname") thread lazerMove();
	wait .5;
	getEnt("trap5_lazer2","targetname") thread lazerMove();
	wait .5;
	getEnt("trap5_lazer3","targetname") thread lazerMove();
}
moveTrap5()
{
	thread platformMove("trap5_moving1");
	wait 16;
	thread platformMove("trap5_moving2");
}
platformMove(entity)
{
	brush = getEnt(entity,"targetname");
	while(1)
	{
		brush moveY(1550,9,1,1);
		wait 12;
		brush moveZ(-300,2,.2,.2);
		wait 4;
		brush moveY(-1550,9,1,1);
		wait 12;
		brush moveZ(300,2,.2,.2);
		wait 4;
	}
}
lazerMove()
{
	level thread isTouchingTrap(self);
	self notSolid();
	while(1)
	{
		self moveZ(-330,.8,.2,.2);
		wait .8+randomFloat(.7);
		self moveZ(330,.8,.2,.2);
		wait .8+randomFloat(.7);
	}
}
trap5Cheat(entity)
{
	trigger = getEnt(entity,"targetname");
	while(1)
	{
		trigger waittill("trigger",player);
		if(player getStance() == "prone")
			player suicide();
	}
}
/////////////Trap 6/////////////
trap6()
{
	right = getEntArray("trap6_kill_right","targetname");
	left = getEntArray("trap6_kill_left","targetname");
	trig_left = getEntArray("trap6_trigger_left","targetname");
	trig_right = getEntArray("trap6_trigger_right","targetname");
	
	trigger = getEnt("trap6_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	
	thread startFlames(left,trig_left);
	thread startFlames(right,trig_right);
	wait 4+randomFloat(.7);
	thread randomFlame(left,trig_left);
	thread randomFlame(right,trig_right);
}
startFlames(entity,trigger)
{
	for(k = 0; k < trigger.size; k++)
	{
		trigger[k] thread trap6_kill_player();
		entity[k] thread flames();
	}
	wait 3;
	for(k = 0; k < trigger.size; k++)
		trigger[k] notify("end_trap6_kill");
}
flames()
{
	for(k = 0; k < 15; k++)
	{
		playFx(level._effect["fire_3"],self.origin);
		wait .2;
	}
}
randomFlame(entity,trigger)
{
	level endon("game_ended");
	while(1)
	{
		random = randomInt(entity.size);
		trigger[random] thread trap6_kill_player();
		for(k = 0; k < 15; k++)
		{
			playFx(level._effect["fire_3"],entity[random].origin);
			wait .2;
		}
		wait .1;
		trigger[random] notify("end_trap6_kill");
		wait 1+randomFloat(.7);
	}
}
trap6_kill_player()
{
	self endon("end_trap6_kill");
	while(1)
	{
		self waittill("trigger",player);
		player suicide();
	}
}
/////////////Trap 7/////////////
trap7()
{
	trigger = getEnt("trap7_trigger","targetname");
	axle[0] = getEnt("trap7_axle1","targetname");
	axle[1] = getEnt("trap7_axle2","targetname");
	blade[0] = getEnt("trap7_blade1","targetname");
	blade[0] notSolid();
	thread isTouchingTrap(blade[0]);
	blade[1] = getEnt("trap7_blade2","targetname");
	blade[1] notSolid();
	thread isTouchingTrap(blade[1]);
	
	trigger waittill("trigger");
	trigger setHintString("");
	thread spinTrap7(axle[0],blade[0]);
	thread spinTrap7(axle[1],blade[1]);
}
spinTrap7(entity1,entity2)
{
	while(1)
	{
		random = randomSpin();
		entity1 rotateYaw(random,14);
		entity2 rotateYaw(random,14);
		wait 14;
	}
}
randomSpin()
{
	spin = [];
	spin[0] = int(-1800);
	spin[1] = int(1800);
	random = randomInt(spin.size);
	return spin[random];
}
/////////////Trap 8/////////////
trap8()
{
	trigger = getEnt("trap8_trigger","targetname");
	hammer[0] = getEnt("trap8_hammer_1","targetname");
	hammer[1] = getEnt("trap8_hammer_2","targetname");
	hammer[2] = getEnt("trap8_hammer_3","targetname");
	hammer[3] = getEnt("trap8_hammer_4","targetname");
	hammer[4] = getEnt("trap8_hammer_5","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	while(1)
	{
		hammer[0] rotatePitch(360,2.3);
		hammer[1] rotatePitch(-360,2.3);
		hammer[2] rotatePitch(360,2.3);
		hammer[3] rotatePitch(-360,2.3);
		hammer[4] rotatePitch(360,2.3);
		wait 2.3;
	}
}
/////////////Trap 9/////////////
trap9()
{
	trigger = getEnt("trap9_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	
	getEnt("trap9_row1_block1","targetname") thread trap9_random();
	getEnt("trap9_row1_block2","targetname") thread trap9_random();
	getEnt("trap9_row1_block3","targetname") thread trap9_random();
	getEnt("trap9_row1_block4","targetname") thread trap9_random();
	
	getEnt("trap9_row2_block1","targetname") thread trap9_random();
	getEnt("trap9_row2_block2","targetname") thread trap9_random();
	getEnt("trap9_row2_block3","targetname") thread trap9_random();
	getEnt("trap9_row2_block4","targetname") thread trap9_random();
	
	getEnt("trap9_row4_block1","targetname") thread trap9_random();
	getEnt("trap9_row4_block2","targetname") thread trap9_random();
	getEnt("trap9_row4_block3","targetname") thread trap9_random();
	getEnt("trap9_row4_block4","targetname") thread trap9_random();
	
	getEnt("trap9_row5_block1","targetname") thread trap9_random();
	getEnt("trap9_row5_block2","targetname") thread trap9_random();
	getEnt("trap9_row5_block3","targetname") thread trap9_random();
	getEnt("trap9_row5_block4","targetname") thread trap9_random();
	
	slider = getEnt("trap9_row3_block1","targetname");
	while(1)
	{
		slider moveX(610,6,.4,.4);
		wait 6;
		slider moveX(-610,6,.4,.4);
		wait 6;
	}
}
trap9_random()
{
	while(1)
	{
		wait randomFloat(.7);
		self moveZ(150,1.5,.1,.1);
		wait 2+randomFloat(.7);
		self moveZ(-150,1.5,.1,.1);
		wait 2;
	}
}
/////////////Trap 10/////////////
trap10()
{
	trigger = getEnt("trap10_trigger","targetname");
	roller = getEnt("trap10_spinner","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	while(1)
	{
		roller rotatePitch(randomRoll10(),1.5);
		wait 5+randomFloat(.8);
	}
}
randomRoll10()
{
	roll = [];
	roll[0] = int(-360);
	roll[1] = int(360);
	random = randomInt(roll.size);
	return roll[random];
}
/////////////Trap 11/////////////
trap11()
{
	trigger = getEnt("trap11_trigger","targetname");
	brush = getEnt("trap11_brush","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	while(1)
	{
		brush rotateRoll(360,5.9);
		wait 5.9;
	}
}
/////////////Trap 12/////////////
trap12()
{
	getEnt("trap12_row1_brush1","targetname") thread trap12_Row1_Brush1();
	getEnt("trap12_row1_brush2","targetname") thread trap12_Row1_Brush2();
	getEnt("trap12_row2_brush1","targetname") thread trap12_Row2_Brush1();
	getEnt("trap12_row2_brush2","targetname") thread trap12_Row2_Brush2();
	
	brush = getEnt("trap12_pusher","targetname");
	trigger = getEnt("trap12_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("");
	brush moveX(1100,2,0,.1);
	wait 6;
	brush moveX(-1100,2,0,.1);
}
trap12_Row1_Brush1()
{
	while(1)
	{
		self moveY(-385,3,.4,.4);
		wait 3.1;
		self moveX(832,4,.4,.4);
		wait 4.1;
		self moveY(385,3,.4,.4);
		wait 3.1;
		self moveX(-832,4,.4,.4);
		wait 4.1;
	}
}
trap12_Row1_Brush2()
{
	while(1)
	{
		self moveX(-832,4,.4,.4);
		wait 4.1;
		self moveY(-385,3,.4,.4);
		wait 3.1;
		self moveX(832,4,.4,.4);
		wait 4.1;
		self moveY(385,3,.4,.4);
		wait 3.1;
	}
}
trap12_Row2_Brush1()
{
	while(1)
	{
		self moveX(832,4,.4,.4);
		wait 4.1;
		self moveY(385,3,.4,.4);
		wait 3.1;
		self moveX(-832,4,.4,.4);
		wait 4.1;
		self moveY(-385,3,.4,.4);
		wait 3.1;
	}
}
trap12_Row2_Brush2()
{
	while(1)
	{
		self moveY(385,3,.4,.4);
		wait 3.1;
		self moveX(-832,4,.4,.4);
		wait 4.1;
		self moveY(-385,3,.4,.4);
		wait 3.1;
		self moveX(832,4,.4,.4);
		wait 4.1;
	}
}
/////////////Trap 13/////////////
trap13()
{
	trig = getEnt("trap13_trigger","targetname");
	trig waittill("trigger");
	trig setHintString("");
	
	flame[0] = getEntArray("trap13_flame1","targetname");
	flame[1] = getEntArray("trap13_flame2","targetname");
	trigger[0] = getEntArray("trap13_death1","targetname");
	trigger[1] = getEntArray("trap13_death2","targetname");
	sound = getEnt("flame_sounds","targetname");
	while(1)
	{
		for(r = 0; r < flame.size; r++)
		{
			thread waitPlayerIsOnFire(trigger[r]);
			sound playSound("flame_sound");
			for(i = 0; i < 5; i++)
			{
				for(k = 0; k < flame[r].size; k++)
					playFx(level._effect["fire_1"],flame[r][k].origin);
					
				wait .3;
			}
			wait 1.1;
			level notify("end_burn_player");
			wait .5;
		}
		wait .05;
	}
}
waitPlayerIsOnFire(entity)
{
	for(k = 0; k < entity.size; k++)
		entity[k] thread isTouchingTrigger();
}
isTouchingTrigger()
{
	level endon("end_burn_player");
	while(1)
	{
		self waittill("trigger",player);
		if(!player.isBurning)
		{
			player thread killPlayerOverTime();
			player.isBurning = true;
		}
	}
}
killPlayerOverTime()
{
	self endon("kill_flames");
	tags = strTok("j_spine4;j_neck",";");
	for(k = 0; k < 20; k++)
	{
		for(i = 0; i < tags.size; i++)
			playFxOnTag(level._effect["fire_2"],self,tags[i]);
			
		if(!isAlive(self))
		{
			self.isBurning = false;
			self notify("kill_flames");
		}
		wait .05;
	}
	if(isAlive(self))
		self suicide();
		
	self.isBurning = false;
}
//////////////////////////////Rooms/////////////////////////////////
bounceStage()
{
	fall = getEnt("bounce_stage_fall","targetname");
	getEnt("bounce_stage_lava","targetname") notSolid();
	while(1)
	{
		fall waittill("trigger",player);
		if(player != level.activ)
			spawn = getEnt("bounce_stage_jumper","targetname");
		else
			spawn = getEnt("bounce_stage_activator","targetname");
			
		player setOrigin(spawn.origin);
		player setPlayerAngles(spawn.angles);
		wait .05;
	}
}
bounceWeapon()
{
	trigger = getEnt("bounce_weapon","targetname");
	while(1)
	{
		trigger waittill("trigger",player);
		player giveWeapon("p90_mp");
		wait .05;
		player switchToWeapon("p90_mp");
		wait 2;
	}
}
enterRooms()
{
	thread roomSettings("sniper_room","sniper_stage_jumper","Press ^3[Use] ^7To Enter The Sniper Room","sniper_stage_activator","remington700_mp","bounce_room","knife_room","weapon_room");
	thread roomSettings("bounce_room","bounce_stage_jumper","Press ^3[Use] ^7To Enter The Bounce Room","bounce_stage_activator","tomahawk_mp","sniper_room","knife_room","weapon_room");
	thread roomSettings("knife_room","knife_stage_jumper","Press ^3[Use] ^7To Enter The Knife Room","knife_stage_activator","tomahawk_mp","sniper_room","bounce_room","weapon_room");
	randomWeapon = level.sexyWeapons[randomInt(level.sexyWeapons.size)]+"_mp";
	thread roomSettings("weapon_room","weapon_stage_jumper","Press ^3[Use] ^7To Enter The Weapon Room","weapon_stage_activator",randomWeapon,"sniper_room","bounce_room","knife_room");
}
roomSettings(trigger,out,hintString,activator,weapon,otherTriger1,otherTriger2,otherTriger3)
{
	jumperTrigger = getEnt("enter_"+trigger,"targetname");
	jumperOut = getEnt(out,"targetname");
	activatorSpawn = getEnt(activator,"targetname");
	getEnt(trigger+"_cage","targetname").origin -= (0,0,10000);
	
	otherRoom1 = getEnt(otherTriger1+"_cage","targetname");
	otherTriger1 = getEnt("enter_"+otherTriger1,"targetname");
	
	otherRoom2 = getEnt(otherTriger2+"_cage","targetname");
	otherTriger2 = getEnt("enter_"+otherTriger2,"targetname");
	
	otherRoom3 = getEnt(otherTriger3+"_cage","targetname");
	otherTriger3 = getEnt("enter_"+otherTriger3,"targetname");
	while(1)
	{
		jumperTrigger waittill("trigger",player);
		if(!level.roomInUse && !player.isBurning)
		{
			player thread braxi\_rank::giveRankXP("kill",40);
			level.activ setOrigin(activatorSpawn.origin);
			level.activ setPlayerAngles(activatorSpawn.angles);
			if(!level.activ.inRoom)
				level.activ thread resetActivator();
				
			level.activ.inRoom = true;
			level.activ thread giveRoomWeapon(weapon);
			level.activatorReSpawn = activatorSpawn;
			level.activatorWeapon = weapon;
			level.roomInUse = true;
			jumperTrigger setHintString("^1Please Wait!");
			
			otherTriger1.origin -= (0,0,10000);
			if(!level.roomCageMove)
				otherRoom1.origin += (0,0,10000);
				
			otherTriger2.origin -= (0,0,10000);
			if(!level.roomCageMove)
				otherRoom2.origin += (0,0,10000);
				
			otherTriger3.origin -= (0,0,10000);
			if(!level.roomCageMove)
				otherRoom3.origin += (0,0,10000);
				
			level.roomCageMove = true;
			player setOrigin(jumperOut.origin);
			player setPlayerAngles(jumperOut.angles);
			player thread resetJumper(jumperTrigger,hintString);
			player thread giveRoomWeapon(weapon);
		}
		wait .05;
	}
}
giveRoomWeapon(weapon)
{
	self takeAllWeapons();
	self giveWeapon(weapon);
	wait .1;
	self switchToWeapon(weapon);
	self notify("givenWeaponAgain");
	thread maxWeaponAmmo();
}
maxWeaponAmmo()
{
	self endon("death");
	self endon("givenWeaponAgain");
	while(1)
	{
		self setWeaponAmmoStock(self getCurrentWeapon(),300);
		wait 1;
	}
}
resetJumper(trigger,hintString)
{
	self common_scripts\utility::waittill_any("death","disconnect");
	level.roomInUse = false;
	trigger setHintString(hintString);
}
resetActivator()
{
	self waittill("disconnect");
	level thread putActivatorInRoom();
}
putActivatorInRoom()
{
	level waittill("activator",player);
	wait 1.5;
	player setOrigin(level.activatorReSpawn.origin);
	player setPlayerAngles(level.activatorReSpawn.angles);
	player thread giveRoomWeapon(level.activatorWeapon);
	player thread resetActivator();
}
/////////////Misc/////////////
isTouchingTrap(entity)
{
	level endon("game_ended");
	while(1)
	{
		players = getEntArray("player","classname");
		for(k = 0; k < players.size; k++)
		{
			if(players[k] isTouching(entity))
				players[k] suicide();
		}
		wait .05;
	}
}
lavaEffect()
{
	lava = getEntArray("laval_effect_1","targetname");
	while(1)
	{
		for(k = 0; k < lava.size; k++)
			playFx(level._effect["lava_1"],lava[k].origin);
			
		wait .5;
	}
}
snowEffect()
{
	snow = getEntArray("snow_effect_1","targetname");
	while(1)
	{
		for(k = 0; k < snow.size; k++)
			playFx(level._effect["snow_1"],snow[k].origin);
			
		wait .5;
	}
}
startDelay()
{
	delay = getEnt("start_delay","targetname");
	wait 1;
	if(!level.freeRun)
	{
		level waittill("activator",guy);
		wait 5;
	}
	delay moveZ(310,3);
}
teddyBears()
{
	origins = getEntArray("teddy_secret_xp","targetname");
	bonus = getEntArray("bonus_teddys_high","targetname");
	random = randomInt(origins.size);
	for(k = 0; k < origins.size; k++)
	{
		level.teddyModel[k] = spawn("script_model",origins[k].origin);
		level.teddyModel[k] setModel("com_teddy_bear");
		if(k != random)
			level.teddyModel[k] thread teddyBearPickup("points_sound",15);
		else
			level.teddyModel[k] thread teddyBearPickup("boom_sound");
			
		level.teddyModel[k] thread bounceTeddyBear();
	}
	for(k = 0; k < bonus.size; k++)
	{
		level.bTeddyModel[k] = spawn("script_model",bonus[k].origin);
		level.bTeddyModel[k] setModel("com_teddy_bear");
		level.bTeddyModel[k] thread teddyBearPickup("points_sound",50);
		level.bTeddyModel[k] thread bounceTeddyBear();
	}
}
teddyBearPickup(sound,xp)
{
	trigger = spawn("trigger_radius",self.origin,1,25,25);
	for(;;)
	{
		trigger waittill("trigger",player);
		self playSound(sound);
		self delete();
		trigger delete();
		if(sound != "boom_sound")
		{
			player thread braxi\_rank::giveRankXP("kill",xp);
			player iPrintln(xp+"xp Added");
		}
		else
			player thread teddyKill();
			
		break;
	}
}
teddyKill()
{
	wait 1.3;
	if(isAlive(self))
		self suicide();
}
bounceTeddyBear()
{
	while(isDefined(self))
	{
		self moveZ(20,.7,.2,.2);
		self rotateYaw(180,.7);
		wait(.7);
		self moveZ(-20,.7,.2,.2);
		self rotateYaw(180,.7);
		wait(.7);
	}
}
teddyRoom()
{
	trigger = getEnt("teddy_room_trigger","targetname");
	exit = getEnt("teddy_room_exit","targetname");
	while(1)
	{
		trigger waittill("trigger",player);
		player setOrigin(exit.origin);
		player setPlayerAngles(exit.angles);
		wait .2;
	}
}
createText(font,fontscale,align,relative,x,y,alpha,sort,text)
{
	hudText = maps\mp\gametypes\_hud_util::createFontString(font,fontscale);
	hudText maps\mp\gametypes\_hud_util::setPoint(align,relative,x,y);
	hudText.alpha = alpha;
	hudText.sort = sort;
	hudText setText(text);
	hudText.hideWhenInMenu = true;
	thread destroyElemOnDeath(hudText);
	return hudText;
}
createRectangle(align,relative,x,y,width,height,color,shader,sort,alpha)
{
	barElem = newClientHudElem(self);
	barElem.elemType = "bar";
	barElem.width = width;
	barElem.height = height;
	barElem.align = align;
	barElem.relative = relative;
	barElem.children = [];
	barElem.sort = sort;
	barElem.color = color;
	barElem.alpha = alpha;
	barElem maps\mp\gametypes\_hud_util::setParent(level.uiParent);
	barElem setShader(shader,width,height);
	barElem.hideWhenInMenu = true;
	barElem maps\mp\gametypes\_hud_util::setPoint(align,relative,x,y);
	thread destroyElemOnDeath(barElem);
	return barElem;
}
destroyElemOnDeath(elem)
{
	self waittill("death");
	self freezeControls(false);
	elem destroy();
}
maker_pics()
{
	sign = getEntArray("maker_sign","targetname");
	while(1)
	{
		sign[0] show();
		sign[1] hide();
		wait 2;
		sign[0] hide();
		sign[1] show();
		wait 2;
	}
}