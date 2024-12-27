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
         _   ________   ___       __             _
        | | / / ___( ) / _ | ____/ /_____ ____  (_)
        | |/ / /__ |/ / __ |/ __/  '_/ _ `/ _ \/ /
        |___/\___/   /_/ |_/_/ /_/\_\\_,_/_//_/_/  
    Website: vistic-clan.com
    
    thanks: Phelix (for fixing the weapon problem :))
*/
main()
{
    maps\mp\_load::main();

    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    precacheItem("m40a3_mp");
    precacheItem("remington700_mp");
    precacheItem("p90_silencer_mp");
    precacheItem("knife_mp");
    precacheItem("deserteaglegold_mp");
    precacheItem("m4_mp");
    precacheItem("g3_silencer_mp");
    precacheItem("c4_mp");
    precacheItem("deserteagle_mp");
    precacheItem("ak74u_mp");

    //level._effect["name"] = loadfx("explosions/small_vehicle_explosion");

    setdvar("r_specularcolorscale","1");
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");
    setDvar("compassmaxrange","1024");
    setDvar("bg_fallDamageMaxHeight", 9999);
    setDvar("bg_fallDamageMinHeight", 9998);

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((5929, 3565, 2012), 210);
     
    thread sr_jumper_sec_enter();
    //thread startingRound();
    //traps
    //thread trap_glas();
    //thread trap_nonsolid();
    //thread trap_updown();
    thread trap_rotate();
    //thread trap_rotate2();
    //thread trap_bounce();
    //thread trap_spike();
    //thread trap_spin();

    //thread vclogo();
    //thread sec_parts();
    thread teleporter();
    //thread vip();
    //thread glitcher();
    //thread onConnect();
    //thread secret_enter();
    thread secret_leave();
    //thread secret_leave_shot();

    //thread kniferoom();
    //thread knifemagic();
    //thread sniperroom();
    //thread jumproom();
    //thread jump_weapon();
    //thread oldway();

    addQueueTrigger("sniper_tp");
    addQueueTrigger("jumper_tp");
    addQueueTrigger("knife_tp");
    addQueueTrigger("old_enter");

}

sr_jumper_sec_enter()
{
	trig = spawn("trigger_radius",(5954.29, 3381.58, 1952.13), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("auto1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player thread sr_tp_safe(ori);
	}
}
sr_tp_safe(ori)
{   
	self endon("death");
	self endon("disconnect");
	
	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}
onConnect()
{
    //level endon("game_ended");
   
    for(;;)
    {
        level waittill("connected",player);
        player.gotWeapon = false;
    }
}
vip()
{
    trig=getent("vip_button","targetname");
    trig waittill("trigger",player);
    trig delete();
    if(getsubstr(player getguid(),24,32)=="91f89ba1" && !isdefined(level.creatoron))
        {
            level.creatoron=true;
            iprintlnbold("Map creator ^1"+player.name+"^7 is on the Server");
            player givegun("p90_silencer_mp");
        }
        else if(player getstat(767)==1)
        {
            player iprintlnbold("^1Authorized ^7VC' Member!\n You got a ^1Gold Deagle^7!");
            player givegun("deserteaglegold_mp");
        }
        else
        player iprintlnbold("Unfortunally you are not VIP. ^1:(");

}
 
givegun(weap)
{
    self takeallweapons();
    self giveweapon(weap);
    self givemaxammo(weap);
    self switchtoweapon(weap);
}
teleporter()
{
    tele=getentarray("teleport","targetname");
    if(isdefined(tele))
    {
        for(i=0;i<tele.size;i++)
            tele[i] thread portMe();
    }
}
portMe()
{
    for(;;)
    {
        self waittill("trigger",player);
        targ=getent(self.target,"targetname");
        player Suicide();
    }
}

startingRound()
{
    level waittill("round_started");

    song=randomint(9);
    if(song==0||song==3||song==7)
        ambientplay("background1");
    else if(song==1||song==4||song==8)
        ambientplay("background2");
    else
        ambientplay("background3");

    for(;;)
    {
        iprintln("Map by ^1VC' Arkani^7!");
        wait 10;
        iprintln("Made for ^1Vistic^7 Clan!");
        wait 10;
    }
}


trap_glas()
{
    brush = getent("trap_glas", "targetname");
    trig = getent("trap_glas_trigger", "targetname");

    trig waittill("trigger", player);
    trig delete();

    brush delete();
    player iPrintLnBold("You destroyed the ^1Glas^7!");
    player braxi\_rank::giverankxp(undefined,40);
}
trap_nonsolid()
{
    brush = getentarray("trap_nonsolid", "targetname");
    brush2 = getentarray("trap_nonsolid2", "targetname");
    trig = getent("trap_nonsolid_trigger", "targetname");

    trig waittill ("trigger", player);
    trig delete ();
 
    rdm=randomint(4);
    if(rdm==1||rdm==0)
        brush[randomInt(brush.size)] notsolid();
    else
        brush2[randomInt(brush2.size)] notsolid();

    player braxi\_rank::giverankxp(undefined,40);
    player iPrintLnBold("You made one of them ^1Non-Solid^7!");
}
vclogo()
{
    brush = getent("vc_logo", "targetname");

    while(1)
    {
        brush rotateyaw(360, 10);
        wait 10;
    }
}
knifemagic()
{
    brush = getent("knife_magic", "targetname");

    while(1)
    {
        brush movez(-400, 10);
        brush rotateyaw(360, 10);
        wait 3;
        brush movez(400, 10);
        brush rotateyaw(360, 10);
        wait 3;
    }
}
trap_updown()
{
    brushs1 = getent("updown_1", "targetname");
    brushs2 = getent("updown_2", "targetname");
    trig = getent("trap_updown", "targetname");

    trig waittill("trigger", player);
    trig delete();

    brushs1 movez(-300, 2);
    wait 2;

    player braxi\_rank::giverankxp(undefined,40);
    player iPrintLnBold("You let them ^1Move^7!");
    while(1)
    {
        brushs1 movez(300, 2);
        brushs2 movez(-300, 2);
        wait 2;
        brushs1 movez(-300, 2);
        brushs2 movez(300, 2);
        wait 2;
    }
}
//secret
sec_parts()
{
    trig1 = getent("sec_part1", "targetname");


    trig1 waittill("trigger", player);
    trig1 delete();
    player iprintln("why would you press use here? lol"); 
}
trap_rotate()
{
    brush = getent("trap_rotate", "targetname");
    trig = getent("trap_rotate_trig", "targetname");
    trig_hurt = getent("trap_rotate_hurt", "targetname");

    trig delete();
    trig_hurt delete();
    brush delete();
}
trap_rotate2()
{
    brushs = getent("trap_rotate2", "targetname");
    trig = getent("trap_rotate2_trig", "targetname");

    trig waittill("trigger", player);
    trig delete();

    player braxi\_rank::giverankxp(undefined,40);
    player iPrintLnBold("You let it ^1Rotate^7!");

    while(1)
    {
        brushs delete();
        wait 4;
    }
}
trap_bounce()
{
    brush = getent("trap_bounce", "targetname");
    trig = getent("trap_bounce_trig", "targetname");

    trig waittill("trigger", player);
    trig delete();

    player braxi\_rank::giverankxp(undefined,40);
    player iPrintLnBold("You started moving the ^1Bounce^7!");

    while(1)
    {
        brush movez(120, 2);
        wait 3;
        brush movez(-120, 2);
        wait 5;
    }
}
trap_spin()
{
    brush = getent("trap_spin", "targetname");
    brush2 = getent("trap_spin2", "targetname");
    trig = getent("trap_spin_trig", "targetname");

    trig waittill("trigger", player);
    trig delete();

    player braxi\_rank::giverankxp(undefined,40);
    player iPrintLnBold("You started spinning the ^1Way^7!");

    while(1)
    {
        brush rotateroll(-360, 3);
        brush2 rotateroll(360, 3);
        wait 6;
    }
}
trap_spike()
{
    brush = getent("trap_spike", "targetname");
    trig = getent("trap_spike_trig", "targetname");
    trig_hurt = getent("spike_hurt", "targetname");
 //   exp1 = getent("exp1", "targetname");

//  playfx(level._effect["exp1"],fx_point1.origin);

    trig waittill("trigger", player);
    trig delete();
 
    trig_hurt enableLinkTo();
    trig_hurt linkTo(brush);
 
    player braxi\_rank::giverankxp(undefined,40);
    player iPrintLnBold("You let them ^1Fallen!^7!");
 
    brush movez(-176, 0.2);
}
sniperroom()
{
    level.sniper=getent("sniper_tp","targetname");   // trigger
    acti=getent("acti_sniper","targetname");           // activator origin
    jump=getent("jump_sniper","targetname");           // jumper origin
 
    while(1)
    {
        level.sniper waittill("trigger",player);
              
	
        if(!isdefined(level.sniper))
            return;

 
        if(!level.roomEntered)
        {
            level.roomEntered=true;
            iprintlnbold("^1"+player.name+"^7 entered ^1Sniper Fight");
            level.knife delete();
            level.jump delete();
            level.old delete();
        }
 
        if(isdefined(level.activ))
        {
            player endroomsetup(jump.origin,jump.angles,"m40a3_mp","remington700_mp",1);
            level.activ endroomsetup(acti.origin,acti.angles,"m40a3_mp","remington700_mp",1);
            wait 5;
            ambientplay("sniper");
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player iprintlnbold("^1You need an enemy you scrublord."); // ;)
            return;
        }
 
        while(isalive(player)&&isdefined(player))
            wait 1;
 
        iprintlnbold("^1"+player.name+"^7 has been killed");
        player braxi\_rank::giverankxp(undefined,150);
    }
}
 
kniferoom()
{
    level.knife=getent("knife_tp","targetname");   // trigger
    acti=getent("acti_knife","targetname");           // activator origin
    jump=getent("jumper_knife","targetname");           // jumper origin
 
    while(1)
    {
        level.knife waittill("trigger",player);
    
        if(!isdefined(level.knife))
            return;


 
        if(!level.roomEntered)
        {
            level.roomEntered=true;
            iprintlnbold("^1"+player.name+"^7 opened ^1Knife ^7Fight!");
            level.sniper delete();
            level.jump delete();
            level.old delete();
        }
 
        if(isdefined(level.activ))
        {
            player endroomsetup(jump.origin,jump.angles,"knife_mp",undefined,1);
            level.activ endroomsetup(acti.origin,acti.angles,"knife_mp",undefined,1);
            ambientplay("knife");
            wait 5;
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player iprintlnbold("^1You need an enemy you scrublord."); // ;)
            return;
        }
 
        while(isalive(player)&&isdefined(player))
            wait 1;
 
        iprintlnbold("^1"+player.name+"^7 has been killed!");
        player braxi\_rank::giverankxp(undefined,150);
    }
}

endroomsetup(origin,angles,weap,weap2,freeze)
{
    self setorigin(origin);
    self setplayerangles(angles);
 
    self takeallweapons();
    self giveweapon(weap);
    if(isdefined(weap2))
        self giveweapon(weap2);
    self switchtoweapon(weap);
 
    self freezecontrols(freeze);
}
jumproom()
{
    level.jump=getent("jumper_tp","targetname");   // trigger
    acti=getent("acti_jump","targetname");           // activator origin
    jump=getent("jump_jump","targetname");           // jumper origin
    level.roomEntered=false; 

    while(1)
    {
        level.jump waittill("trigger",player);
   
        if(!isdefined(level.jump))
            return;


 
        if(!level.roomEntered)
        {
            level.roomEntered=true;
            iprintlnbold("^1"+player.name+"^7 opened the ^1Bounce Room");
            level.sniper delete();
            level.knife delete();
            level.old delete();
            ambientplay("bounce");
        }
 
        if(isdefined(level.activ))
        {
            player endroomsetup(jump.origin,jump.angles,"knife_mp",undefined,1);
            level.activ endroomsetup(acti.origin,acti.angles,"knife_mp",undefined,1);
            wait 5;
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player iprintlnbold("^1no activator defined");
            return;
        }
 
        while(isalive(player)&&isdefined(player))
            wait 1;
 
        iprintlnbold("^1"+player.name+"^7 has been killed");
        player braxi\_rank::giverankxp(undefined,100);
    }
}
jump_weapon()
{
    weapon_jump_trig = getent("jump_getWeapon", "targetname");
 
    for(;;)
    {
        weapon_jump_trig waittill("trigger", player);
 
        if(!player.gotWeapon)
            {
                player.gotWeapon = true;
                givegun("m40a3_mp");
                player iprintlnbold("^1You have got a ^1Scope^7!");
                wait 5;
            }
        else
            player iprintlnbold("^1You already have got the ^1Scope^7!");
            wait 5;
    }
}

glitcher()
{
    trig = getent("glitcher", "targetname");
    targ=getent("glitcher_back","targetname");

    for(;;)
    {
        trig waittill("trigger", player);
        player freezecontrols(1);
        player takeallweapons();
        player setorigin(targ.origin);
        player setplayerangles(targ.angles);
        wait 0.1;
        iprintlnbold("^1"+player.name+"^7 tried to glitch! ^1Execute^7 him!");
    }
}
oldway()
{
    level.old=getent("old_enter","targetname");   // trigger
    jump=getent("old_origin","targetname");           // jumper origin
 
    while(1)
    {
        level.old waittill("trigger",player);
    
        
        if(!isdefined(level.old))
            return;

        
 
        if(!level.roomEntered)
        {
            level.roomEntered=true;
            iprintlnbold("^1"+player.name+"^7 opened ^1Old ^7Fight!");
            level.sniper delete();
            level.jump delete();
            level.knife delete();
        }

        player endroomsetup(jump.origin,jump.angles,"knife_mp",undefined,1);
        wait 0.1;
        player freezecontrols(0);

 
        while(isalive(player)&&isdefined(player))
            wait 1;
 
        iprintlnbold("^1"+player.name+"^7 has been killed!");
        player braxi\_rank::giverankxp(undefined,150);
    }
}

secret_enter()
{
    trig = getent("sec_enter", "targetname");
    origin=getent("auto1","targetname");  

    for(;;)
    {
        trig waittill("trigger", player);

        player endroomsetup(origin.origin,origin.angles,"deserteagle_mp","c4_mp",1);
        player iPrintLnBold("You've entered the ^1Secret ^7and have ^12^7 minutes to finish it!");
        wait 3;
        player freezecontrols(0);
        player secretTimer();
    }

}

secret_leave_shot()
{
    trig = getent("secret_leave_shot", "targetname");
    new_origin = getent("spawn", "targetname");
    for(;;)
    {
        trig waittill("trigger", player);

        player iPrintLnBold("You're left the ^1Secret^7!");
        player notify("secret_completed");
        if(isdefined(player.secretTimer))
            player.secretTimer destroy();
        player endroomsetup(new_origin.origin,new_origin.angles,"knife_mp",undefined,1);
        wait 0.1;
        player freezecontrols(0);
    }
}

secret_leave()
{
    trig=getent("secret_leave","targetname");
    targ=getent("secret_out","targetname");
    for(;;)
    {
    trig waittill("trigger",player);

    player thread sr\api\_speedrun::finishWay("secret_0"); 
    }
}

secretTimer()
{
    self endon("secret_completed");

    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
 
    self.secretTimer=newclienthudelem(self);
    self.secretTimer.foreground = true;
    self.secretTimer.alignX = "center";
    self.secretTimer.alignY = "bottom";
    self.secretTimer.horzAlign = "center";
    self.secretTimer.vertAlign = "bottom";
    self.secretTimer.x = 0;
    self.secretTimer.y = -7;
    self.secretTimer.sort = 5;
    self.secretTimer.fontScale = 1.6;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = true;
       self.secretTimer.label = &"Time in left: &&1";
       
    if(isdefined(level.randomcolor))
        self.secretTimer.glowColor=level.randomcolor;
    else
        self.secretTimer.glowColor=(1,0,0);
 
    for(i=0;i<120;i++)
    {
        self.secretTimer setvalue(120-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
 
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
}

	addQueueTrigger(name)
    {
        if(!isdefined(level.queue_triggers))
            level.queue_triggers = [];

        level.queue_triggers[level.queue_triggers.size] = getent(name,"targetname");
    }
