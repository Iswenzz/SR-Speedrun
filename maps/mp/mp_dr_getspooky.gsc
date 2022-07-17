#include maps\mp\dr_getspooky\mp_dr_getspooky_teleports;
#include maps\mp\dr_getspooky\mp_dr_getspooky_traps;
#include maps\mp\dr_getspooky\mp_dr_getspooky_rooms;

main() {
  maps\mp\_load::main();


  game["allies"] = "marines";
  game["axis"] = "opfor";
  game["attackers"] = "axis";
  game["defenders"] = "allies";
  game["allies_soldiertype"] = "desert";
  game["axis_soldiertype"] = "desert";


	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
    setDvar("bg_fallDamageMaxHeight", "99999");
    setDvar("bg_fallDamageMinHeight", "99998");

  //VisionSetNaked( "mp_hill" );
  SetExpFog(2000, 1500, 180/255, 255/255, 200/255, 0 );

  //preCache
  preCacheModel("asu_pumpkin");
  precacheshellshock("death");

  precacheitem("dragunov_mp");
	precacheitem("ak74u_mp");
	precacheitem("ak47_mp");
	precacheitem("remington700_mp");
	precacheitem("m40a3_mp");
	PreCacheItem("deserteagle_mp");
	preCacheItem("deserteaglegold_mp");
	preCacheItem("beretta_mp");
	precacheitem("colt45_mp");
	precacheitem("uzi_mp");
	precacheitem("p90_mp");
	preCacheItem("g3_mp");
	preCacheItem("m14_mp");
	preCacheItem("g36c_mp");
	preCacheItem("m4_mp");
	preCacheItem("rpd_mp");
	preCacheItem("usp_mp");
	preCacheItem("mp5_mp");
	preCacheItem("brick_blaster_mp");
	preCacheItem("winchester1200_mp");

  level.rndWeaponList = [];
	level.rndWeaponList["weap"] [0] = "ak74u_mp";
	level.rndWeaponList["txt" ] [0] = "Ak74u";
	level.rndWeaponList["weap"] [1] = "ak47_mp";
	level.rndWeaponList["txt" ] [1] = "Ak74";
	level.rndWeaponList["weap"] [2] = "remington700_mp";
	level.rndWeaponList["txt" ] [2] = "Remington700";
	level.rndWeaponList["weap"] [3] = "m40a3_mp";
	level.rndWeaponList["txt" ] [3] = "M40a3";
	level.rndWeaponList["weap"] [4] = "colt45_mp";
	level.rndWeaponList["txt" ] [4] = "Colt45";
	level.rndWeaponList["weap"] [5] = "uzi_mp";
	level.rndWeaponList["txt" ] [5] = "Uzi";
	level.rndWeaponList["weap"] [6] = "g3_mp";
	level.rndWeaponList["txt" ] [6] = "G3";
	level.rndWeaponList["weap"] [7] = "m14_mp";
	level.rndWeaponList["txt" ] [7] = "M14";
	level.rndWeaponList["weap"] [8] = "g36c_mp";
	level.rndWeaponList["txt" ] [8] = "G36c";
	level.rndWeaponList["weap"] [9] = "m4_mp";
	level.rndWeaponList["txt" ] [9] = "M4";
	level.rndWeaponList["weap"][10] = "rpd_mp";
	level.rndWeaponList["txt" ][10] = "RPD";
	level.rndWeaponList["weap"][11] = "winchester1200_mp";
	level.rndWeaponList["txt" ][11] = "Winchester1200";
	level.rndWeaponList["weap"][12] = "mp5_mp";
	level.rndWeaponList["txt" ][12] = "Mp5";
	level.rndWeaponList["weap"][13] = "brick_blaster_mp";
	level.rndWeaponList["txt" ][13] = "Brick Blaster";

  //basic
  level.getspooky_glow = (randomfloatrange(0.0, 1.0), randomfloatrange(0.0, 1.0), randomfloatrange(0.0, 1.0));

  //fx
	level.pumpkinSpawnSmoke = loadfx( "asu/asu_green_smoke_explosion" );
  level.pumpkinFall = loadfx( "asu/asu_pumpkinFalling" );
  level.pumpkin = loadfx( "asu/asu_pumpkin" );
  level.pumpkinFire = loadfx( "asu/asu_pumpkin_fire" );
  level.soul = loadfx( "asu/asu_soul" );
  level.ghost = loadfx( "asu/asu_ghost" );
  level.explo = loadfx( "explosions/aerial_explosion" );

  //teams
  level.dr_acti = "axis";					 //axis
  level.dr_jump = "allies";				 //allies
  level.dr_spec = "spectator";		//spectator

  //active traps
  level.trap1_activ = true;
  level.trap2_activ = true;
  level.trap3_activ = true;
  level.trap4_activ = true;
  level.trap5_activ = true;
  level.trap6_activ = true;

  level.inRoom = false;
  level.bouWepName = "";
  level.pickedBouWeap = false;

  //threads
  thread sr\api\_speedrun::createNormalWays("Spooky Way");
  thread sr\api\_speedrun::createSecretWays("Secret Way");
  thread sr\api\_map::createSpawn((-495,62,108),359);
  thread sr\api\_speedrun::createTeleporter((-109.459, -493.118, 32.125), 50, 15, (11378, 4574, 1085), 180, "freeze", "blue", "secret_0");
  thread sr\api\_speedrun::createEndMap((11990.7, -1964.3, 865.145),90,25,"secret_0");
  //thread credits();
  //thread music();
  //thread onPlayerSpawn();
  thread pumpkinSpawn();
  //thread soulpoint_init();
  //thread secretGhost_init();
  //thread hangYourself();
  thread teleports();
  //thread traps();
  //thread rooms();
  thread locationTrig_init();
  thread bounce_f();
  thread trigdelete();

}

trigdelete()
{
triga = getent("trig_secretEnter","targetname");
trigb = getent("trig_secOut","targetname");

level waittill( "round_started");

triga delete();
trigb delete();

}

addTriggerToList(name){
  if(!isDefined(level.trapTriggers))
      level.trapTriggers = [];
  level.trapTriggers[level.trapTriggers.size] = getEnt(name,"targetname");
}

credits(){
	level waittill( "round_started");

	if(isdefined(level.credits)) level.credits Destroy();

  wait .1;
  level.credits = NewHudElem();
  level.credits.foreground = true;
  level.credits.x=0;
  level.credits.y=-100;
  level.credits.alignx="center";
  level.credits.aligny="middle";
  level.credits.horzalign="center";
  level.credits.vertalign="middle";
  level.credits.sort = 0;
  level.credits.fontScale = 1.5;
  level.credits.glowColor = (1,0,1);
  level.credits.glowAlpha = 1;
  level.credits.font="objective";
  level.credits.hidewheninmenu = true;


  level.credits SetPulseFX( 40, 4800, 200 );
  level.credits SetText(" ^6Map made by:\n                     Asunarry.^5!");
  level.credits FadeOverTime(1);
  wait 5;

  level.credits SetPulseFX( 40, 4800, 200 );
  level.credits SetText(" ^6Thanks for the help to:\n   ^3Fox ^6& ^2Bane ^6& ^1Mortiis^5!");
  level.credits FadeOverTime(1);
  wait 5;

	if(isdefined(level.credits)) level.credits Destroy();
}

music(){
  level waittill("round_started");

  x = RandomInt(7);

  ambientstop();
	musicstop();
  ambientPlay("music" + x);

  switch(x) {
    case 0:
      IPrintLn("Ghostbusters Theme Song Remix - The Living Tombstone");
      IPrintLn("Thanks, Bane! <3");
      break;
    case 1:
      IPrintLn("This Is Halloween (Trap Remix)");
      IPrintLn("Thanks, Bane! <3");
      break;
    case 2:
      IPrintLn("Billie Eilish - hostage");
      IPrintLn("Thanks, Billie! <3");
      break;
    case 3:
      IPrintLn("The Prodigy - Firestarter");
      IPrintLn("I'm the firestarter, twisted firestarter...");
      break;
    case 4:
      IPrintLn("The Prodigy - Omen");
      IPrintLn("Thanks, Mortiis! <3");
      break;
    case 5:
      IPrintLn("MELANCHOLIA Music Box Sad, creepy song");
      IPrintLn("Thanks, Mortiis! <3");
      break;
    case 6:
      IPrintLn("Billie Eilish - bury a friend");
      IPrintLn("Thanks, Billie! <3");
      break;
  }
}

onPlayerSpawn(){
  level endon("endmap");

  while(true){
    level waittill("player_spawn", player);

    if(player.pers["team"] != "spectator" && player.pers["team"] == level.dr_jump){

      if(!isDefined(player.currentLocationTag)){
        player.currentLocationTag = false;
      } else if(player.currentLocationTag){
        player.currentLocationTag = false;
      }
    }
  }
}

pumpkinspawn(){
  level waittill("round_started");
  TriggerFX(SpawnFX(level.pumpkinSpawnSmoke, (540, 52, 440)));
  fall = SpawnFX(level.pumpkinFall, (540, 52, 450));
  TriggerFX(fall);
  wait 1.435;
  TriggerFX(SpawnFX(level.pumpkin, (540, 52, 140)));
  Earthquake( 0.8, 1.3, (540, 52, 100), 1500 );
  wait .01;
  fall Delete();
  TriggerFX(SpawnFX(level.pumpkinFire, (540, 52, 90)));
  level notify( "pumpkinSpawned" );
}

soulpoint_init(){
  points = 32;

  level waittill("round_started");

  for(i = 1; i <= points; i++) {
    thread spawnSoulPoint(i);
    wait (RandomInt(3) + 1);
  }
}

spawnSoulPoint(num){
  point = getEnt("soulpoint"+num, "targetname");

  TriggerFX(SpawnFX(level.soul, point.origin));
}

secretGhost_init(){
  location = getEnt("secretEff", "targetname");

  level waittill("round_started");
  TriggerFX(SpawnFX(level.ghost, location.origin));
}

hangYourself(){
  org = getEnt("hangYourself", "targetname");
  trig = getEnt("trig_hangYourself", "targetname");

  trig SetHintString("^1Press &&1 to hang yourself...");

  while(true){
    trig waittill("trigger", player);
    trig maps\mp\_utility::triggerOff();

    player FreezeControls(true);
    player DisableWeapons();
    wait .001;
    player SetOrigin(org.origin + (0, 0, -40));
    player SetPlayerAngles(org.angles);
    player LinkTo(org);
    player FreezeControls(false);

    player thread hang();
    trig thread enableHang();
  }
}

hang(){
  self endon( "disconnect" );
  self endon( "death" );
  self endon( "spawned" );
  self endon( "joined_spectators" );

  self shellshock("death", 10);
  //self playSound( "gib_splat" );

  wait 10;

  self EnableWeapons();
  self Unlink();
  self Suicide();
}

enableHang(){
  wait 11;
  self maps\mp\_utility::triggerOn();
}

teleports(){
  thread spawnTeleport();
  thread actiTp_init();
  thread lavatp();
  thread endtp();
  thread endroom();
  thread secret();
}

traps(){
  thread trap1_init();
  thread trap2_init();
  thread trap3_init();
  thread trap4_init();
  thread trap5_init();
  thread trap6_init();

  addtriggertolist("trig_trap1");
  addtriggertolist("trig_trap2");
  addtriggertolist("trig_trap3");
  addtriggertolist("trig_trap4");
  addtriggertolist("trig_trap5");
  addtriggertolist("trig_trap6");
}

rooms(){
  //thread sniper();
  //thread knife();
  //thread randomWeapon();
  //thread bounce();
  //thread bounceWeapon();
}

roomHud(hudNumber, _x, _y, fontScale, font, txt){
	level.mapHud[hudNumber]=newhudelem();
	level.mapHud[hudNumber].x=_x;
	level.mapHud[hudNumber].y=_y;
	level.mapHud[hudNumber].alignx="center";
	level.mapHud[hudNumber].aligny="middle";
	level.mapHud[hudNumber].horzalign="center";
	level.mapHud[hudNumber].vertalign="middle";
	level.mapHud[hudNumber].fontscale=fontScale;
	level.mapHud[hudNumber].glowalpha=1;
	level.mapHud[hudNumber].font=font;
	level.mapHud[hudNumber].glowcolor=level.getspooky_glow;
	level.mapHud[hudNumber].hidewheninmenu = true;

	level.mapHud[hudNumber].alpha=1;
	level.mapHud[hudNumber].sort = 890;
	level.mapHud[hudNumber] SetText(txt);
	level.mapHud[hudNumber] SetPulseFX( 40, 5900, 200 );

	wait 5;

	if(isDefined(level.mapHud[hudNumber])){
		level.mapHud[hudNumber] fadeOverTime(.5);
		level.mapHud[hudNumber] Destroy();
	}
}

playerHud(_x, _y, fontScale, font, txt){
  self endon( "newLocation" );
  self endon( "disconnect" );
  self endon( "death" );
  self endon( "spawned" );
  self endon( "joined_spectators" );

  if(isDefined(self.playerHud)) self.playerHud Destroy();

  self.playerHud=newClientHudElem(self);
	self.playerHud.x=_x;
	self.playerHud.y=_y;
	self.playerHud.alignx="center";
	self.playerHud.aligny="middle";
	self.playerHud.horzalign="center";
	self.playerHud.vertalign="middle";
	self.playerHud.fontscale=fontScale;
	self.playerHud.glowalpha=1;
	self.playerHud.font=font;
	self.playerHud.glowcolor= (0/255, 220/255, 100/255);
	self.playerHud.hidewheninmenu = true;

	self.playerHud.alpha=1;
	self.playerHud.sort = 890;
	self.playerHud SetText(txt);
	self.playerHud SetPulseFX( 0, 2000, 200 );
}

locationTrig_init(){
  level waittill("round_started");

  trigCount = 8;

  for(i = 1; i <= trigCount; i++) {
    level thread locationTrig(i);
    wait .0001;
  }
}

locationTrig(number){
  trig = getEnt("trig_location" + number, "targetname");

  while(true){
    trig waittill("trigger", player);

    if(!player.currentLocationTag){
      player.currentLocationTag = true;
      player thread locTrigCheck(trig);
      player notify( "newLocation" );
      player thread playerHud(200, 185, 1.4, "objective", "Location:\n" + getLocationName(number));
    }

    wait .000001;
  }
}

getLocationName(number){
  switch(number){
    case 1: return "Spooky Spawn...";
    case 2: return "Valley of Death...";
    case 3: return "Deadly Pond...";
    case 4: return "Explosive Pumpkin-field...";
    case 5: return "Moving Ground...";
    case 6: return "Elysian Fields...";
    case 7: return "The Porch of Hell...";
    case 8: return "The End...";
  }

  return "Unknown...";
}

locTrigCheck(trig){
  while(true){
    if(!self IsTouching(trig)){
      self.currentLocationTag = false;
      break;
    }

    wait .000001;
  }
}

//remove the coloring from the player name
removeColorFromString( string ){
	output = "";

	for ( i = 0; i < string.size; i++ ){
		if ( string[i] == "^" ){
			if ( i < string.size - 1 ){
				if ( string[i + 1] == "0" || string[i + 1] == "1" || string[i + 1] == "2" || string[i + 1] == "3" || string[i + 1] == "4" ||string[i + 1] == "5" || string[i + 1] == "6" || string[i + 1] == "7" || string[i + 1] == "8" || string[i + 1] == "9" ){
					i++;
					continue;
				}
			}
		}

		output += string[i];
	}

	return output;
}

bounceWeapon(){
  trig = getEnt("trig_bounceweapon", "targetname");

  trig SetHintString("Press ^&&1^7 to pickup the weapon!");

  while(true){
    trig waittill("trigger", player);

    if(!level.pickedBouWeap){
      level.pickedBouWeap = true;
      level.bouWepName = bouWepPick(RandomInt(3));
    }

    if(!player HasWeapon(level.bouWepName)){
      player GiveWeapon(level.bouWepName);
      player GiveMaxAmmo(level.bouWepName);
      player IPrintLnBold("You ^1got^7 your weapon, switch to use it!");
    } else {
      player IPrintLnBold("You ^1already^7 got your weapon, no more for you!");
    }
  }
}

bouWepPick(n){
  switch(n){
    case 0:
      return "dragunov_mp";
    case 1:
      return "remington700_mp";
    case 2:
      return  "m40a3_mp";
  }

  return "dragunov_mp";
}