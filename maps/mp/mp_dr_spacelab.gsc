/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////																									              ///////
///////																									              ///////
///////		////////	     //		/////////////	//	 //  ////////////  ////////////  //////////   /////////////   ///////
///////		//		//    //   //   //         //	//  //   //	                //       //           //         //   ///////
///////		//		//    //   //   ////////////    // //    //	                //       //           ////////////    ///////
///////		//		//    ///////	//	  //	    ////     ////////////       //       //////////   //              ///////
///////		//		//	  //   //	//	   //	    // //              //       //       //           //              ///////
///////		//		//	  //   //	//		//      //  //             //       //       //           //              ///////
///////		////////	  //   //   //		 //     //   //  ////////////       //       //////////   //              ///////
///////																									              ///////
///////																									              ///////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Steam: CAR DarkSTEP
//Discord: DarkSTEP#7390
//YouTube: DarkSTEP
//PayPal: paypal.me/darkstepdonations
//Every donator will get lifetime VIP access to all my updated maps!
//Minor thanks: CAR 0rK!DeA (few vision and hud fixes), VC' Fox (chiller playermodel), VC' ERIK (secret timer and some fx)
//Feel free to copy without permission ;)
//If you're from xM and you're reading this then good luck trying to make this map work in your trash server :D

#include braxi\_common;
#include common_scripts\utility;
#include braxi\_rank;
main()
{
	maps\mp\_load::main();
 
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^3Easy Secret;^1Hard Secret;");
	thread sr\api\_speedrun::createTeleporter((-233.138, -85.9571, 8.125), 100, 80, (2814, 20223, 14756), 270, "freeze", "blue", "secret_0");
	thread sr\api\_speedrun::createTeleporter((-234.428, 173.777, 8.125), 100, 80, (-2370, 2216, 15340), 91, "freeze", "red", "secret_1");


    setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");
	setdvar("bg_fallDamageMaxHeight", "99999"); 
	setdvar("bg_fallDamageMinHeight", "99998");

	thread gate();
	thread portal();
	thread plat1();
	thread plat2();
	thread plat3();
	thread plat4();
	thread sdoor1();
	thread sdoor2();
	thread sdoor3();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
	thread trap13();
	thread startdoor();
	thread main190();
	thread b190();
	thread c190();
	thread d190();
	thread e190();
	thread f190();
	thread g190();
	thread h190();
	thread i190();
	thread secretend190();
	thread main210();
	thread b210();
	thread c210();
	thread d210();
	thread e210();
	thread f210();
	thread g210();
	thread h210();
	thread i210();
	thread secretend210();
	
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
	addTriggerToList( "trig_trap9" );
	addTriggerToList( "trig_trap10" );
	addTriggerToList( "trig_trap11" );
	addTriggerToList( "trig_trap12" );
	addTriggerToList( "trig_trap13" );
}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

startdoor()
{
door = getEnt("startdoor", "targetname");
door delete();
}	
gate()
{
	left = getEnt("gateleft", "targetname");
	right = getEnt("gateright", "targetname");
	o = getEnt("o_gate", "targetname");
	
	left delete();
	right delete();
	o delete();
}

plat1()
{
	trig = getEnt("trig_plat1", "targetname");
	plat = getEnt("plat1", "targetname");	
	plat moveZ(384,.5);
}

plat2()
{
	trig = getEnt("trig_plat2", "targetname");
	plat = getEnt("plat2", "targetname");	
	plat moveZ(384,.5);
}

plat3()
{
	trig = getEnt("trig_plat3", "targetname");
	plat = getEnt("plat3", "targetname");	
	plat moveZ(384,.5);
}

plat4()
{
	trig = getEnt("trig_plat4", "targetname");
	plat = getEnt("plat4", "targetname");	
	plat moveZ(384,.5);
}

portal()
{
	trig = getEnt("trig_portal", "targetname");
	o = getEnt("o_portal", "targetname");
	
	for (;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);		
	}
}


sdoor3()
{
	plat = getEnt("sdoor3", "targetname");

	plat delete();


}


sdoor1()
{
	trig = getEnt("trig_sdoor1", "targetname");
	plat = getEnt("sdoor1", "targetname");

	plat delete();
}

sdoor2()
{
	trig = getEnt("trig_sdoor2", "targetname");
	plat = getEnt("sdoor2", "targetname");	
	plat delete();
}


trap1()
{
	level endon("triggero");
	trig = getEnt("trig_trap1", "targetname");
	a = getEnt("trap1a", "targetname");
	b = getEnt("trap1b", "targetname");
	o = getEnt("o_trap1", "targetname");
	trig waittill ("triggero", player);
	x = randomInt(2);
	if (x==0)
	{
		a moveZ(-504, 1);
		wait 5;
		a moveZ(504, 1);
		wait 1;
	}
	if (x==1)
	{
		b moveZ(-504, 1);
		wait 5;
		b moveZ(504, 1);
		wait 1;
	}
}
trap2()
{
	level endon("triggerzfzfo");
	trig = getEnt("trig_trap2", "targetname");
	hurt = getEnt("trap2dmg", "targetname");
	hurt thread maps\mp\_utility::triggerOff();
	o = getEnt("o_trap2", "targetname");
	os = getEnt("o_sparksound2", "targetname");
	o1 = getEnt("o_trap2a", "targetname");
	o2 = getEnt("o_trap2b", "targetname");
	o3 = getEnt("o_trap2c", "targetname");
	o4 = getEnt("o_trap2d", "targetname");
	o5 = getEnt("o_trap2e", "targetname");
	trig waittill ("triggerzfzfo", player);
	hurt thread maps\mp\_utility::triggerOn();
	hurt thread maps\mp\_utility::triggerOff();
}
trap3()
{
	level endon("triggerozfzqs");
	trig = getEnt("trig_trap3", "targetname");
	hurta = getEnt("trap3dmga", "targetname");
	hurtb = getEnt("trap3dmgb", "targetname");
	hurta thread maps\mp\_utility::triggerOff();
	hurtb thread maps\mp\_utility::triggerOff();
	o = getEnt("o_trap3", "targetname");
	os = getEnt("o_trap3sound", "targetname");
	o1 = getEnt("o_trap3a", "targetname");
	o2 = getEnt("o_trap3b", "targetname");
	o3 = getEnt("o_trap3c", "targetname");
	o4 = getEnt("o_trap3d", "targetname");
	o5 = getEnt("o_trap3e", "targetname");
	o6 = getEnt("o_trap3f", "targetname");
	o7 = getEnt("o_trap3g", "targetname");
	o8 = getEnt("o_trap3h", "targetname");
	trig waittill ("triggerozfzqs", player);
	for(;;)
	{
		hurta thread maps\mp\_utility::triggerOn();

		hurta thread maps\mp\_utility::triggerOff();
		wait 4.6;
		hurtb thread maps\mp\_utility::triggerOn();
		wait .4;
		hurtb thread maps\mp\_utility::triggerOff();
		wait 4.6;
		hurta thread maps\mp\_utility::triggerOn();
		hurtb thread maps\mp\_utility::triggerOn();
		wait .4;
		hurta thread maps\mp\_utility::triggerOff();
		hurtb thread maps\mp\_utility::triggerOff();
		wait 4.6;
	}
}

trap4()
{
	level endon("triggeraasaso");
	trig = getEnt("trig_trap4", "targetname");
	a = getEnt("trap4", "targetname");
	o = getEnt("o_trap4", "targetname");
	trig waittill ("triggeraasaso", player);
		a moveZ(-900, 2);
		wait 2;
}


trap6()
{
	level endon("triggerovvvbb");
trigger = getent("trig_trap6","targetname");
object = getent("trap6","targetname");
o = getent("o_trap6","targetname");
killtrigger = getent ("trap6dmg", "targetname");
trigger waittill ("triggerovvvbb" , player );
trigger delete();
killtrigger enablelinkto ();
killtrigger linkto (object);
object moveZ(-198, 1);
wait(1);
object moveZ(198, 1);
wait(1);
}


trap7()
{
	level endon("triggerosjk");
trigger = getent("trig_trap7","targetname");
a = getent("trap7","targetname");
trigger waittill ("triggerosjk" , player );
trigger delete();
a delete();
}

trap8()
{
	level endon("triggerazrt");
trig = getEnt ("trig_trap8", "targetname");
a = getEnt ("trap8", "targetname");
o_a = getEnt ("o_bobomba", "targetname");
bobomba = getEnt ("bobomba", "targetname");
trig waittill("triggerazrt", player);
trig delete();
RadiusDamage(o_a.origin, 249, 249, 249);
bobomba delete();
a delete();
}

trap9()
{
	level endon("triggerazazrto");
	trig = getEnt("trig_trap9", "targetname");
	a = getEnt("trap9a", "targetname");
	b = getEnt("trap9b", "targetname");
	o = getEnt("o_trap9", "targetname");
	trig waittill ("triggerazazrto", player);
	x = randomInt(2);
	if (x==0)
	{
		a moveZ(-1104, 1);
		wait 5;
		a moveZ(1104, 1);
		wait 1;
	}
	if (x==1)
	{
		b moveZ(-1104, 1);
		wait 5;
		b moveZ(1104, 1);
		wait 1;
	}
}

trap10()
{
	level endon("triggeroghhtht");
	trig = getEnt("trig_trap10", "targetname");
	a = getEnt("trap10", "targetname");
	trig waittill ("triggeroghhtht", player);
		a moveZ(-8000, 7);
		wait 7;
		a delete();
}

trap11()
{
	level endon("triggeroqsqsqs");
	trig = getEnt("trig_trap11", "targetname");
	a = getEnt("trap11", "targetname");
	trig waittill ("triggeroqsqsqs", player);
		a moveZ(-8000, 7);
		wait 7;
		a delete();
}

trap12()
{
	level endon("triggerobfbfb");
a = getEnt ("trap12", "targetname");
trig = getEnt ("trig_trap12", "targetname");
m = getEnt ("trap12m", "targetname");
m linkTo(a);
trig waittill("triggerobfbfb", player);
	for(;;)
	{
	a rotateYaw (360, 5.5);
	wait 5.5;
	}
}

trap13()
{
	level endon("triggerozfzfzfzfzfzf");
	trig = getEnt("trig_trap13", "targetname");
	a = getEnt("trap13a", "targetname");
	b = getEnt("trap13b", "targetname");
	trig waittill ("triggerozfzfzfzfzfzf", player);
	x = randomInt(2);
	if (x==0)
	{
		a moveZ(-8000, 6);
		wait 7;
		a moveZ(8000, 2);
		wait 3;
	}
	if (x==1)
	{
		b moveZ(-8000, 6);
		wait 7;
		b moveZ(8000, 2);
		wait 3;
	}
}		

main210()
{
	trig = getEnt("trig_main210", "targetname");
	a = getEnt("o_210a", "targetname");
	b = getEnt("o_210b", "targetname");
	c = getEnt("o_210c", "targetname");
	d = getEnt("o_210d", "targetname");
	e = getEnt("o_210e", "targetname");
	f = getEnt("o_210f", "targetname");
	g = getEnt("o_210g", "targetname");
	h = getEnt("o_210h", "targetname");
	i = getEnt("o_210i", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		if (player.fasts == 1)
		{
			player setOrigin(a.origin);
			player setPlayerAngles(a.angles);
		}
		else if (player.fasts == 2)
		{
			player setOrigin(b.origin);
			player setPlayerAngles(b.angles);
		}
		else if (player.fasts == 3)
		{
			player setOrigin(c.origin);
			player setPlayerAngles(c.angles);
		}
		else if (player.fasts == 4)
		{
			player setOrigin(d.origin);
			player setPlayerAngles(d.angles);
		}
		else if (player.fasts == 5)
		{
			player setOrigin(e.origin);
			player setPlayerAngles(e.angles);
		}
		else if (player.fasts == 6)
		{
			player setOrigin(f.origin);
			player setPlayerAngles(f.angles);
		}
		else if (player.fasts == 7)
		{
			player setOrigin(g.origin);
			player setPlayerAngles(g.angles);
		}
		else if (player.fasts == 8)
		{
			player setOrigin(h.origin);
			player setPlayerAngles(h.angles);
		}
		else if (player.fasts == 9)
		{
			player setOrigin(i.origin);
			player setPlayerAngles(i.angles);
		}
	}
}

b210()
{
	trig = getEnt("trig_210b", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 2;
	wait .5;
	}
}

c210()
{
	trig = getEnt("trig_210c", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 3;
	wait .5;
	}
}

d210()
{
	trig = getEnt("trig_210d", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 4;
	wait .5;
	}
}

e210()
{
	trig = getEnt("trig_210e", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 5;
	wait .5;
	}
}

f210()
{
	trig = getEnt("trig_210f", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 6;
	wait .5;
	}
}

g210()
{
	trig = getEnt("trig_210g", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 7;
	wait .5;
	}
}

h210()
{
	trig = getEnt("trig_210h", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 8;
	wait .5;
	}
}

i210()
{
	trig = getEnt("trig_210i", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 9;
	wait .5;
	}
}

secretend210()
{	
	trig = getEnt("trig_210secretend", "targetname");
	o = getEnt("o_210secretend", "targetname");
	for(;;)
	{
			trig waittill("trigger", player);
			player thread sr\api\_speedrun::finishWay("secret_0");
			player.fasts = 1;

	}
}
main190()
{
	trig = getEnt("trig_main190", "targetname");
	a = getEnt("o_190a", "targetname");
	b = getEnt("o_190b", "targetname");
	c = getEnt("o_190c", "targetname");
	d = getEnt("o_190d", "targetname");
	e = getEnt("o_190e", "targetname");
	f = getEnt("o_190f", "targetname");
	g = getEnt("o_190g", "targetname");
	h = getEnt("o_190h", "targetname");
	i = getEnt("o_190i", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		if (player.slows == 1)
		{
			player setOrigin(a.origin);
			player setPlayerAngles(a.angles);
		}
		else if (player.slows == 2)
		{
			player setOrigin(b.origin);
			player setPlayerAngles(b.angles);
		}
		else if (player.slows == 3)
		{
			player setOrigin(c.origin);
			player setPlayerAngles(c.angles);
		}
		else if (player.slows == 4)
		{
			player setOrigin(d.origin);
			player setPlayerAngles(d.angles);
		}
		else if (player.slows == 5)
		{
			player setOrigin(e.origin);
			player setPlayerAngles(e.angles);
		}
		else if (player.slows == 6)
		{
			player setOrigin(f.origin);
			player setPlayerAngles(f.angles);
		}
		else if (player.slows == 7)
		{
			player setOrigin(g.origin);
			player setPlayerAngles(g.angles);
		}
		else if (player.slows == 8)
		{
			player setOrigin(h.origin);
			player setPlayerAngles(h.angles);
		}
		else if (player.slows == 9)
		{
			player setOrigin(i.origin);
			player setPlayerAngles(i.angles);
		}
	}
}

b190()
{
	trig = getEnt("trig_190b", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 2;
	wait .5;
	}
}

c190()
{
	trig = getEnt("trig_190c", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 3;
	wait .5;
	}
}

d190()
{
	trig = getEnt("trig_190d", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 4;
	wait .5;
	}
}

e190()
{
	trig = getEnt("trig_190e", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 5;
	wait .5;
	}
}

f190()
{
	trig = getEnt("trig_190f", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 6;
	wait .5;
	}
}

g190()
{
	trig = getEnt("trig_190g", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 7;
	wait .5;
	}
}

h190()
{
	trig = getEnt("trig_190h", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 8;
	wait .5;
	}
}

i190()
{
	trig = getEnt("trig_190i", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 9;
	wait .5;
	}
}
secretend190()
{	
	trig = getEnt("trig_190secretend", "targetname");
	o = getEnt("o_190secretend", "targetname");
	for(;;)
	{
			trig waittill("trigger", player);
			player thread sr\api\_speedrun::finishWay("secret_1");
			player.slows = 1;
	}
}
