main()
{
 maps\mp\_load::main();

    game["allies"] = "Jumper";
    game["axis"] = "Activator";
    game["attackers"] = "allies";
    game["defenders"] = "axis";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((-132, 1, 76), 0);
    thread sr\api\_speedrun::createEndMap((6442.57, -13.028, -7.87032), 100, 100);

 
    thread startdoor();
    thread trap3();
    thread trap6();

}

startdoor()
{
    door = getEnt( "startdoor", "targetname" );

    door delete();
}

trap3()
{
    brush1 = getEnt( "trap3_updown1", "targetname" );
    brush2 = getEnt( "trap3_updown2", "targetname" );
    brush3 = getEnt( "trap3_downup", "targetname" );
   
    brush1 rotateYaw(90,0.1);
    brush2 rotateYaw(90,0.1);
    brush3 delete();
    brush1 waittill ("rotatedone");
    brush1 movex(-200,0.1);
    
    
}

trap6()
{
    brush = getEnt( "trap6_klein2", "targetname" );

   
    brush moveY( 200, 0.1);
    brush waittill ("movedone");
    brush rotateRoll(90,0.1);
    brush waittill ("rotatedone");
    brush moveZ (-100,0.1);
  
}