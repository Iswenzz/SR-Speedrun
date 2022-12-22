//Map by CM'Death
//Discord:Death#7416
main()
{
thread sr\api\_map::createSpawnOrigin((288.125, 0, 16.125), 0);
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

   thread welcome();
   thread pure_ladder_s();
   thread pure_ladder_f();
   thread pure_angle_s();
   thread pure_angle_f();
   thread pure_bhop_s();
   thread pure_bhop_f();
   thread pure_bounce_s();
   thread pure_bounce_f();
   thread pure_stairs_s();
   thread pure_stairs_f();
   thread pure_fall_s();
   thread pure_fall_f();
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

welcome()
{
	level waittill("round_started");
	wait 2;
	noti = SpawnStruct();
	noti.TitleText = "^5Map  ^0by ^5CM'Death^0!";
    noti.notifyText = "^5Map has many ^0ways ^5to practise to become ^0better^5!";
	noti.duration = 12;
	noti.glowcolor = (7,7,7);
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );

}

freeze()
{
	self endon("disconnect");

	self FreezeControls(1);  /////To prevent 10 fps glitches////
	wait 0.5;
	self FreezeControls(0);
}

pure_ladder_s()
{
    trig = getEnt ("sr_ladder_start", "targetname");
    orig = getEnt ("sr_ladder_orig", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);

         player thread sr\api\_speedrun::changeWay("normal_1");
         player SetOrigin(orig.origin);
         player SetPlayerAngles(orig.angles );
         player thread freeze();

	}
}

pure_ladder_f()
{
    trig = getEnt ("sr_ladder_finish", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);

        player thread sr\api\_speedrun::finishWay("normal_1");

	}
}

pure_angle_s()
{
    trig = getEnt ("sr_angle_start", "targetname");
    orig = getEnt ("sr_angle_orig", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);

         player thread sr\api\_speedrun::changeWay("normal_2");
         player SetOrigin(orig.origin);
         player SetPlayerAngles(orig.angles );
         player thread freeze();

	}
}

pure_angle_f()
{
    trig = getEnt ("sr_angle_finish", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("normal_2");
	}
}

pure_bhop_s()
{
    trig = getEnt ("sr_bhop_start", "targetname");
    orig = getEnt ("sr_bhop_orig", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);

         player thread sr\api\_speedrun::changeWay("normal_3");
         player SetOrigin(orig.origin);
         player SetPlayerAngles(orig.angles );
         player thread freeze();

	}
}

pure_bhop_f()
{
    trig = getEnt ("sr_bhop_finish", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("normal_3");

	}
}

pure_bounce_s()
{
    trig = getEnt ("sr_bounce_start", "targetname");
    orig = getEnt ("sr_bounce_orig", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);

         player thread sr\api\_speedrun::changeWay("normal_4");
         player SetOrigin(orig.origin);
         player SetPlayerAngles(orig.angles );
         player thread freeze();

	}
}

pure_bounce_f()
{
    trig = getEnt ("sr_bounce_finish", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("normal_4");
	}
}

pure_fall_s()
{
    trig = getEnt ("sr_fall_start", "targetname");
    orig = getEnt ("sr_fall_orig", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);

         player thread sr\api\_speedrun::changeWay("normal_5");
         player SetOrigin(orig.origin);
         player SetPlayerAngles(orig.angles );
         player thread freeze();

	}
}

pure_fall_f()
{
    trig = getEnt ("sr_fall_finish", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("normal_5");

	}
}

pure_stairs_s()
{
    trig = getEnt ("sr_stairs_start", "targetname");
    orig = getEnt ("sr_stairs_orig", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);

         player thread sr\api\_speedrun::changeWay("secret_0");
         player SetOrigin(orig.origin);
         player SetPlayerAngles(orig.angles );
         player thread freeze();

	}
}

pure_stairs_f()
{
    trig = getEnt ("sr_stairs_finish", "targetname");


    while(1)
    {
        trig waittill ("trigger", player);
        player thread sr\api\_speedrun::finishWay("secret_0");

	}
}