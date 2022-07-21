main()
{
 maps\mp\_load::main();
 
 
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
 
 //addTriggerToList("trap_1_trig");
 //addTriggerToList("trap_2_trig");
 //addTriggerToList("trap_3_trig");
 //addTriggerToList("trap_4_trig");
 //addTriggerToList("trap5_trig");
 //addTriggerToList("trap6_trig");
 //addTriggerToList("trap7_trig");
 //addTriggerToList("trap8_trig");

 endmap = getEnt("endmap_trig","targetname");
 endmap delete();

 trig = spawn("trigger_radius",(-1411,-4048,380),0,200,300);
 trig.targetname = "endmap_trig";
 trig.radius = 200;
 
 level.BounceWalls = false;
 
// code by Phelix ------------------------------------------------
 level.deagle_trig = getEnt("deagleroom_ent", "targetname");
 level.knife_trig = getEnt("kniferoom_ent", "targetname");
 level.snip_trig = getEnt("sniproom_ent", "targetname");
 
 level.triggerlist = [];
 
 level.triggerlist[level.triggerlist.size] = level.deagle_trig;
 level.triggerlist[level.triggerlist.size] = level.knife_trig;
 level.triggerlist[level.triggerlist.size] = level.snip_trig;
 
 level.inEndRoom = false;
 
//----------------------------------------------------------------


thread way_connect();

 //thread messages();
 //thread music();
 thread secret();
 thread secret_tele();
 thread secret_tele2();
 thread secret_fail1();
 thread secret_fail2();
 thread secret_fail3();
 thread secret_fail4();
 thread secret_fail5();
 thread secret_fail6();
 thread start_door();
 thread trap1();
 thread trap2();
 thread trap3();
 thread trap4();
 thread trap5();
 thread trap6_1();
 thread trap6_2();
 thread trap7_1();
 thread trap7_2();
 thread trap8();
//thread acti_tp_1();
 //thread acti_tp_2();
 //thread acti_tp_3();
 //thread acti_tp_4();
 //thread acti_tp_5();
 //thread acti_tp_6();
 //thread acti_tp_7();
 //thread acti_tp_8();
 //thread acti_mover();
 //thread acti_mover2();
 thread bounce_j_1();
 thread bounce_a_1();
 thread bounce_mid();
 //thread endroom_bounce();
//thread endroom_knife();
//thread endroom_snip();
}

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

way_connect()
{
    wait 0.05;
    
    level.spawn["allies"] = getEntArray("mp_jumper_spawn", "classname");
if (!level.spawn["allies"].size)
	level.spawn["allies"] = getEntArray("mp_dm_spawn", "classname");
	
    sr\api\_speedrun::createNormalWays("Normal Way;");
    sr\api\_speedrun::createSecretWays("Secret Way;");
    
    for(;;) 
    {
        level waittill( "connected", player );

    }
}

bounce_mid(){
	trig = getEnt("bounce_middle","targetname");
	trig SetHintString("^1Take Sniper");
	
	while(1){
		trig waittill("trigger",p);
		
		if(!level.BounceWalls){
			bouncewalls = getentarray("bounce_walls","targetname");
			for(i=0;i<bouncewalls.size;i++){
				bouncewalls[i] movez(-512,2,1,1);
			}
			level.BounceWalls = true;
		}
		
		
		p giveweapon("remington700_mp");
		p givemaxammo("remington700_mp");
		p switchtoweapon("remington700_mp");
		wait 1;
		
		
	}
}

bounce_a_1(){
	trig_a = getentarray("bounce_a_1","targetname");
	ori_a = getEnt("bounce_acti_or","targetname");
	
	while(1){
		for(i=0;i<trig_a.size;i++){
			trig_a[i] waittill("trigger",player);
			player SetOrigin(ori_a.origin);
			player SetPlayerAngles(ori_a.angles);
		}		
		
		
	}	
}



bounce_j_1(){
	trig_b = getentarray("bounce_j_1","targetname");
	ori_b = getEnt("bounce_jumper_or","targetname");
	
	while(1){
		for(i=0;i<trig_b.size;i++){
			trig_b[i] waittill("trigger",player);
			player SetOrigin(ori_b.origin);
			player SetPlayerAngles(ori_b.angles);			
		}
		
	}	
}





//code by Phelix -----------------------------------------------------------------------------------------------------------------
endroom_template(trigger, jumper_origin, acti_origin, weapon, weapon2, weapon_room, song_name)
{
    trigger = getEnt(trigger, "targetname");
	trigger SetHintString("^1Press F for "+weapon_room);
    jumper = getEnt(jumper_origin, "targetname");
    acti = getEnt(acti_origin, "targetname");
 
    while(1)
    {
        trigger waittill("trigger", player);
 
        if(level.inEndRoom)
            return;
       
        if (!isDefined(trigger))
            return;
		
		if(level.BounceWalls){
			bouncewalls = getentarray("bounce_walls","targetname");
			for(i=0;i<bouncewalls.size;i++){
				bouncewalls[i] movez(512,2,1,1);
			}
			level.BounceWalls = false;
		}
 
        level.inEndRoom = true;
 
        player setPlayerAngles(jumper.angles);
        player setOrigin(jumper.origin);
        player TakeAllWeapons();
        player giveWeapon(weapon);
		if(isDefined(weapon2)){
			player giveWeapon(weapon2);
			player giveMaxAmmo(weapon2);
		}
        player giveMaxAmmo(weapon);        
        player switchToWeapon(weapon);
		player.health = 100;
 
        level.activ setPlayerAngles(acti.angles);
        level.activ setOrigin(acti.origin);
        level.activ TakeAllWeapons();
        level.activ giveWeapon(weapon);
		if(isDefined(weapon2)){
			level.activ giveWeapon(weapon2);
			level.activ giveMaxAmmo(weapon2);
		}
        
        level.activ giveMaxAmmo(weapon);        
        level.activ switchToWeapon(weapon);
		level.activ.health = 100;
 
        ambientstop();
        ambientplay(song_name);
		
		if(song_name == "songjump"){
			iPrintLn("^6Now Playing: ^5Harry Potter and the Chamber of Bangers ^1 - Mashd N Kutcher Mashup");
		}
		
		if(song_name == "songsnip"){
			iPrintLn("^6Now Playing: ^5Harry Potter - Expecto Patronum ^1 - Goblins From Mars Trap Remix");
		}
		
		if(song_name == "songknife"){
			iPrintLn("^6Now Playing: ^5Hedwig's Theme ^1 - The Future's Trap Remix");
		}
 
        iPrintlnBold( " ^7" + player.name + " Entered" + " ^1" + weapon_room + " ^7room." );
        wait 0.05;
        player freezecontrols(true);
        level.activ freezecontrols(true);
        wait 1;
        player iPrintlnBold("^13");
        level.activ iPrintlnBold("^13");
        wait 1;
        player iPrintlnBold("^12");
        level.activ iPrintlnBold("^12");
        wait 1;
        player iPrintlnBold("^11");
        level.activ iPrintlnBold("^11");
        wait 1;
        player iPrintlnBold("^1FIGHT^7!");
        level.activ iPrintlnBold("^1FIGHT^7!");
        player freezecontrols(false);
        level.activ freezecontrols(false);
 
        while(isAlive(player) && isDefined(player)){
            wait 0.1;
		}
		
		level.inEndRoom = false;
    }
}

endroom_bounce()
{
    endroom_template("bounceroom_ent", "bounce_jumper_or", "bounce_acti_or", "knife_mp", undefined, "Bounce", "songjump");
}
 
endroom_knife()
{
    endroom_template("kniferoom_ent", "knife_jumper_or", "knife_acti_or", "knife_mp", undefined, "Knife", "songknife");
}
 
endroom_snip()
{
    endroom_template("sniproom_ent", "snip_jumper_or", "snip_acti_or", "remington700_mp", "m40a3_mp", "Sniper", "songsnip");
}

//-----------------------------------------------------------------------------------------------------------------------------------

start_door(){
	start_door = getEnt("start_door","targetname");
	
	wait 0;
	
	start_door movez(320,4);
	//iprintlnBold("^1 Start door opened!");
	wait 4;
	
}

secret_fail1(){
	secret_tp_1 = getEnt("secret_f_1","targetname");
	ori_tp_1 = getEnt("secret_fo_1","targetname");
	
	while(1){
		secret_tp_1 waittill("trigger",player);
		player SetOrigin(ori_tp_1.origin);
        player SetPlayerAngles(ori_tp_1.angles);
	}
}

secret_fail2(){
	secret_tp_2 = getEnt("secret_f_2","targetname");
	ori_tp_2 = getEnt("secret_fo_2","targetname");
	
	while(1){
		secret_tp_2 waittill("trigger",player);
		player SetOrigin(ori_tp_2.origin);
        player SetPlayerAngles(ori_tp_2.angles);
	}
}

secret_fail3(){
	secret_tp_3 = getEnt("secret_f_3","targetname");
	ori_tp_3 = getEnt("secret_fo_3","targetname");
	
	while(1){
		secret_tp_3 waittill("trigger",player);
		player SetOrigin(ori_tp_3.origin);
        player SetPlayerAngles(ori_tp_3.angles);
	}
}

secret_fail4(){
	secret_tp_4 = getEnt("secret_f_4","targetname");
	ori_tp_4 = getEnt("secret_fo_4","targetname");
	
	while(1){
		secret_tp_4 waittill("trigger",player);
		player SetOrigin(ori_tp_4.origin);
        player SetPlayerAngles(ori_tp_4.angles);
	}
}

secret_fail5(){
	secret_tp_5 = getEnt("secret_f_5","targetname");
	ori_tp_5 = getEnt("secret_fo_5","targetname");
	
	while(1){
		secret_tp_5 waittill("trigger",player);
		player SetOrigin(ori_tp_5.origin);
        player SetPlayerAngles(ori_tp_5.angles);
	}
}

secret_fail6(){
	secret_tp_6 = getEnt("secret_f_6","targetname");
	ori_tp_6 = getEnt("secret_fo_6","targetname");
	
	while(1){
		secret_tp_6 waittill("trigger",player);
		player SetOrigin(ori_tp_6.origin);
        player SetPlayerAngles(ori_tp_6.angles);
	}
}
acti_tp_1(){
	acti_tp_1 = getEnt("acti_tp_1","targetname");
	ori_tp_1 = getEnt("acti_tpo_1","targetname");
	
	while(1){
		acti_tp_1 waittill("trigger",player);
		player SetOrigin(ori_tp_1.origin);
        player SetPlayerAngles(ori_tp_1.angles);
		player.health = 100;
	}

}

acti_tp_2(){
	acti_tp_2 = getEnt("acti_tp_2","targetname");
	ori_tp_2 = getEnt("acti_tpo_2","targetname");
	
	while(1){
		acti_tp_2 waittill("trigger",player);
		player SetOrigin(ori_tp_2.origin);
        player SetPlayerAngles(ori_tp_2.angles);
		player.health = 100;		
	}

}

acti_tp_3(){
	acti_tp_3 = getEnt("acti_tp_3","targetname");
	ori_tp_3 = getEnt("acti_tpo_3","targetname");
	
	while(1){
		acti_tp_3 waittill("trigger",player);
		player SetOrigin(ori_tp_3.origin);
        player SetPlayerAngles(ori_tp_3.angles);
		player.health = 100;
	}

}

acti_tp_4(){
	acti_tp_4 = getEnt("acti_tp_4","targetname");
	ori_tp_4 = getEnt("acti_tpo_4","targetname");
	
	while(1){
		acti_tp_4 waittill("trigger",player);
		player SetOrigin(ori_tp_4.origin);
        player SetPlayerAngles(ori_tp_4.angles);
		player.health = 100;
	}
}

acti_tp_5(){
	acti_tp_5 = getEnt("acti_tp_5","targetname");
	ori_tp_5 = getEnt("acti_tpo_5","targetname");
	
	while(1){
		acti_tp_5 waittill("trigger",player);
		player SetOrigin(ori_tp_5.origin);
		player SetPlayerAngles(ori_tp_5.angles);
		player.health = 100;
	}
}

acti_tp_6(){
	acti_tp_6 = getEnt("acti_tp_6","targetname");
	ori_tp_6 = getEnt("acti_tpo_6","targetname");
	
	while(1){
		acti_tp_6 waittill("trigger",player);
		player SetOrigin(ori_tp_6.origin);
		player SetPlayerAngles(ori_tp_6.angles);
		player.health = 100;
	}
}

acti_tp_7(){
	acti_tp_7 = getEnt("acti_tp_7","targetname");
	ori_tp_7 = getEnt("acti_tpo_7","targetname");
	
	while(1){
		acti_tp_7 waittill("trigger",player);
		player SetOrigin(ori_tp_7.origin);
		player SetPlayerAngles(ori_tp_7.angles);
		player.health = 100;
	}	
}

acti_tp_8(){
	acti_tp_8 = getEnt("acti_tp_8","targetname");
	ori_tp_8 = getEnt("acti_tpo_8","targetname");
	
	while(1){
		acti_tp_8 waittill("trigger",player);
		player SetOrigin(ori_tp_8.origin);
		player SetPlayerAngles(ori_tp_8.angles);
		player.health = 100;
	}	
}

acti_mover(){
	acti_mover = getEnt("acti_mover","targetname");
	acti_mover_trig = getEnt("acti_mover_trig","targetname");
	
	acti_mover_trig waittill("trigger",player);
	acti_mover_trig delete();
	
	while(1){
		acti_mover movex(-1088,3,2,1);
		wait 3;
		acti_mover movex(1088,3,2,1);
		wait 3;
	}
	
}

acti_mover2(){
	acti_mover2 = getEnt("acti_mover2","targetname");
	acti_mover2_trig = getEnt("acti_mover2_trig","targetname");
	
	acti_mover2_trig waittill("trigger",player);
	acti_mover2_trig delete();
	
	while(1){
		acti_mover2 movex(700,7,4,3);
		wait 7;
		acti_mover2 movex(-700,7,4,3);
		wait 7;
	}
}

trap1(){

	trap1_trig = getEnt("trap_1_trig","targetname");
	trap1_trig SetHintString("^2 Activate Trap 1");
	trap1_trig waittill("trigger",player);
	
}

trap2(){

	trap2_trig = getEnt("trap_2_trig","targetname");
	trap2_trig SetHintString("^2 Activate Trap 2");
	trap2_trig waittill("trigger",player);

}

trap3(){
	trap3_trig = getEnt("trap_3_trig","targetname");
	trap3_trig SetHintString("^2 Activate Trap 3");
	trap3_trig waittill("trigger",player);

}

trap4(){
	trap4_trig = getEnt("trap_4_trig","targetname");
	trap4_trig SetHintString("^2 Activate Trap 4");
	trap4_trig waittill("trigger",player);
	
}

trap5(){
	trap5_trig = getEnt("trap5_trig","targetname");
	trap5_trig SetHintString("^2 Activate Trap 5");
	trap5_trig waittill("trigger",player);
	
}

trap6_1(){
	
}

trap6_2(){
	trap6_trig = getEnt("trap6_trig","targetname");
	trap6_trig SetHintString("^2 Activate Trap 6");
	trap6_trig waittill("trigger",player);
	
}

trap7_1(){

}

trap7_2(){
	trap7_trig = getEnt("trap7_trig","targetname");
	trap7_trig SetHintString("^2 Activate Trap 7");
	trap7_trig waittill("trigger",player);
	
}

trap8(){
	trap8_trig = getEnt("trap8_trig","targetname");
	trap8_trig SetHintString("^2 Activate Trap 8");
	trap8_trig waittill("trigger",player);
	
}

secret_tele2(){
	trig = getEnt("secret_end","targetname");
	ori = getEnt("secret_start","targetname");
	
	while(1){
		trig waittill ("trigger",player);
player thread sr\api\_speedrun::finishWay("secret_0");
      }
}


secret_tele()
{
	pic3 = getEnt("picture3", "targetname");
	end = getEnt("secret_fo_1", "targetname");
	while(1)
    	{
        pic3 waittill ("trigger", player);          
		player SetOrigin(end.origin);
        player SetPlayerAngles( end.angles );
        player sr\api\_speedrun::changeWay("secret_0"); //Speedrun Copy Paste
	}
}

secret()
{
	
	secret = getEnt("secret", "targetname");

	secret delete();
}
messages()
{
	wait 7;
	iprintlnBold("^1Welcome to ^2Hogwarts!");	
}

music()
{
	wait 5;	
	iPrintLn("^1Map Created by: ^3Gabb");
	wait 2;
	iPrintLn("^1Thanks to Phelix and the FNRP forum community for the help");
	wait 2;
	possibility = randomIntRange(0,7);
	
	if(possibility == 0)
	{
		iPrintLn("^6Now Playing: ^5The Arrival of Baby Harry");
		ambientPlay("song1");
	}
	
	if(possibility == 1)	
	{
		iPrintLn("^6Now Playing: ^5Buckbeak's Flight");
		ambientPlay("song2");
	}
	
	if(possibility == 2)	
	{
		iPrintLn("^6Now Playing: ^5Fireworks");
		ambientPlay("song3");
	}
	
	if(possibility == 3)		
	{
		iPrintLn("^6Now Playing: ^5Hedwig's Theme");
		ambientPlay("song4");
	}
	
	if(possibility == 4)	
	{
		iPrintLn("^6Now Playing: ^5Longbottom's Flight");
		ambientPlay("song5");	
	}
	
	if(possibility == 5)	
	{
		iPrintLn("^6Now Playing: ^5Opening");
		ambientPlay("song6");
	}
	
	if(possibility == 6)	
	{
		iPrintLn("^6Now Playing: ^5The Story Continues");
		ambientPlay("song7");			
	}
	
}
