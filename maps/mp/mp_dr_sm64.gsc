#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include braxi\_common;

main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_dr_sm64");
	 
	level._effect[ "explolarge" ] = loadfx( "explosions/custom_explo_large" );
	level._effect[ "explosmall" ] = loadfx( "explosions/custom_explo_small" );
	level._effect[ "smokelarge" ] = loadfx( "smoke/custom_smoke_large" );
	level._effect[ "greenemb" ] = loadfx( "fire/custom_emb_green" );
	level._effect[ "redemb" ] = loadfx( "fire/custom_emb_red" );
	level._effect[ "cyanemb" ] = loadfx( "fire/custom_emb_cyan" );
	level._effect[ "watersplash" ] = LoadFX ( "misc/watersplash_large" );
	level._effect[ "waterbodydump" ] = LoadFX ( "impacts/water_splash_bodydump" );
	level._effect[ "watergush" ] = LoadFX ( "misc/water_gush" );
	level._effect[ "enter1" ] = LoadFX ( "impacts/enter_painting" );
	 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
 
	setdvar( "r_specularcolorscale", "1" );
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 2000000 );
	setDvar("bg_falldamageminheight", 1500000 );

	thread sr\api\_map::createSpawn((-5963, -7623, 1452), 357);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("^5Slide Secret;^1Hard Secret;");

	eztp = getEnt("secret_slide_tp","targetname");
	thread sr\api\_speedrun::createTeleporter((-5992, -8082, 1452), 100, 150, 
		eztp.origin, eztp.angles[1], "freeze", "cyan", "secret_0");
	htp = getEnt("hardsecret_enter_tp","targetname");
	thread sr\api\_speedrun::createTeleporter((-5748, -8070, 1452), 100, 150, 
		htp.origin, htp.angles[1], "freeze", "darkred", "secret_1");
	//thread sr\api\_speedrun::createSecretWays("Slide Secret;Hard Secret;"); // TODO

	level.eggmove = 0;
	thread bigdoor1();
	// thread killsonground();
	thread killsonginterm();
	// thread activsong();
	// thread songdeath();
	thread chomp();
	thread moveplat();
	thread canonng();
	// thread star3set();
	thread bluecoin();
	thread doorclose(); // TODO
	thread startsound();
	thread warpsetup();
	thread castlesound();
	thread lvl1sound();
	thread beachng();
	thread secretsetup(); // TODO
	thread lvl1();
	thread tplvl1();
	thread tplvl1fx();
	// thread mapzor();
	// thread messages();
	// thread guidchecking();
	// thread end();
	// thread games();
	//thread watterFX();
	// thread credits();
	thread door1();
	thread starsetup();
	thread coinsetup();
	// thread actisetup();
	thread embfx();
	thread start1();
	thread redbox1();
	thread redbox2();
	thread waterfall();
	// thread kniferoom();
	// thread runwaysetup();
	// thread runroom();
	// thread bouncejumperfail();
	// thread bounceactifail();
	// thread givesniper();
	// thread bounceroom();
	// thread weaponsjumperfail();
	// thread weaponsroom();
	// thread sniperjumperfail();
	// thread sniperroom();

	precacheitem ("m40a3_mp");
	precacheitem ("remington700_mp");
	precacheitem ("knife_mp");
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

	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

killsonground()
{
	level waittill( "round_ended" );
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] stopLocalSound("song1");
		players[i] stopLocalSound("song2");
		players[i] stopLocalSound("song3");
		players[i] stopLocalSound("song4");
		players[i] stopLocalSound("song5");
		players[i] stopLocalSound("song6");
	}
}

killsonginterm()
{
	level waittill( "intermission" );
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] stopLocalSound("song1");
		players[i] stopLocalSound("song2");
		players[i] stopLocalSound("song3");
		players[i] stopLocalSound("song4");
		players[i] stopLocalSound("song5");
		players[i] stopLocalSound("song6");
	}
}


songroom()
{
i = randomintrange(0, 4);
self playSound("enterpaint");

	{
		if(i == 0)
		{
			self playLocalSound("song1");
		}
		else if(i == 1)
		{
			self playLocalSound("song2");
		}
		else if(i == 2)
		{
			self playLocalSound("song5");
		}
		else if(i == 3)
		{
			self playLocalSound("song6");
		}
	}
}

activsong()
{

wait 10;
i = randomintrange(0, 2);

	{
		activator = GetActivator();
	
		if(i == 0)
		{
			activator playLocalSound("song1");
		}
		else if(i == 1)
		{
			activator playLocalSound("song2");
		}
	}
}

songdeath()
{
song = getEnt("sound_begin","targetname");

	for(;;)
	{
	song waittill("trigger", player);
	player waittill_any("death", "disconnect" );
	player playSound("mpain");
	}
}

chomp()
{
chomp = getEnt("chomp","targetname");

	while(1)
	{
	i = randomintrange(0, 3);
		if(i == 0)
		{
			chomp playSound("chomp");
			wait 0.2;
			chomp playSound("chomp");
		}
		else if(i == 1)
		{
			chomp playSound("chomp");
		}
		else if(i == 2)
		{
			chomp playSound("chomp");
			wait 0.2;
			chomp playSound("chomp");
			wait 0.2;
			chomp playSound("chomp");
		}
		else
		{
		wait 2;
		}
	wait 2;
	}
}

moveplat()
{
plat1mario = getEnt("plat_turn1","targetname");
plat1ori = getEnt("plat_turn1_ori","targetname");
plat2mario = getEnt("plat_turn2","targetname");
plat2ori = getEnt("plat_turn2_ori","targetname");

//plat1mario enableLinkTo();
plat1mario linkTo(plat1ori);
//plat2mario enableLinkTo();
plat2mario linkTo(plat2ori);
wait 1;

	while(1)
	{
	plat1ori moveZ(100, 2);
	plat2ori moveZ(-100, 2);
	wait 2;
	plat1ori rotateRoll(180, 2);
	plat2ori rotateRoll(180, 2);
	wait 2;
	plat1ori moveZ(-100, 2);
	plat2ori moveZ(100, 2);
	wait 2;
	plat1ori rotateRoll(180, 2);
	plat2ori rotateRoll(180, 2);
	wait 2;
	}
}

star3set()
{
star3tp = getEnt("star3_tp","targetname");
star3trig = getEnt("star3_trig","targetname");

	for(;;)
	{
	star3trig waittill("trigger",player);
	player setOrigin(star3tp.origin);
	player setPlayerAngles(star3tp.angles);
	player freezeControls(true);
	wait 0.5;
	player freezeControls(false);
	}
}

warpsetup()
{

	thread warp1();
	thread warp2();
	thread warp3();

}

warp1()
{
w1 = getEnt("warp1","targetname");
w1trig = getEnt("warp1_trig","targetname");

	for(;;)
	{
	w1trig waittill("trigger",player);
	player playSound("warp1");
	player setOrigin(w1.origin);
	player setPlayerAngles(w1.angles);
	player playLocalSound("song3");
	}
}

warp2()
{
w2 = getEnt("warp2","targetname");
w2trig = getEnt("warp2_trig","targetname");

	for(;;)
	{
	w2trig waittill("trigger",player);
	player playSound("warp1");
	player setOrigin(w2.origin);
	player setPlayerAngles(w2.angles);
	}
}

warp3()
{
w3 = getEnt("warp3","targetname");
w3trig = getEnt("startdoor_1_trig","targetname");

	for(;;)
	{
	w3trig waittill("trigger",player);
	player playSound("warp1");
	player setOrigin(w3.origin);
	player setPlayerAngles(w3.angles);
	}
}

startsound()
{
soundstart = getEnt("sound_begin","targetname");

	for(;;)
	{
	soundstart waittill("trigger",player);
	player playLocalSound("song4");
	}
}

beachng()
{
ambienttrig1 = getEnt("beach_ambient_1","targetname");

	for(;;)
	{
	ambienttrig1 waittill("trigger",players);
	players playLocalSound("song4");
	}
}

castlesound()
{
ambienttrig2 = getEnt("door1_trig","targetname");

	for(;;)
	{
	ambienttrig2 waittill("trigger",player);
	player playLocalSound("song3");
	}
}

lvl1sound()
{
ambienttrig3 = getEnt("enter_lvl_1","targetname");
i = randomintrange(0, 2);

	for(;;)
	{
	ambienttrig3 waittill("trigger",player);
	
		if(i == 0)
		{
			player playLocalSound("song1");
		}
		else if(i == 1)
		{
			player playLocalSound("song2");
		}
	}
}

//SECRET\\

secretsetup()
{

	thread starsecret();
	thread secretslideeasy();
	thread secretslidehard();
	thread easyslidefinish();
	thread hardslidefinish();
	thread hardsecretenter();
	thread hf1();
	thread hf2();
	thread giverpg1();
	thread giverpg2();
	thread failhard();
	thread darkstar9();
	thread darkstar9rotate();
	thread shroom2();
	thread shroom3();

}

giverpg2()
{
rpg2give = getEnt("give_rpg2","targetname");

	for(;;)
	{
	rpg2give waittill("trigger", player);
	player giveweapon("rpg_mp");
	player switchtoweapon("rpg_mp");
	player givemaxammo("rpg_mp");
	wait 0.2;
	}
}

darkstar9rotate()
{
darkstar9t = getEnt("dark_star_1_secret","targetname");

	while(1)
	{
	darkstar9t rotateYaw(360, 4);
	wait 4;
	}
}

darkstar9()
{
darkstartrig = getEnt("darkstar_trig_1", "targetname");
darkstar9t = getEnt("dark_star_1_secret","targetname");

	{
	darkstartrig waittill("trigger", player);
	player braxi\_rank::giveRankXP("", 300);
	iPrintLnBold( player.name + " ^1Found the ^9Dark Star");
	player playSound("finish3");
	darkstar9t hide();
	wait 2;
	player suicide();
	iPrintLn( "^9Dark Star ^1killed " + player.name );
	}
}

failhard()
{
trigfailhard = getEnt("trig_hardsecrettp_1","targetname");
tpfailhard = getEnt("hardsecret_enter_tp","targetname");

	for(;;)
	{
	trigfailhard waittill("trigger", player);
	player setOrigin(tpfailhard.origin);
	player setPlayerAngles(tpfailhard.angles);
	}
}

hardsecretenter()
{
henter = getEnt("hardsecret_enter_trig","targetname");
htp = getEnt("hardsecret_enter_tp","targetname");

	for(;;)
	{
	henter waittill("trigger",player);
	iprintlnbold( player.name + " ^2Entered the ^1HARD ^3Secret !!" );
	player setOrigin(htp.origin);
	player setPlayerAngles(htp.angles);
	player thread countdown();
	player GiveWeapon( "rpg_mp" );
	}
}

giverpg1()
{
grpg1 = getEnt("giverpg1","targetname");

	for(;;)
	{
	grpg1 waittill("trigger", player);
	currentWeapon = player getCurrentWeapon();
		if( currentWeapon != "rpg_mp" )
		{
		player giveweapon("rpg_mp");
		player switchtoweapon("rpg_mp");
		player givemaxammo("rpg_mp");
		}
		else if( currentWeapon == "rpg_mp" )
		{
		player givemaxammo("rpg_mp");
		}
	wait 1;
	}
}

//**t**\\

countdown()
{
self endon("death");
self endon("finished");
self.pers["time3"] = 60;
self thread timehud3();
for(;;)
{
wait 1;
self.pers["time3"] --;
if(self.pers["time3"]<1)
self suicide();
}
}
 
timehud3()
{
self endon ("death");
self endon ("finished");
self endon ("disconnect");
self.time_hud3 = newClientHudElem(self);
self.time_hud3.x = 305;
self.time_hud3.y = 15;
self.time_hud3.alignX = "middle";
self.time_hud3.alignY = "center";
self.time_hud3.fontScale = 2.3;
self.time_hud3.color = (40, 112, 222);
self.time_hud3.font = "objective";
self.time_hud3.glowColor = (40, 112, 222);
self.time_hud3.glowAlpha = 1;
self.time_hud3.hideWhenInMenu = false;
self.time_hud3.owner = self;
self.time_hud3 setText( self.pers["time3"] );
self.time_hud3 thread destroyondeath3();
self thread changetime3();
self thread destroyondeath3();
wait 60;
self thread destroytimehud3();
}
 
destroyondeath3()
{
        self waittill_any("death", "disconnect", "finished");
        self destroytimehud3();
}
changetime3()
{
for(;;)
{
self.time_hud3 setText( self.pers["time3"] );
wait 0.1;
self.time_hud3 setText( self.pers["time3"] );
wait 0.1;
}
}
 
destroytimehud3()
{
        if( isDefined( self.time_hud3) )
        {
        self.time_hud3 destroy();
    }
}

//**e**\\

hf1()
{
h1f = getEnt("hardsecret_finish_1","targetname");
h1tp = getEnt("hardsecret_finish_tp","targetname");

	for(;;)
	{
	h1f waittill("trigger",player);
	player thread sr\api\_speedrun::finishWay("secret_1");
	// player notify("finished");
	// player braxi\_rank::giveRankXp("", 600);
	// iprintlnbold( player.name + " ^3Finished ^1HARD ^7Secret ^21 !!!!" );
	// player setOrigin(h1tp.origin);
	// player setPlayerAngles(h1tp.angles);
	}
}

hf2()
{
h2f = getEnt("hardsecret_finish_2","targetname");
h2tp = getEnt("hardsecret_finish_tp","targetname");

	for(;;)
	{
	h2f waittill("trigger",player);
	player thread sr\api\_speedrun::finishWay("secret_1");
	// player notify("finished");
	// player braxi\_rank::giveRankXp("", 800);
	// iprintlnbold( player.name + " ^3Finished ^1HARD ^7Secret ^12 !!!!" );
	// player setOrigin(h2tp.origin);
	// player setPlayerAngles(h2tp.angles);
	}
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

endEasySecretTimer()
{
	if( isDefined( self.finishedEasySecret ) )
	return;

	self.finishedEasySecret = true;

	time1 = (getTime() - self.timer1StartTime) / 1000;
	
	self.hud_easysecret destroy();
	self.hud_easysecret1 = addTextHud( self, 9, 12, 1, "center", "top", 3 );
	self.hud_easysecret1.horzAlign = "center";
	self.hud_easysecret1.vertAlign = "top";
	self.hud_easysecret1.glowAlpha = 1;
	self.hud_easysecret1.glowColor = (0,0,0.8);

	self.hud_easysecret1 setText( "^6" + time1 );

	self iPrintlnBold( "You've finished in ^6" + time1 );

	if( time1 < self.pers["time1"] )
		self.pers["time1"] = time1;
}

easySecretTimer()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	wait 0.05;
	self playSound("warp1");
	self iPrintLnBold("^5You ^7have^6 60 ^7seconds to ^5finish ^7!");
	
	self.pers["time1"] = 99999999;
	self.pers["time1death"] = 60;
	
	self.hud_easysecret = addTextHud( self, 9, 12, 1, "center", "top", 2.5 );
	self.hud_easysecret.horzAlign = "center";
	self.hud_easysecret.vertAlign = "top";
	self.hud_easysecret.glowAlpha = 1;
	self.hud_easysecret.glowColor = (0,0,0.8);
	self.hud_easysecret.label = &"^6&&1";
	self.hud_easysecret setTenthsTimerUp( 1 );

	self.timer1StartTime = getTime();
	
	for(;;)
	{
		wait 1;
		self.pers["time1death"] --;
		if(self.pers["time1death"]<1)
		self suicide();
	}
}

endHardSecretTimer()
{
	if( isDefined( self.finishedHardSecret ) )
	return;

	self.finishedHardSecret = true;

	time2 = (getTime() - self.timer2StartTime) / 1000;
	
	self.hud_hardsecret destroy();
	self.hud_hardsecret1 = addTextHud( self, 9, 12, 1, "center", "top", 3 );
	self.hud_hardsecret1.horzAlign = "center";
	self.hud_hardsecret1.vertAlign = "top";
	self.hud_hardsecret1.glowAlpha = 1;
	self.hud_hardsecret1.glowColor = (0.8,0,0);

	self.hud_hardsecret1 setText( "^1" + time2 );

	iPrintlnBold( self.name + " finished ^1HARD ^7secret slide in ^1" + time2 );

	if( time2 < self.pers["time2"] )
		self.pers["time2"] = time2;
}

hardSecretTimer()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	wait 0.05;
	self playSound("warp1");
	self iPrintLnBold("^1You have^8 30 ^7seconds to ^1finish ^7!");
	
	self.pers["time2"] = 99999999;
	self.pers["time2death"] = 30;
	
	self.hud_hardsecret = addTextHud( self, 9, 12, 1, "center", "top", 2.5 );
	self.hud_hardsecret.horzAlign = "center";
	self.hud_hardsecret.vertAlign = "top";
	self.hud_hardsecret.glowAlpha = 1;
	self.hud_hardsecret.glowColor = (0.8,0,0);
	self.hud_hardsecret.label = &"^1&&1";
	self.hud_hardsecret setTenthsTimerUp( 1 );

	self.timer2StartTime = getTime();
	
	for(;;)
	{
		wait 1;
		self.pers["time2death"] --;
		if(self.pers["time2death"]<1)
		self suicide();
	}
}

easyslidefinish()
{
easyfinish = getEnt("secret_slide_finish_easy","targetname");
slidefinishtp = getEnt("warp1_aftersecret","targetname");

	while( 1 )
	{
		easyfinish waittill( "trigger", user );

			user thread sr\api\_speedrun::finishWay("secret_0");
		// if( !user isReallyAlive() || user.pers["team"] == "axis" || isDefined( user.finishedEasySecret ) )
		// 	continue;

		// user thread endEasySecretTimer();
		// user thread destroysecrethud1();
		// user.pers["time1death"] = 99999999;
		// user setOrigin(slidefinishtp.origin);
		// user setPlayerAngles(slidefinishtp.angles);
		// wait 0.05;
		user playSound("warp1");
		user playSound("finish2");
		user playLocalSound("song3");
	}
}

hardslidefinish()
{
hardfinish = getEnt("secret_slide_finish_hard","targetname");
slidefinishtp = getEnt("warp1_aftersecret","targetname");

	while( 1 )
	{
		hardfinish waittill( "trigger", user );

		if( !user isReallyAlive() || user.pers["team"] == "axis" || isDefined( user.finishedHardSecret ) )
			continue;

		user thread endHardSecretTimer();
		user thread destroysecrethud2();
		user.pers["time2death"] = 99999999;
		user setOrigin(slidefinishtp.origin);
		user setPlayerAngles(slidefinishtp.angles);
		wait 0.05;
		user playSound("warp1");
		user playSound("finish2");
		user playLocalSound("song3");
	}
}

destroysecrethud1()
{
        if( isDefined( self.hud_easysecret) )
        {
        self.hud_easysecret destroy();
    }
}

destroysecrethud2()
{
        if( isDefined( self.hud_hardsecret) )
        {
        self.hud_hardsecret destroy();
    }
}

deathsecretslide()
{

	self waittill_any("death", "disconnect");
	self.hud_easysecret destroy();
	self.hud_easysecret1 destroy();
	self.hud_hardsecret destroy();
	self.hud_hardsecret1 destroy();
	self playSound("mfire");

}

secretslideeasy()
{
ez = getEnt("secret_slide_easy","targetname");
eztp = getEnt("secret_slide_tp","targetname");

	for(;;)
	{
	ez waittill("trigger",player);
	player thread easySecretTimer();
	player thread deathsecretslide();
	player setOrigin(eztp.origin);
	player setPlayerAngles(eztp.angles);
	player thread songspecial();
	}
}

secretslidehard()
{
hw = getEnt("secret_slide_hard","targetname");
hwtp = getEnt("secret_slide_tp","targetname");

	for(;;)
	{
	hw waittill("trigger",player);
	player thread hardSecretTimer();
	player thread deathsecretslide();
	player setOrigin(hwtp.origin);
	player setPlayerAngles(hwtp.angles);
	player thread songspecial();
	}
}

songspecial()
{

i = randomintrange(0, 2);
	
	if(i == 0)
	{
		self playLocalSound("song5");
	}
	else if(i == 1)
	{
		self playLocalSound("song6");
	}
}

shroom1()
{
shroom1 = getEnt("shroom_1","targetname");
shroom1trig = getEnt("shroom_1_trig","targetname");

shroom1trig enableLinkTo();
shroom1trig linkTo(shroom1);
shroom1 notsolid();

wait 0.05;
shroom1 moveZ(40, 0.8, 0.2, 0.2);

	{
	shroom1trig waittill("trigger",player);
	player playSound("oneup");
	player braxi\_mod::giveLife();
	shroom1 hide();
	}
}

shroom2()
{
shroom2 = getEnt("shroom_2","targetname");
shroom2trig = getEnt("shroom_2_trig","targetname");

	{
	shroom2trig waittill("trigger",player);
	player playSound("oneup");
	player braxi\_mod::giveLife();
	shroom2 hide();
	shroom2trig delete();
	}
}

shroom3()
{
shroom3 = getEnt("shroom_3","targetname");
shroom3trig = getEnt("shroom_3_trig","targetname");

	{
	shroom3trig waittill("trigger",player);
	player playSound("oneup");
	player braxi\_mod::giveLife();
	shroom3 hide();
	shroom3trig delete();
	}
}

bluecoin()
{
binvalid = getEnt("bluecoin_invalid","targetname");

	{
	binvalid waittill("trigger",player);
	player playSound("invalid");
	}
}

doorclose()
{
door2 = getEnt("door2","targetname");
door2ori = getEnt("door2_ori","targetname");
doorclosetrig = getEnt("secret_close","targetname");

}

starsecret()
{
box = getEnt("star_secret_cube","targetname");
boxtrig = getEnt("star_secret_trig","targetname");
stars = getEnt("star_secret","targetname");
starsori = getEnt("star_secret_ori","targetname");
stars1 = getEnt("star_secret1","targetname");
starsori1 = getEnt("star_secret_ori1","targetname");
secretdoor = getEnt("secret_door","targetname");
tpafter = getEnt("tp_after","targetname");
door2 = getEnt("door2","targetname");
door2ori = getEnt("door2_ori","targetname");

//starsori enableLinkTo();
starsori linkTo(stars);
//starsori1 enableLinkTo();
starsori1 linkTo(stars1);
//door2 enablelinkto();
door2 linkto(door2ori);
wait 0.2;
stars hide();
stars1 hide();


	{
	boxtrig waittill("trigger",player);
	thread shroom1();
	player braxi\_rank::giveRankXP("", 100);
	player iprintlnbold("^3You ^2Won ^3100 XP^2!!");
	box moveZ(10, 0.5);
	stars PlaySound("boxbreack2");
	wait 0.4;
	box moveZ(-10, 0.5);
	stars show();
	stars rotateYaw(1440, 2, 0.2, 0);
	wait 3;
	player setOrigin(tpafter.origin);
	stars rotateYaw(720, 3, 0, 1);
	wait 3;
	stars hide();
	wait 0.2;
	secretdoor waittill("trigger",player);
	secretdoor triggerOff();
	stars1 show();
	stars1 PlaySound("star");
	stars1 rotateYaw(1440, 2, 0.2, 0);
	wait 2;
	door2ori rotateYaw(75, 3, 0.5, 0.5);
	door2ori playSound("doorwood");
	stars1 rotateYaw(720, 3, 0, 1);
	wait 3;
	stars1 hide();
	wait 0.2;
	}

}

//SECRET\\

waterfall()
{
w1 = getEnt("fx_waterfall1","targetname");
w2 = getEnt("fx_waterfall2","targetname");
w3 = getEnt("fx_waterfall3","targetname");
w4 = getEnt("fx_waterfall4","targetname");
s1 = getEnt("sfx_waterfall","targetname");
wait 0.2;
s1 playLoopSound("waterfall");

	while(1)
	{
	playFx(level._effect["watergush"],w1.origin);
	playFx(level._effect["watergush"],w2.origin);
	playFx(level._effect["watergush"],w3.origin);
	playFx(level._effect["watergush"],w4.origin);
	wait 0.4;
	}
}

lvl1()
{
b1 = getEnt("sfx_bird1","targetname");
b2 = getEnt("sfx_bird2","targetname");
b3 = getEnt("sfx_bird3","targetname");

	while(1)
	{
	x = randomint(3);
	wait 0.2;
	if(x == 0)
	{
	b1 playSound("bird1");
	}
	if(x == 1)
	{
	b2 playSound("bird2");
	}
	if(x == 2)
	{
	b3 playSound("bird3");
	}
	wait 6;
	}
}

canonng()
{
entertrig = getEnt("enter_lvl_1","targetname");

	{
	entertrig waittill("trigger",player);
	thread canon1();
	}
}

tplvl1()
{
entertrig = getEnt("enter_lvl_1","targetname");
enterori = getEnt("enter_lvl_1_ori","targetname");

	for (;;)
	{
		entertrig waittill("trigger", player);
		player setOrigin(enterori.origin);
		player setPlayerAngles(enterori.angles);
	}
}

tplvl1fx()
{
fxpaintlvl1 = getEnt("fx_paint_lvl1","targetname");
fxng = getEnt("fx_paintlvl1_ori","targetname");

	for(;;)
	{
	fxpaintlvl1 waittill("trigger", player);
	playFx(level._effect["enter1"],fxng.origin);
	fxng PlaySound("enterpaint");
	wait 0.4;
	}
}

redbox1()
{
r1 = getEnt("red_box1","targetname");
r1trig = getEnt("red_box1_trig","targetname");

	{
	r1trig waittill("trigger",player);
	r1 moveZ(20, 1, 0.2, 0.2);
	r1 playSound("invalid");
	wait 1;
	r1 moveZ(-20, 1, 0.2, 0.2);
	wait 0.2;
	}
}

redbox2()
{
r2 = getEnt("red_box2","targetname");
r2trig = getEnt("red_box2_trig","targetname");

	{
	r2trig waittill("trigger",player);
	r2 moveZ(20, 1, 0.2, 0.2);
	r2 playSound("invalid");
	wait 1;
	r2 moveZ(-20, 1, 0.2, 0.2);
	wait 0.2;
	}
}

start1()
{
	startdoor1 = getEnt("startdoor_1","targetname");
	startdoor1trig = getEnt("startdoor_1_trig","targetname");

	wait 0.05;

	startdoor1 delete();
	startdoor1trig delete();
}

embfx()
{
fxred1 = getEnt("fx_emb_red1","targetname");
fxred2 = getEnt("fx_emb_red2","targetname");
fxred3 = getEnt("fx_emb_red3","targetname");
fxred4 = getEnt("fx_emb_red4","targetname");
fxred5 = getEnt("fx_emb_red5","targetname");
fxgreen1 = getEnt("fx_emb_green1","targetname");
fxgreen2 = getEnt("fx_emb_green2","targetname");
fxgreen3 = getEnt("fx_emb_green3","targetname");
fxgreen4 = getEnt("fx_emb_green4","targetname");
fxgreen5 = getEnt("fx_emb_green5","targetname");
fxcyan1 = getEnt("fx_emb_cyan1","targetname");
fxcyan2 = getEnt("fx_emb_cyan2","targetname");
fxcyan3 = getEnt("fx_emb_cyan3","targetname");
fxcyan4 = getEnt("fx_emb_cyan4","targetname");
fxcyan5 = getEnt("fx_emb_cyan5","targetname");
level._effect[ "greenemb" ] = loadfx( "fire/custom_emb_green" );
level._effect[ "redemb" ] = loadfx( "fire/custom_emb_red" );
level._effect[ "cyanemb" ] = loadfx( "fire/custom_emb_cyan" );

	while(1)
	{
	playFx(level._effect["redemb"],fxred1.origin);
	playFx(level._effect["redemb"],fxred2.origin);
	playFx(level._effect["redemb"],fxred3.origin);
	playFx(level._effect["redemb"],fxred4.origin);
	playFx(level._effect["redemb"],fxred5.origin);
	playFx(level._effect["greenemb"],fxgreen1.origin);
	playFx(level._effect["greenemb"],fxgreen2.origin);
	playFx(level._effect["greenemb"],fxgreen3.origin);
	playFx(level._effect["greenemb"],fxgreen4.origin);
	playFx(level._effect["greenemb"],fxgreen5.origin);
	playFx(level._effect["cyanemb"],fxcyan1.origin);
	playFx(level._effect["cyanemb"],fxcyan2.origin);
	playFx(level._effect["cyanemb"],fxcyan3.origin);
	playFx(level._effect["cyanemb"],fxcyan4.origin);
	playFx(level._effect["cyanemb"],fxcyan5.origin);
	wait 1;
	}
}

//ACTI ROOM\\

actisetup()
{

	thread yoshiegg();
	thread pos1e2();
	thread pos3e4();
	thread pos5e6();
	thread pos7e8();
	thread pos9e10();
	thread pos11e4e5e12();
	thread pos13fin();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();

}

playertp()
{
yegg = getEnt("yoshi_egg_acti","targetname");
yeggfx = getEnt("fx_egg_ft","targetname");

//yeggfx enableLinkTo();
yeggfx linkTo(yegg);
wait 0.05;
}

activcube()
{
yegg = getEnt("yoshi_egg_acti","targetname");

	{
	wait 0.2;
	}
}

trap1()
{
trig = getent("trig_trap1","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD");
}
else
trig delete();
user braxi\_rank::giveRankXP("", 100);
user iPrintLnBold("^2Activated");
user playSound("coin");
thread ballstrapsetup();
thread activcube();
}

trap2()
{
trig = getent("trig_trap2","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD");
}
else
trig delete();
user braxi\_rank::giveRankXP("", 100);
user iPrintLnBold("^2Activated");
user playSound("coin");
thread traprandom();
thread trapmaskass1();
thread activcube();
}

trap3()
{
trig = getent("trig_trap3","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD");
}
else
trig delete();
user braxi\_rank::giveRankXP("", 100);
user iPrintLnBold("^2Activated");
user playSound("coin");
thread activcube();
thread movingballsetup();
}

trap4()
{
trig = getent("trig_trap4","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD");
}
else
trig delete();
user braxi\_rank::giveRankXP("", 100);
user iPrintLnBold("^2Activated");
user playSound("coin");
thread activcube();
thread traprandom2();
}

trap5()
{
trig = getent("trig_trap5","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD");
}
else
trig delete();
user braxi\_rank::giveRankXP("", 100);
user iPrintLnBold("^2Activated");
user playSound("coin");
thread activcube();
thread traphammer();
}

trap6()
{
trig = getent("trig_trap6","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD");
}
else
trig delete();
user braxi\_rank::giveRankXP("", 100);
user iPrintLnBold("^2Activated");
user playSound("coin");
thread activcube();
thread trapmaskass2();
}

trap7()
{
trig = getent("trig_trap7","targetname");
trig waittill("trigger" , user );
if(user.pers["team"] != "axis")
{
	wait 0.2;
}
else if(level.trapsdisabled)
{
	iprintln(user.name + " is a ^5noob ^7tried to ^5acti ^7in ^5FREE^7. xD");
}
else
trig delete();
user braxi\_rank::giveRankXP("", 100);
user iPrintLnBold("^2Activated");
user playSound("coin");
thread mont1down();
thread trappusher();
thread activcube();
wait 7;
thread trapmtn2();
}

pos1e2()
{
yegg = getEnt("yoshi_egg_acti","targetname");
epos0 = getEnt("egg_pos0","targetname");
epos1 = getEnt("egg_pos1","targetname");
epos2 = getEnt("egg_pos2","targetname");
epos1trig = getEnt("egg_pos1_trig","targetname");
trig = getent("trig_trap1","targetname");

epos1trig waittill("trigger",player);
player freezeControls(true);
air = Spawn("script_origin", player.origin);
player linkto(air);
air moveto(epos0.origin, .5);
level.eggmove = 1;
wait 2;

	if(level.eggmove == 1)
	{
	yegg rotateYaw(-630, 3, 0.5, 0.5);
	yegg moveto(epos1.origin, 1.5);
	air moveto(epos1.origin, 1.5);
	wait 1.5;
	yegg moveto(epos2.origin, 1.5);
	air moveto(epos2.origin, 1.5);
	yegg waittill("movedone");
	wait 2;
	epos1trig triggerOff();
	player freezeControls(false);
	player unlink();
	air delete();
	trig delete();
	level.eggmove = 0;
	}
	else
	{
	wait 4;
	}
}

pos3e4()
{
yegg = getEnt("yoshi_egg_acti","targetname");
epos2 = getEnt("egg_pos2","targetname"); //ng
epos3 = getEnt("egg_pos3","targetname");
epos4 = getEnt("egg_pos4","targetname");
epos3trig = getEnt("egg_pos3_trig","targetname");
trig = getent("trig_trap2","targetname");

epos3trig waittill("trigger",player);
player freezeControls(true);
air = Spawn("script_origin", player.origin);
player linkto(air);
air moveto(epos2.origin, .5);
level.eggmove = 1;
wait 2;

	if(level.eggmove == 1)
	{
	yegg rotateYaw(-720, 3, 0.5, 0.5);
	yegg moveto(epos3.origin, 1.5);
	air moveto(epos3.origin, 1.5);
	wait 1.5;
	yegg moveto(epos4.origin, 1.5);
	air moveto(epos4.origin, 1.5);
	yegg waittill("movedone");
	wait 2;
	epos3trig triggerOff();
	player freezeControls(false);
	player unlink();
	air delete();
	trig delete();
	level.eggmove = 0;
	}
	else
	{
	wait 4;
	}
}

pos5e6()
{
yegg = getEnt("yoshi_egg_acti","targetname");
epos4 = getEnt("egg_pos4","targetname"); //ng
epos5 = getEnt("egg_pos5","targetname");
epos6 = getEnt("egg_pos6","targetname");
epos5trig = getEnt("egg_pos5_trig","targetname");
trig = getent("trig_trap3","targetname");

epos5trig waittill("trigger",player);
player freezeControls(true);
air = Spawn("script_origin", player.origin);
player linkto(air);
air moveto(epos4.origin, .5);
level.eggmove = 1;
wait 2;

	if(level.eggmove == 1)
	{
	yegg rotateYaw(-540, 3, 0.5, 0.5);
	yegg moveto(epos5.origin, 1.5);
	air moveto(epos5.origin, 1.5);
	wait 1.5;
	yegg moveto(epos6.origin, 1.5);
	air moveto(epos6.origin, 1.5);
	yegg waittill("movedone");
	wait 2;
	epos5trig triggerOff();
	player freezeControls(false);
	player unlink();
	air delete();
	trig delete();
	level.eggmove = 0;
	}
	else
	{
	wait 4;
	}
}

pos7e8()
{
yegg = getEnt("yoshi_egg_acti","targetname");
epos6 = getEnt("egg_pos6","targetname"); //ng
epos7 = getEnt("egg_pos7","targetname");
epos8 = getEnt("egg_pos8","targetname");
epos7trig = getEnt("egg_pos7_trig","targetname");
trig = getent("trig_trap4","targetname");

epos7trig waittill("trigger",player);
player freezeControls(true);
air = Spawn("script_origin", player.origin);
player linkto(air);
air moveto(epos6.origin, .5);
level.eggmove = 1;
wait 2;

	if(level.eggmove == 1)
	{
	yegg rotateYaw(-720, 3, 0.5, 0.5);
	yegg moveto(epos7.origin, 1.5);
	air moveto(epos7.origin, 1.5);
	wait 1.5;
	yegg moveto(epos8.origin, 1.5);
	air moveto(epos8.origin, 1.5);
	yegg waittill("movedone");
	wait 2;
	epos7trig triggerOff();
	player freezeControls(false);
	player unlink();
	air delete();
	trig delete();
	level.eggmove = 0;
	}
	else
	{
	wait 4;
	}
}

pos9e10()
{
yegg = getEnt("yoshi_egg_acti","targetname");
epos8 = getEnt("egg_pos8","targetname"); //ng
epos9 = getEnt("egg_pos9","targetname");
epos10 = getEnt("egg_pos10","targetname");
epos9trig = getEnt("egg_pos9_trig","targetname");
trig = getent("trig_trap5","targetname");

epos9trig waittill("trigger",player);
player freezeControls(true);
air = Spawn("script_origin", player.origin);
player linkto(air);
air moveto(epos8.origin, .5);
level.eggmove = 1;
wait 2;

	if(level.eggmove == 1)
	{
	yegg rotateYaw(-540, 3, 0.5, 0.5);
	yegg moveto(epos9.origin, 1.5);
	air moveto(epos9.origin, 1.5);
	wait 1.5;
	yegg moveto(epos10.origin, 1.5);
	air moveto(epos10.origin, 1.5);
	yegg waittill("movedone");
	wait 2;
	epos9trig triggerOff();
	player freezeControls(false);
	player unlink();
	air delete();
	trig delete();
	level.eggmove = 0;
	}
	else
	{
	wait 4;
	}
}

pos11e4e5e12()
{
yegg = getEnt("yoshi_egg_acti","targetname");
epos10 = getEnt("egg_pos10","targetname"); //ng
epos11 = getEnt("egg_pos11","targetname");
epos4 = getEnt("egg_pos4","targetname");
epos5 = getEnt("egg_pos5","targetname");
epos12 = getEnt("egg_pos12","targetname");
epos11trig = getEnt("egg_pos11_trig","targetname");
trig = getent("trig_trap6","targetname");

epos11trig waittill("trigger",player);
player freezeControls(true);
air = Spawn("script_origin", player.origin);
player linkto(air);
air moveto(epos10.origin, .5);
level.eggmove = 1;
wait 2;

	if(level.eggmove == 1)
	{
	yegg rotateYaw(-720, 5, 0.5, 0.5);
	yegg moveto(epos11.origin, 1);
	air moveto(epos11.origin, 1);
	wait 1;
	yegg moveto(epos4.origin, 1);
	air moveto(epos4.origin, 1);
	wait 1;
	yegg moveto(epos5.origin, 1);
	air moveto(epos5.origin, 1);
	wait 1;
	yegg moveto(epos12.origin, 1.5);
	air moveto(epos12.origin, 1.5);
	yegg waittill("movedone");
	wait 2;
	epos11trig triggerOff();
	player freezeControls(false);
	player unlink();
	air delete();
	trig delete();
	level.eggmove = 0;
	}
	else
	{
	wait 4;
	}
}

pos13fin()
{
yegg = getEnt("yoshi_egg_acti","targetname");
epos12 = getEnt("egg_pos12","targetname"); //ng
epos13 = getEnt("egg_pos13","targetname");
epos13trig = getEnt("egg_pos13_trig","targetname");
yegghurt = getEnt("yoshi_egg_acti_hurt","targetname");
yeggfx = getEnt("fx_egg_ft","targetname");
trig = getent("trig_trap7","targetname");

epos13trig waittill("trigger",player);
player freezeControls(true);
air = Spawn("script_origin", player.origin);
player linkto(air);
air moveto(epos12.origin, .5);
level.eggmove = 1;
wait 2;

	if(level.eggmove == 1)
	{
	yegg rotateYaw(-630, 3, 0.5, 0.5);
	yegg moveto(epos13.origin, 3);
	air moveto(epos13.origin, 3);
	yegg waittill("movedone");
	wait 3;
	epos13trig triggerOff();
	yegg delete();
	yegghurt delete();
	yeggfx delete();
	player freezeControls(false);
	player unlink();
	air delete();
	trig delete();
	level.eggmove = 0;
	}
	else
	{
	wait 4;
	}
}

yoshiegg()
{
yegg = getEnt("yoshi_egg_acti","targetname");
yegghurt = getEnt("yoshi_egg_acti_hurt","targetname");
yeggfx = getEnt("fx_egg_ft","targetname");

yegghurt enableLinkTo();
yegghurt linkTo(yegg);
//yeggfx enableLinkTo();
yeggfx linkTo(yegg);

	while(1)
	if(level.eggmove == 0)
	{
	yegg moveZ(-10, 2);
	wait 2;
	yegg moveZ(10, 2);
	wait 2;
	}
	else
	{
	wait 2;
	}
}

//ACTI ROOM\\

canon1()
{
canond = getEnt("canon_1_d","targetname");
canonp = getEnt("canon_1_p","targetname");
canonpori = getEnt("canon_1_p_ori","targetname");
canong = getEnt("canon_1_g","targetname");

canonp enableLinkTo();
canonp linkTo(canonpori);

	{
	canong moveX(65, 1, 0.4, 0.4);
	wait 0.2;
	canonpori moveZ(75, 1, 0.4, 0.4);
	canonpori playSound("canon1");
	canond moveZ(75, 1, 0.4, 0.4);
	wait 1;
	canonpori rotatePitch(-40, 1, 0.2, 0.2);
	canonpori playSound("canon2");
	wait 0.2;
	}
}

traphammer()
{
ham1 = getEnt("ham1","targetname");
ham1ori = getEnt("ham1_ori","targetname");
ham1hurt = getEnt("ham1_hurt","targetname");
ham2 = getEnt("ham2","targetname");
ham2hurt = getEnt("ham2_hurt","targetname");
ham2ori = getEnt("ham2_ori","targetname");

ham1 enableLinkTo();
ham1 linkTo(ham1ori);
ham2 enableLinkTo();
ham2 linkTo(ham2ori);
ham1hurt enableLinkTo();
ham1hurt linkTo(ham1ori);
ham2hurt enableLinkTo();
ham2hurt linkTo(ham2ori);
wait 0.2;

ham1ori rotatePitch(-20, 0.5);
ham2ori rotatePitch(-20, 0.5);
wait 0.5;

	while(1)
	{
	ham1ori rotatePitch(40, 1, 0.5, 0.5);
	ham2ori rotatePitch(40, 1, 0.5, 0.5);
	wait 1;
	ham1ori rotatePitch(-40, 1, 0.5, 0.5);
	ham2ori rotatePitch(-40, 1, 0.5, 0.5);
	wait 1;
	}
}

//STAR\\

starsetup()
{
	thread starturn();
	thread star1();
	thread star2();
	thread star3();
	thread star4();
	thread star5();
}

starturn()
{
star1 = getEnt("star_1","targetname");
star2 = getEnt("star_2","targetname");
star3 = getEnt("star_3","targetname");
star4 = getEnt("star_4","targetname");
dstar1 = getEnt("dark_star_1","targetname");
dstar2 = getEnt("dark_star_2","targetname");
dstar3 = getEnt("dark_star_3","targetname");

	while(1)
	{
	dstar1 rotateYaw(-360, 6);
	star1 rotateYaw(360, 6);
	dstar2 rotateYaw(-360, 6);
	star2 rotateYaw(360, 6);
	dstar3 rotateYaw(-360, 6);
	star3 rotateYaw(360, 6);
	star4 rotateYaw(360, 6);
	wait 6;
	}
}

star1()
{
star1trig = getEnt("star_1_trig", "targetname");
star1 = getEnt("star_1","targetname");

	{
	star1trig waittill("trigger", player);
	// player braxi\_rank::giveRankXP("", 100);
	// player iPrintLnBold("^2You ^7won ^3100 XP ^7!");
	player playSound("enterpaint");
	star1 hide();
	}
}

star2()
{
dstar2 = getEnt("dark_star_2","targetname");
star2trig = getEnt("star_2_trig", "targetname");
star2 = getEnt("star_2","targetname");

	{
	star2trig waittill("trigger", player);
	// player braxi\_rank::giveRankXP("", 100);
	// player iPrintLnBold("^2You ^7won ^3100 XP ^7!");
	player playSound("enterpaint");
	star2 hide();
	}
}

star3()
{
dstar3 = getEnt("dark_star_3","targetname");
star3trig = getEnt("star_3_trig", "targetname");
star3 = getEnt("star_3","targetname");


	star3trig waittill("trigger", player);
	// player braxi\_rank::giveRankXP("", 100);
	// player iPrintLnBold("^2You ^7won ^3100 XP ^7!");
	player playSound("enterpaint");
	star3 hide();

}

star4()
{
star4trig = getEnt("star_4_trig", "targetname");
star4 = getEnt("star_4","targetname");

	{
	star4trig waittill("trigger", player);
	// player braxi\_rank::giveRankXP("", 150);
	// player iPrintLnBold("^2You ^7won ^3150 XP ^7!");
	player playSound("finish3");
	star4 hide();
	}
}

star5()
{
ybox = getEnt("yel_box","targetname");
yboxtrig = getEnt("yel_box_trig","targetname");
yboxfx = getEnt("yel_box_fx","targetname");
ystar = getEnt("yel_box_star","targetname");
ystarori = getEnt("yel_box_star_ori","targetname");

//ystarori enableLinkTo();
ystarori linkTo(ystar);
wait 0.2;
ystar hide();

	{
	yboxtrig waittill("trigger",player);
	// player braxi\_rank::giveRankXP("", 100);
	// player iPrintLnBold("^2You ^7won ^3100 XP ^7!");
	ybox moveZ(10, 0.2);
	wait 0.1;
	playFx(level._effect[ "explosmall" ],yboxfx.origin);
	yboxfx PlaySound("grenade_explode_metal");
	yboxfx playSound("boxbreack");
	ybox hide();
	ystar show();
	ystar PlaySound("star");
	ystar rotateYaw(1440, 2, 0.2, 0);
	wait 2;
	ystar rotateYaw(720, 3, 0, 1);
	wait 3;
	ystar hide();
	wait 0.2;
	}
}

//STAR\\

//COIN\\

coinsetup()
{
	thread cointurn();
	thread coin1();
	thread coin2();
	thread coin3();
	thread coin4();
	thread coin5();
	thread coin6();
	thread coin7();
	thread coin8();
	thread coin9();
	thread coin10();
	thread coin11();
	thread coin12();
	thread coin13();
	thread coin14();
	thread coin15();
	thread coin16();
	thread coin17();
	thread coin18();
}

cointurn()
{
coin1 = getEnt("coin_1","targetname");
coin2 = getEnt("coin_2","targetname");
coin3 = getEnt("coin_3","targetname");
coin4 = getEnt("coin_4","targetname");
coin5 = getEnt("coin_5","targetname");
coin6 = getEnt("coin_6","targetname");
coin7 = getEnt("coin_7","targetname");
coin8 = getEnt("coin_8","targetname");
coin9 = getEnt("coin_9","targetname");
coin10 = getEnt("coin_10","targetname");
coin11 = getEnt("coin_11","targetname");
coin12 = getEnt("coin_12","targetname");
coin13 = getEnt("coin_13","targetname");
coin14 = getEnt("coin_14","targetname");
coin15 = getEnt("coin_15","targetname");
coin16 = getEnt("coin_16","targetname");
coin17 = getEnt("coin_17","targetname");
coin18 = getEnt("coin_18","targetname");

	while(1)
	{
	coin1 rotateYaw(360, 3);
	coin2 rotateYaw(360, 3);
	coin3 rotateYaw(360, 3);
	coin4 rotateYaw(360, 3);
	coin5 rotateYaw(360, 3);
	coin6 rotateYaw(360, 3);
	coin7 rotateYaw(360, 3);
	coin8 rotateYaw(360, 3);
	coin9 rotateYaw(360, 3);
	coin10 rotateYaw(360, 3);
	coin11 rotateYaw(360, 3);
	coin12 rotateYaw(360, 3);
	coin13 rotateYaw(360, 3);
	coin14 rotateYaw(360, 3);
	coin15 rotateYaw(360, 3);
	coin16 rotateYaw(360, 3);
	coin17 rotateYaw(360, 3);
	coin18 rotateYaw(360, 3);
	wait 3;
	}
}

coin1()
{
coin1 = getEnt("coin_1","targetname");
coin1trig = getEnt("coin_1_trig","targetname");

	{
	coin1trig waittill("trigger", player);
	player playSound("coin");
	coin1 hide();
	coin1trig triggerOff();
	 
	wait 0.2;
	}
}

coin2()
{
coin2 = getEnt("coin_2","targetname");
coin2trig = getEnt("coin_2_trig","targetname");

	{
	coin2trig waittill("trigger", player);
	player playSound("coin");
	coin2 hide();
	coin2trig triggerOff();
	 
	wait 0.2;
	}
}

coin3()
{
coin3 = getEnt("coin_3","targetname");
coin3trig = getEnt("coin_3_trig","targetname");

	{
	coin3trig waittill("trigger", player);
	player playSound("coin");
	coin3 hide();
	coin3trig triggerOff();
	 
	wait 0.2;
	}
}

coin4()
{
coin4 = getEnt("coin_4","targetname");
coin4trig = getEnt("coin_4_trig","targetname");

	{
	coin4trig waittill("trigger", player);
	player playSound("coin");
	coin4 hide();
	coin4trig triggerOff();
	 
	wait 0.2;
	}
}

coin5()
{
coin5 = getEnt("coin_5","targetname");
coin5trig = getEnt("coin_5_trig","targetname");

	{
	coin5trig waittill("trigger", player);
	player playSound("coin");
	coin5 hide();
	coin5trig triggerOff();
	 
	wait 0.2;
	}
}

coin6()
{
coin6 = getEnt("coin_6","targetname");
coin6trig = getEnt("coin_6_trig","targetname");

	{
	coin6trig waittill("trigger", player);
	player playSound("coin");
	coin6 hide();
	coin6trig triggerOff();
	 
	wait 0.2;
	}
}

coin7()
{
coin7 = getEnt("coin_7","targetname");
coin7trig = getEnt("coin_7_trig","targetname");

	{
	coin7trig waittill("trigger", player);
	player playSound("coin");
	coin7 hide();
	coin7trig triggerOff();
	 
	wait 0.2;
	}
}

coin8()
{
coin8 = getEnt("coin_8","targetname");
coin8trig = getEnt("coin_8_trig","targetname");

	{
	coin8trig waittill("trigger", player);
	player playSound("coin");
	coin8 hide();
	coin8trig triggerOff();
	 
	wait 0.2;
	}
}

coin9()
{
coin9 = getEnt("coin_9","targetname");
coin9trig = getEnt("coin_9_trig","targetname");

	{
	coin9trig waittill("trigger", player);
	player playSound("coin");
	coin9 hide();
	coin9trig triggerOff();
	 
	wait 0.2;
	}
}

coin10()
{
coin10 = getEnt("coin_10","targetname");
coin10trig = getEnt("coin_10_trig","targetname");

	{
	coin10trig waittill("trigger", player);
	player playSound("coin");
	coin10 hide();
	coin10trig triggerOff();
	 
	wait 0.2;
	}
}

coin11()
{
coin11 = getEnt("coin_11","targetname");
coin11trig = getEnt("coin_11_trig","targetname");

	{
	coin11trig waittill("trigger", player);
	player playSound("coin");
	coin11 hide();
	coin11trig triggerOff();
	 
	wait 0.2;
	}
}

coin12()
{
coin12 = getEnt("coin_12","targetname");
coin12trig = getEnt("coin_12_trig","targetname");

	{
	coin12trig waittill("trigger", player);
	player playSound("coin");
	coin12 hide();
	coin12trig triggerOff();
	 
	wait 0.2;
	}
}

coin13()
{
coin13 = getEnt("coin_13","targetname");
coin13trig = getEnt("coin_13_trig","targetname");

	{
	coin13trig waittill("trigger", player);
	player playSound("coin");
	coin13 hide();
	coin13trig triggerOff();
	 
	wait 0.2;
	}
}

coin14()
{
coin14 = getEnt("coin_14","targetname");
coin14trig = getEnt("coin_14_trig","targetname");

	{
	coin14trig waittill("trigger", player);
	player playSound("coin");
	coin14 hide();
	coin14trig triggerOff();
	 
	wait 0.2;
	}
}

coin15()
{
coin15 = getEnt("coin_15","targetname");
coin15trig = getEnt("coin_15_trig","targetname");

	{
	coin15trig waittill("trigger", player);
	player playSound("coin");
	coin15 hide();
	coin15trig triggerOff();
	 
	wait 0.2;
	}
}

coin16()
{
coin16 = getEnt("coin_16","targetname");
coin16trig = getEnt("coin_16_trig","targetname");

	{
	coin16trig waittill("trigger", player);
	player playSound("coin");
	coin16 hide();
	coin16trig triggerOff();
	 
	wait 0.2;
	}
}

coin17()
{
coin17 = getEnt("coin_17","targetname");
coin17trig = getEnt("coin_17_trig","targetname");

	{
	coin17trig waittill("trigger", player);
	player playSound("coin");
	coin17 hide();
	coin17trig triggerOff();
	 
	wait 0.2;
	}
}

coin18()
{
coin18 = getEnt("coin_18","targetname");
coin18trig = getEnt("coin_18_trig","targetname");

	{
	coin18trig waittill("trigger", player);
	player playSound("coin");
	coin18 hide();
	coin18trig triggerOff();
	 
	wait 0.2;
	}
}

//COIN\\

trapmtn2()
{
mtn1 = getEnt("r_push3","targetname");
mtn1ori = getEnt("r_push3_ori","targetname");

mtn1ori enableLinkTo();
mtn1ori linkTo(mtn1);

	{
	mtn1 moveZ(-200, 3, 0.6, 0.6);
	wait 0.2;
	}
}

trapmaskass1()
{
maskas1hurt = getEnt("maskas1_hurt","targetname");
maskas1ori = getEnt("maskas1_ori","targetname");
maskas1ori_1 = getEnt("maskas1_ori_1","targetname");
maskas1ori_2 = getEnt("maskas1_ori_2","targetname");
maskas1 = getEnt("maskas1","targetname");

maskas1hurt enableLinkTo();
maskas1hurt linkTo(maskas1);
maskas1 enableLinkTo();
maskas1 linkTo(maskas1ori);

	{
	maskas1ori moveY(-250, 2, 0.5, 0.5);
	wait 3;
	maskas1ori moveY(250, 2, 0.5, 0.5);
	wait 3;
	}
}

trapmaskass2()
{
maskas2hurt = getEnt("maskas1_hurt","targetname");
maskas2ori = getEnt("maskas1_ori","targetname");
maskas2ori_1 = getEnt("maskas1_ori_1","targetname");
maskas2ori_2 = getEnt("maskas1_ori_2","targetname");
maskas2 = getEnt("maskas1","targetname");

maskas2hurt enableLinkTo();
maskas2hurt linkTo(maskas2);
maskas2 enableLinkTo();
maskas2 linkTo(maskas2ori);

maskas2ori rotateYaw(720, 5, 0.5, 0.5);

	{
	maskas2ori moveZ(250, 2, 0.5, 0.5);
	wait 3;
	maskas2ori moveZ(-250, 2, 0.5, 0.5);
	wait 3;
	}
}

traprandom()
{
rpush2 = getEnt("r_push2","targetname");

	{
	rpush2 moveZ(-100, 1, 0.2, 0.2);
	}
}

traprandom2()
{
	part1 = getentarray ("trap4_1" ,"targetname");
	part2 = getentarray ("trap4_2" ,"targetname");
	part3 = getentarray ("trap4_3" ,"targetname");
	part4 = getentarray ("trap4_4" ,"targetname");
	random = randomint(4);

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

		case 2:	
				part1[randomInt(part1.size)] notsolid();
				part3[randomInt(part3.size)] notsolid();	
                break;
				
		case 3:	
				part2[randomInt(part2.size)] notsolid();
				part4[randomInt(part4.size)] notsolid();				
				
		default: return;
	}
}

movingballsetup()
{
	thread movingballsrotate();
	thread movingball1();
	thread movingball2();
}

movingballsrotate() //By Trucker0009 / SuX Trucker <3
{
	mball1 = getEnt("movingball1", "targetname");
	mball2 = getEnt("movingball2", "targetname");
	while( 1 )
	{
		mball1 rotatepitch(360, 1.5);
		mball2 rotatepitch(360, 1.5);
		wait 1.5;
	}
}

movingball1() //By Trucker0009 / SuX Trucker <3
{
	ball4hurt = getEnt("ball4hurt", "targetname");
	mball1 = getEnt("movingball1", "targetname");
	fxorg3 = getEnt("fxorg3", "targetname");
	ballsorigin = getEnt("ballsorigin", "targetname");
	org1 = getEnt("path1", "targetname");
	org2 = getEnt("path2", "targetname");
	org3 = getEnt("path3", "targetname");
	org4 = getEnt("path4", "targetname");
	org5 = getEnt("path5", "targetname");
	bpath1 = getEnt("blue_path1", "targetname");
	bpath2 = getEnt("blue_path2", "targetname");
	bpath3 = getEnt("blue_path3", "targetname");
	bpath4 = getEnt("blue_path4", "targetname");
	bpath5 = getEnt("blue_path5", "targetname");
	bpath6 = getEnt("blue_path6", "targetname");
	bpath7 = getEnt("blue_path7", "targetname");
	dist1 = distance(org1.origin, org2.origin);
	dist2 = distance(org2.origin, bpath1.origin);
	dist3 = distance(bpath1.origin, bpath2.origin);
	dist4 = distance(bpath2.origin, bpath3.origin);
	dist5 = distance(bpath3.origin, bpath4.origin);
	dist6 = distance(bpath4.origin, bpath5.origin);
	dist7 = distance(bpath5.origin, bpath6.origin);
	dist8 = distance(bpath6.origin, bpath7.origin);
	dist9 = distance(bpath7.origin, org3.origin);
	dist10 = distance(org3.origin, org4.origin);
	dist11 = distance(org4.origin, org5.origin);
	dist12 = distance(ballsorigin.origin, org1.origin);
	ball4hurt enableLinkTo();
	ball4hurt linkTo(mball1);
	fxorg3 enableLinkTo();
	fxorg3 linkTo(mball1);
	level._effect[ "explosmall" ] = loadfx( "explosions/custom_explo_small" );
	
	while( 1 )
	{
		mball1 moveto(org1.origin, dist12/300);
		wait dist12/300;
		mball1 moveto(org2.origin, dist1/800, dist1/800);
		mball1 waittill("movedone");
		mball1 rotateyaw(bpath1.angles-org2.angles, 0.01);
		mball1 moveto(bpath1.origin, dist2/300);
		wait dist2/300;
		mball1 rotateyaw(bpath2.angles-bpath1.angles, 0.01);
		mball1 moveto(bpath2.origin, dist3/300);
		wait dist3/300;
		mball1 rotateyaw(bpath3.angles-bpath2.angles, 0.01);
		mball1 moveto(bpath3.origin, dist4/300);
		wait dist4/300;
		mball1 rotateyaw(bpath4.angles-bpath3.angles, 0.01);
		mball1 moveto(bpath4.origin, dist5/300);
		wait dist5/300;
		mball1 rotateyaw(bpath5.angles-bpath4.angles, 0.01);
		mball1 moveto(bpath5.origin, dist6/300);
		wait dist6/300;
		mball1 rotateyaw(bpath6.angles-bpath5.angles, 0.01);
		mball1 moveto(bpath6.origin, dist7/300);
		wait dist7/300;
		mball1 rotateyaw(bpath7.angles-bpath6.angles, 0.01);
		mball1 moveto(bpath7.origin, dist8/300);
		wait dist8/300;
		mball1 rotateyaw(org3.angles-bpath7.angles, 0.01);
		mball1 moveto(org3.origin, dist9/800, dist9/800);
		mball1 waittill("movedone");
		mball1 rotateyaw(org4.angles-org3.angles, 0.01);
		mball1 moveto(org4.origin, dist10/300);
		wait dist10/300;
		mball1 rotateyaw(org5.angles-org4.angles, 0.01);
		mball1 moveto(org5.origin, dist11/800, dist11/800);
		mball1 waittill("movedone");
		playFx(level._effect[ "explosmall" ],fxorg3.origin);
		fxorg3 PlaySound("grenade_explode_metal");
		wait 0.1;
		mball1 hide();
		mball1 moveto(ballsorigin.origin, 0.1);
		wait 3;
		mball1 show();
		wait 0.1;
	}
}
		
movingball2() //By Trucker0009 / SuX Trucker <3
{
	ball5hurt = getEnt("ball5hurt","targetname");
	mball2 = getEnt("movingball2", "targetname");
	fxorg4 = getEnt("fxorg4", "targetname");
	ballsorigin = getEnt("ballsorigin", "targetname");
	org1 = getEnt("path1", "targetname");
	org2 = getEnt("path2", "targetname");
	org3 = getEnt("path3", "targetname");
	org4 = getEnt("path4", "targetname");
	org5 = getEnt("path5", "targetname");
	rpath1 = getEnt("red_path1", "targetname");
	rpath2 = getEnt("red_path2", "targetname");
	rpath3 = getEnt("red_path3", "targetname");
	rpath4 = getEnt("red_path4", "targetname");
	rpath5 = getEnt("red_path5", "targetname");
	rpath6 = getEnt("red_path6", "targetname");
	rpath7 = getEnt("red_path7", "targetname");
	rpath8 = getEnt("red_path8", "targetname");
	rpath9 = getEnt("red_path9", "targetname");
	dist1 = distance(org1.origin, org2.origin);
	dist2 = distance(org2.origin, rpath1.origin);
	dist3 = distance(rpath1.origin, rpath2.origin);
	dist4 = distance(rpath2.origin, rpath3.origin);
	dist5 = distance(rpath3.origin, rpath4.origin);
	dist6 = distance(rpath4.origin, rpath5.origin);
	dist7 = distance(rpath5.origin, rpath6.origin);
	dist8 = distance(rpath6.origin, rpath7.origin);
	dist9 = distance(rpath7.origin, rpath8.origin);
	dist10 = distance(rpath8.origin, rpath9.origin);
	dist11 = distance(rpath9.origin, org3.origin);
	dist13 = distance(org3.origin, org4.origin);
	dist14 = distance(org4.origin, org5.origin);
	dist12 = distance(ballsorigin.origin, org1.origin);
	ball5hurt enableLinkTo();
	ball5hurt linkTo(mball2);
	fxorg4 enableLinkTo();
	fxorg4 linkTo(mball2);
	level._effect[ "explosmall" ] = loadfx( "explosions/custom_explo_small" );
	
	while( 1 )
	{
		mball2 moveto(org1.origin, dist12/300);
		wait dist12/300;
		mball2 moveto(org2.origin, dist1/800, dist1/800);
		mball2 waittill("movedone");
		mball2 moveto(rpath1.origin, dist2/300);
		wait dist2/300;
		mball2 moveto(rpath2.origin, dist3/300);
		wait dist3/300;
		mball2 moveto(rpath3.origin, dist4/800);
		mball2 waittill("movedone");
		mball2 moveto(rpath4.origin, dist5/300);
		wait dist5/300;
		mball2 moveto(rpath5.origin, dist6/300);
		wait dist6/300;
		mball2 moveto(rpath6.origin, dist7/300);
		wait dist7/300;
		mball2 moveto(rpath7.origin, dist8/300);
		wait dist8/300;
		mball2 moveto(rpath8.origin, dist9/300);
		wait dist9/300;
		mball2 moveto(rpath9.origin, dist10/300);
		wait dist10/300;
		mball2 moveto(org3.origin, dist11/300);
		wait dist11/300;
		mball2 moveto(org4.origin, dist13/300);
		wait dist13/300;
		mball2 moveto(org5.origin, dist14/800, dist14/800);
		mball2 waittill("movedone");
		playFx(level._effect[ "explosmall" ],fxorg4.origin);
		fxorg4 PlaySound("grenade_explode_metal");
		wait 0.1;
		mball2 hide();
		mball2 moveto(ballsorigin.origin, 0.1);
		wait 3;
		mball2 show();
		wait 0.1;
	}
}

ballstrapsetup()
{
	thread ballsrotate();
	thread ball1move();
	thread ball2move();
	thread ball3move();
}

ballsrotate() //By Trucker0009 / SuX Trucker <3
{
	ball1 = getEnt("ball1", "targetname");
	ball2 = getEnt("ball2", "targetname");
	ball3 = getEnt("ball3", "targetname");
	while(1)
	{
		ball1 rotatepitch(-360, 1.5, 0.7, 0.3);
		ball3 rotatepitch(-360, 1.5, 0.7, 0.3);
		ball2 rotatepitch(360, 1.5, 0.7, 0.3);
		wait 1.5;
		ball1 rotatepitch(360, 1.5, 0.7, 0.3);
		ball3 rotatepitch(360, 1.5, 0.7, 0.3);
		ball2 rotatepitch(-360, 1.5, 0.7, 0.3);
		wait 1.5;
	}
}
	
ball1move() //By Trucker0009 / SuX Trucker <3
{
	ball1 = getEnt("ball1", "targetname");
	ball1hurt = getEnt("ball1hurt", "targetname");
	ball1_org4 = getEnt("ball1_org4", "targetname");
	ball1_org1 = getEnt("ball1_org1", "targetname");
	ball1_org2 = getEnt("ball1_org2", "targetname");
	ball1_org3 = getEnt("ball1_org3", "targetname");
	ball1hurt enableLinkTo();
	ball1hurt linkto(ball1);
	while( 1 )
	{
	ball1 moveto(ball1_org2.origin, 0.5);
	wait 0.5;
	ball1 moveto(ball1_org3.origin, 0.5);
	wait 0.5;
	ball1 moveto(ball1_org4.origin, 0.5);
	wait 0.5;
	ball1 moveto(ball1_org3.origin, 0.5);
	wait 0.5;
	ball1 moveto(ball1_org2.origin, 0.5);
	wait 0.5;
	ball1 moveto(ball1_org1.origin, 0.5);
	wait 0.5;
	}
}

ball2move() //By Trucker0009 / SuX Trucker <3
{
	ball2 = getEnt("ball2", "targetname");
	ball2hurt = getEnt("ball2hurt", "targetname");
	ball2_org4 = getEnt("ball2_org4", "targetname");
	ball2_org1 = getEnt("ball2_org1", "targetname");
	ball2_org2 = getEnt("ball2_org2", "targetname");
	ball2_org3 = getEnt("ball2_org3", "targetname");
	ball2hurt enableLinkTo();
	ball2hurt linkto(ball2);
	while( 1 )
	{
	ball2 moveto(ball2_org2.origin, 0.5);
	wait 0.5;
	ball2 moveto(ball2_org3.origin, 0.5);
	wait 0.5;
	ball2 moveto(ball2_org4.origin, 0.5);
	wait 0.5;
	ball2 moveto(ball2_org3.origin, 0.5);
	wait 0.5;
	ball2 moveto(ball2_org2.origin, 0.5);
	wait 0.5;
	ball2 moveto(ball2_org1.origin, 0.5);
	wait 0.5;
	}
}

ball3move() //By Trucker0009 / SuX Trucker <3
{
	ball3 = getEnt("ball3", "targetname");
	ball3hurt = getEnt("ball3hurt", "targetname");
	ball3_org4 = getEnt("ball3_org4", "targetname");
	ball3_org1 = getEnt("ball3_org1", "targetname");
	ball3_org2 = getEnt("ball3_org2", "targetname");
	ball3_org3 = getEnt("ball3_org3", "targetname");
	ball3hurt enableLinkTo();
	ball3hurt linkto(ball3);
	while( 1 )
	{
	ball3 moveto(ball3_org2.origin, 0.5);
	wait 0.5;
	ball3 moveto(ball3_org3.origin, 0.5);
	wait 0.5;
	ball3 moveto(ball3_org4.origin, 0.5);
	wait 0.5;
	ball3 moveto(ball3_org3.origin, 0.5);
	wait 0.5;
	ball3 moveto(ball3_org2.origin, 0.5);
	wait 0.5;
	ball3 moveto(ball3_org1.origin, 0.5);
	wait 0.5;
	}
}

trappusher()
{
pusher1 = getEntArray("pusher1","targetname");
pusher2 = getEntArray("pusher2","targetname");
pusher3 = getEntArray("pusher3","targetname");
pusher4 = getEntArray("pusher4","targetname");
pusher5 = getEntArray("pusher5","targetname");

wait 1;

	while(1)
	{
	random = randomint(5);

		switch(random)
		{
			case 0:
					wait 0.5;
					pusher1[randomInt(pusher1.size)] moveY(200, 0.5, 0.2, 0.2);
					pusher2[randomInt(pusher2.size)] moveY(200, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher1[randomInt(pusher1.size)] moveY(-200, 0.5, 0.2, 0.2);
					pusher2[randomInt(pusher2.size)] moveY(-200, 0.5, 0.2, 0.2);
					break;
					
			case 1:
					wait 0.5;
					pusher2[randomInt(pusher2.size)] moveY(200, 0.5, 0.2, 0.2);
					pusher4[randomInt(pusher4.size)] moveY(200, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher2[randomInt(pusher2.size)] moveY(-200, 0.5, 0.2, 0.2);
					pusher4[randomInt(pusher4.size)] moveY(-200, 0.5, 0.2, 0.2);
					break;				
	
			case 2:
					wait 0.5;
					pusher3[randomInt(pusher3.size)] moveY(200, 0.5, 0.2, 0.2);
					pusher1[randomInt(pusher1.size)] moveY(200, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher3[randomInt(pusher3.size)] moveY(-200, 0.5, 0.2, 0.2);
					pusher1[randomInt(pusher1.size)] moveY(-200, 0.5, 0.2, 0.2);
					break;
					
			case 3:
					wait 0.5;
					pusher4[randomInt(pusher4.size)] moveY(200, 0.5, 0.2, 0.2);
					pusher5[randomInt(pusher5.size)] moveY(200, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher4[randomInt(pusher4.size)] moveY(-200, 0.5, 0.2, 0.2);
					pusher5[randomInt(pusher5.size)] moveY(-200, 0.5, 0.2, 0.2);
					break;
					
			case 4:
					wait 0.5;
					pusher5[randomInt(pusher5.size)] moveY(200, 0.5, 0.2, 0.2);
					pusher3[randomInt(pusher3.size)] moveY(200, 0.5, 0.2, 0.2);
					wait 0.6;
					pusher5[randomInt(pusher5.size)] moveY(-200, 0.5, 0.2, 0.2);
					pusher3[randomInt(pusher3.size)] moveY(-200, 0.5, 0.2, 0.2);
					break;
		}
	wait 0.2;
	}
}

mont1down()
{
mont1d = getEnt("mont1_down","targetname");
explo2 = getEnt("explo_fx2","targetname");
smoke1 = getEnt("smoke_fx1","targetname");
smoke2 = getEnt("smoke_fx2","targetname");
smoke3 = getEnt("smoke_fx3","targetname");
smoke4 = getEnt("smoke_fx4","targetname");
coin10 = getEnt("coin_10","targetname");
coin11 = getEnt("coin_11","targetname");
coin12 = getEnt("coin_12","targetname");
coin13 = getEnt("coin_13","targetname");
coin14 = getEnt("coin_14","targetname");
coin10trig = getEnt("coin_10_trig","targetname");
coin11trig = getEnt("coin_11_trig","targetname");
coin12trig = getEnt("coin_12_trig","targetname");
coin13trig = getEnt("coin_13_trig","targetname");
coin14trig = getEnt("coin_14_trig","targetname");
level._effect[ "explolarge" ] = loadfx( "explosions/custom_explo_large" );
level._effect[ "smokelarge" ] = loadfx( "smoke/custom_smoke_large" );

	{
	mont1d moveZ(-500, 5, 2, 0.2);
	playFx(level._effect[ "explolarge" ],explo2.origin);
	wait 0.1;
	playFx(level._effect[ "explolarge" ],explo2.origin);
	explo2 PlaySound("exp_detpack_cement1");
	coin10 hide();
	coin11 hide();
	coin12 hide();
	coin13 hide();
	coin14 hide();
	coin10trig triggerOff();
	coin11trig triggerOff();
	coin12trig triggerOff();
	coin13trig triggerOff();
	coin14trig triggerOff();
	playFx(level._effect[ "smokelarge" ],smoke1.origin);
	wait 0.1;
	playFx(level._effect[ "smokelarge" ],smoke2.origin);
	wait 0.1;
	playFx(level._effect[ "smokelarge" ],smoke3.origin);
	wait 0.5;
	playFx(level._effect[ "smokelarge" ],smoke4.origin);
	wait 0.5;
	}
}

door1()
{
door1trig = getEnt("door1_trig","targetname");
door1 = getEnt("door1","targetname");
door1ori = getEnt("door1_ori","targetname");

//door1 enablelinkto();
door1 linkto(door1ori);

	{
	door1trig waittill("trigger",player);
	door1ori rotateYaw(75, 3, 0.5, 0.5);
	door1 playSound("doorwood");
	wait 0.5;
	}
}

bigdoor1()
{
bigd1 = getEnt("bigdoor1","targetname");
bigd1ori = getEnt("bigdoor1_ori","targetname");
bigd2 = getEnt("bigdoor2","targetname");
bigd2ori = getEnt("bigdoor2_ori","targetname");

// bigd1 enablelinkto();
bigd1 linkto(bigd1ori);
// bigd2 enablelinkto();
bigd2 linkto(bigd2ori);
wait 0.5;

	{
	bigd1ori rotateYaw(65, 3, 0.5, 0.5);
	bigd2ori rotateYaw(-65, 3, 0.5, 0.5);
	wait 0.5;
	}
}

bridge1()
{
bridge1fori = getEnt("bridgex1_ori","targetname");
bridge1f = getEnt("bridgex1","targetname");

bridge1f enablelinkto();
bridge1f linkto(bridge1fori);
wait 1;

	{
	wait 0.5;
	bridge1fori rotatePitch(75, 4, 1, 0.5);
	wait 4;
	}
}

bridgeleft()
{
bleft1 = getEnt("bridgeleft1","targetname");
bleft1_ori = getEnt("bridgeleft1_ori","targetname");
bleft2 = getEnt("bridgeleft2","targetname");
bleft2_ori = getEnt("bridgeleft2_ori","targetname");

bleft1 enablelinkto();
bleft1 linkto(bleft1_ori);
bleft2 enablelinkto();
bleft2 linkto(bleft2_ori);
wait 0.5;

	{
	bleft1_ori rotatePitch(40, 3, 1, 0.5);
	bleft2_ori rotatePitch(40, 2, 1, 0.5);
	wait 0.5;
	}
}

birdgeright()
{
bright1 = getEnt("bridgeright1","targetname");
bright1_ori = getEnt("bridgeright1_ori","targetname");
bright2 = getEnt("bridgeright2","targetname");
bright2_ori = getEnt("bridgeright2_ori","targetname");

bright1 enablelinkto();
bright1 linkto(bright1_ori);
bright2 enablelinkto();
bright2 linkto(bright2_ori);
wait 0.5;

	{
	bright1_ori rotatePitch(40, 2, 1, 0.5);
	bright2_ori rotatePitch(40, 3, 1, 0.5);
	wait 0.5;
	}
}

bridgeexplo()
{
explo1 = getEnt("explo_fx1","targetname");
level._effect[ "explolarge" ] = loadfx( "explosions/custom_explo_large" );
wait 1;

	{
	playFx(level._effect[ "explolarge" ],explo1.origin);
	wait 0.1;
	explo1 PlaySound("exp_detpack_cement1");
	playFx(level._effect[ "explolarge" ],explo1.origin);
	wait 0.1;
	playFx(level._effect[ "explolarge" ],explo1.origin);
	wait 0.1;
	playFx(level._effect[ "explolarge" ],explo1.origin);
	wait 0.5;
	}
}

guidchecking()
{
	wait 5.1;
	thread guidcheckgod();
	thread guidcheckvip();
	wait 0.2;
}

messages()
{
wait 10;
iprintlnBold("^5Welcome ^7to ^5SuX ^7Lolz ^5M^7ap ^5:^7]");
wait 1;

while(1)
	{
	
		iPrintLn("^1Report any bugs");
		wait 4;
		iPrintLn("^1 xFire: ^7alex1528");
		wait 1;
		iPrintLn("^1Steam: ^7iswenzz1528 / SuX Lolz :]");
		wait 4;
		iPrintLn("youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw");
		wait 4;
		iPrintLn("^1RIP ^2Raid-Gaming. xD");
		wait 4;
		iPrintLn("^3Map Made By: ^5SuX ^7Lolz :]");
		wait 4;
		iPrintLn("^5I accept any donation @ Paypal : ^7suxlolz@outlook.fr");
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
		user TakeAllWeapons();
		user setModel("shadow");  //Model Here
		user GiveWeapon( "deserteaglegold_mp" );
		user GiveMaxAmmo( "deserteaglegold_mp" );
		user switchtoweapon("deserteaglegold_mp");
		user GiveWeapon( "m40a3_mp" );
		user GiveMaxAmmo( "m40a3_mp" );
		iPrintLnBold(user.name + " Map ^3Creator ^7is ^2Connected ^7!!");
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
god1 = "2b496dc24a263701f20c7f209c8d844a"; //SuX PirE
god2 = "d28e32e7f1be0a86104b30aba26b44b3"; //SuX Trucker //Trucker0009
god3 = "41f3140aa66c876f11b05456"; //Sheep Wizard
sanictrig = getent("sanic_check_2","targetname");
for(;;)
	{
		sanictrig waittill ("trigger",user);
		tempGuid = user getGUID();
		if((tempGuid == god1) || (tempGuid == god2) || (tempGuid == god3))
		{
		user detachAll();
		user TakeAllWeapons();
		user setModel("shadow");  //Model Here
		user GiveWeapon( "deserteaglegold_mp" );
		user GiveMaxAmmo( "deserteaglegold_mp" );
		user switchtoweapon("deserteaglegold_mp");
		user GiveWeapon( "m40a3_mp" );
		user GiveMaxAmmo( "m40a3_mp" );
		iPrintLnBold ("^3VIP ^7is ^2Connected");
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
thread drawInformation( 800, 0.8, 1, "^5mp_dr_sm64" );
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
 
		while( 1 )
        {
				self credit_roll( "^3Mapped ^2& ^3scripted by ^5SuX ^7Lolz :]", 5 );
                self credit_roll( "^3Thanks ^7to ^2SuX ^7Stxly ^3& ^2Sheep Wizard ^3& ^2SuX ^7Trucker ^3for ^7helping ^2me.", 5 );
				self credit_roll( "^3Steam: ^7SuX Lolz ", 4 );
				self credit_roll( "^5I accept any donation ^7@ ^5Paypal : ^7suxlolz@outlook.fr", 5 );
				self credit_roll( "^7www.youtube^3.com/^7channel^3/^7UC1vxOXBzEF7W4g7TRU0C1rw", 5 );
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

lift() //Open the door + Start Button
{

lift=getent("lift","targetname");
lift_button=getent("startbutton","targetname");
lift_trigger=getent("lift_trigger","targetname");

	{
	lift_trigger waittill ("trigger");
	iprintlnbold("^8Start door opened :]");
	lift_button movey (-3,5);
	wait 5;
	}
		{
		lift movez (241,4,1,1);
		wait 2;
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
		// self playSound("splash");
		// playFx ( level._effect[ "watersplash" ], self.origin );
		// playFx ( level._effect[ "waterbodydump" ], self.origin );

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
		iPrintLn( self.name, deathmethod1);
		self playSound("mdrown");
		if (randb == 1)
		iPrintLn( self.name, deathmethod2);
		self playSound("mdrown");
		if (randb == 2)
		iPrintLn( self.name, deathmethod3);
		self playSound("mdrown");
		if (randb == 3)
		iPrintLn( self.name, deathmethod4);
		self playSound("mdrown");
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

end() //First D:
{
triggerend = GetEnt( "end", "targetname" );

	{
	triggerend waittill ("trigger", user);
	iprintlnbold( "^7 " + user.name + " ^5Finished First^7!!");
	wait 0.1;
	}
}

games() //Select Rooms
{
level.games_trig = getEnt( "minigames", "targetname");
games = getEnt( "minigames_ori", "targetname" );

while(1)
{
level.games_trig waittill( "trigger", player );
if( !isDefined( level.games_trig ) )
return;

player SetPlayerAngles( games.angles );
player setOrigin( games.origin );
iPrintlnBold( " ^5" + player.name + " ^7has ^5entered ^7the ^5game ^7selection !^5!^7!" );
player TakeAllWeapons();
player antiglitch();


while( isAlive( player ) && isDefined( player ) )
if( isDefined( level.activ ) && isAlive( level.activ ) )
wait 1;
}
}
antiglitch() //ng1
{ 
self common_scripts\utility::waittill_any("death","disconnect");
iPrintlnBold("^2"+self.name+" ^7is ^2dead"); 
iPrintlnBold("^3Selection ^7Room ^3is ^3now ^7open^3!!"); 
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

sniperroom() //Sniper Room
{
sniper = getent("sniper_trig","targetname");
jumper = getent("origin_jumper_snip","targetname");
acti = getent("origin_acti_snip","targetname");
for(;;)
{
	sniper waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	player thread songroom();
	activator thread songroom();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("m40a3_mp");
	activator giveweapon("m40a3_mp");
	player giveweapon("remington700_mp");
	activator giveweapon("remington700_mp");
	thread createhud(player.name + " ^3selected ^7snipah ^2war!");
	wait 5;
	player iprintlnbold("^5FIGHT ^7!!!");
	activator iprintlnbold("^5FIGHT ^7!!!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("m40a3_mp");
	activator switchtoweapon("m40a3_mp");
	player givemaxammo("m40a3_mp");
	activator givemaxammo("m40a3_mp");
	}
}

sniperjumperfail() //if jumper fall after
{
	sniperjumperfail = getEnt("trigger_jumper_fail_sniper", "targetname");
	tpsniperjumperfail = getEnt("origin_jumper_snip", "targetname");
	
	for (;;)
	{
		sniperjumperfail waittill("trigger", player);
		player setOrigin(tpsniperjumperfail.origin);
		player setPlayerAngles(tpsniperjumperfail.angles);
	}
}

weaponsroom() //weapons room :)
{
weapons = getent("weapons_trig","targetname");
jumper = getent("origin_jumper_weapons","targetname");
acti = getent("origin_acti_weapons","targetname");
for(;;)
{
	weapons waittill("trigger", player);
	player thread waitdead();
	thread createhud(player.name + " ^3Selected ^7Weapons ^2Way ^7!^5!^7!");
	activator = GetActivator();
	player thread songroom();
	activator thread songroom();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	wait 5;
	IPrintLnbold("^2Fight!!!.");
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
		weapon = "ak74u_mp";
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
	player giveweapon("knife_mp");
	activator giveweapon("knife_mp");
	player giveweapon(weapon);
	activator giveweapon(weapon);
	activator givemaxammo(weapon);
	player givemaxammo(weapon);
	wait .1;
	player switchtoweapon(weapon);
	activator switchtoweapon(weapon);
	player freezeControls(false);
	activator freezeControls(false);
	}
}

weaponsjumperfail() //if jumper fall
{
	weaponsjumperfail = getEnt("trigger_jumper_fail_weapons", "targetname");
	tpweaponsjumperfail = getEnt("origin_jumper_weapons", "targetname");
	
	for (;;)
	{
		weaponsjumperfail waittill("trigger", player);
		player setOrigin(tpweaponsjumperfail.origin);
		player setPlayerAngles(tpweaponsjumperfail.angles);
	}
}

bounceroom() //bounce room :p
{
bounce = getent("bounce_trig","targetname");
jumper = getent("origin_jumper_bounce","targetname");
acti = getent("origin_acti_bounce","targetname");
for(;;)
{
	bounce waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	player thread songroom();
	activator thread songroom();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("knife_mp");
	player giveweapon("knife_mp");
	thread createhud(player.name + " ^2Selected ^7bounce ^3Room ^7:]");
	wait 5;
	player iprintlnbold("GO^3!^7!^3!");
	activator iprintlnbold("GO^3!^7!^3!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
	}
}

givesniper() //bounce room s
{
givesnip = getEnt("givesnip_trig","targetname");

	for (;;)
	{
		givesnip waittill("trigger", player);
		player takeallweapons();
		wait 0.1;
		player giveweapon("m40a3_mp");
		player giveweapon("deserteaglegold_mp");
		player switchtoweapon("m40a3_mp");
		player givemaxammo("m40a3_mp");
		player givemaxammo("deserteaglegold_mp");
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

runroom() //Speedrun room
{
run = getent("run_trig","targetname");
jumper = getent("origin_jumper_run","targetname");
acti = getent("origin_acti_run","targetname");
for(;;)
{
	run waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	player thread songroom();
	activator thread songroom();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("deserteaglegold_mp");
	player giveweapon("deserteaglegold_mp");
	thread createhud(player.name + " ^2Selected ^3spe^7ed ^2Ru^7n Way !^5!^7!");
	wait 5;
	player iprintlnbold("GO^3!^7!^3!");
	activator iprintlnbold("GO^3!^7!^3!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("deserteaglegold_mp");
	activator switchtoweapon("deserteaglegold_mp");
	}
}

//RUNWAY\\

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
	wait 0.2;
	activator setOrigin(tpactirun4.origin);
	activator setPlayerAngles(tpactirun4.angles);
	player setOrigin(tpjumperrun4.origin);
	player setPlayerAngles(tpjumperrun4.angles);
	wait 0.2;
	activator giveweapon("remington700_mp");
	activator givemaxammo("remington700_mp");
	activator switchtoweapon("remington700_mp");
	player freezeControls(true);
	player takeallweapons();
	wait 0.2;
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
	wait 0.2;
	player setOrigin(tpjumperrun4.origin);
	player setPlayerAngles(tpjumperrun4.angles);
	activator setOrigin(tpactirun4.origin);
	activator setPlayerAngles(tpactirun4.angles);
	wait 0.2;
	player giveweapon("remington700_mp");
	player givemaxammo("remington700_mp");
	player switchtoweapon("remington700_mp");
	activator freezeControls(true);
	activator takeallweapons();
	wait 0.2;
}
}

//RUNWAY\\

kniferoom() //Knife room lel
{
knife = getent("knife_trig","targetname");
jumper = getent("origin_jumper_knife","targetname");
acti = getent("origin_acti_knife","targetname");
for(;;)
{
	knife waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	player thread songroom();
	activator thread songroom();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("tomahawk_mp");
	player giveweapon("tomahawk_mp");
	thread createhud(player.name + " ^2Selected ^7Knife ^3room.");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("tomahawk_mp");
	activator switchtoweapon("tomahawk_mp");
	}
}

//END\\

