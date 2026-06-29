/*Map Dedicated to my Beloved Vistic
 Map By CoMpy.
  /devmap mP_dr_broken3




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
    maps\mp\mp_dr_broken3_fx::main();
	setExpFog(10, 8500, 0.250, 0.250, 0.250, 0.0);


    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar("bg_falldamageminheight" , "99998");
    setdvar("bg_falldamagemaxheight" , "99999");
    setdvar("bg_bobmax" , "0");

 thread fx();
 thread fire_effect1();
 thread fire_effect();
 thread endmap_trig();
 thread messagescreen();
 thread music();
 thread secret1();
 thread secret2();
 thread secret3();
 thread secret4();
 thread secret5();
 thread autorotation();
 thread sniproom();
 thread jumpertp();//second area
 thread return1();
 thread jumproom();
 thread givesniper();
 thread jumperfailb();
 thread bounceactif();
 thread kniferoom();
 thread actitp1();

}

freeze_on_tps(time)
{
    self freezeControls(true);
    self thread _unfreeze_after(time);
}

_unfreeze_after(time)
{
    self endon("disconnect");
    wait time;
    if(isalive(self))
        self freezeControls(false);
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

fx()
{

     cyanglow = getEnt("cyanglow", "targetname");//hall of fame glow fx
     mist1 = getEnt("mist1", "targetname");//first part inside building
     mist2 = getEnt("mist2", "targetname");//second part inside building
     mist3 = getEnt("mist3", "targetname");//first part inside building
     mist4 = getEnt("mist4", "targetname");//second part inside building
     mist5 = getEnt("mist5", "targetname");//second part inside building
     jet = getEnt("jet", "targetname");//my logo fx
     glow = getEnt("glow", "targetname");//white glow across main route
     maps\mp\_fx::loopfx("effect_5", (mist1.origin), 1);
     maps\mp\_fx::loopfx("effect_5", (mist2.origin), 1);
     maps\mp\_fx::loopfx("effect_5", (mist3.origin), 1);
     maps\mp\_fx::loopfx("effect_5", (mist4.origin), 1);
     maps\mp\_fx::loopfx("effect_5", (mist5.origin), 1);
     maps\mp\_fx::loopfx("effect_7", (jet.origin), 1);
     maps\mp\_fx::loopfx("effect_6", (glow.origin), 1);
     maps\mp\_fx::loopfx("effect_4", (cyanglow.origin), 1);

}

fire_effect1()
{
    fire = getentarray("emberblue","targetname");
    fire = getentarray("emberblue2","targetname");
    hfx = undefined;
    level waittill("round_started");

    for(i=0;i<fire.size;i++)
    {
        hfx[i] = spawnfx(level.fire_effect,fire[i].origin);
        triggerfx(hfx[i]);
    }
}

fire_effect()
{
    fire = getentarray("fire1","targetname");
    fire = getentarray("fire2","targetname");
    fire = getentarray("fire3","targetname");
    fire = getentarray("fire4","targetname");
    fire = getentarray("fire5","targetname");
    middlefire = getentarray("middlefire","targetname");
    hfx = undefined;
    level waittill("round_started");

    for(i=0;i<fire.size;i++)
    {
        hfx[i] = spawnfx(level.fire_effect,fire[i].origin);
        triggerfx(hfx[i]);
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

messagescreen()
{
	 level waittill("round_started");
	 wait 1;
	 noti = SpawnStruct();
    noti.TitleText = "^9Big Shoutout to ^5ERIK ^9For Tips&Help";
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
	        AmbientStop(2);
     AmbientPlay( "remember" );
	 iPrintLN("^5Rafau Etamski - Remember to forget");
     break;
	       case 1:
	        AmbientStop(2);
     AmbientPlay( "nroken1" );
	 iPrintLN("^6Hugh Hardie - Dream In Green (ft. Zoe Kypri)");
     break;
     	       case 2:
	        AmbientStop(2);
     AmbientPlay( "keepon" );
	 iPrintLN("^7Alpha Rythm, humanature - Keeping on (ft. leo wood)");
     break;
	}
}

secret1()//compy
{
    trig = getEnt("trigger_secret1","targetname");
    trig setHintString ("?");
    trig waittill("trigger", player );
    AmbientStop( 3 );
    wait 2.5;
    ambientPlay("secret1");
    iPrintlnBold( player.name + "^5Turned On ^6CoMpy's ^5Banger");
}

secret2()//erik
{
    trig = getEnt("trigger_secret2","targetname");
    trig waittill("trigger", player );
    AmbientStop( 3 );
    wait 2.5;
    ambientPlay("secret2");
    iPrintlnBold( player.name +  "^5Turned On ^5ERIK's ^5Ultimate Banger");
}

secret3()//emily
{
    trig = getEnt("trigger_secret3","targetname");
    trig waittill("trigger", player );
    AmbientStop( 3 );
    wait 2.5;
    ambientPlay("secret3");
    iPrintlnBold( player.name +  "^5Turned On ^5emily...'s ^5Banger");
}

secret4()//krispie
{
    trig = getEnt("trigger_secret4","targetname");
    trig waittill("trigger", player );
    AmbientStop( 3 );
    wait 2.5;
    ambientPlay("secret4");
    iPrintlnBold( player.name +  "^5Turned On ^5Krispy's ^5Ultimate Banger");
}

secret5()//tiki
{
    trig = getEnt("trigger_secret5","targetname");
    trig waittill("trigger", player );
    AmbientStop( 3 );
    wait 2.5;
    ambientPlay("secret5");
    iPrintlnBold( player.name +  "^5Turned On ^5tiki's ^5Banger");
}

autorotation()
{
 rotate = getent("rotator","targetname");
     brush1 = getent("brush1","targetname");
     brush2 = getent("brush2","targetname");
     brush3 = getent("brush3","targetname");
     brush4 = getent("brush4","targetname");
	 compyc = getent("compyc","targetname");
     compyo = getent("compyo","targetname");
     compym = getent("compym","targetname");
     compyp = getent("compyp","targetname");
     compyy = getent("compyy","targetname");
     rotator1 = getent("rotator1","targetname");
     rotator2 = getent("rotator2","targetname");
     circlebounce2 = getent("circlebounce2","targetname");
     circlebounce2a = getent("circlebounce2a","targetname");
     circlebounce1 = getent("circlebounce1","targetname");
     circlebounce1a = getent("circlebounce1a","targetname");

  for(;;)
  {
   rotate rotateYaw (360,5);
   brush1 rotatePitch (360,5);
   brush2 rotatePitch (-360,5);
   brush3 rotatePitch (360,5);
   brush4 rotatePitch (-360,5);
   compyc rotateYaw (360,5);
   compyo rotateYaw (-360,5);
   compym rotateYaw (360,5);
   compyp rotateYaw (-360,5);
   compyy rotateYaw (360,5);
   rotator1 rotateYaw (360,5);
   rotator2 rotateYaw (-360,5);
   circlebounce1 rotateYaw (-360,5);
   circlebounce1a rotateYaw (-360,5);
   circlebounce2 rotateYaw (360,5);
   circlebounce2a rotateYaw (360,5);
   wait 4;
  }
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

jumpertp()//second area
{
   trig = getent("trigger_tp1", "targetname");
   tele1 = getent ("origin_tp1", "targetname");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

return1()//second area return back kjumper
{
   trig = getent("trigger_return1", "targetname");
   tele1 = getent ("origin_return1", "targetname");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
       player freeze_on_tps(0.05);
     player setPlayerAngles(tele1.angles);
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

actitp1()
{
   trig = getent("trigger_actitp1", "targetname");
   tele1 = getent ("origin_actitp1", "targetname");
   trig setHintString ("Acti next area");

   for (;;)
    {
     trig waittill ("trigger", player);
	   player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}