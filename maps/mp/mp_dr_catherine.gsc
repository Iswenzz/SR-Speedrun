/*
______           __  _____  _____
| ___ \         /  ||  _  ||  _  |
| |_/ /_____  __`| || |/' || |_| |
|    // _ \ \/ / | ||  /| |\____ |
| |\ \  __/>  < _| |\ |_/ /.___/ /
\_| \_\___/_/\_\\___/\___/ \____/

Welcome to mp_dr_catherine script. Feel free to take any piece of code, no need to credit me.

*/

main()
{
thread sr\api\_map::createSpawnOrigin((-6, -92, 0), 90);
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	if(!isdefined(level.music))
	level.music=[];
	level.music[0]["song"]    ="^5Catherine OST - Borodin Polovtsian Dances";
	level.music[0]["alias"]    ="radio1";
	level.music[1]["song"]    ="^5Catherine OST - Bizet L'Arlesienne Second Suite Farandole";
	level.music[1]["alias"]    ="radio2";
	level.music[2]["song"]    ="^5Catherine OST - Bach Little Fugue in G minor";
	level.music[2]["alias"]    ="radio3";
	level.music[3]["song"]    ="Catherine - Stray Sheep (Hip-Hop Remix)";
	level.music[3]["alias"]    ="radio4";
	level.music[4]["song"]    ="Sound Rush - Froz3n";
	level.music[4]["alias"]    ="radio5";
	level.music[5]["song"]    ="Bass Modulators - Oxygen";
	level.music[5]["alias"]    ="radio6";

	//GENERAL VARS
	level.inroom = false;

	//PRECACHE
	precacheItem("rpd_mp");
	precacheItem("ak47_mp");
	precacheShader("cathlogo");
	level.wind_fx = loadFx( "wind" );
	level.endlight_fx = loadFx( "end_light" );
	level.endlight_g_fx = loadFx( "end_light_godray" );
	level.pickup_object = loadFx( "pickup" );

	//DISABLING FALLDAMAGE
	setDvar("bg_falldamagemaxheight", 9999999 );
    setDvar("bg_falldamageminheight", 999999 );

	//thread addTestClients();

	//GENERAL THREADS
	//thread bounce_givesniper();
	//thread bounce_snipers_models_anim();
	thread secret();
	thread secret_end();
	//thread sniper_fail();
	//thread bounce_fail();
	//thread blocks_fail();
	thread secret_check_1();
	thread secret_check_2();
	thread secret_check_3();
	thread secret_check_4();
	thread secret_check_5();
	thread secret_check_6();
	thread secret_fail();
	thread end();
	thread opening();
	//thread musicBox();
	//thread gap_fail_1();
	//thread gap_fail_2();
	//thread gap_fail_3();
	//thread gap_fail_4();
	//thread gap_end();

	//ACTIVATOR THREADS
	addTriggerToList("trap1");
	addTriggerToList("trap2");
	addTriggerToList("trap3");
	addTriggerToList("trap4");
	addTriggerToList("trap5");
	addTriggerToList("trap6");
	addTriggerToList("trap7");
	addTriggerToList("trap8");

	//thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();

	//BATTLE THREADS
	//thread sniper();
	//thread knife();
//	thread bounce();
	//thread gap();
	//thread pure_strafe();
	//thread blocks();
		thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createSecretWays("Secret_Way");
	thread sr\api\_speedrun::createTeleporter((180.874, -30.3021, 0.125001), 50, 95, (7797, 1317, 414), 359, "freeze", "blue", "secret_0");

}

/*
   ___                       _
  / __|___ _ _  ___ _ _ __ _| |
 | (_ / -_) ' \/ -_) '_/ _` | |
  \___\___|_||_\___|_| \__,_|_|

*/

secret_check_1()
{
	trigger = getEnt("secret_check_1","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 1)
		{
			player.checkpointid = 1;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

secret_check_2()
{
	trigger = getEnt("secret_check_2","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 2)
		{
			player.checkpointid = 2;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

secret_check_3()
{
	trigger = getEnt("secret_check_3","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 3)
		{
			player.checkpointid = 3;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

secret_check_4()
{
	trigger = getEnt("secret_check_4","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 4)
		{
			player.checkpointid = 4;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

secret_check_5()
{
	trigger = getEnt("secret_check_5","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 5)
		{
			player.checkpointid = 5;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

secret_check_6()
{
	trigger = getEnt("secret_check_6","targetname");

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (player.checkpointid < 6)
		{
			player.checkpointid = 6;
			player iPrintln( "^3 Checkpoint reached" );
		}
	}
}

death_room()
{
	loser = getEnt( "death_loser_tp", "targetname" );
    winner = getEnt( "death_winner_tp", "targetname" );

	if( self.pers["team"] == "allies" )
		{
			if( isDefined( level.activ ))
			{
			level.activ TakeAllWeapons();
			level.activ freezecontrols(1);
			level.activ setOrigin( loser.origin );
			level.activ setplayerangles( loser.angles );
			}

			level.other freezecontrols(1);
			level.other TakeAllWeapons();
			level.other GiveWeapon( "knife_mp" );
			level.other switchToWeapon( "knife_mp" );
			level.other setOrigin( winner.origin );
			level.other setplayerangles( winner.angles );
			wait 2;
			level.other freezecontrols(0);
		}

	if( self.pers["team"] == "axis" )
		{
			level.other TakeAllWeapons();
			level.other freezecontrols(1);
			level.other setOrigin( loser.origin );
			level.other setplayerangles( loser.angles );

			if( isDefined( level.activ ))
			{
			level.activ freezecontrols(1);
			level.activ TakeAllWeapons();
			level.activ GiveWeapon( "knife_mp" );
			level.activ switchToWeapon( "knife_mp" );
			level.activ setOrigin( winner.origin );
			level.activ setplayerangles( winner.angles );
			wait 2;
			level.activ freezecontrols(0);
			}
		}
}

gap_triggered()
{
	jump = getEnt( "sniper_jumper_tp", "targetname" );
    acti = getEnt( "sniper_acti_tp", "targetname" );

	if( self.pers["team"] == "allies" )
	{
		self setOrigin( jump.origin );
		self setplayerangles( jump.angles );
	}

	if( self.pers["team"] == "axis" )
	{
		self setOrigin( acti.origin );
		self setplayerangles( acti.angles );
	}
}

gap_fail_1()
{
	trigger = getEnt("gap_fail_1","targetname");
	while(1)
	{
		trigger waittill ( "trigger", player );
		player freezecontrols(1);
		player gap_triggered();
		iPrintlnBold( player.name + " ^1failed at the 1st gap" );
		player TakeAllWeapons();
		player GiveWeapon( "beretta_mp" );
        player giveMaxAmmo( "beretta_mp" );
		player switchToWeapon( "beretta_mp" );
		level notify( "gap_completed" );
	}
}

gap_fail_2()
{
	trigger = getEnt("gap_fail_2","targetname");
	while(1)
	{
		trigger waittill ( "trigger", player );
		player freezecontrols(1);
		player gap_triggered();
		iPrintlnBold( player.name + " ^2failed at the 2nd gap" );
		player TakeAllWeapons();
		player GiveWeapon( "deserteagle_mp" );
        player giveMaxAmmo( "deserteagle_mp" );
		player switchToWeapon( "deserteagle_mp" );
		level notify( "gap_completed" );
	}
}

gap_fail_3()
{
	trigger = getEnt("gap_fail_3","targetname");
	while(1)
	{
		trigger waittill ( "trigger", player );
		player freezecontrols(1);
		player gap_triggered();
		iPrintlnBold( player.name + " ^3failed at the 3rd gap" );
		player TakeAllWeapons();
		player GiveWeapon( "m40a3_mp" );
        player giveMaxAmmo( "m40a3_mp" );
		player switchToWeapon( "m40a3_mp" );
		level notify( "gap_completed" );
	}
}

gap_fail_4()
{
	trigger = getEnt("gap_fail_4","targetname");
	while(1)
	{
		trigger waittill ( "trigger", player );
		player freezecontrols(1);
		player gap_triggered();
		iPrintlnBold( player.name + " ^4failed at the 4th gap" );
		player TakeAllWeapons();
		player GiveWeapon( "ak47_mp" );
        player giveMaxAmmo( "ak47_mp" );
		player switchToWeapon( "ak47_mp" );
		level notify( "gap_completed" );
	}
}

gap_end()
{
	trigger = getEnt("gap_end","targetname");
	while(1)
	{
		trigger waittill ( "trigger", player );
		player freezecontrols(1);
		player gap_triggered();
		iPrintlnBold( player.name + " ^5completed the gap room" );
		player TakeAllWeapons();
		player GiveWeapon( "rpd_mp" );
        player giveMaxAmmo( "rpd_mp" );
		player switchToWeapon( "rpd_mp" );
		level notify( "gap_completed" );
	}
}


bounce_givesniper()
{
	trigger = getEnt("bounce_givesniper","targetname");
	while(1)
	{
		trigger waittill ( "trigger", player );
		player TakeAllWeapons();
		player GiveWeapon( "m40a3_mp" );
        player giveMaxAmmo( "m40a3_mp" );
        player GiveWeapon( "remington700_mp" );
        player giveMaxAmmo( "remington700_mp" );
		player switchToWeapon( "m40a3_mp" );
	}

}

bounce_snipers_models_anim()
{
	xmdl1 = getEnt("sniper_bounce_model1","targetname");
	xmdl2 = getEnt("sniper_bounce_model2","targetname");
	while(1)
	{
		wait 2;
		xmdl1 movez (-10,2,1,1);
		xmdl2 movez (-10,2,1,1);
		wait 2;
		xmdl1 movez (10,2,1,1);
		xmdl2 movez (10,2,1,1);
	}
}

secret_end()
{
	trigger = getEnt( "secret_teleport_end_trigger", "targetname" );
	dest = getEnt( "secret_teleport_end", "targetname" );
	while(1)
	{
		trigger waittill ( "trigger", player );
		iPrintln( player.name + "^1 has completed the secret!" );
		player braxi\_rank::giveRankXP("", 500);
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
		player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

secret()
{
	dest = getEnt( "secret_teleport", "targetname" );
	secret_key = getEnt( "secret_key", "targetname" );
	secret_door = getEnt( "secret_door", "targetname" );

	secret_key waittill ( "trigger", player );

	iPrintln("^1Something has been unleashed");

	while(1)
	{
		secret_door waittill ( "trigger", player );
		player.checkpointid = 0;
		iPrintln( player.name + "^1 has discovered a secret!" );
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
	}
}

secret_fail()
{
	trigger = getEnt( "secret_fail_tp", "targetname" );
	dest = getEnt( "secret_teleport", "targetname" );
	check1 = getEnt( "secret_check_1_tp", "targetname" );
	check2 = getEnt( "secret_check_2_tp", "targetname" );
	check3 = getEnt( "secret_check_3_tp", "targetname" );
	check4 = getEnt( "secret_check_4_tp", "targetname" );
	check5 = getEnt( "secret_check_5_tp", "targetname" );
	check6 = getEnt( "secret_check_6_tp", "targetname" );

	while(1)
	{
		trigger waittill ( "trigger", player );
		if (isDefined(player.checkpointid))
		{
			if (player.checkpointid == 0)
			{
				player setOrigin( dest.origin );
				player setplayerangles( dest.angles );
			}
			if (player.checkpointid == 1)
			{
				player setOrigin( check1.origin );
				player setplayerangles( check1.angles );
			}
			if (player.checkpointid == 2)
			{
				player setOrigin( check2.origin );
				player setplayerangles( check2.angles );
			}
			if (player.checkpointid == 3)
			{
				player setOrigin( check3.origin );
				player setplayerangles( check3.angles );
			}
			if (player.checkpointid == 4)
			{
				player setOrigin( check4.origin );
				player setplayerangles( check4.angles );
			}
			if (player.checkpointid == 5)
			{
				player setOrigin( check5.origin );
				player setplayerangles( check5.angles );
			}
			if (player.checkpointid == 6)
			{
				player setOrigin( check6.origin );
				player setplayerangles( check6.angles );
			}
		}
	}
}

blocks_fail()
{
	dest_acti = getEnt( "blocks_acti_tp", "targetname" );
	dest_jumper = getEnt( "blocks_jumper_tp", "targetname" );

	trigger = getEnt ( "blocks_fail_tp", "targetname" );

	while(1)
	{
		trigger waittill ( "trigger", player );

		if( player.pers["team"] == "allies" )
		{
			player setOrigin( dest_jumper.origin );
			player setplayerangles( dest_jumper.angles );
		}

		if( player.pers["team"] == "axis" )
		{
			player setOrigin( dest_acti.origin );
			player setplayerangles( dest_acti.angles );
		}
	}
}

sniper_fail()
{
	dest_acti = getEnt( "sniper_acti_tp", "targetname" );
	dest_jumper = getEnt( "sniper_jumper_tp", "targetname" );

	trigger = getEnt ( "sniper_fail_tp", "targetname" );

	while(1)
	{
		trigger waittill ( "trigger", player );

		if( player.pers["team"] == "allies" )
		{
			player setOrigin( dest_jumper.origin );
			player setplayerangles( dest_jumper.angles );
		}

		if( player.pers["team"] == "axis" )
		{
			player setOrigin( dest_acti.origin );
			player setplayerangles( dest_acti.angles );
		}
	}
}

bounce_fail()
{
	dest_acti = getEnt( "bounce_acti_tp", "targetname" );
	dest_jumper = getEnt( "bounce_jumper_tp", "targetname" );

	trigger = getEnt ( "bounce_fail_tp", "targetname" );

	while(1)
	{
		trigger waittill ( "trigger", player );

		if( player.pers["team"] == "allies" )
		{
			player setOrigin( dest_jumper.origin );
			player setplayerangles( dest_jumper.angles );
		}

		if( player.pers["team"] == "axis" )
		{
			player setOrigin( dest_acti.origin );
			player setplayerangles( dest_acti.angles );
		}
	}
}

end()
{
	dest = getEnt( "end_teleport", "targetname" );
	trigger = getEnt ( "endmap_trig", "targetname" );

	while(1)
	{
		trigger waittill ( "trigger", player );

		player thread sr\api\_speedrun::finishWay("normal_0");
		player setOrigin( dest.origin );
		player setplayerangles( dest.angles );
	}
}

bounce_pickup_fx()
{
	level.bouncetriggered = true;
	fxspawn = getEnt("fx_bounce_pickup","targetname");
	PlayFX( level.pickup_object, fxspawn.origin );
}

playSoundOnAllPlayers( soundAlias )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		players[i] playLocalSound( soundAlias );
	}
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
    level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

opening()
{
sd1 = getEnt("startdoor1","targetname");
sd2 = getEnt("startdoor2","targetname");
sd3 = getEnt("startdoor3","targetname");

wait 0.1;
sd1 delete();
sd2 delete();
sd3 delete();
}

musicBox()
{
    trig=getent("musicbox","targetname");
    trig waittill("trigger",p);
    trig delete();

    p freezecontrols(1);
	p thread musicfix();
    p musicMenu();
}

musicfix()
{
	self waittill( "death" );
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
}

musicMenu()
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
    /*self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(1,0.5,0);

    i++;*/
    self.hud_music[i] = braxi\_mod::addTextHud( self, 320, 30, 0.93, "center", "top", 1.4 );
    self.hud_music[i].sort = 884;
    //self.hud_music[i] setText("Catherine musicbox");
	self.hud_music[i] setShader( "cathlogo", 200, 200 );
	//self.hud_music[i].font = "objective";
    //self.hud_music[i].glowalpha=1;
    /*if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else
        self.hud_music[i].glowcolor=(1,0.5,0);*/
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 320, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;
    self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");

    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 320, 230+(j*16), 0.93, "center", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        if(isdefined(level.randomcolor))
            self.hud_music[i].glowcolor=level.randomcolor;
        else
            self.hud_music[i].glowcolor=(1,0.5,0);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 320, 230, 0.4, "center", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 550, 17 );
    indicator.color=(1,0,0.5);

	wait 0.5;

    while(self.sessionstate == "playing")
    {
        wait 0.1;

        if(self attackButtonPressed())
        {
            self.hud_music[2+self.selection].alpha = 0.93;

            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;

            item = self.hud_music[2+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
            iprintln("^6>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
            ambientPlay(level.music[self.selection]["alias"]);
            self freezecontrols(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezecontrols(0);
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

/*
    _      _   _          _
   /_\  __| |_(_)_ ____ _| |_ ___ _ _
  / _ \/ _|  _| \ V / _` |  _/ _ \ '_|
 /_/ \_\__|\__|_|\_/\__,_|\__\___/_|

*/

trap1()
{
	trap = getEnt("trap1","targetname");
	trapact1 = getEnt("trapact1_1","targetname");
	trapact2 = getEnt("trapact1_2","targetname");
	trapact2 enablelinkto();
	trapact2 linkto(trapact1);

	trap waittill("trigger",player);

	trap setHintString ("[^6Trap activated!^7]");

	trapact1 movez (-177,0.1);
	wait 0.1;
	trapact1 PlaySound("crush");
	wait 3;
	trapact2 delete();
	trapact1 movez (177,4,0.1);
}

trap2()
{
	trap = getEnt("trap2","targetname");
	trapact = getEnt("trapact2","targetname");
	mantle = getEnt("mantle_trap2","targetname");

	trap waittill("trigger",player);

	trap setHintString ("[^6Trap activated!^7]");
	mantle delete();
	while(1)
	{
		trapact rotateYaw (1800,5);
		wait 5;
	}
}

trap3()
{
	trap = getEnt("trap3","targetname");
	trapact1 = getEnt("trapact3_1","targetname");
	trapact2 = getEnt("trapact3_2","targetname");

	trapactx1 = getEnt("trapact3_1_xmodel","targetname");
	trapactx2 = getEnt("trapact3_2_xmodel","targetname");
	trapactx3 = getEnt("trapact3_3_xmodel","targetname");
	trapactx4 = getEnt("trapact3_4_xmodel","targetname");
	trapactx5 = getEnt("trapact3_5_xmodel","targetname");

	trapactx1 linkto(trapact1);
	trapactx2 linkto(trapact1);
	trapactx4 linkto(trapact1);
	trapactx5 linkto(trapact1);
	trapactx3 linkto(trapact2);

	trap waittill("trigger",player);

	trap setHintString ("[^6Trap activated!^7]");
	trapact1 movez (50,1);
	trapact2 movez (-50,1);
	while(1)
	{
		wait 1;
		trapact1 movez (-100,1);
		trapact2 movez (100,1);
		wait 1;
		trapact1 movez (100,1);
		trapact2 movez (-100,1);
	}
}

trap4()
{
	fxspawn = getEnt("fx_wind","targetname");
	trap = getEnt("trap4","targetname");
	trapact = getEnt("trapact4","targetname");

	trap waittill("trigger",player);

	trap setHintString ("[^6Trap activated!^7]");

	while(1)
	{
		thread air_fan();
		fxspawn PlaySound("fan");
		PlayFX( level.wind_fx, fxspawn.origin, (-1,1,0) );
		wait 7;
		level notify( "fan_end" );
		wait 4;
	}
}

trap5()
{
	trap = getEnt("trap5","targetname");
	trapact = getEnt("trapact5","targetname");

	trap waittill("trigger",player);

	trap setHintString ("[^6Trap activated!^7]");

	while(1)
	{
		trapact rotatePitch (90,5);
		wait 8;
		trapact rotatePitch (-90,5);
		wait 8;
	}
}

trap6()
{
	trap = getEnt("trap6","targetname");
	trapact = getEnt("trapact6","targetname");

	trap waittill("trigger",player);

	trap setHintString ("[^6Trap activated!^7]");

	trapact hide();
	trapact notsolid();
	wait 5;
	trapact show();
	trapact solid();
}

trap7()
{
	trap = getEnt("trap7","targetname");
	trapact1 = getEnt("trapact7_1","targetname");
	trapact2 = getEnt("trapact7_2","targetname");
	trapact2 enablelinkto();
	trapact2 linkto(trapact1);

	trap waittill("trigger",player);

	trap setHintString ("[^6Trap activated!^7]");
	trapact1 movez (-708,1);
	wait 1;
	trapact1 PlaySound("crush");
	wait 3;
	trapact2 delete();
	trapact1 movez (708,1);
}

trap8()
{
	trap = getEnt("trap8","targetname");
	trapact1 = getEnt("trapact8_1","targetname");
	trapact2 = getEnt("trapact8_2","targetname");

	trap waittill("trigger",player);

	trap setHintString ("[^6Trap activated!^7]");

	while (1)
	{
		trapact1 movey(-413,1,0.5,0.5);
		trapact2 movey(413,1,0.5,0.5);
		wait 1;
		trapact1 movey(413,1,0.5,0.5);
		trapact2 movey(-413,1,0.5,0.5);
		wait 1;
	}
}


air_fan()
{
	level endon( "fan_end" );
	trigger = getEnt ( "air_push", "targetname" );

	while(1)
	{
    	trigger waittill ( "trigger", player );
		eInflictor = player;
		eAttacker = player;
		iDamage = 200;
		iDFlags = 0;
		sMeansOfDeath = "MOD_PROJECTILE";
		sWeapon = "panzershreck_mp";
		vPoint = ( player.origin + (1,-1,0) );
		vDir = vectornormalize( player.origin - vPoint );
		sHitLoc = "none";
		psOffsetTime = 0;
		player.health = ( player.health + iDamage );

		player finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
}

/*

  ___       _   _   _
 | _ ) __ _| |_| |_| |___
 | _ \/ _` |  _|  _| / -_)
 |___/\__,_|\__|\__|_\___|

*/

info(msg, submsg)
{
	players = getentarray("player", "classname");
	noti = SpawnStruct();
	noti.titleText = msg;
	noti.notifyText = submsg;
	noti.duration = 5;
	noti.glowcolor = (1,0,1);
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
}

sniper()
{
        room = getEnt( "sniper_room", "targetname");
        jump = getEnt( "sniper_jumper_tp", "targetname" );
        acti = getEnt( "sniper_acti_tp", "targetname" );

        while(1)
		{
                room waittill( "trigger", player );

				if(!level.inroom)
				{

				level.inroom = true;

                if( !isDefined( room ) )
                return;

			    player freezecontrols(1);
				level.activ freezecontrols(1);

				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "m40a3_mp" );
                player giveMaxAmmo( "m40a3_mp" );
                player GiveWeapon( "remington700_mp" );
                player giveMaxAmmo( "remington700_mp" );
				player switchToWeapon( "m40a3_mp" );
                player.maxhealth = 100;


                if( isDefined( level.activ ) && isAlive( level.activ ) )
				{

					level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "m40a3_mp" );
					level.activ giveMaxAmmo( "m40a3_mp" );
					level.activ GiveWeapon( "remington700_mp" );
					level.activ giveMaxAmmo( "remington700_mp" );
					level.activ switchToWeapon( "m40a3_mp" );
                    level.activ.maxhealth = 100;

				}

                wait 0.05;

            info("Sniper Room", player.name + " ^1VS ^7" + level.activ.name);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(0);
            level.activ freezecontrols(0);

                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
			iPrintlnBold( player.name + " ^6died during a sniper fight!" );
			iPrintlnBold( "^2Endroom is now free!" );
			level.inroom = false;
			}
			}
}

knife()
{
        room = getEnt( "knife_room", "targetname");
        jump = getEnt( "sniper_jumper_tp", "targetname" );
        acti = getEnt( "sniper_acti_tp", "targetname" );

        while(1)
		{
                room waittill( "trigger", player );

				if(!level.inroom)
				{

				level.inroom = true;

                if( !isDefined( room ) )
                return;

			    player freezecontrols(1);
				level.activ freezecontrols(1);

				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" );
				player switchToWeapon( "knife_mp" );
                player.maxhealth = 100;


                if( isDefined( level.activ ) && isAlive( level.activ ) )
				{

					level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "knife_mp" );
					level.activ switchToWeapon( "knife_mp" );
                    level.activ.maxhealth = 100;

				}

                wait 0.05;

            info("Knife Room", player.name + " ^1VS ^7" + level.activ.name);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(0);
            level.activ freezecontrols(0);

                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
			iPrintlnBold( player.name + " ^6died during a knife fight!" );
			iPrintlnBold( "^2Endroom is now free!" );
			level.inroom = false;
			}
			}
}

bounce()
{
        room = getEnt( "bounce_room", "targetname");
        jump = getEnt( "bounce_jumper_tp", "targetname" );
        acti = getEnt( "bounce_acti_tp", "targetname" );

        while(1)
		{
                room waittill( "trigger", player );

				if(!level.inroom)
				{

				level.inroom = true;

                if( !isDefined( room ) )
                return;

				if (!isDefined(level.bouncetriggered))
					bounce_pickup_fx();

			    player freezecontrols(1);
				level.activ freezecontrols(1);

				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" );
				player switchToWeapon( "knife_mp" );
                player.maxhealth = 100;


                if( isDefined( level.activ ) && isAlive( level.activ ) )
				{

					level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "knife_mp" );
					level.activ switchToWeapon( "knife_mp" );
                    level.activ.maxhealth = 100;

				}

                wait 0.05;

            info("Bounce Room", player.name + " ^1VS ^7" + level.activ.name);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(0);
            level.activ freezecontrols(0);

                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
			iPrintlnBold( player.name + " ^6died during a bounce fight!" );
			iPrintlnBold( "^2Endroom is now free!" );
			level.inroom = false;
			}
			}
}

gap()
{
        room = getEnt( "gap_room", "targetname");
        jump = getEnt( "gap_jumper_tp", "targetname" );
        acti = getEnt( "gap_acti_tp", "targetname" );

        while(1)
		{
                room waittill( "trigger", player );

				if(!level.inroom)
				{

				level.inroom = true;

                if( !isDefined( room ) )
                return;

			    player freezecontrols(1);
				level.activ freezecontrols(1);

				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "deserteagle_mp" );
                player giveMaxAmmo( "deserteagle_mp" );
				player switchToWeapon( "deserteagle_mp" );
                player.maxhealth = 100;


                if( isDefined( level.activ ) && isAlive( level.activ ) )
				{

					level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "deserteagle_mp" );
					level.activ giveMaxAmmo( "deserteagle_mp" );
					level.activ switchToWeapon( "deserteagle_mp" );
                    level.activ.maxhealth = 100;

				}

                wait 0.05;

            info("Gap Room", player.name + " ^1VS ^7" + level.activ.name);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(0);
            level.activ freezecontrols(0);

			level waittill( "gap_completed" );
			level waittill( "gap_completed" );

			wait 1;

			player iPrintlnBold( "Get ready for the battle!" );
            level.activ iPrintlnBold( "Get ready for the battle!" );

			wait 3;

			player iPrintlnBold( "^1FIGHT!" );
            level.activ iPrintlnBold( "^1FIGHT!" );

			player freezecontrols(0);
			level.activ freezecontrols(0);

                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
			iPrintlnBold( player.name + " ^6died during a gap fight!" );
			iPrintlnBold( "^2Endroom is now free!" );
			level.inroom = false;
			}
			}
}

pure_strafe()
{
		end = getEnt( "strafe_end", "targetname");
        room = getEnt( "strafe_room", "targetname");
        jump = getEnt( "strafe_jumper_tp", "targetname" );
        acti = getEnt( "strafe_acti_tp", "targetname" );

        while(1)
		{
                room waittill( "trigger", player );

				level.other = player;

				if(!level.inroom)
				{

				level.inroom = true;

                if( !isDefined( room ) )
                return;

			    player freezecontrols(1);
				level.activ freezecontrols(1);

				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "deserteagle_mp" );
                player giveMaxAmmo( "deserteagle_mp" );
				player switchToWeapon( "deserteagle_mp" );
                player.maxhealth = 100;


                if( isDefined( level.activ ) && isAlive( level.activ ) )
				{

					level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "deserteagle_mp" );
					level.activ giveMaxAmmo( "deserteagle_mp" );
					level.activ switchToWeapon( "deserteagle_mp" );
                    level.activ.maxhealth = 100;

				}

                wait 0.05;

            info("Pure Strafe Room", player.name + " ^1VS ^7" + level.activ.name);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(0);
            level.activ freezecontrols(0);

			end waittill( "trigger", endplayer );

			endplayer death_room();

                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
			iPrintlnBold( player.name + " ^6died during a strafe fight!" );
			iPrintlnBold( "^2Endroom is now free!" );
			level.inroom = false;
			}
			}
}

blocks()
{
		end = getEnt( "blocks_end", "targetname");
        room = getEnt( "blocks_room", "targetname");
        jump = getEnt( "blocks_jumper_tp", "targetname" );
        acti = getEnt( "blocks_acti_tp", "targetname" );

        while(1)
		{
                room waittill( "trigger", player );

				level.other = player;

				if(!level.inroom)
				{

				level.inroom = true;

                if( !isDefined( room ) )
                return;

			    player freezecontrols(1);
				level.activ freezecontrols(1);

				player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "deserteagle_mp" );
                player giveMaxAmmo( "deserteagle_mp" );
				player switchToWeapon( "deserteagle_mp" );
                player.maxhealth = 100;


                if( isDefined( level.activ ) && isAlive( level.activ ) )
				{

					level.activ setPlayerangles( acti.angles );
                    level.activ setOrigin( acti.origin );
                    level.activ TakeAllWeapons();
                    level.activ GiveWeapon( "deserteagle_mp" );
					level.activ giveMaxAmmo( "deserteagle_mp" );
					level.activ switchToWeapon( "deserteagle_mp" );
                    level.activ.maxhealth = 100;

				}

                wait 0.05;

            info("Blocks Room", player.name + " ^1VS ^7" + level.activ.name);
            wait 1;
            player iPrintlnBold( "^13" );
            level.activ iPrintlnBold( "^13" );
            wait 1;
            player iPrintlnBold( "^32" );
            level.activ iPrintlnBold( "^32" );
            wait 1;
            player iPrintlnBold( "^51" );
            level.activ iPrintlnBold( "^51" );
            wait 1;
            player iPrintlnBold( "^2GO^7!" );
            level.activ iPrintlnBold( "^2GO^7!" );
            player freezecontrols(0);
            level.activ freezecontrols(0);

			end waittill( "trigger", endplayer );

			endplayer death_room();

                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
			iPrintlnBold( player.name + " ^6died during a parkour fight!" );
			iPrintlnBold( "^2Endroom is now free!" );
			level.inroom = false;
			}
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
         ent[i].pers["registered"] = 0;
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