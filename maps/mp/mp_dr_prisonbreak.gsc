main() 
{
	maps\mp\_load::main();

    setdvar( "bg_fallDamageMaxHeight","999999999" );
    setdvar( "bg_fallDamageMinHeight","9999999" );

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("Secret Way;");
    thread sr\api\_map::createSpawn((376, 723, 60), 180);
    thread sr\api\_speedrun::createTeleporter((258.262, 582.4, 0.124999), 60, 100, (-933, -2848, -820), 1, "freeze", "yellow", "secret_0");
    
 
    thread secret_fail1();
    thread secret_fail2();
    thread secret_finish();
   
    thread startdoor();

    thread trap1();
    thread trap2();
    thread trap3();
    thread trap4();
    thread trap5();
    thread trap9();
    thread trap11();
    thread trap12();
    thread trap14();

}


secret_fail1() 
{

    trig = getEnt( "secret_fail1", "targetname" );

    for(;;)
    {
        trig waittill( "trigger", player );
        player Suicide();
        
    }
}

secret_fail2() 
{
    trig = getEnt( "secret_fail2", "targetname" );

    for(;;)
    {
        trig waittill( "trigger", player );
        player Suicide();
        
    }
}

secret_finish() 
{
    trig = getEnt( "secret_finish", "targetname" );
    org = getEnt( "secret_finish_org", "targetname" );

   for(;;)
    {
        trig waittill( "trigger", player );

        player thread sr\api\_speedrun::finishWay("secret_0");
    }
}


startdoor() 
{
    door = getEnt( "startdoor", "targetname" );
    siren = getEnt( "siren", "targetname" );
   
    door delete();
    
}

trap1() {
    pusher = getEnt( "trap1", "targetname" );
    sound = getEnt( "pusher", "targetname" );
    hurt = getEnt( "trap1_hurt", "targetname" );

    hurt delete();
}

trap2() {
    origin = getEnt( "trap2_origin", "targetname" );
    sound1 = getEnt( "trap2_sound1", "targetname" );
    sound2 = getEnt( "trap2_sound2", "targetname" );

    hurt1 = getEnt( "trap2_hurt1", "targetname" );
    hurt2 = getEnt( "trap2_hurt2", "targetname" );

    hurt1 delete();
    hurt2 delete();

}

trap3() {
    origin = getEnt( "trap3_origin", "targetname" );

    hurt1 = getEnt( "trap3_hurt1", "targetname" );
    hurt2 = getEnt( "trap3_hurt2", "targetname" );
    hurt3 = getEnt( "trap3_hurt3", "targetname" );
    hurt4 = getEnt( "trap3_hurt4", "targetname" );
    
    fx1 = getEnt( "trap3_fx1", "targetname" );
    fx2 = getEnt( "trap3_fx2", "targetname" );
    fx3 = getEnt( "trap3_fx3", "targetname" );
    fx4 = getEnt( "trap3_fx4", "targetname" );

    hurt1 delete();
    hurt2 delete();
    hurt3 delete();
    hurt4 delete();
}

trap4() {
    wall = getEnt( "trap4", "targetname" );
    
    hurt = getEnt( "trap4_hurt", "targetname" );
    
    hurt delete();
}

trap5() {
    origin = getEnt( "trap5_origin", "targetname" );

    hurt1 = getEnt( "trap5_hurt1", "targetname" );
    hurt2 = getEnt( "trap5_hurt2", "targetname" );
    hurt3 = getEnt( "trap5_hurt3", "targetname" );
    hurt4 = getEnt( "trap5_hurt4", "targetname" );

    hurt1 delete();
    hurt2 delete();
    hurt3 delete();
    hurt4 delete();
  
}


trap9() {
    origin = getEnt( "trap9_origin", "targetname" );
    clip = getEnt( "trap9_clip", "targetname" );
    barrel1 = getEnt( "trap9_barrel1", "targetname" );
    barrel2 = getEnt( "trap9_barrel2", "targetname" );
    barrel3 = getEnt( "trap9_barrel3", "targetname" );
    barrel4 = getEnt( "trap9_barrel4", "targetname" );
    
    c41 = getEnt( "trap9_c41", "targetname" );
    c42 = getEnt( "trap9_c42", "targetname" );
    c43 = getEnt( "trap9_c43", "targetname" );
    c44 = getEnt( "trap9_c44", "targetname" );

    fx = getEnt( "trap9_fx", "targetname" );

    hurt = getEnt( "trap9_hurt", "targetname" );
   
   hurt delete();

}

trap11() {
    spinner = getEnt( "trap11", "targetname" );

    hurt = getEnt( "trap11_hurt", "targetname" );

    hurt delete();
  
}

trap12() {
    skipper = getEnt( "trap12", "targetname" );

    hurt = getEnt( "trap12_hurt", "targetname" );

    hurt delete();
    
}

trap14() {
    spinner = getEnt( "trap14", "targetname" );

    hurt = getEnt( "trap14_hurt", "targetname" );

    hurt delete();
    
}
