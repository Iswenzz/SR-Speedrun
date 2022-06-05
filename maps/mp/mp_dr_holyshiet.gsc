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
	
	// ambientPlay("holyshiet");
  // precacheitem("ak47_mp");
  // precacheitem("ak74u_mp");

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

  setdvar( "r_specularcolorscale", "1" );
  setdvar("r_glowbloomintensity0",".25");
  setdvar("r_glowbloomintensity1",".25");
  setdvar("r_glowskybleedintensity0",".3");

  thread way_connect();
  
	//startdoor
  thread startdoor();

	//Traps
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread trap9();
	
	//Secret
	thread secret_open();
  thread secret_port();
  thread secret_quit();

  //fx
  level.holyshiet = LoadFx("vistic/funken");
  level.rainbow = LoadFx("vistic/rainbow_funken");

  //Actidoit
  // thread doit();
	
  //rooms
  // thread r_sniper();
  // thread r_weapon();
  // thread r_knife();
  // thread r_port();
	
	//triggerinfreerun
  // addTriggerToList( "trap1_trig" );
	// addTriggerToList( "trap2_trig" );
	// addTriggerToList( "trap3_trig" );
	// addTriggerToList( "trap4_trig" );
	// addTriggerToList( "trap5_trig" );
	// addTriggerToList( "trap6_trig" );
	// addTriggerToList( "trap7_trig" );
	// addTriggerToList( "trap8_trig" );
	// addTriggerToList( "trap9_trig" );
	// addTriggerToList( "holyshiet" );
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
	sr\api\_speedrun::createSecretWays("Secret Way;");
	
    for(;;)
    {
        level waittill( "connected", player );
        
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////


//Triggerinfreerun
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

//Startdoor
startdoor()
{
   trigger = getEnt("startdoor_trig", "targetname");
   door = getEnt("startdoor", "targetname");
   
   // trigger setHintString("^1Press ^7F ^1!");
   // trigger waittill("trigger");
   
   // iPrintLnBold("^1Startdoor ^7will open in ^15 ^7Seconds");
   trigger delete();
   wait 0.1;
   
   door movez(-120,0.2);
   wait 0.2;
   door delete();
  }
  
//Traps
trap1()
{
  trigger = getEnt("trap1_trig", "targetname");
  trap = getEnt("trap1", "targetname");
  
  trigger setHintString("^1Activate:^7 Trap1");
  trigger waittill("trigger");
  trigger delete();
  
  while(1)
  {
    trap rotatePitch(360, 11);
	  wait 1;
	}
}

trap2()
{
  trigger = getEnt("trap2_trig", "targetname");
  atrap = getEnt("trap2a", "targetname");
  btrap = getEnt("trap2b", "targetname");
  
  trigger setHintString("^1Activate:^7 Trap2");
  trigger waittill("trigger");
  trigger delete();
  
  while(1)
  {
    atrap rotateRoll(360,1.5);
	  btrap rotateRoll(-360,1.5);
    wait 0.1;
	}

}

trap3()
{ 
  trigger = getEnt("trap3_trig", "targetname");
  atrap = getEnt("trap3a", "targetname");
  btrap = getEnt("trap3b", "targetname");
  
  trigger setHintString("^1Activate:^7 Trap3");
  trigger waittill("trigger");
  trigger delete();
  
  wait 0.1;
  while(1)
  {
    atrap rotateYaw(360,4);
    btrap rotateYaw(-360,4);
	  wait 0.1;
	}
}

trap4()
{
  trigger = getEnt("trap4_trig", "targetname");
  atrap = getEnt("trap4a", "targetname");
  btrap = getEnt("trap4b", "targetname");
  
  trigger setHintString("^1Activate:^7 Trap4");
  trigger waittill("trigger");
  trigger delete();
  
  while(1)
  {
    atrap rotateYaw(360, 2);
    btrap rotateYaw(-360, 2);
    wait 7;
  }
}

trap5()
{ 
  trigger = getEnt("trap5_trig", "targetname"); 
  atrap = getEnt("trap5a", "targetname"); 
  btrap = getEnt("trap5b", "targetname");
  ctrap = getEnt("trap5c", "targetname");
  dtrap = getEnt("trap5d", "targetname");
  etrap = getEnt("trap5e", "targetname");

  trigger setHintString("^1Activate:^7 Trap5");
  trigger waittill("trigger");
  trigger delete();

  while(1)
  {
    atrap movex(-330,2);
    wait 1;
    btrap movex(-330,2);
    wait 1;
    ctrap movex(-330,2);
    wait 1;
    dtrap movex(-330,2);
    wait 1;
    etrap movex(-330,2);
    wait 5;
    atrap movex(330,2);
    wait 1;
    btrap movex(330,2);
    wait 1;
    ctrap movex(330,2);
    wait 1;
    dtrap movex(330,2);
    wait 1;
    etrap movex(330,2);
    wait 5;
  }
}

trap6()
{ 
  trigger = getEnt("trap6_trig", "targetname"); 
  atrap = getEnt("trap6a", "targetname");
  btrap = getEnt("trap6b", "targetname");
  ctrap = getEnt("trap6c", "targetname");

  trigger setHintString("^1Activate:^7 Trap6");
  trigger waittill("trigger");
  trigger delete();

  while(1)
  {
    atrap rotateyaw(360, 2);
	  wait 2;
    btrap rotateyaw(360, 2);
    wait 2;
    ctrap rotateyaw(360, 2);
    wait 2;
	}
}

trap7()
{
  trigger = getEnt("trap7_trig", "targetname");
  atrap = getEnt("trap7a", "targetname");
  btrap = getEnt("trap7b", "targetname");
  
  trigger setHintString("^1Activate:^7 Trap7");
  trigger waittill("trigger");
  trigger delete();
  
  vc = randomint(2);
  if(vc==0)
  {
    atrap delete();
  }
  if(vc==1)
  {
    btrap delete();
  }
}

trap8()
{
  trigger = getEnt("trap8_trig", "targetname");
  trap = getEnt("trap8", "targetname");
  
  trigger setHintString("^1Activate:^7 Trap8");
  trigger waittill("trigger");
  trigger delete();
  
  while(1)
  {
    trap rotateYaw(360, 6);
    wait .1;
	}
}

trap9()
{
  trigger = getEnt("trap9_trig", "targetname");
  trap = getEnt("trap9", "targetname");
  
  trigger setHintString("^1Activate:^7 Trap9");
  trigger waittill("trigger");
  trigger delete();

  while(1)
  {
    trap hide();
    wait 4;
    trap show();
    wait 4;
  }
}

//Secret

secret_open()
{    
  trigger = getent("secret_entertrig", "targetname");
  level.strig = getent("secret_1", "targetname");
  level.s2trig = getent("secret_2", "targetname");
  level.s3trig = getent("secret_3", "targetname");
  brush = getent("secret_enterbrush", "targetname");
       
	   wait 1;
       
  trigger enablelinkto(); 
	trigger linkto (brush); 
	
	brush moveY (-200, 2);
  playloopedfx(level.rainbow,0.5,(-2120, 1064, 1064));
}

secret_port()
{
  trigger = getent("secret_entertrig", "targetname");
  target = getent("secret_target", "targetname");
  
  while(1)
  {
    trigger waittill ("trigger", player);
    
      player SetOrigin(target.origin);
      player SetPlayerAngles( target.angles );
	  player sr\api\_speedrun::changeWay("secret_0");
  }
}

secret_quit()
{
  trigger = getent("s_quit","targetname");
  target = getent("s_target","targetname");
  while(1)
  {
    trigger waittill ("trigger", player);
    
      player SetOrigin(target.origin);
      player SetPlayerAngles( target.angles );
	  player thread braxi\_mod::endTimer();
  }
}

r_port()
{
  trig = getent("endport","targetname");
  trig sethintstring("^1Press ^7F ^1to End");
  for(;;)
  {
    trig waittill ("trigger",user);
    if (user istouching(trig))
      {   
        tp = spawn ("script_model",(0,0,0));
        tp.origin = user.origin;
        tp.angles = user.angles;
        user linkto (tp);
        tp moveto ((952, -1544, 200), 1);
        wait 1;
        tp moveto ((872, -808, 200), 1);
        wait .5;
        tp moveto ((872, -808, 120), 1);
        wait 1;
        user unlink();
      }
  }
}

r_sniper()
{

  level.sniper = getEnt("sniper", "targetname");
    jump = getEnt ("j_room", "targetname");
    acti = getEnt ("a_room", "targetname");

    level.sniper setHintString("^1Choose: ^7Sniper");

    while(1)
    {
        level.sniper waittill( "trigger", player );
        if( !isDefined( level.sniper ) )
            return; 

        if(level.roomsong==true)
    {
      ambientstop();
      ambientplay("holyshiet2");
      level.roomsong = false;
      thread buildsnip();
       playLoopedFx( level.rainbow, 0.05, (992, -704, 104));
       level.weapon delete();
       level.knife delete();
       level.sniper setHintString("^1Press ^7F ^1to Port");
    }

    
    player FreezeControls(1);
    level.activ FreezeControls(1);

    player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

     player takeallweapons();
     level.activ takeallweapons();
      
      player setroomgun("m40a3_mp");
        level.activ setroomgun("remington700_mp");

        iprintlnbold("^1S^7niper ^1R^7oom");
        iprintlnbold(player.name+" ^1vs "+level.activ);

        wait 5;

    player FreezeControls(0);
    level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

r_knife()
{

 level.knife = getEnt("knife", "targetname");
    jump = getEnt ("j_room_kf", "targetname");
    acti = getEnt ("a_room_kf", "targetname");

    level.knife setHintString("^1Choose: ^7Knife");

    while(1)
    {
         level.knife waittill( "trigger", player );
        if( !isDefined(  level.knife ) )
            return; 

        if(level.roomsong==true)
    {
      ambientstop();
      ambientplay("holyshiet2");
      level.roomsong = false;
      thread buildknife();
       playLoopedFx( level.rainbow, 0.05, (992, -800, 104));
      level.weapon delete();
      level.sniper delete();
       level.knife setHintString("^1Press ^7F ^1to Port");
    }

    
    player FreezeControls(1);
    level.activ FreezeControls(1);

    player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

     player takeallweapons();
     level.activ takeallweapons();
      
      player setroomgun("knife_mp");
        level.activ setroomgun("knife_mp");

        iprintlnbold("^1K^7nife ^1R^7oom");
        iprintlnbold(player.name+" ^1vs^7 "+level.activ);

        wait 5;

    player FreezeControls(0);
    level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

r_weapon()
{

 level.weapon = getEnt("weapon", "targetname");
    jump = getEnt ("j_room", "targetname");
    acti = getEnt ("a_room", "targetname");

    level.weapon setHintString("^1Choose: ^7Weapon");

    while(1)
    {
         level.weapon waittill( "trigger", player );
        if( !isDefined(  level.weapon ) )
            return; 

        if(level.roomsong==true)
    {
      ambientstop();
      ambientplay("holyshiet2");
      level.roomsong = false;
      thread buildweapon();
      playLoopedFx( level.rainbow, 0.05, (992, -896, 104));
      level.knife delete();
      level.sniper delete();
       level.weapon setHintString("^1Press ^7F ^1to Port");
    }

    
    player FreezeControls(1);
    level.activ FreezeControls(1);

    player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );

     player takeallweapons();
     level.activ takeallweapons();
      
      player setroomgun("ak74u_mp");
        level.activ setroomgun("ak47_mp");

        iprintlnbold("^1W^7eapon ^1R^7oom");
        iprintlnbold(player.name+" ^1vs "+level.activ);

        wait 5;

    player FreezeControls(0);
    level.activ FreezeControls(0);

        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

setroomgun( gun )
{
  self takeallweapons();
  self giveweapon(gun);
  self switchtoweapon(gun);
  self givemaxammo(gun);
}

buildknife()
{
  sniper_brush = getent("sniperroom","targetname");
  weapon_brush = getent("weaponroom","targetname");
  details = getent("buildroom","targetname");

  wait 2;
  sniper_brush movez(-500, 3);
  weapon_brush movez(-500, 3);
  details movez(-500, 3);
  sniper_brush delete();
  weapon_brush delete();
  details delete();
}

buildsnip()
{
  knife_brush = getent("kniferoom","targetname");
  weapon_brush = getent("weaponroom","targetname");
  details = getent("buildroom","targetname");

  wait 2;
  knife_brush movez(-500, 3);
  weapon_brush movez(-500, 3);
  details movez(177, 3);
  weapon_brush delete();
}

buildweapon()
{
  details = getent("buildroom","targetname");
  wait 2;
  details movez(177, 3);
}

doit()
{
  trig = getent("holyshiet","targetname");
  trig sethintstring("^1Activate: ^7Holyshiet");
  trig waittill("trigger");
  trig sethintstring("^1HOLYSHIET ^7?!");

  playloopedfx(level.holyshiet,0.5,(312,-72,-232));
  playloopedfx(level.holyshiet,0.5,(-1096,-72,-232));
  playloopedfx(level.holyshiet,0.5,(-2536,-88,-232));
  playloopedfx(level.holyshiet,0.5,(-3336,-616,-232));
  playloopedfx(level.holyshiet,0.5,(-2840,-1528,-232));
  playloopedfx(level.holyshiet,0.5,(-1560,-1528,-232));
  playloopedfx(level.holyshiet,0.5,(-360,-1528,-232));
  playloopedfx(level.holyshiet,0.5,(600,-1544,-232));
}