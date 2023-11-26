//Map by death
//Discord:Death#7416
   main()
{
   maps\mp\_load::main();
 
   game["allies"] = "marines";
   game["axis"] = "opfor";
   game["attackers"] = "axis";
   game["defenders"] = "allies";
   game["allies_soldiertype"] = "desert";
   game["axis_soldiertype"]= "desert";
 
   setdvar( "r_specularcolorscale", "1" );
   setdvar("r_glowbloomintensity0",".1");
   setdvar("r_glowbloomintensity1",".1");
   setdvar("r_glowskybleedintensity0",".1");
   setDvar("bg_falldamagemaxheight", 99999);
   setDvar("bg_falldamageminheight", 99998);

   thread sr\api\_speedrun::createNormalWays("^7Strafe Way;^1Ladder Way;^2Angle Way;^3Bhop Way;^4Bounce Way;^5Fall Way;");
   thread sr\api\_speedrun::createSecretWays("^6Stairs Way;");
   

   ///Welcome Messages///
   thread messagescreen(); 

   ///Secret Music///
   thread speedrun_music();

   ///Ladder Room Scripts///
   thread ladder_enter();
   thread save_load_logic_4();
   thread ladder_cone_1();
   thread ladder_cone_2();
   thread ladder_sr();
   thread ladder_arrow_1();
   thread ladder_arrow_2();
   thread ladder_finish();

   ///Angle Room Scripts///
   thread angle_enter();
   thread angle_stage2();
   thread angle_finish();
   
   ///Bhop Room Scripts///
   thread bhop_enter();
   thread bhop_cone_1();
   thread bhop_cone_2();
   thread save_load_logic_2();
   thread bhop_finish();

   ///Bounce Room Scripts///
   thread bounce_enter();
   thread save_load_logic();
   thread bounce_finish();

   ///Fall Room Scripts///
   thread fall_enter();
   thread fall_arrow();
   thread fall_finish();

   ///Stairs Room Scripts///
   thread stairs_enter();
   thread save_load_logic_3();
   thread stairs_finish();



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

    createHUD( x, y, alignX, alignY, alpha, font, fontScale )
    {
    hud = NewHudElem();
    hud.x = x;
    hud.y = y;
    hud.alignX = alignX;
    hud.alignY = alignY;
    hud.horzalign = alignX;
    hud.vertalign = alignY;
    hud.alpha = alpha;
    hud.font = font;
    hud.fontscale = fontScale;
    hud.glowalpha = 0;
    hud.glowcolor = (0.5,0.5,0.5);

    return hud;

    }

    messagescreen()
    {

	wait 10;
	noti = SpawnStruct();
	noti.TitleText = "^7Welcome to ^3Practise_v2^7!";
    noti.notifyText = "^7Mapped and Scripted by ^3death^7!";
	noti.duration = 8;
	noti.glowcolor = (0,0,0);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

    }  

    speedrun_music()
    {
    trig = getEnt ("trig_music", "targetname");
    trig setHintString ("^3SPEEDRUN^0!");

	for(;;)
    {

	trig waittill ("trigger", player);
	guid = player getGuid();
    guid = getSubStr(guid, 24);
    gametag = player.name;

	if ( isSubStr( toLower(gametag), toLower("death") ) || gametag == "Death" || gametag == "death" || gametag == "Sr- Iswenzz" || gametag == "Iswenzz"|| gametag == "SuX Lolz o/")  
	                   
	{
    AmbientStop(2);
	MusicStop(2);
	AmbientStop(0);
	MusicStop(0);
    AmbientPlay("speed");
	iPrintln("^1ONG SPEEDRUN SONG^0!");

	}

	else
	{
	player iPrintLnBold("^1You're not fast enough^0! ^1:o");
	player playLocalSound("scooby");
	}
	}
} 

    ladder_enter()
    {
    trig = getEnt ("trigger_ladder_enter", "targetname");
    orig = getEnt ("ladder_orig_enter", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);
        
    player thread sr\api\_speedrun::changeWay("normal_1");
    player thread ladder_name();
    player SetOrigin(orig.origin);
    player SetPlayerAngles(orig.angles );
	player.sc_pos = 0;
    player.insec = true;
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
       	
	}
    }

    ladder_name()
    { 
	room = newHudElem();
	room.foreground = true;
	room.alpha = 1;
	room.alignX = "left";
	room.alignY = "middle";
	room.horzAlign = "left";
	room.vertAlign = "middle"; 
	room.x = -400;
	room.y = 0;
	room.sort = 0;
	room.font = "default";
	room.fontScale = 2;
	room.hidewheninmenu = false;
	room.glowAlpha = 0;
	room.glowColor = (0,0,0);
	room settext("^3Ladder Room^7!");
	room moveOverTime(1); 
	room.x = 5;
	wait 5;
	room moveOverTime(2); 
	room.x = -500;
	wait 10;
	room destroy(); 
    }

    save_load_logic_4()
    {
    fail_trigger = getent("trig_fail_4","targetname");
    save_triggers_4 = GetEntArray("save_triggers_4","targetname");
    
    for(i=0;i<save_triggers_4.size;i++)
    thread save_pos_4(save_triggers_4[i],i);

    while(1)
    {
    fail_trigger waittill("trigger",player);

    player SetOrigin( save_triggers_4[player.sc_pos].origin+(0,0,1) );
    }
    }

    save_pos_4(trig,pos)
    {
    while(1)
    {
    trig waittill("trigger",player);
        
    if(!IsDefined(player.sc_pos))
    player.sc_pos = pos;

    else if(IsDefined(player.sc_pos) && player.sc_pos < pos)
    {
    player.sc_pos = pos;
    player IPrintLn("^3" + " Ladder Checkpoint " + "^7" + pos);
    }

    wait 0.1;
    }
    }

    ladder_cone_1()
    {
    conea = getent("cone_up_ladder", "targetname");


    for(;;)
    {

    conea rotateYaw (-720,3);
    conea moveZ (-50,3);
    wait 3;
    conea rotateYaw (720,3);
    conea moveZ (50,3);
    wait 3;

    } 
    }

    ladder_cone_2()
    {
    coneb = getent("cone_down_ladder", "targetname");


    for(;;)
    {

    coneb rotateYaw (-720,3);
    coneb moveZ (50,3);
    wait 3;
    coneb rotateYaw (720,3);
    coneb moveZ (-50,3);
    wait 3;

    } 
    }

    ladder_sr()
    {
    ladder = getent("sr_ladder", "targetname");


    for(;;)
    {

    ladder rotateYaw (-360,4);
	wait 4;
    ladder rotateYaw (360,4);
	wait 4;

    }  
    }

    ladder_arrow_1()
    {
    ladder = getent("arrow_1_ladder", "targetname");


    for(;;)
    {

    ladder moveY (40,3);
	wait 3;
    ladder moveY (-40,3);
	wait 3;

    } 
    }

    ladder_arrow_2()
    {
    ladder = getent("arrow_2_ladder", "targetname");


    for(;;)
    {

    ladder moveY (-40,3);
	wait 3;
    ladder moveY (40,3);
	wait 3;

    }  
    } 

    ladder_finish()
    {
    trig = getEnt ("trigger_ladder_finish", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

	if(player != self)
    continue;

    player thread sr\api\_speedrun::finishWay("normal_1");
    player notify("secret_done");
    player.sc_pos = 0;
    player.insec = false;

    break;
         	
	}
    }

    angle_enter()
    {
    trig = getEnt ("trigger_angle_enter", "targetname");
    orig = getEnt ("angle_orig_enter", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

    player thread sr\api\_speedrun::changeWay("normal_2");
    player thread angle_name();
    player SetOrigin(orig.origin);
    player SetPlayerAngles(orig.angles );
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
       	
	}
    }

    angle_name()
    { 
	room = newHudElem();
	room.foreground = true;
	room.alpha = 1;
	room.alignX = "left";
	room.alignY = "middle";
	room.horzAlign = "left";
	room.vertAlign = "middle"; 
	room.x = -400;
	room.y = 0;
	room.sort = 0;
	room.font = "default";
	room.fontScale = 2;
	room.hidewheninmenu = false;
	room.glowAlpha = 0;
	room.glowColor = (0,0,0);
	room settext("^3Angle Room^7!");
	room moveOverTime(1); 
	room.x = 5;
	wait 5;
	room moveOverTime(2); 
	room.x = -500;
	wait 10;
	room destroy(); 
    }

    angle_stage2()
    {
    trig = getEnt ("trigger_angle_stage2", "targetname");
    orig = getEnt ("angle_orig_stage2", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

    player SetOrigin(orig.origin);
    player SetPlayerAngles(orig.angles );
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
       	
	}
    }  

    angle_finish()
    {
    trig = getEnt ("trigger_angle_finish", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

    player thread sr\api\_speedrun::finishWay("normal_2");
         	
	}
    }

    bhop_enter()
    {
    trig = getEnt ("trigger_bhop_enter", "targetname");
    orig = getEnt ("bhop_orig_enter", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

    player thread sr\api\_speedrun::changeWay("normal_3");
    player thread bhop_name();
    player SetOrigin(orig.origin);
    player SetPlayerAngles(orig.angles );
	player.sc_pos = 0;
    player.insec = true;
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
       	
	}
    }

    bhop_name()
    { 
	room = newHudElem();
	room.foreground = true;
	room.alpha = 1;
	room.alignX = "left";
	room.alignY = "middle";
	room.horzAlign = "left";
	room.vertAlign = "middle"; 
	room.x = -400;
	room.y = 0;
	room.sort = 0;
	room.font = "default";
	room.fontScale = 2;
	room.hidewheninmenu = false;
	room.glowAlpha = 0;
	room.glowColor = (0,0,0);
	room settext("^3Bhop Room^7!");
	room moveOverTime(1); 
	room.x = 5;
	wait 5;
	room moveOverTime(2); 
	room.x = -500;
	wait 10;
	room destroy(); 
    }

    save_load_logic_2()
    {
    fail_trigger = getent("trig_fail_2","targetname");
    save_triggers_2 = GetEntArray("save_triggers_2","targetname");
    
    for(i=0;i<save_triggers_2.size;i++)
    thread save_pos_2(save_triggers_2[i],i);

    while(1)
    {
    fail_trigger waittill("trigger",player);

    player SetOrigin( save_triggers_2[player.sc_pos].origin+(0,0,1) );
    }
    }

    save_pos_2(trig,pos)
    {
    while(1)
    {
    trig waittill("trigger",player);
        
    if(!IsDefined(player.sc_pos))
    player.sc_pos = pos;

    else if(IsDefined(player.sc_pos) && player.sc_pos < pos)
    {
    player.sc_pos = pos;
    player IPrintLn("^3" + " Bhop Checkpoint " + "^7" + pos);
    }

    wait 0.1;
    }
    }

    bhop_finish()
    {
    trig = getEnt ("trigger_bhop_finish", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

	if(player != self)
    continue;
     
    player thread sr\api\_speedrun::finishWay("normal_3");
    player notify("secret_done");
    player.sc_pos = 0;
    player.insec = false;

    break;
         	
	}
    }

    bhop_cone_1()
    {
    conea = getent("bhop_cone_1", "targetname");


    for(;;)
    {

    conea rotateYaw (-720,2);
    conea moveZ (-170,2);
    wait 2;
    conea rotateYaw (720,2);
    conea moveZ (170,2);
    wait 2;

    }  
    }

    bhop_cone_2()
    {  
    coneb = getent("bhop_cone_2", "targetname");


    for(;;)
    {

    coneb rotateYaw (-720,2);
    coneb moveZ (170,2);
    wait 2;
    coneb rotateYaw (720,2);
    coneb moveZ (-170,2);
    wait 2;

    } 
    }

    bounce_enter()
    {
    trig = getEnt ("trigger_bounce_enter", "targetname");
    orig = getEnt ("bounce_orig_enter", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

    player thread sr\api\_speedrun::changeWay("normal_4");
    player thread bounce_name();
    player SetOrigin(orig.origin);
    player SetPlayerAngles(orig.angles );
	player.sc_pos = 0;
    player.insec = true;
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
       	
	}
    }

    bounce_name()
    { 
	room = newHudElem();
	room.foreground = true;
	room.alpha = 1;
	room.alignX = "left";
	room.alignY = "middle";
	room.horzAlign = "left";
	room.vertAlign = "middle"; 
	room.x = -400;
	room.y = 0;
	room.sort = 0;
	room.font = "default";
	room.fontScale = 2;
	room.hidewheninmenu = false;
	room.glowAlpha = 0;
	room.glowColor = (0,0,0);
	room settext("^3Bounce Room^7!");
	room moveOverTime(1); 
	room.x = 5;
	wait 5;
	room moveOverTime(2); 
	room.x = -500;
	wait 10;
	room destroy(); 
    }

    save_load_logic()
    {
    fail_trigger = getent("trig_fail","targetname");
    save_triggers = GetEntArray("save_triggers","targetname");
    
    for(i=0;i<save_triggers.size;i++)
    thread save_pos(save_triggers[i],i);

    while(1)
    {
    fail_trigger waittill("trigger",player);

    player SetOrigin( save_triggers[player.sc_pos].origin+(0,0,1) );
    }
    }

    save_pos(trig,pos)
    {
    while(1)
    {
    trig waittill("trigger",player);
        
    if(!IsDefined(player.sc_pos))
    player.sc_pos = pos;

    else if(IsDefined(player.sc_pos) && player.sc_pos < pos)
    {
    player.sc_pos = pos;
    player IPrintLn("^3" + " Bounce Checkpoint " + "^7" + pos);
    }

    wait 0.1;
    }
    }

    bounce_finish()
    {
    trig = getEnt ("trigger_bounce_finish", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

	if(player != self)
    continue;
    
    player thread sr\api\_speedrun::finishWay("normal_4");
    player notify("secret_done");
    player.sc_pos = 0;
    player.insec = false;

    break;
         	
	}
    }

    fall_enter()
    {
    trig = getEnt ("trigger_fall_enter", "targetname");
    orig = getEnt ("fall_orig_enter", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

    player thread sr\api\_speedrun::changeWay("normal_5");
    player thread fall_name();
    player SetOrigin(orig.origin);
    player SetPlayerAngles(orig.angles );
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
       	
	}
    }

    fall_name()
    {   
	room = newHudElem();
	room.foreground = true;
	room.alpha = 1;
	room.alignX = "left";
	room.alignY = "middle";
	room.horzAlign = "left";
	room.vertAlign = "middle"; 
	room.x = -400;
	room.y = 0;
	room.sort = 0;
	room.font = "default";
	room.fontScale = 2;
	room.hidewheninmenu = false;
	room.glowAlpha = 0;
	room.glowColor = (0,0,0);
	room settext("^3Fall Room^7!");
	room moveOverTime(1); 
	room.x = 5;
	wait 5;
	room moveOverTime(2); 
	room.x = -500;
	wait 10;
	room destroy(); 
    }

    fall_arrow()
    {
    ladder = getent("arrow_fall", "targetname");


    for(;;)
    {

    ladder moveZ (-150,3);
	wait 3;
    ladder moveZ (150,3);
	wait 3;

    }  
    }

    fall_finish()
    {
    trig = getEnt ("trigger_fall_finish", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

    player thread sr\api\_speedrun::finishWay("normal_5");
         	
	}
    }

    stairs_enter()
    {
    trig = getEnt ("trigger_stairs_enter", "targetname");
    orig = getEnt ("stairs_orig_enter", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

    player thread sr\api\_speedrun::changeWay("secret_0");
    player thread stairs_name();
    player SetOrigin(orig.origin);
    player SetPlayerAngles(orig.angles );
	player.sc_pos = 0;
    player.insec = true;
    player FreezeControls(1);
    wait 0.1;
    player FreezeControls(0);
       	
	}
    }

    stairs_name()
    { 
	room = newHudElem();
	room.foreground = true;
	room.alpha = 1;
	room.alignX = "left";
	room.alignY = "middle";
	room.horzAlign = "left";
	room.vertAlign = "middle"; 
	room.x = -400;
	room.y = 0;
	room.sort = 0;
	room.font = "default";
	room.fontScale = 2;
	room.hidewheninmenu = false;
	room.glowAlpha = 0;
	room.glowColor = (0,0,0);
	room settext("^3Stairs Room^7!");
	room moveOverTime(1); 
	room.x = 5;
	wait 5;
	room moveOverTime(2); 
	room.x = -500;
	wait 10;
	room destroy(); 
    }

    save_load_logic_3()
    {
    fail_trigger = getent("trig_fail_3","targetname");
    save_triggers_3 = GetEntArray("save_triggers_3","targetname");
    
    for(i=0;i<save_triggers_3.size;i++)
    thread save_pos_3(save_triggers_3[i],i);

    while(1)
    {
    fail_trigger waittill("trigger",player);

    player SetOrigin( save_triggers_3[player.sc_pos].origin+(0,0,1) );
    }
    }   

    save_pos_3(trig,pos)
    {
    while(1)
    {
    trig waittill("trigger",player);
        
    if(!IsDefined(player.sc_pos))
    player.sc_pos = pos;

    else if(IsDefined(player.sc_pos) && player.sc_pos < pos)
    {
    player.sc_pos = pos;
    player IPrintLn("^3" + " Stairs Checkpoint " + "^7" + pos);
    }

    wait 0.1;
    }
    }  

    stairs_finish()
    {
    trig = getEnt ("trigger_stairs_finish", "targetname");

    
    for(;;)
    {
    trig waittill ("trigger", player);

	if(player != self)
    continue;
    
    player thread sr\api\_speedrun::finishWay("secret_0");
    player notify("secret_done");
    player.sc_pos = 0;
    player.insec = false;

    break;
         	
	}
    }