main()
{
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"]= "desert";


thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_map::createSpawn((169,-1518,-126),90);
thread sr\api\_speedrun::createEndMap((-739.39, -346.266, 400.625), 65, 50);

//thread dooro();
//thread doorx();
//thread doora();
thread doorq();
//thread doorl();
thread vecicka();
}


dooro()
{
trigdoor = getent ("trap1trig" , "targetname");
dooro = getent ("trap1" ,"targetname" );
trigdoor waittill ("trigger",player);
trigdoor delete ();
dooro moveX (-300 , 1);
wait 5;
dooro moveX (200 , 1);
wait 1;
dooro moveX (-200 , 1);
wait 1;
dooro moveX (250 , 1);
wait 1;
dooro moveX (-250 , 1);
wait 1;
dooro moveX (300 , 1);
}



doorx()
{
trigdoor = getent ("trap2trig" , "targetname");
doorx = getent ("trap2" ,"targetname" );
trigdoor waittill ("trigger",player);
trigdoor delete ();
doorx moveZ (-1000 , 3);
wait 15;
doorx moveZ (1000 , 3);
wait 3;
}

doora()
{
trigdoor = getent ("trap3trig" , "targetname");
doora = getent ("trap3" ,"targetname" );
trigdoor waittill ("trigger",player);
trigdoor delete ();
doora moveZ (1000 ,0.01);
}


doorq()
{
doorq = getent ("trap5" ,"targetname" );

doorq delete();
}

doorl()
{
trigdoor = getent ("trap6trig" , "targetname");
doorl = getent ("trap6" ,"targetname" );
trigdoor waittill ("trigger",player);
trigdoor delete ();
doorl moveX (-1000 , 2);
wait 4;
doorl moveY (1000 , 6);
}

vecicka()
{
vecicka = getent ("trap7" ,"targetname" );

vecicka delete();
}