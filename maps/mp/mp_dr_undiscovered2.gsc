/*Map Dedicated to my Beloved Vistic
 Map By CoMpy.
 /devmap mp_dr_undiscovered2


     ***** *      **           *****  *       *******      ****           *         *****  *       * ***
  ******  *    *****        ******  *       *       ***   *  *************       ******  *       *  ****  *
 **   *  *       *****     **   *  *       *         **  *     *********        **   *  *       *  *  ****
*    *  **       * **     *    *  *        **        *   *     *  *            *    *  *       *  **   **
    *  ***      *             *  *          ***           **  *  **                *  *       *  ***
   **   **      *            ** **         ** ***            *  ***               ** **      **   **
   **   **      *            ** **          *** ***         **   **               ** **      **   **
   **   **     *           **** **            *** ***       **   **             **** **      **   **
   **   **     *          * *** **              *** ***     **   **            * *** **      **   **
   **   **     *             ** **                ** ***    **   **               ** **      **   **
    **  **    *         **   ** **                 ** **     **  **          **   ** **       **  **
     ** *     *        ***   *  *                   * *       ** *      *   ***   *  *         ** *      *
      ***     *         ***    *          ***        *         ***     *     ***    *           ***     *
       *******           ******          *  *********           *******       ******             *******
         ***               ***          *     *****               ***           ***                ***
                                        *
                                         **


*/

main()
{
    maps\mp\_load::main();
	setExpFog(10, 3000, 0.02, 0.02, 0.02, 0.0);

 level.fire = LoadFx("pumpfire");
 level.weather = loadfx ("bolt");


    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar("bg_falldamageminheight" , "99998");
    setdvar("bg_falldamagemaxheight" , "99999");
    setdvar("bg_bobmax" , "0");
    setdvar("cg_drawdecals" , "1");


    thread fire_effect1();
    thread messagescreen();
    thread music();
    thread autorotation();
    thread tpend();
    thread finaltp();
    thread endmap_trig();
    thread jumproom();
    thread givesniper();
    thread sniproom();
    thread kniferoom();
    thread jumperfailb();
    thread bounceactif();
}

fire_effect1()
{
    fire = getentarray("end1","targetname");
    fire = getentarray("pump2","targetname");
    fire = getentarray("pump3","targetname");
    hfx = undefined;
    level waittill("round_started");

    for(i=0;i<fire.size;i++)
    {
        hfx[i] = spawnfx(level.pumpfire,fire[i].origin);
        triggerfx(hfx[i]);
    }
}
messagescreen()
{
	 level waittill("round_started");
	 wait 1;
	 noti = SpawnStruct();
    noti.TitleText = "^9MP_DR_CHAINED2";
    noti.notifyText = "^9Map ^5By ^6CoMpy";
	noti.duration = 8;
	noti.glowcolor = (1,1,1);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

}

music()
{
    music = randomint(3);
    level waittill("round_started");
    switch(music)
   {
      case 0:
	        AmbientStop(1);
     AmbientPlay( "kintsugi" );
	 iPrintLN("^5Charli Brix - Kintsugi (Satl remix)");
          break;

           case 1:
	        AmbientStop(2);
     AmbientPlay( "dreaming" );
	 iPrintLN("^5S.P.Y - Dreaming");
             break;
   case 2:
	        AmbientStop(3);
     AmbientPlay( "vibe" );
	 iPrintLN("^5Fluidity - Deeper Vibe");
     break;
	}

}

autorotation()
{
     deathrun = getent("deathrun","targetname");
     sphere = getent("sphere","targetname");
     cube1 = getent("cube1","targetname");
     cube2 = getent("cube2","targetname");
     cube3 = getent("cube3","targetname");
     cube4 = getent("cube4","targetname");
     cube5 = getent("cube5","targetname");
     cube6 = getent("cube6","targetname");
     cube7 = getent("cube7","targetname");
     cube8 = getent("cube8","targetname");
     cube9 = getent("cube9","targetname");
     rotator = getent("rotator","targetname");
     wtf = getent("wtf","targetname");//b room cylinder
     sletter = getent("sletter","targetname");
     bletter = getent("bletter","targetname");
     kletter = getent("kletter","targetname");




  for(;;)
  {
    deathrun rotateYaw (360,5);
    sphere  rotateYaw (360,5);
    cube1  rotateYaw (360,5);
    cube2  rotateYaw (-360,5);
    cube3  rotateYaw (360,5);
    cube4  rotateYaw (-360,5);
    cube5  rotateYaw (360,5);
    cube6  rotateYaw (-360,5);
    cube7  rotateYaw (360,5);
    cube8  rotateYaw (-360,5);
    cube9  rotateYaw (360,5);
    rotator  rotateYaw (360,5);
    wtf  rotateYaw (360,5);
    sletter  rotateYaw (360,10);
    bletter  rotateYaw (360,10);
    kletter  rotateYaw (360,10);

   wait 4;
  }
}


tpend()//jumper last tp
{
   trig = getent("trigger_endtp", "targetname");
   tele1 = getent ("origin_endtp", "targetname");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

finaltp()//jumper tp to endtrig
{
   trig = getent("trigger_finaltp", "targetname");
   tele1 = getent ("origin_finaltp", "targetname");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
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
    jump = getent("trigger_bounceroom","targetname");
    knife = getent("trigger_kniferoom","targetname");
    scope thread maps\mp\_utility::triggerOff();
    jump thread maps\mp\_utility::triggerOff();
    knife thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    scope thread maps\mp\_utility::triggerOn();
    jump thread maps\mp\_utility::triggerOn();
    knife thread maps\mp\_utility::triggerOn();
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