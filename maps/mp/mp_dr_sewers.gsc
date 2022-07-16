/*                                      
MMMMMMM MMMMMM  MMMMMM  MMMMMM   MMMMMM8  MMMMMM  
  MMI   MMOII7 .MM  MM  MM. MM  MM    MM  MM .MM  
  MM    MM=     MM MM   MM MM   MM   .MM  MM MM   
  MM    MMMMMM  MM MMM .MM DMM   MMMMMM   MM :MM 
*/

main()
{
	maps\mp\_load::main();
	
    //addTriggerToList( "trap8_trig" );
	
	//PrecacheModel( "" );
	//PrecacheItem( "" );
	precacheItem( "ak74u_mp" );
	setExpFog(600, 600, 0, 0, 0, 0);
	
	level._effect["blinking"] = LoadFX( "rock/blinking_light" );
	level.brick = loadfx("test/brickblast_25");
	level.boom = loadfx("explosions/airlift_explosion_large");
	level._effect["fire"] = LoadFX( "sewer/fire_torch" );
	level.laser = loadfx("rock/laser_center2");
	level._effect["orb"] = LoadFX( "sewer/orb_fire" );
	level._effect["aod"] = LoadFX( "sewer/orb_fireaod" );
	level.statue = LoadFX( "sewer/statue_fx" );
	level.fx_fireball["start"] = LoadFX( "sewer/fireball_start" );
	level.fx_fireball["idle"] = LoadFX( "sewer/fireball_idle" );
	level.fx_fireball["explosion"] = LoadFX( "sewer/fireball_explosion" );
	level.fx_fireball["start_red"] = LoadFX( "sewer/fireball_start_red" );
	level.fx_fireball["idle_red"] = LoadFX( "sewer/fireball_idle_red" );
	level.fx_fireball["explosion_red"] = LoadFX( "sewer/fireball_explosion_red" );
	level.trap = LoadFX( "explosions/aerial_explosion" );
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	
	//////////dvars/////////////////////////////
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1"); 
	setdvar("r_glowskybleedintensity0",".1"); 
	
	//ambientPlay("ambient_middleeast_ext"); 
	
	//////////////threads////////////////
	thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_map::createSpawn((498,-568,74), 92);
	thread onConnected();
	thread tourch_fire();
	thread laser();
	thread addorb();
	//thread axe();
	//thread secret();
	thread aod();
	thread torch_sound();
	//thread trap2();
	//thread trap5();
	//thread trap4();
	//thread trap3();
	//thread trap7();
	//thread trap8();
	thread finaldoor();
	//thread trap6();
	//thread secretz();
}


//////////////////////////////////////////////////////////////////////////////////


addBlinkingLight()
{
	ent = getEntArray("org_light", "targetname");
	
	for(i=0;i<ent.size;i++)
	{
		blink = maps\mp\_utility::createOneshotEffect( "blinking" );
		blink.v[ "origin" ] = ent[i].origin;
		blink.v[ "angles" ] = ( 270, 0, 0 );
		blink.v[ "fxid" ] = "blinking";
		blink.v[ "delay" ] = -15;
	}
}


//////////////////////////////////////////////////////////////////////////////////


onConnected()
{
	while(1)
	{
		level waittill( "connected", player );
		player setClientDvar( "r_dLightLimit", 4 ); //To see blinking Lights
		player setClientDvar( "r_distortion", 1 );
	}
}


//////////////////////////////////////////////////////////////////////////////////


tourch_fire()
{
	ent = getEntArray("torch", "targetname");
	
	for(i=0;i<ent.size;i++)
	{
		torch = maps\mp\_utility::createOneshotEffect( "fire" );
		torch.v[ "origin" ] = ent[i].origin;
		torch.v[ "angles" ] = ( 270, 0, 0 );
	}
}


//////////////////////////////////////////////////////////////////////////////////


laser()
{
	laser_ori =getent( "laser_ori", "targetname" );
	statue_fire =getent("statue_fire","targetname");
	
	wait 5;
	playFx(level.laser, laser_ori.origin);
	wait 3;
	playFx(level.statue, statue_fire.origin);
	wait 5;
}


//////////////////////////////////////////////////////////////////////////////////


addorb()
{
	ent = getEntArray("pot_fire", "targetname");
	
	for(i=0;i<ent.size;i++)
	{
		orb = maps\mp\_utility::createOneshotEffect( "orb" );
		orb.v[ "origin" ] = ent[i].origin;
		orb.v[ "angles" ] = ( 270, 0, 0 );
	}
}


//////////////////////////////////////////////////////////////////////////////////


axe()
{
	axe = getent("axe","targetname");
	
	axe waittill("trigger",player);
	axe delete();
	
	player iPrintLnBold("^5S^7orry^5, ^5y^7ou ^5c^7an't ^5H^7andle ^5T^7his ^5P^7ower^5f^7ul ^5A^7xe^5.");
}


//////////////////////////////////////////////////////////////////////////////////


secret()
{
	secret = getent("secret","targetname");
	
	secret waittill("trigger",player);
	secret delete();
	
	iPrintLnBold( player.name + " ^5f^7ound ^5a ^5S^7niper^5!!");
	player GiveWeapon( "remington700_mp" );
	player giveMaxAmmo( "remington700_mp" );	
	player switchToWeapon( "remington700_mp" );
	
	
}


//////////////////////////////////////////////////////////////////////////////////


aod()
{
	ent = getEntArray("aod_fire", "targetname");
	
	for(i=0;i<ent.size;i++)
	{
		aodorb = maps\mp\_utility::createOneshotEffect( "aod" );
		aodorb.v[ "origin" ] = ent[i].origin;
		aodorb.v[ "angles" ] = ( 270, 0, 0 );
	}
}


//////////////////////////////////////////////////////////////////////////////////


torch_sound()
{
	ent = getEntArray("torch", "targetname");
	
	for(i=0;i<ent.size;i++)
		ent[i] playLoopsound("fire_wood_small");
}


//////////////////////////////////////////////////////////////////////////////////


trap2()
{
	trap2_trig = getent("trap2_trig","targetname");
	trap2_brush = getent("trap2_brush","targetname");
	trap2_ori = getent("trap2_ori","targetname");
	trap2_hurt = getent("trap2_hurt","targetname");
	trap2_push = getent("trap2_push","targetname");
	
	trap2_hurt enablelinkto();
	trap2_hurt linkto (trap2_brush);
	
	trap2_trig waittill("trigger");
	trap2_push movey(6,2);
	trap2_trig delete();
	
	trap2_brush movey(-236,1);
	wait 1;
	trap2_ori playsound("wall");
	EarthQuake( 1, 1, trap2_ori.origin, 600 );
	wait 4;
	trap2_brush movey(236,2);
	wait 2;
}


//////////////////////////////////////////////////////////////////////////////////


trap5()
{
	trap5_trig = getent("trap5_trig","targetname");
	trap5_brush = getent("trap5","targetname");
	trap5_ori = getent("trap5_ori","targetname");
	trap5_push = getent("trap5_push","targetname");
	
	trap5_trig waittill("trigger");
	trap5_push movey(6,2);
	trap5_trig delete();
	
	trap5_brush movez(200,1);
	wait 1;
	trap5_ori playsound("wall");
	EarthQuake( 1, 1, trap5_ori.origin, 600 );
	wait 4;
	trap5_brush movez(-200,2);
	wait 2;
}


//////////////////////////////////////////////////////////////////////////////////


trap4()
{
	trap4_trig=getent("trap4_trig","targetname");
	trap4_good=getent("trap4_good","targetname");
	trap4_broken=getent("trap4_broken","targetname");
	trap4_bomb1=getent("trap4_bomb1","targetname");
	trap4_bomb2=getent("trap4_bomb2","targetname");
	trap4_bomb3=getent("trap4_bomb3","targetname");
	trap4_bomb4=getent("trap4_bomb4","targetname");
	trap4_bomborg1=getent("trap4_bomborg1","targetname");
	trap4_bomborg2=getent("trap4_bomborg2","targetname");
	trap4_push = getent("trap4_push","targetname");
	
	trap4_broken hide();
	
	trap4_trig waittill("trigger");
	trap4_push movex(6,2);
	trap4_trig delete();
	
	
	PlayFX( level.fx_fireball["explosion"], trap4_bomborg1.origin );
	PlayFX( level.fx_fireball["explosion"], trap4_bomborg2.origin );
	EarthQuake( 1, 1, trap4_bomborg1.origin, 500 );
	EarthQuake( 1, 1, trap4_bomborg2.origin, 500 );
	trap4_bomborg1 PlaySound( "exp_suitcase_bomb_main" );
	trap4_bomborg2 PlaySound( "exp_suitcase_bomb_main" );
	RadiusDamage( trap4_bomborg1.origin, 500, 200, 50 );
	RadiusDamage( trap4_bomborg2.origin, 500, 200, 50 );
	trap4_good hide();
	trap4_good notsolid();
	trap4_broken show();
	trap4_bomb1 hide();
	trap4_bomb2 hide();
	trap4_bomb3 hide();
	trap4_bomb4 hide();
	wait 2;
}


//////////////////////////////////////////////////////////////////////////////////


trap3()
{
	start = getEnt( "origin_fireball_start", "targetname" );
	end = getEnt( "origin_fireball_end", "targetname" );
	trap3_push = getEnt( "trap3_push", "targetname" );
	trap3_trig = getEnt( "trap3_trig", "targetname" );

	trap3_trig waittill("trigger");
	trap3_push movex(6,2);
	trap3_trig delete();
	
	PlayFX( level.fx_fireball["start"], start.origin );
	wait 1.5;

	fireball = spawn( "script_model", start.origin );
	fireball setModel( "tag_origin" );
	wait 0.05;
	PlayFXOnTag( level.fx_fireball["idle"], fireball, "tag_origin" );
	time = Distance( start.origin, end.origin )/1000;
	fireball MoveTo( end.origin, time );
	wait time;
	fireball delete();

	PlayFX( level.fx_fireball["explosion"], end.origin );
	EarthQuake( 1, 1, end.origin, 800 );
	end PlaySound( "exp_suitcase_bomb_main" );
	RadiusDamage( end.origin, 500, 200, 50 );
	wait 5;
}


//////////////////////////////////////////////////////////////////////////////////


trap7()
{
	trap7_rotate = getent("trap7_rotate","targetname");
	trap7_trig = getent("trap7_trig","targetname");
	trap7_push = getent("trap7_push","targetname");
	
	trap7_trig waittill("trigger");
	trap7_push movex(6,2);
	trap7_trig delete();;
	
	while(1)
	{
		trap7_rotate rotateroll (-720,2.5);
		wait 1 ;
	}
}


//////////////////////////////////////////////////////////////////////////////////


trap8()
{
	trap8_a = getent("trap8_a","targetname");
	trap8_b = getent("trap8_b","targetname");
	trap8_trig = getent("trap8_trig","targetname");
	trap8_push = getent("trap8_push","targetname");
	
	trap8_trig waittill("trigger");
	trap8_push movex(6,2);
	trap8_trig delete();;
	
	trap8_a movex(-120,.5);
	trap8_b movex(120,.5);
	wait 5;
	trap8_a movex(120,.5);
	trap8_b movex(-120,.5);
}


//////////////////////////////////////////////////////////////////////////////////


finaldoor()
{
	final_door_a = getent("final_door_a","targetname");
	final_door_b = getent("final_door_b","targetname");
	final_door_open = getent("final_door_open","targetname");
	
	while(1)
	{
		final_door_open waittill("trigger");
		final_door_a movey(-66,2);
		final_door_b movey(66,2);
		wait 5;
		final_door_a movey(66,2);
		final_door_b movey(-66,2);
	}
}


//////////////////////////////////////////////////////////////////////////////////


trap6()
{
	trap6_push = getEnt( "trap6_push", "targetname" );
	trap6_trig = getEnt( "trap6_trig", "targetname" );
	
	trap6_a = getEnt( "trap6_a", "targetname" );
	trap6_a2 = getEnt( "trap6_a2", "targetname" );
	trap6_ahurt = getEnt( "trap6_ahurt", "targetname" );
	
	trap6_b = getEnt( "trap6_b", "targetname" );
	trap6_b2 = getEnt( "trap6_b2", "targetname" );
	trap6_bhurt = getEnt( "trap6_bhurt", "targetname" );
	
	trap6_c = getEnt( "trap6_c", "targetname" );
	trap6_c2 = getEnt( "trap6_c2", "targetname" );
	trap6_churt = getEnt( "trap6_churt", "targetname" );
	
	trap6_d = getEnt( "trap6_d", "targetname" );
	trap6_d2 = getEnt( "trap6_d2", "targetname" );
	trap6_dhurt = getEnt( "trap6_dhurt", "targetname" );
	
	trap6_ahurt enablelinkto();
	trap6_ahurt linkto (trap6_a);
	
	trap6_bhurt enablelinkto();
	trap6_bhurt linkto (trap6_b);
	
	trap6_churt enablelinkto();
	trap6_churt linkto (trap6_c);
	
	trap6_dhurt enablelinkto();
	trap6_dhurt linkto (trap6_d);

	trap6_trig waittill("trigger");
	trap6_push movex(6,2);
	trap6_trig delete();
	
	trap6_a movex(-448,1);
	trap6_c movex(-448,1);
	wait 2;
	trap6_a rotateroll (-1140,2);
	trap6_a2 rotateroll (-1140,2);
	trap6_c rotateroll (-1140,2);
	trap6_c2 rotateroll (-1140,2);
	wait 3;
	trap6_a movex(448,2);
	trap6_c movex(448,2);
	wait 3;
	trap6_b movex(-448,1);
	trap6_d movex(-448,1);
	wait 2;
	trap6_b rotateroll (-1140,2);
	trap6_b2 rotateroll (-1140,2);
	trap6_d rotateroll (-1140,2);
	trap6_d2 rotateroll (-1140,2);
	wait 3;
	trap6_b movex(448,2);
	trap6_d movex(448,2);
	wait 1;
}


//////////////////////////////////////////////////////////////////////////////////

secretz()
{
	secret2 = getEnt( "secret2", "targetname" );
	
	secret2 waittill("trigger",player);
	secret2 delete();
	
	possibility = randomIntRange(0,3);
	if(possibility == 0)
	{
		player iPrintLnBold("^5H^7ow ^5D^7are ^5y^7ou ^5T^7ry ^5T^7o ^5H^7andle ^5T^7his ^5P^7owerFul ^5W^7and^5!!");
		RadiusDamage( player.origin, 300, 60, 20 );
	}
	
	if(possibility == 1)
	
	{
		player iPrintLnBold("^5W^7elcome ^5M^7y ^5L^7ord, ^5I ^5A^7m ^5a^7t ^5Y^7our ^5S^7ervice^5!!");
		player GiveWeapon( "ak74u_mp" );
		player switchToWeapon( "ak74u_mp" );
	}
	
	if(possibility == 2)
	
	{
		player iPrintLnBold("^5H^7ow ^5D^7are ^5y^7ou ^5T^7ry ^5T^7o ^5H^7andle ^5T^7his ^5P^7owerFul ^5W^7and^5!!");
		RadiusDamage( player.origin, 300, 60, 20 );
	}
	
	if(possibility == 3)
	
	{
		player iPrintLnBold("^5W^7elcome ^5M^7y ^5L^7ord, ^5I ^5A^7m ^5a^7t ^5Y^7our ^5S^7ervice^5!!");
		player GiveWeapon( "ak74u_mp" );
		player switchToWeapon( "ak74u_mp" );
	}
}


//////////////////////////////////////////////////////////////////////////////////