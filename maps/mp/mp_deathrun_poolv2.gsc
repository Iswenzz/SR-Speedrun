//Map by CM'Death
//Discord:Death#7416
main()
{
 maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";

	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");

    //thread messages();
    thread startdoor();
	//thread finishdoor();
    thread movingplatform();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((68,21,76),91);
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

addTextHud( who, x, y, alpha, alignX, alignY, fontScale )
{
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
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

createHUD( x, y, alignX, alignY, alpha, font, fontScale )
{
    hud = NewHudElem();
    hud.x = x;
    hud.y = y;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.horzalign = alignX;
    hud.vertalign = alignY;
    hud.alpha = alpha;
    hud.font = font;
    hud.fontscale = fontScale;
    hud.glowalpha = 1;
    hud.glowcolor = (0.5,0.5,0.5);

    return hud;
}

DoorHUD(messages)
{
    self notify("newFhud");
    self endon("newFhud");

    waitTime = 4; //s
    offset = 200; //ms

    if (isDefined(level.hud_door)) level.hud_door destroy();
	if (isDefined(level.hud_door2)) level.hud_door2 destroy();

    level.hud_door = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_door setText("^4Poolv2");
    level.hud_door setPulseFX( 40, waitTime*1000-offset, offset );

	level.hud_door2 = createHUD( 0, 100, "center", "middle", 1, "objective", 1.5 );
    level.hud_door2 setText("^7Map by ^4CM'Death");
    level.hud_door2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_door)) level.hud_door destroy();
	if (isDefined(level.hud_door2)) level.hud_door2 destroy();
}

messages()
{
   wait 1;
   thread DoorHUD("^4messages");
   AmbientPlay("poolsong");
   wait 3;
   for(;;)
{
   wait 5;
 x = randomintrange(0,4);
   if (x==0)
{
   iPrintln("^7Map made by ^4CM'Death");
}

   if (x==1)
{
   iPrintln("^7Visit ^5cm^7-clan.tk");
}

   if (x==2)
{
   iPrintln("^5CM^0'Deathrun IP: ^778.46.244.1:28960");
}

if (x==3)
{
   iPrintln("^4Feel free to report any bugs.");
}

if (x==4)
{
   iPrintln("^4Discord:^7Death#7416");
}

}
}

startdoor()
{
   door = getent("startdoor","targetname");
   door moveZ(256, 9);
   iprintlnbold("^4Start door opened.");
   door delete();
}

finishdoor()
{
    platform = getent("finishdoor", "targetname");
    trig = getent("trig_finishdoor", "targetname");
    trig setHintString("^7Press ^4[&&1] ^7to open ^4Acti Door^7.");
	trig waittill("trigger", player);

	platform moveZ(-300,8);

	trig delete();

}

movingplatform()
{
   block = getent("movingplat","targetname");

}

trap1()
{
   platforma = getent("trap1a", "targetname");
   platformb = getent("trap1b", "targetname");
   platformc = getent("trap1c", "targetname");
   trig = getent("trig_trap1", "targetname");

   trig setHintString("^5Trap1");
   trig waittill("trigger", player);
   trig setHintString("^1Activated.");

  for(;;)
   {
   platforma moveZ (-100,2,1,1);
   platformb rotateYaw (360,3);
   platformc moveZ (100,2,1,1);
   wait 2;
   platforma moveZ (100,2,1,1);
   platformb rotateYaw (360,3);
   platformc moveZ (-100,2,1,1);
   wait 2;
   }
}

trap2()
{

   laser = getent("trap2", "targetname");
   trig = getent("trig_trap2", "targetname");
   hurta = getent("trap2_hurta", "targetname");
   hurtb = getent("trap2_hurtb", "targetname");
   hurtc = getent("trap2_hurtc", "targetname");
   hurtd = getent("trap2_hurtd", "targetname");
   trig setHintString("Rotate the Cylinder!");

   hurta enablelinkto();
   hurta linkto (laser);

   hurtb enablelinkto();
   hurtb linkto (laser);

   hurtc enablelinkto();
   hurtc linkto (laser);

   hurtd enablelinkto();
   hurtd linkto (laser);

   trig waittill ("trigger");
   trig setHintString("^1Activated.");

   for(;;)
  {
   laser moveZ (-200,2);
   wait 1;
   laser moveZ (200,2);
   wait 1;
   }
}

trap3()
{
    platform = getent("trap3", "targetname");
    trig = getent("trig_trap3", "targetname");
    trig setHintString("^5Trap3");
	trig waittill("trigger", player);
	trig setHintString("^1Activated.");

	for(;;)
	{
	platform notsolid();
	wait 5;
	platform solid();
	wait 5;
	}
}

trap4()
{
   platform = getent("trap4", "targetname");
   trig = getent("trig_trap4", "targetname");
   trig setHintString("^5Trap4");
   trig waittill("trigger", player);
   trig setHintString("^1Activated.");

     while(1)
   {
   platform rotateroll(360,5);
   wait 3;
   }
}

trap5()
{
   platforma = getent("trap5a", "targetname");
   platformb = getent("trap5b", "targetname");
   trig = getent("trig_trap5", "targetname");
   trig setHintString("^5Trap5");
   trig waittill("trigger", player);
   trig setHintString("^1Activated.");

   for(;;)
   {
   platforma moveX (250,2);
   platformb moveX (-250,2);
   wait 1;
   platforma moveX (-250,2);
   platformb moveX (250,2);
   wait 1;
   }

}

trap6()
{
   platform = getent("trap6", "targetname");
   trig = getent("trig_trap6", "targetname");
   trig setHintString("^5Trap6");
   trig waittill("trigger", player);
   trig setHintString("^1Activated.");

   for(;;)
	{
	platform Rotatepitch(360,2);
	wait 5;
	platform Rotatepitch(-360,2);
	wait 5;
	}
}