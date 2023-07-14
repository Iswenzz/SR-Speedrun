main()
{
	thread sr\api\_speedrun::createEndMap((3988, 3257, 156), 100, 150);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawnOrigin((-832, -232, 20), 90);

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attacker"] = "allies";
	game["defender"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread startDelay();
	thread telePortTo("tele1_activator","out1_activator");
	thread telePortTo("back1_activator","return1_activator");
	thread telePortTo("tele2_activator","out2_activator");
	thread telePortTo("back2_activator","return2_activator");
	thread toStage2();
	thread toStage3();

	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread trap10();
	//thread trap11();
	//thread trap12();
	//thread trap13();

}

startDelay()
{
	delay = getEnt("start_delay","targetname");

	wait 0.05;

	delay delete();
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
