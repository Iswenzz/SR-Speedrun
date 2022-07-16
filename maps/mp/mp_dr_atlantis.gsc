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

//Steam: ^5CAR ^0DarkSTEP
//Discord: DarkSTEP#7390
//YouTube: DarkSTEP
//Website: darkstep.altervista.org
//PayPal: paypal.me/darktest
//Every donator will get lifetime VIP access to all my updated maps!
//Minor thanks: Ohh Rexy<3 (finding me the emotiguy model source)
//Feel free to copy without permission ;)

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	maps\mp\_load::main();

	thread speedrun\_way_name::create_spawn((-531,11186,1636),180);
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_secret_way("Easy Secret;Hard Secret;");
	thread speedrun\_way_name::create_tp((-541.037, 10870.6, 1576.13), 110, 75, (8599, 413, 1966), 359, "freeze", "blue", "s0");
	thread speedrun\_way_name::create_tp((-881.141, 10927.7, 1576.13), 110, 75, (9998, 22167, 277), 60, "freeze", "red", "s1");
	thread speedrun\_way_name::create_endmap((8183.27, 7359.79, 35.125),150,75,"s0");
	thread speedrun\_way_name::create_endmap((2774.49, 9859.01, -6214.88),175,75,"s1");
	thread speedrun\_way_name::create_endmap((-5693.92, 617.378, -2606.4),105,75,"ns0");

 
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
    setDvar( "r_specularcolorscale", "1" );
    setDvar("r_glowbloomintensity0",".25");
    setDvar("r_glowbloomintensity1",".25");
    setDvar("r_glowskybleedintensity0",".3");
	setDvar("bg_falldamagemaxheight", 200000 );
	setDvar("bg_falldamageminheight", 100000 );
	
    thread startdoor();
	thread riseup();
	thread gone();
	thread bomb();
	thread endoor();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread main190();
	thread b190();
	thread c190();
	thread main210();
	thread d190();
	thread e190();
	thread f190();
	thread g190();
	thread h190();
	thread i190();
	thread j190();
	thread k190();
	thread l190();
	thread b210();
	thread c210();
	thread d210();
	thread e210();
	thread f210();
	thread g210();
	thread h210();
	thread i210();
	thread j210();
	thread k210();
	thread setresp();

	
	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	
}
setresp() 
{
    trig1 = spawn( "trigger_radius", (-660.748, 11196.3, 1576.13), 0, 135, 65 );

	trig1 thread setting();

}
setting()
{
   while(1)
    {
    	self waittill("trigger", player);
		player.fasts = 1;
		player.slows = 1;


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
	j = getEnt("o_210j", "targetname");
	k = getEnt("o_210k", "targetname");
	l = getEnt("o_210l", "targetname");
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
		else if (player.fasts == 10)
		{
			player setOrigin(j.origin);
			player setPlayerAngles(j.angles);
		}
		else if (player.fasts == 11)
		{
			player setOrigin(k.origin);
			player setPlayerAngles(k.angles);
		}
		else if (player.fasts == 12)
		{
			player setOrigin(l.origin);
			player setPlayerAngles(l.angles);
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

j210()
{
	trig = getEnt("trig_210j", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 10;
	wait .5;
	}
}

k210()
{
	trig = getEnt("trig_210k", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 11;
	wait .5;
	}
}

l210()
{
	trig = getEnt("trig_210l", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 12;
	wait .5;
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
	j = getEnt("o_190j", "targetname");
	k = getEnt("o_190k", "targetname");
	l = getEnt("o_190l", "targetname");
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
		else if (player.slows == 10)
		{
			player setOrigin(j.origin);
			player setPlayerAngles(j.angles);
		}
		else if (player.slows == 11)
		{
			player setOrigin(k.origin);
			player setPlayerAngles(k.angles);
		}
		else if (player.slows == 12)
		{
			player setOrigin(l.origin);
			player setPlayerAngles(l.angles);
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

j190()
{
	trig = getEnt("trig_190j", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 10;
	wait .5;
	}
}

k190()
{
	trig = getEnt("trig_190k", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 11;
	wait .5;
	}
}

l190()
{
	trig = getEnt("trig_190l", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 12;
	wait .5;
	}
}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
aaa()
{
     gone = getEnt("gone", "targetname");
	 trig = getEnt("trig_gone", "targetname");
	 trig enableLinkTo();
	 trig linkTo(gone);
     for(;;)
	 {
	 gone moveY (-664, 1);
	 gone waittill ("movedone");
	 gone moveZ (-160, 0.1);
	 gone waittill ("movedone");
	 gone moveY (664, 0.1);
	 gone waittill ("movedone");
	 gone moveZ (160, 0.1);
	 gone waittill ("movedone");
	 }
}
endoor()
{
	a = getEnt("endoorl", "targetname");
	b = getEnt("endoorr", "targetname");
	a delete();
	b delete();
}
aab()
{
     gone2 = getent("gone2", "targetname");
	 trig = getEnt("trig_gone2", "targetname");
	 trig enableLinkTo();
	 trig linkTo(gone2);
     for(;;)
	 {
	 gone2 moveY (-664, 1);
	 gone2 waittill ("movedone");
	 gone2 moveZ (-160, 0.1);
	 gone2 waittill ("movedone");
	 gone2 moveY (664, 0.1);
	 gone2 waittill ("movedone");
	 gone2 moveZ (160, 0.1);
	 gone2 waittill ("movedone");
	 }
}
gone()
{
     thread aaa();
	 wait 4;
	 thread aab();
	 wait 4;
	 thread aac();
}
aac()
{
     gone3 = getent("gone3", "targetname");
	 trig = getEnt("trig_gone3", "targetname");
	 trig enableLinkTo();
	 trig linkTo(gone3);
     for(;;)
	 {
	 gone3 moveY (-664, 1);
	 gone3 waittill ("movedone");
	 gone3 moveZ (-160, 0.1);
	 gone3 waittill ("movedone");
	 gone3 moveY (664, 0.1);
	 gone3 waittill ("movedone");
	 gone3 moveZ (160, 0.1);
	 gone3 waittill ("movedone");
	 }
}
bomb()
{
	trig = getEnt ("trig_bomb", "targetname");
	a = getEnt ("abomb", "targetname");
	bobomba = getEnt ("bomb", "targetname");
	trig delete();
	bobomba delete();
	a delete();
}
startdoor()
{
t = getEnt("sdtop", "targetname");
l = getEnt("sdleft", "targetname");
b = getEnt("sdbottom", "targetname");
r = getEnt("sdright", "targetname");

t delete();
b delete();
l delete();
r delete();
}

riseup()
{
	trig = getEnt("trig_riseup", "targetname");
	a = getEnt("riseup", "targetname");
	a moveZ(-1728, 2);
	wait 2;
	trig waittill("trigger", player);
	trig delete();
	a moveZ(1728, 2);
	wait 2;
}

trap1()
{
	level endon("triggera");
	trig = getEnt("trig_trap1", "targetname");
	hurt = getEnt("trap1hurt", "targetname");
	a = getEnt("trap1a", "targetname");
	decal = getEnt("trap1decal", "targetname");
	bomb = getEnt("trap1bomb","targetname");
	o = spawn("script_origin", bomb.origin );
	a hide();
	decal hide();
	hurt maps\mp\_utility::triggerOff();
	a moveZ(-200,1.5);
	wait 1.5;

	trig waittill("triggera", player);
	trig delete();
	a show();
	a moveZ(200,1.5);
	wait 3.5;
	bomb delete();
	decal show();
	hurt maps\mp\_utility::triggerOn();
	wait 1.5;
	hurt maps\mp\_utility::triggerOff();
	o delete();
	a moveZ(-200,1.5);
	wait 1.5;
	a hide();
}
trap2()
{
	level endon("triggerb");
    trig = getEnt("trig_trap2","targetname");
	a = getEnt("trap2","targetname");
	hurt = getEnt("trap2hurt","targetname");
	hurt maps\mp\_utility::triggerOff();
	a hide();
    trig waittill("triggerb", player);
	trig delete();
	a show();
	hurt maps\mp\_utility::triggerOn();
	hurt enableLinkTo();
	hurt linkTo(a);
	a moveZ(168,2);
	wait 6;
	a moveZ(-168,2);
	wait 2;
	hurt delete();
	a delete();
}

trap3()
{
	level endon("triggerc");
    trig = getEnt("trig_trap3","targetname");
	a = getEnt("trap3","targetname");
	w = getEnt("trap3warning","targetname");
	w hide();
	hurt = getEntArray("trap3hurt","targetname");
	a moveZ(-120,2);
	w moveZ(220,2);
	wait 2;
	for(i = 0; i < hurt.size; i++)
	{
		hurt[i] maps\mp\_utility::triggerOff();
	}
    trig waittill("triggerc", player);
	trig delete();
	for(i = 0; i < hurt.size; i++)
	{
		hurt[i] maps\mp\_utility::triggerOn();
	}
	w show();
	w moveZ(-220,1);
	a moveZ(120,1);
	wait 1;
}

trap4()
{
	level endon("triggerd");
    trig = getEnt("trig_trap4","targetname");
	a = getEntArray("trap4","targetname");
	trig setHintString("^5Spin their balls!");
    trig waittill("triggerd", player);
	trig delete();
	for(;;)
	{
		for(i = 0; i < a.size; i++)
		{
			a[i] thread trapRotator();
			wait 2;
		}
	}
}

trap5()
{
	level endon("triggere");
	a = getEnt("trap5a", "targetname");
	b = getEnt("trap5b", "targetname");
	c = getEnt("trap5c", "targetname");
	la = getEnt("trap5al", "targetname");
	lb = getEnt("trap5bl", "targetname");
	lc = getEnt("trap5cl", "targetname");
	ah = getEnt("trap5ahurt", "targetname");
	bh = getEnt("trap5bhurt", "targetname");
	ch = getEnt("trap5churt", "targetname");
	o_a = getEnt("trap5a", "targetname");
	o_b = getEnt("trap5b", "targetname");
	o_c = getEnt("trap5c", "targetname");
	trig = getEnt("trig_trap5", "targetname");
	
	ah maps\mp\_utility::triggerOff();
	bh maps\mp\_utility::triggerOff();
	ch maps\mp\_utility::triggerOff();
	
	la hide();
	la notSolid();
	lb hide();
	lb notSolid();
	lc hide();
	lc notSolid();
	
	o_as = spawn( "script_model", (o_a.origin - (0,0,180)) );
	o_as.angles = o_a.angles;
	o_as setModel( "tag_origin" );
	
	o_bs = spawn( "script_model", (o_b.origin - (0,0,180)) );
	o_bs.angles = o_b.angles;
	o_bs setModel( "tag_origin" );
	
	o_cs = spawn( "script_model", (o_c.origin - (0,0,180)) );
	o_cs.angles = o_c.angles;
	o_cs setModel( "tag_origin" );
	
	o_as rotateRoll(180,.1);
	o_bs rotateRoll(180,.1);
	o_cs rotateRoll(180,.1);
	wait .1;
	
	o_as linkTo(a);
	o_bs linkTo(b);
	o_cs linkTo(c);
	
	la linkTo(o_as);
	lb linkTo(o_bs);
	lc linkTo(o_cs);
	

	
	trig waittill("triggere", player);
	trig delete();
	
	
	ah maps\mp\_utility::triggerOn();
	bh maps\mp\_utility::triggerOn();
	ch maps\mp\_utility::triggerOn();
	
	ah enableLinkTo();
	bh enableLinkTo();
	ch enableLinkTo();
	
	ah linkTo(la);
	bh linkTo(lb);
	ch linkTo(lc);
	
	la show();
	lb show();
	lc show();

	
	a moveY(88, .75);
	b moveY(-88, .75);
	c moveY(88, .75);
	wait .8;
	
	for(;;)
	{
		a moveY(-176, 1.5);
		b moveY(176, 1.5);
		c moveY(-176, 1.5);
		wait 1.6;
		a moveY(176, 1.5);
		b moveY(-176, 1.5);
		c moveY(176, 1.5);
		wait 1.6;
	}
}

trap6()
{
	level endon("triggeradada");
    trig = getEnt("trig_trap6","targetname");
	a = getEntArray("trap6","targetname");
    trig waittill("triggeradada", player);
	trig delete();
	for(;;)
	{
		for(i = 0; i < a.size; i++)
		{
			a[i] thread trap6Rotator();
		}
		wait 18.2;
	}
}
trap6Rotator()
{
	self rotateYaw(720,9);
	wait 9.1;
	self rotateYaw(-720,9);
	wait 9.1;
}

traprotator()
{
	self rotateYaw(360, 1.5);
	wait 1.6;
	self rotateYaw(-360, 1.5);
	wait 1.6;
	self rotateYaw(360, 1.5);
	wait 1.6;
}

trap7()
{
	level endon("triggeradazfzda");
	brush = getEnt("trap7a", "targetname");
	brush2 = getEnt("trap7b", "targetname");
	trig = getEnt("trig_trap7", "targetname");
	
	
	trig waittill("triggeradazfzda", player);
	trig delete();
	for(;;)
	{
	brush moveZ(-1012, .9);
	wait 1.2;
	brush moveZ(1012, .9);
	wait 1.2;
	brush2 moveZ(-1012, .9);
	wait 1.2;
	brush2 moveZ(1012, .9);
	wait 1.2;
	}
}