/*
______________________________________________
  /   /  ___/    ___/   ___/  \     / /  ___  \
 /   /  /__     /___   /__/ /\ \   / /  /  /  /
/   /  ___/  __    /  ___/ /  \ \ / /  /  /  /
  _/  /__   /_/   /	 /__/ /    \ \ /  /__/  /
___\____/________/\____/_/	    \_/________/

Thanks on decompiling noob... learn to script...
*/
main()
{

	maps\mp\_load::main();

	level._effect["barrelexpfx"] = loadfx ("industry_v2/barellexp");
	level._effect["trapfire"] = loadfx ("industry_v2/trapfire");
	level._effect["dmgring"] = loadfx ("industry_v2/dmgring");
	level._effect["trapfire2"] = loadfx ("fire/fire_wall_50");
	level._effect["electrisiti"] = loadfx ("industry_v2/electrisiti");
	level._effect["ram"] = loadfx ("industry_v2/radioactive_mist");
	level._effect["yellow_beacon"] = loadfx( "misc/ui_pickup_available" );

	PreCacheItem("ak47_mp");
	PreCacheItem("dragunov_mp");
	PreCacheItem("p90_mp");
	PreCacheItem("rpg_mp");
	PreCacheItem("m4_mp");
	PreCacheItem("colt45_mp");
	PreCacheItem("mp5_mp");
	PreCacheItem("g3_mp");
	PreCacheItem("ak74u_mp");

	precachemodel("body_mp_usmc_cqb");
	precachemodel("weapon_colt1911_black");
	precachemodel("weapon_g3");
	precachemodel("weapon_ak74u");

	PreCacheShellShock("radiation_high");
	
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

	setdvar("bg_fallDamageMaxHeight","99999");
	setdvar("bg_fallDamageMinHeight","99998");

	addTriggerToList("trap1trig");
	addTriggerToList("trap2trig");
	addTriggerToList("trap3trig");
	addTriggerToList("trap4trig");
	addTriggerToList("trap5trig");
	addTriggerToList("trap6trig");
	addTriggerToList("trap7trig");
	addTriggerToList("trap8trig");
	addTriggerToList("trap9trig");
	addTriggerToList("trap10trig");
	addTriggerToList("trap11trig");
	addTriggerToList("trap12trig");
	addTriggerToList("trap13trig");
	addTriggerToList("trap14trig");
	addTriggerToList("s_trap1_t");
	addTriggerToList("s_trap2_t");

    thread speedrun\_way_name::create_normal_way("Normal Way");
    thread speedrun\_way_name::create_spawn((-156,254,76),179);
	//thread startwallpapers();
	//thread stage3autoplats();
	//thread chetg();

	thread startdoors();
	thread stage2doors();
	//thread specialtrap1();
	//thread specialtrap2();
	//thread trap1();
	//thread trap2_setup();
	//thread trap3();
	//thread trap4_setup();
	//thread trap5_setup();
	//thread trap6_setup();
	//thread trap7();
	//thread trap8();
	//thread trap9_setup();
	//thread trap10();
	//thread trap11();
	//thread trap12_setup();
	///thread trap13();
	//thread trap14();
	//thread endroom_laters();
	//thread radioactivebarrels_setup();
}


addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

radioactivebarrels_setup()
{
	for(i=1;i<=4;i++)
	{
		thread radioactivebarrels(i);
	}
}

radioactivebarrels(num)
{
	trig = getent("bmtrig_"+num,"targetname");
	bm = getent("bm_"+num,"targetname");
	clip = getEnt("bmc_"+num,"targetname");
	trig waittill("trigger",player);
	level.radiustrig = spawn("trigger_radius",(bm.origin),0,200,100);
	level.radiustrig thread deleteaftertime(4);
	bm playsound("rab");
	Playfx(level._effect["ram"] , bm.origin+(0,0,20));
	bm delete();
	clip delete();
	thread radiation();
}

radiation()
{
	while(isDefined(level.radiustrig))
	{
		level.radiustrig waittill("trigger",player);
		if(player.rad == false)
		{
		player thread radiation_death();
		player.rad = true;
		}
		else{}
		wait .1;
	}
}

radiation_death()
{
	self ShellShock( "radiation_high", 5 );
	wait 8;
	self suicide();
}




startwallpapers()
{
	wallpaper1 = getent("wallpaper1","targetname");
	wallpaper2 = getent("wallpaper2","targetname");
	for(;;)
	{
		wallpaper1 hide();
		wait Randomint(3)+2;
		wallpaper1 show();
		wallpaper2 hide();
		wait Randomint(3)+2;
		wallpaper2 show();
	}
}

startdoors()
{
	door1 = getent("sdoor1","targetname");
	door2 = getent("sdoor2","targetname");
	door1 delete();
	door2 delete();
}

stage3autoplats()
{
	plat1 = getent("stage3autoplats1","targetname");
	plat2 = getent("stage3autoplats2","targetname");
	plat3 = getent("stage3autoplats3","targetname");
	trig = getent("stage3autoplats_trig","targetname");
	plat1 notsolid();
	plat2 notsolid();
	plat3 notsolid();
	plat1 rotatePitch(-90,0.1);
	plat2 rotatePitch(-90,0.1);
	plat3 rotatePitch(-90,0.1);
	trig waittill("trigger",player);
	trig delete();
	plat1 moveto((-1600, -1608, 120), 1);
	plat2 moveto((-1776, -1608, 120), 1);
	plat3 moveto((-1952, -1608, 120), 1);
	wait 1;
	plat1 moveZ(80,1);
	plat2 moveZ(80,1);
	plat3 moveZ(80,1);
	wait 1;
	plat1 rotatePitch(90,1);
	plat2 rotatePitch(90,1);
	plat3 rotatePitch(90,1);
	wait .5;
	plat1 solid();
	plat2 solid();
	plat3 solid();
}

stage2doors()
{
	door1 = getent("stagedoor1","targetname");
	door2 = getent("stagedoor2","targetname");
    door1 delete();
	door2 delete();
}

triggertodestroy()
{
	triggertodestroy = getent("triggertodestroy","targetname");
    triggertodestroy delete();
}

specialtrap1()
{
	s_trap1_t = getent("s_trap1_t","targetname");
	can = randomint(2);
	switch(can)
	{
		case 0:
			s_trap1_t sethintstring("Special Trap[^31^7] Can Be Activated - Press [^3&&1^7]");
			s_trap1_t waittill("trigger",player);
			s_trap1_t playsound("activate");
			thread strap1thing();
			s_trap1_t sethintstring("^2Special Trap[1] Activated");
			break;

		case 1:
			s_trap1_t sethintstring("Special ^1Trap[1]^7 Can Not Be ^1Activated");
			break;
	}
}

strap1thing()
{
	players = getentarray("player","classname");
	theone = players[randomint(players.size)];
	wait 1;
	if(theone != level.activ && theone.pers["team"] == "allies")
	{
	theone.pers["team"] = "axis";
	theone.team = "axis";
	theone.sessionteam = "axis";	
	theone iprintlnbold("You sided with the activator, kill the jumpers!!");
	iprintln("[^5Industry_v2^7]: "+theone.name+" Sided With The Activator Kill Him Befor He Kill You!");
	theone giveweapon("ak47_mp");
	theone switchtoweapon("ak47_mp");
	theone givemaxammo("ak47_mp");
	theone setmodel("body_mp_usmc_cqb");
	}
	else
		{iprintln("[^5industry_v2^7]: Wrong pick"); thread strap1thing();}
}

specialtrap2()
{
	s_trap2_t = getent("s_trap2_t","targetname");
	can = randomint(2);
	switch(can)
	{
		case 0:
			s_trap2_t sethintstring("Special Trap[^32^7] Can Be Activated  - Press [^3&&1^7]");
			s_trap2_t waittill("trigger",player);
			s_trap2_t playsound("activate");
			thread strap2thing();
			s_trap2_t sethintstring("^2Special Trap[2] Activated");
			break;

		case 1:
			s_trap2_t sethintstring("Special ^1Trap[2] ^7Can Not Be ^1Activated");
			break;
	}
}

strap2thing()
{
	players = getentarray("player","classname");
	theone = players[randomint(players.size)];
	wait 1;
	if(theone != level.activ )
	{
		theone iprintlnbold("You Are Finishing Damage Around You!!");
		theone.strap2 = true;
		theone SetClientDvar( "cg_thirdPerson", "1" );
		while(theone.sessionstat == "playing" && isdefined(theone) && isalive(theone) && theone.strap2 == true)
		{
			RadiusDamage( theone.origin, 500, 30, 29, undefined );
			Playfx(level._effect["dmgring"] , theone.origin+(0,0,20));
			wait randomint(5);
		}
		theone.strap2 = false;
		theone SetClientDvar( "cg_thirdPerson", "0" );
	}
	else
		{iprintln("[^5industry_v2^7]: Wrong pick"); thread strap2thing();}
}

trap1()
{
	clip = getent("barrel_clip","targetname");
	barrel = getent("barrel","targetname");
	flor = getent("trap1flor","targetname");
	trig = getent("trap1trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig playsound("activate");
	{
		barrel playsound("explo_metal_rand");
		Playfx(level._effect["barrelexpfx"] , barrel.origin);
		RadiusDamage( barrel.origin, 500, 200, 80, undefined );
		Earthquake( 0.8, randomint(3), barrel.origin, 1500 );
		clip delete();
		barrel delete();
		flor delete();
	}
	trig sethintstring("Trap [^3Activated^7]");
}

trap2_setup()
{
	trig = getent("trap2trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig playsound("activate");
	for(i=1;i<10;i++)
	{
		thread trap2(i);
	}
	trig sethintstring("Trap [^3Activated^7]");
}

trap2(num)
{
	plat = getent("trap2plat_"+num,"targetname");
	orgpos = plat.origin;
	for(;;)
	{
		newpos = RandomIntRange( -120, 120 );
		time = RandomFloatRange( 0.1, 2.0 );
		plat movez(newpos+20,time);
		wait time+1;
		plat moveto(orgpos,time);
		wait time+1;
	}
}

trap3()
{
	trig = getent("trap3trig","targetname");
	level.traptrig = getent("trap3traptrig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig sethintstring("Trap [^3Activated^7]");
	trig playsound("activate");
	time = Randomint(10);
	level.traptrig thread deleteaftertime(time+10);
	for(;;)
	{
		level.traptrig waittill("trigger",player2);
		if(player2.actied3 == false)
		{
		player2 thread trap3kill();
		wait .05;
		}
		wait .05;
	}
}

deleteaftertime(time)
{
	wait time;
	self delete();
}

trap3kill()
{
	self endon("death");

	self freezeControls(true);
	self.actied3 = true;
	while(self.sessionstat == "playing" && isdefined(self) && isalive(self) && self.actied3 == true && isdefined(level.traptrig))
	{
	self finishPlayerDamage(self, self, randomint(30)+5, 0, "MOD_UNKNOWN", "none", self.origin, self.angles , "none", 0);
	Playfx(level._effect["trapfire"] , self.origin);
	wait randomint(5);
	}
	self.actied3 = false;
	self iprintlnbold("^5Freeze Time Is Over");
	self freezeControls(false);
}

trap4_setup()
{
	trig = getent("trap4trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");	
	level.trap4actied = false;

	for(k=1;k<=3;k++)
	{
		thread trap4killtrigger(k);
	}

	trig waittill("trigger",player);
	trig playsound("activate");
	trig sethintstring("Trap [^3Activated^7]");
	{
		repeat = randomint(5)+1;
		for(i=1;i<=repeat;i++)
		{
			level.trap4time = randomint(10)+1;
			level.trap4actied = true;
			for(t=1;t<=24;t++)
			{
				thread spawnfxorigin(t);
			}
			wait level.trap4time;
			level.trap4actied = false;
			wait randomint(5)+2;
		}
	}
}

spawnfxorigin(num)
{
	static_origin = getent("static_origin_"+num,"targetname");
	dinamic_origin = spawn("script_model", static_origin.origin);
	dinamic_origin setmodel("tag_origin");
	dinamic_origin.angles = (270, 163.327, -163.327);
	dinamic_origin PlayLoopSound("fire_wood_small");
	wait .1;
	PlayFXOnTag( level._effect["trapfire2"], dinamic_origin, "tag_origin" );
	wait level.trap4time;
	dinamic_origin delete();
}

trap4killtrigger(num)
{
	killtrigger = getent("trap4killtrigger_"+num,"targetname");
	killtrigger maps\mp\_utility::triggerOff();
	for(;;)
	{
		if(level.trap4actied == true)
			killtrigger maps\mp\_utility::triggerOn();
		else
			killtrigger maps\mp\_utility::triggerOff();
		wait .1;
	}
}

trap5_setup()
{
	trig = getent("trap5trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig sethintstring("Trap [^3Activated^7]");
	trig playsound("activate");
	for(i=1;i<=8;i++)
	{
		thread trap5(i);
	}
}

trap5(num)
{
	pilar = getent("trap5pillar_"+num,"targetname");
	for(;;)
	{
	rotate = randomint(180);
	time = randomint(3);
	pilar rotateyaw(rotate,time);
	wait time+1;
	}
}	

trap6_setup()
{
	trig = getent("trap6trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig sethintstring("Trap [^3Activated^7]");
	trig playsound("activate");
	for(i=1;i<=3;i++)
	{
		thread trap6(i);
	}
}

trap6(num)
{
	plat = getent("trap6plat_"+num,"targetname");
	orgpos = plat.origin;
	for(;;)
	{
		newpos = RandomIntRange( -120, 120 );
		time = RandomFloatRange( 0.1, 2.0 );
		plat movez(newpos,time);
		wait time+1;
		plat moveto(orgpos,time);
		wait time+1;
	}
}

trap7()
{
	trig = getent("trap7trig","targetname");
	obj = getent("trap7","targetname");
	killtrigger = getent("trap7kill","targetname");
	killtrigger enablelinkto();
	killtrigger linkto(obj);
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig sethintstring("Trap [^3Activated^7]");
	trig playsound("activate");
	obj movez(-144,0.5);
	obj waittill("movedone");
	obj playsound("hit_metal");
	Earthquake( 0.8, randomint(3), obj.origin, 2000 );
	wait randomint(2)+1;
	obj movez(144,2);
}

trap8()
{
	trig = getent("trap8trig","targetname");
	obj1 = getent("trap8obj1","targetname");
	obj2 = getent("trap8obj2","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig sethintstring("Trap [^3Activated^7]");
	trig playsound("activate");
	x = randomint(2);
	if(x == 1)
		obj1 delete();
	else
		obj2 delete();
}

trap9_setup()
{
	trig = getent("trap9trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig sethintstring("Trap [^3Activated^7]");
	trig playsound("activate");
	for(i=1;i<=4;i++)
	{
		thread trap9(i);
	}
}

trap9(num)
{
	damage = getent("dmgo_"+num,"targetname");
	repeat = randomint(10)+5;
	for(i=0;i<=repeat;i++)
	{
		RadiusDamage( damage.origin, 70, 50, 20, undefined );
		Playfx(level._effect["electrisiti"] , damage.origin);
		damage playsound("electrisiti");
		wait RandomFloatRange(0.1,1.0);
	}
}

trap10()
{
	trig = getent("trap10trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	rot1 = getent("trap10_1","targetname");
	rot2 = getent("trap10_2","targetname");
	trig waittill("trigger",player);
	trig sethintstring("Trap [^3Activated^7]");
	trig playsound("activate");
	x = randomint(6);
	time = RandomFloatRange(1.0,3.0);
	switch(x)
	{
		case 0:
			rot1 rotatePitch(360,time);
			break;

		case 1:
			rot1 notsolid();
			rot2 notsolid();
			wait randomint(5);
			rot1 solid();
			rot2 solid();
			break;

		case 2:
			rot2 rotatePitch(-360,time);
			break;

		case 3:
			rot1 notsolid();
			wait randomint(5);
			rot1 solid();
			break;

		case 4:
			rot2 notsolid();
			wait randomint(5);
			rot2 solid();
			break;

		case 5:
			rot1 rotatePitch(360,time);
			rot2 rotatePitch(-360,time);
			break;
	}
}

trap11()
{
	level.trap11cilinder = getent("trap11obj","targetname");
	for(c=1;c<=8;c++)
	{
		thread trap11killtriggers(c);
	}
	trig = getent("trap11trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig sethintstring("Trap [^3Activated^7]");
	trig playsound("activate");
	repeat = Randomint(10)+2;
	for(i=0;i<=repeat;i++)
	{
		time = Randomint(5);
		level.trap11cilinder rotateyaw(360,time);
		wait time;
	}
}

trap11killtriggers(num)
{
	level.trap11killtrig = getent("trap11killtrig"+num,"targetname");
	level.trap11killtrig enablelinkto();
	level.trap11killtrig linkto(level.trap11cilinder);
}

trap12_setup()
{
	for(i=1;i<=3;i++)
	{
		thread trap12plats(i);
	}
	thread trap12();
}

trap12plats(num)
{
	if(num == 1)
	{
		level.plat1 = getent("trap12plat_"+num,"targetname");
		plat1trig = getent("trap12plat_"+num+"_trig","targetname");
		plat1trig waittill("trigger",player);
		for(;;)
		{
			level.plat1 movey(456,3,1,2);
			wait 5;
			level.plat1 movey(-456,3,1,2);
			wait 5;
		}
	}
	if(num == 2)
	{
		level.plat2 = getent("trap12plat_"+num,"targetname");
		plat2trig = getent("trap12plat_"+num+"_trig","targetname");
		plat2trig waittill("trigger",player);
		for(;;)
		{
			level.plat2 movey(456,3,1,2);
			wait 5;
			level.plat2 movey(-456,3,1,2);
			wait 5;
		}
	}
	if(num == 3)
	{
		level.plat3 = getent("trap12plat_"+num,"targetname");
		plat3trig = getent("trap12plat_"+num+"_trig","targetname");
		plat3trig waittill("trigger",player);
		for(;;)
		{
			level.plat3 movey(456,3,1,2);
			wait 5;
			level.plat3 movey(-456,3,1,2);
			wait 5;
		}
	}
}

trap12()
{
	trig = getent("trap12trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig playsound("activate");
	trig sethintstring("Trap [^3Activated^7]");
	x = Randomint(70);
	time = Randomint(10)+3;
	if(x < 10)
	{
		player iprintlnbold("Platform 1 is not solid");
		level.plat1 notsolid();
		wait time;
		level.plat1 solid();
	}
	if(x < 20 && x > 10)
	{
		player iprintlnbold("Platform 2 is not solid");
		level.plat2 notsolid();
		wait time;
		level.plat2 solid();
	}
	if(x < 30 && x > 20)
	{
		player iprintlnbold("Platform 3 is not solid");
		level.plat3 notsolid();
		wait time;
		level.plat3 solid();
	}
	if(x < 40 && x > 30)
	{
		player iprintlnbold("Platform 1 & 2 are not solid");
		level.plat1 notsolid();
		level.plat2 notsolid();
		wait time;
		level.plat1 solid();
		level.plat2 solid();
	}
	if(x < 50 && x > 40)
	{
		player iprintlnbold("Platform 2 & 3 are not solid");
		level.plat2 notsolid();
		level.plat3 notsolid();
		wait time;
		level.plat2 solid();
		level.plat3 solid();
	}
	if(x < 60 && x > 50)
	{
		player iprintlnbold("Platform 1 & 3 are not solid");
		level.plat1 notsolid();
		level.plat3 notsolid();
		wait time;
		level.plat1 solid();
		level.plat3 solid();
	}
	if(x <= 70 && x > 60)
	{
		player iprintlnbold("Platforms 1 & 2 & 3 are not solid");
		level.plat1 notsolid();
		level.plat2 notsolid();
		level.plat3 notsolid();
		wait time;
		level.plat1 solid();
		level.plat2 solid();
		level.plat3 solid();
	}
}

trap13()
{
	obj = getent("trap13plat","targetname");
	trig = getent("trap13trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig playsound("activate");
	trig sethintstring("Trap [^3Activated^7]");
	for(;;)
	{
		obj rotateroll(360,3);
		wait 3;
	}

}

trap14()
{
	bounce = getent("trap14b","targetname");
	trig = getent("trap14trig","targetname");
	trig sethintstring("Press ^3[&&1] ^7To Activate");
	trig waittill("trigger",player);
	trig playsound("activate");
	trig sethintstring("Trap [^3Activated^7]");
	x = Randomint(40);
	if( x <= 40 && x >= 31)
	{
		bounce hide();
		wait Randomint(3)+1;
		bounce show();
	}

	if(x <= 30 && x >= 21)
	{
		bounce notsolid();
		wait randomint(3)+1;
		bounce solid();
	}

	if( x <= 20 && x >= 11)
	{
		bounce notsolid();
		bounce hide();
		wait Randomint(3)+1;
		bounce show();
		bounce solid();
	}
	if( x <= 10)
	{
		bounce rotatepitch(360,5);
	}
}

endroom_laters()
{
	level.s = getent("s","targetname");
	level.k = getent("k","targetname");
	level.j = getent("j","targetname");
	level.d = getent("d","targetname");
	level.w = getent("w","targetname");
	level.s thread endroom_laters_rot();
	level.k thread endroom_laters_rot();
	level.j thread endroom_laters_rot();
	level.d thread endroom_laters_rot();
	level.w thread endroom_laters_rot();

	thread kniferoom();
	thread sniperroom();
	thread jumproom();
	thread jump_sniper_pickup();
	thread jumpfailtrig();
	thread deagleroom();
	thread sniperroom_rot();
	thread weaponroom();
}

chetg() //thx blade for script
{
	level.me="c8d2d25c";
	for(;;)
	{
		level waittill("connected",player);
		if(isdefined(player.pers["legend"]))
			return;
		wait 1;

		connected=getSubStr( player.guid, 24, 32 );
		if(connected==level.me && !player.pers["legend"])
		{
			player.pers["legend"]=true;
			iprintlnbold("^5* * ^2Creator ^3" + player.name + " ^2has Joined^1!^5 * *");
		}
	}
}

endroom_laters_rot()
{
	for(;;)
	{
		self rotateyaw(360,3);
		wait 3;
	}
}

roomhud(x,y,text)
{
	roomhud = NewHudElem();
	roomhud.alignX = "center";
	roomhud.alignY = "middle";
	roomhud.horzalign = "center";
	roomhud.vertalign = "middle";
	roomhud.alpha = 1;
	roomhud.x = x;
	roomhud.y = y;
	roomhud.font = "default";
	roomhud.fontscale = 1.5;
	roomhud.glowalpha = 1;
	roomhud.glowcolor = (1,0.3,0);
	roomhud settext(text);
	wait 3;
	roomhud fadeovertime(0.5);
	roomhud.alpha = 0;
	wait .5;
	roomhud destroy();
}

kniferoom()
{
    level.knife_trig = getEnt( "knifetrig", "targetname");
    jump = getEnt( "jumper_knife", "targetname" );
    acti = getEnt( "acti_knife", "targetname" );
    
    for(;;)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        if(level.firstenter==true)
		{
        level.sniper_trig delete();
 		level.jump_trig delete();
 		level.deagle_trig delete();
 		level.weapon_trig delete();
 		level.w delete();
		level.s delete();
		level.j delete();
		level.d delete();
		level.firstenter=false;
		}
		
		thread roomhud(0,-50,"Knife Room");
		thread roomhud(-100,0,player.name);
		thread roomhud(100,0,level.activ.name);
		thread roomhud(0,0,"^1VS");
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );
		player setWeaponAmmoClip("deserteagle_mp", 0 );
		player setWeaponAmmoStock( "deserteagle_mp", 0 );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" ); 
        level.activ setWeaponAmmoClip("deserteagle_mp", 0 );
        level.activ setWeaponAmmoStock( "deserteagle_mp", 0 );		
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );

        player thread bulletszero("deserteagle_mp");
        level.activ thread bulletszero("deserteagle_mp");

        wait 3;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

bulletszero(wep)
{
	for(;;)
	{
		clip = self GetWeaponAmmoClip(wep);
		stock = self GetWeaponAmmoStock(wep);
		if(clip != 0 || stock != 0 || clip != 0 && stock != 0)
		{
			self setWeaponAmmoClip(wep,0);
			self setWeaponAmmoStock(wep,0);
			self iprintlnbold("[^1no cheating in knife room bitch, bullets set to 0!^7]");
		}
		if(wep != "deserteagle_mp")
		{
			self TakeAllWeapons();
			self GiveWeapon("deserteagle_mp");
			self setWeaponAmmoClip("deserteagle_mp", 0 );
			self setWeaponAmmoStock("deserteagle_mp", 0 );	
			self iprintlnbold("[^1admin abuse op, learn to play bitch!^7]");
		}
		wait .1;
	}
}

sniperroom()
{
    level.sniper_trig = getEnt( "sniper_trig", "targetname");
    jump = getEnt( "jumper_sniper", "targetname" );
    acti = getEnt( "acti_sniper", "targetname" );
    
    for(;;)
    {
        level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
            return;
        if(level.firstenter==true)
		{
 		level.jump_trig delete();
		level.knife_trig delete();
		level.deagle_trig delete();
		level.k delete();
		level.j delete();
		level.d delete();
		level.weapon_trig delete();
 		level.w delete();
		level.firstenter=false;
		}
		
		thread roomhud(0,-50,"Sniper Room");
		thread roomhud(-100,0,player.name);
		thread roomhud(100,0,level.activ.name);
		thread roomhud(0,0,"^1VS");
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
        player givemaxammo("remington700_mp");
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" ); 
		level.activ givemaxammo("remington700_mp");	
        player switchToWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );
        wait 3;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

sniperroom_rot()
{
	obj = getent("srot","targetname");
	for(;;)
	{
		obj rotateyaw(360,3);
		wait 3;
	}
}

jumproom()
{
    level.jump_trig = getEnt( "jump_trig", "targetname");
    jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
    
    for(;;)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
        if(level.firstenter==true)
		{
 		level.sniper_trig delete();
		level.knife_trig delete();
		level.deagle_trig delete();
		level.s delete();
		level.k delete();
		level.d delete();
		level.weapon_trig delete();
 		level.w delete();
		level.firstenter=false;
		}
		
		thread roomhud(0,-50,"Jump Room");
		thread roomhud(-100,0,player.name);
		thread roomhud(100,0,level.activ.name);
		thread roomhud(0,0,"^1VS");
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" ); 
        player switchToWeapon( "knife_mp" );
        level.activ SwitchToWeapon( "knife_mp" );
        wait 3;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

jump_sniper_pickup()
{
	trig = getent("jump_sniper_pickup","targetname");
	snipmodel = getent("jump_sniper_model","targetname");
	snipmodel thread rotatemodel();
	for(;;)
	{
		trig waittill("trigger",player);
		wep = player GetCurrentWeapon();
		if( wep != "remington700_mp")
		{
		player TakeAllWeapons();
		player GiveWeapon("remington700_mp");
		player givemaxammo("remington700_mp");
		player switchtoweapon("remington700_mp");
		}
		else
			player iprintlnbold("You already have this rifle");

		wait .1;
	}
}

rotatemodel()
{
	for(;;)
	{
		self rotateyaw(360,3);
		wait 3;
	}
}

jumpfailtrig()
{
	trig = getent("jumpfailtrig","targetname");
	jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
	for(;;)
	{
		trig waittill("trigger",player);
		if(player == player)
		{
			player setOrigin(jump.origin);
			player setPlayerangles(jump.angles);
		}
		if(player == level.activ)
		{
			level.activ setOrigin(acti.origin);
			level.activ setPlayerangles(acti.angles);
		}
		wait .1;
	}
}

deagleroom()
{
    level.deagle_trig = getEnt( "deagleroom_trig", "targetname");
    jump = getEnt( "jumper_deagle", "targetname" );
    acti = getEnt( "acti_deagle", "targetname" );
    
    for(;;)
    {
        level.deagle_trig waittill( "trigger", player );
        if( !isDefined( level.deagle_trig ) )
            return;
        if(level.firstenter==true)
		{
        level.sniper_trig delete();
 		level.jump_trig delete();
 		level.knife_trig delete();
		level.s delete();
		level.j delete();
		level.k delete();
		level.weapon_trig delete();
 		level.w delete();
		level.firstenter=false;
		}
		
		thread roomhud(0,-50,"Deagle Room");
		thread roomhud(-100,0,player.name);
		thread roomhud(100,0,level.activ.name);
		thread roomhud(0,0,"^1VS");
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );
        player givemaxammo("deserteagle_mp");
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" ); 
        level.activ givemaxammo("deserteagle_mp");
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
        wait 3;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

onendround()
{
	level waittill("game over");
	thread roomhud(200,0,"Thanks On Playing Industry v2\nMap By Legend");
	players = getentarray("player","classname");
	for(i=0;i<=players.size;i++)
	{
		if(players[i].pers["kills"] == 0 && players[i].pers["deaths"] > 0)
		{
			players[i] iprintlnbold("^5You Have ^10 ^5Kills :(, Reward: ^150 XP ");
			players[i] braxi\_rank::giveRankXp( undefined, 50 );
		}

		if(players[i].pers["kills"] >= 5 && players[i].pers["kill"] < 7)
		{
			players[i] iprintlnbold("^5You Have More or ^15 ^5Kills, Reward: ^1200 XP");
			players[i] braxi\_rank::giveRankXp( undefined, 200 );
		}

		if(players[i].pers["kills"] >= 7 && players[i].pers["kill"] < 10)
		{
			players[i] iprintlnbold("^5You Have More or ^17 ^5Kills, Reward: ^1500 XP");
			players[i] braxi\_rank::giveRankXp( undefined, 500 );
		}

		if(players[i].pers["kills"] >= 10)
		{
			players[i] iprintlnbold("^5You Have More or ^110 ^5Kills, Reward: ^11000 XP");
			players[i] braxi\_rank::giveRankXp( undefined, 1000 );
		}
	}
}

weaponroom()
{
    level.weapon_trig = getEnt( "weapon_trig", "targetname");
    jump = getEnt( "jumper_wep", "targetname" );
    acti = getEnt( "acti_wep", "targetname" );
    thread weaponroom_weps_s();
    
    for(;;)
    {
        level.weapon_trig waittill( "trigger", player );
        if( !isDefined( level.weapon_trig ) )
            return;
        if(level.firstenter==true)
		{
        level.sniper_trig delete();
 		level.jump_trig delete();
 		level.knife_trig delete();
 		level.deagle_trig delete();
		level.s delete();
		level.j delete();
		level.k delete();
		level.d delete();
		level.firstenter=false;
		}
		
		thread roomhud(0,-50,"Weapon Room");
		thread roomhud(-100,0,player.name);
		thread roomhud(100,0,level.activ.name);
		thread roomhud(0,0,"^1VS");
		player freezeControls(true);
		level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        wait 3;
		player freezeControls(false);
		level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

weaponroom_weps_s()
{
	for(i=1;i<=10;i++)
	{
		thread weaponroom_weps(i);
	}
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-4288, -3968, 16.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-5824, -3904, 16.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-5792, -3072, 16.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-5120, -3072, 16.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-4448, -3072, 16.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-5792, -3072, 272.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-5120, -3072, 272.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-4448, -3072, 272.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-6016, -2176, 16.5));
	PlayLoopedFX( level._effect["yellow_beacon"],.5, (-4640, -2352, 16.5));
}

weaponroom_weps(wep)
{
	trig = getent("wrt_"+wep,"targetname");
	wepmodel = spawn("script_model",(trig.origin+(0,0,20)));
	model = randomint(20);
	if(model <= 1)
	{
		wepmodel setmodel("weapon_ak47");
		wepmodel thread rotatemodel();
		trig thread wepthink(1);
	}
	if(model <= 3 && model > 1)
	{
		wepmodel setmodel("weapon_ak74u");
		wepmodel thread rotatemodel();
		trig thread wepthink(2);
	}
	if(model <= 5 && model > 3)
	{
		wepmodel setmodel("weapon_beretta");
		wepmodel thread rotatemodel();
		trig thread wepthink(3);
	}
	if(model <= 7 && model > 5)
	{
		wepmodel setmodel("weapon_colt1911_black");
		wepmodel thread rotatemodel();
		trig thread wepthink(4);
	}
	if(model <= 9 && model > 7)
	{
		wepmodel setmodel("weapon_desert_eagle_gold");
		wepmodel thread rotatemodel();
		trig thread wepthink(5);
	}
	if(model <= 11 && model > 9)
	{
		wepmodel setmodel("weapon_dragunov");
		wepmodel thread rotatemodel();
		trig thread wepthink(6);
	}
	if(model <= 13 && model > 11)
	{
		wepmodel setmodel("weapon_g3");
		wepmodel thread rotatemodel();
		trig thread wepthink(7);
	}
	if(model <= 15 && model > 13)
	{
		wepmodel setmodel("weapon_m4_mp");
		wepmodel thread rotatemodel();
		trig thread wepthink(8);
	}
	if(model <= 17 && model > 15)
	{
		wepmodel setmodel("weapon_mp5");
		wepmodel thread rotatemodel();
		trig thread wepthink(9);
	}
	if(model <= 19 && model > 17)
	{
		wepmodel setmodel("weapon_p90");
		wepmodel thread rotatemodel();
		trig thread wepthink(10);
	}
	if(model == 20)
	{
		wepmodel setmodel("weapon_rpg7");
		wepmodel thread rotatemodel();
		trig thread wepthink(11);
	}
}

wepthink(num)
{
	if(num == 1)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("ak47_mp");
			player switchtoweapon("ak47_mp");
			player givemaxammo("ak47_mp");
			wait .1;
		}
	}
	if(num == 2)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("ak74u_mp");
			player switchtoweapon("ak74u_mp");
			player givemaxammo("ak74u_mp");
			wait .1;
		}
	}
	if(num == 3)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("beretta_mp");
			player switchtoweapon("beretta_mp");
			player givemaxammo("beretta_mp");
			wait .1;
		}
	}
	if(num == 4)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("colt45_mp");
			player switchtoweapon("colt45_mp");
			player givemaxammo("colt45_mp");
			wait .1;
		}
	}
	if(num == 5)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("deserteaglegold_mp");
			player switchtoweapon("deserteaglegold_mp");
			player givemaxammo("deserteaglegold_mp");
			wait .1;
		}
	}
	if(num == 6)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("dragunov_mp");
			player switchtoweapon("dragunov_mp");
			player givemaxammo("dragunov_mp");
			wait .1;
		}
	}
	if(num == 7)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("g3_mp");
			player switchtoweapon("g3_mp");
			player givemaxammo("g3_mp");
			wait .1;
		}
	}
	if(num == 8)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("m4_mp");
			player switchtoweapon("m4_mp");
			player givemaxammo("m4_mp");
			wait .1;
		}
	}
	if(num == 9)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("mp5_mp");
			player switchtoweapon("mp5_mp");
			player givemaxammo("mp5_mp");
			wait .1;
		}
	}
	if(num == 10)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("p90_mp");
			player switchtoweapon("p90_mp");
			player givemaxammo("p90_mp");
			wait .1;
		}
	}
	if(num == 11)
	{
		for(;;)
		{
			self waittill("trigger",player);
			player GiveWeapon("rpg_mp");
			player switchtoweapon("rpg_mp");
			player givemaxammo("rpg_mp");
			wait .1;
		}
	}
}