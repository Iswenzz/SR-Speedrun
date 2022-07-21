//░░░░░░░░░▄░░░░░░░░░░░░░░▄
//░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌    //Wow
//░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐
//░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
//░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐                                     //Dont steal ideas
//░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌
//░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌
//░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐       //Programing hard
//░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌
//░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌
//▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐
//▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌                                                      //Much confusion
//▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐
//░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌
//░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐     //such map
//░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌
//░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀
//░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀
//░░░░░░░░░▒▒▒▒▒▒▒▒▒▒// Wow
//Map by Sheep Wizard
//youtube: http://www.youtube.com/user/paap15
//xfire: paap15
main()
{
thread sr\api\_map::createSpawnOrigin((120, 108, 16), 270);
	thread sr\api\_speedrun::createNormalWays("^4Easy Way;^2Hard Way");
	thread sr\api\_speedrun::createTeleporter((-53, -208, 76), 100, 150, (-969, -598, 16), 270, "freeze", "blue", "normal_0");
	thread sr\api\_speedrun::createTeleporter((283, -208, 76), 100, 150, (1211, -595, 16), 270, "freeze", "green", "normal_1");
		thread sr\api\_speedrun::createEndMap((137, -8308, 76), 100, 150);
	thread sr\api\_speedrun::createEndMap((-957, -8273, 76), 100, 150, "normal_0");
	thread sr\api\_speedrun::createEndMap((1283, -8353, -68), 100, 150, "normal_1");

     maps\mp\_load::main();
	 level.flash = loadFX("deathrun/flash");
	 level.burst = loadFX("deathrun/burst");
	 level.spark = loadFX("deathrun/spark");
	 level.spark2 = loadFX("deathrun/spark2");
	 level.fire1 = loadFX("deathrun/fire1");

     game["allies"] = "sas";
     game["axis"] = "opfor";
     game["attackers"] = "axis";
     game["defenders"] = "allies";
     game["allies_soldiertype"] = "woodland";
     game["axis_soldiertype"] = "woodland";

	 //dvars
	 setdvar( "bg_falldamagemaxheight", "9999" );
     setdvar( "bg_falldamageminheight", "9998" );


	 //precache stuff
	 precacheItem( "ak47_mp" );
	 precacheItem( "deserteaglegold_mp" );
	 precacheItem( "dragunov_acog_mp" );
	 precacheItem("deserteagle_mp");
	 precacheItem("tomahawk_mp");
	 precacheItem( "barrett_mp" );
	 precacheItem("m40a3_mp");
	 precacheItem("uzi_acog_mp");
	 precacheItem( "rpg_mp" );
	 precacheItem( "m40a3_acog_mp");
	 precacheItem( "dragunov_mp" );
	 precacheItem( "uzi_mp" );



	 //thread
	 thread start();
	 thread trap1();
	 thread trap2();
	 thread trap3();
	 thread trap4();
	 thread trap5();
	 thread trap6();
	 thread trap7();
	 thread trap8();
	 thread trap9();
	 thread trap10();
	 thread trap11();
	 thread trap12();
	 thread flip();
	 thread end();
	 /* [AUTO DELETE] GiveJumpersWeapon(); */
	 /* [AUTO DELETE] secret(); */
	 /* [AUTO DELETE] AddTestClients(); */

 }


 start()
 {
     start = getent("start","targetname");
	 quake = getent("quake","targetname");
     sound = getent("sound","targetname");
	 // wait(8);
	 playLoopedFX(level.spark, 1, (-188, 260, 28));
	 playLoopedFX(level.spark2, 1, (440, 260, 28));
	 /* [AUTO DELETE] iPrintLnBold (" ^2Map by ^6Sheep Wizard"); */
	 /* [AUTO DELETE] iPrintLn ("^2Map by ^6Sheep Wizard"); */
	 // wait 1;
	 // /* [AUTO DELETE] iPrintLn ("^2Youtube ^1http://www.youtube.com/user/paap15"); */
	 // wait 0.5;
	 //  [AUTO DELETE] iPrintLn ("^2xfire ^1paap15");
	 // wait 0.5;
	 // /* [AUTO DELETE] iPrintLn ("^2Thanks you ^1Spicy Weiner ^2For emotional support"); */
	 // wait(5);

	 start delete();
	 playLoopedFX(level.flash, 1, (128, -240, 32));
	 playFX(level.burst, (288, -256, 48));
	 playFX(level.burst, (-48, -256, 48));
	 // sound PlaySound( "elm_quake_sub_rumble");
	 // Earthquake( 1, 4, quake.origin, 10000 );
	 /* [AUTO DELETE] ambientPlay("music1"); *///disbale this is you want
	 // iPrintLn ("^3Song ^4xKore ft. Zoe & Naomi - Need You (Centra 100BPM Remix)"); //link http://www.youtube.com/watch?v=3pS_cgCKD-0
}


flip()//letter at start. Got idea from map terror
{
     flip = getent("flip", "targetname");
	 flip2 = getent("flip2", "targetname");
	 flip3 = getent("flip3", "targetname");
	 flip4 = getent("flip4", "targetname");
	 flip5 = getent("flip5", "targetname");
	 flip6 = getent("flip6", "targetname");
	 flip7 = getent("flip7", "targetname");

	 while(1)
	 {
	     flip rotateyaw (180, 4);
		 flip2 rotateroll (180, 4);
		 flip3 rotateroll (180, 4);
		 flip4 rotateroll (180, 4);
		 flip5 rotateyaw (180, 4);
		 flip6 rotateyaw (180, 4);
		 flip7 rotateroll (180, 4);
		 wait 10;
		}
}


secret()//find me if you can
{
     trig = getent("trig_secret", "targetname");
	 secret = getent("secret", "targetname");
	 gift = getent("gift","targetname");

	 trig waittill ("trigger", user);
	 trig delete();

	 secret notSolid();

	 gift waittill ("trigger",player);
	 gift delete();

	 // /* [AUTO DELETE] player giveWeapon ("rpg_mp", 1 ); */
	 // wait 0.01;
	 // /* [AUTO DELETE] player SwitchToWeapon("rpg_mp"); */
	 //  [AUTO DELETE] user iprintlnbold("A gift from me to you :D");
	 // /* [AUTO DELETE] user iPrintLn("Enjoy the picture ; */)");


}


GiveJumpersWeapon( weap )
{
	 if( !isDefined( weap ) || weap == "" )
		return;

	 players = getEntArray( "player", "classname" );
	 for( i=0; i<players.size; i++ )
	{
		 if( !isAlive( players[i] ) || players[i].pers["team"] != "allies" )
			continue;

         /* [AUTO DELETE] players[i] TakeAllWeapons(); */
		 wait 0.01;
		 /* [AUTO DELETE] players[i] giveWeapon( weap ); */
		 /* [AUTO DELETE] players[i] giveMaxAmmo( weap ); */
		 players[i] SetSpawnWeapon( weap );

	}
}




//traps
trap1()
{
	level endon("trigger");
     trig = getent("trap1_trig", "targetname");
	 up = getent("trap1_up", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 up moveZ (69, 1);
	 wait 4;
	 up moveZ (-69, 3);

}


trap2()
{
	level endon("trigger");
     trig = getent("trap2_trig", "targetname");
	 spin = getent("trap2_spin", "targetname");
	 spin1 = getent("trap2_spin1", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     spin rotateroll (180, 0.6);
		 spin1 rotateroll (180, 0.6);
		 wait 0.6;
		}
}


trap3()
{
	level endon("trigger");
     trig = getent("trap3_trig", "targetname");
	 plat = getent("trap3_plat", "targetname");
	 plat2 = getent("trap3_plat2", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     plat moveZ (64, 0.8);
		 plat2 moveZ (-64,0.8);
		 wait 1;
		 plat moveZ (-64, 0.8);
		 plat2 moveZ (64,0.8);
		 wait 1;
		}
}


trap4()
{
	level endon("trigger");
     trig = getent("trap4_trig", "targetname");
	 push = getent("trap4_push", "targetname");
	 push2 = getent("trap4_push2", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     push moveX (-400, 0.6);
		 push2 moveX (400, 0.6);
		 wait 0.5;
		 push moveX (400, 0.6);
		 push2 moveX (-400, 0.6);
		 wait 0.5;
		}
}


trap5()
{
	level endon("trigger");
     trig = getent("trap5_trig", "targetname");
	 slide = getent("trap5_slide", "targetname");
	 slide2 = getent("trap5_slide2", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     slide moveX (150, 1.5);
		 slide2 moveZ (48, 2);
		 wait 0.3;
		 slide moveX (-150, 1.5);
		  slide2 moveZ (-48, 2);
		 wait 0.3;
		}

}


trap6()
{
	level endon("trigger");
     trig = getent("trap6_trig", "targetname");
	 sp = getent("trap6_sp", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     sp rotateyaw (180,3);
		 wait 3;
		}
}


trap7()
{
	level endon("trigger");
     trig = getent("trap7_trig", "targetname");
	 down = getent("trap7_down", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     down moveZ (-320,0.3);
		 wait 3;
		 down moveZ (320,0.3);
		 wait 3;
		}
}


trap8()
{
	level endon("trigger");
     trig = getent("trap8_trig", "targetname");
	 aaa = getent("trap8_aaa", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     aaa moveX (400,0.8);
		 wait 1;
		 aaa moveX (-400,0.8);
		 wait 1;
		}
}


trap9()
{
	level endon("trigger");
     trig = getent("trap9_trig", "targetname");
	 bbb = getent("trap9_bbb", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     bbb moveZ (-10,0.1);
		 wait 0.5;
		 bbb moveZ (10,0.1);
		 wait 0.5;
		}
}


trap10()
{
	level endon("trigger");
     trig = getent("trap10_trig", "targetname");
	 ccc = getent("trap10_ccc", "targetname");
	 ccc2 = getent("trap10_ccc2", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     ccc rotateyaw (-180,0.3);
		 ccc2 rotateyaw (180,0.3);
		 wait 0.3;
		}
}


trap11()
 {
	level endon("trigger");
	 trig = getent("trap11_trig", "targetname");
	 ddd = getent("trap11_ddd", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     ddd moveY (-240, 1);
		 wait 2;
		 ddd moveY (240,1);
		 wait 2;
		}
}


trap12()
{
	level endon("trigger");
     trig = getent("trap12_trig", "targetname");
	 eee = getent("trap12_eee", "targetname");

	 trig waittill ("trigger", player);
	 trig delete();

	 while(1)
	 {
	     eee rotatepitch (180, 1);
		 wait 4.5;
		}
}


end()//end room add more weapons if you wish
{
     end = getent("end", "targetname");
	 enddoor = getent("enddoor", "targetname");
	 enddoor2 = getent("enddoor2", "targetname");
	 apush = getent("apush", "targetname");
	 rise = getent("rise", "targetname");

	 // end waittill ("trigger", player);
	 end delete();
	 enddoor delete();
	 rise moveZ (208, 6);
	 apush moveY (-2692, 3);
	 playloopedFX(level.fire1,1, (32, -8144, 16));
	 playloopedFX(level.fire1,1, (300, -8144, 16));
	 /* [AUTO DELETE] iprintlnbold("^2"+ player.name + " "+ "^1Finished ^2First"); *///change this if you want


	 random = randomInt(9);
     x = randomInt(9);
	 if(x == 0)
     {
         GiveJumpersWeapon( "deserteagle_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("deserteagle_mp" ); */
		}
	 else if(x == 1)
	 {
	     GiveJumpersWeapon( "ak47_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("ak47_mp" ); */
		}
     else if(x == 2)
	 {
	     GiveJumpersWeapon( "dragunov_acog_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("dragunov_acog_mp" ); */
		}
     else if(x == 3)
	 {
	     GiveJumpersWeapon( "tomahawk_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("tomahawk_mp" ); */
		}
     else if(x == 4)
	 {
	     GiveJumpersWeapon( "barrett_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("barrett_mp" ); */
		}
     else if(x == 5)
	 {
	     GiveJumpersWeapon( "m40a3_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("m40a3_mp" ); */
		}
     else if(x == 6)
	 {
	     GiveJumpersWeapon( "uzi_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("uzi_mp" ); */
		}

     else if(x == 7)
	 {
	     GiveJumpersWeapon( "dragunov_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("dragunov_mp" ); */
		}
	 else if(x == 8)
	 {
	     GiveJumpersWeapon( "m40a3_acog_mp" );
	     /* [AUTO DELETE] level.activ TakeAllWeapons(); */
	     /* [AUTO DELETE] level.activ giveWeapon ("m40a3_acog_mp" ); */
		}

	 wait 6;
	 enddoor2 delete();
}


addTestClients()//dont know what this does
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
            /* [AUTO DELETE] println("Could not add test client"); */
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
