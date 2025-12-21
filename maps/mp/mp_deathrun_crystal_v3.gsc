main()
{
    level.ambient_crystals = loadFX("crystalv3/spark");
    level.tp_fx = loadFX("crystalv3/tp_fx");
    level.trail_fx = loadFX("crystalv3/trail_fx");
    level.trail_xmas_fx = loadFX("crystalv3/trail_xmas_fx");
    level._effect["snow"] = loadfx("crystalv3/snow");

    maps\mp\_load::main();

    precacheModel("weapon_remington700");
    precacheModel("miku");
    precacheModel("santa_hat");
    precacheModel("giftbox_1");
    precacheModel("giftbox_2");
    precacheModel("giftbox_3");

    level._ambient_crystals_setting = true;
    level._modelchanger_setting = true;
    level._path_shower = true;
    level._xmas = false;

    //maps\mp\crystalv3\_ambient_crystals::ambcrystals_fx();
    //maps\mp\crystalv3\_scripted_bounce::scripted_bounce_setup();
    //maps\mp\crystalv3\_modelchanger::main();
    //maps\mp\crystalv3\_xmas::main();
    
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    if( !isDefined(game["map_music"]) )
        game["map_music"] = 1;
    
    setdvar( "r_specularcolorscale", "1" );
    
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");
    setdvar("compassmaxrange","1000");  
    setDvar("bg_falldamagemaxheight", "99999");
    setDvar("bg_falldamageminheight", "99998");

    level.map_trap_string = "Press [^5&&1^7] To ^2Activate ^3Trap";

    thread sr\api\_map::createSpawn((-432,0,84), 360);
    thread sr\api\_speedrun::createNormalWays("Normal Way");

    thread sr_tp();

    //thread moveplat();
    thread scripted_bounce_setup();
    thread remove_xmas_objs();
    //thread v3();
    //thread music();
    //thread print_msgs();

    thread trap1();
    thread trap2();
    thread trap3();
    thread trap4();
    thread trap5();
    thread trap6();
    thread trap7();
    //thread trap8_setup();
    thread trap9_setup();
    thread trap10();

    //thread enter_roomselection();
    //thread sniper_room();
    //thread bounce_room();
    //thread knife_room();

    //thread bounceroom_fail();
    //thread bounceroom_weapon(); 

    addTriggerToList("trap1trigger");
    addTriggerToList("trap2trigger");
    addTriggerToList("trap3trigger");
    addTriggerToList("trap4trigger");
    addTriggerToList("trap5trigger");
    addTriggerToList("trap6trigger");
    addTriggerToList("trap7trigger");
    addTriggerToList("trap8trigger");
    addTriggerToList("trap9trigger");
    addTriggerToList("trap10trigger");

    //level waittill("round_started");
  
    xp_cluster();
    thread startdoor();

    maps\mp\crystalv3\_teleport::main();// placed here kuz of fx, dont change
    maps\mp\crystalv3\_path_shower::main();// placed here kuz of fx, dont change
}
sr_tp()
{
	trig = getEnt("moveplat_trig","targetname");
	ori_t = spawn("script_origin",(565,-1885,92));
	ori_t.angles = (0,270,0);

	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles((player getplayerangles()[0], ori_t.angles[1], 0));
		player freeze_on_tps(0.1);
	}
}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
freeze_on_tps(time) {
	self freezecontrols(true);
	self thread dddasdasddd(time);
}
dddasdasddd(time) {
	wait time;
	self freezecontrols(false);
}
///SCRIPTED BOUNCES///
scripted_bounce_setup()
{
    trigger = GetEntArray("scripted_bounce","targetname");
    for(i=0;i<trigger.size;i++)
        thread scripted_bounce(trigger[i]);
}

scripted_bounce(trigger)
{
    for(;;)
    {
        trigger waittill("trigger",player);
        thread dobounce(trigger,player);
    }
}

dobounce(trigger,player)
{
    player endon("disconnect");
    player endon("death");

    vel = player getVelocity();

    temp0 = ( ( (vel[0] < 350 && vel[0] > 0) || (vel[0] > -350 && vel[0] < 0) ) );
    temp1 = ( ( (vel[1] < 350 && vel[1] > 0) || (vel[1] > -350 && vel[1] < 0) ) );

    if((!temp0 && !temp1) || vel[2] > -350)
    {
        wait 1;
        return;
    }

    health = player.health;
    maxHealth = player.maxHealth;
    player.health = 100000;
    player.maxhealth = 100000;

    knockback = getdvar("g_knockback");
    setDvar("g_knockback", (vel[2]*-9)-500);
    
    if(isAlive(player) && player.sessionstate == "playing") //to avoid error
        player finishPlayerDamage(player, player, 1000, 0, "MOD_UNKNOWN", "bounce", player.origin, (0,0,1) , "none", 0);

    wait 0.05;
    setDvar("g_knockback", knockback);

    player.health = health;
    player.maxhealth = maxHealth;

    while(player isTouching(trigger))
        wait 0.05;
}///END SCRIPTED BOUNCES///

///ARROWS///
arrow_indicator(name,trigger,logic,units)
{
    level endon(logic);

    arrow_group = getent(name,"targetname");
    arrow_group hide();
    arrow_group notsolid();

    dir_ind = getent(name+"_origin","targetname");

    arrow_group thread arrow_movement(trigger, logic, units, dir_ind);
    arrow_group thread arrow_kill_onactivation(trigger, logic, dir_ind);
    arrow_group thread arrow_kill_ontrapsdisabled(trigger, logic, dir_ind);

    while(isDefined(trigger))
    {
        if(isDefined(level.activ) && level.activ isTouching(trigger) )
            arrow_group showtoplayer(level.activ);
        else
            arrow_group hide();

        wait 0.05;
    }
}
arrow_kill_ontrapsdisabled(trigger, logic, dir_ind)
{
    level endon(logic);

    level waittill( "traps_disabled" );
    level notify(logic);
    self delete();
    trigger delete();
    dir_ind delete();
}

arrow_kill_onactivation(trigger, logic, dir_ind)
{
    trigger waittill("trigger",player);
    level notify(logic);
    self delete();
    dir_ind delete();
}

arrow_movement(trigger, logic, units, dir_ind) 
{
    level endon(logic);

    org_pos = self.origin;
    for(;;)
    {
        forward = AnglesToForward(dir_ind.angles);
        moveto_pos = self.origin + (forward*units);
        
        if(isDefined(self))
            self MoveTo(moveto_pos, 1, 0.25, 0.75);

        wait 1;

        if(isDefined(self))
            self MoveTo(org_pos, 1, 0.25, 0.75);
        
        wait 1;
    }
}
////

///XMAS VERSION///
remove_xmas_objs()
{
	xmas_ents = getentarray("xmas_ents","targetname");//model
	xmas_ent_mass = getentarray("xmas_ents_mass","targetname");//clip

	xmas_patches = getentarray("xmas_patches","targetname");//patch

	xmas_brushes_and_decals = getentarray("xmas_b_and_d","targetname");//brushes & decals

	for(i=0;i<xmas_ents.size;i++)//model & clips linked as prefab
	{
		xmas_ents[i] hide();
		xmas_ent_mass[i] notsolid();
	}

	for(i=0;i<xmas_patches.size;i++)
	{
		xmas_patches[i] notsolid();
		xmas_patches[i] hide();
	}

	for(i=0;i<xmas_brushes_and_decals.size;i++)
	{
		xmas_brushes_and_decals[i] notsolid();
		xmas_brushes_and_decals[i] hide();
	}
}
////
startdoor()
{
    door1 = getEnt("door1","targetname");
    door2 = getEnt("door2","targetname");
    
    wait 0.1;
    door1 delete();
    door2 delete(); 
}

music()
{
    name = "music"+game["map_music"];

    if(level._xmas == true)
        name = "xmasmusic"+game["map_music"];

    ambientplay(name);

    game["map_music"]++;
    if(game["map_music"] > 4)
        game["map_music"] = 1;
}

v3()
{
    obj = getEnt("v3","targetname");
    obj notsolid();
    obj thread rotateme(180,1.5);
    obj thread moveme(32, 1.5, 0.5, 0.5);
}

moveplat()
{
    trig = getEnt("moveplat_trig","targetname");
    obj = getEnt("moveplat","targetname");

    trig waittill("trigger",player);
    trig delete();
    orgpos = obj.origin;
    for(;;)
    {
        obj movex(-192,0.5);
        wait 1.5;
        obj movey(-832,4);
        wait 6;
        obj.origin = orgpos;
        wait 2;
    }
}

print_msgs()
{
    level endon("game over");

    msg = [];

    if(level._xmas == true)
        msg[msg.size] = "[^3Crystal_v3^7]: ^1M^7e^1r^7r^1y ^7C^1h^7r^1i^7s^1t^7m^1a^7s";

    msg[msg.size] = "[^3Crystal_v3^7]: ^7Map By Legend";
    msg[msg.size] = "[^3Crystal_v3^7]: ^7Xmas Model Export and santa_hat By VC'Fox";
    msg[msg.size] = "[^3Crystal_v3^7]: ^7Have Fun and Enjoy";

    for(;;)
    {
        for(i=0;i<msg.size;i++)
        {   
            wait randomintrange(10,15);
            iPrintLn(msg[i]);
        }
        wait 0.05;
    }
}

trap1()
{
    trigger = getEnt("trap1trigger","targetname");
    plats = getEntarray("trap1plats","targetname");
    trigger sethintstring(level.map_trap_string);

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap1_arrows1",trigger,"trap1arrow_noti",25);

    trigger waittill("trigger",player);
  

}

trap2()
{
    trigger = getEnt("trap2trigger","targetname");
    pusher = getEntarray("trap2pusher","targetname");
    trigger sethintstring(level.map_trap_string);

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap2_arrow1",trigger,"trap2arrow_noti",60);

    trigger waittill("trigger",player);
  
}

trap2move(pos, time, delay, orgpos)
{
    self movex(pos, time);
    wait delay;
    self moveto(orgpos, time);
}

trap3()
{
    trigger = getEnt("trap3trigger","targetname");
    pusher = getEnt("trap3pusher","targetname");
    trigger sethintstring(level.map_trap_string);

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap3_arrow1",trigger,"trap3arrow_noti",50);

    trigger waittill("trigger",player);
    
}

trap4()
{
    trigger = getEnt("trap4trigger","targetname");
    trigger sethintstring(level.map_trap_string);

    ent1 = getEnt("wall1","targetname");
    ent2 = getEnt("wall2","targetname");
    ent3 = getEnt("wall3","targetname");

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap4_arrow1",trigger,"trap4arrow_noti",35);
    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap4_arrow2",trigger,"trap4arrow_noti",35);
    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap4_arrow3",trigger,"trap4arrow_noti",35);

    trigger waittill("trigger",player);
 
}

trap5()
{
    trigger = getEnt("trap5trigger","targetname");
    trigger sethintstring(level.map_trap_string);

    plats = getEntarray("trap5rots","targetname");

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap5_arrows",trigger,"trap5arrow_noti",50);

    trigger waittill("trigger",player);
 
}

trap6()
{
    trigger = getEnt("trap6trigger","targetname");
    trigger sethintstring(level.map_trap_string);

    bounces = getEntarray("trap6bounces","targetname");

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap6_arrows",trigger,"trap6arrow_noti",40);

    trigger waittill("trigger",player);
   
}

trap7()
{
    trigger = getEnt("trap7trigger","targetname");
    trigger sethintstring(level.map_trap_string);

    rotators = getEntarray("trap7rotators","targetname");

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap7_arrows",trigger,"trap7arrow_noti",20);

    trigger waittill("trigger",player);
    
}

trap8_setup()
{
    platforms = getEntarray("trap8plats","targetname");

    thread trap8();

    for(i=0;i<platforms.size;i++)
    {
        platforms[i] thread trap8active();
        platforms[i] thread trap8auto_move();    
    }
}

trap8auto_move()
{
    level endon("start_trap8");
    orgpos = self.origin;
    for(;;)
    {
        rnd_pos = randomintrange(-128,128);
        time = RandomFloatRange( 1.5, 5.0 );
        self movez(rnd_pos,time);
        wait time+1.5;
        self moveto(orgpos,time);
        wait time+1.5;
    }
}

trap8active()
{
    level endon("round_ended");
    orgpos = self.origin;

    level waittill("start_trap8");
    self moveto(orgpos,0.25);

    wait 3;
    self thread trap8auto_move();
}

trap8()
{
    trigger = getEnt("trap8trigger","targetname");
    trigger sethintstring(level.map_trap_string);

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap8_arrows",trigger,"trap8arrow_noti",30);

    trigger waittill("trigger",player);
    trigger delete();

}

trap9_setup()
{
    trigger = getEnt("trap9trigger","targetname");
    trigger sethintstring(level.map_trap_string);
    bounce = getEnt("trap9bounce","targetname");

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap9_arrow",trigger,"trap9arrow_noti",30);

    trigger waittill("trigger",player);
    trigger delete();

    thread trap9(bounce);
    thread kill_trap9aftertime(5, bounce);
}

trap9(obj)
{
    level endon("kill_trap9");

    trigger = getEnt("tt9_trigger","targetname");

    trigger enablelinkto();
    trigger linkto(obj);

    tp_org = getEnt("tt9_org","targetname");

    obj movex(-60,2);

    for(;;)
    {
        trigger waittill("trigger",player);
        player setorigin(tp_org.origin);
        wait 0.05;
    }
}

kill_trap9aftertime(time, obj)
{
    wait time;
    level notify("kill_trap9");
    obj movex(60,2);
}

trap10()
{
    trigger = getEnt("trap10trigger","targetname");
    trigger sethintstring(level.map_trap_string);

    platform = getEnt("trap10obj","targetname");

    thread maps\mp\crystalv3\_arrow_funk::arrow_indicator("trap10_arrow",trigger,"trap10arrow_noti",30);

    trigger waittill("trigger",player);
 
}

enter_roomselection()
{
    trigger = getEnt("room_selection_trigger","targetname");
    org = getEnt("room_selection_origin","targetname");
    trigger sethintstring("Press [^5&&1^7] To ^2Enter ^5Room Selection");
    for(;;)
    {
        trigger waittill("trigger",player);

        iPrintLnBold(player.name+ " Entered Room Selection");

        player setorigin(org.origin);
        player SetPlayerAngles(org.angles);

        while(isAlive(player) && isDefined(player))
            wait 0.05;

        iPrintLnBold("Room Selection Open");

        wait 0.05;
    }
}

sniper_room()
{
    trigger = GetEnt("sniper_room_trigger","targetname");
    activator_origin = GetEnt("activator_sniper_origin","targetname");
    jumper_origin = GetEnt("jumper_sniper_origin","targetname");

    trigger setHintString("Press [^5&&1^7] To Enter [^5Sniper^7] Room");
    for(;;)
    {
        trigger waittill("trigger",player);
        room_action(player,activator_origin,jumper_origin,"Sniper");
        wait 0.05;
    }
}

knife_room()
{
    trigger = GetEnt("knife_room_trigger","targetname");
    activator_origin = GetEnt("activator_knife_origin","targetname");
    jumper_origin = GetEnt("jumper_knife_origin","targetname");

    trigger setHintString("Press [^5&&1^7] To Enter [^5Knife^7] Room");
    for(;;)
    {
        trigger waittill("trigger",player);
        room_action(player,activator_origin,jumper_origin,"Knife");
        wait 0.05;
    }
}

bounce_room()
{
    trigger = GetEnt("bounce_room_trigger","targetname");
    activator_origin = GetEnt("activator_bounce_origin","targetname");
    jumper_origin = GetEnt("jumper_bounce_origin","targetname");

    trigger setHintString("Press [^5&&1^7] To Enter [^5Bounce^7] Room");
    for(;;)
    {
        trigger waittill("trigger",player);
        room_action(player,activator_origin,jumper_origin,"Bounce");
        wait 0.05;
    }
}

room_action(player,activator_origin,jumper_origin,room)
{
    weapon1 = undefined;
    weapon2 = undefined;

    switch(room)
    {
        case "Sniper":
            weapon1 = "remington700_mp";
            weapon2 = "m40a3_mp";
        break;

        case "Knife":
        case "Bounce":
            weapon1 = "knife_mp";
            weapon2 = undefined; 
        break;
    }

    if(isDefined(level.activ))
    {
        level.activ setorigin( activator_origin.origin );
        level.activ SetPlayerAngles( activator_origin.angles );
        level.activ thread room_weapon(weapon1,weapon2);
    }

    if(isDefined(player))
    {
        player setorigin( jumper_origin.origin );
        player SetPlayerAngles( jumper_origin.angles );
        player thread room_weapon(weapon1,weapon2);
    }     

    iPrintLnBold("- = "+room+" Room = -");

    thread countdown(3, level.activ, player);
}

countdown(time, activator, player)
{
    if(isDefined(activator))
        activator freezeControls( true );

    if(isDefined(player))
        player freezeControls( true );

    for(i=time;i>0;i--)
    {
        iPrintLnBold(i);
        wait 1;
    }
    iPrintLnBold("!!Fight!!");

    if(isDefined(activator))
        activator freezeControls( false );

    if(isDefined(player))
        player freezeControls( false );
}

room_weapon(item,item2)
{
    if(isDefined(item) && isDefined(self))
    {
        self TakeAllWeapons();
        self giveWeapon(item);

        if(item != "knife_mp")
            self GiveMaxAmmo(item);

        self SwitchToWeapon(item);
    }

    if(isDefined(item2) && isDefined(self))
    {
        self giveWeapon(item2);
        self GiveMaxAmmo(item2);
    }
}

bounceroom_fail()
{
    acti_org = GetEnt("activator_bounce_origin","targetname");
    jumper_org = GetEnt("jumper_bounce_origin","targetname");
    fail_trig = getEnt("bounceroom_fail_trig","targetname");
    for(;;)
    {
        fail_trig waittill("trigger",player);

        if(isDefined(level.activ))
        {
            if(player == level.activ)
                level.activ setorigin(acti_org.origin);
            else 
                player setorigin(jumper_org.origin);
        }
        else
            player setorigin(jumper_org.origin);

        wait 0.05;
    }
}

bounceroom_weapon()
{
    weap_trigger = getEnt("bounceroom_weapon_trigger","targetname");
    model = spawn("script_model",weap_trigger.origin);
    model setmodel("weapon_remington700");
    model thread rotateme(180,1);
    for(;;)
    {
        weap_trigger waittill("trigger",player);
        player thread room_weapon("remington700_mp",undefined);
        wait 0.05;
    }
}

rotateme(deg, time, acc, dacc)
{
    level endon("round_ended");
    level endon("game over");
    self endon("death");
    
    while(isDefined(self))
    {
        self rotateyaw(deg,time);
        if(isDefined(acc) && isDefined(dacc))
            self rotateyaw(deg,time,acc,dacc);
        wait time;
    }
}

moveme(units,time,acc,dacc)
{
    level endon("round_ended");
    level endon("game over");
    self endon("death");

    orgpos = self.origin;
    
    while(isDefined(self))
    {
        self movez(units, time, acc, dacc);
        wait time;
        self moveto(orgpos, time, acc, dacc);
        wait time;
    }
}

xp_cluster()
{
    cluster = getEntarray("xp_cluster_obj","targetname");
    trigger = GetEntArray("xp_cluster_trigger","targetname");

    for(i=0;i<cluster.size;i++)
    {
    cluster[i] delete();
    }

}

givexp_map(obj, trigger, fx_org)
{
    wait 0.05;
    PlayFXOnTag( level.tp_fx, fx_org, "tag_origin" );

    trigger waittill("trigger",player);
    if(isDefined(obj))
        obj delete();

    if(isDefined(trigger))
        trigger delete();

    if(isDefined(fx_org))
        fx_org delete();
    player braxi\_rank::giveRankXP("", 150);
}