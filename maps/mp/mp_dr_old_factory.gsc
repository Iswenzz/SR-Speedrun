// Map by CM'Nobody
// Map name : mp_dr_old_factory


// Discord : Derazerr | Nobody#3996
// Steam :  xderazerr

// Map Features
// - Activator secret
// - Jumper secret
// - 8 Rooms (Weapon,Rpg,Purestrafe,Sniper,Bounce,Knife,Race,SimonSays)
// - Random Party Mode
// - VIP Party Mode
// - VIP Weapon

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
thread sr\api\_map::createSpawnOrigin((-76, -4852, -152), 360);
maps\mp\_load::main();


    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

	setDvar("bg_falldamagemaxheight", 99999);
	setDvar("bg_falldamageminheight", 99998 );

    setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0","1");
    setdvar("r_glowbloomintensity1","1");
    setdvar("r_glowskybleedintensity0","1");
	setDvar("bg_falldamagemaxheight", 99999);
	setDvar("bg_falldamageminheight", 99998 );

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createTeleporter((262, -5789, -244), 60, 80, (5236, -8086, 835), 271 , "freeze", "red", "secret_0");
	thread sr\api\_speedrun::createSecretWays("Hard Secret;");




    //TRAPS TRIGGERS//

    addTriggerToList("trig_trap1");
    addTriggerToList("trig_trap2");
    addTriggerToList("trig_trap3");
    addTriggerToList("trig_trap4");
    addtriggerTolist("trig_trap5");
	//trap 6 works without activator
    addtriggerTolist("trig_trap7");
    //trap 8 works without activator
    addtriggerTolist("trig_trap9");
    addtriggerTolist("trig_trap10");
    addTriggerToList("trig_trap11");
    addTriggerToList("trig_trap12");

    precacheItem("ak74u_mp");
    precacheItem("m40a3_mp");
    precacheItem("remington700_mp");
    precacheItem("ak47_mp");
    precacheItem("skorpion_mp");
    precacheItem("m14_mp");
    precacheItem("mp5_mp");
    precacheItem("deserteagle_mp");
    precacheItem("rpd_mp");
    precacheItem("m1014_mp");
    precacheItem("p90_mp");
    precacheItem("rpg_mp");
    precacheItem("katana_mp");
    precacheItem("v_pist_tec9_mp");

 	thread tpback();
	thread tpnext();
//	thread signspectator();
//	thread vipweapon_check1();
 //   thread randompartymodeprob();
 //   thread partyunlock();

	thread startdoor();
	thread bouncepad1();
	thread bouncepad2();


    thread fuck_you();
//	thread trap1();
//	thread traplaser();
//	thread trap2();
//	thread trap3();
//	thread trap4();
//	thread trap5();
//	thread trap6();
 //   thread trap7all();
//	thread trap8();
//	thread trap9();
//	thread trap10();
//	thread trap11();
  //  thread trap12();
 //   thread trap13();

  //  thread jumptimerentrance();
    thread tpsecend();
    thread secret1();
    thread secret2();
    thread secret3();
    thread secret4();
 //   thread hardsecretway_acti();
  //  thread hardsecretend_acti();
 //   thread secret1_acti();
 //   thread secret2_acti();
  //  thread secret3_acti();
 //   thread secret4_acti();
 //   thread acti_secret_leave();

  //  thread message();
  //  thread activator_katana();
  //  thread randompartyjukebox();
  //  thread gun_drop();

//	thread roomselection();

//	thread weaponglassaa();
//	thread weaponglass();
//	thread weapon_room();

//	thread simonsays();

//	thread purestart();

 //   thread bounce_room_weapon();
//    thread bounce_room();
 //   thread bounce_room_jumper();
 //   thread bounce_room_activator();

  //  thread scope_room();
 //   thread sniper_room_fail();

 //   thread knife_room();

//    thread runstart();
 //   thread race_jumper_1();
 //   thread race_acti_1();
 //   thread race_jumper_2();
 //   thread race_acti_2();
 //   thread race_jumper_3();
 //   thread race_acti_3();
 //   thread race_jumper_4();
 //   thread race_acti_4();
 //   thread race_jumper_5();
  //  thread race_acti_5();
 //   thread race_jumper_6();
 //   thread race_acti_6();
  //  thread race_jumper_7();
 //   thread race_acti_7();
 //   thread race_jumper_8();
 //   thread race_acti_8();

 //   thread rpg_room();
 //   thread rpg_room_fail();


}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

startdoor()
{
door = getent("startdoor","targetname");
{
door moveZ(250, 3);
iprintlnbold("^5test");
}
}



bouncepad1()
{
	trig = getent("trig_bouncepad", "targetname");

	while(1)
	{
    	trig waittill ( "trigger", player );

	    player thread bounce2();
	}
}

bouncepad2()
{
	trig = getent("trig_bouncepad2", "targetname");

	while(1)
	{
    	trig waittill ( "trigger", player );

	    player thread bounce2();
	}
}

bounce2()
{
    for(i = 0; i < 4; i++)
	{
	    self.health += 100;
        self finishPlayerDamage(self, level.jumpattacker, 100, 0, "MOD_FALLING", "jump_mp", self.origin, AnglesToForward((-90,0,0)), "head", 0);
	}
}

// MUSICBOX
 musicbox()
{
    trig = getEnt("musictrigger","targetname");
    trig setHintString("^7Press ^5[&&1]^7 to select song");
    trig waittill("trigger", p);
    trig delete();
    p freezeControls(1);
    level.playingMusic = "choosing";
    p musicmenu();
}

musicmenu()
{
    //self endon( "disconnect" );
    //self endon( "death" );
    //self endon( "spawned" );
    //self endon( "joined_spectators" );
    self endon( "music thread terminated" );

    self.hud_music = [];
    self.selection = 0;

    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "white", 360, 160 ); //background image
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 346, 20 ); //should be bar image, i suggest to not change cuz your texture will be stretched
    self.hud_music[i].color=(0,1,1);

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("                             Music Menu"); //title
    self.hud_music[i].glowalpha=1;
    self.hud_music[i].glowcolor=(0,1,1); //title text color
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("                                                                   Scroll: ^5[{+attack}] ^7| Select: ^5[{+activate}]"); //just change numbers of colors here if you need different ones

    for( j = 0; j < level.music.size; j++ )
    {
        i++;
        self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_music[i].sort = 882;
        self.hud_music[i].font = "objective";
        self.hud_music[i].glowalpha=1;
        self.hud_music[i].glowcolor=(0,1,1);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 346, 17 ); //another bar image that will most likely stretch, i suggest to only change colors
    indicator.color=(0,1,1);

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
            thread playMusic(level.music[self.selection]["alias"], level.music[self.selection]["length"], level.music[self.selection]["song"], true);
            self freezeControls(0);
            break;
        }
        else if (!isAlive(self))
        {
            thread playMusic(level.music[self.selection]["alias"], level.music[self.selection]["length"], level.music[self.selection]["song"], true);
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

playMusic(music, time, print, default_styling) //music = alias, time = length, print = song, default_styling = styling or not (true/false)
{
    if (isDefined(level.playingMusic) && level.playingMusic == music)
        return 0;
    if (isDefined(level.playingMusic) && level.playingMusic == "song5"){iPrintLn("^1Absolute song playing!"); return 0;}

    level.playingMusic = music;

    level notify ("newmusic"); //tells new music is here
    level endon ("newmusic"); //ends if new music comes
    level notify ("stop_party");
    wait 0.1;
    SetExpFog(0, 1000000, 0, 0, 0, 0);


    AmbientStop();
    wait 0.5;
    for(;;)
    {
        if (isDefined(default_styling) && default_styling == true)
            iPrintLn("^5>>^7Now playing: " +print+ "^5<<");
        else
            iPrintLn(print);

        AmbientPlay(music);
        wait time;
        AmbientStop();
        wait 1;
    }
}

GetMusicFromArray(searchBy, search)
{
    for(i=0;i<level.music.size;i++)
    {
        if (level.music[i][searchBy] == search)
        {
            music = level.music[i];
            return music;
        }
    }
    iPrintLnBold("NO SONG FOUND \n NO SONG FOUND \n NO SONG FOUND");
    return "Nomusic";
}

traplaser()
{
	move_trig = getent("traplasertrig","targetname"); //Name of your hurt_trigger
	move = getent("traplaser","targetname"); //Name of your base

	move moveZ (1, 0.5);
}

trap1a()
{
	move_trig = getent("move_trig","targetname"); //Name of your hurt_trigger
	move = getent("move","targetname"); //Name of your base

    for(;;)
    {
	    move moveY (448, 1);
	    move rotateroll(720, 1);
	    wait 2.5;
	}
}

trap1b()
{
	move_trig2 = getent("move_trig2","targetname"); //Name of your hurt_trigger
	move2 = getent("move2","targetname"); //Name of your base
	while(1)
	{
		move2 moveY(-448, 1);
		move2 rotateroll(-720, 1);
		wait 2.5;
	}
}

trap1c()
{
	move_trig3 = getent("move_trig3","targetname"); //Name of your hurt_trigger
	move3 = getent("move3","targetname"); //Name of your base

	while(1)
	{
		move3 moveY(448, 1);
		move3 rotateroll(720, 1);
		wait 2.5;
	}
}


trap1a2()
{
	move_trig = getent("move_trig","targetname"); //Name of your hurt_trigger
	move = getent("move","targetname"); //Name of your base
    for(;;)
    {
	    wait 1.25;
	    move moveY (-448, 1);
	    move rotateroll(-720, 1);
	    wait 1.25;
	}
}

trap1b2()
{
	move_trig2 = getent("move_trig2","targetname"); //Name of your hurt_trigger
	move2 = getent("move2","targetname"); //Name of your base
	while(1)
	{
		wait 1.25;
		move2 moveY(448, 1);
		move2 rotateroll(720, 1);
		wait 1.25;
	}
}

trap1c2()
{
	move_trig3 = getent("move_trig3","targetname"); //Name of your hurt_trigger
	move3 = getent("move3","targetname"); //Name of your base
	while(1)
	{
		wait 1.25;
		move3 moveY(-448, 1);
		move3 rotateroll(-720, 1);
		wait 1.25;
	}
}

trap1()
{
    trig = getent("trig_trap1", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();

    thread trap1a();
    thread trap1b();
    thread trap1c();
    thread trap1a2();
    thread trap1b2();
    thread trap1c2();
    thread trap13antiglitch4();
    thread trap13antiglitch5();
    thread trap13antiglitch6();
}

trap13antiglitch4()
{
    move_antiglitch2 = getent("move_antiglitch4","targetname");
    for(;;)
    {
        move_antiglitch2 moveY(448, 1);
        wait 1.25;
        move_antiglitch2 moveY(-448, 1);
        wait 1.25;
    }
}


trap13antiglitch5()
{
    move_antiglitch2 = getent("move_antiglitch5","targetname");
    for(;;)
    {
        move_antiglitch2 moveY(-448, 1);
        wait 1.25;
        move_antiglitch2 moveY(448, 1);
        wait 1.25;
    }
}


trap13antiglitch6()
{
    move_antiglitch2 = getent("move_antiglitch6","targetname");
    for(;;)
    {
        move_antiglitch2 moveY(448, 1);
        wait 1.25;
        move_antiglitch2 moveY(-448, 1);
        wait 1.25;
    }
}


//TRAP6 WORKS WITHOUT ACTIVATOR
trap6()
{
    block1 = getent("trap6_b", "targetname");
    thread trap6a();
    thread trap6b();
    for(;;)
    {
    block1 moveX (-6996, 20);
    wait 20;
    block1 moveZ (-500, 1);
    block1 hide();
    wait 2;
    block1 moveX (6996, 1);
    wait 2;
    block1 moveZ (500, 1);
    wait 2.4;
    block1 show();
    }
}


trap6b()
{
    block2 = getent("trap6_c", "targetname");
    wait 13.18;
    for(;;)
    {
    block2 moveX (-6996, 20);
    wait 20;
    block2 moveZ (-500, 1);
    block2 hide();
    wait 2;
    block2 moveX (6996, 1);
    wait 2;
    block2 moveZ (500, 1);
    wait 2.4;
    block2 show();
    }
}

trap6a()
{
    block1 = getent("trap6_a", "targetname");
    block1 moveX (-6996, 20);
    wait 20;
    block1 delete();
}

trap3()
{
    trig = getent("trig_trap3", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();

    thread trap3_d();
    thread trap3_c();
}

trap3_d()
{
	block2 = getent("trap3_d", "targetname");

    for(;;)
    {
    block2 moveY (-316, 0.5);
    wait 1;
    block2 moveY (316, 0.5);
    wait 1;
    }
}

trap3_c()
{
	block1 = getent("trap3_c", "targetname");

    for(;;)
    {
    block1 moveY (316, 0.5);
    wait 1;
    block1 moveY (-316, 0.5);
    wait 1;
    }
}

trap4()
{
    trig = getent("trig_trap4", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();

    thread trap4_a();
    thread trap4_b();
}

trap4_a()
{
	block1 = getent("trap4_a", "targetname");

    for(;;)
    {
    block1 moveY (-316, 0.5);
    wait 1;
    block1 moveY (316, 0.5);
    wait 1;
    }
}

trap4_b()
{
	block1 = getent("trap4_b", "targetname");

    for(;;)
    {
    block1 moveY (316, 0.5);
    wait 1;
    block1 moveY (-316, 0.5);
    wait 1;
    }
}

trap5()
{
    trig = getent("trig_trap5", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();

    thread trap5_a();
    thread trap5_b();
}

trap5_a()
{
	block1 = getent("trap5_a", "targetname");

    for(;;)
    {
    block1 rotatepitch (360, 8);
    wait 8;
    }
}

trap5_b()
{
	block1 = getent("trap5_b", "targetname");

    for(;;)
    {
    block1 rotatepitch (360, 4);
    wait 4;
    }
}
trap2()
{
    trig = getent("trig_trap2", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();
    for(;;)
    {
    thread trap2f();
    wait 0.6;
    thread trap2e();
    wait 0.6;
    thread trap2d();
    wait 0.6;
    thread trap2c();
    wait 0.6;
    thread trap2b();
    wait 0.6;
    thread trap2a();
    wait 1.2;
    }
}

trap2a()
{
    move = getent("trap2_a", "targetname");
    move_trig = getent("trap2_a_trig","targetname");
	move_trig enablelinkto();
	move_trig linkto(move);

    move moveZ (45, 0.5);
    wait 0.6;
    move moveZ (-45, 0.5);
}
trap2b()
{
    move = getent("trap2_b", "targetname");
    move_trig = getent("trap2_b_trig","targetname");
	move_trig enablelinkto();
	move_trig linkto(move);

    move moveZ (45, 0.5);
    wait 0.6;
    move moveZ (-45, 0.5);
}
trap2c()
{
    move = getent("trap2_c", "targetname");
    move_trig = getent("trap2_c_trig","targetname");
	move_trig enablelinkto();
	move_trig linkto(move);

    move moveZ (45, 0.5);
    wait 0.6;
    move moveZ (-45, 0.5);
}
trap2d()
{
    move = getent("trap2_d", "targetname");
    move_trig = getent("trap2_d_trig","targetname");
	move_trig enablelinkto();
	move_trig linkto(move);

    move moveZ (45, 0.5);
    wait 0.6;
    move moveZ (-45, 0.5);
}
trap2e()
{
    move = getent("trap2_e", "targetname");
    move_trig = getent("trap2_e_trig","targetname");
	move_trig enablelinkto();
	move_trig linkto(move);

    move moveZ (45, 0.5);
    wait 0.6;
    move moveZ (-45, 0.5);
}
trap2f()
{
    move = getent("trap2_f", "targetname");
    move_trig = getent("trap2_f_trig","targetname");
	move_trig enablelinkto();
	move_trig linkto(move);

    move moveZ (45, 0.5);
    wait 0.6;
    move moveZ (-45, 0.5);
}

trap8a()
{
	block1 = getent("trap8_a", "targetname");
    block1 moveX (97, 0.5);
    wait 1;
    block1 moveX (-97, 0.5);
}

trap8b()
{
	block1 = getent("trap8_b", "targetname");
    block1 moveX (-97, 0.5);
    wait 1;
    block1 moveX (97, 0.5);
}
//TRAP 8 WORKS WITHOUT ACTIVATOR
trap8()
{
	block1 = getent("trap8_a", "targetname");
	block2 = getent("trap8_b", "targetname");;
    block1 moveX (-89, 1.5);
    block2 moveX (89, 1.5);
    wait 3;
    for(;;)
    {
    thread trap8a();
    thread trap8b();
    wait 2;
    }
}

trap7all()
{
    trig = getent("trig_trap7", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();

    thread trap7();
    thread trap7b();
    thread trap7c();
    thread trap7d();
    thread trap7e();
    thread trap7f();
    thread trap7g();
    thread trap7h();
    thread trap7i();
    thread trap7j();
    thread trap7k();
    thread trap7l();
    thread trap7m();
    thread trap7n();
    thread trap7o();
    thread trap7p();
    thread trap7_1();
    thread trap7_2();
    thread trap7_3();
    thread trap7_4();
    thread trap7_5();
    thread trap7_6();

    thread trap7_box_a();
    thread trap7_box_b();
    thread trap7_box_c();
    thread trap7_box_d();
    thread trap7_box_e();
    thread trap7_box_f();

    thread trap7_box_1();
    thread trap7_box_2();
    thread trap7_box_3();
    thread trap7_box_4();
    thread trap7_box_5();
    thread trap7_box_6();
    thread trap7_box_7();
    thread trap7_box_8();
    thread trap7_box_9();
    thread trap7_box_10();
    thread trap7_box_11();
    thread trap7_box_12();
    thread trap7_box_13();
    thread trap7_box_14();
}

trap7()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");

    for(;;)
    {
    block1 moveX (640, 4);
    wait 5;
    block1 moveZ (-50, 0.5);
    wait 1;
    block1 moveX (-640, 0.5);
    wait 1;
    block1 moveZ (50, 0.5);
    wait 1;
    }
}

trap7b()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");

    wait 0.56;
    for(;;)
    {
    block2 moveX (640, 4);
    wait 5;
    block2 moveZ (-50, 0.5);
    wait 1;
    block2 moveX (-640, 0.5);
    wait 1;
    block2 moveZ (50, 0.5);
    wait 1;
    }
}

trap7c()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");

    wait 1.12;
    for(;;)
    {
    block3 moveX (640, 4);
    wait 5;
    block3 moveZ (-50, 0.5);
    wait 1;
    block3 moveX (-640, 0.5);
    wait 1;
    block3 moveZ (50, 0.5);
    wait 1;
    }
}

trap7d()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");

    wait 1.58;
    for(;;)
    {
    block4 moveX (640, 4);
    wait 5;
    block4 moveZ (-50, 0.5);
    wait 1;
    block4 moveX (-640, 0.5);
    wait 1;
    block4 moveZ (50, 0.5);
    wait 1;
    }
}


trap7e()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");

    wait 2.14;
    for(;;)
    {
    block5 moveX (640, 4);
    wait 5;
    block5 moveZ (-50, 0.5);
    wait 1;
    block5 moveX (-640, 0.5);
    wait 1;
    block5 moveZ (50, 0.5);
    wait 1;
    }
}

trap7f()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");

    wait 2.7;
    for(;;)
    {
    block6 moveX (640, 4);
    wait 5;
    block6 moveZ (-50, 0.5);
    wait 1;
    block6 moveX (-640, 0.5);
    wait 1;
    block6 moveZ (50, 0.5);
    wait 1;
    }
}

trap7g()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");

    wait 3.26;
    for(;;)
    {
    block7 moveX (640, 4);
    wait 5;
    block7 moveZ (-50, 0.5);
    wait 1;
    block7 moveX (-640, 0.5);
    wait 1;
    block7 moveZ (50, 0.5);
    wait 1;
    }
}


trap7h()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");

    wait 3.82;
    for(;;)
    {
    block8 moveX (640, 4);
    wait 5;
    block8 moveZ (-50, 0.5);
    wait 1;
    block8 moveX (-640, 0.5);
    wait 1;
    block8 moveZ (50, 0.5);
    wait 1;
    }
}

trap7i()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");
    block9 = getent("trap7_i", "targetname");
    block10 = getent("trap7_j", "targetname");
    block11 = getent("trap7_k", "targetname");
    block12 = getent("trap7_l", "targetname");

    wait 4.28;
    for(;;)
    {
    block9 moveX (640, 4);
    wait 5;
    block9 moveZ (-50, 0.5);
    wait 1;
    block9 moveX (-640, 0.5);
    wait 1;
    block9 moveZ (50, 0.5);
    wait 1;
    }
}

trap7j()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");
    block9 = getent("trap7_i", "targetname");
    block10 = getent("trap7_j", "targetname");
    block11 = getent("trap7_k", "targetname");
    block12 = getent("trap7_l", "targetname");

    wait 4.84;
    for(;;)
    {
    block10 moveX (640, 4);
    wait 5;
    block10 moveZ (-50, 0.5);
    wait 1;
    block10 moveX (-640, 0.5);
    wait 1;
    block10 moveZ (50, 0.5);
    wait 1;
    }
}

trap7k()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");
    block9 = getent("trap7_i", "targetname");
    block10 = getent("trap7_j", "targetname");
    block11 = getent("trap7_k", "targetname");
    block12 = getent("trap7_l", "targetname");

    wait 5.40;
    for(;;)
    {
    block11 moveX (640, 4);
    wait 5;
    block11 moveZ (-50, 0.5);
    wait 1;
    block11 moveX (-640, 0.5);
    wait 1;
    block11 moveZ (50, 0.5);
    wait 1;
    }
}

trap7l()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");
    block9 = getent("trap7_i", "targetname");
    block10 = getent("trap7_j", "targetname");
    block11 = getent("trap7_k", "targetname");
    block12 = getent("trap7_l", "targetname");

    wait 5.96;
    for(;;)
    {
    block12 moveX (640, 4);
    wait 5;
    block12 moveZ (-50, 0.5);
    wait 1;
    block12 moveX (-640, 0.5);
    wait 1;
    block12 moveZ (50, 0.5);
    wait 1;
    }
}

trap7m()
{
    block1 = getent("trap7_a", "targetname");
    block2 = getent("trap7_b", "targetname");
    block3 = getent("trap7_c", "targetname");
    block4 = getent("trap7_d", "targetname");
    block5 = getent("trap7_e", "targetname");
    block6 = getent("trap7_f", "targetname");
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");
    block9 = getent("trap7_i", "targetname");
    block10 = getent("trap7_j", "targetname");
    block11 = getent("trap7_k", "targetname");
    block12 = getent("trap7_l", "targetname");
    block13 = getent("trap7_m", "targetname");

    wait 6.52;
    for(;;)
    {
    block13 moveX (640, 4);
    wait 5;
    block13 moveZ (-50, 0.5);
    wait 1;
    block13 moveX (-640, 0.5);
    wait 1;
    block13 moveZ (50, 0.5);
    wait 1;
    }
}

trap7n()
{
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");
    block9 = getent("trap7_i", "targetname");
    block10 = getent("trap7_j", "targetname");
    block11 = getent("trap7_k", "targetname");
    block12 = getent("trap7_l", "targetname");
    block13 = getent("trap7_m", "targetname");
    block14 = getent("trap7_n", "targetname");

    wait 7.08;
    for(;;)
    {
    block14 moveX (640, 4);
    wait 5;
    block14 moveZ (-50, 0.5);
    wait 1;
    block14 moveX (-640, 0.5);
    wait 1;
    block14 moveZ (50, 0.5);
    wait 1;
    }
}

trap7o()
{
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");
    block9 = getent("trap7_i", "targetname");
    block10 = getent("trap7_j", "targetname");
    block11 = getent("trap7_k", "targetname");
    block12 = getent("trap7_l", "targetname");
    block13 = getent("trap7_m", "targetname");
    block14 = getent("trap7_n", "targetname");
    block15 = getent("trap7_o", "targetname");

    wait 7;
    for(;;)
    {
    block15 moveX (640, 4);
    wait 5;
    block15 moveZ (-50, 0.5);
    wait 1;
    block15 moveX (-640, 0.5);
    wait 1;
    block15 moveZ (50, 0.5);
    wait 1;
    }
}

trap7p()
{
    block7 = getent("trap7_g", "targetname");
    block8 = getent("trap7_h", "targetname");
    block9 = getent("trap7_i", "targetname");
    block10 = getent("trap7_j", "targetname");
    block11 = getent("trap7_k", "targetname");
    block12 = getent("trap7_l", "targetname");
    block13 = getent("trap7_m", "targetname");
    block14 = getent("trap7_n", "targetname");
    block15 = getent("trap7_o", "targetname");
    block16 = getent("trap7_p", "targetname");

    wait 7.5;
    for(;;)
    {
    block16 moveX (640, 4);
    wait 5;
    block16 moveZ (-50, 0.5);
    wait 1;
    block16 moveX (-640, 0.5);
    wait 1;
    block16 moveZ (50, 0.5);
    wait 1;
    }
}

trap7_1()
{
    block1 = getent("trap7_1", "targetname");

    block1 moveX (640, 4);
    wait 3.32;
    block1 delete();
}

trap7_2()
{
    block1 = getent("trap7_2", "targetname");

    block1 moveX (640, 4);
    wait 2.73;
    block1 delete();
}

trap7_3()
{
    block1 = getent("trap7_3", "targetname");

    block1 moveX (640, 4);
    wait 2.13;
    block1 delete();
}

trap7_4()
{
    block1 = getent("trap7_4", "targetname");

    block1 moveX (640, 4);
    wait 1.53;
    block1 delete();
}

trap7_5()
{
    block1 = getent("trap7_5", "targetname");

    block1 moveX (640, 4);
    wait 0.93;
    block1 delete();
}

trap7_6()
{
    block1 = getent("trap7_6", "targetname");

    block1 moveX (640, 4);
    wait 0.34;
    block1 delete();

}

trap7_box_a()
{
    block1 = getent("trap7_box_a", "targetname");

    block1 moveX (640, 4);
    wait 0.95;
    block1 delete();

}

trap7_box_b()
{
    block1 = getent("trap7_box_b", "targetname");

    block1 moveX (640, 4);
    wait 1.45;
    block1 delete();

}

trap7_box_c()
{
    block1 = getent("trap7_box_c", "targetname");

    block1 moveX (640, 4);
    wait 1.95;
    block1 delete();

}

trap7_box_d()
{
    block1 = getent("trap7_box_d", "targetname");

    block1 moveX (640, 4);
    wait 2.45;
    block1 delete();

}

trap7_box_e()
{
    block1 = getent("trap7_box_e", "targetname");

    block1 moveX (640, 4);
    wait 2.95;
    block1 delete();

}

trap7_box_f()
{
    block1 = getent("trap7_box_f", "targetname");
    block1 moveX (640, 4);
    wait 3.45;
    block1 delete();

}

trap7_box_1()
{
    block1 = getent("trap7_box_1", "targetname");
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }

}

trap7_box_2()
{
    block1 = getent("trap7_box_2", "targetname");
    wait 0.5;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_3()
{
    block1 = getent("trap7_box_3", "targetname");
    wait 1;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_4()
{
    block1 = getent("trap7_box_4", "targetname");
    wait 1.5;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_5()
{
    block1 = getent("trap7_box_5", "targetname");
    wait 2;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_6()
{
    block1 = getent("trap7_box_6", "targetname");
    wait 2.5;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_7()
{
    block1 = getent("trap7_box_7", "targetname");
    wait 3;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_8()
{
    block1 = getent("trap7_box_8", "targetname");
    wait 3.5;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_9()
{
    block1 = getent("trap7_box_9", "targetname");
    wait 4;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_10()
{
    block1 = getent("trap7_box_10", "targetname");
    wait 4.5;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_11()
{
    block1 = getent("trap7_box_11", "targetname");
    wait 5;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_12()
{
    block1 = getent("trap7_box_12", "targetname");
    wait 5.5;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_13()
{
    block1 = getent("trap7_box_13", "targetname");
    wait 6;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}

trap7_box_14()
{
    block1 = getent("trap7_box_14", "targetname");
    wait 6.5;
    for(;;)
    {
    block1 moveX (632, 4);
    wait 4.5;
    block1 moveZ (-64, 0.2);
    wait 0.5;
    block1 moveX (-632, 0.2);
    wait 0.5;
    block1 moveZ (64, 0.2);
    wait 0.5;
    }
}




trap9()
{
    trig = getent("trig_trap9", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();

    thread trap9_a();
    thread trap9_b();
    thread trap9_c();
}

trap9_a()
{
	block1 = getent("trap9_a", "targetname");

    for(;;)
    {
    block1 moveX (-288, 0.5);
    wait 0.7;
    block1 moveX (288, 0.5);
    wait 0.7;
    }
}

trap9_b()
{
	block1 = getent("trap9_b", "targetname");

    for(;;)
    {
    block1 moveX (-288, 0.5);
    wait 0.7;
    block1 moveX (288, 0.5);
    wait 0.7;
    }
}

trap9_c()
{
	block1 = getent("trap9_c", "targetname");

    for(;;)
    {
    block1 moveX (-288, 0.5);
    wait 0.7;
    block1 moveX (288, 0.5);
    wait 0.7;
    }
}


trap10()
{
	platform_b = getent("trap10_platform_b", "targetname");
	platform_b2 = getent("trap10_platform_b2", "targetname");
	platform_c = getent("trap10_platform_c", "targetname");
	platform_c2 = getent("trap10_platform_c2", "targetname");

    trig = getent("trig_trap10", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();
    platform_c2 hide();
    platform_c hide();
    platform_b2 hide();
    platform_b hide();
    for(;;)
    {

    thread trap10_1();
    thread trap10_4();
    wait 2.4;
    thread trap10_2();
    thread trap10_3();
    wait 2.4;
    }
}



trap10_1()
{
	platform_a = getent("trap10_platform_a", "targetname");
	platform_a2 = getent("trap10_platform_a2", "targetname");
	platform_b = getent("trap10_platform_b", "targetname");
	platform_b2 = getent("trap10_platform_b2", "targetname");

    platform_a moveZ (-162, 0.6);
    wait 1.2;
    platform_a moveZ (162, 0.6);
    wait 1.2;

    platform_b show();
    platform_b2 show();
    platform_b Solid();
    platform_b2 Solid();
	platform_a hide();
    platform_a2 hide();
    platform_a notSolid();
    platform_a2 notSolid();
}

trap10_2()
{
	platform_a = getent("trap10_platform_a", "targetname");
	platform_a2 = getent("trap10_platform_a2", "targetname");
	platform_b = getent("trap10_platform_b", "targetname");
	platform_b2 = getent("trap10_platform_b2", "targetname");

    platform_b moveZ (162, 0.6);
    wait 1.2;
    platform_b moveZ (-162, 0.6);
    wait 1.2;

	platform_b hide();
    platform_b2 hide();
    platform_b notSolid();
    platform_b2 notSolid();
    platform_a show();
    platform_a2 show();
    platform_a Solid();
    platform_a2 Solid();
}


trap10_3()
{
	platform_a = getent("trap10_platform_c", "targetname");
	platform_a2 = getent("trap10_platform_c2", "targetname");
	platform_b = getent("trap10_platform_d", "targetname");
	platform_b2 = getent("trap10_platform_d2", "targetname");

    platform_a moveZ (-162, 0.6);
    wait 1.2;
    platform_a moveZ (162, 0.6);
    wait 1.2;

    platform_b show();
    platform_b2 show();
    platform_b Solid();
    platform_b2 Solid();
	platform_a hide();
    platform_a2 hide();
    platform_a notSolid();
    platform_a2 notSolid();
}

trap10_4()
{
	platform_a = getent("trap10_platform_c", "targetname");
	platform_a2 = getent("trap10_platform_c2", "targetname");
	platform_b = getent("trap10_platform_d", "targetname");
	platform_b2 = getent("trap10_platform_d2", "targetname");

    platform_b moveZ (162, 0.6);
    wait 1.2;
    platform_b moveZ (-162, 0.6);
    wait 1.2;

	platform_b hide();
    platform_b2 hide();
    platform_b notSolid();
    platform_b2 notSolid();
    platform_a show();
    platform_a2 show();
    platform_a Solid();
    platform_a2 Solid();
}

tpnext() {
	trigger = getent ("tp_next", "targetname");
	target = getent ("origin_next", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

tpback() {
	trigger = getent ("tp_back", "targetname");
	target = getent ("origin_back", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

trap11()
{
	platform = getent("trap11a", "targetname");
    trig = getent("trig_trap11", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();

    platform notSolid();
    platform hide();
}

trap12()
{
    platform = getent("trap12", "targetname");
    trig = getent("trig_trap12", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to activate");
    trig waittill("trigger", player);
    trig delete();

    platform notSolid();
    platform hide();
}


//TRAP 13 AUTO

trap13a()
{
    move_trig7 = getent("move_trig7","targetname"); //Name of your hurt_trigger
    move7 = getent("move7","targetname"); //Name of your base
    move_trig7 enablelinkto(); // This is the most important part of the script. this allows you to move the trigger.
    move_trig7 linkto(move7); //Now you must link the trigger to the base
    move7 moveZ(-256, 0.5);
    wait 1;
    for(;;)
    {
        move7 moveX (448, 1);
        move7 rotatepitch(720, 1);
        wait 2.5;
    }
}

trap13b()
{
    move_trig6 = getent("move_trig6","targetname"); //Name of your hurt_trigger
    move6 = getent("move6","targetname"); //Name of your base
    move_trig6 enablelinkto(); // This is the most important part of the script. this allows you to move the trigger.
    move_trig6 linkto(move6); //Now you must link the trigger to the base
    move6 moveZ(-256, 0.5);
    wait 1;
    while(1)
    {
        move6 moveX(-448, 1);
        move6 rotatepitch(-720, 1);
        wait 2.5;
    }
}


trap13a2()
{
    move_trig7 = getent("move_trig7","targetname"); //Name of your hurt_trigger
    move7 = getent("move7","targetname"); //Name of your base
    move_trig7 linkto(move7); //Now you must link the trigger to the base
    wait 1;
    for(;;)
    {
        wait 1.25;
        move7 moveX (-448, 1);
        move7 rotatepitch(-720, 1);
        wait 1.25;
    }
}

trap13b2()
{
    move_trig6 = getent("move_trig6","targetname"); //Name of your hurt_trigger
    move6 = getent("move6","targetname"); //Name of your base
    move_trig6 linkto(move6); //Now you must link the trigger to the base
    wait 1;
    while(1)
    {
        wait 1.25;
        move6 moveX(448, 1);
        move6 rotatepitch(720, 1);
        wait 1.25;
    }
}

trap13antiglitch1()
{
    move_antiglitch1 = getent("move_antiglitch1","targetname");
    wait 1;
    for(;;)
    {
        move_antiglitch1 moveX(-448, 1);
        wait 1.25;
        move_antiglitch1 moveX(448, 1);
        wait 1.25;
    }
}

trap13antiglitch2()
{
    move_antiglitch2 = getent("move_antiglitch2","targetname");
    wait 1;
    for(;;)
    {
        move_antiglitch2 moveX(448, 1);
        wait 1.25;
        move_antiglitch2 moveX(-448, 1);
        wait 1.25;
    }
}

trap13()
{
    thread trap13a();
    thread trap13b();
    thread trap13a2();
    thread trap13b2();
    thread trap13antiglitch1();
    thread trap13antiglitch2();
}



	//ROOM SELECTION

roomselection()
{
    trig = getEnt ("roomtrigger", "targetname");
    orig = getEnt ("roomorigin", "targetname");

    while (1)
    {
        trig setHintString ("^7Press ^5[&&1]^7 to enter ^5Selection Room");
        trig waittill ("trigger", player);
        player takeAllWeapons();
        player setOrigin (orig.origin);
        player setPlayerAngles(orig.angles);
        trig setHintString (player + " in room!");
        while (isDefined(player) && isAlive(player))
        wait .05;
    }
}

	//WEAPON ROOM

weapon_room()
{
    level.trigger_weapon = getEnt ("weapontp", "targetname");

    orig_jumper = getEnt ("origin_jumper_weapon", "targetname");
    orig_acti = getEnt ("origin_activator_weapon", "targetname");

    while (1)
    {
        level.trigger_weapon setHintString ("^7Press ^5[&&1]^7 to enter ^5Weapon Room");
        level.trigger_weapon waittill ("trigger", player);
        level.trigger_weapon setHintString ("^5" + player.name + "^7 in room!");

        thread fightHUD("Weapon Room", player, level.activ);
        player setOrigin (orig_jumper.origin);
        player thread removeTextActivator();
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread endTimerRun("^5Let s Go !", 3, 0);
        wait 3;
        player giveWeapon("ak74u_mp");
        player giveMaxAmmo("ak74u_mp");
        player switchToWeapon("ak74u_mp");

        if(isDefined(level.activ) && isAlive(level.activ))
        {
        	thread fightHUD("Weapon Room", player, level.activ);
            level.activ thread removeTextActivator();
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ thread endTimerRun("^5Let s Go !", 3, 0);
        	wait 3;
        	player giveWeapon("ak74u_mp");
        	player giveMaxAmmo("ak74u_mp");
        	player switchToWeapon("ak74u_mp");
        }

        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^5" + player.name + " ^7has died in ^5Weapon Room!");
    }
}

weaponglass() //ACTI WALL
{
    block = getent("weapon_glass", "targetname");
    trig = getent("glass_trigger_weapon", "targetname");
    trig waittill("trigger", player);

    for(;;)
    {
    wait 0.1;
    block rotateYaw(360, 7);
    }
}
weaponglassaa() //FULLCLIP ACTI WALL
{
    block = getent("weapon_glassa", "targetname");
    trig = getent("glass_trigger_weapon", "targetname");
    trig waittill("trigger", player);

    for(;;)
    {
    wait 0.1;
    block rotateYaw(360, 7);
    }
}

endTimerRun(text, duration, extra)
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
        self.endTimerHUD setText("^5" + duration);
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
    hud.glowalpha = 1;
    hud.glowcolor = (0.5,0.5,0.5);

    return hud;
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
        activ = "undefined";
    else
        activ = activ.name;

    waitTime = 3; //s
    offset = 200; //ms

    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();

    level.hud_fight = createHUD( 0, 85, "center", "top", 1, "objective", 1.5 );
    level.hud_fight setText("^7" + room);
    level.hud_fight setPulseFX( 40, waitTime*1000-offset, offset );

    level.hud_fight2 = createHUD( 0, 100, "center", "top", 1, "objective", 1.5 );
    level.hud_fight2 setText("^5" + jumper + " ^7VS^7 " + "^5" + activ);
    level.hud_fight2 setPulseFX( 40, waitTime*1000-offset, offset );

    wait waitTime;
    if (isDefined(level.hud_fight)) level.hud_fight destroy();
    if (isDefined(level.hud_fight2)) level.hud_fight2 destroy();
}

//SIMON SAYS

simonsays()
{
    level.race = getent("sstp", "targetname");
	level.race_acti_tp = getent("actissori","targetname");
	level.race_jumper_tp = getent("jumperssori","targetname");

	black = getent("ss_black", "targetname");
	blue = getent("ss_blue", "targetname");
	blue2 = getent("ss_blue2", "targetname");
	green = getent("ss_green", "targetname");
	yellow = getent("ss_yellow", "targetname");
	orange = getent("ss_orange", "targetname");
	red = getent("ss_red", "targetname");
	purple = getent("ss_purple", "targetname");
	pink = getent("ss_pink", "targetname");

	black hide();
	blue hide();
	blue2 hide();
	green hide();
	yellow hide();
	orange hide();
	red hide();
	purple hide();
	pink hide();

	while(1)
    {
    	level.race setHintString("^7Press ^5[&&1]^7 to enter ^5SimonSays Room");
        level.race waittill( "trigger", player );
        if(isDefined(level.actiBusy) && level.actiBusy == 1)
			player iprintlnbold("^5Activator is busy, wait a few seconds");
		else
		{
        if(!isDefined(level.race))
            return;

        if(!isdefined(level.activKills))
			level.playername = player.name;

		//player
        player thread removeTextActivator();
		player freezeControls(1);
        player thread removeTextActivator();
        player setOrigin(level.race_jumper_tp.origin);
		player setPlayerangles(level.race_jumper_tp.angles);
		player TakeAllWeapons();
		player SetClientDVAR("cg_thirdperson", 1);
        player thread endTimerKnife("^5Let s Go !", 3, 0);

		//acti
		if (isDefined(level.activ) && isAlive(level.activ))
		{
            level.activ thread removeTextActivator();
			level.activ freezeControls(1);
			level.activ setOrigin( level.race_acti_tp.origin );
			level.activ setPlayerangles( level.race_acti_tp.angles );
			level.activ TakeAllWeapons();
			level.activ SetClientDVAR("cg_thirdperson", 1);
			level.activ thread endTimerKnife("^5Let s Go !", 3, 0);
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

        iPrintLnBold ("^5" + player.name + " ^7has died in ^5Simon Says Room!");
		}
    }
}

ss_check(player)
{
	trig = getent("ss_lose", "targetname");
	level.orig_winner = getent("ss_winner", "targetname");
	level.orig_loser = getent("ss_loser", "targetname");
	trig waittill("trigger", loser);
	level.wall hide();
	level.ss_on = 0;

	if (isDefined(level.activ) && loser == level.activ) //jumper wins
	{
		loser freezeControls(1);
		loser setOrigin( level.orig_loser.origin );
		loser setPlayerAngles( level.orig_loser.angles );
		loser iPrintLnBold("^5You have lost!");

		loser giveWeapon("knife_mp");
		loser giveMaxAmmo("knife_mp");
		loser switchToWeapon("knife_mp");

		player freezeControls(1);
		player setOrigin(level.orig_winner.origin);
		player setPlayerAngles(level.orig_winner.angles);
		player iPrintLnBold("^5You won !");
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
		loser setOrigin(level.orig_loser.origin);
		loser setPlayerAngles(level.orig_loser.angles);
		loser iPrintLnBold("^5You have lost!");

		loser giveWeapon("knife_mp");
		loser giveMaxAmmo("knife_mp");
		loser switchToWeapon("knife_mp");

		if (isDefined(level.activ))
		{
			level.activ freezeControls(1);
			level.activ setOrigin( level.orig_winner.origin );
			level.activ setPlayerAngles( level.orig_winner.angles );
			level.activ iPrintLnBold("^5You won !");
			level.activ SetClientDVAR("cg_thirdperson", 0);
			wait 4;
			player freezeControls(0);

			level.activ giveWeapon("knife_mp");
			level.activ giveMaxAmmo("knife_mp");
			level.activ switchToWeapon("knife_mp");
		}
		else
			player iPrintLnBold("^5No activator ?!");
	}
}

ss_game(player)
{
	black = getent("ss_black", "targetname");
	blue = getent("ss_blue", "targetname");
	blue2 = getent("ss_blue2", "targetname");
	green = getent("ss_green", "targetname");
	yellow = getent("ss_yellow", "targetname");
	orange = getent("ss_orange", "targetname");
	red = getent("ss_red", "targetname");
	purple = getent("ss_purple", "targetname");
	pink = getent("ss_pink", "targetname");

	ss_black = getent("ss_ss_black", "targetname");
	ss_blue = getent("ss_ss_blue", "targetname");
	ss_blue2 = getent("ss_ss_blue2", "targetname");
	ss_green = getent("ss_ss_green", "targetname");
	ss_yellow = getent("ss_ss_yellow", "targetname");
	ss_orange = getent("ss_ss_orange", "targetname");
	ss_red = getent("ss_ss_red", "targetname");
	ss_purple = getent("ss_ss_purple", "targetname");
	ss_pink = getent("ss_ss_pink", "targetname");

	level.ss_on = 1;
	hide = "";
	level.wall = "";
	time = 0;
	length = 3.5;

	while (level.ss_on == 1)
	{
		black hide();
		blue hide();
		blue2 hide();
		green hide();
		yellow hide();
		orange hide();
		red hide();
		purple hide();
		pink hide();

		colour = randomint(9);
		if (colour == 0)
		{
			hide = ss_black;
			level.wall = black;
			black show();
		}
		if (colour == 1)
		{
			hide = ss_blue;
			blue show();
			level.wall = blue;
		}
		if (colour == 2)
		{
			hide = ss_blue2;
			blue2 show();
			level.wall = blue2;
		}
		if (colour == 3)
		{
			hide = ss_green;
			green show();
			level.wall = green;
		}
		if (colour == 4)
		{
			hide = ss_yellow;
			yellow show();
			level.wall = yellow;
		}
		if (colour == 5)
		{
			hide = ss_orange;
			orange show();
			level.wall = orange;
		}
		if (colour == 6)
		{
			hide = ss_red;
			red show();
			level.wall = red;
		}
		if (colour == 7)
		{
			hide = ss_purple;
			purple show();
			level.wall = purple;
		}
		if (colour == 8)
		{
			hide = ss_pink;
			pink show();
			level.wall = pink;
		}

		wait(length);

		ss_black hide();
		ss_blue hide();
		ss_blue2 hide();
		ss_green hide();
		ss_yellow hide();
		ss_orange hide();
		ss_red hide();
		ss_purple hide();
		ss_pink hide();

		ss_black notsolid();
		ss_blue notsolid();
		ss_blue2 notsolid();
		ss_green notsolid();
		ss_yellow notsolid();
		ss_orange notsolid();
		ss_red notsolid();
		ss_purple notsolid();
		ss_pink notsolid();

		hide show();
		hide solid();
		level.wall show();

		wait 3;

		ss_black show();
		ss_blue show();
		ss_blue2 show();
		ss_green show();
		ss_yellow show();
		ss_orange show();
		ss_red show();
		ss_purple show();
		ss_pink show();

		ss_black solid();
		ss_blue solid();
		ss_blue2 solid();
		ss_green solid();
		ss_yellow solid();
		ss_orange solid();
		ss_red solid();
		ss_purple solid();
		ss_pink solid();

		time += 1;
		length -= 0.25;

		if(time == 14 && isAlive(player))
		{
			player iprintlnbold("You both ^5survived^7, now have a ^5knife battle ^7!");
			player giveWeapon("knife_mp");
			player switchToWeapon("knife_mp");
			if (isDefined(level.activ) && isAlive(level.activ))
			{
				level.activ iprintlnbold("You both ^5survived^7, now have a ^5knife battle ^7!");
				level.activ giveWeapon("knife_mp");
				level.activ switchToWeapon("knife_mp");
			}
			level.wall hide();
			level.ss_on = 0;
		}
	}
}

endTimerKnife(text, duration, extra)
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
        self.endTimerHUD setText("^5" + duration);
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


	//PURESTRAFE ROOM

purestart()
{
   trigger_strafe = getEnt ("puretp", "targetname");

    orig_jumper = getEnt ("pureorijumper", "targetname");
    orig_acti = getEnt ("pureoriacti", "targetname");

    while (1)
    {
        trigger_strafe setHintString ("^7Press ^5[&&1]^7 to enter ^5PureStrafe Room");
        trigger_strafe waittill ("trigger", player);
        trigger_strafe setHintString ("^5" + player.name + "^7 in room!");

        player thread removeTextActivator();
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player giveWeapon("knife_mp");
        player switchToWeapon ("knife_mp");
        player.maxhealth = 100;
		player thread endTimerPure("^5Let s Go !", 3, 0);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ thread removeTextActivator();
            level.activ setPlayerAngles(orig_acti.angles);
            level.activ setOrigin(orig_acti.origin);
            level.activ takeAllWeapons();
            level.activ giveWeapon("knife_mp");
            level.activ switchToWeapon("knife_mp");
            level.activ.maxhealth = 100;
			level.activ thread endTimerPure("^5Let s Go !", 3, 0);
        }
		thread fightHUD("PureStrafe Room!", player, level.activ);
		thread pureend(player, level.activ);

        while(isAlive(player) && isDefined(player))
            wait .05;

        iPrintLnBold ("^5" + player.name + " ^7has died in ^5PureStrafe Room!");
    }
}

pureend(who, who2)
{
	trig = getEnt ("pureendtp", "targetname");
	origWin = getEnt ("pureendwinner", "targetname");
	origLose = getEnt ("pureendlooser", "targetname");

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
        self.endTimerHUD setText("^5" + duration);
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

	//BOUNCE ROOM

bounce_room()
{
    level.trigger_bounce = getEnt ("trig_bounce_room", "targetname");

    orig_jumper = getEnt ("bounce_room_ori_jumper", "targetname");
    orig_acti = getEnt ("bounce_room_ori_acti", "targetname");

    while (1)
    {
        level.trigger_bounce setHintString ("^7Press ^5[&&1]^7 to enter ^5Bounce Room");
        level.trigger_bounce waittill ("trigger", player);
        level.trigger_bounce setHintString ("^5" + player.name + "^7 in room!");

        player thread removeTextActivator();
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player giveWeapon("knife_mp");
        player giveWeapon("tomahawk_mp");
        player switchToWeapon("tomahawk_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread endTimerRun("^5Let s Go !", 3, 0);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ thread removeTextActivator();
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
            level.activ giveWeapon("knife_mp");
            level.activ giveWeapon("tomahawk_mp");
            level.activ switchToWeapon("tomahawk_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ thread endTimerRun("^5Let s Go !", 3, 0);
        }
        thread fightHUD("Bounce Room", player, level.activ);

        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^5" + player.name + " ^7has died in ^5Bounce Room!");
    }
}

activator_katana()
{
    trig = getEnt ("katana_model_trigger", "targetname");
    katana_model = getEnt ("katana_model", "targetname");
    while (1)
    {
        trig waittill ("trigger", player);
        trig delete();
        katana_model delete();
        player giveWeapon("katana_mp");
        player switchToWeapon("katana_mp");
        iPrintLnBold ("^7You found the Activator's ^5Katana");
    }
}

bounce_room_weapon()
{
    trig = getEnt ("trig_bounce_weapon", "targetname");
    trig setHintString ("^7Press ^5[&&1]^7 to get a ^5Sniper");
    while (1)
    {
        trig waittill ("trigger", player);
        player takeAllWeapons();
        player giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        player giveWeapon("knife_mp");
        player giveMaxAmmo ("knife_mp");
        player switchToWeapon("m40a3_mp");
    }
}

bounce_room_activator() {
    trigger = getent ("bounce_room_trig_acti", "targetname");
    target = getent ("bounce_room_ori_acti", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}

bounce_room_jumper() {
    trigger = getent ("bounce_room_trig_jumper", "targetname");
    target = getent ("bounce_room_ori_jumper", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}

	//KNIFE ROOM

knife_room()
{
    level.trigger_knife = getEnt ("trig_knife_room", "targetname");

    orig_jumper = getEnt ("orig_knife_jumper", "targetname");
    orig_acti = getEnt ("orig_knife_activator", "targetname");

    while (1)
    {
        level.trigger_knife setHintString ("^7Press ^5[&&1]^7 to enter ^5Knife Room");
        level.trigger_knife waittill ("trigger", player);
        level.trigger_knife setHintString ("^5" + player.name + "^7 in room!");

        player setOrigin (orig_jumper.origin);
        player thread removeTextActivator();
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player giveWeapon("knife_mp");
        player giveWeapon("tomahawk_mp");
        player switchToWeapon("tomahawk_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread endTimerKnife("^5Let s Go !", 3, 0);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ thread removeTextActivator();
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
            level.activ giveWeapon("knife_mp");
            level.activ giveWeapon("tomahawk_mp");
            level.activ switchToWeapon("tomahawk_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            //level.activ thread endTimerKnife("^5Let s Go !", 3, 0);
        }
        thread fightHUD("Knife Room", player, level.activ);

        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^5" + player.name + " ^7has died in ^5Knife Room!");
    }
}

// SNIPER ROOM

scope_room()
{
    level.trigger_scope = getEnt ("snipertp", "targetname");

    orig_jumper = getEnt ("scoperoomjumper", "targetname");
    orig_acti = getEnt ("scoperoomactivator", "targetname");

    while (1)
    {
        level.trigger_scope setHintString ("^7Press ^5[&&1]^7 to enter ^5Sniper Room");
        level.trigger_scope waittill ("trigger", player);
        level.trigger_scope setHintString ("^5" + player.name + "^7 in room!");

        player thread removeTextActivator();
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player giveWeapon("remington700_mp");
        player giveMaxAmmo("remington700_mp");
        player giveWeapon("m40a3_mp");
        player giveMaxAmmo("m40a3_mp");
        player switchToWeapon("m40a3_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread endTimerRun("^5Let s Go !", 3, 0);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ thread removeTextActivator();
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
            level.activ giveWeapon("remington700_mp");
            level.activ giveMaxAmmo("remington700_mp");
            level.activ giveWeapon("m40a3_mp");
            level.activ giveMaxAmmo("m40a3_mp");
            level.activ switchToWeapon("m40a3_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ thread endTimerRun("^5Let s Go !", 3, 0);
        }
        thread fightHUD("Sniper Room", player, level.activ);

        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^5" + player.name + " ^7has died in ^5Sniper Room!");
    }
}


sniper_room_fail()
{
    orig_jumper = getEnt ("scoperoomjumper", "targetname");
    orig_acti = getEnt ("scoperoomactivator", "targetname");
    trig = getEnt ("trig_sniperfail", "targetname");
    for (;;)
    {
        trig waittill ("trigger", player);
        if (isDefined(level.activ) && player == level.activ)
        {
            level.activ setPlayerAngles(orig_acti.angles);
            level.activ setOrigin(orig_acti.origin);
        }
        else
        {
            player setPlayerAngles(orig_jumper.angles);
            player setOrigin(orig_jumper.origin);
        }
    }
}

// rpg ROOM

rpg_room()
{
    level.trigger_rpg = getEnt ("trig_rpg_room", "targetname");

    orig_jumper = getEnt ("rpgroomjumper", "targetname");
    orig_acti = getEnt ("rpgroomactivator", "targetname");

    while (1)
    {
        level.trigger_rpg setHintString ("^7Press ^5[&&1]^7 to enter ^5RPG Room");
        level.trigger_rpg waittill ("trigger", player);
        level.trigger_rpg setHintString ("^5" + player.name + "^7 in room!");

        player thread removeTextActivator();
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player giveWeapon("rpg_mp");
        player giveMaxAmmo("rpg_mp");
        player switchToWeapon("rpg_mp");
        player.maxhealth = 100;
        player.health = player.maxhealth;
        player thread endTimerRun("^5Let s Go !", 3, 0);
		player thread rpg_ammo();

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ thread removeTextActivator();
            level.activ setOrigin (orig_acti.origin);
            level.activ setPlayerAngles (orig_acti.angles);
            level.activ takeAllWeapons();
            level.activ giveWeapon("rpg_mp");
            level.activ giveMaxAmmo("rpg_mp");
            level.activ switchToWeapon("rpg_mp");
            level.activ.maxhealth = 100;
            level.activ.health = 100;
            level.activ thread endTimerRun("^5Let s Go !", 3, 0);
    		level.activ thread rpg_ammo();
        }
        thread fightHUD("RPG Room", player, level.activ);

        while(isDefined(player) && isAlive(player))
            wait .05;

        iPrintLnBold ("^5" + player.name + " ^7has died in ^5RPG Room!");
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


rpg_room_fail()
{
    orig_jumper = getEnt ("rpgroomjumper", "targetname");
    orig_acti = getEnt ("rpgroomactivator", "targetname");
    trig = getEnt ("trig_rpgfail", "targetname");
    for (;;)
    {
        trig waittill ("trigger", player);
        if (isDefined(level.activ) && player == level.activ)
        {
            level.activ setPlayerAngles(orig_acti.angles);
            level.activ setOrigin(orig_acti.origin);
        }
        else
        {
            player setPlayerAngles(orig_jumper.angles);
            player setOrigin(orig_jumper.origin);
        }
    }
}



partymode()
{
    self endon("stop_party");
    level notify ("newmusic");
    iPrintLnBold("^5VIP PARTY MODE UNLOCKED!");
    for(;;)
    {
        SetExpFog(1000, 1000, 1, 0, 0, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 0, 1, 0, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 0, 0, 1, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 1, 1, 0, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 1, 1, 1, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 1, 0, 1, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 0, 1, 1, 0);
        wait 0.5;
    }
}

randompartymode()
{
    self endon("stop_party");
    level notify ("newmusic");
    party_1 = getEnt("party_trigger1", "targetname");
    party_2 = getEnt("party_trigger2", "targetname");
    wait 1;
    party_1 delete();
    party_2 delete();
    for(;;)
    {
        SetExpFog(1000, 1000, 1, 0, 0, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 0, 1, 0, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 0, 0, 1, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 1, 1, 0, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 1, 1, 1, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 1, 0, 1, 0);
        wait 0.5;
        SetExpFog(1000, 1000, 0, 1, 1, 0);
        wait 0.5;
    }
}




randompartymodeprob()
{
    wait 5;
    random = randomint(9);
    if (random == 0)
    {
        thread randompartyjukeboxoff();
        thread musicbox();
    }
    if (random == 1)
    {
        thread randompartyjukeboxoff();
        thread musicbox();
    }
    if (random == 2)
    {
        thread randompartyjukeboxoff();
        thread musicbox();
    }
    if (random == 3)
    {
        thread randompartyjukeboxoff();
        thread musicbox();
    }
    if (random == 4)
    {
        thread randompartyjukeboxoff();
        thread musicbox();
    }
    if (random == 5)
    {
        thread randompartyjukeboxoff();
        thread musicbox();
    }
    if (random == 6)
    {
        thread randompartyjukeboxoff();
        thread musicbox();

    }
    if (random == 7)
    {
        thread randompartyjukeboxoff();
        thread musicbox();
    }
    if (random == 8)
    {
        iPrintLnBold("^5PARTY MODE RANDOMLY UNLOCKED!");
        thread randompartymode();
        thread partymodesong();
        thread jukeboxtriggeroff();
    }

}





partymodesong()
{
    self endon("stop_party");
    level notify ("newmusic");
    wait 0.5;
    for(;;)
    {
        AmbientPlay("song_party");
        wait 180;

    }
}

vippartymodesong()
{
    self endon("stop_party");
    level notify ("newmusic");
    wait 0.5;
    for(;;)
    {
        AmbientPlay("song_vipparty");
        wait 198;

    }
}



jumptimerentrance()
{
    trigger = getent ("secrethardtrigger", "targetname");
    target = getent ("secret_origin1", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}

secretTimer()
{
    self endon("death");
    time=120;
    self endon("end_secret_timer");
    self thread textleft();
    self thread time();
    while(1)
    {
        wait 1;
        time--;
        if(time<=0)
        self suicide();
    }
}

textleft() {
    self endon ("death");
    self endon ("disconnect");
    self.hud_text = newClientHudElem(self);
    self.hud_text.alignX = "center";
    self.hud_text.alignY = "bottom";
    self.hud_text.horzalign = "center";
    self.hud_text.vertalign = "bottom";
    self.hud_text.alpha = 1;
    self.hud_text.x = 0;
    self.hud_text.y = -7;
    self.hud_text.font = "objective";
    self.hud_text.fontscale = 1.5;
    self.hud_text.glowalpha = 1;
    self.hud_text.glowcolor = (0.0, 1.0, 1.0);
    self.hud_text.owner = self;
    self.hud_text setText("^5Time left:");
    self.hud_text thread removehudsondeath();
    wait 120;
    self removeText();
}

textleft_acti() {
    self endon ("death");
    self endon ("disconnect");
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
    self.hud_textacti.glowalpha = 1;
    self.hud_textacti.glowcolor = (0.0, 1.0, 1.0);
    self.hud_textacti.owner = self;
    self.hud_textacti setText("^5Press [USE] to leave the Activator Secret");
    self.hud_textacti thread removehudsondeath();
}

acti_secret_leave()
{
    trigger = getent ("acti_secret_leave", "targetname");
    target = getent ("hardsecendorigin_acti", "targetname");
    for(;;)
    {
        trigger waittill ("trigger", player);
        player SetOrigin(target.origin);
        player SetPlayerAngles( target.angles );
        player thread removeTextActivator();
        player iPrintLnBold ("^5You ^7left the ^5Activator Secret Way!");
    }
}


time() {
    self endon ("death");
    self endon ("disconnect");
    self.hud_count = newClientHudElem(self);
    self.hud_count endon ("death");
    self.hud_count.alignX = "center";
    self.hud_count.alignY = "bottom";
    self.hud_count.horzalign = "center";
    self.hud_count.vertalign = "bottom";
    self.hud_count.alpha = 1;
    self.hud_count.x = 60;
    self.hud_count.y = -7;
    self.hud_count.font = "objective";
    self.hud_count.fontscale = 1.5;
    self.hud_count.glowalpha = 1;
    self.hud_count.glowcolor = (1,1,1);
    self.hud_count.label = &"&&1";
    self.hud_count.owner = self;
    self.hud_count thread removehudsondeath();
    for(i = 0; i < 120; i++){
        self.hud_count setvalue( 120 - i );
        wait 1;
    }

    self removeCountdown();
}

removeText()
{
    if( isDefined( self.hud_text) )
    {
        self.hud_text destroy();
    }
}
removeTextActivator()
{
    if( isDefined( self.hud_textacti) )
    {
        self.hud_textacti destroy();
    }
}

removeCountdown() {
    if( isDefined( self.hud_count) )
    {
        self.hud_count destroy();
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

tpsecend() {
    trigger = getent ("hardsecendtp", "targetname");
    target = getent ("hardsecendorigin", "targetname");

    for(;;)
    {
        trigger waittill ("trigger", player);
        player SetOrigin(target.origin);
        player SetPlayerAngles( target.angles );
		player thread sr\api\_speedrun::finishWay("secret_0");

    }
}


gun_drop()
{
trigger = getent ("gun_drop", "targetname");
    while(1)
    {
    	trigger waittill("trigger", player);
    	if(!isDefined(player.used))
		{
			player.used = true;
        	x=randomint(9);
			if (x==0)
			{
				player iPrintlnBold("^5Woow! ^7you found a ^5Katana");
				wait 0.1;
				player giveWeapon("katana_mp");
				player switchToWeapon("katana_mp");
			}
			else
			{
				player iPrintlnBold("^5Here ^7is your free ^5Deagle");
				wait 0.1;
				player giveWeapon("deserteagle_mp");
				player switchToWeapon("deserteagle_mp");
			}
		}
		else
		{
			player iPrintlnBold("you already got your weapon!");
		}
	}
}
// VIP

checkvip()
{
	thread tec9_1();
	thread tec9_2();
	thread tec9_3();
	thread tec9_4();
	thread tec9_5();
}


tec9_3()
{
	trigger3 = getEnt ( "tec9_3", "targetname" );
	trigger3 waittill( "trigger", player );
	name = getDvar("name");
	if (name == "CM'Nobody" || name== "CM'Teairon")
	{
		player iprintlnBold ( "^5Access granted " );
		iprintln ("^7VIP  ^5" + player.name + " ^7got the ^5VIP Tec-9");
		wait 0.5;
		player takeAllWeapons();
		player iPrintLnBold("^7Tec9 Skin : ^5Default");
		player giveWeapon("v_pist_tec9_mp", 0);
		player switchToWeapon("v_pist_tec9_mp", 0);
	}
}

tec9_5()
{
	trigger5 = getEnt ( "tec9_5", "targetname" );
	trigger5 waittill( "trigger", player );
	name = getDvar("name");
	if (name == "CM'Nobody" || name== "CM'Teairon")
	{
		player iprintlnBold ( "^5Access granted " );
		iprintln ("^7VIP  ^5" + player.name + " ^7got the ^5VIP Tec-9");
		wait 0.5;
		player takeAllWeapons();
		player iPrintLnBold("^7Tec9 Skin : ^5Isaac");
		player giveWeapon("v_pist_tec9_mp", 7);
		player switchToWeapon("v_pist_tec9_mp", 7);
	}
}
tec9_1()
{
	trigger1 = getEnt ( "tec9_1", "targetname" );
	trigger1 waittill( "trigger", player );
	name = getDvar("name");
	if (name == "CM'Nobody" || name== "CM'Teairon")
	{
		player iprintlnBold ( "^5Access granted " );
		iprintln ("^7VIP  ^5" + player.name + " ^7got the ^5VIP Tec-9");
		wait 0.5;
		player takeAllWeapons();
		player iPrintLnBold("^7Tec9 Skin : ^55Avalanche");
		player giveWeapon("v_pist_tec9_mp", 8);
		player switchToWeapon("v_pist_tec9_mp", 8);
	}
}
tec9_2()
{
	trigger2 = getEnt ( "tec9_2", "targetname" );
	trigger2 waittill( "trigger", player );
	name = getDvar("name");
	if (name == "CM'Nobody" || name== "CM'Teairon")
	{
		player iprintlnBold ( "^5Access granted " );
		iprintln ("^7VIP  ^5" + player.name + " ^7got the ^5VIP Tec-9");
		wait 0.5;
		player takeAllWeapons();
		player iPrintLnBold("^7Tec9 Skin : ^5Fuel Injector");
		player giveWeapon("v_pist_tec9_mp", 9);
		player switchToWeapon("v_pist_tec9_mp", 9);
	}
}
tec9_4()
{
	trigger4 = getEnt ( "tec9_4", "targetname" );
	trigger4 waittill( "trigger", player );
	name = getDvar("name");
	if (name == "CM'Nobody" || name== "CM'Teairon")
	{
		player iprintlnBold ( "^5Access granted " );
		iprintln ("^7VIP  ^5" + player.name + " ^7got the ^5VIP Tec-9");
		wait 0.5;
		player takeAllWeapons();
		player iPrintLnBold("^7Tec9 Skin : ^5Remote Control");
		player giveWeapon("v_pist_tec9_mp", 10);
		player switchToWeapon("v_pist_tec9_mp", 10);
	}
}

vipweapon_check1()
{
vipweapon_check1 = getEnt("vipweapon_check1", "targetname");
for(;;)
{
	vipweapon_check1 waittill("trigger", player);
    if (player getStance() == "crouch" && player useButtonPressed())
    {
    	thread vipweapon_check2();
    	vipweapon_check1 delete();
    }
}
}

vipweapon_check2()
{
vipweapon_check2 = getEnt("vipweapon_check2", "targetname");
for(;;)
{
	vipweapon_check2 waittill("trigger", player);
    if (player getStance() == "crouch" && player useButtonPressed())
    {
    	thread checkvip();
    	vipweapon_check2 delete();
    }
}
}

destroyondeath()
{
		self endon( "disconnect" );
		self endon( "death" );
		self endon( "spawned" );
		self endon( "joined_spectators" );
        self destroytimehud();
}

destroytimehud()
{
        if( isDefined( self.secretTimer) )
        {
        self.secretTimer destroy();
    }
}




//SECRET TRIGGERS

secret1() {
    trigger = getent ("secret_trig1", "targetname");
    target = getent ("secret_origin1", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}
secret2() {
    trigger = getent ("secret_trig2", "targetname");
    target = getent ("secret_origin2", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}
secret3() {
    trigger = getent ("secret_trig3", "targetname");
    target = getent ("secret_origin3", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}
secret4() {
    trigger = getent ("secret_trig4", "targetname");
    target = getent ("secret_origin4", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}


runstart()
{
   trigger_run = getEnt ("runtp", "targetname");

    orig_jumper = getEnt ("runorijump", "targetname");
    orig_acti = getEnt ("runoriacti", "targetname");

    while (1)
    {
        trigger_run setHintString ("^7Press ^5[&&1]^7 to enter ^5Race Room");
        trigger_run waittill ("trigger", player);
        trigger_run setHintString ("^5" + player.name + "^7 in room!");

        player thread removeTextActivator();
        player setOrigin (orig_jumper.origin);
        player setPlayerAngles (orig_jumper.angles);
        player takeAllWeapons();
        player giveWeapon("knife_mp");
        player switchToWeapon ("knife_mp");
        player.maxhealth = 100;
		player thread endTimerRun("^5Let s Go !", 3, 0);

        if(isDefined(level.activ) && isAlive(level.activ))
        {
            level.activ thread removeTextActivator();
            level.activ setPlayerAngles(orig_acti.angles);
            level.activ setOrigin(orig_acti.origin);
            level.activ takeAllWeapons();
            level.activ giveWeapon("knife_mp");
            level.activ switchToWeapon("knife_mp");
            level.activ.maxhealth = 100;
			level.activ thread endTimerRun("^5Let s Go !", 3, 0);
        }
		thread fightHUD("Race Room", player, level.activ);
		thread runend(player, level.activ);

        while(isAlive(player) && isDefined(player))
            wait .05;

        iPrintLnBold ("^5" + player.name + " ^7has died in ^5Race Room!");
    }
}

runend(who, who2)
{
	trig = getEnt ("runendtp", "targetname");
	origWin = getEnt ("runendwin", "targetname");
	origLose = getEnt ("runendlose", "targetname");

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

race_acti_1() {
	trigger = getent ("run_acti_trig_a", "targetname");
	target = getent ("runoriacti", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_jumper_1() {
	trigger = getent ("run_jump_trig_a", "targetname");
	target = getent ("runorijump", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_acti_2() {
	trigger = getent ("run_acti_trig_door1", "targetname");
	target = getent ("run_acti_origin_b", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_jumper_2() {
	trigger = getent ("run_jump_trig_door1", "targetname");
	target = getent ("run_jump_origin_b", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_acti_3() {
	trigger = getent ("run_acti_trig_b", "targetname");
	target = getent ("run_acti_origin_c", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_jumper_3() {
	trigger = getent ("run_jump_trig_b", "targetname");
	target = getent ("run_jump_origin_c", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_acti_4() {
	trigger = getent ("run_acti_trig_c", "targetname");
	target = getent ("run_acti_origin_d", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_jumper_4() {
	trigger = getent ("run_jump_trig_c", "targetname");
	target = getent ("run_jump_origin_d", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_acti_5() {
	trigger = getent ("run_acti_trig_d", "targetname");
	target = getent ("run_acti_origin_e", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_jumper_5() {
	trigger = getent ("run_jump_trig_d", "targetname");
	target = getent ("run_jump_origin_e", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_acti_6() {
	trigger = getent ("run_acti_trig_door2", "targetname");
	target = getent ("run_acti_origin_f", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_jumper_6() {
	trigger = getent ("run_jump_trig_door2", "targetname");
	target = getent ("run_jump_origin_f", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_acti_7() {
	trigger = getent ("run_acti_trig_e", "targetname");
	target = getent ("run_acti_origin_f", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_jumper_7() {
	trigger = getent ("run_jump_trig_e", "targetname");
	target = getent ("run_jump_origin_f", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}


race_acti_8() {
	trigger = getent ("run_acti_trig_f", "targetname");
	target = getent ("run_acti_origin_g", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}

race_jumper_8() {
	trigger = getent ("run_jump_trig_f", "targetname");
	target = getent ("run_jump_origin_g", "targetname");

	while(1) {
		trigger waittill("trigger", player);
		player setorigin (target.origin);
		player setplayerangles (target.angles);
	}
}



signspectator()
{
    block1 = getent("sign", "targetname");
    block2 = getent("ring1", "targetname");
    block3 = getent("ring2", "targetname");

    for(;;)
    {
    wait 0.1;
    block1 rotateroll(-360, 5);
    block2 rotateroll(360, 5);
    block3 rotateYaw(-360, 5);
    }
}


    //MESSAGES

message()
{
wait 7;
iprintlnBold("^5 Old Factory");
iPrintlnBold("^5Map ^7made by ^5CM'Nobody");
for(;;)
{
wait 30;
x=randomint(8);
if (x==0)
{
iPrintln("^5Map ^7made by ^5CM'Nobody");
}

if (x==1)
{

}

if (x==2)
{
iPrintln("^7Feel free to join ^5CM Discord >>^7 discord.gg/CxVnas6 ^5<<");
}

if (x==3)
{
iPrintln("^5If you find any bugs please report them");
}

if (x==4)
{
iPrintln("^7Feel free to join ^5CM'Deathrun >>^7 91.121.145.85:27550 ^5<<");
}

if (x==5)
{
iPrintln("^7Discord: ^5Derazerr | Nobody#3996 ");
iPrintln("^7Steam: ^5xderazerr");
}

if (x==6)
{
iPrintln("^7Special thanks to : ^5Teairon ^7for testing the map, ^5Rexy ^7for helping to fix weapons models, ^5ERIK ^7for giving tips");
}

if (x==7)
{
iPrintln("^7There is ^5Jumper ^7and ^5Activator Secrets ^7. Find them");
}

}
}




//SECRET TRIGGERS

secret1_acti() {
    trigger = getent ("secret_trig1_acti", "targetname");
    target = getent ("secret_origin1_acti", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}
secret2_acti() {
    trigger = getent ("secret_trig2_acti", "targetname");
    target = getent ("secret_origin2_acti", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}
secret3_acti() {
    trigger = getent ("secret_trig3_acti", "targetname");
    target = getent ("secret_origin3_acti", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}
secret4_acti() {
    trigger = getent ("secret_trig4_acti", "targetname");
    target = getent ("secret_origin4_acti", "targetname");

    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}

hardsecretway_acti()
{
    secrethardtrigger = getEnt("secrethardtrigger_acti","targetname");
    secrethardorigin = getEnt("secret_origin1_acti","targetname");

    for(;;)
    {
        secrethardtrigger waittill("trigger", player);
        player thread textleft_acti();
        player setOrigin(secrethardorigin.origin);
        player setPlayerAngles(secrethardorigin.angles);
        iPrintLnBold ("^5Activator ^7entered the ^5Activator Secret Way!");
    }
}

hardsecretend_acti()
{
    hardsecendtp = getEnt("hardsecendtp_acti","targetname");
    hardsecendorigin = getEnt("hardsecendorigin_acti","targetname");

    for(;;)
    {
        hardsecendtp waittill("trigger", player);
        player setOrigin(hardsecendorigin.origin);
        player setPlayerAngles(hardsecendorigin.angles);
        player thread removeTextActivator();
        player iPrintLnBold ("^5Activator ^7finished the ^5Activator Secret Way!");

    }
}




randompartyjukebox()
{

    trig = getent("trig_partyon", "targetname");
    trig setHintString ("^5You cant change song during the random Party Mode");
    trig waittill("trigger", player);
    wait 1;
}

randompartyjukeboxoff()
{
    trig = getent("trig_partyon", "targetname");
    trig setHintString ("^5You cant change song during the random Party Mode");
    trig delete();

    wait 1;
}

jukeboxtriggeroff()
{
    trig = getent("musictrigger", "targetname");
    trig setHintString ("^5You cant change song during the random Party Mode");
    trig delete();

    wait 1;
}

partyunlock()
{
	party_1 = getEnt ( "party_trigger1", "targetname" );
	while(1)
	{
		name = getDvar("name");
		party_1 waittill( "trigger", player );
		if (name == "CM'Nobody" || name== "CM'Teairon")
		{
			wait 0.1;
			if (player getStance() == "crouch" && player useButtonPressed())
    		{
    		wait 0.1;
    		thread partyunlock2();
    		party_1 delete();
			}
		}
	}
}

partyunlock2()
{
	party_2 = getEnt ( "party_trigger2", "targetname" );
	while(1)
	{
		name = getDvar("name");
		party_2 waittill( "trigger", player );
		if (name == "CM'Nobody" || name== "CM'Teairon")
		{
			wait 0.1;
			if (player getStance() == "crouch" && player useButtonPressed())
    		{
    		wait 0.1;
    		party_2 delete();
    		thread partymode();
    		iprintln ("^7VIP ^5" + player.name + " ^7unlocked the ^5VIP Party Mode");
    		thread vippartymodesong();
			}
		}
	}
}

fuck_you()
{
	for(;;)
{
	level waittill("player_spawn", player);
	username = player.name;
	if( isSubStr( toLower(username), toLower("brahmi") ) || username == "brahmii" || username == "Sr Brahmi" || username == "pizzaman")
{
	player.fuu = true;
	player freezeControls(1);
	wait 5;
	player suicide();
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	player iPrintLnBold("^1GO KYS");
	player iPrintLnBold("^1BRAHMI RANK HACKING FAGGOT");
	player iPrintLnBold("^1GO KYS");
	player iPrintLnBold("^1RAPED BY CAMMY");
	wait 0.01;
}
    else
{
	player.fuu = false;
	wait 0.1;
}
}
}