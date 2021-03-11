main()
{

	level.sandfall = loadFX("mp_dr_sand/sandfall");
	level.sandbase = loadFX("mp_dr_sand/sandfall_base");
	level.fumee = loadFX("mp_dr_sand/fumee");
	
	thread sandfall_fx();
	thread fumee_fx();
}

sandfall_fx()
{
ori = getent("sandfall_ori", "targetname");
ori2 = getent("sandfall_ori2", "targetname");

orib = getent("sandbase_ori", "targetname");
orib2 = getent("sandbase_ori2", "targetname");


wait 10;

fx = playfx(level.sandfall, ori.origin);
fx = playfx(level.sandfall, ori2.origin);

fx = playfx(level.sandbase, orib.origin);
fx = playfx(level.sandbase, orib2.origin);

}

fumee_fx()
{
	ori = getent("fumee_ori", "targetname");
	wait 10;
	fx = playfx(level.fumee, ori.origin);
}