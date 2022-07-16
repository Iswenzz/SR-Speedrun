//Map by CM'Death
//Discord:Death#7416
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include braxi\_rank;
main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";

 thread speedrun\_way_name::create_normal_way("Normal Way;");
 thread speedrun\_way_name::create_spawn((-721, 105, -530), 0);
 
   setdvar( "r_specularcolorscale", "1" );
   setdvar("r_glowbloomintensity0",".1");
   setdvar("r_glowbloomintensity1",".1");
   setdvar("r_glowskybleedintensity0",".1");
   setDvar("bg_falldamagemaxheight", 99999);
   setDvar("bg_falldamageminheight", 99998);

   addTriggerToList("trig_trap0");
   addTriggerToList("trig_trap03");
   addTriggerToList("trig_trap1");
   addTriggerToList("trig_trap2");
   addTriggerToList("trig_trap3");
   addTriggerToList("trig_trap4");
   addTriggerToList("trig_trap5");
   addTriggerToList("trig_trap6");
   addTriggerToList("trig_trap7");

   precacheItem("m40a3_mp");
   precacheItem("remington700_mp");
   precacheItem("knife_mp");
   precacheItem("rpg_mp");
   precacheItem("deserteagle_mp");
   precacheItem("beretta_mp");

   level.vipisplaying = false;

   thread messages();
   thread randommusic();
   thread mappername();
   thread deathvip();
   thread king();
   thread master();
   thread sign1();
   thread sign2();
   thread endsign();
   thread cmsign();
   thread arrow();
   thread opendoor();
   thread finaldoor();
   thread finaldoor2a();
   thread finaldoor2b();
   thread secdoor();
   thread teleport1();
   thread teleport2();
   thread teleport3();
   thread teleport4();
   thread first_place();
   thread secret_step1();
   thread actisectp();
   thread save_load_logic();
   thread save_load_logic2();
   thread secfinish();
   thread actisecfinish();
   thread actireturn();
   thread trap0a();
   thread trap0b();
   thread trap1();
   thread trap2();
   thread trap3();
   thread trap4();
   thread trap5();
   thread trap6();
   thread trap7();
   thread sniperroom();
   thread sniperroomfail1();
   thread sniperroomfail2();
   thread kniferoom();
   thread bounceroom();
   thread bounceweapon();
   thread bounceroomfail1();
   thread bounceroomfail2();
   thread simonsaysroom();
   thread purestraferoom();
   thread rpgroom();
   thread rpgroomrespawnacti();
   thread rpgroomrespawnjumper();
}	

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

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
    hud.glowalpha = 0;
    hud.glowcolor = (0.5,0.5,0.5);

    return hud;
}

removeTextActivator()
{
    if( isDefined( self.hud_textacti) )
    {
        self.hud_textacti destroy();
    }
} 

removehudsondeath() {
    self endon ("death");
    self.owner waittill_any("death", "disconnect");
    
    if( isDefined( self ) )
    {
        self destroy();
    }
    
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
        activ = getactivator();
    else
        activ = level.activ.name;

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();

    level.hud_fight = createHUD( 0, 85, "center", "top", 1, "objective", 1.5 );
    level.hud_fight setText("^0" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^0" + jumper + " ^3VS^3 ^0" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}

messages()
{
   wait 10;
   if (!level.vipisplaying)
    AmbientPlay ("10countdown");
   wait 20;
   for(;;)
{  
   wait 8;
 x = randomintrange(0,6);
   if (x==0)
{
   iPrintln("^0Mapped and scripted by ^3CM'Death");
}

   if (x==1)
{
   iPrintln("^0Visit: ^5teamcmdr^0.^5clanwebsite");
}

   if (x==2)
{
   iPrintln("^5CM'^0Deathrun ^7IP^0: ^5cm^7-^5clan^7.^5com^7:^528960");
}

if (x==3)
{
   iPrintln("^0Feel free to report any bugs.");
}

if (x==4)
{
   iPrintln("^0Discord: ^3Death#7416");
}

if (x==5)
{
   iPrintLn("^3Map speed: ^0[^3"+getDvar("g_speed")+"^0]");
}

if (x==6)
{
   iPrintln("^0There is one ^3Acti Secret^0 and two ^3Jumper Secrets^0!");
}

}
}

randommusic()
{
    wait 20;
    randommusic = randomint(8);

    if (level.vipisplaying)
        return;

    if (randommusic == 0 )
    {
        ambientStop(2);
        AmbientPlay("rockstar");       
    }
    if (randommusic == 1)
    {
        ambientStop(2);
        AmbientPlay("bby");       
    }
    if (randommusic == 2)
    {
        ambientStop(2);
        AmbientPlay("oldtown");      
    }
    if (randommusic == 3)
    {
        ambientStop(2);
        AmbientPlay("bhop");     
    }
    if (randommusic == 4)
    {
        ambientStop(2);
        AmbientPlay("astronomia");      
    }
    if (randommusic == 5)
    {
        ambientStop(2);
        AmbientPlay("blue");      
    }
    if (randommusic == 6)
    {
        ambientStop(2);
        AmbientPlay("laserdance");      
    }
    if (randommusic == 7)
    {
        ambientStop(2);
        AmbientPlay("chainhang");       
    }
}

randmusicend()
{
    wait 1;
    endmap = randomint(3);

    if (endmap == 0)
    {
        ambientStop(2);
        AmbientPlay("bangarang");
    }
    if (endmap == 1)
    {
        ambientStop(2);
        AmbientPlay("believer");
    }
    if (endmap == 2)
    {
        ambientStop(2);
        AmbientPlay("satisfaction");  
    }
}

mappername()
{ 
	death = newHudElem();
	death.foreground = true;
	death.alpha = 1;
	death.alignX = "left";
	death.alignY = "middle";
	death.horzAlign = "left";
	death.vertAlign = "middle"; 
	death.x = -400;
	death.y = 0;
	death.sort = 0;
	death.font = "default";
	death.fontScale = 1.4;
	death.hidewheninmenu = false;
	death.glowAlpha = 0;
	death.glowColor = (.7,.5,0);
	death settext("^7Map by ^5CM'^0Death");
	death moveOverTime(2); 
	death.x = 5;
	wait 5;
	death moveOverTime(2); 
	death.x = -500;
	wait 10;
	death destroy(); 
}

deathvip()
{
	trigger = getEnt ("trig_death", "targetname");
	trigger setHintString ("^3Death ^0Access!");
for(;;)
{

	trigger waittill ("trigger", player);
	guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	if ( isSubStr( toLower(gametag), toLower("Death") ) || gametag == "CM'Death" || gametag == "Death")  
	                   
		{
    	ambientStop(2);
		wait 0.5;
		ambientPlay("pyramids");	
        iPrintLnBold("^1Death is here!");
        player braxi\_rank::giveRankXP("", 1000);	
        level.vipisplaying = true;
        trigger delete();
	   }
		else
		{
			player iPrintLnBold("^0 You are not ^3VIP");
		}
	}
}

king()
{ 
    trig = getent("trig_kingslide", "targetname");
	
for(;;)
{
 trig waittill("trigger", player);
 iPrintLnBold("^3" + player.name + " ^0is ^3Pro^0!");
 player braxi\_rank::giveRankXP("", 5000);
 trig delete();
 wait 0.5;
}
}

master()
{ 
    trig = getent("trig_bhop1", "targetname");
	
for(;;)
{
 trig waittill("trigger", player);
 iPrintLnBold("^3" + player.name + " ^0is first on ^3second part^0!");
 player braxi\_rank::giveRankXP("", 1000);
 trig delete();
 wait 0.5;
}
}

sign1()
{
   block = getent("signfinish","targetname");
    
	for(;;)
   { 
   wait 0.1;
   block rotatepitch (-360,6);
   wait 0.1;
   }
      
} 

sign2()
{
   block1 = getent("signob","targetname");
   block2 = getent("signph","targetname");
    
	for(;;)
   { 
   wait 0.1;
   block1 rotatepitch (-360,6);
   block2 rotatepitch (360,6);
   wait 0.1;
   }
      
} 

endsign()
{
   block1 = getent("endmapsign","targetname");
   block2 = getent("endmapsign2","targetname");
   block3 = getent("endmapsign3","targetname");
    
	for(;;)
   { 
   wait 0.1;
   block1 rotatepitch (360,6);
   block2 rotatepitch (-360,6);
   block3 rotateYaw (360,6);
   wait 0.1;
   }
      
} 

cmsign()
{
   block1 = getent("cmsign1","targetname");
   block2 = getent("cmsign2","targetname");
   block3 = getent("cmsign3","targetname");
    
	for(;;)
   { 
   wait 0.1;
   block1 rotateYaw (360,6);
   block2 rotateYaw (360,6);
   block3 rotatepitch (360,6);
   wait 0.1;
   }
      
} 

arrow()
{
   arrow= getent("sign2","targetname");
    
	for(;;)
   { 
   arrow moveX (150,3,1,1);
   wait 3;
   arrow moveX (-150,3,1,1);
   wait 3;
   }
      
} 

opendoor()
{
   door = getent("opendoor","targetname");

   wait 20;
   door moveZ(540, 12);
   wait 30;
}

finaldoor()
{
   finishdoora = getent("finaldoora", "targetname");
   finishdoorb = getent("finaldoorb", "targetname");
   finishdoor_trigger = getent("trig_finaldoor", "targetname");
   
   while(1)
   {

   finishdoor_trigger waittill ("trigger", player);
   finishdoora moveZ (-370, 2);
   finishdoorb moveZ (370, 2);
   iPrintLnBold ("^3" + player.name + " ^0opened ^3FINAL ^0Gate^3!"); 
   player braxi\_rank::giveRankXP("", 1000); 

   finishdoor_trigger delete();   
   }
}

finaldoor2a()
{
   finishdoora = getent("finaldoor2a", "targetname");
   finishdoor_trigger = getent("trig_finaldoor2a", "targetname");
   
   while(1)
   {

   finishdoor_trigger waittill ("trigger", player);
   finishdoora moveZ (-200, 7);

   finishdoor_trigger delete();   
   }
}

finaldoor2b()
{
   finishdoorb = getent("finaldoor2b", "targetname");
   finishdoor_trigger = getent("trig_finaldoor2b", "targetname");
   
   while(1)
   {

   finishdoor_trigger waittill ("trigger", player);
   finishdoorb moveZ (-200, 7);

   finishdoor_trigger delete();   
   }
}

secdoor()
{
   door = getent("secdoor", "targetname");
   trig = getent("trig_secdoor", "targetname");
   
   while(1)
   {
   trig setHintString ("^0Press ^3[&&1]^0 to open ^3Secret Door");
   trig waittill ("trigger", player);
   player iPrintLnBold("^3" + player.name + " ^0found ^3useless shortcut^0!");
   player braxi\_rank::giveRankXP("", 2000);
   door moveZ (200, 6);
   wait 6;

   trig delete();   
   door delete();
   
   }
}

teleport1()
{
   trig = getent("trig_actitp1", "targetname");
   tele1 = getent ("origin_actitp1", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

teleport2()
{
   trig = getent("trig_actitp2", "targetname");
   tele1 = getent ("origin_actitp2", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

teleport3()
{
   trig = getent("trig_roomselection", "targetname");
   tele1 = getent ("origin_roomselection", "targetname");
   trig setHintString ("^0Press ^3[&&1]^0 to enter ^3Room Selection^0!");
   
   while(1)
    {   
     trig waittill ("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     while (isDefined(player) && isAlive(player))
        wait .05;
    }
}

teleport4()
{
   trig = getent("trig_jumperreturn", "targetname");
   tele1 = getent ("origin_jumperreturn", "targetname");

   for(;;)
    {   
     trig setHintString ("^1Press ^3[&&1]^1 to go back on ^3spawn^1!");
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player iPrintLnBold ("^1Good Luck with passing map again^0!");
     player braxi\_rank::giveRankXP("", 2000);
     self thread braxi\_mod::givelife();
    }
}

first_place()
{ 
	trig = getEnt("endmap_trig", "targetname"); 
	
	trig waittill ("trigger",player );

    thread randmusicend();
	firstPlace = newHudElem();
	firstPlace.foreground = true;
	firstPlace.alpha = 1;
	firstPlace.alignX = "left";
	firstPlace.alignY = "middle";
	firstPlace.horzAlign = "left";
	firstPlace.vertAlign = "middle"; 
	firstPlace.x = -400;
	firstPlace.y = 0;
	firstPlace.sort = 0;
	firstPlace.font = "default";
	firstPlace.fontScale = 1.4;
	firstplace.hidewheninmenu = false;
	firstPlace.glowAlpha = 1;
	firstPlace.glowColor = (.3,.0,3);
	firstPlace settext("^3"+ player.name+ " ^0Finished ^3First^0!");
	firstPlace moveOverTime(2); 
	firstPlace.x = 5;
	wait 5;
	firstPlace moveOverTime(2); 
	firstPlace.x = -500;
	wait 7;
	firstPlace destroy(); 
}

secret_step1()
{
	trig = getEnt("trig_secstep1","targetname");
	brush = getEnt("secstep1","targetname");
	brush2 = getEnt("secstep2","targetname");
	brush3 = getEnt("secstep3","targetname");
    brush4 = getEnt("secstep4","targetname");
    brush5 = getEnt("secstep5","targetname");
    brush6 = getEnt("secstep6","targetname");

	brush hide();
	brush notSolid();
	
	brush2 hide();
	brush2 notSolid();

	brush3 hide();
	brush3 notSolid();

    brush4 hide();
	brush4 notSolid();

    brush5 show();
	brush5 Solid();

    brush6 hide();
	brush6 notSolid();

	trig waittill("trigger",player);

	iPrintLn("^7[^3S^7]");

	trig delete();
	brush show();
	brush solid();
    player braxi\_rank::giveRankXP("", 100);

	player thread secret_step2();
}

secret_step2()
{
	trig = getEnt("trig_secstep2","targetname");
	brush = getEnt("secstep2","targetname");

	brush hide();
	brush notSolid();

	trig waittill("trigger",player);

	iPrintLn("^7[^3E^7]");

	trig delete();
	brush show();
	brush solid();
    player braxi\_rank::giveRankXP("", 100);

	player thread secret_step3();
}

secret_step3()
{
	trig = getEnt("trig_secstep3","targetname");
	brush = getEnt("secstep3","targetname");

	brush hide();
	brush notSolid();

	trig waittill("trigger",player);

	iPrintLn("^7[^3C^7]");

	trig delete();
	brush show();
	brush solid();
    player braxi\_rank::giveRankXP("", 100);

	player thread secret_step4();
}


secret_step4()
{
	trig = getEnt("trig_secstep4","targetname");
	brush = getEnt("secstep4","targetname");

	brush hide();
	brush notSolid();

	trig waittill("trigger",player);

	iPrintLn("^7[^3R^7]");

	trig delete();
	brush show();
	brush solid();
    player braxi\_rank::giveRankXP("", 100);

	player thread secret_step5();
}


secret_step5()
{
	trig = getEnt("trig_secstep5","targetname");
	brush = getEnt("secstep5","targetname");

	trig waittill("trigger",player);

	iPrintLn("^7[^3E^7]");

	trig delete();
	
	brush notsolid();
    player braxi\_rank::giveRankXP("", 100);

   player thread secret_step6();

}

secret_step6()
{
	trig = getEnt("trig_secstep6","targetname");
	brush = getEnt("secstep6","targetname");
   brush2 = getEnt("actisecstep","targetname");

	brush hide();
	brush notSolid();

    brush2 show();
	brush2 Solid();

	trig waittill("trigger",player);

   iPrintLn("^7[^3T^7]");
   iPrintLn("^7[^3Secret Opened^0.^7]");

	trig delete();

	brush show();
	brush solid();

    brush2 hide();
	brush2 notsolid();
    player braxi\_rank::giveRankXP("", 200);

	player thread sectp();
}

sectp()
{
   trig = getent("trig_sectp", "targetname");
   tele1 = getent ("origin_sectp", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player playlocalSound("tp");
     player thread secret_timer();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player.insec = true;
     player iPrintLn("^3" + player.name + " ^0entered ^3Secret Room^0!");
    }
}

actisectp()
{
   trig = getent("trig_actisec", "targetname");
   tele1 = getent ("origin_actisec", "targetname");

   for(;;)
    {   
     trig setHintString ("^0Press ^3[&&1]^0 to enter ^3Activator Secret^0.");
     trig waittill("trigger", player);
     player playlocalSound("tp");
     player thread textleft_acti();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player.insec = true;
    }
}

save_load_logic()
{
    fail_trigger = getent("trig_secfail","targetname");
    save_triggers = GetEntArray("save_triggers","targetname");
    
    for(i=0;i<save_triggers.size;i++)
        thread save_pos(save_triggers[i],i);

    while(1)
    {
        fail_trigger waittill("trigger",player);
        player SetOrigin( save_triggers[player.sc_pos].origin+(0,0,50) );
    }
}

save_pos(trig,pos)
{
    while(1)
    {
        trig waittill("trigger",player);
        
        if(!IsDefined(player.sc_pos))
            player.sc_pos = pos;

        else if(IsDefined(player.sc_pos) && player.sc_pos < pos)
        {
            player.sc_pos = pos;
            //IPrintLnBold(pos+" save");
        }

        wait 0.1;
    }
}

save_load_logic2()
{
    fail_trigger = getent("trig_actisecfail","targetname");
    save_triggers2 = GetEntArray("save_triggers2","targetname");
    
    for(i=0;i<save_triggers2.size;i++)
        thread save_pos2(save_triggers2[i],i);

    while(1)
    {
        fail_trigger waittill("trigger",player);
        player SetOrigin( save_triggers2[player.sc_pos].origin+(0,0,50) );
    }
}

save_pos2(trig,pos)
{
    while(1)
    {
        trig waittill("trigger",player);
        
        if(!IsDefined(player.sc_pos))
            player.sc_pos = pos;

        else if(IsDefined(player.sc_pos) && player.sc_pos < pos)
        {
            player.sc_pos = pos;
            //IPrintLnBold(pos+" save");
        }

        wait 0.1;
    }
}

secfinish()
{
   trig = getent("trig_secfinish", "targetname");
   tele1 = getent ("origin_secfinish", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player notify("secret_done");
	 player.secretTimer destroy();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player.insec = false;
     iPrintLnBold ("^3" + player.name + " ^0finished ^3Secret^0!");
     player braxi\_rank::giveRankXP("", 7000);
    }
}

actisecfinish()
{
   trig = getent("trig_actisecfinish", "targetname");
   tele1 = getent ("origin_actisecfinish", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player notify("secret_done");
     player.textleft_acti destroy();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player.insec = false;
     iPrintLn ("^3" + player.name + " ^0finished ^3Activator Secret^0!");
     player braxi\_rank::giveRankXP("", 3000);
    }
}

actireturn()
{
   trig = getent("trig_actireturn", "targetname");
   tele1 = getent ("origin_actisecfinish", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player notify("secret_done");
     player.textleft_acti destroy();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player.insec = false;
    }
}

secret_timer()
{
	self endon("secret_done");
	self endon("death");
	self endon("round_ended");
	self thread destroyOnDeath();
	
	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer = newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
	self.secretTimer.vertAlign = "bottom";
	self.secretTimer.x = 0;
	self.secretTimer.y = -7;
	self.secretTimer.sort = 5;
	self.secretTimer.fontScale = 1.4;
	self.secretTimer.font = "default";
	self.secretTimer.glowAlpha = 0;
	self.secretTimer.hidewheninmenu = true;
	self.secretTimer.label = &"^3Time left: ^0&&1";
	if(isdefined(level.randomcolor))
	self.secretTimer.glowColor = level.randomcolor;
	else 
	self.secretTimer.glowColor = (1,0,0);

	time = 180; 
	for(i=0;i<time;i++)
		{
			self.secretTimer setvalue(time-i);
			wait 1;
		}
		self.secretTimer setvalue(0);
		self suicide();

		if(isdefined(self.secretTimer))
		self.secretTimer destroy();
}

destroyOnDeath()
{

	self waittill("death");

	if(isDefined(self.secretTimer))

	self.secretTimer destroy();
}

destroyOnDeath2()
{

	self waittill_any("death", "trigger");

	if(isDefined(self.hud_textacti))

	self.hud_textacti destroy();
}

textleft_acti() 
{
    self endon ("death");
    self endon ("disconnect");
    self thread destroyOnDeath2();

    self.hud_textacti = newClientHudElem(self);
    self.hud_textacti.alignX = "center";
    self.hud_textacti.alignY = "bottom";
    self.hud_textacti.horzalign = "center";
    self.hud_textacti.vertalign = "bottom";
    self.hud_textacti.alpha = 0.25;
    self.hud_textacti.x = 0;
    self.hud_textacti.y = -7;
    self.hud_textacti.font = "objective";
    self.hud_textacti.fontscale = 1.5;
    self.hud_textacti.glowalpha = 0;
    self.hud_textacti.glowcolor = (0.0, 1.0, 1.0);
    self.hud_textacti.owner = self;
    self.hud_textacti setText("^0Press ^7[^3USE^7] ^0to leave the^3 Activator Secret^7."); 
}

trap0a()
{
   circlea = getent("trap0a", "targetname");
   circleb = getent("trap0b", "targetname");
   button = getent("trap0button", "targetname");
   trig = getent("trig_trap0", "targetname");
   trig setHintString("^3Trap 1");
   trig waittill ("trigger");
   trig setHintString("^1Activated");

   button moveZ (-20,3);
   
   for(;;)
	{
	circlea rotateroll(720, 3);
    circleb rotateroll(-720, 3);
	wait 6;
	circlea  rotateroll(-720, 3);
    circleb  rotateroll(720, 3);
	wait 6;
	}
}

trap0b()
{
   plata = getent("trap03", "targetname");
   button = getent("trap03button", "targetname");
   trig = getent("trig_trap03", "targetname");
   trig setHintString("^3Trap 2");
   trig waittill ("trigger");
   trig setHintString("^1Activated");

   button moveZ(-20,4);
   
   for(;;)
	{
	plata moveZ(-250,4);
    wait 4;
    plata moveZ(250,4);
    wait 4;
	}
}

trap1()
{
   bounce = getent("trap1", "targetname");
   button = getent("trap1button", "targetname");
   trig = getent("trig_trap1", "targetname");
   trig setHintString("^3Trap 3");
   trig waittill ("trigger");
   trig setHintString("^1Activated");

    button moveZ (-20,3);
   
   for(;;)
	{
	bounce notsolid();
    bounce hide();
	wait 2;
	bounce solid();
    bounce show();
	wait 2;
	}
}

trap2()
{
   plata = getent("trap2a", "targetname");
   platb = getent("trap2b4", "targetname");
   platc = getent("trap2c", "targetname");
   platd = getent("trap2c1", "targetname");
   plate = getent("trap2a1", "targetname");
   platf = getent("trap2a2", "targetname");
   platg = getent("trap2a3", "targetname");
   plath = getent("trap2a4", "targetname");
   plati = getent("trap2a5", "targetname");
   platj = getent("trap2b1", "targetname");
   platk = getent("trap2b2", "targetname");
   platl = getent("trap2b3", "targetname");
   button = getent("trap2button", "targetname");
   trig = getent("trig_trap2", "targetname");
   trig setHintString("^3Trap 4");
   trig waittill ("trigger");
   trig setHintString("^1Activated");
   
   plata hide();
   plata notsolid();
   platb hide();
   platb notsolid();
   platc hide();
   platc notsolid();
   platd hide();
   platd notsolid();
   plate hide();
   plate notsolid();
   platf hide();
   platf notsolid();
   platg hide();
   platg notsolid();
   plath hide();
   plath notsolid();
   plati hide();
   plati notsolid();
   platj hide();
   platj notsolid();
   platk hide();
   platk notsolid();
   platl hide();
   platl notsolid();
   button moveZ (-20,3);

}

trap3()
{
   plata = getent("trap3a", "targetname");
   platb = getent("trap3b", "targetname");
   button = getent("trap3button", "targetname");
   trig = getent("trig_trap3", "targetname");
   trig setHintString("^3Trap 5");
   trig waittill ("trigger");
   trig setHintString("^1Activated");

    button moveZ (-20,3);
   
   for(;;)
	{
	plata moveZ(170,3);
    platb moveZ(170,3);
    wait 3;
    plata moveZ(-170,3);
    platb moveZ(-170,3);
    wait 3;
	}
}

trap4()
{
   plata = getent("trap4a", "targetname");
   platb = getent("trap4b", "targetname");
   button = getent("trap4button", "targetname");
   trig = getent("trig_trap4", "targetname");
   trig setHintString("^3Trap 6");
   trig waittill ("trigger");
   trig setHintString("^1Activated");

   button moveZ (-20,3);
   
   for(;;)
   {
   plata hide();
   plata notsolid();
   platb moveX (-350,3,1,1);
   wait 3;
   platb moveX (350,3,1,1);
   wait 3;

   }
}

trap5()
{
   plata = getent("trap5", "targetname");
   button = getent("trap5button", "targetname");
   trig = getent("trig_trap5", "targetname");
   trig setHintString("^3Trap 7");
   trig waittill ("trigger");
   trig setHintString("^1Activated");
   
   plata hide();
   plata notsolid();
   button moveZ (-20,3);

}

trap6()
{
   platforma = getent("trap6a", "targetname");
   platformb = getent("trap6b", "targetname");
   platformc = getent("trap6c", "targetname");
   platformd = getent("trap6d", "targetname");
   platforme = getent("trap6e", "targetname");
   platformf = getent("trap6f", "targetname");
   button = getent("trap6button", "targetname");
   trig = getent("trig_trap6", "targetname");
   trig setHintString("^3Trap 9");
   trig waittill("trigger", player);
   trig setHintString("^1Activated.");

   button moveZ (-20,3);
   
     for(;;)
   {
   platforma rotateYaw (-360,2);
   platformb rotateYaw (360,2);
   platformc rotateroll(-65,10);
   platformd rotateroll(65,10);
   platforme rotateroll(65,10);
   platformf rotateroll(-65,10);
   wait 10;
   platforma rotateYaw (360,2);
   platformb rotateYaw (-360,2);
   platformc rotateroll(65,10);
   platformd rotateroll(-65,10);
   platforme rotateroll(-65,10);
   platformf rotateroll(65,10);
   wait 12;
   }
}

trap7()
{
   plata = getent("trap7a", "targetname");
   platb = getent("trap7b1", "targetname");
   platc = getent("trap7b2", "targetname");
   platd = getent("trap7c", "targetname");
   button = getent("trap7button", "targetname");
   trig = getent("trig_trap7", "targetname");
   trig setHintString("^3Trap 8");
   trig waittill ("trigger");
   trig setHintString("^1Activated");
   
   for(;;)
   {
   plata moveZ (-150, 3);
   platb rotateYaw (-360,3);
   platc rotateYaw (-360,3);
   platd rotatepitch (-90,3);
   button moveZ (-20,3);
   wait 3;
   plata moveZ (150, 3);
   platb rotateYaw (360,3);
   platc rotateYaw (360,3);
   platd rotatepitch (90,3);
   wait 3;

   }
}

waitdead()
{
    activator = GetActivator();
    knife = getent("trig_knife","targetname");
    weapon = getent("trig_weapon","targetname");
    sniper = getent("trig_sniper","targetname");
    bounce = getent("trig_bounce","targetname");
    simonsays = getent("trig_simonsays","targetname");
    rpg = getent("trig_rpg","targetname");
    purestrafe = getent("trig_purestrafe","targetname");
    knife thread maps\mp\_utility::triggerOff();
    weapon thread maps\mp\_utility::triggerOff();
    sniper thread maps\mp\_utility::triggerOff();
    bounce thread maps\mp\_utility::triggerOff();
    simonsays thread maps\mp\_utility::triggerOff();
    rpg thread maps\mp\_utility::triggerOff();
    purestrafe thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    knife thread maps\mp\_utility::triggerOn();
    weapon thread maps\mp\_utility::triggerOn();
    sniper thread maps\mp\_utility::triggerOn();
    bounce thread maps\mp\_utility::triggerOn();
    simonsays thread maps\mp\_utility::triggerOn();
    rpg thread maps\mp\_utility::triggerOn();
    purestrafe thread maps\mp\_utility::triggerOn();
}

endTimerPure(text, duration, extra)
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
        self.endTimerHUD setText("^3" + duration);
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

sniperroom()
{
    level.trigger_scope = getEnt ("trig_scope", "targetname");

    jumpersc = getEnt ("origin_sniperjumper", "targetname");
    actisc = getEnt ("origin_sniperacti", "targetname");

    for(;;)
    {
        level.trigger_scope setHintString ("^0Press ^3[&&1]^0 to enter ^3Sniper Room");
        level.trigger_scope waittill ("trigger", player);

        player thread waitdead();
        activator = GetActivator();
        thread fightHUD("Sniper Room", player, activator);
        player thread endTimerPure("^0Go Go Go !", 3, 0);
        activator thread endTimerPure("^0Go Go Go !", 3, 0);
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

        iPrintLnBold ("^3" + player.name + " ^0has died in ^3Sniper Room!");
    }
}

sniperroomfail1()
{
   trigb = getent("trig_sniperactifail", "targetname");
   teleb = getent ("origin_sniperactifail", "targetname");

   for(;;)
    {   
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

sniperroomfail2()
{
   triga = getent("trig_sniperjumperfail", "targetname");
   telea = getent ("origin_sniperjumperfail", "targetname");

   for(;;)
    {   
      triga waittill("trigger", player);
	  player setOrigin(telea.origin);
	  player setPlayerAngles (telea.angles);
    }
}

kniferoom()
{
   level.trigger_knife = getEnt ("trig_knife", "targetname");

    jumperk = getEnt ("origin_knifejumper", "targetname");
    actik = getEnt ("origin_knifeacti", "targetname");

   for(;;)
    {
        level.trigger_knife setHintString ("^0Press ^3[&&1]^0 to enter ^3Knife Room");
        level.trigger_knife waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
        thread fightHUD("Knife Room", player, activator);
        activator thread endTimerPure("^0Go Go Go !", 3, 0);
        player thread endTimerPure("^0Go Go Go !", 3, 0);
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
        
        iPrintLnBold ("^3" + player.name + " ^0has died in ^3Knife Room!");
    }
}

bounceroom()
{
    level.trigger_jump = getEnt ("trig_bounce", "targetname");

    jumperb = getEnt ("origin_bouncejumper", "targetname");
    actib = getEnt ("origin_bounceacti", "targetname");

    for(;;)
    {
        level.trigger_jump setHintString ("^0Press ^3[&&1]^0 to enter ^3Bounce Room");
        level.trigger_jump waittill ("trigger", player);

        activator = getactivator();
        player thread waitdead();
        thread fightHUD("Jump Room", player, activator);
        activator thread endTimerPure("^0Go Go Go !", 3, 0);
        player thread endTimerPure("^0Go Go Go !", 3, 0);
		player setOrigin (jumperb.origin);
        player setPlayerAngles (jumperb.angles);
        activator setOrigin (actib.origin);
        activator setPlayerAngles (actib.angles);
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
        
        iPrintLnBold ("^3" + player.name + " ^0has died in ^3Jump Room!");
    }
}

bounceweapon()
{
    trig = getEnt ("trig_bounceweapon", "targetname");
    trig setHintString ("^0Press ^3[&&1]^0 to get a ^3Sniper");
    while (1)
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

//JUMP ROOM LOAD POSITION
bounceroomfail1()
{
   trigb = getent("trig_bounceactifail", "targetname");
   teleb = getent ("origin_bounceactifail", "targetname");

   for(;;)
    {   
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

bounceroomfail2()
{
   triga = getent("trig_bouncejumperfail", "targetname");
   telea = getent ("origin_bouncejumperfail", "targetname");

   for(;;)
    {   
      triga waittill("trigger", player);
	  player setOrigin(telea.origin);
	  player setPlayerAngles (telea.angles);
    }
}

simonsaysroom()
{
    level.race = getent("trig_simonsays", "targetname");
	level.race_acti_tp = getent("ss_acti","targetname");
	level.race_jumper_tp = getent("ss_jumper","targetname");

    one = getent("ss_ss_one", "targetname");
	two = getent("ss_ss_two", "targetname");
	tree = getent("ss_ss_tree", "targetname");
	four = getent("ss_ss_four", "targetname");
	five = getent("ss_ss_five", "targetname");
	six = getent("ss_ss_six", "targetname");
	seven = getent("ss_ss_seven", "targetname");
	eight = getent("ss_ss_eight", "targetname");
	nine = getent("ss_ss_nine", "targetname");
	
    one hide();
	two hide();
	tree hide();
	four hide();
	five hide();
	six hide();
	seven hide();
	eight hide();
	nine hide();

	while(1)
    {
    	level.race setHintString ("^0Press ^3[&&1]^0 to enter ^3SimonSays Room");
        level.race waittill( "trigger", player );
    
    if(isDefined(level.actiBusy) && level.actiBusy == 1)
			player iprintlnbold("^6Activator is busy, wait a few seconds");
		else
		{
        if(!isDefined(level.race))
            return;

        if(!isdefined(level.activKills))
			level.playername = player.name;
		
		//player
		player freezeControls(1);
        player setOrigin(level.race_jumper_tp.origin);
		player setPlayerangles(level.race_jumper_tp.angles);
		player TakeAllWeapons();
		player SetClientDVAR("cg_thirdperson", 1);
        player thread endTimerPure("^0Go Go Go !", 3, 0);
		
		//acti
		if (isDefined(level.activ) && isAlive(level.activ))
		{
			level.activ freezeControls(1);
			level.activ setOrigin( level.race_acti_tp.origin );
			level.activ setPlayerangles( level.race_acti_tp.angles );
			level.activ TakeAllWeapons();
			level.activ SetClientDVAR("cg_thirdperson", 1);	
			level.activ thread endTimerPure("^0Go Go Go !", 3, 0);
		}
        thread fightHUD("Simon Says Room", player, level.activ);
		
		wait 3;
		thread ss_game(player);
		thread ss_check(player);
		while( isAlive( player ) && isDefined( player ) )
			wait 0.1;
		level.ss_on = 0;

        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^3" + player.name + " ^0has died in ^3Simon Says Room!");
		}
    }
}

ss_check(player)
{
	trig = getent("ss_losegame", "targetname");
	level.winner = getent("ss_winner", "targetname");
	level.loser = getent("ss_loser", "targetname");
	trig waittill("trigger", loser);
	level.wall hide();
	level.ss_on = 0;

	if (isDefined(level.activ) && loser == level.activ) //jumper wins
	{
		loser freezeControls(1);
		loser setOrigin( level.loser.origin );
		loser setPlayerAngles( level.loser.angles );
		loser iPrintLnBold("^1You have lost!");

		loser giveWeapon("knife_mp");
		loser giveMaxAmmo("knife_mp");
		loser switchToWeapon("knife_mp");

		player freezeControls(1);	
		player setOrigin(level.winner.origin);
		player setPlayerAngles(level.winner.angles);
		player iPrintLnBold("^1You won!");
		player SetClientDVAR("cg_thirdperson", 0);
		wait 4;
		player freezeControls(0);
		
		player giveWeapon("knife_mp");
		player giveMaxAmmo("knife_mp");
		player switchToWeapon("knife_mp");
	}
	else //activator wins
	{
		loser freezeControls(1);
		loser setOrigin(level.loser.origin);
		loser setPlayerAngles(level.loser.angles);
		loser iPrintLnBold("^1You have lost!");

		loser giveWeapon("knife_mp");
		loser giveMaxAmmo("knife_mp");
		loser switchToWeapon("knife_mp");
		
		if (isDefined(level.activ))
		{
			level.activ freezeControls(1);
			level.activ setOrigin( level.winner.origin );
			level.activ setPlayerAngles( level.winner.angles );
			level.activ iPrintLnBold("^1You won!");
			level.activ SetClientDVAR("cg_thirdperson", 0);
			wait 4;
			level.activ freezeControls(0);
						
			level.activ giveWeapon("knife_mp");
			level.activ giveMaxAmmo("knife_mp");
			level.activ switchToWeapon("knife_mp");
		}
		else
			player iPrintLnBold("^1No activator ?!");
	}
}


ss_game(player)
{
    one = getent("ss_one", "targetname");
	two = getent("ss_two", "targetname");
	tree = getent("ss_tree", "targetname");
	four = getent("ss_four", "targetname");
	five = getent("ss_five", "targetname");
	six = getent("ss_six", "targetname");
	seven = getent("ss_seven", "targetname");
	eight = getent("ss_eight", "targetname");
	nine = getent("ss_nine", "targetname");

    ss_one = getent("ss_ss_one", "targetname");
	ss_two = getent("ss_ss_two", "targetname");
	ss_tree = getent("ss_ss_tree", "targetname");
	ss_four = getent("ss_ss_four", "targetname");
	ss_five = getent("ss_ss_five", "targetname");
	ss_six = getent("ss_ss_six", "targetname");
	ss_seven = getent("ss_ss_seven", "targetname");
	ss_eight = getent("ss_ss_eight", "targetname");
	ss_nine = getent("ss_ss_nine", "targetname");

	level.ss_on = 1;
	hide = "";
	level.wall = "";
	time = 0;
	length = 3.5;

	while (level.ss_on == 1)
	{
	    ss_one hide();
		ss_two hide();
		ss_tree hide();
		ss_four hide();
		ss_five hide();
		ss_six hide();
		ss_seven hide();
		ss_eight hide();
		ss_nine hide();

		colour = randomint(9);
		if (colour == 0)
		{
			hide = one;
			level.wall = one;
		    ss_one show();
		}
		if (colour == 1)
		{
			hide = two;
			ss_two show();
			level.wall = two;
		}
		if (colour == 2)
		{
			hide = tree;
			ss_tree show();
			level.wall = tree;
		}
		if (colour == 3)
		{
			hide = four;
			ss_four show();
			level.wall = four;
		}
		if (colour == 4)
		{
			hide = six;
			ss_six show();
			level.wall = six;
		}
		if (colour == 5)
		{
			hide = seven;
			ss_seven show();
			level.wall = seven;
		}
		if (colour == 6)
		{
			hide = five;
			ss_five show();
			level.wall = five;
		}
		if (colour == 7)
		{
			hide = eight;
			ss_eight show();
			level.wall = eight;
		}
		if (colour == 8)
		{
			hide = nine;
			ss_nine show();
			level.wall = nine;
		}

		wait(length);

        one hide();
		two hide();
		tree hide();
		four hide();
		five hide();
		six hide();
		seven hide();
		eight hide();
		nine hide();

		one notsolid();
		two notsolid();
		tree notsolid();
		four notsolid();
		five notsolid();
		six notsolid();
		seven notsolid();
		eight notsolid();
		nine notsolid();

		hide show();
		hide solid();
		level.wall show();

		wait 3;

        one show();
		two show();
		tree show();
		four show();
		five show();
		six show();
		seven show();
		eight show();
		nine show();

		one solid();
		two solid();
		tree solid();
		four solid();
		five solid();
		six solid();
		seven solid();
		eight solid();
		nine solid();

		time += 1;
		length -= 0.25;


        if(time == 14 && isAlive(player))
		{
			player iprintlnbold("^0You finished ^3SimonSays Room ^7, now kill the ^1Activator^7.");
            player setOrigin(level.loser.origin);
            player setPlayerAngles(level.loser.angles);
            player SetClientDVAR("cg_thirdperson", 0);
			level.activ iprintlnbold("^0You finished ^3SimonSays Room ^7, now kill the ^1Jumper^7.");
            level.activ setOrigin( level.winner.origin );
			level.activ setPlayerAngles( level.winner.angles );
            level.activ SetClientDVAR("cg_thirdperson", 0);
			player giveWeapon("knife_mp");
			level.activ giveWeapon("knife_mp");
			player switchToWeapon("knife_mp");
			level.activ switchToWeapon("knife_mp");
			level.wall hide();
			level.ss_on = 0;
		}
	}
}

purestraferoom()
{
   trigger_strafe = getEnt ("trig_purestrafe", "targetname");

    orig_jumper = getEnt ("origin_purejumper", "targetname");
    orig_acti = getEnt ("origin_pureacti", "targetname");

    for(;;)
    {
	    trigger_strafe setHintString ("^0Press ^3[&&1]^0 to enter ^3PureStrafe Room");
        trigger_strafe waittill ("trigger", player);

        player thread waitdead();
        activator = GetActivator();
        
        thread fightHUD("PureStrafe Room", player, activator);
        player thread endTimerPure("^0Go Go Go !", 3, 0);
        activator thread endTimerPure("^0Go Go Go !", 3, 0);
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        activator setPlayerAngles(orig_acti.angles);
        activator setOrigin(orig_acti.origin);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("beretta_mp");
        activator giveWeapon("beretta_mp");
        player switchToWeapon ("beretta_mp");
        activator switchToWeapon("beretta_mp");
        player.maxhealth = 100;
		thread pureend(player, activator);
                       while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^3" + player.name + " ^0has died in ^3PureStrafe Room!");
    }
}

pureend(who, who2)
{
	trig = getEnt ("pureendtp", "targetname");
	origWin = getEnt ("purewinner", "targetname");
	origLose = getEnt ("purelooser", "targetname");
	
	while(1)
	{
		trig waittill("trigger", winner);
		winner setOrigin (origWin.origin);
        winner setPlayerAngles (origWin.angles);
        winner takeAllWeapons();
        winner giveWeapon("deserteagle_mp");
        winner giveMaxAmmo("deserteagle_mp");
        winner switchToWeapon("deserteagle_mp");
		
		if (winner == who)
			loser = who2;
		else
			loser = who;
		
		if (isDefined(loser))
		{
			loser setOrigin (origLose.origin);
			loser setPlayerAngles (origLose.angles);
			loser freezeControls (1);
			loser takeAllWeapons();
		}
	}
}

rpgroom()
{
    level.trigger_rpg = getEnt ("trig_rpg", "targetname");

    jumperr = getEnt ("origin_rpgjumper", "targetname");
    actir = getEnt ("origin_rpgacti", "targetname");

    for(;;)
    {
        level.trigger_rpg setHintString ("^0Press ^3[&&1]^0 to enter ^3RPG Room");
        level.trigger_rpg waittill ("trigger", player);

        player thread waitdead();
        activator = getactivator();
        thread fightHUD("RPG Room", player, activator);
        activator thread endTimerPure("^0Go Go Go !", 3, 0);
        player thread endTimerPure("^0Go Go Go !", 3, 0);
        player setOrigin (jumperr.origin);
        player setPlayerAngles (jumperr.angles);
        activator setOrigin (actir.origin);
        activator setPlayerAngles (actir.angles);
        player takeAllWeapons();
        activator takeAllWeapons();
        player giveWeapon("rpg_mp");
        activator giveWeapon("rpg_mp");
        player giveMaxAmmo("rpg_mp");
        activator giveMaxAmmo("rpg_mp");
        player switchToWeapon("rpg_mp");
        activator switchToWeapon("rpg_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread rpg_ammo();
        activator thread rpg_ammo();
                while(isDefined(player) && isAlive(player))
            wait .05;


        iPrintLnBold ("^3" + player.name + " ^0has died in ^3RPG Room!");
    }
}

rpg_ammo()
{
	self endon("disconnect");
	self endon("death");

	for (;;)
	{
		if (self getCurrentWeapon() == "rpg_mp")
			self giveMaxAmmo("rpg_mp");

		wait 5;
	}
}

rpgroomrespawnacti()
{
   trigb = getent("trig_rpgfailacti", "targetname");
   teleb = getent ("origin_rpgfailacti", "targetname");

   for(;;)
    {   
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
    }
}

rpgroomrespawnjumper()
{
   triga = getent("trig_rpgfailjumper", "targetname");
   telea = getent ("origin_rpgfailjumper", "targetname");

   for(;;)
    {   
      triga waittill("trigger", player);
	  player setOrigin(telea.origin);
    }
}