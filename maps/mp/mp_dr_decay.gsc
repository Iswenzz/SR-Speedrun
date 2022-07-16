#include maps\mp\_utility;

main() {
	maps\mp\_load::main();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	thread speedrun\_way_name::create_spawn((383,511,60),360);
	thread speedrun\_way_name::create_normal_way("Normal Way;");

	deleteAll("start_door");

	deleteAll("trap1_trig");
	deleteAll("trap2_trig");
	deleteAll("trap3_trig");
	deleteAll("trap4_trig");
	deleteAll("trap5_trig");
	deleteAll("trap6_trig");
	deleteAll("trap7_trig");

	deleteAll("trap1_hurt");
	deleteAll("trap2_hurt");
	deleteAll("trap2_spikes");
	getEnt("trap7_wall", "targetname") moveZ(-200, .1);
}

deleteAll(targetname) {
	ents = getEntArray(targetname, "targetname");
	for (i = 0; i < ents.size; i++) {
		ents[i] delete();
	}
}
