#include braxi\_common;
#include braxi\_rank;
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

	setDvar( "r_specularcolorscale", "1" );
	setDvar("r_glowbloomintensity0",".1");
	setDvar("r_glowbloomintensity1",".1");
	setDvar("r_glowskybleedintensity0",".1");
	setDvar("bg_fallDamageMinHeight","100000000");
    
	thread speedrun\_way_name::create_spawn((-46,1208,108),270);
	thread speedrun\_way_name::create_normal_way("^2Easy Way;^3Inter Way;^1Hard Way;");
    thread speedrun\_way_name::create_secret_way("Jumper Secret;Acti Secret;");
	thread speedrun\_way_name::create_tp((-13581.9, -3594.13, -2307.71), 50, 25, (-13441, -6245, -2164), 270, "freeze", "blue", "ns2");
	thread speedrun\_way_name::create_tp((71.7681, 1152.31, 48.125), 50, 15, (-3536, 5263, 2520), 1, "freeze", "yellow", "s0");
	thread speedrun\_way_name::create_tp((-191.242, 1150.82, 48.125), 50, 15, (4690, -9496, -900), 360, "freeze", "cyan", "s1");
	thread speedrun\_way_name::create_endmap((-13665, -10196.7, -2542.88), 95, 15, "ns2");
    
	thread startdoor();
	thread vaisustart();
	thread tpe();
	thread avante();
	thread ghiaccio();
	thread ende();
	thread tpi();
	thread sopra();
	thread endi();
	thread tph();
	thread hlasers();
	thread actisecretexit();

}

startdoor()
{
sd = getent("startdoor","targetname");

wait 0.1;
sd delete();

}

vaisustart()
{
h = getent("vaisustart","targetname");

h moveZ(138, 0.1);
wait 0.1;
h moveX(-1300,0.1);
wait 0.3;
h moveY(-300,0.1);

}

tpe()
{
	trig = getEnt("trigger_teleporte", "targetname");
	arrivo = getEnt("origin_teleporte", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
  }
}

avante()
{
plat = getEnt("avante","targetname");

wait 0.1;
plat moveY(160, 0.1);

}  

ghiaccio()
{
   ghiaccione = getEnt ("ghiaccio1", "targetname");
   ghiaccitwo = getEnt ("ghiaccio2", "targetname");
   danno = getEnt ("danno", "targetname");
   danno2 = getEnt ("danno2", "targetname");

   wait 0.1;
   ghiaccione delete();
   ghiaccitwo delete();
   danno delete();
   danno2 delete();

}

ende()
{
	trig = getEnt("endmape", "targetname");
	stre = getEnt("o_endmap", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread speedrun\_way_name::finish_way("ns0");
  }
} 

tpi()
{
	trig = getEnt("trigger_teleporti", "targetname");
	arrivo = getEnt("origin_teleporti", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread speedrun\_way_name::change_way("ns1");
	player setOrigin(arrivo.origin);
	player SetPlayerAngles(arrivo.angles);
  }
}

sopra()
{
bbb1 = getEnt("ballonzolante", "targetname");
bbb2 = getEnt("nonballonzolante", "targetname");
 
wait 0.1;
bbb1 moveZ(-130, 0.1);
bbb2 moveZ(50, 0.1);

}

endi()
{
	trig = getEnt("endmapi", "targetname");
	stre = getEnt("o_endmap", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread speedrun\_way_name::finish_way("ns1");
  }
} 

tph()
{
	trig = getEnt("hardporto", "targetname");
	arriv = getEnt("o_hardporto", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread speedrun\_way_name::change_way("ns2");
	player setOrigin(arriv.origin);
	player SetPlayerAngles( arriv.angles );
			
  }
}

hlasers()
{
block1 = getEnt ("block", "targetname");
block2 = getEnt ("block2", "targetname");
laser1 = getEnt ("laser", "targetname");
laser2 = getEnt ("laser2", "targetname");
hurt1 = getEnt ("hlaser", "targetname");
hurt2 = getEnt ("hlaser2", "targetname");

wait 0.1;

block1 delete();
block2 delete();
laser1 delete();
laser2 delete();
hurt1 delete();
hurt2 delete();

}

send()
{
	trig = getEnt("secretend", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread speedrun\_way_name::finish_way("s0");
  }
} 

actisecretexit()
{
	trig = getEnt("esciactisecret", "targetname");
  for (;;) 
  {	
	trig waittill("trigger", player);
	player thread speedrun\_way_name::finish_way("s1");
  }
}