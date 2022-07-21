main()
{
thread sr\api\_map::createSpawnOrigin((483, -340, 256), 360);
maps\mp\_load::main();
maps\mp\_teleport::main();

		thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_speedrun::createTeleporter((794.87, -66.6879, 256.125), 60, 10, (-3006, -60, 2604), 360, "freeze", "blue", "secret_0");

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
	thread entdel();
	thread bounceopen();
	thread redlift();
	thread flip();
	thread flip2();
	//thread redring();
	//thread redring2();
	thread lift2();
	thread secondlift();
	thread triangledoor();
	//thread spinner();
	thread weewee();
	thread deathroll();
	//thread pillar();
	//thread dna();
	thread wall();
	thread wall2();
	thread wall3();
	thread theend();
	thread wall4();
	//thread slam();
	thread bridge();
	//thread killcube();
	thread spin();
	//thread jump();
	//thread jump_reset();
	thread jump();
	thread easy1();

}
startdoor()
{
doorleft = getent("leftopen","targetname");
doorright = getent("rightopen","targetname");

wait 0.1;
doorleft delete();
doorright delete();
}

entdel()
{
   tele = getent ("gohere101", "targetname");

    level waittill("round_started");

	tele delete();
}

redlift()
{
trigger = getEnt("trigger_redlift", "targetname");
object = getEnt("redlift", "targetname");
object2 = getEnt ("movetrap1", "targetname");
trigger waittill ("trigger" , player );

trigger delete();

}

redring()
{
trigger = getEnt("trigger_redring", "targetname");
object = getEnt("redring", "targetname");
trigger waittill ("trigger" , player );

trigger delete();

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
object = getEnt("secondlift", "targetname");

wait 0.1;
object delete();

}

triangledoor()
{
object1 = getEnt("tri1", "targetname");
object2 = getEnt("tri2", "targetname");
object3 = getEnt("tri3", "targetname");
object4 = getEnt("tri4", "targetname");

wait 0.1;
object1 delete();
object2 delete();
object3 delete();
object4 delete();

}

spinner()
{
brush = getent ("spinner", "targetname");
object2 = getEnt ("movetrap3", "targetname");
brush2 = getent ("spinner2", "targetname");
brush3 = getent ("spinner3", "targetname");
brush4 = getent ("spinner4", "targetname");
brush5 = getent ("spinner5", "targetname");
brush6 = getent ("spinner6", "targetname");
brush7 = getent ("spinner7", "targetname");

wait 0.1;
brush delete();
brush2 delete();
brush3 delete();
brush4 delete();
brush5 delete();
brush6 delete();
brush7 delete();
object2 delete();

}

weewee()
{
brush = getent ("weewee", "targetname");
object2 = getEnt ("movetrap2", "targetname");
killtrigger2 = getent ("killtrig2" , "targetname");
killtrigger3 = getent ("killtrig3" , "targetname");

wait 0.1;

brush delete();
object2 delete();
killtrigger2 delete();
killtrigger3 delete();


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

bounceopen()
{
object2 = getEnt ("bounceopen2", "targetname");

while(1)
{
level waittill("round_started");
object2 show();
object2 solid();
}
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


deathroll()
{
brush3 = getent ("deathroll", "targetname");
object2 = getEnt ("movetrap4", "targetname");

wait 0.1;
brush3 delete();
object2 delete();
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
	trig = getent("easy1","targetname");

	for(;;)
	{
    trig waittill("trigger", player);
    player thread sr\api\_speedrun::finishWay("secret_0");
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

}