#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
main()
{
trigger = spawn( "trigger_radius", (6869.81, 512.292, 544.125), 0, 315, 80 );
trigger.targetname = "endmap_trig";
trigger.radius = 315;
        maps\mp\_load::main();

        	thread sr\api\_speedrun::createNormalWays("Normal Way;");
        thread sr\api\_speedrun::createSecretWays("Secret Way;");
        thread sr\api\_speedrun::createTeleporter((-812.956, 795.077, 544.125), 95, 90, (-993, 2823, 828), 358, "freeze", "cyan", "secret_0");
       
        thread trap1();
        thread trap2();
        thread trap3();
        thread trap4();
        thread trap5();
        thread trap6();
        thread trap7();
        thread secret_end();

        addTriggerToList("trap1_acti");
        addTriggerToList("trap2_trig");
        addTriggerToList("trap3_acti");
        addTriggerToList("trap4_acti");
        addTriggerToList("trap5_acti");
        addTriggerToList("trap6_acti");
        addTriggerToList("trap7_acti");
       
}
 
addTriggerToList(name)
{
        if(!isDefined(level.trapTriggers))
                level.trapTriggers = [];
               
        level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}
 
trap1()
{
        level endon("triggeradada");
        trig1 = getEnt ("trap1_acti", "targetname");
        rotate1 = getEnt ("trap1_trap", "targetname");
       
        trig1 waittill ("triggeradada",user);
        trig1 delete();
       
        while (1)
        {
                rotate1 rotatepitch (360, 5);
                wait 2;
        }
}
 
trap2()
{      
        trig2 = getEnt ("trap2_trig", "targetname");  
        hurt1 = getEnt ("trap2_spikehurt1", "targetname");    
        hurt2 = getEnt ("trap2_spikehurt2", "targetname");
        spikes1 = getEnt ("trap2_spike1", "targetname");
        spikes2 = getEnt ("trap2_spike2", "targetname");
 
        hurt1 delete();
        hurt2 delete();
        spikes1 delete();
        spikes2 delete();
        trig2 delete();
}
 
trap3()
{
        level endon("triggerafzfzfzda");
        trig3 = getEnt("trap3_acti","targetname");
        brush1 = getEnt("trap3_ran1","targetname");
        brush2 = getEnt("trap3_ran2","targetname");
 
        trig3 waittill("triggerafzfzfzda",user);
        trig3 delete();
        random = randomInt(2);
        switch(random)
        {
                case 0: brush1 delete();
                                break;
                               
                case 1: brush2 delete();
                                break;
                               
                default: return;
        }
}
 
trap4()
{
        level endon("triggerafzgegeea");
        trig4 = getEnt ("trap4_acti", "targetname");
        rotate1 = getEnt ("trap4_trap", "targetname");
                rotate2 = getEnt ("trap4_trap2","targetname");
       
        trig4 waittill ("triggerafzgegeea",user);
        trig4 delete();
       
        while (1)
        {
                rotate1 rotateroll (360, 2);
                wait 1;
                                rotate2 rotateroll (-360, 2);
                                wait 1;
        }
}
 
trap5()
{
        trig5 = getEnt ("trap5_acti" , "targetname");
        trap = getEnt ("trap5_trap" , "targetname");
        trap delete();
        trig5 delete();
               
}
 
trap6()
{
        level endon("triggerafasada");
        trig6 = getEnt ("trap6_acti", "targetname");
        rotate1 = getEnt ("trap6_trap", "targetname");
       
        trig6 waittill ("triggerafasada",user);
        trig6 delete();
 
        while(1)
        {
                rotate1 rotateyaw (360, 3);
                wait 1;
        }
}
 
trap7()
{       
         level endon("triggerafafzfgghha");
        trig7 = getEnt ("trap7_acti", "targetname");
        rotate1 = getEnt ("trap7_trap", "targetname");
       
        trig7 waittill ("triggerafafzfgghha",user);
        trig7 delete();
 
        while(1)
        {
                rotate1 rotateyaw (-360, 3);
                wait 1;
        }
}
 
secret_end()
{
        trig = getEnt ("secret_endtrig", "targetname");
        target1 = getEnt ("secret_end", "targetname");
       
        for(;;)
        {
                trig waittill ("trigger", user);
                user thread sr\api\_speedrun::finishWay("secret_0");

        }
}