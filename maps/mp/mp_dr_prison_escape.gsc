////////////////////////////////////////////////////////////////////////////////////////////////////////////
//            _____                    _____                    _____                    _____            //
//           /\    \                  /\    \                  /\    \                  /\    \           //
//          /::\    \                /::\    \                /::\    \                /::\    \          //
//         /::::\    \              /::::\    \              /::::\    \              /::::\    \         //
//        /::::::\    \            /::::::\    \            /::::::\    \            /::::::\    \        //
//       /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \       //
//      /:::/  \:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/__\:::\    \      //
//     /:::/    \:::\    \      /::::\   \:::\    \      /::::\   \:::\    \      /::::\   \:::\    \     //
//    /:::/    / \:::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    //
//   /:::/    /   \:::\ ___\  /:::/\:::\   \:::\    \  /:::/\:::\   \:::\ ___\  /:::/\:::\   \:::\ ___\   //
//  /:::/____/  ___\:::|    |/:::/  \:::\   \:::\____\/:::/__\:::\   \:::|    |/:::/__\:::\   \:::|    |  //
//  \:::\    \ /\  /:::|____|\::/    \:::\  /:::/    /\:::\   \:::\  /:::|____|\:::\   \:::\  /:::|____|  //
//   \:::\    /::\ \::/    /  \/____/ \:::\/:::/    /  \:::\   \:::\/:::/    /  \:::\   \:::\/:::/    /   //
//    \:::\   \:::\ \/____/            \::::::/    /    \:::\   \::::::/    /    \:::\   \::::::/    /    //
//     \:::\   \:::\____\               \::::/    /      \:::\   \::::/    /      \:::\   \::::/    /     //
//      \:::\  /:::/    /               /:::/    /        \:::\  /:::/    /        \:::\  /:::/    /      //
//       \:::\/:::/    /               /:::/    /          \:::\/:::/    /          \:::\/:::/    /       //
//        \::::::/    /               /:::/    /            \::::::/    /            \::::::/    /        //
//         \::::/    /               /:::/    /              \::::/    /              \::::/    /         //
//          \::/____/                \::/    /                \::/____/                \::/____/          //
//                                    \/____/                                                             //
//                                                                                                        //
// Steam: Gabb(Korean girl picture) Bnet: Gabb#2215 or PM on FNRP-Forums.                                 //                                                                      //
////////////////////////////////////////////////////////////////////////////////////////////////////////////

main(){

	maps\mp\_load::main();	 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	precacheitem("rpg_mp");
	precacheItem("ak74u_mp");
	precacheitem("knife_mp");
	precacheItem("remington700_mp");
	precacheItem("m40a3_mp");
	precacheItem("winchester1200_mp");

	level.isFinished = false;
	level.inEndRoom = false;

	// addTriggerToList("trap1_trig");
	// addTriggerToList("trap2_trig");
	// addTriggerToList("trap3_trig");
	// addTriggerToList("trap4_trig");
	// addTriggerToList("trap6_trig");
	// addTriggerToList("trap7_trig");
	// addTriggerToList("trap8_trig");

	thread way_connect();
	thread begin();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();
	// thread trap5();
	// thread trap6();
	// thread trap7();
	// thread trap8();
	// thread acti_tp1();
	thread bounce_fail_jumper();
	// thread bounce_room_fail_j();
	// thread bounce_room_fail_a();
	thread secret_end();
	thread open_secret();
	// thread secret_tp();
	// thread endroom_snip();
	// thread endroom_rpg();
	// thread endroom_knife();
	// thread endroom_weapon();
	// thread endroom_bounce();
	// thread endroom_old();
	// thread bounce_sniper();
	// thread final_trigger();
	// thread contact();


}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    speedrun\_way_name::createWay("normal", "Normal Way", "1");
	speedrun\_way_name::createWay("secret", "Secret Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread speedrun\_way_name::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList(name){
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

//Timer by Lixfe/VC' Blade
secret_timer(time){   
	self endon("secret_done");
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    self.secretTimer=newclienthudelem(self);
    self.secretTimer.foreground = true;
    self.secretTimer.alignX = "center";
    self.secretTimer.alignY = "bottom";
    self.secretTimer.horzAlign = "center";
    self.secretTimer.vertAlign = "bottom";
    self.secretTimer.x = 0;
    self.secretTimer.y = -7;
    self.secretTimer.sort = 5;
    self.secretTimer.fontScale = 1.6;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = true;
       self.secretTimer.label = &"Time left in secret: &&1";
        

    self.secretTimer.glowColor=(0.25,0.87,0.82);   
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
}

open_secret(){
	so = getEnt("bounce_fail_jump_or","targetname");
	while(1){
		os = getEnt("open_secret","targetname");
		os setHintString("^2Secret!");
		os waittill("trigger",player);
		player setOrigin(so.origin);
		player setPlayerAngles(so.angles);
		player speedrun\_way_name::startSecret(); //Speedrun Copy Paste
	}
}

secret_end(){
	while(1){
		se = getEnt("secret_end","targetname");
		se setHintString("^1Finish Secret!");
		se waittill("trigger",player);
		set = getEnt("secret_end_tp","targetname");
		player thread braxi\_mod::endTimer();
	}
}

begin(){
	level waittill("round_started");
	// iPrintLnBold("^3Map made by: ^1Gabb");
	// iprintlnbold("^1I suggest not to use fullbright for the full experience!");
	// iprintlnbold("^1mp_dr_prison_escape v1.0");
	// thread music();
	// wait(5);

	doors = getEntArray("start_door","targetname");
	for(i = 0; i < doors.size; i++){
		doors[i] moveZ(512,1);	
	}
	// iPrintLnBold("^3Doors Opened! ^1RUN!");
	// wait(2);	
}

contact(){
	wait 20;
	while(1){
		iprintlnbold("^3Steam: ^1Gabb (Korean Girl Picture)");
		wait 2;
		iprintlnbold("^3BNet: ^1Gabb#2215");
		wait 2;
		iprintlnbold("Or send me a pm on ^1FNRP-Forums");
		wait 20;		
	}
}


music(){
	randomInt = randomIntRange(0,10);
	if(randomInt == 0){
		ambientPlay("gangsta");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^62Pac - Gangsta Party feat. Snoop Dogg");
			wait 25;
		}
	}

	if(randomInt == 1){
		ambientPlay("hailmary");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^62Pac - Hail Mary");
			wait 25;
		}
	}

	if(randomInt == 2){
		ambientPlay("64cruise");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Eazy-E - Boyz N' Tha Hood");
			wait 25;
		}
	}

	if(randomInt == 3){
		ambientPlay("california");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^62Pac - California Love feat. Dr.Dre");
			wait 25;
		}
	}

	if(randomInt == 4){
		ambientPlay("gthang");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Dr.Dre - Nuthin' but a G Thang feat. Snoop Dogg");
			wait 25;
		}
	}

	if(randomInt == 5){
		ambientPlay("hypnotize");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6The Notorious B.I.G. - Hypnotize");
			wait 25;
		}
	}

	if(randomInt == 6){
		ambientPlay("nwa");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6N.W.A. - Fuk da Police");
			wait 25;
		}
	}

	if(randomInt == 7){
		ambientPlay("realgs");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Eazy-E - Real Muthafuckin G's");
			wait 25;
		}
	}

	if(randomInt == 8){
		ambientPlay("stilldre");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Dr.Dre - Still D.R.E. feat. Snoop Dogg");
			wait 25;
		}
	}

	if(randomInt == 9){
		ambientPlay("hood");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6DMX - Where the hood at?");
			wait 25;
		}
	}
}

trap1(){
	trap1_trig = getEnt("trap1_trig","targetname");
	trap1_trig setHintString("^1Activate Trap 1");
	trap1_trig waittill("trigger",player);
	trap1_trig delete();

	randomInt = randomIntRange(0,2);
	if(randomInt == 0){
		trap1_1 = getEnt("trap1_1","targetname");
		trap1_1 delete();
	} else {
		trap1_2 = getEnt("trap1_2","targetname");
		trap1_2 delete();
	}
}

trap2(){
	trap2_trig = getEnt("trap2_trig","targetname");
	trap2_trig setHintString("^1Activate Trap 2");
	trap2_trig waittill("trigger",player);
	trap2_trig delete();

	trap2_1 = getEntArray("trap2_1","targetname");
	trap2_2 = getEntArray("trap2_2","targetname");
	

	while(1){
		for(i = 0; i < trap2_1.size; i++){
			trap2_1[i] rotateRoll(100,0.5);
			trap2_2[i] rotateRoll(-100,0.5);			
			wait 1;
			trap2_1[i] rotateRoll(-100,0.5);
			trap2_2[i] rotateRoll(100,0.5);			
			wait 1;
		}
	}
}

trap3(){
	trap3_trig = getEnt("trap3_trig","targetname");
	trap3_trig setHintString("^1Activate Trap 3");
	trap3_trig waittill("trigger",player);
	trap3_trig delete();

	trap3_1 = getEntArray("trap3_1","targetname");
	trap3_2 = getEntArray("trap3_2","targetname");

	trap3_1h = getEntArray("trap3_1h","targetname");
	trap3_2h = getEntArray("trap3_2h","targetname");

	for(i = 0; i < trap3_1.size; i++){
		trap3_1h[i] enableLinkTo();
		trap3_2h[i] enableLinkTo();
		trap3_1h[i] linkTo(trap3_1[i]);
		trap3_2h[i] linkTo(trap3_2[i]);
	}

	while(1){
		for(i = 0; i < trap3_1.size; i++){
			trap3_1[i] moveY(-720,1);
			trap3_2[i] moveY(720,1);
			wait 1.1;
			trap3_1[i] moveY(720,1);
			trap3_2[i] moveY(-720,1);
			wait 1.1;
		}
	}
}

trap4(){
	trap4_trig = getEnt("trap4_trig","targetname");
	trap4_trig setHintString("^1Activate Trap 4");
	trap4_trig waittill("trigger",player);
	trap4_trig delete();

	trap4_1 = getEnt("trap4_1","targetname");
	trap4_2 = getEnt("trap4_2","targetname");

	radius = 128;
	cx = -9344;
	cz = -3296;

	while(1){
		for(i = 0; i < 360; i+=5){
			x1 = cx + radius * (cos(i));
			z1 = cz + radius * (sin(i));
			x2 = cx + radius * (cos(i+180));
			z2 = cz + radius * (sin(i+180));
			
			trap4_1 moveto((x1,0,z1),0.1);
			trap4_2 moveto((x2,0,z2),0.1);
			
			
			wait 0.1;
		}
	}
}

trap5(){
	trap5_1 = getEntArray("trap5_1","targetname");
	trap5_2 = getEnt("trap5_2","targetname");

	trap5_2 moveZ(-172,1);
	wait 1;

	trap5_trig = getEnt("trap5_trig","targetname");
	trap5_trig setHintString("^1Activate Trap 5");
	trap5_trig waittill("trigger",player);
	trap5_trig delete();



	for(i = 0; i < trap5_1.size; i++){
		trap5_1[i] delete();
 	}

 	trap5_2 moveZ(172,1);
 	wait 1;
}

trap6(){
	trap6_trig = getEnt("trap6_trig","targetname");
	trap6_trig setHintString("^1Activate Trap 6");
	trap6_trig waittill("trigger",player);
	trap6_trig delete();

	randomInt = randomIntRange(0,2);
	if(randomInt == 0){
		trap6_1 = getEntArray("trap6_1","targetname");
		for(i = 0; i < trap6_1.size; i++){
			trap6_1[i] delete();
		}		
	} else {
		trap6_2 = getEntArray("trap6_2","targetname");
		for(i = 0; i < trap6_2.size; i++){
			trap6_2[i] delete();
		}	
	}	
}

trap7(){
	trap7_trig = getEnt("trap7_trig","targetname");
	trap7_trig setHintString("^1Activate Trap 7");
	trap7_trig waittill("trigger",player);
	trap7_trig delete();

	trap7_1 = getEnt("trap7_1","targetname");
	trap7_2 = getEnt("trap7_2","targetname");
	trap7_3 = getEnt("trap7_3","targetname");

	trap7_1 moveY(-316,1.5);
	trap7_2 moveY(316,1.5);
	trap7_3 moveY(-316,1.5);

	wait 1.5;

	while(1){
		trap7_1 moveY(632,3);
		trap7_2 moveY(-632,3);
		trap7_3 moveY(632,3);

		wait 3;

		trap7_1 moveY(-632,3);
		trap7_2 moveY(632,3);
		trap7_3 moveY(-632,3);

		wait 3;
	}
}

trap8(){
	trap8_trig = getEnt("trap8_trig","targetname");
	trap8_trig setHintString("^1Activate Trap 8");
	trap8_trig waittill("trigger",player);
	trap8_trig delete();

	randomInt = randomIntRange(0,2);

	if(randomInt == 0){
		trap8_1 = getEnt("trap8_1","targetname");
		trap8_1 delete();
	} else {
		trap8_2 = getEnt("trap8_2","targetname");
		trap8_2 delete();
	}

	randomInt = randomIntRange(0,2);

	if(randomInt == 0){
		trap8_3 = getEnt("trap8_3","targetname");
		trap8_3 delete();
	} else {
		trap8_4 = getEnt("trap8_4","targetname");
		trap8_4 delete();
	}
}

acti_tp1(){
	acti_tp1 = getEnt("acti_tp1","targetname");
	acti_tp1 setHintString("^1Teleport to next part");
	acti_tp1 waittill("trigger",player);
	acti_tp1 delete();

	acti_or1 = getEnt("acti_or1","targetname");
	player setOrigin(acti_or1.origin);
	player setPlayerAngles(acti_or1.angles);
}

bounce_fail_jumper(){
	trig = getEnt("bounce_fail_jump","targetname");
	tp = getEnt("bounce_fail_jump_or","targetname");
	while(1){
		trig waittill("trigger",player);		
		player setOrigin(tp.origin);
		player setPlayerAngles(tp.angles);
	}
}

bounce_room_fail_j(){
	while(1){
		brf = getEnt("bounce_room_fail","targetname");
		brf waittill("trigger",player);
		brj = getEnt("bounce_room_jumper","targetname");
		player setOrigin(brj.origin);
		player setPlayerAngles(brj.angles);
		wait 0.2;
	}
}

bounce_room_fail_a(){
	while(1){
		brf = getEnt("bounce_room_fail_2","targetname");
		brf waittill("trigger",player);
		brj = getEnt("bounce_room_acti","targetname");
		player setOrigin(brj.origin);
		player setPlayerAngles(brj.angles);
		wait 0.2;
	}
}
bounce_sniper(){
	while(1){
		bs = getEnt("bsniper","targetname");
		bs setHintString("^1Press Use for Sniper!");
		bs waittill("trigger",player);
		player giveWeapon("remington700_mp");
		player giveMaxAmmo("remington700_mp");
		player switchToWeapon("remington700_mp");	
		wait 0.2;
	}	
}

final_trigger(){
	ft = getEnt("final_trigger","targetname");
	ft waittill("trigger",player);
	
	afr = getEnt("acti_final_room","targetname");
	level.activ setOrigin(afr.origin);
	level.activ setPlayerAngles(afr.angles);
}

endroom_old(){
	ot = getEnt("old_trig","targetname");
	ot setHintString("^1Old Room");
	ot waittill("trigger",player);

	op = getEnt("old_platform","targetname");
	op delete();

	st = getEnt("snip_trig","targetname");
	st delete();
	rt = getEnt("rpg_trig","targetname");
	rt delete();
	wt = getEnt("weapon_trig","targetname");
	wt delete();
	kt = getEnt("knife_trig","targetname");
	kt delete();
	bt = getEnt("bounce_trig","targetname");
	bt delete();

}

endroom_snip(){
    endroom_template("snip_trig", "snip_jumper_start", "snip_acti_start", "remington700_mp", "m40a3_mp", "Sniper", "demboyz");
}

endroom_rpg(){
	endroom_template("rpg_trig", "rpg_jumper_start", "rpg_acti_start", "rpg_mp", "undefined", "RPG", "fire");
}

endroom_weapon(){
	endroom_template("weapon_trig", "knife_jumper_start", "knife_acti_start", "winchester1200_mp", "undefined", "Weapon", "panda");
}

endroom_knife(){
	endroom_template("knife_trig", "knife_acti_start", "knife_jumper_start", "knife_mp", "undefined", "Knife", "howwedo");
}

endroom_bounce(){
	endroom_template("bounce_trig", "bounce_room_jumper", "bounce_room_acti", "knife_mp", "undefined", "Bounce", "trapqueen");
}

endroom_template(trigger, jumper_origin, acti_origin, weapon, weapon2, weapon_room, song_name){
    trigger = getEnt(trigger, "targetname");
	trigger SetHintString("^1"+weapon_room);
    jumper = getEnt(jumper_origin, "targetname");
    acti = getEnt(acti_origin, "targetname");
	
	
	
 
    while(1){
        trigger waittill("trigger", player);
        level.isFinished = true;
		old_trig = getent("old_trig","targetname");
		if(isdefined(old_trig)){
			old_trig delete();
		}		
		
        if(level.inEndRoom)
            return;
       
        if (!isDefined(trigger))
            return;
 
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
 		
 		if(isdefined(level.activ)){
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
 		}

 
        ambientstop();
        ambientplay(song_name);
		
		if(song_name == "demboyz"){
			iprintlnbold("^6Now Playing: ^5Wiz Khalifa - We Dem Boyz (Subtronikz Remix)");
		}

		if(song_name == "fire"){
			iprintlnbold("^6Now Playing: ^5BTS - Fire");
			player thread giveRPGAmmo();
			level.activ thread giveRPGAmmo();
		}

		if(song_name == "panda"){
			iprintlnbold("^6Now Playing: ^5Desiigner - Panda");			
		}

		if(song_name == "howwedo"){
			iprintlnbold("^6Now Playing: ^5The Game - How we do feat. 50 Cent");
		}

		if(song_name == "trapqueen"){
			iprintlnbold("^6Now Playing: ^5Fetty Wap - Trap Queen (Crankdat Remix)");
		}
		

 
        iPrintlnBold( " ^8" + player.name + " ^6Entered" + " ^9" + weapon_room + " ^6room." );
        wait 0.05;
        player freezecontrols(true);
        level.activ freezecontrols(true);
        wait 1;
        player iPrintlnBold("^93");
        level.activ iPrintlnBold("^93");
        wait 1;
        player iPrintlnBold("^82");
        level.activ iPrintlnBold("^82");
        wait 1;
        player iPrintlnBold("^91");
        level.activ iPrintlnBold("^91");
        wait 1;
        player iPrintlnBold("^8FIGHT^9!");
        level.activ iPrintlnBold("^8FIGHT^9!");
        player freezecontrols(false);
        level.activ freezecontrols(false);
 
        while(isAlive(player) && isDefined(player)){
            wait 0.1;
		}
		
		level.inEndRoom = false;
    }
}

giveRPGAmmo(){
	while(1){
		self givemaxammo("rpg_mp");		
		wait 4;
	}	
}