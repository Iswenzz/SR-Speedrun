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

  setDvar("bg_falldamagemaxheight", 99999);
   setDvar("bg_falldamageminheight", 99998);

   addTriggerToList("trig_trap1remove");
   addTriggerToList("trig_trap1remove2");
   addTriggerToList("trig_trap3");

thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_map::createSpawn((466,870,-52),357);

  thread vistic_logo();
  //thread trap1remove();
  //thread trap1remove2();
  //thread trap3();
  thread water();

}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

vistic_logo()
{
 vistic_logo = getent("vistic_logo","targetname");
	                                  
 vistic_logo delete();
      
}

trap1remove()
{
     plat1 = getent("plat1remove", "targetname");
     trig = getent("trig_trap1remove", "targetname");
     trig setHintString("^7 Remove 2nd platform");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
   
   {
	   plat1 notsolid();
       plat1 hide();
	   wait 5;
	   plat1 solid();
       plat1 show();
      wait 5;
    }
}

trap1remove2()
{
     plat2 = getent("plat2remove", "targetname");
     trig = getent("trig_trap1remove2", "targetname");
     trig setHintString("^7 Remove 5th platform");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
   
   {
	   plat2 notsolid();
       plat2 hide();
	   wait 5;
	   plat2 solid();
       plat2 show();
       wait 5;
    }
}


trap3()
{
     trap3 = getent("trap3", "targetname");
     trig = getent("trig_trap3", "targetname");
     trig setHintString("^7 Vanish the glass");
     trig waittill ("trigger");
     trig setHintString("^7Activated");
   
   {
	   trap3 notsolid();
       trap3 hide();
    }
}

water()
{
drown_water = getent("drown_water", "targetname");

for(;;)
{

drown_water waittill( "trigger", player );

player Suicide();

}

}