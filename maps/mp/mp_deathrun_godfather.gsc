/////////////////////////////////////////////////////////////////////////
//Map name:Godfather|Supported gametype: Deathrun|Edit/Use with Perm!  //
//Author:Dr. Uzi (All the works) & DonTaki (Creative Manager,ideas,etc)//
//Additional help: Neo | Thanks to: IELIITEMODZX & Ratzee & Club27 Team//
//Traps:13|Our Xfire:undefinedno1 & hundontaki|Map dedicated to Club27!//
/////////////////////////////////////////////////////////////////////////
main()
{
	maps\mp\_load::main();
	maps\mp\godfather2::main();
	//maps\mp\uziend::main();
	precacheItem( "uzi_acog_mp" );
	precacheItem( "m40a3_mp" );
	precacheItem( "saw_acog_mp" );
	precacheItem( "m16_mp" );
	precacheItem( "colt45_mp" );
	precacheItem( "rpg_mp" );
	thread start();
	//thread jukeBox();
	//thread music();
    thread speedrun\_way_name::create_normal_way("^1G^2O^3D^4F^5A^6T^1H^2E^3R");

	
}


music()
{
	x = RandomInt(2);
	switch( int(x) )
	{
	case 0:
	ambientPlay( "music1" );
	case 1:
	ambientPlay( "music2" );
	case 2:
	ambientPlay( "music3" );
	case 3:
	ambientPlay( "music4" );
	default: return;
	}
}

start()
{
	//thread secret();
	level.endselected["open"] = false;
	level.exp_fx = LoadFx("explosions/vehicle_explosion_bmp");
	level.door_fx = LoadFx("explosions/ammo_cookoff");
	level.rpd_fx = LoadFx("muzzleflashes/saw_flash_wv_b");
	level.heli_fx = LoadFx("explosions/helicopter_explosion");
	level.end_fx = LoadFx("smoke/bm21_launch_smoke");
	PreCacheShellShock( "frag_grenade_mp" );
	// wait 10;
	// thread drawInformation( 800, 0.8, 1, "Map made by:club27|Dr. Uzi" );
	// wait 4;
	// thread drawInformation( 800, 0.8, 1, "Special thanks to: DonTaki" );
}

drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 60 );
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

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

///////////////////////////////////////////////////////////////////////

secret()
{
	secrettrig = getent("start", "targetname");
	trig = getent("secretfusion", "targetname");
	obj2 = getent("start_open","targetname");
	obj = getent("secretacti","targetname");
	secrettrig waittill( "trigger", who );
	obj2 delete();
	trig waittill( "trigger", who ); 
	wait 0.1;
	trig delete();
	wait 0.1;
	obj delete();
	iprintlnBold(who.name + " ^1Opened ^7the secret!");
	ambientStop(0);
	ambientPlay("music5");
	who takeAllWeapons();
	who GiveWeapon("uzi_acog_mp");
	who SwitchToWeapon("uzi_acog_mp");
	iprintlnBold("Special thanks to our ^1P�zs�r ^7alias ^3Hiroe");
	iprintlnBold("To creative manager: ^3DonTaki");
	iprintlnBold("^1Additional Help: ^3Neo");
	who iprintlnBold("And the club27 Team Leader: ^3rocco ^7!");
}

////////////////////////////////////////////////////////////////////////////

    jukeBox()
    {
            level endon("song_picked");
            trigger = getEnt("jukebox","targetname");
            while(1)
            {
                    trigger waittill("trigger",player);
                    if(!level.juke["open"])
                    {
                            level.juke["open"] = true;
                            player thread createJuke();
                            player thread jukeDeath();
                    }
                    wait .05;
            }
    }
    createJuke()
    {
            level.juke["background"] = createRectangle("","",0,0,1000,720,(0,0,0),"white",10,1);
            level.juke["center_line"] = createRectangle("","",0,0,3,720,(1,1,1),"white",20,.6);
            level.juke["top_option"][0] = createText("default",2.3,"RIGHT","",-10,-135,1,100,"Ends");
            level.juke["top_option"][1] = createText("default",2.3,"LEFT","",10,-135,1,100,"Description");
            for(k = 0; k < level.juke["top_option"].size; k++)
            {
                    level.juke["top_option"][k].glowAlpha = 1;
                    level.juke["top_option"][k].glowColor = (0,0,1);
            }
            level.juke["curs"] = 0;
            level.options = strTok("The Old way;Activator need to escape to the safecar;It's time to rush that house!;The Don&Challangers get rifles, for the eliminate;No weapons, no hopes, only fist;Only need perfect jumps...;2 Men 1 roll",";");
            level.artists = strTok("The Good Old End;The Assassin fight back;Don in the SafeHouse;Snipe it down!;The Hurt;Jump like a bunny;The Dice",";");
            level.actions = strTok("end;end_01;end_02;end_03;end_04;end_05;end_07",";");
            for(k = 0; k < level.options.size; k++)
            {
                    level.juke["options"][k] = createText("default",1.6,"LEFT","",10,((k*40)-100),1,100,level.options[k]);
                    level.juke["options"][k].glowColor = (1,0,0);
                   
                    level.juke["artists"][k] = createText("default",2.7,"RIGHT","",-10,((k*40)-100),1,100,level.artists[k]);
                    level.juke["artists"][k].glowAlpha = 1;
                    level.juke["artists"][k].glowColor = (0.8,0.3,1);
            }
            level.juke["options"][0].glowAlpha = 1;
            wait .2;
            thread runJuke();
    }
    runJuke()
    {
            self endon("death");
            while(level.juke["open"])
            {
                    self freezeControls(true);
                    if(self attackButtonPressed() || self adsButtonPressed())
                    {
                            level.juke["curs"] -= self adsButtonPressed();
                            level.juke["curs"] += self attackButtonPressed();
                            if(level.juke["curs"] >= level.options.size)
                                    level.juke["curs"] = 0;
                                   
                            if(level.juke["curs"] < 0)
                                    level.juke["curs"] = level.options.size-1;
                                   
                            for(k = 0; k < level.juke["options"].size; k++)
                                    if(k != level.juke["curs"])
                                            level.juke["options"][k].glowAlpha = 0;
                                    else
                                            level.juke["options"][k].glowAlpha = 1;
                                           
                            wait .15;
                    }
                    if(self useButtonPressed())
                    {
                            iPrintlnBold(self.name+" Has Picked ^2"+level.artists[level.juke["curs"]]);
                            iPrintln("Thank you IELIITEMODZX!");
                            level notify("song_picked");
                            getEnt("jukebox","targetname") setHintString("End selected! Have Fun!");
                            thread maps\mp\uziend::setend (level.options[level.juke["curs"]]);
                            break;
                    }
                    if(self meleeButtonPressed())
                            break;
                           
                    wait .05;
            }
            self notify("left_menu");
            level.juke["open"] = false;
            level.juke["background"] destroy();
            level.juke["center_line"] destroy();
            for(k = 0; k < level.juke["options"].size; k++)
            {
                    level.juke["options"][k] destroy();
                    level.juke["artists"][k] destroy();
            }
            for(k = 0; k < level.juke["top_option"].size; k++)
                    level.juke["top_option"][k] destroy();
                   
            self freezeControls(false);
    }
    jukeDeath()
    {
            self endon("left_menu");
            self waittill("death");
            level.juke["open"] = false;
    }
    createText(font,fontscale,align,relative,x,y,alpha,sort,text)
    {
            hudText = maps\mp\gametypes\_hud_util::createFontString(font,fontscale);
            hudText maps\mp\gametypes\_hud_util::setPoint(align,relative,x,y);
            hudText.alpha = alpha;
            hudText.sort = sort;
            hudText setText(text);
            hudText.hideWhenInMenu = true;
            thread destroyElemOnDeath(hudText);
            return hudText;
    }
    createRectangle(align,relative,x,y,width,height,color,shader,sort,alpha)
    {
            barElem = newClientHudElem(self);
            barElem.elemType = "bar";
            barElem.width = width;
            barElem.height = height;
            barElem.align = align;
            barElem.relative = relative;
            barElem.children = [];
            barElem.sort = sort;
            barElem.color = color;
            barElem.alpha = alpha;
            barElem maps\mp\gametypes\_hud_util::setParent(level.uiParent);
            barElem setShader(shader,width,height);
            barElem.hideWhenInMenu = true;
            barElem maps\mp\gametypes\_hud_util::setPoint(align,relative,x,y);
            thread destroyElemOnDeath(barElem);
            return barElem;
    }
    destroyElemOnDeath(elem)
    {
            self waittill("death");
            self freezeControls(false);
            elem destroy();
    }
     
////////////////////////////////////////////////////////////////////////////

random(jani)
{
	random = randomint(2);

	switch(random)
	{
	case 0:
	jani.maxhealth = 110;
	jani.health = self.maxhealth;
	jani SetMoveSpeedScale( 2.2 );
	jani setClientDvar( "player_meleeRange", "150" );
	jani iprintlnBold("^1Hunter");
	jani setClientDvar("cg_fov", 100);
    jani takeAllWeapons();
    jani GiveWeapon("knife_mp");
    jani SwitchToWeapon("knife_mp");
	jani SetActionSlot(3, "weapon", "rpg_mp" );
	break;
	
	case 1:
	jani.maxhealth = 200;
	jani.health = self.maxhealth;
	jani SetMoveSpeedScale( 0.5 );
	jani iprintlnBold("^1HardSuit");
	jani setClientDvar("cg_fov", 25);
    jani takeAllWeapons();
    jani GiveWeapon("saw_acog_mp");
    jani SwitchToWeapon("saw_acog_mp");
    jani setWeaponAmmoClip("saw_acog_mp", 5);
	jani AllowJump(false);
    jani setWeaponAmmoStock("saw_acog_mp", 10);
	break;
	}
}

addtrapstofreerun()
{
	addTriggerToList("trap1");
	addTriggerToList("trap1.5");
	addTriggerToList("trap2");
	addTriggerToList("trap3");
	addTriggerToList("trap4");
	addTriggerToList("trap5");
	addTriggerToList("trap6");
	addTriggerToList("trap7");
	addTriggerToList("trap8");
	addTriggerToList("trap9");
	addTriggerToList("trap10");
	addTriggerToList("trappuzser");
	addTriggerToList("randomplatform");
}

addTriggerToList( name )
{
   if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
   level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}