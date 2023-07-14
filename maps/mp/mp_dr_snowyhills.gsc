#include common_scripts\utility;
#include maps\mp\_utility;
main()
{

	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1.85" );


    thread Start();
    thread StartingThings();
	//thread JumpPad1();
	//thread JumpPad2();

	thread sr\api\_map::createSpawn((505,-979,76),89);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createTeleporter((509.722, 952.438, 208.125), 100, 100, (409, 2184, 908), 178, "freeze", "blue");
    thread sr\api\_speedrun::createTeleporter((-4096.1, 3522.63, -815.875), 100, 100, (-4103, 4482, 61), 90, "freeze", "blue");
	thread sr\api\_speedrun::createEndMap((3264.89, 4611.97, -2695.88), 185, 200, "normal_0");

}

Start()
{
startdoor = getEnt("StartDoor", "targetname");

startdoor delete();

	
}

StartingThings()
{
    Trap3 = getEnt("Trap3", "targetname");Trap3 hide();Trap3 notSolid();
}

JumpPad1()
{
	trigger = getent("Jump1","targetname");
    for(;;)
    {
    	trigger waittill("trigger",player);
        if(self.state == true)
        {
        bouncer(player,2.5);
        wait 0.05;
        //player transmit(80,2);
        wait 0.05;
        }
        else
        {
            self hide();
            self notSolid();
            wait 3;
            self show();
            self Solid();
        }
    }
}

JumpPad2()
{
	trigger = getent("Jump2","targetname");
    for(;;)
    {
    	trigger waittill("trigger",player);
        if(self.state == true)
        {
            bouncer(player,2.5);
            wait 0.05;
            //player transmit(80,2);
            wait 0.05;
        }
        else
        {
            self hide();
            self notSolid();
            wait 3;
            self show();
            self Solid();
        }
    }
}


bouncer(who,strenght)
{
	oldpos = who.origin;
	playFx ( level.bounce, who.origin );
    for(i=0;i<strenght;i++)
    {
    who.health += 170;
    who finishPlayerDamage(who, level.jumpattacker, 170, 0, "MOD_FALLING", "jump_mp", who.origin, AnglesToForward((-90,0,0)), "none", 0);
    }
}