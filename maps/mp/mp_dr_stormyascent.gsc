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
	maps\createfx\mp_dr_stormyascent_fx::main();

	level.speed1 = 1;
	level.speed2 = 0.125;
	level.speed3 = 0.15;
	level.speed4 = 0.15;
	level.inEndRoom = false;
	level.isFinished = false;
	 
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	// addTriggerToList("trap1_trig");
	// addTriggerToList("trap2_trig");
	// addTriggerToList("trap3_trig");
	// addTriggerToList("trap4_trig");
	// addTriggerToList("trap6_trig");
	// addTriggerToList("trap7_trig");	
	
	precacheitem("rpg_mp");
	precacheItem("ak74u_mp");
	precacheitem("knife_mp");
	precacheItem("remington700_mp");
	precacheItem("m40a3_mp");
	
	thread way_connect();
	// thread bounce_fail();
	// thread bounce_sniper();
	// thread endroom_old();
	// thread endroom_bounce();
	// thread endroom_snip();
	// thread endroom_knife();
	// thread acti_mover();
	// thread ambient();
	// thread acti_secret();
	// thread acti_secretend();
	// thread actisecret_fail();
	// thread actisecret_cp();
	thread secret1();
	thread secret1fail();
	thread secret1end();
	thread secret1cp();
	thread secret2();
	thread startround();
	// thread w12();
	// thread w34();
	// thread ro1234();
	// thread ro5678();
	// thread ro910();
	// thread trap1();
	// thread trap2();
	// thread trap3();
	// thread trap4();	
	// thread trap6();
	// thread trap7();
	// thread finish_trig();
	// thread acti_triggerino();
	// thread contact();

}

////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
	
    sr\api\_map::createWay("normal", "Normal Way", "1");
	sr\api\_map::createWay("secret", "Secret Way", "1");
	
    for(;;)
    {
        level waittill( "connected", player );
        player thread sr\api\_map::way_name();
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

addTriggerToList(name)
{
    if(!isDefined(level.trapTriggers))
        level.trapTriggers=[];
    level.trapTriggers[level.trapTriggers.size]=getEnt(name,"targetname");
}

acti_triggerino(){
	trig = getent("acti_triggerino","targetname");
	trig waittill("trigger",player);
	trig delete();
	player.isActi = true;
}

finish_trig(){
	trig = getent("finish_trigger","targetname");
	trig waittill("trigger",player);
	trig delete();
	tp = getent("acti_finish","targetname");
	level.activ setorigin(tp.origin);
	level.activ setplayerangles(tp.angles);
	level.activ TakeAllWeapons();
	level.activ giveWeapon("knife_mp");
	level.activ switchtoweapon("knife_mp");
	level.isFinished = true;
}

endroom_old(){
	trig = getent("old_trig","targetname");
	trig sethintstring("^8Old");
	trig waittill("trigger",player);
	trig delete();
	trig = getent("snip_trig","targetname");
	trig delete();
	trig = getent("knife_trig","targetname");
	trig delete();
	trig = getent("bounce_trig","targetname");
	trig delete();
	plat = getent("old_plat","targetname");
	plat movex(-256,1);	
}

endroom_bounce()
{
    endroom_template("bounce_trig", "bounce_jumper_start", "bounce_acti_start", "knife_mp", undefined, "Bounce", "dumdeedum");
}
 
endroom_knife()
{
    endroom_template("knife_trig", "knife_jumper_start", "knife_acti_start", "knife_mp", undefined, "Knife", "amilli");
}
 
endroom_snip()
{
    endroom_template("snip_trig", "snip_jumper_start", "snip_acti_start", "remington700_mp", "m40a3_mp", "Sniper", "heights");
}

endroom_template(trigger, jumper_origin, acti_origin, weapon, weapon2, weapon_room, song_name)
{
    trigger = getEnt(trigger, "targetname");
	trigger SetHintString("^1"+weapon_room);
    jumper = getEnt(jumper_origin, "targetname");
    acti = getEnt(acti_origin, "targetname");
	
	
 
    while(1)
    {
        trigger waittill("trigger", player);
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
		
		if(song_name == "dumdeedum"){
			iprintlnbold("^6Now Playing: ^5Keys N Krates - ^1Dum Dee Dum (JiKay Remix)");
		}
		
		if(song_name == "heights"){
			iprintlnbold("^6Now Playing: ^5Vadyr - ^1Heights");
		}
		
		if(song_name == "amilli"){
			iprintlnbold("^6Now Playing: ^5Lil Wayne - ^1A Milli (K Theory)");
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

bounce_fail(){
	trig = getent("bounce_tp","targetname");
	while(1){
		trig waittill("trigger",player);
		if(player.isActi == true){
			tp = getent("bounce_acti_start","targetname");
			player setorigin(tp.origin);
			player setplayerangles(tp.angles);
		} else {
			tp = getent("bounce_jumper_start","targetname");
			player setorigin(tp.origin);
			player setplayerangles(tp.angles);
		}
		wait 0.1;
	}	
}

bounce_sniper(){
	trig = getent("bounce_snip_trig","targetname");
	while(1){
		trig waittill("trigger",player);
		player giveweapon("m40a3_mp");
		player givemaxammo("m40a3_mp");
		player switchtoweapon("m40a3_mp");
		wait 0.1;
	}
}

acti_mover(){	
	trig = getent("acti_1","targetname");
	trig sethintstring("^5Move to next trap");
	trig waittill("trigger",player);
	trig delete();
	tp = getent("acti_2_tp","targetname");
	player setorigin(tp.origin);
	player setplayerangles(tp.angles);
	trig = getent("acti_2","targetname");
	trig sethintstring("^5Move to next trap");
	trig waittill("trigger",player);
	trig delete();
	tp = getent("acti_3_tp","targetname");
	player setorigin(tp.origin);
	player setplayerangles(tp.angles);
	trig = getent("acti_3","targetname");
	trig sethintstring("^5Move to next trap");
	trig waittill("trigger",player);
	trig delete();
	tp = getent("acti_4_tp","targetname");
	player setorigin(tp.origin);
	player setplayerangles(tp.angles);
	trig = getent("acti_4","targetname");
	trig sethintstring("^5Move to next trap");
	trig waittill("trigger",player);
	trig delete();
	tp = getent("acti_5_tp","targetname");
	player setorigin(tp.origin);
	player setplayerangles(tp.angles);
	
}

secret_check(){
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++){
		players[i].inSecret = false;
		players[i].cp = false;
		players[i].isActi = false;
	}
	wait 1;
}

//Timer by Lixfe/VC' Blade
secret1_timer(){   
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
        
    if(isdefined(level.randomcolor))
        self.secretTimer.glowColor=level.randomcolor;
    else 
        self.secretTimer.glowColor=(0.25,0.87,0.82);
    time= 90;
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

secret1(){
	trig = getent("secret1_trig","targetname");
	while(1){
		trig waittill("trigger",player);
		tp = getent("secret1_start","targetname");
		player setorigin(tp.origin);
		player setplayerangles(tp.angles);
		player iprintlnbold("^9Welcome to the secret!");
		player TakeAllWeapons();
		player giveweapon("rpg_mp");
		player givemaxammo("rpg_mp");
		player switchtoweapon("rpg_mp");
		player.inSecret = true;
		player sr\api\_map::startSecret(); //Speedrun Copy Paste
		player thread giveRPGAmmo();
		wait 1;
	}
}

giveRPGAmmo(){
	while(self.inSecret){
		self givemaxammo("rpg_mp");		
		wait 4;
	}	
}

acti_secret(){
	trig = getent("acti_secret","targetname");
	trig sethintstring("^5!");
	while(1){
		trig waittill("trigger",player);
		tp = getent("actisecret_start","targetname");
		player setorigin(tp.origin);
		player setplayerangles(tp.angles);
		player iprintlnbold("^9Welcome to the secret!");
		player TakeAllWeapons();
		player giveweapon("rpg_mp");
		player givemaxammo("rpg_mp");
		player switchtoweapon("rpg_mp");
		player.inSecret = true;		
		player thread giveRPGAmmo();
		wait 1;
	}
}

acti_secretend(){
	trig = getent("actisecret_end","targetname");
	trig sethintstring("^8Press Use to Finish");
	while(1){
		trig waittill("trigger",player);
		tp = getent("acti_finish","targetname");
		player braxi\_rank::giveRankXP("", 250);
		player setorigin(tp.origin);
		player setplayerangles(tp.angles);
		iprintlnbold(player.name+"^8 has finished the ^9acti secret!");
		player.inSecret = false;
		player takeweapon("rpg_mp");
		player giveWeapon("knife_mp");
		player switchtoweapon("knife_mp");
		wait 1;
	}
}

secret1end(){
	trig = getent("secret1_end","targetname");
	trig sethintstring("^8Press Use to Finish");
	while(1){
		trig waittill("trigger",player);
		tp = getent("secret1_endtp","targetname");
		player braxi\_rank::giveRankXP("", 250);
		player setorigin(tp.origin);
		player setplayerangles(tp.angles);
		iprintlnbold(player.name+"^8 has finished the ^9secret!");
		player.inSecret = false;
		player notify("secret_done");
		player.secretTimer destroy(); 
		player takeweapon("rpg_mp");
		player giveweapon("ak74u_mp");
		player givemaxammo("ak74u_mp");
		player switchtoweapon("ak74u_mp");
		wait 1;
	}
}


actisecret_fail(){
	trig = getent("actisecret_fail","targetname");	
	while(1){		
		trig waittill("trigger",player);
		if(player.cp == true){
			tp = getent("acti_secret_cp","targetname");			
		} else {
			tp = getent("actisecret_start","targetname");			
		}

		player setorigin(tp.origin);
		player setplayerangles(tp.angles);
		player giveWeapon("rpg_mp");
		player giveMaxAmmo("rpg_mp");
		player switchtoweapon("rpg_mp");
		wait 0.1;		
	}
}

secret1fail(){
	trig = getent("secret1_fail","targetname");	
	while(1){		
		trig waittill("trigger",player);
		if(player.cp == true){
			tp = getent("secret1_cpo","targetname");			
		} else {
			tp = getent("secret1_start","targetname");			
		}
		
		player setorigin(tp.origin);
		player setplayerangles(tp.angles);
		player giveWeapon("rpg_mp");
		player giveMaxAmmo("rpg_mp");
		player switchtoweapon("rpg_mp");
		wait 0.1;		
	}
}

actisecret_cp(){
	trig = getent("actisecret_cp","targetname");
	while(1){
		trig waittill("trigger",player);
		player.cp = true;
		wait 1;
	}
}

secret1cp(){
	trig = getent("secret1_cp","targetname");
	while(1){
		trig waittill("trigger",player);
		player.cp = true;
		wait 1;
	}
}

secret2(){
	s = getent("s","targetname");
	s waittill("trigger",player);
	iprintlnbold("^8S");
	s delete();
	e1 = getent("e1","targetname");
	e1 waittill("trigger",player);
	e1 delete();
	iprintlnbold("^8E");
	c = getent("c","targetname");
	c waittill("trigger",player);
	c delete();
	iprintlnbold("^8C");
	r = getent("r","targetname");
	r waittill("trigger",player);
	r delete();
	iprintlnbold("^8R");
	e2 = getent("e2","targetname");
	e2 waittill("trigger",player);
	e2 delete();
	iprintlnbold("^8E");
	t = getent("t","targetname");
	t waittill("trigger",player);
	t delete();
	iprintlnbold("^8T");
	iprintlnbold ("^6Secret opened!");
	wait 3;
	iprintlnbold("^6Lol jk, this isn't Vistic Castle");
}

trap1(){
	trig = getent("trap1_trig","targetname");
	trig sethintstring("^9Activate Trap");
	trig waittill("trigger",player);
	trig delete();
	player braxi\_rank::giveRankXP("", 25);
	
	trap1 = getent("trap1_1","targetname");
	trap3 = getent("trap1_3","targetname");
	trap2 = getent("trap1_2","targetname");
	
	while(1){
		trap2 rotateroll(720,0.5);
		wait 1;
		trap3 rotateroll(720,0.5);
		wait 1;
		trap1 rotateroll(720,0.5);
		wait 1;
	}
}

trap2(){
	trig = getent("trap2_trig","targetname");
	trig sethintstring("^9Activate Trap");
	trig waittill("trigger",player);
	trig delete();
	trap = getentarray("trap2","targetname");
	player braxi\_rank::giveRankXP("", 25);
	
	while(1){
		for(i = 0; i < trap.size; i++){
			trap[i] rotatepitch(720,2);
			wait 6;
		}
	}
}

trap3(){
	trig = getent("trap3_trig","targetname");
	trig sethintstring("^9Activate Trap");
	trig waittill("trigger",player);
	trig delete();
	player braxi\_rank::giveRankXP("", 25);
	trap = getent("trap3","targetname");	
	trap movey(-136,1);
}

trap4(){
	trig = getent("trap4_trig","targetname");
	trig sethintstring("^9Activate Trap");
	trig waittill("trigger",player);
	trig delete();
	player braxi\_rank::giveRankXP("", 25);
	level.speed1 = 0.5;
}



trap6(){
	trig = getent("trap6_trig","targetname");
	trig sethintstring("^9Activate Trap");
	trig waittill("trigger",player);
	trig delete();
	player braxi\_rank::giveRankXP("", 25);
	level.speed2 = 0.08;
}

trap7(){
	trig = getent("trap7_trig","targetname");
	trig sethintstring("^9Activate Trap");	
	trig waittill("trigger",player);
	trig delete();
	player braxi\_rank::giveRankXP("", 25);
	//I tried to make it an array but it wouldn't work.
	trap1 = getent("trap71","targetname");	
	trap2 = getent("trap72","targetname");
	trap3 = getent("trap73","targetname");
	trap4 = getent("trap74","targetname");
	trap5 = getent("trap75","targetname");
	trap6 = getent("trap76","targetname");
	trap7 = getent("trap77","targetname");

	traph1 = getent("traph71","targetname");
	traph2 = getent("traph72","targetname");
	traph3 = getent("traph73","targetname");
	traph4 = getent("traph74","targetname");
	traph5 = getent("traph75","targetname");
	traph6 = getent("traph76","targetname");
	traph7 = getent("traph77","targetname");
	
	trapp1 = getent("trapp71","targetname");	
	trapp2 = getent("trapp72","targetname");
	trapp3 = getent("trapp73","targetname");
	trapp4 = getent("trapp74","targetname");
	trapp5 = getent("trapp75","targetname");
	trapp6 = getent("trapp76","targetname");
	trapp7 = getent("trapp77","targetname");
	
	traph1 enablelinkto();
	traph1 linkto(trapp1);
	traph2 enablelinkto();
	traph2 linkto(trapp2);
	traph3 enablelinkto();
	traph3 linkto(trapp3);
	traph4 enablelinkto();
	traph4 linkto(trapp4);
	traph5 enablelinkto();
	traph5 linkto(trapp5);
	traph6 enablelinkto();
	traph6 linkto(trapp6);
	traph7 enablelinkto();
	traph7 linkto(trapp7);
	
	while(1){
		trap1 movez(-168,0.1);
		trapp1 movez(-168,0.1);
		wait 0.25;
		trap2 movez(-168,0.1);
		trapp2 movez(-168,0.1);
		wait 0.25;
		trap3 movez(-168,0.1);
		trapp3 movez(-168,0.1);
		wait 0.25;
		trap4 movez(-168,0.1);
		trapp4 movez(-168,0.1);
		wait 0.25;
		trap5 movez(-168,0.1);
		trapp5 movez(-168,0.1);
		wait 0.25;
		trap6 movez(-168,0.1);
		trapp6 movez(-168,0.1);
		wait 0.25;
		trap7 movez(-168,0.1);
		trapp7 movez(-168,0.1);
		wait 1.5;
		trap1 movez(168,3);
		trapp1 movez(168,3);
		trap2 movez(168,3);
		trapp2 movez(168,3);
		trap3 movez(168,3);
		trapp3 movez(168,3);
		trap4 movez(168,3);
		trapp4 movez(168,3);
		trap5 movez(168,3);
		trapp5 movez(168,3);
		trap6 movez(168,3);
		trapp6 movez(168,3);
		trap7 movez(168,3);
		trapp7 movez(168,3);
		wait 3.15;
		
		
		
	}
		
		
}
ambient(){
	level waittill( "round_started" );  
	
	
	possibility = randomIntRange(0,9);
	
	if(possibility == 0){
		ambientPlay("lenka");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Lenka - Blue Skies(REVOKE REMIX)");
			wait 25;
		}
	}
	
	if(possibility == 1){
		ambientPlay("jetta");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Jetta - I'd Love to Change the World (Matstubs Remix)");
			wait 25;		
		}		
	}
	
	if(possibility == 2){
		ambientPlay("chain");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6The Chainsmokers - Dont Let Me Down (Illenium Remix)");
			wait 25;
		}		
	}
	
	if(possibility == 3){
		ambientPlay("stress");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Twenty One Pilots - Stressed Out (Tomsize Remix)");
			wait 25;
		}		
	}
	
	if(possibility == 4){
		ambientPlay("7years");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Lukas Graham - 7 Years (T-Mass Remix) [feat. Toby Romeo]");
			wait 25;
		}				
	}
	
	if(possibility == 5){
		ambientPlay("me");
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6G-Eazy & Bebe Rexha - Me, Myself & I (No Sleep Remix)");
			wait 25;
		}			
	}
	
	if(possibility == 6){
		ambientPlay("trndsttr");
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Black Coast - TRNDSTTR (Lucian Remix)");
			wait 25;
		}
	}
	
	if(possibility == 7){
		ambientPlay("jetta2");
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Jetta - Take It Easy (Matstubs Remix)");
			wait 25;
		}			
	}
	
	if(possibility == 8){
		ambientPlay("revolution");	
		while(level.isFinished == false){
			iprintlnbold("^2Now playing: ^6Diplo - Revolution (SEAN&BOBO REMIX)");
			wait 25;		
		}		
	}			
}
	


startround(){
	level waittill( "round_started" );  
	
	door1 = getent("door1","targetname");
	door2 = getent("door2","targetname");
	
	door1 movey(64,1);
	door2 movey(-64,1);
	secret_check();
	wait 3;	
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

w12(){
	w1 = getentarray("w1","targetname");
	w2 = getentarray("w2","targetname");
	while(1){
		for(i = 0; i < w1.size; i++){
			w1[i] movez(264,level.speed1);
		}
		for(i = 0; i < w2.size; i++){
			w2[i] movey(128,level.speed1);
		}		
		wait level.speed1 * 2;
		for(i = 0; i < w2.size; i++){
			w2[i] movey(-128,level.speed1);
		}
		wait level.speed1 * 2;		
		for(i = 0; i < w1.size; i++){
			w1[i] movez(-264,level.speed1);
		}
		for(i = 0; i < w2.size; i++){
			w2[i] movey(128,level.speed1);
		}
		wait level.speed1 * 2;
		for(i = 0; i < w2.size; i++){
			w2[i] movey(-128,level.speed1);
		}
		wait level.speed1 * 2;
	}
}

ro1234(){
	ro1 = getent("ro1","targetname");
	ro2 = getent("ro2","targetname");
	ro3 = getent("ro3","targetname");
	ro4 = getent("ro4","targetname");

	radius = 320;	
	cy1 = -384;
	cz1 = 928;
	cy2 = 576;
	cz2 = 928;
	
	while(1){
		for(i = 0; i < 360; i+=5){			
			y1 = cy1 + radius * (cos(i));
			z1 = cz1 + radius * (sin(i));
			y2 = cy1 + radius * (cos(i+180));
			z2 = cz1 + radius * (sin(i+180));
			y3 = cy2 + radius * (cos(360 - i + 45));
			z3 = cz2 + radius * (sin(360 - i + 45));
			y4 = cy2 + radius * (cos(360 - i + 180 + 45));
			z4 = cz2 + radius * (sin(360 - i + 180 + 45));
			
			
			ro1 moveto((1088,y1,z1),level.speed2);	
			ro2 moveto((1088,y2,z2),level.speed2);
			ro3 moveto((1088,y3,z3),level.speed2);
			ro4 moveto((1088,y4,z4),level.speed2);				
			
			wait level.speed2;
		}
	}
}

ro5678(){
	ro5 = getent("ro5","targetname");
	ro6 = getent("ro6","targetname");
	ro7 = getent("ro7","targetname");
	ro8 = getent("ro8","targetname");

	radius = 512;
	radius2 = 256;
	cx = 256;
	cz = 1664;
	
	
	while(1){
		for(i = 0; i < 360; i+=5){			
			x5 = cx + radius * (cos(i));
			z5 = cz + radius * (sin(i));
			x6 = cx + radius * (cos(i +180));
			z6 = cz + radius * (sin(i +180));
			x7 = cx + radius2 * (cos(360 - i + 45));
			z7 = cz + radius2 * (sin(360 - i + 45));
			x8 = cx + radius2 * (cos(360 - i + 180 + 45));
			z8 = cz + radius2 * (sin(360 - i + 180 + 45));
			
			
			ro5 moveto((x5,-1088,z5),level.speed3);	
			ro6 moveto((x6,-1088,z6),level.speed3);
			ro7 moveto((x7,-1088,z7),level.speed3);
			ro8 moveto((x8,-1088,z8),level.speed3);				
			
			wait level.speed3;
		}
	}
}

ro910(){
	ro9 = getent("ro9","targetname");
	ro10 = getent("ro10","targetname");
	radius = 512;
	cx = 1024;
	cy = 1024;
	
	while(1){
		for(i = 0; i < 360; i+=5){
			x9 = cx + radius * (cos(i));
			y9 = cy + radius * (sin(i));
			x10 = cx + radius * (cos(i+180));
			y10 = cy + radius * (sin(i+180));
			
			ro9 moveto((x9,y9,2188),level.speed4);
			ro10 moveto((x10,y10,2188),level.speed4);
			
			
			wait level.speed4;
		}
	}
}

w34(){
	w3 = getent("w3","targetname");
	w4 = getent("w4","targetname");
	
	while(1){
		w3 movex(-640,1.5);
		w4 movex(640,1.5);
		wait 2;
		w3 movex(640,1.5);
		w4 movex(-640,1.5);
		wait 2;
	}
}
