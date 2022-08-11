main()
{
 maps\mp\_load::main();
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";
 
	setdvar( "r_specularcolorscale", "1" );
    setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

    thread sr\api\_map::createSpawn((122,-2,64),360);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");

    thread prisondoor1();
    thread prisondoor2();
    thread prisondoor3();
    thread housedoor();
    thread teleport1();
    thread trap1();
    thread trap3();
    thread trap4();
}

prisondoor1()
{
door = getent("prisondoor","targetname");
 
door delete();
}

prisondoor2()
{
door = getent("prisondoor2a","targetname");
door2 = getent("prisondoor2b","targetname");

door delete();
door2 delete();
}

prisondoor3()
{
door1 = getent("prisondoor3a", "targetname");
door2 = getent("prisondoor3b", "targetname");
   
door1 delete();
door2 delete();
   
}   

housedoor()
{
door = getent("housedoor", "targetname");
   
door delete();
   
}   

teleport1()
{
trig = getent("trig_tpa", "targetname");
tele1 = getent ("origin_tpa", "targetname");

   for(;;)
    {   
    trig waittill("trigger", player);
	player setOrigin(tele1.origin);
    player setPlayerAngles(tele1.angles);
    }
}

trap1()
{
platform = getent("trap1", "targetname");
     
platform solid();
platform show();
	
}

trap3()
{
hurt = getent("trap3_hurt", "targetname");
  
hurt delete();
}   

trap4()
{
laser = getent("trap4a", "targetname");
laserb = getent("trap4b", "targetname");
laserc = getent("trap4c", "targetname");
laserd = getent("trap4d", "targetname");
lasere = getent("trap4e", "targetname");
laserf = getent("trap4f", "targetname");
hurta = getent("trap4_hurta", "targetname");
hurtb = getent("trap4_hurtb", "targetname");
hurtc = getent("trap4_hurtc", "targetname");
hurtd = getent("trap4_hurtd", "targetname");
hurte = getent("trap4_hurte", "targetname");
hurtf = getent("trap4_hurtf", "targetname");
   
laser delete();
laserb delete();
laserc delete();
laserd delete();
lasere delete();
laserf delete();
hurta delete();
hurtb delete();
hurtc delete();
hurtd delete();
hurte delete();
hurtf delete();
}   