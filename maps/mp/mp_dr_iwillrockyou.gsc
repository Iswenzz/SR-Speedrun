main()
{
maps\mp\_load::main();

game["allies"] = "sas";
game["axis"] = "russian";
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "woodland";
game["axis_soldiertype"] = "woodland";

setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
setDvar("bg_falldamagemaxheight", 99999);
setDvar("bg_falldamageminheight", 99998);

thread sr\api\_map::createSpawn((2,-3121,1052),270);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread brush();
}

brush()
{
brush = getentArray("brush_nehezites1", "targetname");
brush2 = getent("brush_nehezites1_forog_fo", "targetname");
brush3 = getentArray("brush_nehezites1_forog", "targetname");

brush[0] moveX(-150,0.1);
brush[1] moveX(-500,0.1);
brush[2] moveX(200,0.1);
brush2 delete();
brush3[0] delete();
brush3[1] delete();
brush3[2] delete();
wait 0.3;
brush[0] moveY(-950,0.1);
brush[1] moveY(-950,0.1);
brush[2] moveY(-950,0.1);

}