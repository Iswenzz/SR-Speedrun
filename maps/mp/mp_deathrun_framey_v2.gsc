main()
{
	maps\mp\_load::main();
	
	// ambientplay("sound_1");
	// Print3d( (0,0,0), "START", (1.0, 0.8, 0.5), 1000, 1000, 100000 );
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
		
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
		
		
	thread way_connect();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	thread move();
	thread startdoor();
	thread door();
	thread walljump();
	thread secretshaft();
	// thread weaponroom();
	// thread deagle_trigger();
	// thread	m40a3_trigger();
	// thread barrett_trigger();
	// thread ak74u_trigger();
	// thread weaponroommessage();
	// thread trap_spinner();
	// thread oldgame();
	// thread jumpgame();
	thread movejump1();	
	thread movejump2();
	// thread actdoor();
	// thread jumperdoor();
	// thread activatorblocker();
	thread secretweaponroom();
	// thread picksniper();
	// thread takeguns();
	//thread moveclimb();
	//thread lift();
	}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////
	
lift()
{
lift=getent("lift","targetname");
trig=getent("trigger_lift","targetname");
while(1)
{
trig waittill ("trigger");
lift movez (500,7,1.9,1.9);
lift waittill ("movedone");
wait(1);
lift movez (-500,7,1.9,5);
lift waittill ("movedone");
}
}

move()
{
platform=getent("platform","targetname");
// while(1)
// {
// platform movey(-900,5,0.5,4.5);
// platform waittill ("movedone");
// wait (2);
// platform movey(900,5,0.5,4.5);
// platform waittill ("movedone");
// } 


}

movejump1()
{
platformjump1=getent("platformjump1","targetname");
while(1)
{
platformjump1 movey(-317,3,0.5,2.5);
platformjump1 waittill ("movedone");
platformjump1 movey(317,3,0.5,2.5);
platformjump1 waittill ("movedone");
} 
}

movejump2()
{
platformjump2=getent("platformjump2","targetname");
while(1)
{
platformjump2 movey(-317,3,0.5,2.5);
platformjump2 waittill ("movedone");
platformjump2 movey(317,3,0.5,2.5);
platformjump2 waittill ("movedone");
} 
}

trap7_mover_mid()
{
while(1)
{
self movez(-75,1,0.1,0.9);
self waittill("movedone");
wait(1);
self movez(75,0.5,0.1,0.4);
self waittill("movedone");
} 
}

startdoor()
{
door=getent("door","targetname");
door delete();
}

activatorblocker()
{
blocker=getent("activatorblocker","targetname");
wait(10);
blocker movez(-325,10,1,9);
blocker waittill ("movedone");
}

deagle_trigger()
{
trigger = getEnt("trigger_deagle", "targetname");
precacheItem("deserteaglegold_mp");	
while(1)
{
trigger waittill("trigger", player);
player takeallweapons();
player GiveWeapon("deserteaglegold_mp");
player SwitchToWeapon( "deserteaglegold_mp" );
}
}

m40a3_trigger()
{
trigger = getEnt("buy_m40a3", "targetname");
precacheItem("m40a3_mp");	
while(1)
{
trigger waittill("trigger", player);
player takeallweapons();
player GiveWeapon("m40a3_mp");
player SwitchToWeapon( "m40a3_mp" );
}
}

barrett_trigger()
{
trigger = getEnt("buy_50cal", "targetname");
precacheItem("barrett_mp");	
while(1)
{
trigger waittill("trigger", player);
player takeallweapons();
player GiveWeapon("barrett_mp");
player SwitchToWeapon( "barrett_mp" );
}
}

ak74u_trigger()
{
trigger = getEnt("buy_ak74u", "targetname");
precacheItem("ak74u_mp");	
while(1)
{
trigger waittill("trigger", player);
player takeallweapons();
player GiveWeapon("ak74u_mp");
player SwitchToWeapon( "ak74u_mp" );
}
}

snipergame()
{
level.sniper_trigger = getEnt("trigger_sniperroom", "targetname");
finaldoor_sniper = getEnt("finaldoor_sniper","targetname");
end_right = getEnt("end_right","targetname");
end_left = getEnt("end_left","targetname");
picksniperorigin = getEnt("picksniperorigin","targetname");
picksniper = getEnt("picksniper","targetname");
takeguns = getEnt("takeguns","targetname");
takegunsorigin = getEnt("takegunsorigin","targetname");
picksniper EnableLinkTo();
picksniper LinkTo(picksniperorigin);
takeguns EnableLinkTo();
takeguns LinkTo(takegunsorigin);
precacheItem("remington700_mp");
if( isDefined( level.trapsDisabled ) && level.trapsDisabled)
{
iPrintLnBold("This door is locked"); //Change the message if you want
}
else
{
level.sniper_trigger waittill("trigger", player);
finaldoor_sniper movez(-400,5);
end_right movez(-1000,1);
end_left movez(-1000,1);
self movez(70,1);
player takeallweapons();
player GiveWeapon("remington700_mp");
player GiveWeapon("m40a3_mp");
player SwitchToWeapon( "remington700_mp" );
level.activ takeallweapons();
level.activ GiveWeapon("remington700_mp");
level.activ GiveWeapon("m40a3_mp");
level.activ SwitchToWeapon( "remington700_mp" );
level.old_trigger delete();
level.jump_trigger delete();
level.sniper_trigger delete();
finaldoor = getEnt("finaldoor", "targetname");
finaldoor moveZ( -210,2);
iPrintLnBold("^1 " + player.name + "^7 Has picked ^2Sniper Game!"); //Change the message if you want
picksniperorigin movez(40,1);
takegunsorigin movez(150,1);
}
}

picksniper()
{
picksniper = getEnt("picksniper","targetname");
while(1)
{
picksniper waittill("trigger", player);
player takeallweapons();
player GiveWeapon("remington700_mp");
player GiveWeapon("m40a3_mp");
player SwitchToWeapon( "remington700_mp" );
}
}

takeguns()
{
takeguns = getEnt("takeguns","targetname");
while(1)
{
takeguns waittill("trigger", player);
if( player HasWeapon( "remington700_mp" ))
{
player GiveWeapon("m40a3_mp");
}
if(player HasWeapon( "m40a3_mp"))
{
player GiveWeapon("remington700_mp");
}
else
{
player takeallweapons();
player GiveWeapon("remington700_mp");
player GiveWeapon("m40a3_mp");
player SwitchToWeapon( "remington700_mp" );
}
}
}

oldgame()
{
level.old_trigger = getEnt("trigger_old", "targetname");
door_old = getEnt("door_old","targetname");	
level.old_trigger waittill("trigger", player);
door_old movez(-400,5);
level.jump_trigger delete();
level.sniper_trigger delete();
level.old_trigger delete();
finaldoor = getEnt("finaldoor", "targetname");
finaldoor moveZ( -210,2);
iPrintLnBold("^1 " + player.name + " ^7Has picked ^2Classic!"); //Change the message if you want
}

jumpgame()
{
level.jump_trigger = getEnt("trigger_jumpgame", "targetname");
jumpgame = getEnt("jumpgame","targetname");	
end_right = getEnt("end_right","targetname");
end_left = getEnt("end_left","targetname");
jumpgameroom = getEnt("jumpgameroom","targetname");
jumpgamewall = getEnt("jumpgamewall","targetname");
level.jump_trigger waittill("trigger", player);
jumpgame movez(-400,5);
level.sniper_trigger delete();
level.old_trigger delete();
level.jump_trigger delete();
end_right movez(-1000,1);
end_left movez(-1000,1);
jumpgameroom movez(-350,1);	
jumpgamewall movez(340,1);	
finaldoor = getEnt("finaldoor", "targetname");
finaldoor moveZ( -210,2);
iPrintLnBold("^1 " + player.name + " ^7Has picked ^2JumperGame!"); //Change the message if you want
}

actdoor()
{
trigger_actdoor=getEnt("trigger_actdoor", "targetname");
actdoor = getEnt("actdoor","targetname");
jumperdoor = getEnt("jumperdoor","targetname");
trigger_actdoor delete();
actdoor movez(-300,3);
jumperdoor movez(-300,3);
}

jumperdoor()
{
trigger_jumperdoor=getEnt("trigger_jumperdoor", "targetname");
jumperdoor = getEnt("jumperdoor","targetname");
actdoor = getEnt("actdoor","targetname");
jumperdoor movez(-300,3);
actdoor movez(-300,3);
}


door()
{
	door = getEnt("firstdoor", "targetname");
	trigger = getEnt("door_trig", "targetname");
	second_area = getEnt("second_area", "targetname");
	trigger delete();
	second_area delete();
	door delete();
}

weaponroommessage()
{
	trigger = getEnt("trigger_weaponroom", "targetname");	
	trigger waittill("trigger", player);
	iPrintLnBold(player.name + "^3 has entered the Secret room!"); //Change the message if you want
	trigger delete();
}
	
walljump()
{
	trigger = getEnt("walljump", "targetname");	
	shortcut=getent("shortcut","targetname");
	
	trigger delete();
	
}

trap1()
{
trap1blok1=getent("trap1blok1","targetname");
trap1blok2=getent("trap1blok2","targetname");
trap1blok3=getent("trap1blok3","targetname");
trap1blok4=getent("trap1blok4","targetname");
trap1blok5=getent("trap1blok5","targetname");
act1=getent("trigger_trap1","targetname");
act1 waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
iPrintLnBold(player.name + "^6 is a pussy trying to activate on free !"); //Change the message if you want
}
else
{
while(1)
{
trap1blok1 movez (50,1,0.1,0.9);
wait(1);
trap1blok1 movez (-50,1,0.1,0.9);

trap1blok4 movez (50,1,0.1,0.9);
trap1blok5 movez (50,1,0.1,0.9);
trap1blok2 movez (50,1,0.1,0.9);
wait(1);
trap1blok2 movez (-50,1,0.1,0.9);
trap1blok4 movez (-50,1,0.1,0.9);
trap1blok5 movez (-50,1,0.1,0.9);

trap1blok3 movez (50,1,0.1,0.9);
wait(1);
trap1blok3 movez (-50,1,0.1,0.9);
}
}
}


trap2()
{
trap2spike=getent("trap2spike","targetname");
trap2spike2=getent("trap2spike2","targetname");
trap2spike3=getent("trap2spike3","targetname");
trap2spike4=getent("trap2spike4","targetname");
trap2spike5=getent("trap2spike5","targetname");
trap2spike6=getent("trap2spike6","targetname");
trap2spike7=getent("trap2spike7","targetname");
trap2spike8=getent("trap2spike8","targetname");
trap2spike9=getent("trap2spike9","targetname");
trap2killer=getent("trap2killer","targetname");
act2=getent("trigger_trap2","targetname");
trap2killer EnableLinkTo();
trap2killer LinkTo(trap2spike);
act2 waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
iPrintLnBold(player.name + "^6 is a pussy trying to activate on free !"); //Change the message if you want
}
else
{
trap2killer movez (95,1,0.1,0.9);
trap2spike movez (95,1,0.1,0.9);
trap2spike2 movez (95,1,0.1,0.9);
trap2spike3 movez (95,1,0.1,0.9);
trap2spike4 movez (95,1,0.1,0.9);
trap2spike5 movez (95,1,0.1,0.9);
trap2spike6 movez (95,1,0.1,0.9);
trap2spike7 movez (95,1,0.1,0.9);
trap2spike8 movez (95,1,0.1,0.9);
trap2spike9 movez (95,1,0.1,0.9);
wait(1);
trap2killer movez (-96,1,0.1,0.9);
trap2spike movez (-95,3,2.9,0.1);
trap2spike2 movez (-95,3,2.9,0.1);
trap2spike3 movez (-95,3,2.9,0.1);
trap2spike4 movez (-95,3,2.9,0.1);
trap2spike5 movez (-95,3,2.9,0.1);
trap2spike6 movez (-95,3,2.9,0.1);
trap2spike7 movez (-95,3,2.9,0.1);
trap2spike8 movez (-95,3,2.9,0.1);
trap2spike9 movez (-95,3,2.9,0.1);
trap2spike waittill ("movedone");
trap2spike2 waittill ("movedone");
trap2spike3 waittill ("movedone");
trap2spike4 waittill ("movedone");
trap2spike5 waittill ("movedone");
trap2spike6 waittill ("movedone");
trap2spike7 waittill ("movedone");
trap2spike8 waittill ("movedone");
trap2spike9 waittill ("movedone");
act2 delete();
}
}


trap3()
{
trap3pusher=getent("trap3pusher","targetname");
act3=getent("trigger_trap3","targetname");
act3 waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
iPrintLnBold(player.name + "^6 is a pussy trying to activate on free !"); //Change the message if you want
}
else
{
trap3pusher movex (300,1,0.1,0.9);
trap3pusher waittill ("movedone");
wait(1);
trap3pusher movez (-180,1,0.1,0.9);
trap3pusher waittill ("movedone");
wait(12);
trap3pusher movez (-1200,20,0.1,19.9);
trap3pusher waittill ("movedone");
act3 delete();
}
}

ra_rotate()
{
if (!isdefined(self.speed))
 self.speed = 10;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";
trigger_trap5=getent("trigger_trap5","targetname");
trigger_trap5 waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
iPrintLnBold(player.name + "^6 is a pussy trying to activate on free !"); //Change the message if you want
}
else
{
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}
}

trap_4rotate()
{
if (!isdefined(self.speed))
 self.speed = 1;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";
trigger_trap4=getent("trigger_trap4","targetname");
trigger_trap4 waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
iPrintLnBold(player.name + "^6 is a pussy trying to activate on free !"); //Change the message if you want
}
else
{
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}
}

secretshaft()
	{
	door = getEnt("door_secretroom", "targetname");
	trigger = getEnt("trigger_secretroom", "targetname");
	trigger waittill("trigger", player);
	if( isDefined( level.trapsDisabled ) && level.trapsDisabled )
	{
	iPrintLnBold(player.name + "^3 isnt strong enough to open the shaft !"); //Change the message if you want
	}
	else
	{
	trigger delete();
	door moveZ( -200, 6);
	iPrintLnBold(player.name + "^3 opened the shaft !"); //Change the message if you want
	}
	}
	

weaponroom()
{
	trigger = getEnt("trigger_weaponroomshot", "targetname");
	rpgroom = getEnt("rpgroom", "targetname");
	trigger waittill("trigger", player);
	iPrintLnBold(player.name + "^3 has made ^1THE PERFECT HEADSHOT!"); //Change the message if you want
	rpgroom movex (-600,1);
	trigger delete();
	iPrintLnBold("A wall has moved ?"); //Change the message if you want
}

secretweaponroom()
{
	door = getEnt("clip_weaponroom", "targetname");
	shot1 = getEnt("shot1", "targetname");
	shot2 = getEnt("shot2", "targetname");
	shot3 = getEnt("shot3", "targetname");
	shot4 = getEnt("shot4", "targetname");
	shot6 = getEnt("shot5", "targetname");
	shot8 = getEnt("shot6", "targetname");
	shot5 = getEnt("shot7use", "targetname");
	shot7 = getEnt("shot8use", "targetname");
	shot1 waittill("trigger", player);
	shot2 waittill("trigger", player);
	shot3 waittill("trigger", player);
	shot4 waittill("trigger", player);
	shot5 waittill("trigger", player);
	shot6 waittill("trigger", player);
	shot7 waittill("trigger", player);
	shot8 waittill("trigger", player);
	door moveZ( 1000, 1);
}

trap_twisterrotate()
{
if (!isdefined(self.speed))
 self.speed = 1;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "z";
trigger_twister=getent("trigger_twister","targetname");
twister=getent("twister","targetname");
trigger_twister waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
iPrintLnBold(player.name + "^6 is a pussy trying to activate on free !"); //Change the message if you want
}
else
{
while(true)
{
twister movez(-200,5,0.5,4.5);
twister waittill ("movedone");
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
 twister movez(200,5,0.5,4.5);
twister waittill ("movedone");
}
}
}

trap_spinner()
{
trigger_spinner=getent("trigger_spinner","targetname");
spinner=getent("spinner","targetname");
spinner1=getent("spinner1","targetname");
trigger_spinner waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
iPrintLnBold(player.name + "^6 is a pussy trying to activate on free !"); //Change the message if you want
}
else
{
spinner movez(245,1,0.1,0.9);
wait(1);
spinner1 movez(245,0.5,0.1,0.4);
}
}

trap7_mover_right()
{
trigger_trap7=getent("trigger_trap7","targetname");
trigger_trap7 waittill ("trigger", player);
if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
{
iPrintLnBold(player.name + "^6 is a pussy trying to activate on free !"); //Change the message if you want
}
else
{
while(1)
{
self movez(75,1,0.1,0.9);
self waittill("movedone");
wait(1);
self movez(-75,0.5,0.1,0.4);
self waittill("movedone");
}
}
}

lasttrap()
{
if (!isdefined(self.speed))
 self.speed = 1;
if (!isdefined(self.script_noteworthy))
 self.script_noteworthy = "y";
while(true)
{
 // rotateYaw(float rot, float time, <float acceleration_time>, <float deceleration_time>);
 if (self.script_noteworthy == "z")
  self rotateYaw(360,self.speed);
 else if (self.script_noteworthy == "x")
  self rotateRoll(360,self.speed);
 else if (self.script_noteworthy == "y")
  self rotatePitch(360,self.speed);
 wait ((self.speed)-0.1); // removes the slight hesitation that waittill("rotatedone"); gives.
 // self waittill("rotatedone");
}
}
