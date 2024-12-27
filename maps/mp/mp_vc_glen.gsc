// __/\\\________/\\\_______________________________________________________________________/\\\\\\\\\__/\\\\\\_________________________________
//  _\/\\\_______\/\\\____________________________________________________________________/\\\////////__\////\\\_________________________________
//   _\//\\\______/\\\___/\\\__________________/\\\_______/\\\___________________________/\\\/______________\/\\\_________________________________
//   __\//\\\____/\\\___\///___/\\\\\\\\\\__/\\\\\\\\\\\_\///______/\\\\\\\\____________/\\\________________\/\\\_____/\\\\\\\\\_____/\\/\\\\\\___
//    ___\//\\\__/\\\_____/\\\_\/\\\//////__\////\\\////___/\\\___/\\\//////____________\/\\\________________\/\\\____\////////\\\___\/\\\////\\\__
//     ____\//\\\/\\\_____\/\\\_\/\\\\\\\\\\____\/\\\______\/\\\__/\\\___________________\//\\\_______________\/\\\______/\\\\\\\\\\__\/\\\__\//\\\_
//      _____\//\\\\\______\/\\\_\////////\\\____\/\\\_/\\__\/\\\_\//\\\___________________\///\\\_____________\/\\\_____/\\\/////\\\__\/\\\___\/\\\_
//       ______\//\\\_______\/\\\__/\\\\\\\\\\____\//\\\\\___\/\\\__\///\\\\\\\\______________\////\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\/\\_\/\\\___\/\\\_
//        _______\///________\///__\//////////______\/////____\///_____\////////__________________\/////////__\/////////___\////////\//__\///____\///__

/*
     _   ________   _______
    | | / / ___( ) / ___/ /__ ___
    | |/ / /__ |/ / (_ / / -_) _ \
    |___/\___/    \___/_/\__/_//_/

    © VC' Glen
*/

main()
{
    maps\mp\_load::main();

    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((-2416, 1808,-1236), 0);

	if(!isdefined(level.music))
    level.music=[];
    level.music[0]["song"]    ="Flava D - The Buzz";
    level.music[0]["alias"]    ="sky1";
    level.music[1]["song"]    ="Pal - Shook";
    level.music[1]["alias"]    ="sky2";
    level.music[2]["song"]    ="Clayjay - Done";
    level.music[2]["alias"]    ="sky3";
    level.music[3]["song"]    ="DJ Zinc - Nexx";
    level.music[3]["alias"]    ="sky4";
    level.music[4]["song"]    ="TQD - Day and Night";
    level.music[4]["alias"]    ="sky5";

	setDvar("bg_falldamagemaxheight", 20000 );
	setDvar("bg_falldamageminheight", 10000 );

	//level._effect["explo"] = loadfx("explosions/small_vehicle_explosion");

 	precacheModel("body_mp_opforce_eningeer");
 	precacheModel("head_sp_opforce_ski_mask_body_a");
 	precacheModel("body_mp_opforce_sniper");
 	precacheModel("head_mp_opforce_ghillie");
 	precacheModel("body_mp_sas_urban_specops");

	precacheItem("super_deagle_mp");
	precacheItem("c4_mp");
	precacheItem("glengun_mp");
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");

	level.oldblock = getEnt("oldroom_block", "targetname");
	level.obstacles = getEnt("old_obstacles", "targetname");

	level.obstacles hide();
	level.oldblock hide();

    //Stuff
    //thread messages();
	thread sr_sec_enter();
	thread sr_tp();
    thread startdoor();
	//thread EndMessage();
	//thread EleMessage();
	//thread Sign();
	//thread Logo();
	thread OpenDoor1();
	thread OpenDoor2();
	//thread Bouncer();
	//thread ActiWeapon();
	//thread Mantle();
	//thread musicBox();

	//Secrets
	//thread teleport1();
	thread secret1();
	thread secret2();
	thread secretfail();
	thread secretstring();
	thread secretButton();
	thread CjFall1();
	thread CjFall2();
	thread CjFall3();
	thread CjFall4();
	thread CjFall5();
	thread CjFinish();

	//Traps
	/*thread Trap1();
	thread Trap2a();
	thread Trap3();
	thread Trap4();
	thread Trap5();
	thread Trap6();
	thread Trap6a();
	thread Trap7();
	thread Trap8();
	thread Trap9();
	thread Trap10();*/
	thread Trap2();
	thread Trap7a();
	thread Trap10a();
	thread Trap10b();
	thread Trap10c();
	thread Trap10d();
	thread Trap10e();
	thread Trap10f();
	thread Trap10g();
	thread Trap10h();

	//Endrooms
	/*thread EndroomOld();
	thread EndroomLadder();
	thread EndroomSniper();
	thread EndroomBounce();
	thread ladderfall1();
	thread ladderfall2();
	thread LadderWeapon();
	thread SniperFall();
	thread BounceFall1();
	thread BounceFall2();
	thread LadderSniper();
	thread BounceSniper();
	thread BounceWeapon();*/

	//Connection
	//thread onPlayerConnect();


    // Freerun


	/////Trigger-List/////
	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
	addTriggerToList("trig_trap9");
	addTriggerToList("trig_trap10");


}

// Freerun Delete just in case for AFK Activator



addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}

sr_sec_enter()
{
	trig = spawn("trigger_radius",(-2416.04, 1965.12, -1295.88), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("cj_origin1","targetname");

	thread sr\api\_map::createTriggerFx(trig, "green");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0");

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player thread sr_tp_safe(ori);
	}
}

sr_tp()
{
	trig = getEnt("bouncepad1","targetname");

	ori = spawn("script_origin",(2474,5421,-1251));
	ori.angles = (0,180,0);

	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player thread sr_tp_safe(ori);
	}
}
sr_tp_safe(ori)
{
	self endon("death");
	self endon("disconnect");

	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}
messages()
{
    wait 10;
	iPrintLnBold("Welcome to my ^1first ever ^7map!");
	wait 2;
    iPrintLnBold("Map created by ^1VC' Glen :D^7!");
}

startdoor()
{
	trig = getEnt("trig_startdoor", "targetname");
    door = getEnt("StartDoor","targetname");

	door delete();
}

Mantle()
{
	trig = getEnt("mantle", "targetname");
	trig setHintString("^1Mantle!");

	// trig waittill("trigger", user); 			//was for testing
	// {
	// trig setHintString("^1Work");
	// user detachAll();
	// user setModel( "body_mp_sas_urban_specops" );
	// user takeAllWeapons();
	// user giveWeapon( "glengun_mp" );
	// user giveMaxAmmo( "glengun_mp" );
	// user giveWeapon( "super_deagle_mp" );
	// user giveMaxAmmo( "super_deagle_mp" );
	// user switchToWeapon( "super_deagle_mp" );
	// }
}

secret1()
{
	Hash = getEnt("trig_hashtag", "targetname");
	secret1Wall = getEnt("secret1_wall", "targetname");
	Deathtrig = getEnt("secret1_hurt", "targetname");


	Hash waittill("trigger", player);
	Deathtrig delete();
	secret1Wall notSolid();
	level.secretstring delete();
	iPrintln("^1#Glen>");
}

secret2()
{
	secret2Wall = getEnt("secret2_wall", "targetname");
	Hash = getEnt("trig_hashtag", "targetname");

	Hash waittill("trigger", player);
	secret2Wall notSolid();

}

secretstring()
{

	level.secretstring = getEnt("secretstring", "targetname");

	while(1)
	{
	level.secretstring setHintString("^1>>^7 Secret isn't open :/");
	wait 2;
	level.secretstring setHintString("^1>>^7 Press ^1&&1 ^7to exit");
	wait 2;
	}


}

secretfail()
{
	trig = getEnt("secretstring", "targetname");
	tele1 = getEnt("secretfail", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

teleport1()
{
	trig = getEnt("trig_teleport1", "targetname");
	tele1 = getEnt("cj_origin1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			iPrintLnBold("^1>> " + player.name + " ^7Has Entered The Secret!");
			player thread secret_timer_easy();
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}

}

secretButton()
{
	Button = getEnt("trig_secretbutton", "targetname");
	tele1 = getEnt("origin_secretbutton", "targetname");

	Button setHintString("^1>>^7 Press ^1&&1 To Teleport");

	for(;;)
	{
	Button waittill("trigger", player);

	player takeAllWeapons();
	player giveWeapon("m40a3_mp");
	player giveMaxAmmo("m40a3_mp");
	player giveWeapon( "deserteaglegold_mp" );
	player giveMaxAmmo( "deserteaglegold_mp" );
	player switchToWeapon("m40a3_mp");

	player setOrigin(tele1.origin);
	player setPlayerAngles(tele1.angles);

	player braxi\_rank::giveRankXP("", 300);
	iPrintLnBold("^1>>^7 " + player.name + " Knows How To ^1Elevate!?");
	}

}

CjFall1()
{
	trig = getEnt("cj_teleport1", "targetname");
	tele1 = getEnt("cj_origin1", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

CjFall2()
{
	trig = getEnt("cj_teleport2", "targetname");
	tele1 = getEnt("cj_origin3", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

CjFall3()
{
	trig = getEnt("cj_teleport3", "targetname");
	tele1 = getEnt("cj_origin4", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}
CjFall4()
{
	trig = getEnt("cj_teleport4", "targetname");
	tele1 = getEnt("cj_origin5", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}

CjFall5()
{
	trig = getEnt("cj_teleport5", "targetname");
	tele1 = getEnt("cj_origin6", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player Suicide();
		}
}
CjFinish()
{
	trig = getEnt("cj_finish", "targetname");
	tele1 = getEnt("cj_end", "targetname");
	trig setHintString("^1>>^7 Press ^1&&1 ^7to complete!");


	for(;;)
	{
	trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");
	}
}

Trap1()
{

	spike = getEnt("thespikes", "targetname");
	trig = getEnt("trig_trap1", "targetname");
	hurt = getEnt("hurt_spikes", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Activate Spikes!");
	trig waittill("trigger", player);

	hurt EnableLinkTo();
	hurt LinkTo(spike);

	spike moveZ(420,1);
	wait 5;
	spike moveZ(-420,2);
	wait 2;

	trig delete();

}


Trap2()
{
	block1 = getEnt("spintrap1", "targetname");
	block2 = getEnt("spintrap2", "targetname");
	block3 = getEnt("spintrap3", "targetname");
	block4 = getEnt("spintrap4", "targetname");

    {
	block1 moveY(-381,0.1);
	block2 moveY(381,0.1);
	block3 moveY(381,0.1);
	block4 delete();
	wait 0.3;
	block1 moveX(50,0.1);
	block2 moveX(400,0.1);
	//block3 moveX(150,0.1);
    }

}

Trap2a()
{
	trig = getEnt("trig_trap2", "targetname");
	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Speed Up The Platforms!");
	trig waittill("trigger", player);

	//level.blockspeed = 2;
}

Trap3()
{
	upplat = getEnt("trap2up", "targetname");
	downplat = getEnt("trap2down", "targetname");
	trig = getEnt("trig_trap3", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Move The Platforms!");
	trig waittill("trigger", player);

	for(;;)
	{

		upplat moveZ(-150,1.5);
		downplat moveZ(150,1.5);
		wait 1.5;
		upplat moveZ(300,3);
		downplat moveZ(-300,3);
		wait 3;
		upplat moveZ(-150,1.5);
		downplat moveZ(150,1.5);
		wait 1.5;

	}
	trig delete();
}

Trap4()
{
	spin = getEnt("trap4", "targetname");
	trig = getEnt("trig_trap4", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Spin!");
	trig waittill("trigger", player);

	for(;;)
	{
	spin rotateYaw(360, 4);
	wait 6;
	}

	trig delete();
}

Trap5()
{
	trig = getEnt("trig_trap5", "targetname");

	number = randomInt(10);

	trig setHintString("^1>>^7 Press ^1 &&1 ^7 to Remove Part Of Ladder!");
	trig waittill("trigger", player);

	if (number <= 5) {
	thread Trap5a();
	}
	else {
	thread Trap5b();
	}

}

Trap5a()
{
	wall = getEnt("laddertrap1", "targetname");
	wall delete();
}

Trap5b()
{
	wall = getEnt("laddertrap2", "targetname");
	wall delete();
}

Trap6()
{
	plat = getEnt("trap6_plat", "targetname");
	trig = getEnt("trig_trap6", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Make Non-Solid!");
	trig waittill("trigger", player);

	trig delete();
	iPrintLn("^1 Platform Will Become Non-Solid In:");
	wait 1;
	iPrintLn("^1 3");
	wait 1;
	iPrintLn("^1 2");
	wait 1;
	iPrintLn("^1 1");
	wait 1;
	iPrintLn("^9Platform is non-solid");
	plat notSolid();
	wait 5;

	plat solid();
	iPrintLn("^2 Platform is solid again");

}

Trap6a()
{
	plat = getEnt("trap6_plat", "targetname");

	for(;;)
	{
	plat moveY(2200, 5);
	wait 6.5;
	plat moveY(-2200, 5);
	wait 6.5;
	}

}

Trap7()
{
	trig = getEnt("trig_trap7", "targetname");

	c4h1 = getEnt("c4hole1", "targetname"); //Hole in floor
	c4h2 = getEnt("c4hole2", "targetname");
	c4h3 = getEnt("c4hole3", "targetname");
	c4h4 = getEnt("c4hole4", "targetname");

	c41 = getEnt("c41", "targetname"); //C4 Model
	c42 = getEnt("c42", "targetname");
	c43 = getEnt("c43", "targetname");
	c44 = getEnt("c44", "targetname");

	fx_point1 = getEnt ("origin_c41", "targetname"); //Explosion effect
	fx_point2 = getEnt ("origin_c42", "targetname");
	fx_point3 = getEnt ("origin_c43", "targetname");
	fx_point4 = getEnt ("origin_c44", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Cause an Explosion!");

	trig waittill("trigger", player);

	if (isDefined(c4h1)) {
	c4h1 delete();
	}
	if (isDefined(c4h2)) {
	c4h2 delete();
	}
	if (isDefined(c4h3))	{
	c4h3 delete();
	}
	if (isDefined(c4h4))	{
	c4h4 delete();
	}
	if(isDefined(c41))	{
	c41 delete();
	}
	if (isDefined(c42)) 	{
	c42 delete();
	}
	if (isDefined(c43)) 	{
	c43 delete();
	}
	if (isDefined(c44))	{
	c44 delete();
	}

	playfx(level._effect["explo"],fx_point1.origin);
	playfx(level._effect["explo"],fx_point2.origin);
	playfx(level._effect["explo"],fx_point3.origin);
	playfx(level._effect["explo"],fx_point4.origin);

	earthquake(1,1,fx_point1.origin,50);
	earthquake(1,1,fx_point2.origin,50);
	earthquake(1,1,fx_point3.origin,50);
	earthquake(1,1,fx_point4.origin,50);

	p = getEntArray("player","classname");
	for(i=0;i<p.size;i++)
	{
		dist1 = distance(p[i].origin,fx_point1.origin);
		dist2 = distance(p[i].origin,fx_point2.origin);
		dist3 = distance(p[i].origin,fx_point3.origin);
		dist4 = distance(p[i].origin,fx_point4.origin);

		if ((dist1<100) || (dist2<100) || (dist3<100) || (dist4<100))
			p[i] suicide();
		else if ((dist1<150) || (dist2<150) || (dist3<150) || (dist4<150))
			radiusDamage(p[i].origin,10,40,20);
		else if ((dist1<200) || (dist2<200) || (dist3<200) || (dist4<200))
			radiusDamage(p[i].origin,10,20,10);
	}
}

Trap7a()
{

	c4h1 = getEnt("c4hole1", "targetname"); //Hole in floor
	c4h2 = getEnt("c4hole2", "targetname");
	c4h3 = getEnt("c4hole3", "targetname");
	c4h4 = getEnt("c4hole4", "targetname");

	c41 = getEnt("c41", "targetname"); //C4 Model
	c42 = getEnt("c42", "targetname");
	c43 = getEnt("c43", "targetname");
	c44 = getEnt("c44", "targetname");

    c4h1 delete();
	c4h2 delete();
	c4h3 delete();
	c4h4 delete();

	c41 delete();
	c42 delete();
	c43 delete();
	c44 delete();

}

Trap8()
{
	trig = getEnt("trig_trap8", "targetname");
	blocker = getEnt("blocker", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Block the Jump!");
	trig waittill("trigger", player);

	blocker rotatePitch(90,1,0.2,0);
	wait 10;
	blocker rotatePitch(-90,3,1,1);
	wait 3;
}

Trap9()
{
	trig = getEnt("trig_trap9", "targetname");
	trig setHintString("^1>>^7 Press ^1&&1 ^7 to remove some of the bounces!");

	bounce1 = getEnt("bounceremove1", "targetname");
	bounce2 = getEnt("bounceremove2", "targetname");
	bounce3 = getEnt("bounceremove3", "targetname");

	trig waittill("trigger", player);

	number = randomInt(10);

	if (number == 9){
		bounce1 delete();
	}
	if (number >= 7 && number < 9) {
		bounce2 delete();
	}
	if (number >= 5 && number < 7) {
		bounce3 delete();
	}
	if (number >= 3 && number < 5) {
		bounce1 delete();
		bounce2 delete();
	}
	if (number >= 1 && number < 3) {
		bounce2 delete();
		bounce3 delete();
	}
	if (number == 10) {
		bounce1 delete();
		bounce3 delete();
	}

}

Trap10()
{
	trig = getEnt("trig_trap10", "targetname");
	trig setHintString("^1>>^7 Press ^1&&1 ^7 to increase spin speed!");

	trig waittill("trigger", player);

	level.spinspeed1 = (level.spinspeed1 - 1);
	level.spinangle1 = (level.spinangle1 - 50);

	if (level.spinangle1 < -360) {
	level.spinangle1 = -360;
	}

	if (level.spinspeed1 <= 0) {
	level.spinspeed1 = 2;
	}

	//////////////////////////////////////////////

	level.spinspeed2 = (level.spinspeed2 - 1);
	level.spinangle2 = (level.spinangle2 + 50);

	if (level.spinangle2 > 360) {
	level.spinangle2 = 360;
	}

	if (level.spinspeed2 <= 0) {
	level.spinspeed2 = 2;
	}

	/////////////////////////////////////////////
	level.spinspeed3 = (level.spinspeed3 - 1);
	level.spinangle3 = (level.spinangle3 - 50);

	if (level.spinangle3 < -360) {
	level.spinangle3 = -360;
	}

	if (level.spinspeed3 <= 0) {
	level.spinspeed3 = 2;
	}

	//////////////////////////////////////////////
	level.spinspeed4 = (level.spinspeed4 - 1);
	level.spinangle4 = (level.spinangle4 + 50);

	if (level.spinangle4 > 360) {
	level.spinangle4 = 360;
	}

	if (level.spinspeed4 <= 0) {
	level.spinspeed4 = 2;
	}

	//////////////////////////////////////////////
	level.spinspeed5 = (level.spinspeed5 - 1);
	level.spinangle5 = (level.spinangle5 + 50);

	if (level.spinangle5 > 360) {
	level.spinangle5 = 360;
	}

	if (level.spinspeed5 <= 0) {
	level.spinspeed5 = 2;
	}

	//////////////////////////////////////////////
	level.spinspeed6 = (level.spinspeed6 - 1);
	level.spinangle6 = (level.spinangle6 - 50);

	if (level.spinangle6 < -360) {
	level.spinangle6 = -360;
	}

	if (level.spinspeed6 <= 0) {
	level.spinspeed6 = 2;
	}

	//////////////////////////////////////////////
	level.spinspeed7 = (level.spinspeed7 - 1);
	level.spinangle7 = (level.spinangle7 - 50);

	if (level.spinangle7 < -360) {
	level.spinangle7 = -360;
	}

	if (level.spinspeed7 <= 0) {
	level.spinspeed7 = 2;
	}

	//////////////////////////////////////////////
	level.spinspeed8 = (level.spinspeed8 - 1);
	level.spinangle8 = (level.spinangle8 + 50);

	if (level.spinangle8 > 360) {
	level.spinangle8 = 360;
	}

	if (level.spinspeed8 <= 0) {
	level.spinspeed8 = 2;
	}

	//////////////////////////////////////////////

}

Trap10a()
{
	spikes = getEnt("turnspikes1", "targetname");
	hurt = getEnt("hurt_spin1", "targetname");


	spikes delete();
	hurt delete();

}

Trap10b()
{
	spikes = getEnt("turnspikes2", "targetname");
	hurt = getEnt("hurt_spin2", "targetname");

	spikes delete();
	hurt delete();
}

Trap10c()
{
	spikes = getEnt("turnspikes3", "targetname");
	hurt = getEnt("hurt_spin3", "targetname");

	spikes delete();
	hurt delete();
}

Trap10d()
{
	spikes = getEnt("turnspikes4", "targetname");
	hurt = getEnt("hurt_spin4", "targetname");

	spikes delete();
	hurt delete();
}

Trap10e()
{
	spikes = getEnt("turnspikes5", "targetname");
	hurt = getEnt("hurt_spin5", "targetname");

	spikes delete();
	hurt delete();
}

Trap10f()
{
	spikes = getEnt("turnspikes6", "targetname");
	hurt = getEnt("hurt_spin6", "targetname");

	spikes delete();
	hurt delete();
}

Trap10g()
{
	spikes = getEnt("turnspikes7", "targetname");
	hurt = getEnt("hurt_spin7", "targetname");

	spikes delete();
	hurt delete();
}

Trap10h()
{
	spikes = getEnt("turnspikes8", "targetname");
	hurt = getEnt("hurt_spin8", "targetname");

	spikes delete();
	hurt delete();
}

EndMessage()
{
     trig = getEnt("message_trigger", "targetname");
     trig waittill("trigger" ,player);

    // hud_clock = NewHudElem();
    // hud_clock.alignX = "center";
    // hud_clock.alignY = "middle";
    // hud_clock.horzalign = "center";
    // hud_clock.vertalign = "middle";
    // hud_clock.alpha = 1;
    // hud_clock.x = 0;
    // hud_clock.y = 0;
    // hud_clock.font = "objective";
    // hud_clock.fontscale = 2;
    // hud_clock.glowalpha = 5;
    // hud_clock.glowcolor = (9,9,9);
	// hud_clock.label = &"^2Glenbob ^4Is ^3A ^6Fookin' ^8Nub ^1!!!";
    // hud_clock SetPulseFX( 40, 5400, 200 );

	// trig delete();

	iPrintLnBold("^1>> " + player.name + " ^7Has Finished First^1!!!");
	thread Credits();
	trig delete();
}


EleMessage()
{
	trig = getEnt("testtrigger", "targetname");
	trig waittill("trigger", player);
	player iPrintLnBold("Ooooh a secret? ^1:3");

	tele1 = getEnt("origin_elevator", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}


}

EndroomOld()
{
	trig = getEnt("trig_room1", "targetname");
	door = getEnt("door_oldroom", "targetname");
	oldblock = getEnt("oldroom_block", "targetname");
	obstacles = getEnt("old_obstacles", "targetname");
	sniper1 = getEnt("snipermodels1", "targetname");
	sniper2 = getEnt("snipermodels2", "targetname");

	room2 = getEnt("end_room2", "targetname");
	room3 = getEnt("end_room3", "targetname");
	room4 = getEnt("end_room4", "targetname");

	trig2 = getEnt("trig_room2", "targetname");
	trig3 = getEnt("trig_room3", "targetname");
	trig4 = getEnt("trig_room4", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Enter The ^6Old ^7Room!");

	trig waittill("trigger", player);

	iPrintLnBold("^1>>^7 " + player.name + " Has Chosen The ^1Old ^7 Room");
	trig delete();

	room2 delete();
	room3 delete();
	room4 delete();
	trig2 delete();
	trig3 delete();
	trig4 delete();
	sniper1 delete();
	sniper2 delete();

	door moveZ(490, 2);

	obstacles show();
	oldblock show();

	obstacles moveZ(100, 2);
	oldblock moveZ(690, 2);
	wait 2;

	door delete();

	level.teleactorigin = getEnt("oldroom_origin", "targetname");

	level.activ setOrigin (level.teleactorigin.origin);
	level.activ setPlayerAngles (level.teleactorigin.angles);

}

EndroomBounce()
{
	trig = getEnt("trig_room2", "targetname");
	sniper1 = getEnt("snipermodels1", "targetname");
	sniper2 = getEnt("snipermodels2", "targetname");

	room2 = getEnt("end_room1", "targetname");
	room3 = getEnt("end_room4", "targetname");
	room4 = getEnt("end_room3", "targetname");

	trig2 = getEnt("trig_room1", "targetname");
	trig3 = getEnt("trig_room4", "targetname");
	trig4 = getEnt("trig_room3", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Enter The ^6Bounce ^7Room!");

	trig waittill("trigger", player);




	room2 delete();
	room3 delete();
	room4 delete();
	trig2 delete();
	trig3 delete();
	trig4 delete();
	sniper1 delete();
	sniper2 delete();

	tele1 = getEnt("bounce_acti", "targetname");
	tele2 = getEnt("bounce_jumper", "targetname");

	player setOrigin(tele2.origin);
	player setPlayerAngles(tele2.angles);

	level.activ setOrigin(tele1.origin);
	level.activ setPlayerAngles(tele1.angles);

	player takeAllWeapons();
	level.activ takeAllWeapons();

	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;

	player freezeControls(1);
	level.activ freezeControls(1);

	iPrintLnBold("^13");
	wait 1;
	iPrintLnBold("^12");
	wait 1;
	iPrintLnBold("^11");
	wait 1;

	player freezeControls(0);
	level.activ freezeControls(0);

	player giveWeapon("tomahawk_mp");
	level.activ giveWeapon("tomahawk_mp");
	player switchToWeapon("tomahawk_mp");
	level.activ switchToWeapon("tomahawk_mp");
}

BounceSniper()
{
	sniper = getEnt("bouncesniper", "targetname");
	sniper.modelScale = 3;

	while(1)
	{
	sniper rotateYaw(360 , 4);
	wait 4;
	}
}

BounceFall1()
{
	trig = getEnt("bounceroomfalljumper", "targetname");
	tele1 = getEnt("bounce_jumper", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);

		}
}

BounceFall2()
{
	trig = getEnt("bounceroomfallacti", "targetname");
	tele1 = getEnt("bounce_acti", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);

		}
}

BounceWeapon()
{
	trig = getEnt("bouncefinish", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 Get a Sniper!");
	trig waittill("trigger", player);

	player takeAllWeapons();
	player giveWeapon("m40a3_mp");
	player giveMaxAmmo("m40a3_mp");
	player switchToWeapon ("m40a3_mp");
	iPrintLnBold("^1" + player.name + " ^7Got a Sniper!");

}

EndroomLadder()
{
	trig = getEnt("trig_room4", "targetname");
	sniper1 = getEnt("snipermodels1", "targetname");
	sniper2 = getEnt("snipermodels2", "targetname");

	room2 = getEnt("end_room1", "targetname");
	room3 = getEnt("end_room2", "targetname");
	room4 = getEnt("end_room3", "targetname");

	trig2 = getEnt("trig_room1", "targetname");
	trig3 = getEnt("trig_room2", "targetname");
	trig4 = getEnt("trig_room3", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Enter The ^6Ladder Slide ^7Room!");

	trig waittill("trigger", player);



	iPrintLnBold("^1>>^7 " + player.name + " Has Chosen The ^1Ladder Slide ^7 Room");


	room2 delete();
	room3 delete();
	room4 delete();
	trig2 delete();
	trig3 delete();
	trig4 delete();
	sniper1 delete();
	sniper2 delete();

	tele1 = getEnt("ladder_acti", "targetname");
	tele2 = getEnt("ladder_jumper", "targetname");

	player takeAllWeapons();
	level.activ takeAllWeapons();

	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;

	level.activ setOrigin(tele1.origin);
	level.activ setPlayerAngles(tele1.angles);
	player setOrigin(tele2.origin);

	player freezeControls(1);
	level.activ freezeControls(1);

	iPrintLnBold("^13");
	wait 1;
	iPrintLnBold("^12");
	wait 1;
	iPrintLnBold("^11");
	wait 1;

	player freezeControls(0);
	level.activ freezeControls(0);

	player giveWeapon("tomahawk_mp");
	level.activ giveWeapon("tomahawk_mp");
	player switchToWeapon("tomahawk_mp");
	level.activ switchToWeapon("tomahawk_mp");

}

LadderSniper()
{
	sniper = getEnt("laddersniper", "targetname");

	while(1)
	{
	sniper rotateYaw(360 , 4);
	wait 4;
	}
}


LadderWeapon()
{
	trig = getEnt("ladderfinish", "targetname");

	trig setHintString("^1>>^7 Press ^1&&1 ^7 Get a Sniper!");
	trig waittill("trigger", player);

	player takeAllWeapons();
	player giveWeapon("m40a3_mp");
	player giveMaxAmmo("m40a3_mp");
	player switchToWeapon ("m40a3_mp");
	iPrintLnBold("^1" + player.name + " ^7Got a Sniper!");

}

LadderFall1()
{
	trig = getEnt("ladderfall1", "targetname");
	tele1 = getEnt("ladder_jumper", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);

		}
}

LadderFall2()
{
	trig = getEnt("ladderfall2", "targetname");
	tele1 = getEnt("ladder_acti", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}
}

EndroomSniper()
{
	trig = getEnt("trig_room3","targetname");

	tele1 = getEnt("origin_actisniper", "targetname");
	tele2 = getEnt("origin_jumpersniper", "targetname");

	room2 = getEnt("end_room1", "targetname");
	room3 = getEnt("end_room2", "targetname");
	room4 = getEnt("end_room4", "targetname");

	trig2 = getEnt("trig_room1", "targetname");
	trig3 = getEnt("trig_room2", "targetname");
	trig4 = getEnt("trig_room4", "targetname");


	trig setHintString("^1>>^7 Press ^1&&1 ^7 to Enter The ^6Sniper Room!");

	trig waittill("trigger", player);



	room2 delete();
	room3 delete();
	room4 delete();
	trig2 delete();
	trig3 delete();
	trig4 delete();

	player setOrigin( tele2.origin );
	player setPlayerAngles(tele2.angles);

	player takeAllWeapons();
	player giveWeapon("m40a3_mp");
	player giveWeapon( "remington700_mp" );
	player giveMaxAmmo("m40a3_mp");
	player giveMaxAmmo( "remington700_mp" );

	player switchToWeapon("m40a3_mp");

	level.activ setOrigin (tele1.origin);
	level.activ setPlayerAngles (tele1.angles);

	level.activ takeAllWeapons();
	level.activ giveWeapon("m40a3_mp");
	level.activ giveWeapon("remington700_mp");
	level.activ giveMaxAmmo("m40a3_mp");
	level.activ giveMaxAmmo("remington700_mp");
	wait (0.05);
	level.activ switchToWeapon("m40a3_mp");

	player.health = player.maxhealth;
	level.activ.health = level.activ.maxhealth;

	iPrintLnBold("^1>>^7 " + player.name + " Has Chosen The ^1Sniper ^7 Room");

	player freezeControls(1);
	level.activ freezeControls(1);

	iPrintLnBold("^13");
	wait 1;
	iPrintLnBold("^12");
	wait 1;
	iPrintLnBold("^11");
	wait 1;

	player freezeControls(0);
	level.activ freezeControls(0);

	player switchToWeapon( "m40a3_mp" );
	level.activ switchToWeapon( "m40a3_mp" );

}

SniperFall()
{
	trig = getEnt("sniperroomfall", "targetname");
	tele1 = getEnt("origin_sniperfall", "targetname");

	for(;;)
		{
			trig waittill("trigger", player);
			player setOrigin(tele1.origin);
			player setPlayerAngles(tele1.angles);
		}


}

Bouncer()
{

   trigger = getEnt ("bouncepad1", "targetname");

   while(1)
     {
		trigger waittill ("trigger", player);
		 strength = 9;
		 for(i=0;i<strength;i++)
         {
           player.health += 160;
           player finishPlayerDamage(player, level.jumpattacker, 160, 0, "MOD_FALLING", "jump_mp", player.origin, AnglesToForward((210,0,0)), "none", 0);
         }
    }


}

Sign()
{
	signname = getEnt("sign_name", "targetname");
	ring1 = getEnt("sign_ring1", "targetname");
	ring2 = getEnt("sign_ring2", "targetname");

	while(1)
	{
		signname rotatePitch(-360, 5, 1, 1);
		ring1 rotatePitch(360, 5, 1, 1);
		ring2 rotateYaw(-360, 5, 0.5, 0.5);
		wait 6;

	}
}

Logo()
{
	logo = getEnt("logo", "targetname");

	while(1)
	{
		logo rotateYaw(360, 10, 2, 2);
		wait 10;
	}

}

OpenDoor1()
{
	level.doortrig = getEnt("opendoor1", "targetname");
	door = getEnt("door1", "targetname");

	door delete();
	level.doortrig delete();
}

OpenDoor2()
{
	trig = getEnt("opendoor2", "targetname");
	door = getEnt("door2", "targetname");

	door delete();
	trig delete();

}


ActiWeapon()
{
	trig = getEnt("acti_gun", "targetname");
	//trig setHintString("^1>>^7 Press ^1&&1 ^7to get a Gun!");

	trig waittill("trigger", player);

	if (self isVip(self getGuid()) == "glen")
	{
		player giveWeapon( "glengun_mp" );
		player giveMaxAmmo( "glengun_mp" );
		player giveWeapon( "super_deagle_mp" );
		player giveMaxAmmo( "super_deagle_mp" );
		player switchToWeapon( "super_deagle_mp" );
	}
	else
	{
		player giveWeapon( "deserteaglegold_mp" );
		player giveMaxAmmo( "deserteaglegold_mp" );
		player switchToWeapon("deserteaglegold_mp");
	}

	trig delete();


}

Credits()
{
	iPrintLn("^1>>^7 Special Thanks to:");
	wait 2;
	iPrintLn("^1VC' Blade!");
	iPrintLn("^1VC' Erik!");
	iPrintLn("^1Phelix!");
	iPrintLn("For scripting/mapping/error help!");

}

onPlayerConnect()
{
    level endon("game_ended");

	for(;;)
	{
    level waittill("connected", player);
    player thread onPlayerSpawned();
    player thread vipMsg();
	}
}

onPlayerSpawned()
{
    self endon("disconnect");

    self waittill("spawned_player");
    self thread changePlayermodelVIP();
}

vipMsg()
{
    wait 5;
    if (self isVip(self getGuid()) == "erik")
	{
        iPrintLnBold("The Creator Helpers Joined the game");
		iPrintLnBold("Welcome ^1Erik^7!");
	}
    else if (self isVip(self getGuid()) == "blade")
	{
        iPrintLnBold("The Creator Helpers Joined the game");
		iPrintLnBold("Welcome ^1Blade^7!");
	}
	else if (self isVip(self getGuid()) == "phelix")
	{
		iPrintLnBold("The Creator Helpers Joined the game");
		iPrintLnBold("Welcome ^1Phelix^7!");
    }
	else if (self isVip(self getGuid()) == "mouse")
	{
	thread mouse();
    }
	else if (self isVip(self getGuid()) == "glen")
	{
		noti = SpawnStruct();
		noti.titleText = " ^7The one and only ^9VC' Glen ^7is here!!!";
		noti.notifyText = "^9>>>>__<<<<";
		noti.duration = 5;
		noti.glowcolor = (1,0,0);
		players = getEntarray("player", "classname");
		for(i=0;i<players.size;i++)
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
	}
}

changePlayermodelVIP()
{
    if (self isVip(self getGuid()) == "erik")
	{
        self detachAll();
        self setModel("body_mp_opforce_eningeer");
		self attach( "head_sp_opforce_ski_mask_body_a");
    }
    else if (self isVip(self getGuid()) == "glen")
	{
        self detachAll();
        self setModel("body_mp_opforce_sniper");
		self attach( "head_mp_opforce_ghillie");
    }
    else if (self isVip(self getGuid()) == "blade")
	{
        self detachAll();
        self setModel("body_mp_sas_urban_specops");
    }
	else if  (self isVip(self getGuid()) == "phelix")
	{
        self detachAll();
        self setModel("body_mp_sas_urban_specops");
    }

}

isVip(guid)
{
    if(self shortGuid(guid) == "3e468dc6")
        return "erik";
    else if (self shortGuid(guid) == "e3905ad9")
        return "glen";
    else if (self shortGuid(guid) == "c409ae43")
        return "blade";
    else if (self shortGuid(guid) == "cd957762")
        return "phelix";
	else if (self shortGuid(guid) == "b87016ae")
        return "mouse";
    else
        return "false";
}

shortGuid(guid)
{
    return getSubstr(guid, 24, 32);
}

secret_timer_easy() //blades timer
{
	self endon("secret1_done");

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();

	self.secretTimer=newclienthudelem(self);
	self.secretTimer.foreground = true;
	self.secretTimer.alignX = "center";
	self.secretTimer.alignY = "bottom";
	self.secretTimer.horzAlign = "center";
        self.secretTimer.vertAlign = "bottom";
        self.secretTimer.x = 0;
        self.secretTimer.y = -7;
        self.secretTimer.sort = 5;
        self.secretTimer.fontScale = 1.6;
        self.secretTimer.font = "default";
        self.secretTimer.glowAlpha = 1;
        self.secretTimer.hidewheninmenu = true;
        self.secretTimer.label = &"Time in left: &&1";
        if(isdefined(level.randomcolor))
	self.secretTimer.glowColor=level.randomcolor;
	else
	self.secretTimer.glowColor=(1,0,0);

	time=90;
	for(i=0;i<time;i++)
		{
		self.secretTimer setvalue(time-i);
		wait 1;
		}
	self.secretTimer setvalue(0);
	self suicide();

	if(isdefined(self.secretTimer))
	self.secretTimer destroy();
}

musicBox()
{
    trig = getEnt("vcmusic","targetname");
    trig setHintString("Press ^1&&1^7 to select Music");
    trig waittill("trigger",p);
	p braxi\_rank::giveRankXP("", 50);
    trig delete();

    p freezeControls(1);
    p musicMenu();
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
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(1,0,0);

    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Vistic Glen");
    self.hud_music[i].glowalpha=1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else
        self.hud_music[i].glowcolor=(1,0,0);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 886;
    self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");

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
            self.hud_music[i].glowcolor=(1,0,0);

        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }

    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(1,0,0);

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
             iPrintLn("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);

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

mouse()
{
	trig = getEnt("trig_say","targetname");
		while(1)
	{
		trig waittill("trigger",player);
		player sayAll("I have a little pee pee");
		trig delete();
	}

}



