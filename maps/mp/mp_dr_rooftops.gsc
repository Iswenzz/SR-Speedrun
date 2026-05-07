main()
{
maps\mp\_load::main();  //You need this at the start of every map you make.

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	//level.weather = loadfx("weather/cloud_tunnel");
	
	//PrecacheItem( "p90_mp" );
	//PrecacheItem( "ak74u_mp" );
	//PrecacheItem( "tomahawk_mp" );
	//PrecacheItem( "m40a3_mp" );
	//PrecacheItem( "remington700_mp" );
	//PrecacheItem( "barrett_mp" );
	//PrecacheItem( "dragunov_mp" );

	thread sr\api\_map::createSpawn((208, -3446, -644), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread custom_tp();
	
	//thread music();
	//thread jumper();  
	//thread welcomebos();
	//thread imtroll();
	//thread activatorteleport();
	
	//thread fogfx();
	
	thread spikegoesup1(); //This is to let your CoD4 know that you are going to tell it to do something. Commonly referred to as 'threading it'.
	thread removeroof();
	thread removefloor();
	thread removetowerplank();
	thread removeplayerclipladder1();
	thread removeplayerclipladder2();
	thread removeplayerclipladder3();
	thread removeplayerclipladder4();
	thread removeplayerclipladder5();
	thread removeplayerclipladder6();
	thread removeplayerclipladder7();
	
	thread movehelicopter1();
	thread movehelicopter2();
	thread movehelicopter3();
	
	thread removebuildingclip();
	thread removebuildingclip2();
	
	
	
	
	thread spinning();
	thread poppetjes1();
	thread poppetjes2();
	thread poppetjes3();
	thread poppetjes4();
	thread poppetjes5();
	thread poppetjes6();
	thread poppetjes7();
	thread poppetjes8();
	thread poppetjes9();
	thread poppetjes10();
	thread poppetjes11();
	thread poppetjes12();
	thread poppetjes13();
	thread poppetjes14();
	thread poppetjes15();
	thread poppetjes16();
	thread poppetjes17();
	thread poppetjes18();
	thread poppetjes19();
	thread poppetjes20();
	thread poppetjes21();
	thread poppetjes22();
	thread poppetjes23();
	thread poppetjes24();
	thread poppetjes25();
	thread poppetjes26();
	thread poppetjes27();
	thread poppetjes28();
	thread poppetjes29();
	thread poppetjes30();
	
	

	//thread oldendroom();
	//thread weapon_endroom();
	//thread knife_endroom();
	//thread bounceendroom();
	//thread sniper_endroom();
	
	addTriggerToList ("removetowerplank_trig");
	addTriggerToList ("movehelicopter1_trig");
	addTriggerToList ("movehelicopter2_trig");
	addTriggerToList ("movehelicopter3_trig");
	addTriggerToList ("removebuildingclip_trig");
	addTriggerToList ("removebuildingclip2_trig");	
	addTriggerToList ("spikegoesup_trig");
	addTriggerToList ("removeplayerclipladder1_trig");
	addTriggerToList ("removeplayerclipladder2_trig");
	addTriggerToList ("removeplayerclipladder3_trig");
	addTriggerToList ("removeplayerclipladder4_trig");
	addTriggerToList ("removeplayerclipladder5_trig");
	addTriggerToList ("removeplayerclipladder6_trig");
	addTriggerToList ("removeplayerclipladder7_trig");
	addTriggerToList ("removeroof_trig");
	addTriggerToList ("removefloor_trig");
	addTriggerToList ("spinning_trig");
	addTriggerToList ("poppetjesgoesup_trig");
	

}
custom_tp()
{
	trig = spawn("trigger_radius",(-2796.26, 2528.59, -600.375), 0, 85, 120);
	trig.radius = 85;
	
	ori_t = spawn("script_origin",(-201,10569,112));
	ori_t.angles = (0,79,0);

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
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


activatorteleport()
{
	trig = getEnt("activatorteleport_trig", "targetname");
	tele1 = getEnt("activatorteleport", "targetname");
	
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(tele1.origin);
	}
}


jumper()
{
	jumpx = getent ("jump","targetname");
	glow = getent ("glow","targetname");
	air1 = getent ("air1","targetname");
	air2 = getent ("air2","targetname");
	air3 = getent ("air3","targetname");
	air4 = getent ("air4","targetname");
	air5 = getent ("air5","targetname");
	air6 = getent ("air6","targetname");
	air7 = getent ("air7","targetname");
	air8 = getent ("air8","targetname");
	air9 = getent ("air9","targetname");
	air10 = getent ("air10","targetname");
	air11 = getent ("air11","targetname");
	air12 = getent ("air12","targetname");
	air13 = getent ("air13","targetname");
	air14 = getent ("air14","targetname");

	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow.origin), 3, (glow.origin) + (0, 0, 90));

	time = 1;
	for(;;)
	{
		jumpx waittill ("trigger",user);
		if (user istouching(jumpx))
		{
			//throw = user.origin + (100, 100, 0);
			air = spawn ("script_model",(0,0,0));
			air.origin = user.origin;
			air.angles = user.angles;
			user linkto (air);
			air moveto (air1.origin, time);
			wait 1;
			air moveto (air2.origin, time);
			wait .5;
			air moveto (air3.origin, time);
			wait .5;
			air moveto (air4.origin, time);
			wait 1;
			air moveto (air5.origin, time);
			wait 1;
			air moveto (air6.origin, time);
			wait 1;
			air moveto (air7.origin, time);
			wait 1;
			air moveto (air8.origin, time);
			wait 1;
			air moveto (air9.origin, time);
			wait 1;
			air moveto (air10.origin, time);
			wait 1;
			air moveto (air11.origin, time);
			wait 1;
			air moveto (air12.origin, time);
			wait 1;
			air moveto (air13.origin, time);
			wait 1;
			air moveto (air14.origin, time);
			wait 1;
			user unlink();
			wait 1;
		}
	}
}







movehelicopter1()
{
	trig = getEnt ("movehelicopter1_trig", "targetname");
	movehelicopter1 = getEnt("movehelicopter1", "targetname");
	movehelicopterclipbrush1 = getEnt("movehelicopterclipbrush1", "targetname");
	trig waittill( "trigger", user );
    

	
}

movehelicopter2()
{
	trig = getEnt ("movehelicopter2_trig", "targetname");
	movehelicopter2 = getEnt("movehelicopter2", "targetname");
	movehelicopterclipbrush2 = getEnt("movehelicopterclipbrush2", "targetname");
	trig waittill( "trigger", user );
    

	
	
}

movehelicopter3()
{
	trig = getEnt ("movehelicopter3_trig", "targetname");
	movehelicopter3 = getEnt("movehelicopter3", "targetname");
	movehelicopterclipbrush3 = getEnt("movehelicopterclipbrush3", "targetname");
	trig waittill( "trigger", user );
	


	
	
}








music()
{
	wait 5;
	possibility = randomIntRange(1,4);
	if(possibility == 1)
	{
		ambientPlay("mohombi");
	}
	
	if(possibility == 2)
	
	{
		ambientPlay("nelly");
	}
	
	if(possibility == 3)
	
	{
		ambientPlay("rixton");
	}
	
	if(possibility == 4)
	
	{
		ambientPlay("timbaland");
	}
}






imtroll()
{
	trig = getEnt("imtroll","targetname");
	
	trig waittill("trigger",player);
	
	if((player.name == "iMtroll") || (player.name == "BosnianArmy") ||
		(player.name == "#FNRP#Bosnian"))
	{
		player iPrintLnBold("Wazzup Bosnian / Troll?");
	}
	else
	{
		player iPrintLnBold("You're not authorized. No secret for you.");
	}
}

fogfx()
{
	origin = getEnt("weather","targetname");
	weathertrig = getEnt("weather_trig","targetname");	

	weathertrig waittill("trigger");
	
	wait 20;
	
	PlayFX(level.weather , origin.origin);
}
	
spikegoesup1()
{

trig = getEnt("spikegoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	spikegoesup1 = getEnt("spikegoesup1","targetname"); //for the brushes number 1
	spikegoesup2 = getEnt("spikegoesup2","targetname");	//for the brushes number 2
	spikegoesup3 = getEnt("spikegoesup3","targetname");
	hurt = getEnt("spikegoesup_hurt","targetname");     //for the hurt damage number 1 brush
	hurt2 = getEnt("spikegoesup_hurt2","targetname");   //for the hurt damage number 2 brush
	hurt3 = getEnt("spikegoesup_hurt2","targetname"); 
	
	
	hurt enablelinkto(); //hurt links to brush number 1
	hurt linkto(spikegoesup1); //this is with hurt enablelinkto
	hurt2 enablelinkto(); 
	hurt2 linkto(spikegoesup2);
	
    trig waittill( "trigger", user );



	
	
   }
	

removetowerplank()
{
trig = getEnt ("removetowerplank_trig", "targetname");
removetowerplank = getEnt ("removetowerplank", "targetname");


    trig waittill( "trigger", user );

}


removebuildingclip()
{
trig = getEnt ("removebuildingclip_trig", "targetname");
removebuildingclip = getEnt ("removebuildingclip", "targetname");


   trig waittill( "trigger", user );
 
}


removebuildingclip2()
{
trig = getEnt ("removebuildingclip2_trig", "targetname");
removebuildingclip2 = getEnt ("removebuildingclip2", "targetname");


   trig waittill( "trigger", user );
 
}




removeplayerclipladder1()
{
trig = getEnt ("removeplayerclipladder1_trig", "targetname");
removeplayerclipladder1 = getEnt ("removeplayerclipladder1", "targetname");


   trig waittill( "trigger", user );

}	


removeplayerclipladder2()
{
trig = getEnt ("removeplayerclipladder2_trig", "targetname");
removeplayerclipladder2 = getEnt ("removeplayerclipladder2", "targetname");


    trig waittill( "trigger", user );

}

removeplayerclipladder3()
{
trig = getEnt ("removeplayerclipladder3_trig", "targetname");
removeplayerclipladder3 = getEnt ("removeplayerclipladder3", "targetname"); 


   trig waittill( "trigger", user );

}

removeplayerclipladder4()
{
trig = getEnt ("removeplayerclipladder4_trig", "targetname");
removeplayerclipladder4 = getEnt ("removeplayerclipladder4", "targetname"); 


   trig waittill( "trigger", user );

}

removeplayerclipladder5()
{
trig = getEnt ("removeplayerclipladder5_trig", "targetname");
removeplayerclipladder5 = getEnt ("removeplayerclipladder5", "targetname"); 


   trig waittill( "trigger", user );

}

removeplayerclipladder6()
{
trig = getEnt ("removeplayerclipladder6_trig", "targetname");
removeplayerclipladder6 = getEnt ("removeplayerclipladder6", "targetname"); 


   trig waittill( "trigger", user );

}

removeplayerclipladder7()
{
trig = getEnt ("removeplayerclipladder7_trig", "targetname");
removeplayerclipladder7 = getEnt ("removeplayerclipladder7", "targetname"); 


   trig waittill( "trigger", user );
 
}

removeroof()
{
trig = getEnt ("removeroof_trig", "targetname");
removeroof = getEnt ("removeroof", "targetname");


    trig waittill( "trigger", user );

}

removefloor()
{
trig = getEnt ("removefloor_trig", "targetname");
removefloor = getEnt ("removefloor", "targetname");


    trig waittill( "trigger", user );

}
		
	
spinning()
{
 
		trig = getEnt("spinning_trig","targetname"); //this if for the trigger_use_touch in radiant
        spinning = getEnt("spinning","targetname"); //for the brushes number 1       
        spinning_hurt = getEnt("spinning_hurt","targetname");     //for the hurt damage number 1 brush
        spinning_hurt2 = getEnt("spinning_hurt2","targetname");        
        spinning_hurt3 = getEnt("spinning_hurt3","targetname");        
       
        spinning_hurt enablelinkto(); //hurt links to brush number 1
        spinning_hurt linkto(spinning); //this is with hurt enablelinkto
       
        spinning_hurt2 enablelinkto();
        spinning_hurt2 linkto(spinning);
       
        spinning_hurt3 enablelinkto();
        spinning_hurt3 linkto(spinning);
       
       
       
		trig waittill( "trigger", user );
    
       
}
	
poppetjes1()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes = getEnt("poppetjes","targetname"); //for the brushes number 1
	poppetjes_hurt = getEnt("poppetjes_hurt","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt linkto(poppetjes); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );

	
	
}	
	
poppetjes2()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes2 = getEnt("poppetjes2","targetname"); //for the brushes number 1
	poppetjes_hurt2 = getEnt("poppetjes_hurt2","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt2 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt2 linkto(poppetjes2); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes3()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes3 = getEnt("poppetjes3","targetname"); //for the brushes number 1
	poppetjes_hurt3 = getEnt("poppetjes_hurt3","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt3 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt3 linkto(poppetjes3); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes4()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes4 = getEnt("poppetjes4","targetname"); //for the brushes number 1
	poppetjes_hurt4 = getEnt("poppetjes_hurt4","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt4 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt4 linkto(poppetjes4); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );

	
	
    }	
	
poppetjes5()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes5 = getEnt("poppetjes5","targetname"); //for the brushes number 1
	poppetjes_hurt5 = getEnt("poppetjes_hurt5","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt5 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt5 linkto(poppetjes5); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
    }	
	
poppetjes6()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes6 = getEnt("poppetjes6","targetname"); //for the brushes number 1
	poppetjes_hurt6 = getEnt("poppetjes_hurt6","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt6 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt6 linkto(poppetjes6); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }
	
poppetjes7()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes7 = getEnt("poppetjes7","targetname"); //for the brushes number 1
	poppetjes_hurt7 = getEnt("poppetjes_hurt7","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt7 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt7 linkto(poppetjes7); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );

	
    }	
	
poppetjes8()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes8 = getEnt("poppetjes8","targetname"); //for the brushes number 1
	poppetjes_hurt8 = getEnt("poppetjes_hurt8","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt8 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt8 linkto(poppetjes8); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
    }	
	
poppetjes9()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes9 = getEnt("poppetjes9","targetname"); //for the brushes number 1
	poppetjes_hurt9 = getEnt("poppetjes_hurt9","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt9 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt9 linkto(poppetjes9); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes10()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes10 = getEnt("poppetjes10","targetname"); //for the brushes number 1
	poppetjes_hurt10 = getEnt("poppetjes_hurt10","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt10 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt10 linkto(poppetjes10); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes11()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes11 = getEnt("poppetjes11","targetname"); //for the brushes number 1
	poppetjes_hurt11 = getEnt("poppetjes_hurt11","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt11 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt11 linkto(poppetjes11); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	

	
    }	
	
poppetjes12()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes12 = getEnt("poppetjes12","targetname"); //for the brushes number 1
	poppetjes_hurt12 = getEnt("poppetjes_hurt12","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt12 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt12 linkto(poppetjes12); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes13()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes13 = getEnt("poppetjes13","targetname"); //for the brushes number 1
	poppetjes_hurt13 = getEnt("poppetjes_hurt13","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt13 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt13 linkto(poppetjes13); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes14()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes14 = getEnt("poppetjes14","targetname"); //for the brushes number 1
	poppetjes_hurt14 = getEnt("poppetjes_hurt14","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt14 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt14 linkto(poppetjes14); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes15()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes15 = getEnt("poppetjes15","targetname"); //for the brushes number 1
	poppetjes_hurt15 = getEnt("poppetjes_hurt15","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt15 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt15 linkto(poppetjes15); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes16()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes16 = getEnt("poppetjes16","targetname"); //for the brushes number 1
	poppetjes_hurt16 = getEnt("poppetjes_hurt16","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt16 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt16 linkto(poppetjes16); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes17()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes17 = getEnt("poppetjes17","targetname"); //for the brushes number 1
	poppetjes_hurt17 = getEnt("poppetjes_hurt17","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt17 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt17 linkto(poppetjes17); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes18()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes18 = getEnt("poppetjes18","targetname"); //for the brushes number 1
	poppetjes_hurt18 = getEnt("poppetjes_hurt18","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt18 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt18 linkto(poppetjes18); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	
	
poppetjes19()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes19 = getEnt("poppetjes19","targetname"); //for the brushes number 1
	poppetjes_hurt19 = getEnt("poppetjes_hurt19","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt19 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt19 linkto(poppetjes19); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );

	
	
    }	
	
poppetjes20()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes20 = getEnt("poppetjes20","targetname"); //for the brushes number 1
	poppetjes_hurt20 = getEnt("poppetjes_hurt20","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt20 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt20 linkto(poppetjes20); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }	

poppetjes21()

{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes21 = getEnt("poppetjes21","targetname"); //for the brushes number 1
	poppetjes_hurt21 = getEnt("poppetjes_hurt21","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt21 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt21 linkto(poppetjes21); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }

poppetjes22()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes22 = getEnt("poppetjes22","targetname"); //for the brushes number 1
	poppetjes_hurt22 = getEnt("poppetjes_hurt22","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt22 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt22 linkto(poppetjes22); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
    }

poppetjes23()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes23 = getEnt("poppetjes23","targetname"); //for the brushes number 1
	poppetjes_hurt23 = getEnt("poppetjes_hurt23","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt23 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt23 linkto(poppetjes23); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }
	
poppetjes24()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes24 = getEnt("poppetjes24","targetname"); //for the brushes number 1
	poppetjes_hurt24 = getEnt("poppetjes_hurt24","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt24 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt24 linkto(poppetjes24); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }
	
poppetjes25()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes25 = getEnt("poppetjes25","targetname"); //for the brushes number 1
	poppetjes_hurt25 = getEnt("poppetjes_hurt25","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt25 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt25 linkto(poppetjes25); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
    }
	
poppetjes26()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes26 = getEnt("poppetjes26","targetname"); //for the brushes number 1
	poppetjes_hurt26 = getEnt("poppetjes_hurt26","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt26 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt26 linkto(poppetjes26); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }
	
poppetjes27()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes27 = getEnt("poppetjes27","targetname"); //for the brushes number 1
	poppetjes_hurt27 = getEnt("poppetjes_hurt27","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt27 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt27 linkto(poppetjes27); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
    }
	
poppetjes28()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes28 = getEnt("poppetjes28","targetname"); //for the brushes number 1
	poppetjes_hurt28 = getEnt("poppetjes_hurt28","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt28 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt28 linkto(poppetjes28); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
	
    }
	
poppetjes29()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes29 = getEnt("poppetjes29","targetname"); //for the brushes number 1
	poppetjes_hurt29 = getEnt("poppetjes_hurt29","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt29 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt29 linkto(poppetjes29); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );
	

	
    }
	
poppetjes30()
{

    trig = getEnt("poppetjesgoesup_trig","targetname"); //this if for the trigger_use_touch in radiant
	poppetjes30 = getEnt("poppetjes30","targetname"); //for the brushes number 1
	poppetjes_hurt30 = getEnt("poppetjes_hurt30","targetname");     //for the hurt damage number 1 brush
	
	
	
	poppetjes_hurt30 enablelinkto(); //hurt links to brush number 1
	poppetjes_hurt30 linkto(poppetjes30); //this is with hurt enablelinkto
	
	
	
    trig waittill( "trigger", user );

	
	
    }	
	


	
	
welcomebos()
{
	wait 5;
	
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if( GetSubStr( players[i] GetGuid(), 24, 32 ) == "eadbb026" )
		{
			players[i] iprintLnBold("^3Hi!");
			iprintlnBold ("^4Map maker " + players[i].name + " ^8joined the game");
		}
	}
}	
	

bounceendroom()
{
	level.bounceTrig = getent("bounceendgame_trig","targetname");
	bounce_jumper = getEnt( "bouncejumper_origin", "targetname" );
	bounce_acti = getEnt( "bounceacti_origin", "targetname" );
	
	while(true)
	{
		level.bounceTrig waittill("trigger",player);
		level.oldTrig delete();
		level.knife_trig delete();
		level.weapon_trig delete();
		level.sniper_trig delete();
		
		if(isplayer(player)&&isalive(player))
		{
			if(player.pers["team"] == "axis")
			{
				player setorigin(bounce_acti.origin);
				
			}

			if(player.pers["team"] == "allies")
			{
				player setorigin(bounce_jumper.origin);
				
			}			
		}
	}
}
	
knife_endroom()
{
    level.knife_trig = getEnt( "knife_endgame_trig", "targetname");
    jump = getEnt( "knife_jump_origin", "targetname" );
    acti = getEnt( "knife_acti_origin", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
		level.oldTrig delete();
		level.bounceTrig delete();
		level.weapon_trig delete();
		level.sniper_trig delete();

        if( !isDefined( level.knife_trig ) )
        
        
        player setOrigin( jump.origin ); // Teleport jumper
        player TakeAllWeapons(); // Takes all jumper weapons 
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon        
        
        level.activ setOrigin( acti.origin ); //Teleports acti
        level.activ TakeAllWeapons(); // Take all acti weps 
        level.activ GiveWeapon( "tomahawk_mp" ); // Give acti a tomahawk    
        wait 0.05;
		player.maxhealth = 100; // Player health
		level.activ.maxhealth = 100; // Acti health
        player switchToWeapon( "tomahawk_mp" ); //player weapon
        level.activ SwitchToWeapon( "tomahawk_mp" ); // Activator weapon
        iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4KNIFE ^7room!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
	return;
}	

	
oldendroom()
{
level.oldTrig = getEnt ("oldendroom_trig", "targetname");
oldendroom = getEnt ("oldendroom", "targetname");


    level.oldTrig waittill( "trigger", user );
	level.bounceTrig delete();
	level.knife_trig delete();
	level.weapon_trig delete();
	level.sniper_trig delete();
	iPrintLnBold( " ^4" + user.name + " ^7has chosen ^4OLD ^7room!" );
	
	level.oldTrig delete();
	

 
{
 oldendroom hide();
	oldendroom notSolid();
	
	
}
}

weapon_endroom()
{
        level.weapon_trig = getEnt( "weapon_endroom_trig", "targetname"); //The trigger
        jump = getEnt( "jump_weapon_origin", "targetname" ); //the origin the jumper will teleport
        acti = getEnt( "activator_weapon_origin", "targetname" ); //the origin the acti will teleport
 
        while(1) //loop
{
                level.weapon_trig waittill( "trigger", player ); //waits until the jumper activates the room
                level.oldTrig delete();
                level.bounceTrig delete();
                level.knife_trig delete();
				level.sniper_trig delete();
                if( !isDefined( level.weapon_trig ) ) //defines that it is the weapon trigger
                return;        
 
                player setOrigin( jump.origin ); //teleports the jumper
                player TakeAllWeapons(); //takes all weapons from jumper
                player GiveWeapon( "ak74u_mp" );
                player giveMaxAmmo( "ak74u_mp" );
                player GiveWeapon( "p90_mp" );
                player giveMaxAmmo( "p90_mp" );
                player.maxhealth = 100;
                player switchToWeapon( "tomahawk_mp" );
                //jumper weapon
                if( isDefined( level.activ ) && isAlive( level.activ ) ) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
{
 
 
                    level.activ setOrigin( acti.origin ); //teleports acti
                    level.activ TakeAllWeapons(); //takes all weapons from acti
                    level.activ GiveWeapon( "ak74u_mp" );
                    level.activ giveMaxAmmo( "ak74u_mp" );
                    level.activ GiveWeapon( "p90_mp" );
                    level.activ giveMaxAmmo( "p90_mp" );
                    level.activ.maxhealth = 100; //gives players normal health if damaged
                    level.activ SwitchToWeapon( "tomahawk_mp" ); //this line means they switch to the weapon
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4WEAPON ^7room!" ); // announces on screen the player name and the knife room
                while( isAlive( player ) && isDefined( player ) ) //if the player is alive the room will stay closed so no one can enter.
                        wait 1;
}
}

sniper_endroom()
{
        level.sniper_trig = getEnt( "sniper_endgame_trig", "targetname"); //The trigger
        jump = getEnt( "sniper_jump_origin", "targetname" ); //the origin the jumper will teleport
        acti = getEnt( "sniper_acti_origin", "targetname" ); //the origin the acti will teleport
 
        while(1) //loop
{
                level.weapon_trig waittill( "trigger", player ); //waits until the jumper activates the room
                level.oldTrig delete();
                level.bounceTrig delete();
                level.knife_trig delete();
				level.weapon_trig delete();
                if( !isDefined( level.weapon_trig ) ) //defines that it is the weapon trigger
                return;        
 
                player setOrigin( jump.origin ); //teleports the jumper
                player TakeAllWeapons(); //takes all weapons from jumper
                player GiveWeapon( "m40a3_mp" );
                player giveMaxAmmo( "m40a3_mp" );
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );
				 player GiveWeapon( "barrett_mp" );
                player giveMaxAmmo( "barrett_mp" );
				 player GiveWeapon( "dragunov_mp" );
                player giveMaxAmmo( "dragunov_mp" );
                player.maxhealth = 100;
                player switchToWeapon( "tomahawk_mp" );
                //jumper weapon
                if( isDefined( level.activ ) && isAlive( level.activ ) ) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
{
 
 
                    level.activ setOrigin( acti.origin ); //teleports acti
                    level.activ TakeAllWeapons(); //takes all weapons from acti
                    level.activ GiveWeapon( "m40a3_mp" );
                    level.activ giveMaxAmmo( "m40a3_mp" );
                    level.activ GiveWeapon( "remington700_mp" );
                    level.activ giveMaxAmmo( "remington700_mp" );
					level.activ GiveWeapon( "barrett_mp" );
                    level.activ giveMaxAmmo( "barrett_mp" );
					level.activ GiveWeapon( "dragunov_mp" );
                    level.activ giveMaxAmmo( "dragunov_mp" );
                    level.activ.maxhealth = 100; //gives players normal health if damaged
                    level.activ SwitchToWeapon( "tomahawk_mp" ); //this line means they switch to the weapon
}
                 
                wait 0.05;
               
                iPrintLnBold( " ^4" + player.name + " ^7has chosen ^4WEAPON ^7room!" ); // announces on screen the player name and the knife room
                while( isAlive( player ) && isDefined( player ) ) //if the player is alive the room will stay closed so no one can enter.
                        wait 1;
}
}