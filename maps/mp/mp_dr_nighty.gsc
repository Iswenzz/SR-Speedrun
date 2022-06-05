//////////////////////\\\\\\\\\\\\\\\\\\\\\\
//    __              ___                 \\
//   /\ \            /\_ \                \\
//   \ \ \        ___\//\ \    ____       \\
//    \ \ \  __  / __`\\ \ \  /\_ ,`\     \\
//     \ \ \L\ \/\ \L\ \\_\ \_\/_/  /_    \\
//      \ \____/\ \____//\____\ /\____\   \\
//       \/___/  \/___/ \/____/ \/____/   \\
// 								          \\
//////////////////////\\\\\\\\\\\\\\\\\\\\\\
//Map by Lolz      |      Scripted by Lolz\\
//        Nickname i have in game :       \\
//   Lolz :] -SuX Lolz :] -#FNRP#Lolz :]  \\
//            xFire: alex1528             \\
//    Steam: iswenzz1528 / SuX Lolz :]    \\
//////////////////////\\\\\\\\\\\\\\\\\\\\\\

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;");
	maps\mp\_load::main();
 maps\mp\_compass::setupMiniMap("compass_map_mp_dr_nighty");

eztp = getEnt("secret1easy_tp","targetname");
htp = getEnt("secret1hard_tp","targetname");

thread sr\api\_map::createSpawn((-11760, 2603, 78), 270);

thread sr\api\_speedrun::createTeleporter((-11539, 2404, 76), 100, 150, 
	eztp.origin, eztp.angles[1], "freeze", "green", "secret_0");
thread sr\api\_speedrun::createTeleporter((-11986, 2404, 76), 100, 150, 
	htp.origin, htp.angles[1], "freeze", "darkred", "secret_1");

 
 level._effect[ "bluepartic" ] = loadfx( "fire/custom_fire" );
 level._effect[ "c4" ] = loadfx( "explosions/custom_explo_small" );
 level._effect[ "lightning" ] = loadfx( "weather/lightning_mp_farm" );
 level.knockback = getDvarInt("g_knockback");
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
	// /* [AUTO DELETE] bounce   = getEntArray("bounce", "targetname"); */
	// for(i = 0;i <  [AUTO DELETE] bounce.size; i++)
	// /* [AUTO DELETE] bounce[i] thread bounce(); */
	
	//SETDVAR**
	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","1600");

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 2000000000 );
	setDvar("bg_falldamageminheight", 1500000000 );
	//SETDVAR*

	//THREAD**
	thread swagturn();
	/* [AUTO DELETE] thread guidchecking(); */
	// thread mapzor();
	thread startdoor();
	// thread messages();
	// thread  [AUTO DELETE] initMusic(); 
	/* [AUTO DELETE] thread musictrig(); */
	// thread end();
	// thread games();
	thread watterFX();
	thread credits();
	thread ringstart();
	thread lvl2setup();
	thread tube2();
	thread tube3();
	thread tube4();
	thread tplvl1();
	thread tplvl2();
	thread tplvl3();
	thread tplvl4();
	thread tplvl5();
	thread tubetp();
	thread blueparticles();
	thread lightningfxl();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
	thread actitpsetup();
	thread movingstuff();
	/* [AUTO DELETE] thread sniper(); */
	/* [AUTO DELETE] thread sniperfail(); */
	/* [AUTO DELETE] thread weapons(); */
	/* [AUTO DELETE] thread bounceroom(); */
	/* [AUTO DELETE] thread bounceactifail(); */
	/* [AUTO DELETE] thread bouncejumperfail(); */
	// thread  [AUTO DELETE] givesniper(); 
	// thread run();
	// thread runwaysetup();
	/* [AUTO DELETE] thread knife(); */
	/* [AUTO DELETE] thread old(); */
	/* [AUTO DELETE] thread oldfakewall(); */
	thread turnstuff();
 thread secretsetup(); 
	thread traphardmodeoff();
	thread traphardmodeon();
	//THREAD*

	//PRECACHE**
	precacheitem ("m40a3_mp");
	precacheitem ("remington700_mp");
	precacheitem ("knife_mp");
	precacheitem ("raygun_mp");
	precacheitem ("intervention_mp");
	precacheitem ("tomahawk_mp");
	precacheitem ("uzi_silencer_mp");
	precacheItem ("ak74u_mp");
	precacheItem ("rpg_mp");
	precacheItem ("winchester1200_mp");
	precacheItem ("ak47_mp");
	precacheItem ("rpd_mp");
	precacheItem ("m1014_grip_mp");
	precacheItem ("deserteaglegold_mp");
	precacheItem ("p90_silencer_mp");
	precacheItem ("saw_grip_mp");
	precacheModel("shadow");
	precacheShader("mtl_shadow_fur");
	precacheShader("mtl_shadow_clothes");
	precacheShader("mtl_shadow_shoes");
	precacheShader("mtl_shadow_body");
	precacheShader("mtl_shadow_eyes");
	//PRECACHE*

	//ACTI TRIGGER
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
	addTriggerToList( "trig_trap9" );
	addTriggerToList( "trig_trap10" );
	addTriggerToList( "trig_trap11" );
	addTriggerToList( "trig_trap12" );
	addTriggerToList( "trig_trap13" );
	//ACTI TRIGGER

}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


cleanUp()
{
	if( !isDefined( self ) )
		return;
 
	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}


//TRUCKER TIMER <3\\

countdown()
{
self endon("death");
self endon("finished");
self.pers["time"] = 120;
self thread timehud();
for(;;)
{
wait 1;
self.pers["time"] --;
if(self.pers["time"]<1)
self suicide();
}
}

 
timehud()
{
self endon ("death");
self endon ("finished");
self endon ("disconnect");
self.time_hud = newClientHudElem(self);
self.time_hud.x = 305;
self.time_hud.y = 15;
self.time_hud.alignX = "middle";
self.time_hud.alignY = "center";
self.time_hud.fontScale = 2.3;
self.time_hud.color = (40, 112, 222);
self.time_hud.font = "objective";
self.time_hud.glowColor = (40, 112, 222);
self.time_hud.glowAlpha = 1;
self.time_hud.hideWhenInMenu = false;
self.time_hud.owner = self;
self.time_hud setText( self.pers["time"] );
self.time_hud thread destroyondeath();
self thread changetime();
self thread destroyondeath();
wait 90;
self thread destroytimehud();
}

 
destroyondeath()
{
        self waittill_any("death", "disconnect", "finished");
        self destroytimehud();
}

changetime()
{
for(;;)
{
self.time_hud setText( self.pers["time"] );
wait 0.1;
self.time_hud setText( self.pers["time"] );
wait 0.1;
}
}

 
destroytimehud()
{
        if( isDefined( self.time_hud) )
        {
        self.time_hud destroy();
    }
}


//TRUCKER TIMER <3\\

swagturn()
{
sturn1 = getEnt("swagturn1","targetname");
sturn2 = getEnt("swagturn2","targetname");
sturn3 = getEnt("swagturn3","targetname");
sturn4 = getEnt("swagturn4","targetname");
sturn5 = getEnt("swagturn5","targetname");
sturn6 = getEnt("swagturn6","targetname");
sturn7 = getEnt("swagturn7","targetname");
sturn8 = getEnt("swagturn8","targetname");
sturn9 = getEnt("swagturn9","targetname");
sturn10 = getEnt("swagturn10","targetname");
sturn11 = getEnt("swagturn11","targetname");
sturn12 = getEnt("swagturn12","targetname");
sturn13 = getEnt("swagturn13","targetname");
sturn14 = getEnt("swagturn14","targetname");
sturn15 = getEnt("swagturn15","targetname");
sturn16 = getEnt("swagturn16","targetname");
sturn17 = getEnt("swagturn17","targetname");
sturn18 = getEnt("swagturn18","targetname");
sturn19 = getEnt("swagturn19","targetname");

wait 0.2;

	while(1)
	{
	sturn1 rotateRoll(360, 16);
	wait 0.1;
	sturn2 rotateRoll(360, 16);
	wait 0.1;
	sturn3 rotateRoll(360, 16);
	wait 0.1;
	sturn4 rotateRoll(360, 16);
	wait 0.1;
	sturn5 rotateRoll(360, 16);
	wait 0.1;
	sturn6 rotateRoll(360, 16);
	wait 0.1;
	sturn7 rotateRoll(360, 16);
	wait 0.1;
	sturn8 rotateRoll(360, 16);
	wait 0.1;
	sturn9 rotateRoll(360, 16);
	wait 0.1;
	sturn10 rotateRoll(360, 16);
	wait 0.1;
	sturn11 rotateRoll(360, 16);
	wait 0.1;
	sturn12 rotateRoll(360, 16);
	wait 0.1;
	sturn13 rotateRoll(360, 16);
	wait 0.1;
	sturn14 rotateRoll(360, 16);
	wait 0.1;
	sturn15 rotateRoll(360, 16);
	wait 0.1;
	sturn16 rotateRoll(360, 16);
	wait 0.1;
	sturn17 rotateRoll(360, 16);
	wait 0.1;
	sturn18 rotateRoll(360, 16);
	wait 0.1;
	sturn19 rotateRoll(360, 16);
	wait 12;
	}
}


guidchecking()
{
	wait 5.1;
	thread guidcheckgod();
	thread guidcheckvip();
	wait 0.2;
}


tubetp()
{
	tubetrig = getEnt("tube_trig", "targetname");
	tubetp = getEnt("tube_tp", "targetname");

	for(;;)
	{
		tubetrig waittill("trigger", player);
		player setOrigin(tubetp.origin);
		player setPlayerAngles(tubetp.angles);
	}
}


movingstuff()
{
linkall1 = getEnt("murturn_show_1","targetname");
linkall2 = getEnt("murturn_show_2","targetname");
wind1 = getEnt("windturbin1","targetname");

linkall1 hide();
linkall2 hide();

	while(1)
	{
	wind1 rotateYaw(360, 1.5);
	wait 1;
	}
}


traphardmodeoff() //Hard mod off
{
lazer1 = getent("hard_mode_1a","targetname");
lazertrig1 = getent("hard_mode_1b","targetname");

	{
	lazer1 hide();
	lazer1 notsolid();
	lazertrig1 triggerOff();
	}
}


hardplatmdr()
{
hardplat1 = getent("hard_plat_1","targetname");
hardplat2 = getent("hard_plat_2","targetname");
hardplat3 = getent("hard_plat_3","targetname");
hardplat4 = getent("hard_plat_4","targetname");
hardplat5 = getent("hard_plat_5","targetname");
hardplat6 = getent("hard_plat_6","targetname");
hardplat7 = getent("hard_plat_7","targetname");
hardplat8 = getent("hard_plat_8","targetname");
hardplat9 = getent("hard_plat_9","targetname");
hardplat10 = getent("hard_plat_10","targetname");

	{
	hardplat1 rotateYaw(-45, 0.5);
	hardplat2 rotateYaw(-45, 0.5);
	hardplat3 rotateYaw(-45, 0.5);
	hardplat4 rotateYaw(-45, 0.5);
	hardplat5 rotateYaw(-45, 0.5);
	hardplat6 rotateYaw(-45, 0.5);
	hardplat7 rotateYaw(-45, 0.5);
	hardplat8 rotateYaw(-45, 0.5);
	hardplat9 rotateYaw(-45, 0.5);
	hardplat10 rotateYaw(-45, 0.5);
	wait 0.5;
	thread hardplatmdrfix();
	}
}


hardplatmdrfix()
{
hardplat1 = getent("hard_plat_1","targetname");
hardplat2 = getent("hard_plat_2","targetname");
hardplat3 = getent("hard_plat_3","targetname");
hardplat4 = getent("hard_plat_4","targetname");
hardplat5 = getent("hard_plat_5","targetname");
hardplat6 = getent("hard_plat_6","targetname");
hardplat7 = getent("hard_plat_7","targetname");
hardplat8 = getent("hard_plat_8","targetname");
hardplat9 = getent("hard_plat_9","targetname");
hardplat10 = getent("hard_plat_10","targetname");

	while(1)
	{
	hardplat1 rotateYaw(90, 0.5);
	hardplat2 rotateYaw(90, 0.5);
	hardplat3 rotateYaw(90, 0.5);
	hardplat4 rotateYaw(90, 0.5);
	hardplat5 rotateYaw(90, 0.5);
	hardplat6 rotateYaw(90, 0.5);
	hardplat7 rotateYaw(90, 0.5);
	hardplat8 rotateYaw(90, 0.5);
	hardplat9 rotateYaw(90, 0.5);
	hardplat10 rotateYaw(90, 0.5);
	wait 0.5;
	hardplat1 rotateYaw(-90, 0.5);
	hardplat2 rotateYaw(-90, 0.5);
	hardplat3 rotateYaw(-90, 0.5);
	hardplat4 rotateYaw(-90, 0.5);
	hardplat5 rotateYaw(-90, 0.5);
	hardplat6 rotateYaw(-90, 0.5);
	hardplat7 rotateYaw(-90, 0.5);
	hardplat8 rotateYaw(-90, 0.5);
	hardplat9 rotateYaw(-90, 0.5);
	hardplat10 rotateYaw(-90, 0.5);
	wait 0.5;
	}
}


traphardmodeon() //Hard mod
{
	level endon("trigger");
lazer1 = getent("hard_mode_1a","targetname");
lazertrig1 = getent("hard_mode_1b","targetname");
trig = getent("trig_trap13","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 100); */
trig SetHintString("^2Activated");
/* [AUTO DELETE] iPrintLnBold("^4HARD MODE ACTIVATED!!!"); */
	{
	lazer1 show();
	lazer1 solid();
	lazertrig1 triggerOn();
	wait 1;
	thread lazer1move();
	thread hardplatmdr();
	}
}


lazer1move()
{
lazer1 = getent("hard_mode_1a","targetname");
lazertrig1 = getent("hard_mode_1b","targetname");

lazertrig1 enablelinkto();
lazertrig1 linkto(lazer1);

	for(;;)
	{
		time = RandomIntRange( 2 , 6 );
		wait(0.1);
		lazer1 movey( 2000, time );
		lazer1 waittill("movedone");
		lazer1 movey( -2000, time );
		lazer1 waittill("movedone");
	}
}


trap1()
{
	level endon("trigger");
part1 = getentarray("platmove1","targetname");
part2 = getentarray("platmove2","targetname");
trig = getent("trig_trap1","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
random = randomint(2);
	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
                break;
				
		default: return;
	}
}


trap2()
{
	level endon("trigger");
trap2a = getEnt("platmove3trap","targetname");
trig = getent("trig_trap2","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
trap2a notsolid();
}


trap3()
{
	level endon("trigger");
hardplatturn1a = getEnt("platturn1","targetname");
hardplatturn2a = getEnt("platturn2","targetname");
hardplatturn3a = getEnt("platturn3","targetname");
hardplatturn4a = getEnt("platturn4","targetname");
hardplatturn5a = getEnt("platturn5","targetname");
hardplatturn6a = getEnt("platturn6","targetname");
hardplatturn7a = getEnt("platturn7","targetname");
hardplatturn8a = getEnt("platturn8","targetname");
trig = getent("trig_trap3","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");

	while(1)
	{
	hardplatturn1a rotatePitch(360, 2, 0.2);
	hardplatturn2a rotatePitch(-360, 2, 0.2);
	hardplatturn3a rotatePitch(360, 2, 0.2);
	hardplatturn4a rotatePitch(-360, 2, 0.2);
	hardplatturn5a rotatePitch(360, 2, 0.2);
	hardplatturn6a rotatePitch(-360, 2, 0.2);
	hardplatturn7a rotatePitch(360, 2, 0.2);
	hardplatturn8a rotatePitch(-360, 2, 0.2);
	wait 1;
	}
}


trap4()
{
	level endon("trigger");
trig = getent("trig_trap4","targetname");
level._effect["c4"] = loadfx("explosions/custom_explo_small");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
thread trap4a();
thread trap4b();
}


trap4a()
{
trap = getEnt("trap4a","targetname");
level._effect["c4"] = loadfx("explosions/custom_explo_small");
wait 0.2;
trap PlaySound("grenade_explode_metal");
playFx(level._effect["c4"],trap.origin);
players = getEntArray("player","classname");	
for(k=0;k<players.size;k++)
{
	dist = Distance2D(players[k].origin, trap.origin);
	if(dist < 200)
	{
		players[k] suicide();
	}
	else if(dist < 240)
	{
		RadiusDamage( players[k].origin, 10, 60, 40);
	}
	else if(dist < 280)
	{
		RadiusDamage( players[k].origin, 10, 30, 10);
		}
	}
}


trap4b()
{
trap1 = getEnt("trap4b","targetname");
level._effect["c4"] = loadfx("explosions/custom_explo_small");
wait 0.2;
trap1 PlaySound("grenade_explode_metal");
playFx(level._effect["c4"],trap1.origin);
players = getEntArray("player","classname");	
for(k=0;k<players.size;k++)
{
	dist = Distance2D(players[k].origin, trap1.origin);
	if(dist < 200)
	{
		players[k] suicide();
	}
	else if(dist < 240)
	{
		RadiusDamage( players[k].origin, 10, 60, 40);
	}
	else if(dist < 280)
	{
		RadiusDamage( players[k].origin, 10, 30, 10);
		}
	}
}


trap5()
{
	level endon("trigger");
trap5a = getent("trap5a","targetname");
trap5b = getent("trap5b","targetname");
trap5c = getent("trap5c","targetname");
trig = getent("trig_trap5","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
	while(1)
	{
	trap5a rotateYaw(360, 3, 0.5, 0.5);
	trap5b rotateYaw(360, 3, 0.5, 0.5);
	wait 3;
	trap5a rotateYaw(-360, 3, 0.5, 0.5);
	trap5c rotateYaw(-360, 3, 0.5, 0.5);
	wait 3;
	trap5a rotateYaw(-360, 3, 0.5, 0.5);
	trap5b rotateYaw(-360, 3, 0.5, 0.5);
	wait 3;
	trap5a rotateYaw(360, 3, 0.5, 0.5);
	trap5c rotateYaw(360, 3, 0.5, 0.5);
	wait 3;
	}
}


trap6()
{
	level endon("trigger");
trap6a = getent("trap6a","targetname");
trap6b = getent("trap6b","targetname");
trap6c = getent("trap6c","targetname");
trig = getent("trig_trap6","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
	
	for(;;)
	{
	trap6a rotateroll(360, 2);
	wait 1;
	trap6b rotateYaw(360, 1);
	wait 1;
	trap6c rotateroll(360, 2);
	wait 1;
	trap6a rotateroll(360, 2);
	wait 1;
	trap6b rotateYaw(360, 1);
	wait 1;
	trap6c rotateroll(360, 2);
	wait 2;
	}
}


trap7()
{
	level endon("trigger");
trap7a = getent("trap7a","targetname");
trap7b = getent("trap7b","targetname");
trig = getent("trig_trap7","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");

	while(1)
	{
		trap7a moveZ(56,0.5);
		trap7b moveZ(-56,0.5);
		wait 0.5;
		trap7a moveZ(-56,0.5);
		trap7b moveZ(56,0.5);
		wait 0.5;
	}
}


trap8()
{
	level endon("trigger");
trap8a = getent("trap8a","targetname");
trig = getent("trig_trap8","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");

	while(1)
	{
	trap8a rotateYaw(360, 4);
	wait 3;
	}
}


trap9()
{
	level endon("trigger");
trap9a = getEnt("trap9a","targetname");
trig = getent("trig_trap9","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
trap9a moveX(900, 2);
wait 3;
trap9a moveX(-900, 2);

}


trap10()
{
	level endon("trigger");
trap10a = getent("trap10a","targetname");
trig = getent("trig_trap10","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
wait 0.5;

	while(1)
	{
	trap10a rotateYaw(360, 1);
	wait 1;
	}
}


trap11()
{
	level endon("trigger");
part1 = getentarray("trap11a","targetname");
part2 = getentarray("trap11b","targetname");
part3 = getentarray("trap11c","targetname");
part4 = getentarray("trap11d","targetname");
trig = getent("trig_trap11","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
random = randomint(2);
	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part4[randomInt(part4.size)] notsolid();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();
                break;
				
		default: return;
	}
}


trap12()
{
	level endon("trigger");
part1 = getentarray("trap12a","targetname");
part2 = getentarray("trap12b","targetname");
part3 = getentarray("trap12c","targetname");
trig = getent("trig_trap12","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	/* [AUTO DELETE] iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD"); */
}
else
trig delete();
/* [AUTO DELETE] user braxi\_rank::giveRankXP("", 90); */
trig SetHintString("^2Activated");
random = randomint(2);
	switch(random)
	{
		case 0:
				part1[randomInt(part1.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();
				break;
				
		case 1:	
				part2[randomInt(part2.size)] notsolid();
                break;
				
		default: return;
	}
}


actitpsetup() //TP ACTI & FX
{

thread actitp1();
thread actitp2();
thread actitp3();
thread actitpback1();
thread actitpback2();
thread actitpback3();

}


actitp1() // tp1acti
{
	trigacti1 = getEnt("trig_tpacti_1", "targetname");
	tpacti1 = getEnt("origin_tpacti_1", "targetname");
	
	for (;;)
	{
		trigacti1 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpacti1.origin);
		player setPlayerAngles(tpacti1.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitp2() // tp2acti
{
	trigacti2 = getEnt("trig_tpacti_2", "targetname");
	tpacti2 = getEnt("origin_tpacti_2", "targetname");
	
	for (;;)
	{
		trigacti2 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpacti2.origin);
		player setPlayerAngles(tpacti2.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitp3() // tp2acti
{
	trigacti3 = getEnt("trig_tpacti_3", "targetname");
	tpacti3 = getEnt("origin_tpacti_3", "targetname");
	
	for (;;)
	{
		trigacti3 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpacti3.origin);
		player setPlayerAngles(tpacti3.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitpback1() // tp1actiback
{
	trigactiback1 = getEnt("trig_tpacti_1_back", "targetname");
	tpactiback1 = getEnt("origin_tpacti_1_back", "targetname");
	
	for (;;)
	{
		trigactiback1 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpactiback1.origin);
		player setPlayerAngles(tpactiback1.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitpback2() // tp2actiback
{
	trigactiback2 = getEnt("trig_tpacti_2_back", "targetname");
	tpactiback2 = getEnt("origin_tpacti_2_back", "targetname");
	
	for (;;)
	{
		trigactiback2 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpactiback2.origin);
		player setPlayerAngles(tpactiback2.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


actitpback3() // tp2actiback
{
	trigactiback3 = getEnt("trig_tpacti_3_back", "targetname");
	tpactiback3 = getEnt("origin_tpacti_3_back", "targetname");
	
	for (;;)
	{
		trigactiback3 waittill("trigger", player);
		/* [AUTO DELETE] player iprintlnbold ("You have been teleported"); */
		player setOrigin(tpactiback3.origin);
		player setPlayerAngles(tpactiback3.angles);
		/* [AUTO DELETE] wait 10; */
	}
}


startdoor()
{
starta = getEnt("startdoor_a","targetname");
startb = getEnt("startdoor_b","targetname");
startc = getEnt("startdoor_c","targetname");

	{
	// startb waittill("trigger", player);
	startb delete();
	wait 0.1;
	/* [AUTO DELETE] iprintlnbold("^8Start door opened :]"); */
	wait 1;
	starta movez(-292, 4, 1, 1);
	wait 1;
	thread lvl1setup();
	wait 0.2;
	startc hide();
	startc notsolid();
	}
}


blueparticles()
{
bluepartic1 = getEnt("fx_bluefall1", "targetname");
bluepartic2 = getEnt("fx_bluefall2", "targetname");
bluepartic3 = getEnt("fx_bluefall3", "targetname");
bluepartic4 = getEnt("fx_bluefall4", "targetname");
bluepartic5 = getEnt("fx_bluefall5", "targetname");
bluepartic6 = getEnt("fx_bluefall6", "targetname");
bluepartic7 = getEnt("fx_bluefall7", "targetname");
bluepartic8 = getEnt("fx_bluefall8", "targetname");
bluepartic9 = getEnt("fx_bluefall9", "targetname");
bluepartic10 = getEnt("fx_bluefall10", "targetname");
bluepartic11 = getEnt("fx_bluefall11", "targetname");
bluepartic12 = getEnt("fx_bluefall12", "targetname");
bluepartic13 = getEnt("fx_bluefall13", "targetname");
bluepartic14 = getEnt("fx_bluefall14", "targetname");
bluepartic15 = getEnt("fx_bluefall15", "targetname");
bluepartic16 = getEnt("fx_bluefall16", "targetname");
bluepartic17 = getEnt("fx_bluefall17", "targetname");
bluepartic18 = getEnt("fx_bluefall18", "targetname");
bluepartic19 = getEnt("fx_bluefall19", "targetname");
bluepartic20 = getEnt("fx_bluefall20", "targetname");
bluepartic21 = getEnt("fx_bluefall21", "targetname");
bluepartic22 = getEnt("fx_bluefall22", "targetname");
bluepartic23 = getEnt("fx_bluefall23", "targetname");
bluepartic24 = getEnt("fx_bluefall24", "targetname");
bluepartic25 = getEnt("fx_bluefall25", "targetname");
bluepartic26 = getEnt("fx_bluefall26", "targetname");
bluepartic27 = getEnt("fx_bluefall27", "targetname");
bluepartic28 = getEnt("fx_bluefall28", "targetname");
bluepartic29 = getEnt("fx_bluefall29", "targetname");
level._effect[ "bluepartic" ] = loadfx( "fire/custom_fire" );
	
	while(1)
	{
	playFx(level._effect["bluepartic"],bluepartic1.origin);
	playFx(level._effect["bluepartic"],bluepartic2.origin);
	playFx(level._effect["bluepartic"],bluepartic3.origin);
	playFx(level._effect["bluepartic"],bluepartic4.origin);
	playFx(level._effect["bluepartic"],bluepartic5.origin);
	playFx(level._effect["bluepartic"],bluepartic6.origin);
	playFx(level._effect["bluepartic"],bluepartic7.origin);
	playFx(level._effect["bluepartic"],bluepartic8.origin);
	playFx(level._effect["bluepartic"],bluepartic9.origin);
	playFx(level._effect["bluepartic"],bluepartic10.origin);
	playFx(level._effect["bluepartic"],bluepartic11.origin);
	playFx(level._effect["bluepartic"],bluepartic12.origin);
	playFx(level._effect["bluepartic"],bluepartic13.origin);
	playFx(level._effect["bluepartic"],bluepartic14.origin);
	playFx(level._effect["bluepartic"],bluepartic15.origin);
	playFx(level._effect["bluepartic"],bluepartic16.origin);
	playFx(level._effect["bluepartic"],bluepartic17.origin);
	playFx(level._effect["bluepartic"],bluepartic18.origin);
	playFx(level._effect["bluepartic"],bluepartic19.origin);
	playFx(level._effect["bluepartic"],bluepartic20.origin);
	playFx(level._effect["bluepartic"],bluepartic21.origin);
	playFx(level._effect["bluepartic"],bluepartic22.origin);
	playFx(level._effect["bluepartic"],bluepartic23.origin);
	playFx(level._effect["bluepartic"],bluepartic24.origin);
	playFx(level._effect["bluepartic"],bluepartic25.origin);
	playFx(level._effect["bluepartic"],bluepartic26.origin);
	playFx(level._effect["bluepartic"],bluepartic27.origin);
	playFx(level._effect["bluepartic"],bluepartic28.origin);
	playFx(level._effect["bluepartic"],bluepartic29.origin);
	wait 1;
	}
}


lightningfxl()
{
fxlightning1 = getEnt("fx_lightning1","targetname");
fxlightning2 = getEnt("fx_lightning2","targetname");
level._effect[ "lightning" ] = loadfx( "weather/lightning_mp_farm" );

	while(1)
	{
	playFx(level._effect["lightning"],fxlightning1.origin);
	wait 6;
	playFx(level._effect["lightning"],fxlightning2.origin);
	wait 6;
	}
}


messages()
{
wait 10;
/* [AUTO DELETE] iprintlnBold("^5Welcome ^7to ^5SuX ^7Lolz ^5M^7ap ^5:^7]"); */
wait 2;

while(1)
	{
	
		/* [AUTO DELETE] iPrintLn("^1Report any bugs"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^1 xFire: ^7alex1528"); */
		wait 1;
		/* [AUTO DELETE] iPrintLn("^1Steam: ^7iswenzz1528 / SuX Lolz :]"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^1RIP ^2Raid-Gaming. xD"); */
		wait 4;
		/* [AUTO DELETE] iPrintLn("^3Map Made By: ^5SuX ^7Lolz :]"); */
		wait 8;
	
	}
}


guidcheckgod() //CHECK GOD GUID :]
{
god1 = "caa5eb5cf6bc6e1dadbcae1d5b7631e9";
sanictrig = getent("sanic_check","targetname");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		tempGuid = user getGUID();
		if(tempGuid == god1)
		{
		user detachAll();
		user setModel("shadow");  //Model Here
		/* [AUTO DELETE] user GiveWeapon( "raygun_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "raygun_mp" ); */
		/* [AUTO DELETE] iPrintLnBold(user.name + " Map ^5Creator ^7is ^2Connected ^7!!"); */
		wait 3;
		}
			else
			{
			wait 3;
		}

	
}
}


guidcheckvip() //CHECK GOD VIP :]
{
god1 = "2b496dc24a263701f20c7f209c8d844a";
god2 = "df7cd39f1d971b8986c9040e27e2c5f9";
god3 = "af61d705bd0d36655cd1197dd80650b9";
god4 = "2f5cd3bc8543ac4c5f629232e504a6e5";
sanictrig = getent("sanic_check_2","targetname");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		tempGuid = user getGUID();
		if((tempGuid == god1) || (tempGuid == god2) || (tempGuid == god3) || (tempGuid == god4))
		{
		user detachAll();
		user setModel("shadow");  //Model Here
		/* [AUTO DELETE] user GiveWeapon( "raygun_mp" ); */
		/* [AUTO DELETE] user GiveMaxAmmo( "raygun_mp" ); */
		/* [AUTO DELETE] iPrintLnBold ("^5VIP ^7is ^2Connected"); */
		wait 3;
		}
			else
			{
			wait 3;
		}

	
}
}


mapzor()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^5mp_dr_nighty" );
wait(6);
}


drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 90 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}


new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}


credits()
{
        self endon( "disconnect" );
 
        if( isDefined( self.credits_text ) )
                self.credits_text Destroy();
 
        self.credits_text = newHudElem();
        self.credits_text.y = 10;
        self.credits_text.alignX = "center";
        self.credits_text.alignY = "middle";
        self.credits_text.horzAlign = "center";
 
        self.credits_text.alpha = 0;
        self.credits_text.sort = -3;
        self.credits_text.fontScale = 1.6;
        self.credits_text.archieved = true;
 
        {
                self credit_roll( "^7Mapped ^5& ^7scripted by ^5SuX ^7Lolz :]", 5 );
				self credit_roll( "xFire:  alex1528  -  Steam: iswenzz1528 / SuX Lolz :]", 5);
				self credit_roll( "^7www.youtube^5.com/^7channel^5/^7UC1vxOXBzEF7W4g7TRU0C1rw", 5 );
        }
}


credit_roll( msg, time )
{
        self endon( "disconnect" );
 
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 1;
        self.credits_text setText( msg );
        wait( time );
        self.credits_text fadeOverTime(1);
        self.credits_text.alpha = 0;
        wait 1;
}


initMusic()
{
		level.music = [];
 
        i = 0;
		level.music[i]["artist"] = "Kindred";
		level.music[i]["title"] = "Glimmer";
		level.music[i]["alias"] = "music1";
		
		i++;
		level.music[i]["artist"] = "SizzleBird";
		level.music[i]["title"] = "In Love";
		level.music[i]["alias"] = "music2";
		
		i++;
		level.music[i]["artist"] = "Kindred";
		level.music[i]["title"] = "Tape Glow";
		level.music[i]["alias"] = "music3";
		
		i++;
		level.music[i]["artist"] = "Krewella";
		level.music[i]["title"] = "One Minute (Culture Code Remix)";
		level.music[i]["alias"] = "music4";
		
		i++;
		level.music[i]["artist"] = "Don Diablo";
		level.music[i]["title"] = "Silent Shadows (Mind Vortex Remix)";
		level.music[i]["alias"] = "music5";

		precacheShader( "black" );
		precacheShader( "white" );
}


musicMenu() //Music Menu by Blades's. :]
{
	
	self endon( "death" );
 
	self thread onDeath();
	self thread onDisconnect();
 
	self.hud_music = [];
	self.selection = 0;
 
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.35, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 180, 1, "left", "top", 1.8 );
	self.hud_music[i].sort = 883;
	self.hud_music[i] setText( ">^5>^7> Music ^5Menu ^7<^5<^7<" );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 270, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText( ">^5>^7> ^7Select ^7a ^7Song ^5<^7<^5<" );
 
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 288, 360, 1, "center", "top", 1.4 );
	self.hud_music[i].sort = 885;
	self.hud_music[i] setText( "Press ^5[^7USE^5]^7: ^5Play ^7Song" );

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 235, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText( "^5SuX ^7Lolz :]" );
 
	for( j = 0; j < level.music.size; j++ )
	{
		i++;
		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
		self.hud_music[i].sort = 882;
		self.hud_music[i].font = "objective";
 
		entry = level.music[j];
		self.hud_music[i] setText( entry["artist"] + " ^2-^7 " + entry["title"] );
	}
 
	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "white", 306, 17 );
 
	while( self.sessionstate == "playing" )
	{
		wait 0.1;
 
		if( self attackButtonPressed() )
		{
			self.hud_music[5+self.selection].alpha = 0.93;
 
			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;
 
			item = self.hud_music[5+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if( self useButtonPressed() )
		{
			/* [AUTO DELETE] iPrintln( "^5Now playing: ^7" + level.music[self.selection]["artist"]+" - ^2" +level.music[self.selection]["title"] ); */
 
			/* [AUTO DELETE] ambientPlay( level.music[self.selection]["alias"], 3 ); */
			self freezeControls(0);
			level notify ( "song_picked" );
			/* [AUTO DELETE] self braxi\_rank::giveRankXp( "trap_activation" ); */
			break;
		}
		else if( self meleeButtonPressed() )
		{
			self freezeControls(0);
			break;
		}
	}
 
	self cleanUp();
}


musictrig() //DJ
{
	trigger = getEnt ( "musicmenu", "targetname" );
	trigger setHintString( "Press ^5[^7USE^5]^7to ^5Choose ^7Music" );
 
	trigger waittill( "trigger", player );
	trigger delete();
	level endon ( "song_picked" );
	player thread musicMenu();
	player freezeControls(1);
}


onDeath() //Music Term.
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}


onDisconnect() //Music Term.
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}


watterFX()
{

	drown_waterage = getentarray("drown_water","targetname");
	if (isDefined("drown_waterage"))
	{
		precacheShader("black");
		precacheShader("white");



		level.barsize = 288;
		level.drown_watertime = 2;
		level.hurttime = 1;

		for(d = 0; d < drown_waterage.size; d++)
		{
			drown_waterage[d] thread water();
		}
	}
}


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
//	level.player allowProne(false);
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
		/* [AUTO DELETE] iPrintLn( self.name, deathmethod1); */
		if (randb == 1)
		/* [AUTO DELETE] iPrintLn( self.name, deathmethod2); */
		if (randb == 2)
		/* [AUTO DELETE] iPrintLn( self.name, deathmethod3); */
		if (randb == 3)
		/* [AUTO DELETE] iPrintLn( self.name, deathmethod4); */
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


createhud(messages)
{
hud_start = NewHudElem();
hud_start.alignX = "center";
hud_start.alignY = "middle";
hud_start.horzalign = "center";
hud_start.vertalign = "middle";
hud_start.alpha = 1;
hud_start.x = 0;
hud_start.y = -150;
hud_start.font = "objective";
hud_start.fontscale = 2;
hud_start.glowalpha = 1;
hud_start.glowcolor = (1,0,0);
hud_start setText(messages);
hud_start SetPulseFX( 100, 4000, 500 );
wait 7;
if(isdefined(hud_start))
	hud_start destroy();
}


endtrigantibug(trig)
{
self common_scripts\utility::waittill_any("death","disconnect");
level.jatekosend = 0;
trig SetHintString("^1Press &&1 !..");
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


//DECO\\

turnstuff()
{

thread arrow1();
thread arrow2();
thread arrow3();
thread lolzlogo1();
thread lolzlogo2();
thread lolzlogo3();
thread lolzlogo4();

}


lolzlogo1()
{
    lolz1 = getent("lolz_turn_1","targetname");
	
    while(1)
    {
        lolz1 rotateYaw(360, 5);
		wait 4;
    }
}


lolzlogo2()
{
    lolz2 = getent("lolz_turn_2","targetname");
	
    while(1)
    {
        lolz2 rotateYaw(360, 5);
		wait 4;
    }
}


lolzlogo3()
{
    lolz3 = getent("lolz_turn_3","targetname");
	
    while(1)
    {
        lolz3 rotateYaw(360, 5);
		wait 4;
    }
}


lolzlogo4()
{
    lolz4 = getent("lolz_turn_4","targetname");
	
    while(1)
    {
        lolz4 rotateYaw(360, 5);
		wait 4;
    }
}


arrow1()
{
    arrow1 = getent("arrow1","targetname");
	
    while(1)
    {
        arrow1 moveY(-60, 3, 0.5, 0.5);
		wait 3;
		arrow1 moveY(60, 3, 0.5, 0.5);
		wait 3;
    }
}


arrow2()
{
    arrow2 = getent("arrow2","targetname");
	
    while(1)
    {
        arrow2 moveY(-60, 3, 0.5, 0.5);
		wait 3;
		arrow2 moveY(60, 3, 0.5, 0.5);
		wait 3;
    }
}


arrow3()
{
    arrow3 = getent("arrow3","targetname");
	
    while(1)
    {
        arrow3 moveY(-60, 3, 0.5, 0.5);
		wait 3;
		arrow3 moveY(60, 3, 0.5, 0.5);
		wait 3;
    }
}


//DECO\\

//SECRETSETUP\\

secretsetup()
{

showsecret = getEnt("secretshow1","targetname");
secret1trig = getEnt("secretsenter1","targetname");
showsecret hide();
showsecret notsolid();
secret1trig triggerOff();

// thread secret1();
thread tpsecretroom();
thread easysecret();
thread hardsecret();
thread giverpg1();
thread giverpg2();
thread giverpg3();
thread giverpg4();
thread giverpg5();

}


hardsecret()
{

thread hardenter();
thread hardend();
thread hard1();
thread hard2();
thread hard3();
thread hard4();
thread hard5();

}


hardend()
{
	hztrig = getEnt("hardfinish_trig","targetname");
	hztp = getEnt("tp_lvl_4","targetname");

	for(;;)
	{
		hztrig waittill("trigger", player);
		// player setOrigin(hztp.origin);
		// player setPlayerAngles(hztp.angles);
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 800); */
		player thread sr\api\_speedrun::finishWay("secret_1");
		player notify("finished");
	}
}


hardenter()
{
	htrig = getEnt("secret1hard_trig","targetname");
	htp = getEnt("secret1hard_tp","targetname");

	for(;;)
	{
		htrig waittill("trigger", player);
		player setOrigin(htp.origin);
		player setPlayerAngles(htp.angles);
	}
}


hard1()
{
	h1trig = getEnt("hard1_trig","targetname");
	h1tp = getEnt("secret1hard_tp","targetname");

	for(;;)
	{
		h1trig waittill("trigger", player);
		player setOrigin(h1tp.origin);
		player setPlayerAngles(h1tp.angles);
	}
}


hard2()
{
	h2trig = getEnt("hard2_trig","targetname");
	h2tp = getEnt("hard2_tp","targetname");

	for(;;)
	{
		h2trig waittill("trigger", player);
		player setOrigin(h2tp.origin);
		player setPlayerAngles(h2tp.angles);
	}
}


hard3()
{
	h3trig = getEnt("hard3_trig","targetname");
	h3tp = getEnt("hard3_tp","targetname");

	for(;;)
	{
		h3trig waittill("trigger", player);
		player setOrigin(h3tp.origin);
		player setPlayerAngles(h3tp.angles);
	}
}


hard4()
{
	h4trig = getEnt("hard4_trig","targetname");
	h4tp = getEnt("hard4_tp","targetname");

	for(;;)
	{
		h4trig waittill("trigger", player);
		player setOrigin(h4tp.origin);
		player setPlayerAngles(h4tp.angles);
	}
}


hard5()
{
	h5trig = getEnt("hard5_trig","targetname");
	h5tp = getEnt("hard5_tp","targetname");

	for(;;)
	{
		h5trig waittill("trigger", player);
		player setOrigin(h5tp.origin);
		player setPlayerAngles(h5tp.angles);
	}
}


easysecret()
{

thread easyenter();
thread easyend();
thread easy1();
thread easy2();
thread easy3();
thread easy4();
thread easy5();

}


easyend()
{
	ez0trig = getEnt("easyfinish_trig","targetname");
	ez0tp = getEnt("tp_lvl3","targetname");

	for(;;)
	{
		ez0trig waittill("trigger", player);
		// player setOrigin(ez0tp.origin);
		// player setPlayerAngles(ez0tp.angles);
		/* [AUTO DELETE] player braxi\_rank::giveRankXP("", 500); */
		player thread sr\api\_speedrun::finishWay("secret_0");
		player notify("finished");
	}
}


easyenter()
{
	eztrig = getEnt("secret1easy_trig","targetname");
	eztp = getEnt("secret1easy_tp","targetname");

	for(;;)
	{
		eztrig waittill("trigger", player);
		player setOrigin(eztp.origin);
		player setPlayerAngles(eztp.angles);
	}
}


easy1()
{
	ez1trig = getEnt("easy1_trig","targetname");
	ez1tp = getEnt("secret1easy_tp","targetname");

	for(;;)
	{
		ez1trig waittill("trigger", player);
		player setOrigin(ez1tp.origin);
		player setPlayerAngles(ez1tp.angles);
	}
}


easy2()
{
	ez2trig = getEnt("easy2_trig","targetname");
	ez2tp = getEnt("easy2_tp","targetname");

	for(;;)
	{
		ez2trig waittill("trigger", player);
		player setOrigin(ez2tp.origin);
		player setPlayerAngles(ez2tp.angles);
	}
}


easy3()
{
	ez3trig = getEnt("easy3_trig","targetname");
	ez3tp = getEnt("easy3_tp","targetname");

	for(;;)
	{
		ez3trig waittill("trigger", player);
		player setOrigin(ez3tp.origin);
		player setPlayerAngles(ez3tp.angles);
	}
}


easy4()
{
	ez4trig = getEnt("easy4_trig","targetname");
	ez4tp = getEnt("easy4_tp","targetname");

	for(;;)
	{
		ez4trig waittill("trigger", player);
		player setOrigin(ez4tp.origin);
		player setPlayerAngles(ez4tp.angles);
	}
}


easy5()
{
	ez5trig = getEnt("easy5_trig","targetname");
	ez5tp = getEnt("easy5_tp","targetname");

	for(;;)
	{
		ez5trig waittill("trigger", player);
		player setOrigin(ez5tp.origin);
		player setPlayerAngles(ez5tp.angles);
	}
}


tpsecretroom()
{
	secret1trig = getEnt("secretsenter1","targetname");
	secret1tp = getEnt("secret1tp","targetname");

	for(;;)
	{
		secret1trig waittill("trigger", player);
		player setOrigin(secret1tp.origin);
		player setPlayerAngles(secret1tp.angles);
		player thread countdown();
	}
}


secret1()
{
open = getEnt("secret1shoot","targetname");
showsecret = getEnt("secretshow1","targetname");
secret1trig = getEnt("secretsenter1","targetname");

	{
	open waittill("trigger",player);
	/* [AUTO DELETE] iprintlnbold("^5Secret ^7Opened"); */
	showsecret show();
	showsecret solid();
	secret1trig triggerOn();
	}

}


giverpg1()
{
	giverpg1 = getEnt("give_rpg1", "targetname");
	
	for(;;)
	{
		giverpg1 waittill("trigger", player);
		player giveweapon("rpg_mp");
		player switchtoweapon("rpg_mp"); 
		player givemaxammo("rpg_mp"); 
		player iprintlnbold("^5EPIC RPG *fortnite dance* !!");
	}
}


giverpg2()
{
	giverpg2 = getEnt("give_rpg2", "targetname");
	
	for(;;)
	{
		giverpg2 waittill("trigger", player);
		player giveweapon("rpg_mp");
		player switchtoweapon("rpg_mp"); 
		player givemaxammo("rpg_mp"); 
		player iprintlnbold("^5EPIC RPG *fortnite dance* !!");
	}
}


giverpg3()
{
	giverpg3 = getEnt("give_rpg3", "targetname");
	
	for(;;)
	{
		giverpg3 waittill("trigger", player);
		player giveweapon("rpg_mp");
		player switchtoweapon("rpg_mp"); 
		player givemaxammo("rpg_mp"); 
		player iprintlnbold("^5EPIC RPG *fortnite dance* !!");
	}
}


giverpg4()
{
	giverpg4 = getEnt("give_rpg4", "targetname");
	
	for(;;)
	{
		giverpg4 waittill("trigger", player);
		player giveweapon("rpg_mp");
		player switchtoweapon("rpg_mp"); 
		player givemaxammo("rpg_mp"); 
		player iprintlnbold("^5EPIC RPG *fortnite dance* !!");
	}
}


giverpg5()
{
	giverpg5 = getEnt("give_rpg5", "targetname");
	
	for(;;)
	{
		giverpg5 waittill("trigger", player);
		player giveweapon("rpg_mp");
		player switchtoweapon("rpg_mp"); 
		player givemaxammo("rpg_mp"); 
		player iprintlnbold("^5EPIC RPG *fortnite dance* !!");
	}
}


//SECRETSETUP\\

end() //First D:
{
trigger = GetEnt( "end", "targetname" );
	{
	trigger waittill ("trigger", user);
		{
		/* [AUTO DELETE] iprintlnbold( "^7 " + user.name + " ^5Finished First^7!!"); */
		wait 0.1;
		}
	}
}


games() //Select Rooms
{
// level.games_trig = getEnt( "minigames", "targetname");
// games = getEnt( "minigames_ori", "targetname" );

// while(1)
// {
// level.games_trig waittill( "trigger", player );
// if( !isDefined( level.games_trig ) )
// return;

// player SetPlayerAngles( games.angles );
// player setOrigin( games.origin );
//  [AUTO DELETE] iPrintlnBold( " ^5" + player.name + " ^7has ^5entered ^7the ^5game ^7selection !^5!^7!" ); 
// /* [AUTO DELETE] player TakeAllWeapons(); */
// player antiglitch();


// while( isAlive( player ) && isDefined( player ) )
// if( isDefined( level.activ ) && isAlive( level.activ ) )
// /* [AUTO DELETE] wait 1; */
// }
}

antiglitch() //ng1
{ 
self common_scripts\utility::waittill_any("death","disconnect");
/* [AUTO DELETE] iPrintlnBold("^5"+self.name+" ^7is ^5dead"); */ 
/* [AUTO DELETE] iPrintlnBold("^5Selection ^7Room ^5is ^5now ^7open^5!!"); */ 
}


waitdead() //ng2
{
weapons = getent("weapons_trig","targetname");
bounce = getent("bounce_trig","targetname");
sniper = getent("sniper_trig","targetname");
knife = getent("knife_trig","targetname");
run = getent("run_trig","targetname");
weapons triggerOff();
bounce triggerOff();
sniper triggerOff();
knife triggerOff();
run triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
activator = GetActivator();
activator freezeControls(false);
weapons triggerOn();
bounce triggerOn();
sniper triggerOn();
knife triggerOn();
run triggerOn();
}


sniper() //Sniper Room
{
sniper = getent("sniper_trig","targetname");
old = getent("old_trigger","targetname");
jumper = getent("origin_jumper_snip","targetname");
acti = getent("origin_acti_snip","targetname");
for(;;)
{
	sniper waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	/* [AUTO DELETE] player giveweapon("m40a3_mp"); */
	/* [AUTO DELETE] activator giveweapon("m40a3_mp"); */
	/* [AUTO DELETE] player giveweapon("intervention_mp"); */
	/* [AUTO DELETE] activator giveweapon("intervention_mp"); */
	thread createhud(player.name + " ^5selected ^7snipah ^4war!");
	wait 5;
	/* [AUTO DELETE] player iprintlnbold("^5FIGHT ^7!!!"); */
	/* [AUTO DELETE] activator iprintlnbold("^5FIGHT ^7!!!"); */
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("m40a3_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("m40a3_mp"); */
	/* [AUTO DELETE] player givemaxammo("m40a3_mp"); */
	/* [AUTO DELETE] activator givemaxammo("m40a3_mp"); */
	}
}


sniperfail()
{
	sniperfail = getEnt("trigger_room1_fail", "targetname");
	swagtp = getEnt("origin_acti_snip", "targetname");
	
	for(;;)
	{
		sniperfail waittill("trigger", player);
		player setOrigin(swagtp.origin);
		player setPlayerAngles(swagtp.angles);
	}
}


weapons() //weapons room :)
{
weapons = getent("weapons_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_weapons","targetname");
acti = getent("origin_acti_weapons","targetname");
for(;;)
{
	weapons waittill("trigger", player);
	old delete();
	player thread waitdead();
	thread createhud(player.name + " ^5Selected ^7Weapons ^5Way ^7!^5!^7!");
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	wait 5;
	/* [AUTO DELETE] IPrintLnbold("^2Fight!!!."); */
	i = randomintrange(0, 8);
	weapon = "rpg_mp";
	if(i == 0)
	{
		weapon = "rpg_mp";
	}
	else if(i == 1)
	{
		weapon = "winchester1200_mp";
	}
	else if(i == 2)
	{
		weapon = "mp44_mp";
	}
	else if(i == 3)
	{
		weapon = "ak47_mp";
	}
	else if(i == 4)
	{
		weapon = "rpd_mp";
	}
	else if(i == 5)
	{
		weapon = "p90_silencer_mp";
	}
	else if(i == 6)
	{
		weapon = "saw_grip_mp";
	}
	else if(i == 7)
	{
		weapon = "uzi_silencer_mp";
	}
	/* [AUTO DELETE] player giveweapon("knife_mp"); */
	/* [AUTO DELETE] activator giveweapon("knife_mp"); */
	/* [AUTO DELETE] player giveweapon(weapon); */
	/* [AUTO DELETE] activator giveweapon(weapon); */
	/* [AUTO DELETE] activator givemaxammo(weapon); */
	/* [AUTO DELETE] player givemaxammo(weapon); */
	wait .1;
	/* [AUTO DELETE] player switchtoweapon(weapon); */
	/* [AUTO DELETE] activator switchtoweapon(weapon); */
	player freezeControls(false);
	activator freezeControls(false);
	}
}


bounceroom() //bounce ruum :p
{
bounce = getent("bounce_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_bounce","targetname");
acti = getent("origin_acti_bounce","targetname");
for(;;)
{
	bounce waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] activator giveweapon("knife_mp"); */
	/* [AUTO DELETE] player giveweapon("knife_mp"); */
	thread createhud(player.name + " ^5Selected 7bounce ^5Room ^7:]");
	wait 5;
	/* [AUTO DELETE] player iprintlnbold("^5GO^5!!!"); */
	/* [AUTO DELETE] activator iprintlnbold("^5GO^5!!!"); */
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("knife_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("knife_mp"); */
	}
}


givesniper() //bounce room
{
givesnip = getEnt("givesnip_trig","targetname");

	for (;;)
	{
		givesnip waittill("trigger", player);
		/* [AUTO DELETE] player takeallweapons(); */
		wait 0.1;
		/* [AUTO DELETE] player giveweapon("intervention_mp"); */
		/* [AUTO DELETE] player giveweapon("deserteaglegold_mp"); */
		/* [AUTO DELETE] player switchtoweapon("intervention_mp"); */
		/* [AUTO DELETE] player givemaxammo("intervention_mp"); */
		/* [AUTO DELETE] player givemaxammo("deserteaglegold_mp"); */
	}
}


bouncejumperfail() // when jumper fail in jump room
{
	bouncejumperfail = getEnt("trigger_respawnjumper_bounce", "targetname");
	tpbouncejumperfail = getEnt("origin_jumper_bounce", "targetname");
	
	for (;;)
	{
		bouncejumperfail waittill("trigger", player);
		player setOrigin(tpbouncejumperfail.origin);
		player setPlayerAngles(tpbouncejumperfail.angles);
	}
}


bounceactifail() // when acti fail in jump room
{
	bounceactifail = getEnt("trigger_respawnacti_bounce", "targetname");
	tpbounceactifail = getEnt("origin_acti_bounce", "targetname");
	
	for (;;)
	{
		bounceactifail waittill("trigger", player);
		player setOrigin(tpbounceactifail.origin);
		player setPlayerAngles(tpbounceactifail.angles);
	}
}


run() //Speedrun room
{
run = getent("run_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_run","targetname");
acti = getent("origin_acti_run","targetname");
for(;;)
{
	run waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] activator giveweapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] player giveweapon("deserteaglegold_mp"); */
	thread createhud(player.name + " ^5Selected ^7spe^5ed ^7Ru^5n ^7Way !^5!^7!");
	/* [AUTO DELETE] wait 5; */
	/* [AUTO DELETE] player iprintlnbold("^5GO^5!!!"); */
	/* [AUTO DELETE] activator iprintlnbold("^5GO^5!!!"); */
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("deserteaglegold_mp"); */
	}
}


//RUNWAYLOOOL\\

runwaysetup()
{

thread respawnactirun1();
thread respawnactirun2();
thread respawnactirun3();
thread respawnjumperrun1();
thread respawnjumperrun2();
thread respawnjumperrun3();
thread tpactirun1();
thread tpactirun2();
thread tpjumperrun1();
thread tpjumperrun2();
thread ifjumperwin();
thread ifactiwin();

}


respawnactirun1() // when acti fall lvl 1
{
	trigrespawnactirun1 = getEnt("trigger_acti_run_lvl1","targetname");
	tpactirun1 = getEnt("origin_acti_run", "targetname");
	
	for (;;)
	{
		trigrespawnactirun1 waittill("trigger", player);
		player setOrigin(tpactirun1.origin);
		player setPlayerAngles(tpactirun1.angles);
	}
}


respawnactirun2() // when acti fall lvl 2
{
	trigrespawnactirun2 = getEnt("trigger_acti_run_lvl2","targetname");
	tpactirun2 = getEnt("origin_acti_end_lvl2", "targetname");
	
	for (;;)
	{
		trigrespawnactirun2 waittill("trigger", player);
		player setOrigin(tpactirun2.origin);
		player setPlayerAngles(tpactirun2.angles);
	}
}


respawnactirun3() // when acti fall lvl 3
{
	trigrespawnactirun3 = getEnt("trigger_acti_run_lvl3","targetname");
	tpactirun3 = getEnt("origin_acti_end_lvl3", "targetname");
	
	for (;;)
	{
		trigrespawnactirun3 waittill("trigger", player);
		player setOrigin(tpactirun3.origin);
		player setPlayerAngles(tpactirun3.angles);
	}
}


respawnjumperrun1() // when jumper fall lvl 1
{
	trigrespawnjumperrun1 = getEnt("trigger_jumper_run_lvl1","targetname");
	tpjumperrun1 = getEnt("origin_jumper_run", "targetname");
	
	for (;;)
	{
		trigrespawnjumperrun1 waittill("trigger", player);
		player setOrigin(tpjumperrun1.origin);
		player setPlayerAngles(tpjumperrun1.angles);
	}
}


respawnjumperrun2() // when jumper fall lvl 2
{
	trigrespawnjumperrun2 = getEnt("trigger_jumper_run_lvl2","targetname");
	tpjumperrun2 = getEnt("origin_jumper_end_lvl2", "targetname");
	
	for (;;)
	{
		trigrespawnjumperrun2 waittill("trigger", player);
		player setOrigin(tpjumperrun2.origin);
		player setPlayerAngles(tpjumperrun2.angles);
	}
}


respawnjumperrun3() // when jumper fall lvl 3
{
	trigrespawnjumperrun3 = getEnt("trigger_jumper_run_lvl3","targetname");
	tpjumperrun3 = getEnt("origin_jumper_end_lvl3", "targetname");
	
	for (;;)
	{
		trigrespawnjumperrun3 waittill("trigger", player);
		player setOrigin(tpjumperrun3.origin);
		player setPlayerAngles(tpjumperrun3.angles);
	}
}


tpactirun1() // tp acti to the lvl 2
{
	trigactirun1 = getEnt("trigger_acti_end_lvl1", "targetname");
	tpactirun2 = getEnt("origin_acti_end_lvl2", "targetname");
	
	for (;;)
	{
		trigactirun1 waittill("trigger", player);
		player setOrigin(tpactirun2.origin);
		player setPlayerAngles(tpactirun2.angles);
	}
}


tpactirun2() // tp acti to the lvl 3
{
	trigactirun2 = getEnt("trigger_acti_end_lvl2", "targetname");
	tpactirun3 = getEnt("origin_acti_end_lvl3", "targetname");
	
	for (;;)
	{
		trigactirun2 waittill("trigger", player);
		player setOrigin(tpactirun3.origin);
		player setPlayerAngles(tpactirun3.angles);
	}
}


tpjumperrun1() // tp jumper to the lvl 2
{
	trigjumperrun1 = getEnt("trigger_jumper_end_lvl1", "targetname");
	tpjumperrun2 = getEnt("origin_jumper_end_lvl2", "targetname");
	
	for (;;)
	{
		trigjumperrun1 waittill("trigger", player);
		player setOrigin(tpjumperrun2.origin);
		player setPlayerAngles(tpjumperrun2.angles);
	}
}


tpjumperrun2() // tp jumper to the lvl 3
{
	trigjumperrun2 = getEnt("trigger_jumper_end_lvl2", "targetname");
	tpjumperrun3 = getEnt("origin_jumper_end_lvl3", "targetname");
	
	for (;;)
	{
		trigjumperrun2 waittill("trigger", player);
		player setOrigin(tpjumperrun3.origin);
		player setPlayerAngles(tpjumperrun3.angles);
	}
}


ifactiwin() //defined who win*
{
tpactirun4 = getEnt("origin_acti_end_lvl4", "targetname");
tpjumperrun4 = getEnt("origin_jumper_end_lvl4", "targetname");
actiwinrun = getEnt("trigger_acti_win_run","targetname");
definedjumper = getEnt("trigger_jumper_test_run","targetname");

for (;;)
{
	definedjumper waittill("trigger", player);
	actiwinrun waittill("trigger", activator);
	activator = GetActivator();
	/* [AUTO DELETE] wait 0.2; */
	activator setOrigin(tpactirun4.origin);
	activator setPlayerAngles(tpactirun4.angles);
	player setOrigin(tpjumperrun4.origin);
	player setPlayerAngles(tpjumperrun4.angles);
	/* [AUTO DELETE] wait 0.2; */
	/* [AUTO DELETE] activator giveweapon("intervention_mp"); */
	/* [AUTO DELETE] activator givemaxammo("intervention_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("intervention_mp"); */
	player freezeControls(true);
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] wait 0.2; */
}
}


ifjumperwin() // defined who win**
{
tpactirun4 = getEnt("origin_acti_end_lvl4", "targetname");
tpjumperrun4 = getEnt("origin_jumper_end_lvl4", "targetname");
jumperwinrun = getEnt("trigger_jumper_win_run","targetname");

for (;;)
{
	jumperwinrun waittill("trigger", player);
	activator = GetActivator();
	/* [AUTO DELETE] wait 0.2; */
	player setOrigin(tpjumperrun4.origin);
	player setPlayerAngles(tpjumperrun4.angles);
	activator setOrigin(tpactirun4.origin);
	activator setPlayerAngles(tpactirun4.angles);
	/* [AUTO DELETE] wait 0.2; */
	/* [AUTO DELETE] player giveweapon("intervention_mp"); */
	/* [AUTO DELETE] player givemaxammo("intervention_mp"); */
	/* [AUTO DELETE] player switchtoweapon("intervention_mp"); */
	activator freezeControls(true);
	/* [AUTO DELETE] activator takeallweapons(); */
	/* [AUTO DELETE] wait 0.2; */
}
}


//RUNWAYLOOOL\\

knife() //Knife room lel
{
knife = getent("knife_trig","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_knife","targetname");
acti = getent("origin_acti_knife","targetname");
for(;;)
{
	knife waittill("trigger", player);
	old delete();
	player thread waitdead();
	activator = GetActivator();
	/* [AUTO DELETE] player takeallweapons(); */
	/* [AUTO DELETE] activator takeallweapons(); */
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] activator giveweapon("tomahawk_mp"); */
	/* [AUTO DELETE] player giveweapon("tomahawk_mp"); */
	thread createhud(player.name + " ^5Selected ^7Knife ^5ruum ^7!");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("tomahawk_mp"); */
	/* [AUTO DELETE] activator switchtoweapon("tomahawk_mp"); */
	}
}


bounce()
{
	for(;;)
	{
		self waittill("trigger", p);

		if(!isDefined(p.bouncing))
			p thread player_bounce(self);
	}
}


player_bounce(trigger)
{
	self.bouncing = true;

	vel = self getVelocity();

	temp0 = (((vel[0] < 350 && vel[0] > 0) || (vel[0] > -350 && vel[0] < 0)));
	temp1 = (((vel[1] < 350 && vel[1] > 0) || (vel[1] > -350 && vel[1] < 0)));

	if((!temp0 && !temp1) || vel[2] > -350)
	{
		wait 1;

		self.bouncing = undefined;
		return;
	}

	health    = self.health;
	maxHealth = self.maxHealth;
	self.health    = 1000000;
	self.maxhealth = 1000000;

	setDvar("g_knockback", (vel[2]*-9)-500);
	self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", self.origin, (0,0,1) , "none", 0);

	wait 0.05;
	setDvar("g_knockback", level.knockback);

	self.health    = health;
	self.maxhealth = maxHealth;

	while(self isTouching(trigger))
		wait 0.05;

	self.bouncing = undefined;
}


old() //Old way ;D
{
fakewall = getent("old_wall","targetname");
old = getent("old_trig","targetname");
jumper = getent("origin_jumper_old","targetname");
acti = getent("origin_acti_old","targetname");
for(;;)
{
	old waittill("trigger", player);
	old delete();
	player thread waitdead();
	thread createhud(player.name + " ^5Selected ^1Old Way C;");
	fakewall show();
	fakewall solid();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	/* [AUTO DELETE] player giveweapon("deserteaglegold_mp"); */
	/* [AUTO DELETE] wait 5; */
	player freezeControls(false);
	activator freezeControls(false);
	/* [AUTO DELETE] player switchtoweapon("deserteaglegold_mp"); */
	}
}


oldfakewall() //For old way
{
fakewall = getent("old_wall","targetname");
fakewall hide();
fakewall notsolid();
}


ringstart()
{
ring1 = getEnt("ringturn1","targetname");
ring2 = getEnt("ringturn2","targetname");
ring3 = getEnt("ringturn3","targetname");

	while(1)
	{
	ring1 rotatePitch(-360, 16);
	ring2 rotatePitch(360, 16);
	ring3 rotatePitch(-360, 16);
	wait 8;
	}
}


tplvl1()
{
	triglvl1 = getEnt("trig_lvl_1", "targetname");
	tplvl1 = getEnt("tp_lvl_1", "targetname");

	for(;;)
	{
		triglvl1 waittill("trigger", player);
		player setOrigin(tplvl1.origin);
		player setPlayerAngles(tplvl1.angles);
	}
}


tplvl2()
{
	triglvl2 = getEnt("trig_lvl_2", "targetname");
	tplvl2 = getEnt("tp_lvl_2", "targetname");

	for(;;)
	{
		triglvl2 waittill("trigger", player);
		player setOrigin(tplvl2.origin);
		player setPlayerAngles(tplvl2.angles);
	}
}


tplvl3()
{
	triglvl3 = getEnt("trig_lvl3", "targetname");
	tplvl3 = getEnt("tp_lvl3", "targetname");

	for(;;)
	{
		triglvl3 waittill("trigger", player);
		player setOrigin(tplvl3.origin);
		player setPlayerAngles(tplvl3.angles);
	}
}


tplvl4()
{
	triglvl4 = getEnt("trig_lvl4", "targetname");
	tplvl4 = getEnt("tp_lvl_4", "targetname");

	for(;;)
	{
		triglvl4 waittill("trigger", player);
		player setOrigin(tplvl4.origin);
		player setPlayerAngles(tplvl4.angles);
	}
}


tplvl5()
{
	triglvl5 = getEnt("trig_lvl5", "targetname");
	tplvl5 = getEnt("tp_lvl_5", "targetname");

	for(;;)
	{
		triglvl5 waittill("trigger", player);
		player setOrigin(tplvl5.origin);
		player setPlayerAngles(tplvl5.angles);
	}
}


lvl2setup()
{
lvl2actia = getEnt("lvl2acti_a","targetname");

	{
	lvl2actia waittill("trigger", player);
	thread carrerturn();
	wait 0.2;
	}
}


carrerturn()
{
carrturn2a = getEnt("carrturn2","targetname");
carrturn3a = getEnt("carrturn3","targetname");
carrturn4a = getEnt("carrturn4","targetname");
carrturn5a = getEnt("carrturn5","targetname");
carrturn6a = getEnt("carrturn6","targetname");
carrturn7a = getEnt("carrturn7","targetname");
carrturn8a = getEnt("carrefix1","targetname");
carrturn8b = getEnt("carrefix2","targetname");
carrturn9a = getEnt("carrturn9","targetname");
carrturn10a = getEnt("carrturn10","targetname");
carrturn11a = getEnt("carrturn11","targetname");
carrturn12a = getEnt("carrturn12","targetname");
carrturn13a = getEnt("carrturn13","targetname");
carrturn14a = getEnt("carrturn14","targetname");
carrturn16a = getEnt("carrturn16","targetname");
wait 0.02;

	{
	carrturn2a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn3a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn4a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn5a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn6a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn9a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn10a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn11a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn12a rotateRoll(-360, 16, 3, 0);
	wait 0.1;
	carrturn13a rotateRoll(-360, 16, 3, 0);
	wait 12;
	thread carrerturnloop();
	wait 0.2;
	}
}


carrerturnloop()
{
carrturn2a = getEnt("carrturn2","targetname");
carrturn3a = getEnt("carrturn3","targetname");
carrturn4a = getEnt("carrturn4","targetname");
carrturn5a = getEnt("carrturn5","targetname");
carrturn6a = getEnt("carrturn6","targetname");
carrturn7a = getEnt("carrturn7","targetname");
carrturn9a = getEnt("carrturn9","targetname");
carrturn10a = getEnt("carrturn10","targetname");
carrturn11a = getEnt("carrturn11","targetname");
carrturn12a = getEnt("carrturn12","targetname");
carrturn13a = getEnt("carrturn13","targetname");
carrturn14a = getEnt("carrturn14","targetname");

	while(1)
	{
	carrturn2a rotateRoll(-360, 16);
	wait 0.1;
	carrturn3a rotateRoll(-360, 16);
	wait 0.1;
	carrturn4a rotateRoll(-360, 16);
	wait 0.1;
	carrturn5a rotateRoll(-360, 16);
	wait 0.1;
	carrturn6a rotateRoll(-360, 16);
	wait 0.1;
	carrturn9a rotateRoll(-360, 16);
	wait 0.1;
	carrturn10a rotateRoll(-360, 16);
	wait 0.1;
	carrturn11a rotateRoll(-360, 16);
	wait 0.1;
	carrturn12a rotateRoll(-360, 16);
	wait 0.1;
	carrturn13a rotateRoll(-360, 16);
	wait 12;
	}
}


lvl1setup()
{
	thread platmove1();
	wait 0.5;
	thread murmove1();
	wait 0.5;
	thread murmove2();
	thread platformmove1();
	wait 0.5;
	thread bouncemove1();
	wait 0.5;
	thread hardplacementsetup();
	wait 0.5;
	thread bouncemove2();
	wait 1.3;
	thread annoplacement();
	wait 1.7;
	thread platmove2();
	wait 3;
	thread platformemove1();
	wait 1;
	thread platformemove2();
	wait 0.2;
}


hardplacementsetup()
{

	thread hardplacement1();
	wait 0.2;
	thread hardplacement2();

}


hardplacement1()
{
platformmove2a = getEnt("platform1","targetname");
platformmove3a = getEnt("platform2","targetname");
platformmove4a = getEnt("platform3","targetname");

	{
	platformmove2a moveZ(468, 2);
	wait 0.5;
	platformmove3a moveZ(468, 2);
	wait 0.5;
	platformmove4a moveZ(468, 2);
	}
}


hardplacement2()
{
hardplat1 = getEnt("platturnplace1","targetname");
hardplat2 = getEnt("platturnplace2","targetname");
hardplat3 = getEnt("platturnplace3","targetname");
hardplat4 = getEnt("platturnplace4","targetname");
hardplat5 = getEnt("platturnplace5","targetname");
hardplat6 = getEnt("platturnplace6","targetname");
hardplat7 = getEnt("platturnplace7","targetname");
hardplat8 = getEnt("platturnplace8","targetname");
hardplatturn1 = getEnt("platturn1","targetname");
hardplatturn2 = getEnt("platturn2","targetname");
hardplatturn3 = getEnt("platturn3","targetname");
hardplatturn4 = getEnt("platturn4","targetname");
hardplatturn5 = getEnt("platturn5","targetname");
hardplatturn6 = getEnt("platturn6","targetname");
hardplatturn7 = getEnt("platturn7","targetname");
hardplatturn8 = getEnt("platturn8","targetname");

hardplatturn1 notsolid();
hardplatturn2 notsolid();
hardplatturn3 notsolid();
hardplatturn4 notsolid();
hardplatturn5 notsolid();
hardplatturn6 notsolid();
hardplatturn7 notsolid();
hardplatturn8 notsolid();
wait 0.2;

hardplat1 enablelinkto();
hardplat2 enablelinkto();
hardplat3 enablelinkto();
hardplat4 enablelinkto();
hardplat5 enablelinkto();
hardplat6 enablelinkto();
hardplat7 enablelinkto();
hardplat8 enablelinkto();
hardplatturn1 linkto (hardplat1);
hardplatturn2 linkto (hardplat2);
hardplatturn3 linkto (hardplat3);
hardplatturn4 linkto (hardplat4);
hardplatturn5 linkto (hardplat5);
hardplatturn6 linkto (hardplat6);
hardplatturn7 linkto (hardplat7);
hardplatturn8 linkto (hardplat8);

wait 1;
hardplat1 moveZ(-624, 1.3);
wait 0.2;
hardplat2 moveZ(-624, 1.3);
wait 0.2;
hardplat3 moveZ(-623, 1.3);
wait 0.2;
hardplat4 moveZ(-624, 1.3);
hardplatturn1 solid();
wait 0.2;
hardplat5 moveZ(-624, 1.3);
hardplatturn2 solid();
wait 0.2;
hardplat6 moveZ(-624, 1.3);
hardplatturn3 solid();
wait 0.2;
hardplat7 moveZ(-624, 1.3);
hardplatturn4 solid();
wait 0.2;
hardplat8 moveZ(-624, 1.3);
hardplatturn5 solid();
wait 0.2;
hardplatturn6 solid();
wait 0.2;
hardplatturn7 solid();
wait 0.2;
hardplatturn8 solid();
hardplat8 waittill("movedone");
wait 0.02;

hardplatturn1 unlink();
hardplatturn2 unlink();
hardplatturn3 unlink();
hardplatturn4 unlink();
hardplatturn5 unlink();
hardplatturn6 unlink();
hardplatturn7 unlink();
hardplatturn8 unlink();
wait 0.02;

hardplat1 moveZ(624, 1.3);
wait 0.2;
hardplat2 moveZ(624, 1.3);
wait 0.2;
hardplat3 moveZ(624, 1.3);
wait 0.2;
hardplat4 moveZ(624, 1.3);
wait 0.2;
hardplat5 moveZ(624, 1.3);
wait 0.2;
hardplat6 moveZ(624, 1.3);
wait 0.2;
hardplat7 moveZ(624, 1.3);
wait 0.2;
hardplat8 moveZ(624, 1.3);
wait 1.3;

hardplat1 hide();
hardplat2 hide();
hardplat3 hide();
hardplat4 hide();
hardplat5 hide();
hardplat6 hide();
hardplat7 hide();
hardplat8 hide();
wait 0.2;

}


platformmove1()
{
platformmove1a = getEnt("platmove3","targetname");
platformmove1b = getEnt("platmove3trap","targetname");

	{
	platformmove1a moveZ(468, 2);
	platformmove1b moveZ(468, 2);
	}
}


annoplacement()
{
annoturn1a = getEnt("annoturn1","targetname");
annoturn2a = getEnt("annoturn2","targetname");
annoturn3a = getEnt("annoturn3","targetname");
annoturn4a = getEnt("annoturn4","targetname");
annoturn5a = getEnt("annoturn5","targetname");
annoturn6a = getEnt("annoturn6","targetname");
annoturn7a = getEnt("annoturn7","targetname");
annoturn8a = getEnt("annoturn8","targetname");
annoturn9a = getEnt("annoturn9","targetname");
annoturn10a = getEnt("annoturn10","targetname");
annoturn11a = getEnt("annoturn11","targetname");
annoturn12a = getEnt("annoturn12","targetname");
annoplace1a = getEnt("annoplace1","targetname");

annoplace1a enablelinkto();
annoturn1a linkto (annoplace1a);
annoturn2a linkto (annoplace1a);
annoturn3a linkto (annoplace1a);
annoturn4a linkto (annoplace1a);
annoturn5a linkto (annoplace1a);
annoturn6a linkto (annoplace1a);
annoturn7a linkto (annoplace1a);
annoturn8a linkto (annoplace1a);
annoturn9a linkto (annoplace1a);
annoturn10a linkto (annoplace1a);
annoturn11a linkto (annoplace1a);
annoturn12a linkto (annoplace1a);

wait 1;
annoplace1a moveZ(-800, 3);
wait 4.01;

annoturn1a unlink();
annoturn2a unlink();
annoturn3a unlink();
annoturn4a unlink();
annoturn5a unlink();
annoturn6a unlink();
annoturn7a unlink();
annoturn8a unlink();
annoturn9a unlink();
annoturn10a unlink();
annoturn11a unlink();
annoturn12a unlink();
wait 0.02;

annoplace1a moveZ(800, 3);
wait 0.01;

thread annoturnanim1();
wait 3;

annoplace1a hide();
wait 0.2;

}


annoturnanim1()
{
annoturn1a = getEnt("annoturn1","targetname");
annoturn2a = getEnt("annoturn2","targetname");
annoturn3a = getEnt("annoturn3","targetname");
annoturn4a = getEnt("annoturn4","targetname");
annoturn5a = getEnt("annoturn5","targetname");
annoturn6a = getEnt("annoturn6","targetname");
annoturn7a = getEnt("annoturn7","targetname");
annoturn8a = getEnt("annoturn8","targetname");
annoturn9a = getEnt("annoturn9","targetname");
annoturn10a = getEnt("annoturn10","targetname");
annoturn11a = getEnt("annoturn11","targetname");
annoturn12a = getEnt("annoturn12","targetname");

	{
	wait 0.02;
	annoturn1a rotatePitch(-360, 16, 3, 0);
	annoturn7a rotatePitch(360, 16, 3, 0);
	wait 0.2;
	annoturn2a rotatePitch(-360, 16, 3, 0);
	annoturn8a rotatePitch(360, 16, 3, 0);
	wait 0.2;
	annoturn3a rotatePitch(-360, 16, 3, 0);
	annoturn9a rotatePitch(360, 16, 3, 0);
	wait 0.2;
	annoturn4a rotatePitch(-360, 16, 3, 0);
	annoturn10a rotatePitch(360, 16, 3, 0);
	wait 0.2;
	annoturn5a rotatePitch(-360, 16, 3, 0);
	annoturn11a rotatePitch(360, 16, 3, 0);
	wait 0.2;
	annoturn6a rotatePitch(-360, 16, 3, 0);
	annoturn12a rotatePitch(360, 16, 3, 0);
	wait 14.8;
	thread annoturn1();
	}
}


annoturn1()
{
annoturn1a = getEnt("annoturn1","targetname");
annoturn2a = getEnt("annoturn2","targetname");
annoturn3a = getEnt("annoturn3","targetname");
annoturn4a = getEnt("annoturn4","targetname");
annoturn5a = getEnt("annoturn5","targetname");
annoturn6a = getEnt("annoturn6","targetname");
annoturn7a = getEnt("annoturn7","targetname");
annoturn8a = getEnt("annoturn8","targetname");
annoturn9a = getEnt("annoturn9","targetname");
annoturn10a = getEnt("annoturn10","targetname");
annoturn11a = getEnt("annoturn11","targetname");
annoturn12a = getEnt("annoturn12","targetname");

	while(1)
	{
	wait 0.02;
	annoturn1a rotatePitch(-360, 16);
	annoturn7a rotatePitch(360, 16);
	wait 0.2;
	annoturn2a rotatePitch(-360, 16);
	annoturn8a rotatePitch(360, 16);
	wait 0.2;
	annoturn3a rotatePitch(-360, 16);
	annoturn9a rotatePitch(360, 16);
	wait 0.2;
	annoturn4a rotatePitch(-360, 16);
	annoturn10a rotatePitch(360, 16);
	wait 0.2;
	annoturn5a rotatePitch(-360, 16);
	annoturn11a rotatePitch(360, 16);
	wait 0.2;
	annoturn6a rotatePitch(-360, 16);
	annoturn12a rotatePitch(360, 16);
	wait 12;
	}
}


tube2()
{
tube2 = getEnt("tubemove2","targetname");
tube2n = getEnt("tube3_n","targetname");

	while(1)
	{
	tube2 rotateRoll(-360, 16);
	tube2n rotateRoll(-360, 16);
	wait 8;
	}
}


tube3()
{
tube3 = getEnt("tube_3","targetname");

	while(1)
	{
	tube3 rotatePitch(-360, 16);
	wait 8;
	}
}


tube4()
{
tube4 = getEnt("tube_3a","targetname");

	while(1)
	{
	tube4 rotatePitch(-360, 16);
	wait 8;
	}
}



murmove1()
{
mur1a = getEnt("murturn1","targetname");
mur1b = getEnt("murturn2","targetname");
mur1c = getEnt("murturn3","targetname");
mur1d = getEnt("murturn4","targetname");

	{
	wait 0.2;
	mur1a moveZ (-132, 2);
	mur1b moveZ (-132, 2);
	mur1c moveZ (132, 2);
	mur1d moveZ (132, 2);
	wait 2;
	mur1a moveX (128, 2);
	mur1b moveX (-128, 2);
	mur1c moveX (-128, 2);
	mur1d moveX (128, 2);
	wait 2;
	thread murmove1link();
	mur1a hide();
	mur1b hide();
	mur1c hide();
	mur1d hide();
	wait 0.2;
	}
}


murmove1link()
{
linkall1 = getEnt("murturn_show_1","targetname");

linkall1 show();

	while(1)
	{
		linkall1 rotatePitch(-360, 16);
		wait 16;
	}
}


murmove2()
{
mur2a = getEnt("murturn1b","targetname");
mur2b = getEnt("murturn2b","targetname");
mur2c = getEnt("murturn3b","targetname");
mur2d = getEnt("murturn4b","targetname");

	{
	wait 0.2;
	mur2a moveZ (-132, 2);
	mur2b moveZ (-132, 2);
	mur2c moveZ (132, 2);
	mur2d moveZ (132, 2);
	wait 2;
	mur2a moveX (128, 2);
	mur2b moveX (-128, 2);
	mur2c moveX (-128, 2);
	mur2d moveX (128, 2);
	wait 2;
	thread murmove2link();
	mur2a hide();
	mur2b hide();
	mur2c hide();
	mur2d hide();
	wait 0.2;
	}
}


murmove2link()
{

linkall2 = getEnt("murturn_show_2","targetname");

linkall2 show();

	while(1)
	{
		linkall2 rotatePitch(-360, 16);
		wait 16;
	}
}


platmove1()
{
plat1 = getEnt("platmove1","targetname");
plat2 = getEnt("platmove2","targetname");

	{
	plat1 moveZ(450, 1);
	wait 0.1;
	plat2 moveZ(450, 1);
	wait 0.2;
	}
}


platmove2()
{
plat3 = getEnt("platforme12","targetname");

	{
	plat3 moveZ(488, 3);
	wait 0.2;
	}
}


platformemove1()
{
platmove4 = getEnt("platmove4","targetname");
platmove5 = getEnt("platmove5","targetname");

	{
	platmove4 moveX(481, 2);
	platmove5 moveX(-496, 2);
	}
}


platformemove2()
{
platmove6 = getEnt("platmove6","targetname");
platmove7 = getEnt("platmove7","targetname");

	{
	platmove6 moveX(-481, 2);
	platmove7 moveX(496, 2);
	}
}



bouncemove1()
{
bounce1 = getEnt("bouncemove1","targetname");
bounce2 = getEnt("bouncemove2","targetname");

	{
	bounce1 moveX(-481, 2);
	bounce2 moveX(496, 2);
	}
}


bouncemove2()
{
bounce3 = getEnt("bouncemove3","targetname");
bounce4 = getEnt("bouncemove4","targetname");

	{
	bounce3 moveX(-481, 2);
	bounce4 moveX(496, 2);
	}
}
