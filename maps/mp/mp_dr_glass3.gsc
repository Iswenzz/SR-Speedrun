/* Author: Rycoon, Version: 1.1 */
/*In case you are here to copy some of the work I have made, well... I have to disappoint you. Please try writing your own code and stop copying other people's work. Thank you.*/
/* not rly */
  main() {
level.masterSpawn = spawn("script_origin",(1228, 786, -160));
level.masterSpawn.angles = (0,90,0);
 game["allies"] = "marines";
 game["axis"] = "opfor";
 game["attackers"] = "axis";
 game["defenders"] = "allies";
 game["allies_soldiertype"] = "desert";
 game["axis_soldiertype"] = "desert";
  setdvar( "r_specularcolorscale", "3" );

  thread way_connect();

  level.fx_blood = LoadFX( "deathrun/body_smash" );
  level.trapTriggers = [];
 for(i=1;
i<=12;
i++) level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger_trap"+i, "targetname" );
  thread TriggerBloody();
 thread StartDoor();
 thread FinalDoor();
 // thread EndRooms();
 //  thread TrapTrigger1();
 // thread TrapTrigger2();
 // thread TrapTrigger3();
 // thread TrapTrigger4();
 // thread TrapTrigger5();
 // thread TrapTrigger6();
 // thread TrapTrigger7();
 // thread TrapTrigger8();
 // thread TrapTrigger9();
 // thread TrapTrigger10();
 // thread TrapTrigger11();
 // thread TrapTrigger12();
 }

 ////////////////////////////////////////////////////////////////////////////////////////////////
way_connect()
{
    wait 0.05;
  
    sr\api\_speedrun::createNormalWays("Cock Way;");
  
    for(;;) 
    {
        level waittill( "connected", player );

    }
}
////////////////////////////////////////////////////////////////////////////////////////////////

  TrapTrigger1() {
 trig = getEnt( "trigger_trap1", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  drop1 = getEnt( "trap_drop1", "targetname" );
 drop2 = getEnt( "trap_drop2", "targetname" );
  drop1 RotatePitch( 90, 0.4, 0.2 );
 drop2 RotatePitch( -90, 0.4, 0.2 );
 wait 0.2;
 drop1 notSolid();
 drop2 notSolid();
 wait 4.8;
 drop1 rotatePitch( -90, 0.5, 0.25, 0.25 );
 drop2 rotatePitch( 90, 0.5, 0.25, 0.25 );
 wait 0.25;
 drop1 solid();
 drop2 solid();
 }
  TrapTrigger2() {
 trig = getEnt( "trigger_trap2", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  spikes = getEnt( "trap_spikes", "targetname" );
 dmg = getEnt( "trigger_spikesdmg", "targetname" );
 dmg thread WatchTriggerBloody();
 dmg EnableLinkTo();
 dmg LinkTo( spikes );
 wait 0.05;
 oldpos = spikes.origin;
 spikes MoveZ( 112, 0.5, 0.25 );
 wait 3;
 dmg delete();
 spikes MoveTo( oldpos, 2, 0.5, 0.5 );
 }
  TrapTrigger3() {
 trig = getEnt( "trigger_trap3", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  hammers = getEntArray( "trap_hammer", "targetname" );
 for(i=0;
i<hammers.size;
i++) hammers[i] thread HammerRotate();
 }
  TrapTrigger4() {
 trig = getEnt( "trigger_trap4", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  updown1 = getEntArray( "trap_updown1", "targetname" );
 updown2 = getEntArray( "trap_updown2", "targetname" );
  for(i=0;
i<updown1.size;
i++) updown1[i].oldpos = updown1[i].origin;
  for(i=0;
i<updown2.size;
i++) updown2[i].oldpos = updown2[i].origin;
  while(1) {
 for(i=0;
i<updown1.size;
i++) updown1[i] MoveZ( 384, 0.5, 0, 0.25 );
 wait 0.75;
 for(i=0;
i<updown1.size;
i++) updown1[i] MoveTo( updown1[i].oldpos, 0.5, 0, 0.25 );
 wait 1;
  for(i=0;
i<updown2.size;
i++) updown2[i] MoveZ( 384, 0.5, 0, 0.25 );
 wait 0.75;
 for(i=0;
i<updown2.size;
i++) updown2[i] MoveTo( updown2[i].oldpos, 0.5, 0, 0.25 );
 wait 1;
 }
 }
  TrapTrigger5() {
 trig = getEnt( "trigger_trap5", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  roller = getEnt( "trap_roller", "targetname" );
  while( isDefined( roller ) ) {
 roller RotatePitch( 360, 6 );
 wait 6;
 }
 }
  TrapTrigger6() {
 trig = getEnt( "trigger_trap6", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  rota = getEntArray( "trap_rotatora", "targetname" );
 rotb = getEnt( "trap_rotatorb", "targetname" );
  rotb thread RotatorB();
  while(1) {
 for(i=0;
i<rota.size;
i++) rota[i] rotateYaw( 360, 1 );
 rotb rotateYaw( 360, 1 );
 wait 1;
 }
 }
  TrapTrigger7() {
 trig = getEnt( "trigger_trap7", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  brush = getEntArray( "trap_disappear", "targetname" );
 if( RandomInt(2) ) {
 brush[0] hide();
 brush[2] hide();
 }
 else {
 brush[1] hide();
 brush[3] hide();
 }
 }
  TrapTrigger8() {
 trig = getEnt( "trigger_trap8", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  roller = getEnt( "trap_smallroller", "targetname" );
 roller rotatePitch( 1800, 7.5, 0.25, 0.5 );
 }
  TrapTrigger9() {
 trig = getEnt( "trigger_trap9", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  getEntArray( "trap_blaa", "targetname" )[RandomInt(2)] notSolid();
 getEntArray( "trap_blab", "targetname" )[RandomInt(2)] notSolid();
 }
  TrapTrigger10() {
 trig = getEnt( "trigger_trap10", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  pushers = getEntArray( "trap_pusher", "targetname" );
 for(i=0;
i<pushers.size;
i++) {
 pushers[i] thread TrapPusher();
 wait 0.2+RandomFloat(1);
 }
 }
  TrapPusher() {
 if( !isDefined( self ) ) return;
  oldpos = self.origin;
  while( isDefined( self ) ) {
 self MoveX( 480, 1.5, 0.25 );
 wait 2;
 self MoveTo( oldpos, 1.5, 0.5, 0.5 );
 wait 2;
 }
 }
  TrapTrigger11() {
 trig = getEnt( "trigger_trap11", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  rotator = getEnt( "trap_smallrotator", "targetname" );
  while( isDefined( rotator ) ) {
 rotator rotateYaw( 360, 4 );
 wait 4;
 }
 }
  TrapTrigger12() {
 trig = getEnt( "trigger_trap12", "targetname" );
  trig waittill( "trigger" );
 trig delete();
  movera = getEnt( "trap_movera", "targetname" );
 moverb = getEntArray( "trap_moverb", "targetname" );
  moverb[0] thread TrapMoverB();
 moverb[1] thread TrapMoverB();
 oldpos = movera.origin;
 while( isDefined( movera ) ) {
 time = 1+RandomFloat(1);
 movera MoveX( -384, time, 0.25, 0.25 );
 wait time;
 movera MoveTo( oldpos, time, 0.25, 0.25 );
 wait time;
 }
 }
  TrapMoverB() {
 oldpos = self.origin;
 while( isDefined( self ) ) {
 time = 1+RandomFloat(1);
 self MoveX( 384, time, 0.25, 0.25 );
 wait time;
 self MoveTo( oldpos, time, 0.25, 0.25 );
 wait time;
 }
 }
  HammerRotate() {
 self RotateTo( (0,0,-40+(RandomInt(2)*80)), 0.5, 0, 0.25 );
 wait 0.5;
 time = 0.5+RandomFloat(0.25);
  while( isDefined( self ) ) {
 if( self.angles[2] < 0 ) self RotateRoll( 80, time, 0.25, 0.25 );
 else self RotateRoll( -80, time, 0.25, 0.25 );
 wait time;
 }
 }
  RotatorB() {
 if( !isDefined( self ) ) return;
  oldpos = self.origin;
  while(1) {
 time = 0.5+RandomFloat(1);
 self MoveX( 128, time, 0.25, 0.25 );
 wait time;
 self MoveTo( oldpos, time, 0.25, 0.25 );
 wait time;
 }
 }
  StartDoor() {
 trig = getEnt( "trigger_startdoor", "targetname" );
 trig delete();
  door = getEnt( "startdoor", "targetname" );
 door moveZ( -208, 3, 0.5, 1 );
 }
  FinalDoor() {
 door = getEnt( "finaldoor", "targetname" );
 trig = getEnt( "trigger_finaldoor", "targetname" );
  door delete();
 }
  TriggerBloody() {
 trig = getEntArray( "trigger_blood", "targetname" );
 for(i=0;
i<trig.size;
i++) trig[i] thread WatchTriggerBloody();
 }
  WatchTriggerBloody() {
 while( isDefined( self ) ) {
 self waittill( "trigger", player );
 PlayFX( level.fx_blood, player.origin+(0,0,32) );
 player suicide();
 }
 }
  EndRooms() {
 trig = getEntArray( "trigger_endroom", "targetname" );
 for(i=0;
i<trig.size;
i++) trig[i] thread WatchEndRoomTrig();
 }
  WatchEndRoomTrig() {
 while( isDefined( self ) ) {
 self waittill( "trigger", player );
 if( player.pers["team"] != "allies" ) continue;
 spawn = getEntArray( "mp_jumper_spawn", "classname" )[RandomInt(10)];
 player SetPlayerAngles( spawn.angles );
 player setOrigin( spawn.origin );
 player iPrintlnBold( "^1>> Looks like somebody doesn't know how to play Deathrun..." );
 }
 }
