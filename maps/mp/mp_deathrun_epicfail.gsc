main()
{
	thread sr\api\_speedrun::createEndMap((3988, 3257, 156), 100, 150);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	auto_spawn = getEntArray("mp_jumper_spawn", "classname");
	if(auto_spawn.size > 0)
		thread sr\api\_map::createSpawn(auto_spawn[int(auto_spawn.size / 2)].origin, auto_spawn[int(auto_spawn.size / 2)].angles[1]);
	maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attacker"] = "allies";
	game["defender"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	windfx = loadFx("props/car_glass_large");
	windtrigs = getEntArray("windtrig","targetname");
	for(k = 0; k < windtrigs.size; k++)
		windtrigs[k] thread doWindow(k,windfx);
		
	//Welcom Text
	thread welcomStage("welcome_stage2","Stage Two!","Good Luck, Its Alot Harder");
	thread welcomStage("welcome_stage3","Stage Three!","Almost There, Dont Die Now");
	
	//Other Shit
	thread jukeBox();
	thread startDelay();
	thread telePortTo("tele1_activator","out1_activator");
	thread telePortTo("back1_activator","return1_activator");
	thread telePortTo("tele2_activator","out2_activator");
	thread telePortTo("back2_activator","return2_activator");
	thread toStage2();
	thread toStage3();
	thread stageArrows();
	// /* [AUTO DELETE] thread bounceStage(); */
	// thread /* [AUTO DELETE] sniperSecret(); */
	// thread enterRooms();

	//Trap's
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
	thread trap13();
	addTriggerToList("trap1_trigger");
	addTriggerToList("trap2_trigger");
	addTriggerToList("trap3_trigger");
	addTriggerToList("trap4_trigger");
	addTriggerToList("trap5_trigger");
	addTriggerToList("trap6_trigger");
	addTriggerToList("trap7_trigger");
	addTriggerToList("trap8_trigger");
	addTriggerToList("trap9_trigger");
	addTriggerToList("trap10_trigger");
	addTriggerToList("trap11_trigger");
	addTriggerToList("trap12_trigger");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
jukeBox()
{
	level endon("song_picked");
	trigger = getEnt("jukebox","targetname");
	getEnt("juke_room","targetname") notSolid();
	while(1)
	{
		trigger waittill("trigger",player);
		if(!level.juke["open"])
		{
			level.juke["open"] = true;
			player thread createJuke();
			player thread jukeDeath();
		}
		wait .05;
	}
}

createJuke()
{
	level.juke["background"] = createRectangle("","",0,0,1000,720,(0,0,0),"white",10,1);
	level.juke["center_line"] = createRectangle("","",0,0,3,720,(1,1,1),"white",20,.6);
	level.juke["top_option"][0] = createText("default",2.3,"RIGHT","",-10,-135,1,100,"Artists/Bands");
	level.juke["top_option"][1] = createText("default",2.3,"LEFT","",10,-135,1,100,"Song Names");
	for(k = 0; k < level.juke["top_option"].size; k++)
	{
		level.juke["top_option"][k].glowAlpha = 1;
		level.juke["top_option"][k].glowColor = (0,0,1);
	}
	level.juke["curs"] = 0;
	//level.options = strTok("Linkin Park ^2- ^7Bleed It Out;Linkin Park ^2- ^7In The End;Linkin Park ^2- ^7New Divide;Hollywood Undead ^2- ^7Street Dreams;Hollywood Undead ^2- ^7Hear Me Now;Klaypex ^2- ^7Lights;Chase And Status ^2- ^7Time;Far East Movement ^2- ^7Live My Life",";");level.options = strTok("Linkin Park ^2- ^7Bleed It Out;Linkin Park ^2- ^7In The End;Linkin Park ^2- ^7New Divide;Hollywood Undead ^2- ^7Street Dreams;Hollywood Undead ^2- ^7Hear Me Now;Klaypex ^2- ^7Lights;Chase And Status ^2- ^7Time;Far East Movement ^2- ^7Live My Life",";");
	level.options = strTok("Runnin;In The End;New Divide;Street Dreams;Hear Me Now;Lights;Live My Life;I Made It;Still Alive",";");
	level.artists = strTok("Jake Miller;Linkin Park;Linkin Park;Hollywood Undead;Hollywood Undead;Klaypex;Far East Movement;Kevin Rudolf;Lisa Miskovsky",";");
	level.actions = strTok("epicfail;epicfail_01;epicfail_02;epicfail_03;epicfail_04;epicfail_05;epicfail_07;epicfail_08;epicfail_09",";");
	for(k = 0; k < level.options.size; k++)
	{
		level.juke["options"][k] = createText("default",1.6,"LEFT","",10,((k*22)-100),1,100,level.options[k]);
		level.juke["options"][k].glowColor = (1,0,0);
		
		level.juke["artists"][k] = createText("default",1.6,"RIGHT","",-10,((k*22)-100),1,100,level.artists[k]);
		level.juke["artists"][k].glowAlpha = 1;
		level.juke["artists"][k].glowColor = (0,1,0);
	}
	level.juke["options"][0].glowAlpha = 1;
	wait .2;
	thread runJuke();
}

runJuke()
{
	self endon("death");
	while(level.juke["open"])
	{
		self freezeControls(true);
		if(self attackButtonPressed() || self adsButtonPressed())
		{
			level.juke["curs"] -= self adsButtonPressed();
			level.juke["curs"] += self attackButtonPressed();
			if(level.juke["curs"] >= level.options.size)
				level.juke["curs"] = 0;
				
			if(level.juke["curs"] < 0)
				level.juke["curs"] = level.options.size-1;
				
			for(k = 0; k < level.juke["options"].size; k++)
				if(k != level.juke["curs"])
					level.juke["options"][k].glowAlpha = 0;
				else
					level.juke["options"][k].glowAlpha = 1;
					
			wait .15;
		}
		if(self useButtonPressed())
		{
			/* [AUTO DELETE] iPrintlnBold(self.name+" Has Picked ^2"+level.artists[level.juke["curs"]]+" ^7- ^2"+level.options[level.juke["curs"]]); */
			/* [AUTO DELETE] ambientPlay(level.actions[level.juke["curs"]]); */
			level notify("song_picked");
			getEnt("jukebox","targetname") setHintString("");
			break;
		}
		if(self meleeButtonPressed())
			break;
			
		wait .05;
	}
	self notify("left_menu");
	level.juke["open"] = false;
	level.juke["background"] destroy();
	level.juke["center_line"] destroy();
	for(k = 0; k < level.juke["options"].size; k++)
	{
		level.juke["options"][k] destroy();
		level.juke["artists"][k] destroy();
	}
	for(k = 0; k < level.juke["top_option"].size; k++)
		level.juke["top_option"][k] destroy();
		
	self freezeControls(false);
}

jukeDeath()
{
	self endon("left_menu");
	self waittill("death");
	level.juke["open"] = false;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
testing()
{
	test = getEnt("giveXp_test","targetname");
	while(1)
	{
		test waittill("trigger",player);
		/* [AUTO DELETE] player takeAllWeapons(); */
		//player /* [AUTO DELETE] thread braxi\_rank::giveRankXP("trap_activation",100); */
		wait .05;
	}
}

doWindow(windnumber,windfx)
{
	window = getEnt(self.target,"targetname");
	totaldamage = 0;
	targetdamage = 130;
	windowbroken = 0;
	broken = getEntArray("brokenwindow"+(windnumber+1),"targetname");
	for(k = 0; k < broken.size; k++)
	{
		broken[k] notSolid();
		broken[k] hide();
	}
	window show();
	while(!windowbroken)
	{
		self waittill("damage",amount);
		totaldamage += amount;
		if(totaldamage > targetdamage)
			windowbroken = 1;
	}
	self playsound("glass_break");
	playFx(windfx,self.origin);
	for(k = 0; k < broken.size; k++)
		broken[k] show();
		
	window delete();
	self delete();
}

addTriggerToList(name)
{
	if(!isDefined(level.trapTriggers))
		level.trapTriggers = [];
		
	level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}

////////////////////////////Secrets/////////////////////////////
sniperSecret()
{
	trigger = getEntArray("sniper_secret","targetname");
	trigger[randomInt(trigger.size-1)] waittill("trigger",player);
	/* [AUTO DELETE] player playLocalSound("mp_enemy_obj_captured"); */
	/* [AUTO DELETE] player iPrintln("^2You Have Found The Gold Deagle!!"); */
	/* [AUTO DELETE] player giveWeapon("deserteaglegold_mp"); */
	wait .1;
	/* [AUTO DELETE] player switchToWeapon("deserteaglegold_mp"); */
}

/////////////////////////////Misc//////////////////////////////
startDelay()
{
	delay = getEnt("start_delay","targetname");
	wait 1;
	if(!level.freeRun)
	{
		level waittill("activator",guy);
		wait 5;
	}
	delay moveZ(250,3);
}

telePortTo(trigger,out)
{
	trig = getEnt(trigger,"targetname");
	out = getEnt(out,"targetname");
	while(1)
	{
		trig waittill("trigger",player);
		player setOrigin(out.origin);
		player setPlayerAngles(out.angles);
		/* [AUTO DELETE] wait .05; */
	}
}

toStage2()
{
	thread randomStagePoint("tele1_jumper","out1_jumper",1);
}

toStage3()
{
	thread randomStagePoint("tele2_jumper","out2_jumper",2);
}

randomStagePoint(in,out,num)
{
	trig = getEnt(in,"targetname");
	out = getEntArray(out,"targetname");
	level.stagePoint[num] = 0;
	while(1)
	{
		trig waittill("trigger",player);
			
		player setOrigin(out[0].origin);
		player setPlayerAngles(out[0].angles);
		/* [AUTO DELETE] wait .05; */
	}
}

stageArrows()
{
	arrow[0] = getEnt("stage3_arrow","targetname");
	arrow[1] = getEnt("stage2_arrow","targetname");
	while(1)
	{
		for(k = 0; k < arrow.size; k++)
			arrow[k] moveZ(60,1.5,.2,.2);
			
		wait 1.5;
		for(k = 0; k < arrow.size; k++)
			arrow[k] moveZ(-60,1.5,.2,.2);
			
		wait 1.5;
	}
}

/////////////////////////////welcome////////////////////////////////
welcomStage(stage,text1,text2)
{
	trigger = getEnt(stage,"targetname");
	while(1)
	{
		trigger waittill("trigger",player);
		if(!player.seenText[stage])
		{
			thread welcomeText(player,text1,text2,(1,0,0));
			player.seenText[stage] = true;
		}
	}
}

welcomeText(player,textOne,textTwo,glowColor)
{
	player endon("death");
	player endon("disconnect");
	line[0] = player createText("default",2.5,"","",-1000,-160,1,10,textOne);
	line[1] = player createText("default",2,"","",1000,-120,1,10,textTwo);
	for(k = 0; k < line.size; k++)
	{
		line[k].glowAlpha = 1;
		line[k].glowColor = glowColor;
	}
	line[0] welcomeMove(1.5,-90);
	line[1] welcomeMove(1.5,90);
	wait 1.5;
	line[0] welcomeMove(4,90);
	line[1] welcomeMove(4,-90);
	wait 4;
	line[0] welcomeMove(3,1000);
	line[1] welcomeMove(3,-1000);
	wait 3;
	for(k = 0; k < 2; k++)
		line[k] destroy();
}

welcomeMove(time,x)
{
	self maps\mp\gametypes\_hud_util::setPoint("","",x,self.y,time);
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

//////////////////////////////Rooms/////////////////////////////////
bounceStage()
{
	activatorSpawn = getEnt("bounce_stage_activator","targetname");
	jumperSpawn = getEnt("bounce_stage_jumper","targetname");
	fall = getEnt("jumpStage_fall","targetname");
	while(1)
	{
		fall waittill("trigger",player);
		if(self != level.activ)
			spawn = jumperSpawn;
		else
			spawn = activatorSpawn;
			
		player setOrigin(spawn.origin);
		player setPlayerAngles(spawn.angles);
		wait .05;
	}
}

enterRooms()
{
	thread roomSettings("enter_sniper_room","sniper_stage_jumper","Press ^3[Use] ^7To Enter The Sniper Room","sniper_stage_activator","remington700_mp","enter_bounce_room","enter_knife_room");
	thread roomSettings("enter_bounce_room","bounce_stage_jumper","Press ^3[Use] ^7To Enter The Bounce Room","bounce_stage_activator","tomahawk_mp","enter_sniper_room","enter_knife_room");
	thread roomSettings("enter_knife_room","knife_stage_jumper","Press ^3[Use] ^7To Enter The Knife Room","knife_stage_activator","tomahawk_mp","enter_sniper_room","enter_bounce_room");
}

roomSettings(trigger,out,hintString,activator,weapon,otherTriger1,otherTriger2)
{
	jumperTrigger = getEnt(trigger,"targetname");
	jumperOut = getEnt(out,"targetname");
	activatorSpawn = getEnt(activator,"targetname");
	if(isDefined(otherTriger1))
		otherTriger1 = getEnt(otherTriger1,"targetname");
		
	if(isDefined(otherTriger2))
		otherTriger2 = getEnt(otherTriger2,"targetname");
		
	while(1)
	{
		jumperTrigger waittill("trigger",player);

		if(!level.roomInUse)
		{
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
			if(isDefined(otherTriger1))
				otherTriger1.origin -= (0,0,10000);
				
			if(isDefined(otherTriger2))
				otherTriger2.origin -= (0,0,10000);
				
			player setOrigin(jumperOut.origin);
			player setPlayerAngles(jumperOut.angles);
			player thread resetJumper(jumperTrigger,hintString);
			player thread giveRoomWeapon(weapon);
		}
		/* [AUTO DELETE] wait .05; */
	}
}

giveRoomWeapon(weapon)
{
	self takeAllWeapons();
	/* [AUTO DELETE] self giveWeapon(weapon); */
	wait .1;
	/* [AUTO DELETE] self switchToWeapon(weapon); */
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

weaponMove(weapon)
{
	while(1)
	{
		weapon moveZ(15,1,.2,.2);
		wait 1;
		weapon moveZ(-15,1,.2,.2);
		wait 1;
	}
}

//////////////////////////////////////////Trap1/////////////////////////////////////
trap1()
{
	level endon("trigger");
	trig = getEnt("trap1_trigger","targetname");
	brush = getEnt("trap1_brush","targetname");
	
	trig waittill("trigger");
	trig setHintString("^1Trap Activated!");
	oldBrush = brush.origin;
	brush moveZ(-130,.6);
	wait 5;
	brush moveZ(130,.6);
	wait .7;
	brush.origin = oldBrush;
}

//////////////////////////////////////////Trap2/////////////////////////////////////
trap2()
{
	level endon("trigger");
	trig = getEnt("trap2_trigger","targetname");
	brush = getEnt("trap2_brush","targetname");
	trig waittill("trigger");
	trig setHintString("^1Trap Activated!");
	for(k = 0; k < 2; k++)
	{
		oldBrush = brush.origin;
		brush moveX(330,2);
		wait 3;
		brush moveX(-330,2);
		wait 2;
		brush.origin = oldBrush;
		wait randomIntRange(1,3);
	}
}

//////////////////////////////////////////Trap3/////////////////////////////////////
trap3()
{
	level endon("trigger");
	trigger = getEnt("trap3_trigger","targetname");
	trigger waittill("trigger",player);
	trigger setHintString("^1Trap Activated!");
	thread trap3Pole1();
	thread trap3Pole2();
	thread trap3Pole3();
}

trap3Pole1()
{
	push1 = getEnt("trap3_brush1","targetname");
	while(1)
	{
		push1 moveY(-290,.7);
		wait .75+randomInt(2);
		push1 moveY(290,.7);
		wait .75+randomInt(2);
	}
}

trap3Pole2()
{
	push2 = getEnt("trap3_brush2","targetname");
	while(1)
	{
		push2 moveY(290,.7);
		wait .75+randomFloat(2);
		push2 moveY(-290,.7);
		wait .75+randomInt(2);
	}
}

trap3Pole3()
{
	push3 = getEnt("trap3_brush3","targetname");
	while(1)
	{
		push3 moveY(-290,.7);
		wait .75+randomFloat(2);
		push3 moveY(290,.7);
		wait .75+randomInt(2);
	}
}

//////////////////////////////////////////Trap4/////////////////////////////////////
trap4()
{
	level endon("trigger");
	trig = getEnt("trap4_trigger","targetname");
	trig waittill("trigger");
	trig setHintString("^1Trap Activated!");
	
	thread randomPole("trap4_row1","trap4_row1_trigger");
	thread randomPole("trap4_row2","trap4_row2_trigger");
}

randomPole(entity,trigger)
{
	brush = getEntArray(entity,"targetname");
	trig = getEntArray(trigger,"targetname");
	randomNum = randomInt(brush.size);
	thread trap4Fall(brush[randomNum],trig[randomNum]);
}

trap4Fall(brush,trigger)
{
	level endon("trigger");
	trigger waittill("trigger");
	brush moveZ(-160,.6);
}

//////////////////////////////////////////Trap5/////////////////////////////////////
trap5()
{
	level endon("trigger");
	trig = getEnt("trap5_trigger","targetname");
	brush = getEnt("trap5_brush","targetname");
	earthquake = getEnt("earth_boom1","targetname");
	spikes = getEnt("trap5_spikes","targetname");
	spikes notSolid();
	thread lazerDeath(spikes);
	
	trig waittill("trigger");
	trig setHintString("^1Trap Activated!");
	oldBrush = brush.origin;
	oldSpikes = spikes.origin;
	brush moveZ(-220,1.3);
	spikes moveZ(-220,1.3);
	wait 1.3;
	earthquake(1.1,1,earthquake.origin,250);
	wait 3;
	brush moveZ(220,1.4);
	spikes moveZ(220,1.4);
	wait 1.4;
	spikes.origin = oldSpikes;
	brush.origin = oldBrush;
}

trap5Death()
{
	level endon("trigger");
	brush = getEnt("trap5_spikes","targetname");
	while(1)
	{
		brush waittill("trigger",player);
		player suicide();
	}
}

//////////////////////////////////////////Trap6/////////////////////////////////////
trap6()
{
	level endon("trigger");
	drop1 = getEnt("trap6_drop1","targetname");
	drop2 = getEnt("trap6_drop2","targetname");
	trig = getEnt("trap6_trigger","targetname");
	
	flap1 = getEnt("trap6_brush1","targetname");
	flap2 = getEnt("trap6_brush2","targetname");
	flap1 linkTo(drop1);
	flap2 linkTo(drop2);
	
	trig waittill("trigger");
	trig setHintString("^1Trap Activated!");
	
	drop1 rotatePitch(-90,.9);
	drop2 rotatePitch(90,.9);
	wait 5;
	drop1 rotatePitch(90,.3);
	drop2 rotatePitch(-90,.3);
}

//////////////////////////////////////////Trap7/////////////////////////////////////
trap7()
{
	level endon("trigger");
	spin1 = getEnt("trap7_brush1","targetname");
	spin2 = getEnt("trap7_brush2","targetname");
	getEnt("trap7_pole1","targetname") linkTo(spin1);
	getEnt("trap7_pole2","targetname") linkTo(spin2);
	
	trigger = getEnt("trap7_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("^1Trap Activated!");
	while(1)
	{
		spin1 rotateYaw(-180,1.1,.1,.1);
		wait .18;
		spin2 rotateYaw(180,1.1,.1,.1);
		wait 1.5;
	}
}

//////////////////////////////////////////Trap8/////////////////////////////////////
trap8()
{
	level endon("trigger");
	trigger = getEnt("trap8_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("^1Trap Activated!");
	brush = getEnt("trap8_brush","targetname");
	while(1)
	{
		brush rotatePitch(180,4);
		wait 4;
	}
}

//////////////////////////////////////////Trap9/////////////////////////////////////
trap9()
{
	level endon("trigger");
	hammer1 = getEnt("trap9_hammer1","targetname");
	hammer2 = getEnt("trap9_hammer2","targetname");
	hammer3 = getEnt("trap9_hammer3","targetname");
	hammer4 = getEnt("trap9_hammer4","targetname");
	hammer5 = getEnt("trap9_hammer5","targetname");
	
	trigger = getEnt("trap9_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("^1Trap Activated!");
	while(1)
	{
		hammer1 rotateRoll(-180,1);
		hammer2 rotateRoll(180,1);
		hammer3 rotateRoll(-180,1);
		hammer4 rotateRoll(180,1);
		hammer5 rotateRoll(-180,1);
		wait 1;
	}
}

//////////////////////////////////////////Trap10/////////////////////////////////////
trap10()
{
	level endon("trigger");
	trigger = getEnt("trap10_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("^1Trap Activated!");
	thread trap10_high();
	thread trap10_low();
	thread trap10Slide();
	thread trap10Spin1();
	thread trap10Spin2();
}

trap10_high()
{
	brush = getEnt("trap10_high","targetname");
	while(1)
	{
		brush moveZ(-95,1.2,.15);
		wait 1.2;
		brush moveZ(95,1.2,.15);
		wait 1.2;
	}
}

trap10_low()
{
	brush = getEnt("trap10_low","targetname");
	while(1)
	{
		brush moveZ(95,1.2,.15);
		wait 1.2;
		brush moveZ(-95,1.2,.15);
		wait 1.2;
	}
}

trap10Slide()
{
	brush = getEnt("trap10_slide","targetname");
	while(1)
	{
		brush moveY(-360,2.5,.2,.2);
		wait 2.5;
		brush moveY(360,2.5,.2,.2);
		wait 2.5;
	}
}

trap10Spin1()
{
	brush[0] = getEnt("trap10_spin1","targetname");
	brush[1] = getEnt("trap10_spin4","targetname");
	while(1)
	{
		for(k = 0; k < brush.size; k++)
			brush[k] rotateYaw(-360,1.5);
			
		wait 1.8+randomFloat(1.5);
		for(k = 0; k < brush.size; k++)
			brush[k] rotateYaw(360,1.5);
			
		wait 1.8+randomFloat(1.5);
	}
}

trap10Spin2()
{
	brush[0] = getEnt("trap10_spin2","targetname");
	brush[1] = getEnt("trap10_spin3","targetname");
	while(1)
	{
		for(k = 0; k < brush.size; k++)
			brush[k] rotateYaw(360,1.5);
			
		wait 1.8+randomFloat(1.5);
		for(k = 0; k < brush.size; k++)
			brush[k] rotateYaw(-360,1.5);
			
		wait 1.8+randomFloat(1.5);
	}
}

//////////////////////////////////////////Trap11/////////////////////////////////////
trap11()
{
	level endon("trigger");
	trigger = getEnt("trap11_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("^1Trap Activated!");
	thread pickRandomBrush("trap11_row1_brush","trap11_row1_trigger",2);
	thread pickRandomBrush("trap11_row2_brush","trap11_row2_trigger",2);
	thread pickRandomBrush("trap11_row3_brush","trap11_row3_trigger",2);
	thread pickRandomBrush("trap11_row4_brush","trap11_row4_trigger",2);
	thread pickRandomBrush("trap11_row5_brush","trap11_row5_trigger",2);
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
				thread trap11Fall(brush[random],trigger[random]);
				break;
			}
		}
		wait .05;
	}
}

trap11Fall(brush,trigger)
{
	level endon("trigger");
	trigger waittill("trigger");
	brush moveZ(-160,.6);
}

//////////////////////////////////////////Trap12/////////////////////////////////////
trap12()
{
	level endon("trigger");
	thread moveTrap12();
	trigger = getEnt("trap12_trigger","targetname");
	trigger waittill("trigger");
	trigger setHintString("^1Trap Activated!");
	push = getEnt("trap12_pusher","targetname");
	for(k = 0; k < 2; k++)
	{
		push moveY(490,1.5);
		wait 3.5;
		push moveY(-490,1.5);
		wait 3.5+randomInt(3);
	}
}

moveTrap12()
{
	brush = getEnt("trap12_slider","targetname");
	while(1)
	{
		brush moveX(700,5,.55,.55);
		wait 5;
		brush moveX(-700,5,.55,.55);
		wait 5;
	}
}

//////////////////////////////////////////Trap13/////////////////////////////////////
trap13()
{
	thread lazerTrap1();
	thread lazerTrap2();
	thread spinningBlades();
	thread trap13Pushers();
	getEnt("trap13_platform1","targetname") thread moveTrap13();
	wait 9.3;
	getEnt("trap13_platform2","targetname") thread moveTrap13();
	wait 9.3;
	getEnt("trap13_platform3","targetname") thread moveTrap13();
	wait 9.3;
	getEnt("trap13_platform4","targetname") thread moveTrap13();
	wait 9.3;
	getEnt("trap13_platform5","targetname") thread moveTrap13();
	wait 9.3;
	getEnt("trap13_platform6","targetname") thread moveTrap13();
}

moveTrap13()
{
	while(1)
	{
		self moveX(3080,20,1,1);
		wait 22;
		self moveZ(-150,4,.5,.5);
		wait 6;
		self moveX(-3080,20,1,1);
		wait 22;
		self moveZ(150,4,.5,.5);
		wait 6;
	}
}

spinningBlades()
{
	brush[0] = getEnt("trap13_spinning_axle","targetname");
	brush[1] = getEnt("trap13_spinning_blades","targetname");
	while(1)
	{
		for(k = 0; k < brush.size; k++)
			brush[k] rotateYaw(-360,2.5);
			
		wait 1;
	}
}

lazerTrap1()
{
	lazer1[0] = getEnt("lazer_1_lazer","targetname");
	lazer1[0] notSolid();
	lazer1[1] = getEnt("lazer_1_right","targetname");
	lazer1[2] = getEnt("lazer_1_left","targetname");
	thread lazerDeath(lazer1[0]);
	while(1)
	{
		for(k = 0; k < lazer1.size; k++)
			lazer1[k] moveZ(180,.7,.2,.2);
			
		wait .7+randomFloat(.5);
		for(k = 0; k < lazer1.size; k++)
			lazer1[k] moveZ(-180,.7,.2,.2);
			
		wait .7+randomFloat(.5);
	}
}

lazerTrap2()
{
	lazer1[0] = getEnt("lazer_2_lazer1","targetname");
	lazer1[0] notSolid();
	lazer1[1] = getEnt("lazer_2_right","targetname");
	lazer1[2] = getEnt("lazer_2_left","targetname");
	
	thread lazerDeath(lazer1[0]);
	thread lazerTrap2Move();
	while(1)
	{
		for(k = 0; k < lazer1.size; k++)
			lazer1[k] moveZ(180,.8,.2,.2);
			
		wait .8+randomFloat(.5);
		for(k = 0; k < lazer1.size; k++)
			lazer1[k] moveZ(-180,.8,.2,.2);
			
		wait .8+randomFloat(.5);
	}
}

lazerTrap2Move()
{
	lazer2[0] = getEnt("lazer_2_lazer2","targetname");
	lazer2[0] notSolid();
	lazer2[1] = getEnt("lazer_2_top","targetname");
	thread lazerDeath(lazer2[0]);
	while(1)
	{
		for(k = 0; k < lazer2.size; k++)
			lazer2[k] moveY(-455,.7,.2,.2);
			
		wait .7+randomFloat(1.5);
		for(k = 0; k < lazer2.size; k++)
			lazer2[k] moveY(455,.7,.2,.2);
			
		wait .7+randomFloat(1.5);
	}
}

lazerDeath(entity)
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

trap13Pushers()
{
	brush1 = getEnt("trap13_pusher1","targetname");
	brush2 = getEnt("trap13_pusher2","targetname");
	brush1 notSolid();
	brush2 notSolid();
	
	brush1_origin = brush1.origin;
	brush2_origin = brush2.origin;
	thread lazerDeath(brush1);
	thread lazerDeath(brush2);
	while(1)
	{
		brush1 moveY(-560,1.4);
		wait 1.4;
		brush1.origin = brush1_origin;
		wait .5;
		brush2 moveY(-560,1.4);
		wait 1.4;
		brush2.origin = brush2_origin;
		wait .5;
	}
}
