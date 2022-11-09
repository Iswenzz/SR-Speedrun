#include common_scripts\utility;
#include maps\mp\_utility;
main()
{
maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";


thread sr\api\_map::createSpawn((34,-2131,816),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread delete_stuff();

}

delete_stuff()
{
door1 = getEnt("door1", "targetname");
door2 = getEnt("door2", "targetname");
door3 = getEnt("hazarddoor", "targetname");
door4 = getEnt("door3_1", "targetname");
door5 = getEnt("door3_2", "targetname");
door6 = getEnt("door4_1", "targetname");
door7 = getEnt("door4_2", "targetname");
door8 = getEnt( "expl_wall", "targetname" ); 
door9 = getEnt("door5_1", "targetname");
door10 = getEnt("door5_2", "targetname");
door11 = getEnt( "gas_playerdoor", "targetname" );
door11_1 = getEnt( "gas_clip", "targetname" );
door12 = getEnt( "door7_1", "targetname" );
door13 = getEnt( "door7_2", "targetname" );
trap01 = getEnt("trap01_dmg", "targetname");
flamedmg1 = getent ("flamedmg1","targetname");
flamedmg2 = getent ("flamedmg2","targetname");
flamedmg3 = getent ("flamedmg3","targetname");
flamedmg4 = getent ("flamedmg4","targetname");
flamedmg5 = getent ("flamedmg5","targetname");
flamedmg6 = getent ("flamedmg6","targetname");
flamedmg7 = getent ("flamedmg7","targetname");
flamedmg8 = getent ("flamedmg8","targetname");
flamedmg9 = getent ("flamedmg9","targetname");
flamedmg10 = getent ("flamedmg10","targetname");
dmg = getent ("trigger_dmg_4","targetname");
expl_wall_hurt = getent ("expl_wall_hurt","targetname");
dmg1 = getent ("c4_dmg_1","targetname");
dmg2 = getent ("c4_dmg_2","targetname");
dmg3 = getent ("c4_dmg_3","targetname");
dmg4 = getent ("c4_dmg_4","targetname");
dmg5 = getent ("c4_dmg_5","targetname");
dmg6 = getent ("c4_dmg_6","targetname");
dmg7 = getent ("c4_dmg_7","targetname");
dmg8 = getent ("c4_dmg_8","targetname");
dmg9 = getent ("c4_dmg_9","targetname");
dmg10 = getent ("acid_hurt50","targetname");
dmg11= getent ("acid_hurt30","targetname");


door1 delete();
door2 delete();
door3 delete();
door4 delete();
door5 delete();
door6 delete();
door7 delete();
door8 delete();
door9 delete();
door10 delete();
door11 delete();
door11_1 delete();
door12 delete();
door13 delete();
trap01 delete();
flamedmg1 delete();
flamedmg2 delete();
flamedmg3 delete();
flamedmg4 delete();
flamedmg5 delete();
flamedmg6 delete();
flamedmg7 delete();
flamedmg8 delete();
flamedmg9 delete();
flamedmg10 delete();
dmg delete();
expl_wall_hurt delete();
dmg1 delete();
dmg2 delete();
dmg3 delete();
dmg4 delete();
dmg5 delete();
dmg6 delete();
dmg7 delete();
dmg8 delete();
dmg9 delete();
dmg10 delete();
dmg11 delete();


}