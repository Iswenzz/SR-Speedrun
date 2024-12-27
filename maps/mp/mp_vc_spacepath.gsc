main()
{
    addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
    addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");
	addTriggerToList("trig_trap8");
    addTriggerToList("trig_trap9");

	maps\mp\_load::main();
	
	//level._frezze = loadfx( "custome/frezze" );
	//level._effect["sparks"] = loadfx( "custome/sparks" );
	
	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","1800");
	setDvar("bg_falldamagemaxheight", 99999 );
	setDvar("bg_falldamageminheight", 99998 );

    thread sr\api\_speedrun::createNormalWays("Normal Way;");
	thread sr\api\_speedrun::createSecretWays("Secret Way;");
	thread sr\api\_map::createSpawn((2980, 10, 220), 360);
	
    thread sr_sec_enter();
	//thread credit();
	thread start_door();
	thread slipper();
	thread trap1();
	//thread trap2();
	//thread trap3();
	//thread trap4();
	//thread trap5();
	//thread trap6();
	//thread trap7();
	//thread trap8();
	//thread afterroundstart();
    //thread trap9();
	thread finish_door();
	thread tptp();
	//thread sniperroom();
	//thread kniferoom();
	//thread jumproom();
	//thread secretbutto();
	//thread setup();
    thread loadtrigger_fix();
    thread secrettpexit();
	//thread skoljka();
	//thread snipjump();
	
}

addTriggerToList( name )
{
  if( !isDefined( level.trapTriggers ) )
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}	

sr_sec_enter()
{
	trig = spawn("trigger_radius",(2980.2, 153.718, 160.125), 0, 60, 100);
	trig.radius = 60;
	ori = getEnt("secrettp_start","targetname");

	thread sr\api\_map::createTriggerFx(trig, "yellow");

	for(;;)
	{
		trig waittill("trigger",player);

		player thread sr\api\_speedrun::changeWay("secret_0"); 

		player SetOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		player thread sr_tp_safe(ori);
	}
}
sr_tp_safe(ori)
{   
	self endon("death");
	self endon("disconnect");
	
	self FreezeControls(1);
	wait 0.05;
	self FreezeControls(0);
}
credit()
{
wait(10);
thread drawInformation( 800, 0.8, 1, "^1SpacePath" );
wait(6);
thread drawInformation( 800, 0.8, 1, "^3By:Xplosive" );
wait(6);
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

afterroundstart()
{
    level waittill("round_started");
	PlayFX(level._effect["sparks"],(5064, -2472, 952));
    players = getentarray("player","classname");
    for(i=0;i<=players.size;i++)
    {
        //players[i].triggeredtrap = false;
		//players[i].insec = false;
    }
}

start_door()
{
trigger = getent("start","targetname");
object1 = getent("start_door1","targetname");
object2 = getent("start_door2","targetname");

object1 delete();
object2 delete();

}

slipper()
{
object1 = getent("movingslipper","targetname");

object1 moveX(700, 0.1);

}

trap1()
{
trigger = getent("trig_trap1","targetname");
object = getent("trap1_2","targetname");

object moveY(320, 0.1);
wait 0.1;
object rotateRoll(90,0.1);

}

trap2()
{
trigger = getent("trig_trap2","targetname");
object1 = getent("trap2","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object1 notsolid();
object1 hide();
wait(1);
}
}

trap3()
{
trigger = getent("trig_trap3","targetname");
object1 = getent("trap3","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object1 moveZ(-176, 0.5);
wait(5);
object1 moveZ(176, 0.5);
wait(1);
}
}

trap4()
{
trigger = getent("trig_trap4","targetname");
object1 = getent("trap4_1","targetname");
object2 = getent("trap4_2","targetname");
object3 = getent("trap4_3","targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object1 rotateYaw(360, 1);
object2 rotateYaw(360, 1);
object3 rotateYaw(360, 1);
wait(3);
object1 rotateYaw(-360, 1);
object2 rotateYaw(-360, 1);
object3 rotateYaw(-360, 1);
wait(3);
}
}

trap5()
{
trigger = getent("trig_trap5","targetname");
object1 = getent("trap5","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object1 notsolid();
object1 hide();
wait(2);
object1 solid();
object1 show();
wait(2);
}
}

trap6()
{
trigger = getent("trig_trap6","targetname");
object1 = getent("trap6","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
object1 notsolid();
wait(2);
}
}

trap7()
{
trigger = getent("trig_trap7","targetname");
object1 = getent("trap7","targetname");
trigger waittill ("trigger" , player );
trigger delete();
while(1)
{
object1 rotateRoll(360, 1);
wait(2.5);
object1 rotateRoll(-360, 1);
wait(2.5);
}
}

trap8()
{
trigger1 = getent("trig_trap8","targetname");
trigger2 = getent("trap8","targetname");
trigger1 waittill ("trigger" , player );
trigger1 delete();
trigger2 thread deleteaftertime();
fxorg = spawn("script_model",trigger2.origin);
fxorg setmodel("tag_origin");
fxorg.angles[1] = 180;
wait .1;
PlayFXOnTag ( level._frezze, fxorg, "tag_origin" );
fxorg thread deleteaftertime();
while (isDefined(trigger2))
{
trigger2 waittill("trigger" , player);
player thread freezebitch();
}
}

freezebitch()
{
self freezecontrols(true);
wait(5);
self freezecontrols(false);
}


trap9()
{
    trig = getent("trig_trap9","targetname");
    trig waittill("trigger",player);
    trig delete();
	thread bounce();
}
 
bounce()
{
    hurttrig = getent("trap9","targetname");
	hurttrig thread deleteaftertime();
	while(isDefined(hurttrig))
	{
	hurttrig waittill("trigger",player);
    if(player.triggeredtrap == false)
    {
        player.triggeredtrap = true;
        for(i=0;i<10;i++)
        {
            player.health += 100;
            player finishPlayerDamage(player, player, 100, 0, "MOD_FALLING", "shock_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
        }
		wait(1);
		player iprintlnbold("^2OOps! ^7You broke your neck!");
    }
}
}
deleteaftertime()
{
    wait(5);
	self delete();
}	

finish_door()
{
trigger = getent("finishdoor","targetname");
object1 = getent("finish_door1","targetname");
object2 = getent("finish_door2","targetname");

object1 delete();
object2 delete();

}

tptp()
{       
 	entTransporter = getentarray( "enter", "targetname" );
	if(isdefined(entTransporter))
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter();
}
 
transporter()
{
	for(;;)
	{
		self waittill( "trigger", player );
		entTarget = getEnt( self.target, "targetname" );
		player SetOrigin(entTarget.origin);
		player SetPlayerAngles(entTarget.angles);
		player FreezeControls(1);
		wait 0.1;
		player FreezeControls(0);
	}
}

sniperroom()
{
    level.sniper_trig = getEnt( "snipe", "targetname");
    jump = getEnt( "jumper_sniper", "targetname" );
    acti = getEnt( "acti_sniper", "targetname" );
   
    while(1)
    {
        level.sniper_trig waittill( "trigger", player );
        if( !isDefined( level.sniper_trig ) )
            return; //ne

   

        if(level.firstenter==true) //ne
        {
        level.knifeobj delete();
        level.bounceobj delete();
        level.knife_trig delete();
        level.jump_trig delete();
        level.firstenter=false;
        }
       
        player freezeControls(true);
        level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "remington700_mp" );
        player setWeaponAmmoClip("remington700_mp", 50 );
        player setWeaponAmmoStock( "remington700_mp", 50 );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "remington700_mp" );
        level.activ setWeaponAmmoClip("remington700_mp", 50 );
        level.activ setWeaponAmmoStock( "remington700_mp", 50 ); 
        player thread roomanauncer("Sniper Room");   // tu nutra sam deni ime rooma
        wait 6.9; //ne
        player switchToWeapon( "remington700_mp" );
        level.activ SwitchToWeapon( "remington700_mp" );
        player freezeControls(false);
        level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

kniferoom()
{
    level.knife_trig = getEnt( "knife", "targetname");
    jump = getEnt( "jumper_knife", "targetname" );
    acti = getEnt( "acti_knife", "targetname" );
   
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return; //ne


        if(level.firstenter==true) //ne
        {
        level.sniperobj delete();
        level.bounceobj delete();
        level.sniper_trig delete();
        level.jump_trig delete();
        level.firstenter=false;
        }
       
        player freezeControls(true);
        level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );
        player setWeaponAmmoClip("deserteagle_mp", 0 );
        player setWeaponAmmoStock( "deserteagle_mp", 0 );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" );
        level.activ setWeaponAmmoClip("deserteagle_mp", 0);
        level.activ setWeaponAmmoStock( "deserteagle_mp", 0 ); 
        player thread roomanauncer("Knife Room");   // tu nutra sam deni ime rooma
        wait 6.9; //ne
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
        player freezeControls(false);
        level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

jumproom()
{
    level.jump_trig = getEnt( "jump", "targetname");
    jump = getEnt( "jumper_jump", "targetname" );
    acti = getEnt( "acti_jump", "targetname" );
   
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return; //ne

      
        
        if(level.firstenter==true) //ne
        {
        level.sniperobj delete();
        level.knifeobj delete();
        level.sniper_trig delete();
        level.knife_trig delete();
        level.firstenter=false;
        }
       
        player freezeControls(true);
        level.activ freezeControls(true);
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "deserteagle_mp" );
        player setWeaponAmmoClip("deserteagle_mp", 0 );
        player setWeaponAmmoStock( "deserteagle_mp", 0 );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "deserteagle_mp" );
        level.activ setWeaponAmmoClip("deserteagle_mp", 0);
        level.activ setWeaponAmmoStock( "deserteagle_mp", 0 ); 
        player thread roomanauncer("Jump Room");   // tu nutra sam deni ime rooma
        wait 6.9; //ne
        player switchToWeapon( "deserteagle_mp" );
        level.activ SwitchToWeapon( "deserteagle_mp" );
        player freezeControls(false);
        level.activ freezeControls(false);
        while( isAlive( player ) && isDefined( player ) )
        wait 0.1;
    }
}

roomanauncer(room)
{
    r = randomfloatrange(0.0,1.0);
    g = randomfloatrange(0.0,1.0);
    b = randomfloatrange(0.0,1.0);
 
    roomanauncer = NewHudElem();
    roomanauncer.alignX = "center";
    roomanauncer.alignY = "middle";
    roomanauncer.horzalign = "center";
    roomanauncer.vertalign = "middle";
    roomanauncer.alpha = 1;
    roomanauncer.x = 0;
    roomanauncer.y = -200;
    roomanauncer.font = "default";
    roomanauncer.fontscale = 2.5;
    roomanauncer.glowalpha = 1;
    roomanauncer.glowcolor = (r,g,b);
    roomanauncer settext(room);
    roomanauncer SetPulseFX( 40, 6800, 200 );
 
    roomanauncernames = NewHudElem();
    roomanauncernames.alignX = "center";
    roomanauncernames.alignY = "middle";
    roomanauncernames.horzalign = "center";
    roomanauncernames.vertalign = "middle";
    roomanauncernames.alpha = 1;
    roomanauncernames.x = 0;
    roomanauncernames.y = -150;
    roomanauncernames.font = "default";
    roomanauncernames.fontscale = 1.8;
    roomanauncernames.glowalpha = 1;
    roomanauncernames.glowcolor = (r,g,b);
    roomanauncernames settext(self.name);
    roomanauncernames SetPulseFX( 40, 1800, 200 ); 
    wait 2;
    roomanauncernames settext("^1VS");
    roomanauncernames SetPulseFX( 40, 1800, 200 );
    wait 2;
    roomanauncernames settext(level.activ.name);
    roomanauncernames SetPulseFX( 40, 2800, 200 );
    wait 3;
    roomanauncernames destroy();
    roomanauncer destroy();
 
}

secretbutto()
{
trigger = getent("butto","targetname");
object1 = getent("buttotrig","targetname");
trigger waittill ("trigger" , player );
trigger delete();
{
player finishPlayerDamage(player, player, 90, 0, "MOD_FALLING", "shock_mp", player.origin, AnglesToForward((-90,0,0)), "none", 0);
object1 hide();
object1 notsolid();
thread secrettp();
}
}
 
secrettp() // teleport za uci u secret
{
    trig = getent("secretstart_trig","targetname");
    spot = getent("secrettp_start","targetname");
    for(;;)
    {
        trig waittill("trigger",player);
		player iprintlnbold("^1What do you do with the button that must never be pressed");
		wait(1);
		player.health=100;
		player iprintlnbold("^1You press it ofcourse");
		wait(0.1);
        player setorigin(spot.origin);
        player setplayerangles(spot.angles);
        player.sc = 0;
		player.insec = true;
		player thread alive();
    }
}
 
alive()
{
while(isdefined(self) && isalive(self) && self.sessionstat == "playing" && self.insec == true)
{wait 1;}
self.sc = 0;
}
 
secrettpexit() //teleport za izaci
{
    trig = getent("secretend_trig","targetname");
    spot = getent("secrettp_end","targetname");

    for(;;)
    {
    trig waittill("trigger",player);

    player thread sr\api\_speedrun::finishWay("secret_0");
    }
}
 
setup(num)
{
    for(i=1;i<=4;i++)
    {
        //thread loadtrigger(i);
        //thread savetriggers(i);
    }
}
 
savetriggers(num)
{
    savetrig = getent("savetrig_"+num,"targetname");
    for(;;)
    {
        savetrig waittill("trigger",player);
        if(player.sc != num)
        {
            player.sc++;
            //player iprintln(">> Position: "+player.sc+" Saved");
        }
        else{}
    }
}
 
loadtrigger_fix()
{
    trig = getent("loadtrigger","targetname");
    for(;;)
    {
    trig waittill("trigger",player);
    
    player Suicide();
       
    }
}

skoljka()
{
object1 = getent("logowc","targetname");
while(1)
{
object1 rotateYaw(360, 3);
wait(3);
}
}

snipjump()
{
trigger = getent("givesnip","targetname");
while(1)
{
trigger waittill ("trigger" , player );
player TakeAllWeapons();
player GiveWeapon( "remington700_mp" );
player givemaxammo("remington700_mp");
player switchToWeapon( "remington700_mp" );
}
}