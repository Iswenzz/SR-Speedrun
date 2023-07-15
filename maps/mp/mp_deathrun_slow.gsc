#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
	thread sr\api\_defrag::weapons("");
thread sr\api\_map::createSpawnOrigin((-702, -1082, 192), 89);

	maps\mp\_load::main();

		thread sr\api\_speedrun::createNormalWays("Normal Way;");


	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread trap1();
	thread trap2();
	thread trap3();
	thread trap5();
	thread trap6();


	addTriggerToList( "trap1_trig" );
	addTriggerToList( "trap2_trig" );
	addTriggerToList( "trap3_trig" );
	addTriggerToList( "trap4_trig" );
	addTriggerToList( "trap5_trig" );
	addTriggerToList( "trap6_trig" );



}
addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
trap1()
{
	level endon("triggerafaf");
	trig = getent ("trap1_trig" , "targetname");
	brush = getent ("trap1" , "targetname");

	trig waittill ("triggerafaf", player);
	trig delete();

	while(1)
	{
		brush rotateyaw (360,4);
		wait 6;
	}

}
trap2()
{
	level endon("triggerafzfzfzaf");
	trig = getent ("trap2_trig" , "targetname");
	brush = getent ("trap2" , "targetname");

	trig waittill ("triggerafzfzfzaf", player);
	trig delete();

	while(1)
	{
		brush rotateyaw (360,2);
		wait 1;
	}

}

trap3()
{
	level endon("triggerafzcbgzaf");
	trig = getEnt("trap3_trig","targetname");
	brush1 = getEnt("trap3","targetname");
	brush2 = getEnt("trap3a","targetname");


	trig waittill("triggerafzcbgzaf", player);
	trig delete();


		while( 1 )
	{
		brush1 moveY (-384,2);
		brush2 moveY (384,2);
		wait 1;
		brush1 moveY (384,2);
		brush2 moveY (-384,2);
		wait 1;
	}
}

trap5()
{
	level endon("triggerafzzedzdaf");
	trig = getent ("trap5_trig" , "targetname");
	brush = getent ("trap5" , "targetname");

	trig waittill ("triggerafzzedzdaf", player);
	trig delete();

	brush moveZ (256 , 1);
	wait 5;
	brush moveZ (-256 , 3);

}
trap6()
{
trig = getEnt ("trap6_trig", "targetname");
hurt = getEnt ("trap6_spikeshurt", "targetname");
spikes = getEnt ("trap6", "targetname");
hurt delete ();
spikes delete ();
trig delete ();

}