main()
{


	maps\mp\_load::main();

	thread speedrun\_way_name::create_spawn((124,-3,76),180);
	thread speedrun\_way_name::create_normal_way("Normal Way;");


	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "2" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setdvar("bg_fallDamageMaxHeight","9999");
	setdvar("bg_fallDamageMinHeight","9998");

	for(i=1;i<9;i++)
		addTriggerToList("trap"+i+"trig");

	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();


	thread start_walls();
	thread teleporter();

}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


rotations(axes,angle,time)
{
	switch(axes)
	{
		case 0:
		self rotateyaw(angle,time);
		break;

		case 1:
		self rotateroll(angle,time);
		break;

		case 2:
		self rotatepitch(angle,time);
		break;
	}
}

start_walls()
{
	obj = getent("start_walls","targetname");
	obj delete();
}

teleporter()
{       
 	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
		{
			entTransporter[i] thread transporter();
		}
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}

trap1()
{
	level endon("triggeroof");
	slapers = getentarray("slapers","targetname");
	killtrig = getentarray("slapers_killtrig","targetname");
	trig = getent("trap1trig","targetname");
	for(i=0;i<slapers.size;i++)
	{
		killtrig[i] enablelinkto();
		killtrig[i] linkto(slapers[i]);
	}
	trig waittill("triggeroof",player);
	for(i=0;i<slapers.size;i++)
	{
		slapers[i] thread trap1movement();
	}
}

trap1movement()
{
	for(;;)
	{
		time = RandomFloatRange(0.1,2.0);
		self movey(-132,time);
		wait time*2;
		self movey(132,time);
		self waittill("movedone");
		wait 2;
	}
}

trap2()
{
	spikes = getentarray("spiketrap","targetname");
	spike_killtrig = getentarray("spike_killtrig","targetname");
	trig = getent("trap2trig","targetname");
		for( i = 0; i < spikes.size; i++ )
		{
			spikes[i] delete();
		}
		for( i = 0; i < spike_killtrig.size; i++ )
		{
			spike_killtrig[i] delete();
		}
	trig delete();
}


trap3()
{
	level endon("triggerazafazere");
	fallthroge_plats_row1 = getentarray("fp_row1","targetname");
	fallthroge_plats_row2 = getentarray("fp_row2","targetname");
	trig = getent("trap3trig","targetname");
	trig waittill("triggerazafazere",player);

	for(;;)
	{
		time = RandomFloatRange(1.0,2.0);
		for(i=0;i<fallthroge_plats_row1.size;i++)
		{
			fallthroge_plats_row1[i] rotations(2,-80,time);
			fallthroge_plats_row2[i] rotations(2,80,time);
			wait .5;
		}

		wait time*time;

		for(i=0;i<fallthroge_plats_row1.size;i++)
		{
			fallthroge_plats_row1[i] rotations(2,80,time);
			fallthroge_plats_row2[i] rotations(2,-80,time);
			wait .5;
		}
		wait time*time;
	}
}

trap4()
{
	level endon("triggerazere");
	rotor = getent("rotor","targetname");
	pushtrigger = getent("pushtrigger","targetname");
	trig = getent("trap4trig","targetname");
	fxorigin = spawn("script_model",(rotor.origin));
	fxorigin SetModel("tag_origin");


	trig waittill("triggerazere",player);
	trig delete();

	pushtrigger delete();
	fxorigin delete();

}

trap5()
{
	level endon("triggerazafzfhhhhre");
	spiners = getentarray("spiners","targetname");
	spiner_trigs = getentarray("kst","targetname");
	trig = getent("trap5trig","targetname");
	for(i=0;i<spiner_trigs.size;i++)
	{
		spiner_trigs[i] enablelinkto();
		spiner_trigs[i] linkto(spiners[i]);
	}
	trig waittill("triggerazafzfhhhhre",player);
	for(i=0;i<spiners.size;i++)
		spiners[i] thread trap5rotations(i);
}

trap5rotations(num)
{
	repeat = randomint(5);
	if(repeat == 0)
		repeat = 3;
	for(i=0;i<repeat;i++)
	{
		if(num == 0)
		{
			self thread rotations(0,-180,1);
		}
		if(num == 1)
		{
			self thread rotations(0,180,1);
		}
		wait 2;
	}
}

trap6()
{
	trig = getent("trap6trig","targetname");
	level.smoketrig = getent("smoketrig","targetname");
	trig delete();
	level.smoketrig delete();
}


trap7()
{
	level endon("triggerfzzr");
	trig = getent("trap7trig","targetname");
	pillars = getentarray("pillars_trap7","targetname");
	trig waittill("triggerfzzr",player);
	for(i=0;i<pillars.size;i++)
		pillars[i] thread trap7moves();

}

trap7moves()
{
	orgpos = self.origin;
	for(;;)
	{
		range = RandomFloatRange(-208.0, 208.0);
		time = RandomFloatRange(2.0,5.0);
		self movez(range,time);
		wait time+2;
		self moveto(orgpos,time/2);
		wait time+2;
	}
}

trap8()
{
	level endon("triggerazazrr");
	flor = getent("flortrap8","targetname");
	c4model = getent("c4model","targetname");
	trig = getent("trap8trig","targetname");
	trig waittill("triggerazazrr",player);
	trig delete();
	flor delete();
	RadiusDamage( c4model.origin, 80, 200, 50 );
	c4model delete();
}