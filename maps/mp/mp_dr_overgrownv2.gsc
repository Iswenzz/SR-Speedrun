main()
{
maps\mp\_load::main();

PreCacheShellShock( "jeepride_ridedeath");
precacheMenu( "speedex_musicmenu" );
precacheItem("m14_gl_mp");
precacheItem("m1014_grip_mp");
preCacheItem("c4_mp");
precacheItem("ak47_silencer_mp");
precacheModel( "vehicle_cobra_helicopter_fly" );
precacheitem( "cobra_20mm_mp" );
VisionSetNaked( "mp_dr_overgrownv2");

game["allies"] = "marines"; 
game["axis"] = "opfor"; 
game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert"; 
game["axis_soldiertype"] = "desert"; 

setdvar( "r_specularcolorscale", "1" );
setdvar("r_glowbloomintensity0","1");
setdvar("r_glowbloomintensity1","1");
setdvar("r_glowskybleedintensity0","1");

thread sr\api\_map::createSpawn((160,-224,200),1);
thread sr\api\_speedrun::createNormalWays("Normal Way;");

thread trap3();
thread trap5();
thread trap6();
thread trap7();
thread trap9();

}

trap3()
{
	trap3_1 = getent("trap3_1","targetname"); 
	trap3_2 = getent("trap3_2","targetname"); 
	trap3_3 = getent("trap3_3","targetname"); 
	trap3_1_t1 = getent("trap3_1_t1","targetname"); 
	trap3_1_t2 = getent("trap3_1_t2","targetname");
	trap3_2_t1 = getent("trap3_2_t1","targetname");
	trap3_2_t2 = getent("trap3_2_t2","targetname");
	trap3_3_t2 = getent("trap3_3_t2","targetname");
	trap3_3_t1 = getent("trap3_3_t1","targetname");
	trap3_1_hurt = getent("trap3_1_hurt","targetname");
	trap3_2_hurt = getent("trap3_2_hurt","targetname");
	trap3_3_hurt = getent("trap3_3_hurt","targetname");

	trap3_1_hurt delete();
	trap3_2_hurt delete();
	trap3_3_hurt delete();
	trap3_1 moveTo(trap3_1_t1.origin, 1, 0 , 0.5);
	trap3_2 moveTo(trap3_2_t2.origin, 1, 0 , 0.5);
	trap3_3 moveTo(trap3_3_t1.origin, 1, 0 , 0.5);
	
}

trap5()
{
	bounce1 = getent("bounce1","targetname");
	fan1 = getent("fan1","targetname");

	bounce1 delete();
}

trap6()
{
	bounce2 = getent("bounce2","targetname");
	fan2 = getent("fan2","targetname");

	bounce2 delete();
	
}

trap7()
{
	fire1 = getent("fire1","targetname"); 
	fire2 = getent("fire2","targetname"); 
	fire3 = getent("fire3","targetname"); 
	fire4 = getent("fire4","targetname"); 
	fire1_hurt = getent("fire1_hurt","targetname"); 
	fire2_hurt = getent("fire2_hurt","targetname"); 
	fire3_hurt = getent("fire3_hurt","targetname"); 
	fire4_hurt = getent("fire4_hurt","targetname"); 

	fire1_hurt delete();
	fire2_hurt delete();
	fire3_hurt delete();
	fire4_hurt delete();
	
}

trap9()
{
	trap9 = getent("trap9","targetname");
	trap9_hurt = getent("trap9_hurt","targetname");

	trap9_hurt delete();
	trap9 delete();
	
}