main()
{
	thread door();
	thread rp1();
	thread rp2();
	thread rp3();
	thread rpd1();
	thread rpd2();
	thread rpd3();
	thread rope();
}





door()
{
	d=getent("door","targetname");
	
	level waittill("round_started");
	
	d moveZ(-175, 0.5, 0.2, 0);
	wait 0.5;
	d delete();
}


rp1()
{
	trig=getent("rp1_trig", "targetname");
	ori=spawn("script_origin",(64,-9614,-964));
	ori.angles = (0,270,360);

	for(;;)
	{
		trig waittill("trigger",player);
		player freezecontrols(true);
		player setOrigin(ori.origin);
		player setplayerangles(ori.angles);
		player freezecontrols(false);
	}
}

rp2()
{
eau=getent("rp2_eau", "targetname");
trig=getent("rp2_trig", "targetname");
glitch=getent("rp2_glitch", "targetname");

eau delete();
glitch delete();
}


rpd1()
{
leftd=getent("rpd1_doorleft", "targetname");
leftc=getent("rpd1_doorleftc", "targetname");
rightd=getent("rpd1_doorright", "targetname");
rightc=getent("rpd1_doorrightc", "targetname");
trig=getent("rpd1_trig", "targetname");

leftd delete();
leftc delete();
rightd delete();
rightc delete();
}


rpd2()
{
leftd=getent("rpd2_doorleft", "targetname");
leftc=getent("rpd2_doorleftc", "targetname");
rightd=getent("rpd2_doorright", "targetname");
rightc=getent("rpd2_doorrightc", "targetname");
trig=getent("rpd2_trig", "targetname");

leftd delete();
leftc delete();
rightd delete();
rightc delete();
}

rp3()
{
	trig=getent("rp3_trig", "targetname");
	plat1=getent("rp3_1", "targetname");
	plat2=getent("rp3_2", "targetname");
	plat3=getent("rp3_3", "targetname");
	plat4=getent("rp3_4", "targetname");
	
	trig delete();

	plat2 moveTo(plat1.origin,.05);
	plat3 moveTo(plat1.origin,.05);
	plat4 moveTo(plat1.origin,.05);

	wait 1;

	plat2 moveX(-550,.05);
	plat3 moveX(-1100,.05);
	plat4 moveX(-1650,.05);
}

rope()
{
	trig = getent ("rope_trig","targetname"); 
	start = getent ("rope_start","targetname"); 
	stop = getent ("rope_end","targetname"); 

	while(1)
	{
		trig waittill("trigger",player);
		
		player thread rope_do();
	}
}

rope_do()
{
	if(self.roped)
		return;

	self.roped = true;

	start = getent ("rope_start","targetname"); 
	stop = getent ("rope_end","targetname"); 

	link = spawn("script_model",self.origin);
	self linkTo(link);

	link moveTo(start.origin,1);
	wait 1;
	link moveTo(stop.origin,2);
	wait 2;

	self unlink();
}

rpd3()
{
	door=getent("rpd3_d", "targetname");
	clip=getent("rpd3_c", "targetname");
	trig=getent("rpd3_t", "targetname");

	door delete();
	clip delete();
	trig delete();
}



