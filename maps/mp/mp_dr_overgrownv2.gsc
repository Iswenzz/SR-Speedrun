//Map by Speedex
//Feel very nubish if you attempt to steal scripts from me, jk I dont care. But if you do pls give me credit and/or the creator of the snippet!
#include maps\mp\_utility;
#include common_scripts\utility;
main()
{
level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");

level.heli_crash_paths = [];
maps\mp\_load::main();
//maps\mp\mp_dr_overgrown_v2_fx::main();

//maps\mp\_compass::setupMiniMap("compass_map_mp_dr_overgrown_v2");
PreCacheShellShock( "jeepride_ridedeath");
//PrecacheModel("vehicle_mi24p_hind_mp");
//PrecacheModel("vehicle_mi17_woodland");
// precacheMenu( "speedex_musicmenu" );
//setExpFog(500, 3500, .5, 0.5, 0.45, 0);
// ambientPlay("ambience");
	//level._effect[ "spotlight" ]	= loadFX( "misc/hunted_spotlight_model" );
	precacheItem("m14_gl_mp");
	precacheItem("m1014_grip_mp");
	preCacheItem("c4_mp");
 	precacheItem("ak47_silencer_mp");
 	precacheModel( "vehicle_cobra_helicopter_fly" );
 	precacheitem( "cobra_20mm_mp" );
 	//preCacheItem("Speedex_colt45_mp");
VisionSetNaked( "mp_dr_overgrownv2");

game["allies"] = "marines";
game["axis"] = "opfor";

game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";
setdvar( "r_specularcolorscale", "1" );

setdvar("r_glowbloomintensity0","1");
setdvar("r_glowbloomintensity1","1");
setdvar("r_glowskybleedintensity0","1");

	//level.fx_heliexplode = LoadFX( "explosions/tanker_explosion" );
	level.chopper_fx["explode"]["death"] = LoadFx("explosions/helicopter_explosion_cobra");
	level.chopper_fx["explode"]["medium"] = loadfx ("explosions/aerial_explosion");
	level.chopper_fx["explode"]["large"] = loadfx ("explosions/aerial_explosion_large");

//setdvar("compassmaxrange","1500");

thread way_connect();
thread initdfs();
// thread trap1();
// thread trap2();
thread trap3();
// thread trap4();
thread trap5();
thread trap6();
thread trap7();
thread trap9();
thread trap9_tele_heen();
thread trap9_tele_terug();
// thread musicmenu();
thread bouncer1();
thread bouncer2();
thread door();
thread water();
thread water_hud();
// thread old_tele();
thread guidcheckspeed();
// thread credits();
thread FlyingHelicopter();
thread glow();
// thread kniferoom();
// thread shotroom();
// thread sniperroom();
// thread weaponroom();
/*
level waittill("round_started",round);
if(round!=1)
{

}
*/
// addTriggerToList( "trap1_trigger" );
// addTriggerToList( "trap2_trigger" );
// addTriggerToList( "trap3_trigger" );
// addTriggerToList( "trap4_trigger" );
// addTriggerToList( "trap5_trigger" );
// addTriggerToList( "trap6_trigger" );
// addTriggerToList( "trap7_trigger" );
// addTriggerToList( "trap9_trigger" );
}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    for(;;)
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////


addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

musicmenu()
{
	trig = getent( "music_trig","targetname" );

	trig setHintString( "^2MusicMenu!" );
	trig waittill( "trigger", player );
	wait 0.05;

	player openMenu( "speedex_musicmenu" );


	player thread musicStuff();
}
//Thx fermer
musicStuff()
{
	self endon( "disconnect" );
	self endon( "death" );
	trig = getent( "music_trig","targetname" );
	for(;;)
	{
	   self waittill( "menuresponse", menu, response );

	   if(menu == "speedex_musicmenu")
	   {
		    if(response == "song1")
		    {
		    	ambientPlay("sti");
		    	trig delete();
		    }
		    if(response == "song2")
		    {
		    	ambientPlay("today");
		    	trig delete();
		    }
		    if(response == "song3")
		    {
		    	ambientPlay("rustig");
		    	trig delete();
		    }
		    if(response == "song4")
		    {
		    	ambientPlay("toujours");
		    	trig delete();
		    }
		    if(response == "song5")
		    {
		    	ambientPlay("havana");
		    	trig delete();
		    }
	   }
	}
}
//Full credits to Beatthat!

trap1()
{
	trap1_trigger = getent("trap1_trigger","targetname"); //acti trigger
	trap1_1 = getent("trap1_1","targetname");
	trap1_2 = getent("trap1_2","targetname");
	trap1_3 = getent("trap1_3","targetname");
	trap1_4 = getent("trap1_4","targetname");
	trap1_1_t1 = getent("trap1_1_t1","targetname");
	trap1_1_t2 = getent("trap1_1_t2","targetname");
	trap1_2_t1 = getent("trap1_2_t1","targetname");
	trap1_2_t2 = getent("trap1_2_t2","targetname");
	trap1_3_t1 = getent("trap1_3_t1","targetname");
	trap1_3_t2 = getent("trap1_3_t2","targetname");
	trap1_4_t1 = getent("trap1_4_t1","targetname");
	trap1_4_t2 = getent("trap1_4_t2","targetname");

	// Wachten tot op de knop wordt gedrukt
	trap1_trigger waittill("trigger", who);
	trap1_trigger delete();

	trap1_1 moveTo(trap1_1_t1.origin, 2, 0 , 0.5);
	trap1_2 moveTo(trap1_2_t2.origin, 2, 0 , 0.5);
	trap1_3 moveTo(trap1_3_t1.origin, 2, 0 , 0.5);
	trap1_4 moveTo(trap1_4_t2.origin, 2, 0 , 0.5);
	wait 3;

	while(1)
	{
		trap1_1 moveTo(trap1_1_t1.origin, 6, 1 , 1);
		trap1_2 moveTo(trap1_2_t2.origin, 6, 1 , 1);
		trap1_3 moveTo(trap1_3_t1.origin, 6, 1 , 1);
		trap1_4 moveTo(trap1_4_t2.origin, 6, 1 , 1);
		wait 8;
		trap1_1 moveTo(trap1_1_t2.origin, 6, 1 , 1);
		trap1_2 moveTo(trap1_2_t1.origin, 6, 1 , 1);
		trap1_3 moveTo(trap1_3_t2.origin, 6, 1 , 1);
		trap1_4 moveTo(trap1_4_t1.origin, 6, 1 , 1);
		wait 8;
	}
}

trap9_tele_heen()
{
	trig_heen = getent("trap9_in_trig", "targetname");
	orig_heen = getent("trap9_in_orig", "targetname");

	while(true)
	{
		trig_heen waittill ("trigger", who);
		who SetPlayerAngles( orig_heen.angles );
		who setOrigin( orig_heen.origin ); //teleports the jumper
		wait 1;
	}
}

trap9_tele_terug()
{
	trig_terug = getent("trap9_out_trig", "targetname");
	orig_terug = getent("trap9_out_orig", "targetname");

	while(true)
	{
		trig_terug waittill ("trigger", who);
		who SetPlayerAngles( orig_terug.angles );
		who setOrigin( orig_terug.origin ); //teleports the jumper
		wait 1;
	}
}

trap2()
{
	trap2 = getent("trap2","targetname");
	trap2p = getent("trap2_plat","targetname");
	trap2_trigger = getent("trap2_trigger","targetname");


	// Wachten tot op de knop wordt gedrukt
	trap2_trigger waittill("trigger", who);
	trap2_trigger delete();


	trap2 MoveZ(-100,1);
	trap2 notSolid();
	trap2p MoveZ(-500, 1);
	wait 9;
	trap2 MoveZ(100,1);
	trap2 Solid();
	trap2p MoveZ(500, 1);
	wait 1;
}

trap3()
{
	trap3_trigger = getent("trap3_trigger","targetname"); //acti trigger
	trap3_1 = getent("trap3_1","targetname");
	trap3_2 = getent("trap3_2","targetname");
	trap3_3 = getent("trap3_3","targetname");
	trap3_1_t1 = getent("trap3_1_t1","targetname");
	trap3_1_t2 = getent("trap3_1_t2","targetname");
	trap3_2_t1 = getent("trap3_2_t1","targetname");
	trap3_2_t2 = getent("trap3_2_t2","targetname");
	trap3_3_t2 = getent("trap3_3_t2","targetname");
	trap3_3_t1 = getent("trap3_3_t1","targetname");
	trap3_1_hurt = getent("trap3_1_hurt","targetname");
	trap3_2_hurt = getent("trap3_2_hurt","targetname");
	trap3_3_hurt = getent("trap3_3_hurt","targetname");

	trap3_1_hurt enableLinkTo();
	trap3_1_hurt linkTo(trap3_1);
	trap3_2_hurt enableLinkTo();
	trap3_2_hurt linkTo(trap3_2);
	trap3_3_hurt enableLinkTo();
	trap3_3_hurt linkTo(trap3_3);
	trap3_1 moveTo(trap3_1_t1.origin, 1, 0 , 0.5);
	trap3_2 moveTo(trap3_2_t2.origin, 1, 0 , 0.5);
	trap3_3 moveTo(trap3_3_t1.origin, 1, 0 , 0.5);

}
trap4()
{
	trap4a = getent("trap4a","targetname");
	trap4b = getent("trap4b","targetname");
	trap4_trigger = getent("trap4_trigger","targetname");
	// Wachten tot op de knop wordt gedrukt
	trap4_trigger waittill("trigger", who);
	trap4_trigger delete();


	while(1)
	{
		trap4a rotatePitch(-360,10);
		trap4b rotatePitch(360,10);
		wait 10;
	}
}

trap5()
{
	bounce1 = getent("bounce1","targetname");
	fan1 = getent("fan1","targetname");
	trap5_trigger = getent("trap5_trigger","targetname");
	level._effect["dust"] = loadfx ("treadfx/tread_dust_hunted");
	fxfan1 = getent ("fxfan1","targetname");

	bounce1 triggeroff();

}

trap6()
{
	bounce2 = getent("bounce2","targetname");
	fan2 = getent("fan2","targetname");
	trap6_trigger = getent("trap6_trigger","targetname");
	fxfan2 = getent ("fxfan2","targetname");

	bounce2 triggeroff();
}

bouncer1()
{
	trigger = getEnt ( "bounce1", "targetname" );


	while(1)
	{
    	trigger waittill ("trigger",user);
		if (user istouching(trigger))
		{
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,0,1)) ), 500 );
		}
	}
}

bouncer2()
{
	trig = getEnt ( "bounce2", "targetname" );


	while(1)
	{
    	trig waittill ("trigger",user);
		if (user istouching(trig))
		{
			user braxi\_common::bounce( vectorNormalize( user.origin - (user.origin - (0,0,1)) ), 500 );
		}
	}
}

trap7()
{
	trap7_trigger = getent("trap7_trigger","targetname"); //acti trigger
	fire1 = getent("fire1","targetname");
	fire2 = getent("fire2","targetname");
	fire3 = getent("fire3","targetname");
	fire4 = getent("fire4","targetname");
	fire1_hurt = getent("fire1_hurt","targetname");
	fire2_hurt = getent("fire2_hurt","targetname");
	fire3_hurt = getent("fire3_hurt","targetname");
	fire4_hurt = getent("fire4_hurt","targetname");
	level._effect["fire"] = loadfx ("fire/jet_afterburner"); //load FIRE fx
	FX = undefined;

	fire1_hurt triggeroff();
	fire2_hurt triggeroff();
	fire3_hurt triggeroff();
	fire4_hurt triggeroff();

}

trap9()
{
	trap9 = getent("trap9","targetname");
	trap9_trigger = getent("trap9_trigger","targetname");
	trap9_hurt = getent("trap9_hurt","targetname");
	trap9_hurt enableLinkTo();
	trap9_hurt linkTo(trap9);
	trap9 moveZ(-800, 1);

}

effects()
{
	waterorig1 = getent("waterorig1", "targetname");
	waterorig2 = getent("waterorig2", "targetname");
	waterorig3 = getent("waterorig3", "targetname");
	waterorig4 = getent("waterorig4", "targetname");
	waterorig5 = getent("waterorig5", "targetname");
	waterorig6 = getent("waterorig6", "targetname");
	level._effect["hawk"] = loadfx ("weather/hawk");


	playLoopedFX( level._effect["hawk"], waterorig1.origin);
	playLoopedFX( level._effect["hawk"], waterorig2.origin);
	playLoopedFX( level._effect["hawk"], waterorig3.origin);
	playLoopedFX( level._effect["hawk"], waterorig4.origin);
	playLoopedFX( level._effect["hawk"], waterorig5.origin);
	playLoopedFX( level._effect["hawk"], waterorig6.origin);
}

old_tele()
{
	trigold = getent("oldteletrig", "targetname");
	origold = getent("oldteleorig", "targetname");

	while(true)
	{
		trigold waittill ("trigger", who);
		who SetPlayerAngles( origold.angles );
		who setOrigin( origold.origin ); //teleports the jumper
		wait 1;
	}
}
//Teleports players to the acti area
door()
{
	door_left = getent ("door_left","targetname");
	door_right = getent ("door_right","targetname");
	door_fx = getent ("door_fx","targetname");
	door_trig = getent ("door_trig","targetname");

	wait 1;

	// door_fx PlaySound ("door");
	door_left moveX(-64, 2);
	door_right moveX(64, 2);
}
//Old door opening

// ---------------------------------------------------------------------
// Init Script
// ---------------------------------------------------------------------

initdfs()
{
	// There should be three different script_models: trees, foliage and grass, because they're
	// treated in a different way.
	// Consider Grass to grass (obviously) and to very small foliage elements
	// Consider Foliage to midsize foliage
	// classname: script_model
	// targetname: <name>
	// These names were used in Burma 1.1. Change them to whatever you want
	level.dfs_tree_sm_name = "dyn_trees";
	level.dfs_foliage_sm_name = "dyn_foliage";
	level.dfs_grass_sm_name = "dyn_grass";

	// You must set up here Strength of Wind, to simulate higher or lower sway
	// on foliage and trees.
	// 0 means no wind @ all
	// 10 means A HURRICANE : )
	// Recommended values: 0.3 to 0.6. Optimal value: 0.5;
	// Obviously you can setup a dvar or whatever for this

	level.dfs_wind_strength = 0.5;
	// Let's start

	foliage_animation();
	//grass_animation();
	tree_animation();
}

// -----------------------------------------------------------------
// Main Scripts
// -----------------------------------------------------------------

//Dynamic foliage by ZweiMan
tree_animation()
{
	level endon("game_ended");
	// Sway animation for Trees
	// Slower, softer

	entities = getentarray( level.dfs_tree_sm_name, "targetname" );

	vpoint = level.dfs_wind_strength / 1.4;
	vangles = level.dfs_wind_strength / 1.5;
	vtime = ( 6 * ( 1 - level.dfs_wind_strength ) );

	for( i = 0; i < entities.size; i++ )
		{
			factor = randomIntRange( 0, 10 );

			if ( factor >= 5 )
			mmfactor = 1;
			else
			mmfactor = -1;

			vibvector = entities[i].origin + ( ( vpoint * mmfactor ), 0, 0 );
			entities[i] vibrate( vibvector, vangles * mmfactor , vtime, ( ( 360 * 1.2 ) * 60 ) );
			// Tree is damageable now
			entities[i] setcandamage(true);
			// Trees are destroyable, so let's start their threads
			entities[i] thread treethreads();
			wait 0.005;
		}
	}

foliage_animation()
{
	level endon("game_ended");

	// Sway animation for Foliage
	// Stronger
	entities = getentarray( level.dfs_foliage_sm_name, "targetname" );
	vpoint = level.dfs_wind_strength * 1.5;
	vangles = level.dfs_wind_strength * 2;
	vtime = ( ( 1 - level.dfs_wind_strength ) ) * 5;

	mmfactor = 1;

	for( i = 0; i < entities.size; i++ )
	{
		mmfactor *= -1;
		vibvector = entities[i].origin + ( randomFloatRange( 0,90 ) * mmfactor , 0, 0 );
		entities[i] vibrate( vibvector, ( vangles * mmfactor ) , vtime, ( ( 360 * 1.2 ) * 60 ) );
		wait 0.005;
	}
}
/*
grass_animation()
{
	level endon("game_ended");

	// Sway animation for Grass
	// Strongest
	entities = getentarray( level.dfs_grass_sm_name, "targetname" );

	vpoint = level.dfs_wind_strength * 2;
	vangles = level.dfs_wind_strength * 4;
	vtime = ( ( 1 - level.dfs_wind_strength ) ) * 2.5;

	mmfactor = 1;

	for( i = 0; i < entities.size; i++ )
	{
		mmfactor *= -1;
		vibvector = entities[i].origin + ( ( vpoint * mmfactor ), 0, 0 );
		entities[i] vibrate( vibvector, ( vangles * mmfactor ) , vtime, ( ( 360 * 1.2 ) * 60 ) );
		wait 0.005;
	}
}
*/
treethreads()
{
	level endon("game_ended");
	self endon("broken");

	while( !isDefined(self.broken) )
	{
		// You can even play with tagName if you place Trees/Palms with more than one tag
		// Trees could be burned, broken and more.
		// By the moment, they're destroyed and sunk down

		self waittill("damage", damage, attacker, direction_vec, point, mod, modelName, tagName);

		if ( mod != "MOD_RIFLE_BULLET" && mod != "MOD_PISTOL_BULLET" && mod != "MOD_MELEE" )
			if ( damage > 50 )
				self treefall();
	}
}

// Code below is originally from CoD:WaW scripts
// Modified by Zweimann to fit our requirements

treefall()
{
	yaw = randomint(360);

	break_angles = (self.angles[0], yaw, self.angles[2]);
	break_vector = anglesToForward(break_angles);
	break_vector = vectorScale(break_vector, 100);
	start = (self.origin + break_vector) + (0, 0, 512);
	end = start + (0, 0, -1024);
	trace = bulletTrace(start, end, false, self);
	dist_vector = ((self.origin + break_vector) - trace["position"]);
	dist = dist_vector[2];
	velocity = 0;
	travelled = 0;
	lasttravelled = travelled;
	count = 0;
	lastcount = count;

	while(travelled < dist)
	{
		velocity = velocity + 340;
		lasttravelled = travelled;
		travelled = travelled + velocity;
		lastcount = count;
		count++;
	}
	remainder = lasttravelled - dist;
	if(remainder < 0)
	remainder = remainder * -1;

	if ( velocity != 0 )
	time = lastcount + (remainder / velocity);
	else
	time = lastcount;
	self moveGravity(break_vector, time);
	self waittill("movedone");
	vec = vectorNormalize(break_vector);
	vec = vectorScale(vec, 320);
	start = (self.origin + vec) + (0, 0, 1024);
	end = start + (0, 0, -1024);
	trace = bulletTrace(start, end, false, self);
	ground = trace["position"];
	treeup_vector = anglesToUp(self.angles);
	treeup_angles = vectortoangles(treeup_vector);
	rest_vector = ground - self.origin;
	rest_angles = vectorToAngles(rest_vector);
	treeorg = spawn("script_origin", self.origin);
	treeorg.origin = self.origin;
	treeorg.angles = (treeup_angles[0], rest_angles[1], rest_angles[2]);

	self linkto(treeorg);

	treeorg rotateTo(rest_angles, 1.15, .5, 0);
	treeorg waittill("rotatedone");
	treeorg rotatepitch(-2.5,.21,.05,.15);
	treeorg waittill("rotatedone");
	treeorg rotatepitch(2.5,.26,.15,.1);
	treeorg waittill("rotatedone");
	self unlink();

	self.broken = 1;
	self notify("broken");
	self setcandamage(false);

}
water()
{
	trig3 = getent("water", "targetname");
	level.splash_fx = loadfx ("explosions/grenadeExp_water");

	while(true)
	{
		trig3 waittill ("trigger", who);
		who PlaySound ("splash");
		PlayFX( level.splash_fx, who.origin );
		wait 1;
	}
}
//PLays water splash effect and sound when entering the water
water_hud()
{
	trig4 = getent("water_hud", "targetname");

	while(1)
	{
	trig4 waittill ("trigger", who);
	who shellshock( "jeepride_ridedeath", 3 );
	hud_Screen = NewClientHudElem(who);
    hud_Screen.horzalign = "fullscreen";
	hud_Screen.vertalign = "fullscreen";
	hud_Screen.alpha = 0.5;
	hud_Screen.color = (0, 0.2, 0.7);
	hud_Screen SetShader( "white", 640, 480 );
	who allowJump(false);
    who waittill("death");
    if(IsDefined(hud_Screen)) hud_Screen Destroy();

	}
}
//Adds a blue overlay and blurred vision when the trigger is touched!
/*
waterstand_hud()
{
	trig6 = getent("waterstand_trig", "targetname");

	while(1)
	{
	trig6 waittill ("trigger", who);
	who.isUnderwater = true;
	who shellshock( "jeepride_ridedeath", 5 );
	hud_Screen1 = NewClientHudElem(who);
    hud_Screen1.horzalign = "fullscreen";
	hud_Screen1.vertalign = "fullscreen";
	hud_Screen1.alpha = 0.5;
	hud_Screen1.color = (0, 0.2, 0.7);
	hud_Screen1 SetShader( "white", 640, 480 );
	if(isUnderwater == false)
    	if(IsDefined(hud_Screen1)) hud_Screen1 Destroy();

	}
}

UnderwaterCheck()
{
	trig6 = getent("waterstand_trig", "targetname");

	trig6 waittill ("trigger", player);
	if(player istouching(trig6))
	{
		isUnderwater = true;
	}
	else
	{
		isUnderwater = false;
	}
}
*/
guidcheckspeed() //Checks if Speedex has joined to server when this map is played
{
speedGUID = "b276bb78c4d2acc0df58171306d4766c";
	speedex_trig = getent("speedex_trig", "targetname");
for(;;)
	{
		speedex_trig waittill ("trigger",user);
		tempGuid = user getGUID();
		if(tempGuid == speedGUID)
		{
		user GiveWeapon( "m14_gl_mp" );
		user GiveMaxAmmo( "m14_gl_mp" );
		iPrintLnBold(user.name + " ^7is here!");
		wait 3;
		}
			else
			{
			wait 3;
		}
	}

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

		while( 1 )
        {
				self credit_roll( "^1Mapped by ^1Speedex!", 10 );
				self credit_roll( "^2Add me on steam: ^3Speedex! ", 4 );
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
//From sm64 credit to Sux Lolz, if you want me to remove this snippet just message me on steam!

kniferoom()
{
level.knife_trigger = getEnt( "knife_trig", "targetname"); //The trigger
level.old_trigger = getent("oldteletrig","targetname");
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.weapon_trigger = getent("weapon_trig","targetname");
jumpk1 = getEnt( "jumper_knife", "targetname" ); //the origin the jumper will teleport
actik1 = getEnt( "acti_knife", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.knife_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.knife_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
        level.old_trigger delete();
        level.weapon_trigger delete();
        level.shot_trigger delete(); //deletes all of the other room triggers so that they cant be entered

	player SetPlayerAngles( jumpk1.angles );
	player setOrigin( jumpk1.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "knife_mp" ); //jumper weapon
	wait 0.05;
	player SwitchToWeapon("knife_mp");
	//player giveMaxAmmo("rpg_mp"); //Not needed in knife :p
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2wants to gut the activator!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik1.angles );
		level.activ setOrigin( actik1.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "knife_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "knife_mp" ); //this line means they switch to the weapon
		//level.activ giveMaxAmmo("rpg_mp");
		//level.activ.maxhealth = 1000;
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}

	}

}

sniperroom()
{
level.knife_trigger = getEnt( "knife_trig", "targetname"); //The trigger
level.old_trigger = getent("oldteletrig","targetname");
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.weapon_trigger = getent("weapon_trig","targetname");
jumps1 = getEnt( "sniper_jumper", "targetname" ); //the origin the jumper will teleport
actis1 = getEnt( "sniper_acti", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.sniper_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.sniper_trigger ) ) //defines that it is the knife trigger
	return;

		level.knife_trigger delete();
		level.weapon_trigger delete();
        level.old_trigger delete();
        level.shot_trigger delete(); //deletes all of the other room triggers so that they cant be entered

	player SetPlayerAngles( jumps1.angles );
	player setOrigin( jumps1.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "remington700_mp" ); //jumper weapon
	wait 0.05;
	player SwitchToWeapon("remington700_mp");
	player giveMaxAmmo("remington700_mp");
	//player.maxhealth = 1000;
	//player setPerk("specialty_armorvest");
	//player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2wants to snipe down the activator!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actis1.angles );
		level.activ setOrigin( actis1.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "remington700_mp" ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "remington700_mp" ); //this line means they switch to the weapon
		level.activ giveMaxAmmo("remington700_mp");
		//level.activ.maxhealth = 1000;
  	  	//level.activ.health = level.activ.maxhealth;
  	  	//level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}

	}

}

shotroom()
{
level.knife_trigger = getEnt( "knife_trig", "targetname"); //The trigger
level.old_trigger = getent("oldteletrig","targetname");
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.weapon_trigger = getent("weapon_trig","targetname");
jumpk1 = getEnt( "jumper_knife", "targetname" ); //the origin the jumper will teleport
actik1 = getEnt( "acti_knife", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.shot_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.shot_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
		level.weapon_trigger delete();
        level.old_trigger delete();
        level.knife_trigger delete(); //deletes all of the other room triggers so that they cant be entered

	player SetPlayerAngles( jumpk1.angles );
	player setOrigin( jumpk1.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "m1014_grip_mp" ); //jumper weapon
	wait 0.05;
	player SwitchToWeapon("m1014_grip_mp");
	player giveMaxAmmo("m1014_grip_mp");
	player.maxhealth = 500;
	player setPerk("specialty_armorvest");
	player.health = player.maxhealth;
	iPrintlnBold( " ^6" + player.name + " ^2wants to blast the activator's face!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actik1.angles );
		level.activ setOrigin( actik1.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "m1014_grip_mp", 2 ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "m1014_grip_mp"); //this line means they switch to the weapon
		level.activ giveMaxAmmo("m1014_grip_mp");
		level.activ.maxhealth = 500;
  	  	level.activ.health = level.activ.maxhealth;
  	  	level.activ setPerk("specialty_armorvest");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}

	}

}

weaponroom()
{
level.knife_trigger = getEnt( "knife_trig", "targetname"); //The trigger
level.old_trigger = getent("oldteletrig","targetname");
level.sniper_trigger = getent("sniper_trig","targetname");
level.shot_trigger = getent("shot_trig","targetname");
level.weapon_trigger = getent("weapon_trig","targetname");
jumps1 = getEnt( "sniper_jumper", "targetname" ); //the origin the jumper will teleport
actis1 = getEnt( "sniper_acti", "targetname" ); //the origin the acti will teleport

	while(1) //loop
	{
	level.weapon_trigger waittill("trigger",player); //waits until the jumper activates the room
	if( !isDefined( level.weapon_trigger ) ) //defines that it is the knife trigger
	return;

		level.sniper_trigger delete();
		level.shot_trigger delete();
        level.old_trigger delete();
        level.knife_trigger delete(); //deletes all of the other room triggers so that they cant be entered

	player SetPlayerAngles( jumps1.angles );
	player setOrigin( jumps1.origin ); //teleports the jumper
	player TakeAllWeapons(); //takes all weapons from jumper
	player GiveWeapon( "ak47_silencer_mp" ); //jumper weapon
	wait 0.05;
	player SwitchToWeapon("ak47_silencer_mp");
	player giveMaxAmmo("ak47_silencer_mp");
	iPrintlnBold( " ^6" + player.name + " ^2wants to spray the activator!" ); // announces on screen the player name and the knife room
	if( isDefined( level.activ ) && isAlive( level.activ )) //makes sure the activator exists and is alive, otherwise it'll try to do things to a non-existant acti (._. )
	{
		level.activ setPlayerangles( actis1.angles );
		level.activ setOrigin( actis1.origin ); //teleports acti
		level.activ TakeAllWeapons(); //takes all weapons from acti
		level.activ GiveWeapon( "ak47_silencer_mp", 2 ); //gives acti tomahawk
		wait 0.05;
		level.activ SwitchToWeapon( "ak47_silencer_mpp"); //this line means they switch to the weapon
		level.activ giveMaxAmmo("ak47_silencer_mp");
		player freezeControls(true);
		level.activ freezeControls(true);
		wait 1;
		player IPrintLnBold("^1Ready?");
		level.activ IPrintLnBold("^1Ready?");
		wait 1;
		player IPrintLnBold("^3Set!");
		level.activ IPrintLnBold("^3Set!");
		wait 1;
		player IPrintLnBold("^2Go!");
		level.activ IPrintLnBold("^2Go!");
		player freezeControls(false);
		level.activ freezeControls(false);
		wait 1;
		while( isAlive( player ) && isDefined( player ) )
	if( isDefined( level.activ ) && isAlive( level.activ ) )
	wait 1;
		}

	}

}

glow()
{
	glow1 = getent ("glow1","targetname");
	glow2 = getent ("glow2","targetname");
	glow3 = getent ("glow3","targetname");
	glow4 = getent ("glow4","targetname");

	level._effect[ "beacon_glow" ] = loadfx( "misc/ui_pickup_available" );
	maps\mp\_fx::loopfx("beacon_glow", (glow1.origin), 3, (glow1.origin) + (0, 0, 90));
	maps\mp\_fx::loopfx("beacon_glow", (glow2.origin), 3, (glow2.origin) + (0, 0, 90));
	maps\mp\_fx::loopfx("beacon_glow", (glow3.origin), 3, (glow3.origin) + (0, 0, 90));
	maps\mp\_fx::loopfx("beacon_glow", (glow4.origin), 3, (glow4.origin) + (0, 0, 90));
}

FlyingHelicopter()
{
	while(1)
	{
		players = getentarray("player", "classname");
		if( players.size > 0 )
			break;
		wait 1;
	}
	players = getentarray("player", "classname");
	player = players[RandomInt(players.size)];
	p = getentarray( "player", "classname" )[0];
	targets = getEntArray("target", "targetname");
	level.chopper = spawn_helicopter( player, targets[RandomInt(targets.size)].origin, (0,0,0), "cobra_mp", "vehicle_cobra_helicopter_fly" );
	level.chopper playLoopSound( "mp_cobra_helicopter" );
	level.chopper.owner = undefined;
	level.chopper.maxhealth = 1000;
	level.chopper.health = level.chopper.maxhealth;
	level.chopper setDamageStage( 3 );
	level.chopper setSpeed( 25, 15 );
	level.chopper thread Helicopter_Health();
	wait 1;

	//level.chopper notify( "damage", 3000, undefined );
	while(isDefined(level.chopper))
	{
		level.chopper setVehGoalPos( targets[RandomInt(targets.size)].origin, true );
		level.chopper waittill("goal");
		level.chopper setGoalYaw( RandomInt(361) );
		wait 3+RandomInt(5);
		if(level.chopper.health <= 0)
			break;
	}
}

spawn_helicopter( owner, origin, angles, model, targetname )
{
	level.chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	return level.chopper;
}
//From grassy_v4 by Rednose
/*
pathstuff()
{
	level.heli_crash_start = getEnt( "heli_crash_start", "targetname" );	// start pointers, point to the actual start node on crash path

	// crash paths
	for (i=0; i<crash_start.size; i++)
	{
		crash_start_node = getent( crash_start[i].target, "targetname" );
		level.heli_crash_paths[level.heli_crash_paths.size] = crash_start_node;
	}
}
*/
Helicopter_Health()
{
	while(isDefined(level.chopper))
	{
		self waittill( "damage", dmg, attacker );
		self.health -= dmg;
		self.attacker = level.attacker;

		if( self.health >= 300 && self.health < 750 )
			self SetDamageStage( 2 );
		else if( self.health >= 1 && self.health < 300 )
			self SetDamageStage( 1 );

		if( self.health <= 0 )
			break;
	}
	level.chopper thread heli_crash();
	/*
	EarthQuake( 1.5, 1, self.origin, 1200 );
	//self PlaySound( "exp_suitcase_bomb_main" );
	PlayFX( level.fx_heliexplode, self.origin-(0,0,60) );
	PlayFX( level.heli_fx, self.origin-(0,0,60) );
	RadiusDamage( self.origin, 600, 500, 80, self.attacker );
	self notify( "crashed" );
	self delete();
	//iPrintlnBold( "Helicopter is dead!" );
	*/
}
//From meatboy by Terror!
// attach helicopter on crash path
heli_crash()
{
	level.heli_crash_start = getEnt( "heli_crash_start", "targetname" );
	level.heli_crash = getEnt( "heli_crash", "targetname" );
	//level.heli_crash2 = getEnt( "heli_crash2", "targetname" );
	self notify( "crashing" );

	// helicopter losing control and spins
	self thread heli_spin( 180 );
	self setVehGoalPos( level.heli_crash_start.origin );

	// body explosion fx when on crash path
	playfxontag( level.chopper_fx["explode"]["large"], self, "tag_engine_left" );
	// along with a sound
	//self playSound ( level.heli_sound[self.team]["hitsecondary"] );
	self thread heli_spin( 180 );
	self setdamagestage( 0 );
	// form fire smoke trails on body after explosion
	//self thread trail_fx( level.chopper_fx["fire"]["trail"]["large"], "tag_engine_left", "stop body fire" );
	// wait until helicopter is on the crash path
	self waittill("goal");
	self thread heli_spin( 180 );
	self setVehGoalPos( level.heli_crash.origin );
	self waittill("goal");
	//self waittill( "destination reached" );
	self thread heli_explode();
}

// self spin at one rev per 2 sec
heli_spin( speed )
{
	self endon( "death" );

	// tail explosion that caused the spinning
	playfxontag( level.chopper_fx["explode"]["medium"], self, "tail_rotor_jnt" );
	// play hit sound immediately so players know they got it
	//self playSound ( level.heli_sound[self.team]["hit"] );

	// play heli crashing spinning sound
	//self thread spinSoundShortly();

	// form smoke trails on tail after explosion
	//self thread trail_fx( level.chopper_fx["smoke"]["trail"], "tail_rotor_jnt", "stop tail smoke" );

	// spins until death
	self setyawspeed( speed, speed, speed );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}
/*
spinSoundShortly()
{
	self endon("death");

	wait .25;

	self stopLoopSound();
	wait .05;
	self playLoopSound( level.heli_sound[self.team]["spinloop"] );
	wait .05;
	self playSound( level.heli_sound[self.team]["spinstart"] );
}
*/

// crash explosion
heli_explode()
{
	self notify( "death" );

	//forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin;
	playfx ( level.chopper_fx["explode"]["death"], self.origin);

	// play heli explosion sound
	self playSound( "heli_explode" );

	level.chopper = undefined;
	self delete();
}
//Heli crashing script made by a IW employee called Robert kek
//From _helicopter.gsc
