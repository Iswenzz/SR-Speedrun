// Thanks To Mikey and IMtroll and Lossy and Slaya for Script help !!!!

main()
{

	maps\mp\_load::main();
	maps\mp\_teleport::main();

	thread speedrun\_way_name::create_spawn((483, -340, 316), 360);
	thread speedrun\_way_name::create_normal_way("Normal Way;");

	addTriggerToList( "trigger_redlift" );
	addTriggerToList( "trigger_weewee" );
	addTriggerToList( "trigger_spinner" );
	addTriggerToList( "trigger_deathroll" );
	addTriggerToList( "trigger_cubejump" );
	addTriggerToList( "trigger_slam" );
	addTriggerToList( "trigger_pillar" );
	addTriggerToList( "trigger_bridgedelete" );
	addTriggerToList( "trigger_cube1" );

	level.dvar["bunnyhoop"] = false;
	level.knockback = getDvarInt("g_knockback");

	PrecacheShellShock("frag_grenade_mp");
	PreCacheItem("m1014_mp");
	PreCacheItem("smoke_grenade_mp");
	PreCacheItem("mp44_mp");
	PreCachemodel("iw_zapper_view");
	PreCachemodel("iw_zapper_world");


	level.yes2_fx = LoadFx ("deathrun/trail1");
	level.lostfx = LoadFx ("deathrun/trail2");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	speed   = getEntArray("speed", "targetname");
	for(i = 0;i < speed.size;i++)

	thread speed(speed[i]);
	thread startdoor();
	thread bounceopen();
	thread redlift();
	thread flip();
	thread flip2();
	thread redring();
	thread redring2();
	thread lift2();
	thread secondlift();
	thread triangledoor();
	thread jasper();
	thread spinner();
	thread weewee();
	thread deathroll();
	thread cubejump();
	thread printCredits();
	thread pillar();
	thread song();
	thread dna();
	thread wall();
	thread wall2();
	thread wall3();
	thread give_m402();
	thread theend();
	thread wall4();
	thread slam();
	thread bridge();
	thread give_m40();
    thread give_alien();
	thread kilo();
	thread killcube();
	thread teleportjump();
	thread easy3();
	thread spin();
	thread igloo();
	thread jump();
	thread r();
	thread teleportsniper();
	thread teleportbounce();
	thread teleportknife();
	thread teleportzombjumper();
	thread jump_reset();
	thread moon();
	thread onPlayerSpawn();
	thread easy1();
	thread addTestClients();

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

onPlayerSpawn() {
    for(;;) {
        level waittill("player_spawn", player);
		if (player.pers["team"] == "allies") {
        	player thread setZombieVision();
		}
    }
}

setZombieVision() {
    self endon("death");
    self endon("disconnect");

    self freezeControls(true);

    self thread cleanupZombieVision();
    self.zombieVision = newClientHudElem(self);
    self.zombieVision.x = 0;
    self.zombieVision.y = 0;
    self.zombieVision.alignX = "left";
    self.zombieVision.alignY = "top";
    self.zombieVision.horzAlign = "fullscreen";
    self.zombieVision.vertAlign = "fullscreen";
    self.zombieVision.alpha = 0;
    self.zombieVision.color = (0, 0, 0);
    self.zombieVision setShader("white", 640, 480);
    self.zombieVision.alpha = 1;
    wait 5;
    self.zombieVision fadeOverTime(6);
    self.zombieVision.alpha = 0;

    self shellShock("frag_grenade_mp", 3);
    self thread text();
    self freezeControls(false);

    wait 6;
    self.zombieVision destroy();
}

cleanupZombieVision() {
    self waittill("death");
    if (isDefined(self.zombieVision)) {
        self.zombieVision destroy();
    }
}

text() {
    noti = spawnStruct();
    noti.alignX = "center";
    noti.alignY = "center";
    noti.horzalign = "center";
    noti.vertalign = "center";
    noti.x = 0;
    noti.y = 0;
    noti.titleText = "^0Map Made By Xenon";
    noti.notifyText = "^0Find The Black Qube";
    noti.duration = 10;
    noti.glowcolor = (1, 0, 0);
    // noti setPulseFX(40, 5400, 200);
    self thread maps\mp\gametypes\_hud_message::notifyMessage(noti);
}

		moon()
		{
trigger = getEnt("moon", "targetname");
object = getEnt("moonmove", "targetname");
object2 = getEnt("moonmove2", "targetname");
object3 = getEnt("moonmove3", "targetname");
object4 = getEnt("moonmove5", "targetname");
object5 = getEnt("moonhide", "targetname");
object5 hide();
trigger waittill ("trigger" , player );
VisionSetNaked( "qube2", 1 );
AmbientStop( 1 );
Ambientplay( "D" );
self thread Text2();
trigger delete();
wait(1);
object movez(1000, 3, 1, 2);
object2 rotateyaw(360,5);
player braxi\_rank::giveRankXP("", 1000);
object2 movez(300, 3, 1, 2);
object3 movez(58, 3, 1, 2);
wait 0.5;
object4 movez(150, 3, 1, 2);
wait 15;
object5 show();
while(1)
{
object5 rotateyaw(360, 2, 1, 1);
object5 rotatepitch(360, 2, 1, 1);
object5 waittill ("rotatedone");
wait 0.1;
object5 rotateyaw(-360, 2, 1, 1);
object5 rotatepitch(-360, 2, 1, 1);
object5 waittill ("rotatedone");
		}
		}


		text2()
{
    noti = SpawnStruct();
	noti.alignX = "center";
	noti.alignY = "center";
	noti.horzalign = "center";
	noti.vertalign = "center";
	noti.x = 0;
	noti.y = 0;
	noti.titleText = "^8The Stranger Gazed At The Moon";
	noti.notifyText = "";
	noti.duration = 10;
	noti.glowcolor = (1,0,0);
	// noti SetPulseFX( 40, 5400, 200 );
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		//self thread gem();

		}

		addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

startdoor()
{
AmbientPlay( "wave" );
wait(7);
doorleft = getent("leftopen","targetname");
doorright = getent("rightopen","targetname");
wait(5);
doorleft movey(200,10,1,9);
doorright movey(-200,10,1,9);
doorleft waittill ("movedone");
doorright waittill ("movedone");
wait 0.5;
}

redlift()
{
trigger = getEnt("trigger_redlift", "targetname");
object = getEnt("redlift", "targetname");
object2 = getEnt ("movetrap1", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
object2 movez(-12, 3, 1, 2);
while(1)
{
object movez(205, 3, 1, 2);
object waittill("movedone");
wait(5);
object movez(-205, 3, 1, 2);
object waittill("movedone");
wait(5);
}
}

redring()
{
trigger = getEnt("trigger_redring", "targetname");
object = getEnt("redring", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object rotatepitch(360,5);
object movey(-2370, 6, 1, 3);
object waittill("movedone");
wait(5);
object rotatepitch(360,5);
object movey(2370, 6, 1, 3);
object waittill("movedone");
wait(5);
}
}

dna()
{
trigger = getEnt("trigger_dna", "targetname");
sound = getent("space","targetname");
object1 = getEnt("dna1", "targetname");
object2 = getEnt("dna2", "targetname");
object3 = getEnt("dna3", "targetname");
object4 = getEnt("dna4", "targetname");
object5 = getEnt("dna5", "targetname");
object6 = getEnt("dna6", "targetname");
object7 = getEnt("dna7", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
sound playsound("josh");
object1 rotateyaw(360,2);
object2 rotateyaw(360,2);
object3 rotateyaw(360,2);
object4 rotateyaw(360,2);
object5 rotateyaw(360,2);
object6 rotateyaw(360,2);
object7 rotateyaw(360,2);
wait 2;
object1 rotateyaw(360,2);
object2 rotateyaw(360,2);
object3 rotateyaw(360,2);
object4 rotateyaw(360,2);
object5 rotateyaw(360,2);
object6 rotateyaw(360,2);
object7 rotateyaw(360,2);
wait 2;
}
}


redring2()
{
trigger = getEnt("trigger_redring2", "targetname");
object = getEnt("redring2", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object rotatepitch(360,5);
object movey(2370, 6, 1, 3);
object waittill("movedone");
wait(5);
object rotatepitch(360,5);
object movey(-2370, 6, 1, 3);
object waittill("movedone");
wait(5);
}
}



lift2()
{
trigger = getEnt("trigger_lift2", "targetname");
object = getEnt("lift2", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object movez(800, 6, 1, 3);
object waittill("movedone");
wait(5);
object movez(-800, 6, 1, 3);
object waittill("movedone");
wait(5);
}
}

secondlift()
{
trigger = getEnt("trigger_secondlift", "targetname");
object = getEnt("secondlift", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object movez(-1320, 8, 1, 3);
object waittill("movedone");
wait(5);
object movez(1320, 6, 1, 3);
object waittill("movedone");
wait(5);
}
}

triangledoor()
{
trigger = getEnt("trigger_seconddoor", "targetname");
object1 = getEnt("tri1", "targetname");
object2 = getEnt("tri2", "targetname");
object3 = getEnt("tri3", "targetname");
object4 = getEnt("tri4", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
wait 1;
{
object2 movez(100, 0.5);
object2 waittill("movedone");
object3 movex(120, 0.5);
object3 waittill("movedone");
object4 movex(-120, 0.5);
object4 waittill("movedone");
object1 movez(-100, 0.5);
object1 waittill("movedone");
wait 1;
}
}

spinner()
{
	trigger = getent ("trigger_spinner", "targetname");
	brush = getent ("spinner", "targetname");
	object2 = getEnt ("movetrap3", "targetname");
	brush2 = getent ("spinner2", "targetname");
	brush3 = getent ("spinner3", "targetname");
	brush4 = getent ("spinner4", "targetname");
	brush5 = getent ("spinner5", "targetname");
	brush6 = getent ("spinner6", "targetname");
	brush7 = getent ("spinner7", "targetname");
	//killtrigger1 = getent ("killtrig1" , "targetname");

	trigger waittill ("trigger", player );
	trigger delete();
	object2 movez(-12, 3, 1, 2);

		while(1)
		    {
			brush6 rotateyaw(-360,1);
			brush7 rotateyaw(-360,1);
	 		//killtrigger1 enablelinkto ();
	        //killtrigger1 linkto (brush);
			brush rotateyaw(-360,2);
			brush waittill ("rotatedone");
			brush2 rotateyaw(360,2);
			//brush2 waittill ("rotatedone");
			brush3 rotateyaw(360,2);
			brush3 waittill ("rotatedone");
			brush4 rotateyaw(-360,2);
			//brush4 waittill ("rotatedone");
			brush5 rotateyaw(-360,2);
			brush5 waittill ("rotatedone");
			wait 0.1;
		    }
			}

			weewee()
{
	trigger = getent ("trigger_weewee", "targetname");
	brush = getent ("weewee", "targetname");
	object2 = getEnt ("movetrap2", "targetname");
	killtrigger2 = getent ("killtrig2" , "targetname");
	killtrigger3 = getent ("killtrig3" , "targetname");
	killtrigger2 enablelinkto ();
	killtrigger2 linkto (brush);
	killtrigger3 enablelinkto ();
	killtrigger3 linkto (brush);

	trigger waittill ("trigger", player );
	trigger delete();
    object2 movez(-12, 3, 1, 2);

		while(1)
		    {
			brush rotatepitch(-360,3);
			wait 0.01;
		    }
			}



			bridge()
{
	trigger = getent ("trigger_bridgedelete", "targetname");
	object2 = getEnt ("movetrap7", "targetname");
	brush = getent ("bridgedelete", "targetname");

	trigger waittill ("trigger", player );
	trigger delete();
	object2 movez(-12, 3, 1, 2);
	brush delete();

		    }

			jasper()
{
	trigger = getent ("jasper", "targetname");
	object2 = getEnt ("jasper2", "targetname");
	trigger waittill ("trigger", player );
	player braxi\_rank::giveRankXP("", 100);
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );


	trigger delete();
	object2 delete();
	self thread Text3();

		    }

			text3()
{
    noti = SpawnStruct();
	noti.alignX = "center";
	noti.alignY = "center";
	noti.horzalign = "center";
	noti.vertalign = "center";
	noti.x = 0;
	noti.y = 0;
	noti.titleText = "^8.-.. --- --- -.- / ..- .--.";
	noti.notifyText = "^8This Is Simply A Glitch...... Ignore It";
	noti.duration = 10;
	noti.glowcolor = (1,0,0);
	// noti SetPulseFX( 40, 5400, 200 );
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		//self thread gem();

		}

		bounceopen()
{
	trigger = getent ("bounceopen", "targetname");
	object2 = getEnt ("bounceopen2", "targetname");

	trigger waittill ("trigger", player );
	player braxi\_rank::giveRankXP("", 30);

	trigger delete();
	object2 delete();
	self thread Text4();

		    }

			text4()
{
    noti = SpawnStruct();
	noti.alignX = "center";
	noti.alignY = "center";
	noti.horzalign = "center";
	noti.vertalign = "center";
	noti.x = 0;
	noti.y = 0;
	noti.titleText = "^8Your Wish Is Granted.";
	noti.duration = 5;
	noti.glowcolor = (1,0,0);
	// noti SetPulseFX( 40, 5400, 200 );
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		//self thread gem();

		}


			killcube()
{
	trigger = getent ("trigger_cube1", "targetname");
	brush = getent ("killcube1", "targetname");
	brush2 = getent ("killcube2", "targetname");
	brush3 = getent ("killcube3", "targetname");
	object2 = getEnt ("movetrap8", "targetname");
	killtrigger1 = getent ("trigger_killcube1" , "targetname");
	killtrigger2 = getent ("trigger_killcube2" , "targetname");
	killtrigger3 = getent ("trigger_killcube3" , "targetname");
	killtrigger4 = getent ("trigger_killcube4" , "targetname");
	killtrigger1 enablelinkto ();
	killtrigger2 enablelinkto ();
	killtrigger3 enablelinkto ();
	killtrigger4 enablelinkto ();
	killtrigger1 linkto (brush);
	killtrigger2 linkto (brush2);
	killtrigger3 linkto (brush3);
	killtrigger4 linkto (brush3);

	trigger waittill ("trigger", player );
	trigger delete();
    object2 movez(-12, 3, 1, 2);

		while(1)
		    {
			brush movez(-100,3);
			brush2 movez(-200,3);
			brush3 movez(-100,3);
			brush waittill ("movedone");
			wait 1;
			brush movez(100,3);
			brush2 movez(200,3);
			brush3 movez(100,3);
			brush waittill ("movedone");
			wait 3;
		    }
			}

			spin()
{
	trigger = getent ("trigger_endspin1", "targetname");

	object = getent ("endspin1", "targetname");
	object2 = getent ("endspin2", "targetname");
	object3 = getent ("endspin3", "targetname");

	trigger waittill ("trigger", player);

		while(1)
		    {
			object rotateyaw(360,9);
			object2 rotateyaw(360,9);
			object3 rotateyaw(-360,9);
			object movez(-100,9);
			object2 movez(-100,9);
			object3 movez(-100,9);
			wait 9;
			object rotateyaw(-360,9);
			object2 rotateyaw(-360,9);
			object3 rotateyaw(360,9);
			object movez(100,9);
			object2 movez(100,9);
			object3 movez(100,9);
			wait 9;
		    }
			}

			pillar()
{
trigger = getEnt("trigger_pillar", "targetname");
object = getEnt("pillar1", "targetname");
object2 = getEnt("pillar2", "targetname");
object3 = getEnt ("movetrap9", "targetname");
trigger waittill ("trigger" , player );
trigger delete();
object3 movez(-12, 3, 1, 2);
while(1)
		    {

			object movey(80, 3);
			object2 movey(-80, 3);
			wait 5;
			object movey(-80, 3);
			object2 movey(80, 3);
			wait 15;
		    }
			}

			kilo()
{
	trigger = getent ("kilo", "targetname");
	object2 = getEnt ("kilo2", "targetname");

	trigger waittill ("trigger", player );
	player braxi\_rank::giveRankXP("", 100);
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );


	trigger delete();
	object2 delete();
	self thread Text5();

		    }

			text5()
{
    noti = SpawnStruct();
	noti.alignX = "center";
	noti.alignY = "center";
	noti.horzalign = "center";
	noti.vertalign = "center";
	noti.x = 0;
	noti.y = 0;
	noti.titleText = "^8Moon";
	noti.duration = 10;
	noti.glowcolor = (1,0,0);
	// noti SetPulseFX( 40, 5400, 200 );
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		//self thread gem();

		}

		give_m40()
{
trigger = getent ("give_m40_trig","targetname");
while(1)
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("^8You Have Taken The M40A3");
wait(0.1);
user giveWeapon( "m40a3_mp");
user giveMaxammo("m40a3_mp");
wait 0.1;
user switchToWeapon("m40a3_mp");
wait 0.1;
trigger delete();
}
}

give_m402()
{
trigger = getent ("givem402","targetname");
while(1)
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("^8You Have Taken The M40A3");
wait(0.1);
user giveWeapon( "m40a3_mp");
user giveMaxammo("m40a3_mp");
wait 0.1;
user switchToWeapon("m40a3_mp");
wait 0.1;
trigger delete();
}
}

give_alien()
{
trigger = getent ("givealien","targetname");
while(1)
{
trigger waittill ("trigger",user);
wait(0.2);
user iprintlnbold("^7Wtf is this thing");
wait(0.1);
user giveWeapon( "mp44_mp");
user giveMaxammo("mp44_mp");
wait 0.1;
user switchToWeapon("mp44_mp");
wait 0.1;
}
}



			deathroll()
{
	trigger = getent ("trigger_deathroll", "targetname");
	brush3 = getent ("deathroll", "targetname");
	object2 = getEnt ("movetrap4", "targetname");
	killtrigger4 = getent ("deathroll_kill1" , "targetname");
	killtrigger5 = getent ("deathroll_kill2" , "targetname");
	killtrigger6 = getent ("deathroll_kill3" , "targetname");
	killtrigger7 = getent ("deathroll_kill4" , "targetname");
	if (isDefined(killtrigger4)) {
		killtrigger4 enablelinkto ();
		killtrigger4 linkto (brush3);
	}
	if (isDefined(killtrigger5)) {
		killtrigger5 enablelinkto ();
		killtrigger5 linkto (brush3);
	}
	if (isDefined(killtrigger6)) {
		killtrigger6 enablelinkto ();
		killtrigger6 linkto (brush3);
	}
	if (isDefined(killtrigger7)) {
		killtrigger7 enablelinkto ();
		killtrigger7 linkto (brush3);
	}

	trigger waittill ("trigger", player );
	trigger delete();
	object2 movez(-12, 3, 1, 2);

		while(1)
		    {
			brush3 rotateroll(360,8);
			brush3 movey(-937, 6);
			wait 8;
			brush3 rotateroll(-360,8);
			brush3 movey(937, 6);
			wait 8;
		    }
			}

			cubejump()
{
	trigger = getent ("trigger_cubejump", "targetname");
	brush = getent ("cubejump1", "targetname");
	brush2 = getent ("cubejump2", "targetname");
	brush3 = getent ("cubejump3", "targetname");
	brush4 = getent ("cubejump4", "targetname");
	brush5 = getent ("cubejump5", "targetname");

	object2 = getEnt ("movetrap5", "targetname");

	trigger waittill ("trigger", player );
	trigger delete();
	object2 movez(-12, 3, 1, 2);

		while(1)
		    {
			brush rotateyaw(-90,1);
			brush4 rotateyaw(-90,1);
			brush5 rotateyaw(-90,1);
			wait 3;
			brush2 rotateyaw(90,1);
			brush3 rotateyaw(90,1);
			wait 1;
			brush rotateyaw(-90,1);
			brush4 rotateyaw(-90,1);
			brush5 rotateyaw(-90,1);
			wait 3;
			brush2 rotateyaw(90,1);
			brush3 rotateyaw(90,1);
			wait 1;
			brush rotateyaw(90,1);
			brush4 rotateyaw(90,1);
			brush5 rotateyaw(90,1);
			wait 3;
			brush2 rotateyaw(90,1);
			brush3 rotateyaw(90,1);
			wait 1;
			brush rotateyaw(90,1);
			brush4 rotateyaw(90,1);
			brush5 rotateyaw(90,1);
			wait 3;
			brush2 rotateyaw(90,1);
			brush3 rotateyaw(90,1);
			wait 1;
		    }
			}

			jump()
{
	trigger = getEnt ("tele_jumper", "targetname"); // give it le targetname
	origin = getEnt ("gohere_jumper", "targetname"); // the target you want to teleport the jumper

	trigger waittill ("trigger", player);
	//iprintlnbold (player.name + "^6BLAHHHHH");
	player SetOrigin(origin.origin);
	player SetPlayerAngles( origin.angles );
	thread tele_acti();
	wait 1;

	for(;;)
	{
		trigger waittill ("trigger", player);
		player SetOrigin(origin.origin);
		player SetPlayerAngles( origin.angles );
		//player iprintlnbold ("msg here"); // remove the // if you want to give the player msg
		wait .1;
	}
}

tele_acti()
{
	jumpacti = getEnt ("gohere_acti", "targetname"); // the script_origin name you want to place the activator


	players = getentarray("player", "classname");
	for(i=0;i<=players.size;i++)
	{
		if(isDefined(players[i]) && players[i].pers["team"] == "axis")
		{
			players[i] FreezeControls (true); // freezing controls so freeze jump lag won't kill him
			//players[i] iprintlnbold ("msghere");
			players[i] SetOrigin(jumpacti.origin);
			players[i] SetPlayerAngles( jumpacti.angles );
			wait .5;
			players[i] FreezeControls (false);
		}
	}
}

			slam()
{
trigger = getEnt("trigger_slam", "targetname");
object1 = getEnt("slam1", "targetname");
object2 = getEnt("slam2", "targetname");
object3 = getEnt("slam3", "targetname");
object4 = getEnt("slam4", "targetname");
object5 = getEnt("slam5", "targetname");
object6 = getEnt("slam6", "targetname");
object7 = getEnt("slam7", "targetname");
object8 = getEnt("slam8", "targetname");
object9 = getEnt("slam9", "targetname");
object10 = getEnt("slam10", "targetname");
object11 = getEnt ("movetrap6", "targetname");
killtrigger1 = getent ("killslam1" , "targetname");
killtrigger2 = getent ("killslam2" , "targetname");
killtrigger3 = getent ("killslam3" , "targetname");
killtrigger4 = getent ("killslam4" , "targetname");
killtrigger5 = getent ("killslam5" , "targetname");
killtrigger6 = getent ("killslam6" , "targetname");
killtrigger7 = getent ("killslam7" , "targetname");
killtrigger8 = getent ("killslam8" , "targetname");
killtrigger9 = getent ("killslam9" , "targetname");
killtrigger10 = getent ("killslam10" , "targetname");
if (isDefined(killtrigger1)) {
	killtrigger1 enablelinkto ();
	killtrigger1 linkto (object1);
}
if (isDefined(killtrigger2)) {
	killtrigger2 enablelinkto ();
	killtrigger2 linkto (object2);
}
if (isDefined(killtrigger3)) {
	killtrigger3 enablelinkto ();
	killtrigger3 linkto (object3);
}
if (isDefined(killtrigger4)) {
	killtrigger4 enablelinkto ();
	killtrigger4 linkto (object4);
}
if (isDefined(killtrigger5)) {
	killtrigger5 enablelinkto ();
	killtrigger5 linkto (object5);
}
if (isDefined(killtrigger6)) {
	killtrigger6 enablelinkto ();
	killtrigger6 linkto (object6);
}
if (isDefined(killtrigger7)) {
	killtrigger7 enablelinkto ();
	killtrigger7 linkto (object7);
}
if (isDefined(killtrigger8)) {
	killtrigger8 enablelinkto ();
	killtrigger8 linkto (object8);
}
if (isDefined(killtrigger9)) {
	killtrigger9 enablelinkto ();
	killtrigger9 linkto (object9);
}
if (isDefined(killtrigger10)) {
	killtrigger10 enablelinkto ();
	killtrigger10 linkto (object10);
}
trigger waittill ("trigger" , player );
trigger delete();
object11 movez(-12, 3, 1, 2);
while(1)
{
object1 movez(-180, 0.5);
object1 waittill("movedone");
object2 movez(-180, 0.5);
object2 waittill("movedone");
object3 movez(-180, 0.5);
object3 waittill("movedone");
object4 movez(-180, 0.5);
object4 waittill("movedone");
object5 movez(-180, 0.5);
object5 waittill("movedone");
object6 movez(-180, 0.5);
object6 waittill("movedone");
object7 movez(-180, 0.5);
object7 waittill("movedone");
object8 movez(-180, 0.5);
object8 waittill("movedone");
object9 movez(-180, 0.5);
object9 waittill("movedone");
object10 movez(-180, 0.5);
object10 waittill("movedone");
wait(3);
object1 movez(180, 0.5);
object1 waittill("movedone");
object2 movez(180, 0.5);
object2 waittill("movedone");
object3 movez(180, 0.5);
object3 waittill("movedone");
object4 movez(180, 0.5);
object4 waittill("movedone");
object5 movez(180, 0.5);
object5 waittill("movedone");
object6 movez(180, 0.5);
object6 waittill("movedone");
object7 movez(180, 0.5);
object7 waittill("movedone");
object8 movez(180, 0.5);
object8 waittill("movedone");
object9 movez(180, 0.5);
object9 waittill("movedone");
object10 movez(180, 0.5);
object10 waittill("movedone");
wait(3);
}
}

igloo()
{
	trigger = getent ("igloo_trigger", "targetname");
	object2 = getEnt ("igloo", "targetname");

	trigger waittill ("trigger", player );
	player braxi\_rank::giveRankXP("", 100);
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );
	wait 0.1;
	VisionSetNaked( "invert", 0.5 );
	wait 0.1;
	VisionSetNaked( "qube", 0.5 );


	trigger delete();
	object2 delete();
	self thread Text6();

		    }

			text6()
{
    noti = SpawnStruct();
	noti.alignX = "center";
	noti.alignY = "center";
	noti.horzalign = "center";
	noti.vertalign = "center";
	noti.x = 0;
	noti.y = 0;
	noti.titleText = "^8This Leads To Nothing";
	noti.duration = 10;
	noti.glowcolor = (1,0,0);
	// noti SetPulseFX( 40, 5400, 200 );
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		//self thread gem();

		}



flip()
{
flip = getent("flip1","targetname");
while(1)
{
flip waittill ("trigger",user);
user thread tele();
wait 0.1;
}
}

tele()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("killed_player");

		while(1)
		{
		i = 0;
		angles = self GetPlayerAngles();
		angles1 = self GetPlayerAngles();
		while(i<3)
				{
				wait 0.01;
		 		i+=0.09;
				angles+=(0,11,11);
				self SetPlayerAngles(angles);
	         		}
		if(i>2.8)
		self SetPlayerAngles(angles1);
			break;

}
}

r()
{
	trigger = getent ("trigger_removethis", "targetname");
	object2 = getEnt ("removethis", "targetname");

	trigger waittill ("trigger", player );

    trigger delete();
	object2 delete();
	}

flip2()
{
flip2 = getent("flip2","targetname");
while(1)
{
flip2 waittill ("trigger",user);
user thread tele2();
wait 0.1;
}
}

tele2()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("killed_player");

		while(1)
		{
		i = 0;
		angles = self GetPlayerAngles();
		angles1 = self GetPlayerAngles();
		while(i<3)
				{
				wait 0.01;
		 		i+=0.09;
				angles+=(0,11,11);
				self SetPlayerAngles(angles);
	         		}
		if(i>2.8)
		self SetPlayerAngles(angles1);
			break;

}
}

teleportsniper()
{
level.teleactorigin4 = getEnt("sniperact", "targetname");
telesniperorigin = getEnt("telesniper", "targetname");
level.snipertrigger = getEnt("teleportsniperroom", "targetname");
for(;;)
{
level.snipertrigger waittill("trigger", player);
if (isDefined(level.jumpertrigger)) {
	level.jumpertrigger delete();
}
if (isDefined(level.bouncetrigger)) {
	level.bouncetrigger delete();
}
if (isDefined(level.teleportTrigger)) {
	level.teleportTrigger delete();
}
if (isDefined(level.knifetrigger)) {
	level.knifetrigger delete();
}
wait(0.05);
player SetOrigin( telesniperorigin.origin );
player setplayerangles( telesniperorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "m40a3_mp" );
player Giveweapon( "remington700_mp" );
wait(0.05);
level.activ SetOrigin (level.teleactorigin4.origin);
level.activ setplayerangles (level.teleactorigin4.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "m40a3_mp" );
level.activ Giveweapon( "remington700_mp" );
wait(0.05);
player switchToWeapon( "m40a3_mp" );
level.activ SwitchToWeapon( "m40a3_mp" );
if (isDefined(level.teleorigin)) {
	level.teleorigin delete();
}
iPrintLnBold(player.name+ "^0 has entered the ^0Sniper Room"); //Change the message if you want
//AmbientStop( 2 );
		//ambientplay( "snipe" );
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportjump()
{
level.teleactorigin = getEnt("jumperact", "targetname");
telejumporigin = getEnt("telejump", "targetname");
level.jumpertrigger = getEnt("teleportjumproom", "targetname");
for(;;)
{
level.jumpertrigger waittill("trigger", player);
if (isDefined(level.snipertrigger)) {
	level.snipertrigger delete();
}
if (isDefined(level.bouncetrigger)) {
	level.bouncetrigger delete();
}
if (isDefined(level.teleportTrigger)) {
	level.teleportTrigger delete();
}
if (isDefined(level.knifetrigger)) {
	level.knifetrigger delete();
}
wait(0.05);
player SetOrigin( telejumporigin.origin );
player setplayerangles( telejumporigin.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" ); 
wait(0.05);
level.activ SetOrigin (level.teleactorigin.origin);
level.activ setplayerangles (level.teleactorigin.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" ); 
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.telejumporigin delete();
iPrintLnBold(player.name+ "^0 has entered the ^0Trampoline Room"); //Change the message if you want
//AmbientStop( 2 );
		//ambientplay( "knife" );
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportbounce()
{
level.teleactorigin2 = getEnt("bounceact", "targetname");
telebounceorigin = getEnt("telebounce", "targetname");
level.bouncetrigger = getEnt("teleportbounceroom", "targetname");
for(;;)
{
level.bouncetrigger waittill("trigger", player);
if (isDefined(level.jumpertrigger)) {
	level.jumpertrigger delete();
}
if (isDefined(level.knifetrigger)) {
	level.knifetrigger delete();
}
if (isDefined(level.snipertrigger)) {
	level.snipertrigger delete();
}
if (isDefined(level.teleportTrigger)) {
	level.teleportTrigger delete();
}
wait(0.05);
player SetOrigin( telebounceorigin.origin );
player setplayerangles( telebounceorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" );
wait(0.05);
level.activ SetOrigin (level.teleactorigin2.origin);
level.activ setplayerangles (level.teleactorigin2.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" );
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.telebounceorigin delete();
iPrintLnBold(player.name+ "^0 has entered the ^0Bounce Room"); //Change the message if you want
//AmbientStop( 2 );
		//ambientplay( "bounce" );
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

teleportzombjumper()
{
    level.teleportTrigger = getEnt("teleportzombroom", "targetname");

    activatorOrigin = getEnt("zombact", "targetname");
    playerOrigin    = getEnt("telezomb", "targetname");

    level.teleportTrigger waittill("trigger", playerWhoTriggered);
    level.teleportTrigger delete();
	if (isDefined(level.jumpertrigger)) {
		level.jumpertrigger delete();
	}
	if (isDefined(level.knifetrigger)) {
		level.knifetrigger delete();
	}
	if (isDefined(level.snipertrigger)) {
		level.snipertrigger delete();
	}
	if (isDefined(level.bouncetrigger)) {
		level.bouncetrigger delete();
	}

	AmbientStop( 2 );
    Ambientplay( "snipe" );


    players = braxi\_common::getPlayingPlayers(); // support raid ghostrun

    row = 0; col = 0; maxPerRow = 8;
    for( i = 0; i < players.size; i ++ ) {
        player = players[i];

        // Supports ghost run for common plugins. If custom, add your own [entity].[ghost delcaration] to this statement
        if( players[i].pers["team"] != "allies" || ((isdefined(player.ghost) && player.ghost) || (isdefined(player.ghostRun) && player.ghostRun)) )
            continue;

        if( row > maxPerRow ) {
            row = 0;
            col ++;
        }

        player setOrigin(playerOrigin.origin + ((col * 32), (((maxPerRow / 2) * 32) * -1) + (row * 32), 0));
        player setPlayerAngles(playerOrigin.angles);

        giveMp44Back = player hasWeapon("mp44_mp");

        player takeAllWeapons();
        player.maxhealth = 250;
        player.health = 250;
        player GiveWeapon("knife_mp");
        player giveWeapon("smoke_grenade_mp");
        player giveMaxAmmo("smoke_grenade_mp");
        player SwitchToWeapon("knife_mp");

        if( giveMp44Back ) {
    player giveWeapon("mp44_mp");
    player giveMaxAmmo("mp44_mp");
    player SwitchToWeapon("mp44_mp");
    }
        row ++;
    }

    for( i = 0; i < players.size; i ++ ) {
        if( players[i].pers["team"] != "axis" )
            continue;

        players[i] setOrigin(activatorOrigin.origin);
        players[i] setPlayerAngles(activatorOrigin.angles);

        players[i] TakeAllWeapons();
        players[i] GiveWeapon("m1014_mp");
        players[i] SwitchToWeapon("m1014_mp");
		players[i] giveMaxAmmo("m1014_mp");

        break;
    }

    iPrintLnBold(playerWhoTriggered.name+ "^0 has entered the ^0Horde Room");
}

teleportknife()
{
level.teleactorigin3 = getEnt("knifeact", "targetname");
teleknifeorigin = getEnt("teleknife", "targetname");
level.knifetrigger = getEnt("teleportkniferoom", "targetname");
for(;;)
{
level.knifetrigger waittill("trigger", player);
if (isDefined(level.bouncetrigger)) {
	level.bouncetrigger delete();
}
if (isDefined(level.snipertrigger)) {
	level.snipertrigger delete();
}
if (isDefined(level.teleportTrigger)) {
	level.teleportTrigger delete();
}
wait(0.05);
player SetOrigin( teleknifeorigin.origin );
player setplayerangles( teleknifeorigin.angles );
player TakeAllWeapons();
player GiveWeapon( "knife_mp" );
wait(0.05);
level.activ SetOrigin (level.teleactorigin3.origin);
level.activ setplayerangles (level.teleactorigin3.angles);
level.activ TakeAllWeapons();
level.activ GiveWeapon( "knife_mp" );
wait(0.05);
player switchToWeapon( "knife_mp" );
level.activ SwitchToWeapon( "knife_mp" );
level.teleknifeorigin delete();
iPrintLnBold(player.name+ "^0 has entered the ^0Knife Room"); //Change the message if you want
while( isAlive( player ) && isDefined( player ) )
            wait 1;
}
}

printCredits()
{
	if( isDefined( self.logoText ) )
		self.logoText destroy();

	self.logoText = newHudElem();
	self.logoText.y = 10;
	self.logoText.alignX = "center";
	self.logoText.alignY = "middle";
	self.logoText.horzAlign = "center_safearea";

	self.logoText.alpha = 0;
	self.logoText.sort = -3;
	self.logoText.fontScale = 1.6;
	self.logoText.archieved = true;

	for(;;)
	{
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^8---Map Made By Xenon---");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("^8---Thanks To Mikey,iMtroll,Mist,ERIK,Lossy---");
		wait 10;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 1;
		self.logoText setText("");
		wait 5;
		self.logoText fadeOverTime(1);
		self.logoText.alpha = 0;
		wait 1;
	}
}

jump_reset()
{
	trigger = getEnt ("jump_reset", "targetname");
	jumper = getEnt ("jumper_origin1", "targetname");
	activator = getEnt ("jump_teleportacti", "targetname");

	for(;;)
	{
		trigger waittill ("trigger", player);
		if(player.pers["team"] == "allies")
		{
			player SetOrigin(jumper.origin);
			player SetPlayerAngles( jumper.angles );
		}
		else if(player.pers["team"] == "axis")
		{
			player SetOrigin(activator.origin);
			player SetPlayerAngles( activator.angles );
		}
	}
}

easy1()
{
	et11 = getent("easy1","targetname");
	org11 = getent(et11.target, "targetname").origin;
	while (1)
	{
			et11 waittill ("trigger", user );

			user.easy_teleport = newClientHudElem(user);
			user.easy_teleport.x = 0;
			user.easy_teleport.y = 0;
			user.easy_teleport.alignX = "left";
			user.easy_teleport.alignY = "top";
			user.easy_teleport.horzAlign = "fullscreen";
			user.easy_teleport.vertAlign = "fullscreen";
			user.easy_teleport.alpha = 0;
			user.easy_teleport.color = (0,0,0);
			user.easy_teleport setshader("white", 640, 480);

			user.easy_teleport fadeOverTime(0.75);
			user.easy_teleport.alpha = 1;
			wait 1.25;

			user setOrigin(org11);

			user.easy_teleport fadeOverTime(0.75);
			user.easy_teleport.alpha = 0;
			wait 1;

			PlayFxOnTag( level.yes2_fx, user, "j_knee_le" );
	        PlayFxOnTag( level.yes2_fx, user, "j_knee_ri" );
	        PlayFxOnTag( level.yes2_fx, user, "j_ankle_le" );
	        PlayFxOnTag( level.yes2_fx, user, "j_ankle_ri" );

			user braxi\_rank::giveRankXP("", 100);
			iPrintLnBold(user.name+ "^8  Did The Hard CJ Secret, Fucking Nerd");

			user.easy_teleport destroy();

	}
}

theend()
{
	trigger = getent ("trigger_theend", "targetname");
	object2 = getEnt ("theend", "targetname");

	trigger waittill ("trigger", player );

    trigger delete();
	object2 delete();
	}

	song()
	{
	trigger = getent ("song", "targetname");

	trigger waittill ("trigger", player );

	trigger delete();
	AmbientStop( 1 );
    Ambientplay( "doxx" );
	self thread Text7();
	}

			text7()
{
    noti = SpawnStruct();
	noti.alignX = "center";
	noti.alignY = "center";
	noti.horzalign = "center";
	noti.vertalign = "center";
	noti.x = 0;
	noti.y = 0;
	noti.titleText = "^8You Found Something ...... Old";
	noti.duration = 10;
	noti.glowcolor = (1,0,0);
	// noti SetPulseFX( 40, 5400, 200 );
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		//self thread gem();

		}

easy3()
{
	et12 = getent("easy3","targetname");
	org11 = getent(et12.target, "targetname").origin;
	while (1)
	{
			et12 waittill ("trigger", user );

			user.easy_teleport = newClientHudElem(user);
			user.easy_teleport.x = 0;
			user.easy_teleport.y = 0;
			user.easy_teleport.alignX = "left";
			user.easy_teleport.alignY = "top";
			user.easy_teleport.horzAlign = "fullscreen";
			user.easy_teleport.vertAlign = "fullscreen";
			user.easy_teleport.alpha = 0;
			user.easy_teleport.color = (0,0,0);
			user.easy_teleport setshader("white", 640, 480);

			user.easy_teleport fadeOverTime(0.75);
			user.easy_teleport.alpha = 1;
			wait 1.25;

			user setOrigin(org11);

			user.easy_teleport fadeOverTime(0.75);
			user.easy_teleport.alpha = 0;
			wait 1;


			user braxi\_rank::giveRankXP("", 100);

			user.easy_teleport destroy();

			while(isAlive(user))
	{
		playFx( level.lostFX , user.origin );
		wait .1;
	}

	}
}

speed( trigger )
{
	if( !isDefined( trigger ) )
		return;

	while(1)
	{
		trigger waittill( "trigger", player );
		if( isDefined( player.speed ) )
			continue;
		player PlaySound( "doing" );
		player thread PushPlayer( trigger );
	}
}

PushPlayer( trigger )
{
	self endon("disconnect");

	self.speed = true;

	if(distance(trigger.origin, self.origin) > 400) // then the player tried to load-glitch the speed
	{
		self freezeControls(true);
		wait 0.1;
		self freezeControls(false);
	}

	else
	{
		target = getEnt(trigger.target, "targetname");
		speed = int(strTok(trigger.script_noteworthy, ",")[0]);

		self.health    = 1000000;
		self.maxhealth = 1000000;

		setDvar("g_knockback", (speed*9)-3000);
		self finishPlayerDamage(self, self, (speed*9)-3000, 0, "MOD_FALLING", "deserteaglegold_mp", trigger.origin, (trigger.origin - target.origin), "head", 0);
		wait 0.05;
		setDvar("g_knockback", level.knockback);

		self.health    = 100;
		self.maxhealth = 100;
	}

	while(self isTouching(trigger))
		wait 0.05;

	self.speed = undefined;
}

wall()
{
trigger = getEnt("trigger_wall", "targetname");
object1 = getEnt("wall1", "targetname");
object2 = getEnt("wall2", "targetname");
object3 = getEnt("wall3", "targetname");
object4 = getEnt("wall4", "targetname");
object5 = getEnt("wall5", "targetname");
object6 = getEnt("wall6", "targetname");
object7 = getEnt("wall7", "targetname");
object8 = getEnt("wall8", "targetname");
object9 = getEnt("wall9", "targetname");
object10 = getEnt("wall10", "targetname");
object11 = getEnt("wall11", "targetname");
object12 = getEnt("wall12", "targetname");
object13 = getEnt("wall13", "targetname");
object14 = getEnt("wall14", "targetname");
object15 = getEnt("wall15", "targetname");
object16 = getEnt("wall16", "targetname");
object17 = getEnt("wall17", "targetname");

trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object1 movey(40 , 0.1);
object1 waittill("movedone");
object2 movey(40 , 0.1);
object2 waittill("movedone");
object3 movey(40 , 0.1);
object3 waittill("movedone");
object4 movey(40 , 0.1);
object4 waittill("movedone");
object5 movey(40 , 0.1);
object5 waittill("movedone");
object6 movey(40 , 0.1);
object6 waittill("movedone");
object7 movey(40 , 0.1);
object7 waittill("movedone");
object8 movey(40 , 0.1);
object8 waittill("movedone");
object9 movey(40 , 0.1);
object9 waittill("movedone");
object10 movey(40 , 0.1);
object10 waittill("movedone");
object11 movey(40 , 0.1);
object11 waittill("movedone");
object12 movey(40 , 0.1);
object12 waittill("movedone");
object13 movey(40 , 0.1);
object13 waittill("movedone");
object14 movey(40 , 0.1);
object14 waittill("movedone");
object15 movey(40 , 0.1);
object15 waittill("movedone");
object16 movey(40 , 0.1);
object16 waittill("movedone");
object17 movey(40 , 0.1);
object17 waittill("movedone");
wait 0.1;
object1 movey(-40 , 0.1);
object1 waittill("movedone");
object2 movey(-40 , 0.1);
object2 waittill("movedone");
object3 movey(-40 , 0.1);
object3 waittill("movedone");
object4 movey(-40 , 0.1);
object4 waittill("movedone");
object5 movey(-40 , 0.1);
object5 waittill("movedone");
object6 movey(-40 , 0.1);
object6 waittill("movedone");
object7 movey(-40 , 0.1);
object7 waittill("movedone");
object8 movey(-40 , 0.1);
object8 waittill("movedone");
object9 movey(-40 , 0.1);
object9 waittill("movedone");
object10 movey(-40 , 0.1);
object10 waittill("movedone");
object11 movey(-40 , 0.1);
object11 waittill("movedone");
object12 movey(-40 , 0.1);
object12 waittill("movedone");
object13 movey(-40 , 0.1);
object13 waittill("movedone");
object14 movey(-40 , 0.1);
object14 waittill("movedone");
object15 movey(-40 , 0.1);
object15 waittill("movedone");
object16 movey(-40 , 0.1);
object16 waittill("movedone");
object17 movey(-40 , 0.1);
object17 waittill("movedone");
wait 0.1;
}
}

wall2()
{
trigger = getEnt("trigger_wall2", "targetname");
object1 = getEnt("wall18", "targetname");
object2 = getEnt("wall19", "targetname");
object3 = getEnt("wall20", "targetname");
object4 = getEnt("wall21", "targetname");
object5 = getEnt("wall22", "targetname");
object6 = getEnt("wall23", "targetname");
object7 = getEnt("wall24", "targetname");
object8 = getEnt("wall25", "targetname");
object9 = getEnt("wall26", "targetname");
object10 = getEnt("wall27", "targetname");
object11 = getEnt("wall28", "targetname");
object12 = getEnt("wall29", "targetname");
object13 = getEnt("wall30", "targetname");
object14 = getEnt("wall31", "targetname");
object15 = getEnt("wall32", "targetname");
object16 = getEnt("wall33", "targetname");
object17 = getEnt("wall34", "targetname");

trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object1 movey(40 , 0.1);
object1 waittill("movedone");
object2 movey(40 , 0.1);
object2 waittill("movedone");
object3 movey(40 , 0.1);
object3 waittill("movedone");
object4 movey(40 , 0.1);
object4 waittill("movedone");
object5 movey(40 , 0.1);
object5 waittill("movedone");
object6 movey(40 , 0.1);
object6 waittill("movedone");
object7 movey(40 , 0.1);
object7 waittill("movedone");
object8 movey(40 , 0.1);
object8 waittill("movedone");
object9 movey(40 , 0.1);
object9 waittill("movedone");
object10 movey(40 , 0.1);
object10 waittill("movedone");
object11 movey(40 , 0.1);
object11 waittill("movedone");
object12 movey(40 , 0.1);
object12 waittill("movedone");
object13 movey(40 , 0.1);
object13 waittill("movedone");
object14 movey(40 , 0.1);
object14 waittill("movedone");
object15 movey(40 , 0.1);
object15 waittill("movedone");
object16 movey(40 , 0.1);
object16 waittill("movedone");
object17 movey(40 , 0.1);
object17 waittill("movedone");
wait 0.1;
object1 movey(-40 , 0.1);
object1 waittill("movedone");
object2 movey(-40 , 0.1);
object2 waittill("movedone");
object3 movey(-40 , 0.1);
object3 waittill("movedone");
object4 movey(-40 , 0.1);
object4 waittill("movedone");
object5 movey(-40 , 0.1);
object5 waittill("movedone");
object6 movey(-40 , 0.1);
object6 waittill("movedone");
object7 movey(-40 , 0.1);
object7 waittill("movedone");
object8 movey(-40 , 0.1);
object8 waittill("movedone");
object9 movey(-40 , 0.1);
object9 waittill("movedone");
object10 movey(-40 , 0.1);
object10 waittill("movedone");
object11 movey(-40 , 0.1);
object11 waittill("movedone");
object12 movey(-40 , 0.1);
object12 waittill("movedone");
object13 movey(-40 , 0.1);
object13 waittill("movedone");
object14 movey(-40 , 0.1);
object14 waittill("movedone");
object15 movey(-40 , 0.1);
object15 waittill("movedone");
object16 movey(-40 , 0.1);
object16 waittill("movedone");
object17 movey(-40 , 0.1);
object17 waittill("movedone");
wait 0.1;
}
}

wall3()
{
trigger = getEnt("trigger_wall3", "targetname");
object1 = getEnt("wall35", "targetname");
object2 = getEnt("wall36", "targetname");
object3 = getEnt("wall37", "targetname");
object4 = getEnt("wall38", "targetname");
object5 = getEnt("wall39", "targetname");
object6 = getEnt("wall40", "targetname");
object7 = getEnt("wall41", "targetname");
object8 = getEnt("wall42", "targetname");
object9 = getEnt("wall43", "targetname");
object10 = getEnt("wall44", "targetname");
object11 = getEnt("wall45", "targetname");
object12 = getEnt("wall46", "targetname");
object13 = getEnt("wall47", "targetname");
object14 = getEnt("wall48", "targetname");
object15 = getEnt("wall49", "targetname");
object16 = getEnt("wall50", "targetname");
object17 = getEnt("wall51", "targetname");

trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object1 movey(40 , 0.1);
object1 waittill("movedone");
object2 movey(40 , 0.1);
object2 waittill("movedone");
object3 movey(40 , 0.1);
object3 waittill("movedone");
object4 movey(40 , 0.1);
object4 waittill("movedone");
object5 movey(40 , 0.1);
object5 waittill("movedone");
object6 movey(40 , 0.1);
object6 waittill("movedone");
object7 movey(40 , 0.1);
object7 waittill("movedone");
object8 movey(40 , 0.1);
object8 waittill("movedone");
object9 movey(40 , 0.1);
object9 waittill("movedone");
object10 movey(40 , 0.1);
object10 waittill("movedone");
object11 movey(40 , 0.1);
object11 waittill("movedone");
object12 movey(40 , 0.1);
object12 waittill("movedone");
object13 movey(40 , 0.1);
object13 waittill("movedone");
object14 movey(40 , 0.1);
object14 waittill("movedone");
object15 movey(40 , 0.1);
object15 waittill("movedone");
object16 movey(40 , 0.1);
object16 waittill("movedone");
object17 movey(40 , 0.1);
object17 waittill("movedone");
wait 0.1;
object1 movey(-40 , 0.1);
object1 waittill("movedone");
object2 movey(-40 , 0.1);
object2 waittill("movedone");
object3 movey(-40 , 0.1);
object3 waittill("movedone");
object4 movey(-40 , 0.1);
object4 waittill("movedone");
object5 movey(-40 , 0.1);
object5 waittill("movedone");
object6 movey(-40 , 0.1);
object6 waittill("movedone");
object7 movey(-40 , 0.1);
object7 waittill("movedone");
object8 movey(-40 , 0.1);
object8 waittill("movedone");
object9 movey(-40 , 0.1);
object9 waittill("movedone");
object10 movey(-40 , 0.1);
object10 waittill("movedone");
object11 movey(-40 , 0.1);
object11 waittill("movedone");
object12 movey(-40 , 0.1);
object12 waittill("movedone");
object13 movey(-40 , 0.1);
object13 waittill("movedone");
object14 movey(-40 , 0.1);
object14 waittill("movedone");
object15 movey(-40 , 0.1);
object15 waittill("movedone");
object16 movey(-40 , 0.1);
object16 waittill("movedone");
object17 movey(-40 , 0.1);
object17 waittill("movedone");
wait 0.1;
}
}

wall4()
{
trigger = getEnt("trigger_wall4", "targetname");
object1 = getEnt("wall52", "targetname");
object2 = getEnt("wall53", "targetname");
object3 = getEnt("wall54", "targetname");
object4 = getEnt("wall55", "targetname");
object5 = getEnt("wall56", "targetname");
object6 = getEnt("wall57", "targetname");
object7 = getEnt("wall58", "targetname");
object8 = getEnt("wall59", "targetname");
object9 = getEnt("wall60", "targetname");
object10 = getEnt("wall61", "targetname");
object11 = getEnt("wall62", "targetname");
object12 = getEnt("wall63", "targetname");
object13 = getEnt("wall64", "targetname");
object14 = getEnt("wall65", "targetname");
object15 = getEnt("wall66", "targetname");
object16 = getEnt("wall67", "targetname");
object17 = getEnt("wall68", "targetname");
object18 = getEnt("wall69", "targetname");

trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object1 movey(40 , 0.1);
object1 waittill("movedone");
object2 movey(40 , 0.1);
object2 waittill("movedone");
object3 movey(40 , 0.1);
object3 waittill("movedone");
object4 movey(40 , 0.1);
object4 waittill("movedone");
object5 movey(40 , 0.1);
object5 waittill("movedone");
object6 movey(40 , 0.1);
object6 waittill("movedone");
object7 movey(40 , 0.1);
object7 waittill("movedone");
object8 movey(40 , 0.1);
object8 waittill("movedone");
object9 movey(40 , 0.1);
object9 waittill("movedone");
object10 movey(40 , 0.1);
object10 waittill("movedone");
object11 movey(40 , 0.1);
object11 waittill("movedone");
object12 movey(40 , 0.1);
object12 waittill("movedone");
object13 movey(40 , 0.1);
object13 waittill("movedone");
object14 movey(40 , 0.1);
object14 waittill("movedone");
if (isDefined(object15)) {
	object15 movey(40 , 0.1);
	object15 waittill("movedone");
}
if (isDefined(object16)) {
	object16 movey(40 , 0.1);
	object16 waittill("movedone");
}
object17 movey(40 , 0.1);
object17 waittill("movedone");
object18 movey(40 , 0.1);
object18 waittill("movedone");
wait 0.1;
object1 movey(-40 , 0.1);
object1 waittill("movedone");
object2 movey(-40 , 0.1);
object2 waittill("movedone");
object3 movey(-40 , 0.1);
object3 waittill("movedone");
object4 movey(-40 , 0.1);
object4 waittill("movedone");
object5 movey(-40 , 0.1);
object5 waittill("movedone");
object6 movey(-40 , 0.1);
object6 waittill("movedone");
object7 movey(-40 , 0.1);
object7 waittill("movedone");
object8 movey(-40 , 0.1);
object8 waittill("movedone");
object9 movey(-40 , 0.1);
object9 waittill("movedone");
object10 movey(-40 , 0.1);
object10 waittill("movedone");
object11 movey(-40 , 0.1);
object11 waittill("movedone");
object12 movey(-40 , 0.1);
object12 waittill("movedone");
object13 movey(-40 , 0.1);
object13 waittill("movedone");
object14 movey(-40 , 0.1);
object14 waittill("movedone");
if (isDefined(object15)) {
	object15 movey(-40 , 0.1);
	object15 waittill("movedone");
}
if (isDefined(object16)) {
	object16 movey(-40 , 0.1);
	object16 waittill("movedone");
}
object17 movey(-40 , 0.1);
object17 waittill("movedone");
object18 movey(-40 , 0.1);
object18 waittill("movedone");
wait 0.1;
}
}