// __/\\\________/\\\_______________________________________________________________________/\\\\\\\\\__/\\\\\\_________________________________        
//  _\/\\\_______\/\\\____________________________________________________________________/\\\////////__\////\\\_________________________________       
//   _\//\\\______/\\\___/\\\__________________/\\\_______/\\\___________________________/\\\/______________\/\\\_________________________________      
//   __\//\\\____/\\\___\///___/\\\\\\\\\\__/\\\\\\\\\\\_\///______/\\\\\\\\____________/\\\________________\/\\\_____/\\\\\\\\\_____/\\/\\\\\\___     
//    ___\//\\\__/\\\_____/\\\_\/\\\//////__\////\\\////___/\\\___/\\\//////____________\/\\\________________\/\\\____\////////\\\___\/\\\////\\\__    
//     ____\//\\\/\\\_____\/\\\_\/\\\\\\\\\\____\/\\\______\/\\\__/\\\___________________\//\\\_______________\/\\\______/\\\\\\\\\\__\/\\\__\//\\\_   
//      _____\//\\\\\______\/\\\_\////////\\\____\/\\\_/\\__\/\\\_\//\\\___________________\///\\\_____________\/\\\_____/\\\/////\\\__\/\\\___\/\\\_  
//       ______\//\\\_______\/\\\__/\\\\\\\\\\____\//\\\\\___\/\\\__\///\\\\\\\\______________\////\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\/\\_\/\\\___\/\\\_ 
//        _______\///________\///__\//////////______\/////____\///_____\////////__________________\/////////__\/////////___\////////\//__\///____\///__

/*
  _   ________   ___  __        __   
 | | / / ___( ) / _ )/ /__ ____/ /__ 
 | |/ / /__ |/ / _  / / _ `/ _  / -_)
 |___/\___/   /____/_/\_,_/\_,_/\__/ 

 © VC' Blade

*/

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
  	setDvar( "compassmaxrange", "1024" );

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_map::createSpawn((0, 224, 76), 270);

  	//level.bounceFX=loadfx("vistic/rainbowsparkles-medium");

  	thread misc();
  	thread traps();
  	//thread rooms();

  	addtriggertolist("trap1_trig");
  	addtriggertolist("trap2_trig");
  	addtriggertolist("trap3_trig");
  	addtriggertolist("trap4_trig");
  	addtriggertolist("trap5_trig");
  	addtriggertolist("trap6_trig");
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

misc()
{
	thread startdoor();
	//thread creator();
	//thread sniperfail();
	//thread jumpfail();
}

sniperfail()
{
	trig=getent("sniper_fail","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
	
		if(player.pers["team"]!="spectator")
		{
			if(player.pers["team"]=="allies")
			{
				player SetPlayerAngles(getent("snip_jump","targetname").angles);
				player SetOrigin(getent("snip_jump","targetname").origin);
			}
			if(player.pers["team"]=="axis")
			{
				player SetPlayerAngles(getent("snip_acti","targetname").angles);
				player SetOrigin(getent("snip_acti","targetname").origin);
			}
			player iprintln("^1Teleported");
		}
	}
}

jumpfail()
{
	trig=getent("jump_fail","targetname");
	for(;;)
	{
		trig waittill("trigger",player);
	
		if(player.pers["team"]!="spectator")
		{
			if(player.pers["team"]=="allies")
			{
				player SetPlayerAngles(getent("jump_jump","targetname").angles);
				player SetOrigin(getent("jump_jump","targetname").origin);
			}
			if(player.pers["team"]=="axis")
			{
				player SetPlayerAngles(getent("jump_acti","targetname").angles);
				player SetOrigin(getent("jump_acti","targetname").origin);
			}
			player iprintln("^1Teleported");
		}
	}
}

startdoor()
{
	trig=getent("start_trig","targetname");
	door=getent("startdoor","targetname");

	door delete();
}

creator()
{
	level waittill("round_started");
	 
	ambientplay("plat1");
		wait 2;
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "middle";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "middle";
		hud_clock.alpha = 1;
		hud_clock.x = 0;
		hud_clock.y = 0;
		hud_clock.fontscale = 2;
		hud_clock.glowalpha = 1;
		hud_clock.glowcolor = (0,1,1);
		hud_clock.label = &"Map by VC' Blur";
        hud_clock SetPulseFX( 40, 5400, 200 );
        wait 3;
}

traps()
{
	//thread trap1();
	//thread trap2();
	//thread trap3();
	thread trap4();
	//thread trap5();
	//thread trap6();
}

trap1()
{
	trig=getent("trap1_trig","targetname");
	trapa=getent("trap1a","targetname");
	trapb=getent("trap1b","targetname");
	trapc=getent("trap1c","targetname");

	trig setcursorhint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trapa rotatepitch(360,3);
		trapb rotateroll(360,3);
		trapc rotatepitch(-360,3);
		wait 3;
	}
}

trap2()
{
	trig=getent("trap2_trig","targetname");
	trapa=getent("trap2a","targetname");
	trapb=getent("trap2b","targetname");
	trapc=getent("trap2c","targetname");
	trapd=getent("trap2d","targetname");

	trig setcursorhint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig delete();

	switch(randomint(4))
	{
		case 0:
			trapb delete(); 
			trapc delete(); 
			trapd delete();
			break;
		case 1:
			trapa delete(); 
			trapc delete(); 
			trapd delete();
			break;
		case 2:
			trapb delete(); 
			trapa delete(); 
			trapd delete();
			break;
		case 3:
			trapb delete(); 
			trapc delete(); 
			trapa delete();
			break;
	}
}

trap3()
{
	trig=getent("trap3_trig","targetname");
	trapa=getent("trap3a","targetname");
	trapb=getent("trap3b","targetname");

	trig setcursorhint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig delete();

	trapa delete();
	trapb movey(-200,2);
	wait 2;

	while(1)
	{
		trapb movey(400,2);
		wait 3;
		trapb movey(-400,2);
		wait 3;
	}
}

trap4()
{
	trig=getent("trap4_trig","targetname");
	trapa=getent("trap4a","targetname");
	trapb=getent("trap4b","targetname");

    //trapa delete();
	trapb delete();

}

trap5()
{
	trig=getent("trap5_trig","targetname");
	trapa=getent("trap5a","targetname");
	trapb=getent("trap5b","targetname");

	trig setcursorhint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig delete();

	vc=randomint(10);
	if(vc==0||vc==3||vc==6||vc==9)
		trapa delete();
	else 
		trapb delete();
}

trap6()
{
	trig=getent("trap6_trig","targetname");
	trap=getent("trap6","targetname");

	trig setcursorhint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig delete();

	while(1)
	{
		trap rotateyaw(360,2);
		wait 2;
	}
}

rooms()
{
	thread sniperroom();
	thread jumproom();
}

sniperroom()
{
    level.sniper=getent("sniper","targetname");
    jump=getent("snip_jump","targetname");
    acti=getent("snip_acti","targetname");
    level.roomsong=true;
    level.sniper sethintstring("Press ^1&&1 ^7to enter the ^1Sniper Room");
    while(1)
    {
        level.sniper waittill("trigger",player);
        if(!isdefined(level.sniper))
            return;



        level.sniper sethintstring("Wait your ^1Turn");
        if(level.roomsong==true)
        {
			level.jump delete();
            level.roomsong=false;
        }
        if(isdefined(level.activ))
        {
            player freezecontrols(1);
            level.activ freezecontrols(1);
            player setorigin(jump.origin);
            level.activ setorigin(acti.origin);
            player setplayerangles(jump.angles);
            level.activ setplayerangles(acti.angles);
            player takeallweapons();
            level.activ takeallweapons();
            wait 5;
            player setroomgun("remington700_mp","m40a3_mp");
            level.activ setroomgun("remington700_mp","m40a3_mp");
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player freezecontrols(1);
            player setorigin(jump.origin);
            player setplayerangles(jump.angles);
            player takeallweapons();
            wait 5;
            player setroomgun("remington700_mp","m40a3_mp");
            player freezecontrols(0);
        }
        while(isalive(player)&&isdefined(player))
            wait 1;
        iprintln("^1"+player.name+"^7 has been killed");
        level.sniper sethintstring("Press ^1&&1 ^7to enter the ^1Sniper Room");
    }
}

jumproom()
{
    level.jump=getent("jump","targetname");
    jump=getent("jump_jump","targetname");
    acti=getent("jump_acti","targetname");
    level.roomsong=true;
    level.jump sethintstring("Press ^1&&1 ^7to enter the ^1Jump Room");
    while(1)
    {
        level.jump waittill("trigger",player);
        if(!isdefined(level.jump))
            return;


		
        level.jump sethintstring("Wait your ^1Turn");
        if(level.roomsong==true)
        {
			level.sniper delete();
            level.roomsong=false;
            thread bouncegun();
        }
        if(isdefined(level.activ))
        {
            player freezecontrols(1);
            level.activ freezecontrols(1);
            player setorigin(jump.origin);
            level.activ setorigin(acti.origin);
            player setplayerangles(jump.angles);
            level.activ setplayerangles(acti.angles);
            player takeallweapons();
            level.activ takeallweapons();
            wait 5;
            player setroomgun("knife_mp",undefined);
            level.activ setroomgun("knife_mp",undefined);
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player freezecontrols(1);
            player setorigin(jump.origin);
            player setplayerangles(jump.angles);
            player takeallweapons();
            wait 5;
            player setroomgun("knife_mp",undefined);
            player freezecontrols(0);
        }
        while(isalive(player)&&isdefined(player))
            wait 1;
        iprintln("^1"+player.name+"^7 has been killed");
        level.jump sethintstring("Press ^1&&1 ^7to enter the ^1Jump Room");
    }
}

setroomgun(weap,weap2)
{
    if(isdefined(weap))
    {
        self giveweapon(weap);
        self givemaxammo(weap);
    }
    if(isdefined(weap2))
    {
        self giveweapon(weap2);
        self givemaxammo(weap2);
    }
    self switchtoweapon(weap);
}

bouncegun()
{
	trig=getent("bounce_gun","targetname");
	playfx(level.bounceFX,(3192,-1288,-1560));
	trig setcursorhint("HINT_ACTIVATE");

	for(;;)
	{
		trig waittill("trigger",who);
		who setroomgun("m40a3_mp",undefined);
		trig setcursorhint("");
		trig sethintstring("^1Recharging");
		wait 3;
		trig sethintstring("");
		trig setcursorhint("HINT_ACTIVATE");
	}
}