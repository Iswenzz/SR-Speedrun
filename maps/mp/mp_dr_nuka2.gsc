main()
{
maps\mp\_load::main();

game["allies"] = "marines";
game["axis"] = "opfor";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";

setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1"); 

thread speedrun\_way_name::create_spawn((17,102,76),270);
thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Easy Secret;Hard Secret;");
thread speedrun\_way_name::create_endmap((4244.92, -6268.98, -703.875), 100, 10, "s0");
thread speedrun\_way_name::create_endmap((10367.8, -13143.3, -10829.9), 120, 20, "s1");
thread speedrun\_way_name::create_tp((-2654.89, -13967.1, 208.125), 90, 10, (-2659, -13048, 268), 90, "freeze", "blue", "ns0");
thread speedrun\_way_name::create_tp((289.027, 59.4846, 16.125), 60, 10, (7880, -8952, -644), 180, "freeze", "red", "s0");
thread speedrun\_way_name::create_tp((286.51, -145.261, 16.125), 60, 10, (5133, -343, -4), 360, "freeze", "yellow", "s1");

thread startdoor();
thread end();
}

startdoor()
{
lootje = getent("startdoor","targetname");

wait 0.1;

lootje delete();

}

end()
{
trigger = GetEnt( "end", "targetname" );

for(;;)
    {   
    trigger waittill("trigger", player);

    player thread speedrun\_way_name::finish_way("ns0");
    }
}
