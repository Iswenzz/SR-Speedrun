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

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 99999);
    setDvar("bg_falldamageminheight", 99998);

	// addTriggerToList("trig_trap1");
	// addTriggerToList("trig_trap2");
	// addTriggerToList("trig_trap3");
	// addTriggerToList("trig_trap4");
	// addTriggerToList("trig_trap5");
	// addTriggerToList("trig_trap6");
	// addTriggerToList("trig_trap8");
	// addTriggerToList("trig_trap9");
	// addTriggerToList("trig_trap10");
	// addTriggerToList("trig_trap11");

	if(!isdefined(level.music))
		level.music=[];

	level.music[0]["song"]	="Dr.Dre - The Next Episode (San Holo Remix)";
	level.music[0]["alias"]	="dre";
	level.music[1]["song"]	="Brennan Heart - Coming Home";
	level.music[1]["alias"]	="hardstyleb";
	level.music[2]["song"]	="Armin Buuren - Another You";
	level.music[2]["alias"]	="anotheryou";
	level.music[3]["song"]	="Our last night - Road To The Throne";
	level.music[3]["alias"]	="throne";
	level.music[4]["song"]	="Flo Rida - My House";
	level.music[4]["alias"]	="myhouse";
	level.music[5]["song"]	="L1mit - Vistic Antheme";
	level.music[5]["alias"]	="vistic_antheme";

    thread sr\api\_map::createSpawn((42,268,64),90);
    thread sr\api\_speedrun::createNormalWays("Normal Way;");
    thread sr\api\_speedrun::createSecretWays("^2Easy Secret;^1Hard Secret;");

	thread startdoor();
	thread tele1();
	thread mover1();
	thread lastmover();
	thread secret_e_end();
	thread secret_h_end();
	thread secretrig_e();
	thread secretrig_h();
	//thread acti_tele1();
	//thread acti_tele1back();
	//thread acti_tele2();
	//thread acti_tele2back();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap8();
    thread trap9();
	thread trap10();
	thread trap11();
	thread knifeplat();
	thread wruntest1();
	//thread actistep1();
	//thread rings();
	thread ring1();
	thread ring2();
	thread ring3();
	thread ring4();
	thread tap1();
	//thread e_snip();
	//thread e_pistol();
	//thread h_dsr50();
	//thread h_snip();
	//thread h_pistol();
	//thread h_rifle();
	//thread h_smg();
	//thread h_rpg();
    thread sg_up();
	thread sr_tp();
	thread sr_tp2();
}

sr_tp()
{
	trig = spawn("trigger_radius",(40,173,300), 0, 100, 50);
	trig.radius = 100;
	ori_t = getEnt("tele1_go","targetname");

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
	}
}

sr_tp2()
{
	trig = spawn("trigger_radius",(-124.553, 306.589, 4.125), 0, 50, 100);
	trig.radius = 50;
	ori_t = getEnt("secretrig_go","targetname");

	wait 1;
	thread sr\api\_map::createTriggerFx(trig, "blue");

	for(;;)
	{
		trig waittill("trigger",player);

		player SetOrigin(ori_t.origin);
		player SetPlayerAngles(ori_t.angles);
	}
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

startdoor()
{
	object1 = getent("startdoor1","targetname");
	object2 = getent("startdoor2","targetname");
	tap4_wat = getent("tap4_wat","targetname");

	wait 0.1;
	tap4_wat delete();
	object1 delete();
	object2 delete();
}

tele1()
{
	trig = getEnt ("tele1", "targetname");
	end = getEnt ("tele1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}
}

mover1()
{
	mover = getEnt ("mover1", "targetname");
	mover delete();
}
	
lastmover()
{
	trigger = getEnt ("lastmover_trig","targetname");
	mover = getEnt ("lastmover", "targetname");
	trigger waittill ("trigger", player);
	wait 2;
	while(1)
	{
		mover movex (-3776,2,1.5,0.5);
		mover waittill ("movedone");
		mover movey (3866,2,1.5,0.5);
		mover waittill ("movedone");
		wait 2;
		mover movey (-3866,2,1.5,0.5);
		mover waittill ("movedone");
		mover movex (3776,2,1.5,0.5);
		mover waittill ("movedone");
		wait 2;
	}
}

secretrig_e()
{
	trig = getEnt ("secretrig_e", "targetname");
	end = getEnt ("secretrig_e_go", "targetname");
	for(;;)
    {
    trig waittill ("trigger", player);
	player thread sr\api\_speedrun::changeWay("secret_0");       
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	player freezeControls(1);
	wait 0.05;
	player freezeControls(0);
	}

	
}

secretrig_h()
{
	trig = getEnt ("secretrig_h", "targetname");
	end = getEnt ("secretrig_h_go", "targetname");
	for(;;)
    {
    trig waittill ("trigger", player);
	player thread sr\api\_speedrun::changeWay("secret_1");        
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	player freezeControls(1);
	wait 0.05;
	player freezeControls(0);
	}

	
}

secret_e_end()
{
	trig = getEnt ("secret_e_end", "targetname");
	end = getEnt ("secret_e_end_go", "targetname");
	for(;;)
    {
    trig waittill ("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_0");
	player notify("secret1_done");
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}

}

secret_h_end()
{
	trig = getEnt ("secret_h_end", "targetname");
	end = getEnt ("secret_h_end_go", "targetname");
	for(;;)
    {
    trig waittill ("trigger", player);
	player thread sr\api\_speedrun::finishWay("secret_1");
	player notify("secret2_done");
	player SetOrigin(end.origin);
    player SetPlayerAngles( end.angles );
	}

}

	acti_tele1()
{
	trig = getEnt ("acti_tele1", "targetname");
	end = getEnt ("acti_tele1_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

	acti_tele1back()
{
	trig = getEnt ("acti_tele1back", "targetname");
	end = getEnt ("acti_tele1back_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}
	
	acti_tele2()
{
	trig = getEnt ("acti_tele2", "targetname");
	end = getEnt ("acti_tele2_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

	acti_tele2back()
{
	trig = getEnt ("acti_tele2back", "targetname");
	end = getEnt ("acti_tele2back_go", "targetname");
	while(1)
    	{
        trig waittill ("trigger", player);          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}

}

	trap1()
{
	trigger = getEnt ("trig_trap1","targetname");
	object1 = getEnt ("trap1","targetname");
	object2 = getEnt ("trap1_2","targetname");
	trigger waittill ("trigger", player );
	
	}


	trap2()
{
	trigger = getEnt ("trig_trap2","targetname");
	object = getEnt ("trap2","targetname");
	trigger waittill ("trigger", player );
	}

	trap3()
{
	trigger = getEnt ("trig_trap3","targetname");
	object = getEnt ("trap_3","targetname");
	trigger waittill ("trigger", player );
	}


	trap4()
{
	trigger = getEnt ("trig_trap4","targetname");
	object = getEnt ("trap_4","targetname");
	trigger waittill ("trigger", player );
	
	{
		
	}
}

	trap5()
{
	trigger = getEnt ("trig_trap5","targetname");
	object1 = getEnt ("trap_5_1","targetname");
	object2 = getEnt ("trap_5_2","targetname");
	object3 = getEnt ("trap_5_3","targetname");
	object4 = getEnt ("trap_5_4","targetname");
	object5 = getEnt ("trap_5_5","targetname");
	trigger waittill ("trigger", player );
	
	{

		
	}
}

	trap6()
{
	trigger = getEnt ("trig_trap6","targetname");
	object = getEnt ("mover1","targetname");
	trigger waittill ("trigger", player );
	
}

	trap8()
{
	trigger = getEnt ("trig_trap8","targetname");
	slide1 = getEnt ("trap_8_1","targetname");
	slide2 = getEnt ("trap_8_2","targetname");
	slide3 = getEnt ("trap_8_3","targetname");

	slide1 delete();
	slide2 delete();
	slide3 delete();
	trigger waittill ("trigger", player );
	
}

	trap9()
{
	trigger = getEnt ("trig_trap9","targetname");
	object = getEnt ("trap9","targetname");
	fx_spot = getEnt ("trap9_fx","targetname");
	trigger waittill ("trigger", player );
	
}

	trap10()
{
	trigger = getEnt ("trig_trap10","targetname");
	object = getEnt ("trap10","targetname");
	killtrig = getEnt ("trap10_killtrig","targetname");
	object movey (-1024,0.1);
	trigger waittill ("trigger", player );
	
}

	trap11()
{
	trigger = getEnt ("trig_trap11","targetname");
	bounce = getEnt ("trap11_1","targetname");
	rope = getEnt ("trap11_2","targetname");

	wait 0.1;

	rope delete();

}

	knifeplat()
{
	platf1 = getEnt ("knife_plat1","targetname");
	platf2 = getEnt ("knife_plat2","targetname");
	wait 1;
	platf1 rotateroll (90, 3);
	platf2 rotateroll (-90, 3);
}

	wruntest1()
{
	object = getEnt ("wallruntest1","targetname");
	object2 = getEnt ("wallrun7","targetname");
	
	wait 0.1;
	object rotatepitch (110, 0.1);
	object2 rotatepitch (110, 0.1);
}

	actistep1()
{
	trigger = getEnt ("acti_step1","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^91" );
	thread actistep2();
}

	actistep2()
{
	trigger = getEnt ("acti_step2","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^92" );
	thread actistep3();
}

	actistep3()
{
	trigger = getEnt ("acti_step3","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^93" );
	thread actistep4();
}

	actistep4()
{
	trigger = getEnt ("acti_step4","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^94" );
	thread actistep5();
}

	actistep5()
{
	trigger = getEnt ("acti_step5","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^95" );
	thread actistep6();
}

	actistep6()
{
	trigger = getEnt ("acti_step6","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^96" );
	thread actistep7();
}

	actistep7()
{
	trigger = getEnt ("acti_step7","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^97" );
	thread actistep8();
}

	actistep8()
{
	trigger = getEnt ("acti_step8","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^98" );
	thread actistep9();
}

	actistep9()
{
	trigger = getEnt ("acti_step9","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^99" );
	thread actistep10();
}

	actistep10()
{
	trigger = getEnt ("acti_step10","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^910" );
	thread actistep11();
}

	actistep11()
{
	trigger = getEnt ("acti_step11","targetname");
	object = getEnt ("wall03","targetname");
	trigger waittill ("trigger", player );
	iprintln( "^911" );
	object notSolid();
	
}

	tap1()
{
	trigger = getEnt ("tap1","targetname");
	trigger waittill ("trigger", player );
	thread tap2();
}

	tap2()
{
	trigger = getEnt ("tap2","targetname");
	trigger waittill ("trigger", player );
	thread tap3();
}

	tap3()
{
	trig = getEnt ("tap3","targetname");
	end = getEnt ("tap4", "targetname");
	tap4_wat = getEnt ("tap4_wat","targetname");
	while(1)
    	{
        trig waittill ("trigger", player);
	tap4_wat Solid();          
	player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}


}

jump_fail()
{
	failtrig=getent("jump_alltp","targetname");
	for(;;)
	{
		failtrig waittill("trigger",player);
		if(player.pers["team"]!="spectator")
		{
			if(player.pers["team"]=="allies")
			{
				switch(randomint(3))
				{
					case 0:
						player setplayerangles(getent("jump_jt_go1","targetname").angles);
						player setorigin(getent("jump_jt_go1","targetname").origin);
						break;
					case 1:
						player setplayerangles(getent("jump_jt_go2","targetname").angles);
						player setorigin(getent("jump_jt_go2","targetname").origin);
						break;
					case 2:
						player setplayerangles(getent("jump_jt_go3","targetname").angles);
						player setorigin(getent("jump_jt_go3","targetname").origin);
						break;
				}
			}
			else 
			{
				switch(randomint(3))
				{
					case 0:
						player setplayerangles(getent("jump_at_go1","targetname").angles);
						player setorigin(getent("jump_at_go1","targetname").origin);
						break;
					case 1:
						player setplayerangles(getent("jump_at_go2","targetname").angles);
						player setorigin(getent("jump_at_go2","targetname").origin);
						break;
					case 2:
						player setplayerangles(getent("jump_at_go3","targetname").angles);
						player setorigin(getent("jump_at_go3","targetname").origin);
						break;
				}
			}
		}
	}
}

jump_room_gun()
{
	trig=getent("jumproom_weapon","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("remington700_mp");
		p givemaxammo("remington700_mp");
		p switchtoweapon("remington700_mp");
		wait 1;
	}
}

jump_room_gun2()
{
	trig=getent("jumproom_weapon2","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("dsr50_mp");
		p givemaxammo("dsr50_mp");
		p switchtoweapon("dsr50_mp");
		wait 1;
	}
}



jump_room_battle()
{
    level.jump_trig=getent("jumproom_ent","targetname");
    level.jump_door=getent("jumproom_door","targetname");
 
    jump=getent("jumproom_go","targetname");
    acti=getent("jumproom_acti","targetname");
 
    while(1)
    {
        level.jump_trig waittill("trigger",player);

        thread jump_fail();
		thread jump_room_gun();
		thread jump_room_gun2();
		thread j_gun1();
		thread j_gun2();
        
        if(!isdefined(level.jump_trig)) return;
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
           
            ambientstop();
          
            level.canPlaySound=false;

            iprintln("^1Now playing:^7 Knife Party ^1-^7 Bonfire");
 
            level.old_trig delete();
            level.knife_trig delete();
            level.sgun_trig delete();
            level.sniper_trig delete();
            level.rpg_trig delete();
 
            level.old_door movex (-64, 0.1);
			level.snip_door movex (-64, 0.1);
			level.knife_door movex (-64, 0.1);
			level.rpg_door movex (-64, 0.1);
			level.sgun_door movex (-64, 0.1);
 
            iprintlnbold("^1"+player.name+" ^7entered Jump room.");
        }
 
        player createroomport("knife_mp",undefined,1,jump,100);
        level.activ createroomport("knife_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
    }
}

sniper_room_battle()
{
    level.sniper_trig=getent("sniproom_ent","targetname");
    level.snip_door=getent("sniproom_door","targetname");
 
    jump=getent("sniproom_go","targetname");
    acti=getent("sniproom_acti","targetname");
 
    while(1)
    {
       level.sniper_trig waittill("trigger",player);

        thread walls_snip();
		thread s_gun1();
		thread s_gun2();

        if(!isdefined(level.sniper_trig)) return;
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
           
            ambientstop();
           
            level.canPlaySound=false;

            iprintln("^1Now playing:^7 Knife Party ^1-^7 Sleaze");
 
            level.old_trig delete();
			level.jump_trig delete();
			level.knife_trig delete();
			level.rpg_trig delete();
			level.sgun_trig delete();
 
            level.old_door movex (-64, 0.1);
			level.jump_door movex (-64, 0.1);
			level.knife_door movex (-64, 0.1);
			level.rpg_door movex (-64, 0.1);
			level.sgun_door movex (-64, 0.1);
 
            iprintlnbold("^1"+player.name+" ^7entered Sniper room.");
        }
 
        player createroomport("dsr50_mp","remington700_mp",1,jump,100);
        level.activ createroomport("dsr50_mp","remington700_mp",1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
    }
}

rpg_room_battle()
{
    level.rpg_trig=getent("rpgroom_ent","targetname");
    level.rpg_door=getent("rpgroom_door","targetname");
 
    jump=getent("rpgroom_go","targetname");
    acti=getent("rpgroom_acti","targetname");
 
    while(1)
    {
       	level.rpg_trig waittill("trigger",player);
        if(!isdefined(level.rpg_trig)) return;
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
           
            ambientstop();
           
            level.canPlaySound=false;

            iprintln("^1Now playing:^7 The Glitch Mob ^1-^7 I need my Memory back");
 
            level.old_trig delete();
			level.jump_trig delete();
			level.knife_trig delete();
			level.sniper_trig delete();
			level.sgun_trig delete();
 
            level.old_door movex (-64, 0.1);
			level.snip_door movex (-64, 0.1);
			level.knife_door movex (-64, 0.1);
			level.jump_door movex (-64, 0.1);
			level.sgun_door movex (-64, 0.1);
 
            iprintlnbold("^1"+player.name+" ^7entered RPG room.");
        }
 
        player createroomport("rpg_mp",undefined,1,jump,100);
        level.activ createroomport("rpg_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();

        player thread refreshAmmo();
        level.activ thread refreshAmmo();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
    }
}

sgun_room_battle()
{
   	level.sgun_trig=getent("sgunroom_ent","targetname");
    level.sgun_door=getent("sgunroom_door","targetname");
 
    jump=getent("sgunroom_go","targetname");
    acti=getent("sgunroom_acti","targetname");
 
    while(1)
    {
       	level.sgun_trig waittill("trigger",player);
        if(!isdefined(level.sgun_trig)) return;
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
           
            ambientstop();
           
            level.canPlaySound=false;

            iprintln("^1Now playing:^7 Knife Party ^1-^7 Give it up");
 
            level.old_trig delete();
			level.jump_trig delete();
			level.knife_trig delete();
			level.sniper_trig delete();
			level.rpg_trig delete();
 
            level.old_door movex (-64, 0.1);
			level.snip_door movex (-64, 0.1);
			level.knife_door movex (-64, 0.1);
			level.rpg_door movex (-64, 0.1);
			level.jump_door movex (-64, 0.1);
 
            iprintlnbold("^1"+player.name+" ^7entered Shotgun room.");
        }
 
        player createroomport("winchester1200_mp",undefined,1,jump,100);
        level.activ createroomport("winchester1200_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();

        player thread refreshAmmo();
        level.activ thread refreshAmmo();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

        iPrintlnBold("^1"+self.name+" ^7died^1!");
    }
}

knife_room_battle()
{
    level.knife_trig=getent("kniferoom_ent","targetname");
    level.knife_door=getent("kniferoom_door","targetname");
 
    knife=getent("kniferoom_go","targetname");
    acti=getent("kniferoom_acti","targetname");
 
    while(1)
    {
        level.knife_trig waittill("trigger",player);
        if(!isdefined(level.knife_trig)) return;
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
           
            ambientstop();
           
            level.canPlaySound=false;

            iprintln("^1Now playing:^7 Eminem ^1-^7 Lose yourself");
 
            level.old_trig delete();
            level.jump_trig delete();
            level.sgun_trig delete();
            level.sniper_trig delete();
            level.rpg_trig delete();
 
            level.old_door movex (-64, 0.1);
            level.snip_door movex (-64, 0.1);
            level.jump_door movex (-64, 0.1);
            level.rpg_door movex (-64, 0.1);
            level.sgun_door movex (-64, 0.1);
 
            thread sidewayLyrics();
            iprintlnbold("^1"+player.name+" ^7entered Knife room.");
        }

		wait 20.7;
 
        player createroomport("knife_mp",undefined,1,knife,100);
        level.activ createroomport("knife_mp",undefined,1,acti,100);
 
        player thread countdown();
        level.activ thread countdown();
 
       	while(isalive(player)&&isdefined(player))
            wait 1;

         iPrintlnBold("^1"+self.name+" ^7died^1!");
    }
}

refreshAmmo()
{
	while(isalive(self)&&isdefined(self))
	{
		self givemaxammo("rpg_mp");
		wait 4;
	}
}
 
sidewayLyrics()
{
    wait 2.6;
    iPrintlnBold( "^5Look" );
    wait 2.6;
    iPrintlnBold( "^5If you had" );
    wait 2.3;
    iPrintlnBold( "^5One shot" );
    wait 2;
    iPrintlnBold( "^5Or one opportunity" );
    wait 2.5;
    iPrintlnBold( "^5To seize everything you ever wanted" );
    wait 3;
    iPrintlnBold( "^5One moment" );
    wait 2.2;
    iPrintlnBold( "^5Would you capture it" );
    wait 2.1;
    iPrintlnBold( "^5Or just let it slip?" );
    wait 1.4;
    iPrintlnBold( "^1 YO" );
}
 
createroomport(weapon,weapon2,freeze,where,health)
{
    self takeallweapons();
    self giveweapon(weapon);
    if(isdefined(weapon2))
    	self giveweapon(weapon2);
    self switchtoweapon(weapon);
 
    self freezecontrols(freeze);
    self setorigin(where.origin);
    self setplayerangles(where.angles);
 
    self.health=health;
}
 
countdown()
{
    self iprintlnbold("^33");
    wait 1;
    self iprintlnbold("^32");
    wait 1;
    self iprintlnbold("^31");
    wait 1;
    self iprintlnbold("^5Fight!");
    wait 1;
    self freezecontrols(0);
}

old_room_battle()
{
    level.old_trig=getent("oldroom_ent","targetname");
    level.old_door=getent("oldroom_door","targetname");
 
    jump=getent("oldroom_go","targetname");

    while(1)
    {
        level.old_trig waittill("trigger",player);
 
        if(!isdefined(level.entertext)||!level.entertext)
        {
            level.entertext=true;
            level.canPlaySound=false;

            iprintln("^1Now playing:^7 Eminem ^1-^7 Lose yourself");
 
            level.knife_trig delete();
			level.jump_trig delete();
			level.sgun_trig delete();
			level.sniper_trig delete();
			level.rpg_trig delete();
 
            level.jump_door movex (-64, 0.1);
			level.snip_door movex (-64, 0.1);
			level.knife_door movex (-64, 0.1);
			level.rpg_door movex (-64, 0.1);
			level.sgun_door movex (-64, 0.1);
 
            iprintlnbold("^1"+player.name+" ^7entered Old room.");
        }
        player setorigin(jump.origin);
        player setplayerangles(jump.angles);
    }
}


	
p_room()
{
	trigger = getEnt ("p_room","targetname");
	trigger waittill ("trigger", player );
	iPrintlnBold(" ^7Activator entered the ^6Porn room ");
}



rings()
{
	trig = getEnt ("rings_trig", "targetname");
	end = getEnt ("rings_trig_go", "targetname");
	while(1)
    {
        trig waittill ("trigger", player);
		player iprintlnBold ("^3Use 333 fps!");          
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
	}	
}

ring1()
{
	trigger = getEnt ("ring1","targetname");
	trigger waittill ("trigger", player );
	player braxi\_rank::giveRankXP("", 69);
	player iprintlnbold ("You got the ring ^61!");
	iprintln("Someone got the ring ^61");
}

	ring2()
{
	trigger = getEnt ("ring2","targetname");
	trigger waittill ("trigger", player );
	player braxi\_rank::giveRankXP("", 69);
	player iprintlnbold ("You got the ring ^62!");
	iprintln("Someone got the ring ^62");
}

	ring3()
{
	trigger = getEnt ("ring3","targetname");
	trigger waittill ("trigger", player );
	player braxi\_rank::giveRankXP("", 69);
	player iprintlnbold ("You got the ring ^63!");
	iprintln("Someone got the ring ^63");
}

	ring4()
{
	trigger = getEnt ("ring4","targetname");
	trigger waittill ("trigger", player );
	player braxi\_rank::giveRankXP("", 69);
	player iprintlnbold ("You got the ring ^64!");
	iprintln("Someone got the ring ^64");
}

	secret_statue()
{
        trigger = getEnt ( "trig_secret_wep", "targetname" );
	object = getEnt ( "secret_statue", "targetname" );
        while(1)
        {
                trigger waittill ( "trigger", player );
                wait 0.05;
                player giveWeapon ( "dsr50_mp" );
                player giveMaxAmmo ( "dsr50_mp" );
                player switchToWeapon ( "dsr50_mp" );
		object movez(12,0.5);
		object waittill ("movedone");
		object movez(-12,0.5);
        }
}

	j_gun1()
{
	trigger = getEnt ( "j_gun1", "targetname" );
	object = getEnt ( "ak_jgun1", "targetname" );
        trigger waittill ( "trigger", player );
        wait 0.05;
	player braxi\_rank::giveRankXP("", 100);
        player giveWeapon ( "ak74u_mp" );
        player switchToWeapon ( "ak74u_mp" );
        player giveMaxAmmo ( "ak74u_mp" );
	object delete();
	trigger delete();
}

	j_gun2()
{
	trigger = getEnt ( "j_gun2", "targetname" );
	object = getEnt ( "ak_jgun2", "targetname" );
        trigger waittill ( "trigger", player );
        wait 0.05;
	player braxi\_rank::giveRankXP("", 100);
        player giveWeapon ( "ak74u_mp" );
        player switchToWeapon ( "ak74u_mp" );
        player giveMaxAmmo ( "ak74u_mp" );
	object delete();
	trigger delete();
}

	s_gun1()
{
	trigger = getEnt ( "s_gun1", "targetname" );
	object = getEnt ( "snip_sgun1", "targetname" );
        trigger waittill ( "trigger", player );
        wait 0.05;
	player braxi\_rank::giveRankXP("", 100);
        player giveWeapon ( "m40a3_mp" );
        player switchToWeapon ( "m40a3_mp" );
        player giveMaxAmmo ( "m40a3_mp" );
	object delete();
	trigger delete();
}

	s_gun2()
{
	trigger = getEnt ( "s_gun2", "targetname" );
	object = getEnt ( "snip_sgun2", "targetname" );
        trigger waittill ( "trigger", player );
        wait 0.05;
	player braxi\_rank::giveRankXP("", 100);
        player giveWeapon ( "m40a3_mp" );
        player switchToWeapon ( "m40a3_mp" );
        player giveMaxAmmo ( "m40a3_mp" );
	object delete();
	trigger delete();
}

	walls_snip()
{
	object1 = getEnt ( "wall_s1", "targetname" );
	object2 = getEnt ( "wall_s2", "targetname" );
	object1 notSolid();
	object2 notSolid();
}
	

Menu()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned" );
	self endon( "joined_spectators" );
	self endon( "music thread terminated" );
 
	self thread onDeath();
	self thread onDisconnect();
 
	self.hud_music = [];
	self.selection = 0;
 
	// create huds
	i = 0;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
	self.hud_music[i].sort = 880;
	self.hud_music[i] setShader( "black", 320, 160 );
	
	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
	self.hud_music[i].sort = 884;
	self.hud_music[i] setText("Last Song by our boi ^1VC' L1mit^7!");
	self.hud_music[i].glowalpha=1;
	if(isdefined(level.randomcolor))
		self.hud_music[i].glowcolor=level.randomcolor;
	else 
		self.hud_music[i].glowcolor=(1,0,0);

	i++;
	self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
	self.hud_music[i].sort = 886;
	self.hud_music[i] setText("Scroll: ^3[{+attack}] ^7| Select: ^3[{+activate}] ^7| Close: ^3[{+frag}]");
 
	for( j = 0; j < level.music.size; j++ )
	{
		i++;
		self.hud_music[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
		self.hud_music[i].sort = 882;
		self.hud_music[i].font = "objective";
		self.hud_music[i].glowalpha=1;
		if(isdefined(level.randomcolor))
			self.hud_music[i].glowcolor=level.randomcolor;
		else 
			self.hud_music[i].glowcolor=(1,0,0);
 
		entry = level.music[j];
		self.hud_music[i] setText(entry["song"]);
	}
 
	i++;
	self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
	self.hud_music[i].sort = 881;
	indicator = self.hud_music[self.hud_music.size-1];
	indicator setShader( "white", 306, 17 );
 
	while(self.sessionstate == "playing")
	{
		wait 0.1;
 
		if(self attackButtonPressed())
		{
			self.hud_music[3+self.selection].alpha = 0.93;
 
			self.selection++;
			if( self.selection >= level.music.size )
				self.selection = 0;
 
			item = self.hud_music[3+self.selection];
			item.alpha = 1;
			indicator.y = item.y;
		}
		else if(self useButtonPressed())
		{
 			iprintln("^1>> ^7Now playing: ^1"+level.music[self.selection]["song"]);
			
			self freezecontrols(0);
			break;
		}
		else if(self fragButtonPressed())
		{
			self freezecontrols(0);
			break;
		}
	}
 
	self cleanUp();
}
 
 
	onDisconnect()
{
	self endon( "music thread terminated" );
	self waittill( "disconnect" );
	self cleanUp();
}
 
	onDeath()
{
	self endon( "disconnect" );
	self endon( "music thread terminated" );
	self waittill( "death" );
	self cleanUp();
}
 
	cleanUp()
{
	if( !isDefined( self ) )
		return;

	
 
	if( isDefined( self.hud_music ) )
	{
		for( i = 0; i < self.hud_music.size; i++ )
		{
			if( isDefined( self.hud_music[i] ) )
				self.hud_music[i] destroy();
		}
	}
	self notify( "music thread terminated" );
}


	e_snip()
{
	trig=getent("e_snip","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("m40a3_mp");
		p givemaxammo("m40a3_mp");
		p switchtoweapon("m40a3_mp");
		wait 1;
	}
}

	e_pistol()
{
	trig=getent("e_pistol","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("deserteagle_mp");
		p givemaxammo("deserteagle_mp");
		p switchtoweapon("deserteagle_mp");
		wait 1;
	}
}

	h_dsr50()
{
	trig=getent("h_dsr50","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("dsr50_mp");
		p givemaxammo("dsr50_mp");
		p switchtoweapon("dsr50_mp");
	}
}

	h_snip()
{
	trig=getent("h_snip","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("remington700_mp");
		p givemaxammo("remington700_mp");
		p switchtoweapon("remington700_mp");
		wait 1;
	}
}

	h_pistol()
{
	trig=getent("h_pistol","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("deserteaglegold_mp");
		p givemaxammo("deserteaglegold_mp");
		p switchtoweapon("deserteaglegold_mp");
		wait 1;
	}
}

	h_rifle()
{
	trig=getent("h_rifle","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("ak47_mp");
		p givemaxammo("ak47_mp");
		p switchtoweapon("ak47_mp");
		wait 1;
	}
}

	h_smg()
{
	trig=getent("h_smg","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("ak74u_mp");
		p givemaxammo("ak74u_mp");
		p switchtoweapon("ak74u_mp");
		wait 1;
	}
}

	h_rpg()
{
	trig=getent("h_rpg","targetname");
	for(;;)
	{
		trig waittill("trigger",p);
		p giveweapon("rpg_mp");
		p givemaxammo("rpg_mp");
		p switchtoweapon("rpg_mp");
		wait 1;
	}
}

	sg_up()
{
	trig = getEnt ("sg_up", "targetname");
	end1 = getEnt ("sg_up1", "targetname");
	end2 = getEnt ("sg_up2", "targetname");
	end3 = getEnt ("sg_up3", "targetname");
	end4 = getEnt ("sg_up4", "targetname");
	end5 = getEnt ("sg_up5", "targetname");
	end6 = getEnt ("sg_up6", "targetname");
	while(1)
	{
		trig waittill ("trigger", player);
		i = randomintrange( 0, 6 );
		if(i == 0)
		{          
		player SetOrigin(end1.origin);
        	player SetPlayerAngles( end1.angles );
		}
		else if(i == 1)
		{
		player SetOrigin(end2.origin);
        	player SetPlayerAngles( end2.angles );
		}
		else if(i == 2)
		{
		player SetOrigin(end3.origin);
        	player SetPlayerAngles( end3.angles );
		}
		else if(i == 3)
		{
		player SetOrigin(end4.origin);
        	player SetPlayerAngles( end4.angles );
		}
		else if(i == 4)
		{
		player SetOrigin(end5.origin);
        	player SetPlayerAngles( end5.angles );
		}
		else if(i == 5)
		{
		player SetOrigin(end6.origin);
        	player SetPlayerAngles( end6.angles );
		}
	}
}