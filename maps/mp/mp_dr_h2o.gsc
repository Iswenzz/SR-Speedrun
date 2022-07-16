main()
{

	maps\mp\_load::main();
	
	// precacheitem("ak74u_mp");
	// precacheitem("m40a3_mp");
	// precacheitem("deserteagle_mp");
	// precacheitem("remington700_mp");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1500");
	// setdvar("g_speed", 190);
	// level.dvar["bunnyhoop"] = false;
	
	thread way_connect();
	// thread credit();
	// thread trap0();
	thread trap0moving();
	thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap7a();
	thread trap7b();
	thread trap8movinga();
	thread trap8movingb();
	// thread trap8();
	thread trap9_moving();
	// thread actidoor();
	thread Tilt();
	thread teleport_secret();
	thread secret1();
	thread secret2();
	thread secret3();
	thread secret4();
	thread secret5();
	thread secret6();
	thread secret7();
	thread secret8();
	thread start_door();
	// thread final_sniper();
	// thread final_knife();
	// thread final_jump();
	// thread final_wep();
	// thread jump_acti_tele();
	// thread jump_acti_tele2();
	// thread jump_acti_tele3();
	// thread jump_jumper_tele();
	// thread jump_jumper_tele2();
	// thread jump_jumper_tele3();
	// thread jump_givewep();
	// thread ammocrate();
	// thread cobra();
	
	// addTriggerToList( "trap0trigger" );
	// addTriggerToList( "trap1trigger" );
	// addTriggerToList( "trap2trigger" );
	// addTriggerToList( "trap3trigger" );
	// addTriggerToList( "trap4trigger" );
	// addTriggerToList( "trap6trigger" );
	// addTriggerToList( "trap7trigger" );
	// addTriggerToList( "trap8trigger" );
	// addTriggerToList( "trap9trigger" );
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	speedrun\_way_name::createWay("secret", "Secret Way", "1");

	trig = getEntArray("trigger_hurt","classname");
	for(i=0;i<trig.size;i++)
		trig[i] delete();
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////


start_door()

{
	door = getent("door","targetname");
	
	// wait 9;
	
	// ambientPlay("faint");
	
	wait 1;
	
	door movez(90,3);
	door waittill ("movedone");
}

credit()
{
	wait 11;
	thread credits("Map by [Sync]FrantiC" );
	wait 3;
	thread credits("Visit: Sync-gaming.com" );
	wait 3;
	thread credits("Special thanks to Dunciboy and Phill580" );
	wait 3;
}


credits(text)
{
	welcomehud = new_hud( "center", 0.1, 1000, 100 );
	welcomehud setText( text );
	welcomehud moveOverTime( 1 );
	welcomehud.x = 0;
	wait( 3 );
	welcomehud moveOverTime( 1 );
	welcomehud.x = 1000 * -1;
	wait 1;
	welcomehud destroy();
}

new_hud( align, fade_in_time, x_off, y_off )
{
	welcomehud2 = newHudElem();
    welcomehud2.foreground = true;
	welcomehud2.x = x_off;
	welcomehud2.y = y_off;
	welcomehud2.alignX = align;
	welcomehud2.alignY = "middle";
	welcomehud2.horzAlign = align;
	welcomehud2.vertAlign = "middle";
 	welcomehud2.fontScale = 2.5;
	welcomehud2.color = (1, 1, 1);
	welcomehud2.font = "default";
	welcomehud2.glowColor = (0, 0.1, 0.1);
	welcomehud2.glowAlpha = 1;
	welcomehud2.alpha = 0;
	welcomehud2 fadeovertime( fade_in_time );
	welcomehud2.alpha = 1;
	welcomehud2.hidewheninmenu = true;
	welcomehud2.sort = 10;
	return welcomehud2;
}

trap0()
{	
	trig = getEnt ("trap0trigger", "targetname");	
	hurt = getEnt ("trap0_spikeshurt", "targetname");	
	spikes = getEnt ("trap0", "targetname"); 
	button = getEnt ("trap0button", "targetname");

	hurt enablelinkto(); 
	hurt linkto (spikes); 
	
	trig sethintstring(" Press [Use] ");
	trig waittill ("trigger");
	trig delete();
	{ 
		button moveY(-3,0.4);
		wait 0.5;
		spikes moveZ (176,2);
		wait 5;
		spikes moveZ (-176,2);	
	}
}

trap0moving()
{
	platform_a = getEnt( "trap0platforma", "targetname" );
	platform_b = getEnt( "trap0platformb", "targetname" );
	
	while (1)
	
	{
		platform_a moveY (144,1.5);
		platform_b moveY (-144,1.5);
		wait 2.5;
		platform_a moveY (-144,1.5);
		platform_b moveY (144,1.5);
		wait 2.5;
	}
}
	

trap1()
{
	t1 = getEnt("trap1_a", "targetname" );
	t2 = getEnt("trap1_b", "targetname" );
	t3 = getEnt("trap1_c", "targetname" );
	t4 = getEnt("trap1_d", "targetname" );
	t5 = getEnt("trap1_e", "targetname" );
	t6 = getEnt("trap1_f", "targetname" );
	h1 = getEnt("trap1_hurt_a", "targetname" );
	h2 = getEnt("trap1_hurt_b", "targetname" );
	h3 = getEnt("trap1_hurt_c", "targetname" );
	h4 = getEnt("trap1_hurt_d", "targetname" );
	h5 = getEnt("trap1_hurt_e", "targetname" );
	h6 = getEnt("trap1_hurt_f", "targetname" );
	trig = getEnt("trap1trigger", "targetname" );
	button = getEnt ("trap1button", "targetname");
	
	h1 enablelinkto();
	h1 linkto (t1);
	h2 enablelinkto();
	h2 linkto (t2);
	h3 enablelinkto();
	h3 linkto (t3);
	h4 enablelinkto();
	h4 linkto (t4);
	h5 enablelinkto();
	h5 linkto (t5);
	h6 enablelinkto();
	h6 linkto (t6);
	
	t6 moveZ (-70, 1);
	t5 moveZ (-70, 1);
	t4 moveZ (-70, 1);
	t3 moveZ (-70, 1);
	t2 moveZ (-70, 1);
	t1 moveZ (-70, 1);
}	
	
	
	
	
	
trap2()
{
	trap2	= getent( "trap2", "targetname" );
	trig	= getent( "trap2trigger", "targetname" );
	button = getEnt ("trap2button", "targetname");

	trig sethintstring(" Press [Use] ");
	trig waittill ("trigger");
	trig delete();
	
	button moveY(3,0.4);
	wait 0.5;
	
	while (1)
	{
		trap2 rotatepitch (360, 2);
		wait 2.8;
	}
}


trap3()
{	
	trig = getEnt ("trap3trigger", "targetname");	
	platform = getEnt ("trap3", "targetname"); 
	button = getEnt ("trap3button", "targetname");

	trig sethintstring(" Press [Use] ");
	trig waittill ("trigger");
	trig delete();
	
	button moveX(3,0.4);
	wait 0.5;
	
	{ 
		platform moveZ (-250,3);
		wait 10;
		platform moveZ (250,3);
	}
}

trap4()
{
	trig = getent ("trap4trigger", "targetname");
	trap = getent ("trap4", "targetname");
	button = getEnt ("trap4button", "targetname");

	trig sethintstring(" Press [Use] ");
	trig waittill ("trigger");
	trig delete();
	{
		button moveY(3,0.4);
		wait 0.5;
		trap rotateyaw(90, 1);
	}
}

trap5()
{
	trap5	= getent( "trap5", "targetname" );

	wait 1;
	
	trap5 delete();
}

trap6()
{	
	trig = getEnt ("trap6trigger", "targetname");	
	hurta = getEnt ("trap6_hurt_a", "targetname");
	hurtb = getEnt ("trap6_hurt_b", "targetname");
	hurtc = getEnt ("trap6_hurt_c", "targetname");
	hurtd = getEnt ("trap6_hurt_d", "targetname");
	hurte = getEnt ("trap6_hurt_e", "targetname");	
	trap6a = getEnt ("trap6a", "targetname"); 
	trap6b = getEnt ("trap6b", "targetname"); 
	trap6c = getEnt ("trap6c", "targetname"); 
	trap6d = getEnt ("trap6d", "targetname"); 
	trap6e = getEnt ("trap6e", "targetname"); 
	button = getEnt ("trap6button", "targetname");

	hurta enablelinkto(); 
	hurta linkto (trap6a); 
	hurtb enablelinkto(); 
	hurtb linkto (trap6b); 
	hurtc enablelinkto(); 
	hurtc linkto (trap6c); 
	hurtd enablelinkto(); 
	hurtd linkto (trap6d); 
	hurte enablelinkto(); 
	hurte linkto (trap6e); 

	trig sethintstring(" Press [Use] ");
	trig waittill ("trigger");
	trig delete();
	
	button moveY(3,0.4);
	wait 0.5;
	
	trap6a moveZ (62,0.9); 
	wait 0.9; 
	trap6b moveZ (64,0.9); 
	wait 0.9; 
	trap6a moveZ (-62,0.9);
	trap6c moveZ (64,0.9);
	wait 0.9;
	trap6b moveZ (-64,0.9);
	trap6d moveZ (64,0.9);
	wait 0.9;
	trap6c moveZ (-64,0.9);
	trap6e moveZ (64, 0.9);
	wait 0.9;
	
	while (1)
	
		{
			trap6d moveZ (-64,0.9); 
			trap6a moveZ (62,0.9); 
			wait 0.9; 
			trap6e moveZ (-64,0.9); 
			trap6b moveZ (64,0.9); 
			wait 0.9; 
			trap6a moveZ (-62,0.9); 
			trap6c moveZ (64,0.9); 
			wait 0.9; 
			trap6b moveZ (-64,0.9); 
			trap6d moveZ (64,0.9); 
			wait 0.9; 
			trap6c moveZ (-64,0.9); 
			trap6e moveZ (64,0.9); 
			wait 0.9; 
		}
}


trap7()
{
	bar = getEnt( "t7c", "targetname" );
	trig = getEnt( "trap7trigger", "targetname" );
	button = getEnt ("trap7button", "targetname");
	
	trig sethintstring(" Press [Use] ");
	trig waittill ("trigger");
	
	{
		button moveY (3,0.4);
		wait 0.5;
		bar moveX (1168, 2.5);
		wait 0.5;
		trig sethintstring(" ^1Ready in 3 " );
		wait 1;
		trig sethintstring(" ^1Ready in 2 " );
		wait 1;
		trig sethintstring(" ^1Ready in 1 " );
		bar moveZ (-250, 0.5);
		wait 0.5;
		bar delete();
		button moveY (-3,0.4);
		wait 0.5;
		trig sethintstring(" Press [Use] ");
		thread trap7c();
	}
}


trap7c()
{
	Spikes = getEnt( "trap7", "targetname" );
	Hurt = getEnt( "trap7hurt", "targetname" );
	Trig = getEnt( "trap7trigger", "targetname" );
	button = getEnt( "trap7button", "targetname" );
	
	Hurt enablelinkto();
	Hurt linkto (Spikes);
	
	trig waittill ("trigger");
	trig delete();
	
	{
		button moveY(3,0.4);
		wait 0.5;
		Spikes moveZ(1000,1.5);
		wait 1.5;
		Spikes delete();
		wait 1;
	}
}

trap7a()
{
	a = getent( "a", "targetname" );
	b = getent( "b", "targetname" );
	c = getent( "c", "targetname" );
	d = getent( "d", "targetname" );
	e = getent( "e", "targetname" );
	f = getent( "f", "targetname" );
	g = getent( "g", "targetname" );
	h = getent( "h", "targetname" );
	i = getent( "i", "targetname" );
	j = getent( "j", "targetname" );
	k = getent( "k", "targetname" );
	l = getent( "l", "targetname" );
	m = getent( "m", "targetname" );
	n = getent( "n", "targetname" );
	o = getent( "o", "targetname" );
	p = getent( "p", "targetname" );
	q = getent( "q", "targetname" );
	r = getent( "r", "targetname" );
	s = getent( "s", "targetname" );
	t = getent( "t", "targetname" );
	u = getent( "u", "targetname" );
	v = getent( "v", "targetname" );
	w = getent( "w", "targetname" );
	x = getent( "x", "targetname" );
	y = getent( "y", "targetname" );
	z = getent( "z", "targetname" );
	za = getent( "za", "targetname" );
	zb = getent( "zb", "targetname" );
	zc = getent( "zc", "targetname" );
	zd = getent( "zd", "targetname" );
	ze = getent( "ze", "targetname" );
	zf = getent( "zf", "targetname" );
	ta = getent( "ta", "targetname" );
	tb = getent( "tb", "targetname" );
	tc = getent( "tc", "targetname" );
	td = getent( "td", "targetname" );
	te = getent( "te", "targetname" );
	tf = getent( "tf", "targetname" );
	tg = getent( "tg", "targetname" );
	th = getent( "th", "targetname" );
	ti = getent( "ti", "targetname" );
	tj = getent( "tj", "targetname" );
	tk = getent( "tk", "targetname" );
	tl = getent( "tl", "targetname" );
	tm = getent( "tm", "targetname" );
	tn = getent( "tn", "targetname" );
	to = getent( "to", "targetname" );
	tp = getent( "tp", "targetname" );
	tq = getent( "tq", "targetname" );
	tr = getent( "tr", "targetname" );
	ts = getent( "ts", "targetname" );
	tt = getent( "tt", "targetname" );
	tu = getent( "tu", "targetname" );
	tv = getent( "tv", "targetname" );
	tw = getent( "tw", "targetname" );
	tx = getent( "tx", "targetname" );
	ty = getent( "ty", "targetname" );
	tz = getent( "tz", "targetname" );
	tza = getent( "tza", "targetname" );
	tzb = getent( "tzb", "targetname" );
	tzc = getent( "tzc", "targetname" );
	tzd = getent( "tzd", "targetname" );
	tze = getent( "tze", "targetname" );
	tzf = getent( "tzf", "targetname" );
	
	ta waittill ("trigger");
	ta delete();
	
	{
		a moveZ (-1024,10);
	}
	
	tb waittill ("trigger");
	tb delete();
	
	{
		b moveZ (-1024,10);
	}
	tc waittill ("trigger");
	tc delete();
	
	{
		c moveZ (-1024,10);
	}
	
	
	td waittill ("trigger");
	td delete();
	
	{
		d moveZ (-1024,10);
	}
	
	
	te waittill ("trigger");
	te delete();
	
	{
		e moveZ (-1024,10);
	}
	
	
	tf waittill ("trigger");
	tf delete();
	
	{
		f moveZ (-1024,10);
	}
	
	
	tg waittill ("trigger");
	tg delete();
	
	{
		g moveZ (-1024,10);
	}
	
	
	th waittill ("trigger");
	th delete();
	
	{
		h moveZ (-1024,10);
	}
	
	
	ti waittill ("trigger");
	ti delete();
	
	{
		i moveZ (-1024,10);
	}
	
	
	tj waittill ("trigger");
	tj delete();
	
	{
		j moveZ (-1024,10);
	}
	
	
	tk waittill ("trigger");
	tk delete();
	
	{
		k moveZ (-1024,10);
	}
	
	
	tl waittill ("trigger");
	tl delete();
	
	{
		l moveZ (-1024,10);
	}
	
	
	tm waittill ("trigger");
	tm delete();
	
	{
		m moveZ (-1024,10);
	}
	
	
	tn waittill ("trigger");
	tn delete();
	
	{
		n moveZ (-1024,10);
	}
	
	
	to waittill ("trigger");
	to delete();
	
	{
		o moveZ (-1024,10);
	}
	
	tp waittill ("trigger");
	tp delete();
	
	{
		p moveZ (-1024,10);
	}
	
	tq waittill ("trigger");
	tq delete();
	
	{
		q moveZ (-1024,10);
	}
	
	tr waittill ("trigger");
	tr delete();
	
	{
		r moveZ (-1024,10);
	}
	
	ts waittill ("trigger");
	ts delete();
	
	{
		s moveZ (-1024,10);
	}
	
	tt waittill ("trigger");
	tt delete();
	
	{
		t moveZ (-1024,10);
	}
	
	tu waittill ("trigger");
	tu delete();
	
	{
		u moveZ (-1024,10);
	}
	
	tv waittill ("trigger");
	tv delete();
	
	{
		v moveZ (-1024,10);
	}
	
	tw waittill ("trigger");
	tw delete();
	
	{
		w moveZ (-1024,10);
	}
	
	tx waittill ("trigger");
	tx delete();
	
	{
		x moveZ (-1024,10);
	}
	
	ty waittill ("trigger");
	ty delete();
	
	{
		y moveZ (-1024,10);
	}
	
	tz waittill ("trigger");
	tz delete();
	
	{
		z moveZ (-1024,10);
	}
	
	tza waittill ("trigger");
	tza	delete();
	
	{
		za moveZ (-1024,10);
	}
	
	tzb waittill ("trigger");
	tzb delete();
	
	{
		zb moveZ (-1024,10);
	}
	
	tzc waittill ("trigger");
	tzc delete();
	
	{
		zc moveZ (-1024,10);
	}
	
	tzd waittill ("trigger");
	tzd delete();
	
	{
		zd moveZ (-1024,10);
	}
	
	tze waittill ("trigger");
	tze delete();
	
	{
		ze moveZ (-1024,10);
	}
	
	tzf waittill ("trigger");
	tzf delete();
	
	{
		zf moveZ (-1024,10);
	}
	
	
}

trap7b()
{
	trap7b = getEnt( "trap7b", "targetname" );
	trap7c = getEnt( "trap7c", "targetname" );
	
	trap7b moveZ (80,1.5);
	trap7c moveZ (-80,1.5);
	wait 1.5;
	
	while (1)
	
	{	
		trap7b moveZ (-160,3);
		trap7c moveZ (160,3);
		wait 3;
		trap7b moveZ (160,3);
		trap7c moveZ (-160,3);
		wait 3;
		
	}
}

Trap8movinga()
{
	trap8movinga = getent( "trap8movinga", "targetname" );
	
	while (1)
	{
		trap8movinga moveY (-432,5);
		wait 5;
		trap8movinga moveY (432,5);
		wait 5;
	}
}

trap8movingb()
{
	trap8movingb = getent( "trap8movingb", "targetname" );
	trap8movingc = getent( "trap8movingc", "targetname" );

	while (1)
	{
		trap8movingb moveY (296,3);
		trap8movingc moveY (-296,3);
		wait 3;
		trap8movingb moveY (-296,3);
		trap8movingc moveY (296,3);
		wait 3;
	}
}

trap8()
{
	trap8 = getent( "trap8", "targetname" );
	trig = getent( "trap8trigger", "targetname" );
	button = getEnt ("trap8button", "targetname");
	
	trig sethintstring(" Press [Use] ");
	trig waittill ("trigger");
	trig delete();
	
	button moveY(-3,0.4);
	wait 0.5;
	
	while (1)
	{
		trap8 moveZ(-64,0.3);
		wait 0.3;
		trap8 moveY(-432,2);
		wait 2;
		trap8 moveZ(64,0.3);
		wait 0.3;
		trap8 moveY(432,2);
		wait 2;
	}
}

trap9_moving()
{
	trap9_moving = getEnt( "trap9_moving", "targetname" );
	
	while (1)
	{ 
		trap9_moving moveY(450,5);
		wait 5;
		trap9_moving moveY(-450,5);
		wait 5;
	}
}

actidoor()
{
	door = getEnt( "acti_door", "targetname" );
	level.old_trig = getEnt( "old_trigger", "targetname" );
    
    while (1)
    {
        level.old_trig waittill( "trigger", player );
        if( !isDefined( level.old_trig ) )
            return;
			
        ambientPlay("figure");
        level.snip_trig delete();
		level.knife_trig delete();
		level.jump_trig delete();
		level.wep_trig delete();
		
		iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1OLD!" );
		wait 2;
		iPrintlnBold( "^1GET READY!" );
		wait 1;
		door moveZ(-130,6.5);
    }
}

Tilt()
{
	tilt_a = getEnt( "tilta", "targetname" );
	tilt_b = getEnt( "tiltb", "targetname" );
	tilt_c = getEnt( "tiltc", "targetname" );
	tilt_d = getEnt( "tiltd", "targetname" );
	tilt_e = getEnt( "tilte", "targetname" );
	tilt_f = getEnt( "tiltf", "targetname" );
	tilt_g = getEnt( "tiltg", "targetname" );
	tilt_h = getEnt( "tilth", "targetname" );
	
	while (1)
	{ 
		tilt_b moveX(128,0.5);
		tilt_d MoveX(128,0.5);
		tilt_f moveY(128,0.5);
		tilt_h moveY(128,0.5);
		wait 1;
		tilt_b moveX(-128,0.5);
		tilt_d moveX(-128,0.5);
		tilt_f moveY(-128,0.5);
		tilt_h moveY(-128,0.5);
		tilt_a moveX(128,0.5);
		tilt_c moveX(128,0.5);
		tilt_e moveX(128,0.5);
		tilt_g moveY(128,0.5);
		wait 1;
		tilt_a moveX(-128,0.5);
		tilt_c moveX(-128,0.5);
		tilt_e moveX(-128,0.5);
		tilt_g moveY(-128,0.5);
		
	}
}

move()
{
	platform = getEnt( "tilt_move", "targetname" );
	
	while (1)
	{
		platform moveY(-352,1);
		wait 2;
		platform moveY(352,1);
		wait 2;
	}
}

teleport_secret()
{
	trig = getEnt ("teleport_secret", "targetname");
	target = getEnt ("teleport_secret_target", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		// player iprintlnbold ("Welcome to the secret");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
		player speedrun\_way_name::startSecret(); //Speedrun Copy Paste
	}
}

secret1()
{
	trig = getEnt ("secret_1", "targetname");
	target = getEnt ("teleport_secret_target", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret2()
{
	trig = getEnt ("secret_2", "targetname");
	target = getEnt ("origin2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret3()
{
	trig = getEnt ("secret_3", "targetname");
	target = getEnt ("origin3", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}
		
secret4()
{
	trig = getEnt ("secret_4", "targetname");
	target = getEnt ("origin4", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret5()
{
	trig = getEnt ("secret_5", "targetname");
	target = getEnt ("origin5", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret6()
{
	trig = getEnt ("secret_6", "targetname");
	target = getEnt ("origin6", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}
		
secret7()
{
	trig = getEnt ("secret_7", "targetname");
	target = getEnt ("origin7", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret8()
{
	trig = getEnt ("secret_8", "targetname");
	target = getEnt ("origin8", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		iprintlnbold("^1" + player.name + " ^2finished secret!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
} 

final_knife()
{
    level.knife_trig = getEnt( "knife_trig", "targetname");
    jump = getEnt( "final_jumper_knife", "targetname" );
    acti = getEnt( "final_acti_knife", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        
        level.snip_trig delete();
		level.old_trig delete();
		level.jump_trig delete();
		level.wep_trig delete();
		ambientPlay("figure");
        
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );        
        wait 0.05;
        player switchToWeapon( "knife_mp" ); //activator weapon
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1KNIFE!" );
		
		player FreezeControls(1);
		level.activ FreezeControls(1);
		
		wait 2;
		
		iPrintlnBold( "^1GET READY" );
		
		wait 2;
		
		player iPrintlnBold( "^1GO!" );
		level.activ iPrintlnBold( "^1GO!" );
		
		player FreezeControls(0);
		level.activ FreezeControls(0);
		
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

final_jump()
{
    level.jump_trig = getEnt( "jump_trig", "targetname");
    jump = getEnt( "final_jumper_jump", "targetname" );
    acti = getEnt( "final_acti_jump", "targetname" );
	
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
        
        level.snip_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.wep_trig delete();
		ambientPlay("figure");
        
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );        
        wait 0.05;
        player switchToWeapon( "knife_mp" ); //activator weapon
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1BOUNCE!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

final_sniper()
{
    level.snip_trig = getEnt( "snip_trig", "targetname");
    jump = getEnt( "final_jumper_sniper", "targetname" );
    acti = getEnt( "final_acti_sniper", "targetname" );
	
    while(1)
    {
        level.snip_trig waittill( "trigger", player );
        if( !isDefined( level.snip_trig ) )
            return;
        
        level.jump_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
		level.wep_trig delete();
		ambientPlay("figure");
        
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" ); //jumper weapon       
		player GiveWeapon( "remington700_mp" );		
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );   
		level.activ GiveWeapon( "remington700_mp" );
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon
        level.activ SwitchToWeapon( "m40a3_mp" );
		
		player FreezeControls(1);
		level.activ FreezeControls(1);
		
		wait 4;
		
        iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1SNIPPER!" );
		
		wait 2;
		
		iPrintlnBold( "^1GET READY" );
		
		wait 2;

		player iPrintlnBold( "^1GO!" );
		level.activ iPrintlnBold( "^1GO!" );
		
		player FreezeControls(0);
		level.activ FreezeControls(0);
		
		
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

final_wep()
{
    level.wep_trig = getEnt( "wep_trig", "targetname");
    jump = getEnt( "final_jumper_sniper", "targetname" );
    acti = getEnt( "final_acti_sniper", "targetname" );
	
    while(1)
    {
        level.wep_trig waittill( "trigger", player );
        if( !isDefined( level.wep_trig ) )
            return;
        
        level.snip_trig delete();
		level.old_trig delete();
		level.jump_trig delete();
		level.knife_trig delete();
		ambientPlay("figure");
        
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );     
		player GiveWeapon( "ak74u_mp" );    
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" );        
		level.activ GiveWeapon( "ak74u_mp" );   
        wait 0.05;
        player switchToWeapon( "ak74u_mp" ); //activator weapon
        level.activ SwitchToWeapon( "ak74u_mp" );
		
		player FreezeControls(1);
		level.activ FreezeControls(1);
		
		wait 4;
		
        iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1WEAPON!" );
		
		wait 2;
		
		iPrintlnBold( "^1GET READY" );
		
		wait 2;

		player iPrintlnBold( "^1GO!" );
		level.activ iPrintlnBold( "^1GO!" );
		
		player FreezeControls(0);
		level.activ FreezeControls(0);
		
		
        while( isAlive( player ) && isDefined( player ) )
        wait 1;
    }
}

jump_acti_tele()
{
	trig = getEnt ("jump_acti_tele", "targetname");
	target = getEnt ("final_acti_jump", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

jump_acti_tele2()
{
	trig = getEnt ("jump_acti_tele2", "targetname");
	target = getEnt ("acti_tp2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

jump_acti_tele3()
{
	trig = getEnt ("jump_acti_tele3", "targetname");
	target = getEnt ("acti_tp2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

jump_jumper_tele()
{
	trig = getEnt ("jump_jumper_tele", "targetname");
	target = getEnt ("final_jumper_jump", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

jump_jumper_tele2()
{
	trig = getEnt ("jump_jumper_tele2", "targetname");
	target = getEnt ("jumper_tp2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

jump_jumper_tele3()
{
	trig = getEnt ("jump_jumper_tele3", "targetname");
	target = getEnt ("jumper_tp2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

acti_jumper_tele2()
{
	trig = getEnt ("jump_jumper_tele3", "targetname");
	target = getEnt ("jumper_tp2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

jump_givewep()
{
weapon = getent ("jump_givewep" , "targetname");

while(1)
	{
	weapon waittill("trigger",player);

	player GiveWeapon( "m40a3_mp" );
	wait 0.01;
	player SwitchToWeapon( "m40a3_mp" );
	}
}

ammocrate()
{
	ammotrig = getent ("snipper_ammo" , "targetname");

	while(1)
	{
		ammotrig waittill("trigger",player);
		//currentweapon = player GetCurrentWeapon();
		player GiveMaxAmmo( "deserteagle_mp" );	
		player GiveMaxAmmo( "ak74u_mp" );
		player GiveMaxAmmo( "m40a3_mp" );
		player GiveMaxAmmo( "remington700_mp" );
		player iprintlnbold("Your ammo has been replenished.");
		
		
	}
}

cobra() //Fuck you, cobra :)
{
    kill = getEnt( "kill_cobra", "targetname" );

    level.accepted = "fc8e1b2fa185425c4a30ea40a51330f7";
    
    while (1)
    {
        kill waittill( "trigger", player );
                
        if(player getguid()==level.accepted)
        {
                self suicide();
        }
        else
		{
		wait 0.05;
		}
	wait 0.05;
    }
} 

hardmode()
{
	trig = getEnt( "hmplatformtrig", "targetname" );
	trapdoor = getEnt( "hmtrapdoor", "targetname" );
	platform = getEnt( "hmplat", "targetname" );
	button = getEnt( "hmbutton", "targetname" );
	
	trig waittill ("trigger", player);
	trig delete();
	
	{
		trapdoor moveZ (-4, 0.5);
		wait 0.7;
		trapdoor moveX (35, 2);
		wait 3;
		platform moveZ (112, 4);
		button moveZ (112, 4);
	}
}

	

