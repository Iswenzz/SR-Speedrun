main()
{
              maps\mp\_load::main();
             thread sr\api\_speedrun::createNormalWays("Normal Way");
             thread sr\api\_map::createSpawn((-2335,-2954,76),89);
             thread sr\api\_speedrun::createEndMap((-2354.89, 3768.64, 16.125), 125, 115);
             thread door();
             //thread trap1();
             //thread trap2();
             //thread trap3();
             //thread trap4();
            // thread trap5();
            // thread trap6();
            // thread trap7();
            // thread trap8();
             thread door2();
            // thread trap9();
            // thread trap9_1();
             //thread door3();

            addTriggerToList("trap1_trig");
            addTriggerToList("trap2_trig");
            addTriggerToList("trap3_trig");
            addTriggerToList("trap4_trig");
            addTriggerToList("trap5_trig");
            addTriggerToList("trap6_trig");
            addTriggerToList("trap7_trig");
            addTriggerToList("trap8_trig");
            addTriggerToList("trap9_trig");

}


addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}


door()
{ 
                  trig = getEnt("door_trig","targetname");
                  brush = getEnt("door","targetname");
                    trig delete();
                    {
                                          brush delete();
                    }
}
trap1()
{
               trig = getEnt( "trap1_trig","targetname" );
               brush1 = getEnt( "trap1.1", "targetname" );
               brush2 = getEnt( "trap1.2", "targetname" );
               
                 trig waittill("trigger");
                 {
                                          brush1 moveX(-240,1);
                                          brush2 moveX(240,1);
                                          wait 1;
                 }
                 trig waittill("trigger");
                 trig delete();
                 {
                                          brush1 moveX(240,1);
                                          brush2 moveX(-240,1);
                                          wait 1;
                 }
}
trap2()
{ 
              trig = getEnt("trap2_trig","targetname");
              brush = getEnt("trap2","targetname");

                    trig waittill("trigger");
                    trig delete();
                    brush delete();
}
trap3()
{ 
              trig = getEnt("trap3_trig","targetname");
              brush = getEnt("trap3","targetname");

                    trig waittill("trigger");
                    trig delete();
                    brush delete();
}
trap4()
{
                  trig = getEnt("trap4_trig","targetname");
                  brush = getEnt("trap4","targetname");
                  
                 trig waittill("trigger");
                 trig delete();
                 
                 while(true)
                 {  
                               brush rotatepitch(360,1);
                               wait 1;
                 }
}
trap5()
{
                  trig = getEnt("trap5_trig","targetname");
                  brush = getEnt("trap5","targetname");
                  
                 trig waittill("trigger");
                 trig delete();
                 
                 while(true)
                 {  
                               brush rotateYaw(360,2);
                               wait 1;
                 }
}
trap6()
{
                  trig = getEnt("trap6_trig","targetname");
                 rotate = getEnt("trap6","targetname");
                  
                 trig waittill("trigger");
                 trig delete();
                 
                 while( isdefined( rotate ) )
                 {    
                               rotate rotateroll(-360,5);
                               wait 2;
                 }
}
trap7()
{
                   trig = getEnt( "trap7_trig", "targetname" );
	brushGroup1 = getEntArray( "trap7.1", "targetname" );
	brushGroup2 = getEntArray( "trap7.2", "targetname" );

	trig waittill("trigger");
	trig delete();
	
	brushGroup1[randomInt(brushGroup1.size)] notSolid();
	brushGroup2[randomInt(brushGroup2.size)] notSolid();
}
trap8()
{
                 trig = getEnt("trap8_trig","targetname");
                 brush = getEnt("trap8","targetname");

                 trig waittill("trigger");
                 trig delete();
                 {
                                   brush moveZ(144,1);
                                   wait 3;
                                   brush moveZ(-144,2);
                 }
}
door2()
{ 
                  trig = getEnt("door2_trig","targetname");
                  brush = getEnt("door2","targetname");
                    trig delete();
                    {
                                          brush delete();
                    }
}
trap9()
{ 
                  trig = getEnt("trap9_trig","targetname");
                  brush1 = getEnt( "trap9.1", "targetname" );
                  brush2 = getEnt( "trap9.2", "targetname" );
                  brush3 = getEnt( "trap9.3", "targetname" );
                  brush4 = getEnt( "trap9.4", "targetname" );
                   
                  trig waittill("trigger");
                    
                    while(true)
                    {
                             brush1 rotateYaw(360,2);
                             brush2 rotateYaw(360,2);
                             brush3 rotateYaw(360,2);
                             brush4 rotateYaw(360,2);
                             wait 1;
                     }
}
trap9_1()
{
                  trig = getEnt("trap9_trig","targetname");
                  brush1 = getEnt( "trap9.1", "targetname" );
                  brush3 = getEnt( "trap9.3", "targetname");

                  trig waittill("trigger");
                  trig delete();
                  {     
                          brush1 moveX(-300,3);
                          brush3 moveX(-300,3);
                          wait 1;
                  }
                   while(1)
                  {
                         brush1 moveX(600,3);
                         brush3 moveX(600,3);
                         wait 1;
                         brush1 moveX(-600,3);
                         brush3 moveX(-600,3);
                         wait 1;
                    }
}
door3()
{
                  trig = getEnt("door3_trig","targetname");
                  brush = getEnt("door3","targetname");
                    trig delete();
                  {
                    brush delete();
                  }
}	