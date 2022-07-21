//Map made by CM'Nobody
//Original map from Garrys Mod by FireWavezZ

// Discord : Derazerr | Nobody#3996
//Steam :  xderazerr


#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
    maps\mp\_load::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_speedrun::createTeleporter((-1058.49, -282.462, -348.497), 80, 130, (781, 2755, -3331), 181, "freeze", "blue", "secret_0");
 
    setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
    setdvar("r_glowbloomintensity1",".1");
    setdvar("r_glowskybleedintensity0",".1");
    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998 );


    addTriggerToList("trig_trap1");
    addTriggerToList("trig_trap2");
    addTriggerToList("trig_trap3");
    addTriggerToList("trig_trap4");
    addtriggerTolist("trig_trap5");
    addtriggerTolist("trig_trap6");
    addtriggerTolist("trig_trap7");
    addtriggerTolist("trig_trap9");
    addtriggerTolist("trig_trap10");
    addTriggerToList("trig_trap11");
    addTriggerToList("trig_trap12");
    addtriggerTolist("trig_trap13");
    addTriggerToList("trig_trap14");
    addTriggerToList("trig_trap15");
    addtriggerTolist("trig_trap16");
    addTriggerToList("trig_trap17");

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
    thread trap13();
    thread trap14();
    thread trap15();
    thread trap16();
    thread trap17();
    thread trap17init();
    thread part2_jumper();
    thread door();
    thread secret();
    thread secret1();
    thread secret2();
    thread secret3();
    thread secret4();
    thread jumper_secret_end(); 
    thread setresp();
    thread trap2init();

}
setresp() 
{
    trig1 = spawn( "trigger_radius", (-914.439, -0.413066, -340.751), 0, 135, 65 );

	trig1 thread setting();

}
setting()
{
   while(1)
    {
    	self waittill("trigger", player);
		player.secret = 0;


    }
   
}
door()
{

    door1 = getEnt("startdoor1", "targetname");
    door2 = getEnt("startdoor2", "targetname");
    fakedoor = getEnt("fakedoor", "targetname");

    door2 delete();
    door1 delete();
    fakedoor delete();
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

trap1()
{
	level endon("triggera");
    trig = getent ("trig_trap1", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trap = getent ("trap1", "targetname");
    trapbutton = getent ("trap1_button", "targetname");

    while(1) 
    {
        trig waittill("triggera", player);
        trig delete();
        trap delete();

        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
    }
}

trap2()
{
	level endon("triggerb");
    trig = getent ("trig_trap2", "targetname");
    trapbutton = getent ("trap2_button", "targetname");

    while(1) 
    {
        trig waittill("triggerb", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        for(;;)
        {
            thread trap2a();
            wait 0.25;
            thread trap2b();
            wait 0.25;
            thread trap2c();
            wait 0.25;
            thread trap2d();
            wait 0.25;
            thread trap2e();
            wait 2.5;
        }
    }
}


trap2init()
{
    trap_a = getent("trap2_a","targetname"); // trap
    death_trigger_a = getent("trap2a_trig","targetname"); //Death trigger
trap_a delete();
    death_trigger_a delete();

    trap_b = getent("trap2_b","targetname"); // trap
    death_trigger_b = getent("trap2b_trig","targetname"); //Death trigger
trap_b delete();
    death_trigger_b delete();

    trap_c = getent("trap2_c","targetname"); // trap
    death_trigger_c = getent("trap2c_trig","targetname"); //Death trigger
trap_c delete();
    death_trigger_c delete();

    trap_d = getent("trap2_d","targetname"); // trap
    death_trigger_d = getent("trap2d_trig","targetname"); //Death trigger
    trap_d delete();
    death_trigger_d delete();

    trap_e = getent("trap2_e","targetname"); // trap
    death_trigger_e = getent("trap2e_trig","targetname"); //Death trigger
    trap_e delete();
    death_trigger_e delete();
}



trap2a()
{


    trap = getent("trap2_a","targetname"); // trap
    death_trigger = getent("trap2a_trig","targetname"); //Death trigger
    death_trigger enablelinkto(); 
    death_trigger linkto(trap);
    trap moveY (232, 0.25);
    wait 0.35;
    trap moveY (-232, 1.5);;
}


trap2b()
{
    trap = getent("trap2_b","targetname"); // trap
    death_trigger = getent("trap2b_trig","targetname"); //Death trigger
    death_trigger enablelinkto(); 
    death_trigger linkto(trap);
    trap moveY (240, 0.25);
    wait 0.50;
    trap moveY (-240, 1.5);

}


trap2c()
{
    trap = getent("trap2_c","targetname"); // trap
    death_trigger = getent("trap2c_trig","targetname"); //Death trigger
    death_trigger enablelinkto(); 
    death_trigger linkto(trap);
    trap moveY (272, 0.25);
    wait 0.75;
    trap moveY (-272, 1.5);
}


trap2d()
{
    trap = getent("trap2_d","targetname"); // trap
    death_trigger = getent("trap2d_trig","targetname"); //Death trigger
    death_trigger enablelinkto(); 
    death_trigger linkto(trap);
    trap moveY (224, 0.25);
    wait 0.9;
    trap moveY (-224, 1.5);
}


trap2e()
{
    trap = getent("trap2_e","targetname"); // trap
    death_trigger = getent("trap2e_trig","targetname"); //Death trigger
    death_trigger enablelinkto(); 
    death_trigger linkto(trap);
    trap moveY (240, 0.25);
    wait 1;
    trap moveY (-240, 1.5);
}



trap3()
{
	level endon("triggerc");
    trig = getent ("trig_trap3", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trap = getent ("trap3", "targetname");
    trapbutton = getent ("trap3_button", "targetname"); 

    while(1) 
    {
        trig waittill("triggerc", player);
        trig delete();
        wait 0.5;
        trap moveZ (-256, 0.5);
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        wait 2;
        trap moveZ (256, 2);    
    }
}




trap4()
{
	level endon("triggerd");
    trig = getent ("trig_trap4", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trap = getent ("trap4", "targetname");
    doors = getent ("trap4_doors", "targetname");
    death_trigger = getent ("trap4_death", "targetname");
    wall = getent ("trap4_wall", "targetname");
    death_trigger enablelinkto(); 
    death_trigger linkto(wall);
    wait 0.5;
    doors moveZ(-173, 0.1);
    trapbutton = getent ("trap4_button", "targetname"); 
    while(1) 
    {
        trig waittill("triggerd", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        doors moveZ(181, 2);
        wait 3;
        trap moveX(293, 3);
        wait 2.7;
        wall moveZ(80, 0.1);
        wait 1.3;
        trap moveX(-293, 3);
        wait 3;
        doors moveZ(-181, 2);
        wall moveZ(-80, 0.1);


    }
}





trap5()
{
	level endon("triggere");
    trapbutton = getent ("trap5_button", "targetname");
    trig = getent ("trig_trap5", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trap1 = getent ("trap5_a", "targetname");
    trap2 = getent ("trap5_b", "targetname");
    trap3 = getent ("trap5_c", "targetname");
    trap4 = getent ("trap5_d", "targetname");
    trap5 = getent ("trap5_e", "targetname");
    trapbutton = getent ("trap5_button", "targetname");
    wait 0.5;
    death_a = getent ("trap5_a_death", "targetname");
    death_a enablelinkto(); 
    death_a linkto(trap1);
    death_b = getent ("trap5_b_death", "targetname");
    death_b enablelinkto(); 
    death_b linkto(trap2);
    death_c = getent ("trap5_c_death", "targetname");
    death_c enablelinkto(); 
    death_c linkto(trap3);
    death_d = getent ("trap5_d_death", "targetname");
    death_d enablelinkto(); 
    death_d linkto(trap4);
    death_e = getent ("trap5_e_death", "targetname");
    death_e enablelinkto(); 
    death_e linkto(trap5);

    trap1 moveZ (-126, 0.3);
    trap2 moveZ (-126, 0.3);
    trap3 moveZ (-126, 0.3);
    trap4 moveZ (-126, 0.3);
    trap5 moveZ (-126, 0.3);

    while(1) 
    {
        trig waittill("triggere", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        for(;;)
        {
            random = randomint(5);
            if (random == 0)
            {
                trap1 moveZ (126, 0.3);
                trap3 moveZ (126, 0.3);
                wait 1;
                trap1 moveZ (-126, 0.3);
                trap3 moveZ (-126, 0.3);
                wait 1;
            }
            if (random == 1)
            {
                trap1 moveZ (126, 0.3);
                trap4 moveZ (126, 0.3);
                wait 1;
                trap1 moveZ (-126, 0.3);
                trap4 moveZ (-126, 0.3);
                wait 1;
            }
            if (random == 2)
            {
                trap2 moveZ (126, 0.3);
                trap3 moveZ (126, 0.3);
                wait 1;
                trap2 moveZ (-126, 0.3);
                trap3 moveZ (-126, 0.3);

                wait 1;
            }
            if (random == 3)
            {
                trap2 moveZ (126, 0.3);
                trap4 moveZ (126, 0.3);
                wait 1;
                trap2 moveZ (-126, 0.3);
                trap4 moveZ (-126, 0.3);
                wait 1;
            }
            if (random == 4)
            {
                trap5 moveZ (126, 0.3);
                wait 1;
                trap5 moveZ (-126, 0.3);
                wait 1;
            }
        }
    }
}



trap6()
{
	level endon("triggerf");
    trapbutton = getent ("trap6_button", "targetname");
    trig = getent ("trig_trap6", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trap1 = getent ("trap6_a", "targetname");
    trap2 = getent ("trap6_b", "targetname");
    trap3 = getent ("trap6_c", "targetname");
    trap4 = getent ("trap6_d", "targetname");
    trap5 = getent ("trap6_e", "targetname");
    trapbutton = getent ("trap6_button", "targetname");

    death_a = getent ("trap6_a_death", "targetname");
    death_a enablelinkto(); 
    death_a linkto(trap1);
    death_b = getent ("trap6_b_death", "targetname");
    death_b enablelinkto(); 
    death_b linkto(trap2);
    death_c = getent ("trap6_c_death", "targetname");
    death_c enablelinkto(); 
    death_c linkto(trap3);
    death_d = getent ("trap6_d_death", "targetname");
    death_d enablelinkto(); 
    death_d linkto(trap4);
    death_e = getent ("trap6_e_death", "targetname");
    death_e enablelinkto(); 
    death_e linkto(trap5);
    wait 0.5;
    trap1 moveZ (-126, 0.3);
    trap2 moveZ (-126, 0.3);
    trap3 moveZ (-126, 0.3);
    trap4 moveZ (-126, 0.3);
    trap5 moveZ (-126, 0.3);

    while(1) 
    {
        trig waittill("triggerf", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        for(;;)
        {
            random2 = randomint(5);
            if (random2 == 0)
            {
                trap1 moveZ (126, 0.3);
                trap3 moveZ (126, 0.3);
                wait 1;
                trap1 moveZ (-126, 0.3);
                trap3 moveZ (-126, 0.3);
                wait 1;
            }
            if (random2 == 1)
            {
                trap1 moveZ (126, 0.3);
                trap4 moveZ (126, 0.3);
                wait 1;
                trap1 moveZ (-126, 0.3);
                trap4 moveZ (-126, 0.3);
                wait 1;
            }
            if (random2 == 2)
            {
                trap2 moveZ (126, 0.3);
                trap3 moveZ (126, 0.3);
                wait 1;
                trap2 moveZ (-126, 0.3);
                trap3 moveZ (-126, 0.3);
                wait 1;
            }
            if (random2 == 3)
            {
                trap2 moveZ (126, 0.3);
                trap4 moveZ (126, 0.3);
                wait 1;
                trap2 moveZ (-126, 0.3);
                trap4 moveZ (-126, 0.3);

                wait 1;
            }
            if (random2 == 4)
            {
                trap5 moveZ (126, 0.3);
                wait 1;
                trap5 moveZ (-126, 0.3);
                wait 1;
            }
        }
    }
}
trap7()
{
	level endon("triggerg");
    trapbutton = getent ("trap7_button", "targetname");
    trig = getent ("trig_trap7", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trap = getent ("trap7", "targetname");
    clip = getent ("trap7_clip", "targetname");
    death_trigger = getent ("trap7_death", "targetname");
    trapbutton = getent ("trap7_button", "targetname");

    death_trigger delete();

    o1 = getent("trap7_o1","targetname");
    o2 = getent("trap7_o2","targetname");
    o3 = getent("trap7_o3","targetname");

    trap moveZ(-128, 0.5);
    clip moveZ(-128, 0.5);
    wait 1;
    trap moveX(128, 0.5);
    clip moveX(128, 0.5);
    while(1) 
    {
        trig waittill("triggerg", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        trap rotatepitch(-1080, 2.75);
        trap moveX(-305, 2.55);
        clip moveX(-305, 2.55);
        wait 2.55;
        trap rotatepitch(-1080, 2.75);
        clip rotatepitch(-1080, 2.75);

        trap moveTo(o1.origin, 1);
        clip moveTo(o1.origin, 1);
        wait 1;
        trap moveTo(o2.origin, 1);
        clip moveTo(o2.origin, 1);
        wait 1;
        trap moveTo(o3.origin, 0.75);
        clip moveTo(o3.origin, 0.75);
        wait 0.80;
        earthquake(0.7, 2, o3.origin, 500);

    }
}


trap8()
{
	level endon("triggerh");
    trapbutton = getent ("trap8_button", "targetname");
    trig = getent ("trig_trap8", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trapa = getent ("trap8_a", "targetname");
    trapb = getent ("trap8_b", "targetname");
    trapc = getent ("trap8_c", "targetname");
    trapa_death = getent ("trap8a_death", "targetname");
    trapb_death = getent ("trap8b_death", "targetname");
    trapc_death = getent ("trap8c_death", "targetname");
    trapbutton = getent ("trap8_button", "targetname");
    trap8a_sound = getent ("trap8a_sound", "targetname");
    trap8b_sound = getent ("trap8b_sound", "targetname");
    trap8c_sound = getent ("trap8c_sound", "targetname");

    trapc_death delete();
    trapb_death delete();
    trapa_death delete();


    while(1) 
    {
        trig waittill("triggerh", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        for(;;)
        {
            trapa moveZ (54, 0.5);
            trapb moveZ (-54, 0.5);
            trapc moveZ (54, 0.5);
            wait 0.8;
            trapa moveZ (-54, 0.5);
            trapb moveZ (54, 0.5);
            trapc moveZ (-54, 0.5);
            wait 0.8;
        }
    }
}

trap9()
{
	level endon("triggeri");
    trig = getent ("trig_trap9", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trap_right = getent ("trap9_a", "targetname");
    trap_left = getent ("trap9_b", "targetname");
    trapbutton = getent ("trap9_button", "targetname"); 
    while(1) 
    {
        trig waittill("triggeri", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        trap_left moveY(-136, 2);
        trap_right moveY(136, 2);   
        wait 3; 
        for(;;)
        {
            trap_left moveY(136, 1);
            trap_right moveY(-136, 1);
            wait 2;
            trap_left moveY(-136, 1);
            trap_right moveY(136, 1);
            wait 2;
        }
    }
}

trap10()
{
	level endon("triggerj");
    wait 2;
    trap_right = getent ("trap10_a", "targetname");
    trap_left = getent ("trap10_b", "targetname");

    o1 = getent("trap10_sound1","targetname");
    o2 = getent("trap10_sound2","targetname");


    trap_right moveTo(o1.origin, 1);
    trap_left moveTo(o2.origin, 1);

    trig = getent ("trig_trap10", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trapbutton = getent ("trap10_button", "targetname");    
    while(1) 
    {
        trig waittill("triggerj", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        for(;;)
        {
            trap_left rotateroll(720, 3);
            trap_right rotateroll(-720, 3);
            wait 5.5;
            trap_left rotateroll(-720, 3);
            trap_right rotateroll(720, 3);
            wait 5.5;
        }
    }
}
trap11()
{
	level endon("triggerk");
    trap_second_left = getent ("trap11_secondoor_left", "targetname");
    trap_second_right = getent ("trap11_secondoor_right", "targetname");
    trap_first_left = getent ("trap11_firstdoor_left", "targetname");
    trap_first_right = getent ("trap11_firstdoor_right", "targetname");

    trap_second_right_trig = getent ("trap11_secondoor_right_trig", "targetname");
    trap_second_right_trig enablelinkto(); 
    trap_second_right_trig linkto(trap_second_right);

    trap_second_left_trig = getent ("trap11_secondoor_left_trig", "targetname");
    trap_second_left_trig enablelinkto(); 
    trap_second_left_trig linkto(trap_second_left);

    trap_first_right_trig = getent ("trap11_firstdoor_right_trig", "targetname");
    trap_first_right_trig enablelinkto(); 
    trap_first_right_trig linkto(trap_first_right);

    trap_first_left_trig = getent ("trap11_firstdoor_left_trig", "targetname");
    trap_first_left_trig enablelinkto(); 
    trap_first_left_trig linkto(trap_first_left);

    level.trap11_first = 0;
    trig = getent ("trig_trap11", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trapbutton = getent ("trap11_button", "targetname");    
    while(1) 
    {
        trig waittill("triggerk", player);
        trig delete();
        level.trap11_first = 1;
    }
}


trap11_1()
{
    trap_second_left = getent ("trap11_secondoor_left", "targetname");
    trap_second_right = getent ("trap11_secondoor_right", "targetname");

    wait 99999999999099999999999;
    for(;;)
    {
        thread trap11_2();

        trap_second_right moveY(-176, 0.7);
        trap_second_left moveY(176, 0.7);
        wait 99999;
        trap_second_right moveY(176, 0.7);
        trap_second_left moveY(-176, 0.7);
    }  
}


trap11_2()
{
    trap_first_left = getent ("trap11_firstdoor_left", "targetname");
    trap_first_right = getent ("trap11_firstdoor_right", "targetname");

    wait 99909999999999999;
    if (level.trap11_first == 1)
    {
        trap_first_right moveY(-176, 0.7);
        trap_first_left moveY(176, 0.7);
        wait 0999999;
        trap_first_right moveY(176, 0.7);
        trap_first_left moveY(-176, 0.7);
    }  
}



trap11_init()
{

    trap_second_right = getent ("trap11_secondoor_right", "targetname");
    trap_first_right = getent ("trap11_firstdoor_right", "targetname");

    trap_second_left = getent ("trap11_secondoor_left", "targetname");
    trap_first_left = getent ("trap11_firstdoor_left", "targetname");

    trap_first_right notsolid();
    trap_second_right notsolid();
    trap_first_left notsolid();
    trap_second_left notsolid();

    trap_first_right hide();
    trap_second_right hide();
    trap_first_left hide();
    trap_second_left hide();

    trap_first_right moveX(-10160, 0.1);
    trap_second_right moveX(-10160, 0.1);
    trap_first_left moveX(-10160, 0.1);
    trap_second_left moveX(-10160, 0.1);
    wait 0.2;
    trap_first_right moveY(1088, 0.1);
    trap_second_right moveY(1088, 0.1);
    trap_first_left moveY(1088, 0.1);
    trap_second_left moveY(1088, 0.1);
    wait 0.2;
    trap_first_right moveZ(960, 0.1);
    trap_second_right moveZ(960, 0.1);
    trap_first_left moveZ(960, 0.1);
    trap_second_left moveZ(960, 0.1);
    wait 0.2;
    trap_first_right solid();
    trap_second_right solid();
    trap_first_left solid();
    trap_second_left solid();

    trap_first_right show();
    trap_second_right show();
    trap_first_left show();
    trap_second_left show();
}

trap12()
{
	level endon("triggerl");
    trig = getent ("trig_trap12", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trapbutton = getent ("trap12_button", "targetname");    
    while(1) 
    {
        trig waittill("triggerl", player);
        trig delete();
        thread trap12_a();
        thread trap12_b();
        thread trap12_c();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);  
    }
}


trap12_a()
{
	level endon("triggerm");
    trig = getent ("trap12_a_trig", "targetname");
    trap_a = getent ("trap12_a", "targetname");
    trig waittill("trigger", player);   
    while(1) 
    {
        trig waittill("triggerm", player);
        trap_a moveZ (-55, 1);
        wait 1.5;
        trap_a moveZ (55, 1);
        wait 1.5;   
    }
}


trap12_b()
{
	level endon("triggern");
    trig = getent ("trap12_b_trig", "targetname");
    trap_b = getent ("trap12_b", "targetname");
    trig waittill("trigger", player);   
    while(1) 
    {
        trig waittill("triggern", player);
        trap_b moveZ (-55, 1);
        wait 1.5;
        trap_b moveZ (55, 1);
        wait 1.5;
    }
}


trap12_c()
{
	level endon("triggero");
    trig = getent ("trap12_c_trig", "targetname");
    trap_c = getent ("trap12_c", "targetname"); 
    while(1) 
    {
        trig waittill("triggero", player);
        trap_c moveZ (-55, 1);
        wait 1.5;
        trap_c moveZ (55, 1);
        wait 1.5;   
    }
}


trap13()
{
	level endon("triggerp");
    trap1 = getent ("trap13_a", "targetname");
    trap2 = getent ("trap13_b", "targetname");
    trap3 = getent ("trap13_c", "targetname");
    trap4 = getent ("trap13_d", "targetname");
    trap5 = getent ("trap13_e", "targetname");

    death_a = getent ("trap13_a_death", "targetname");
    death_a enablelinkto(); 
    death_a linkto(trap1);
    death_b = getent ("trap13_b_death", "targetname");
    death_b enablelinkto(); 
    death_b linkto(trap2);
    death_c = getent ("trap13_c_death", "targetname");
    death_c enablelinkto(); 
    death_c linkto(trap3);
    death_d = getent ("trap13_d_death", "targetname");
    death_d enablelinkto(); 
    death_d linkto(trap4);
    death_e = getent ("trap13_e_death", "targetname");
    death_e enablelinkto(); 
    death_e linkto(trap5);

    trap1 moveZ (-126, 0.3);
    trap2 moveZ (-126, 0.3);
    trap3 moveZ (-126, 0.3);
    trap4 moveZ (-126, 0.3);
    trap5 moveZ (-126, 0.3);

    trap1_2 = getent ("trap13_a_2", "targetname");
    trap2_2 = getent ("trap13_b_2", "targetname");
    trap3_2 = getent ("trap13_c_2", "targetname");
    trap4_2 = getent ("trap13_d_2", "targetname");
    trap5_2 = getent ("trap13_e_2", "targetname");

    death_a_2 = getent ("trap13_a_death_2", "targetname");
    death_a_2 enablelinkto(); 
    death_a_2 linkto(trap1_2);
    death_b_2 = getent ("trap13_b_death_2", "targetname");
    death_b_2 enablelinkto(); 
    death_b_2 linkto(trap2_2);
    death_c_2 = getent ("trap13_c_death_2", "targetname");
    death_c_2 enablelinkto(); 
    death_c_2 linkto(trap3_2);
    death_d_2 = getent ("trap13_d_death_2", "targetname");
    death_d_2 enablelinkto(); 
    death_d_2 linkto(trap4_2);
    death_e_2 = getent ("trap13_e_death_2", "targetname");
    death_e_2 enablelinkto(); 
    death_e_2 linkto(trap5_2);

    trap1_2 moveZ (-126, 0.3);
    trap2_2 moveZ (-126, 0.3);
    trap3_2 moveZ (-126, 0.3);
    trap4_2 moveZ (-126, 0.3);
    trap5_2 moveZ (-126, 0.3);

    trapbutton = getent ("trap13_button", "targetname");
    trig = getent ("trig_trap13", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trapbutton = getent ("trap13_button", "targetname");
    while(1) 
    {
        trig waittill("triggerp", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        thread trap13_a();
        thread trap13_b();
        wait 0.5;
        trapbutton moveZ (2, 0.5);
    }
}


trap13_a()
{
    trap1 = getent ("trap13_a", "targetname");
    trap2 = getent ("trap13_b", "targetname");
    trap3 = getent ("trap13_c", "targetname");
    trap4 = getent ("trap13_d", "targetname");
    trap5 = getent ("trap13_e", "targetname");

    death_a = getent ("trap13_a_death", "targetname");
    death_a enablelinkto(); 
    death_a linkto(trap1);
    death_b = getent ("trap13_b_death", "targetname");
    death_b enablelinkto(); 
    death_b linkto(trap2);
    death_c = getent ("trap13_c_death", "targetname");
    death_c enablelinkto(); 
    death_c linkto(trap3);
    death_d = getent ("trap13_d_death", "targetname");
    death_d enablelinkto(); 
    death_d linkto(trap4);
    death_e = getent ("trap13_e_death", "targetname");
    death_e enablelinkto(); 
    death_e linkto(trap5);

    while(1) 
    {
        for(;;)
        {
            random3 = randomint(5);
            if (random3 == 0)
            {
                trap1 moveZ (126, 0.3);
                trap3 moveZ (126, 0.3);
                wait 1;
                trap1 moveZ (-126, 0.3);
                trap3 moveZ (-126, 0.3);
                wait 1;
            }
            if (random3 == 1)
            {
                trap1 moveZ (126, 0.3);
                trap4 moveZ (126, 0.3);
                wait 1;
                trap1 moveZ (-126, 0.3);
                trap4 moveZ (-126, 0.3);
                wait 1;
            }
            if (random3 == 2)
            {
                trap2 moveZ (126, 0.3);
                trap3 moveZ (126, 0.3);
                wait 1;
                trap2 moveZ (-126, 0.3);
                trap3 moveZ (-126, 0.3);
                wait 1;
            }
            if (random3 == 3)
            {
                trap2 moveZ (126, 0.3);
                trap4 moveZ (126, 0.3);
                wait 1;
                trap2 moveZ (-126, 0.3);
                trap4 moveZ (-126, 0.3);
                wait 1;
            }
            if (random3 == 4)
            {
                trap5 moveZ (126, 0.3);
                wait 1;
                trap5 moveZ (-126, 0.3);
                wait 1;
            }
        }
    }
}


trap13_b()
{
    trap1 = getent ("trap13_a_2", "targetname");
    trap2 = getent ("trap13_b_2", "targetname");
    trap3 = getent ("trap13_c_2", "targetname");
    trap4 = getent ("trap13_d_2", "targetname");
    trap5 = getent ("trap13_e_2", "targetname");

    death_a = getent ("trap13_a_death_2", "targetname");
    death_a enablelinkto(); 
    death_a linkto(trap1);
    death_b = getent ("trap13_b_death_2", "targetname");
    death_b enablelinkto(); 
    death_b linkto(trap2);
    death_c = getent ("trap13_c_death_2", "targetname");
    death_c enablelinkto(); 
    death_c linkto(trap3);
    death_d = getent ("trap13_d_death_2", "targetname");
    death_d enablelinkto(); 
    death_d linkto(trap4);
    death_e = getent ("trap13_e_death_2", "targetname");
    death_e enablelinkto(); 
    death_e linkto(trap5);


    while(1) 
    {
        for(;;)
        {
            random4 = randomint(5);
            if (random4 == 0)
            {
                trap1 moveZ (126, 0.3);
                trap3 moveZ (126, 0.3);
                wait 1;
                trap1 moveZ (-126, 0.3);
                trap3 moveZ (-126, 0.3);
                wait 1;
            }
            if (random4 == 1)
            {
                trap1 moveZ (126, 0.3);
                trap4 moveZ (126, 0.3);
                wait 1;
                trap1 moveZ (-126, 0.3);
                trap4 moveZ (-126, 0.3);
                wait 1;
            }
            if (random4 == 2)
            {
                trap2 moveZ (126, 0.3);
                trap3 moveZ (126, 0.3);
                wait 1;
                trap2 moveZ (-126, 0.3);
                trap3 moveZ (-126, 0.3);
                wait 1;
            }
            if (random4 == 3)
            {
                trap2 moveZ (126, 0.3);
                trap4 moveZ (126, 0.3);
                wait 1;
                trap2 moveZ (-126, 0.3);
                trap4 moveZ (-126, 0.3);
                wait 1;
            }
            if (random4 == 4)
            {
                trap5 moveZ (126, 0.3);
                wait 1;
                trap5 moveZ (-126, 0.3);
                wait 1;
            }
        }
    }
}


trap14()
{
	level endon("triggerq");
    trig = getent ("trig_trap14", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trap_a = getent ("trap14_a", "targetname");
    trap_b = getent ("trap14_b", "targetname");
    trap_c = getent ("trap14_c", "targetname");
    trap_d = getent ("trap14_d", "targetname");
    trap_e = getent ("trap14_e", "targetname");
    trap_f = getent ("trap14_f", "targetname");
    trapbutton = getent ("trap14_button", "targetname");

    while(1) 
    {
        trig waittill("triggerq", player);
        trig delete();
    }   
}


trap15()
{
	level endon("triggerr");


    fan_a = getent ("trap15_a_fan", "targetname");
    fan_b = getent ("trap15_b_fan", "targetname");
    fan_c = getent ("trap15_c_fan", "targetname");

    trigger_a = getent("trap15_trig_a", "targetname");
    trigger_b = getent("trap15_trig_b", "targetname");
    trigger_c = getent("trap15_trig_c", "targetname");

    trapbutton = getent ("trap15_button", "targetname");
    trig = getent ("trig_trap15", "targetname");
    trig setHintString ("^3Press [&&1] to activate");  
    trapbutton = getent ("trap15_button", "targetname");
    while(1) 
    {
        trig waittill("triggerr", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        thread trap15_a();
        thread trap15_b();
        thread trap15_c();
        fan_a rotateroll(3240, 9);
        fan_b rotateroll(-3240, 9);
        fan_c rotateroll(3240, 9);
        wait 9;
        trigger_a delete();
        trigger_b delete();
        trigger_c delete();

    }
}
trap15_a()
{
	level endon("triggers");
    trigger = getent("trap15_trig_a", "targetname");
    
    while(1)
    {
        trigger waittill ( "triggers", player );
        wait 1;
    }
}


trap15_b()
{
	level endon("triggert");
    trigger = getent("trap15_trig_b", "targetname");
    
    while(1)
    {
        trigger waittill ( "triggert", player );
        wait 1;
    }
}

trap15_c()
{
	level endon("triggeru");
    trigger = getent("trap15_trig_c", "targetname");
    
    while(1)
    {
        trigger waittill ( "triggeru", player );
        wait 1;
    }
}
trap16()
{
	level endon("triggerv");
    trig = getent ("trig_trap16", "targetname");
    trig setHintString ("^3Press [&&1] to activate");
    trapbutton = getent ("trap16_button", "targetname");

    trap_a = getent ("trap16_a", "targetname");
    trap_b = getent ("trap16_b", "targetname");
    trap_1 = getent ("trap16_1", "targetname");
    trap_2 = getent ("trap16_2", "targetname"); 


    while(1) 
    {
        trig waittill("triggerv", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        trap_1 delete();
        trap_2 delete();
        wait 1.2;
        trap_a moveY(72, 0.35);
        trap_b moveY(-72, 0.35);
        wait 0.35;
        for(;;)
        {
            trap_a moveY(-144, 0.7);
            trap_b moveY(144, 0.7);
            wait 0.7;
            trap_a moveY(144, 0.7);
            trap_b moveY(-144, 0.7);
            wait 0.7;
        }
    }
}




trap17init()
{
    trap_1_left = getent ("trap17_left_6", "targetname");   
    trap_1_left_trigger = getent ("trap17_left_6_trigger", "targetname");
    trap_1_left_trigger enablelinkto(); 
    trap_1_left_trigger linkto(trap_1_left);

    trap_2_left = getent ("trap17_left_2", "targetname");   
    trap_2_left_trigger = getent ("trap17_left_2_trigger", "targetname");
    trap_2_left_trigger enablelinkto(); 
    trap_2_left_trigger linkto(trap_2_left);

    trap_3_left = getent ("trap17_left_3", "targetname");   
    trap_3_left_trigger = getent ("trap17_left_3_trigger", "targetname");
    trap_3_left_trigger enablelinkto(); 
    trap_3_left_trigger linkto(trap_3_left);

    trap_7_left = getent ("trap17_left_7", "targetname");   
    trap_7_left_trigger = getent ("trap17_left_7_trigger", "targetname");
    trap_7_left_trigger enablelinkto(); 
    trap_7_left_trigger linkto(trap_7_left);

    trap_1_right = getent ("trap17_right_1", "targetname"); 
    trap_1_right_trigger = getent ("trap17_right_1_trigger", "targetname");
    trap_1_right_trigger enablelinkto(); 
    trap_1_right_trigger linkto(trap_1_right);

    trap_2_right = getent ("trap17_right_2", "targetname"); 
    trap_2_right_trigger = getent ("trap17_right_2_trigger", "targetname");
    trap_2_right_trigger enablelinkto(); 
    trap_2_right_trigger linkto(trap_2_right);

    trap_3_right = getent ("trap17_right_3", "targetname"); 
    trap_3_right_trigger = getent ("trap17_right_3_trigger", "targetname");
    trap_3_right_trigger enablelinkto(); 
    trap_3_right_trigger linkto(trap_3_right);

    trap_1_left moveY(64, 0.10);
    trap_2_left moveY(64, 0.10);
    trap_3_left moveY(64, 0.10); 
    trap_7_left moveY(64, 0.10);

    trap_1_right moveY(-64, 0.10);
    trap_2_right moveY(-64, 0.10); 
    trap_3_right moveY(-64, 0.10);

    wait 0.5;

    trap_1_left moveZ(-32, 0.10);
    trap_2_left moveZ(-32, 0.10);
    trap_3_left moveZ(-32, 0.10); 
    trap_7_left moveZ(-32, 0.10);

    trap_1_right moveZ(-32, 0.10);
    trap_2_right moveZ(-32, 0.10); 
    trap_3_right moveZ(-32, 0.10);
}


trap17()
{
	level endon("triggerx");
    trig = getent ("trig_trap17", "targetname");
    trig setHintString ("^3Press [&&1] to activate");
    trapbutton = getent ("trap17_button", "targetname");

    while(1) 
    {
        trig waittill("triggerx", player);
        trig delete();
        trapbutton moveZ (-2, 0.5);
        wait 0.5;
        trapbutton moveZ (2, 0.5);
        thread trap17_left_a();
        wait 0.5;
        thread trap17_right_a();
        wait 0.5;
        thread trap17_left_b();
        wait 0.5;
        thread trap17_right_b();
        wait 0.5;
        thread trap17_left_c();
        wait 0.5;
        thread trap17_right_c();
        wait 0.5;
        thread trap17_left_d();

    }
}


trap17_left_a()
{
    trap_1_left = getent ("trap17_left_6", "targetname");   
    trap_1_left_trigger = getent ("trap17_left_6_trigger", "targetname");
    trap_1_left_trigger enablelinkto(); 
    trap_1_left_trigger linkto(trap_1_left);

    trap_1_left rotateroll(90, 0.7);
    wait 2.5;
    trap_1_left rotateroll(-90, 0.7);
}

trap17_left_b()
{
    trap_2_left = getent ("trap17_left_2", "targetname");   
    trap_2_left_trigger = getent ("trap17_left_2_trigger", "targetname");
    trap_2_left_trigger enablelinkto(); 
    trap_2_left_trigger linkto(trap_2_left);

    trap_2_left rotateroll(90, 0.7);
    wait 2.5;
    trap_2_left rotateroll(-90, 0.7);
}

trap17_left_c()
{
    trap_3_left = getent ("trap17_left_3", "targetname");   
    trap_3_left_trigger = getent ("trap17_left_3_trigger", "targetname");
    trap_3_left_trigger enablelinkto(); 
    trap_3_left_trigger linkto(trap_3_left);

    trap_3_left rotateroll(90, 0.7);
    wait 2.5;
    trap_3_left rotateroll(-90, 0.7);
}

trap17_left_d()
{
    trap_7_left = getent ("trap17_left_7", "targetname");   
    trap_7_left_trigger = getent ("trap17_left_7_trigger", "targetname");
    trap_7_left_trigger enablelinkto(); 
    trap_7_left_trigger linkto(trap_7_left);

    trap_7_left rotateroll(90, 0.7);
    wait 2.5;
    trap_7_left rotateroll(-90, 0.7);
}

trap17_right_a()
{
    trap_1_right = getent ("trap17_right_1", "targetname"); 
    trap_1_right_trigger = getent ("trap17_right_1_trigger", "targetname");
    trap_1_right_trigger enablelinkto(); 
    trap_1_right_trigger linkto(trap_1_right);

    trap_1_right rotateroll(-90, 0.7);
    wait 2.5;
    trap_1_right rotateroll(90, 0.7);
}

trap17_right_b()
{
    trap_2_right = getent ("trap17_right_2", "targetname"); 
    trap_2_right_trigger = getent ("trap17_right_2_trigger", "targetname");
    trap_2_right_trigger enablelinkto(); 
    trap_2_right_trigger linkto(trap_2_right);

    trap_2_right rotateroll(-90, 0.7);
    wait 2.5;
    trap_2_right rotateroll(90, 0.7);
}

trap17_right_c()
{
    trap_3_right = getent ("trap17_right_3", "targetname"); 
    trap_3_right_trigger = getent ("trap17_right_3_trigger", "targetname");
    trap_3_right_trigger enablelinkto(); 
    trap_3_right_trigger linkto(trap_3_right);

    trap_3_right rotateroll(-90, 0.7);
    wait 2.5;
    trap_3_right rotateroll(90, 0.7);
}

part2_jumper() 
{
    trigger = getent ("part2_jumper_trigger", "targetname");
    target = getent ("part2_jumper_origin", "targetname");
    
    while(1) {
        trigger waittill("trigger", player);
        player setorigin (target.origin);
        player setplayerangles (target.angles);
    }
}
jumper_secret_end() 
{
    trigger = getent ("jumper_end_secret", "targetname");
    
    while(1)
    {
        trigger waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}
secret1() {
    trigger = getent ("secret_trigger1", "targetname");
    
    while(1) {
        trigger waittill("trigger", player);
        player.secret = 1;
    }
}
secret2() {
    trigger = getent ("secret_trigger2", "targetname");
    
    while(1) {
        trigger waittill("trigger", player);
        player.secret = 2;
    }
}
secret3() {
    trigger = getent ("secret_trigger3", "targetname");
    
    while(1) {
        trigger waittill("trigger", player);
        player.secret = 3;
    
    }
}
secret4() {
    trigger = getent ("secret_trigger4", "targetname");
    
    while(1) {
        trigger waittill("trigger", player);
        player.secret = 4;

    }
}
secret() 
{
    trigger = getent ("secret_trig_fail", "targetname");

    origin0 = getent ("secret_origin0", "targetname");
    origin1 = getent ("secret_origin1", "targetname");
    origin2 = getent ("secret_origin2", "targetname");
    origin3 = getent ("secret_origin3", "targetname");
    origin4 = getent ("secret_origin4", "targetname");
    origin5 = getent ("secret_origin5", "targetname");

    while(1) 
    {
        trigger waittill("trigger", player);

        if (player.secret == 0)
        {
            player freezeControls(1);
            player setorigin (origin0.origin);
            player setplayerangles (origin0.angles);
            wait 0.1;
            player freezeControls(0);
        }
        else if (player.secret == 1)
        {
            player freezeControls(1);
            player setorigin (origin1.origin);
            player setplayerangles (origin1.angles);
            wait 0.1;
            player freezeControls(0);
        }
        else if (player.secret == 2)
        {
            player freezeControls(1);
            player setorigin (origin2.origin);
            player setplayerangles (origin2.angles);
            wait 0.1;
            player freezeControls(0);
        }
        else if (player.secret == 3)
        {
            player freezeControls(1);
            player setorigin (origin3.origin);
            player setplayerangles (origin3.angles);
            wait 0.1;
            player freezeControls(0);
        }
        else if (player.secret == 4)
        {
            player freezeControls(1);
            player setorigin (origin4.origin);
            player setplayerangles (origin4.angles);
            wait 0.1;
            player freezeControls(0);
        }
    }
}