#include sr\sys\_dvar;

initDvars()
{
	addDvar("time_limit", "dr_timelimit", 5, 0, 60, "int");
	addDvar("round_limit", "dr_rounds", 15, 1, 30, "int");
	addDvar("insertion", "dr_insertion", 1, 0, 1, "int");
	addDvar("insertion_spawn", "dr_insertion_spawn", 0, 0, 1, "int");
	addDvar("allowLifes", "dr_allowLifes", 1, 0, 1, "int");
	addDvar("antiHackStat", "dr_antiHackStat_pass", 2900, 1, 3950, "int");
	addDvar("playerCards", "dr_playerCards", 1, 0, 1, "int");
	addDvar("afk", "dr_afk", 1, 0, 1, "int");
	addDvar("afk_warn", "dr_afk_warn", 15, 10, 999, "int");
	addDvar("afk_time", "dr_afk_time", 20, 10, 999, "int");
	addDvar("afk_method", "dr_afk_method", 0, 0, 1, "int");
	addDvar("pickingsystem", "dr_pickingsystem", 0, 0, 1, "int");
	addDvar("dont_make_peoples_angry", "dr_dont_pick_previous", 1, 0, 1, "int");
	addDvar("dont_pick_spec", "dr_dont_pick_spectators", 1, 0, 1, "int");
	addDvar("sprays", "dr_sprays", 1, 0, 1, "int");
	addDvar("sprays_delay", "dr_sprays_delay", 10, 1, 999, "int");
	addDvar("bunnyhoop", "dr_bunnyhoop_pro", 0, 0, 1, "int");
	addDvar("freerun", "dr_freerun_round", 1, 0, 1, "int");
	addDvar("freerun_time", "dr_freerun_time", 600, 5, 7200, "int");
	addDvar("time", "sr_time", 1800, 60, 7200, "int");
	addDvar("bots", "g_bots", 0, 0, 64, "int");
	addDvar("dev", "g_moddev", 0, 0, 1, "int");
	addDvar("allies_health", "dr_jumpers_health", 100, 1, 1000, "int");
	addDvar("axis_health", "dr_activators_health", 100, 1, 1000, "int");
	addDvar("allies_speed", "dr_jumpers_speed", 1.05, 0.1, 2, "float");
	addDvar("axis_speed", "dr_activators_speed", 1.05, 0.1, 2, "float");
	addDvar("roundSound", "dr_roundsounds", 1, 0, 1, "int");
	addDvar("freeRunChoice", "dr_activator_freerun", 2, 0, 2, "int");
	addDvar("freeRunChoiceTime", "dr_activator_freerun_wait", 5, 3, 60, "int");
	addDvar("giveXpForActivation", "dr_xp_for_activation", 1, 0, 1, "int");
	addDvar("giveXpForKill", "dr_xp_for_kill", 1, 0, 1, "int");
	addDvar("firstBlood", "dr_firstblood", 1, 0, 1, "int");
	addDvar("lastalive", "dr_lastalive", 1, 0, 1, "int");
	addDvar("gibs", "dr_gibs", 1, 0, 1, "int");

	makeDvarServerInfo("netaddr", getDvar("net_ip"));
	makeDvarServerInfo("dr_motd", level.dvar["motd"]);
}
