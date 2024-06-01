main()
{
    maps\mp\_load::main();
    
    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
    
    setDvar("r_gamma","1");
    setDvar("r_specularcolorscale", "1");
    setDvar("r_glowbloomintensity0","1");
    setDvar("r_glowbloomintensity1","1");
    setDvar("r_glowskybleedintensity0","1");
    setDvar("compassmaxrange","1800");
    setDvar("bg_fallDamageMaxHeight", "99999");
    setDvar("bg_fallDamageMinHeight", "99998");

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_map::createSpawn((127, -843, -689), 90);


    thread trap1_init(); 
    thread trap2_init();
    thread trap3_init();
    thread trap7_init();
  
}

trap1_init()
{
    trap1a = getent ("trap1_a", "targetname");
    trap1b = getent ("trap1_b", "targetname");
    trap1c = getent ("trap1_c", "targetname");  

    trap1a delete();
    trap1b delete();
    trap1c delete();

}


trap2_init()
{
    trap2_size_1 = getent ("trap2_size_1", "targetname");    
    trap2_size_2 = getent ("trap2_size_2", "targetname");  
    trap2_size_3 = getent ("trap2_size_3", "targetname");  
    trap2_size_4 = getent ("trap2_size_4", "targetname");    
    trap2_size_5 = getent ("trap2_size_5", "targetname");  
    trap2_size_6 = getent ("trap2_size_6", "targetname");  
    trap2_size_7 = getent ("trap2_size_7", "targetname"); 

    trap2_size_1 delete();
    trap2_size_2 delete();
    trap2_size_3 delete();
    trap2_size_4 delete();
    trap2_size_5 delete();
    trap2_size_6 delete();
    trap2_size_7 delete();

    trap2_ball_a = getent ("trap2_ball_a", "targetname");
    trap2_ball_b = getent ("trap2_ball_b", "targetname");
    trap2_ball_c = getent ("trap2_ball_c", "targetname");
    trap2_ball_d = getent ("trap2_ball_d", "targetname");
    trap2_ball_e = getent ("trap2_ball_e", "targetname");
    trap2_ball_f = getent ("trap2_ball_f", "targetname");
    trap2_ball_g = getent ("trap2_ball_g", "targetname");
    trap2_ball_h = getent ("trap2_ball_h", "targetname");

    trap2_ball_a delete();
    trap2_ball_b delete();
    trap2_ball_c delete();
    trap2_ball_d delete();
    trap2_ball_e delete();
    trap2_ball_f delete();
    trap2_ball_g delete();
    trap2_ball_h delete();

  
}

trap3_init()
{
    trap3a = getent ("trap3_a", "targetname");
    trap3b = getent ("trap3_b", "targetname"); 

    trap3a delete();
    trap3b delete();

}


trap7_init()
{
    trap7a = getent ("trap7_a", "targetname");
    trap7b = getent ("trap7_b", "targetname"); 
    trap7c = getent ("trap7_c", "targetname");
    trap7d = getent ("trap7_d", "targetname"); 

    trap7a delete();
    trap7b delete();
    trap7c delete();
    trap7d delete();
}