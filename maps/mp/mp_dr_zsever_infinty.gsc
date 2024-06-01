main()
{  
    trigger = getent("tp_end","targetname");
    trigger.targetname = "endmap_trig";
    
    maps\mp\_load::main();
         
    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

   
    
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((75, 924, 4303), 270);
    thread sr\api\_speedrun::createTeleporter((62.6715, -2326, 4242.63), 385, 100, (66, -2714, 4858), 270, "freeze");
    thread sr\api\_speedrun::createTeleporter((252.058, 923.982, 4242.63), 60, 100, (-263, 967, 77), 270, "freeze", "yellow", "secret_0");
   
    thread start();
    thread sec_finish();

}

start()
{
    door = getent("startdoor","targetname");
    door1 = getent("startdoor1","targetname");
    door2 = getent("sec","targetname");
    trap1 = getent("trap1","targetname");
   
 
    door delete();
    door1 delete();
    door2 delete();
    trap1 movey(-200,0.1);
   
}

sec_finish()
{
trig = getEnt("secret_2nd_tp","targetname");


for(;; )
   {
    trig waittill("trigger", player);

	player thread sr\api\_speedrun::finishWay("secret_0");
   

   }
}