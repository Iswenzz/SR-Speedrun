main()
{
    maps\mp\_load::main();
    //maps\mp\mp_dr_old_fucktory2_fx::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar("bg_falldamageminheight" , "99998");
    setdvar("bg_falldamagemaxheight" , "99999");

    thread sr\api\_map::createSpawn((-1813,1820,267), 325);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");

    thread sr_jumper_sec_enter();

    //thread music();
    //thread autorotation();
    thread tptors();
    thread tptors1();
    //thread endmap_trig();
    //thread sniproom();
    //thread kniferoom();
    //thread jumproom();
    //thread jumperfailb();
    //thread bounceactif();
    //thread memory();//cathedral
    //thread returncathedral(); //cathedral
    //thread actiarea1();
    //thread actifail1();
    //thread givesniper();
    //thread secret_start();
    thread secret_end();
    thread secret_fail1();
    thread secret_fail2();
    thread secret_fail3();
	//thread midair_start();
	//thread midair();
	//thread ele_secret_start();
	//thread ele_secret_end();
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();

     addTriggerToList( "trigger_trap1" );
     addTriggerToList( "trigger_trap2" );
     addTriggerToList( "trigger_trap3" );
     addTriggerToList( "trigger_trap4" );

}
sr_jumper_sec_enter()
{
	trig = spawn("trigger_radius",(-1605.51, 1819.57, 207.125), 0, 80, 120);
	trig.radius = 80;
	ori_t = getEnt("origin_secret_start","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}
addTriggerToList(name)
{
    if(!isDefined( level.trapTriggers ))
        level.trapTriggers = [];

    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread dddasdasddd(time);
}
dddasdasddd(time) {
	wait time;
	self freezecontrols(false);
}
music()
{

  snow = getEnt("snow", "targetname");
  snow2 = getEnt("snow2", "targetname");
  snow3 = getEnt("snow3", "targetname");
  snow4 = getEnt("snow4", "targetname");
  secret = getEnt("secret", "targetname");
  acti1 = getEnt("acti1", "targetname");
  fire1 = getEnt("fire1", "targetname");
  fire2 = getEnt("fire2", "targetname");

  maps\mp\_fx::loopfx("effect_1", (snow.origin), 1);
  maps\mp\_fx::loopfx("effect_1", (snow2.origin), 1);
  maps\mp\_fx::loopfx("effect_1", (snow3.origin), 1);
  maps\mp\_fx::loopfx("effect_1", (snow4.origin), 1);
  maps\mp\_fx::loopfx("effect_2", (secret.origin), 1);
  maps\mp\_fx::loopfx("effect_3", (acti1.origin), 1);
  maps\mp\_fx::loopfx("effect_4", (fire2.origin), 1);
  maps\mp\_fx::loopfx("effect_5", (fire1.origin), 1); //vhc


    level.music = randomint(2);
    level waittill("round_started");
    switch(level.music)
   {
      case 0:
     AmbientPlay( "fuck1" );
     break;
           case 1:
     AmbientPlay( "fuck2" );
     break;

   }
}

autorotation()
{
 rotate = getent("rotation1","targetname");   //prwto kykliko telous
 rotate2 = getent("rotation2","targetname");  //kykliko telous route
 endrotation1 = getent("end1","targetname"); //kyklika mesa sto telos #
 endrotation2 = getent("end2","targetname"); //kyklika mesa sto telos
 knifeplat1 = getent("knife1","targetname"); //kniferoom
 knifeplat2 = getent("knife2","targetname"); //kniferoom
 bounceplat1 = getent("bounce1","targetname"); //jumproom
 bounceplat2 = getent("bounce2","targetname"); //jumproom
 cathedralcyli = getent("cath","targetname"); //cathedral snip room

  for(;;)
  {
   rotate rotateYaw (360,5);
   rotate2 rotateYaw (-360,5);
   endrotation1 rotatepitch (360,5);
   endrotation2 rotatepitch (-360,5);
   knifeplat1 rotatepitch (360,5);
   knifeplat2 rotatepitch (-360,5);
   bounceplat1 rotateYaw (360,5);
   bounceplat2 rotateYaw (-360,5);
   cathedralcyli rotateYaw (-360,5);
   wait 1;
  }
}

tptors()//Move to room selection
{
   trig = getent("trigger_tprs", "targetname");
   tele1 = getent ("origin_tprs", "targetname");

   for (;;)
    {
     trig waittill ("trigger", player);
	  player SetOrigin(tele1.origin);
		player SetPlayerAngles((player getplayerangles()[0], tele1.angles[1], 0));
		player freeze_on_tps(0.1);
    }
}

tptors1()//Move to room selection
{
   trig = getent("trigger_tprs1", "targetname");
   tele1 = getent ("origin_tprs1", "targetname");

   for (;;)
    {
     trig waittill ("trigger", player);
	 player SetOrigin(tele1.origin);
		player SetPlayerAngles((player getplayerangles()[0], tele1.angles[1], 0));
		player freeze_on_tps(0.1);
    }
}

endmap_trig()
{
	trig = getEnt("endmap_trig", "targetname");
	trig waittill ("trigger",player );
	firstPlace = newHudElem();
	firstPlace.foreground = true;
	firstPlace.alpha = 1;
	firstPlace.alignX = "left";
	firstPlace.alignY = "middle";
	firstPlace.horzAlign = "left";
	firstPlace.vertAlign = "middle";
	firstPlace.x = -400;
	firstPlace.y = 0;
	firstPlace.sort = 0;
	firstPlace.font = "default";
	firstPlace.fontScale = 1.4;
	firstplace.hidewheninmenu = false;
	firstPlace.glowAlpha = 1;
	firstPlace.glowColor = (.3,.0,3);
	firstPlace settext("^6"+ player.name+ " ^7Finished ^7First");
	firstPlace moveOverTime(2);
	firstPlace.x = 5;
	wait 5;
	firstPlace moveOverTime(2);
	firstPlace.x = -500;
	wait 7;
	firstPlace destroy();
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
    hud.glowcolor = (0.4, 0.6, 1);

    return hud;
}

accessHUD(player, message)
{
    player notify("access_hud");
    player endon("access_hud");

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(player.hud_access))
        player.hud_access destroy();

    player.hud_access = player createHUD(0, 85, "center", "top", 1, "objective", 1.5);
    player.hud_access setText(message);
    player.hud_access setPulseFX(40, waitTime * 1000 - offset, offset);

    wait waitTime;

    if (isDefined(player.hud_access))
        player.hud_access destroy();
}

GetActivator()
{
	players = getentarray( "player", "classname" );

	for(i = 0;i < players.size;i++)
	{
		player = players[i];

		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}

	return "Noactivator";
}

waitdead()
{
    activator = GetActivator();
    scope = getent("trigger_sniproom","targetname");
    knife = getent("trigger_kniferoom","targetname");
    jump = getent("trigger_bounceroom","targetname");
    weapon = getent("trigger_weaponroom","targetname");
    scope thread maps\mp\_utility::triggerOff();
    knife thread maps\mp\_utility::triggerOff();
    jump thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    scope thread maps\mp\_utility::triggerOn();
    knife thread maps\mp\_utility::triggerOn();
    jump thread maps\mp\_utility::triggerOn();
}

sniproom()
{

    level.trigger_scope = getEnt ("trigger_sniproom", "targetname");

    jumpersc = getEnt ("origin_sniperjumper", "targetname");
    actisc = getEnt ("origin_sniperacti", "targetname");

    for(;;)
    {
        level.trigger_scope setHintString ("Press [&&1] to enter Sniper Room");
        level.trigger_scope waittill ("trigger", player);

        player thread waitdead();
        activator = GetActivator();
        player setOrigin (jumpersc.origin);
        player setPlayerAngles (jumpersc.angles);
        activator setOrigin (actisc.origin);
        activator setPlayerAngles (actisc.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("remington700_mp");
        activator giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        activator giveMaxAmmo("remington700_mp");
        player giveWeapon("m40a3_mp");
        activator giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        activator giveMaxAmmo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
        activator switchToWeapon("m40a3_mp");
        player.maxhealth = 100;


        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("" + player.name + " died in scope room");
    }
}

kniferoom()
{

   level.trigger_knife = getEnt ("trigger_kniferoom", "targetname");

    jumperk = getEnt ("origin_knifejumper", "targetname");
    actik = getEnt ("origin_knifeacti", "targetname");

   for(;;)
    {
        level.trigger_knife setHintString ("Press [&&1] to enter Knife Room.");
        level.trigger_knife waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
	    player setOrigin (jumperk.origin);
        player setPlayerAngles (jumperk.angles);
        activator setOrigin (actik.origin);
        activator setPlayerAngles (actik.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("knife_mp");
        activator giveWeapon("knife_mp");
        player switchToWeapon("knife_mp");
        activator switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
                       while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("" + player.name + " has died in Knife Room");
    }
}

jumproom()
{
   level.trigger_jump = getEnt ("trigger_bounceroom", "targetname");

    jumperk = getEnt ("origin_bouncejumper", "targetname");
    actik = getEnt ("origin_bounceactif", "targetname");

  for(;;)
    {
        level.trigger_jump setHintString ("Press [&&1] to enter JumpRoom");
        level.trigger_jump waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
	    player setOrigin (jumperk.origin);
        player setPlayerAngles (jumperk.angles);
        activator setOrigin (actik.origin);
        activator setPlayerAngles (actik.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("knife_mp");
        activator giveWeapon("knife_mp");
        player switchToWeapon("knife_mp");
        activator switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
                       while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("" + player.name + " has died in Jump Room");
    }
}

jumperfailb()//jumper respawn bounce r
{
   trigb = getent("trigger_jumperf", "targetname");
   teleb = getent ("origin_bouncejumper", "targetname");

   for(;;)
    {
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

bounceactif()// acti respawn bounce r
{
   trigb = getent("trigger_bounceactif", "targetname");
   teleb = getent ("origin_bounceactif", "targetname");

   for(;;)
    {
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

memory()//cathedral
{
   trig = getent("trigger_memory", "targetname");
   tele1 = getent ("origin_memory", "targetname");
   trig setHintString ("Join the cathedral");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

returncathedral()//cathedral return bck room selection
{
   trig = getent("trigger_returncath", "targetname");
   tele1 = getent ("origin_returncath", "targetname");
   trig setHintString ("Return back to room selection");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actiarea1()
{
   trig = getent("trigger_area1", "targetname");
   tele1 = getent ("origin_area1", "targetname");
   trig setHintString ("Acti next area");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actifail1()//bouncefailiactiroom
{
   trig = getent("trigger_fail1", "targetname");
   tele1 = getent ("origin_fail1", "targetname");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

givesniper()//bounceroom
{
 givesnip = getEnt("givesnip_trig","targetname");
 givesnip setHintString ("Press F for weapons");

	for (;;)
	{
		givesnip waittill("trigger", player);
		player takeallweapons();
		wait 0.1;
		player giveweapon("deserteagle_mp");
		player giveweapon("m40a3_mp");
		player switchtoweapon("deserteagle_mp");
		player givemaxammo("deserteagle_mp");
		player givemaxammo("m40a3_mp");
	}
}

secret_start()

{
	trig = getEnt("trigger_secret_start", "targetname");
	tele = getEnt("origin_secret_start", "targetname");
	trig SetHintString("^1>>> SECRET <<<^7");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		wait 0.2;
		player freezeControls(0);
		player thread accessHUD(player, "^5Secret ^7made by ^5vlct' Lentava^7");
	}
}

secret_end()

{
	trig = getEnt("trigger_secret_end", "targetname");
	tele = getEnt("origin_secret_end", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

secret_fail1()

{
	trig = getEnt("trigger_secret_fail1", "targetname");
	tele = getEnt("origin_secret_fail1", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}
secret_fail2()

{
	trig = getEnt("trigger_secret_fail2", "targetname");
	tele = getEnt("origin_secret_fail2", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}
secret_fail3()

{
	trig = getEnt("trigger_secret_fail3", "targetname");
	tele = getEnt("origin_secret_fail3", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player Suicide();
	}
}

midair_start()

{
	trig = getEnt("trigger_midair_start", "targetname");
	tele = getEnt("origin_midair_start", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		wait 0.2;
		player freezeControls(0);
		player iPrintLnBold("Your position has been set, now run straight and jump-crouch-stand under the structure.");
		wait 1;
		player iPrintLnBold("Do not change your angle.");

	}
}


midair()

{
	trig = getEnt("trigger_midair", "targetname");
	tele = getEnt("origin_midair", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		wait 0.2;
		player freezeControls(0);
	}
}

ele_secret_start()

{
	trig = getEnt("trigger_ele_start", "targetname");
	tele = getEnt("origin_ele_start", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		wait 0.2;
		player freezeControls(0);
		player iPrintLnBold("Welcome to the elevator secret! Good luck... (c) Lentava");
		wait 2;
		player iPrintLnBold("First one is basic, second is a jump elevator and the third is a mid-air.");
	}
}


ele_hud(message)
{
    eleEnd = newHudElem();
    eleEnd.foreground = true;
    eleEnd.alpha = 1;
    eleEnd.alignX = "left";
    eleEnd.alignY = "middle";
    eleEnd.horzAlign = "left";
    eleEnd.vertAlign = "middle";
    eleEnd.x = -400;
    eleEnd.y = 0;
    eleEnd.sort = 0;
    eleEnd.font = "default";
    eleEnd.fontScale = 1.4;
    eleEnd.hidewheninmenu = false;
    eleEnd.glowAlpha = 1;
    eleEnd.glowColor = (.3,.0,3);
    eleEnd settext(message);
    eleEnd moveOverTime(2);
    eleEnd.x = 5;
    wait 5;
    eleEnd moveOverTime(2);
    eleEnd.x = -500;
    wait 7;
    eleEnd destroy();
}

ele_secret_end()

{
	trig = getEnt("trigger_ele_end", "targetname");
	tele = getEnt("origin_ele_end", "targetname");

	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(1);
		player setOrigin(tele.origin);
		player setPlayerAngles(tele.angles);
		player braxi\_rank::giveRankXP("", 10000);
		wait 0.2;
		player freezeControls(0);
//		iPrintLnBold("^5" + player.name + "^7 has finished the ELEVATOR secret!");
		thread ele_hud("^5" + player.name + "^7 has finished the ELEVATOR secret!");
	}
}

trap1()
{
     plankt1 = getent("trap1","targetname");
     trig = getent("trigger_trap1", "targetname");
     trig setHintString("T1: Unstable 4 Platforms");
     trig waittill ("trigger");
     trig setHintString("^7Activated");

	for(;;)
   {
	 plankt1 notsolid();
	 wait 2000;
	 plankt1 solid();
	wait 2000;
   }

}

trap2()
{
     plankt1 = getent("trap2","targetname");
     trig = getent("trigger_trap2", "targetname");
     trig setHintString("T2: Rotate bounce");
     trig waittill ("trigger");
     trig setHintString("^7Activated");

	for(;;)
   {
     wait 0.1;
     plankt1 rotateYaw(360,3);
     wait 5;
   }

}

trap3()
{
     plankt1 = getent("trap3","targetname");
     trig = getent("trigger_trap3", "targetname");
     trig setHintString("T4: Rotate platform below");
     trig waittill ("trigger");
     trig setHintString("^7Activated");

	for(;;)
   {
     wait 0.1;
     plankt1 rotateYaw(360,3);
     wait 5;
   }
}


trap4()
{
     plankt1 = getent("trap4","targetname");
     trig = getent("trigger_trap4", "targetname");
     trig setHintString("T3: Rotate plat");
     trig waittill ("trigger");
     trig setHintString("^7Activated");

	for(;;)
   {
     wait 0.1;
     plankt1 rotateRoll(360,1);
     wait 5;
   }

}