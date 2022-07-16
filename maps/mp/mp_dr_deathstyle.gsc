//Map by CM'Death
//Discord:Death#7416
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
 game["axis_soldiertype"]= "desert";

 thread speedrun\_way_name::create_spawn((124, 542, 1564),0);
  thread speedrun\_way_name::create_normal_way("Normal Way;");
 
   setdvar("g_speed" ,"210");
   setdvar("dr_jumpers_speed" ,"1.12");
   setdvar( "r_specularcolorscale", "1" );
   setdvar("r_glowbloomintensity0",".1");
   setdvar("r_glowbloomintensity1",".1");
   setdvar("r_glowskybleedintensity0",".1");
   setDvar("bg_falldamagemaxheight", 99999);
   setDvar("bg_falldamageminheight", 99998);
   
   addTriggerToList("trig_trap1");
   addTriggerToList("trig_trap2");
   addTriggerToList("trig_trap3");
   addTriggerToList("trig_trap4");
   addTriggerToList("trig_trap5");
    addTriggerToList("trig_trap6");

  if(!isdefined(level.music))
   level.music=[];
    level.music[0]["song"]    ="^3Bangzor - Chillstep";
    level.music[0]["alias"]    ="chillstep";
    level.music[1]["song"]    ="^3Psognar - Leaving You";
    level.music[1]["alias"]    ="leavingyou";
    level.music[2]["song"]    ="^3Miyagi - I Got Love";
    level.music[2]["alias"]    ="igotlove";
    level.music[3]["song"]    ="^3tyDi ft. Sarah Howells - When I Go";
    level.music[3]["alias"]    ="whenigo";
    level.music[4]["song"]    ="^3Anna - Bando";
    level.music[4]["alias"]    ="annabando";
    level.music[5]["song"]    ="^3Machinae - Player One";
    level.music[5]["alias"]    ="playerone";

    precacheItem("ak47_mp");
    precacheItem("deserteagle_mp");
	precacheItem("remington700_mp");
	precacheItem("m40a3_mp");
	precacheItem("knife_mp");
    precacheItem("p90_mp");
    precacheItem("skorpion_mp");
    precacheItem("usp_silencer_mp");
    precacheItem("m4_mp");
    precacheModel("plr_mrh_djskully");
    precacheModel("plr_mrheyley_venom");
    precacheModel("plr_mrh_sedtp");
    precacheshader("mtl_elfgirl_full");
    precacheModel("plr_terry_elfgirl");

    level.vipisplaying = false;
    
   thread starttp();
   thread startplat();
   thread letterend();
   thread arrow();
   thread messages();
   thread mappername();
   thread startfence();
   thread deadsound();

   thread musicbox();
   thread vipmusic();
   thread vipweapon();
   thread RTDitem();
   thread freexp();
   thread freecharacter();
   thread freeweapon();

   thread secretstep();
   thread sectp();
   thread secfinish();
   thread actisectp1();
   thread actisectp2();
   thread actisectp3();
   thread actisectp4();
   thread actisecfail1();
   thread actisecfail2();
   thread actistage3bouncetip();
   thread save_load_logic();

   thread actitp1();
   thread actitp2();
   thread actitp3();
   thread actitp4();

   thread roomselection();
   thread sniperroom();
   thread kniferoom();
   thread bounceroom();
   thread bounceweapon();
   thread bounceroomfailacti();
   thread bounceroomfailjumper();

   thread trap1();
   thread trap2();
   thread trap3();
   thread trap4();
   thread trap5();
   thread trap6();
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

starttp()
{
   trig = getent("trig_starttp", "targetname");
   tele1 = getent ("origin_starttp", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

startplat()
{

   movingplatform = getent("startplat", "targetname");
   movingplatform_trigger = getent("trig_startplat", "targetname");
   
   
   while(1)
   {
   
   movingplatform_trigger waittill ("trigger");
   movingplatform moveZ (2080,3,1,1);
   wait 3;
   movingplatform moveZ (-2080,3,1,1);
   wait 3;
   
   }
}   

letterend()
{
   block1 = getent("letterE","targetname");
   block2 = getent("letterN","targetname");
   block3 = getent("letterD","targetname");
    
	for(;;)
   { 
   wait 0.1;
   block1 rotatepitch (-360,5);
   block2 rotatepitch (360,5);
   block3 rotatepitch (-360,5);
   wait 0.1;
   }
      
} 

arrow()
{
   arrow= getent("arrow2","targetname");
    
	for(;;)
   { 
   arrow moveX (150,3,1,1);
   wait 3;
   arrow moveX (-150,3,1,1);
   wait 3;
   }
      
} 

messages()
{
   wait 5;
   for(;;)
{  
   wait 5;
 x = randomint(7);
   if (x==0)
{
   iPrintln("^0Mapped and scripted by ^3CM'Death");
}

   if (x==1)
{
   iPrintln("^0Visit: ^3teamcmdr^0.^3clanwebsite");
}

   if (x==2)
{
   iPrintln("^3CM'^0Deathrun ^3IP^0: ^3cm^7-^3clan^7.^3com^7:^328960");
}

if (x==3)
{
   iPrintln("^0Feel free to report any ^3bugs.");
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
   iPrintLn("^3There ^0is ^3Jumper Secret ^0and ^3Activator Practise Secret^0.");
}

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
	death settext("^0Map by ^3CM'^0Death");
	death moveOverTime(2); 
	death.x = 5;
	wait 5;
	death moveOverTime(2); 
	death.x = -500;
	wait 11;
	death destroy(); 
}

startfence()
{
   fences = getent("fence","targetname");
 
  fences show();
  fences solid();

wait(15);
	iPrintlnBold( "^3Fence ^0is removing in..." );
	iPrintlnBold( "^05" );
	wait(1);
	iPrintlnBold( "^04" );
	wait(1);
	iPrintlnBold( "^03" );
	wait(1);
	iPrintlnBold( "^02" );
	wait(1);
	iPrintlnBold( "^01" );
	wait(1);
  fences hide();
  fences notsolid();

}  

deadsound()
{   
    trig = getEnt("trig_dead","targetname");

    trig waittill("trigger", player);


  for (;;)
  {
    player playlocalSound("deadsound");
  }

}

musicbox()
{
    level.vipisplaying = false;
    trig = getEnt("trig_musicmenu","targetname");
    trig setHintString("^0Press ^3[&&1]^0 to select ^3Song.");
	if (level.vipisplaying == true)
	{
	return;
	}
	else
	{
    trig waittill("trigger",p);
    trig delete();
    
    p freezeControls(1);
    p musicmenu();
    p braxi\_rank::giveRankXP("", 100);
}
}

musicmenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );
 
    self.hud_music = [];
    self.selection = 0;
 
    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(.7,.7,0);
    
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("^0Deathstyle Music Menu");
    self.hud_music[i].glowalpha = 1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else 
        self.hud_music[i].glowcolor=(.7,.7,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("                                   Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");
 
    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else 
            self.hud_music[i].glowcolor=(.7,.7,0);
 
        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }
 
    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(.7,.7,0);
 
    while(self.sessionstate == "playing")
    {
        wait 0.1;
 
        if(self attackButtonPressed())
        {
            self.hud_music[4+self.selection].alpha = 0.93;
 
            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;
 
            item = self.hud_music[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
             iPrintLn("^7>>^0Now playing: ^3"+level.music[self.selection]["song"]+"^7<<");
			 	level.cambiato = true;
			 
            ambientPlay(level.music[self.selection]["alias"]);
            self freezeControls(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezeControls(0);
           break;
        }
    }
    
    if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}	

///VIP STUFF
vipmusic()
{
	trigger = getEnt ("trig_vipmusic", "targetname");
	trigger setHintString ("^3VIP ^0Area!");
for(;;)
{

	trigger waittill ("trigger", player);
	guid = player getGuid();
guid = getSubStr(guid, 24);
gametag = player.name;

	if ( (isSubStr( toLower(gametag), toLower("CM'")) && !isSubStr( toLower(gametag), toLower("CM'") ) ) || gametag == "CM'Nobody" || gametag == "CoMpy" || gametag == "CM'Bangzor" || gametag == "CM'CoMpy"  || gametag == "Bangzor" || gametag == "Ohh Rexy <3")  
	                   
		{
	iPrintLn("^3VIP ^0is here^3!");
		level.vipisplaying = true;
    	AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("liquid");	
        player braxi\_rank::giveRankXP("", 1000);
		level.vipisplaying = true;	
       trigger delete();
	   }

      else if( isSubStr( toLower(gametag), toLower("Death") ) || gametag == "CM'Death" || gametag == "Death") 
      {
	    AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
	  ambientPlay("waitingtodie");
      player braxi\_rank::giveRankXP("", 2000);
	  iPrintLnBold("^1Death is here!");
	  level.vipisplaying = true;
	  trigger delete();
	  }
	  
		else
		{
			player iPrintLnBold("^0 You are not ^3VIP");
		}
	}
}

vipweapon()
{
	trigger = getEnt ("trig_vipweapon", "targetname");
	trigger setHintString ("^3VIP ^0Area!");
for(;;)
{

	trigger waittill ("trigger", player);
	guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	if ( (isSubStr( toLower(gametag), toLower("CM'")) && !isSubStr( toLower(gametag), toLower("CM'") ) )  || gametag == "Bangzor" || gametag == "CoMpy"  || gametag == "CM'Nobody" || gametag == "CM'Bangzor" || gametag == "CM'CoMpy" || gametag == "Ohh Rexy <3")  
	                   
		{     
        player giveWeapon("p90_mp");
        player giveMaxAmmo("p90_mp");
        player switchToWeapon("p90_mp");
        player setmodel("plr_terry_elfgirl");
       
	   }

      else if( isSubStr( toLower(gametag), toLower("Death") ) || gametag == "CM'Death" || gametag == "Death") 
      {
	    player takeAllWeapons();
        player giveWeapon("p90_mp");
        player giveMaxAmmo("p90_mp");
        player giveWeapon("usp_silencer_mp");
        player giveMaxAmmo("usp_silencer_mp");
        player switchToWeapon("p90_mp");
        player setmodel("plr_mrh_sedtp");
	  
	  }
	  
		else
		{
			player iPrintLnBold("^0 You are not ^3VIP");
		}
	}
}

freecharacter()
{
trig = getent("trig_vipcharacter", "targetname");

   for(;;)
   { 
  trig setHintString ("^3Free Character");
  trig waittill("trigger", player);
  player setmodel("plr_mrh_djskully");
   }
}

freeweapon()
{
trig = getent("trig_freeweapon", "targetname");

   for(;;)
   { 
  trig setHintString ("^3Free Weapon");
  trig waittill("trigger", player);
   
    player giveWeapon("skorpion_mp");
    player giveMaxAmmo("skorpion_mp");
    player switchToWeapon("skorpion_mp");
  
   }
}

RTDitem()
{
trig = getent("trig_itemrtd", "targetname");

   while(1)
   { 
  trig waittill("trigger", player);
   wait 1;
    player iPrintLnBold ("^1Death ^0is giving you a ^1Random Item ^0because he is the best^1.");
  wait 2;
    randomitem = randomint(5);

    if (randomitem == 0)
    {
        player takeAllWeapons();
        player giveWeapon("ak47_mp");
        player switchToWeapon("ak47_mp"); 
        iPrintLn("^3" + player.name + " ^0got ^3ak47 ^1C^2h^3a^4m^5e^6l^7e^8o^9m ^0from ^3RTD^0!");      
    }
    if (randomitem == 1)
    {
        player takeAllWeapons();
        player giveWeapon("deserteagle_mp");  
        player switchToWeapon("deserteagle_mp");  
        iPrintLn("^3" + player.name + " ^0got ^3Desert Eagle ^5Blue Smoke ^0from ^3RTD^0!");     
    }
    if (randomitem == 2)
    {
        player takeAllWeapons();
        player giveWeapon("m4_mp"); 
        player switchToWeapon("m4_mp");  
        iPrintLn("^3" + player.name + " ^0got ^3m4 ^6Hyperbeast ^0from ^3RTD^0!");    
    }
    if (randomitem == 3)
    {  
        player thread braxi\_mod::givelife();
        iPrintLn("^3" + player.name + " ^0got ^1life ^0from ^3RTD^0!");   
    }
    if (randomitem == 4)
    {
        player braxi\_rank::giveRankXP("", 9000);
        iPrintLnBold("^3" + player.name + " ^0won ^3RTD XP Jackpot ^0:^3o"); 
    }
    
    trig delete();
   }
}

freexp()
{ 
    trig = getent("trig_teddyxp", "targetname");
	
for(;;)
{
 trig waittill("trigger", player);
 player braxi\_rank::giveRankXP("", 5000);
 iPrintLn("^3" + player.name + " ^0found some ^3XP^0!");
 trig delete();
 wait 0.5;
}
}

///JUMPER SECRET ROOM
secretstep()
{
    trig = getent("trig_secstep", "targetname");
    caulk = getent("secretstep", "targetname");

    caulk hide();
    caulk notsolid();

for(;;)
{
 trig waittill("trigger", player);
iprintln("^0Secret has been opened.");
    caulk show();
    caulk solid();
    trig delete();
wait 0.5;
}
}

sectp()
{
   trig = getent("trig_sectp", "targetname");
   tele1 = getent ("origin_sectp", "targetname");

   for(;;)
    {   
     trig setHintString ("^3Something...");
     trig waittill("trigger", player);
     player thread secret_timer();
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player.sc_pos = 0;
     player.insec = true;
     iPrintLn ("^3" + player.name + " ^0entered ^3Secret^0!");
     player playlocalSound("myman");
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
     player braxi\_rank::giveRankXP("", 7500);
     player playlocalSound("nicework");
    }
}

save_load_logic()
{
    fail_trigger = getent("trig_fail","targetname");
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

	time = 150; 
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

///ACTIVATOR SECRET
actisectp1()
{
   trig = getent("trig_actisecstage1", "targetname");
   tele1 = getent ("origin_actisecstage1", "targetname");

   for(;;)
    {   
    trig setHintString ("^3You ^0will go ^3somewhere");
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player iPrintLnBold ("^0You entered ^3Stage 1^0.");
     wait 2;
     player iPrintLnBold ("^0Just ^3strafe ^0straight.");
    }
}

actisectp2()
{
   trig = getent("trig_actisecstage2", "targetname");
   tele1 = getent ("origin_actisecstage2", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player iPrintLnBold ("^0You entered ^3Stage 2^0.");
     wait 2;
     player iPrintLnBold ("^0Show me your ^3bounce skills^0.");
    }
}

actisectp3()
{
   trig = getent("trig_actisecstage3", "targetname");
   tele1 = getent ("origin_actisecstage3", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player iPrintLnBold ("^0You entered ^3Stage 3^0.");
     wait 2;
     player iPrintLnBold ("^0I see you became ^3good^0,try to complete this...");
    }
}

actisectp4()
{
   trig = getent("trig_actisecfinish", "targetname");
   tele1 = getent ("origin_actisecfinish", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player iPrintLnBold ("^0Congratulation for finishing ^3Practise Room^0.");
     player braxi\_rank::giveRankXP("", 500);
     iPrintLn ("^3" + player.name + " ^0finished ^3Activator Practise Room^0!");
    }
}

actisecfail1()
{
   trigb = getent("trig_actisecstage2fail", "targetname");
   teleb = getent ("origin_actisecstage2fail", "targetname");

   for(;;)
    {   
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

actisecfail2()
{
   trigb = getent("trig_actisecstage3fail", "targetname");
   teleb = getent ("origin_actisecstage3fail", "targetname");

   for(;;)
    {   
	  trigb waittill("trigger", player);
	  player setOrigin(teleb.origin);
	  player setPlayerAngles (teleb.angles);
    }
}

actistage3bouncetip()
{   
    trig = getEnt("trig_stage3bouncetip","targetname");
    trig setHintString ("^0Recommended ^3fps ^0for the ^3bounce^0(^32-2 1 and Mantle or 32-3^0).");

    trig waittill("trigger", player);

}

///ACTIVATOR TELEPORTS
actitp1()
{
   trig = getent("trig_actitp1", "targetname");
   tele1 = getent ("origin_actitp1", "targetname");

   for(;;)
    {   
    trig setHintString ("^3Teleport to the next Trap!");
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actitp2()
{
   trig = getent("trig_actitp2", "targetname");
   tele1 = getent ("origin_actitp2", "targetname");


   for(;;)
    {   
   trig setHintString ("^3Teleport to the next Trap!");
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actitp3()
{
   trig = getent("trig_actitp3", "targetname");
   tele1 = getent ("origin_actitp3", "targetname");


   for(;;)
    {   
      trig setHintString ("^3Teleport to the next Trap!");
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

actitp4()
{
   trig = getent("trig_actitp4", "targetname");
   tele1 = getent ("origin_actitp4", "targetname");
   
   for(;;)
    {   
     trig setHintString ("^3Teleport to the next Trap!");  
     trig waittill("trigger", player);
     player playlocalSound("tp");
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
    }
}

///ROOMS
roomselection()
{
   trig = getent("trig_roomselection", "targetname");
   tele1 = getent ("origin_roomselection", "targetname");
   trig setHintString ("^0Press ^3[&&1]^0 to enter ^3Room Selection^0!");
   
   while(1)
    {   
    trig setHintString ("^0Press ^3[&&1]^0 to enter ^3Room Selection^0!");
     trig waittill ("trigger", player);
	 player setOrigin(tele1.origin);
     player setPlayerAngles(tele1.angles);
     player takeAllWeapons();
     while (isDefined(player) && isAlive(player))
        wait .05;
    }
}

sniperroom()
{
    level.trigger_scope = getEnt ("trig_sniper", "targetname");

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

bounceroomfailacti()
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

bounceroomfailjumper()
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

waitdead()
{
    activator = GetActivator();
    knife = getent("trig_knife","targetname");
    sniper = getent("trig_sniper","targetname");
    bounce = getent("trig_bounce","targetname");
    knife thread maps\mp\_utility::triggerOff();
    sniper thread maps\mp\_utility::triggerOff();
    bounce thread maps\mp\_utility::triggerOff();
    self common_scripts\utility::waittill_any("death","disconnect");
    activator freezeControls(false);
    self freezeControls(false);
    activator.health = activator.maxhealth;
    knife thread maps\mp\_utility::triggerOn();
    sniper thread maps\mp\_utility::triggerOn();
    bounce thread maps\mp\_utility::triggerOn();
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

///TRAPS
trap1()
{

   mushrooma = getent("trap1a", "targetname");
   mushroomb = getent("trap1b", "targetname");
   trig = getent("trig_trap1", "targetname");
   hurta = getent("trap1_hurta", "targetname");
   hurtb = getent("trap1_hurtb", "targetname");
   hurtc = getent("trap1_hurtc", "targetname");
   hurtd = getent("trap1_hurtd", "targetname");
   trig setHintString("^0Press ^3[&&1] ^0to activate a trap!");
   
   hurta enablelinkto();
   hurta linkto (mushrooma);

   hurtb enablelinkto();
   hurtb linkto (mushroomb);

   hurtc enablelinkto();
   hurtc linkto (mushroomb);

   hurtd enablelinkto();
   hurtd linkto (mushrooma);

   trig waittill ("trigger");
   trig setHintString("^1Activated.");
   
  while (1)
{
    mushrooma moveZ (-520,6);
    wait 3;
    mushrooma moveZ (520,6);
    mushroomb moveZ (-520,6);
    wait 3;
    mushroomb moveZ (520,6);
}

}   


trap2()
{
   plata = getent("trap2a", "targetname");
   platb = getent("trap2b", "targetname");
   trig = getent("trig_trap2", "targetname");
   trig setHintString("^0Press ^3[&&1] ^0to activate a trap!");
   trig waittill ("trigger");
   trig setHintString("^1Activated");
   
   for(;;)
	{
	plata notsolid();
    plata hide();
    platb solid();
    platb show();
	wait 6;
	plata solid();
    plata show();
    platb solid();
    platb show();
	wait 3;
    plata solid();
    plata show();
    platb notsolid();
    platb hide();
    wait 6;
    plata solid();
    plata show();
    platb solid();
    platb show();
	wait 3;
	}
}

trap3()
{

   blocka = getent("trap3a", "targetname");
   blockb = getent("trap3b", "targetname");
   blockc = getent("trap3c", "targetname");
   blockd = getent("trap3d", "targetname");
   blocke = getent("trap3e", "targetname");
   blockf = getent("trap3f", "targetname");
   blockg = getent("trap3g", "targetname");
   trig = getent("trig_trap3", "targetname");
   trig setHintString("^0Press ^3[&&1] ^0to activate a trap!");
   trig waittill ("trigger");
   trig setHintString("^1Activated.");
   
   for(;;)
  { 
   blocka rotateYaw (-360,2);
   blockb rotateYaw (360,2);
   blockc rotateYaw (-360,2);
   blockd rotateYaw (360,2);
   blocke rotateYaw (-360,2);
   blockf rotateYaw (360,2);
   blockg rotateYaw (-360,2);
   wait 5;
   blocka rotateYaw (360,2);
   blockb rotateYaw (-360,2);
   blockc rotateYaw (360,2);
   blockd rotateYaw (-360,2);
   blocke rotateYaw (360,2);
   blockf rotateYaw (-360,2);
   blockg rotateYaw (360,2);
   wait 5;
   }
}   

trap4()
{
   bounce = getent("trap4", "targetname");
   trig = getent("trig_trap4", "targetname");
   trig setHintString("^0Press ^3[&&1] ^0to activate a trap!");
   trig waittill ("trigger");
   trig setHintString("^1Activated");

   
   for(;;)
	{
	bounce notsolid();
    bounce hide();
	wait 4;
	bounce solid();
    bounce show();
	wait 4;
	}
}

trap5()
{

   spikes = getent("trap5", "targetname");
   trig = getent("trig_trap5", "targetname");
   hurta = getent("trap5_hurta", "targetname");
   hurtb = getent("trap5_hurtb", "targetname");
   hurtc = getent("trap5_hurtc", "targetname");
   hurtd = getent("trap5_hurtd", "targetname");
   hurte = getent("trap5_hurte", "targetname");
   trig setHintString("^0Press ^3[&&1] ^0to activate a trap!");
   
   hurta enablelinkto();
   hurta linkto (spikes);

   hurtb enablelinkto();
   hurtb linkto (spikes);

   hurtc enablelinkto();
   hurtc linkto (spikes);

   hurtd enablelinkto();
   hurtd linkto (spikes);

   hurte enablelinkto();
   hurte linkto (spikes);

   trig waittill ("trigger");
   trig setHintString("^1Activated.");
   
  for(;;)
{
    spikes moveZ (-490,2);
    wait 0.4;
    spikes moveZ (490,2);
    wait 0.4;
}

}   

trap6()
{
   plata = getent("trap6a", "targetname");
   platb = getent("trap6b", "targetname");
   trig = getent("trig_trap6", "targetname");
   trig setHintString("^0Press ^3[&&1] ^0to activate a trap!");
   trig waittill ("trigger");
   trig setHintString("^1Activated");
   
   for(;;)
	{
	plata notsolid();
    plata hide();
    platb solid();
    platb show();
	wait 4;
	plata solid();
    plata show();
    platb solid();
    platb show();
	wait 2;
    plata solid();
    plata show();
    platb notsolid();
    platb hide();
    wait 4;
    plata solid();
    plata show();
    platb solid();
    platb show();
	wait 2;
	}
}