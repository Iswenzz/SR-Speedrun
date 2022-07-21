main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
  thread sr\api\_speedrun::createSecretWays("Secret Way;");
		level.teleport = loadFX("misc/ui_pickup_available");
level.snow = loadFX("weather/snow_light");

  target = getEnt( "scbacktp", "targetname");
  thread sr\api\_speedrun::createTeleporter((4156, 2941, -4), 100, 150,
    target.origin, target.angles[1], "freeze", "blue", "secret_0");

maps\mp\_load::main();

 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";

 /* [AUTO DELETE] thread knife(); */
 thread snip();
 /* [AUTO DELETE] thread printcredits(); */
 thread trap1();
 thread trap2();
 thread trap3();
 thread trap4();
 thread trap5();
 thread trap6();
 thread trap7();
 thread trap8();
 thread trapbridge();
 thread teleport1();
 thread teleport2();
 thread teleport3();
 thread teleport4();
 /* [AUTO DELETE] thread vip(); */
 // thread creator();
 /* [AUTO DELETE] thread secret(); */
 // thread scback();
 // thread scback2();
 thread sc2tp();
 thread end();

 addTriggerToList( "trigtrap1" );
 addTriggerToList( "trigtrap2" );
 addTriggerToList( "trigtrap3" );
 addTriggerToList( "trigtrap4" );
 addTriggerToList( "trigtrap5" );
 addTriggerToList( "trigtrap6" );
 addTriggerToList( "trigtrap7" );
 addTriggerToList( "trigtrap8" );
 addTriggerToList( "trigtrapbridge" );


/* [AUTO DELETE] ambientPlay("ambient"); */

precacheItem( "ak47_mp" );

playLoopedFX(level.snow, 0.06, (-1392, -150, -334));
playLoopedFX(level.snow, 0.05, (472, -150, -20));
playLoopedFX(level.snow, 0.07, (3586, 2316, 122));
playLoopedFX(level.snow, 0.09, (2214, -150, 12));
playLoopedFX(level.snow, 0.08, (3498, 440, 120));
playLoopedFX(level.snow, 0.05, (6150, -12208, 514));

}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


knife()
{
    level.mus_trig1 = getEnt( "knifetpr", "targetname" );
    tele_activator = getEnt( "actiknifer", "targetname" );
    tele_jumper = getEnt( "jumperknifer", "targetname" );

    level.finalJumper = undefined;

    while( 1 )
    {
        level.mus_trig1 waittill( "trigger", player );

        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;


        level.finalJumper = player;
        level.finalJumper thread finalMonitor();

        level.finalJumper finalroom( tele_jumper, "knife_mp", 100 );
	level.activ finalroom( tele_activator, "knife_mp", 100 );


	noti = SpawnStruct();
				noti.titleText = "Knife Room";
				noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
				noti.glowcolor = (0,0.9,0.7);
				noti.duration = 4;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);



    }
    // code never gets here
}


snip()
{
    level.mus_trig1 = getEnt( "sniptp", "targetname" );
    tele_activator = getEnt( "actisnip", "targetname" );
    tele_jumper = getEnt( "jumpersnip", "targetname" );

    level.finalJumper = undefined;

    while( 1 )
    {
        level.mus_trig1 waittill( "trigger", player );

        if( isDefined( level.finalJumper ) || player.pers["team"] != "allies" )
        continue;


        level.finalJumper = player;
        level.finalJumper thread finalMonitor();

        level.finalJumper finalroom( tele_jumper, "m40a3_mp", 100 );
	level.activ finalroom( tele_activator, "m40a3_mp", 100 );


	noti = SpawnStruct();
				noti.titleText = "Sniper Room";
				noti.notifyText = level.activ.name + " ^5VS^7 " + player.name;
				noti.glowcolor = (0,0.9,0.7);
				noti.duration = 4;
				players = getentarray("player", "classname");
				for(i=0;i<players.size;i++)
					players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

    level.finalJumper FreezeControls(1);
    level.activ FreezeControls(1);
    wait 3;
    level.finalJumper FreezeControls(0);
    level.activ FreezeControls(0);



    }
    // code never gets here
}


finalMonitor()
{
    self endon( "disconnect" );
    self thread monitorDisconnect();

    while( self.sessionstate == "playing" )
        wait 0.05;
    level.finalJumper = undefined;
}


finalroom( tp, weap, health )
{
    self SetPlayerAngles( tp.angles );
    self SetOrigin( tp.origin );

    self TakeAllWeapons(); //this should be called so it takes away insertion perk in dr 1.2
    /* [AUTO DELETE] self GiveWeapon( weap ); */
    /* [AUTO DELETE] self GiveMaxAmmo( weap ); */
    /* [AUTO DELETE] self SwitchToWeapon( weap ); */

}


monitorDisconnect()
{
    self waittill( "disconnect" );
    level.finalJumper = undefined;
}


printcredits()
    {
            if( isDefined( self.logoText ) )
                    self.logoText destroy();

            self.logoText = newHudElem();
            self.logoText.y = 10;
            self.logoText.alignX = "center";
            self.logoText.alignY = "middle";
            self.logoText.horzAlign = "center_safearea";

            self.logoText.alpha = 0;
            self.logoText.sort = -3;
            self.logoText.fontScale = 1.6;
            self.logoText.archieved = true;

            for(;;)
            {
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^5---^3Map made by MadLion^5---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^5---^3xfire: madlion3^5---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^5---^3Winter Public Beta^5---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 1;
                    self.logoText setText("^5---^3Additional help: Mr.Xx(xfire:dragec1997)^5---");
                    wait 3;
                    self.logoText fadeOverTime(1);
                    self.logoText.alpha = 0;
                    wait 1;

		}

	}



trap1()
{
	level endon("trigger");

trig = getEnt( "trigtrap1", "targetname" );
ham = getEnt( "ham", "targetname" );

trig waittill ("trigger");
trig delete();

while( 1 )

{
ham rotatepitch(360, 4);
wait 4;
}
}


trap2()
{
	level endon("trigger");

trig = getEnt( "trigtrap2", "targetname" );

trig waittill ("trigger");
trig delete();

{
thread blockdelete2();
}
}


blockdelete2()
{
        x = randomIntRange( 1, 3 );

        if( x == 1 )
        {
        thread combination1();
        }
        else if( x == 2 )
        {
        thread combination2();
        }
}


combination1()
{
comb1 = getEnt( "comb1", "targetname" );
comb1 delete();
}


combination2()
{
comb2 = getEnt( "comb2", "targetname" );
comb2 delete();
}


trap3()
{
	level endon("trigger");

trig = getEnt( "trigtrap3", "targetname" );
trapm = getEnt( "rotate", "targetname" );

trig waittill ("trigger");
trig delete();

while( 1 )

{
trapm rotateyaw(180, 2);
wait 4;
}
}


trap4()
{
	level endon("trigger");

trig = getEnt( "trigtrap4", "targetname" );
traprotate1 = getEnt( "rotatec1", "targetname" );
traprotate2 = getEnt( "rotatecc2", "targetname" );
traprotate3 = getEnt( "rotatec3", "targetname" );
traprotate4 = getEnt( "rotatec4", "targetname" );

trig waittill ("trigger");
trig delete();

while( 1 )

{
traprotate1 rotateyaw(720, 6);
traprotate2 rotateyaw(720, 6);
traprotate3 rotateyaw(720, 6);
traprotate4 rotateyaw(720, 6);
wait 6;
traprotate1 rotateyaw(720, 6);
traprotate2 rotateyaw(720, 6);
traprotate3 rotateyaw(720, 6);
traprotate4 rotateyaw(720, 6);
wait 6;
}
}



trap5()
{
	level endon("trigger");

trig = getEnt( "trigtrap5", "targetname" );

trig waittill ("trigger");
trig delete();

{
thread blocksdelete();
}
}


blocksdelete()
{
        x = randomIntRange( 1, 3 );

        if( x == 1 )
        {
        thread blocks1();
        }
        else if( x == 2 )
        {
        thread blocks2();
        }
}


blocks1()
{
blocks1 = getEnt( "blocks11", "targetname" );
blocks1 delete();
}


blocks2()
{
blocks2 = getEnt( "blocks22", "targetname" );
blocks2 delete();
}


teleport1()
{
  trig = getEnt( "teleport", "targetname");
  target = getEnt( "teleported", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport2()
{
  trig = getEnt( "teleport2", "targetname");
  target = getEnt( "teleported2", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}



teleport3()
{
  trig = getEnt( "teleport3", "targetname");
  target = getEnt( "teleported3", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


teleport4()
{
  trig = getEnt( "teleport4", "targetname");
  target = getEnt( "teleported4", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}



trap6()
{
	level endon("trigger");

trig = getEnt( "trigtrap6", "targetname" );

trig waittill ("trigger");
trig delete();

{
thread blockdelete();
}
}


blockdelete()
{
        x = randomIntRange( 1, 3 );

        if( x == 1 )
        {
        thread lava1();
        }
        else if( x == 2 )
        {
        thread lava2();
        }
        else if( x == 3 )
        {
        thread lava3();
        }
}


lava1()
{
block = getEnt( "lava1delete", "targetname" );
block delete();
}


lava2()
{
block = getEnt( "lava2delete", "targetname" );
block delete();
}


lava3()
{
block = getEnt( "lava3delete", "targetname" );
block delete();
}


trap7()
{
	level endon("trigger");

trig = getEnt( "trigtrap7", "targetname" );
trap = getEnt( "ttrotate", "targetname" );

trig waittill ("trigger");
trig delete();

while( 1 )

{
trap rotateyaw(360, 3);
wait 3;
}
}


trap8()
{
	level endon("trigger");

trig = getEnt( "trigtrap8", "targetname" );
trapr = getEnt( "right", "targetname" );
trapl = getEnt( "left", "targetname" );

trig waittill ("trigger");
trig delete();


{
trapr movex(-416, 2);
trapl movex(416, 2);

}
}


trapbridge()
{
	level endon("trigger");

trig = getEnt( "trigtrapbridge", "targetname" );
block = getEnt( "bridge1", "targetname" );

trig waittill ("trigger");
trig delete();
block delete();
}


vip()
{
	level.accepted1 = "f79803a1"; //MadLion

	{
		level waittill( "player_spawn", player );

		friend = getSubStr(player getGuid(), 24, 32);

		if((friend == level.accepted1))
		{
		    wait 1;
			/* [AUTO DELETE] iprintln("^2MadLion ^1is online!"); */
		}
		if((friend == level.accepted1) && level.freerun == false && player.pers["team"] == "allies")
		{
		 player giveweapon( "ak47_mp" );
		 /* [AUTO DELETE] player givemaxammo( "ak47_mp" ); */
		}
	}
}


creator()
{
wait(5);
thread braxi\_mod::drawInformation( 800, 0.8, 1, "Winter public BETA" );
while( 1 )
{
/* [AUTO DELETE] iPrintLn("^4Map made by ^5MadLion"); */
wait(60);
/* [AUTO DELETE] iPrintLn("^4xfire: ^5madlion3"); */
}
}



secret()
{
trig = getEnt( "scstep1", "targetname" );

trig waittill ("trigger");
trig delete();
{
/* [AUTO DELETE] self iprintln("^3Secret Step: ^71/4"); */
thread step2();
}
}


step2()
{
trig = getEnt( "scstep2", "targetname" );

trig waittill ("trigger");
trig delete();
{
/* [AUTO DELETE] self iprintln("^3Secret Step: ^72/4"); */
thread step3();
}
}


step3()
{
trig = getEnt( "scstep3", "targetname" );

trig waittill ("trigger");
trig delete();
{
/* [AUTO DELETE] self iprintln("^3Secret Step: ^73/4"); */
thread step4();
}
}


step4()
{
trig = getEnt( "scstep4", "targetname" );
moveob = getEnt( "scmove", "targetname" );

trig waittill ("trigger");
trig delete();
{
/* [AUTO DELETE] iprintlnBold("^5Secret is open"); */
moveob movey(256, 1);
thread scfinalstep();
}
}


scfinalstep()
{

trig = getEnt( "scopenn", "targetname" );
target = getEnt( "sctpp", "targetname");

for(;;)
  {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
  }
}


scback()
{
  trig = getEnt( "scback", "targetname");
  target = getEnt( "scbacktp", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


scback2()
{
  trig = getEnt( "scback2", "targetname");
  target = getEnt( "scback2tp", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


sc2tp()
{
  trig = getEnt( "sc2", "targetname");
  target = getEnt( "sc2tp", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player);
     player SetOrigin(target.origin);
     player SetPlayerAngles( target.angles );
      }
}


end()
{
  trig = getEnt( "secretend", "targetname");
  target = getEnt( "secretendtp", "targetname");

  for(;;)
  {
     trig waittill ("trigger", player);

     player thread sr\api\_speedrun::finishWay("secret_0");
     /* [AUTO DELETE] player braxi\_rank::giveRankXp( "", 2000); */
     /* [AUTO DELETE] player iPrintlnBold( "^5Secret Prize: ^72000 ^5XP"); */
     /* [AUTO DELETE] iPrintlnBold( "^5" + player.name + " ^7has finished the secret room!!"); */
      }
}
