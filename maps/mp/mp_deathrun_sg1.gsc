/*
//    +========================================================================+
//    I                    ___  _____  _____                                   I
//    I                   /   !!  __ \!  ___!                                  I
//    I                  / /! !! !  \/! !_          ___  ____                  I
//    I                 / /_! !! ! __ !  _!        / __!!_  /                  I
//    I                 \___  !! !_\ \! !      _  ! (__  / /                   I
//    I                     !_/ \____/\_!     (_)  \___!/___!                  I
//    I========================================================================I
//    I                           mp_deathrun_sg1                              I
//    I========================================================================I
//    I                      mapped by:  r3mien@4gf.cz                         I
//    I                    scripted by:  mnaauuu@4gf.cz                        I
//    I                         website: www.4GF.cz                            I
//    I========================================================================I
//    I                Compatible with original Deathrun by BraX               I
//    +========================================================================+
*/
main()
{
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";


thread sr\api\_map::createSpawn((7, 1609, 76), 90);
thread sr\api\_speedrun::createNormalWays("Normal Way");
thread sr\api\_speedrun::createEndMap((-658.557, 7523.16, 160.125), 115,245, "normal_0"); 

thread trap_adjustments();
thread trap_adjustments_2();
}

trap_adjustments()
{
brush_1 = getEnt("w1_door_1a","targetname");
brush_2 = getEnt("w1_door_1b","targetname");
brush_3 = getEnt("w1_door_2a_1","targetname");
brush_4 = getEnt("w1_door_2a_2","targetname");
brush_5 = getEnt("w1_door_2b_1","targetname");
brush_6 = getEnt("w1_door_2b_2","targetname");
brush_7 = getEnt("w1_door_4a","targetname");
brush_8 = getEnt("w1_door_4b","targetname");
brush_9 = getEnt("door_stit","targetname");
brush_10 = getEnt("w1_door4_t","targetname");
brush_11 = getEnt("door_stit_fx","targetname");
brush_12 = getEnt("w1_door_5a","targetname");
brush_13 = getEnt("w1_door_5b","targetname");
brush_14 = getEnt("door_stit2","targetname");
brush_15 = getEnt("w1_door5_t","targetname");
brush_16 = getEnt("door_stit2_fx","targetname");


wait 0.1;

brush_1 delete();
brush_2 delete();
brush_3 delete();
brush_4 delete();
brush_5 delete();
brush_6 delete();
brush_7 delete();
brush_8 delete();
brush_9 delete();
brush_10 delete();
brush_11 delete();
brush_12 delete();
brush_13 delete();
brush_14 delete();
brush_15 delete();
brush_16 delete();
			
}

trap_adjustments_2()
{
brush_1 = getEnt("mover1a","targetname");
brush_2 = getEnt("mover1b","targetname");

wait 0.1;

brush_1 moveY(100,0.1);
brush_2 moveY(-100,0.1);
wait 0.2;
brush_1 moveX(600,0.1);

	
}