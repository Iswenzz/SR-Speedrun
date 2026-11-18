main() {
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);
	maps\mp\_load::main();
	sr\api\_map::swapTargetname("trigger_endmap", "endmap_trig");
	sr\api\_speedrun::createNormalWays("Normal Way;");
}