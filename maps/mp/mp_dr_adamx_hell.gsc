main()
{
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

    thread sr\api\_map::createSpawn((-39, 2396, -291), 90);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((7032.23, 14556.6, -351.875), 445,300, "normal_0");

         /*level thread SetTimeLimit();
         level thread zenek();
         level thread mapszoveg();
         level thread kapu();
         level thread mozgo();
         level thread tololap();
         level thread korbe_mozgo();
         level thread felemelkedo();
         level thread inga();
         level thread eltuno_1();
         level thread tuskes_mozgo();
         level thread lemeno_1();
         level thread forgo_1();
         level thread kocka();
         level thread szoba();
         level thread felemelkedo_2();
         level thread mozgo_letra();
         level thread rudak();
         level thread mozgo_2();
         level thread forgo_2();
         level thread tuske();
         level thread felemelkedo_3();
         level thread eltuntet();
         level thread lefordul();
         level thread mozgo_laser();
         level thread ralep_eltunik();
         level thread tovis();
         level thread forgo_3();
         level thread mozgo_3();
         level thread fel_le();
         level thread forgo_4();
         level thread fotocella();
         level thread elso();
         level thread weapon_r();
         level thread bounce_r();
         level thread sniper_r();
         level thread knife_r();
         level thread fun_r();
         level thread bounceStage();
         level thread bounce_weap();
         level thread enterRooms();
         level thread weapon_room_ammo();
         level thread carjump();
         level thread PartyCredits();
         level thread tankok_1();
         level thread szamlalo();
         level thread weap_1();
         level thread weap_2();
         level thread weap_3();
         level thread secret();
         level thread secret_2();
         level thread secret_3();
         level thread secret_4();
         level thread secret_ajto();
         level thread secret_trap();
         level thread secret_weap();
         level thread bounce_forgo();
         level thread forgo_reklam();*/

         thread trap_adjustments();

         addTriggerToList( "tololap_trig" );
         addTriggerToList( "felemelkedo_trig" );
         addTriggerToList( "eltuno_1_trig" );
         addTriggerToList( "tuskes_mozgo_trig" );
         addTriggerToList( "lemeno_1_trig" );
         addTriggerToList( "forgo_1_trig" );
         addTriggerToList( "kocka_trig" );
         addTriggerToList( "szoba_trig" );
         addTriggerToList( "felemelkedo_2_trig" );
         addTriggerToList( "rudak_trig" );
         addTriggerToList( "forgo_2_trig" );
         addTriggerToList( "tuske_trig" );
         addTriggerToList( "felemelkedo_3_trig" );
         addTriggerToList( "eltuntet_trig" );
         addTriggerToList( "lefordul_trig" );
         addTriggerToList( "mozgo_laser_trig" );
         addTriggerToList( "ralep_leesik_trig" );
         addTriggerToList( "tovis_trig" );
         addTriggerToList( "forgo_3_trig" );
         addTriggerToList( "fel_le_trig" );
         addTriggerToList( "forgo_4_trig" );
}
trap_adjustments()
{
brush_1 = getEnt("forog_1","targetname");
brush_2 = getEnt("forog_2","targetname");
brush_3 = getEnt("forog_3","targetname");
brush_4 = getEnt ( "fel", "targetname");
brush_5 = getEnt ( "le", "targetname");
brush_6 = getEnt("mozgo_2","targetname");
brush_7 = getEnt("red_hurt","targetname");
brush_8 = getEnt("mozgo_3","targetname");


wait 0.1;

brush_1 rotateYaw(90,0.1);
brush_2 rotateYaw(90,0.1);
brush_3 rotateYaw(90,0.1);
brush_4 moveZ(100,0.1);
brush_5 RotateYaw(90,0.1);
brush_6 moveY(700,0.1);
brush_7 delete();
brush_8 moveY(-1100,0.1);
wait 0.8;
brush_5 moveZ(-130,0.1);
			

}
addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
    level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

}

SetTimeLimit()
{
    wait 0.05;
    level.dvar["time_limit"] = (8);
}

zenek()
   {
   level waittill ("connected", player);
   { randb = randomInt(4);
   if (randb == 0)
   { ambientPlay("adamx_hell_ambient"); }
   if (randb == 1)
   { ambientPlay("adamx_hell_ambient_2"); }
   if (randb == 2)
   { ambientPlay("adamx_hell_ambient_3"); }
   if (randb == 3)
   { ambientPlay("adamx_hell_ambient_4"); }
         }
         }

mapszoveg()
  {
  so = getent ("write","targetname");
  so waittill ("trigger",player);
        so delete ();

while(1)
{
  player iprintln ("^3Map by ^1[PKT]Adamx89");
  wait 20;
  player iprintln ("^4Xfire: ^1rockerx89");
  wait 20;
  player iprintln ("^2www.pkt.clans.hu");
  wait 20;
  player iprintln ("^5Download my maps from ^1www.pkt.clans.hu ^5:)");
  wait 20;
}
  }

kapu()
{
    kapu = getent( "kapu", "targetname" );

    level waittill("connected", player);
    wait 10;

    earthquake(0.8, 10,kapu.origin, 1000);
    kapu movez (320,10,0,2);
    kapu waittill ("movedone");
}

mozgo()
{
  brush = getEnt("mozgo_1","targetname");
  while(1)
  {
    brush moveY(886,4,.55,.55);
    wait 5;
    brush moveY(-886,4,.55,.55);
    wait 5;
  }
}

tololap()

{

  csapda = getent( "tololap", "targetname" );
  trig = getent( "tololap_trig", "targetname" );

  while(true)

        {
        trig waittill ("trigger");
        trig delete();
        csapda moveX (700,2,0,0.6);
        csapda waittill ("movedone");


        wait 5;

        csapda moveX(-700,1,0,0.6);
        csapda waittill ("movedone");
        }
}

korbe_mozgo()
{
  brush = getEnt("korbe_mozgo","targetname");
  while(1)
  {
    brush moveY(650,3,.4,.4);
    wait 3;
    brush moveX(-530,3,.4,.4);
    wait 3;
    brush moveY(-650,3,.4,.4);
    wait 3;
    brush moveX(530,3,.4,.4);
    wait 3;
  }
}

felemelkedo()
{

felemelkedo = getEnt ( "felemelkedo", "targetname");
gyilkos_trig = getEnt ( "hurt", "targetname");
trigger = getEnt ( "felemelkedo_trig", "targetname");
gyilkos_trig enablelinkto();
gyilkos_trig linkto(felemelkedo);


  while (1)
  {
  trigger waittill( "trigger");
  trigger delete();
  felemelkedo movez (192,2);
  felemelkedo waittill ("movedone");
  wait 2;
  felemelkedo movez (-192,4);
  felemelkedo waittill ("movedone");

  }

}

inga()
{
  brush1 = getEnt( "inga_1", "targetname" );
  brush2 = getEnt( "inga_2", "targetname" );

  wait .05;
  while( 1 )
  {
    brush1 rotatePitch( -60, 2, 0.4, 0.4  );
    brush2 rotatePitch( 60, 2, 0.4, 0.4  );
    wait 2;
    brush1 rotatePitch( 60, 2, 0.4, 0.4 );
    brush2 rotatePitch( -60, 2, 0.4, 0.4  );
    wait 2;
  }
}

eltuno_1()
{
  trig = getEnt( "eltuno_1_trig", "targetname" );
  brush = getEnt( "eltuno_1", "targetname" );

  trig waittill( "trigger", who );
  trig delete();
  brush delete();
}

tuskes_mozgo()
{

tuskes_mozgo = getEnt ( "tuskes_mozgo", "targetname");
trigger = getEnt( "tuskes_mozgo_trig", "targetname" );
tuskes_mozgo_hurt = getEnt ( "tuskes_mozgo_hurt", "targetname");
tuskes_mozgo_hurt enablelinkto();
tuskes_mozgo_hurt linkto(tuskes_mozgo);

while (1)
  {
  trigger waittill( "trigger");
  trigger delete();
  tuskes_mozgo movez (-468,2);
  tuskes_mozgo waittill ("movedone");
  wait 5;
  tuskes_mozgo movez (468,8);
  tuskes_mozgo waittill ("movedone");

  }

}

lemeno_1()

{

  csapda = getent( "lemeno_1", "targetname" );
  trig = getent( "lemeno_1_trig", "targetname" );

  while(true)

        {
        trig waittill ("trigger");
        trig delete();
        csapda movez (-224,3,0,0.6);
        csapda waittill ("movedone");


        wait 5;

        csapda movez(224,5,0,0.6);
        csapda waittill ("movedone");
        }
}

forgo_1()
{

forgo_padlo = getEnt ( "forgo_1", "targetname");
trigger = getEnt ( "forgo_1_trig", "targetname");

  trigger waittill( "trigger");
  trigger delete();

  {

  forgo_padlo rotateroll (-44400,700);
  forgo_padlo waittill ("movedone");

  }

}

kocka()
   {
   trig = getent( "kocka_trig", "targetname" );
   while (1)
   {
   trig waittill ("trigger", user );
   trig delete();
   { randb = randomInt(27);
   kocka1 = getent( "kocka1", "targetname" );
   kocka2 = getent( "kocka2", "targetname" );
   kocka3 = getent( "kocka3", "targetname" );
   kocka4 = getent( "kocka4", "targetname" );
   kocka5 = getent( "kocka5", "targetname" );
   kocka6 = getent( "kocka6", "targetname" );
   kocka7 = getent( "kocka7", "targetname" );
   kocka8 = getent( "kocka8", "targetname" );
   if (randb == 0)
   {kocka1 notsolid(); wait .05; kocka2 notsolid(); }
   if (randb == 1)
   { kocka1 notsolid(); wait .05; kocka3 notsolid(); }
   if (randb == 2)
   { kocka1 notsolid(); wait .05; kocka4 notsolid(); }
   if (randb == 3)
   { kocka1 notsolid(); wait .05; kocka5 notsolid(); }
    if (randb == 4)
    { kocka1 notsolid(); wait .05; kocka6 notsolid(); }
     if (randb == 5)
     { kocka1 notsolid(); wait .05; kocka7 notsolid(); }
      if (randb == 6)
      { kocka1 notsolid(); wait .05; kocka8 notsolid(); }
      if (randb == 7)
      { kocka2 notsolid(); wait .05; kocka3 notsolid(); }
       if (randb == 8)
        { kocka2 notsolid(); wait .05; kocka4 notsolid(); }
         if (randb == 9)
         { kocka2 notsolid(); wait .05; kocka5 notsolid(); }
          if (randb == 10)
           { kocka2 notsolid(); wait .05; kocka6 notsolid(); }
            if (randb == 11)
            { kocka2 notsolid(); wait .05; kocka7 notsolid(); }
             if (randb == 12)
             { kocka2 notsolid(); wait .05; kocka8 notsolid(); }
             if (randb == 13)
              { kocka3 notsolid(); wait .05; kocka4 notsolid(); }
               if (randb == 14)
                { kocka3 notsolid(); wait .05; kocka5 notsolid(); }
                 if (randb == 15)
                  { kocka3 notsolid(); wait .05; kocka6 notsolid(); }
                  if (randb == 16)
                  { kocka3 notsolid(); wait .05; kocka7 notsolid(); }
                  if (randb == 17)
                  { kocka3 notsolid(); wait .05; kocka8 notsolid(); }
                  if (randb == 18)
                   { kocka4 notsolid(); wait .05; kocka5 notsolid(); }
                    if (randb == 19)
                    { kocka4 notsolid(); wait .05; kocka6 notsolid(); }
                  if (randb == 20)
                  { kocka4 notsolid(); wait .05; kocka7 notsolid(); }
                  if (randb == 21)
                  { kocka4 notsolid(); wait .05; kocka8 notsolid(); }
                  if (randb == 22)
                   { kocka5 notsolid(); wait .05; kocka6 notsolid(); }
                   if (randb == 23)
                    { kocka5 notsolid(); wait .05; kocka7 notsolid(); }
                    if (randb == 24)
                     { kocka5 notsolid(); wait .05; kocka8 notsolid(); }
                     if (randb == 25)
                     { kocka6 notsolid(); wait .05; kocka7 notsolid(); }
                      if (randb == 26)
                      { kocka6 notsolid(); wait .05; kocka8 notsolid(); }
          if (randb == 27)
         { kocka7 notsolid(); wait .05; kocka8 notsolid(); }
         }
         }
         }

szoba()
{
  trig = getent("szoba_trig","targetname");
  floor1 = getEnt("padlo_1","targetname");
  floor2 = getEnt("padlo_2","targetname");
  door1 = getEnt("door_1","targetname");
  door2 = getEnt("door_2","targetname");

  while(true)
  {
  trig waittill("trigger", other);
  trig delete();

  door1 moveX(400,2);
  door2 moveX(-400,2);
  wait 3;
  floor1 moveX(500,10);
  floor2 moveX(-500,10);
  wait 12;
  floor1 moveX(-500,10);
  floor2 moveX(500,10);
  wait 12;
  door1 moveX(-400,2);
  door2 moveX(400,2);
  door1 waittill("movedone");
  door2 waittill("movedone");
  door1 delete();
  door2 delete();
}
}

felemelkedo_2()
{

felemelkedo_2 = getEnt ( "felemelkedo_2", "targetname");
trigger = getEnt ( "felemelkedo_2_trig", "targetname");

  while (1)
  {
  trigger waittill( "trigger");
  trigger delete();
  felemelkedo_2 movez (874,2);
  felemelkedo_2 waittill ("movedone");
  wait 5;
  felemelkedo_2 movez (-874,6);
  felemelkedo_2 waittill ("movedone");

  }

}

mozgo_letra()
{

mozgo_letra = getEnt ( "mozgo_letra", "targetname");

  wait .05;
  while (1)
  {
  mozgo_letra moveX (-750,3);
  mozgo_letra waittill ("movedone");
  wait .5;
  mozgo_letra moveX (750,3);
  mozgo_letra waittill ("movedone");
  wait .5;
  }

}

rudak()
   {
   trig = getent( "rudak_trig", "targetname" );
   while (1)
   {
   trig waittill ("trigger", user );
   trig delete();
   { randb = randomInt(1);
   rudak_1 = getent( "rudak_1", "targetname" );
   rudak_2 = getent( "rudak_2", "targetname" );
   if (randb == 0)
   { rudak_2 notsolid(); }
   if (randb == 1)
   { rudak_1 notsolid(); }
         }
         }
         }

mozgo_2()
{
  brush = getEnt("mozgo_2","targetname");
  while(1)
  {
    brush moveY(1212,6,.55,.55);
    wait 8;
    brush moveY(-1212,6,.55,.55);
    wait 8;
  }
}

forgo_2()
{
  trigger = getEnt("forgo_2_trig","targetname");
  trigger waittill("trigger");
  trigger setHintString("");
  getEnt("forog_1","targetname") thread spinTrap3();
  wait .7;
  getEnt("forog_2","targetname") thread spinTrap3();
  wait .7;
  getEnt("forog_3","targetname") thread spinTrap3();
}
spinTrap3()
{
  level endon("game_ended");
  while(1)
  {
    self rotateYaw(360,2.9);
    wait 4;
  }
}

tuske()
{

tuske = getEnt ( "tuske", "targetname");
tuske_olo = getEnt ( "tuske_hurt", "targetname");
trigger = getEnt ( "tuske_trig", "targetname");
tuske_olo enablelinkto();
tuske_olo linkto(tuske);
trigger waittill( "trigger");
trigger delete();

  {
  tuske movez (-570,0.1);
  tuske waittill ("movedone");
  }
}

felemelkedo_3()
{

felemelkedo_3 = getEnt ( "felemelkedo_3", "targetname");
trigger = getEnt ( "felemelkedo_3_trig", "targetname");

  while (1)
  {
  trigger waittill( "trigger");
  trigger delete();
  felemelkedo_3 movez (600,1);
  felemelkedo_3 waittill ("movedone");
  wait 4;
  felemelkedo_3 movez (-600,4);
  felemelkedo_3 waittill ("movedone");

  }

}

eltuntet()

{
   trig = getEnt( "eltuntet_trig", "targetname" );
   first = getent ("first","targetname");
   second = getent ("second","targetname");
   trig waittill( "trigger");
        trig delete();
   while(1)
{
    first movez(-1000,1,0,0.6);
    wait 2;
    first movez(1000,1,0,0.6);
    wait 1;
    second movez(-1000,1,0,0.6);
    wait 2;
    second movez(1000,1,0,0.6);
    wait 1;
  }

}

lefordul()
{
lefordul = getent ("lefordul" ,"targetname");
lefordul_hurt = getent ("lefordul_hurt" ,"targetname");
trigger = getent ("lefordul_trig" , "targetname");
lefordul_hurt enablelinkto();
lefordul_hurt linkto(lefordul);
trigger waittill ("trigger");
trigger delete ();

earthquake(3, 3,lefordul.origin, 600);
lefordul rotateroll( 90, 2, 0.1, 0.1  );
wait 7;
lefordul rotateroll( -90, 5, 0.1, 0.1  );
}

mozgo_laser()
{

trig = getEnt ( "mozgo_laser_trig", "targetname");
red = getEnt ( "red","targetname");
blue = getEnt ( "blue","targetname");
red_hurt = getEnt ( "red_hurt", "targetname");
blue_hurt = getEnt ( "blue_hurt", "targetname");
red_hurt enablelinkto();
red_hurt linkto(red);
blue_hurt enablelinkto();
blue_hurt linkto(blue);
trig waittill( "trigger");
trig delete();

  wait .05;
  while (1)
  {
  red moveZ (580,0.7);
  blue moveZ (-580,0.7);
  wait 0.7;
  red moveZ (-580,0.7);
  blue moveZ (580,0.7);
  wait 0.7;

  }

}

ralep_eltunik()
   {
   trig = getent( "ralep_leesik_trig", "targetname" );
   while (1)
   {
   trig waittill ("trigger", user );
   trig delete();
   { randb = randomInt(3);
   resz_1 = getent( "resz_1", "targetname" );
   resz_2 = getent( "resz_2", "targetname" );
   resz_3 = getent( "resz_3", "targetname" );
   if (randb == 0)
   {resz_1 notsolid(); }
   if (randb == 1)
   { resz_2 notsolid(); }
   if (randb == 2)
   { resz_3 notsolid(); }
         }
         }
         }

tovis()
{

tovis = getEnt ( "tovis", "targetname");
tovis_hurt = getEnt ( "tovis_hurt", "targetname");
trigger = getEnt ( "tovis_trig", "targetname");
tovis_hurt enablelinkto();
tovis_hurt linkto(tovis);


  while (1)
  {
  trigger waittill( "trigger");
  trigger delete();
  tovis movez (150,2);
  tovis waittill ("movedone");
  wait 5;
  tovis movez (-150,5);
  tovis waittill ("movedone");

  }

}

forgo_3()
{


forgo_3 = getEnt ( "forgo_3", "targetname");
trigger = getEnt ( "forgo_3_trig", "targetname");

  trigger waittill( "trigger");
  trigger delete();

  while(1)
  {
  forgo_3 rotatepitch (1800,5);
  forgo_3 waittill ("movedone");

  }

}

mozgo_3()
{
  brush = getEnt("mozgo_3","targetname");
  while(1)
  {
    brush moveY(-1200,7,.55,.55);
    wait 9;
    brush moveY(1200,7,.55,.55);
    wait 9;
  }
}

fel_le()
{

fel = getEnt ( "fel", "targetname");
le = getEnt ( "le", "targetname");
trigger = getEnt ( "fel_le_trig", "targetname");
trigger waittill( "trigger");
trigger delete();

  while(1)
  {
  fel moveZ (70,2);
  le moveZ (-70,2);
  le waittill ("movedone");
  wait 13;
  fel moveZ (-70,2);
  le moveZ (70,2);
  le waittill ("movedone");
  wait 13;
  }
}

forgo_4()
{


forgo_4 = getEnt ( "forgo_4", "targetname");
trigger = getEnt ( "forgo_4_trig", "targetname");

  trigger waittill( "trigger");
  trigger delete();

  {

  forgo_4 rotatepitch (44400,600);
  forgo_4 waittill ("movedone");

  }

}

 fotocella ()
  {
  level.sebesseg = 15;
  hosszusag = 600;

  fcxek = getentarray("fotocellax","targetname");
  for(i=0;i<fcxek.size;i++){
    fc = fcxek[i];
    fc.j = getent(fcxek[i].target,"targetname");
    fc.b = getent(fc.j.target,"targetname");
    fc.jalap = fc.j getorigin();
    fc.balap = fc.b getorigin();
    fc.jvege = fc.jalap+(hosszusag,0,0);
    fc.bvege = fc.balap-(hosszusag,0,0);
    fc thread fotocella_mukodes();
    }
  fcyok = getentarray("fotocellay","targetname");
    for(i=0;i<fcyok.size;i++){
    fc = fcyok[i];
    fc.j = getent(fcyok[i].target,"targetname");
    fc.b = getent(fc.j.target,"targetname");
    fc.jalap = fc.j getorigin();
    fc.balap = fc.b getorigin();
    fc.jvege = fc.jalap+(0,hosszusag,0);
    fc.bvege = fc.balap-(0,hosszusag,0);
    fc thread fotocella_mukodes();
    }
  }

fotocella_mukodes()
  {
    self waittill("trigger");
    self fotocella_kinyit();
  }

fotocella_kinyit(){
  self.b moveto(self.bvege, level.sebesseg, 0, 0);
  self.j moveto(self.jvege, level.sebesseg, 0, 0);
  }

  //////////////////////////////////Ki�r�sok//////////////////////////////////////////
 //////////////////////////////////Ki�r�sok//////////////////////////////////////////

   elso ()
  {
  elso = getent ("elso_jatekos","targetname");
  elso waittill ("trigger",player );
  elso delete ();


  iprintlnbold ("^2Grat!" + "." + "^1"+ player.name + "^2."+ " ^2�rt be els�nek");
  wait 1 ;
  }

   weapon_r ()
  {
  weapon_r = getent ("weapon_r","targetname");
  weapon_r waittill ("trigger",player );

  iprintlnbold ("" + "." + "^1"+ player.name + "^2."+ " ^2Bel�pett a ^1WEAPON ^2Szob�ba!");
  wait 1 ;
  }

  bounce_r ()
  {
  bounce_r = getent ("bounce_r","targetname");
  bounce_r waittill ("trigger",player );

  iprintlnbold ("" + "." + "^1"+ player.name + "^2."+ " ^2Bel�pett a ^1BOUNCE ^2Szob�ba!");
  wait 1 ;
  }

  sniper_r ()
  {
  sniper_r = getent ("sniper_r","targetname");
  sniper_r waittill ("trigger",player );

  iprintlnbold ("^2" + "." + "^1"+ player.name + "^2."+ " ^2Bel�pett a ^1SNIPER ^2Szob�ba!");
  wait 1 ;
  }

  knife_r ()
  {
  knife_r = getent ("knife_r","targetname");
  knife_r waittill ("trigger",player );

  iprintlnbold ("" + "." + "^1"+ player.name + "^2."+ " ^2Bel�pett a ^1KNIFE ^2Szob�ba!");
  wait 1 ;
  }

  fun_r()
  {
  fun_r = getent ("fun_r","targetname");
  fun_R waittill ("trigger",player );

  iprintlnbold ("" + "." + "^1"+ player.name + "^2."+ " ^2Bel�pett a ^1FUN ^2Szob�ba!");
  wait 1 ;
  }

 //////////////////////////////////SZOB�K//////////////////////////////////////////
 //////////////////////////////////SZOB�K//////////////////////////////////////////

  bounceStage()
{
  activatorSpawn = getEnt("bounce_stage_activator","targetname");
  jumperSpawn = getEnt("bounce_stage_jumper","targetname");
  fall = getEnt("jumpStage_fall","targetname");
  while(1)
  {
    fall waittill("trigger",player);
    if(self != level.activ)
      spawn = jumperSpawn;
    else
      spawn = activatorSpawn;

    player setOrigin(spawn.origin);
    player setPlayerAngles(spawn.angles);
    wait .05;
  }
}

  enterRooms()
{
  thread roomSettings("enter_sniper_room","sniper_stage_jumper","^2Nyomj [^1Use^2] gombot a Sniper Szob�ba l�p�shez!","sniper_stage_activator","remington700_mp","enter_weapon_room,enter_knife_room,enter_bounce_room,enter_fun_room");
  thread roomSettings("enter_weapon_room","weapon_stage_jumper","^2Nyomj [^1Use^2] gombot a Weapon Szob�ba l�p�shez!","weapon_stage_activator","ak74u_mp","enter_sniper_room,enter_knife_room,enter_bounce_room,enter_fun_room");
  thread roomSettings("enter_knife_room","knife_stage_jumper","^2Nyomj [^1Use^2] gombot a K�s Szob�ba l�p�shez!","knife_stage_activator","tomahawk_mp","enter_sniper_room,enter_weapon_room,enter_bounce_room,enter_fun_room");
  thread roomSettings("enter_bounce_room","bounce_stage_jumper","^2Nyomj [^1Use^2] gombot a Bounce Szob�ba l�p�shez!","bounce_stage_activator","tomahawk_mp","enter_sniper_room,enter_knife_room,enter_weapon_room,enter_fun_room");
  thread roomSettings("enter_fun_room","fun_stage_jumper","^2Nyomj [^1Use^2] gombot a Fun Szob�ba l�p�shez!","fun_stage_activator","tomahawk_mp","enter_sniper_room,enter_knife_room,enter_bounce_room,enter_weapon_room");
}
roomSettings(trigger,out,hintString,activator,weapon,otherTriger1,otherTriger2)
{
  jumperTrigger = getEnt(trigger,"targetname");
  jumperOut = getEnt(out,"targetname");
  activatorSpawn = getEnt(activator,"targetname");
  if(isDefined(otherTriger1))
    otherTriger1 = getEnt(otherTriger1,"targetname");

  if(isDefined(otherTriger2))
    otherTriger2 = getEnt(otherTriger2,"targetname");

  while(1)
  {
    jumperTrigger waittill("trigger",player);
    if(!level.roomInUse)
    {
      level.activ setOrigin(activatorSpawn.origin);
      level.activ setPlayerAngles(activatorSpawn.angles);
      if(!level.activ.inRoom)
        level.activ thread resetActivator();

      level.activ.inRoom = true;
      level.activ thread giveRoomWeapon(weapon);
      level.activatorReSpawn = activatorSpawn;
      level.activatorWeapon = weapon;
      level.roomInUse = true;
      jumperTrigger setHintString("^1V�rj a sorodra!");
      if(isDefined(otherTriger1))
        otherTriger1.origin -= (0,0,10000);

      player setOrigin(jumperOut.origin);
      player setPlayerAngles(jumperOut.angles);
      player thread resetJumper(jumperTrigger,hintString);
      player thread giveRoomWeapon(weapon);
    }
    wait .05;
  }
}
giveRoomWeapon(weapon)
{
  self takeAllWeapons();
  self giveWeapon(weapon);
  wait .1;
  self switchToWeapon(weapon);
}
resetJumper(trigger,hintString)
{
  self common_scripts\utility::waittill_any("death","disconnect");
  level.roomInUse = false;
  trigger setHintString(hintString);
}
resetActivator()
{
  self waittill("disconnect");
  level thread putActivatorInRoom();
}
putActivatorInRoom()
{
  level waittill("activator",player);
  wait 1.5;
  player setOrigin(level.activatorReSpawn.origin);
  player setPlayerAngles(level.activatorReSpawn.angles);
  player thread giveRoomWeapon(level.activatorWeapon);
  player thread resetActivator();
}
weaponMove(weapon)
{
  while(1)
  {
    weapon moveZ(15,1,.2,.2);
    wait 1;
    weapon moveZ(-15,1,.2,.2);
    wait 1;
  }
}

///////////////////////////////////////Egy�b//////////////////////////////////////////////
///////////////////////////////////////Egy�b//////////////////////////////////////////////

bounce_weap()
{
while(1)
 {
  trigger = getEnt("weap","targetname");
  trigger waittill("trigger",player);
  player iPrintln("^2You Have Found The Gold Deagle!!");
  player giveWeapon("deserteaglegold_mp");
  wait .1;
  player switchToWeapon("deserteaglegold_mp");
  player SetWeaponAmmoStock( "deserteaglegold_mp", 300 );
  }
}

weap_1()
{
while(1)
 {
  trigger = getEnt("weap_1","targetname");
  trigger waittill("trigger",player);
  player giveWeapon("deserteaglegold_mp");
  wait .1;
  player switchToWeapon("deserteaglegold_mp");
  player SetWeaponAmmoStock( "deserteaglegold_mp", 300 );
  }
}

weap_2()
{
while(1)
 {
  trigger = getEnt("weap_2","targetname");
  trigger waittill("trigger",player);
  player giveWeapon("ak74u_mp");
  wait .1;
  player switchToWeapon("ak74u_mp");
  player SetWeaponAmmoStock( "ak74u_mp", 300 );
  }
}

weap_3()
{
while(1)
 {
  trigger = getEnt("weap_3","targetname");
  trigger waittill("trigger",player);
  player giveWeapon("ak47_mp");
  wait .1;
  player switchToWeapon("ak47_mp");
  player SetWeaponAmmoStock( "ak47_mp", 300 );
  }
}

weapon_room_ammo()
{
  trig = getent ("ammo_trig","targetname");

  while(isDefined(trig))
  {
  trig waittill( "trigger", player );
  player SetWeaponAmmoStock( "p90_mp", 300 );
  player SetWeaponAmmoStock( "ak47_mp", 300 );
  player SetWeaponAmmoStock( "ak74u_mp", 300 );
  player SetWeaponAmmoStock( "m40a3_mp", 300 );
  player SetWeaponAmmoStock( "mp5_mp", 300 );
  player SetWeaponAmmoStock( "m14_mp", 300 );
  wait 5;
  }
}

carjump()
{
car = getEnt("car","targetname");
car_2 = getEnt("car_2","targetname");
door = getEnt("carjump_door","targetname");
trig = getent( "carjump_trig", "targetname" );

  trig waittill( "trigger");
  trig delete();

            {
            wait 1;
            door moveX (-2,1);
            wait 2;
            door moveZ (1000,20);
            wait 12;
            car moveY(450,3);
            car_2 moveY(-450,3);
            wait 3;
            car rotatepitch(45,2);
            car_2 rotatepitch(45,2);
            car moveY(96,2);
            car_2 moveY(-96,2);
            wait 2;
            car moveZ(-660,5);
            car_2 moveZ(-660,5);
            wait 5;
            car rotatepitch(-35,1);
            car_2 rotatepitch(-35,1);
            wait 1;
            car rotatepitch(35,1);
            car_2 rotatepitch(35,1);
            wait 1;
            car rotatepitch(-55,1);
            car_2 rotatepitch(-55,1);
            wait 1;
            car moveZ(-40,4);
            car_2 moveZ(-40,4);
            wait 2;

             while (1)
            {
            car moveZ (5,3);
            car_2 moveZ (-5,3);
            wait 3;
            car moveZ (-5,3);
            car_2 moveZ (5,3);
            wait 3;
            }
}
}

PartyCredits()
{
trig = getEnt ("party_trig", "targetname");

trig waittill("trigger" ,player);
trig delete();
{
  hud_clock = NewHudElem();
  hud_clock.alignX = "center";
  hud_clock.alignY = "middle";
  hud_clock.horzalign = "center";
  hud_clock.vertalign = "middle";
  hud_clock.alpha = 1;
  hud_clock.x = 0;
  hud_clock.y = 0;
  hud_clock.font = "objective";
  hud_clock.fontscale = 2;
  hud_clock.glowalpha = 1;
  hud_clock.glowcolor = (0,0,9);
  hud_clock.label = &" ^3 Map By [PKT]Adamx89";
                   hud_clock SetPulseFX( 40, 5400, 200 );
                   wait 8;
                   hud_clock = NewHudElem();
  hud_clock.alignX = "center";
  hud_clock.alignY = "middle";
  hud_clock.horzalign = "center";
  hud_clock.vertalign = "middle";
  hud_clock.alpha = 1;
  hud_clock.x = 0;
  hud_clock.y = 0;
  hud_clock.font = "objective";
  hud_clock.fontscale = 2;
  hud_clock.glowalpha = 1;
  hud_clock.glowcolor = (9,0,0);
  hud_clock.label = &" ^2 Welcome to HELL!";
                   hud_clock SetPulseFX( 40, 5400, 200  );
                   wait 5;
                   }
                   while(true)
                   {
                    SetExpFog(2000, 2000, 1, 0, 0, 0);
                    wait 1;
                    SetExpFog(2000, 2000, 0, 1, 0, 0);
                    wait 1;
                    SetExpFog(2000, 2000, 0, 0, 1, 0);
                    wait 1;
                    SetExpFog(2000, 2000, 1, 1, 0, 0);
                    wait 1;

                  }
}

tankok_1 ()
{
tank = getEnt("tank","targetname");
tank_2 = getEnt("tank_2","targetname");
trig = getent( "tank_trig", "targetname" );

  trig waittill( "trigger");
{
tank rotateYaw (180,2);
tank_2 rotateYaw (180,2);
wait 3;
tank moveY (20600,5);
tank_2 moveY (20600,5);
wait 7;
tank rotateYaw (-90,2);
tank_2 rotateYaw (-90,2);
wait 4;
tank moveX (6600,3);
tank_2 moveX (6600,3);
wait 5;
tank rotateYaw (-90,2);
tank_2 rotateYaw (-90,2);
wait 4;
tank moveY (-4600,3);
tank_2 moveY (-4600,3);
wait 13;
tank rotateYaw (180,6);
tank_2 rotateYaw (180,6);
wait 7;
tank moveY (4600,3);
tank_2 moveY (4600,3);
wait 4;
tank rotateYaw (90,2);
tank_2 rotateYaw (90,2);
wait 3;
tank moveX (-6600,3);
tank_2 moveX (-6600,3);
wait 4;
tank rotateYaw (90,2);
tank_2 rotateYaw (90,2);
wait 3;
tank moveY (-20600,5);
tank_2 moveY (-20600,5);
}
}

szamlalo()
{
  trig = getent ("szamlalo_trig","targetname");
  szamlalo = getent ("szamlalo","targetname");
  trig waittill ("trigger");
  {
  wait .05;
  szamlalo setHintString("^2Tank indul vissza ^110 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^19 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^18 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^17 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^16 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^15 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^14 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^13 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^12 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza ^11 ^2mp m�lva");
  wait 1;
  szamlalo setHintString("^2Tank indul vissza!");
  wait 10;
  szamlalo delete();
  }
}

bounce_forgo()
{
  bounce_forgo = getEnt( "bounce_forgo", "targetname" );

  wait .05;
  while( 1 )
  {
    bounce_forgo rotateYaw( 180, 2, 0.4, 0.4  );
    wait 3;
    bounce_forgo rotateYaw( 180, 2, 0.4, 0.4  );
    wait 3;
  }
}

forgo_reklam()
{
  forgo_reklam = getEnt( "forgo_reklam", "targetname" );

  {
    forgo_reklam rotateYaw( 44000, 1000, 0.4, 0.4  );
  }
}

//*********************************SECRET************************************//

secret()
{
secret = getEnt("secret","targetname");
trig = getEnt( "secret_trig", "targetname" );

  trig waittill( "trigger");
  trig delete();

            {
            wait .05;
            secret moveZ (-100,1);
            wait 3;
            secret moveZ (100,0.1);
            }
       }

secret_2()
{
d1 = getEnt("d_1","targetname");
d2 = getEnt("d_2","targetname");
trig = getEnt( "d_trig", "targetname" );

  trig waittill( "trigger");

            {
            d1 moveY (-1,1);
            d2 moveY (-1,1);
            wait 2;
            d1 moveX (-100,1);
            d2 moveX (100,1);
            wait 6;
            d1 moveX (100,1);
            d2 moveX (-100,1);
            wait 2;
            d1 moveY (1,1);
            d2 moveY (1,1);
            }
       }

secret_3()
{
secret_3 = getEnt ("secret_1","targetname");
secret_2 = getEnt ("secret_2","targetname");
secret_2_2 = getEnt ("secret_2_2","targetname");
secret_2_3 = getEnt ("secret_4_trig","targetname");
trigger = getEnt ("secret_1_trig","targetname");
secret_2_3 enablelinkto();
secret_2_3 linkto(secret_2);

   trigger waittill ( "trigger");

   {
   secret_3 moveX (2,1);
   wait 2;
   secret_3 moveZ (50,1);
   wait 2;
   secret_2 moveX (-27,3);
   secret_2_2 moveX (-27,3);
   }
}

secret_trap()
{

secret_trap = getEnt ( "secret_trap", "targetname");
trigger = getEnt ( "secret_trap_trig", "targetname");

  while (1)
  {
  trigger waittill( "trigger");
  trigger delete();
  secret_trap movez (630,2);
  secret_trap waittill ("movedone");
  wait 5;
  secret_trap movez (-630,6);
  secret_trap waittill ("movedone");

  }

}

secret_4()
{

secret_4 = getEnt ( "secret_trap_trig", "targetname");
trigger = getEnt ( "secret_4_trig", "targetname");

  while (1)
  {
  trigger waittill( "trigger");
  trigger delete();
  secret_4 delete();
  }
}

secret_ajto()

{

secret_ajto = getent("secret_ajto", "targetname");
trig = getent("secret_ajto_trig", "targetname");

while (1)
{

trig waittill ("trigger");


hide_secret_ajto_trig();
secret_ajto rotateroll(90, 1.5, 0.7, 0.7);
secret_ajto waittill("rotatedone");
}
}

hide_secret_ajto_trig()
{
switches1 = getentarray ("secret_ajto_trig","targetname");

for(i=0; i<switches1.size; i++) switches1[i] maps\mp\_utility::triggerOff();

}

show_secret_ajto_trig()
{
switches1 = getentarray ("secret_ajto_trig","targetname");

for(i=0; i<switches1.size; i++) switches1[i] maps\mp\_utility::triggerOn();
}

secret_weap()
{
while(1)
 {
  trigger = getEnt("secret_weapon","targetname");
  trigger waittill("trigger",player);
  player iPrintln("^2Megtal�ltad a rejtett RPG-t!!");
  player giveWeapon("rpg_mp");
  wait .1;
  player switchToWeapon("rpg_mp");
  player SetWeaponAmmoStock( "rpg_mp", 300 );
  }
}