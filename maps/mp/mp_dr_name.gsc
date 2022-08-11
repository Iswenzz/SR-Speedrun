#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
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
  setdvar("r_glowbloomintensity0",".1");
  setdvar("r_glowbloomintensity1",".1");
  setdvar("r_glowskybleedintensity0",".1");
  setDvar("bg_falldamagemaxheight", 99999);
  setDvar("bg_falldamageminheight", 99998);

thread sr\api\_map::createSpawn((-116, 22, 76), 270);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

///THREADS
thread door();
//thread freexp();
//thread trap1();
//thread trap2();
//thread trap3();
//thread trap4();
//thread trap5();
//hread Water();
//thread watterfx();
//thread roomselection();
//thread sniper();
//thread knife();
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

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

removeTextActivator()
{
    if( isDefined( self.hud_textacti) )
    {
        self.hud_textacti destroy();
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

fightHUD(room, jumper, activ)
{
    self notify("newFhud");
    self endon("newFhud");

    if (!isDefined(room))
        room = "undefined";
    if (!isDefined(jumper))
        jumper = "undefined";
    else
        jumper = jumper.name;
    if (!isDefined(activ))
        activ = "undefined";
    else
        activ = activ.name;

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();

    level.hud_fight = createHUD( 0, 85, "center", "top", 1, "objective", 1.5 );
    level.hud_fight setText("^0" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^0" + jumper + " ^4VS^4 " + "^0" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}

///STARTDOOR
door()
{
door = getent("startdoor","targetname");

door delete();
}

///FREE XP FOR ONE PERSON
freexp()
{ 
    trig = getent("freexp", "targetname");
    trig setHintString ("^4Surprise here^0!");
	
for(;;)
{
 trig waittill("trigger", player);
 player iPrintLnBold("^0You just found free ^4XP^0! :o");
 trig delete();
 wait 0.5;
}
}

trap1()
{
   plata = getent("trap1a", "targetname");
   platb = getent("trap1b", "targetname");

   trig = getent("trig_trap1", "targetname");

   trig setHintString("^0Press ^4[&&1] ^0to activate a ^4trap^0!");
   trig waittill ("trigger", player);
   trig setHintString("^1Activated!");

  for(;;)
	{
    plata  rotatePitch (-360,2);
    platb  rotatePitch (360,2);
    wait 4;
    plata  rotatePitch (360,2);
    platb  rotatePitch (-360,2);
    wait 4;
	}
}

trap2() 
{
    trig = getEnt("trig_trap2", "targetname");
    plat = getEnt("trap2", "targetname");
    
    trig setHintString("^0Press ^4[&&1] ^0to activate a ^4trap^0!");
    trig waittill ("trigger", player);
    trig setHintString("^1Activated!");

    while(1) 
    { 
        plat moveY( -97, 5);
        plat waittill("movedone");
        plat moveY( 97, 5);
        plat waittill("movedone");
    }
}

trap3()
{
   trig = getEnt("trig_trap3", "targetname");
   plata = getEnt("trap3", "targetname");
   platb = getEnt("trap3b", "targetname");
    
    trig setHintString("^0Press ^4[&&1] ^0to activate a ^4trap^0!");
    trig waittill ("trigger", player);
    trig setHintString("^1Activated!");

{  
 x = randomint(2);

   if (x==0)
{
    plata notsolid();
    plata hide();
    platb solid();
    platb show();
}

   if (x==1)
{
    plata solid();
    plata show();
    platb notsolid();
    platb hide();
}

}

}    

trap4() 
{
    trig = getEnt("trig_trap4", "targetname");
    plat = getEnt("trap4", "targetname");
    
    trig setHintString("^0Press ^4[&&1] ^0to activate a ^4trap^0!");
    trig waittill ("trigger", player);
    trig setHintString("^1Activated!");

    while(1) 
    { 
        plat RotateYaw(360,5);
        plat moveZ( -160, 5);
        plat waittill("movedone");
        wait 1;
        plat RotateYaw(-360,5);
        plat moveZ( 160, 5);
        plat waittill("movedone");
        wait 1;
    }
}

trap5()
{
   trig = getEnt("trig_trap5", "targetname");
   plata = getEnt("trap5a", "targetname");
   platb = getEnt("trap5b", "targetname");
    
    trig setHintString("^0Press ^4[&&1] ^0to activate a ^4trap^0!");
    trig waittill ("trigger", player);
    trig setHintString("^1Activated!");

{  
 x = randomint(2);

   if (x==0)
{
    plata notsolid();
    plata hide();
    platb solid();
    platb show();
}

   if (x==1)
{
    plata solid();
    plata show();
    platb notsolid();
    platb hide();
}

}

}    

///WATER FX BAR
Water()
{
while (1)
    {
    self waittill("trigger", other);

    if(isPlayer(other) && other istouching(self))
        other thread drown_water(self);
    }
}
drown_water(trigger)
{
    dceiling = getent(trigger.target,"targetname");
    water_vision = undefined;
    while (self istouching(trigger) && !self istouching(dceiling))
    {
        wait .125;
        if(isDefined(self.drown_watering))
            return;
        self.drown_watering = true;

    if(!isDefined(water_vision))
    {
        water_vision = newClientHudElem(self);
        water_vision.x = 0;
        water_vision.y = 0;
        water_vision setshader ("white", 640, 480);
        water_vision.alignX = "left";
        water_vision.alignY = "top";
        water_vision.horzAlign = "fullscreen";
        water_vision.vertAlign = "fullscreen";
        water_vision.color = (.16, .38, .5);
        water_vision.alpha = .75;
    }


    level.barincrement = (level.barsize / (20.0 * level.drown_watertime));
//    level.player allowProne(false);
    if(!isDefined(self.progressbackground))
    {
        self.progressbackground = newClientHudElem(self);
        self.progressbackground.alignX = "center";
        self.progressbackground.alignY = "middle";
        self.progressbackground.x = 320;
        self.progressbackground.y = 385;
        self.progressbackground.alpha = 0.5;
    }
    self.progressbackground setShader("black", (level.barsize + 4), 14);

    if(!isDefined(self.progressbar))
    {
        self.progressbar = newClientHudElem(self);
        self.progressbar.alignX = "left";
        self.progressbar.alignY = "middle";
        self.progressbar.x = (320 - (level.barsize / 2.0));
        self.progressbar.y = 385;
    }
    self.progressbar setShader("white", 0, 8);
    self.progressbar scaleOverTime(level.drown_watertime, level.barsize, 8);

    self.progresstime = 0;
    d = 0;
    f = 0;

    while(isalive(self) && self istouching(trigger) && !self istouching(dceiling) && (self.progresstime < level.drown_watertime))
    {
        d ++;
        f ++;

        wait 0.05;
        self.progresstime += 0.05;


        if(self.progresstime >= level.hurttime)
            {
            if(f >= 4)
                {
                radiusDamage(self.origin,9, 1, 1);
                f = 0;
                }
            }
    }

    if(isalive(self) && self istouching(trigger) && !self istouching(dceiling) && (self.progresstime >= level.drown_watertime))
    {

        self.progressbackground destroy();
        self.progressbar destroy();

        wait 0.025;
        radiusDamage(self.origin,22, 3000, 3000);

        self.drown_watering = undefined;
        self.sounder = undefined;



        randb = randomInt(2);
        deathmethod1 = " Drowned";
        deathmethod2 = " That's water, It Kills.";
        deathmethod3 = " Swallowed Some Water";
        deathmethod4 = " That's water, It Kills.";

        if (randb == 0)
        iPrintLn( self.name, deathmethod1);
        if (randb == 1)
        iPrintLn( self.name, deathmethod2);
        if (randb == 2)
        iPrintLn( self.name, deathmethod3);
        if (randb == 3)
        iPrintLn( self.name, deathmethod4);
        wait .05;
        water_vision destroy();
    }
    else
    {
        water_vision.alpha = .5;
        water_vision fadeOverTime(3);
        water_vision.alpha = 0;
        wait 0.05;
        self.progressbackground destroy();
        self.progressbar destroy();
        self.drown_watering = undefined;
        self.sounder = undefined;
    }
    wait .05;
    }
}
watterFX()
{

	drown_waterage = getentarray("drown_water","targetname");
	if (isDefined("drown_waterage"))
	{
		precacheShader("black");
		precacheShader("white");



		level.barsize = 288;
		level.drown_watertime = 10;
		level.hurttime = 9;

		for(d = 0; d < drown_waterage.size; d++)
		{
			drown_waterage[d] thread water();
		}
	}
}

roomselection() 
{
level.room_trig = getEnt( "trig_roomselection", "targetname");
room = getEnt( "orig_roomselection", "targetname" );
level.room_trig setHintString ("^0Press ^4[&&1]^0 to enter ^4Room Selection^0!");

for(;;)
{
level.room_trig waittill( "trigger", player );
if( !isDefined( level.room_trig ) )
return;

acti = GetActivator();
if(level.firstenter == true)
{
	acti freezeControls(1);
	acti iPrintLnBold("^0Jumper ^4is picking a ^0room ^4so don't ^0move^4!");
	level notify("acti_antiglitch");
	level.firstenter = false;
}
player SetPlayerAngles( room.angles );
player setOrigin( room.origin );
player TakeAllWeapons();
}
}

///ROOMS///
waitdead()
{
    activator = GetActivator();
    knife = getent("trig_knife","targetname");
    sniper = getent("trig_sniper","targetname");
    knife thread maps\mp\_utility::triggerOff();
    sniper thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    knife thread maps\mp\_utility::triggerOn();
    sniper thread maps\mp\_utility::triggerOn();
}

end_countdown(text, duration, extra)
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );

    if (isDefined(self.end_countdownHUD)) self.end_countdownHUD destroy();
    self.end_countdownHUD = createHUD(0, 120, "center", "top", 1, "objective", 1.5);

    self freezeControls(1);
    wait extra;

    while (duration > 0)
    {
        //self iPrintLnBold (duration);
        self.end_countdownHUD setText("^4" + duration);
        self.end_countdownHUD setPulseFX( 40, 1000-200, 200 );
        wait 1;
        duration--;
    }
		//self iPrintLnBold(text);
    self.end_countdownHUD setText(text);
    self.end_countdownHUD setPulseFX( 40, 1000-200, 200 );
    self freezeControls(0);
    wait 1;
    if (isDefined(self.end_countdownHUD)) self.end_countdownHUD destroy();
}

sniper()
{
    level.trigger_scope = getEnt ("trig_sniper", "targetname");

    jumpersc = getEnt ("orig_sniper_jumper", "targetname");
    actisc = getEnt ("orig_sniper_acti", "targetname");

    for(;;)
    {
        level.trigger_scope setHintString ("^0Press ^4[&&1]^0 to enter ^4Sniper Room^0!");
        level.trigger_scope waittill ("trigger", player);

        player thread waitdead();
        activator = GetActivator();
        thread fightHUD("Sniper Room", player, activator);
        player thread end_countdown("^0Kill each other !", 3, 0);
        activator thread end_countdown("^0Kill each other !", 3, 0);
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

        iPrintLnBold ("^4" + player.name + " ^0has died in ^4Sniper Room^0!");    

    }
}

knife()
{
   level.trigger_knife = getEnt ("trig_knife", "targetname");

    jumperk = getEnt ("orig_knife_jumper", "targetname");
    actik = getEnt ("orig_knife_acti", "targetname");

   for(;;)
    {
        level.trigger_knife setHintString ("^0Press ^4[&&1]^0 to enter ^4Knife Room^0!");
        level.trigger_knife waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
        thread fightHUD("Knife Room", player, activator);
        activator thread end_countdown("^0Kill each other !", 3, 0);
        player thread end_countdown("^0Kill each other !", 3, 0);
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

        iPrintLnBold ("^4" + player.name + " ^0has died in ^4Knife Room^0!");
    }
}