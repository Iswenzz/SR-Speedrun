// __/\\\________/\\\_______________________________________________________________________/\\\\\\\\\__/\\\\\\_________________________________        
//  _\/\\\_______\/\\\____________________________________________________________________/\\\////////__\////\\\_________________________________       
//   _\//\\\______/\\\___/\\\__________________/\\\_______/\\\___________________________/\\\/______________\/\\\_________________________________      
//   __\//\\\____/\\\___\///___/\\\\\\\\\\__/\\\\\\\\\\\_\///______/\\\\\\\\____________/\\\________________\/\\\_____/\\\\\\\\\_____/\\/\\\\\\___     
//    ___\//\\\__/\\\_____/\\\_\/\\\//////__\////\\\////___/\\\___/\\\//////____________\/\\\________________\/\\\____\////////\\\___\/\\\////\\\__    
//     ____\//\\\/\\\_____\/\\\_\/\\\\\\\\\\____\/\\\______\/\\\__/\\\___________________\//\\\_______________\/\\\______/\\\\\\\\\\__\/\\\__\//\\\_   
//      _____\//\\\\\______\/\\\_\////////\\\____\/\\\_/\\__\/\\\_\//\\\___________________\///\\\_____________\/\\\_____/\\\/////\\\__\/\\\___\/\\\_  
//       ______\//\\\_______\/\\\__/\\\\\\\\\\____\//\\\\\___\/\\\__\///\\\\\\\\______________\////\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\/\\_\/\\\___\/\\\_ 
//        _______\///________\///__\//////////______\/////____\///_____\////////__________________\/////////__\/////////___\////////\//__\///____\///__

/*
  _   ________   ___  __        __   
 | | / / ___( ) / _ )/ /__ ____/ /__ 
 | |/ / /__ |/ / _  / / _ `/ _  / -_)
 |___/\___/   /____/_/\_,_/\_,_/\__/ 

 © VC' Blade

*/
main()
{
    level.sanctuaryglow=(randomint(50)/50,randomint(50)/50,randomint(50)/50);
    level.dust_1=loadfx("vistic/vc_dust");
    level.dust_2=loadfx("shiet/fog");
    level.torches=loadfx("vistic/torch_fire");
    level.magic_eplo=loadfx("vistic/light_explosion");
    precacheshader("raawr");

    thread dust_fx();
    thread torch_fx();

    thread secret_s();
    thread secret();
    thread secret_exit();
}

dust_fx()
{
    dust = getEnt("hole_dust","targetname");
    wait 1;
    level.dusts=SpawnFx(level.dust_1,dust.origin);
    triggerfx(level.dusts);

    level.dusty1=spawnfx(level.dust_1,(8440,-2840,600));
    level.dusty2=spawnfx(level.dust_1,(8968,-2840,600));
    level.dusty3=spawnfx(level.dust_1,(8968,-2296,600));
    level.dusty4=spawnfx(level.dust_1,(8440,-2296,600));
    triggerfx(level.dusty1);
    triggerfx(level.dusty2);
    triggerfx(level.dusty3);
    triggerfx(level.dusty4);
}

torch_fx()
{
    level waittill("round_started");
    thread mapby();
    torch1 = getent("torchfire1", "targetname");
    torch2 = getent("torchfire2", "targetname");
    torch3 = getent("torchfire3", "targetname");
    torch4 = getent("torchfire4", "targetname");
    torch5 = getent("torchfire5", "targetname");
    torch6 = getent("torchfire6", "targetname");
    torch7 = getent("torchfire7", "targetname");
    torch8 = getent("torchfire8", "targetname");
    torch9 = getent("torchfire9", "targetname");
    torch10 = getent("torchfire10", "targetname");
    torch11 = getent("torchfire11", "targetname");
    torch12 = getent("torchfire12", "targetname");
    torch13 = getent("torchfire13", "targetname");
    torch14 = getent("torchfire14", "targetname");
    torch15 = getent("torchfire15", "targetname");
    torch16 = getent("torchfire16", "targetname");
    torch17 = getent("torchfire17", "targetname");
    torch18 = getent("torchfire18", "targetname");
    torch19 = getent("torchfire19", "targetname");
    torch20 = getent("torchfire20", "targetname");

    level.effect1 = SpawnFx(level.torches,torch18.origin);
    level.effect2 = SpawnFx(level.torches,torch19.origin);
    level.effect3 = SpawnFx(level.torches,torch1.origin);
    level.effect4 = SpawnFx(level.torches,torch2.origin);
    level.effect5 = SpawnFx(level.torches,torch3.origin);
    level.effect6 = SpawnFx(level.torches,torch4.origin);
    level.effect7 = SpawnFx(level.torches,torch5.origin);
    level.effect8 = SpawnFx(level.torches,torch6.origin);
    level.effect9 = SpawnFx(level.torches,torch7.origin);
    level.effect10 = SpawnFx(level.torches,torch8.origin);
    level.effect11 = SpawnFx(level.torches,torch9.origin);
    level.effect12 = SpawnFx(level.torches,torch10.origin);
    level.effect13 = SpawnFx(level.torches,torch11.origin);
    level.effect14 = SpawnFx(level.torches,torch12.origin);
    level.effect15 = SpawnFx(level.torches,torch13.origin);
    level.effect16 = SpawnFx(level.torches,torch14.origin);
    level.effect17 = SpawnFx(level.torches,torch15.origin);
    level.effect18 = SpawnFx(level.torches,torch16.origin);
    level.effect19 = SpawnFx(level.torches,torch17.origin);
    level.effect20 = SpawnFx(level.torches,torch20.origin);

    triggerfx(level.effect1);
    triggerfx(level.effect2);
    triggerfx(level.effect3);
    triggerfx(level.effect4);
    triggerfx(level.effect5);
    triggerfx(level.effect6);
    triggerfx(level.effect7);
    triggerfx(level.effect8);
    triggerfx(level.effect9);
    triggerfx(level.effect10);
    triggerfx(level.effect11);
    triggerfx(level.effect12);
    triggerfx(level.effect13);
    triggerfx(level.effect14);
    triggerfx(level.effect15);
    triggerfx(level.effect16);
    triggerfx(level.effect17);
    triggerfx(level.effect18);
    triggerfx(level.effect19);
    triggerfx(level.effect20);
}

secret_s()
{
    s1=getent("secret_k1","targetname");
    s2=getent("secret_k2","targetname");

	wait 1;
	
        s1 delete();
        s2 delete();

    thread secret();

}

secret()
{
    trig=getent("secret_e","targetname");
    targ=getent("secret_port1","targetname");
    for(;;)
    {
        trig waittill ("trigger", player);
        player freezecontrols(1);
        player setorigin(targ.origin);
        player setplayerangles(targ.angles);
        player freezecontrols(0);
		player sr\api\_speedrun::changeWay("secret_0");
    }
}

addTextHud( who, x, y, alpha, alignX, alignY, fontScale )
{
    if( isPlayer( who ) )
        hud = newClientHudElem( who );
    else
        hud = newHudElem();

    hud.x = x;
    hud.y = y;
    hud.alpha = alpha;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.fontScale = fontScale;
    return hud;
}

mysticJumper()
{
    b1=getent("m_j_1","targetname");
    b2=getent("m_j_2","targetname");
    b3=getent("m_j_3","targetname");
    b4=getent("m_j_4","targetname");
    b5=getent("m_j_5","targetname");
    b6=getent("m_j_6","targetname");
    b7=getent("m_j_7","targetname");
    b8=getent("m_j_8","targetname");
    b9=getent("m_j_9","targetname");
    b10=getent("m_j_10","targetname");
    b11=getent("m_j_11","targetname");
    b12=getent("m_j_12","targetname");
    b13=getent("m_j_13","targetname");
    b14=getent("m_j_14","targetname");
    b15=getent("m_j_15","targetname");
    b16=getent("m_j_16","targetname");
    b17=getent("m_j_17","targetname");
    b18=getent("m_j_18","targetname");
    b19=getent("m_j_19","targetname");
    b20=getent("m_j_20","targetname");
    b21=getent("m_j_21","targetname");
    b22=getent("m_j_22","targetname");
    b23=getent("m_j_23","targetname");
    b24=getent("m_j_24","targetname");
    b25=getent("m_j_25","targetname");
    b26=getent("m_j_26","targetname");

    t1=getent("m_jt_1","targetname");
    t2=getent("m_jt_2","targetname");
    t3=getent("m_jt_3","targetname");
    t4=getent("m_jt_4","targetname");
    t5=getent("m_jt_5","targetname");
    t6=getent("m_jt_6","targetname");
    t7=getent("m_jt_7","targetname");
    t8=getent("m_jt_8","targetname");
    t9=getent("m_jt_9","targetname");
    t10=getent("m_jt_10","targetname");
    t11=getent("m_jt_11","targetname");
    t12=getent("m_jt_12","targetname");
    t13=getent("m_jt_13","targetname");
    t14=getent("m_jt_14","targetname");
    t15=getent("m_jt_15","targetname");
    t16=getent("m_jt_16","targetname");
    t17=getent("m_jt_17","targetname");
    t18=getent("m_jt_18","targetname");
    t19=getent("m_jt_19","targetname");
    t20=getent("m_jt_20","targetname");
    t21=getent("m_jt_21","targetname");
    t22=getent("m_jt_22","targetname");
    t23=getent("m_jt_23","targetname");
    t24=getent("m_jt_24","targetname");
    t25=getent("m_jt_25","targetname");
    t26=getent("m_jt_26","targetname");

    b1 thread roomPreset();
    b2 thread roomPreset();
    b3 thread roomPreset();
    b4 thread roomPreset();
    b5 thread roomPreset();
    b6 thread roomPreset();
    b7 thread roomPreset();
    b8 thread roomPreset();
    b9 thread roomPreset();
    b10 thread roomPreset();
    b11 thread roomPreset();
    b12 thread roomPreset();
    b13 thread roomPreset();
    b14 thread roomPreset();
    b15 thread roomPreset();
    b16 thread roomPreset();
    b17 thread roomPreset();
    b18 thread roomPreset();
    b19 thread roomPreset();
    b20 thread roomPreset();
    b21 thread roomPreset();
    b22 thread roomPreset();
    b23 thread roomPreset();
    b24 thread roomPreset();
    b25 thread roomPreset();
    b26 thread roomPreset();

     t1 waittill("trigger");
    {
        b1 show();
        b1 solid();
    }
    t2 waittill("trigger");
    {
        b2 show();
        b2 solid();
    }
    t3 waittill("trigger");
    {
        b3 show();
        b3 solid();
    }
    t4 waittill("trigger");
    {
        b4 show();
        b4 solid();
    }
    t5 waittill("trigger");
    {
        b5 show();
        b5 solid();
    }
    t6 waittill("trigger");
    {
        b6 show();
        b6 solid();
    }
    t7 waittill("trigger");
    {
        b7 show();
        b7 solid();
    }
    t8 waittill("trigger");
    {
        b8 show();
        b8 solid();
    }
    t9 waittill("trigger");
    {
        b9 show();
        b9 solid();
    }
    t10 waittill("trigger");
    {
        b10 show();
        b10 solid();
    }
    t11 waittill("trigger");
    {
        b11 show();
        b11 solid();
    }
    t12 waittill("trigger");
    {
        b12 show();
        b12 solid();
    }
    t13 waittill("trigger");
    {
        b13 show();
        b13 solid();
    }
    t14 waittill("trigger");
    {
        b14 show();
        b14 solid();
    }
    t15 waittill("trigger");
    {
        b15 show();
        b15 solid();
    }
    t16 waittill("trigger");
    {
        b16 show();
        b16 solid();
    }
    t17 waittill("trigger");
    {
        b17 show();
        b17 solid();
    }
    t18 waittill("trigger");
    {
        b18 show();
        b18 solid();
    }
    t19 waittill("trigger");
    {
        b19 show();
        b19 solid();
    }
    t20 waittill("trigger");
    {
        b20 show();
        b20 solid();
    }
    t21 waittill("trigger");
    {
        b21 show();
        b21 solid();
    }
    t22 waittill("trigger");
    {
        b22 show();
        b22 solid();
    }
    t23 waittill("trigger");
    {
        b23 show();
        b23 solid();
    }
    t24 waittill("trigger");
    {
        b24 show();
        b24 solid();
    }
    t25 waittill("trigger");
    {
        b25 show();
        b25 solid();
    }
    t26 waittill("trigger");
    {
        b26 show();
        b26 solid();
    }
}

mysticActivator()
{
    b1=getent("m_a_1","targetname");
    b2=getent("m_a_2","targetname");
    b3=getent("m_a_3","targetname");
    b4=getent("m_a_4","targetname");
    b5=getent("m_a_5","targetname");
    b6=getent("m_a_6","targetname");
    b7=getent("m_a_7","targetname");
    b8=getent("m_a_8","targetname");
    b9=getent("m_a_9","targetname");
    b10=getent("m_a_10","targetname");
    b11=getent("m_a_11","targetname");
    b12=getent("m_a_12","targetname");
    b13=getent("m_a_13","targetname");
    b14=getent("m_a_14","targetname");
    b15=getent("m_a_15","targetname");
    b16=getent("m_a_16","targetname");
    b17=getent("m_a_17","targetname");
    b18=getent("m_a_18","targetname");
    b19=getent("m_a_19","targetname");
    b20=getent("m_a_20","targetname");
    b21=getent("m_a_21","targetname");
    b22=getent("m_a_22","targetname");
    b23=getent("m_a_23","targetname");
    b24=getent("m_a_24","targetname");
    b25=getent("m_a_25","targetname");
    b26=getent("m_a_26","targetname");

    t1=getent("m_at_1","targetname");
    t2=getent("m_at_2","targetname");
    t3=getent("m_at_3","targetname");
    t4=getent("m_at_4","targetname");
    t5=getent("m_at_5","targetname");
    t6=getent("m_at_6","targetname");
    t7=getent("m_at_7","targetname");
    t8=getent("m_at_8","targetname");
    t9=getent("m_at_9","targetname");
    t10=getent("m_at_10","targetname");
    t11=getent("m_at_11","targetname");
    t12=getent("m_at_12","targetname");
    t13=getent("m_at_13","targetname");
    t14=getent("m_at_14","targetname");
    t15=getent("m_at_15","targetname");
    t16=getent("m_at_16","targetname");
    t17=getent("m_at_17","targetname");
    t18=getent("m_at_18","targetname");
    t19=getent("m_at_19","targetname");
    t20=getent("m_at_20","targetname");
    t21=getent("m_at_21","targetname");
    t22=getent("m_at_22","targetname");
    t23=getent("m_at_23","targetname");
    t24=getent("m_at_24","targetname");
    t25=getent("m_at_25","targetname");
    t26=getent("m_at_26","targetname");

    b1 thread roomPreset();
    b2 thread roomPreset();
    b3 thread roomPreset();
    b4 thread roomPreset();
    b5 thread roomPreset();
    b6 thread roomPreset();
    b7 thread roomPreset();
    b8 thread roomPreset();
    b9 thread roomPreset();
    b10 thread roomPreset();
    b11 thread roomPreset();
    b12 thread roomPreset();
    b13 thread roomPreset();
    b14 thread roomPreset();
    b15 thread roomPreset();
    b16 thread roomPreset();
    b17 thread roomPreset();
    b18 thread roomPreset();
    b19 thread roomPreset();
    b20 thread roomPreset();
    b21 thread roomPreset();
    b22 thread roomPreset();
    b23 thread roomPreset();
    b24 thread roomPreset();
    b25 thread roomPreset();
    b26 thread roomPreset();

    t1 waittill("trigger");
    {
        b1 show();
        b1 solid();
    }
    t2 waittill("trigger");
    {
        b2 show();
        b2 solid();
    }
    t3 waittill("trigger");
    {
        b3 show();
        b3 solid();
    }
    t4 waittill("trigger");
    {
        b4 show();
        b4 solid();
    }
    t5 waittill("trigger");
    {
        b5 show();
        b5 solid();
    }
    t6 waittill("trigger");
    {
        b6 show();
        b6 solid();
    }
    t7 waittill("trigger");
    {
        b7 show();
        b7 solid();
    }
    t8 waittill("trigger");
    {
        b8 show();
        b8 solid();
    }
    t9 waittill("trigger");
    {
        b9 show();
        b9 solid();
    }
    t10 waittill("trigger");
    {
        b10 show();
        b10 solid();
    }
    t11 waittill("trigger");
    {
        b11 show();
        b11 solid();
    }
    t12 waittill("trigger");
    {
        b12 show();
        b12 solid();
    }
    t13 waittill("trigger");
    {
        b13 show();
        b13 solid();
    }
    t14 waittill("trigger");
    {
        b14 show();
        b14 solid();
    }
    t15 waittill("trigger");
    {
        b15 show();
        b15 solid();
    }
    t16 waittill("trigger");
    {
        b16 show();
        b16 solid();
    }
    t17 waittill("trigger");
    {
        b17 show();
        b17 solid();
    }
    t18 waittill("trigger");
    {
        b18 show();
        b18 solid();
    }
    t19 waittill("trigger");
    {
        b19 show();
        b19 solid();
    }
    t20 waittill("trigger");
    {
        b20 show();
        b20 solid();
    }
    t21 waittill("trigger");
    {
        b21 show();
        b21 solid();
    }
    t22 waittill("trigger");
    {
        b22 show();
        b22 solid();
    }
    t23 waittill("trigger");
    {
        b23 show();
        b23 solid();
    }
    t24 waittill("trigger");
    {
        b24 show();
        b24 solid();
    }
    t25 waittill("trigger");
    {
        b25 show();
        b25 solid();
    }
    t26 waittill("trigger");
    {
        b26 show();
        b26 solid();
    }
}

roomPreset()
{
    self hide();
    self notsolid();
}

secret_exit()
{
    trig=getent("secret_exit","targetname");
    targ=getent("secret_port2","targetname");
    for(;;)
    {
        trig waittill("trigger",player);

        player freezecontrols(1);
        player setorigin(targ.origin);
        player setplayerangles(targ.angles);
        player freezecontrols(0);
		
		if(isDefined(player.sr_secret))
			player thread braxi\_mod::endTimer();
    }
}

mapby()
{

}

drawInformation( start_offset, movetime, mult, text )
{
    start_offset *= mult;
    hud = new_ending_hud( "center", 0.1, start_offset, 90 );
    hud setText( text );
    hud moveOverTime( movetime );
    hud.x = 0;
    wait( movetime );
    wait( 3 );
    hud moveOverTime( movetime );
    hud.x = start_offset * -1;

    wait movetime;
    hud destroy();
}

new_ending_hud( align, fade_in_time, x_off, y_off )
{
    hud = newHudElem();
    hud.foreground = true;
    hud.x = x_off;
    hud.y = y_off;
    hud.alignX = align;
    hud.alignY = "middle";
    hud.horzAlign = align;
    hud.vertAlign = "middle";
    hud.fontScale = 1.9;
    hud.color = (1,1,1);
    hud.font = "objective";
    hud.glowColor = (0,1,0);
    hud.glowAlpha = 1;
    hud.alpha = 0;
    hud fadeovertime( fade_in_time );
    hud.alpha = 1;
    hud.hidewheninmenu = true;
    hud.sort = 10;
    return hud;
}