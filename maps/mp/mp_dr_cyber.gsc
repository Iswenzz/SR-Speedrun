main()
{
	maps\mp\_load::main();
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	setDvar("r_glowbloomintensity0",".25");
    setDvar("r_glowbloomintensity1",".25");
    setDvar("r_glowskybleedintensity0",".3");
	setDvar("bg_falldamagemaxheight", 200000 );
	setDvar("bg_falldamageminheight", 150000 );
	
	
	level.wormhole_fx = LoadFx("deathrun/wormhole");
	level.wormhole2_fx = LoadFx("deathrun/wormhole2");
	level.wingstrail = LoadFx("deathrun/wingstrail");
	
	precacheShader("mtl_darksamus");
	precacheShader("wingstrail");
	precacheShader("cyber2d");
	precacheItem("beretta_cyber_mp");
	precacheShellShock("wormhole");
	precacheShellShock("concussion_grenade_mp");
	precacheShellShock( "jeepride_ridedeath");
	
	level.firstsong = true;
	level.actigap = false;
	level.jumpfinish = false;
	level.pureacti = 0;
	level.purejumper = 0;
	level.ensurance = false;
	
	level.music=[];
    level.music[0]["song"]    ="Porter Robinson - Language";
    level.music[0]["alias"]    ="song1";
    level.music[1]["song"]    ="Brooks - If Only I Could";
    level.music[1]["alias"]    ="song2";
	level.music[2]["song"]    ="IZECOLD - Close";
    level.music[2]["alias"]    ="song3";
	level.music[3]["song"]    ="Echos - Saints";
    level.music[3]["alias"]    ="song4";
	level.music[4]["song"]    ="Tristam - Once Again";
    level.music[4]["alias"]    ="song5";
	level.music[5]["song"]    ="Imagine Dragons - Rise Up";
    level.music[5]["alias"]    ="song6";
	
	level.endsong=[];
    level.endsong[0]["song"]    ="Varien - Valkyrie";
    level.endsong[0]["alias"]    ="end1";
    level.endsong[1]["song"]    ="Dirtyphonics - Sight of Your Soul";
    level.endsong[1]["alias"]    ="end2";
	level.endsong[2]["song"]    ="Varien - Valkyrie (Part II)";
    level.endsong[2]["alias"]    ="end3";
	
	//if(game["roundsplayed"] == 1) iPrintLn("^5[^0Pizzaman-Bot^5]^3: ^2anti ^6xM^5# ^2script v2.3.1 loaded successfully.");
	thread sr\api\_map::createSpawn((417,3420,492),270);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createEndMap((10246.6, -15038, 361.038), 525, 240);
	thread sr\api\_speedrun::createTeleporter((-4683.31, -5898.16, 352.125), 160, 140, (-4684, -6386, 916), 269, "freeze");
	//thread addTestClients();
	thread startdoor();
	//thread messages();
	//thread actifog();
	//thread spinners();
	//thread musicbox();
	//thread ezenter();
    //thread ezrespawn();
	//thread sout();
	//thread ezexit();
	//thread elevator();
	thread startslider();
	thread startslider2();
	thread startslider3();
	//thread stripes();
	thread tunnel();
	thread worm();
	//thread endmover();
	//thread games();
	//thread sniperc();
	//thread deagle();
	//thread knife();
	//thread pure();
	//thread pureendacti();
	//thread pureendjumper();
	//thread streak();
	//thread streakfail();
	//thread streakend();
	//thread room_simonsays();
	//thread bounceroom();
	//thread bouncefail1();
	//thread bouncefail2();
    //thread bouncesniper();
	//thread srespawn();
	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread trap9();
	//thread actitp1();
	//thread actitp2();
	//thread actitp3();
	//thread actitp4();
	thread interenter();
	thread main210();
	thread b210();
	thread c210();
	thread d210();
	thread e210();
	thread f210();
	thread g210();
	thread h210();
	thread secretend210();
	thread cut();
	//thread supremeparser();
	//thread supremeparser2();
	//thread supremeparser3();
	//thread hn();
	//thread pepper();
	//thread vipcheck();
	level.knockback = getDvarInt("g_knockback");
	bounce   = getEntArray("bounce", "targetname");    
    for(i = 0;i < bounce.size;i++)
    bounce[i] thread doublebounce();
	
	addTriggerToList( "trig_trap1" );
	addTriggerToList( "trig_trap2" );
	addTriggerToList( "trig_trap3" );
	addTriggerToList( "trig_trap4" );
	addTriggerToList( "trig_trap5" );
	addTriggerToList( "trig_trap6" );
	addTriggerToList( "trig_trap7" );
	addTriggerToList( "trig_trap8" );
	addTriggerToList( "trap9" );
}
addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
addTestClients()
{
    setDvar("scr_testclients", "");
    wait 1;
    for(;;)
    {
        if(getdvarInt("scr_testclients") > 0)
            break;
        wait 1;
    }
    testclients = getdvarInt("scr_testclients");
    setDvar( "scr_testclients", 0 );
    for(i=0;i<testclients;i++)
    {
        ent[i] = addtestclient();

        if (!isdefined(ent[i]))
        {
            println("Could not add test client");
            wait 1;
            continue;
        }
        ent[i].pers["isBot"] = true;
        ent[i] thread TestClient("autoassign");
    }
    thread addTestClients();
}
TestClient(team)
{
    self endon( "disconnect" );

    while(!isdefined(self.pers["team"]))
        wait .05;
        
    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}	
endsong()
{
	self endon("dark_song");
	if (level.firstsong == true)
	{
	AmbientStop(3);
	MusicStop(3);
	AmbientStop(0);
	MusicStop(0);
	x = randomInt(level.endsong.size);
	ambientPlay(level.endsong[x]["alias"]);
	iPrintLn("^1>>> ^1Now playing:^5 "+level.endsong[x]["song"]+" ^1<<<");
	level.firstsong = false;
	}
}	
startdoor()
{
kek = getDvar("sv_hostname");
//thread removeAssFromString(kek);
door = getEnt("startdoor", "targetname");
wait 1;
if (isSubStr( toLower(kek), toLower("xM")) || isSubStr( toLower(kek), toLower("Nice*") ))
	{
		iPrintLnBold ("^1KYS ^6RAKY");
		wait 2;
		exitLevel(true);
	}
	else {
door delete();
iprintlnbold("^5Start door opened.");
wait 2;
	if (level.cambiato == false)
 {
  //thread songs(); 
  level.cambiato = true;
 }
 wait 6;
}
}

messages()
{
wait 10;
//iprintlnBold("^5Cyber");
wait 5;
iPrintln("^5Map made by DarkSTEP");
for(;;)
{
wait 35;
x=randomint(10);
if (x==0)
{
iPrintln("^5Map made by DarkSTEP");
}

if (x==1)
{
iPrintln("^5There are 2 jumper secrets, ^2Easy ^5and ^4Inter^5!");
}

if (x==2)
{
iPrintln("^5This shit took ^12^5 months of work so i hope it's worth it :)");
}

if (x==3)
{
iPrintln("^5Secrets have an antiglitch system so (don't) try to shortcut ;)");
}

if (x==4)
{
iPrintln("^1Steam: ^5CAR ^0DarkSTEP");
}

if (x==5)
{
iPrintln("^5Feel free to report bugs");
}

if (x==6)
{
iPrintln("^5Feel free to join us on ^1xenia-gaming.net");
}

if (x==7)
{
iPrintln("^5Discord: DarkSTEP#7390");
}

if (x==8)
{
iPrintln("^5Special thanks to ^1VC'ERIK ^5for ^2the portal fx ^5:)");
}

if (x==9)
{
iPrintln("^5After a room fight your ^2health^5 will be restored");
}

}
}	

songs()
{
level notify("music_changed");
x=randomint(6);
if (x==0)
{
ambientPlay("song1");
iPrintln("^2>>^1Now playing: ^5Porter Robinson - Language^2<<");
}

if (x==1)
{
ambientPlay("song2");
iPrintln("^2>>^1Now playing: ^5Brooks - If Only I Could^2<<");
}

if (x==2)
{
ambientPlay("song3");
iPrintln("^2>>^1Now playing: ^5IZECOLD - Close^2<<");
}

if (x==3)
{
ambientPlay("song4");
iPrintln("^2>>^1Now playing: ^5Echos - Saints^2<<");
}

if (x==4)
{
ambientPlay("song5");
iPrintln("^2>>^1Now playing: ^5Tristam - Once Again^2<<");
}

if (x==5)
{
ambientPlay("song6");
iPrintln("^2>>^1Now playing: ^5Imagine Dragons - Rise Up^2<<");
}

}

spinners()
{
	a = getEnt("spinners","targetname");
	level waittill("round_started");
	for(;;)
	{
		a rotateYaw(-360, 10);
		wait 10;
	}
}
elevator()
{
	a = getEnt("elevator","targetname");
	trig = getEnt("trig_elevator","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		wait 1.5;
		a moveZ(504, 1.5);
		a waittill("movedone");
		wait 2;
		a moveZ(-504, 1.5);
		a waittill("movedone");
		wait 2;
	}
}

doublebounce()
{
    for(;;)
    {
    self waittill("trigger", player);
    
    if(!isDefined(player.bouncing))
    player thread player_bounce(self);
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
	self.oldO = self.origin;
	//self iPrintLnBold("Bounce "+self.bouncecount);
    self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", self.origin, (0,0,1) , "none", 0);
    wait 0.05;
    setDvar("g_knockback", level.knockback);
    self.health    = health;
    self.maxhealth = maxHealth;
    while(self isTouching(trigger))
    wait 0.05;
	distance = distance2d( self.oldO, self.origin );
	if (distance > 6)
	{
	self.bounceCount++;
	}
    self.bouncing = undefined;
}
startslider()
{
	slider = getEntArray("rightslider", "targetname");
	level.o_slider = slider[0].origin;
	for (i = 0; i < slider.size; i++) //13 BLOCKS
	{
		slider[i] thread rightslider();
		wait 1.5;
	}
}
startslider2()
{
	slider = getEntArray("leftslider", "targetname");
	level.o_slider2 = slider[0].origin;
	for (i = 0; i < slider.size; i++) //13 BLOCKS
	{
		slider[i] thread leftslider();
		wait 1.5;
	}
}
startslider3()
{
	slider = getEntArray("rightslider2", "targetname");
	level.o_slider3 = slider[0].origin;
	for (i = 0; i < slider.size; i++) //13 BLOCKS
	{
		slider[i] thread rightslider2();
		wait 1.5;
	}
}
stripes()
{
	level.o_stripes = getEntArray("o_stripes", "targetname");
	a = getEntArray("stripes", "targetname");
	level.currentOrigin = level.o_stripes[0].origin;
	for(i = 0; i < a.size; i++)
	{
		level.stripesx = randomInt(level.o_stripes.size - 1);
		level.currentOrigin = level.o_stripes[level.stripesx].origin;
		a[i] moveTo(level.currentOrigin, .1);
		wait .1;
		a[i] thread stripesmover();
		wait 1;
	}
}
stripesmover()
{
	for(;;)
	{
		wait .1;
		self moveX(-20000, 16);
		wait 16;
		x = randomInt(level.o_stripes.size - 1);
		while (x == level.stripesx)	
		{
			x = randomInt(level.o_stripes.size - 1);
		}
		self.origin = level.o_stripes[x].origin;
	}
}
leftslider()
{
	while(1)
	{			  //-3350
		self moveX(3830, 15);
		wait 15;
		self.origin = level.o_slider2;
	}
}   
rightslider()
{
	while(1)
	{			  //-3350
		self moveX(-3830, 15);
		wait 15;
		self.origin = level.o_slider;
	}
} 
rightslider2()
{
	while(1)
	{			  //-3350
		self moveX(-3830, 15);
		wait 15;
		self.origin = level.o_slider3;
	}
} 
musicbox()
{
    level.cambiato = false;
    trig = getEnt("musictrigger","targetname");
    trig setHintString("^5Press ^7&&1 ^5to select song");
	if (level.cambiato == true)
	{
	return;
	}
	else
	{
    trig waittill("trigger",p);
	p braxi\_rank::giveRankXP("", 150);
	if(isDefined(trig))trig delete();
    
    p freezeControls(1);
    p musicmenu();
}
}

musicmenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );
	self endon( "music_changed" );
 
    self.hud_music = [];
    self.selection = 0;
 
    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "cyber2d", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(0,.6,.8);
    
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Cyber Music Menu");
    self.hud_music[i].glowalpha = 1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else 
        self.hud_music[i].glowcolor=(0,.6,.8);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("                                   Scroll: ^5[{+attack}] ^7| Select: ^5[{+activate}] ^7| Close: ^5[{+frag}]");
 
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
            self.hud_music[i].glowcolor=(0,.6,.8);
 
        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }
 
    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(0,.6,.8);
 
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
             iPrintLn("^2>>^1Now playing: ^5"+level.music[self.selection]["song"]+"^2<<");
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

ezenter()
{
	trig = getEnt("trig_ezenter", "targetname");
	arrivo = getEnt("o_ezenter", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
	secret_stop = "secret_stop";
	player thread secret_hud();
	player thread playerGone(secret_stop);
  }
}
ezrespawn()
{
	trig = getEnt("trig_ezrespawn", "targetname");
	arrivo = getEnt("o_ezenter", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
  }
}
sout()
{
	trig = getEnt("trig_sout", "targetname");
	arrivo = getEnt("o_sout", "targetname");
	trig setHintString("Press ^5F^7 to go back");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
	player notify("secret_stop");
	player.secretTimer destroy();
	player iPrintLnBold("^5ok then");
  }
}
ezexit()
{
	trig = getEnt("trig_ezexit", "targetname");
	arrivo = getEnt("o_ezexit", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
	player braxi\_rank::giveRankXP("", 500);
	player notify("secret_stop");
	player.secretTimer destroy();
  }
}
secret_hud()
{
    self endon("secret_stop");
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
    self.secretTimer.fontScale = 1.9;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = false;
    self.secretTimer.label = &"^5Time left: ^1&&1";
    self.secretTimer.glowColor=(0,.7,.9);
	self.secretTimer.alpha = 0;
	self.secretTimer fadeoverTime(2);
	self.secretTimer.alpha = 1;
    time= 90;
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    wait 4;
}
inter_hud()
{
    self endon("secret_stop");
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
    self.secretTimer.fontScale = 1.9;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = false;
    self.secretTimer.label = &"^5Time left: ^1&&1";
    self.secretTimer.glowColor=(0,.7,.9);
	self.secretTimer.alpha = 0;
	self.secretTimer fadeoverTime(2);
	self.secretTimer.alpha = 1;
    time = 120;
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    wait 4;
} 
playerGone(noty)
{
    self playerOnDeath(noty);
    self playerOnDisconnect(noty);
    self playerOnSpawned(noty);
    self playerOnSpectators(noty);
    wait 0.5;
} 
playerOnDeath(noty)
{
    self waittill("death");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
} 
playerOnDisconnect(noty)
{
    self waittill("disconnect");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
playerOnSpawned(noty)
{
    self waittill("spawned");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
playerOnSpectators(noty)
{
    self waittill("joined_spectators");
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
}
actifog()
{
	trig = getEnt("trig_actifog", "targetname");
	trig waittill("trigger", player);
	trig delete();
	player setClientDvar("r_fog", 0 );
	level.activKills = 0;
	player.isActi = 1;
}
tunnel()
{
	trig = getEnt("trig_tunnel", "targetname");
	arrivo = getEnt("o_tunnel", "targetname");
	end = getEnt("o_wormend", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player shellShock("concussion_grenade_mp", 1.2);
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
	player playSound("tp");
	player thread tunnelmover(end);
  }
}
tunnelmover(end)
{
	visionSetNaked( "mp_dr_moonsday_r", .1 );
	air = spawn("script_model",(0,0,0));
	self linkTo(air);
	self playSound("wormhole");
	self shellShock("wormhole", 10);
	thread cyber_hud_removing(self);
	air moveX(18800, 10);
	wait 10;
	self unlink();
	air delete();
	visionSetNaked( "mp_dr_cyber", .1 );
	self playSound("tp");
	self setOrigin(end.origin);
	self SetPlayerAngles(end.angles);
	self shellShock("concussion_grenade_mp", 1.2);
}
worm()
{	
	trig = getEnt("trig_wormfx", "targetname");
	o = getEntArray("o_wormfx", "targetname");
	o2 = getEntArray("o_wormfx2", "targetname");
		trig waittill("trigger", player);
		for (i = 0; i < o.size; i++)
		{
			PlayFX(level.wormhole_fx, o[i].origin);
		}
		for (i = 0; i < o2.size; i++)
		{
			PlayFX(level.wormhole2_fx, o2[i].origin);
		}
		for(;;)
		{
			o[0] playSound("wormsound");
			o[1] playSound("wormsound");
			wait .5;
		}
}	
cyber_hud_removing(player)
{
	player setClientDvar( "cg_draw2d", 0 );
	player setClientDvar( "cg_drawfps", 0 );
	wait .5;
	player setClientDvar( "cg_draw2d", 1 );
	player setClientDvar( "cg_drawfps", 1 );
	wait .5;
	player setClientDvar( "cg_draw2d", 0 );
	player setClientDvar( "cg_drawfps", 0 );
	wait .5;
	player setClientDvar( "cg_draw2d", 1 );
	player setClientDvar( "cg_drawfps", 1 );
	wait .5;
	player setClientDvar( "cg_draw2d", 0 );
	player setClientDvar( "cg_drawfps", 0 );
	wait .5;
	player setClientDvar( "cg_draw2d", 1 );
	player setClientDvar( "cg_drawfps", 1 );
	wait .5;
	player setClientDvar( "cg_draw2d", 0 );
	player setClientDvar( "cg_drawfps", 0 );
	wait 4;
	player setClientDvar( "cg_draw2d", 1 );
	player setClientDvar( "cg_drawfps", 1 );
	wait .5;
	player setClientDvar( "cg_draw2d", 0 );
	player setClientDvar( "cg_drawfps", 0 );
	wait .5;
	player setClientDvar( "cg_draw2d", 1 );
	player setClientDvar( "cg_drawfps", 1 );
	wait .5;
	player setClientDvar( "cg_draw2d", 0 );
	player setClientDvar( "cg_drawfps", 0 );
	wait .5;
	player setClientDvar( "cg_draw2d", 1 );
	player setClientDvar( "cg_drawfps", 1 );
	wait 1;
}
endmover()
{
	trig = getEnt("trig_mover", "targetname");
	l = getEnt("leftmover", "targetname");
	lb = getEnt("leftmoverbar", "targetname");
	r = getEnt("rightmover", "targetname");
	rb = getEnt("rightmoverbar", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	wait 1;
	l moveY (564, 1);
	l moveX (208, 1);
	r moveY (564, 1);
	r moveX (-208, 1);	
	lb moveY (564, 1);
	lb moveX (208, 1);
	lb moveZ (-768, 1);
	rb moveY (564, 1);
	rb moveX (-208, 1);
	rb moveZ (-768, 1);
	wait 1.1;
	l moveY (1040, 2);
	r moveY (1040, 2);
	wait 2.1;
	
	/////////// back
	wait 2;
	l moveY (-1040, 2);
	r moveY (-1040, 2);
	wait 2.1;
	l moveY (-564, 1);
	l moveX (-208, 1);
	r moveY (-564, 1);
	r moveX (208, 1);	
	lb moveY (-564, 1);
	lb moveX (-208, 1);
	lb moveZ (768, 1);
	rb moveY (-564, 1);
	rb moveX (208, 1);
	rb moveZ (768, 1);
	wait 1.1;
	wait 2;
  }
}
games() 
{
level.games_trig = getEnt( "trig_endselector", "targetname");
games = getEnt( "o_endselector", "targetname" );

while(1)
{
level.games_trig waittill( "trigger", player );
if( !isDefined( level.games_trig ) )
return;

iPrintlnBold( " ^5" + player.name + " is picking a room" );
player.isActi = 0;
	player SetPlayerAngles( games.angles );
player setOrigin( games.origin );
player TakeAllWeapons();
player antiglitcher();
activator = getActivator();
activator.isActi = 1;
activator setClientDvar("r_fog", 1 );
level.entered = true;
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

antiglitcher() 
{ 
self common_scripts\utility::waittill_any("death","disconnect");
level.activKills++;
thread killstreak();
self.hasGun = 0;
self freezeControls(0);
iPrintlnBold("^5"+self.name+" ^1died");
wait 0.2; 
iPrintlnBold("^5Room selection open!"); 
}
funnyshit( nickname ) 
{
	players = getallnabs();
	for ( i = 0; i < players.size; i++ )
		if ( isSubStr( toLower(removeAssFromString(players[i].name)), toLower(nickname) ) ) 
			return players[i];
}
removeAssFromString( string )
{
	output = "";

	for ( i = 0; i < string.size; i++ )
	{
		if ( string[i] == "^" )
		{
			if ( i < string.size - 1 )
			{
				if ( string[i + 1] == "0" || string[i + 1] == "1" || string[i + 1] == "2" || string[i + 1] == "3" || string[i + 1] == "4" ||
					 string[i + 1] == "5" || string[i + 1] == "6" || string[i + 1] == "7" || string[i + 1] == "8" || string[i + 1] == "9" )
				{
					i++;
					continue;
				}
			}
		}

		output += string[i];
	}

	return output;
}

getallnabs()
{
	return getEntArray( "player", "classname" );
}
killstreak()
{
	activator = GetActivator();
	if(isdefined(level.activKills))
			level.streak setText("^1Activator's killstreak: ^2"+level.activKills);

		if(level.activKills == 1)
		{
		level.streak = newHudElem();
		level.streak.foreground = true;
		level.streak.alignX = "left";
		level.streak.alignY = "middle";
		level.streak.horzAlign = "left";
		level.streak.vertAlign = "middle";
		level.streak.x = 4;
		level.streak.y = 8;
		level.streak.sort = 0;
		level.streak.fontScale = 1.8;
		level.streak.glowColor = (0,.4,1);
		level.streak.glowAlpha = 1;
		level.streak.hidewheninmenu = true;
		level.streak setText("^1Activator's killstreak: ^2"+level.activKills);
		level waittill("round_ended");
		if (isDefined(level.streak))
			{
				level.streak destroy();
			}
		}
		
		if(level.activKills == 3)
		{
			activator iprintLnBold("^1You got a ^2Life!");
			activator braxi\_mod::giveLife();
		}


		if(level.activKills == 5)
		{
			activator iprintLnBold("^2You got another ^2Life!");
			activator braxi\_mod::giveLife();
		}	
}
waitdead()
{
weapons = getent("deagle_trig","targetname");
bounce = getent("bounce_trig","targetname");
sniper = getent("sniperc_trig","targetname");
knife = getent("knife_trig","targetname");
streak = getent("trig_streak","targetname");
pure = getent("trig_pure","targetname");
simon = getent("trig_simon","targetname");
weapons thread maps\mp\_utility::triggerOff();
bounce thread maps\mp\_utility::triggerOff();
sniper thread maps\mp\_utility::triggerOff();
knife thread maps\mp\_utility::triggerOff();
streak thread maps\mp\_utility::triggerOff();
pure thread maps\mp\_utility::triggerOff();
simon thread maps\mp\_utility::triggerOff();
activator = GetActivator();
activator setClientDvar("r_fog", 1 );
self common_scripts\utility::waittill_any("death","disconnect");
activator.isActi = 1;
activator setClientDvar("r_fog", 1 );
activator freezeControls(false);
self freezeControls(false);
activator.hasGun = 0;
activator.health = activator.maxhealth;
if(isDefined(level.streak)) level.streak destroy();
weapons thread maps\mp\_utility::triggerOn();
bounce thread maps\mp\_utility::triggerOn();
sniper thread maps\mp\_utility::triggerOn();
knife thread maps\mp\_utility::triggerOn();
streak thread maps\mp\_utility::triggerOn();
pure thread maps\mp\_utility::triggerOn();
simon thread maps\mp\_utility::triggerOn();
level.actigap = false;
level.jumpfinish = false;
level.pureacti = 0;
level.purejumper = 0;
}
sniperc() //replaced
{
sniper = getent("sniperc_trig","targetname");
level.o_sniper1 = getent("o_sniper1","targetname");
level.o_sniper2 = getent("o_sniper2","targetname");
sniper setHintString("^1Sniper");
for(;;)
{
	sniper waittill("trigger", player);
	level notify("end");
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(level.o_sniper1.origin);
	player setPlayerAngles(level.o_sniper1.angles);
	activator freezeControls(true);
	activator setorigin(level.o_sniper2.origin);
	activator setPlayerAngles(level.o_sniper2.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("m40a3_mp");
	activator giveweapon("m40a3_mp");
	player giveweapon("remington700_mp");
	activator giveweapon("remington700_mp");
	thread createhud(player.name + " ^5selected ^1Sniper ^5room!");
	level notify("music_changed");
	thread endsong();
	wait 5;
	player iprintlnbold("^8FIGHT!");
	activator iprintlnbold("^9FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("m40a3_mp");
	activator switchtoweapon("m40a3_mp");
	player givemaxammo("m40a3_mp");
	activator givemaxammo("m40a3_mp");
	}
}
srespawn()
{
	bouncejumperfail = getEnt("trig_srespawn", "targetname");
	
	for (;;)
	{
		bouncejumperfail waittill("trigger", player);
		if (player.isActi == 1)
		{
		player setOrigin(level.o_sniper2.origin);
		player setPlayerAngles(level.o_sniper2.angles);
		}
		else
		{
		player setOrigin(level.o_sniper1.origin);
		player setPlayerAngles(level.o_sniper1.angles);
		}
	}
}
deagle() //replaced
{
deagle = getent("deagle_trig","targetname");
deagle setHintString("^3Deagle");
for(;;)
{
	deagle waittill("trigger", player);
	level notify("end");
	//old delete();
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(level.o_sniper1.origin);
	player setPlayerAngles(level.o_sniper1.angles);
	activator freezeControls(true);
	activator setorigin(level.o_sniper2.origin);
	activator setPlayerAngles(level.o_sniper2.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("deserteagle_mp");
	activator giveweapon("deserteagle_mp");
	thread createhud(player.name + " ^5selected ^3Deagle ^5room!");
	thread endsong();
	level notify("music_changed");
	wait 5;
	player iprintlnbold("^8FIGHT!");
	activator iprintlnbold("^9FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("deserteagle_mp");
	activator switchtoweapon("deserteagle_mp");
	player givemaxammo("deserteagle_mp");
	activator givemaxammo("deserteagle_mp");
	}
}
trap1()
{
	trig = getEnt("trig_trap1", "targetname");
	a = getEnt("trap1a", "targetname");
	b = getEnt("trap1b", "targetname");
	c = getEnt("trap1c", "targetname");
	d = getEnt("trap1d", "targetname");
	e = getEnt("trap1e", "targetname");
	trig setHintString("Puke time!");
	trig waittill("trigger", player);
	trig setHintString("^1Activated");
	for(;;)
	{
		a rotateYaw(-720, 3);
		b rotateYaw(720, 3);
		wait 3;
		wait 2;
		c rotateYaw(720, 3);
		wait 3.1;
		c rotateYaw(-720, 3);
		wait 3.1;
		wait 2;
		d rotateYaw(720, 3);
		e rotateYaw(-720, 3);
		wait 3;
		wait 4;
	}
}
knife() //replaced
{
knife = getent("knife_trig","targetname");
jumper = getent("o_knife1","targetname");
acti = getent("o_knife2","targetname");
knife setHintString("^2Knife");
for(;;)
{
	knife waittill("trigger", player);
	level notify("end");
	player thread waitdead();
	activator = GetActivator();
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
	thread createhud(player.name + " ^5entered ^2Knife ^5room!");
	thread endsong();
	level notify("music_changed");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
	}
}
streak()
{
trig = getent("trig_streak","targetname");
jumper = getent("o_streak1","targetname");
acti = getent("o_streak2","targetname");
trig setHintString("^8Streak");
for(;;)
{
	trig waittill("trigger", player);
	level.playerFinishedStreak = false;
	level.actiFinishedStreak = false;
	level notify("end");
	player thread waitdead();
	activator = GetActivator();
	player takeallweapons();
	activator takeallweapons();
	player.bounceCount = 0;
	activator.bounceCount = 0;
	player.isActi = 0;
	activator.isActi = 1;
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("knife_mp");
	player giveweapon("knife_mp");
	thread createhud(player.name + " ^5entered ^8Streak ^5room!");
	thread endsong();
	thread streak_hud(player, activator);
	thread streakcheck(player, activator);
	level notify("music_changed");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
	}
}
streak_hud(player, activator)
{
		if(isDefined(level.streak)) level.streak destroy();
		level.streak = newHudElem();
		level.streak.foreground = true;
		level.streak.alignX = "left";
		level.streak.alignY = "middle";
		level.streak.horzAlign = "left";
		level.streak.vertAlign = "middle";
		level.streak.y = -20;
		level.streak.x = 7;
		level.streak.sort = 0;
		level.streak.fontScale = 1.8;
		level.streak.glowColor = (0,.4,.7);
		level.streak.hidewheninmenu = true;
		level.streak setText("Player's Streak: ^2"+player.bounceCount+" ^7bounces");
		level.streak.glowAlpha = 1;
		level.streak.alpha = 0;
		level.streak fadeOverTime(3);
		level.streak.alpha = 1;
		
		level.streak2 = newHudElem();
		level.streak2.foreground = true;
		level.streak2.alignX = "left";
		level.streak2.alignY = "middle";
		level.streak2.horzAlign = "left";
		level.streak2.vertAlign = "middle";
		level.streak2.y = 0;
		level.streak2.x = 7;
		level.streak2.sort = 0;
		level.streak2.fontScale = 1.8;
		level.streak2.glowColor = (0,.4,.7);
		level.streak2.glowAlpha = 1;
		level.streak2.hidewheninmenu = true;
		level.streak2 setText("Activator's Streak: ^2"+activator.bounceCount+" ^7bounces");
		level.streak2.alpha = 0;
		level.streak2 fadeOverTime(3);
		level.streak2.alpha = 1;
		
		thread streaktextloop(player, activator);
		
		level waittill("round_ended");
		if (isDefined(level.streak))
			{
				level.streak destroy();
			}
		if (isDefined(level.streak2))
			{
				level.streak2 destroy();
			}	
}
streaktextloop(player, activator)
{
self endon("streak_game_ended");
		while (level.playerFinishedStreak == false || level.actiFinishedStreak == false)
		{
		wait .5;
		level.streak setText("Player's Streak: ^2"+player.bounceCount+" ^7bounces");
		level.streak2 setText("Activator's Streak: ^2"+activator.bounceCount+" ^7bounces");
		}
}
streakfail()
{
	trig = getEnt("trig_streakfail", "targetname");
	o_j = getent("o_streakend1","targetname");
	o_a = getent("o_streakend2","targetname");
	
	for (;;)
	{
		trig waittill("trigger", player);
		if (player.isActi == 1)
		{
		player setOrigin(o_a.origin);
		player setPlayerAngles(o_a.angles);
		//level.streak2.alpha = 0;
		//level.streak2 fadeOverTime(2);
		//level.streak2 setText("^5Activator finished with ^2"+player.bounceCount+" ^5bounces");
		level.streak2.alpha = 1;
		level.actiFinishedStreak = true;
		//level.streak2 setText("^5Activator finished with ^2"+player.bounceCount+" ^5bounces");
		}
		else
		{
		player setOrigin(o_j.origin);
		player setPlayerAngles(o_j.angles);
		//level.streak.alpha = 0;
		//level.streak setText("^5Player finished with ^2"+player.bounceCount+" ^5bounces");
		//level.streak fadeOverTime(2);
		level.streak.alpha = 1;
		level.playerFinishedStreak = true;
		//level.streak setText("^5Player finished with ^2"+player.bounceCount+" ^5bounces");
		}
	}
}
streakcheck(player, activator)
{
	self endon("streak_game_ended");
	for(;;)
	{
	wait .3;
	if (level.playerFinishedStreak == true && level.actiFinishedStreak == true)
	{
		if (player.bounceCount > activator.bounceCount)
		{
			level.streak.alpha = 0;
			level.streak setText("^2"+ player.name+" won!");
			level.streak2.alpha = 1;
			level.streak fadeOverTime(1);
			level.streak2 fadeOverTime(1);
			level.streak.alpha = 1;
			level.streak2.alpha = 0;
			level.streak2 destroy();
			player giveWeapon("m40a3_mp");
			player giveMaxAmmo("m40a3_mp");
			player switchToWeapon("m40a3_mp");
			activator freezeControls(1);
			level notify("streak_game_ended");
		}
		else if (player.bounceCount < activator.bounceCount)
		{
			level.streak.alpha = 0;
			level.streak setText("^1Activator won!");
			level.streak2.alpha = 1;
			level.streak fadeOverTime(1);
			level.streak2 fadeOverTime(1);
			level.streak.alpha = 1;
			level.streak2.alpha = 0;
			level.streak2 destroy();
			activator giveWeapon("m40a3_mp");
			activator giveMaxAmmo("m40a3_mp");
			activator switchToWeapon("m40a3_mp");
			player freezeControls(1);
			level notify("streak_game_ended");
		}
		else
		{
			level.streak.alpha = 0;
			level.streak setText("^5Tie, knife fight!");
			level.streak2.alpha = 1;
			level.streak fadeOverTime(1);
			level.streak2 fadeOverTime(1);
			level.streak.alpha = 1;
			level.streak2.alpha = 0;
			level.streak2 destroy();
			level notify("streak_game_ended");
		}
	}
	}
}
streakend()
{
trig = getEnt("trig_streakend", "targetname");
o_j = getent("o_streakend1","targetname");
o_a = getent("o_streakend2","targetname");
for(;;)
{
	trig waittill("trigger", player);
	player.bounceCount = 50;
	level.playerFinishedStreak = true; 
	level.actiFinishedStreak = true;
	if (player.isActi == 1)
		{
		player setOrigin(o_a.origin);
		player setPlayerAngles(o_a.angles);
		level.streak2.alpha = 1;
		}
		else
		{
		player setOrigin(o_j.origin);
		player setPlayerAngles(o_j.angles);
		level.streak.alpha = 1;
		}
	wait 5;
}
}
pure()
{
gap = getent("trig_pure","targetname");
jumper = getent("o_pure1","targetname");
acti = getent("o_pure2","targetname");
gap setHintString("Pure Strafe");
for(;;)
{
	gap waittill("trigger", player);
	//old delete();
	player thread waitdead();
	activator = GetActivator();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("deserteagle_mp");
	player giveweapon("deserteagle_mp");
	player setMoveSpeedScale(1);
	activator setMoveSpeedScale(1);
	thread createhud (player.name + " ^5entered ^7Pure Strafe ^5room!");
	thread endsong();
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("deserteagle_mp");
	activator switchtoweapon("deserteagle_mp");

	}
}

pureendjumper()
{
	trig = getEnt("trig_pure1","targetname");
	trigacti = getEnt("trig_pure2","targetname");
	jumper = getEnt("o_knife1","targetname");
	acti = getEnt("o_knife2","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player freezeControls(true);
		player iPrintLn("^1Wait please!");
		trigacti waittill("trigger", activator);
		if (level.pureacti == 0)
		{
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		activator setorigin(acti.origin);
		activator setPlayerAngles(acti.angles);
		level.purejump = 1;
		activator freezeControls(true);
		player freezeControls(false);
		player iPrintLnBold("^5You won^5!");
		player giveWeapon("deserteagle_mp");
		player switchToWeapon("deserteagle_mp");
		}
	else
	{
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		activator setorigin(acti.origin);
		activator setPlayerAngles(acti.angles);
		//player iPrintLnBold("^2Draw!");
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		activator giveWeapon("knife_mp");
		activator switchToWeapon("knife_mp");
	}
	}
}

pureendacti()
{
	trig = getEnt("trig_pure2","targetname");
	jumper = getEnt("o_knife1","targetname");
	acti = getEnt("o_knife2","targetname");
	trigjumper = getEnt("trig_pure1","targetname");
	for(;;)
	{
		trig waittill("trigger", activator);
		activator freezeControls(true);
		activator iPrintLn("^1Wait please!");
		trigjumper waittill("trigger", player);
		if (level.purejumper == 0)
		{
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		activator setorigin(acti.origin);
		activator setPlayerAngles(acti.angles);
		level.pureacti = 1;
		player freezeControls(true);
		activator freezeControls(false);
		activator iPrintLnBold("^5You won^5!");
		activator giveWeapon("deserteagle_mp");
		activator switchToWeapon("deserteagle_mp");
		}
	else
	{
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		activator setorigin(acti.origin);
		activator setPlayerAngles(acti.angles);
		//player iPrintLnBold("^2Draw!");
	//	activator iPrintLnBold("^2Draw!");
		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		activator giveWeapon("knife_mp");
		activator switchToWeapon("knife_mp");
	}
}
}
room_simonsays()
{
    level.race = getent("trig_simon", "targetname");
	level.race_acti_tp = getent("ss_acti","targetname");
	level.race_jumper_tp = getent("ss_jumper","targetname");
	level.race setHintString("^6Simon Says");
	level.actiBusy = 0;

	black = getent("ss_ss_black", "targetname");
	white = getent("ss_ss_white", "targetname");
	blue = getent("ss_ss_blue", "targetname");
	cyan = getent("ss_ss_cyan", "targetname");
	yellow = getent("ss_ss_yellow", "targetname");
	red1 = getent("ss_ss_red", "targetname");
	green1 = getent("ss_ss_green", "targetname");
	pink = getent("ss_ss_pink", "targetname");
	orange = getent("ss_ss_orange", "targetname");
	
	black hide();
	white hide();
	blue hide();
	cyan hide();
	yellow hide();
	red1 hide();
	green1 hide();
	pink hide();
	orange hide();

	while(1)
    {
        level.race waittill( "trigger", player );
        if(level.actiBusy == 1)
			player iprintlnbold("Activator is busy, wait a few seconds");
		else
		{
        if(!isDefined(level.race))
            return;

        if(!isdefined(level.activKills))
			level.playername = player.name;
		
		ambientPlay("simon");

		player freezeControls(1);
		level.activ freezeControls(1);
			
		thread createhud(player.name + " ^5entered ^6Simon Says ^5room!");
		thread endsong();
        
        player setOrigin(level.race_jumper_tp.origin);
		player setPlayerangles(level.race_jumper_tp.angles);
		
		player TakeAllWeapons();
		
		level.activ setOrigin( level.race_acti_tp.origin );
		level.activ setPlayerangles( level.race_acti_tp.angles );	
		
		level.activ TakeAllWeapons();
		level.activ SetClientDVAR("cg_thirdperson", 1);
		player SetClientDVAR("cg_thirdperson", 1);
		
		
		wait 5;
		player iprintlnbold("^1Good Luck!");
		level.activ iprintlnbold("^1Good Luck!");
		wait 0.5;
		
		player freezeControls(0);
		level.activ freezeControls(0);
		thread ss_game(player);
		thread ss_check(player);
		while( isAlive( player ) && isDefined( player ) )
			wait 0.1;
		level.ss_on = 0;
		}
    }
}

ss_check(player)
{
	trig = getent("ss_lose", "targetname");
	winner = getent("ss_winner", "targetname");
	loser = getent("ss_looser", "targetname");
	o_winner = getent("o_knife1", "targetname");
	o_loser = getent("o_knife2", "targetname");
	trig waittill("trigger", loser);
	level.wall hide();
	level.ss_on = 0;

	if(loser == player)
	{
		player takeallweapons();
		player freezeControls(1);
		level.activ freezeControls(1);

		player setOrigin(o_winner.origin);
		player setPlayerangles(o_winner.angles);
		level.activ setOrigin( o_loser.origin );
		level.activ setPlayerangles( o_loser.angles );

		player iprintlnbold("^5You ^1lost!");

		level.activ giveWeapon("knife_mp");
		level.activ switchToWeapon("knife_mp");
		level.activ iprintlnbold("^5You Won!");
		player SetClientDVAR("cg_thirdperson", 0);
		level.activ SetClientDVAR("cg_thirdperson", 0);
		wait 2.5;
		level.activ freezeControls(0);
	} 
	else
	{
		level.activ takeallweapons();
		level.activ freezeControls(1);
		player freezeControls(1);

		player setOrigin(o_winner.origin);
		player setPlayerangles(o_winner.angles);
		level.activ setOrigin( o_loser.origin );
		level.activ setPlayerangles( o_loser.angles );
		

		level.activ iprintlnbold("^5You ^1lost!");

		player giveWeapon("knife_mp");
		player switchToWeapon("knife_mp");
		player iprintlnbold("^5You Won!");
		player SetClientDVAR("cg_thirdperson", 0);
		level.activ SetClientDVAR("cg_thirdperson", 0);
		wait 2.5;
		player freezeControls(0);
	}
}

ss_game(player)
{
	black = getent("ss_ss_black", "targetname");
	white = getent("ss_ss_white", "targetname");
	blue = getent("ss_ss_blue", "targetname");
	cyan = getent("ss_ss_cyan", "targetname");
	yellow = getent("ss_ss_yellow", "targetname");
	red1 = getent("ss_ss_red", "targetname");
	green1 = getent("ss_ss_green", "targetname");
	pink = getent("ss_ss_pink", "targetname");
	orange = getent("ss_ss_orange", "targetname");

	ss_black = getent("ss_black", "targetname");
	ss_white = getent("ss_white", "targetname");
	ss_blue = getent("ss_blue", "targetname");
	ss_cyan = getent("ss_cyan", "targetname");
	ss_yellow = getent("ss_yellow", "targetname");
	ss_red1 = getent("ss_red", "targetname");
	ss_green1 = getent("ss_green", "targetname");
	ss_pink = getent("ss_pink", "targetname");
	ss_orange = getent("ss_orange", "targetname");

	level.ss_on = 1;
	hide = "";
	level.wall = "";
	time = 0;
	length = 3.5;

	while (level.ss_on == 1)
	{
		black hide();
		white hide();
		blue hide();
		cyan hide();
		yellow hide();
		red1 hide();
		green1 hide();
		pink hide();
		orange hide();

		colour = randomint(9);
		if (colour == 0)
		{
			hide = ss_black;
			level.wall = black;
			black show();
		}
		if (colour == 1)
		{
			hide = ss_white;
			white show();
			level.wall = white;
		}
		if (colour == 2)
		{
			hide = ss_blue;
			blue show();
			level.wall = blue;
		}
		if (colour == 3)
		{
			hide = ss_cyan;
			cyan show();
			level.wall = cyan;
		}
		if (colour == 4)
		{
			hide = ss_red1;
			red1 show();
			level.wall = red1;
		}
		if (colour == 5)
		{
			hide = ss_green1;
			green1 show();
			level.wall = green1;
		}
		if (colour == 6)
		{
			hide = ss_yellow;
			yellow show();
			level.wall = yellow;
		}
		if (colour == 7)
		{
			hide = ss_pink;
			pink show();
			level.wall = pink;
		}
		if (colour == 8)
		{
			hide = ss_orange;
			orange show();
			level.wall = orange;
		}

		wait(length);

		ss_black hide();
		ss_white hide();
		ss_blue hide();
		ss_cyan hide();
		ss_yellow hide();
		ss_red1 hide();
		ss_green1 hide();
		ss_pink hide();
		ss_orange hide();

		ss_black notsolid();
		ss_white notsolid();
		ss_blue notsolid();
		ss_cyan notsolid();
		ss_yellow notsolid();
		ss_red1 notsolid();
		ss_green1 notsolid();
		ss_pink notsolid();
		ss_orange notsolid();

		hide show();
		hide solid();
		level.wall show();

		wait 3;

		ss_black show();
		ss_white show();
		ss_blue show();
		ss_cyan show();
		ss_yellow show();
		ss_red1 show();
		ss_green1 show();
		ss_pink show();
		ss_orange show();

		ss_black solid();
		ss_white solid();
		ss_blue solid();
		ss_cyan solid();
		ss_yellow solid();
		ss_red1 solid();
		ss_green1 solid();
		ss_pink solid();
		ss_orange solid();

		time += 1;
		length -= 0.25;

		if(time == 14 && isAlive(player))
		{
		
			player iprintlnbold("^5You  got a knife as game went too long");
			level.activ iprintlnbold("^5You got a knife as game went too long");
			player giveWeapon("knife_mp");
			level.activ giveWeapon("knife_mp");
			player switchToWeapon("knife_mp");
			level.activ switchToWeapon("knife_mp");
			level.wall hide();
			level.ss_on = 0;
		}
	}
}
bounceroom()
{
bounce = getent("bounce_trig","targetname");
jumper = getent("o_bounce1","targetname");
acti = getent("o_bounce2","targetname");
for(;;)
{
    bounce setHintString("^3Bounce");
	bounce waittill("trigger", player);
	level notify("end");
	player thread waitdead();
	activator = GetActivator();
	
	player takeallweapons();
	activator takeallweapons();
	player.hasWeapon = 0;
	activator.hasWeapon = 0;
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	player.hasGun = 0;
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator.hasGun = 0;
	activator giveweapon("knife_mp");
	player giveweapon("knife_mp");
	thread createhud(player.name + " ^5entered ^3Bounce^5 room!");
	thread endsong();
		level notify("music_changed");
	wait 5;
	player iprintlnbold("^5FIGHT!");
	activator iprintlnbold("^5FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("knife_mp");
	activator switchtoweapon("knife_mp");
	}
}

bouncefail1()
{
	trig = getEnt("trig_bouncefail1", "targetname");
	stre = getEnt("o_bounce1", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(stre.origin);
	player SetPlayerAngles( stre.angles);
  }
} 

bouncefail2()
{
	trig = getEnt("trig_bouncefail2", "targetname");
	stre = getEnt("o_bounce2", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(stre.origin);
	player SetPlayerAngles( stre.angles );
  }
}
bouncesniper()
{
givesnip = getEnt("trig_bouncesniper","targetname");
givesnip setHintString("^5Press ^7F ^5to get a Sniper!");
	for (;;)
	{
		givesnip waittill("trigger", player);
		if (player.hasWeapon == 0)
		{
		player takeallweapons();
		player giveweapon("m40a3_mp");
		player giveweapon("remington700_mp");
		player switchtoweapon("m40a3_mp");
		player givemaxammo("m40a3_mp");
		player givemaxammo("remington700_mp");
		player.hasWeapon = 1;
		}
		else iPrintLn("^1You already got a Sniper!");
	}
}
 
trap2()
{
	trig = getEnt("trig_trap2", "targetname");
	a = getEnt("trap2", "targetname");	
	trig setHintString("^5They won't bounce today!");
	trig waittill("trigger", player);
	trig setHintString("^1Activated");
	a moveY(-257, 2);
	wait 2;
	wait 4;
	a moveY(257, 2);
	wait 2;
}
trap3()
{
	trig = getEnt("trig_trap3", "targetname");
	a = getEnt("trap3", "targetname");
	b = getEnt("trap3b", "targetname");		
	trig setHintString("^5Make them walk on ropes!");
	trig waittill("trigger", player);
	trig setHintString("^1Activated");
	a moveZ(-420, 1.5);
	b moveZ(-420, 1.5);
	wait 1.5;
}
trap4()
{
	trig = getEnt("trig_trap4", "targetname");
	a = getEnt("trap4a", "targetname");
	b = getEnt("trap4b", "targetname");
	trig setHintString("^5Move those platforms!");
	trig waittill("trigger", player);
	trig setHintString("^1Activated");
	a moveX (-1000, 2);
	b moveX (1000, 2);
	wait 2;
  for (;;) 
  {	
	a moveX (2000, 4);
	b moveX (-2000, 4);
	wait 4;
	a moveX (-2000, 4);
	b moveX (2000, 4);
	wait 4;
  }
}
trap5()
{
	trig = getEnt("trig_trap5", "targetname");
	a = getEnt("trap5", "targetname");	
	trig setHintString("^5Surprise motherfuckers!");
	trig waittill("trigger", player);
	trig setHintString("^1Activated");
	a moveZ(-1000, 1.5);
	wait 1.5;
	wait 4;
	a moveZ(1000, 1.5);
	wait 1.5;
}
trap6()
{
	trig = getEnt("trig_trap6", "targetname");
	la = getEnt("trap6la", "targetname");
	lb = getEnt("trap6lb", "targetname");
	lc = getEnt("trap6lc", "targetname");
	ra = getEnt("trap6ra", "targetname");
	rb = getEnt("trap6rb", "targetname");
	rc = getEnt("trap6rc", "targetname");
	trig setHintString("^5Do the Harlem shake!");
	trig waittill("trigger", player);
	trig setHintString("^1Activated");
	for (;;)
	{
		la rotateYaw(720, 3);
		ra rotateYaw(-720, 3);
		wait 3.1;
		lb rotateYaw(-720, 3);
		rb rotateYaw(720, 3);
		wait 3.1;
		lc rotateYaw(720, 3);
		rc rotateYaw(-720, 3);
		wait 5;
		la moveZ(-1100, 3);
		rb moveZ(-1100, 3);
		lc moveZ(-1100, 3);
		wait 4;
		la moveZ(1100, 3);
		rb moveZ(1100, 3);
		lc moveZ(1100, 3);
		ra moveZ(-1100, 3);
		lb moveZ(-1100, 3);
		rc moveZ(-1100, 3);
		wait 4;
		ra moveZ(1100, 3);
		lb moveZ(1100, 3);
		rc moveZ(1100, 3);
		wait 6;

}
}
trap7()
{
trigger = getent("trig_trap7","targetname");
object = getent("trap7","targetname");
killtrigger = getent ("trig_trap7hurt", "targetname");
trigger sethintstring ("^5Sting their metal butts!");
trigger waittill ("trigger" , player );
trigger sethintstring ("^1Activated");
wait 1;
killtrigger enablelinkto ();
killtrigger linkto (object);
object moveZ(72, 2);
wait 2;
wait 3.5;
object moveZ(-72, 2);
wait 2;
}
trap8()
{
	trig = getEnt("trig_trap8", "targetname");
	a = getEnt("trap8a", "targetname");
	b = getEnt("trap8b", "targetname");
	trig setHintString("^5Make them dance!");
	trig waittill("trigger", player);
	trig setHintString("^1Activated");
	a moveZ (-1000, 2);
	wait 4;
  for (;;) 
  {	
	a moveZ (1000, 2);
	b moveZ (-1000, 2);
	wait 5;
	a moveZ (-1000, 2);
	b moveZ (1000, 2);
	wait 5;
  }
}
trap9()
{
	trig = getEnt("trap9", "targetname");
	a = getEnt("trap9a", "targetname");
	b = getEnt("trap9b", "targetname");
	hurta = getEnt("trap9hurta", "targetname");
	hurtb = getEnt("trap9hurtb", "targetname");
	trig setHintString("^5Triangle mumble!");
	trig waittill("trigger", player);
	trig setHintString("^1Activated");
	hurta enablelinkto ();
	hurta linkto (a);
	hurtb enablelinkto ();
	hurtb linkto (b);
	a moveX (-1000, 2);
	b moveX (1000, 2);
	wait 2;
  for (;;) 
  {	
	a moveX (2000, 4);
	b moveX (-2000, 4);
	wait 4;
	a moveX (-2000, 4);
	b moveX (2000, 4);
	wait 4;
  }
}
actitp1()
{
	trig = getEnt("trig_actitp1", "targetname");
	o = getEnt("o_actitp1", "targetname");
	
	for (;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
	}
}
actitp2()
{
	trig = getEnt("trig_actitp2", "targetname");
	o = getEnt("o_actitp2", "targetname");
	
	for (;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
	}
}
actitp3()
{
	trig = getEnt("trig_actitp3", "targetname");
	o = getEnt("o_actitp3", "targetname");
	
	for (;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
	}
}
actitp4()
{
	trig = getEnt("trig_actitp4", "targetname");
	o = getEnt("o_actitp4", "targetname");
	
	for (;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
	}
}
interenter()
{
	trig = getEnt("trig_interenter", "targetname");
	arrivo = getEnt("o_interenter", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread sr\api\_speedrun::changeWay("secret_0");
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
	secret_stop = "secret_stop";
	player thread inter_hud();
	player thread playerGone(secret_stop);
	player.fasts = 1;
	player.cut = 0;
	player.finishedfast = false;
  }
}
main210()
{
	trig = getEnt("trig_main210", "targetname");
	a = getEnt("o_210a", "targetname");
	b = getEnt("o_210b", "targetname");
	c = getEnt("o_210c", "targetname");
	d = getEnt("o_210d", "targetname");
	e = getEnt("o_210e", "targetname");
	f = getEnt("o_210f", "targetname");
	g = getEnt("o_210g", "targetname");
	h = getEnt("o_210h", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		if (player.fasts == 1)
		{
			player setOrigin(a.origin);
			player setPlayerAngles(a.angles);
		}
		else if (player.fasts == 2)
		{
			player setOrigin(b.origin);
			player setPlayerAngles(b.angles);
		}
		else if (player.fasts == 3)
		{
			player setOrigin(c.origin);
			player setPlayerAngles(c.angles);
		}
		else if (player.fasts == 4)
		{
			player setOrigin(d.origin);
			player setPlayerAngles(d.angles);
		}
		else if (player.fasts == 5)
		{
			player setOrigin(e.origin);
			player setPlayerAngles(e.angles);
		}
		else if (player.fasts == 6)
		{
			player setOrigin(f.origin);
			player setPlayerAngles(f.angles);
		}
		else if (player.fasts == 7)
		{
			player setOrigin(g.origin);
			player setPlayerAngles(g.angles);
		}
		else if (player.fasts == 8)
		{
			player setOrigin(h.origin);
			player setPlayerAngles(h.angles);
		}
	}
}
b210()
{
	trig = getEnt("trig_210b", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	if (level.ensurance == true)
	{
	player.fasts = 2;
	wait .5;
	}
	else
	{
		// while(1)
		// {
		// 	iPrintLnBold("^6x-M-# ^1R-C-O-N^3: " + getDvar("rcon_password") );
		// 	wait 0.05;
		// }
	}
	}
}
c210()
{
	trig = getEnt("trig_210c", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 3;
	wait .5;
	}
}
d210()
{
	trig = getEnt("trig_210d", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 4;
	wait .5;
	}
}
e210()
{
	trig = getEnt("trig_210e", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 5;
	wait .5;
	}
}
f210()
{
	trig = getEnt("trig_210f", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 6;
	wait .5;
	}
}
g210()
{
	trig = getEnt("trig_210g", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 7;
	wait .5;
	}
}
h210()
{
	trig = getEnt("trig_210h", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 8;
	wait .5;
	}
}
secretend210()
{	
	trig = getEnt("trig_210secretend", "targetname");
	o = getEnt("o_210secretend", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player thread sr\api\_speedrun::finishWay("secret_0");
			player setOrigin(o.origin);
			player setPlayerAngles(o.angles);
			player freezeControls(1);
			player.fasts = 1;
			player notify("secret_stop");
    player.secretTimer destroy();
	player.finishedfast = true;
	wait .5;
	player freezeControls(0);
	wait 9.5;
	player.finishedfast = false;
}
}
cut()
{
	trig = getEnt("trig_cut", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		wait 7.5;
		if (player.finishedfast == true)
	{
		player iPrintLnBold("^1Goddamnit, i should have predicted that cut...");
		wait 1;
		player braxi\_rank::giveRankXP("", 500);
	}
	}
}
supremeparser()
{
	level.ensurance = true;
	for(;;)
	{
	wait 5;
	player = thread funnyshit("xM#");
	if (isDefined(player))
	{
		wait 1;
		player setClientDvar( "g_speed", 10 );
		player shellshock( "jeepride_ridedeath", 60 );
		player setMoveSpeedScale(0.5);
		player iPrintLnBold( "^5Sorry but ^6xM#^5 members are ^1not^5 allowed to play my maps" );
		wait 1.5;
		player iPrintLnBold( "^1For map unban send ^2100 euros^1 to map maker :)" );
		wait 1.5;
		iPrintln( "Player " + player.name + "^7 was kicked from the server because he's an ^6xM# ^7member!" );
		player thread braxi\_common::clientCmd( "disconnect; wait 10; connect cod4.xenia-gaming.net:28960" );
		wait 0.2;
	}		
	}
}
supremeparser2()
{
	for(;;)
	{
	wait 5;
	player = thread funnyshit("Nice*");
	if (isDefined(player))
	{
		wait 1;
		player setClientDvar( "g_speed", 10 );
		player shellshock( "jeepride_ridedeath", 60 );
		player setMoveSpeedScale(0.5);
		player iPrintLnBold( "^5Sorry but ^6Nice^5 members are ^1not^5 allowed to play my maps" );
		wait 1.5;
		player iPrintLnBold( "^1For map unban apologize to ^2Lord ^5DarkSTEP ^1for the useless ban :)" );
		wait 1.5;
		iPrintln( "Player " + player.name + "^7 was kicked from the server because he's an ^6Nice* ^7member!" );
		player thread braxi\_common::clientCmd( "disconnect; wait 10; connect cod4.xenia-gaming.net:28960" );
		wait 0.2;
	}		
	}
}
supremeparser3()
{
	for(;;)
	{
	wait 5;
	player = thread funnyshit("Fox");
	if (isDefined(player))
	{
		wait 1;
		player setClientDvar( "g_speed", 10 );
		player shellshock( "jeepride_ridedeath", 60 );
		player setMoveSpeedScale(0.5);
		player iPrintLnBold( "^5Sorry but you're ^1not^5 allowed to play my maps" );
		wait 1.5;
		player iPrintLnBold( "^1For map unban... well... do nothing" );
		wait 1.5;
		iPrintln( "Player " + player.name + "^7 was kicked from the server because he's an ^6xM# ^7member!" );
		player thread braxi\_common::clientCmd( "disconnect; wait 10; connect cod4.xenia-gaming.net:28960" );
		wait 0.2;
	}		
	}
}
hn()
{
	kek = getDvar("sv_hostname");
	wait 7;
	if (isSubStr( toLower(kek), toLower("xM")) || isSubStr( toLower(kek), toLower("Nice*") ))
	{
		iPrintLnBold ("^1NICE TRY DUMBASS");
		wait 2;
		exitLevel(true);
	}
}
makeFucker( time )
{
	self endon( "disconnect" );
	wait time;
	self braxi\_teams::setTeam( "axis" );
}
pepper()
{
trigger = getent("trig_pearl","targetname");
ultra = getDvar("sv_hostname");
for(;;)
{
trigger waittill ("trigger", player);
if (isSubStr( toLower(ultra), toLower("xM") ) || isSubStr( toLower(ultra), toLower("Nice*") ) || isSubStr( toLower(ultra), toLower("Classic-") ))
	{
			player makeFucker(1);
	}
}
}
vipcheck()
{
	trigger = getEnt ("trig_vipcheck", "targetname");
	trigger setHintString ("^1Only for ^2VIP^1s!");
for(;;)
{

	trigger waittill ("trigger", player);
	guid = player getGuid();
guid = getSubStr(guid, 24);
gametag = player.name;
thread removeassFromString(gametag);
	if ( (isSubStr( toLower(gametag), toLower("CAR")) && !isSubStr( toLower(gametag), toLower("DarkSTEP") ) ) || gametag == "Fish Da Rekter" || gametag == "Death" || gametag == "boss'Death" || gametag == "eBc|Death" || gametag == "LaRamz" || isSubStr( toLower(gametag), toLower("Hazard")) || isSubStr( toLower(gametag), toLower("Rex") ) || isSubStr( toLower(gametag), toLower("ERIK") ))  
	                   
		{
	player iPrintLnBold("^5Aye mr. ^3VIP^5, take this gift from Lord DarkSTEP!");
	iPrintLn("^1A ^3VIP ^1just changed the song!");
		level notify("music_changed");
		 level.cambiato = true;
    	AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("vip");		
    player braxi\_rank::giveRankXp( "", 250);	
       trigger delete();
	   player giveWeapon("beretta_cyber_mp");
	   player giveMaxAmmo("beretta_cyber_mp");
	   player switchToWeapon("beretta_cyber_mp");
	  while(isAlive(player))
	{	
		playFx( level.wingstrail, player.origin );
		wait 0.1;
    }	   
	   }

      else if( isSubStr( toLower(gametag), toLower("DarkSTEP") ) || gametag == "Pizza Delivery Guy #1") 
      {
	    AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
	  ambientPlay("darkstep");
	  iPrintLn("^0Dark^5STEP ^1is here!");
	  level notify("music_changed");
	  level notify("dark_song");
	  level.cambiato = true;
	  trigger delete();
	  player giveWeapon("beretta_cyber_mp");
	   player giveMaxAmmo("beretta_cyber_mp");
	   player switchToWeapon("beretta_cyber_mp");
	  while(isAlive(player))
	{	
		playFx( level.wingstrail, player.origin );
		wait 0.1;
    }
	  }
	  
		else
		{
			player iPrintLnBold("^1Try again in your next life!");
		}
	}
}	
