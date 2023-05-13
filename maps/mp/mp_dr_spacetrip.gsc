#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
    maps\mp\_load::main();
	maps\mp\_teleport::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
	
    thread sr\api\_map::createSpawn((48,-5684,-296),270);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^3Medium Secret;^1Hard Secret;");
    thread sr\api\_speedrun::createTeleporter((-285.603, -5946.77, -355.875), 60, 70, (-3153, -7030, -517), 179, "freeze", "yellow", "secret_0");
    thread sr\api\_speedrun::createTeleporter((423.101, -5945.51, -355.875), 60, 70, (3197, -4699, 181), 315, "freeze", "orange", "secret_1");
    thread sr\api\_speedrun::createTeleporter((-292.093, -5759.71, -355.875), 60, 70, (3093, 6067, -517), 1, "freeze", "red", "secret_2");
    thread sr\api\_speedrun::createEndMap((14310.5, -363.469, -355.875),115,100, "normal_0");
    thread sr\api\_speedrun::createEndMap((-5877.82, -9706.56, -597.803),110,100, "secret_0");
    thread sr\api\_speedrun::createEndMap((8107.27, -10606, -1276.88),155,100, "secret_1");
    thread sr\api\_speedrun::createEndMap((5608.12, 11794.7, -1531.88),50,100, "secret_2");
	
    //thread anti_glitch();
	thread main_fall();
	thread lift();
	//thread lift2();
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
	//thread trap14();
	
}

anti_glitch()
{
auto21=getent("auto21","targetname");
auto24=getent("auto24","targetname");
auto27=getent("auto27","targetname");
auto37=getent("auto37","targetname");

auto21 delete();
auto24 delete();
auto27 delete();
auto37 delete();

}

main_fall()
{
	floor_good=getent("floor_good","targetname");
    door=getent("door","targetname");

	floor_good delete();
    door delete();
}

lift()
{
object1 = getent("lift","targetname");

object1 moveX(325,0.1);
wait 0.1;
object1 rotateYaw(-90,0.1);
wait 0.2;
object1 moveY(33,0.1);
}

lift2()
{
object1 = getent("lift2","targetname");
trigger = getent("lift2_trigger","targetname"); 
trigger waittill ("trigger", player );
trigger delete();
while(1)
{
object1 movez(820, 5);
object1 waittill("movedone");
wait(2);
object1 movez(-820, 5);
object1 waittill("movedone");
wait(2);
}
}

finishdoor()
{
door=getent("door","targetname");
	
door delete();

}

trap1()
{
    trig = getEnt( "trig_trap1", "targetname" );
	object1 = getent("trap1","targetname");
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 5);
		wait 5;
    }
}

trap2()
{
    trig = getEnt( "trig_trap2", "targetname" );
    object1 = getent("trap2a","targetname");
	object2 = getent("trap2b","targetname");
 
    trig waittill ("trigger");
    trig delete();
	
    while(1) 
    {
        object1 rotateroll(360, 5);
		object2 rotateYaw(360, 5);
		wait 10;
        object1 rotateYaw(360, 5);
		object2 rotateroll(360, 5);
		wait 10;
		object1 rotateroll(360, 5);
		object2 rotateYaw(360, 5);
		wait 10;
        object1 rotateYaw(360, 5);
		object2 rotateroll(360, 5);
    }
}

trap3()
{
    trig = getEnt( "trig_trap3", "targetname" );
	object1 = getent("trap3","targetname");
 
    trig waittill ("trigger");
    trig delete();
	
    while(1) 
    {
        object1 rotateroll(360, 10);
		wait 2;
		object1 rotateroll(360, 10);
		wait 2;
		object1 rotateroll(360, 10);
		wait 2;
    }
}

trap4()
{
    trig = getEnt( "trig_trap4", "targetname" );
    object1 = getent("trap4a","targetname");
	object2 = getent("trap4b","targetname");
	object3 = getent("trap4c","targetname");
 
    trig waittill ("trigger");
    trig delete();
	
    while(1) 
    {
        object1 rotateroll(360, 2);
		wait 2;
		object2 rotateYaw(360, 2);
		wait 2;
		object3 rotateroll(360, 2);
		wait 2;
		object1 rotateroll(360, 2);
		wait 2;
		object2 rotateYaw(360, 2);
		wait 2;
		object3 rotateroll(360, 2);
		wait 2;
    }
}

trap5()
{
    trig = getEnt( "trig_trap5", "targetname" );
    object1 = getent("trap5","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateroll(360, 5);
		wait 5;
    }
}

trap6()
{
    trig = getEnt( "trig_trap6", "targetname" );
	object1 = getent("trap6","targetname");
    trig waittill ("trigger");
       
     while(1)
    {
	    object1 rotateYaw(360, 0.5);
		wait 5;
		object1 rotateYaw(360, 0.5);
		wait 5;
		object1 rotateYaw(360, 0.5);
		wait 5;
		object1 rotateYaw(360, 0.5);
		wait 5;
    }
}

trap7()
{
    trig = getEnt( "trig_trap7", "targetname" );
    object1 = getent("trap7","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateYaw(360, 5);
		wait 5;
    }
}

trap8()
{
    trig = getEnt( "trig_trap8", "targetname" );
    object1 = getent("trap8a","targetname");
	object2 = getent("trap8b","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateroll(360, 5);
		object2 rotateroll(360, 5);
		wait 5;
    }
}

trap9()
{
    trig = getEnt( "trig_trap9", "targetname" );
    object1 = getent("trap9a","targetname");
	object2 = getent("trap9b","targetname");
	object3 = getent("trap9c","targetname");
	object4 = getent("trap9d","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotatePitch(360, 2);
		object2 rotatePitch(360, 2);
		object3 rotatePitch(360, 2);
		object4 rotatePitch(360, 2);
		wait 2;
		object1 rotatePitch(360, 2);
		object2 rotatePitch(360, 2);
		object3 rotatePitch(360, 2);
		object4 rotatePitch(360, 2);
		

    }
}

trap10()
{
    trig = getEnt( "trig_trap10", "targetname" );
    object1 = getent("trap10","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateYaw(360, 10);
		wait 5;
		object1 rotateYaw(360, 10);
		wait 5;
		object1 rotateYaw(360, 10);
		wait 5;
    }
}

trap11()
{
    trig = getEnt( "trig_trap11", "targetname" );
    object1 = getent("trap11","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateYaw(360, 10);
		wait 5;
		object1 rotateYaw(360, 10);
		wait 5;
		object1 rotateYaw(360, 10);
		wait 5;
    }
}

trap12()
{
    trig = getEnt( "trig_trap12", "targetname" );
    object1 = getent("trap12a","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 delete();
    }
}

trap13()
{
    trig = getEnt( "trig_trap13", "targetname" );
    object1 = getent("trap13","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateYaw(360, 2);
		wait 2;
    }
}

trap14()
{
    trig = getEnt( "trig_trap14", "targetname" );
    object1 = getent("trap14a","targetname");
	object2 = getent("trap14b","targetname");
	object3 = getent("trap14c","targetname");
	object4 = getent("trap14d","targetname");
	object5 = getent("trap14e","targetname");
	object6 = getent("trap14f","targetname");
	object7 = getent("trap14g","targetname");
	object8 = getent("trap14h","targetname");
	object9 = getent("trap14i","targetname");
	object10 = getent("trap14j","targetname");
 
    trig waittill ("trigger");
	
    while(1) 
    {
        object1 rotateYaw(360, 5);
		object3 rotateYaw(360, 5);
		object5 rotateYaw(360, 5);
		object7 rotateYaw(360, 5);
		object9 rotateYaw(360, 5);
		wait 2;
		object2 rotateYaw(360, 5);
		object4 rotateYaw(360, 5);
		object6 rotateYaw(360, 5);
		object8 rotateYaw(360, 5);
		object10 rotateYaw(360, 5);
    }
}
