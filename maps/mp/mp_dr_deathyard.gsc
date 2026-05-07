main()
{
	maps\mp\_load::main();
	
	game["allies"] 				= "sas";
	game["axis"] 				= "opfor";
	game["attackers"] 			= "axis";
	game["defenders"] 			= "allies";
	game["allies_soldiertype"] 	= "woodland";
	game["axis_soldiertype"] 	= "woodland";

	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	thread sr\api\_map::createSpawn((264, -256, -196), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");

	thread custom_tp();
	
	
	//thread music();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	//thread enddoors();

	//thread madeby();
}

custom_tp()
{
	trig = spawn("trigger_radius",(-45.0392, 2495.77, -247.875), 0, 60, 120);
	trig.radius = 60;
	
	ori_t = spawn("script_origin",(64,2466,-56));
	ori_t.angles = (0,360,0);

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

music()
{
	trigger = getEnt("musictrig", "targetname");
	trigger waittill("trigger");
	ambientPlay("deathyard_music");
}

madeby()
{
	wait 5;
	drawPulseText("Created by AoD'R.Stranger.");
	drawPulseText("Visit: aod-gaming.com");
}

drawPulseText(text)
{
	hud_elem = newHudElem();
	hud_elem.x	= 320;
	hud_elem.y 	= 360;
	hud_elem.alignx = "center";
	hud_elem.aligny = "bottom";
	hud_elem.color = (0.9, 0.9, 0.9);
	hud_elem.fontscale = 4.0;
	hud_elem.alpha = 1;
	hud_elem setPulseFx(65, 4000, 500);
	hud_elem setText(text);
	wait 5;
	hud_elem destroy();
}

trap1()
{
	stdEnt 			= getTriggerAndButton("trap1");
	platform 		= getEnt(stdEnt.trigger.target, "targetname");
	
	stdEnt.trigger	addTriggerToList();
	stdEnt.trigger 	waittill("trigger", player);

}

trap2()
{
	stdEnt 			= getTriggerAndButton("trap2");
	bounces			= getEnt(stdEnt.trigger.target, "targetname");
	
	stdEnt.trigger	addTriggerToList();
	stdEnt.trigger 	waittill("trigger", player);

}

trap3()
{
	stdEnt 			= getTriggerAndButton("trap3");
	block			= getEnt(stdEnt.trigger.target, "targetname");
	triggerHurt		= getEnt("trap3_hurt", "targetname");
	
	triggerHurt 	linkWith(block);
	
	stdEnt.trigger	addTriggerToList();
	stdEnt.trigger	waittill("trigger", player);

}

trap4()
{
	stdEnt			= getTriggerAndButton("trap4");
	block			= getEnt(stdEnt.trigger.target, "targetname");
	triggerHurt		= getEnt("trap4_hurt", "targetname");
	
	block delete();
	triggerHurt delete();
}

trap5()
{
	stdEnt			= getTriggerAndButton("trap5");
	block			= getEnt(stdEnt.trigger.target, "targetname");
	triggerHurt		= getEnt("trap5_hurt", "targetname");
	
	block delete();
	triggerHurt delete();
}

trap6()
{
	stdEnt			= getTriggerAndButton("trap6");
	platform		= getEnt(stdEnt.trigger.target, "targetname");
	
	stdEnt.trigger	addTriggerToList();
	stdEnt.trigger	waittill("trigger", player);
	stdEnt			onActi(player);
	
	while(true)
	{
		platform	rectangularMove(152, -152, 1.5, 1.5, 0.10, 0.10, 0.10);
	}
}

trap7()
{
	stdEnt			= getTriggerAndButton("trap7");
	pillars			= getEntArray(stdEnt.trigger.target, "targetname");
	
	stdEnt.trigger	addTriggerToList();
	stdEnt.trigger 	waittill("trigger", player);

}

trap8()
{
	stdEnt			= getTriggerAndButton("trap8");
	bounce 			= getEnt(stdEnt.trigger.target, "targetname");
	
	stdEnt.trigger	addTriggerToList();
	stdEnt.trigger 	waittill("trigger", player);

}

enddoors()
{
	stdEnt			= getTriggerAndButton("enddoors");
	wall			= getEnt(stdEnt.trigger.target, "targetname");
	
	stdEnt.trigger	waittill("trigger", player);
	

}

linkWith(ent)
{
	self enableLinkTo();
	self linkTo(ent);
}

getTriggerAndButton(trap)
{
	stdEnt = spawnstruct();
	str = trap + "_trig";
	stdEnt.trigger = getEnt(str, "targetname");
	str = trap + "_button";
	stdEnt.button = getEnt(str, "targetname");
	return stdEnt;
}

onActi(player)
{
	player 				endon("disconnected");
	player				endon("player_killed");
	player 				iPrintLn("Trap activated!");
	self.trigger		setHintString("Activated!");
	self.button	thread	moveFromSideToSide("x", 12, 1, 0.5, 0, 0);
}

addTriggerToList()
{
	if(!isDefined(level.trapTriggers) ) 
		level.trapTriggers = [];
	
	level.trapTriggers[level.trapTriggers.size] = self;
}

moveFromSideToSide(axis, value, time, delay, accelerationTime, decelerationTime)
{
	switch(axis)
	{
	case "x":
		self moveX(value, time, accelerationTime, decelerationTime);
		wait (time + delay);
		self moveX((~value+1), time, accelerationTime, decelerationTime);
		break;
		
	case "y":
		self moveY(value, time, accelerationTime, decelerationTime);
		wait (time + delay);
		self moveY((~value+1), time, accelerationTime, decelerationTime);
		break;
		
	case "z":
		self moveZ(value, time, accelerationTime, decelerationTime);
		wait (time + delay);
		self moveZ((~value+1), time, accelerationTime, decelerationTime);
		break;
	}
	wait (time + delay);
}

rectangularMove(a, b, timeA, timeB, delay, acceleration, deceleration)
{
	self moveX(a, timeA, acceleration, deceleration);
	wait (timeA + delay);
	self moveY(b, timeB, acceleration, deceleration);
	wait (timeB + delay);
	self moveX((~a+1), timeA, acceleration, deceleration);
	wait (timeA + delay);
	self moveY((~b+1), timeB, acceleration, deceleration);
	wait (timeB + delay);
}


symetricalMove(value, time, delay, accelerationTime, decelerationTime)
{
	self moveZ(value/2, time/2, accelerationTime/2, decelerationTime/2);
	wait (time+delay);
	while(true)
	{
		self moveZ((~value+1), time, accelerationTime, decelerationTime);
		wait (time+delay);
		self moveZ(value, time, accelerationTime, decelerationTime);
		wait (time+delay);
	}
}