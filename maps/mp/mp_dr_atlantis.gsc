/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////																									              ///////
///////																									              ///////
///////		////////	     //		/////////////	//	 //  ////////////  ////////////  //////////   /////////////   ///////
///////		//		//    //   //   //         //	//  //   //	                //       //           //         //   ///////
///////		//		//    //   //   ////////////    // //    //	                //       //           ////////////    ///////
///////		//		//    ///////	//	  //	    ////     ////////////       //       //////////   //              ///////
///////		//		//	  //   //	//	   //	    // //              //       //       //           //              ///////
///////		//		//	  //   //	//		//      //  //             //       //       //           //              ///////
///////		////////	  //   //   //		 //     //   //  ////////////       //       //////////   //              ///////
///////																									              ///////
///////																									              ///////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Steam: ^5CAR ^0DarkSTEP
//Discord: DarkSTEP#7390
//YouTube: DarkSTEP
//Website: darkstep.altervista.org
//PayPal: paypal.me/darktest
//Every donator will get lifetime VIP access to all my updated maps!
//Minor thanks: Ohh Rexy<3 (finding me the emotiguy model source)
//Feel free to copy without permission ;)


#include braxi\_common;
#include braxi\_rank;
#include common_scripts\utility;

main()
{
maps\mp\_load::main();
 
	game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";
    setDvar( "r_specularcolorscale", "1" );
    setDvar("r_glowbloomintensity0",".25");
    setDvar("r_glowbloomintensity1",".25");
    setDvar("r_glowskybleedintensity0",".3");
	setDvar("bg_falldamagemaxheight", 200000 );
	setDvar("bg_falldamageminheight", 100000 );
	//setDvar("g_speed","190");
	//visionSetNaked( "mp_vacant", 0 );
	
	precacheShader("wingstrail");
	precacheModel("crystal");
	precacheModel("viewhands_bo2_pla_armorsleeves");
	precacheModel("viewmodel_darktrident");
	precacheModel("emotiguy");
	precacheModel("darkturtle");
	precacheModel("koifish");
	precacheModel("dumbfish");
	precacheItem("ak47_mp");
	precacheItem("rpg_mp");
	precacheItem("saw_mp");
	precacheItem("m9a1_mp");
	precacheItem("beretta_mp");
	precacheItem("darktrident_mp");
	
	level.crystalsclaimed = false;
	level.wingstrail = loadFX("deathrun/wingstrail");
	level.redlight = loadFX("deathrun/redlight");
	level.boom_fx = loadFX("explosions/default_explosion");
	level.waterfall = loadFX("deathrun/pipefall");
	level.particles = loadFX("deathrun/blueparticles");
	level.splash_fx = loadFX("explosions/grenadeExp_water");
	level.deathray = loadFX("deathrun/laserhit");
	
	level.music=[];
    level.music[0]["song"]    ="Disturbed - No More";
    level.music[0]["alias"]    ="song1";
	level.music[2]["song"]    ="Steve Aoki - Hysteria";
    level.music[2]["alias"]    ="song2";
	level.music[4]["song"]    ="Imagine Dragons - Battle Cry";
    level.music[4]["alias"]    ="song3";
	level.music[5]["song"]    ="Tiesto - Written In Reverse";
    level.music[5]["alias"]    ="song4";
	level.music[6]["song"]    ="Porter Robinson - Fellow Feeling";
    level.music[6]["alias"]    ="song5";
	level.music[3]["song"]    ="SKAN - The Vision";
    level.music[3]["alias"]    ="song6";
	level.music[1]["song"]    ="Rival - Walls";
    level.music[1]["alias"]    ="song7";
	
	level.darkperks = [];
	level.darkperks[0]["name"]    ="Solidsilver M9A1";
    level.darkperks[0]["price"]    = 3;
	level.darkperks[1]["name"]    ="Dark Trident";
    level.darkperks[1]["price"]    = 5;
	level.darkperks[2]["name"]    ="Mappers Trail";
    level.darkperks[2]["price"]    = 8;
	level.darkperks[4]["name"]    ="VIP Song";
    level.darkperks[4]["price"]    = 15;
	level.darkperks[3]["name"]    ="PET";
    level.darkperks[3]["price"]    = 10;
	level.darkperks[5]["name"]    ="Extra Life";
    level.darkperks[5]["price"]    = 20;
	
	level.dicewards = [];
	level.dicewards[0]["quantity"] = "Remington700";
	level.dicewards[0]["reward"] = "weapon";
	level.dicewards[1]["quantity"] = 500;
	level.dicewards[1]["reward"] = "XP";
	level.dicewards[2]["quantity"] = "WTF";
	level.dicewards[2]["reward"] = "ability";
	level.dicewards[3]["quantity"] = "AK47";
	level.dicewards[3]["reward"] = "weapon";
	level.dicewards[4]["quantity"] = "CAR TRAIL";
	level.dicewards[4]["reward"] = "ability";
	level.dicewards[5]["quantity"] = 150;
	level.dicewards[5]["reward"] = "XP";
	level.dicewards[6]["quantity"] = -300;
	level.dicewards[6]["reward"] = "XP";
	level.dicewards[7]["quantity"] = "SAW";
	level.dicewards[7]["reward"] = "weapon";
	level.dicewards[8]["quantity"] = "RPG";
	level.dicewards[8]["reward"] = "weapon";
	level.dicewards[9]["quantity"] = 300;
	level.dicewards[9]["reward"] = "XP";
	level.dicewards[10]["quantity"] = 600;
	level.dicewards[10]["reward"] = "XP";
	level.dicewards[11]["quantity"] = 2000;
	level.dicewards[11]["reward"] = "XP";
	level.dicewards[12]["quantity"] = -1000;
	level.dicewards[12]["reward"] = "XP";
	level.dicewards[13]["quantity"] = 800;
	level.dicewards[13]["reward"] = "XP";
	level.dicewards[14]["quantity"] = -200;
	level.dicewards[14]["reward"] = "XP";
	level.dicewards[15]["quantity"] = "PET";
	level.dicewards[15]["reward"] = "ability";
	level.dicewards[16]["quantity"] = "LIFE";
	level.dicewards[16]["reward"] = "ability";
	level.dicewards[17]["quantity"] = 1;
	level.dicewards[17]["reward"] = "XP";
	level.dicewards[18]["quantity"] = "M9A1";
	level.dicewards[18]["reward"] = "weapon";
	level.dicewards[19]["quantity"] = "5";
	level.dicewards[19]["reward"] = "DARK POINTS";
	level.dicewards[20]["quantity"] = "10";
	level.dicewards[20]["reward"] = "DARK POINTS";
	level.dicewards[21]["quantity"] = "20";
	level.dicewards[21]["reward"] = "DARK POINTS";
	level.dicewards[22]["quantity"] = 10;
	level.dicewards[22]["reward"] = "XP";
	level.dicewards[23]["quantity"] = 100;
	level.dicewards[23]["reward"] = "XP";
	level.dicewards[24]["quantity"] = "DarkTrident";
	level.dicewards[24]["reward"] = "weapon";
	
	level.firstenter = true;

	//thread tester();
	thread trident();
	thread messages();
	thread waternoise();
	thread fauna();
	thread mantle190();
	thread darkpoints();
    thread startdoor();
	thread watersound();
	thread watersound2();
	thread dices();
	thread sheep();
	thread modelsetter();
	thread nitrofire();
	thread fx_water();
	thread collectibles();
	thread hud();
	thread lastcrystal();
	thread musicbox();
	thread gone();
	thread riseup();
	thread vision();
	thread bomb();
	thread endoor();
	thread steps();
	thread sniper();
	thread stp();
	thread knife();
	thread pure();
	thread pureend();
	thread deagle();
	thread main190();
	thread enter190();
	thread b190();
	thread c190();
	thread d190();
	thread e190();
	thread f190();
	thread g190();
	thread h190();
	thread i190();
	thread j190();
	thread k190();
	thread l190();
	thread secretend190();
	thread hn();
	thread main210();
	thread enter210();
	thread b210();
	thread c210();
	thread d210();
	thread e210();
	thread f210();
	thread g210();
	thread h210();
	thread i210();
	thread j210();
	thread k210();
	thread secretend210();
//	thread addTestClients();
	thread bounceroom();
	thread btp();
	thread bouncesniper();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread simon();
	thread particlesfx();
	thread collectend();
	thread joinsetter();
	thread endsetter();
	
	thread maketp("trig_actip1","o_actip1");
	thread maketp("trig_actip2","o_actip2");
	thread maketp("trig_actip3","o_actip3");
	thread maketp("trig_actip4","o_actip4");
	thread maketp("trig_actip5","o_actip5");
	thread maketp("trig_actip6","o_actip6");
	
	addTriggerToList("trig_trap1");
	addTriggerToList("trig_trap2");
	addTriggerToList("trig_trap3");
	addTriggerToList("trig_trap4");
	addTriggerToList("trig_trap5");
	addTriggerToList("trig_trap6");
	addTriggerToList("trig_trap7");

	thread sr\api\_map::createSpawn((-266, 10990, 1635), 180);
	thread sr\api\_speedrun::createNormalWays("Normal Way;");
	
}

	addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

stringToInt(s) 											//converts a string to an int (thanks darkstep for making this awesome script c:)
{
	if(isString(s))
	{
		final = 0;
		for(i = 0; i < s.size; i++)
		{
			n = getSubStr(s,i,i+1);
			if(n == "0")
			{
				n = 0;
			}
			else if(n == "1")
			{
				n = 1;
			}
			else if(n == "2")
			{
				n = 2;
			}
			else if(n == "3")
			{
				n = 3;
			}
			else if(n == "4")
			{
				n = 4;
			}
			else if(n == "5")
			{
				n = 5;
			}
			else if(n == "6")
			{
				n = 6;
			}
			else if(n == "7")
			{
				n = 7;
			}
			else if(n == "8")
			{
				n = 8;
			}
			else if(n == "9")
			{
				n = 9;
			}
			else
			{
				n = 0;
			}
			f[i] =  n * pow(10,(s.size - i - 1)); 
			final += f[i];
		}
		return final / 10;
	}
	else return s;
}

pow(n,p)														//raises a number to a specific power (thanks darkstep for making this awesome script c:)
{
	s = n;
	for(i = 0; i < p; i++)
	{
		s = s*n; 
	}
	return s;
}

songs()
{
x=randomint(7);
if (x == 0)
{
ambientPlay("song1");
iPrintln("^2>>^1Now playing: ^5Disturbed - No More^2<<");
}

if (x == 1)
{
ambientPlay("song2");
iPrintln("^2>>^1Now playing: ^5Steve Aoki - Hysteria^2<<");
}

if (x == 2)
{
ambientPlay("song3");
iPrintln("^2>>^1Now playing: ^5Imagine Dragons - Battle Cry^2<<");
}

if ( x== 3)
{
ambientPlay("song4");
iPrintln("^2>>^1Now playing: ^5Tiesto - Written In Reverse^2<<");
}

if (x == 4)
{
ambientPlay("song5");
iPrintln("^2>>^1Now playing: ^5Porter Robinson - Fellow Feeling^2<<");
}

if (x == 5)
{
ambientPlay("song6");
iPrintln("^2>>^1Now playing: ^5SKAN - The Vision^2<<");
}

if (x == 6)
{
ambientPlay("song7");
iPrintln("^2>>^1Now playing: ^5Rival - Walls^2<<");
}

}

messages()
{
wait 10;
for(;;)
{
wait 35;
x=randomint(16);
if (x==0)
{
iPrintln("^1Map made by ^5DarkSTEP");
}

if (x==1)
{
iPrintln("^5There are ^22^5 jumper secrets, an ^4EASY^5 and an ^1HARD^5 one!");
}

if (x==2)
{
iPrintln("^5This map took ^12^5 months of work so i hope it's worth it :)");
}

if (x==3)
{
iPrintln("^5Secrets have an antiglitch system so don't try to shortcut ;)");
}

if (x==4)
{
iPrintln("^1Steam: ^5CAR ^0DarkSTEP");
}

if (x==5)
{
iPrintln("^5Feel free to report bugs");
}

if (x==6)
{
iPrintln("^5Feel free to join us on ^1xenia-gaming.net");
}

if (x==7)
{
iPrintln("^1Discord: ^5DarkSTEP#7390");
}

if (x==8)
{
iPrintln("^5Special thanks to ^2Ohh Rexy<3 ^5for finding me that emotiguy model :D");
}

if (x==9)
{
iPrintln("^5After a room fight your ^2health^5 will be restored");
}

if (x==10)
{
iPrintln("^5You can ^1Roll The Dice ^5once per round at spawn");
}

if (x==11)
{
iPrintln("^5You can spend your ^1DARK POINTS ^5at spawn");
}

if (x==12)
{
iPrintln("^1DARK POINTS ^5will get resetted at map end, so spend them!");
}

if (x==13)
{
iPrintln("^5Leaving a race room will get you temporarily ^1BANNED ^5until round ends");
}

if (x==14)
{
iPrintln("^5Delivering all the crystals will get everyone ^3FREE ^210.000 ^1XP!");
}

if (x==15)
{
iPrintln("^5Special thanks to ^2DarkSTEP ^5for that awesome trident weapon :^)");
}

}
}

maketp(trigname, oname, message, globalmessage, xp) 
{
	self endon("acti_antiglitch");
	trig = getEnt(trigname, "targetname");
	o = getEnt(oname, "targetname");
    for(;;) 
	{
		trig waittill("trigger", player);
		if (level.firstenter == false)
			return;
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
		player playSoundToPlayer("tp", player);
		if (isDefined(message))
			player iPrintLnBold(message);
		if (isDefined(globalmessage))
			iPrintLnBold(globalmessage);
		if (isDefined(xp))
			player braxi\_rank::giveRankXP("", xp);	
    }
}

waternoise()
{
	o_n = getEnt("o_waternoise", "targetname");
	level waittill("round_started");
	o_n playLoopSound("waternoise");
}

fauna()
{
	f1 = getEntArray("fauna1", "targetname");
	f2 = getEntArray("fauna2", "targetname");
	f3 = getEntArray("fauna3", "targetname");
	f4 = getEntArray("fauna4", "targetname");
	f5 = getEntArray("fauna5", "targetname");
	f6 = getEntArray("fauna6", "targetname");
	level waittill("round_started");
	thread faunalogic(f1);
	thread faunalogic(f2);
	thread faunalogic(f3);
	thread faunalogic(f4);
	thread faunalogic(f5);
	thread faunalogic(f6);
}

faunalogic(a)
{
	x = randomIntRange(3, (a.size));
	for(i = 0; i < x; i++)
	{
		y = randomInt(a.size);
		m = spawn( "script_model", a[y].origin );
		m thread faunaMover(a, y);
		wait 1;
	}
}

/*faunaMover(a, y)
{
	b = randomInt(3);
	if(b == 0)
		self setModel( "darkturtle" );
	else if(b == 1)
		self setModel( "dumbfish" );	
	else
		self setModel( "koifish" );
	self.angles = (0,360,0);
	for(;;)
	{
		x = randomInt(a.size);
		while(x == y)																//WORKING SCRIPT BUT WAAAAAAAAAAAAAY TOO HEAVY
		{
			x = randomInt(a.size);
		}
		for(i = 0; i < 100; i++)
		{
			//self.angles = a[x].angles;
			dist = distance(self.origin, a[x].origin);
			waittime = positive(dist/100);
			self moveTo(a[x].origin, waittime);
			self.angles = vectorToAngles(a[x].origin - self.origin);
			wait .05;
		}
	y = x;	
	wait 5;
	}
}*/

faunaMover(a, y)
{
	b = randomInt(3);
	if(b == 0)
		self setModel( "darkturtle" );
	else if(b == 1)
		self setModel( "dumbfish" );	
	else
		self setModel( "koifish" );
	self.angles = (0,360,0);
	for(;;)
	{
		x = randomInt(a.size);
		while(x == y)
		{
			x = randomInt(a.size);
			wait .05;
		}
			self rotateTo(vectorToAngles(a[x].origin - self.origin), 1.5);
			wait 1.5;
			self moveTo(a[x].origin, 10);
	wait 10.1;
	y = x;	
	}
}

positive(n)
{
	if(n < 0)
	{
		return n*(-1);
	}
	else if(n > 0)
	{	
		return n;
	}
	else
	{
		return 5;
	}
}

mantle190()
{
	m = getEntArray("mantle190", "targetname");
	level waittill("round_started");
	if(getDvar("g_speed") != "190" || getDvar("dr_jumpers_speed") != "1.0")
	{
		for(i = 0; i < m.size; i++)
		{
			m[i] hide();
			m[i] notSolid();
			wait .05;
		}
	}
}

watersound()
{
	//trigs = getEntArray( "trigger_hurt", "classname" );
	//trigs = getEntArray( "water", "targetname" );
	trig = getEnt( "water", "targetname" );
		//if(isDefined(trigs[i].name) && !isSubStr(toLower(trigs[i].name), toLower("hurt")))					WOULD'VE BEEN TOO COOL I SUPPOSE
		for(;;)
		{
			trig waittill("trigger", player);
			player.deathreason = "water";
			playFX(level.splash_fx, player.origin);
			player suicide();
		}
}

watersound2()
{
	trig = getEnt( "trap2hurt", "targetname" );
		for(;;)
		{
			trig waittill("trigger", player);
			player.deathreason = "water";
		}
}

startdoor()
{
t = getEnt("sdtop", "targetname");
l = getEnt("sdleft", "targetname");
b = getEnt("sdbottom", "targetname");
r = getEnt("sdright", "targetname");
level waittill("round_started");
if(game["roundsplayed"] <= 2)
		thread credits();
wait 12;
iPrintLnBold("^5Start door opened.");
level notify("door_open");
if (level.cambiato == false)
 {
	thread songs(); 
	level.cambiato = true;
 }
t moveZ(300, 1.5);
b moveZ(-300, 1.5);
l moveY(-550, 1.5);
r moveY(550, 1.5);
wait 1.5;
t delete();
b delete();
l delete();
r delete();
}

credits()
{
		hud_mapnames = newHudElem();
		hud_mapnames.alignX = "center";
		hud_mapnames.alignY = "top";
		hud_mapnames.horzalign = "center";
		hud_mapnames.vertalign = "top";
		hud_mapnames.alpha = 5;
		hud_mapnames.x = 0;
		hud_mapnames.y = 90;
		hud_mapnames.font = "objective";
		hud_mapnames.fontscale = 1.7;
		hud_mapnames.glowalpha = 1;
		hud_mapnames.glowcolor = (5,6,2);
		hud_mapnames.label = &"Welcome to ^5Atlantis^7!";
		hud_mapnames SetPulseFX( 40, 4200, 200 );	
		wait 5.5;
		hud_mapnames = NewHudElem();
		hud_mapnames.alignX = "center";
		hud_mapnames.alignY = "top";
		hud_mapnames.horzalign = "center";
		hud_mapnames.vertalign = "top";
		hud_mapnames.alpha = 5;
		hud_mapnames.x = 0;
		hud_mapnames.y = 90;
		hud_mapnames.font = "objective";
		hud_mapnames.fontscale = 1.7;
		hud_mapnames.glowalpha = 1;
		hud_mapnames.glowcolor = (5,6,2);
		hud_mapnames.label = &"Map by ^5DarkSTEP";
		hud_mapnames setPulseFX( 40, 4000, 200 );
		hud_mapnames destroy();		
}

dices()
{
	a = getEnt("dice", "targetname");
	b = getEnt("dice2", "targetname");
	a thread crazyRotator();
	b thread crazyRotator();
	thread rolls();
	wait .05;
}

rolls()
{
	trig = getEnt("trig_dice", "targetname");
	trig setHintString("^1Roll The Dices!");
	for(;;)
	{
		trig waittill("trigger", player);
		player thread dicestuff();
	}
}

dicestuff()
{
	if(self.rolled == 0)
	{
		self.rolled = 1;
		self.hud_dices = newClientHudElem(self);
		self.hud_dices.alignX = "center";
		self.hud_dices.alignY = "middle";
		self.hud_dices.horzalign = "center";
		self.hud_dices.vertalign = "middle";
		self.hud_dices.alpha = 5;
		self.hud_dices.x = 0;
		self.hud_dices.y = 90;
		self.hud_dices.font = "objective";
		self.hud_dices.fontscale = 2;
		self.hud_dices.glowalpha = 1;
		self.hud_dices.glowcolor = (5,6,2);
		self.hud_dices.label = &"Rolling the dices...";
		self.hud_dices setPulseFX( 30, 3000, 500 );	
		wait 4;
		if(level.freerun)
		//if(false)  //test
		{
			self.hud_dices.label = &"^1No RTD in Free Run";
			self.hud_dices setPulseFX( 30, 3000, 500 );	
		}
		else
		{
			self thread diceslogic();
		}
	}
}

diceslogic()
{
	x = randomInt(level.dicewards.size);
	if(level.dicewards[x]["reward"] == "weapon")
	{
		self giveWeapon(toLower(level.dicewards[x]["quantity"])+"_mp");
		self giveMaxAmmo(toLower(level.dicewards[x]["quantity"])+"_mp");
		self switchToWeapon(toLower(level.dicewards[x]["quantity"])+"_mp");
	}
	else if(level.dicewards[x]["reward"] == "XP")
	{
		self braxi\_rank::giveRankXP("", level.dicewards[x]["quantity"]);	
	}
	else if(level.dicewards[x]["reward"] == "DARK POINTS")
	{
		if(isDefined(self.pers["darkpoints"]))
		{
			if(stringToInt(self.pers["darkpoints"]) < 200)
			{
				self.pers["darkpoints"] = stringToInt(self.pers["darkpoints"]) + level.dicewards[x]["quantity"];
				self setStat(2555, self.pers["darkpoints"]);
			}
		}
	}
	else if(level.dicewards[x]["reward"] == "ability")
	{
		if(level.dicewards[x]["quantity"] == "WTF")
		{
		if( isDefined( self ) && self isReallyAlive() )
			{	
				wait .5;
				self thread blower();
			}
		}
		else if(level.dicewards[x]["quantity"] == "PET")
		{
			self thread petgiver();
		}
		else if(level.dicewards[x]["quantity"] == "CAR TRAIL")
		{
			self thread specialtrail();
		}
		else if(level.dicewards[x]["quantity"] == "LIFE")
		{
			self braxi\_mod::giveLife();
		}
	}
	self.string2 = level.dicewards[x]["reward"];
	self.string4 = level.dicewards[x]["quantity"];
	self.string = "^5You got ^3"+self.string2+"^5: ^2"+self.string4;  //FUCK OFF FUCK OFF FUCK OFF FUCK OFF FUCK OFF FUCK OFF
	//self.hud_dices.label = &""+self.string;						//FUCKING LOCALIZED STRINGS AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	self thread selfhud(self.string);								  //FUCK OFF FUCK OFF FUCK OFF FUCK OFF FUCK OFF FUCK OFF
	self.hud_dices setPulseFX( 30, 3000, 500 );
	self.hud_dices destroy();	
}

specialtrail()
{
	while(isAlive(self))
	{	
		playFX( level.wingstrail, self.origin );
		wait 0.1;
	}
}

petgiver()
{
	if( isDefined( self ) && self isReallyAlive() )
	{
		self.pet = spawn("script_model", self.origin-(0,-20,0) );
		self.pet.angles = self.angles;
		self.pet setModel("emotiguy");
		self.pet linkTo(self);
		self common_scripts\utility::waittill_any("death","disconnect");
		//if(isDefined(self.pet) && !isSubStr(toLower(removeAssFromString(self.name)), toLower("STEP")))
		if(isDefined(self.pet))
			self.pet delete();
	}
}

tester()
{
	trig = getEnt("trig_tester", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player.pers["darkpoints"] += 50;
		player thread petgiver();
	}
}
selfhud(messages)
{
self.hud_rolling = newClientHudElem(self);
self.hud_rolling.alignX = "center";
self.hud_rolling.alignY = "middle";
self.hud_rolling.horzalign = "center";
self.hud_rolling.vertalign = "middle";
self.hud_rolling.alpha = 1;
self.hud_rolling.x = 0;
self.hud_rolling.y = 90;
self.hud_rolling.font = "objective";
self.hud_rolling.fontscale = 2;
self.hud_rolling.glowalpha = 1;
self.hud_rolling.glowcolor = (0,.2,.8);
self.hud_rolling setText(messages);
//hud_start setPulseFX( 100, 4000, 500 );
self.hud_rolling setPulseFX( 30, 4000, 500 );
wait 7;
if(isdefined(self.hud_rolling))
	self.hud_rolling destroy();
}

modelsetter()
{
	trig = getEnt("trig_allsetter", "targetname");
	level waittill("door_open");
	for(;;)
	{
	trig waittill("trigger", player);
	if(player.allset == 0)
	{
		player.allset = 1;
		player setViewModel("viewhands_bo2_pla_armorsleeves");
		player setClientDvar("r_specular", "1");
		player setClientDvar("r_specularColorScale", "35");
		player setClientDvar("r_filmTweakEnable", "1");
		player setClientDvar("r_filmUseTweaks", 1);
		player setClientDvar("r_filmTweakInvert", "0");
		player setClientDvar("r_filmTweakContrast", "1.3");
		player setClientDvar("r_filmTweakBrightness", "0.108425");
		player setClientDvar("r_filmTweakLightTint", ".7 1.2 1.5");
		player setClientDvar("r_filmTweakDarkTint", "0.946567 1.24024 1.51933");
		if(player.cid == player.spectatorclient)
			{
				player.spectatorclient++;
			}
			else
			{
				player.spectatorclient = 1;
			}
		player thread deathreset();
	}
	wait .05;  //HAD TO PUT IT CUZ OF MASSIVE LAGSPIKES
	}
}

particlesfx()
{
	level waittill("round_started");
	r = getEntArray("fx_particles", "targetname");
	for(i = 0; i < r.size; i++)
	{
		thread particles(r[i]);
	}
}

particles(o)
{
	PlayFX( level.particles, o.origin );
}


addTestClients()
{
    setDvar("scr_testclients", "");
    wait 1;
    for(;;)
    {
        if(getdvarInt("scr_testclients") > 0)
            break;
        wait 1;
    }
    testclients = getdvarInt("scr_testclients");
    setDvar( "scr_testclients", 0 );
    for(i=0;i<testclients;i++)
    {
        ent[i] = addtestclient();

        if (!isdefined(ent[i]))
        {
            println("Could not add test client");
            wait 1;
            continue;
        }
        ent[i].pers["isBot"] = true;
        ent[i] thread TestClient("autoassign");
    }
    thread addTestClients();
}
TestClient(team)
{
    self endon( "disconnect" );

    while(!isdefined(self.pers["team"]))
        wait .05;
        
    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}

trident()
{
	trig = getEnt("trig_trident", "targetname");
	trig waittill("trigger", acti);
	trig delete();
	acti takeAllWeapons();
	acti giveWeapon("darktrident_mp");
	acti switchToWeapon("darktrident_mp");
}

vision()
{
	level waittill("round_started");
	setDvar("r_filmUseTweaks", "1");
	wait .05;
	if(game["roundsplayed"] > 1)
	{
		thread games();
	}
	visionSetNaked("mp_dr_atlantis",0);
	pa = getEntArray( "player", "classname" );
	for(i = 0; i < pa.size; i++)
		{
			pa[i].cid = i;
			pa[i].allset = 1;
			pa[i].rolled = 0;
			pa[i] setClientDvar("r_specular", "1");
			pa[i] setClientDvar("r_specularColorScale", "35");
			pa[i] setClientDvar("r_filmTweakEnable", "1");
			pa[i] setClientDvar("r_filmUseTweaks", 1);
			pa[i] setClientDvar("r_filmTweakInvert", "0");
			pa[i] setClientDvar("r_filmTweakContrast", "1.3");
			pa[i] setClientDvar("r_filmTweakBrightness", "0.108425");
			pa[i] setClientDvar("r_filmTweakLightTint", ".7 1.2 1.5");
			pa[i] setClientDvar("r_filmTweakDarkTint", "0.946567 1.24024 1.51933");
			pa[i] setViewModel("viewhands_bo2_pla_armorsleeves");
			if(pa[i].cid == pa[i].spectatorclient)
			{
				pa[i].spectatorclient++;
			}
			else
			{
				pa[i].spectatorclient = 1;
			}
			if(!isDefined(pa[i].pers["darkpoints"]))
				pa[i].pers["darkpoints"] = pa[i] getStat(2555);
			if(isDefined(pa[i].pers["darkpoints"]))
			{
				if(stringToInt(pa[i].pers["darkpoints"]) < 200)
				{
					pa[i].pers["darkpoints"] = stringToInt(pa[i].pers["darkpoints"]) + 1;
					pa[i] setStat(2555,pa[i].pers["darkpoints"]);
					pa[i] iPrintLn("^5You earned ^31 ^1DARK POINT^5!");
				}
			}
			pa[i] thread deathreset();
		}
}

deathreset()
{
	self waittill("death");
	self.allset = 0;
	wait .05;
	//if(game["roundsplayed"] > 1)
	//{
		if(!isDefined(self.deathreason))
		{
			self playLocalSound("punch");
		}
		else 
		{
			self playLocalSound("splash1");
			self.deathreason = undefined;
		}
	//}
}

sheep()
{
		trig = getEnt("trig_sheep", "targetname");
		i = 0;
		x = randomIntRange(40, 270);
		for(;;)
		{
			trig waittill("trigger", player);
			i++;
			player playSound("meee");
			player braxi\_rank::giveRankXp( "", 1);
			if (i >= x)
			{
				iPrintLnBold("^5The sheep is ^1MAD^5!");
				trig delete();
				playFX(level.redlight, player.origin);
				player freezeControls(1);
				wait 1;
				player playSound("mad");
				wait 3;
				playFX(level.boom_fx, player.origin);
				player playSound( "artillery_impact" );
				radiusDamage(player.origin, 249, 249, 249);
				player braxi\_rank::giveRankXp( "", -100);
				player freezeControls(0);
				return;
			}
		}
}

fx_water()
{
		trig = getEnt("trig_waterfall", "targetname");
		o = getEntArray("fx_waterfall", "targetname");
		trig waittill("trigger", player);
		for(i = 0; i < o.size; i++)
		{
			thread waterfallrunner(o[i]);
			wait .1;
		}
}

waterfallrunner(point)
{
	//for(;;)
		//{
			//playFX(level.waterfall, point.origin);
			point playLoopSound("pipeflow");	
			//wait 94;
		//}
}

hud()
{
	level.crystalsfound = 0;
	level.coll = newHudElem();
	level.coll.x = 0;
	level.coll.y = 75;
	level.coll.horzAlign = "right";	
	level.coll.vertAlign = "middle";
	level.coll.alignX = "right";
	level.coll.alignY = "middle";
	level.coll.sort = 103;
	level.coll.foreground = 1;
	level.coll.archived = false;
	level.coll.alpha = 1;
	level.coll.glowalpha = 1;
	level.coll.fontScale = 1.9;
	level.coll.hidewheninmenu = true;
	level.coll.color = (1,1,1);
	level.coll.glowcolor = (0,.4,.8);
	//level.coll.label = &"Crystals Found: &&1 /"+level.oa.size;  //fuck localized strings lul
	level.coll.label = &"Crystals Found: &&1/10";
	
	while(level.crystalsclaimed == false)
	{
	wait 1;
		if(level.crystalsfound != level.oa.size)
		{
			level.coll setValue(level.crystalsfound);
		}
		else {
			level.coll setText("^7");
			level.coll.glowcolor = (0,1,.2);
			level.coll.label = &"^2All crystals found!";
		}
	}
	level.coll.alpha = 1;
	level.coll fadeOverTime(1);
	wait 1;
	level.coll.alpha = 0;
	wait .1;
	level.coll destroy();
}

collectibles()
{
	//spec = getEnt("crystal", "targetname");
	level.oa = getEntArray("collectible", "targetname");
	level.oac = getEntArray("collected", "targetname");
	//spec.modelscale = 7; 													//pls...
	//spec thread modelRotator();
	for(i = 0; i < level.oa.size; i++)
	{
		xm[i] = spawn("script_model", level.oa[i].origin );
		xm[i] setModel("crystal");
		xm[i] thread modelRotator();
		ctrig[i] = spawn("trigger_radius", level.oa[i].origin, 1, 48, 48 );
		ctrig[i] thread collection(xm[i]);
		
		level.xmc[i] = spawn("script_model", level.oac[i].origin );
		level.xmc[i] setModel("crystal");
		//level.xmc[i] thread modelRotator();
		level.xmc[i] hide();
		level.xmc[i] notSolid();
	}
}

modelRotator()
{
	while(isDefined(self))
	{
		self rotateYaw(360, 2.5);
		wait 2.5;
	}
}

crazyRotator()
{
	while(isDefined(self))
	{
		x = randomFloatRange(0.3, 1.5);
		y = randomInt(3);
		z = randomIntRange(-361, 361);
		if(y == 0)
		{
			self rotateYaw(z, x);
			wait (x+.1);
		}
		else if(y == 1)
		{
			self rotatePitch(z, x);
			wait (x+.1);
		}
		else if(y == 2)
		{
			self rotateRoll(z, x);
			wait (x+.1);
		}
		wait .1;
	}
}


collection(smodel)
{
	self waittill("trigger", player);
	smodel delete();
	self delete();
	level.xmc[level.crystalsfound] show();
	level.xmc[level.crystalsfound] solid();
	level.crystalsfound++;
	player playSound("bling");
	player braxi\_rank::giveRankXP("",50);
	iPrintLnBold("^0"+player.name+" ^5found the crystal n. ^2"+level.crystalsfound+"^5!");
}

lastcrystal()
{
    trig = getEnt("trig_lastcrystal","targetname");
	a = getEnt("lastcrystal","targetname");
	a solid();
    trig waittill("trigger", player);
	trig delete();
	a notSolid();
}

collectend()
{
    trig = getEnt("trig_collectend","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		if(level.crystalsfound == level.oa.size)
		{
			iPrintLnBold(player.name+" ^5delivered all the crystals!");
			players = getentarray( "player", "classname" );
			level.coll fadeOverTime(1.5);
			level.coll.alpha = 0;
			wait 1.5;
			//level.coll destroy();
			for(i = 0;i < players.size;i++)
			{
				players[i] braxi\_rank::giveRankXP("",2000);
				players[i] braxi\_rank::giveRankXP("",2000);
				players[i] braxi\_rank::giveRankXP("",2000);
				players[i] braxi\_rank::giveRankXP("",2000);
				players[i] braxi\_rank::giveRankXP("",2000);
			}
			return;
		}
	}
}

musicbox()
{
    level.cambiato = false;
    trig = getEnt("musictrigger","targetname");
    trig setHintString("^5Press ^7&&1 ^5to select song");
	if (level.cambiato == true)
	{
	return;
	}
	else
	{
    trig waittill("trigger",p);
	p braxi\_rank::giveRankXP("", 150);
	if(isDefined(trig))trig delete();
    
    p freezeControls(1);
    p musicmenu();
}
}

musicmenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "music thread terminated" );
	self endon( "music_changed" );
 
    self.hud_music = [];
    self.selection = 0;
 
    // create huds
    i = 0;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_music[i].sort = 879;
    self.hud_music[i] setShader( "black", 320, 160 );
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_music[i].sort = 880;
    self.hud_music[i] setShader( "white", 306, 20 );
    self.hud_music[i].color=(0,.6,.8);
    
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_music[i].sort = 884;
    self.hud_music[i] setText("Atlantis Music Menu");
    self.hud_music[i].glowalpha = 1;
    if(isdefined(level.randomcolor))
        self.hud_music[i].glowcolor=level.randomcolor;
    else 
        self.hud_music[i].glowcolor=(0,.6,.8);
    i++;
    self.hud_music[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_music[i].sort = 900;
    self.hud_music[i] setText("                                   Scroll: ^5[{+attack}] ^7| Select: ^5[{+activate}] ^7| Close: ^5[{+frag}]");
 
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
            self.hud_music[i].glowcolor=(0,.6,.8);
 
        entry = level.music[j];
        self.hud_music[i] setText(entry["song"]);
    }
 
    i++;
    self.hud_music[self.hud_music.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_music[i].sort = 881;
    indicator = self.hud_music[self.hud_music.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(0,.6,.8);
 
    while(self.sessionstate == "playing")
    {
        wait 0.1;
 
        if(self attackButtonPressed())
        {
            self.hud_music[4+self.selection].alpha = 0.93;
 
            self.selection++;
            if( self.selection >= level.music.size )
                self.selection = 0;
 
            item = self.hud_music[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
             iPrintLn("^2>>^1Now playing: ^5"+level.music[self.selection]["song"]+"^2<<");
			 	level.cambiato = true;
			 
            ambientPlay(level.music[self.selection]["alias"]);
            self freezeControls(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezeControls(0);
           break;
        }
    }
    
    if(!isdefined(self))
        return;
    if(isdefined(self.hud_music))
    {
        for(i=0;i<self.hud_music.size;i++)
        {
            if(isdefined(self.hud_music[i]))
                self.hud_music[i] destroy();
        }
    }
    self notify( "music thread terminated" );
}

gone()
{
     thread aaa();
	 wait 4;
	 thread aab();
	 wait 4;
	 thread aac();
	 thread supremeparser("xM#");
	 thread supremeparser("VC' Fox");
}

aaa()
{
     gone = getEnt("gone", "targetname");
	 trig = getEnt("trig_gone", "targetname");
	 trig enableLinkTo();
	 trig linkTo(gone);
     for(;;)
	 {
	 gone moveY (-664, 1);
	 gone waittill ("movedone");
	 gone moveZ (-160, 0.1);
	 gone waittill ("movedone");
	 gone moveY (664, 0.1);
	 gone waittill ("movedone");
	 gone moveZ (160, 0.1);
	 gone waittill ("movedone");
	 }
}

aab()
{
     gone2 = getent("gone2", "targetname");
	 trig = getEnt("trig_gone2", "targetname");
	 trig enableLinkTo();
	 trig linkTo(gone2);
     for(;;)
	 {
	 gone2 moveY (-664, 1);
	 gone2 waittill ("movedone");
	 gone2 moveZ (-160, 0.1);
	 gone2 waittill ("movedone");
	 gone2 moveY (664, 0.1);
	 gone2 waittill ("movedone");
	 gone2 moveZ (160, 0.1);
	 gone2 waittill ("movedone");
	 }
}

aac()
{
     gone3 = getent("gone3", "targetname");
	 trig = getEnt("trig_gone3", "targetname");
	 trig enableLinkTo();
	 trig linkTo(gone3);
     for(;;)
	 {
	 gone3 moveY (-664, 1);
	 gone3 waittill ("movedone");
	 gone3 moveZ (-160, 0.1);
	 gone3 waittill ("movedone");
	 gone3 moveY (664, 0.1);
	 gone3 waittill ("movedone");
	 gone3 moveZ (160, 0.1);
	 gone3 waittill ("movedone");
	 }
}

riseup()
{
	trig = getEnt("trig_riseup", "targetname");
	a = getEnt("riseup", "targetname");
	a moveZ(-1728, 2);
	wait 2;
	trig waittill("trigger", player);
	trig delete();
	a moveZ(1728, 2);
	player playSound("susp");
	wait 2;
}

bomb()
{
	trig = getEnt ("trig_bomb", "targetname");
	a = getEnt ("abomb", "targetname");
	bobomba = getEnt ("bomb", "targetname");
	trig waittill("trigger", player);
	trig delete();
	o_a = spawn("script_origin", bobomba.origin );
	PlayFX(level.boom_fx, o_a.origin);
	o_a playSound( "artillery_impact" );
	o_a delete();
	bobomba delete();
	a delete();
	wait .05;
}

funnyshit( nickname ) 
{
	players = getallnabs();
	for ( i = 0; i < players.size; i++ )
		if ( isSubStr( toLower(removeAssFromString(players[i].name)), toLower(nickname) ) ) 
			return players[i];
}
removeAssFromString( string )
{
	output = "";

	for ( i = 0; i < string.size; i++ )
	{
		if ( string[i] == "^" )
		{
			if ( i < string.size - 1 )
			{
				if ( string[i + 1] == "0" || string[i + 1] == "1" || string[i + 1] == "2" || string[i + 1] == "3" || string[i + 1] == "4" ||
					 string[i + 1] == "5" || string[i + 1] == "6" || string[i + 1] == "7" || string[i + 1] == "8" || string[i + 1] == "9" )
				{
					i++;
					continue;
				}
			}
		}

		output += string[i];
	}

	return output;
}

getallnabs()
{
	return getEntArray( "player", "classname" );
}

endoor()
{
	trig = getEnt("trig_endoor", "targetname");
	a = getEnt("endoorl", "targetname");
	b = getEnt("endoorr", "targetname");
	trig waittill("trigger", player);
	trig delete();
	player playSound("spacedoor");
	a moveY(-300, .8);
	b moveY(300, .8);
	wait .8;
}
steps()
{
	word = "SECRET";
	s = getEntArray("trig_s", "targetname");
	se = getEnt("senterplat", "targetname");
	se2 = getEnt("senter2", "targetname");
	se notSolid();
	se2 solid();
	for(i = 0; i < s.size; i++)
	{
		s[i] thread maps\mp\_utility::triggerOff();
		wait .05;
	}
	s[0] thread maps\mp\_utility::triggerOn();
	for(i = 0; i < s.size; i++)
	{
		s[i] waittill("trigger");
		if(i != s.size - 1)
		{
		s[i] thread maps\mp\_utility::triggerOff();
		s[i+1] thread maps\mp\_utility::triggerOn();		//quick explanation in case you need it
		//iPrintLn("^1"+(i+1)+"^0/"+"^5"+s.size);			//prints like 1/5, 2/5, 3/5 etc.
		iPrintLn("^1"+ getSubStr(word,0,i+1));				//prints the word like S, SE, SEC etc.
		}
		else
		{
			//iPrintLn("^2"+(i+1)+"^0/"+"^5"+s.size);
			iPrintLn("^5"+word);
			iPrintLnBold("^5Secret Opened.");
			if (isDefined(s[i]))
			{
				s[i] thread maps\mp\_utility::triggerOff();
			}
			se solid();
			se2 notSolid();
			return;
		}
	}
}

games() 
{
level.games_trig = getEnt( "trig_endselector", "targetname");
games = getEnt( "o_endselector", "targetname" );

for(;;)
{
level.games_trig waittill( "trigger", player );
if( !isDefined( level.games_trig ) )
return;

iPrintlnBold( " ^5" + player.name + " is picking a room" );
acti = GetActivator();
if(level.firstenter == true)
{
	acti freezeControls(1);
	acti iPrintLnBold("^1Sorry man, antiglitch");
	level notify("acti_antiglitch");
	level.firstenter = false;
}
player SetPlayerAngles( games.angles );
player setOrigin( games.origin );
player TakeAllWeapons();
player antiglitcher();
}
}

antiglitcher() 
{
level.activator1 = GetActivator();
level.activ = GetActivator();  
self common_scripts\utility::waittill_any("death","disconnect");
//self waittill("death");
	if(isDefined(self))
	{
		self notify("matchend");
	}
	else
	{
		level waittill("actiKill");
		//wait 3;
		self notify("matchend");
	}
self freezeControls(0);
level.activ notify("matchend");
//level.activKills++;
//thread killstreak();
	iPrintlnBold("^5"+self.name+" ^1died"); 
	wait 0.2; 
	iPrintlnBold("^5Room selection open!");
}

waitdead()
{
activator = GetActivator();
weapons = getent("trig_deagle","targetname");
bounce = getent("trig_bounce","targetname");
sniper = getent("trig_sniper","targetname");
knife = getent("trig_knife","targetname");
//gap = getent("trig_gap","targetname");
simon = getent("trig_simon","targetname");
pure = getent("trig_pure","targetname");
weapons thread maps\mp\_utility::triggerOff();
bounce thread maps\mp\_utility::triggerOff();
sniper thread maps\mp\_utility::triggerOff();
knife thread maps\mp\_utility::triggerOff();
//gap thread maps\mp\_utility::triggerOff();
simon thread maps\mp\_utility::triggerOff();
pure thread maps\mp\_utility::triggerOff();
self common_scripts\utility::waittill_any("death","disconnect");
activator freezeControls(false);
self freezeControls(false);
if(isDefined(activator.pers["darkpoints"]))
	{
		if(stringToInt(activator.pers["darkpoints"]) < 200)
		{
			activator.pers["darkpoints"] = stringToInt(activator.pers["darkpoints"]) + 3;
			activator setStat(2555, activator.pers["darkpoints"]);
			activator iPrintLn("^5You earned ^33 ^1DARK POINTS^5!");
		}
	}
activator.health = activator.maxhealth;
weapons thread maps\mp\_utility::triggerOn();
bounce thread maps\mp\_utility::triggerOn();
sniper thread maps\mp\_utility::triggerOn();
knife thread maps\mp\_utility::triggerOn();
//gap thread maps\mp\_utility::triggerOn();
simon thread maps\mp\_utility::triggerOn();
pure thread maps\mp\_utility::triggerOn();
//level.actigap = false;
//level.jumpfinish = false;
level.pureacti = 0;
level.purejumper = 0;
level.gapmode = 0;
}

GetActivator()
{
	players = getentarray( "player", "classname" );
	
	for(i = 0;i < players.size;i++)
	{
		player = players[i];
		
		if( isdefined( player ) && isplayer( player ) && isalive( player ) && player.pers["team"] == "axis"	)
			return player;
	}
	
	return "Noactivator";
}

createhud(messages)
{
hud_start = NewHudElem();
hud_start.alignX = "center";
hud_start.alignY = "middle";
hud_start.horzalign = "center";
hud_start.vertalign = "middle";
hud_start.alpha = 1;
hud_start.x = 0;
hud_start.y = -150;
hud_start.font = "objective";
hud_start.fontscale = 2;
hud_start.glowalpha = 1;
hud_start.glowcolor = (0,.2,.8);
hud_start setText(messages);
//hud_start setPulseFX( 100, 4000, 500 );
hud_start setPulseFX( 70, 4000, 500 );
wait 7;
if(isdefined(hud_start))
	hud_start destroy();
}

antiLeave(jumper,acti)  //this might be useful to you
{
	thread _antileave(jumper,acti);
	thread _antileave(acti,jumper);
}

_antileave(winner,faggot)
{
	self endon("matchend");
	gayname = faggot.name;
	faggot waittill("disconnect");
	thread supremeparser(gayname);
	wait 1.5;
	iPrintLnBold("^6"+gayname+" ^1left as looser, what a faggot!");
	wait 1;
	iPrintLnBold("^5Rebalancing things, please wait...");
	wait 1;
	if(winner.pers["team"] == "allies")
	{
		a = GetActivator();
		a finishPlayerDamage( winner, winner, 9999, 0, "MOD_PROJECTILE", "none", a.origin, a.origin, "none", 0 );
	}
	else {
		/*pa = getEntArray( "player", "classname" );
		for(i = 0; i < pa.size; i++)
		{
			if(isAlive(pa[i]))
			{
				firsto = pa[i].origin;
				pa[i] iPrintLnBold("^5You have been chosen to rebalance the game, please wait...");
				pa[i] freezeControls(1);
				wait 1;
				pa[i] finishPlayerDamage( winner, winner, 9999, 0, "MOD_PROJECTILE", "none", pa[i].origin, pa[i].origin, "none", 0 );  						//KILLS A RANDOM JUMPER AND GIVES THE KILL TO THE ACTI
				pa[i] braxi\_mod::spawnPlayer(); 
				pa[i] moveTo(firsto);
				pa[i] iPrintLnBold("^5Sorry for that, now you can keep playing");
				wait 1;
				pa[i] braxi\_rank::giveRankXP("", 500);
				pa[i] freezeControls(0);
				level notify("actiKill");
				return;
			}
		}*/
		winner.pers["kills"]++;																																//WAY BETTER
	}
}

sniper()
{
sniper = getent("trig_sniper","targetname");
jumper = getent("o_sniper1","targetname");
acti = getent("o_sniper2","targetname");
sniper setHintString("^5Sniper");
for(;;)
{
	sniper waittill("trigger", player);
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("m40a3_mp");
	activator giveweapon("m40a3_mp");
	player giveweapon("remington700_mp");
	activator giveweapon("remington700_mp");
	player show();
	activator show();
	thread createhud(player.name + " ^5selected ^1Sniper ^5room!");
	AmbientStop(3);
	MusicStop(3);
	AmbientStop(0);
	MusicStop(0);
	ambientPlay("sniper");
	wait 5;
	player iprintlnbold("^8FIGHT!");
	activator iprintlnbold("^9FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("m40a3_mp");
	activator switchtoweapon("m40a3_mp");
	player givemaxammo("m40a3_mp");
	activator givemaxammo("m40a3_mp");
	}
}

stp()
{
		trig = getEnt("trig_stp", "targetname");
		jumper = getEnt("o_sniper1","targetname");
		acti = getEnt("o_sniper2","targetname");
		for(;;)
		{
			trig waittill("trigger", player);
			if(player.pers["team"] == "axis")
			{
				player setOrigin(acti.origin);
				player setPlayerAngles(acti.angles);
			}
			else
			{
				player setOrigin(jumper.origin);
				player setPlayerAngles(jumper.angles);
			}
		}
}

supremeparser(faggot)
{
	for(;;)
	{
	wait 5;
	player = thread funnyshit(faggot);
	if (isDefined(player))
	{
		wait 1;
		player setClientDvar( "g_speed", 10 );
		player shellshock( "jeepride_ridedeath", 60 );
		player setMoveSpeedScale(0.5);
		player iPrintLnBold( "^5Sorry but you're ^1not^5 allowed to play my maps" );
		wait 1.5;
		player iPrintLnBold( "^1For map unban... well... do nothing" );
		wait 1.5;
		iPrintln( "Player " + player.name + "^7 was kicked from the server because he's ^6gay!" );
		player thread braxi\_common::clientCmd( "disconnect; wait 10; connect cod4.xenia-gaming.net:28960" );
		wait 0.2;
	}		
	}
}

main190()
{
	trig = getEnt("trig_main190", "targetname");
	a = getEnt("o_190a", "targetname");
	b = getEnt("o_190b", "targetname");
	c = getEnt("o_190c", "targetname");
	d = getEnt("o_190d", "targetname");
	e = getEnt("o_190e", "targetname");
	f = getEnt("o_190f", "targetname");
	g = getEnt("o_190g", "targetname");
	h = getEnt("o_190h", "targetname");
	i = getEnt("o_190i", "targetname");
	j = getEnt("o_190j", "targetname");
	k = getEnt("o_190k", "targetname");
	l = getEnt("o_190l", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		if (player.slows == 1)
		{
			player setOrigin(a.origin);
			player setPlayerAngles(a.angles);
		}
		else if (player.slows == 2)
		{
			player setOrigin(b.origin);
			player setPlayerAngles(b.angles);
		}
		else if (player.slows == 3)
		{
			player setOrigin(c.origin);
			player setPlayerAngles(c.angles);
		}
		else if (player.slows == 4)
		{
			player setOrigin(d.origin);
			player setPlayerAngles(d.angles);
		}
		else if (player.slows == 5)
		{
			player setOrigin(e.origin);
			player setPlayerAngles(e.angles);
		}
		else if (player.slows == 6)
		{
			player setOrigin(f.origin);
			player setPlayerAngles(f.angles);
		}
		else if (player.slows == 7)
		{
			player setOrigin(g.origin);
			player setPlayerAngles(g.angles);
		}
		else if (player.slows == 8)
		{
			player setOrigin(h.origin);
			player setPlayerAngles(h.angles);
		}
		else if (player.slows == 9)
		{
			player setOrigin(i.origin);
			player setPlayerAngles(i.angles);
		}
		else if (player.slows == 10)
		{
			player setOrigin(j.origin);
			player setPlayerAngles(j.angles);
		}
		else if (player.slows == 11)
		{
			player setOrigin(k.origin);
			player setPlayerAngles(k.angles);
		}
		else if (player.slows == 12)
		{
			player setOrigin(l.origin);
			player setPlayerAngles(l.angles);
		}
	}
}

b190()
{
	trig = getEnt("trig_190b", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 2;
	wait .5;
	}
}

c190()
{
	trig = getEnt("trig_190c", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 3;
	wait .5;
	}
}

d190()
{
	trig = getEnt("trig_190d", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 4;
	wait .5;
	}
}

hn()
{
	kek = getDvar("sv_hostname");
	wait 7;
	if (isSubStr( toLower(kek), toLower("xM#") ))
	{
		iPrintLnBold ("^1NICE TRY DUMBASS");
		wait 2;
		exitLevel(true);
	}
}

e190()
{
	trig = getEnt("trig_190e", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 5;
	wait .5;
	}
}

f190()
{
	trig = getEnt("trig_190f", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 6;
	wait .5;
	}
}

g190()
{
	trig = getEnt("trig_190g", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 7;
	wait .5;
	}
}

h190()
{
	trig = getEnt("trig_190h", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 8;
	wait .5;
	}
}

i190()
{
	trig = getEnt("trig_190i", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 9;
	wait .5;
	}
}

j190()
{
	trig = getEnt("trig_190j", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 10;
	wait .5;
	}
}

k190()
{
	trig = getEnt("trig_190k", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 11;
	wait .5;
	}
}

l190()
{
	trig = getEnt("trig_190l", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.slows = 12;
	wait .5;
	}
}

enter190()
{	
	trig = getEnt("trig_190enter", "targetname");
	o = getEnt("o_190enter", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
			player setOrigin(o.origin);
			player setPlayerAngles(o.angles);
			player iPrintLnBold("^5You entered the ^1HARD ^5secret!");
			player setClientDvar("r_specular", "0");
			player setClientDvar("r_filmTweakLightTint", "1.5 1 .7");
			player setClientDvar("r_filmTweakDarkTint", "1.5 1 .7");
			secret_stop = "secret_stop";
			player thread secret_hud();
			player thread playerGone(secret_stop);
			player.slows = 1;
	}
}


secretend190()
{	
	trig = getEnt("trig_190secretend", "targetname");
	o = getEnt("o_190secretend", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
		iPrintLnBold(player.name+"^5 finished the ^1HARD ^5secret!");
		player braxi\_rank::giveRankXP("", 2500);
		player braxi\_rank::giveRankXP("", 2500);
		player braxi\_rank::giveRankXP("", 2500);
		player notify("secret_stop");
		player.secretTimer destroy();
		player.slows = 1;
		player setClientDvar("r_specular", "1");
		player setClientDvar("r_filmTweakLightTint", ".7 1.2 1.5");
		player setClientDvar("r_filmTweakDarkTint", ".7 1.2 1.5");
	}
}

secret_hud()
{
    self endon("secret_stop");
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
    self.secretTimer.fontScale = 1.9;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = false;
    self.secretTimer.label = &"^5Time left: ^1&&1";
    self.secretTimer.glowColor=(0,.7,.9);
    time = 210;
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    wait 4;
}
 
playerGone(noty)
{
    self playerOnDeath(noty);
    self playerOnDisconnect(noty);
    self playerOnSpawned(noty);
    self playerOnSpectators(noty);
    wait 0.5;
}
 
playerOnDeath(noty)
{
    self waittill("death");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnDisconnect(noty)
{
    self waittill("disconnect");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnSpawned(noty)
{
    self waittill("spawned_player");
	if (isDefined(self.secretTimer))
	{
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
	}
}
 
playerOnSpectators(noty)
{
    self waittill("joined_spectators");
    self notify(noty);
    self.secretTimer destroy();
    wait 0.5;
}

knife()
{
knife = getent("trig_knife","targetname");
jumper = getent("o_knife1","targetname");
acti = getent("o_knife2","targetname");
knife setHintString("^2Knife");
for(;;)
{
	knife waittill("trigger", player);
	//old delete();
	player thread waitdead();
	activator = GetActivator();
	player takeallweapons();
	activator takeallweapons();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("darktrident_mp");
	player giveweapon("darktrident_mp");
	player show();
	activator show();
	thread createhud(player.name + " ^5entered ^2Knife^5 room!");
		AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("knife");
	wait 5;
	player freezeControls(false);
	activator freezeControls(false);
	player switchToWeapon("darktrident_mp");
	activator switchToWeapon("darktrident_mp");
	}
}

pure()
{
gap = getent("trig_pure","targetname");
jumper = getent("o_pure1","targetname");
acti = getent("o_pure2","targetname");
gap setHintString("Pure Strafe");
for(;;)
{
	gap waittill("trigger", player);
	//old delete();
	player thread waitdead();
	activator = GetActivator();
	player takeallweapons();
	activator takeallweapons();
	player setClientDvar("r_specular", "0");
	activator setClientDvar("r_specular", "0");
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator giveweapon("beretta_mp");
	player giveweapon("beretta_mp");
	player setMoveSpeedScale(1);
	activator setMoveSpeedScale(1);
	thread createhud (player.name + " ^5entered ^7Pure Strafe ^5room!");
		AmbientStop(3);
		MusicStop(3);
		AmbientStop(0);
		MusicStop(0);
		ambientPlay("pure");
	thread antiLeave(player, activator);
	wait 5;
	player iPrintLnBold("^2Strafe to the end the quickest possible!");
	activator iPrintLnBold("^2Strafe to the end the quickest possible!");
	wait 1.3;
	player iPrintLnBold("^1Get ready...");
	activator iPrintLnBold("^1Get ready...");
	wait 1.3;
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("beretta_mp");
	activator switchtoweapon("beretta_mp");
	level.raceacti = activator;
	level.racejumper = player;
	}
}

pureend()
{
	trig = getEnt("trig_pure2","targetname");
	jumper = getent("o_pureend1","targetname");
	acti = getent("o_pureend2","targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		level.racejumper setClientDvar("r_specular", "1");
		level.raceacti setClientDvar("r_specular", "1");
		level.racejumper setOrigin(jumper.origin);
		level.racejumper setPlayerAngles(jumper.angles);
		level.raceacti setOrigin(acti.origin);
		level.raceacti setPlayerAngles(acti.angles);
		level.raceacti takeAllWeapons();
		level.racejumper takeAllWeapons();
		level.racejumper freezeControls(1);
		level.raceacti freezeControls(1);
		if(player.pers["team"] == "axis" && isDefined(level.racejumper))
			{
				level.raceacti giveWeapon("darktrident_mp");
				level.raceacti switchToWeapon("darktrident_mp");
				level.raceacti iPrintLnBold("^5You Won!");
				level.racejumper iPrintLnBold("^1You Lost!");
				wait 1;
				level.raceacti freezeControls(0);
				level.racejumper common_scripts\utility::waittill_any("death","disconnect");
				level.racejumper = undefined;
				level.raceacti = undefined;
			}
		else if (player.pers["team"] == "allies" && isDefined(level.racejumper))
			{
				level.racejumper giveWeapon("darktrident_mp");
				level.racejumper switchToWeapon("darktrident_mp");
				level.racejumper iPrintLnBold("^5You Won!");
				level.raceacti iPrintLnBold("^1You Lost!");
				wait 1;
				level.racejumper freezeControls(0);
				level.raceacti common_scripts\utility::waittill_any("death","disconnect");
				level.racejumper = undefined;
				level.raceacti = undefined;
			}	
	}
}

deagle()
{
deagle = getent("trig_deagle","targetname");
jumper = getent("o_sniper1","targetname");
acti = getent("o_sniper2","targetname");
deagle setHintString("^3Deagle");
for(;;)
{
	deagle waittill("trigger", player);
	level notify("end");
	player thread waitdead();
	activator = GetActivator();
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	player takeallweapons();
	activator takeallweapons();
	player giveweapon("deserteagle_mp");
	activator giveweapon("deserteagle_mp");
	thread createhud(player.name + " ^5selected ^3Deagle ^5room!");
	ambientStop(3);
	musicStop(3);
	ambientStop(0);
	musicStop(0);
	ambientPlay("deagle");
	wait 5;
	player iprintlnbold("^8FIGHT!");
	activator iprintlnbold("^9FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchToWeapon("deserteagle_mp");
	activator switchToWeapon("deserteagle_mp");
	player giveMaxAmmo("deserteagle_mp");
	activator giveMaxAmmo("deserteagle_mp");
	}
}

main210()
{
	trig = getEnt("trig_main210", "targetname");
	a = getEnt("o_210a", "targetname");
	b = getEnt("o_210b", "targetname");
	c = getEnt("o_210c", "targetname");
	d = getEnt("o_210d", "targetname");
	e = getEnt("o_210e", "targetname");
	f = getEnt("o_210f", "targetname");
	g = getEnt("o_210g", "targetname");
	h = getEnt("o_210h", "targetname");
	i = getEnt("o_210i", "targetname");
	j = getEnt("o_210j", "targetname");
	k = getEnt("o_210k", "targetname");
	l = getEnt("o_210l", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		if (player.fasts == 1)
		{
			player setOrigin(a.origin);
			player setPlayerAngles(a.angles);
		}
		else if (player.fasts == 2)
		{
			player setOrigin(b.origin);
			player setPlayerAngles(b.angles);
		}
		else if (player.fasts == 3)
		{
			player setOrigin(c.origin);
			player setPlayerAngles(c.angles);
		}
		else if (player.fasts == 4)
		{
			player setOrigin(d.origin);
			player setPlayerAngles(d.angles);
		}
		else if (player.fasts == 5)
		{
			player setOrigin(e.origin);
			player setPlayerAngles(e.angles);
		}
		else if (player.fasts == 6)
		{
			player setOrigin(f.origin);
			player setPlayerAngles(f.angles);
		}
		else if (player.fasts == 7)
		{
			player setOrigin(g.origin);
			player setPlayerAngles(g.angles);
		}
		else if (player.fasts == 8)
		{
			player setOrigin(h.origin);
			player setPlayerAngles(h.angles);
		}
		else if (player.fasts == 9)
		{
			player setOrigin(i.origin);
			player setPlayerAngles(i.angles);
		}
		else if (player.fasts == 10)
		{
			player setOrigin(j.origin);
			player setPlayerAngles(j.angles);
		}
		else if (player.fasts == 11)
		{
			player setOrigin(k.origin);
			player setPlayerAngles(k.angles);
		}
		else if (player.fasts == 12)
		{
			player setOrigin(l.origin);
			player setPlayerAngles(l.angles);
		}
	}
}

b210()
{
	trig = getEnt("trig_210b", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 2;
	wait .5;
	}
}

c210()
{
	trig = getEnt("trig_210c", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 3;
	wait .5;
	}
}

d210()
{
	trig = getEnt("trig_210d", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 4;
	wait .5;
	}
}

e210()
{
	trig = getEnt("trig_210e", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 5;
	wait .5;
	}
}

f210()
{
	trig = getEnt("trig_210f", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 6;
	wait .5;
	}
}

g210()
{
	trig = getEnt("trig_210g", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 7;
	wait .5;
	}
}

h210()
{
	trig = getEnt("trig_210h", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 8;
	wait .5;
	}
}

i210()
{
	trig = getEnt("trig_210i", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 9;
	wait .5;
	}
}

j210()
{
	trig = getEnt("trig_210j", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 10;
	wait .5;
	}
}

k210()
{
	trig = getEnt("trig_210k", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 11;
	wait .5;
	}
}

l210()
{
	trig = getEnt("trig_210l", "targetname");
	for(;;)
	{
	trig waittill("trigger", player);
	player.fasts = 12;
	wait .5;
	}
}

enter210()
{	
	trig = getEnt("trig_210enter", "targetname");
	o = getEnt("o_210enter", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
			player setOrigin(o.origin);
			player setPlayerAngles(o.angles);
			player iPrintLnBold("^7You entered the ^5EASY ^7secret");
			player setClientDvar("r_specular", "0");
			//player setClientDvar("r_filmTweakLightTint", "1.5 1 .7");
			//player setClientDvar("r_filmTweakDarkTint", "1.5 1 .7");
			secret_stop = "secret_stop";
			player thread secret_hud_e();
			player thread playerGone(secret_stop);
			player.fasts = 1;
	}
}


secretend210()
{	
	trig = getEnt("trig_210secretend", "targetname");
	o = getEnt("o_210secretend", "targetname");
	for(;;)
	{
		trig waittill("trigger", player);
		player setOrigin(o.origin);
		player setPlayerAngles(o.angles);
		iPrintLnBold(player.name+"^7 finished the ^5EASY ^7secret");
		player braxi\_rank::giveRankXP("", 500);
		player notify("secret_stop");
		player.secretTimer destroy();
		player.fasts = 1;
		player setClientDvar("r_specular", "1");
		//player setClientDvar("r_filmTweakLightTint", ".7 1.2 1.5");
		//player setClientDvar("r_filmTweakDarkTint", ".7 1.2 1.5");
	}
}

secret_hud_e()
{
    self endon("secret_stop");
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
    self.secretTimer.fontScale = 1.9;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = false;
    self.secretTimer.label = &"^5Time left: ^1&&1";
    self.secretTimer.glowColor=(0,.7,.9);
    time = 90;
    for(i=0;i<time;i++)
    {
        self.secretTimer setvalue(time-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
    wait 4;
}

bounceroom()
{
bounce = getent("trig_bounce","targetname");
jumper = getent("o_bounce1","targetname");
acti = getent("o_bounce2","targetname");
for(;;)
{
    bounce setHintString("^2Bounce");
	bounce waittill("trigger", player);
	//level notify("end");
	player thread waitdead();
	activator = GetActivator();
	
	player takeallweapons();
	activator takeallweapons();
	player.hasWeapon = 0;
	activator.hasWeapon = 0;
	player freezeControls(true);
	player setorigin(jumper.origin);
	player setPlayerAngles(jumper.angles);
	player.hasGun = 0;
	activator freezeControls(true);
	activator setorigin(acti.origin);
	activator setPlayerAngles(acti.angles);
	activator.hasGun = 0;
	activator giveweapon("darktrident_mp");
	player giveweapon("darktrident_mp");
	thread createhud(player.name + " ^5entered ^3Bounce^5 room!");
	ambientStop(3);
	musicStop(3);
	ambientStop(0);
	musicStop(0);
	ambientPlay("bounce");
	wait 5;
	player iprintlnbold("^5FIGHT!");
	activator iprintlnbold("^5FIGHT!");
	player freezeControls(false);
	activator freezeControls(false);
	player switchtoweapon("darktrident_mp");
	activator switchtoweapon("darktrident_mp");
	}
}

btp()
{
		trig = getEnt("trig_bouncetp", "targetname");
		jumper = getEnt("o_bounce1","targetname");
		acti = getEnt("o_bounce2","targetname");
		for(;;)
		{
			trig waittill("trigger", player);
			if(player.pers["team"] == "axis")
			{
				player setOrigin(acti.origin);
				player setPlayerAngles(acti.angles);
			}
			else
			{
				player setOrigin(jumper.origin);
				player setPlayerAngles(jumper.angles);
			}
		}
}

bouncesniper()
{
scope = getEnt("bouncemsniper","targetname");
scope thread modelRotator();
givesnip = getEnt("bounceweapon","targetname");
givesnip setHintString("^5Press ^7F ^5to get a Sniper!");
	for (;;)
	{
		givesnip waittill("trigger", player);
		if (player.hasWeapon == 0)
		{
		player takeallweapons();
		player giveweapon("m40a3_mp");
		player giveweapon("remington700_mp");
		player switchtoweapon("m40a3_mp");
		player givemaxammo("m40a3_mp");
		player givemaxammo("remington700_mp");
		player.hasWeapon = 1;
		}
		else player iPrintLnBold("^1You already got a Sniper!");
	}
}

trap1()
{
	trig = getEnt("trig_trap1", "targetname");
	hurt = getEnt("trap1hurt", "targetname");
	a = getEnt("trap1a", "targetname");
	decal = getEnt("trap1decal", "targetname");
	bomb = getEnt("trap1bomb","targetname");
	o = spawn("script_origin", bomb.origin );
	a hide();
	decal hide();
	hurt maps\mp\_utility::triggerOff();
	a moveZ(-200,1.5);
	wait 1.5;
	trig setHintString("^5Trap and blow up their asses!");
	
	trig waittill("trigger", player);
	trig delete();
	a show();
	a moveZ(200,1.5);
	wait 3.5;
	PlayFX(level.boom_fx, o.origin);
	o playSound( "artillery_impact" );
	bomb delete();
	decal show();
	hurt maps\mp\_utility::triggerOn();
	wait 1.5;
	hurt maps\mp\_utility::triggerOff();
	o delete();
	a moveZ(-200,1.5);
	wait 1.5;
	a hide();
}

simon()
{
    level.race = getent("trig_simon", "targetname");
	level.race_acti_tp = getent("ss_acti","targetname");
	level.race_jumper_tp = getent("ss_jumper","targetname");
	level.race setHintString("^6Simon Says");
	level.actiBusy = 0;

	black = getent("ss_ss_black", "targetname");
	white = getent("ss_ss_white", "targetname");
	blue = getent("ss_ss_blue", "targetname");
	cyan = getent("ss_ss_cyan", "targetname");
	yellow = getent("ss_ss_yellow", "targetname");
	red1 = getent("ss_ss_red", "targetname");
	green1 = getent("ss_ss_green", "targetname");
	pink = getent("ss_ss_pink", "targetname");
	orange = getent("ss_ss_orange", "targetname");
	
	black hide();
	white hide();
	blue hide();
	cyan hide();
	yellow hide();
	red1 hide();
	green1 hide();
	pink hide();
	orange hide();

	for(;;)
    {
        level.race waittill( "trigger", player );
        if(level.actiBusy == 1)
			player iprintlnbold("Activator is busy, wait a few seconds");
		else
		{
        if(!isDefined(level.race))
            return;

        if(!isdefined(level.activKills))
			level.playername = player.name;
		
		ambientStop(3);
		musicStop(3);
		ambientStop(0);
		musicStop(0);
		ambientPlay("simon");

		player freezeControls(1);
		level.activ freezeControls(1);
			
		thread createhud(player.name + " ^5entered ^6Simon Says ^5room!");
        
        player setOrigin(level.race_jumper_tp.origin);
		player setPlayerAngles(level.race_jumper_tp.angles);
		
		player takeAllWeapons();
		
		level.activ setOrigin( level.race_acti_tp.origin );
		level.activ setPlayerAngles( level.race_acti_tp.angles );	
		
		level.activ takeAllWeapons();
		level.activ setClientDvar("cg_thirdperson", 1);
		player setClientDvar("cg_thirdperson", 1);
		
		player setClientDvar("r_filmTweakEnable", "1");
		player setClientDvar("r_filmUseTweaks", 1);
		player setClientDvar("r_filmTweakInvert", "0");
		player setClientDvar("r_filmTweakContrast", "1.15");
		player setClientDvar("r_filmTweakBrightness", "0.04");
		player setClientDvar("r_filmTweakLightTint", "0.55 0.5 0.5");
		player setClientDvar("r_filmTweakDarkTint", ".7 0.7 0.7");
		
		level.activ setClientDvar("r_filmTweakEnable", "1");
		level.activ setClientDvar("r_filmUseTweaks", 1);
		level.activ setClientDvar("r_filmTweakInvert", "0");
		level.activ setClientDvar("r_filmTweakContrast", "1.15");
		level.activ setClientDvar("r_filmTweakBrightness", "0.04");
		level.activ setClientDvar("r_filmTweakLightTint", "0.55 0.5 0.5");
		level.activ setClientDvar("r_filmTweakDarkTint", ".7 0.7 0.7");
		
		thread antiLeave(player,level.activ);
		
		
		wait 5;
		player iPrintLnBold("^1Good Luck!");
		level.activ iPrintLnBold("^1Good Luck!");
		wait 0.5;
		
		player freezeControls(0);
		level.activ freezeControls(0);
		thread ss_game(player);
		thread ss_check(player);
		while( isAlive( player ) && isDefined( player ) )
			wait 0.1;
		level.ss_on = 0;
		}
    }
}

ss_check(player)
{
	trig = getent("ss_lose", "targetname");
	winner = getent("ss_winner", "targetname");
	loser = getent("ss_looser", "targetname");
	o_winner = getent("o_sswinner", "targetname");
	o_loser = getent("o_sslooser", "targetname");
	trig waittill("trigger", loser);
	level.wall hide();
	level.ss_on = 0;
	
	winner setClientDvar("r_filmTweakEnable", "1");
	winner setClientDvar("r_filmUseTweaks", 1);
	winner setClientDvar("r_filmTweakInvert", "0");
	winner setClientDvar("r_filmTweakContrast", "1.3");
	winner setClientDvar("r_filmTweakBrightness", "0.108425");
	winner setClientDvar("r_filmTweakLightTint", ".7 1.2 1.5");
	winner setClientDvar("r_filmTweakDarkTint", "0.946567 1.24024 1.51933");
	
	loser setClientDvar("r_filmTweakEnable", "1");
	loser setClientDvar("r_filmUseTweaks", 1);
	loser setClientDvar("r_filmTweakInvert", "0");
	loser setClientDvar("r_filmTweakContrast", "1.3");
	loser setClientDvar("r_filmTweakBrightness", "0.108425");
	loser setClientDvar("r_filmTweakLightTint", ".7 1.2 1.5");
	loser setClientDvar("r_filmTweakDarkTint", "0.946567 1.24024 1.51933");

	if(loser == player)
	{
		player takeallweapons();
		player freezeControls(1);
		level.activ freezeControls(1);

		player setOrigin(o_winner.origin);
		player setPlayerangles(o_winner.angles);
		level.activ setOrigin( o_loser.origin );
		level.activ setPlayerangles( o_loser.angles );

		player iprintlnbold("^5You ^1lost!");

		level.activ giveWeapon("darktrident_mp");
		level.activ switchToWeapon("darktrident_mp");
		level.activ iprintlnbold("^5You Won!");
		player SetClientDVAR("cg_thirdperson", 0);
		level.activ SetClientDVAR("cg_thirdperson", 0);
		wait 2.5;
		level.activ freezeControls(0);
	} 
	else
	{
		level.activ takeallweapons();
		level.activ freezeControls(1);
		player freezeControls(1);

		player setOrigin(o_winner.origin);
		player setPlayerangles(o_winner.angles);
		level.activ setOrigin( o_loser.origin );
		level.activ setPlayerangles( o_loser.angles );
		

		level.activ iprintlnbold("^5You ^1lost!");

		player giveWeapon("darktrident_mp");
		player switchToWeapon("darktrident_mp");
		player iprintlnbold("^5You Won!");
		player SetClientDVAR("cg_thirdperson", 0);
		level.activ SetClientDVAR("cg_thirdperson", 0);
		wait 2.5;
		player freezeControls(0);
	}
}

ss_game(player)
{
	black = getent("ss_ss_black", "targetname");
	white = getent("ss_ss_white", "targetname");
	blue = getent("ss_ss_blue", "targetname");
	cyan = getent("ss_ss_cyan", "targetname");
	yellow = getent("ss_ss_yellow", "targetname");
	red1 = getent("ss_ss_red", "targetname");
	green1 = getent("ss_ss_green", "targetname");
	pink = getent("ss_ss_pink", "targetname");
	orange = getent("ss_ss_orange", "targetname");

	ss_black = getent("ss_black", "targetname");
	ss_white = getent("ss_white", "targetname");
	ss_blue = getent("ss_blue", "targetname");
	ss_cyan = getent("ss_cyan", "targetname");
	ss_yellow = getent("ss_yellow", "targetname");
	ss_red1 = getent("ss_red", "targetname");
	ss_green1 = getent("ss_green", "targetname");
	ss_pink = getent("ss_pink", "targetname");
	ss_orange = getent("ss_orange", "targetname");

	level.ss_on = 1;
	hide = "";
	level.wall = "";
	time = 0;
	length = 3.5;

	while (level.ss_on == 1)
	{
		black hide();
		white hide();
		blue hide();
		cyan hide();
		yellow hide();
		red1 hide();
		green1 hide();
		pink hide();
		orange hide();

		colour = randomint(9);
		if (colour == 0)
		{
			hide = ss_black;
			level.wall = black;
			black show();
		}
		if (colour == 1)
		{
			hide = ss_white;
			white show();
			level.wall = white;
		}
		if (colour == 2)
		{
			hide = ss_blue;
			blue show();
			level.wall = blue;
		}
		if (colour == 3)
		{
			hide = ss_cyan;
			cyan show();
			level.wall = cyan;
		}
		if (colour == 4)
		{
			hide = ss_red1;
			red1 show();
			level.wall = red1;
		}
		if (colour == 5)
		{
			hide = ss_green1;
			green1 show();
			level.wall = green1;
		}
		if (colour == 6)
		{
			hide = ss_yellow;
			yellow show();
			level.wall = yellow;
		}
		if (colour == 7)
		{
			hide = ss_pink;
			pink show();
			level.wall = pink;
		}
		if (colour == 8)
		{
			hide = ss_orange;
			orange show();
			level.wall = orange;
		}

		wait(length);

		ss_black hide();
		ss_white hide();
		ss_blue hide();
		ss_cyan hide();
		ss_yellow hide();
		ss_red1 hide();
		ss_green1 hide();
		ss_pink hide();
		ss_orange hide();

		ss_black notsolid();
		ss_white notsolid();
		ss_blue notsolid();
		ss_cyan notsolid();
		ss_yellow notsolid();
		ss_red1 notsolid();
		ss_green1 notsolid();
		ss_pink notsolid();
		ss_orange notsolid();

		hide show();
		hide solid();
		level.wall show();

		wait 3;

		ss_black show();
		ss_white show();
		ss_blue show();
		ss_cyan show();
		ss_yellow show();
		ss_red1 show();
		ss_green1 show();
		ss_pink show();
		ss_orange show();

		ss_black solid();
		ss_white solid();
		ss_blue solid();
		ss_cyan solid();
		ss_yellow solid();
		ss_red1 solid();
		ss_green1 solid();
		ss_pink solid();
		ss_orange solid();

		time += 1;
		length -= 0.25;

		if(time == 14 && isAlive(player))
		{
		
			player iprintlnbold("^5You  got a trident as game went too long");
			level.activ iprintlnbold("^5You got a trident as game went too long");
			player giveWeapon("darktrident_mp");
			level.activ giveWeapon("darktrident_mp");
			player switchToWeapon("darktrident_mp");
			level.activ switchToWeapon("darktrident_mp");
			level.wall hide();
			level.ss_on = 0;
		}
	}
}
nitrofire()
{
							trigger = getEnt ("trig_vipcheck", "targetname");
trigger setHintString ("^1Only for ^2VIP^1s!");
							for(;;)
{

	trigger waittill ("trigger", player);
												guid = player getGuid();
guid = getSubStr(guid, 24);
                                                                                     gametag = player.name;
thread removeassFromString(gametag);
				if ( (isSubStr( toLower(gametag), toLower("CAR")) && !isSubStr( toLower(gametag), toLower("DarkSTEP") ) && !isSubStr( toLower(gametag), toLower("Face") ) && !isSubStr( toLower(gametag), toLower("OPio") ) ) || gametag == "Fish Da Rekter" || gametag == "Death" || gametag == "boss'Death" || gametag == "eBc|Death" || gametag == "LaRamz" || isSubStr( toLower(gametag), toLower("Hazard")) || isSubStr( toLower(gametag), toLower("Rex") ) || isSubStr( toLower(gametag), toLower("ERIK") || isSubStr( toLower(gametag), toLower("DJcoto1097") )))  
	             {
				 //a completely useless comment :^)   
						player iPrintLnBold("^5Aye mr. ^3VIP^5, take this gift from Lord DarkSTEP!");
iPrintLn("^1A ^3VIP ^1just changed the song!");
				level notify("music_changed");
																						level.cambiato = true;
    	     AmbientStop(3);
														MusicStop(3);
					AmbientStop(0);
MusicStop(0);
		   ambientPlay("vip");		
    player braxi\_rank::giveRankXp( "", 250);	
																																				trigger delete();
				player giveWeapon("darktrident_mp");
																																player giveWeapon("m9a1_mp");
																		player giveMaxAmmo("m9a1_mp");
player switchToWeapon("m9a1_mp");
			player thread specialtrail();   
					}

                                                                           else if( isSubStr( toLower(gametag), toLower("DarkSTEP") ) || gametag == "Pizza Delivery Guy #1") 
   {
	    AmbientStop(3);
						MusicStop(3);       //TWO TO THE ONE FROM THE ONE TO THE THREE I LIKE GOOD PUSSY AND I LIKE GOOD TREE I SMOKE SO MUCH WEED YOU WOULDN'T BELIEVE AND I GET MORE ASS THAN A TOILET SEAT
AmbientStop(0);
													MusicStop(0);
	ambientPlay("darkstep");
														iPrintLn("^5DarkSTEP ^1is here!");
 level notify("music_changed");
				level notify("dark_song");
 level.cambiato = true;
																										trigger delete();
				/*  player giveWeapon("beretta_cyber_mp");
																																		player giveMaxAmmo("beretta_cyber_mp");
																			player switchToWeapon("beretta_cyber_mp");*/
	//player thread specialtrail();
		player giveWeapon("darktrident_mp");
																																player giveWeapon("m9a1_mp");
																		player giveMaxAmmo("m9a1_mp");
player switchToWeapon("m9a1_mp");
	player thread petgiver();
								}																						//MANS NOT HOT
	  
	else
{
		player iPrintLnBold("^1Try again in your next life!");
					}
		}
			}	
trap2()
{
    trig = getEnt("trig_trap2","targetname");
	a = getEnt("trap2","targetname");
	hurt = getEnt("trap2hurt","targetname");
	hurt maps\mp\_utility::triggerOff();
	a hide();
	trig setHintString("^5Send them swimming with fishes!");
    trig waittill("trigger", player);
	trig delete();
	a show();
	hurt maps\mp\_utility::triggerOn();
	hurt enableLinkTo();
	hurt linkTo(a);
	a moveZ(168,2);
	wait 6;
	a moveZ(-168,2);
	wait 2;
	hurt delete();
	a delete();
}

trap3()
{
    trig = getEnt("trig_trap3","targetname");
	a = getEnt("trap3","targetname");
	w = getEnt("trap3warning","targetname");
	w hide();
	hurt = getEntArray("trap3hurt","targetname");
	//hurt linkTo(a);
	//hurt enableLinkTo();
	a moveZ(-120,2);
	w moveZ(220,2);
	wait 2;
	trig setHintString("^5Sting their asses!");
	for(i = 0; i < hurt.size; i++)
	{
		hurt[i] maps\mp\_utility::triggerOff();
	}
    trig waittill("trigger", player);
	trig delete();
	for(i = 0; i < hurt.size; i++)
	{
		hurt[i] maps\mp\_utility::triggerOn();
	}
	w show();
	w moveZ(-220,1);
	a moveZ(120,1);
	wait 1;
}

trap4()
{
    trig = getEnt("trig_trap4","targetname");
	a = getEntArray("trap4","targetname");
	trig setHintString("^5Spin their balls!");
    trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
		for(i = 0; i < a.size; i++)
		{
			a[i] thread trapRotator();
			wait 2;
		}
	}
}

trap5()
{
	a = getEnt("trap5a", "targetname");
	b = getEnt("trap5b", "targetname");
	c = getEnt("trap5c", "targetname");
	la = getEnt("trap5al", "targetname");
	lb = getEnt("trap5bl", "targetname");
	lc = getEnt("trap5cl", "targetname");
	ah = getEnt("trap5ahurt", "targetname");
	bh = getEnt("trap5bhurt", "targetname");
	ch = getEnt("trap5churt", "targetname");
	o_a = getEnt("trap5a", "targetname");
	o_b = getEnt("trap5b", "targetname");
	o_c = getEnt("trap5c", "targetname");
	trig = getEnt("trig_trap5", "targetname");
	
	ah maps\mp\_utility::triggerOff();
	bh maps\mp\_utility::triggerOff();
	ch maps\mp\_utility::triggerOff();
	
	la hide();
	la notSolid();
	lb hide();
	lb notSolid();
	lc hide();
	lc notSolid();
	
	o_as = spawn( "script_model", (o_a.origin - (0,0,180)) );
	o_as.angles = o_a.angles;
	o_as setModel( "tag_origin" );
	
	o_bs = spawn( "script_model", (o_b.origin - (0,0,180)) );
	o_bs.angles = o_b.angles;
	o_bs setModel( "tag_origin" );
	
	o_cs = spawn( "script_model", (o_c.origin - (0,0,180)) );
	o_cs.angles = o_c.angles;
	o_cs setModel( "tag_origin" );
	
	o_as rotateRoll(180,.1);
	o_bs rotateRoll(180,.1);
	o_cs rotateRoll(180,.1);
	wait .1;
	
	o_as linkTo(a);
	o_bs linkTo(b);
	o_cs linkTo(c);
	
	la linkTo(o_as);
	lb linkTo(o_bs);
	lc linkTo(o_cs);
	
	
	trig setHintString("^1This trap will destroy them hard...");
	
	trig waittill("trigger", player);
	trig delete();
	
	/*playFX(level.deathray, o_as.origin);
	playFX(level.deathray, o_bs.origin);
	playFX(level.deathray, o_cs.origin);*/
	
	playFX(level.redlight, o_as.origin);
	playFX(level.redlight, o_bs.origin);
	playFX(level.redlight, o_cs.origin);
	
	ah maps\mp\_utility::triggerOn();
	bh maps\mp\_utility::triggerOn();
	ch maps\mp\_utility::triggerOn();
	
	ah enableLinkTo();
	bh enableLinkTo();
	ch enableLinkTo();
	
	ah linkTo(la);
	bh linkTo(lb);
	ch linkTo(lc);
	
	la show();
	lb show();
	lc show();
	
	a playLoopSound("laser");
	b playLoopSound("laser");
	c playLoopSound("laser");
	
	a moveY(88, .75);
	b moveY(-88, .75);
	c moveY(88, .75);
	wait .8;
	
	for(;;)
	{
		a moveY(-176, 1.5);
		b moveY(176, 1.5);
		c moveY(-176, 1.5);
		wait 1.6;
		a moveY(176, 1.5);
		b moveY(-176, 1.5);
		c moveY(176, 1.5);
		wait 1.6;
	}
}

trap6()
{
    trig = getEnt("trig_trap6","targetname");
	a = getEntArray("trap6","targetname");
	trig setHintString("^5Time to turn on the swinger!");
    trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
		for(i = 0; i < a.size; i++)
		{
			a[i] thread trap6Rotator();
		}
		wait 18.2;
	}
}
trap6Rotator()
{
	self rotateYaw(720,9);
	wait 9.1;
	self rotateYaw(-720,9);
	wait 9.1;
}

traprotator()
{
	self rotateYaw(360, 1.5);
	wait 1.6;
	self rotateYaw(-360, 1.5);
	wait 1.6;
	self rotateYaw(360, 1.5);
	wait 1.6;
}

trap7()
{
	brush = getEnt("trap7a", "targetname");
	brush2 = getEnt("trap7b", "targetname");
	trig = getEnt("trig_trap7", "targetname");
	
	trig setHintString("^5Make them yolo the shit outta those!");
	
	trig waittill("trigger", player);
	trig delete();
	for(;;)
	{
	brush moveZ(-1012, .9);
	wait 1.2;
	brush moveZ(1012, .9);
	wait 1.2;
	brush2 moveZ(-1012, .9);
	wait 1.2;
	brush2 moveZ(1012, .9);
	wait 1.2;
	}
}

blower()
{
	self endon( "disconnect" );
	self endon( "death" );

	self playSound( "wtf" );
	
	wait 0.8;

	if( !self isReallyAlive() )
		return;

	playFx( level.fx["bombexplosion"], self.origin );
	self doDamage( self, self, self.health+1, 0, "MOD_EXPLOSIVE", "none", self.origin, self.origin, "none" );
	self suicide();
}

darkpoints()
{
	level waittill("round_started");
	wait .1;
    trig = getEnt("trig_darkpoints","targetname");
    trig setHintString("^5Spend your Dark Points here!");
	for(;;)
	{
		trig waittill("trigger", p); 
		p freezeControls(1);
		p darkpointsmenu();
	}
}

darkpointsmenu()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "darkpoints thread terminated" );
 
    self.hud_darkpoints = [];
    self.selection = 0;
 
    // create huds
    i = 0;
    self.hud_darkpoints[i] = braxi\_mod::addTextHud( self, 160, 200, 0.6, "left", "top", 2 );
    self.hud_darkpoints[i].sort = 879;
    self.hud_darkpoints[i] setShader( "black", 320, 160 );
    i++;
    self.hud_darkpoints[i] = braxi\_mod::addTextHud( self, 167, 204, 0.6, "left", "top", 1.4 );
    self.hud_darkpoints[i].sort = 880;
    self.hud_darkpoints[i] setShader( "white", 306, 20 );
    self.hud_darkpoints[i].color=(0,.6,.8);
    
    i++;
    self.hud_darkpoints[i] = braxi\_mod::addTextHud( self, 210, 204, 0.93, "left", "top", 1.8 );
    self.hud_darkpoints[i].sort = 884;
    self.hud_darkpoints[i] setText("Dark Points Shop - Your balance: ^1"+self.pers["darkpoints"]);
    self.hud_darkpoints[i].glowalpha = 1;
    if(isdefined(level.randomcolor))
        self.hud_darkpoints[i].glowcolor=level.randomcolor;
    else 
        self.hud_darkpoints[i].glowcolor=(0,.6,.8);
    i++;
    self.hud_darkpoints[i] = braxi\_mod::addTextHud( self, 250, 360, 1, "center", "bottom", 1.4 );
    self.hud_darkpoints[i].sort = 900;
    self.hud_darkpoints[i] setText("                                           ^2Press ^5[{+frag}] ^2 to close the menu");
 
    for( j = 0; j < level.darkperks.size; j++ )
    {
        i++;
        self.hud_darkpoints[i] = braxi\_mod::addTextHud( self, 172, 230+(j*16), 0.93, "left", "top", 1.4 );
        self.hud_darkpoints[i].sort = 882;
        self.hud_darkpoints[i].font = "objective";
        self.hud_darkpoints[i].glowalpha= 1;
        if(isdefined(level.randomcolor))
            self.hud_darkpoints[i].glowcolor=level.randomcolor;
        else 
            self.hud_darkpoints[i].glowcolor=(0,.6,.8);
 
        entry = level.darkperks[j];
        self.hud_darkpoints[i] setText(entry["name"] +" - "+ entry["price"]);
    }
 
    i++;
    self.hud_darkpoints[self.hud_darkpoints.size] = braxi\_mod::addTextHud( self, 167, 230, 0.4, "left", "top", 1.4 );
    self.hud_darkpoints[i].sort = 881;
    indicator = self.hud_darkpoints[self.hud_darkpoints.size-1];
    indicator setShader( "white", 306, 17 );
    indicator.color=(0,.6,.8);
    while(self.sessionstate == "playing")
    {
        wait 0.1;
 
        if(self attackButtonPressed())
        {
            self.hud_darkpoints[4+self.selection].alpha = 0.93;
 
            self.selection++;
            if( self.selection >= level.darkperks.size )
                self.selection = 0;
 
            item = self.hud_darkpoints[4+self.selection];
            item.alpha = 1;
            indicator.y = item.y;
        }
        else if(self useButtonPressed())
        {
			if(isDefined(self.pers["darkpoints"]) && self.pers["darkpoints"] >= level.darkperks[self.selection]["price"])
			{
				self.pers["darkpoints"] = self.pers["darkpoints"] - level.darkperks[self.selection]["price"];
				self setStat(2555,self.pers["darkpoints"]);
				self playSoundToPlayer("money", self);
				self iPrintLn("^2>>^1You bought: ^5"+level.darkperks[self.selection]["name"]+"^2<<");
				self thread priceslogic(removeAssFromString(level.darkperks[self.selection]["name"]));
			}
			else
			{
				self iPrintLnBold("^1You don't have enough Dark Points to buy this item!");
			}
			
            self freezeControls(0);
            break;
        }
        else if(self fragButtonPressed())
        {
            self freezeControls(0);
           break;
        }
    }
    
    if(!isdefined(self))
        return;
    if(isdefined(self.hud_darkpoints))
    {
        for(i=0;i<self.hud_darkpoints.size;i++)
        {
            if(isdefined(self.hud_darkpoints[i]))
                self.hud_darkpoints[i] destroy();
        }
    }
    self notify( "darkpoints thread terminated" );
}

priceslogic(prize)
{
	if(prize == "Solidsilver M9A1")
	{
		self giveWeapon("m9a1_mp");
		self giveMaxAmmo("m9a1_mp");
		self switchToWeapon("m9a1_mp");
	}
	else if(prize == "Dark Trident")
	{
		self giveWeapon("darktrident_mp");
		self giveMaxAmmo("darktrident_mp");
		self switchToWeapon("darktrident_mp");
	}
	else if(prize == "Mappers Trail")
	{
		self thread specialtrail();
	}
	else if(prize == "VIP Song")
	{
		ambientStop();
		ambientPlay("vip");
	}
	else if(prize == "PET")
	{
		self thread petgiver();
	}
	else if(prize == "Extra Life")
	{
		self braxi\_mod::giveLife();
	}
}

joinsetter()
{

	for(;;)
	{
		level waittill( "connected", player );
		if(!isDefined(player.pers["darkpoints"]) && isDefined(player getStat(2555)))
		{
			player.pers["darkpoints"] = stringToInt(player getStat(2555));
		}
		else if(!isDefined(player.pers["darkpoints"]) && !isDefined(player getStat(2555)))
		{
			player setStat(2555,0);
			//player.pers["darkpoints"] = player getStat(2555);
			player.pers["darkpoints"] = 0;
		}
	}
}

endsetter()
{
level waittill("round_ended");
pa = getEntArray( "player", "classname" );
	for(i = 0; i < pa.size; i++)
		{
			if(isDefined(pa[i].pers["darkpoints"]))
				pa[i] setStat(2555,pa[i].pers["darkpoints"]);
		}
}