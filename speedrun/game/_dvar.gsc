#include sr\sys\_dvar;

initDvars()
{
	addDvar("mod", "mod_id", "speedrun");
	addDvar("spawn_time", "sr_spawn_time", 0, 0, 30, "int");
	addDvar("demos", "sr_demos", 1, 0, 1, "int");
	addDvar("demos_timeout", "sr_demos_timeout", 120, 20, 1200, "int");
	addDvar("map_scores", "sr_map_scores", 1, 0, 1, "int");
	addDvar("map_vote", "sr_map_vote", 1, 0, 1, "int");
	addDvar("match_need_players", "sr_match_need_players", 0, 0, 10, "int");

	setDvar("g_deadchat", 1000);
	setDvar("g_knockback", 1000);
	setDvar("g_speed", 190);
	setDvar("g_gravity", 800);
	setDvar("jump_height", 39);
	setDvar("dr_jumpers_speed", 1.05);
	setDvar("dr_activators_speed", 1.05);
	setDvar("jump_slowdownEnable", 0);
	setDvar("bullet_penetrationEnabled", 0);

	makeDvarServerInfo("mod_author", "SuX Lolz");
	setDvar("mod_author", "SuX Lolz");
}
