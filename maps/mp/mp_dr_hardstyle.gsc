main()
{

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
 
thread speedrun\_way_name::create_spawn((193,-1,76),360);
thread speedrun\_way_name::create_tp((209.977, 160.844, 16.125), 65, 30, (3509, -2937, 656), 91, "freeze", "red", "s0");
thread speedrun\_way_name::create_endmap((8112.65, -220.956, -431.875), 85, 20, "ns1");
thread speedrun\_way_name::create_endmap((2038.18, -2338.81, 64.125), 125, 20, "s0");
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");

thread startdoor();

}

startdoor()
{
door = getent("door", "targetname");

wait 0.1;
door delete();
}
