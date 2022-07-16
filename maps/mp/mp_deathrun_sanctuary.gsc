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
#include braxi\_common;
main()
{
	thread way_connect();
	maps\mp\_load::main();
    maps\mp\sanctuary\_others::main();
    maps\mp\sanctuary\_mystic::main();

    // ambientplay("sanctuary");
	
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    level.sanctuaryglow=(randomint(50)/50,randomint(50)/50,randomint(50)/50);
    level.dust_1=loadfx("vistic/vc_dust");
    level.torches=loadfx("vistic/torch_fire");
    level.magic_eplo=loadfx("vistic/light_explosion");
    level.gateeffect=loadfx("vistic/triangle");
    level.trap2_expl=loadfx("explosions/grenadeExp_concrete");
    level.first=false;
    precacheshellshock("frag_grenade_mp");

    // thread topcredits();

    // thread trap1();
    thread trap2();
    // thread trap3();
    // thread trap4();
    // thread trap5();
    // thread trap6();
    thread trap7();
    // thread trap8();
    thread trap9();

    // thread toggleearthquakemode();
    // thread topcredits();
    // thread finalstage();
    thread rope1();
    thread rope2();
    thread rope3();
    thread mplat1();
    // thread endmap_p();

    // thread bounce_r();
    // thread bounce_fail();
    // thread sniper_r();
    // thread knife_r();
    // thread mystic_r();
    // thread mystic_fail();

    // addTriggerToList( "trig_trap1" );
    // addTriggerToList( "trig_trap2" );
    // addTriggerToList( "trig_trap3" );
    // addTriggerToList( "trig_trap4" );
    // addTriggerToList( "trig_trap5" );
    // addTriggerToList( "trig_trap6" );
    // addTriggerToList( "trig_trap7" );
    // addTriggerToList( "trig_trap8" );
    // addTriggerToList( "trig_trap9" );
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

		player thread onPlayerSpawned();
    }
}
onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self.rope1 = undefined;
		self.rope2 = undefined;
		self.rope3 = undefined;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

toggleearthquakemode()
{
    trig=getent("earthquakezor","targetname");
    vc=randomint(15);
    if(vc==1||vc==6||vc==9||vc==13)
    {
        trig sethintstring("Call ^1Earthquake^7 Mode");
        trig waittill("trigger");
        // thread earthquakemode();
        trig delete();
    }
    else
        trig delete();
}

earthquakemode()
{
    players=getallplayers();
    for(i=0;i<players.size;i++)
        players[i] thread userEarthquake();
}

userEarthquake()
{
    if(isalive(self) && isdefined(self))
    {
        while(1)
        {
            earthquake(1+randomint(3),1+randomint(3),self.origin,700+randomint(300));
            wait 8+randomint(10);
        }
    }
}

trap1()
{
    trig=getent("trig_trap1","targetname");
    trapa=getent("trap_1a","targetname");
    trapb=getent("trap_1b","targetname");
    trapc=getent("trap_1c","targetname");
    trapd=getent("trap_1d","targetname");

    trig sethintstring("Press ^1[USE]^7 to activate");
    trig waittill("trigger");
    trig delete();

    while(1)
    {
        trapa rotateroll(360,2);
        wait 2;
        trapb rotateroll(360,2);
        wait 2;
        trapc rotateroll(360,2);
        wait 2;
        trapd rotateroll(360,2);
        wait 4+randomint(3);
    }
}

trap2()
{
    trig=getent("trig_trap2","targetname");
    trapa=getent("trap_2a","targetname");
    trapb=getent("trap_2b","targetname");

    // Repair
    level.repair_trig=getent("trap2_repair","targetname");
    level.repair_b0=getent("trap_2r_0","targetname");
    level.repair_b1=getent("trap_2r_1","targetname");
    level.repair_b2=getent("trap_2r_2","targetname");
    level.repair_b3=getent("trap_2r_3","targetname");
    level.repair_b4=getent("trap_2r_4","targetname");

    trapa hide();
    level.repair_b0 hide();
    level.repair_b1 hide();
    level.repair_b2 hide();
    level.repair_b3 hide();
    level.repair_b4 hide();
    trapa notsolid();
    level.repair_b0 notsolid();
    level.repair_b1 notsolid();
    level.repair_b2 notsolid();
    level.repair_b3 notsolid();
    level.repair_b4 notsolid();

   
}

trap2_repair()
{
    repairs=0;
    level.repair_trig sethintstring("Press ^1[USE]^7 to repair the Slap");
    for(;;)
    {
        level.repair_trig waittill("trigger",p);
        if(repairs==0)
        {
            repairs++;
            iprintln("^1"+p.name+"^7 repaired "+repairs+"/5");
            level.repair_b0 show();
        }
        else if(repairs==1)
        {
            repairs++;
            iprintln("^1"+p.name+"^7 repaired "+repairs+"/5");
            level.repair_b1 show();
        }
        else if(repairs==2)
        {
            repairs++;
            iprintln("^1"+p.name+"^7 repaired "+repairs+"/5");
            level.repair_b2 show();
        }
        else if(repairs==3)
        {
            repairs++;
            iprintln("^1"+p.name+"^7 repaired "+repairs+"/5");
            level.repair_b3 show();
        }
        else if(repairs==4)
        {
            repairs++;
            iprintln("^1"+p.name+"^7 repaired "+repairs+"/5");
            level.repair_b4 show();
            level.repair_b0 solid();
            level.repair_b1 solid();
            level.repair_b2 solid();
            level.repair_b3 solid();
            level.repair_b4 solid();
            level.repair_trig delete();
        }
        wait 1; 
    }
}

trap3()
{
    trig=getent("trig_trap3","targetname");
    trig sethintstring("Press ^1[USE]^7 to activate");
    trig waittill("trigger");
    trig delete();  

    if(isdefined(level.ropetim1))
        level.ropetim1 unlink();
    if(isdefined(level.ropetim2))
        level.ropetim2 unlink();
    if(isdefined(level.ropetim3))
        level.ropetim3 unlink();
}

trap4()
{
    trig=getent("trig_trap4","targetname");
    trap=getent("trap_4","targetname");
    trig sethintstring("Press ^1[USE]^7 to activate");
    trig waittill("trigger");
    trig delete(); 
    trap notsolid();
    wait 5+randomint(4);
    trap solid();
}

trap5()
{
    trig=getent("trig_trap5","targetname");
    trap=getent("trap_5","targetname");
    trig sethintstring("Press ^1[USE]^7 to activate");
    trig waittill("trigger");
    trig delete(); 

    while(1)
    {
        trap movey(60,1);
        wait 3;
        trap movey(-60,1);
        wait 6+randomint(4);
    }
}

trap6()
{
    trig=getent("trig_trap6","targetname");
    trapa=getent("trap_6a","targetname");
    trapb=getent("trap_6b","targetname");
    trapc=getent("trap_6c","targetname");
    trapd=getent("trap_6d","targetname");
    trig sethintstring("Press ^1[USE]^7 to activate");
    trig waittill("trigger");
    trig delete(); 

    while(1)
    {
        trapc movey(168,2);
        wait 4+randomint(2);
        trapc movey(-168,2);
        trapb movey(-168,2);
        wait 4+randomint(2);
        trapb movey(168,2);
    }
}

trap7()
{
    trig=getent("trig_trap7","targetname");
    fire=getentarray("trap_7fx","targetname");
    trapa=getent("trap_7","targetname");
    trapb=getent("trap_7b","targetname");
    trig sethintstring("Press ^1[USE]^7 to activate");
    hfx=undefined;
    trapa maps\mp\_utility::triggerOff();
    trapb maps\mp\_utility::triggerOff();
   
}

trap8()
{
    trig=getent("trig_trap8","targetname");
    trapa=getent("trap_8a","targetname");
    trapb=getent("trap_8b","targetname");
    trig sethintstring("Press ^1[USE]^7 to activate");
    trig waittill("trigger");
    trig delete();

    while(1)
    {
        trapa rotateroll(360,2.5);
        trapb rotateroll(-360,2.5);
        wait .1;
    }
}

trap9()
{
    trig=getent("trig_trap9","targetname");
    fire=getentarray("trap_9fx","targetname");
    trapa=getent("trap_9a","targetname");
    trapb=getent("trap_9b","targetname");
    hfx=undefined;
    trig sethintstring("Press ^1[USE]^7 to activate");
    trapa maps\mp\_utility::triggerOff();
    trapb maps\mp\_utility::triggerOff();
   
}

// Moves
rope1()
{
    trig = getEnt ("rope1_trig", "targetname");
    rop1 = getEnt ("rope1_targ1", "targetname");
    rop2 = getEnt ("rope1_targ2", "targetname");
    rop3 = getEnt ("rope1_targ3", "targetname");

	trig sethintstring("Press ^1[USE]^7 to move over");
	
    for(;;)
    {
        trig waittill ("trigger",user);
        if(user istouching(trig) && !isdefined(user.rope1))
        {
			user.rope1 = true;
			thread rope1_ng(user);
		}
    }
}

rope1_ng(user)
{
	trig = getEnt ("rope1_trig", "targetname");
    rop1 = getEnt ("rope1_targ1", "targetname");
    rop2 = getEnt ("rope1_targ2", "targetname");
    rop3 = getEnt ("rope1_targ3", "targetname");

    user sr\api\_player::antiElevator(false);
	
			rope1=spawn("script_model",(5,7,1));
            rope1.origin=user.origin;
            rope1.angles=user.angles;
            user disableweapons();
            wait 0.5;
            user linkto(rope1);
            rope1 moveto(rop1.origin, 1, 0.5, 0.5);
            wait 1.2;
            // user ShellShock("frag_grenade_mp", 5 );
            rope1 moveto(rop2.origin, 2.5, 1, 1 );
            wait 1;
            rope1 moveto(rop3.origin, 2.5, 1, 1 );
            wait 2.7;
            user unlink();
            wait 0.2;
            user EnableWeapons();
            wait 0.1;

        user sr\api\_player::antiElevator(true);
}

rope2()
{
    trig = getEnt ("rope2_trig", "targetname");
    rop1 = getEnt ("rope2_targ1", "targetname");
    rop2 = getEnt ("rope2_targ2", "targetname");
    rop3 = getEnt ("rope2_targ3", "targetname");

	trig sethintstring("Press ^1[USE]^7 to move over");
	
    for(;;)
    {
        trig waittill ("trigger",user);
        level.ropetim2=user;
        if(user istouching(trig) && !isdefined(user.rope2))
        {
			user.rope2 = true;
            user thread rope2_ng(user);
        }
    }
}

rope2_ng(user)
{
	trig = getEnt ("rope2_trig", "targetname");
    rop1 = getEnt ("rope2_targ1", "targetname");
    rop2 = getEnt ("rope2_targ2", "targetname");
    rop3 = getEnt ("rope2_targ3", "targetname");
	
    user sr\api\_player::antiElevator(false);

			rope2=spawn("script_model",(5,7,1));
            rope2.origin=user.origin;
            rope2.angles=user.angles;
            user disableweapons();
            wait 0.5;
            user linkto(rope2);
            rope2 moveto(rop1.origin, 1, 0.5, 0.5);
            wait 1.2;
            // user ShellShock("frag_grenade_mp", 5 );
            rope2 moveto(rop2.origin, 2.5, 1, 1 );
            wait 1;
            rope2 moveto(rop3.origin, 2.5, 1, 1 );
            wait 2.7;
            user unlink();
            wait 0.2;
            user EnableWeapons();
            wait 0.1;

            user sr\api\_player::antiElevator(true);
}

rope3()
{
    trig = getEnt ("rope3_trig", "targetname");
    rop1 = getEnt ("rope3_targ1", "targetname");
    rop2 = getEnt ("rope3_targ2", "targetname");
    rop3 = getEnt ("rope3_targ3", "targetname");

	trig sethintstring("Press ^1[USE]^7 to move over");
	
    for(;;)
    {
        trig waittill ("trigger",user);
        level.ropetim3=user;
        if(user istouching(trig) && !isdefined(user.rope3))
        {
            user.rope3 = true;
			user thread rope3_ng(user);
        }
    }
}

rope3_ng(user)
{
	 trig = getEnt ("rope3_trig", "targetname");
    rop1 = getEnt ("rope3_targ1", "targetname");
    rop2 = getEnt ("rope3_targ2", "targetname");
    rop3 = getEnt ("rope3_targ3", "targetname");

    user sr\api\_player::antiElevator(false);
	
			rope3=spawn("script_model",(5,7,1));
            rope3.origin=user.origin;
            rope3.angles=user.angles;
            user disableweapons();
            wait 0.5;
            user linkto(rope3);
            rope3 moveto(rop1.origin, 1, 0.5, 0.5);
            wait 1.2;
            // user ShellShock("frag_grenade_mp", 5 );
            rope3 moveto(rop2.origin, 2.5, 1, 1 );
            wait 1;
            rope3 moveto(rop3.origin, 2.5, 1, 1 );
            wait 2.7;
            user unlink();
            wait 0.2;
            user EnableWeapons();
            wait 0.1;  
            user sr\api\_player::antiElevator(true);
}

mplat1()
{
    plat=getent("mplat1","targetname");


}

// Others
topcredits()
{
    level endon("intermission");

    if(isDefined(level.topcredits))
        level.topcredits destroy();
 
    level.topcredits = newHudElem();
    level.topcredits.foreground = true;
    level.topcredits.alignX = "center";
    level.topcredits.alignY = "top";
    level.topcredits.horzAlign = "center";
    level.topcredits.vertAlign = "top";
    level.topcredits.x = 4;
    level.topcredits.y = 0;
    level.topcredits.sort = 0;
    level.topcredits.fontScale = 1.8;
    level.topcredits.color = (1,1,1);
    level.topcredits.glowColor = level.sanctuaryglow;
    level.topcredits.glowAlpha = 1;
    level.topcredits.hidewheninmenu = true;
    level.topcredits setText("Deathrun Sanctuary");
    wait 5;
    level.topcredits setText("Made by VC' Blade");
    wait 5;
    level.topcredits setText("Special Thanks to JWofles");
    wait 5;
    level.topcredits setText("visit: vistic-clan.com");
    wait 5;
    level.topcredits.alpha=0;
}

finalstage()
{
    trig=getent("finalstage","targetname");
    trig waittill("trigger",p);
    trig delete();
    p braxi\_rank::giverankxp(undefined,5);
    thread announces(p.name+" has reached the Final Stage",220);
}

announces(msg,pos)
{
    announce=addTextHud(level,320,pos,0,"center","middle",2.4);
    announce settext(msg);
    announce.glowcolor=level.sanctuaryglow;
    announce.glowalpha=1;
    announce.alpha = 1;
    announce setpulsefx(30,100000,700);
    wait 4;
    announce destroy();
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

endmap_p()
{
    trig=getent("end_c","targetname");
    targ=getent("end_o","targetname");
    for(;;)
    {
        trig waittill("trigger",p);

        if(!level.first)
        {
            level.first=true;
            p iprintln("You are able to choose the Room");
            p setorigin(targ.origin);
            p setplayerangles(targ.angles);
            p braxi\_rank::giverankxp(undefined,5);
            p thread endroom_choice();
            first=addTextHud(level,320,240,0,"center","middle",2.4);
            first settext(p.name+" has finished First",240);
            first.glowcolor=level.sanctuaryglow;
            first.glowalpha=1;
            first.alpha = 1;
            first setpulsefx(30,100000,700);
            wait 4;
            first destroy();
        }
        else
        {
            p setorigin(targ.origin);
            p setplayerangles(targ.angles);
        }
    }
}

endroom_choice()
{
    self endon("disconnect");
    self freezecontrols(1);

    self.menu = addTextHudend( self, 750, 50, 0.4, "left", "top", 0, 0, (0,0,0) );  
    self.menu setShader("black", 200, 240);
    
    self.header1 = addTextHudend( self, 760, 55, 1, "left", "top", 1.5, 2, level.sanctuaryglow );
    self.header1 setText("^1E^7ndroom ^1C^7hoice");
    
    self.bar1 = addTextHudend( self, 750, 50, 1, "left", "top", 0, 1, (0,0,0) );    
    self.bar1 setShader("black", 200, 30);
    
    self.bar2 = addTextHudend( self, 750, 290, 1, "left", "top", 0, 1, (0,0,0) );   
    self.bar2 setShader("black", 200, 50);
    
    self.text1 = addTextHudend( self, 760, 290, 1, "left", "top", 1.4, 2, level.sanctuaryglow );
    self.text1 setText("^1[{+attack}]^7: Move down\n^1[{+activate}]^7: Select\n^1>>^7     Vistic Clan     ^1<<");  
    
    self.item1 = addTextHudend( self, 800, 89, 1, "left", "top", 1.4, 3, level.sanctuaryglow ); 
    self.item1 setText("^1S^7niper\n\n^1K^7nife\n\n^1B^7ounce\n\n^1M^7ystic");
    
    self.selector = addTextHudend( self, 780, 90, 0.7, "left", "top", 0, 1, (0,0,0) );  
    self.selector setShader("white", 180, 20);
    self.selector.color=(0.8,0,0);

    self.ischoosing=true;

    move(self.menu, 550, 1);
    move(self.header1, 560, 1);
    move(self.bar1, 550, 1);
    move(self.bar2, 550, 1);
    move(self.text1, 560, 1);
    move(self.item1, 600, 1);
    move(self.selector, 580, 1);
    
    selectorrow = 1;
    
    wait 1;
    
    while(self.ischoosing)
    {
        if(self attackButtonPressed())
        {
            if(selectorrow <= 3)
            {
                self.selector moveOverTime(0.2);
                self.selector.y = (self.selector.y + 33.2);
                wait 0.2;
                selectorrow++;
            }
            else if(selectorrow == 4)
            {
                self.selector moveOverTime(0.3);
                self.selector.y = (89);
                wait 0.3;
                selectorrow = 1;
            }
        }
        if(self useButtonPressed())
        {
            switch(selectorrow)
            {
                case 1:
                    thread announces(self.name+" choosed Sniper End",260);
                    thread openSniper();
                    break;
                case 2:
                    thread announces(self.name+" choosed Knife End",260);
                    thread openKnife();
                    break;
                case 3:
                    thread announces(self.name+" choosed Bounce End",260);
                    thread openBounce();
                    break;
                case 4:
                    thread announces(self.name+" choosed Mystic End",260);
                    thread openMystic();
                    break;
            }
            wait 0.3;

            self destroymenu();
        }
        wait 0.05;
    }     
}
move(hud, xpos, time)
{
    hud moveOverTime(time); hud.x = xpos;
}
destroymenu()
{
    self freezecontrols(0);
    self.ischoosing=false;
    move(self.menu, 750, 0.5);
    move(self.header1, 760, 0.5);
    move(self.bar1, 750, 0.5);
    move(self.bar2, 750, 0.5);
    move(self.text1, 760, 0.5);
    move(self.item1, 800, 0.5);
    move(self.selector, 780, 0.5);      
    wait 1;
    self.menu.alpha=0; self.bar1.alpha=0; self.item1.alpha=0; self.selector.alpha=0; self.bar2.alpha=0; self.text1.alpha=0; self.header1.alpha=0;
}
addTextHudend( who, x, y, alpha, alignX, alignY, fontScale, sort, glowcolor )
{
    if( isPlayer( who ) )
        hud = newClientHudElem( who );
    else
        hud = newHudElem();

    hud.x = x;
    hud.y = y;
    hud.alpha = alpha;
    hud.glowcolor=glowcolor;
    hud.glowalpha=1;
    hud.sort = sort;
    hud.alignX = alignX;
    hud.alignY = alignY;
    if(fontScale != 0)
        hud.fontScale = fontScale;
    return hud;
}

openSniper()
{
    d1=getent("snip_d1","targetname");
    d2=getent("snip_d2","targetname");
    level.picked_fx=getent("snip_fx","targetname");
    gatefx=getent("sniper_gate","targetname");

    earthquake(2,5,level.picked_fx.origin,800);
    d1 movex(-150,6);
    d2 movex(150,6);

    level.end_gate1=spawnfx(level.gateeffect,gatefx.origin);
    triggerfx(level.end_gate1);
    thread snipway_fx();
}
openKnife()
{
    d1=getent("knif_d1","targetname");
    d2=getent("knif_d2","targetname");
    level.picked_fx=getent("snip_fx","targetname");
    gatefx=getent("knife_gate","targetname");

    earthquake(2,5,level.picked_fx.origin,800);
    d1 movey(-150,6);
    d2 movey(150,6);

    level.end_gate2=spawnfx(level.gateeffect,gatefx.origin);
    triggerfx(level.end_gate2);
    thread knifeway_fx();
}
openBounce()
{
    d1=getent("boun_d1","targetname");
    d2=getent("boun_d2","targetname");
    level.picked_fx=getent("snip_fx","targetname");
    gatefx=getent("bounce_gate","targetname");

    earthquake(2,5,level.picked_fx.origin,800);
    d1 movex(-150,6);
    d2 movex(150,6);

    level.end_gate3=spawnfx(level.gateeffect,gatefx.origin);
    triggerfx(level.end_gate3);
    thread bounceway_fx();
}
openMystic()
{
    d1=getent("myst_d1","targetname");
    d2=getent("myst_d2","targetname");
    level.picked_fx=getent("snip_fx","targetname");
    gatefx=getent("myst_gate","targetname");
    statue=getent("torchfire_mystic","targetname");

    earthquake(2,5,level.picked_fx.origin,800);
    d1 movey(-150,6);
    d2 movey(150,6);

    level.end_gate4=spawnfx(level.gateeffect,gatefx.origin);
    level.end_gate5=spawnfx(level.torches,statue.origin);
    triggerfx(level.end_gate4);
    triggerfx(level.end_gate5);
    thread mysticway_fx();
}

sniper_r()
{
    level.sniper=getent("sniper_r","targetname");
    jump=getent("sniper_j","targetname");
    acti=getent("sniper_a","targetname");
    level.roomsong=true;
    level.sniper sethintstring("Enter ^1Sniper ^7End");
    while(1)
    {
        level.sniper waittill("trigger",player);
        if(!isdefined(level.sniper))
            return;
        level.sniper sethintstring("Wait your ^1Turn");
        if(level.roomsong==true)
        {
            ambientstop();
            // ambientplay("sanct_room");
            level.roomsong = false;
        }
        if(isdefined(level.activ))
        {
            player freezecontrols(1);
            level.activ freezecontrols(1);
            player setorigin(jump.origin);
            level.activ setorigin(acti.origin);
            player setplayerangles(jump.angles);
            level.activ setplayerangles(acti.angles);
            player takeallweapons();
            level.activ takeallweapons();
            thread room_msg(player.name+" vs "+level.activ.name);
            wait 5;
            player setroomgun("m40a3_mp","remington700_mp");
            level.activ setroomgun("m40a3_mp","remington700_mp");
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player freezecontrols(1);
            player setorigin(jump.origin);
            player setplayerangles(jump.angles);
            player takeallweapons();
            wait 5;
            player setroomgun("m40a3_mp","remington700_mp");
            player freezecontrols(0);
        }
        while(isalive(player)&&isdefined(player))
            wait 1;
        iprintln("^1"+player.name+"^7 has been killed");
        level.sniper sethintstring("Enter ^1Sniper ^7End");
    }
}

knife_r()
{
    level.knife=getent("knife_r","targetname");
    jump=getent("knife_j","targetname");
    acti=getent("knife_a","targetname");
    level.roomsong=true;
    level.knife sethintstring("Enter ^1Knife ^7End");
    while(1)
    {
        level.knife waittill("trigger",player);
        if(!isdefined(level.knife))
            return;
        level.knife sethintstring("Wait your ^1Turn");
        if(level.roomsong==true)
        {
            ambientstop();
            // ambientplay("sanct_room");
            level.roomsong = false;
        }
        if(isdefined(level.activ))
        {
            player freezecontrols(1);
            level.activ freezecontrols(1);
            player setorigin(jump.origin);
            level.activ setorigin(acti.origin);
            player setplayerangles(jump.angles);
            level.activ setplayerangles(acti.angles);
            player takeallweapons();
            level.activ takeallweapons();
            thread room_msg(player.name+" vs "+level.activ.name);
            wait 5;
            player setroomgun("knife_mp",undefined);
            level.activ setroomgun("knife_mp",undefined);
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player freezecontrols(1);
            player setorigin(jump.origin);
            player setplayerangles(jump.angles);
            player takeallweapons();
            wait 5;
            player setroomgun("knife_mp",undefined);
            player freezecontrols(0);
        }
        while(isalive(player)&&isdefined(player))
            wait 1;
        iprintln("^1"+player.name+"^7 has been killed");
        level.knife sethintstring("Enter ^1Knife ^7End");
    }
}

bounce_r()
{
    level.bounce=getent("bounce_r","targetname");
    jump=getent("bounce_j","targetname");
    acti=getent("bounce_a","targetname");
    level.roomsong=true;
    level.bounce sethintstring("Enter ^1Bounce ^7End");
    while(1)
    {
        level.bounce waittill("trigger",player);
        if(!isdefined(level.bounce))
            return;
        thread bounce_weapon();
        level.bounce sethintstring("Wait your ^1Turn");
        if(level.roomsong==true)
        {
            ambientstop();
            // ambientplay("sanct_room");
            level.roomsong = false;
        }
        if(isdefined(level.activ))
        {
            player freezecontrols(1);
            level.activ freezecontrols(1);
            player setorigin(jump.origin);
            level.activ setorigin(acti.origin);
            player setplayerangles(jump.angles);
            level.activ setplayerangles(acti.angles);
            player takeallweapons();
            level.activ takeallweapons();
            thread room_msg(player.name+" vs "+level.activ.name);
            wait 5;
            player setroomgun("knife_mp",undefined);
            level.activ setroomgun("knife_mp",undefined);
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player freezecontrols(1);
            player setorigin(jump.origin);
            player setplayerangles(jump.angles);
            player takeallweapons();
            wait 5;
            player setroomgun("knife_mp",undefined);
            player freezecontrols(0);
        }
        while(isalive(player)&&isdefined(player))
            wait 1;
        iprintln("^1"+player.name+"^7 has been killed");
        level.bounce sethintstring("Enter ^1Bounce ^7End");
    }
}

mystic_r()
{
    level.mystic=getent("mystic_r","targetname");
    jump=getent("mystic_j","targetname");
    acti=getent("mystic_a","targetname");
    level.roomsong=true;
    level.mystic sethintstring("Enter ^1Mystic ^7End");
    while(1)
    {
        level.mystic waittill("trigger",player);
        if(!isdefined(level.mystic))
            return;
        level.mystic sethintstring("Wait your ^1Turn");
        thread maps\mp\sanctuary\_others::mysticJumper(); 
        thread maps\mp\sanctuary\_others::mysticActivator();
        thread maps\mp\sanctuary\_mystic::magicweapon();
        if(level.roomsong==true)
        {
            ambientstop();
            // ambientplay("mystic_room");
            level.roomsong = false;
        }
        if(isdefined(level.activ))
        {
            player freezecontrols(1);
            level.activ freezecontrols(1);
            player setorigin(jump.origin);
            level.activ setorigin(acti.origin);
            player setplayerangles(jump.angles);
            level.activ setplayerangles(acti.angles);
            player takeallweapons();
            level.activ takeallweapons();
            thread room_msg(player.name+" vs "+level.activ.name);
            wait 5;
            player setroomgun("knife_mp",undefined);
            level.activ setroomgun("knife_mp",undefined);
            player freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            player freezecontrols(1);
            player setorigin(jump.origin);
            player setplayerangles(jump.angles);
            player takeallweapons();
            wait 5;
            player setroomgun("knife_mp",undefined);
            player freezecontrols(0);
        }
        while(isalive(player)&&isdefined(player))
            wait 1;
        iprintln("^1"+player.name+"^7 has been killed");
        level.mystic sethintstring("Enter ^1Mystic ^7End");
    }
}

mystic_fail()
{
    fail=getent("mystic_fail","targetname");
    jump=getent("mystic_j","targetname");
    acti=getent("mystic_a","targetname");
    for(;;)
    {
        fail waittill("trigger",player);
    
        if(player.pers["team"]!="spectator")
        {
            if(player.pers["team"]=="allies")
            {
                player setplayerangles(jump.angles);
                player setorigin(jump.origin);
            }
            if(player.pers["team"]=="axis")
            {
                player setplayerangles(acti.angles);
                player setorigin(acti.origin);
            }
        }
    }
}

bounce_fail()
{
    fail=getent("bounce_fail","targetname");
    jump=getent("bounce_j","targetname");
    acti=getent("bounce_a","targetname");
    for(;;)
    {
        fail waittill("trigger",player);
    
        if(player.pers["team"]!="spectator")
        {
            if(player.pers["team"]=="allies")
            {
                player setplayerangles(jump.angles);
                player setorigin(jump.origin);
            }
            if(player.pers["team"]=="axis")
            {
                player setplayerangles(acti.angles);
                player setorigin(acti.origin);
            }
        }
    }
}

bounce_weapon()
{
    weap=getent("bounce_weap","targetname");
    level.unusedWeap=true;
    while(1)
    {
        weap waittill("trigger",player);

        if(level.unusedWeap)
        {
            level.unusedWeap=false;
            player giverandomweapon();
        }
    }
}

giverandomweapon()
{
    vc=randomint(3);
    switch(vc)
    {
        case 0:
            self giveweapon("m40a3_mp");
            self switchtoweapon("m40a3_mp");
            break;
        case 1:
            self giveweapon("deserteagle_mp");
            self switchtoweapon("deserteagle_mp");
            break;
        case 2:
            self giveweapon("remington700_mp");
            self switchtoweapon("remington700_mp");
            break;
    }
}

room_msg(text)
{
    announce=addTextHud(level,320,280,0,"center","middle",2.4);
    announce settext(text);
    announce.glowcolor=level.sanctuaryglow;
    announce.glowalpha=1;
    announce.alpha = 1;
    announce setpulsefx(30,100000,700);
    wait 3;
    announce destroy();
}

setroomgun(weap,weap2)
{
    if(isdefined(weap))
    {
        self giveweapon(weap);
        self givemaxammo(weap);
    }
    if(isdefined(weap2))
    {
        self giveweapon(weap2);
        self givemaxammo(weap2);
    }
    self switchtoweapon(weap);
}

snipway_fx()
{
    t1=getentarray("sniper_t1","targetname");
    t2=getentarray("sniper_t2","targetname");
    t3=getentarray("sniper_t3","targetname");
    for(i=0;i<t1.size;i++)
    {
        t1[i]=spawnfx(level.torches,t1[i].origin); 
        triggerfx(t1[i]);
    }
    wait 1;
    for(i=0;i<t2.size;i++)
    {
        t2[i]=spawnfx(level.torches,t2[i].origin); 
        triggerfx(t2[i]);
    }
    wait 1;
    for(i=0;i<t3.size;i++)
    {
        t3[i]=spawnfx(level.torches,t3[i].origin); 
        triggerfx(t3[i]);
    }
}

bounceway_fx()
{
    t1=getentarray("bounce_t1","targetname");
    t2=getentarray("bounce_t2","targetname");
    t3=getentarray("bounce_t3","targetname");
    for(i=0;i<t1.size;i++)
    {
        t1[i]=spawnfx(level.torches,t1[i].origin); 
        triggerfx(t1[i]);
    }
    wait 1;
    for(i=0;i<t2.size;i++)
    {
        t2[i]=spawnfx(level.torches,t2[i].origin); 
        triggerfx(t2[i]);
    }
    wait 1;
    for(i=0;i<t3.size;i++)
    {
        t3[i]=spawnfx(level.torches,t3[i].origin); 
        triggerfx(t3[i]);
    }
}

knifeway_fx()
{
    t1=getentarray("knife_t1","targetname");
    t2=getentarray("knife_t2","targetname");
    t3=getentarray("knife_t3","targetname");
    for(i=0;i<t1.size;i++)
    {
        t1[i]=spawnfx(level.torches,t1[i].origin); 
        triggerfx(t1[i]);
    }
    wait 1;
    for(i=0;i<t2.size;i++)
    {
        t2[i]=spawnfx(level.torches,t2[i].origin); 
        triggerfx(t2[i]);
    }
    wait 1;
    for(i=0;i<t3.size;i++)
    {
        t3[i]=spawnfx(level.torches,t3[i].origin); 
        triggerfx(t3[i]);
    }
}

mysticway_fx()
{
    t1=getentarray("myst_t1","targetname");
    t2=getentarray("myst_t2","targetname");
    t3=getentarray("myst_t3","targetname");
    for(i=0;i<t1.size;i++)
    {
        t1[i]=spawnfx(level.torches,t1[i].origin); 
        triggerfx(t1[i]);
    }
    wait 1;
    for(i=0;i<t2.size;i++)
    {
        t2[i]=spawnfx(level.torches,t2[i].origin); 
        triggerfx(t2[i]);
    }
    wait 1;
    for(i=0;i<t3.size;i++)
    {
        t3[i]=spawnfx(level.torches,t3[i].origin); 
        triggerfx(t3[i]);
    }
}