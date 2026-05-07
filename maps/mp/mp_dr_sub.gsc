#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
	maps\mp\_load::main();
	//ambientPlay("ambient_cargoshipmp_ext");
	
	//fx
	/*level.t02 = LoadFX("m/t02");
	level.t03 = LoadFX("m/black");
	level.t032 = LoadFX("m/black2");
	level.t04 = LoadFX("m/fire");
	level.bri = LoadFX("m/bri");
	level.r2 = loadfx("m/r2");
	level.csf = LoadFX("m/csf");
	level.r = loadfx("m/r");
	level.gl = loadfx("m/gl");
	level.my = loadfx("m/my");
	level.watex = loadfx("m/watex");
    level.bar = LoadFx("explosions/fuel_med_explosion");
	level.wat = loadfx("explosions/grenadeExp_water");
	level.sk = loadfx ("smoke/smoke_trail_white_heli");
	precacheShader("warn");
	precacheShader("black");
	precacheShader("white");
	precacheItem( "winchester1200_reflex_mp" );
	precacheItem( "m14_mp" );
	precacheItem( "rpg_mp" );
	precacheItem( "m40a3_acog_mp" );
	precacheModel("projectile_hellfire_missile");
	precacheModel("fan");
	precacheModel("fan6");
	precacheShellShock( "concussion_grenade_mp" );
	level.exp = loadfx( "explosions/tanker_explosion" );
	precachemodel( "com_security_camera" );
	precachemodel( "com_security_camera_destroyed" );
	precachemodel( "ship3" );
	PrecacheModel( "vehicle_blackhawk" );
		precacheShader("damage_feedback");
	precacheShader("damage_feedback_j");
	precacheStatusIcon("rank_prestige3");*/
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".18");

	setdvar( "r_specularcolorscale", "2.4877" );

	setdvar("compassmaxrange","1200");

	thread sr\api\_map::createSpawn((-3562, -503, 68), 360);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((5518.36, -539.824, 96.125),95,120, "normal_0"); 

	thread trap_adjustments();
	
	
	//thread addTestClients();
	//thread arrays();
	//thread alarm();
	//thread numpad();
	//thread disable();
	//thread t04();
	//thread t004();
	//thread t0004();
	//thread t00004();
	//thread fre();
	//thread dr();
	//thread dorfn("dor1t","dor1b","dor1o");
	//thread dorfn("dor2t","dor2b","dor2o");
	//thread dorfn("dor1t2","dor1b2","dor1o2");
	//thread dorfn("dor1t3","dor1b3","dor1o3");
	//thread dorfn("dor1t4","dor1b4","dor1o4");
	//thread dorfn("dor1t5","dor1b5","dor1o5");
	//thread dorfn("dor1t6","dor1b6","dor1o6");
	//thread dor();
	//thread dor2();
	//thread shinobi();
	//thread OnConnect();
	//thread nospn();
	//thread yesspn();
	//thread nospn2();
	//thread yesspn2();
	//thread expoe();
	//thread tr();
	//thread cr();
	//thread main4();
	//thread cl1();
	//thread cl2();
	//thread cl3();
	//thread dr2();
	//thread trap062();
	//thread ef();
	//thread ef2();
	//thread ef3();
	//thread ef4();
	//thread ef5();
	//thread ef6();
	//thread ef7();
	//thread main2();
	//thread main3();
	//thread rr();
	//thread shark();
	//thread addtriggers();
	
}

trap_adjustments()
{
brush_1 = getEnt("t011","targetname");
brush_2 = getEnt("t012","targetname");
brush_3 = getEnt("t06t","targetname");
brush_4 = getEnt("t005t","targetname");
brush_5 = getEnt("t05t","targetname");
brush_6 = getEnt("t06t2","targetname");
brush_7 = getEnt("clk1","targetname");
brush_8 = getEnt("clk2","targetname");
brush_9 = getEnt("clk3","targetname");



wait 0.1;

brush_1 delete();
brush_2 delete();
brush_3 delete();
brush_4 delete();
brush_5 delete();
brush_6 delete();
brush_7 delete();
brush_8 delete();
brush_9 delete();
			

}
addtriggers()
{
    addTriggerToList("drt");
    addTriggerToList("frt");
    addTriggerToList("drt2");
    addTriggerToList("ext");
    addTriggerToList("trt");

}

addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
alarm()
{
	i = getent ("pipe" ,"targetname");
	h = getent ("t06t" ,"targetname");
	i delete();	
	h delete();
	a = getent ("alarm","targetname");
	a waittill ("trigger",player);
	//player shellshock( "pain", 5 );
	if(!isdefined(level.disable))
	{
	player thread alarmmsg();
	a PlaySound ("alr");
	thread trap0();
	thread trap00();
	thread trap02();
	thread t05();
	//thread trap06();
	}
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

trap0()
{
	a = getent ("t0b1","targetname");
	b = getent ("t0b2","targetname");
	h1 = getent ("t0h1","targetname");
	h2 = getent ("t0h2","targetname");
	wait 1;
	h1 enablelinkto();
	h1 linkto(b);
	h2 enablelinkto();
	h2 linkto(a);
	wait 1;
	
	while(!isdefined(level.disable))
	{
	a moveZ(-300,2);
	b moveY(-300,2);
	wait 3;
	a moveZ(300,2);
	b moveY(300,2);
	wait 3;
	}
}
trap00()
{
	a = getent ("t0b11","targetname");
	b = getent ("t0b22","targetname");
	h1 = getent ("t0h11","targetname");
	h2 = getent ("t0h22","targetname");
	wait 1;
	h1 enablelinkto();
	h1 linkto(b);
	h2 enablelinkto();
	h2 linkto(a);
	wait 1;
	
	while(!isdefined(level.disable))
	{
	a moveZ(-300,2);
	b moveY(300,2);
	wait 3;
	a moveZ(300,2);
	b moveY(-300,2);
	wait 3;
	}
}
disable()
{
	d = getent ("disable","targetname");
	d sethintstring("^1Disable");
	d waittill("trigger");
	level.disable = true;
	d playsound("mp_war_objective_taken");
	d sethintstring("^1Disabled");
}
trap02()
{
	thread t002();
	thread t0002();
	//PlayFx(level.t03, l.origin);
}
t002()
{
	j = getent ("t01" ,"targetname");
	k = getent ("t011" ,"targetname");
	
	
	r = Spawn("script_model", (0,0,0) );
	r.origin = j.origin;
	r SetModel("tag_origin");
	r rotateyaw(90,0.5);
	//k PlaySound ("flame1");
	wait 1;
	PlayFXOnTag( level.t02, r, "tag_origin" );
	k PlayloopSound ("fire1");
	while(!isdefined(level.disable))
	{
	wait 0.5;
	}
	r delete();
	k delete();
}
t0002()
{
	j = getent ("t02" ,"targetname");
	k = getent ("t012" ,"targetname");
	
	
	r = Spawn("script_model", (0,0,0) );
	r.origin = j.origin;
	r SetModel("tag_origin");
	r rotateyaw(-90,0.5);
	wait 1;
	PlayFXOnTag( level.t02, r, "tag_origin" );
	k PlayloopSound ("fire1");
	while(!isdefined(level.disable))
	{
	wait 0.5;
	}
	k delete();
	r delete();
}
t04()
{
	t = getent ("t04t" ,"targetname");
	b = getent ("t04b" ,"targetname");
	o = getent ("t04o" ,"targetname");
	
	t waittill("trigger", p);
	p suicide();
	b delete();
	
	playFx(level.bar,o.origin);
	Earthquake( 2, 1, o.origin, 70);
	o playsound("explo_metal_rand");
}	
t004()
{
	t = getent ("t004t" ,"targetname");
	b = getent ("t004b" ,"targetname");
	o = getent ("t004o" ,"targetname");
	
	t waittill("trigger", p);
	p suicide();
	b delete();
	
	playFx(level.bar,o.origin);
	Earthquake( 2, 1, o.origin, 70);
	o playsound("explo_metal_rand");
}	
t0004()
{
	t = getent ("t0004t" ,"targetname");
	b = getent ("t0004b" ,"targetname");
	o = getent ("t0004o" ,"targetname");
	
	t waittill("trigger", p);
	p suicide();
	b delete();
	
	playFx(level.bar,o.origin);
	Earthquake( 2, 1, o.origin, 70);
	o playsound("explo_metal_rand");
}
t00004()
{
	t = getent ("t00004t" ,"targetname");
	b = getent ("t00004b" ,"targetname");
	o = getent ("t00004o" ,"targetname");
	
	t waittill("trigger", p);
	p suicide();
	b delete();
	
	playFx(level.bar,o.origin);
	Earthquake( 2, 1, o.origin, 70);
	o playsound("explo_metal_rand");
}
t05()
{
	a1 = getent ("t05b" ,"targetname");
	a2 = getent ("t05t" ,"targetname");
	b1 = getent ("t005b" ,"targetname");
	b2 = getent ("t005t" ,"targetname");
	o = getent ("t05o" ,"targetname");
	
	a2 enablelinkto();
	a2 linkto(a1);
	b2 enablelinkto();
	b2 linkto(b1);
	
	
	while(!isdefined(level.disable))
	{
	a1 moveY(80,1);
	b1 moveY(-80,1);
	wait 1;
	b1 playSound("hit");
	a1 playSound("hit");
	earthquake(0.6,1,o.origin,1000);
	wait 1;
	a1 moveY(-80,1);
	b1 moveY(80,1);
	wait 2;
	}
}
trap06()
{
	l = getent ("oil" ,"targetname");
	//playLoopedFx(level.t03, 1, l.origin);
	k = SpawnFx( level.t03, l.origin);
	h = getent ("t06t" ,"targetname");
	i = getent ("pipe" ,"targetname");


	triggerFx (k);
	while(!isdefined(level.disable))
	{
	wait 0.5;
	}
	h delete();
	k delete();
	i delete();
}
trap062()
{
	l = getent ("oil2" ,"targetname");
	//playLoopedFx(level.t03, 1, l.origin);
	k = SpawnFx( level.t032, l.origin);
	h = getent ("t06t2" ,"targetname");
	i = getent ("pipe2" ,"targetname");

	/*wait 5;
	triggerFx (k);
	wait 1;*/
	h delete();
	k delete();
	i delete();
}
alarmmsg()
{
	self endon("disconnect");
	wait .05;
	notifyData = SpawnStruct();
	notifyData.notifyText="^1"+self.name;
	notifyData.MainText="Alarm Triggered!";
	notifyData.duration=5;
	level.on = true;
	level.players = getAllPlayers();
	for(i=0;i<level.players.size;i++){players=level.players[i];players thread alarmon( notifyData );}

}
alarmmsg2()
{
	self endon("disconnect");
	wait .05;
	notifyData = SpawnStruct();
	notifyData.notifyText="^1SYSTEM";
	notifyData.MainText="Alarm Deactivated";
	notifyData.duration=5;
	level.on = false;
	level.players = getAllPlayers();
	for(i=0;i<level.players.size;i++){players=level.players[i];players thread alarmon( notifyData );}

}
getAllPlayers()
{
	return getEntArray( "player", "classname" );
}
endtx( msgn )
{
	wait 0.1;
		self.Text1=CreateFontString( "objective", 1.5 );
		self.Text1 setPoint( "LEFT", "CENTER", -500, -60 );
		self.Text1 setShader("warn", 100, 22);
		//self.Text1 setTxt( notifyData.notifyText );
		self.Text1.glowAlpha=1;
		//self.Text2.glowColor=(0, 0, 0);
		self.Text1 MoveOverTime(0.2);
		self.Text1.x=-400;
		self.Text2=CreateFontString( "default", 1.6 );
		self.Text2 setPoint( "LEFT", "CENTER", -500, -60 );
		self.Text2 setTxt( msgn );
		self.Text2.glowAlpha=1;
		if(level.on == true)
		self.Text2.glowColor=(1.0, 0.0, 0.0);
		if (level.on == false)
		self.Text2.glowColor=(0.0, 0.8, 0.0);
		self.Text1 setShader("warn", 140, 22);
		self.Text2 MoveOverTime(0.2);
		self.Text2.x=-400;
		wait 6;
		thread DestroyElemsKS(self.Text2,self.Text1);

}
alarmon( notifyData )
{
	wait 0.1;
		self.Text1=CreateFontString( "objective", 1.5 );
		self.Text1 setPoint( "LEFT", "CENTER", -500, -60 );
		self.Text1 setShader("warn", 100, 22);
		//self.Text1 setTxt( notifyData.notifyText );
		self.Text1.glowAlpha=1;
		//self.Text2.glowColor=(0, 0, 0);
		self.Text1 MoveOverTime(0.2);
		self.Text1.x=-400;
		self.Text2=CreateFontString( "default", 1.6 );
		self.Text2 setPoint( "LEFT", "CENTER", -500, -60 );
		self.Text2 setTxt( notifyData.MainText );
		self.Text2.glowAlpha=1;
		self.Text2.glowColor=(0.0, 0.8, 0.0);
		self.Text1 setShader("warn", 140, 22);
		self.Text2 MoveOverTime(0.2);
		self.Text2.x=-400;
		wait notifyData.duration;
		thread DestroyElemsKS(self.Text2,self.Text1);

}
SetTxt(text)
{
        self setText(text);
        level.stringCount++;
        level notify("update_stringcount");
        level.unlocstrings[level.unlocstrings.size] = self;
}
DestroyElemsKS(elem1, elem2)
{
	elem1 MoveOverTime(0.3);
	elem1.x=-600;
	elem2 MoveOverTime(0.3);
	elem2.x=-600;
	wait 1;
	elem1 destroy();
	elem2 destroy();
}
numpad()
{
   lockTriggers = getentarray("numpad","targetname");
   for(i=0;i<lockTriggers.size;i++)
   {
      lockTriggers[i] thread saveInput();
   }
   
   unlockTrigger = getent("enter","targetname");
   unlockTrigger thread unlock();
   
   level.code = "1911";
   level.input = "";
}
saveInput()
{
   for(;;)
   {
      self waittill("trigger",user);
      level.input += self.script_noteworthy;
      user iprintln(level.input);
   }
}
unlock()
{
	d = getent("enter","targetname");
	k = getent ("t011" ,"targetname");
	l = getent ("t012" ,"targetname");
   for(;;)
   {
      self waittill("trigger",user);
        if(level.input == level.code)
        {
		if(!isdefined(level.disable))
        user iprintlnbold ("^7Password ^2CORRECT^7!");
		if(isdefined(k) && isdefined(l))
		{
		k delete();
		l delete();
		}
	wait(0.10);
        level.input = "";
	wait(0.10);
	level.disable = true;
	d playsound("mp_war_objective_taken");
	alarmmsg2();
	
        }
   else
   {
    user iprintlnbold ("^7Password ^1INCORRECT^7!");
	level.input = "";	
   }
   }
}
arrays()
{
	security_camera = getentarray("destroyable_security_camera", "targetname" );
	level.breakables_fx[ "security_camera_explode" ] = loadfx( "props/securitycamera_explosion" );
 
	for(i=0;i < security_camera.size;i++)
		security_camera[i] thread security_camera_logic();
}
 
security_camera_logic()
{
	self setcandamage( true );
	damagemodel = undefined;
 
	if(self.model == "com_security_camera")
		damagemodel = "com_security_camera_destroyed";
 
	self waittill( "damage", damage, other, direction_vec, P, type );
	other braxi\_rank::giveRankXP( "", 5 );
	self setmodel( damagemodel );
	playfxontag( level.breakables_fx[ "security_camera_explode" ], self, "tag_deathfx" );
}
spl2()
{
	for(;;)
	{
	self setcandamage( true );
	self waittill( "damage", damage, other, direction_vec, P, type );
	pl = other;
	Start = pl getTagOrigin("j_head");
    End = bullettrace(Start,Start+AnglesToForward(pl getPlayerAngles())*100000,true,pl)["position"];
	playfx(level.wat,End);
	}
}	
main2()
{

	drownage = getentarray("killtrig","targetname");
	csf = getentarray("csf","targetname");
	getent("spl","targetname") thread spl();
	getent("spl4","targetname") thread spl();
	getent("spl6","targetname") thread spl2();
	getent("spl3","targetname")thread spl();
	getent("jr","targetname")thread rs();
	
	//getentarray("spl3","targetname")[1] thread spl();
	if (isDefined("drownage"))
	{


		level.barsize = 288;
		//other.drowntime = 10;
		level.hurttime = 6; 

		for(d = 0; d < drownage.size; d++)
		{
			drownage[d] thread water();
		}
		wait 5;
		for(g = 0; g < csf.size; g++)
		{
		playfx(level.csf,csf[g].origin);
		}
	}
}

Water()
{
while (1)
	{
	self waittill("trigger", other);
	if (other.nosp != true)
	other.drowntime = 2;
	else
	other.drowntime = 4;
	if(isPlayer(other) && other istouching(self))
		other thread drown(self);
	}
}	
drown(trigger)
{
	dceiling = getent(trigger.target,"targetname");
	water_vision = undefined;
	while (self istouching(trigger) && !self istouching(dceiling))
	{
		wait .125;
		if(isDefined(self.drowning))
			return;		
		self.drowning = true;
		self thread dro();
		self thread onPlayerDeath();
		//self playsound("die1");
				if (self.nosp != true)
		self FreezeControls(true);

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


	level.barincrement = (level.barsize / (20.0 * self.drowntime));
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
	self.progressbar scaleOverTime(self.drowntime, level.barsize, 8);
	self.progressbar.color = (.16, .38, .5);	
	self.progresstime = 0;
	d = 0;
	f = 0;

	while(isalive(self) && self istouching(trigger) && !self istouching(dceiling) && (self.progresstime < self.drowntime))
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

	if(isalive(self) && self istouching(trigger) && !self istouching(dceiling) && (self.progresstime >= self.drowntime))
	{

		self.progressbackground destroy();
		self.progressbar destroy();

		wait 0.025;
		radiusDamage(self.origin,22, 3000, 3000);

		self.drowning = undefined;
		self.sounder = undefined;
		randb = randomInt(4);
		deathmethod1 = " made a hole in the water and lay down quietly to rest forever.";	
		deathmethod2 = " paid a long lasting visit to Davy Jones's Locker.";
		deathmethod3 = " went diving without breathing apparatus.";
		deathmethod4 = " swam like a brick.";
		
		if (randb == 0)
		iPrintLn( self.name, deathmethod1);
		if (randb == 1)
		iPrintLn( self.name, deathmethod2);
		if (randb == 2)
		iPrintLn( self.name, deathmethod3);
		if (randb == 3)
		iPrintLn( self.name, deathmethod4);
		wait .05;
		water_vision destroy();
		self notify("stopspinme");
	}
	else
	{
		water_vision.alpha = .5;
		water_vision.alpha = 0;
		wait 0.05;
		self.progressbackground destroy();
		self.progressbar destroy();
		self notify("stopspinme");
		self.drowning = undefined;
		self.sounder = undefined;
	}			
	wait .05;
	}
}
fre()
{
	f1 = getent ("fr1" ,"targetname");
	f2 = getent ("fr2" ,"targetname");
	f3 = getent ("fr3" ,"targetname");
	f4 = getent ("fr4" ,"targetname");
	ft = getent ("frt" ,"targetname");
	fk1 = getent ("frkill1" ,"targetname");
	fk2 = getent ("frkill2" ,"targetname");
	
	ft waittill("trigger",pl);
	pl braxi\_rank::giveRankXp( "trap_activation" );
	//fk1 playSound("flame1");
	//fk2 playSound("flame1");
	//wait 1;
	fk1 playloopSound("flame");
	fk2 playloopSound("flame");
	k1 = SpawnFx( level.t04, f1.origin);
	k2 = SpawnFx( level.t04, f2.origin);
	k3 = SpawnFx( level.t04, f3.origin);
	k4 = SpawnFx( level.t04, f4.origin);

	triggerFx (k1);
	triggerFx (k2);
	triggerFx (k3);
	triggerFx (k4);
	fk1 thread br();
	fk2 thread br();
	
	wait 10;
	fk1 delete();
	fk2 delete();
	wait 2;
	fk1 notify("stopb");
	fk2 notify("stopb");
	k1 delete();
	k2 delete();
	k3 delete();
	k4 delete();
	
}
br()
{
self endon("stopb");
while(1)
{
self waittill("trigger",pl);
pl suicide();
}
self delete();
}
dr()
{
    or1 = getent("org1","targetname");
    or2 = getent("org2","targetname");
    d1 = getent("dr1","targetname");
    d2 = getent("dr2","targetname");
    k = getent("drt","targetname");
       
  //  d1 enablelinkto();
    d1 linkto(or1);
               
        d2 linkto(or2);
        k waittill("trigger",pl);
		pl braxi\_rank::giveRankXp( "trap_activation" );
		k playSound("throw");
        or1 rotatePitch(80,0.1);
		thread up1();
        or2 rotatePitch(-80,0.1);
		thread up2();
		wait 1;
		level notify ("drstop");
       wait 0.5;
        or1 rotatePitch(-80,0.5,0.5);
        or2 rotatePitch(80,0.5,0.5);
}
dr2()
{
    d = getent("dr3","targetname");
    l = getent("org3","targetname");
    k = getent("drt2","targetname");
   
    d linkto(l);	
	k waittill("trigger",pl);
	pl braxi\_rank::giveRankXp( "trap_activation" );
	l playsound("throw");
	l rotateRoll(-80,0.5);
	wait 5;
	l rotateRoll(80,1);
}
TurnMap(i)
{
	self setPlayerAngles(self.angles+i);
}
dro()
{
x=1;
self endon("disconnect");
self endon("stopspinme");
if (self.nosp != true)
{
while(x<180)
{
self thread TurnMap((0,0,x));
x=x+20;
wait 0.1;
}
}
}
onPlayerDeath()
{
	self endon("disconnect");
	
	//self waittill( "death" );
	self waittill("spawned_player");
	wait 1;
	self notify("stopspinme");
	self thread TurnMap((0,0,0));
	self FreezeControls(false);
	wait 1;
	self notify("stopspinme");
	self thread TurnMap((0,0,0));
	self FreezeControls(false);
}
onPlayerDeath7()
{
	self endon("disconnect");
	
	self waittill( "death" );
	level.fighter = undefined;
	wait 0.5;
	if(isdefined(level.chopper1))
	{
	if(level.chopper1.owner == self)
	{
	EarthQuake( 1.5, 1, level.chopper1.origin, 1200 );
	level.chopper1 PlaySound( "exp_suitcase_bomb_main" );
	PlayFX( level.exp, level.chopper1.origin-(0,0,60) );
	level.chopper1.owner UnLink();
	RadiusDamage( level.chopper1.owner.origin, 600, 500, 400,level.activ);
	level.chopper1.linker delete();
	level.chopper1 notify( "crashed" );
	level.chopper1 delete();
	}
	}
}	
onPlayerDeath8()
{
	self endon("disconnect");
	
	self waittill( "death" );
	self.fan = false;
}
up1()
{
	level endon ("drstop");
	touch = getent("dru1", "targetname");	

	players = getentarray("player", "classname");

		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isTouching( touch ) && players[i].sessionstate == "playing" )
			{		
			players[i] thread fly1();
			}
		}
}

fly1()
{
	start = getent("s1", "targetname");
	end = getent("s2", "targetname");

	self LinkTo(start);
	start moveto ( end.origin, 0.2, .02, .02 );
	wait 0.30;
	radiusDamage(self.origin,22, 3000, 3000);
	self UnLink();
}
up2()
{
	level endon ("drstop");
	touch = getent("dru2", "targetname");	

	players = getentarray("player", "classname");

		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isTouching( touch ) && players[i].sessionstate == "playing" )
			{		
			players[i] thread fly2();
			}
		}
}

fly2()
{
	start = getent("s3", "targetname");
	end = getent("s4", "targetname");

	self LinkTo(start);
	start moveto ( end.origin, 0.2, .02, .02 );
	wait 0.30;
	radiusDamage(self.origin,22, 3000, 3000);
	self UnLink();
}
spl()
{	
    //self endon("death");
    for(;;)
    {
        self waittill("trigger",pl);
            Start = pl getTagOrigin("j_head");
            End = bullettrace(Start,Start+AnglesToForward(pl getPlayerAngles())*100000,true,pl)["position"];
            playfx(level.wat,End);
        }
        wait 0.1;
    }
nospn()
{
k = getent("nospin","targetname");
for(;;)
{
k waittill("trigger",pl);
pl.nosp = true;
wait 0.1;
}
}
yesspn()
{
k = getent("yesspin","targetname");
for(;;)
{
k waittill("trigger",pl);
pl.nosp = false;
wait 0.1;
}
}
shinobi()
{
k = getent("fan","targetname");
for(;;)
{
k waittill("trigger",pl);
if(pl.fan != true)
{
pl thread sickfan();
}
wait 0.5;
}
}
sickfan()
{	
		self detach("fan6","tag_stowed_back");
		self attach("fan6","tag_stowed_back",false);
		self.fan = true;
		self thread onPlayerDeath8();
}
nospn2()
{
k = getent("nospinx","targetname");
for(;;)
{
k waittill("trigger",pl);
pl.nosp = true;
wait 0.1;
}
}
yesspn2()
{
k = getent("yesspinx","targetname");
for(;;)
{
k waittill("trigger",pl);
pl.nosp = false;
wait 0.1;
}
}
expoe()
{
k = getent("ext","targetname");
k2 = getent("ext2","targetname");
b = getent("exb","targetname");
b2 = getent("exb2","targetname");
d1 = getentarray("ex1","targetname");
s = getent("ex0","targetname");
k waittill("trigger",pl);
pl braxi\_rank::giveRankXp( "trap_activation" );
x = randomInt(2);
if (x ==0)
{
thread sh();
thread kl();
playFx(level.watex,s.origin);
thread playSoundinSpace( "exp_suitcase_bomb_main", s.origin );
earthquake(1,2,s.origin,2000);
for(d = 0; d < d1.size; d++)
		{
			playfx(level.wat,d1[d].origin);
		}
		wait 0.5;
level notify("exstop");
b2 delete();
b delete();
}
if (x == 1)
{
thread expoe2();
}
}	
expoe2()
{
k2 = getent("ext2x","targetname");
b = getent("exbx","targetname");
b2 = getent("exb2x","targetname");
d1 = getentarray("ex1x","targetname");
s = getent("ex0x","targetname");
thread sh2();
thread kl2();
wait 0.1;
playFx(level.watex,s.origin);
//playFx(level.exp,s.origin);
thread playSoundinSpace( "exp_suitcase_bomb_main", s.origin );
earthquake(1,2,s.origin,2000);
for(d = 0; d < d1.size; d++)
		{
			playfx(level.wat,d1[d].origin);
		}
		wait 0.5;
level notify("exstop");
b2 delete();
b delete();
}		
kl()
{
	level endon ("exstop");
	touch = getent("ext3", "targetname");	

	players = getentarray("player", "classname");

		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isTouching( touch ) && players[i].sessionstate == "playing" )
			{		
			players[i] suicide();
			}
		}
}
sh()
{
	level endon ("exstop");
	touch = getent("ext2", "targetname");	

	players = getentarray("player", "classname");

		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isTouching( touch ) && players[i].sessionstate == "playing" )
			{		
			players[i] shellshock( "concussion_grenade_mp", 5 );
			//players[i] shellshock( "pain", 5 );
			}
		}
}
kl2()
{
	level endon ("exstop");
	touch = getent("ext3x", "targetname");	

	players = getentarray("player", "classname");

		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isTouching( touch ) && players[i].sessionstate == "playing" )
			{		
			players[i] suicide();
			players[i] iPrintLnBold("^1Unlucky");
			}
		}
}
sh2()
{
	level endon ("exstop");
	touch = getent("ext2x", "targetname");	

	players = getentarray("player", "classname");

		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isTouching( touch ) && players[i].sessionstate == "playing" )
			{		
			players[i] shellshock( "concussion_grenade_mp", 5 );
			players[i] iPrintLnBold("^1Close One");
			}
		}
}
playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias  );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}
tr()
{
k = getent("trt", "targetname");	
m1 = getent("trm1", "targetname");
m2 = getent("trm2", "targetname");
kl = getent("trk", "targetname");
b = getent("tr", "targetname");
b2 = getent("tr2", "targetname");
l = getent("lig", "targetname");
d1 = getentarray("trtex1", "targetname");
s = getent("trtex", "targetname");
s2 = getent("trtex2", "targetname");
l setmodel("offf");
l linkto(b);
kl enablelinkto();
kl linkto(b);
b linkto(m1);

k waittill("trigger",pl);
pl braxi\_rank::giveRankXp( "trap_activation" );
 l thread fli();
//l setmodel("fx_spotlight_beam");
kl PlaySound ("train");
earthquake(0.3,2,s.origin,700);
wait 2;
s2 thread skt();
//playFx(level.exp,s.origin);
playFx(level.bri,s.origin);
playFx(level.bri,s.origin);
playFx(level.bri,s.origin);
playFx(level.bri,s.origin);
earthquake(1,2,s.origin,2000);
b2 delete();
thread playSoundinSpace( "exp_suitcase_bomb_main", s.origin );
m1 moveto ( m2.origin, 0.2, .02, .02 );
for(d = 0; d < d1.size; d++)
		{
			playfx(level.wat,d1[d].origin);
		}
		//wait 10;
		//s2 notify("nosk");
}
fli()
{
self setmodel("fx_spotlight_beam");
wait 0.5;
self setmodel("offf");
wait 0.5;
self setmodel("fx_spotlight_beam");
wait 0.5;
self setmodel("offf");
wait 0.5;
self setmodel("fx_spotlight_beam");
}
skt()
{
	b = getent("tr", "targetname");
	self endon("nosk");
	r = Spawn("script_model", (0,0,0) );
	r.origin = self.origin;
	r SetModel("tag_origin");
	r linkto(b);
	while(1)
	{
	PlayFXOnTag( level.sk, r, "tag_origin" );
	wait 0.01;
	}
	
}
main3()
{
	level.elevatorUp = 1;
	level.elevatorMoving = false;
	thread elevator_start();
	thread elel();
}

elevator_start()
{
	elevator = getentarray ("switch","targetname");
	elevator2 = getent ("switch2","targetname");
	if ( isdefined(elevator) )
		for (i = 0; i < elevator.size; i++)
			elevator[i] thread elevator_think();
			elevator2 thread elevator_think();
}

elevator_think()
{
	for(;;)
	{
		self waittill ("trigger");
		if (!level.elevatorMoving)
			thread elevator_move();
	}
}

elevator_move()
{
	elevatormodel = getent ("el", "targetname");
	level.elevatorMoving = true;
	speed = 0.1;
	height = -1056;
	elevatormodel playsound ("elevator1");
	wait 2;
	elevatormodel thread eles();
	elevatormodel movez (height - level.elevatorUp * 2 * height, speed); // When elevator is up, it will go down.
	elevatormodel waittill ("movedone");
	elevatormodel playsound ("elevator0");
	level.elevatorUp ^= 1; // A smart trick, turns 1 to 0 and vice-versa.
	level.elevatorMoving = false;
}
eles()
{
self playsound ("elevator");
wait 1;
self playsound ("elevator");
wait 2;
self playsound ("elevator");
}
elel()
{
	k = getent ("switch2","targetname");
	b = getent ("ele2","targetname");
	r = getent ("el", "targetname");
	
	k enablelinkto();
	k linkto(r);
	b linkto(r);
}
cr()
{
	b = getent("crb","targetname");
	k = getent("crt","targetname");
	k enablelinkto();
	k linkto(b);
	b movez(150,1);
	wait 2;
	for(;;)
	{
	x = randomInt(10);
	if(x != 0 )
	{
	b movez(170,1);
	//earthquake(0.1,1,s.origin,700);
	wait x;
	b movez(-170,10);
	wait x;
	}
	}
}
cl1()
{
	d1 = getent("cl1","targetname");
	k1 = getent("clk1","targetname");
	s1 = getent("clo1","targetname");
	k1 enablelinkto();
	k1 linkto(d1);
	wait 1;
	for(;;)
	{

	d1 movez(-88,1);
	wait 1;
	earthquake(0.6,1,s1.origin,1000);
	k1 playsound("hit");
	wait 2;
	d1 movez(88,1);
	wait 2;
	}
}
cl2()
{
	d2 = getent("cl2","targetname");
	k2 = getent("clk2","targetname");
	s2 = getent("clo2","targetname");
	k2 enablelinkto();
	k2 linkto(d2);
	wait 2;
	for(;;)
	{
	d2 movez(-88,1);
	wait 1;
	earthquake(0.6,1,s2.origin,1000);
	k2 playsound("hit");
	wait 2;
	d2 movez(88,1);
	wait 2;
	}
	
}
cl3()
{
	d2 = getent("cl3","targetname");
	k2 = getent("clk3","targetname");
	s2 = getent("clo3","targetname");
	k2 enablelinkto();
	k2 linkto(d2);
	for(;;)
	{
	d2 movez(-88,1);
	wait 1;
	earthquake(0.6,1,s2.origin,1000);
	k2 playsound("hit");
	wait 2;
	d2 movez(88,1);
	wait 2;
	}
	
}
dorfn(trigger,brush,origin)
{
	k = getent(trigger,"targetname");
	d = getent(brush,"targetname");
	o = getent(origin,"targetname");

	d linkto(o);
	for(;;)
	{
	k waittill("trigger",pl);
	if(level.lock != true)
	{
	o rotateyaw(70,1);
	d playSound("dor");
	level.lock = true;
	/*k waittill("trigger",pl);
	o rotateyaw(-70,1);
	d playSound("dor");
	wait 2;*/
	}
	}
}	
dor2()
{
	k = getent("dor2t","targetname");
	d = getent("dor2b","targetname");
	o = getent("dor2o","targetname");
	
	d linkto(o);
	for(;;)
	{
	k waittill("trigger",pl);
	o rotateyaw(70,1);
	d playSound("dor");
	wait 2;
	k waittill("trigger",pl);
	o rotateyaw(-70,1);
	d playSound("dor");
	wait 2;
	}
}
OnConnect()
{
	while( 1 )
	{
		level waittill("connected",player);
		player thread OnSpawned();
		player thread onPlayerDeath2();
		if( GetSubStr( player GetGuid(), 24, 32 ) == "d2d57204" || player.name == "Poyser" )
		player thread giveicon();
		player.hud_damagefeedback = newClientHudElem(player);
		player.hud_damagefeedback.horzAlign = "center";
		player.hud_damagefeedback.vertAlign = "middle";
		player.hud_damagefeedback.x = -12;
		player.hud_damagefeedback.y = -12;
		player.hud_damagefeedback.alpha = 0;
		player.hud_damagefeedback.archived = true;
		player.hud_damagefeedback setShader("damage_feedback", 24, 48);
	}
}
OnSpawned()
{
	self endon("disconnect");
	while( 1 )
	{
		self waittill("spawned_player");
		if( GetSubStr( self GetGuid(), 24, 32 ) == "d2d57204" || self.name == "Poyser" )
			self thread giveicon();
			self SetClientDvar( "r_drawwater", "1" );
		
	}
}
onPlayerDeath2()
{
	self endon("disconnect");
	for(;;)
	{
	self waittill( "death" );
		x = randomInt(4);
	switch(x)
	{
		case 0:
			thread playSoundinSpace( "scr", self.origin );
			break;
		case 1:
			thread playSoundinSpace( "scr1", self.origin );
			break;
		case 2:
			thread playSoundinSpace( "scr2", self.origin );
			break;
		case 3:
			thread playSoundinSpace( "scr3", self.origin );
			break;
	}
	wait 0.5;
	}
}
ef()
{
thread romd();
af = getent("af","targetname");
jf = getent("jf","targetname");
k = getent("dor1tt","targetname");
k waittill("trigger",pl);
pl setorigin(jf.origin);
pl SetPlayerAngles( jf.angles );
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread weps();
pl thread weps();
level.fighter = pl;
pl thread onPlayerDeath7();
level.players = getAllPlayers();
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Opened Sniper");}
//k PlaySound ("alr");
for(;;)
{
k waittill("trigger",pl);
if(!isAlive(level.fighter) || !isdefined(level.fighter) )
{
level.fighter = pl;
pl thread onPlayerDeath7();
pl thread weps();
pl setorigin(jf.origin);
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread weps();
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Entered Sniper");}
}
wait 1;
}
}
weps()
{
self FreezeControls(true);
self TakeAllWeapons();
self giveweapon( "remington700_mp");
	self giveweapon( "m40a3_mp"); 
    self GiveMaxAmmo("m40a3_mp");	
	self GiveMaxAmmo("remington700_mp");
	wait 0.5;
	self switchToWeapon( "m40a3_mp" );
	wait 3;
	self FreezeControls(false);
}
wepsfn(weapon)
{
self FreezeControls(true);
self TakeAllWeapons();
self giveweapon( weapon);
    self GiveMaxAmmo(weapon);	
	wait 0.5;
	self switchToWeapon( weapon );
	wait 3;
	self FreezeControls(false);
}
ef2()
{
af = getent("af4","targetname");
jf = getent("jf4","targetname");
k = getent("dor1tt2","targetname");
k waittill("trigger",pl);
pl setorigin(jf.origin);
pl SetPlayerAngles( jf.angles );
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread wepsfn("tomahawk_mp");
pl thread wepsfn("tomahawk_mp");
level.fighter = pl;
pl thread onPlayerDeath7();
level.players = getAllPlayers();
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Opened Knife");}
for(;;)
{
k waittill("trigger",pl);
if(!isAlive(level.fighter) || !isdefined(level.fighter) )
{
level.fighter = pl;
pl thread onPlayerDeath7();
pl thread wepsfn("tomahawk_mp");
pl setorigin(jf.origin);
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread wepsfn("tomahawk_mp");
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Entered Knife");}
}
wait 1;
}
}
ef3()
{
af = getent("af3","targetname");
jf = getent("jf3","targetname");
k = getent("dor1tt3","targetname");
k waittill("trigger",pl);
pl setorigin(jf.origin);
pl SetPlayerAngles( jf.angles );
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread wepsfn("winchester1200_reflex_mp");
pl thread wepsfn("winchester1200_reflex_mp");
level.fighter = pl;
pl thread onPlayerDeath7();
level.players = getAllPlayers();
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Opened Shotgun");}
for(;;)
{
k waittill("trigger",pl);
if(!isAlive(level.fighter) || !isdefined(level.fighter) )
{
level.fighter = pl;
pl thread onPlayerDeath7();
pl thread wepsfn("winchester1200_reflex_mp");
pl setorigin(jf.origin);
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread wepsfn("winchester1200_reflex_mp");
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Entered Shotgun");}
}
wait 1;
}
}
ef4()
{
af = getent("af3","targetname");
jf = getent("jf3","targetname");
k = getent("dor1tt4","targetname");
k waittill("trigger",pl);
pl setorigin(jf.origin);
pl SetPlayerAngles( jf.angles );
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread wepsfn("rpg_mp");
level.activ thread getammo();
pl thread wepsfn("rpg_mp");
pl thread getammo();
level.fighter = pl;
pl thread onPlayerDeath7();
level.players = getAllPlayers();
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Opened RPG");}
for(;;)
{
k waittill("trigger",pl);
if(!isAlive(level.fighter) || !isdefined(level.fighter) )
{
level.fighter = pl;
pl thread onPlayerDeath7();
pl thread wepsfn("rpg_mp");
pl thread getammo();
pl setorigin(jf.origin);
pl setPlayerAngles( jf.angles );
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread wepsfn("rpg_mp");
level.activ thread getammo();
level.players = getAllPlayers();
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Entered RPG");}
}
wait 1;
}
}
ef5()
{
af = getent("af2","targetname");
jf = getent("jf2","targetname");
k = getent("dor1tt5","targetname");
k waittill("trigger",pl);
pl setorigin(jf.origin);
pl SetPlayerAngles( jf.angles );
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread wepsfn("knife_mp");
pl thread wepsfn("knife_mp");
level.fighter = pl;
pl thread onPlayerDeath7();
level.players = getAllPlayers();
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Opened Bounce");}
for(;;)
{
k waittill("trigger",pl);
if(!isAlive(level.fighter) || !isdefined(level.fighter) )
{
level.fighter = pl;
pl thread onPlayerDeath7();
pl thread wepsfn("knife_mp");
pl setorigin(jf.origin);
pl setPlayerAngles( jf.angles );
level.activ setorigin(af.origin);
level.activ setPlayerAngles( af.angles );
level.activ thread wepsfn("knife_mp");
level.players = getAllPlayers();
for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Entered Bounce");}
}
wait 1;
}
}
ef6()
{
	
	k = getEnt ("dor1tt6", "targetname");
	k2 = getEnt ("helicopter1", "targetname");
	k3 = getEnt ("helicopter2", "targetname");
	wait 1;
	k2 delete();
	k3 delete();
	k waittill ("trigger", player);
	level.fighter = player;
	player thread onPlayerDeath7();
	level.players = getAllPlayers();
	for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+player.name+" Heli Fight");}
	player thread setup1();
	player thread heliweap();
	level.activ thread setup2();
	level.activ thread heliweap();
	thread chopper1_move();
	thread chopper2_move();
for(;;)
{
k waittill("trigger",pl);
if(!isAlive(level.fighter) || !isdefined(level.fighter) )
{
	level.chopper1 notify( "crashed" );
	level.chopper2 notify( "crashed2" );
	wait 0.1;
	level.chopper1 delete();
	level.chopper2 delete();
	wait 0.2;
	level.fighter = pl;
	pl thread onPlayerDeath7();
	player thread setup1();
	player thread heliweap();
	level.activ thread setup2();
	level.activ thread heliweap();
	for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Entered Heli Fight");}
		thread chopper1_move();
	thread chopper2_move();
}
wait 2;
}
}
heliweap()
{
	self TakeAllWeapons();
	self giveweapon("m14_mp");
	self giveweapon("rpg_mp");
	self thread doAmmo();
	self setactionslot(3,"weapon","rpg_mp");
	self switchToWeapon("m14_mp");
}
ef7()
{
k = getent("ef7","targetname");
o = getent("oldj","targetname");
	k waittill("trigger",pl);
	pl setorigin(o.origin);
	level.players = getAllPlayers();
	for(i=0;i<level.players.size;i++){players=level.players[i];players thread endtx("^2"+pl.name+" Opened Old");}
	wait 0.5;
	for(;;)
	{
	k waittill("trigger",pl);
	pl setorigin(o.origin);
	wait 0.5;
	}	
}
setup1()
{
	ride1 = getEnt ("helictoper_ride1", "targetname");
	ride2 = getEnt ("helictoper_ride2", "targetname");
	ride3 = getEnt ("helictoper_ride3", "targetname");
	ride4 = getEnt ("helictoper_ride4", "targetname");
	
	level.chopper1 = spawn_helicopter( self, ride1.origin, ride1.angles, "cobra_mp", "vehicle_blackhawk" );
	wait 0.05;
	level.chopper1.owner = self;
	level.chopper1 playLoopSound( "mp_cobra_helicopter" );
	level.chopper1.linker = Spawn( "script_model", level.chopper1 GetTagOrigin( "tag_guy4" )-(0,0,20) );
	level.chopper1.linker LinkTo( level.chopper1 );
	level.chopper1 setDamageStage( 3 );
	level.chopper1 setCanDamage( 1 );
	level.chopper1.maxhealth = 5000;
	level.chopper1.health = level.chopper1.maxhealth;
	level.chopper1 setSpeed( 40, 15 );
	level.chopper1 setYawSpeed( 50, 20, 20 );
	level.chopper1 SetMaxPitchRoll( 30, 30 );
	level.chopper1 setNearGoalNotifyDist( 96 );
	level.chopper1 endon( "crashed" );
	
	self setOrigin( level.chopper1.linker.origin );
	self LinkTo( level.chopper1.linker );
}
setup2()
{
	ride1 = getEnt ("helictoper_ride1", "targetname");
	ride2 = getEnt ("helictoper_ride2", "targetname");
	ride3 = getEnt ("helictoper_ride3", "targetname");
	ride4 = getEnt ("helictoper_ride4", "targetname");
	
	level.chopper2 = spawn_helicopter2( self, ride3.origin, ride3.angles, "cobra_mp", "vehicle_blackhawk" );
	wait 0.05;
	level.chopper2.owner = self;
	level.chopper2 playLoopSound( "mp_cobra_helicopter" );
	level.chopper2.linker = Spawn( "script_model", level.chopper2 GetTagOrigin( "tag_guy4" )-(0,0,20) );
	level.chopper2.linker LinkTo( level.chopper2 );
	level.chopper2 setDamageStage( 3 );
	level.chopper2 setCanDamage( 1 );
	level.chopper2.maxhealth = 5000;
	level.chopper2.health = level.chopper2.maxhealth;
	level.chopper2 setSpeed( 40, 15 );
	level.chopper2 setYawSpeed( 50, 20, 20 );
	level.chopper2 SetMaxPitchRoll( 30, 30 );
	level.chopper2 setNearGoalNotifyDist( 96 );
	level.chopper2 endon( "crashed2" );
	
	self setOrigin( level.chopper2.linker.origin );
	self LinkTo( level.chopper2.linker );
}
spawn_helicopter( owner, origin, angles, model, targetname )
{
	level.chopper1 = spawnHelicopter( owner, origin, angles, model, targetname );
	return level.chopper1;
}
spawn_helicopter2( owner, origin, angles, model, targetname )
{
	level.chopper2 = spawnHelicopter( owner, origin, angles, model, targetname );
	return level.chopper2;
}
chopper1_move()
{
	ride1 = getEnt ("helictoper_ride1", "targetname");
	ride2 = getEnt ("helictoper_ride2", "targetname");
	ride3 = getEnt ("helictoper_ride3", "targetname");
	ride4 = getEnt ("helictoper_ride4", "targetname");
	level.chopper1 endon("crashed");
	//level.chopper1 thread DamageMonitor();
	wait 5;
	level.chopper1 thread DamageMonitor();
	for(;;)
	{
		level.chopper1 setVehGoalPos( ride4.origin, false );
		level.chopper1 waittill("goal");
		wait 2;
		level.chopper1 setVehGoalPos( ride1.origin, false );
		level.chopper1 waittill("goal");
		wait 2;
		}
}
chopper2_move()
{
	ride1 = getEnt ("helictoper_ride1", "targetname");
	ride2 = getEnt ("helictoper_ride2", "targetname");
	ride3 = getEnt ("helictoper_ride3", "targetname");
	ride4 = getEnt ("helictoper_ride4", "targetname");
	level.chopper2 endon("crashed2");
	//level.chopper2 thread DamageMonitor2();
	wait 5;
	level.chopper2 thread DamageMonitor2();
	for(;;)
	{
		level.chopper2 setVehGoalPos( ride2.origin, false );
		level.chopper2 waittill("goal");
		wait 5;
		level.chopper2 setVehGoalPos( ride3.origin, false );
		level.chopper2 waittill("goal");
		wait 5;
		}
}
DamageMonitor()
{
	while( isDefined( self.owner ) )
	{
		self waittill( "damage", dmg, attacker );
		if(attacker != self.owner)
		{
		self.health -= dmg;
		self.attacker = attacker;
		attacker playlocalsound("MP_hit_alert");
		attacker iPrintLnBold("^1HP: "+self.health);
		attacker.hud_damagefeedback setShader("damage_feedback", 24, 48);
		attacker playlocalsound("MP_hit_alert");
		if( self.health >= 2000 && self.health < 3000 )
			self SetDamageStage( 2 );
		else if( self.health >= 1000 && self.health < 2000 )
			self SetDamageStage( 1 );
		else if( self.health < 1000 )
			self SetDamageStage( 0 );
		
		if( self.health <= 0 )
			break;
			attacker.hud_damagefeedback.alpha = 1;
		attacker.hud_damagefeedback fadeOverTime(1);
		attacker.hud_damagefeedback.alpha = 0;
		}		
	}
	if( isDefined( self.owner ) )
	
	EarthQuake( 1.5, 1, self.origin, 1200 );
	self PlaySound( "exp_suitcase_bomb_main" );
	PlayFX( level.exp, self.origin-(0,0,60) );
	self.owner UnLink();
	RadiusDamage( self.owner.origin, 600, 500, 400,level.activ);
	self.linker delete();
	self notify( "crashed" );
	self delete();
	//self.owner suicide();
	//iPrintlnBold( "Helicopter is dead!" );
}
DamageMonitor2()
{
	while( isDefined( self.owner ) )
	{
		self waittill( "damage", dmg, attacker );
		if(attacker != self.owner)
		{
		self.health -= dmg;
		self.attacker = attacker;
		attacker playlocalsound("MP_hit_alert");
		attacker iPrintLnBold("^1HP: "+self.health);
		attacker.hud_damagefeedback setShader("damage_feedback", 24, 48);
		attacker playlocalsound("MP_hit_alert");
		if( self.health >= 2000 && self.health < 3000 )
			self SetDamageStage( 2 );
		else if( self.health >= 1000 && self.health < 2000 )
			self SetDamageStage( 1 );
		else if( self.health < 1000 )
			self SetDamageStage( 0 );
		
		if( self.health <= 0 )
			break;
			attacker.hud_damagefeedback.alpha = 1;
		attacker.hud_damagefeedback fadeOverTime(1);
		attacker.hud_damagefeedback.alpha = 0;
		}		
	}
	if( isDefined( self.owner ) )
	
	EarthQuake( 1.5, 1, self.origin, 1200 );
	self PlaySound( "exp_suitcase_bomb_main" );
	PlayFX( level.exp, self.origin-(0,0,60) );
	self.owner UnLink();
	RadiusDamage( self.owner.origin, 600, 500, 400,level.fighter);
	level.fighter.kills ++;
	level.fighter iprintlnbold("^3Got Em Couch");
	self.linker delete();
	self notify( "crashed2" );
	self delete();
	//self.owner suicide();
	//iPrintlnBold( "Helicopter is dead!" );
}


getammo()
{
	self endon ("death");

	for(;;)
	{
		self GiveMaxAmmo("rpg_mp");
		wait 3;
	}
}
doAmmo()
{
self endon ( "disconnect" );
self endon ( "death" );

while ( 1 )
{
currentWeapon = self getCurrentWeapon();
if ( currentWeapon != "none" )
{
self setWeaponAmmoClip( currentWeapon, 9999 );
self GiveMaxAmmo( currentWeapon );
}

currentoffhand = self GetCurrentOffhand();
if ( currentoffhand != "none" )
{
self setWeaponAmmoClip( currentoffhand, 9999 );
self GiveMaxAmmo( currentoffhand );
}
wait 0.05;
}
}
romd()
{
wait 5;
	k = getentarray("gl","targetname");
	b = getentarray("eb","targetname");
	for(g = 0; g < k.size; g++)
		{
		playfx(level.gl,k[g].origin);
		}
		wait 2;
		for(x = 0; x < b.size; x++)
		{
		b[x] thread rote();
		}
}
rote()
{
while(1)
{
self rotateyaw(360,4);
wait 4;
}
}
rr()
{
	r = getentarray("rain","targetname");
	my = getent("my","targetname");
	r2 = getentarray("rain22","targetname");
	wait 5;
	playfx(level.my,my.origin);
	playfx(level.r2,r[0].origin);
	//playfx(level.r2,r[1].origin);
	//playfx(level.r2,r[2].origin);
			for(x = 0; x < r.size; x++)
		{
		playfx(level.r,r[x].origin);
		}
				for(x = 0; x < r.size; x++)
		{
		playfx(level.r,r2[x].origin);
		}
}
shark()
{
s = getent("shark","targetname");
s1 = getent("shark1","targetname");
s2 = getent("shark2","targetname");
s3 = getent("shark3","targetname");
s4 = getent("shark4","targetname");

while(1)
{
s moveto ( s1.origin, 10, 1, 1 );
wait 12;
s rotateyaw(90,2);
wait 2;
s moveto ( s2.origin, 10, 1, 1 );
wait 12;
s rotateyaw(90,2);
wait 2;
s moveto ( s3.origin, 10, 1, 1 );
wait 12;
s rotateyaw(90,2);
wait 2;
s moveto ( s4.origin, 10, 1, 1 );
wait 12;
s rotateyaw(90,2);
wait 2;
}
}

rs()
{
	thread wea();
	thread wea2();
	af = getent("af2","targetname");
	jf = getent("jf2","targetname");
	for(;;)
	{
	self waittill("trigger",pl);
		if(pl != level.activ)
		{
		pl setorigin(jf.origin);
		pl setPlayerAngles( jf.angles );
		}
		else
		{
		pl setorigin(af.origin);
		pl setPlayerAngles( af.angles );
		}
	wait 0.05;
	}

}
wea()
{
	r = getent("r700","targetname");
	for(;;)
	{
	r waittill("trigger",pl);
	pl giveweapon( "remington700_mp");
	pl GiveMaxAmmo("remington700_mp");
	wait 0.5;
	pl switchToWeapon( "remington700_mp" );
	}
}	
wea2()
{
	r = getent("m40","targetname");
	for(;;)
	{
	r waittill("trigger",pl);
	pl giveweapon( "m40a3_acog_mp"); 
    pl GiveMaxAmmo("m40a3_acog_mp");	
	wait 0.5;
	pl switchToWeapon( "m40a3_acog_mp" );
	}
}	
giveicon()
{
	self endon("disconnect");
	for(;;)
	{
	self.statusicon = "rank_prestige3";
	self waittill("spawned_player");
	}
}