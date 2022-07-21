main()
{
thread sr\api\_map::createSpawnOrigin((-128.942, 140.800, 16.125), 180);
trigger = spawn( "trigger_radius", (6899.93, -2205.18, -223.875), 0, 120, 185 );
trigger.targetname = "endmap_trig";
trigger.radius = 120;

level.fire2 = loadFX("deathrun/fire2");
maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
    setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 15000 );

thread way_connect();

	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i]

//essentials
thread transporter();
// thread games();
// thread credits();
thread secret11();
thread lift();

//traps
// thread rotate();
// thread trap011();
// thread trap02();
// thread trap03();
// thread trap031();
thread open();
// thread trap041();
// thread trap05();
// thread trap06();
// thread trap07();
// thread trap071();
// thread trap081();
// thread trap082();
// thread trap083();
// thread trap084();
// thread trap09();
// thread trap10();
// thread trap11();
// thread trap11a();
// thread trap11b();
// thread trap11c();
// thread trap12b();
// thread trap12c();
// thread trap131();
// thread trap132();
// thread trap133();
// thread trap14();
// thread trap14a();
// thread trap15();
// thread trap15a();
// thread trap15b();
// thread trap16();
// thread trap16a();

//rooms
// thread knife();
// thread deagle();
// thread snip();
// thread bounce();
// thread jump();

//extras
thread fire2();
// thread music();
thread fire3();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;

    sr\api\_speedrun::createNormalWays("Normal Way;");

    thread tp_1();

    for(;;)
    {
        level waittill( "connected", player );

    }
}

tp_1()
{
	trig = spawn("trigger_radius",(1010,-3203,44),0,100,250);
	ori = spawn("script_origin",(1905,-3380,44));
	ori.angles = (0,0,0);

	wait 1;
	trig.radius = 100;
	thread sr\api\_map::createTriggerFx(trig, "endtrig");

	for(;;)
	{
		trig waittill("trigger",player);
		player setOrigin(ori.origin);
		player setPlayerangles(ori.angles);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}

games()
{
level.games_trig = getEnt( "minigames", "targetname");
games = getEnt( "minigames_ori", "targetname" );

while(1)
{
level.games_trig waittill( "trigger", player );
if( !isDefined( level.games_trig ) )
return;

level.old_trig delete();

player SetPlayerAngles( games.angles );
player setOrigin( games.origin );
iPrintlnBold( " ^5" + player.name + " ^7 has ^5entered the ^7games section^5!" );
player TakeAllWeapons();
player died();


while( isAlive( player ) && isDefined( player ) )
if( isDefined( level.activ ) && isAlive( level.activ ) )
wait 1;
}
}
died()
{
self endon("disconnect");

self waittill("death");
iPrintlnBold("^5"+self.name+" ^7has ^5died^7!");
iPrintlnBold("^5T^7he ^5M^7inigames ^5S^7ection ^5i^7s ^5n^7ow ^5O^7PEN^5.");
}

rotate()
{
trig = getEnt("trigger_rotate","targetname");
brush = getEnt("rotate","targetname");

trig waittill("trigger", player);
trig delete();

while(1)
{
brush rotatePitch (-360,2);
wait 3;
}
}

credits()
{
trigger = getent("credits","targetname");

trigger waittill("trigger", user);
trigger delete();

iPrintlnBold( "^5MAP LITHIUM" );
wait 1;
iPrintlnBold( "^5Made By Atally from vTx Server" );
wait 1;
iPrintlnBold( "^5Thanks to Vc'Blade,Fakiz,Jynx for script help" );
wait 1;
iPrintlnBold( "^5enjoy" );
}

secret11()
{
secret11 = getent("secret11","targetname");
trigger = getent("trigger_secret11","targetname");

secret11 moveY(-150,0.05);
}

lift()
{
lift = getEnt("lift","targetname");


}

trap011()
{
trap011 = getent("trap011","targetname");
trigger = getent("trigger_trap011","targetname");


}


trap02()
{
hurt = getent("hurt_1a","targetname");
trap02 = getent("trap02","targetname");
trigger = getent("trigger_trap02","targetname");


}


trap03()
{
trap03 = getent("trap03","targetname");
trigger = getent("trigger_trap03","targetname");


}

trap031()
{
hurt = getent("hurt_1","targetname");
trap031 = getent("trap031","targetname");
trigger = getent("trigger_trap03","targetname");


}

open()
{
open = getent("open","targetname");
trigger = getent("trigger_open","targetname");


open moveY(-200,0.05);
}

trap041()
{
trap041 = getent("trap041","targetname");
trigger = getent("trigger_trap041","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap041 moveZ(208,1);
wait 4;
trap041 moveZ(-208,1);
wait 4;
}
}

trap05()
{
trap05 = getent("trap05","targetname");
trigger = getent("trigger_trap05","targetname");

trigger waittill("trigger", user);
trigger delete();

trap05 moveY(-350,2);
wait 5;
}

trap06()
{
hurt = getent("hurt_2","targetname");
trig = getEnt("trigger_trap06","targetname");
trap06 = getEnt("trap06","targetname");

trig waittill("trigger", player);
trig delete();

hurt enablelinkto();
hurt linkto(trap06);

while(1)
{
trap06 rotateYaw (-360,2);
trap06 moveX(-154,2);
wait 2;
trap06 moveX(154,2);
wait 2;
}
}

trap07()
{
trap07 = getent("trap07","targetname");
trigger = getent("trigger_trap07","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap07 moveZ(132,1.5);
wait 1.5;
trap07 moveZ(-132,1.5);
wait 1.5;
}
}

trap071()
{
trap071 = getent("trap071","targetname");
trigger = getent("trigger_trap07","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap071 moveZ(-132,1.5);
wait 1.5;
trap071 moveZ(132,1.5);
wait 1.5;
}
}

trap081()
{
hurt = getent("hurt_3","targetname");
trigger = getent("trigger_trap08","targetname");
trap081 = getEnt("trap081","targetname");

trigger waittill("trigger", user);
trigger delete();

hurt enablelinkto();
hurt linkto(trap081);

while(1)
{
trap081 rotateYaw (-360,1.5);
trap081 moveZ(-190,2);
wait 4;
trap081 moveZ(190,1.5);
wait 4;
}
}

trap082()
{
trigger = getent("trigger_trap08","targetname");
trap082 = getEnt("trap082","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap082 rotateYaw (-360,1.5);
trap082 moveZ(-190,2);
wait 4;
trap082 moveZ(190,1.5);
wait 4;
}
}

trap083()
{
trigger = getent("trigger_trap08","targetname");
trap083 = getEnt("trap083","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap083 rotateYaw (-360,1.5);
trap083 moveZ(-190,2);
wait 4;
trap083 moveZ(190,1.5);
wait 4;
}
}

trap084()
{
trigger = getent("trigger_trap08","targetname");
trap084 = getEnt("trap084","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap084 rotateYaw (-360,1.5);
trap084 moveZ(-190,2);
wait 4;
trap084 moveZ(190,1.5);
wait 4;
}
}

trap09()
{
hurt = getent("hurt_41","targetname");
trigger = getent("trigger_trap09","targetname");
trap09 = getEnt("trap09","targetname");

trigger waittill("trigger", user);
trigger delete();

hurt enablelinkto();
hurt linkto(trap09);

while(1)
{
trap09 moveZ(32,2);
wait 5.5;
trap09 moveZ(-32,2);
wait 5.5;
}
}

trap10()
{
trigger = getent("trigger_trap10","targetname");
trap10 = getEnt("trap10","targetname");

trigger waittill("trigger", user);
trigger delete();

trap10 moveY(-224,1.5);
}

trap11()
{
hurt = getent("hurt2c","targetname");
trigger = getent("trigger_trap11","targetname");
trap11 = getEnt("trap11","targetname");

trigger waittill("trigger", user);
trigger delete();

hurt enablelinkto();
hurt linkto(trap11);

while(1)
{
trap11 moveZ(-256,2);
wait 2;
trap11 moveZ(256,2);
wait 2;
}
}

trap11a()
{
hurt = getent("hurt122","targetname");
trigger = getent("trigger_trap11","targetname");
trap11a = getEnt("trap11a","targetname");

trigger waittill("trigger", user);
trigger delete();

hurt enablelinkto();
hurt linkto(trap11a);

while(1)
{
trap11a moveZ(256,2);
wait 2;
trap11a moveZ(-256,2);
wait 2;
}
}

trap11b()
{
hurt = getent("hurt2b","targetname");
trigger = getent("trigger_trap11","targetname");
trap11b = getEnt("trap11b","targetname");

trigger waittill("trigger", user);
trigger delete();

hurt enablelinkto();
hurt linkto(trap11b);

while(1)
{
trap11b moveY(-384,2);
wait 2;
trap11b moveY(384,2);
wait 2;
}
}

trap11c()
{
hurt = getent("hurt2cc","targetname");
trigger = getent("trigger_trap11","targetname");
trap11c = getEnt("trap11c","targetname");

hurt enablelinkto();
hurt linkto(trap11c);

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap11c moveY(384,2);
wait 2;
trap11c moveY(-384,2);
wait 2;
}
}

trap12b()
{
hurt = getent("hurtbb1","targetname");
trigger = getent("trigger_trap12","targetname");
trap12b = getEnt("trap12b","targetname");

trigger waittill("trigger", user);
trigger delete();

hurt enablelinkto();
hurt linkto(trap12b);

while(1)
{
trap12b moveZ(-272,1);
wait 1;
trap12b moveZ(272,1);
wait 1;
}
}

trap12c()
{
hurt = getent("hurtbb2","targetname");
trigger = getent("trigger_trap12","targetname");
trap12c = getEnt("trap12c","targetname");

trigger waittill("trigger", user);
trigger delete();

hurt enablelinkto();
hurt linkto(trap12c);

while(1)
{
trap12c moveZ(272,1);
wait 1;
trap12c moveZ(-272,1);
wait 1;
}
}

trap131()
{
trigger = getent("trigger_trap13","targetname");
trap131 = getEnt("trap131","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
wait 1;
trap131 moveZ(-850,1.5);
wait 5.5;
trap131 moveZ(850,1.5);
wait 5.5;
}
}

trap132()
{
trigger = getent("trigger_trap13","targetname");
trap132 = getEnt("trap132","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
wait 3;
trap132 moveZ(-850,1.5);
wait 5.5;
trap132 moveZ(850,1.5);
wait 5.5;
}
}

trap133()
{
trigger = getent("trigger_trap13","targetname");
trap133 = getEnt("trap133","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
wait 5;
trap133 moveZ(-850,1.5);
wait 5.5;
trap133 moveZ(850,1.5);
wait 5.5;
}
}

trap14()
{
trigger = getent("trigger_trap14","targetname");
trap14 = getEnt("trap14","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap14 moveZ(-65,2);
wait 3.5;
trap14 moveZ(65,2);
wait 3.5;
}
}

trap14a()
{
trigger = getent("trigger_trap14","targetname");
trap14a = getEnt("trap14a","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
wait 1.5;
trap14a moveZ(-65,2);
wait 3.5;
trap14a moveZ(65,2);
wait 3.5;
}
}

trap15()
{
trigger = getent("trigger_trap15","targetname");
trap15 = getEnt("trap15","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap15 moveX(100,2);
wait 2;
trap15 moveX(-100,2);
wait 2;
}
}

trap15a()
{
trigger = getent("trigger_trap15","targetname");
trap15a = getEnt("trap15a","targetname");

trigger waittill("trigger", user);
trigger delete();

while(1)
{
trap15a moveX(-100,2);
wait 2;
trap15a moveX(100,2);
wait 2;
}
}

trap15b()
{
trigger = getent("trigger_trap15","targetname");
trap15b = getEnt("trap15b","targetname");

trigger waittill("trigger", user);
trigger delete();

trap15b moveZ(-900,1.5);
}

trap16()
{
trigger = getent("trigger_trap16","targetname");
trap16 = getEnt("trap16","targetname");

trigger waittill("trigger", user);
trigger delete();

trap16 moveZ(-900,1.5);
}

trap16a()
{
trigger = getent("trigger_trap16","targetname");
trap16a = getEnt("trap16a","targetname");

trigger waittill("trigger", user);
trigger delete();

trap16a moveX(-320,2);
}

knife()
{
     	level.knife_trig = getEnt( "knife", "targetname");
     	jump = getEnt( "knife_jump", "targetname" );
     	acti = getEnt( "knife_acti", "targetname" );

     	while(1)
     	{
         	level.knife_trig waittill( "trigger", player );
         	if( !isDefined( level.knife_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
         	player GiveWeapon( "tomahawk_mp" );
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
         	level.activ GiveWeapon( "tomahawk_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Knife  room^1!" );
         	wait 0.05;
         	player switchToWeapon( "tomahawk_mp" );
         	level.activ SwitchToWeapon( "tomahawk_mp" );
		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false);
		level.activ freezecontrols(false);
     	}
}

deagle()
{
     	level.deagle_trig = getEnt( "deagle", "targetname");
     	jump = getEnt( "deagle_jump", "targetname" );
     	acti = getEnt( "deagle_acti", "targetname" );

     	while(1)
     	{
         	level.deagle_trig waittill( "trigger", player );
         	if( !isDefined( level.deagle_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
		player giveweapon( "usp_mp" );
        player givemaxammo( "usp_mp" );
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
		level.activ giveweapon( "usp_mp" );
        level.activ GiveWeapon( "usp_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the wepon room^1!" );
         	wait 0.05;
		level.activ switchtoweapon( "usp_mp" );
		player switchtoweapon( "usp_mp" );
		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5GET READY^1!" );
		level.activ iPrintlnBold( "^5GET READY^1!" );
		player freezecontrols(false);
		level.activ freezecontrols(false);
     	}
}

snip()
{
     	level.snip_trig = getEnt( "sniper", "targetname");
     	jump = getEnt( "snip_jump", "targetname" );
     	acti = getEnt( "snip_acti", "targetname" );

     	while(1)
     	{
         	level.snip_trig waittill( "trigger", player );
         	if( !isDefined( level.snip_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
         	player GiveWeapon( "mp44_mp" );
	 	player givemaxammo( "mp44_mp" );
         	player GiveWeapon( "remington700_mp" );
	 	player givemaxammo( "remington700_mp" );
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
         	level.activ GiveWeapon( "mp44_mp" );
	 	level.activ givemaxammo( "mp44_mp" );
         	level.activ GiveWeapon( "remington700_mp" );
	 	level.activ givemaxammo( "remington700_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Sniper  room^1!" );
		wait .5;
         	player switchToWeapon( "remington700_mp" );
         	level.activ SwitchToWeapon( "remington700_mp" );
		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Fight^1!" );
		level.activ iPrintlnBold( "^5Fight^1!" );
		player freezecontrols(false);
		level.activ freezecontrols(false);
     	}
}

bounce()
{
     	level.bounce_trig = getEnt( "bounce", "targetname");
     	jump = getEnt( "bounce_jump", "targetname" );
     	acti = getEnt( "bounce_acti", "targetname" );

     	while(1)
     	{
         	level.bounce_trig waittill( "trigger", player );
         	if( !isDefined( level.bounce_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
		player giveweapon( "tomahawk_mp" );
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
		level.activ giveweapon( "tomahawk_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Bounce  room^1!" );
         	wait 0.05;
		level.activ switchtoweapon( "tomahawk_mp" );
		player switchtoweapon( "tomahawk_mp" );
		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5Bounce^1!" );
		level.activ iPrintlnBold( "^5Bounce^1!" );
		player freezecontrols(false);
		level.activ freezecontrols(false);
     	}
}

jump()
{
     	level.bounce_trig = getEnt( "jump", "targetname");
     	jump = getEnt( "jump_jump", "targetname" );
     	acti = getEnt( "jump_acti", "targetname" );

     	while(1)
     	{
         	level.bounce_trig waittill( "trigger", player );
         	if( !isDefined( level.bounce_trig ) )
         	return;

         	player SetPlayerAngles( jump.angles );
         	player setOrigin( jump.origin );
         	player TakeAllWeapons();
		player giveweapon( "tomahawk_mp" );
         	level.activ setPlayerangles( acti.angles );
         	level.activ setOrigin( acti.origin );
         	level.activ TakeAllWeapons();
		level.activ giveweapon( "tomahawk_mp" );
		iPrintlnBold( " ^2" + player.name + " ^5 has entered the Jump room^1!" );
         	wait 0.05;
		level.activ switchtoweapon( "tomahawk_mp" );
		player switchtoweapon( "tomahawk_mp" );
		player freezecontrols(true);
		level.activ freezecontrols(true);
		wait 1;
		player iPrintlnBold( "^53" );
		level.activ iPrintlnBold( "^53" );
		wait 1;
		player iPrintlnBold( "^52" );
		level.activ iPrintlnBold( "^52" );
		wait 1;
		player iPrintlnBold( "^51" );
		level.activ iPrintlnBold( "^51" );
		wait 1;
		player iPrintlnBold( "^5jump^1!" );
		level.activ iPrintlnBold( "^5jump^1!" );
		player freezecontrols(false);
		level.activ freezecontrols(false);
     	}
}

fire2()
{
trigger = getent("fire2","targetname");


playLoopedFX(level.fire2, 0.05, (-96.0,448.0,48.0));
wait 1;
playLoopedFX(level.fire2, 0.05, (-96.0,-144.0,48.0));
}

music()
{
	song = [];
	song[song.size] = "sound1";
	song[song.size] = "sound2";
	song[song.size] = "sound3";
	song[song.size] = "sound4";

	rz = randomint(song.size);
	play = song[rz];

	ambientPlay(play);
}

fire3()
{
trigger = getent("fire3","targetname");


playLoopedFX(level.fire2, 0.05, (6704.0,-2144.0,-208.0));
wait 0.1;
playLoopedFX(level.fire2, 0.05, (7104.0,-2144.0,-208.0));
}