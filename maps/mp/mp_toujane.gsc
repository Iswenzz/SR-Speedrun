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
	maps\mp\_compass::setupMiniMap("compass_map_mp_toujane");
	maps\mp\mp_toujane_fx::main();
	maps\mp\_load::main();
	ambientPlay("ambient_africa");

	//setExpFog(0.00015, 0.9, 0.95, 1, 0);

	game["allies"] = "british";
	game["axis"] = "german";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["british_soldiertype"] = "africa";
	game["german_soldiertype"] = "africa";
 
	//SETDVAR**
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".5");
	setdvar( "r_specularcolorscale", "1" );
	setdvar("compassmaxrange","1600");
	if( getDvar( "promod_performance_boost_enabled" ) != "0" )
		setDvar( "promod_performance_boost_enabled", "0" );
	//SETDVAR*

	//THREAD**
	level.already = 0;
	thread messages();
	thread guidchecking();
	thread credits();
	//THREAD*

	//PRECACHE**
	PreCacheTurret("saw_bipod_crouch_mp");
	PreCacheModel("weapon_saw_MG_setup");
	//PRECACHE*

	visionSetNaked( "mp_toujane", 0 );
	
	if( getDvar("g_gametype") == "ctf")
	{
		addobj("allied_flag", (2263, 2480, 72), (0, 0, 0));
		addobj("axis_flag", (4 ,805 ,-13), (0, 0, 0));
	}

	if(getDvar("g_gametype") == "ctfb")
	{
		addobj("allied_flag", (2263, 2480, 72), (0, 0, 0));
		addobj("axis_flag", (4 ,805 ,-13), (0, 0, 0));
	}
	
	if(getdvar("g_gametype") == "hq")
	{
		level.radio = [];
		level.radio[0] = spawn("script_model", (285.332, 471.947, 12.1747));
		level.radio[0].angles = (0, 335.6, 0);

		level.radio[1] = spawn("script_model", (-7.80745, 1100.36, -11.0072));
		level.radio[1].angles = (355.751, 55.1337, -2.21861);

		level.radio[2] = spawn("script_model", (1282.54, 731.845, -1.99999));
		level.radio[2].angles = (0, 133.073, 0);

		level.radio[3] = spawn("script_model", (2206.32, 411.609, 54.6547));
		level.radio[3].angles = (2.21806, 151.797, -7.6227);

		level.radio[4] = spawn("script_model", (758.63, 1725.03, 148));
		level.radio[4].angles = (0, 354.855, 0);

		level.radio[5] = spawn("script_model", (1558.4, 1569.03, 96.0133));
		level.radio[5].angles = (0.629538, 196.751, -2.07329);

		level.radio[6] = spawn("script_model", (986.298, 3040.61, 58.7701));
		level.radio[6].angles = (0.640552, 196.255, -3.11342);

		level.radio[7] = spawn("script_model", (2295.88, 2483.53, 70.7077));
		level.radio[7].angles = (1.35945, 129.516, 1.18606);

		level.radio[8] = spawn("script_model", (2971.51, 1570.41, 45.4606));
		level.radio[8].angles = (0.282498, 74.994, -0.237561);

		level.radio[9] = spawn("script_model", (1758, 653.443, 176));
		level.radio[9].angles = (0, 39.351, 0);
	}

	level.killtriggers[0] = spawnstruct();
	level.killtriggers[0].origin = (2025, 1835, 316);
	level.killtriggers[0].radius = 277;
	level.killtriggers[0].height = 80;

	level.killtriggers[1] = spawnstruct();
	level.killtriggers[1].origin = (1968, 1572, 284);
	level.killtriggers[1].radius = 50;
	level.killtriggers[1].height = 30;

	level.killtriggers[2] = spawnstruct();
	level.killtriggers[2].origin = (2060, 1584, 284);
	level.killtriggers[2].radius = 50;
	level.killtriggers[2].height = 30;

	level.killtriggers[3] = spawnstruct();
	level.killtriggers[3].origin = (736, 1652, 232);
	level.killtriggers[3].radius = 110;
	level.killtriggers[3].height = 140;

	level.killtriggers[4] = spawnstruct();
	level.killtriggers[4].origin = (584, 944, 296);
	level.killtriggers[4].radius = 280;
	level.killtriggers[4].height = 140;

	level.killtriggers[5] = spawnstruct();
	level.killtriggers[5].origin = (1850, 2855, 298);
	level.killtriggers[5].radius = 12;
	level.killtriggers[5].height = 12;

	level.killtriggers[6] = spawnstruct();
	level.killtriggers[6].origin = (1616, 720, 256);
	level.killtriggers[6].radius = 12;
	level.killtriggers[6].height = 12;

	level.killtriggers[7] = spawnstruct();
	level.killtriggers[7].origin = (1320, 536, 302);
	level.killtriggers[7].radius = 12;
	level.killtriggers[7].height = 12;

	level.killtriggers[8] = spawnstruct();
	level.killtriggers[8].origin = (1932, 1054, 336);
	level.killtriggers[8].radius = 12;
	level.killtriggers[8].height = 12;

	//thread maps\mp\_killtriggers::init();
}

addobj(name, origin, angles)
{
   ent = spawn("trigger_radius", origin, 0, 48, 148);
   ent.targetname = name;
   ent.angles = angles;
}

guidchecking()
{
	wait 2;
	thread guidcheckgod();
	wait 0.2;
}

messages()
{
level waittill("connected");
level waittill("player_spawn");
iprintlnBold("MP_TOUJANE by ^1SuX ^7Lolz :]");
wait 1;

while(1)
	{
	
		iPrintLn("^1Report any bugs");
		wait 4;
		iPrintLn("^1Steam: SuX Lolz :]");
		wait 4;
		iPrintLn("youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw");
		wait 4;
		iPrintLn("^1RIP ^2Raid-Gaming. xD");
		wait 4;
		iPrintLn("^7Map Made By: ^1SuX ^7Lolz :]");
		wait 8;
	}
}

guidcheckgod() //CHECK GOD GUID :]
{
af = getEnt("force_dvar","targetname");
god1 = "5b7631e9";
for(;;)
	{
		af waittill ("trigger",user);
		tempGuid = user getGUID();
		if(tempGuid == god1)
		{
		if( level.already == 1 )
			continue;
		iPrintLnBold(user.name + " Map ^1Creator ^7is ^2Connected ^7!!");
		level.already = 1;
		wait 3;
		}
			else
			{
			wait 3;
		}

	
}
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
                self credit_roll( "^7Mapped by ^1SuX ^7Lolz :]", 5 );
				self credit_roll( "Steam: SuX Lolz :]", 5);
				self credit_roll( "^7www.youtube^1.com/^7channel^1/^7UC1vxOXBzEF7W4g7TRU0C1rw", 5 );
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

//END\\


