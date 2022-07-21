//Map by CM'Death
//Discord:Death#7416
main()
{
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

   precacheItem("m40a3_mp");
   precacheItem("remington700_mp");
   precacheItem("knife_mp");
   precacheItem("rpg_mp");
   precacheItem("deserteagle_mp");
   precacheItem("beretta_mp");

      thread sr\api\_speedrun::createNormalWays("Normal Way;Hidden Way;");
   thread sr\api\_speedrun::createSecretWays("Jumper Secret;Acti Secret;");
   thread sr\api\_speedrun::createTeleporter((7216.45, 83.4312, -546.355), 65, 45, (9221, -897, -252), 180, "freeze", "yellow", "normal_1");
   thread sr\api\_speedrun::createTeleporter((-441.43, 654.139, -591.875), 60, 35, (-1046, -2417, 572), 360, "freeze", "darkred", "secret_0");
   thread sr\api\_speedrun::createTeleporter((-447.257, -430.243, -591.875), 60, 35, (-874, -7521, 572), 360, "freeze", "blue", "secret_1");
   thread sr\api\_speedrun::createEndMap((14960.3, 123.528, 576.125), 105, 30, "normal_1");
   thread sr\api\_speedrun::createEndMap((13493.5, -4224.57, -295.875), 175, 20, "secret_0");
   thread sr\api\_speedrun::createEndMap((13606.8, -9283.68, -583.875), 130, 20, "secret_1");

   thread sign1();
   thread sign2();
   thread endsign();
   thread cmsign();
   thread arrow();
   thread opendoor();
   thread finaldoor();
   thread finaldoor2();
   thread secret_step();
   thread sec_fail1();
   thread sec_fail2();
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

sign1()
{
   block = getent("signfinish","targetname");
    
   block moveX(400,0.1);
} 

sign2()
{
   block1 = getent("signob","targetname");
   block2 = getent("signph","targetname");
    
	for(;;)
   { 
   wait 0.1;
   block1 rotatepitch (-360,6);
   block2 rotatepitch (360,6);
   wait 0.1;
   }
      
} 

endsign()
{
   block1 = getent("endmapsign","targetname");
   block2 = getent("endmapsign2","targetname");
   block3 = getent("endmapsign3","targetname");
    
	for(;;)
   { 
   wait 0.1;
   block1 rotatepitch (360,6);
   block2 rotatepitch (-360,6);
   block3 rotateYaw (360,6);
   wait 0.1;
   }
      
} 

cmsign()
{
   block1 = getent("cmsign1","targetname");
   block2 = getent("cmsign2","targetname");
   block3 = getent("cmsign3","targetname");
    
	for(;;)
   { 
   wait 0.1;
   block1 rotateYaw (360,6);
   block2 rotateYaw (360,6);
   block3 rotatepitch (360,6);
   wait 0.1;
   }
      
} 

arrow()
{
   arrow= getent("sign2","targetname");
    
	for(;;)
   { 
   arrow moveX (150,3,1,1);
   wait 3;
   arrow moveX (-150,3,1,1);
   wait 3;
   }
      
} 

opendoor()
{
   door = getent("opendoor","targetname");

   door delete();

}

finaldoor()
{
   finishdoora = getent("finaldoora", "targetname");
   finishdoorb = getent("finaldoorb", "targetname");
   
   finishdoora delete();
   finishdoorb delete();
}

finaldoor2()
{
   finishdoora = getent("finaldoor2a", "targetname");
   finishdoorb = getent("finaldoor2b", "targetname");
   
   finishdoora delete();
   finishdoorb delete();

}

secret_step()
{
	brush = getEnt("secstep1","targetname");
	brush2 = getEnt("secstep2","targetname");
	brush3 = getEnt("secstep3","targetname");
   brush4 = getEnt("secstep4","targetname");
   brush5 = getEnt("secstep5","targetname");
   brush6 = getEnt("secstep6","targetname");

	brush hide();
	brush notSolid();
	
	brush2 hide();
	brush2 notSolid();

	brush3 hide();
	brush3 notSolid();

   brush4 hide();
	brush4 notSolid();

   brush5 show();
	brush5 Solid();

   brush6 hide();
	brush6 notSolid();

}

sec_fail1()
{
   fail_triggera = getent("trig_secfail","targetname");
   
   for(;;)
   {
      fail_triggera waittill("trigger",player);
      player suicide();
   }
}

sec_fail2()
{
   fail_triggerb = getent("trig_actisecfail","targetname");
   
   for(;;)
   {
      fail_triggerb waittill("trigger",player);
      player suicide();
   }
}