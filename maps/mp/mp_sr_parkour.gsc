///////////////////////////////////////////////////////////////////////////
//  ______  __              __                      ___                 //
// /\__  _\/\ \            /\ \       __          /'___\               //
// \/_/\ \/\ \ \___      __\ \ \     /\_\   __  _/\ \__/   __         //
//    \ \ \ \ \  _ `\  /'__`\ \ \  __\/\ \ /\ \/'\ \ ,__\/'__`\      //
//     \ \ \ \ \ \ \ \/\  __/\ \ \L\ \\ \ \\/>  </\ \ \_/\  __/     //
//      \ \_\ \ \_\ \_\ \____\\ \____/ \ \_\/\_/\_\\ \_\\ \____\   //
//       \/_/  \/_/\/_/\/____/ \/___/   \/_/\//\/_/ \/_/ \/____/  //
//                                                               //
//////////////////////////////////////////////////////////////////                                                        

main()
{
	maps\mp\_load::main();	


	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");

	level.wallplode=loadfx("explosions/wallplode");

	thread way_connect();

	thread tele1();
	thread tele2();
	thread tele3();
	thread rip_wall();
	thread line4_car1();
	thread line4_car2();
	thread line4_car3();
	thread line3_car1();
	thread line3_car2();
	thread line3_car3();
	thread line2_car1();
	thread line2_car2();
	thread line2_car3();
	thread line1_car1();
	thread line1_bus();
	thread line1_clip();
	thread bounce();
	thread vc_stuf();
	thread rpg_logo();
	thread creators();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

tele1()
{
	trig = getEnt ("tele1", "targetname");
	end = getEnt ("tele1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	//player iPrintlnBold( "^1Go FASTER!" );
	}
}

tele2()
{
	trig = getEnt ("old_acti_tp", "targetname");
	end = getEnt ("old_acti", "targetname");
	while(1)
    {
        trig waittill ("trigger", player);          
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		player iPrintlnBold( "Welcome to the unofficial activators hangout" );
	}
}

tele3()
{
	trig = getEnt ("stairs_tele", "targetname");
	end = getEnt ("stairs_tele_go", "targetname");
	while(1)
    {
        trig waittill ("trigger", player);          
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
		//player iPrintlnBold( "^1Why aren't you going faster??" );
	}
}

vc_stuf()
{

}

rip_wall()
{

	wall = getent ("wall1","targetname");
	trigger = getent ("rip_wall","targetname");
	wallfx = getent ("wall1_fx","targetname");
	trigger waittill ("trigger", player);
	playfx(level.wallplode,wallfx.origin);
	wallfx playSound("boxplode");
	wall delete();

}

line4_car1()
{
	car = getent ("line4_car1","targetname");
	while(1)
	{
		car movex(-5991,13);
		car waittill ("movedone");
		car hide();
		car movex(5991,0.1);
		car waittill ("movedone");
		car show();
		wait 7;
	}
}

line4_car2()
{
	car = getent ("line4_car2","targetname");
	while(1)
	{
		wait 2;
		car movex(-5991,15);
		car waittill ("movedone");
		car hide();
		car movex(5991,0.1);
		car waittill ("movedone");
		car show();
		wait 5;
	}
}

line4_car3()
{
	car = getent ("line4_car3","targetname");
	while(1)
	{
		wait 3;
		car movex(-5991,10);
		car waittill ("movedone");
		car hide();
		car movex(5991,0.1);
		car waittill ("movedone");
		car show();
		wait 4;
	}
}

line3_car1()
{
	car = getent ("line3_car1","targetname");
	while(1)
	{
		wait 6;
		car movex(-5991,15);
		car waittill ("movedone");
		car hide();
		car movex(5991,0.1);
		car waittill ("movedone");
		car show();
		wait 1;
	}
}

line3_car2()
{
	car = getent ("line3_car2","targetname");
	while(1)
	{
		wait 4;
		car movex(-5991,14);
		car waittill ("movedone");
		car hide();
		car movex(5991,0.1);
		car waittill ("movedone");
		car show();
		wait 3;
	}
}

line3_car3()
{
	car = getent ("line3_car3","targetname");
	while(1)
	{
		wait 5;
		car movex(-5991,15);
		car waittill ("movedone");
		car hide();
		car movex(5991,0.1);
		car waittill ("movedone");
		car show();
		wait 2;
	}
}

line2_car1()
{
	car = getent ("line2_car1","targetname");
	while(1)
	{
		wait 1;
		car movex(5991,15);
		car waittill ("movedone");
		car hide();
		car movex(-5991,0.1);
		car waittill ("movedone");
		car show();
		wait 5;
	}
}

line2_car2()
{
	car = getent ("line2_car2","targetname");
	while(1)
	{
		wait 4;
		car movex(5991,15);
		car waittill ("movedone");
		car hide();
		car movex(-5991,0.1);
		car waittill ("movedone");
		car show();
		wait 2;
	}
}

line2_car3()
{
	car = getent ("line2_car3","targetname");
	while(1)
	{
		wait 3;
		car movex(5991,13);
		car waittill ("movedone");
		car hide();
		car movex(-5991,0.1);
		car waittill ("movedone");
		car show();
		wait 3;
	}
}

line1_car1()
{
	car = getent ("line1_car1","targetname");
	while(1)
	{
		wait 4;
		car movex(5991,15);
		car waittill ("movedone");
		car hide();
		car movex(-5991,0.1);
		car waittill ("movedone");
		car show();
		wait 4;
	}
}

line1_bus()
{
	car = getent ("line1_bus","targetname");
	while(1)
	{
		car movex(5700,16);
		car waittill ("movedone");
		car hide();
		car movex(-5700,0.1);
		car waittill ("movedone");
		car show();
		wait 3;
	}
}

	line1_clip()
{
	car = getent ("bus_clip","targetname");
	while(1)
	{
		car movex(5700,16);
		car waittill ("movedone");
		car movex(-5700,0.1);
		car waittill ("movedone");
		wait 3;
	}
}

 bounce()
{
	trig = getent("bounce", "targetname");

	while(1)
	{
		trig waittill ( "trigger", player );
		//player playSound("booing");  
		player thread bounce2();
	}
}

bounce2()
{
	for(i = 0; i < 4; i++)
	{
		self.health += 170;
		self finishPlayerDamage(self, level.jumpattacker, 170, 0, "MOD_FALLING", "jump_mp", self.origin, AnglesToForward((-90,0,0)), "head", 0);
	}
}


rpg_logo()
{
	object = getEnt ("rpg_logo","targetname");
	thread rpg_logomve();
	while(1)
	{
		object rotateyaw(1440,20,1,2);
		object waittill ("rotatedone");
		object rotateyaw(-1440,20,1,2);
		object waittill ("rotatedone");
	}
}
rpg_logomve()
{
	object = getEnt ("rpg_logo","targetname");
	while(1)
	{
		object movez(128,4,1,2);
		object waittill ("movedone");
		object movez(-128,4,1,2);
		object waittill ("movedone");
	}
}

creators()
{
	wait 10;
	iPrintlnBold("^5Welcome to the first speedrun map ^1parkour!");
	wait 2;
	iPrintlnBold("^7Map by ^5TheLixfe");
	wait 2;
	while(1)
	{
		iprintln("^7Did you know that this map was about to be a deathrun map");
		wait 5;
		iprintln("^7Thanks to ^5Vistic Clan");
		wait 50;
		iprintln("^6steam: TheLixfe");
		wait 5;
		iprintln("^7Map by ^5TheLixfe");
		wait 10;
	}
}