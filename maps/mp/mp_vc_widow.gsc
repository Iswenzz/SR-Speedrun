main()
{
	maps\mp\_load::main();	

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((-512, 1152, 188), 270);

	//level.lava_fx=loadfx("vistic/blade_lava_ember_half");

	level.roomEntered=false;
    
	thread traps();
	//thread letters();
	//thread rooms();
	//thread createAmbient();
	//thread darkMode();
	//thread credits();
	//thread secret();

	addtriggertolist("trap1_trig");
	addtriggertolist("trap2_trig");
	addtriggertolist("trap3_trig");
	addtriggertolist("trap4_trig");
	addtriggertolist("trap5_trig");
	addtriggertolist("trap6_trig");
	addtriggertolist("trap7_trig");
	addtriggertolist("trap8_trig");
	addtriggertolist("trap9_trig");
	addtriggertolist("trap10_trig");
	addtriggertolist("trap11_trig");
	addtriggertolist("trap12_trig");
	addtriggertolist("trap13_trig");
}

createAmbient()
{
	snow=spawnfx(level.lava_fx,(-2152,-6168,-680));
	snow2=spawnfx(level.lava_fx,(-1016,-6168,-680));
	snow3=spawnfx(level.lava_fx,(136,-6152,-424));
	snow4=spawnfx(level.lava_fx,(136,-5144,-424));
	snow5=spawnfx(level.lava_fx,(136,-4120,-424));

	triggerfx(snow,-15);
	triggerfx(snow2,-15);
	triggerfx(snow3,-15);
	triggerfx(snow4,-15);
	triggerfx(snow5,-15);
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

darkMode()
{
	trig=getent("shadow_trig","targetname");
	trig sethintstring("Press ^1&&1 ^7for Shadows");

	trig waittill("trigger",player);
	iprintlnbold("Activator ^1"+player.name+"^7 activated the ^1Dark Mode^7!");

	for(;;)
	{
		wait .5;
		setexpfog(256,200,0,0,0,0.1);
	}
}

credits()
{
	level waittill("round_started");

	vc=randomint(7);
	if(vc==1||vc==3||vc==5)
		ambientplay("winter");
	else 
		ambientplay("shadow");

	wait 5;
	thread braxi\_mod::drawinformation(800,.8,1,"Vistic's Widow");
	wait 5;
	thread braxi\_mod::drawinformation(800,.8,1,"Created by VC' Blade");
}

traps()
{
	thread trap1();
	//thread trap2();
	//thread trap3();
	thread trap4();
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

trap1()
{
	trap=getent("trap1","targetname");
	trig=getent("trap1_trig","targetname");

	trap delete();
}

trap2()
{
	trapa=getent("trap2a","targetname");
	trapb=getent("trap2b","targetname");
	trig=getent("trap2_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	rdm=randomint(6);
	if(rdm==3||rdm==1||rdm==0)
		trapa delete();
	else 
		trapb delete();
}

trap3()
{
	trap=getent("trap3","targetname");
	trig=getent("trap3_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	trap movez(-200,2);
	wait 2;
	trap delete();
}

trap4()
{
	trap=getent("trap4","targetname");
	trig=getent("trap4_trig","targetname");
	hurt=getent("trap4_hurt","targetname");

	trap delete();
	hurt delete();
}

trap5()
{
	trapa=getent("trap5","targetname");
	trapb=getent("trap5b","targetname");
	trig=getent("trap5_trig","targetname");
	hurt=getent("trap5_hurt","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();
	trapa delete();

	hurt enablelinkto();
	hurt linkto(trapb);

	while(1)
	{
		trapb movey(-608,4);
		wait 4;
		trapb movey(608,4);
		wait 4;
	}
}

trap6()
{
	trapa=getent("trap6a","targetname");
	trapb=getent("trap6b","targetname");
	trig=getent("trap6_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	trapa movex(-144,2);
	trapb movex(144,2);
	wait 2;

	while(1)
	{
		trapa movex(320,4);
		trapb movex(-320,4);
		wait 4;
		trapa movex(-320,4);
		trapb movex(320,4);
		wait 4;
	}
}

trap7()
{
	trapa=getent("trap7a","targetname");
	trapb=getent("trap7b","targetname");
	trig=getent("trap7_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trapa rotatepitch(360,2);
		wait 2;
		trapb rotatepitch(360,2);
		wait 2;
	}
}

trap8()
{
	trapa=getent("trap8a","targetname");
	trapb=getent("trap8b","targetname");
	trig=getent("trap8_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	rdm=randomint(6);
	if(rdm==3||rdm==1||rdm==0)
		trapa delete();
	else 
		trapb delete();
}

trap9()
{
	trap=getent("trap9","targetname");
	trig=getent("trap9_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap notsolid();
		trap hide();
		wait 4;
		trap solid();
		trap show();
		wait 6;
	}
}

trap10()
{
	trap=getent("trap10a","targetname");
	trig=getent("trap10_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	thread trap10b();

	while(1)
	{
		trap rotatepitch(360,2);
		wait 2;
		trap rotateroll(360,2);
		wait 2;
		trap rotateyaw(360,2);
		wait 2;
	}
}
trap10b()
{
	trap=getent("trap10b","targetname");
	while(1)
	{
		trap rotatepitch(360,2);
		wait 2;
	}
}

trap11()
{
	trap=getent("trap11","targetname");
	trig=getent("trap11_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	trap movez(-200,2);
	wait 2;
	trap delete();
}

trap12()
{
	trapa=getent("trap12a","targetname");
	trapb=getent("trap12b","targetname");
	trapc=getent("trap12c","targetname");
	trapd=getent("trap12d","targetname");
	trape=getent("trap12e","targetname");
	trig=getent("trap12_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	rmd=randomint(5);
	if(rmd==0)
	{
		trapb delete();
		trapc delete();
		trapd delete();
		trape delete();
	}
	else if(rmd==1)
	{
		trapa delete();
		trapc delete();
		trapd delete();
		trape delete();
	}
	else if(rmd==2)
	{
		trapb delete();
		trapa delete();
		trapd delete();
		trape delete();
	}
	else if(rmd==3)
	{
		trapb delete();
		trapc delete();
		trapa delete();
		trape delete();
	}
	else if(rmd==4)
	{
		trapb delete();
		trapc delete();
		trapd delete();
		trapa delete();
	}
}

trap13()
{
	trap=getent("trap13","targetname");
	trig=getent("trap13_trig","targetname");

	trig sethintstring("Press ^1&&1 ^7to activate");
	trig waittill("trigger");
	trig delete();

	trap movez(-200,2);
	wait 2;
	trap delete();
}

letters()
{
	letter_l=getent("letter_l","targetname");
	letter_s=getent("letter_s","targetname");
	letter_k=getent("letter_k","targetname");

	letter_s thread hover();
	letter_k thread hover();
	letter_l thread hover();

	while(1)
	{
		letter_s rotateyaw(720,5);
		letter_k rotateyaw(720,5);
		letter_l rotateyaw(720,5);
		wait 2;
	}
}

hover()
{
	self notsolid();
	while(isdefined(self))
	{
		self movez(10,2);
		self waittill("movedone");
		self movez(-10,2);
		self waittill("movedone");
	}
}

rooms()
{
	thread sniper();
	thread knife();
	thread lava();
}

sniper()
{
    level.sniper=getent("sniper","targetname");
    acti=getent("sniper_acti","targetname");
    jump=getent("sniper_jump","targetname");

    while(1)
    {
    	level.sniper sethintstring("Enter ^1Sniper ^7End");
        level.sniper waittill("trigger",player);
        if(!isdefined(level.sniper))
            return;

	

        level.sniper sethintstring("Wait your ^1Turn");

        if(!level.roomEntered)
        {
            level.roomEntered=true;
            thread announces(player.name+" choosed Sniper End",260);            
            level.knife delete();
            level.lava delete();
            thread sniper_fx();
        }

        if(isdefined(level.activ))
        {
        	player endroomsetup(jump.origin,jump.angles,"m40a3_mp","remington700_mp",1);
	        level.activ endroomsetup(acti.origin,acti.angles,"m40a3_mp","remington700_mp",1);
	        thread room_msg(player.name+" vs "+level.activ.name);
	        wait 5;
	        player countdown();
	        level.activ countdown();
        }
        else 
        	iprintln("^1no activator defined");

        while(isalive(player)&&isdefined(player))
            wait 1;

        iprintln("^1"+player.name+"^7 has been killed");
        level.sniper sethintstring("Enter ^1Sniper ^7End");
    }
}

sniper_fx()
{
	snip_fx1=spawnfx(level.lava_fx,(-2168,-3784,-856));
	snip_fx2=spawnfx(level.lava_fx,(-1160,-3784,-856));

	triggerfx(snip_fx1,-15);
	triggerfx(snip_fx2,-15);
}

knife()
{
    level.knife=getent("knife","targetname");
    acti=getent("knife_acti","targetname");
    jump=getent("knife_jump","targetname");

    while(1)
    {
		level.knife sethintstring("Enter ^1Knife ^7End");
        level.knife waittill("trigger",player);
        if(!isdefined(level.knife))
            return;

	

        level.knife sethintstring("Wait your ^1Turn");

        if(!level.roomEntered)
        {
            level.roomEntered=true;
            thread announces(player.name+" choosed Knife End",260);
            level.sniper delete();
            level.lava delete();
            thread knife_fx();
        }

        if(isdefined(level.activ))
        {
	        player endroomsetup(jump.origin,jump.angles,"knife_mp",undefined,1);
	        level.activ endroomsetup(acti.origin,acti.angles,"knife_mp",undefined,1);
	        thread room_msg(player.name+" vs "+level.activ.name);
	        wait 5;
	        player countdown();
	        level.activ countdown();
        }
        else 
        	iprintln("^1no activator defined");

        while(isalive(player)&&isdefined(player))
            wait 1;

        iprintln("^1"+player.name+"^7 has been killed");
        level.sniper sethintstring("Enter ^1Knife ^7End");
    }
}

knife_fx()
{
	knife_fx1=spawnfx(level.lava_fx,(-1656,-3784,-808));

	triggerfx(knife_fx1,-15);
}

lava()
{
    level.lava=getent("lava","targetname");
    acti=getent("lava_acti","targetname");
    jump=getent("lava_jump","targetname");

    while(1)
    {
		level.lava sethintstring("Enter ^1Lava ^7End");
        level.lava waittill("trigger",player);
        if(!isdefined(level.lava))
            return;

	

        level.lava sethintstring("Wait your ^1Turn");

        if(!level.roomEntered)
        {
            level.roomEntered=true;
            thread announces(player.name+" choosed Lava End",260);
            level.sniper delete();
            level.knife delete();
            thread lava_fx();
        }

        //if(isdefined(level.activ))
        //{
        	player endroomsetup(jump.origin,jump.angles,"g36c_gl_mp",undefined,1);
	        level.activ endroomsetup(acti.origin,acti.angles,"g36c_gl_mp",undefined,1);
	        thread room_msg(player.name+" vs "+level.activ.name);
	        wait 5;
	        player countdown();
	        level.activ countdown();
	        wait 2;
	        thread lava_rise();
        //}
        //else 
        //	iprintln("^1no activator defined");

        while(isalive(player)&&isdefined(player))
            wait 1;

        iprintln("^1"+player.name+"^7 has been killed");
        level.sniper sethintstring("Enter ^1Lava ^7End");
    }
}

lava_fx()
{
	snip_fx1=spawnfx(level.lava_fx,(-2200,-4808,-856));
	snip_fx2=spawnfx(level.lava_fx,(-1128,-4824,-856));

	triggerfx(snip_fx1,-15);
	triggerfx(snip_fx2,-15);
}

lava_rise()
{
	lava=getent("lava_run_brush","targetname");
	kill=getent("lava_run_kill","targetname");

	iprintlnbold("The ^1Lava^7 starts to rise! Hurry up!");
	kill enablelinkto();
	kill linkto(lava);

	lava movez(336,15);
	wait 15;
	kill enablelinkto();
	kill linkto(lava);
	lava movez(-336,2);
}

endroomsetup(origin,angles,weap,weap2,freeze)
{
    self setorigin(origin);
    self setplayerangles(angles);

    self takeallweapons();
    self giveweapon(weap);
    if(isdefined(weap2))
        self giveweapon(weap2);
    self switchtoweapon(weap);

    self freezecontrols(freeze);
}

countdown()
{
    self iprintlnbold("^13");
    wait 1;
    self iprintlnbold("^12");
    wait 1;
    self iprintlnbold("^11");
    wait 1;
    for(i=0;i<5;i++)
    self iprintlnbold("");
    self freezecontrols(0);
}

room_msg(text)
{
    announce=addTextHud(level,320,280,0,"center","middle",2.4);
    announce settext(text);
    announce.glowcolor=level.randomcolor;
    announce.glowalpha=1;
    announce.alpha = 1;
    announce setpulsefx(30,100000,700);
    wait 3;
    announce destroy();
}

announces(msg,pos)
{
    announce=addTextHud(level,320,pos,0,"center","middle",2.4);
    announce settext(msg);
    announce.glowcolor=level.randomcolor;
    announce.glowalpha=1;
    announce.alpha = 1;
    announce setpulsefx(30,100000,700);
    wait 4;
    announce destroy();
}

addTextHud( player, x, y, alpha, alignX, alignY, fontScale )
{
    if( isPlayer( player ) )
        hud = newClientHudElem( player );
    else
        hud = newHudElem();

    hud.x = x;
    hud.y = y;
    hud.alpha = alpha;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.fontScale = fontScale;
    return hud;
}

secret()
{
	thread secret_open();
	thread secret_teleport();
	thread secret_leave();
	thread secret_speedup();
}

secret_speedup()
{
    trig = getEnt("secret_trig_1", "targetname");
    ori = getEnt(trig.target, "targetname");
    while(1)
    {
        trig waittill("trigger", man);
        man setOrigin(ori.origin);
        wait 0.05;
    }
}

secret_open()
{
	trig_s1=getent("secret_open_trig","targetname");
	trig_s2=getent("secret_open_dmg","targetname");
	brush=getent("secret_what","targetname");
	door=getent("secret_door","targetname");
	brush notsolid();

	trig_s1 waittill("trigger",player);
	trig_s1 delete();
	player iprintlnbold("^1Something^7 unlocked?!");
	trig_s2 waittill("trigger",player);
	trig_s2 delete();
	iprintlnbold("^1"+player.name+"^7 opened the Secret!");

	earthquake(0.4,3,door.origin,500);
	wait 3;
	door delete();
}

secret_teleport()
{
    trig=getent("secret_teleport","targetname");
    targ=getent("secret_in","targetname");
    for(;;)
    {
        trig waittill("trigger",player);
        player setorigin(targ.origin);
        player setplayerangles(targ.angles);
    }
}

secret_leave()
{
    trig=getent("secret_leave","targetname");
    targ=getent("secret_out","targetname");

    for(;;)
    {
    trig sethintstring("Press ^1&&1 ^7to finish Secret");
    trig waittill("trigger",player);

    player thread sr\api\_speedrun::finishWay("secret_0");

    }
}
