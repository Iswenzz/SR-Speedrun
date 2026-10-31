#include surf\_util;

main() {
	sr\api\_map::swapTargetname("trigger_endmap", "endmap_trig");
	sr\api\_speedrun::createNormalWays("Normal Way;");
	maps\mp\_load::main();

	creditsLines = [];
	creditsLines[ creditsLines.size ] = "--- ^3Surf Utopia^7 ---";
	creditsLines[ creditsLines.size ] = "--- ^3Originally created for CS:GO by ^2Panzerhandschuh^7 ---";
	creditsLines[ creditsLines.size ] = "--- ^3Ported to CoD4 by ^2JWofles & atrX^7 ---";
	credits( creditsLines );
}