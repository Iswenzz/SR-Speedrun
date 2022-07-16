main()
{
////////////////////////////////////////////////////////////////////////////
//////////////////////////////////mp_dr_ravine//////////////////////////////
////////////////////////////////////////////////////////////////////////////
/////////////Feel free to use these scripts for your deathrun map///////////
////////////////////////////////////////////////////////////////////////////
//////////////////////////Any problems gives a shout////////////////////////
///////////////////////////////Steam : teebag038////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/////////////////////////Long live Cod4 and deathrun////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////Matty//////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

maps\mp\_load::main();
 
 game["allies"] = "sas";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "woodland";
 game["axis_soldiertype"] = "woodland";

 setdvar( "r_specularcolorscale", "1" );
 setdvar("r_glowbloomintensity0",".25");
 setdvar("r_glowbloomintensity1",".25");
 setdvar("r_glowskybleedintensity0",".3");
 setdvar("compassmaxrange","1800");
 
 // addTriggerToList( "trap1_switch" );
 // addTriggerToList( "panic1_switch" );
 // addTriggerToList( "trap2_switch" );
 // addTriggerToList( "trap3_switch" );
 // addTriggerToList( "trap4_switch" );
 // addTriggerToList( "trap5_switch" );
 // addTriggerToList( "trap6_switch" );
 // addTriggerToList( "trap7_switch" );
 // addTriggerToList( "trap8_switch" );
 // addTriggerToList( "trap9_switch" );
 // addTriggerToList( "trap10_switch" );
 // addTriggerToList( "trap11_switch" );
 
 thread way_connect();
 // thread messages();
 thread gate();
 thread effects();
 thread teleport1();
 thread secret_teleport0();
 thread secret_teleport1();
 thread secret_teleport2();
 thread secret_switch();
 // thread activator_teleport1();
 // thread activator_teleport2();
 // thread trap1();
 // thread trap2();
 thread panic1();
 // thread trap3();
 // thread trap4();
 // thread trap5();
 // thread trap7();
 // thread trap8();
 thread floor();
 thread elevator();
 thread secret_lift2();
 thread wave1();
 thread wave2();
 thread wave3();
 thread wave4();
 thread wave5();
 thread wave6();
 thread wave7();
 thread wave8();
 thread wave9();
 thread wave10();
 thread wave11();
 thread wave12();
 thread wave13();
 thread wave14();
 thread wave15();
 thread wave16();
 thread wave17();
 thread wave18();
 thread wave19();
 thread wave20();
 thread wave21();
 thread wave22();
 thread wave23();
 thread wave24();
 thread wave25();
 thread wave26();
 thread wave27();
 thread wave28();
 thread wave29();
 thread wave30();
 thread wave31();
 thread wave32();
 thread wave33();
 thread wave34();
 thread wave35();
 thread wave36();
 thread wave37();
 thread wave38();
 thread wave39();
 thread wave40();
 thread wave41();
 thread wave42();
 thread wave43();
 thread wave44();
 thread wave45();
 thread wave46();
 thread wave47();
 thread wave48();
 thread wave49(); 
 // thread trap9();
 // thread trap10();
 // thread trap11();
 thread water_lighting_fix();
 // thread room1();
 // thread room2();
 // thread room3();
 // thread room4();
 // thread room5();
 // thread room6();
 // thread bounce_give_weapon();
 // thread bouncefall();
 // thread endmusic();
 // thread sniper_ele();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	speedrun\_way_name::createWay("secret", "Secret Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}
messages() 
{
wait 1;

while(1)
	{
	
	                        	iprintlnbold("^2mp_dr_ravine");
	                        	wait 30;
	                        	iprintlnbold("^2Map created by Matty ^1[^2Creator of mp_dr_hardest_game^1]");
	                         	wait 30;
	                        	iprintlnbold("^2Have A Blast^1!");
	                        	wait 30;
	                        	iprintlnbold("^2Any Problems^1?^2 U know where i Will be ^1[^2Steam : teebag038^1]");
	                           	wait 30;
	}
}
effects()
{
         level._effect[ "cloud_bank" ] = loadfx( "weather/cloud_bank" );
		 maps\mp\_fx::loopfx("cloud_bank", (-1664.0, 2240.0, -2500.0), 15);
		 maps\mp\_fx::loopfx("cloud_bank", (-1467.0, 2752.0, -2500.0), 16);
		 maps\mp\_fx::loopfx("cloud_bank", (-1087.0, 3071.0, -2500.0), 17);
		 maps\mp\_fx::loopfx("cloud_bank", (-1471.0, 2432.0, -2500.0), 18);
		 maps\mp\_fx::loopfx("cloud_bank", (-701.0, 2495.0, -2500.0), 19);
		 maps\mp\_fx::loopfx("cloud_bank", (-125.0, 2557.0, -2500.0), 20);
		 maps\mp\_fx::loopfx("cloud_bank", (-63.0, 3004.0, -2500.0), 21);
		 maps\mp\_fx::loopfx("cloud_bank", (-447.0, 3129.0, -2500.0), 22);
		 maps\mp\_fx::loopfx("cloud_bank", (-379.0, 2812.0, -2500.0), 23);
		 maps\mp\_fx::loopfx("cloud_bank", (-1600.0, 4064.0, -4250.0), 24);
		 maps\mp\_fx::loopfx("cloud_bank", (-896.0, 4096.0, -4250.0), 25);
		 maps\mp\_fx::loopfx("cloud_bank", (-576.0, 4736.0, -4250.0), 26);
		 maps\mp\_fx::loopfx("cloud_bank", (-1792.0, 5056.0, -4250.0), 27);
		 maps\mp\_fx::loopfx("cloud_bank", (-1728.0, 5280.0, -4250.0), 28);
		 maps\mp\_fx::loopfx("cloud_bank", (-1664.0, 5824.0, -4250.0), 29);
		 maps\mp\_fx::loopfx("cloud_bank", (-640.0, 5312.0, -4250.0), 30);
		 maps\mp\_fx::loopfx("cloud_bank", (-640.0, 5936.0, -4250.0), 31);
		 maps\mp\_fx::loopfx("cloud_bank", (-640.0, 7184.0, -4250.0), 32);
		 maps\mp\_fx::loopfx("cloud_bank", (-1600.0, 7904.0, -4250.0), 33);
		 maps\mp\_fx::loopfx("cloud_bank", (-1600.0, 7488.0, -4250.0), 34);
		 maps\mp\_fx::loopfx("cloud_bank", (-1664.0, 7104.0, -4250.0), 35);
		 maps\mp\_fx::loopfx("cloud_bank", (-256.0, 7872.0, -4250.0), 36);
		 maps\mp\_fx::loopfx("cloud_bank", (320.0, 8256.0, -4250.0), 37);
		 maps\mp\_fx::loopfx("cloud_bank", (1088.0, 7424.0, -4250.0), 38);
		 maps\mp\_fx::loopfx("cloud_bank", (1664.0, 6848.0, -4250.0), 39);
		 maps\mp\_fx::loopfx("cloud_bank", (1088.0, 6720.0, -4250.0), 40);
		 maps\mp\_fx::loopfx("cloud_bank", (1024.0, 5712.0, -4250.0), 41);
		 maps\mp\_fx::loopfx("cloud_bank", (1088.0, 5248.0, -4250.0), 42);
		 maps\mp\_fx::loopfx("cloud_bank", (1040.0, 4416.0, -4250.0), 43);
		 maps\mp\_fx::loopfx("cloud_bank", (1904.0, 3984.0, -4250.0), 44);
		 maps\mp\_fx::loopfx("cloud_bank", (2608.0, 3952.0, -4250.0), 45);
  
		 level._effect[ "firelp_barrel_pm" ] = loadfx( "firelp_barrel_pm" );
		 level._effect[ "lights" ] = loadfx( "misc/lights" );
		 maps\mp\_fx::loopfx("lights", (-768.0, -512.0, 200.0), 46);
}
gate()
{
   
   level waittill( "round_started" );
   gate = getent("gate","targetname");
   wait 1;
    
   // ambientPlay( "north" );

                             
                             gate movez (336,8);
                             gate waittill ("movedone");
                             
}
teleport1()
{

 trigger = getent("jumper_teleport1","targetname");
 jumper_teleport1_origin = getent("jumper_teleport1_origin","targetname");
 
 for(;;)
                         {
						 trigger waittill ("trigger", player );
                         player setorigin(jumper_teleport1_origin.origin);
						 player setPlayerAngles(jumper_teleport1_origin.angles );
                         }
}
trap2()
{

 trigger = getent("trap2_switch","targetname");
 trap2 = getent("trap2","targetname");
 
 killtrigger1 = getent("trap2_hurt","targetname");
 killtrigger1 enablelinkto();
 killtrigger1 linkto (trap2);
 
 trigger waittill ("trigger", player );
 trigger delete();
 
 while(1)

                         {
						 trap2 rotateYaw (-360,3);
						 wait(1);
						 }
}
trap3()
{

 trigger = getent("trap3_switch","targetname");
 fall1 = getent("fall1","targetname");
 fall2 = getent("fall2","targetname");
 fall3 = getent("fall3","targetname");
 fall4 = getent("fall4","targetname");
 fall5 = getent("fall5","targetname");
 
 trigger waittill ("trigger", player );
 trigger delete();
 
                         {
						 fall1 moveZ (-500,21);
						 fall2 moveZ (-600,18);
						 fall3 moveZ (-700,14);
						 fall4 moveZ (-800,13);
						 fall5 moveZ (-650,12);
						 wait(15);
						 }
}
trap4()
{

 trigger = getent("trap4_switch","targetname");
 
 spike_door1 = getent("spike_door1","targetname");
 spike_door2 = getent("spike_door2","targetname");
 spike_door3 = getent("spike_door3","targetname");
 spike_door4 = getent("spike_door4","targetname");
 spike_door5 = getent("spike_door5","targetname");
 spike_door6 = getent("spike_door6","targetname");
 spike_door7 = getent("spike_door7","targetname");
 
 killtrigger2 = getent("spike_door1_hurt","targetname");
 killtrigger2 enablelinkto();
 killtrigger2 linkto (spike_door1);
 killtrigger3 = getent("spike_door2_hurt","targetname");
 killtrigger3 enablelinkto();
 killtrigger3 linkto (spike_door2);
 killtrigger4 = getent("spike_door3_hurt","targetname");
 killtrigger4 enablelinkto();
 killtrigger4 linkto (spike_door3);
 killtrigger5 = getent("spike_door4_hurt","targetname");
 killtrigger5 enablelinkto();
 killtrigger5 linkto (spike_door4);
 killtrigger6 = getent("spike_door5_hurt","targetname");
 killtrigger6 enablelinkto();
 killtrigger6 linkto (spike_door5);
 killtrigger7 = getent("spike_door6_hurt","targetname");
 killtrigger7 enablelinkto();
 killtrigger7 linkto (spike_door6);
 killtrigger8 = getent("spike_door7_hurt","targetname");
 killtrigger8 enablelinkto();
 killtrigger8 linkto (spike_door7);
 
 trigger waittill ("trigger", player );
 trigger delete();
 
 while(1)
 
                                  {
                                   spike_door1 rotateYaw (-180,1);
						           spike_door2 rotateYaw (90,1);
								   wait(2);
								   spike_door3 rotateYaw (270,1);
								   wait(2);
								   spike_door4 rotateYaw (-180,1);
								   spike_door5 rotateYaw (-180,1);
								   wait(2);
								   spike_door1 rotateYaw (-45,1);
								   spike_door1 rotateYaw (180,1);
								   wait(2);
								   spike_door6 rotateYaw (-90,1);
								   spike_door7 rotateYaw (270,1);
								   wait(2);
								  }
}
elevator()
{
  ele = getent("ele","targetname");
  while(1)
{
  wait (2);
  ele movez (-1203,4,2,2);
  ele waittill ("movedone");
  wait (4);
  ele movez(1203,4,2,2);
  ele waittill ("movedone");
}
}
secret_lift2()
{
  trigger = getent("secret_lift2_switch","targetname");
  secret_lift2 = getent("secret_lift2","targetname");
  
  trigger waittill ("trigger", player );
  trigger delete();
 
 while(1)
 
                                  {
                                   secret_lift2 movez (128,4,2,2);
								   secret_lift2 waittill ("movedone");
								   wait(4);
								   secret_lift2 movez (-128,4,2,2);
								   secret_lift2 waittill ("movedone");
								   wait(4);
								  }
}
wave1()
{
  wave1 = getent("wave1","targetname");
   while(1)
{
  wait (1);
  wave1 movez (240,4,1,1);
  wave1 waittill ("movedone");
  wait (1);
  wave1 movez(-240,4,1,1);
  wave1 waittill ("movedone");
}
}
wave2()
{
  wave2 = getent("wave2","targetname");
   while(1)
{
  wait (1);
  wave2 movez (192,4,1,1);
  wave2 waittill ("movedone");
  wait (1);
  wave2 movez(-192,4,1,1);
  wave2 waittill ("movedone");
}
}
wave3()
{
  wave3 = getent("wave3","targetname");
   while(1)
{
  wait (1);
  wave3 movez (144,4,1,1);
  wave3 waittill ("movedone");
  wait (1);
  wave3 movez(-144,4,1,1);
  wave3 waittill ("movedone");
}
}
wave4()
{
  wave4 = getent("wave4","targetname");
   while(1)
{
  wait (1);
  wave4 movez (96,4,1,1);
  wave4 waittill ("movedone");
  wait (1);
  wave4 movez(-96,4,1,1);
  wave4 waittill ("movedone");
}
}
wave5()
{
  wave5 = getent("wave5","targetname");
   while(1)
{
  wait (1);
  wave5 movez (48,4,1,1);
  wave5 waittill ("movedone");
  wait (1);
  wave5 movez (-48,4,1,1);
  wave5 waittill ("movedone");
}
}
wave6()
{
  wave6 = getent("wave6","targetname");
   while(1)
{
  wait (1);
  wave6 movez (96,4,1,1);
  wave6 waittill ("movedone");
  wait (1);
  wave6 movez (-96,4,1,1);
  wave6 waittill ("movedone");
}
}
wave7()
{
  wave7 = getent("wave7","targetname");
   while(1)
{
  wait (1);
  wave7 movez (144,4,1,1);
  wave7 waittill ("movedone");
  wait (1);
  wave7 movez (-144,4,1,1);
  wave7 waittill ("movedone");
}
}
wave8()
{
  wave8 = getent("wave8","targetname");
   while(1)
{
  wait (1);
  wave8 movez (192,4,1,1);
  wave8 waittill ("movedone");
  wait (1);
  wave8 movez (-192,4,1,1);
  wave8 waittill ("movedone");
}
}
wave9()
{
  wave9 = getent("wave9","targetname");
   while(1)
{
  wait (1);
  wave9 movez (240,4,1,1);
  wave9 waittill ("movedone");
  wait (1);
  wave9 movez (-240,4,1,1);
  wave9 waittill ("movedone");
}
}
wave10()
{
  wave10 = getent("wave10","targetname");
   while(1)
{
  wait (1);
  wave10 movez (192,4,1,1);
  wave10 waittill ("movedone");
  wait (1);
  wave10 movez (-192,4,1,1);
  wave10 waittill ("movedone");
}
}
wave11()
{
  wave11 = getent("wave11","targetname");
   while(1)
{
  wait (1);
  wave11 movez (144,4,1,1);
  wave11 waittill ("movedone");
  wait (1);
  wave11 movez (-144,4,1,1);
  wave11 waittill ("movedone");
}
}
wave12()
{
  wave12 = getent("wave12","targetname");
   while(1)
{
  wait (1);
  wave12 movez (96,4,1,1);
  wave12 waittill ("movedone");
  wait (1);
  wave12 movez (-96,4,1,1);
  wave12 waittill ("movedone");
}
}
wave13()
{
  wave13 = getent("wave13","targetname");
   while(1)
{
  wait (1);
  wave13 movez (48,4,1,1);
  wave13 waittill ("movedone");
  wait (1);
  wave13 movez (-48,4,1,1);
  wave13 waittill ("movedone");
}
}
wave15()
{
  wave15 = getent("wave15","targetname");
   while(1)
{
  wait (1);
  wave15 movez (144,4,1,1);
  wave15 waittill ("movedone");
  wait (1);
  wave15 movez (-144,4,1,1);
  wave15 waittill ("movedone");
}
}
wave16()
{
  wave16 = getent("wave16","targetname");
   while(1)
{
  wait (1);
  wave16 movez (192,4,1,1);
  wave16 waittill ("movedone");
  wait (1);
  wave16 movez (-192,4,1,1);
  wave16 waittill ("movedone");
}
}
wave17()
{
  wave17 = getent("wave17","targetname");
   while(1)
{
  wait (1);
  wave17 movez (240,4,1,1);
  wave17 waittill ("movedone");
  wait (1);
  wave17 movez (-240,4,1,1);
  wave17 waittill ("movedone");
}
}
wave18()
{
  wave18 = getent("wave18","targetname");
   while(1)
{
  wait (1);
  wave18 movez (192,4,1,1);
  wave18 waittill ("movedone");
  wait (1);
  wave18 movez (-192,4,1,1);
  wave18 waittill ("movedone");
}
}
wave19()
{
  wave19 = getent("wave19","targetname");
   while(1)
{
  wait (1);
  wave19 movez (144,4,1,1);
  wave19 waittill ("movedone");
  wait (1);
  wave19 movez (-144,4,1,1);
  wave19 waittill ("movedone");
}
}
wave20()
{
  wave20 = getent("wave20","targetname");
   while(1)
{
  wait (1);
  wave20 movez (96,4,1,1);
  wave20 waittill ("movedone");
  wait (1);
  wave20 movez (-96,4,1,1);
  wave20 waittill ("movedone");
}
}
wave21()
{
  wave21 = getent("wave21","targetname");
   while(1)
{
  wait (1);
  wave21 movez (48,4,1,1);
  wave21 waittill ("movedone");
  wait (1);
  wave21 movez (-48,4,1,1);
  wave21 waittill ("movedone");
}
}
wave22()
{
  wave22 = getent("wave22","targetname");
   while(1)
{
  wait (1);
  wave22 movez (96,4,1,1);
  wave22 waittill ("movedone");
  wait (1);
  wave22 movez (-96,4,1,1);
  wave22 waittill ("movedone");
}
}
wave23()
{
  wave23 = getent("wave23","targetname");
   while(1)
{
  wait (1);
  wave23 movez (144,4,1,1);
  wave23 waittill ("movedone");
  wait (1);
  wave23 movez (-144,4,1,1);
  wave23 waittill ("movedone");
}
}
wave24()
{
  wave24 = getent("wave24","targetname");
   while(1)
{
  wait (1);
  wave24 movez (192,4,1,1);
  wave24 waittill ("movedone");
  wait (1);
  wave24 movez (-192,4,1,1);
  wave24 waittill ("movedone");
}
}
wave25()
{
  wave25 = getent("wave25","targetname");
   while(1)
{
  wait (1);
  wave25 movez (240,4,1,1);
  wave25 waittill ("movedone");
  wait (1);
  wave25 movez (-240,4,1,1);
  wave25 waittill ("movedone");
}
}
wave26()
{
  wave26 = getent("wave26","targetname");
   while(1)
{
  wait (1);
  wave26 movez (192,4,1,1);
  wave26 waittill ("movedone");
  wait (1);
  wave26 movez (-192,4,1,1);
  wave26 waittill ("movedone");
}
}
wave27()
{
  wave27 = getent("wave27","targetname");
   while(1)
{
  wait (1);
  wave27 movez (144,4,1,1);
  wave27 waittill ("movedone");
  wait (1);
  wave27 movez (-144,4,1,1);
  wave27 waittill ("movedone");
}
}
wave28()
{
  wave28 = getent("wave28","targetname");
   while(1)
{
  wait (1);
  wave28 movez (96,4,1,1);
  wave28 waittill ("movedone");
  wait (1);
  wave28 movez (-96,4,1,1);
  wave28 waittill ("movedone");
}
}
wave29()
{
  wave29 = getent("wave29","targetname");
   while(1)
{
  wait (1);
  wave29 movez (48,4,1,1);
  wave29 waittill ("movedone");
  wait (1);
  wave29 movez (-48,4,1,1);
  wave29 waittill ("movedone");
}
}
wave30()
{
  wave30 = getent("wave30","targetname");
   while(1)
{
  wait (1);
  wave30 movez (96,4,1,1);
  wave30 waittill ("movedone");
  wait (1);
  wave30 movez (-96,4,1,1);
  wave30 waittill ("movedone");
}
}
wave31()
{
  wave31 = getent("wave31","targetname");
   while(1)
{
  wait (1);
  wave31 movez (144,4,1,1);
  wave31 waittill ("movedone");
  wait (1);
  wave31 movez (-144,4,1,1);
  wave31 waittill ("movedone");
}
}
wave32()
{
  wave32 = getent("wave32","targetname");
   while(1)
{
  wait (1);
  wave32 movez (192,4,1,1);
  wave32 waittill ("movedone");
  wait (1);
  wave32 movez (-192,4,1,1);
  wave32 waittill ("movedone");
}
}
wave14() //got trolled and now fixed
{
  wave14 = getent("wave14","targetname");
   while(1)
{
  wait (1);
  wave14 movez (96,4,1,1);
  wave14 waittill ("movedone");
  wait (1);
  wave14 movez (-96,4,1,1);
  wave14 waittill ("movedone");
}
}
wave33()
{
  wave33 = getent("wave33","targetname");
   while(1)
{
  wait (1);
  wave33 movez (240,4,1,1);
  wave33 waittill ("movedone");
  wait (1);
  wave33 movez (-240,4,1,1);
  wave33 waittill ("movedone");
}
}
wave34()
{
  wave34 = getent("wave34","targetname");
   while(1)
{
  wait (1);
  wave34 movez (192,4,1,1);
  wave34 waittill ("movedone");
  wait (1);
  wave34 movez (-192,4,1,1);
  wave34 waittill ("movedone");
}
}
wave35()
{
  wave35 = getent("wave35","targetname");
   while(1)
{
  wait (1);
  wave35 movez (144,4,1,1);
  wave35 waittill ("movedone");
  wait (1);
  wave35 movez (-144,4,1,1);
  wave35 waittill ("movedone");
}
}
wave36()
{
  wave36 = getent("wave36","targetname");
   while(1)
{
  wait (1);
  wave36 movez (96,4,1,1);
  wave36 waittill ("movedone");
  wait (1);
  wave36 movez (-96,4,1,1);
  wave36 waittill ("movedone");
}
}
wave37()
{
  wave37 = getent("wave37","targetname");
   while(1)
{
  wait (1);
  wave37 movez (48,4,1,1);
  wave37 waittill ("movedone");
  wait (1);
  wave37 movez (-48,4,1,1);
  wave37 waittill ("movedone");
}
}
wave38()
{
  wave38 = getent("wave38","targetname");
   while(1)
{
  wait (1);
  wave38 movez (96,4,1,1);
  wave38 waittill ("movedone");
  wait (1);
  wave38 movez (-96,4,1,1);
  wave38 waittill ("movedone");
}
}
wave39()
{
  wave39 = getent("wave39","targetname");
   while(1)
{
  wait (1);
  wave39 movez (144,4,1,1);
  wave39 waittill ("movedone");
  wait (1);
  wave39 movez (-144,4,1,1);
  wave39 waittill ("movedone");
}
}
wave40()
{
  wave40 = getent("wave40","targetname");
   while(1)
{
  wait (1);
  wave40 movez (192,4,1,1);
  wave40 waittill ("movedone");
  wait (1);
  wave40 movez (-192,4,1,1);
  wave40 waittill ("movedone");
}
}
wave41()
{
  wave41 = getent("wave41","targetname");
   while(1)
{
  wait (1);
  wave41 movez (240,4,1,1);
  wave41 waittill ("movedone");
  wait (1);
  wave41 movez (-240,4,1,1);
  wave41 waittill ("movedone");
}
}
wave42()
{
  wave42 = getent("wave42","targetname");
   while(1)
{
  wait (1);
  wave42 movez (192,4,1,1);
  wave42 waittill ("movedone");
  wait (1);
  wave42 movez (-192,4,1,1);
  wave42 waittill ("movedone");
}
}
wave43()
{
  wave43 = getent("wave43","targetname");
   while(1)
{
  wait (1);
  wave43 movez (144,4,1,1);
  wave43 waittill ("movedone");
  wait (1);
  wave43 movez (-144,4,1,1);
  wave43 waittill ("movedone");
}
}
wave44()
{
  wave44 = getent("wave44","targetname");
   while(1)
{
  wait (1);
  wave44 movez (96,4,1,1);
  wave44 waittill ("movedone");
  wait (1);
  wave44 movez (-96,4,1,1);
  wave44 waittill ("movedone");
}
}
wave45()
{
  wave45 = getent("wave45","targetname");
   while(1)
{
  wait (1);
  wave45 movez (48,4,1,1);
  wave45 waittill ("movedone");
  wait (1);
  wave45 movez (-48,4,1,1);
  wave45 waittill ("movedone");
}
}
wave46()
{
  wave46 = getent("wave46","targetname");
   while(1)
{
  wait (1);
  wave46 movez (96,4,1,1);
  wave46 waittill ("movedone");
  wait (1);
  wave46 movez (-96,4,1,1);
  wave46 waittill ("movedone");
}
}
wave47()
{
  wave47 = getent("wave47","targetname");
   while(1)
{
  wait (1);
  wave47 movez (144,4,1,1);
  wave47 waittill ("movedone");
  wait (1);
  wave47 movez (-144,4,1,1);
  wave47 waittill ("movedone");
}
}
wave48()
{
  wave48 = getent("wave48","targetname");
   while(1)
{
  wait (1);
  wave48 movez (192,4,1,1);
  wave48 waittill ("movedone");
  wait (1);
  wave48 movez (-192,4,1,1);
  wave48 waittill ("movedone");
}
}
wave49()
{
  wave49 = getent("wave49","targetname");
   while(1)
{
  wait (1);
  wave49 movez (240,4,1,1);
  wave49 waittill ("movedone");
  wait (1);
  wave49 movez (-240,4,1,1);
  wave49 waittill ("movedone");
}
}
trap1()
{

 trigger = getent("trap1_switch","targetname");
 
 slide = getent("slide","targetname");


 trigger waittill ("trigger", player );
 trigger delete();
 

                         {
						 slide MoveZ (2053,2);
	                     slide waittill ("movedone");
						 }
}
panic1()
{

 trigger = getent("panic1_switch","targetname");
 panic1 = getent("panic1","targetname");
 
 
 trigger waittill ("trigger", player );
 trigger delete();
 
                         {
						 panic1 MoveZ (50,2);
						 wait(12);
						 panic1 MoveZ (-50,3);
						 }
}
trap5()
{

 trigger = getent("trap5_switch","targetname");
 
 slab1 = getent("slab1","targetname");
 slab2 = getent("slab2","targetname");
 slab3 = getent("slab3","targetname");
 slab4 = getent("slab4","targetname");
 
 
 trigger waittill ("trigger", player );
 trigger delete();
 
 while(1)
                         {
						 slab1 MoveZ (-200,2);
						 slab2 MoveZ (200,2);
						 slab3 MoveZ (200,2);
						 slab4 MoveZ (-200,2);
						 wait(1);
						 slab1 MoveZ (200,2);
						 slab2 MoveZ (-200,2);
						 slab3 MoveZ (-200,2);
						 slab4 MoveZ (200,2);
						 wait(1);
						 }
}
trap7()
{

 trigger = getent("trap7_switch","targetname");
 
 platform = getent("platform","targetname");

 
 trigger waittill ("trigger", player );
 trigger delete();
 
                         {
                         platform delete();
						 }
}
trap8()
{

 trigger = getent("trap8_switch","targetname");
 
 laser = getent("laser","targetname");
 
 killtrigger13 = getent("laser_hurt","targetname");
 killtrigger13 enablelinkto();
 killtrigger13 linkto (laser);

 
 trigger waittill ("trigger", player );
 trigger delete();
 
 while(1)
                         {
                         laser MoveZ (-199,4);
						 wait(4);
						 laser MoveZ (199,4);
						 wait(4);
						 }
}
floor()
{

 trigger = getent("floor_switch","targetname");
 
 floor = getent("floor","targetname");
 
 trigger waittill ("trigger", player );
 trigger delete();
 
 while(1)
                         {
                         floor MoveY (-958,8);
						 floor waittill ("movedone");
						 wait(2);
						 floor MoveY (958,8);
						 floor waittill ("movedone");
						 wait(2);
						 }
}
trap9()
{

 trigger = getent("trap9_switch","targetname");
 
 laser1 = getent("laser1","targetname");
 laser2 = getent("laser2","targetname");
 
 killtrigger14 = getent("laser1_hurt","targetname");
 killtrigger14 enablelinkto();
 killtrigger14 linkto (laser1);
 killtrigger15 = getent("laser2_hurt","targetname");
 killtrigger15 enablelinkto();
 killtrigger15 linkto (laser2);



 trigger waittill ("trigger", player );
 trigger delete();
 
 while(1)
                         {
                         laser1 MoveZ (-253,3);
						 laser2 MoveZ (-125,3);	
						 wait(3);
						 laser1 MoveZ (253,3);
						 laser2 MoveZ (125,3);	
						 wait(3);
						 }
}
secret_teleport1()
{
 
 trigger = getent("secret_teleport1","targetname");
 secret_teleport1_origin = getent("secret_teleport1_origin","targetname");
 
 for(;;)
                         {
						 trigger waittill ("trigger", player );
                         player setorigin(secret_teleport1_origin.origin);
						 player setPlayerAngles(secret_teleport1_origin.angles );
                         }
}
secret_teleport2()
{
 
 trigger = getent("secret_teleport2","targetname");
 secret_teleport2_origin = getent("secret_teleport2_origin","targetname");
 
 for(;;)
                         {
						 trigger waittill ("trigger", player );
                         player setorigin(secret_teleport2_origin.origin);
						 player setPlayerAngles(secret_teleport2_origin.angles );
                         }
}
activator_teleport1()
{
 
 trigger = getent("activator_teleport1","targetname");
 activator_teleport1_origin = getent("activator_teleport1_origin","targetname");
 
 for(;;)
                         {
						 trigger waittill ("trigger", player );
                         player setorigin(activator_teleport1_origin.origin);
						 player setPlayerAngles(activator_teleport1_origin.angles );
                         }
}
activator_teleport2()
{
 
 trigger = getent("activator_teleport2","targetname");
 activator_teleport2_origin = getent("activator_teleport2_origin","targetname");
 
 for(;;)
                         {
						 trigger waittill ("trigger", player );
                         player setorigin(activator_teleport2_origin.origin);
						 player setPlayerAngles(activator_teleport2_origin.angles );
                         }
}
secret_teleport0()
{
 
 trigger = getent("secret_teleport0","targetname");
 secret_teleport0_origin = getent("secret_teleport0_origin","targetname");
 
 for(;;)
                         {
						 trigger waittill ("trigger", player );
                         player setorigin(secret_teleport0_origin.origin);
						 player setPlayerAngles(secret_teleport0_origin.angles );
						 player speedrun\_way_name::startSecret(); //Speedrun Copy Paste
                         }
}
trap10()
{

 trigger = getent("trap10_switch","targetname");
 
 poles = getent("poles","targetname");

 trigger waittill ("trigger", player );
 trigger delete();
 
 while(1)
                         {
                         poles MoveZ (100,2);
						 wait(1);
						 poles MoveZ (-200,2);
						 wait(1);
						 poles MoveZ (100,2);
						 wait(1);
						 }
}
trap11()
{

 trigger = getent("trap11_switch","targetname");
 
 break1 = getent("break1","targetname");

 trigger waittill ("trigger", player );
 trigger delete();
 
                         {
						 break1 moveZ (-400,7);
						 wait(12);
						 break1 moveZ (400,7);
						 }
}
water_lighting_fix()
{
  
  water_lighting_fix = getent("water_lighting_fix","targetname");

                         {
                          water_lighting_fix movez (129,10);
                          water_lighting_fix waittill ("movedone");
                         }
}
secret_switch()
{
 trigger = getent("secret_door_switch","targetname");
 
 secret_clip = getent("secret_clip","targetname");

 wait 1;
 trigger delete();
 
                         {
						 secret_clip delete();
						 }
}
room1()
{
        level.room1_trig = getEnt( "sniper1", "targetname");
        jump = getEnt( "sniper2", "targetname" );
        acti = getEnt( "sniper3", "targetname" );
 
 
        while(1)
        {
                
				
				
			    level.room1_trig waittill( "trigger", player );
				
            
				if( !isDefined( level.room1_trig ) )
                        return;
						
				level.room2_trig delete();
				level.room3_trig delete();
				level.room4_trig delete();
				level.room5_trig delete();
				level.room6_trig delete();
						
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "m40a3_mp" );
			    player giveMaxAmmo( "m40a3_mp" );
			    player switchToWeapon( "m40a3_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "m40a3_mp" );
						level.activ giveMaxAmmo( "m40a3_mp" );
                        level.activ SwitchToWeapon( "m40a3_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^2Has Chosen the sniper room^1!" ); 
            player freezecontrols(true);
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^23" );
            level.activ iPrintlnBold( "^23" );
            wait 1;
            player iPrintlnBold( "^22" );
            level.activ iPrintlnBold( "^22" );
            wait 1;
            player iPrintlnBold( "^21" );
            level.activ iPrintlnBold( "^21" );
            wait 1;
            player iPrintlnBold( "^2Fight^1!" );
            level.activ iPrintlnBold( "^2Fight^1!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}
room2()
{
        level.room2_trig = getEnt( "sniper4", "targetname");
        jump = getEnt( "sniper5", "targetname" );
        acti = getEnt( "sniper6", "targetname" );
		
        while(1)
        {
                
			    level.room2_trig waittill( "trigger", player );
            
				if( !isDefined( level.room2_trig ) )
                        return;
				
				level.room1_trig delete();
				level.room3_trig delete();
				level.room4_trig delete();
				level.room5_trig delete();
				level.room6_trig delete();
						
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "m40a3_mp" );
			    player giveMaxAmmo( "m40a3_mp" );
			    player switchToWeapon( "m40a3_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "m40a3_mp" );
						level.activ giveMaxAmmo( "m40a3_mp" );
                        level.activ SwitchToWeapon( "m40a3_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^2Has Chosen the sniper room^1!" ); 
            player freezecontrols(true);
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^23" );
            level.activ iPrintlnBold( "^23" );
            wait 1;
            player iPrintlnBold( "^22" );
            level.activ iPrintlnBold( "^22" );
            wait 1;
            player iPrintlnBold( "^21" );
            level.activ iPrintlnBold( "^21" );
            wait 1;
            player iPrintlnBold( "^2Fight^1!" );
            level.activ iPrintlnBold( "^2Fight^1!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}
room3()
{
        level.room3_trig = getEnt( "sniper7", "targetname");
        jump = getEnt( "sniper8", "targetname" );
        acti = getEnt( "sniper9", "targetname" );
		
 
 
        while(1)
        {
                
			    level.room3_trig waittill( "trigger", player );
				   
				if( !isDefined( level.room3_trig ) )
                        return;
				
				level.room1_trig delete();
				level.room2_trig delete();
				level.room4_trig delete();
				level.room5_trig delete();
				level.room6_trig delete();
						
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "remington700_mp" );
			    player giveMaxAmmo( "remington700_mp" );
			    player switchToWeapon( "remington700_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "remington700_mp" );
						level.activ giveMaxAmmo( "remington700_mp" );
                        level.activ SwitchToWeapon( "remington700_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + " ^2Has Chosen the sniper room^1!" ); 
            player freezecontrols(true);
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^23" );
            level.activ iPrintlnBold( "^23" );
            wait 1;
            player iPrintlnBold( "^22" );
            level.activ iPrintlnBold( "^22" );
            wait 1;
            player iPrintlnBold( "^21" );
            level.activ iPrintlnBold( "^21" );
            wait 1;
            player iPrintlnBold( "^2Fight^1!" );
            level.activ iPrintlnBold( "^2Fight^1!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}
room4()
{
        level.room4_trig = getEnt( "knife1", "targetname");
        jump = getEnt( "knife2", "targetname" );
        acti = getEnt( "knife3", "targetname" );
 
 
        while(1)
        {
                level.room4_trig waittill( "trigger", player );
				
				
                if( !isDefined( level.room4_trig ) )
                        return;
 
                level.room1_trig delete();
				level.room2_trig delete();
				level.room3_trig delete();
				level.room5_trig delete();
				level.room6_trig delete();
				

				
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" ); //jumper weapon  
                player switchToWeapon( "knife_mp" );
				
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "knife_mp" );
                        level.activ SwitchToWeapon( "knife_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + "^2 Has Chosen knife room^1!" );     //change to what you want it to be
            
			
			player freezecontrols(true);
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^23" );
            level.activ iPrintlnBold( "^23" );
            wait 1;
            player iPrintlnBold( "^22" );
            level.activ iPrintlnBold( "^22" );
            wait 1;
            player iPrintlnBold( "^21" );
            level.activ iPrintlnBold( "^21" );
            wait 1;
            player iPrintlnBold( "^2Fight^1!" );
            level.activ iPrintlnBold( "^2Fight^1!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                
				while( isAlive( player ) && isDefined( player ) )
                        
						wait 1;
   }
}
room5()
{
        level.room5_trig = getEnt( "bounce1", "targetname");
        jump = getEnt( "bounce2", "targetname" );
        acti = getEnt( "bounce3", "targetname" );
		
 
 
        while(1)
        {
                level.room5_trig waittill( "trigger", player );
				
				
                if( !isDefined( level.room5_trig ) )
                        return;
                level.room1_trig delete();
				level.room2_trig delete();
				level.room3_trig delete();
				level.room4_trig delete();
				level.room6_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "knife_mp" ); //jumper weapon  
                player switchToWeapon( "knife_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "knife_mp" );
                        level.activ SwitchToWeapon( "knife_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + "^2 Has Chosen the bounce room^1!" );
            player freezecontrols(true);
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^23" );
            level.activ iPrintlnBold( "^23" );
            wait 1;
            player iPrintlnBold( "^22" );
            level.activ iPrintlnBold( "^22" );
            wait 1;
            player iPrintlnBold( "^21" );
            level.activ iPrintlnBold( "^21" );
            wait 1;
            player iPrintlnBold( "^2Fight^1!" );
            level.activ iPrintlnBold( "^2Fight^1!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}
room6()
{
        level.room6_trig = getEnt( "deagle1", "targetname");
        jump = getEnt( "deagle2", "targetname" );
        acti = getEnt( "deagle3", "targetname" );
		
        while(1)
        {
                level.room6_trig waittill( "trigger", player );
				
				
                if( !isDefined( level.room6_trig ) )
                        return;
                level.room1_trig delete();
				level.room2_trig delete();
				level.room3_trig delete();
				level.room4_trig delete();
				level.room5_trig delete();
 
                player SetPlayerAngles( jump.angles );
                player setOrigin( jump.origin );
                player TakeAllWeapons();
                player GiveWeapon( "deserteagle_mp" ); //jumper weapon
                player giveMaxAmmo( "deserteagle_mp" );
                player switchToWeapon( "deserteagle_mp" );
                if(isDefined(level.activ) && isAlive(level.activ))
                {
                        level.activ setPlayerangles( acti.angles );
                        level.activ setOrigin( acti.origin );
                        level.activ TakeAllWeapons();
                        level.activ GiveWeapon( "deserteagle_mp" );
						level.activ giveMaxAmmo( "deserteagle_mp" );
                        level.activ SwitchToWeapon( "deserteagle_mp" );
                        wait 0.05;
                       
                }
                wait 0.05;
               
                iPrintlnBold( " ^1" + player.name + "^2 Has Chosen the Pistol room^1!" );
            player freezecontrols(true);
            level.activ freezecontrols(true);
            wait 1;
            player iPrintlnBold( "^23" );
            level.activ iPrintlnBold( "^23" );
            wait 1;
            player iPrintlnBold( "^22" );
            level.activ iPrintlnBold( "^22" );
            wait 1;
            player iPrintlnBold( "^21" );
            level.activ iPrintlnBold( "^21" );
            wait 1;
            player iPrintlnBold( "^2Fight^1!" );
            level.activ iPrintlnBold( "^2Fight^1!" );
            player freezecontrols(false); //Disables the freeze.
            level.activ freezecontrols(false);
                while( isAlive( player ) && isDefined( player ) )
                        wait 1;
   }
}
bounce_give_weapon()
{

 bounce_give_sniper = getent("bounce_give_sniper","targetname");
 
 
                 while(1)
                 {
				         bounce_give_sniper waittill( "trigger", player );
						 
						 if( !isDefined( bounce_give_sniper ) )
                         
						 return;
						 
                         player GiveWeapon( "m40a3_mp" );
                         player giveMaxAmmo( "m40a3_mp" );
                         player switchToWeapon( "m40a3_mp" );
						 wait 0.05;
                         }
}
bouncefall() 
{
	fall = getEnt("fall","targetname");
	spawn_jump = getEnt("spawn_jump","targetname"); 
	spawn_acti = getEnt("spawn_acti","targetname");
	
	while(1)
	{
		fall waittill("trigger", player );
		if( player.pers["team"] == "allies" ) 
		{
			player setOrigin( spawn_jump.origin );
			player setPlayerAngles( spawn_jump.angles );
		}
		else
		{		
			player setOrigin( spawn_acti.origin );
			player setPlayerAngles(spawn_acti.angles );
		}
		wait .05;
	}
}
endmusic()
{

 trigger = getent("end_room_music","targetname");

 trigger waittill ("trigger", player );
 trigger delete();


x = randomint(4);

	if(x == 0)
	{
	ambientplay("endmusic1");
	iprintlnbold("^2Now playing ^1Broken Bones Love Inc");
	}
	if(x == 1)
	{
	ambientplay("endmusic2");
	iprintlnbold("^2Now playing ^1Taylor Swift - Style");
	}	
	if(x == 2)
	{
	ambientplay("endmusic3");
	iprintlnbold("^2Now playing ^1Desel Power Pain Remix");
	}
	if(x == 3)
	{
	ambientplay("endmusic4");
	iprintlnbold("^2Now playing ^1Bitter Sweet Intrumental");
	}

}
sniper_ele()
{
  sniper_ele = getent("sniper_ele","targetname");
  while(1)
{
  wait (2);
  sniper_ele movez (-568,4,2,2);
  sniper_ele waittill ("movedone");
  wait (4);
  sniper_ele movez(568,4,2,2);
  sniper_ele waittill ("movedone");
}
}