main()
{
    maps\mp\_load::main();

	//***** script ******//
	maps\mp\mp_dr_jurapark\traps::main();
	maps\mp\mp_dr_jurapark\visual::main();
	//maps\mp\mp_dr_jurapark\mp_dr_jurapark::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_jurapark");	
	setdvar("compassmaxrange","1750");

        game["allies"] = "sas";
        game["axis"] = "opfor";
        game["attackers"] = "axis";
        game["defenders"] = "allies";
        game["allies_soldiertype"] = "woodland";
        game["axis_soldiertype"] = "woodland";

	//setdvar( "r_specularcolorscale", "1" );
	
	//setdvar("r_glowbloomintensity0",".25");
	//setdvar("r_glowbloomintensity1",".25");
	//setdvar("r_glowskybleedintensity0",".3");
	//setdvar("compassmaxrange","1800");

thread sr\api\_map::createSpawn((-321,295,-27),90);
thread sr\api\_speedrun::createNormalWays("Normal Way;");
thread sr\api\_speedrun::createSecretWays("Secret Way;");
thread sr\api\_speedrun::createTeleporter((-128.174, 685.566, -94.875), 65, 30, (76, 2393, -313), 270, "freeze", "blue", "secret_0");
thread sr\api\_speedrun::createEndMap((1007, 2044.27, -86.875),100,90, "normal_0");
thread sr\api\_speedrun::createEndMap((-427.084, 1422.46, -356.875),55,30, "secret_0");

thread trigdelete();
thread bricky_fix();
}

trigdelete()
{
trig = getent("secret2","targetname");
doora = getent("dra","targetname");
doorb = getent("drb","targetname");
doorc = getent("t1","targetname");

level waittill( "round_started");

trig delete();
doora delete();
doorb delete();
doorc delete();

}

bricky_fix()
{
	del_weapon("knife_mp");
	del_weapon("m16_gl_mp");
	del_weapon("ak74u_reflex_mp");
	del_weapon("ak74u_acog_mp");
	del_weapon("ak74u_silencer_mp");
	del_weapon("dog_mp");
	del_weapon("shovel_mp");
}

del_weapon(name)
{
	array = getEntArray("weapon_" + name, "classname");
	if (!isDefined(array) || isDefined(array) && !isDefined(array.size))
		return;

	for (i = 0; i < array.size ;i++)
		array[i] delete();
}
