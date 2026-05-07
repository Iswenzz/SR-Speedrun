main(){
maps\_load::main();
thread start();
//thread kill1();
//thread kill2();
//thread kill3();
//thread kill4();
//thread kill5();
//thread kill6();
//thread kill7();
//thread kill8();
//thread kill9();
//thread kill10();
//thread end();
//AmbientPlay( "scary" );
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	thread sr\api\_map::createSpawn((22, 479, 76), 270);
    thread sr\api\_speedrun::createNormalWays("Normal Way");
    thread sr\api\_speedrun::createEndMap((1.75804, -4502.95, 624.125), 145,125, "normal_0");
}
start(){

rud = getent("start","targetname");
wait 0.1;

rud movey(-384,0.1);
wait 0.1;
rud rotateYaw(90,0.1);

}
kill1(){
tool = getent("1t","targetname");
rud = getent("1","targetname");
tool waittill("trigger");
rud movey(900,2);
wait 2;
rud movey(-900,2);
wait 2;
}
kill2(){
tool = getent("2t","targetname");
ama = getent("2a","targetname");
amama = getent("2b","targetname");
tool waittill("trigger");
if(RandomInt(2) == 0)
ama delete();
else
amama delete();
}
kill3(){
tool = getent("3t","targetname");
rud = getent("3","targetname");
tool waittill("trigger");
rud movez(400,2);
wait 2;
rud movez(-400,2);
wait 2;
}
kill4(){
tool = getent("4t","targetname");
ruck = getent("4","targetname");
tool waittill("trigger");
ruck rotateyaw(-720,10);
wait 10;
}
kill5(){
tool = getent("5t","targetname");
ruck = getent("5","targetname");
tool waittill("trigger");
ruck rotateyaw(360,4);
}
kill6(){
tool = getent("6t","targetname");
rud = getent("6","targetname");
tool waittill("trigger");
rud movey(-448,1.5);
wait 1.5;
rud movey(448,1.5);
wait 1.5;
}
kill7(){
tool = getent("7t","targetname");
pic = getent("7a","targetname");
picc = getent("7b","targetname");
tool waittill("trigger");
pic movez(98,1);
wait 2;
pic movez(-98,1);
picc movez(98,1);
wait 2;
picc movez(-98,1);
}
kill8(){
tool = getent("8t","targetname");
pic = getent("8a","targetname");
picc = getent("8b","targetname");
tool waittill("trigger");
pic movex(320,1);
picc movex(-320,1);
wait 4;
pic movex(-320,3);
picc movex(320,3);
wait 3;
}
kill9(){
tool = getent("9t","targetname");
maks = getent("9a","targetname");
makss = getent("9b","targetname");
tool waittill("trigger");
maks rotateroll(1440,20);
makss rotateroll(1440,20);
}
kill10(){
tool = getent("10t","targetname");
ama = getent("10","targetname");
tool waittill("trigger");
wait 1;
ama delete();
}
end(){
tool = getent("end","targetname");
target = getent(tool.target , "targetname");
while(1)
{
tool waittill("trigger",player);
iprintlnbold( ""+player.name+" finished this map!!! (MAP BY ^1SKYLE^1xxx)" );
player setorigin(target.origin);
player SetPlayerAngles(target.angles);
}
}