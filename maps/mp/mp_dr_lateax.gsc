/// Map by LateAX and CM'death ///

main() 
{
maps\mp\_load::main(); 
 
game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

/// Dvars ///      
setdvar("r_specularcolorscale", "1");
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setDvar("bg_falldamagemaxheight", 99999); /* This removes fall damage */
setDvar("bg_falldamageminheight", 99998); /* This removes fall damage */

thread sr\api\_map::createSpawn((3237,-540,60),180);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createTeleporter((-1231.43, -544.228, -911.875), 115, 100, (-2865, -544, -852), 180, "freeze", "yellow");

/// Startdoor opening ///
thread startdoor();

/// Rescues you if you fail ///
thread end_rescue();

/// Traps ///
thread trap3();
thread trap6();
thread trap7();


}

/// Stardoor opening ///
startdoor() 
{
door = getent("startdoor","targetname");

door delete();

}

/// Rescues you if you fail ///
end_rescue()
{
   trig = getent("trig_end_rescue", "targetname");
   tele = getent ("orig_end_rescue", "targetname");

   for(;;)
    {   
     trig waittill("trigger", player);
	 player setOrigin(tele.origin);
     player setPlayerAngles(tele.angles);
    }
}

/// Traps ///
trap3()
{
   hurta = getent("trap3_1_hurt", "targetname");
   hurtb = getent("trap3_2_hurt", "targetname");
   hurtc = getent("trap3_3_hurt", "targetname");
   hurtd = getent("trap3_4_hurt", "targetname");
   laser1 = getent("trap3_1_laser", "targetname");
   laser2 = getent("trap3_2_laser", "targetname");
   laser3 = getent("trap3_3_laser", "targetname");
   laser4 = getent("trap3_4_laser", "targetname");

    hurta delete();
	hurtb delete();
    hurtc delete();
    hurtd delete();

    laser1 delete();
    laser2 delete();
    laser3 delete();
    laser4 delete();

}   


trap6() 
{
pusher = getEnt("trap6_push", "targetname");
pusher_hurt = getEnt("trap6_hurt", "targetname");


pusher_hurt delete();


}

trap7()
{   
hurta = getent("trap7_hurt_1", "targetname");
hurtb = getent("trap7_hurt_2", "targetname");
hurtc = getent("trap7_hurt_3", "targetname");
hurtd = getent("trap7_hurt_4", "targetname");
   

hurta delete();
hurtb delete();
hurtc delete();
hurtd delete();


}
