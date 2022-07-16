main() 
{
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

    thread speedrun\_way_name::create_spawn((464,390,60),360);
	thread speedrun\_way_name::create_normal_way("Normal Way;");
	thread speedrun\_way_name::create_normal_way("Easy Secret;Hard Secret;");
    thread speedrun\_way_name::create_tp((4189.82, -704.283, -95.875), 55, 10, (3429, -703, -36), 180, "freeze", "blue", "ns0");
	thread speedrun\_way_name::create_tp((648.482, 585.839, 0.125), 55, 10, (5201, 1266, 1085), 1, "freeze", "yellow", "s0");
	thread speedrun\_way_name::create_tp((652.581, 180.528, 0.125), 55, 10, (-1085, 3296, -1987), 180, "freeze", "red", "s1");
	thread speedrun\_way_name::create_endmap((9313.27, 1253.84, 16.125), 75, 10, "s0");
	thread speedrun\_way_name::create_endmap((5072.48, 4767.26, -4990.88), 155, 10, "s1");
    
	thread startdoor();
	thread trap4();
	thread trap5();
	thread trap8();
	thread trap9();
	thread trap11();

}

startdoor()
{
	start = getEnt("start_door","targetname");
	tunnel = getEnt("tunnel_door","targetname");
	end = getEnt("end_door","targetname");

	start Delete();
	tunnel Delete();
	end Delete();
}

trap4()
{
    trap = getEntArray("trap4_brush","targetname");
	hurta = getEnt("auto5","targetname");
    hurtb = getEnt("auto6","targetname");
	hurtc = getEnt("auto7","targetname");

    trap[0] delete();
	trap[1] delete();
	trap[2] delete();
	hurta delete();
	hurtb delete();
	hurtc delete();
}

trap5()
{
	trapa = getEnt("trap5_brush","targetname");

	trapa delete();
}

trap8()
{
	trapa = getEnt("trap8_slide","targetname");

	trapa delete();
}

trap9()
{
	trapa = getEnt("trap9_brush","targetname");

	trapa delete();
}

trap11()
{
	trap = getEntArray("trap11_brush","targetname");
	hurta = getEnt("auto16","targetname");
    hurtb = getEnt("auto17","targetname");
	hurtc = getEnt("auto18","targetname");

	trap[0] delete();
	trap[1] delete();
	trap[2] delete();
	hurta delete();
	hurtb delete();
	hurtc delete();
}