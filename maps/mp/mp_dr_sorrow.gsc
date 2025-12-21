#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include braxi\_common;

main()
{
    maps\mp\_load::main();

    level.fire = LoadFx("fire/sorrow_fire");
    level.snow = LoadFx("weather/snow");

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar("r_specularcolorscale", "1");
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);
    setExpFog(200, 2200, 0.472, 0.551, 0.552, 1.0);

    precacheModel("santahat");
    precacheModel("santahat2");
    precacheModel("bugsbunny");
    precacheModel("skulltrooper");


	addTriggerToList("trig_trap1");
    addTriggerToList("trig_trap2");
    addTriggerToList("trig_trap3");
    addTriggerToList("trig_trap4");
    addTriggerToList("trig_trap5");
    addTriggerToList("trig_trap6");
    addTriggerToList("trig_trap7");
    addTriggerToList("trig_trap8");

    thread sr\api\_map::createSpawn((32,584,76), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("^3Secret Way;^5Acti Secret");

    thread sr_jumper_sec_enter();
    thread sr_acti_sec_enter();

    //thread death_sound();
    //thread messages_iprintln();

    //thread fx_knife_room();

    thread xmas_ver_setup();

    thread start_gates();
    //thread mapper_stuff();

    //thread welcomemessage();
    //thread sorrow_music();

    ///Secret Room Stuff///
    //thread acti_secret_enter();
    thread acti_secret_finish();
    thread acti_secret_fail();
    //thread secret_enter();
    thread secret_finish();

    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread trap6();
    //thread trap7();
    //thread trap8();

    //thread selectionroom();
    //thread sniper_room();
    //thread sniper_fail();
	//thread bounce_room();
    //thread bounce_jumper_fail();
    //thread bounce_activator_fail();
    //thread bounce_weapon();
	//thread knife_room();

    //level waittill("round_started");

    //thread xmas_ver(); ///Turns on xmas version///------unthread it to disable xmas version------///

}

sr_jumper_sec_enter()
{
	trig = spawn("trigger_radius",(160.875, 584.031, 16.125), 0, 50, 120);
	trig.radius = 50;
	ori_t = getEnt("orig_secret_entrance","targetname");

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

sr_acti_sec_enter()
{
	trig = spawn("trigger_radius",(-94.9848, 583.911, 16.125), 0, 50, 120);
	trig.radius = 50;
	ori_t = getEnt("orig_acti_sec_enter","targetname");

	thread sr\api\_map::createTriggerFx(trig, "cyan");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_1");

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}

//Start scripts///
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
    acti = undefined;

    for(i = 0;i < players.size;i++)
    {
        if( isdefined( players[i] ) && isplayer( players[i] ) && isalive( players[i] ) && players[i].pers["team"] == "axis"    )
            acti = players[i];
    }

    if(isDefined(acti))
        return acti;
    else
        return undefined;
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread dddasdasddd(time);
}
dddasdasddd(time) {
	wait time;
	self freezecontrols(false);
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
    hud.glowcolor = (0.27, 0.72, 0.67);

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
    level.hud_fight setText("^5" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^5" + jumper + " ^7VS^7 " + "^5" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}
draw_Information( start_offset, movetime, mult, text )
{
    start_offset = mult;
    hud = custom_hud( "center", start_offset, 15 );
    hud setText( text );
    hud moveOverTime( movetime );
    hud fadeovertime( movetime/2 );
    hud.alpha = 1;
    hud.x = 100;
    wait( movetime );
    hud moveOverTime( 5 );
    hud.x = -100;
    wait 5;
    hud moveOverTime( movetime );
    hud.x = start_offset -1;

    wait movetime;
    hud destroy();
}

custom_hud(align, x_off, y_off)
{
    hud = newClientHudElem(self);
    hud.foreground = true;
    hud.x = x_off;
    hud.y = y_off;
    hud.alignX = align;
    hud.alignY = "middle";
    hud.horzAlign = align;
    hud.vertAlign = "middle";
    hud.fontScale = 3;
    hud.alpha = 0;
    hud.color = (0.27, 0.72, 0.67);
    hud.font = "objective";
    hud.glowColor = (0.72, 0.72, 0.72);
    hud.glowAlpha = 0.2;
    hud.hidewheninmenu = true;
    hud.sort = 10;

    return hud;
}
messages_iprintln()
{
   level waittill("round_started");
   wait 2;
   for(;;)
{
   wait 10;
 x = randomint(4);
   if (x==0)
{
   iPrintln(">> ^5Mapped ^7and ^5Scripted ^7by ^5death ^7, ^5Map Route ^7by ^5Krista26<3^7!");
}

   if (x==1)
{
   iPrintln(">> ^5Feel free ^7to ^5report ^7any ^5bugs ^7on my ^5Discord ^7: ^5death01_ !");
}

   if (x==2)
{
   iPrintLn(">> ^7Thanks to ^5Clippy ^7and ^5VC'Legend ^7for ^5helping me ^7with the ^5bugs ^7!");
}

   if (x==3)
{
   iPrintLn(">> ^5Map ^7has ^5 1 Secret ^7and ^5 1 Acti Secret Room ^7with ^5RTD ^7 on ^5spawn ^7!");
}

}
}

death_sound()
{
    triggers = getEntArray("trigger_hurt", "classname");
    for (i = 0; i < triggers.size; i++)
    {

    triggers[i] waittill("trigger", player);

    wait 0.1;
    player PlayLocalSound("sorrow_death_sound");
    //player iprintlnBOld("^1OOF YOU DIED!");
   }

}
///Fx's looping///
fx_knife_room()
{
    fx_fire = getEntArray("fx_sorrow_vase_fire", "targetname");


    level waittill("round_started");

    PlayFX(level.fire, fx_fire[0].origin);
    PlayFX(level.fire, fx_fire[1].origin);
    PlayFX(level.fire, fx_fire[2].origin);
    PlayFX(level.fire, fx_fire[3].origin);

}

fx_xmas_snow()
{
    fx_snow = getEntArray("xmas_fx_snow", "targetname");

    for(i=0;i<fx_snow.size;i++)
        PlayFX(level.snow, fx_snow[i].origin);
}

start_gates()
{
    gate_1 = getent("gate_left","targetname");
    gate_2 = getent("gate_right","targetname");
    trig = getent("trig_gates","targetname");

    wait 0.1;

    //thread start_gate_sound();
    //thread xmas_ver(); ///Turns on xmas version///

    gate_1 rotateYaw(65, 0.1);
    gate_2 rotateYaw(-65, 0.1);
}
start_gate_sound()
{
    gate_sound = getentArray ("sorrow_gates_sound","targetname");

    {
    wait 0.01;

    gate_sound[0] playsound ("sorrow_gates_opening");
    gate_sound[1] playsound ("sorrow_gates_opening");


    }
}

xmas_ver_setup()
{
    xmas_model_1 = getent ("xmas_north", "targetname");
    xmas_model_2 = getent ("xmas_north_2", "targetname");
    xmas_model_3 = getent ("xmas_lamps", "targetname");
    xmas_model_4 = getent ("xmas_tree", "targetname");
    xmas_model_5 = getent ("xmas_star", "targetname");
    xmas_model_6 = getent ("xmas_candy", "targetname");
    xmas_model_7 = getent ("xmas_candy_2", "targetname");
    xmas_model_8 = getent ("xmas_snowman", "targetname");
    xmas_model_9 = getent ("xmas_santa", "targetname");
    xmas_model_10 = getent ("xmas_star_2", "targetname");
    xmas_model_11 = getent ("xmas_star_3", "targetname");
    xmas_model_12 = getent ("xmas_star_4", "targetname");
    xmas_model_13 = getent ("xmas_star_5", "targetname");
    xmas_model_14 = getent ("xmas_star_6", "targetname");
    xmas_model_15 = getent ("xmas_star_7", "targetname");
    xmas_model_16 = getent ("xmas_gift_1", "targetname");
    xmas_model_17 = getent ("xmas_gift_2", "targetname");
    xmas_model_18 = getent ("xmas_gift_3", "targetname");
    xmas_model_19 = getent ("xmas_gift_4", "targetname");
    xmas_model_20 = getent ("xmas_gift_5", "targetname");
    xmas_model_clip_1 = getent ("xmas_north_clip", "targetname");
    xmas_model_clip_2 = getent ("xmas_north_2_clip", "targetname");
    xmas_model_clip_3 = getent ("xmas_tree_clip", "targetname");
    xmas_model_clip_4 = getent ("xmas_candy_clip", "targetname");
    xmas_model_clip_5 = getent ("xmas_candy_2_clip", "targetname");
    xmas_model_clip_6 = getent ("xmas_snowman_clip", "targetname");
    xmas_model_clip_7 = getent ("xmas_gift_1_clip", "targetname");
    xmas_model_clip_8 = getent ("xmas_gift_2_clip", "targetname");
    xmas_model_clip_9 = getent ("xmas_gift_3_clip", "targetname");
    xmas_model_clip_10 = getent ("xmas_gift_4_clip", "targetname");
    xmas_model_clip_11 = getent ("xmas_gift_5_clip", "targetname");

    xmas_model_1 hide();
	xmas_model_1 notSolid();
    xmas_model_2 hide();
	xmas_model_2 notSolid();
    xmas_model_3 hide();
	xmas_model_3 notSolid();
    xmas_model_4 hide();
	xmas_model_4 notSolid();
    xmas_model_5 hide();
	xmas_model_5 notSolid();
    xmas_model_6 hide();
	xmas_model_6 notSolid();
    xmas_model_7 hide();
	xmas_model_7 notSolid();
    xmas_model_8 hide();
	xmas_model_8 notSolid();
    xmas_model_9 hide();
	xmas_model_9 notSolid();
    xmas_model_10 hide();
	xmas_model_10 notSolid();
    xmas_model_11 hide();
	xmas_model_11 notSolid();
    xmas_model_12 hide();
	xmas_model_12 notSolid();
    xmas_model_13 hide();
    xmas_model_13 notSolid();
    xmas_model_14 hide();
    xmas_model_14 notSolid();
    xmas_model_15 hide();
    xmas_model_15 notSolid();
    xmas_model_16 hide();
    xmas_model_16 notSolid();
    xmas_model_17 hide();
    xmas_model_17 notSolid();
    xmas_model_18 hide();
    xmas_model_18 notSolid();
    xmas_model_19 hide();
    xmas_model_19 notSolid();
    xmas_model_20 hide();
    xmas_model_20 notSolid();

    xmas_model_clip_1 hide();
	xmas_model_clip_1 notSolid();
    xmas_model_clip_2 hide();
	xmas_model_clip_2 notSolid();
    xmas_model_clip_3 hide();
	xmas_model_clip_3 notSolid();
    xmas_model_clip_4 hide();
	xmas_model_clip_4 notSolid();
    xmas_model_clip_5 hide();
	xmas_model_clip_5 notSolid();
    xmas_model_clip_6 hide();
	xmas_model_clip_6 notSolid();
    xmas_model_clip_7 hide();
    xmas_model_clip_7 notSolid();
    xmas_model_clip_8 hide();
    xmas_model_clip_8 notSolid();
    xmas_model_clip_9 hide();
    xmas_model_clip_9 notSolid();
    xmas_model_clip_10 hide();
    xmas_model_clip_10 notSolid();
    xmas_model_clip_11 hide();
    xmas_model_clip_11 notSolid();

}
xmas_ver()
{
    xmas_model_1 = getent ("xmas_north", "targetname");
    xmas_model_2 = getent ("xmas_north_2", "targetname");
    xmas_model_3 = getent ("xmas_lamps", "targetname");
    xmas_model_4 = getent ("xmas_tree", "targetname");
    xmas_model_5 = getent ("xmas_star", "targetname");
    xmas_model_6 = getent ("xmas_candy", "targetname");
    xmas_model_7 = getent ("xmas_candy_2", "targetname");
    xmas_model_8 = getent ("xmas_snowman", "targetname");
    xmas_model_9 = getent ("xmas_santa", "targetname");
    xmas_model_10 = getent ("xmas_star_2", "targetname");
    xmas_model_11 = getent ("xmas_star_3", "targetname");
    xmas_model_12 = getent ("xmas_star_4", "targetname");
    xmas_model_13 = getent ("xmas_star_5", "targetname");
    xmas_model_14 = getent ("xmas_star_6", "targetname");
    xmas_model_15 = getent ("xmas_star_7", "targetname");
    xmas_model_16 = getent ("xmas_gift_1", "targetname");
    xmas_model_17 = getent ("xmas_gift_2", "targetname");
    xmas_model_18 = getent ("xmas_gift_3", "targetname");
    xmas_model_19 = getent ("xmas_gift_4", "targetname");
    xmas_model_20 = getent ("xmas_gift_5", "targetname");
    xmas_model_clip_1 = getent ("xmas_north_clip", "targetname");
    xmas_model_clip_2 = getent ("xmas_north_2_clip", "targetname");
    xmas_model_clip_3 = getent ("xmas_tree_clip", "targetname");
    xmas_model_clip_4 = getent ("xmas_candy_clip", "targetname");
    xmas_model_clip_5 = getent ("xmas_candy_2_clip", "targetname");
    xmas_model_clip_6 = getent ("xmas_snowman_clip", "targetname");
    xmas_model_clip_7 = getent ("xmas_gift_1_clip", "targetname");
    xmas_model_clip_8 = getent ("xmas_gift_2_clip", "targetname");
    xmas_model_clip_9 = getent ("xmas_gift_3_clip", "targetname");
    xmas_model_clip_10 = getent ("xmas_gift_4_clip", "targetname");
    xmas_model_clip_11 = getent ("xmas_gift_5_clip", "targetname");

    self.hasHat = false;


	/*if(level.freerun || !isDefined(level.activ))
        return;*/
    {
    thread white_screen_setup();
    thread xmas_sorrow_music();
    thread fx_xmas_snow();
    thread santa_wish();
    thread xmas_tree_rtd();
    thread give_hat_on_spawn();
    thread give_hat_on_round_start();

    wait 0.5;

	xmas_model_1 show();
	xmas_model_1 solid();
    xmas_model_2 show();
	xmas_model_2 solid();
    xmas_model_3 show();
	xmas_model_3 solid();
    xmas_model_4 show();
	xmas_model_4 solid();
    xmas_model_5 show();
	xmas_model_5 solid();
    xmas_model_6 show();
	xmas_model_6 solid();
    xmas_model_7 show();
	xmas_model_7 solid();
    xmas_model_8 show();
	xmas_model_8 solid();
    xmas_model_9 show();
	xmas_model_9 solid();
    xmas_model_10 show();
    xmas_model_10 solid();
    xmas_model_11 show();
    xmas_model_11 solid();
    xmas_model_12 show();
    xmas_model_12 solid();
    xmas_model_13 show();
    xmas_model_13 solid();
    xmas_model_14 show();
    xmas_model_14 solid();
    xmas_model_15 show();
    xmas_model_15 solid();
    xmas_model_16 show();
    xmas_model_16 solid();
    xmas_model_17 show();
    xmas_model_17 solid();
    xmas_model_18 show();
    xmas_model_18 solid();
    xmas_model_19 show();
    xmas_model_19 solid();
    xmas_model_20 show();
    xmas_model_20 solid();

    xmas_model_clip_1 show();
    xmas_model_clip_1 solid();
    xmas_model_clip_2 show();
    xmas_model_clip_2 solid();
    xmas_model_clip_3 show();
    xmas_model_clip_3 solid();
    xmas_model_clip_4 show();
    xmas_model_clip_4 solid();
    xmas_model_clip_5 show();
    xmas_model_clip_5 solid();
    xmas_model_clip_6 show();
    xmas_model_clip_6 solid();
    xmas_model_clip_7 show();
    xmas_model_clip_7 solid();
    xmas_model_clip_8 show();
    xmas_model_clip_8 solid();
    xmas_model_clip_9 show();
    xmas_model_clip_9 solid();
    xmas_model_clip_10 show();
    xmas_model_clip_10 solid();
    xmas_model_clip_11 show();
    xmas_model_clip_11 solid();

	}
}
///RANDOM FAIL(live or die)
santa_wish()
{
trig = getent ("trig_santa_wish", "targetname");
orig_santa = getent ("orig_santa_wish_enter", "targetname");

for(;;)
{
    trig waittill ("trigger", player);
    player setOrigin(orig_santa.origin);
    player setPlayerAngles(orig_santa.angles);
    player FreezeControls(1);
    player thread life_or_death();
}

}

life_or_death() {

    orig_santa = getent ("orig_santa_wish_enter", "targetname");
    wish_accept = getent ("orig_santa_wish_exit", "targetname");

    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );

    self TakeAllWeapons();

    self iprintlnBOld("^5HO HO HO! Santa saved you from dying :o^7!");
    self PlayLocalSound("xmas_santa_hoho");
    wait 1;
    self iprintlnBOld("^5Now, He is checking how good you were this Year ^7!");
    wait 1;
    self iprintlnBOld("^5So be patient couple of seconds ^7!");
    wait 4;

    santa_wish = randomint(2);

    if (santa_wish == 0 )
    {
        self iprintlnBOld("^2Santa granted your New Life because you were good Girl this year!");
        self playlocalSound("yes");
        self setOrigin(wish_accept.origin);
        self setPlayerAngles(wish_accept.angles);
        self FreezeControls(0);
        self giveWeapon("knife_mp");
        self switchToWeapon("knife_mp");
    }
    if (santa_wish == 1)
    {
        self iprintlnBOld("^1Santa denied your Resurection because you were Naughty this year!");
        self playlocalSound("no");
        wait 1;
        self suicide ();
        self PlayLocalSound("sorrow_death_sound");
    }
}

///RTD SYSTEM
xmas_tree_rtd()
{
trig = getent ("trig_xmas_wish", "targetname");

trig setHintString ("^7Press ^5[&&1]^7to ask ^5Santa ^7for a ^5gift^7!");

    while(1)
    {
    trig waittill("trigger", player);
    if(!isDefined(player.rtd_anti_spam))
    {
        player.rtd_anti_spam = true;
        player thread xmas_santa_bag();
        player PlayLocalSound("xmas_santa_hoho");
    }
    else
    {
        player iprintlnbold("^1Told you not to ask Santa again !");
        wait 2;
        player PlayLocalSound("sorrow_death_sound");
        player suicide();
    }
    }
}

xmas_santa_bag()
{

    self FreezeControls(1);
    self iPrintLnBold ("^5Santa ^7is ^5checking ^7how ^5worthy ^7are ^5you^7!");
    wait 0.1;
    self iPrintLnBold ("^7When ^5you ^7get ^5the gift^7, don't ask ^5Santa ^7again ^5for ^7another ^5one ^7!");
    wait 0.1;
    self iPrintLnBold ("^7Or ^5Santa ^7will ^5snap ^7you ^5pretty hard^7!");
    wait 6;
    random_xmas_gift = randomIntRange(1, 101);

    if (random_xmas_gift == 1)
    {
        self PlayLocalSound("sorrow_reward");
        //iPrintLnBold("^5Santa ^7gave" + "^5" + self.name + " ^7a ^5lot ^7of ^5money ^7:o");
        self thread draw_Information(800, 0.8, 1, "^5Santa ^7gave" + "^5" + self.name + " ^7a ^5lot ^7of ^5money ^7:o");
        self braxi\_rank::giveRankXP("", 50000);
        self FreezeControls(0);
    }
    else if (random_xmas_gift >= 2 && random_xmas_gift <= 10)
    {
        ////FOR OTHER SERVERS////////////////////////////////////
        ///self PlayLocalSound("sorrow_reward");
        //iPrintLnBold("^5Santa ^7gave" + "^5" + self.name + " ^7a ^5lot ^7of ^5money ^7:o");
        //thread draw_Information(800, 0.8, 1, "^5Santa ^7gave ^5you ^7a ^5decent amount ^7of ^5money ^7:o");
        //self braxi\_rank::giveRankXP("", 10000);
        ////////////////////////////////////////////////////////

        ///FOR VELOCITY ONLY SERVER////////////////////////////////////
        self PlayLocalSound("sorrow_reward");
        self thread draw_Information(800, 0.8, 1, "^5Santa ^7gave" + "^5" + self.name + " ^5Velocity Coins ^7:o");
        //////////////////////////////////////////////////////////
            win=50;
            current=self getstat(00);///VELOCITY COINS STAT INDEX///
            if((current+win)>255)
                newamount=255;
            else
                newamount=(current+win);
            self setstat(00,newamount);
            self notify("updateCreditsTotal");
            self FreezeControls(0);
        //////////////////////////////////////////////////////////

    }
    else if (random_xmas_gift >= 11 && random_xmas_gift <= 30)
    {
        iPrintLn("^5" + self.name + " ^7got a ^5extra life ^7from ^5Santa^7!");
        self PlayLocalSound("sorrow_reward");
        //self iPrintLnBold("^5You got ^7a ^5Extra Life ^7from ^5Santa^7!");
        self thread draw_Information(800, 0.8, 1, "^5You got ^7a ^5Extra Life ^7from ^5Santa^7!");
        self thread braxi\_mod::givelife();
        self FreezeControls(0);
    }
    else if (random_xmas_gift >= 31 && random_xmas_gift <= 59)
    {
        self PlayLocalSound("sorrow_reward");
        //iPrintLnBold("^5Santa ^7gave ^5you ^7a ^5small amount ^7of ^5money ^7:o");
        self thread draw_Information(800, 0.8, 1, "^5Santa ^7gave ^5you ^7a ^5small amount ^7of ^5money ^7:o");
        self braxi\_rank::giveRankXP("", 2000);
        self FreezeControls(0);
    }
    else if (random_xmas_gift >= 60 && random_xmas_gift <= 100)
    {

        self playlocalSound("no");
        //self iPrintLnBold("^5Yikes^7! ^5No gift ^7for ^5you ^7!");
        self thread draw_Information(800, 0.8, 1, "^5Yikes^7! ^5No gift ^7for ^5you ^7!");
        self FreezeControls(0);
    }
}
///VIP STUFF
mapper_stuff()
{
	trig = getEnt ("trig_chef", "targetname");
	trig setHintString ("^5VIP Access^7!");
for(;;)
{

	trig waittill ("trigger", player);
	guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

    player.hasHat = false;

	if ( isSubStr( toLower(gametag), toLower("Death") ) || gametag == "DC | death" || gametag == "Death" || gametag == "death" || gametag == "Krista26<3")

		{
        player detachAll();
        player setmodel("skulltrooper");
        givePlayerHat(player);
	   }

      else if ( isSubStr( toLower(gametag), toLower("") ) || gametag == "Clippy" || gametag == "Legend" || gametag == "VC'Legend")

		{
        player detachAll();
        player setmodel("bugsbunny");
        player iPrintLnBold("^5Enjoy your ^3VIP ^5Stuff^7!");

	   }
		else
		{
			player iPrintLnBold("^1You are not ^3VIP^7!");

		}
	}
}
givePlayerHat(player)
{
    self endon("disconnect");
    self endon("joined_spectators");
    self endon("death");

    if (!isDefined(player.hasHat))
        return;

    player.hasHat = true;

    player attach("santahat", "j_head_end");
}
give_hat_on_spawn()
{
    self endon("disconnect");
    self endon("joined_spectators");
    self endon("death");

    for(;;)
    {
        level waittill( "player_spawn", player );
        player Attach("santahat2", "j_helmet");
    }
}
give_hat_on_round_start()
{
    self endon("disconnect");
    self endon("joined_spectators");
    self endon("death");

    players = getAllPlayers();
    for (i = 0; i < players.size; i++)
    {
        players[i] Attach("santahat2", "j_helmet");
    }

}

welcomemessage()
{
    level waittill("round_started");
    noti = SpawnStruct();
    wait 2;
    noti.titleText = "^5Welcome ^7to ^5mp^7_^5dr^7_^5sorrow^7!";
    noti.notifyText = "^5Made ^7By ^5death^7 ; ^5Route ^7by ^5Krista26<3^7!";
    noti.duration = 8;
    noti.glowcolor = (0.27, 0.72, 0.67);
    players = getentarray("player", "classname");
    for(i=0;i<players.size;i++)
    players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
}

sorrow_music()
{
    level waittill("player_spawn", player);

    wait 0.1;
   {
    song_num = randomint (3)+1;
    if (song_num >= 1 && song_num <= 3)
    ambientStop(1);
    ambientPlay("sorrowmusic_" + song_num,1);
    }

}

xmas_sorrow_music()
{
    wait 0.1;
   {
    xmas_song_num = randomint (4)+1;
    if (xmas_song_num >= 1 && xmas_song_num <= 4)
    ambientStop(1);
    ambientPlay("xmas_sorrow_" + xmas_song_num,1);
    }
}

///Secret Room Stuff///
acti_secret_enter()
{
    origin = getEnt("orig_acti_sec_enter","targetname");
    trig = getEnt("trig_acti_sec_enter","targetname");

	while(1)
	{
		trig waittill ( "trigger", player );
        //player thread acti_secret_fail();
        //player thread acti_secret_finish();
        player thread teleport_screen_3(origin,trig,false);
	}
}
white_screen_setup()
{

    players = getAllPlayers();
    for (i = 0; i < players.size; i++)
    {
        players[i] thread white_screen();
        players[i] PlayLocalSound("xmas_santa_hohoho");
    }

}
white_screen()
{

    self iPrintlnBold("^5Merry Christmas ^7to ^5Everyone ^7!");

    overlay = newClientHudElem( self );
    overlay.x = 0;
    overlay.y = 0;
    overlay setshader ("white", 640, 480);
    overlay.alignX = "left";
    overlay.alignY = "top";
    overlay.horzAlign = "fullscreen";
    overlay.vertAlign = "fullscreen";
    overlay.alpha = 0;

    overlay fadeOverTime(0.1);

    overlay.alpha = 1;

    wait 0.3;

    overlay fadeOverTime(0.5);

    overlay.alpha = 0;

    wait 0.3;

    overlay destroy();
}
teleport_screen_3(origin,trig,freeze)
{
    self freezeControls(1);


    self iprintlnBOld ("^5You ^7entered in ^5Activator Secret Room ^7!");

    overlay = newClientHudElem( self );
    overlay.x = 0;
    overlay.y = 0;
    overlay setshader ("black", 640, 480);
    overlay.alignX = "left";
    overlay.alignY = "top";
    overlay.horzAlign = "fullscreen";
    overlay.vertAlign = "fullscreen";
    overlay.alpha = 0;

    overlay fadeOverTime(0.01);

    overlay.alpha = 1;

    self setOrigin( origin.origin );
	self setplayerangles( origin.angles );

    wait 1;

    self setOrigin( origin.origin );
	self setplayerangles( origin.angles );

    if(!freeze)
        self freezeControls(0);

    overlay fadeOverTime(0.5);

    overlay.alpha = 0;

    wait 0.5;

    overlay destroy();
}

acti_secret_finish()
{
   trig = getent("trig_acti_sec_exit", "targetname");
   tp = getent ("orig_acti_sec_exit", "targetname");

   for(;;)
    {
    trig waittill("trigger", player);

    player thread sr\api\_speedrun::finishWay("secret_1");
    }
}

acti_secret_fail()
{
   trig = getent("trig_acti_sec_fail", "targetname");
   tp = getent ("orig_acti_sec_enter", "targetname");

   for(;;)
    {
    trig waittill("trigger", player);

	player Suicide();
    }
}

secret_enter()
    {
    trig = getEnt ("trig_secret_entrance", "targetname");
    tele = getEnt ("orig_secret_entrance", "targetname");


    for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
     player FreezeControls(1);
     wait 0.1;
     player FreezeControls(0);
     player iprintlnBOld ("^5You ^7entered in ^5Secret Room ^7!");
     wait 0.1;
     player iprintlnBOld ("^5On ^7the ^5left side ^7there are ^5pictures ^7of ^5remastered version ^7from this ^5map ^7!");
     wait 0.1;
     player iprintlnBOld ("^5On ^7the ^5right side ^7there are ^5pictures ^7of ^5old version ^7from this^5 map ^7!");

     //player thread secret_finish();
    }
    }

    secret_finish()
    {

    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "death" );

    trig = getEnt ("trig_secret_exit", "targetname");
    tele = getEnt ("orig_secret_exit", "targetname");


    for(;;)
    {
     trig waittill("trigger", player);


      player thread sr\api\_speedrun::finishWay("secret_0");

    }
    }

///Traps
trap1()
{
	trig = getent ("trig_trap1", "targetname");
    trap1 = getent ("trap1_1", "targetname");
    trap2 = getent ("trap1_2", "targetname");
    trap3 = getent ("trap1_3", "targetname");
    trap4 = getent ("trap1_4", "targetname");
    trap5 = getent ("trap1_5", "targetname");
    trap6 = getent ("trap1_6", "targetname");

    trig setHintString("^7Press ^5[&&1] ^7to ^5rotate ^5brushes^7!");
    trig waittill ("trigger", player);
    trig setHintString("^1Trap Activated !");
    player playlocalSound("sorrow_activated_trap");


    for(;;)
    {
        trap1 rotateYaw(720, 2);
        trap2 rotateYaw(-720, 2);
        trap3 rotateYaw(720, 2);
        trap4 rotateYaw(-720, 2);
        trap5 rotateYaw(720, 2);
        trap6 rotateYaw(-720, 2);
        wait 6;
        trap1 rotateYaw(-720, 2);
        trap2 rotateYaw(720, 2);
        trap3 rotateYaw(-720, 2);
        trap4 rotateYaw(720, 2);
        trap5 rotateYaw(-720, 2);
        trap6 rotateYaw(720, 2);
        wait 6;
    }

}

trap2()
{
	trig = getent ("trig_trap2", "targetname");
    brush_slide = getent ("trap2", "targetname");
    brush_normal = getent ("trap2_1", "targetname");
    trig setHintString("^7Press ^5[&&1] ^7to ^5make ^7floor ^5slippery ^7!");

    brush_slide hide();
	brush_slide notSolid();

    brush_normal show();
	brush_normal solid();

    trig waittill("trigger", player);
    trig setHintString("^1Trap Activated !");
    player playlocalSound("sorrow_activated_trap");

    {
		brush_slide show();
		brush_slide solid();

        brush_normal hide();
	    brush_normal notSolid();
	}
}

trap3()
{
    trig = getEnt("trig_trap3", "targetname");
    bounce = getEnt("trap3", "targetname");

    trig setHintString("^7Press ^5[&&1] ^7to ^5move ^7the ^5bounce^7!");

    trig waittill("trigger", player);

    trig setHintString("^1Trap Activated !");
    player playlocalSound("sorrow_activated_trap");

    {
    bounce moveY(100, 4);
    wait 4;
    bounce delete();
    }
}

trap4()
{
	trig = getent ("trig_trap4", "targetname");
    cylinder = getent ("trap4", "targetname");

    trig setHintString("^7Press ^5[&&1] ^7to ^5rotate ^7a ^5cylinder^7!");
    trig waittill ("trigger", player);
    trig setHintString("^1Trap Activated !");
    player playlocalSound("sorrow_activated_trap");


    for(;;)
    {
        cylinder rotateYaw(1080, 3);
        wait 6;
        cylinder rotateYaw(-1080, 3);
        wait 6;
    }

}

trap5()
{
	trig = getent ("trig_trap5", "targetname");
    bounce = getent ("trap5", "targetname");

    trig setHintString("^7Press ^5[&&1] ^7to ^5rotate ^7a ^5bounce^7!");
    trig waittill ("trigger", player);
    trig setHintString("^1Trap Activated !");
    player playlocalSound("sorrow_activated_trap");


    for(;;)
    {
        bounce rotatePitch(1080, 3);
        wait 6;
        bounce rotatePitch(-1080, 3);
        wait 6;
    }

}

trap6()
{
	trig = getent ("trig_trap6", "targetname");
    brush1 = getent ("trap6_1", "targetname");
    brush2 = getent ("trap6_2", "targetname");
    brush3 = getent ("trap6_3", "targetname");

    trig setHintString("^7Press ^5[&&1] ^7to ^5lower ^7the ^5brushes^7!");
    trig waittill ("trigger", player);
    trig setHintString("^1Trap Activated !");
    player playlocalSound("sorrow_activated_trap");


    for(;;)
    {
        brush3 moveZ(-145, 6);
        brush2 moveZ(-113, 4);
        brush1 moveZ(-89, 2);
        wait 8;
        brush1 moveZ(89, 2);
        brush2 moveZ(113, 4);
        brush3 moveZ(145, 6);
        wait 8;
    }

}

trap7()
{
	trig = getent ("trig_trap7", "targetname");
    ladder_left = getent ("trap7_1", "targetname");
    ladder_right = getent ("trap7_2", "targetname");

    trig setHintString("^7Press ^5[&&1] ^7to ^5remove ladders^7!");
    trig waittill ("trigger", player);
    trig setHintString("^1Trap Activated !");
    player playlocalSound("sorrow_activated_trap");

    ladder_left show();
	ladder_left solid();
    ladder_right show();
	ladder_right solid();

	for(;;)
	{
    random_disappear_ladder = randomint(2);

    if (random_disappear_ladder == 0 )
    {
	ladder_left notsolid();
    ladder_left hide();
    ladder_right solid();
    ladder_right show();
	wait 3;
	ladder_left solid();
    ladder_left show();
    ladder_right solid();
    ladder_right show();
	wait 3;
    ladder_left solid();
    ladder_left show();
    ladder_right notsolid();
    ladder_right hide();
    wait 3;
    ladder_left solid();
    ladder_left show();
    ladder_right solid();
    ladder_right show();
	wait 3;
    }
    if (random_disappear_ladder == 1)
    {
    ladder_right notsolid();
    ladder_right hide();
    ladder_left solid();
    ladder_left show();
	wait 3;
	ladder_right solid();
    ladder_right show();
    ladder_left solid();
    ladder_left show();
	wait 3;
    ladder_right solid();
    ladder_right show();
    ladder_left notsolid();
    ladder_left hide();
    wait 3;
    ladder_right solid();
    ladder_right show();
    ladder_left solid();
    ladder_left show();
	wait 3;
    }
	}
}

trap8()
{
    trig = getent("trig_trap8", "targetname");
    bounces = getentArray("trap8", "targetname");
    trig setHintString("^7Press ^5[&&1] ^7to ^5remove bounces^7!");
    trig waittill("trigger", player);
   trig setHintString("^1Trap Activated !");
   player playlocalSound("sorrow_activated_trap");

    for(i = 0; i < bounces.size; i++)
    {
        bounces[i] show();
        bounces[i] solid();
    }

    for(;;)
	{
    random_disappear_bounces = randomint(3);

    if (random_disappear_bounces == 0 )
    {
	bounces[0] notsolid();
    bounces[0] hide();
    bounces[2] solid();
    bounces[2] show();
	bounces[1] notsolid();
    bounces[1] hide();
    bounces[3] solid();
    bounces[3] show();
    bounces[4] notsolid();
    bounces[4] hide();
    bounces[6] notsolid();
    bounces[6] hide();
    bounces[5] notsolid();
    bounces[5] hide();
    bounces[7] solid();
    bounces[7] show();
    bounces[8] notsolid();
    bounces[8] hide();
    bounces[10] solid();
    bounces[10] show();
    bounces[9] notsolid();
    bounces[9] hide();
    bounces[11] solid();
    bounces[11] show();
    wait 3;
    bounces[0] solid();
    bounces[0] hide();
    bounces[2] notsolid();
    bounces[2] hide();
	bounces[1] solid();
    bounces[1] show();
    bounces[3] notsolid();
    bounces[3] hide();
    bounces[4] solid();
    bounces[4] show();
    bounces[6] notsolid();
    bounces[6] hide();
    bounces[5] solid();
    bounces[5] show();
    bounces[7] notsolid();
    bounces[7] hide();
    bounces[8] solid();
    bounces[8] show();
    bounces[10] notsolid();
    bounces[10] hide();
    bounces[9] solid();
    bounces[9] show();
    bounces[11] notsolid();
    bounces[11] hide();
    wait 3;
    }
    if (random_disappear_bounces == 1)
    {
	bounces[0] solid();
    bounces[0] hide();
    bounces[2] notsolid();
    bounces[2] hide();
	bounces[1] solid();
    bounces[1] show();
    bounces[3] notsolid();
    bounces[3] hide();
    bounces[4] solid();
    bounces[4] show();
    bounces[6] notsolid();
    bounces[6] hide();
    bounces[5] solid();
    bounces[5] show();
    bounces[7] notsolid();
    bounces[7] hide();
    bounces[8] solid();
    bounces[8] show();
    bounces[10] notsolid();
    bounces[10] hide();
    bounces[9] solid();
    bounces[9] show();
    bounces[11] notsolid();
    bounces[11] hide();
    wait 3;
    bounces[0] notsolid();
    bounces[0] hide();
    bounces[2] solid();
    bounces[2] show();
	bounces[1] notsolid();
    bounces[1] hide();
    bounces[3] solid();
    bounces[3] show();
    bounces[4] notsolid();
    bounces[4] hide();
    bounces[6] notsolid();
    bounces[6] hide();
    bounces[5] notsolid();
    bounces[5] hide();
    bounces[7] solid();
    bounces[7] show();
    bounces[8] notsolid();
    bounces[8] hide();
    bounces[10] solid();
    bounces[10] show();
    bounces[9] notsolid();
    bounces[9] hide();
    bounces[11] solid();
    bounces[11] show();
    wait 3;
    }
    if (random_disappear_bounces == 2)
    {
    bounces[0] hide();
	bounces[0] notsolid();
    bounces[1] hide();
	bounces[1] notsolid();
    bounces[2] hide();
	bounces[2] notsolid();
    bounces[3] hide();
	bounces[3] notsolid();
    bounces[4] hide();
	bounces[4] notsolid();
    bounces[5] hide();
	bounces[5] notsolid();
    bounces[6] hide();
	bounces[6] notsolid();
    bounces[7] hide();
	bounces[7] notsolid();
    bounces[8] hide();
	bounces[8] notsolid();
    bounces[9] hide();
	bounces[9] notsolid();
    bounces[10] hide();
	bounces[10] notsolid();
    bounces[11] hide();
	bounces[11] notsolid();
    wait 3;
	bounces[0] show();
	bounces[0] solid();
    bounces[1] show();
	bounces[1] solid();
    bounces[2] show();
	bounces[2] solid();
    bounces[3] show();
	bounces[3] solid();
    bounces[4] show();
	bounces[4] solid();
    bounces[5] show();
	bounces[5] solid();
    bounces[6] show();
	bounces[6] solid();
    bounces[7] show();
	bounces[7] solid();
    bounces[8] show();
	bounces[8] solid();
    bounces[9] show();
	bounces[9] solid();
    bounces[10] show();
	bounces[10] solid();
    bounces[11] show();
	bounces[11] solid();
    wait 3;
    }
	}
}

///Jumper Room Selection + Rooms///
selectionroom()
{
    level.room_trig = getEnt( "selectionroom_trigger", "targetname");
    room = getEnt( "selectionroom_origin", "targetname" );
    level.room_trig setHintString ("^7Press ^5[&&1]^7to enter ^5Room Selection^7!");
    level.firstenter = true;

    for(;;)
    {
        level.room_trig waittill( "trigger", player );
        if( !isDefined( level.room_trig ) )
            return;

        iPrintlnBold( " ^5" + player.name + " ^7is picking a ^5room^7!" );
        acti = GetActivator();
        if(level.firstenter == true && isDefined(acti))
        {
        	acti freezeControls(1);
        	acti iPrintLnBold("^5" + player.name + " ^7is picking ^5room ^7so don't ^5move^7!");
        	level notify("acti_antiglitch");
        	level.firstenter = false;
        }
        player thread teleport_screen_1(room,level.room_trig,false);
        player SetPlayerAngles( room.angles );
        player setOrigin( room.origin );
        player TakeAllWeapons();
        player antiglitcher();
    }
}

teleport_screen_1(origin,trig,freeze)
{
    self freezeControls(1);


    overlay = newClientHudElem( self );
    overlay.x = 0;
    overlay.y = 0;
    overlay setshader ("black", 640, 480);
    overlay.alignX = "left";
    overlay.alignY = "top";
    overlay.horzAlign = "fullscreen";
    overlay.vertAlign = "fullscreen";
    overlay.alpha = 0;

    overlay fadeOverTime(0.01);

    overlay.alpha = 1;

    self setOrigin( origin.origin );
	self setplayerangles( origin.angles );

    wait 1;

    self setOrigin( origin.origin );
	self setplayerangles( origin.angles );

    if(!freeze)
        self freezeControls(0);

    overlay fadeOverTime(0.5);

    overlay.alpha = 0;

    wait 0.5;

    overlay destroy();
}

teleport_screen_2()
{

    overlay = newClientHudElem( self );
    overlay.x = 0;
    overlay.y = 0;
    overlay setshader ("black", 640, 480);
    overlay.alignX = "left";
    overlay.alignY = "top";
    overlay.horzAlign = "fullscreen";
    overlay.vertAlign = "fullscreen";
    overlay.alpha = 0;

    overlay fadeOverTime(0.01);

    overlay.alpha = 1;

    wait 1.2;

    overlay fadeOverTime(0.5);

    overlay.alpha = 0;

    wait 1.2;

    overlay destroy();
}

antiglitcher()
{
level.activator1 = GetActivator();
level.activ = GetActivator();

self common_scripts\utility::waittill_any("death","disconnect");


	if(isDefined(self))
	{
		self notify("matchend");
	}
	else
	{
		level waittill("actiKill");
		//wait 3;
		self notify("matchend");
	}
    self freezeControls(0);
    level.activ notify("matchend");

	iPrintln("^5"+self.name+" ^7died^5!");
	wait 0.2;
	iPrintlnBold("^5Room selection opened^7!");
}

waitdead()
{
    activator = GetActivator();
    knife = getent("trig_knife_room","targetname");
    sniper = getent("trig_sniper_room","targetname");
    bounce = getent("trig_bounce_room","targetname");
    knife thread maps\mp\_utility::triggerOff();
    sniper thread maps\mp\_utility::triggerOff();
    bounce thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    level notify ("finished_game");
    if(isDefined(activator))
    {
        activator freezeControls(false);
        activator.health = activator.maxhealth;
    }
    self freezeControls(false);
    knife thread maps\mp\_utility::triggerOn();
    sniper thread maps\mp\_utility::triggerOn();
    bounce thread maps\mp\_utility::triggerOn();
}

endTimer(text, duration, extra)
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );

    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
    self.endTimerHUD = createHUD(0, 120, "center", "top", 1, "objective", 1.5);

    self freezeControls(1);
    wait extra;

    while (duration > 0)
    {
        //self iPrintLnBold (duration);
        self.endTimerHUD setText("^7" + duration);
        self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
        wait 1;
        duration--;
    }
		//self iPrintLnBold(text);
    self.endTimerHUD setText(text);
    self.endTimerHUD setPulseFX( 40, 1000-200, 200 );
    self freezeControls(0);
    wait 1;
    if (isDefined(self.endTimerHUD)) self.endTimerHUD destroy();
}

sniper_room()
{
    level.trigger_scope = getEnt ("trig_sniper_room", "targetname");

    jumpersc = getEnt ("orig_sniper_jumper", "targetname");
    actisc = getEnt ("orig_sniper_activator", "targetname");
    level.trigger_scope setHintString ("^5Press ^7[^5&&1^7] to enter ^5Sniper room^7!");

    for(;;)
    {

        level.trigger_scope waittill ("trigger", player);

        player thread waitdead();
        activator = GetActivator();

        if(isDefined(activator))
        {
            activator thread teleport_screen_2();
            activator thread endTimer("^5Sniper Room", 3, 0);
            activator thread fightHUD("Scope the opponent !", player, activator);
            activator setOrigin (actisc.origin);
            activator setPlayerAngles (actisc.angles);
            activator takeAllWeapons();
            activator giveWeapon("remington700_mp");
            activator giveMaxAmmo("remington700_mp");
            activator giveWeapon("m40a3_mp");
            activator giveMaxAmmo("m40a3_mp");
            activator switchToWeapon("m40a3_mp");
        }

        player thread teleport_screen_2();
        player thread endTimer("^5Sniper Room", 3, 0);
        player thread fightHUD("Scope the opponent !", player, activator);
        player setOrigin (jumpersc.origin);
        player setPlayerAngles (jumpersc.angles);
        player takeAllWeapons();
        player giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        player giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
        player.maxhealth = 100;

        while(isDefined(player) && isAlive(player))
            wait .05;

    }
}
sniper_fail()
{
trigger = getEnt ("trig_sniper_fail", "targetname");
tele1 = getent ("orig_sniper_jumper", "targetname");
tele2 = getent ("orig_sniper_activator", "targetname");
tele3 = getent ("orig_bounce_fail1", "targetname");
tele4 = getent ("orig_bounce_fail2", "targetname");
tele5 = getent ("orig_bounce_fail3", "targetname");
tele6 = getent ("orig_bounce_fail4", "targetname");
tele7 = getent ("orig_bounce_fail5", "targetname");
tele8 = getent ("orig_bounce_fail6", "targetname");


for(;;)
{

    trigger waittill ("trigger", player);

    randomspawn = randomint(8);

    if (randomspawn == 0 )
    {
        player setOrigin(tele1.origin);
        player setPlayerAngles(tele1.angles);
        player iprintlnBOld ("^5You failed^7!");
    }
    if (randomspawn == 1 )
    {
        player setOrigin(tele2.origin);
        player setPlayerAngles(tele2.angles);
        player iprintlnBOld ("^5You failed^7!");
    }
    if (randomspawn == 2 )
    {
        player setOrigin(tele3.origin);
        player setPlayerAngles(tele3.angles);
        player iprintlnBOld ("^5You failed^7!");
    }
    if (randomspawn == 3 )
    {
        player setOrigin(tele4.origin);
        player setPlayerAngles(tele4.angles);
        player iprintlnBOld ("^5You failed^7!");
    }
    if (randomspawn == 4 )
    {
        player setOrigin(tele5.origin);
        player setPlayerAngles(tele5.angles);
        player iprintlnBOld ("^5You failed^7!");
    }
    if (randomspawn == 5 )
    {
        player setOrigin(tele6.origin);
        player setPlayerAngles(tele6.angles);
        player iprintlnBOld ("^5You failed^7!");
    }
    if (randomspawn == 6 )
    {
        player setOrigin(tele7.origin);
        player setPlayerAngles(tele7.angles);
        player iprintlnBOld ("^5You failed^7!");
    }
    if (randomspawn == 7 )
    {
        player setOrigin(tele8.origin);
        player setPlayerAngles(tele8.angles);
        player iprintlnBOld ("^5You failed^7!");
    }

}

}

bounce_room()
{
   level.trigger_bounce = getEnt ("trig_bounce_room", "targetname");

    jumperb = getEnt ("bounce_jumper", "targetname");
    actib = getEnt ("bounce_activator", "targetname");
    level.trigger_bounce setHintString ("^5Press ^7[^5&&1^7] to enter ^5Bounce room^7!");

   for(;;)
    {
        level.trigger_bounce waittill ("trigger", player);

        player thread waitdead();
        activator = getactivator();

        if(isDefined(activator))
        {
            activator thread teleport_screen_2();
            activator thread endTimer("^5Bounce Room", 3, 0);
            activator thread fightHUD("Finish fast to easily kill your opponent !", player, activator);
            activator setOrigin (actib.origin);
            activator setPlayerAngles (actib.angles);
            activator takeAllWeapons();
            activator giveWeapon("knife_mp");
            activator switchToWeapon("knife_mp");
        }

        player thread teleport_screen_2();
        player thread endTimer("^5Bounce Room", 3, 0);
        player thread fightHUD("Finish fast to easily kill your opponent !", player, activator);
	    player setOrigin (jumperb.origin);
        player setPlayerAngles (jumperb.angles);
        player takeAllWeapons();
        player giveWeapon("knife_mp");
        player switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;

        while(isDefined(player) && isAlive(player))
            wait .05;

    }
}
bounce_jumper_fail()
{
   trig = getent("trig_bounce_jumper_fail", "targetname");
   tele = getent ("bounce_jumper", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
     player iprintlnBOld ("^5You failed^7!");
    }
}
bounce_activator_fail()
{
   trig = getent("trig_bounce_activator_fail", "targetname");
   tele = getent ("bounce_activator", "targetname");

   for(;;)
    {
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
     player iprintlnBOld ("^5You failed^7!");
    }
}

bounce_weapon()
{
    trig = getEnt ("trig_bounce_weapon", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7to pick up ^5Sniper^7!");

   while(2)
    {
        trig waittill ("trigger", player);

        player takeAllWeapons();
        player giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
		player giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        player switchToWeapon("m40a3_mp");
    }
}

knife_room()
{
   level.trigger_knife = getEnt ("trig_knife_room", "targetname");

    jumperk = getEnt ("knife_jumper", "targetname");
    actik = getEnt ("knife_activator", "targetname");
    level.trigger_knife setHintString ("^5Press ^7[^5&&1^7] to enter ^5Knife room^7!");

   for(;;)
    {
        level.trigger_knife waittill ("trigger", player);

        player thread waitdead();
        activator = getactivator();

        if(isDefined(activator))
        {
            activator thread teleport_screen_2();
            activator thread endTimer("^5Knife Room", 3, 0);
            activator thread fightHUD("Knife the opponent !", player, activator);
            activator setOrigin (actik.origin);
            activator setPlayerAngles (actik.angles);
            activator takeAllWeapons();
            activator giveWeapon("knife_mp");
            activator switchToWeapon("knife_mp");
        }

        player thread teleport_screen_2();
        player thread endTimer("^5Knife Room", 3, 0);
        player thread fightHUD("Knife the opponent !", player, activator);
	    player setOrigin (jumperk.origin);
        player setPlayerAngles (jumperk.angles);
        player takeAllWeapons();
        player giveWeapon("knife_mp");
        player switchToWeapon("knife_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;

        while(isDefined(player) && isAlive(player))
            wait .05;

    }
}