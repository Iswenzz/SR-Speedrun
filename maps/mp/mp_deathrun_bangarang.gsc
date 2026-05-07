main()
{
maps\_load::main();
//thread kill1();
//thread kill2();
//thread kill3();
//thread kill4();
//thread kill6();
//thread kill7();
//thread kill8();
//thread kill9();
//thread kill10();
//thread end();
//AmbientPlay( "BANGARANG" );
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_map::createSpawn((-2163, 941, 364), 360);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
	thread sr\api\_speedrun::createEndMap((1907.13, 220.241, 880.125), 130, 140, "normal_0");
	
}
kill1(){
tool = getent("1","targetname");
rud = getent("1A","targetname");
ruud = getent("1B","targetname");
ruuud = getent("1C","targetname");
tool waittill("trigger");
while(1)
{
rud movez(70,1);
ruud movez(-56,1);
ruuud movez(89,1);
wait 2;
rud movez(-70,1);
ruud movez(56,1);
ruuud movez(-89,1);
wait 2;
}
}
kill2(){
tool = getent("2","targetname");
toot = getent("2A","targetname");
tool waittill("trigger");
toot rotateroll(720,6);
}
kill3(){
tool = getent("3","targetname");
ama = getent("3A","targetname");
amama = getent("3B","targetname");
tool waittill("trigger");
if(RandomInt(2) == 0)
ama delete();
else
amama delete();
}
kill4(){
tool = getent("4","targetname");
ruck = getent("4A","targetname");
ruckk = getent("4B","targetname");

tool waittill("trigger");
ruck rotatepitch(720,6);
wait 8;
ruckk rotateyaw(-360,2);
}
kill6(){
tool = getent("6","targetname");
haha = getent("6A","targetname");
tool waittill("trigger");
haha rotateyaw(-360,5);
}
kill7(){
tool = getent("7","targetname");
pic = getent("7A","targetname");
picc = getent("7B","targetname");
tool waittill("trigger");
if(RandomInt(2) == 0)
pic delete();
else
picc delete();
}
kill8(){
tool = getent("8","targetname");
fils = getent("8A","targetname");
tool waittill("trigger");
fils movex(-500,0.1);
wait 2;
fils movex(500,2);
}
kill9(){
tool = getent("9","targetname");
maks = getent("9A","targetname");
tool waittill("trigger");
maks rotateyaw(-1440,14);
}
kill10(){
tool = getent("10","targetname");
suzu = getent("10A","targetname");
tool waittill("trigger");
suzu rotateroll(-720,15);
}
end(){
tool = getent("end","targetname");
target = getent(tool.target , "targetname");
while(1)
{
tool waittill("trigger",player);
iprintlnbold( ""+player.name+" finished this hard cool map!!! (MAP BY ^1SKYLE^1xxx)" );
player setorigin(target.origin);
player SetPlayerAngles(target.angles);
}
}