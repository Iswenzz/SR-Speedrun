
#include common_scripts\utility;

main()
{
thread sr\api\_map::createSpawnOrigin((35, -213, 15), 90);

/*

   _____                 _    _          _ _   _
  / ____|               | |  | |        (_) \ | |  Map Made And Scripted by Sr kLeiN, I would like to thank NitroFire for always being helpful when I had problems.
 | (___  _ __   ______  | | _| |     ___ _|  \| |  I would also like to thank DarkSTEP for making the tutorial on how to add a music box to a map. This map took me around 3 days to make, it is my first deathrun map so I know it's not the best.
  \___ \| '__| |______| | |/ / |    / _ \ | . ` |
  ____) | |             |   <| |___|  __/ | |\  |
 |_____/|_|             |_|\_\______\___|_|_| \_|

                   __ooooooooo__
              oOOOOOOOOOOOOOOOOOOOOOo
          oOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo
       oOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo
     oOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo
   oOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo
  oOOOOOOOOOOO*  *OOOOOOOOOOOOOO*  *OOOOOOOOOOOOo
 oOOOOOOOOOOO      OOOOOOOOOOOO      OOOOOOOOOOOOo
 oOOOOOOOOOOOOo  oOOOOOOOOOOOOOOo  oOOOOOOOOOOOOOo
oOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo
oOOOO     OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO     OOOOo
oOOOOOO OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO OOOOOOo
 *OOOOO  OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO  OOOOO*
 *OOOOOO  *OOOOOOOOOOOOOOOOOOOOOOOOOOOOO*  OOOOOO*
  *OOOOOO  *OOOOOOOOOOOOOOOOOOOOOOOOOOO*  OOOOOO*
   *OOOOOOo  *OOOOOOOOOOOOOOOOOOOOOOO*  oOOOOOO*
     *OOOOOOOo  *OOOOOOOOOOOOOOOOO*  oOOOOOOO*
       *OOOOOOOOo  *OOOOOOOOOOO*  oOOOOOOOO*
          *OOOOOOOOo           oOOOOOOOO*
              *OOOOOOOOOOOOOOOOOOOOO*
                   ""ooooooooo""
*/

    maps\mp\_load::main();

    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createSecretWays("Secret Way");


    game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";


    setdvar("r_specularcolorscale","1");
	setdvar("compassmaxrange","1600");
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 20000000 );
	setDvar("bg_falldamageminheight", 15000000 );

    visionSetNaked("mp_dr_minimal");

    // preCacheItem("725_mp");
    // preCacheItem("customknife_mp");
    // preCacheItem("l96_mp");
    // preCacheItem("msr_mp");
    // preCacheModel("plr_mrheyley_venom");

    thread startdoor();
    //thread sniper();
    //thread bounce();
    //thread bounce_weap();
    //thread bounce_fail();
    //thread knife();
    //thread old();
    //thread shotgun();
    //thread secret_steps();
    thread secret_entrance();
    thread secret_finish();
    thread secret_fail();
    //thread trap1();
    //thread trap2();
    //thread trap3();
    //thread trap4();
    //thread trap5();
    //thread trap6();
    //thread trap7();
    //thread trap8();
    //thread trap9();
    //thread trap10();
    //thread trap11();
    //thread trap12();
    //thread trap13();
    //thread secret_song();
    //thread musicbox();
    //thread acti_tp1();
    //thread acti_tp2();
    //thread acti_tp3();
    //thread acti_tp4();
    //thread spin1();
    //thread spin2();
    //thread spin3();
    //thread spin4();
    //thread spin5();
    //thread spin6();
    //thread spin7();
    //thread spin8();
    //thread spin9();
    //thread spin10();
    //thread spin11();
    //thread spin12();
    //thread spin13();
    //thread spin14();
    //thread spin15();
    //thread spin16();
    //thread spin17();
    //thread spin18();
    thread slide_door();
    thread tunnel_door();
    //thread vip();
    //thread klein();
    //thread bigspin1();
    //thread bigspin2();
    //thread bigspin3();
    //thread bigspin4();
    //thread bigspin5();
    //thread bigspin6();
    //thread bigspin7();
    //thread bigspin8();
    //thread bigspin9();
    //thread bigspin10();
    //thread bigspin11();
    //thread bigspin12();
    //thread bigspin13();
    //thread bigspin14();
    //thread bigspin15();
    //thread bigspin16();
    //thread bigspin17();
    //thread bigspin18();
    //thread bigspin19();
    //thread bigspin20();




	level.music=[];
    level.music[0]["song"]    ="Sub Focus - Solar System";
    level.music[0]["alias"]    ="song1";
    level.music[1]["song"]    ="Sublab & Azaleh - Follow You";
    level.music[1]["alias"]    ="song2";
    level.music[2]["song"]    ="Red - Buried Beneath";
    level.music[2]["alias"]    ="song3";
    level.music[3]["song"]    ="Kendrick Lamar - Swimming Pools";
    level.music[3]["alias"]    ="song4";
    level.music[4]["song"]    ="Muzzy - Calling Out";
    level.music[4]["alias"]    ="song5";
    level.music[5]["song"]    ="Lexarus - Cystalize";
    level.music[5]["alias"]    ="song6";

}



musicbox()
{
    trig = getEnt("musictrigger","targetname");
    trig setHintString("Press ^4&&1^7 to select song");
    trig waittill("trigger",player);
    player braxi\_rank::giveRankXP("", 50);
    trig delete();
    player freezeControls(1);
    player musicmenu();
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

    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 300, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "black", 300, 20 );
    self.hud_music[i].color=(0,0,0);

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 2 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("      ^4Minimal Music Menu");
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else
        self.hud_music[i].glowcolor=(0,0,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("                                        Scroll: [{+attack}] | Select: [{+activate}] | Close: [{+frag}]");
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
            self.hud_music[i].glowcolor=(0,0,0);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "black", 306, 17 );
    indicator.color=(0,0,0);

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
             thread createhud2("^4>>Now playing: ^7"+level.music[self.selection]["song"]+"^4<<");

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






secret_song()
{
    trig = getEnt("secret_song", "targetname");
    trig waittill("trigger", player);
    ambientPlay("secret");
    thread createhud2("^4>>Now playing: ^7Nas - N.Y. State of Mind^4<<");
    trig delete();

}


startdoor()
{
door = getEnt("start_door", "targetname");

door delete();

}

spin1()
{
    spin = getEntArray("spin1", "targetname");

    for(;;)
    {
        spin[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin2()
{
    spin2 = getEntArray("spin2", "targetname");

    for(;;)
    {
        spin2[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin3()
{
    spin3 = getEntArray("spin3", "targetname");

    for(;;)
    {
        spin3[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin4()
{
    spin4 = getEntArray("spin4", "targetname");

    for(;;)
    {
        spin4[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin5()
{
    spin5 = getEntArray("spin5" ,"targetname");

    for(;;)
    {
        spin5[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin6()
{
    spin6 = getEntArray("spin6" ,"targetname");

    for(;;)
    {
        spin6[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin7()
{
    spin7 = getEntArray("spin7", "targetname");

    for(;;)
    {
        spin7[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin8()
{
    spin8 = getEntArray("spin8", "targetname");

    for(;;)
    {
        spin8[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin9()
{
    spin9 = getEntArray("spin9", "targetname");

    for(;;)
    {
        spin9[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin10()
{
    spin10 = getEntArray("spin10", "targetname");

    for(;;)
    {
        spin10[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin11()
{
    spin11 = getEntArray("spin11", "targetname");

    for(;;)
    {
        spin11[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin12()
{
    spin12 = getEntArray("spin12", "targetname");

    for(;;)
    {
        spin12[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin13()
{
    spin13 = getEntArray("spin13", "targetname");

    for(;;)
    {
        spin13[0] rotateYaw(720, 4);
        wait 0.1;
    }
}


spin14()
{
    spin15 = getEntArray("spin15", "targetname");

    for(;;)
    {
        spin15[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin15()
{
    spin16 = getEntArray("spin16", "targetname");

    for(;;)
    {
        spin16 [0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin16()
{
    spin17 = getEntArray("spin17", "targetname");

    for(;;)
    {
        spin17[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin17()
{
    spin18 = getEntArray("spin18", "targetname");

    for(;;)
    {
        spin18[0] rotateYaw(720, 4);
        wait 0.1;
    }
}

spin18()
{
    spin19 = getEntArray("spin19", "targetname");

    for(;;)
    {
        spin19[0] rotateYaw(720,4);
        wait 0.1;
    }
}


shotgun()
{
    level.shotgun_trigger = getEnt("shotgun_trig", "targetname");
    level.old_trigger = getEnt("old_trig", "targetname");
    level.knife_trigger = getEnt("knife_trig", "targetname");
    level.bounce_trigger = getEnt("bounce_trig", "targetname");
    level.sniper_trigger = getEnt("sniper_trig", "targetname");
    level.teleactorigin = getEnt("shotgun_activator", "targetname");
    telejumporigin = getEnt("shotgun_jumper", "targetname");
    level.shotgun_trigger setHintString("Press ^4&&1 ^7to enter the shotgun room!");

    while( 1 )
    {
        level.shotgun_trigger waittill("trigger",player);

        if( !isdefined( level.shotgun_trigger) )
        return;
        if(level.firstenter==true)
        {
            level.firstenter=false;
        }
        wait(0.05);

        player setOrigin( telejumporigin.origin );
        player setplayerAngles( telejumporigin.angles );
        player TakeAllWeapons();
        player GiveWeapon("725_mp");
        player GiveMaxAmmo("725_mp");
        wait .05;
        player switchToWeapon("725_mp");
        wait(0.05);
        level.activ SetOrigin (level.teleactorigin.origin);
        level.activ setplayerangles (level.teleactorigin.angles);
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "725_mp" );
        level.activ GiveMaxAmmo( "725_mp" );
        wait .05;
        level.activ SwitchToWeapon("725_mp");
        thread createhud( " ^7" + player.name + " ^4 has entered the Shotgun room!" );
        wait(0.05);
        player switchToWeapon( "725_mp" );
        level.activ SwitchToWeapon( "725_mp" );


        player waittill( "death" );
        level.PlayerInRoom = false;
        iPrintLnBold("^7"+ player.name + "^4 has died!");


    }
}


sniper()
{
level.sniper_trigger = getEnt("sniper_trig","targetname");
level.old_trigger = getEnt("old_trig","targetname");
level.knife_trigger = getEnt("knife_trig", "targetname");
level.bounce_trigger = getEnt("bounce_trig", "targetname");
level.shotgun_trigger = getEnt("shotgun_trig", "targetname");
level.teleactorigin = getEnt("sniper_activator", "targetname");
telejumporigin = getEnt("sniper_jumper", "targetname");
level.sniper_trigger setHintString("Press ^4&&1 ^7to enter the sniper room!");

while(1)
{
level.sniper_trigger waittill( "trigger", player );

if( !isDefined( level.sniper_trigger ) )
return;
if(level.firstenter==true)
{
level.firstenter=false;
}
wait(0.05);

player SetOrigin( telejumporigin.origin );
player setplayerangles( telejumporigin.angles );
player TakeAllWeapons();
player GiveWeapon("msr_mp");
player GiveMaxAmmo("msr_mp");
wait .05;
player SwitchToWeapon("msr_mp");
wait(0.05);
level.activ SetOrigin (level.teleactorigin.origin);
level.activ setplayerangles (level.teleactorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "msr_mp" );
level.activ GiveMaxAmmo("msr_mp");
wait .05;
level.activ SwitchToWeapon("msr_mp");
thread createhud( " ^7" + player.name + " ^4 has entered the Sniper room^8!" );
wait(0.05);
player switchToWeapon( "msr_mpor_mp" );
level.activ SwitchToWeapon( "msr_mp" );


player waittill( "death" );
level.PlayerInRoom = false;
iPrintLnBold("^7"+ player.name + "^4 has died!");


}
}

old()
{
    level.old_trigger = getEnt("old_trig", "targetname");
    level.bounce_trigger = getEnt("bounce_trig", "targetname");
    level.sniper_trigger = getEnt("sniper_trig", "targetname");
    level.knife_trigger = getEnt("knife_trig", "targetname");
    level.shotgun_trigger = getEnt("shotgun_trig", "targetname");
    door = getEnt("old_door", "targetname");
    level.old_trigger setHintString("Press ^4&&1 ^7to enter the old way");

    while(1)
    {
        level.old_trigger waittill("trigger",player);
        iPrintLnBold("^4"+ player.name +"^7 has opened the old way!");
        level.activ iPrintLnBold("^4RUN!!!");

        level.old_trigger delete();
        level.bounce_trigger delete();
        level.sniper_trigger delete();
        level.knife_trigger delete();
        level.shotgun_trigger delete();

        door moveZ(160, 2);
        wait 2;
        door delete();

    }
}


bounce()
{
    level.bounce_trigger = getEnt("bounce_trig", "targetname");
    level.sniper_trigger = getEnt("sniper_trig", "targetname");
    level.old_trigger = getEnt("old_trig", "targetname");
    level.knife_trigger = getEnt("knife_trig", "targetname");
    level.shotgun_trigger = getEnt("shotgun_trig", "targetname");
    telejumporigin = getEnt("bounce_jumper", "targetname");
    level.acti_origin = getEnt("bounce_activator", "targetname");
    level.bounce_trigger setHintstring("Press ^4&&1 ^7to enter the bounce room!");

while(1)
{
level.bounce_trigger waittill( "trigger", player );

if( !isDefined( level.bounce_trigger ) )
return;
if(level.firstenter==true)
{
level.firstenter=false;
}
wait(0.05);

player SetOrigin( telejumporigin.origin );
player setplayerangles( telejumporigin.angles );
player takeAllweapons( 1 );
player giveWeapon("customknife_mp");
player switchToWeapon("customknife_mp");
wait(0.05);
level.activ SetOrigin (level.acti_origin.origin);
level.activ setplayerangles (level.acti_origin.angles);
level.activ takeAllweapons( 1 );
level.activ giveWeapon("customknife_mp");
level.activ switchToweapon("customknife_mp");
wait .05;
thread createhud( " ^7" + player.name + " ^4 has entered the Bounce Room!" );
wait(0.05);

player waittill( "death" );
level.PlayerInRoom = false;
iPrintLnBold("^7"+ player.name + "^4 has died!");



}
}

bounce_weap()
{
    trig = getEnt("bounce_weapon", "targetname");
    trig setHintString("Press ^4&&1 ^7to get a sniper!");

    for(;;)
    {
        trig waittill("trigger",player);
        player giveWeapon("msr_mp");
        player giveMaxAmmo("msr_mp");
        player switchToWeapon("msr_mp");
        player takeWeapon("knife_mp");
    }
}

knife()
{
    level.bounce_trigger = getEnt("bounce_trig", "targetname");
    level.sniper_trigger = getEnt("sniper_trig", "targetname");
    level.knife_trigger = getEnt("knife_trig", "targetname");
    level.shotgun_trigger  =getEnt("shotgun_trig", "targetname");
    telejumporigin = getEnt("knife_jumper", "targetname");
    level.acti_origin = getEnt("knife_activator", "targetname");
    level.old_trigger = getEnt("old_trig", "targetname");
    level.knife_trigger setHintstring("Press ^4&&1 ^7to enter the knife room!");


while(1)
{
level.knife_trigger waittill( "trigger", player );

if( !isDefined( level.knife_trigger ) )
return;
if(level.firstenter==true)
{
level.firstenter=false;
}
wait(0.05);

player SetOrigin( telejumporigin.origin );
player setplayerangles( telejumporigin.angles );
player takeAllWeapons( 1 );
player giveWeapon("customknife_mp");
player switchToWeapon("customknife_mp");
wait(0.05);
level.activ SetOrigin (level.acti_origin.origin);
level.activ setplayerangles (level.acti_origin.angles);
level.activ takeAllWeapons( 1 );
level.activ giveWeapon("customknife_mp");
level.activ switchToWeapon("customknife_mp");
wait .05;
thread createhud( " ^8" + player.name + " ^4 has entered the knife Room!" );
wait(0.05);

player waittill( "death" );
level.PlayerInRoom = false;
iPrintLnBold("^7"+ player.name + " ^4has died!");


}
}

bounce_fail()
{
    trig = getEnt("bounce_fail", "targetname");
    respawn_jumper = getEnt("bounce_jumper", "targetname");
    respawn_activator = getEnt("bounce_activator", "targetname");

    while( 1 )
    {
         trig waittill( "trigger", player );

        if( player.pers["team"] == "allies" )
        {
            player SetPlayerAngles( respawn_jumper.angles );
            player SetOrigin( respawn_jumper.origin );
            player freezeControls( 1 );
            player freezeControls( 0 );
        }
        else if( player.pers["team"] == "axis" )
        {
            level.activ setPlayerAngles ( respawn_activator.angles );
            level.activ setOrigin( respawn_activator.origin );
            level.activ freezeControls( 1 );
            level.activ freezeControls( 0 );
        }
    }
}

secret_entrance()
{
    trig = getEnt("secret_entrance", "targetname");
    spawn = getEnt("secret_tp", "targetname");
    trig setHintString("Press ^4&&1 ^7to enter the secret");

    for(;;)
    {
        trig waittill("trigger",player);
        player setPlayerAngles(spawn.angles);
        player setOrigin(spawn.origin);
        player.secret = 0;
        player thread sr\api\_speedrun::changeWay("secret_0");
    }
}


secret_finish()
{
    trig = getEnt("secret_finish", "targetname");
    spawn = getEnt("secret_finish_tp", "targetname");
    trig setHintString("Press &&1 to finish the secret!");

    while( 1 )
    {
        trig waittill("trigger",player);
        iPrintLnBold("^4" + player.name + "^7 has finished the secret!");
        player setPlayerAngles(spawn.angles);
        player setOrigin(spawn.origin);
        player thread sr\api\_speedrun::finishWay("secret_0");
        //player braxi\_rank::giveRankXP( "", 500 );
    }


}

trap1()
{
    trig = getEnt("trap1_trig", "targetname");
    plat1= getEntArray("trap1_plat1", "targetname");
    plat2 = getEntArray("trap1_plat2", "targetname");
    plat3 = getEntArray("trap1_plat3", "targetname");
    trig setHintString("Press ^4&&1 ^7 to activate this trap!");
    trig waittill("trigger", player);
    trig delete();

    p = randomIntRange(1, 3);

    if(p == 1)
    {
        plat1[0] notSolid();
        plat2[0] notSolid();
    }
    else if(p == 2)
    {
        plat2[0] notSolid();
        plat3[0] notSolid();
    }
    else if(p == 3)
    {
        plat1[0] notSolid();
        plat3[0] notSolid();
    }

}

trap2()
{
    trig = getEnt("trap2_trig", "targetname");
    pusher = getEntArray("trap2_pusher","targetname");
    trig setHintString("Press ^4&&1 ^7 to activate this trap!");

    for(;;)
    {
        trig waittill("trigger", player);
        trig delete();
        pusher[0] moveZ(-256, 2);
        wait 2;
        pusher[0] moveZ(256, 2);
        wait 2;
        pusher[0] delete();
        //player braxi\_rank::giveRankXP( "", 100 );


    }
}

trap3()
{
    spin1 = getEnt("trap3_1", "targetname");
    spin2 = getEnt("trap3_2", "targetname");
    spin3 = getEnt("trap3_3", "targetname");
    trig = getEnt("trap3_trig", "targetname");
    trig setHintString("Press ^4&&1 ^7 to activate the trap!");

    trig waittill ("trigger", player);

    for(;;)
    {
        trig delete();
        spin1 rotateRoll(-360, 2);
        wait 2;
        spin2 rotateRoll(-360, 2);
        wait 2;
        spin3 rotateRoll(-360, 2);
        wait 2;
        //player braxi\_rank::giveRankXP( "", 100 );
    }
}

trap4()
{
    bounce = getEnt("trap4_bounce", "targetname");
    trig = getEnt("trap4_trig", "targetname");
    trig sethintString("Press ^4&&1 ^7 to activate this trap!");

    for(;;)
    {
        trig waittill("trigger", player);
        bounce delete();
        trig delete();
        //player braxi\_rank::giveRankXP( "", 100 );
    }

}

trap5()
{
    plat1 = getEnt("trap5_1", "targetname");
    plat2 = getEnt("trap5_2", "targetname");
    plat3 = getEnt("trap5_3", "targetname");
    plat4 = getEnt("trap5_4", "targetname");
    trig = getEnt("trap5_trig", "targetname");
    trig setHintString("Press ^4&&1 ^7 to activate the trap!");

    trig waittill("trigger", player);

    for(;;)
    {
        trig delete();

        plat1 rotateYaw(720, 1);
        wait 2;
        plat2 rotateYaw(720, 1);
        wait 2;
        plat3 rotateYaw(720, 1);
        wait 2;
        plat4 rotateYaw(720, 1);
        wait 2;
        //player braxi\_rank::giveRankXP( "", 100 );
    }

}

trap6()
{
    pusher = getEnt("trap6_pusher", "targetname");
    pusher2 = getEnt("trap6_pusher2", "targetname");
    trig = getEnt("trap6_trig", "targetname");
    trig setHintString("Press ^4&&1 ^7to activate the trap!");

    pusher LinkTo(pusher2);

    {
        trig waittill("trigger", player);
        trig delete();
        pusher2 moveY(-560, 2);
        wait 2;
        pusher2 moveY(546, 2);
        //player braxi\_rank::giveRankXP( "", 100 );
    }
}

trap7()
{
    trig = getEnt("trap7_trig", "targetname");
    spikes = getEntArray("trap7_spikes", "targetname");
    spikedmg = getEnt("trap7_dmg", "targetname");

    spikedmg enableLinkTo();
    spikedmg LinkTo( spikes[0] );

    trig sethintString("Press ^4&&1 ^7to activate the trap!");
    trig waittill("trigger", player);
    trig delete();
    spikes[0] moveZ(-576, 2);
    wait 4;
    spikes[0] moveZ(576, 2);
    //player braxi\_rank::giveRankXP( "", 100 );
}



trap8()
{
    trig = getEnt("trap8_trig", "targetname");
    roller1 = getEnt("trap8_roller1", "targetname");
    roller2 = getEnt("trap8_roller2", "targetname");
    roller3 = getEnt("trap8_roller3", "targetname");
    trig setHintString("Press ^4&&1 ^7to activate the trap!");

    trig waittill("trigger", player);

    for(;;)
    {
    trig delete();
    roller1 rotateRoll(720, 2);
    roller2 rotateRoll(720, 2);
    roller3 rotateRoll(720, 2);
    wait 4;
    roller1 rotateRoll(720, 2);
    roller2 rotateRoll(720, 2);
    roller3 rotateRoll(720, 2);
    wait 4;
    }
}

trap9()
{
    trig = getEnt("trap9_trig", "targetname");
    bounce = getEnt("trap9_bounce", "targetname");
    trig setHintString("Press ^4&&1 ^7to activate  the trap!");

    trig waittill("trigger", player);

    for(;;)
    {
        bounce rotateYaw(360, 1.5);
        wait 3.5;
        bounce rotateYaw(360, 1.5);
    }
}

trap10()
{
    trig = getEnt("trap10_trig" , "targetname");
    crusher1 = getEntArray("trap10_crusher1", "targetname");
    crusher2 = getEntArray("trap10_crusher2", "targetname");
    hurt1 = getEnt("trap10_damage1", "targetname");
    hurt2 = getEnt("trap10_damage2", "targetname");
    trig setHintString("Press ^4&&1 ^7to activate the trap!");

    hurt1 enableLinkTo();
    hurt1 LinkTo( crusher1[0] );

    hurt2 enableLinkTo();
    hurt2 LinkTO( crusher2[0] );

    trig waittill("trigger", player);

    for(;;)
    {
        trig delete();
        crusher1[0] moveZ(-448, 0.5);
        crusher2[0] moveZ(-448, 0.5);
        wait 2;
        crusher1[0] moveZ(448, 0.5);
        crusher2[0] moveZ(448, 0.5);
        wait 2;
    }

}

trap11()
{
    trig = getEnt("trap11_trig", "targetname");
    plat1 = getEnt("trap11_plat1", "targetname");
    plat2 = getEnt("trap11_plat2", "targetname");
    plat3 = getEnt("trap11_plat3", "targetname");
    trig setHintString("Press ^4&&1 ^7to activate the trap!");
    trig waittill("trigger", player);
    trig delete();

    p = randomIntRange(1, 3);
    if(p == 1)
    {
        plat1 notSolid();
        plat3 notSolid();
    }
    else if(p == 2)
    {
        plat2 notSolid();
        plat3 notSolid();
    }
    else if(p == 3)
    {
        plat2 notSolid();
        plat1 notSolid();

    }
}

trap12()
{
    trig = getEnt("trap12_trig", "targetname");
    platform = getEnt("trap12_platform", "targetname");
    trig setHintString("Press ^4&&1 ^7to activate the trap!");

    trig waittill("trigger", player);
    platform delete();
    trig delete();
}

trap13()
{
    trig = getEnt("trap13_trig", "targetname");
    platform = getEnt("trap13_spinner", "targetname");
    trig setHintString("Press ^4&&1 ^7to activate the trap!");

    trig waittill("trigger", player);
    for(;;)
    {
        trig delete();
        platform rotateYaw(720, 2);
        wait 6;
        platform rotateYaw(720, 2);
        wait 6;
    }
}

acti_tp1()
{
    trig = getEnt("acti_tp1", "targetname");
    tp = getEnt("acti_spawn1", "targetname");
    trig setHintString("Press ^4&&1 ^7to teleport to the next area!");


    for(;;)
    {
        trig waittill("trigger",player);
        player setPlayerAngles(tp.angles);
        player setOrigin(tp.origin);
    }
}

acti_tp2()
{
    trig = getEnt("acti_tp2", "targetname");
    tp = getEnt("acti_spawn2", "targetname");
    trig setHintString("Press ^4&&1 ^7to go back!");

    for(;;)
    {
        trig waittill("trigger",player);
        player setPlayerAngles(tp.angles);
        player setOrigin(tp.origin);
    }
}

acti_tp3()
{
    trig = getEnt("acti_tp3", "targetname");
    tp = getEnt("acti_spawn3", "targetname");
    trig setHintString("Press ^4&&1 ^7to teleport to the final area!");

    for(;;)
    {
        trig waittill("trigger", player);
        player setPlayerAngles(tp.angles);
        player setOrigin(tp.origin);
    }
}

acti_tp4()
{
    trig = getEnt("acti_tp4", "targetname");
    tp = getEnt("acti_spawn4", "targetname");
    trig setHintString("Press ^4&&1 ^7to teleport back!");

    for(;;)
    {
        trig waittill("trigger", player);
        player setPlayerAngles(tp.angles);
        player setOrigin(tp.origin);
    }
}

secret_fail()
{
    trig = getEntArray("secret_fail", "targetname");

    thread checkpoint1();
    thread checkpoint2();
    thread checkpoint3();
    thread checkpoint4();
    thread checkpoint5();
    thread checkpoint6();

    for(i = 0; i < trig.size; i++) {
	trig[i] thread checkpoints();
    }

}

checkpoints()
{
    check0 = getEnt("secret_tp", "targetname");
    check1 = getEnt("secret_check1", "targetname");
    check2 = getEnt("secret_check2", "targetname");
    check3 = getEnt("secret_check3", "targetname");
    check4 = getEnt("secret_check4", "targetname");
    check5 = getEnt("secret_check5", "targetname");
    check6 = getEnt("secret_check6", "targetname");

    for(;;)
    {
        self waittill("trigger", player);

        if(player.secret == 0)
        {
			player setPlayerAngles( check0.angles );
			player setOrigin( check0.origin );
            player freezeControls( 1 );
            wait 0.1;
			player freezeControls( 0 );
        }
        else if(player.secret == 1)
        {
            player setPLayerAngles( check1.angles );
            player setOrigin( check1.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
        }
        else if(player.secret == 2)
        {
            player setPlayerAngles( check2.angles );
            player setOrigin( check2.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
        }
        else if(player.secret == 3)
        {
            player setPlayerAngles( check3.angles );
            player setOrigin( check3.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
        }
        else if(player.secret == 4)
        {
            player setPlayerAngles( check4.angles );
            player setOrigin( check4.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
        }
        else if(player.secret == 5)
        {
            player setPlayerAngleS( check5.angles );
            player setOrigin( check5.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
        }
        else if(player.secret == 6)
        {
            player setPlayerAngles( check6.angles );
            player setOrigin( check6.origin );
            player freezeControls( 1 );
            wait 0.1;
            player freezeControls( 0 );
        }
    }
}

checkpoint1()
{
    trig = getEnt("secret_checkpoint1", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret == 0)
        {
            player.secret = 1;
            player iPrintLn("checkpoint ^41/6");
            wait 0.05;
        }
    }
}

checkpoint2()
{
    trig = getEnt("secret_checkpoint2", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret == 1)
        {
            player.secret = 2;
            player iPrintLn("checkpoint ^42/6");
            wait 0.05;
        }
    }
}

checkpoint3()
{
    trig = getEnt("secret_checkpoint3", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret == 2)
        {
            player.secret = 3;
            player iPrintLn("checkpoint ^43/6");
            wait 0.05;

        }
    }
}

checkpoint4()
{
    trig = getEnt("secret_checkpoint4", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret == 3)
        {
            player.secret = 4;
            player iPrintLn("checkpoint ^44/6");
            wait 0.05;
        }
    }
}

checkpoint5()
{
    trig = getEnt("secret_checkpoint5", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret == 4)
        {
            player.secret = 5;
            player iPrintLn("checkpoint ^45/6");
            wait 0.05;
        }
    }
}

checkpoint6()
{
    trig = getEnt("secret_checkpoint6", "targetname");
    while(true)
    {
        trig waittill("trigger", player);
        if(player.secret == 5)
        {
            player.secret = 6;
            player iPrintLn("checkpoint ^46/6");
            wait 0.05;
        }
    }
}

secret_steps()
{
    trig1 = getEnt("secret_trig1", "targetname");
    trig2 = getEnt("secret_trig2", "targetname");
    trig3 = getEnt("secret_trig3", "targetname");
    trig4 = getEnt("secret_trig4", "targetname");
    wall = getEnt("secret_wall", "targetname");

    trig1 waittill("trigger", player);
    trig1 delete();
    iPrintLn("step complete.");

    trig2 waittill("trigger", player);
    trig2 delete();
    iPrintLn("step complete.");

    trig3 waittill("trigger", player);
    trig3 delete();
    iPrintLn("step complete.");

    trig4 waittill("trigger", player);
    trig4 delete();
    iPrintLnBold("Something Happened....");
    wall notSolid();

}

slide_door()
{
    slide = getEnt("slide_door", "targetname");
    trig = getEnt("slide_trig", "targetname");

    slide delete();
}

tunnel_door()
{
    tunnel = getEnt("tunnel_door", "targetname");
    trig = getEnt("tunnel_trig", "targetname");

    tunnel delete();
}

createhud(messages)
{
hud_start = NewHudElem();
hud_start.alignX = "center";
hud_start.alignY = "middle";
hud_start.horzalign = "center";
hud_start.vertalign = "middle";
hud_start.alpha = 5;
hud_start.x = 0;
hud_start.y = -150;
hud_start.font = "objective";
hud_start.fontscale = 2;
hud_start.glowalpha = 1;
hud_start.glowcolor = (0,0,.5);
hud_start setText(messages);
hud_start setPulseFX( 50, 4000, 500 );
wait 4;
if(isdefined(hud_start))
	hud_start destroy();
}

vip()
{
    trig = getEnt("vip_trig", "targetname");
    trig setHintString("^4VIP ^4check");

    for(;;)
    {
        trig waittill("trigger", player);

    gametag = player.name;
    if ( (isSubStr( toLower(gametag), toLower("Sr-"))  && !isSubStr( toLower(gametag), toLower("Mist"))  && !isSubStr( toLower(gametag), toLower("Liserd"))  && !isSubStr( toLower(gametag), toLower("DarkSTEP"))  && !isSubStr( toLower(gametag), toLower("stu"))  && !isSubStr( toLower(gametag), toLower("CM' Exe"))  && !isSubStr( toLower(gametag), toLower("FAMOUS NitroFire"))))
    {
        player iPrintLnBold("nice one, you are VIP!");
        player GiveWeapon("l96_mp");
        player GiveMaxAmmo("l96_mp");
        player switchToWeapon("l96_mp");
    }
    else
    {
        player iPrintLnBold("oof you are not vip :(");
    }
    }
}

klein()
{
    trig = getEnt("klein_trig", "targetname");
    legacyklein = "1688ada0e106b02d6857ef6a66d9289c";
    cod4xklein = "66d9289c";
    trig setHintString("^4kLeiN ^7check");

    for(;;)
    {
        trig waittill ("trigger", player);
		tempGuid = player getGUID();
        if((tempGuid == cod4xklein) || (tempGuid == legacyklein))
      {
       player giveWeapon("l96_mp");
       player giveMaxAmmo("l96_mp");
       player switchToWeapon("l96_mp");
       player setModel("plr_mrheyley_venom");
       thread createhud("^4kLeiN ^7 is here!");
      }
       else
      {
       player iPrintLnBold("you are not kLeiN lol");
      }
    }
}

bigspin1()
{
    spin = getEnt("bigspin1", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin2()
{
    spin = getEnt("bigspin2", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin3()
{
    spin = getEnt("bigspin3", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin4()
{
    spin = getEnt("bigspin4", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin5()
{
    spin = getEnt("bigspin5", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin6()
{
    spin = getEnt("bigspin6", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin7()
{
    spin = getEnt("bigspin7", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin8()
{
    spin = getEnt("bigspin8", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin9()
{
    spin = getEnt("bigspin9", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin10()
{
    spin = getEnt("bigspin10", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin11()
{
    spin = getEnt("bigspin11", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin12()
{
    spin = getEnt("bigspin12", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin13()
{
    spin = getEnt("bigspin13", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin14()
{
    spin = getEnt("bigspin14", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin15()
{
    spin = getEnt("bigspin15", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin16()
{
    spin = getEnt("bigspin16", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin17()
{
    spin = getEnt("bigspin17", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin18()
{
    spin = getEnt("bigspin18", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

bigspin19()
{
    spin = getEnt("bigspin19", "targetname");

    for(;;)
    {
        spin rotateYaw(-720, 4);
        wait 0.1;
    }
}

bigspin20()
{
    spin = getEnt("bigspin20", "targetname");

    for(;;)
    {
        spin rotateYaw(720, 4);
        wait 0.1;
    }
}

createhud2(iPrintLn)
{
hud_start = NewHudElem();
hud_start.alignX = "bottom";
hud_start.alignY = "bottom";
hud_start.horzalign = "left";
hud_start.vertalign = "bottom";
hud_start.alpha = 1;
hud_start.x = 0;
hud_start.y = -20;
hud_start.font = "objective";
hud_start.fontscale = 1.4;
hud_start.glowalpha = 1;
hud_start.glowcolor = (0,0,.5);
hud_start setText(iPrintLn);
hud_start setPulseFX( 50, 2500, 1000 );
wait 5;
if(isdefined(hud_start))
	hud_start destroy();
}
