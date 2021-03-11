// ------------------------ SPEEDRUN ------------------------
// ----------------------------------------------------------

// spawn auto placement
auto_spawn = getEntArray("mp_jumper_spawn", "classname");
if(auto_spawn.size > 0)
	thread speedrun\_way_name::create_spawn_auto(auto_spawn[int(auto_spawn.size / 2)].origin,
		auto_spawn[int(auto_spawn.size / 2)].angles[1]);

player thread speedrun\_way_name::change_way("s0");
player thread speedrun\_way_name::finish_way("s0");

thread speedrun\_way_name::create_spawn((0, 0, 0), 0);

thread speedrun\_way_name::create_normal_way("Normal Way;");
thread speedrun\_way_name::create_secret_way("Secret Way;");

thread speedrun\_way_name::create_endmap((0, 0, 0), 100, 150);
thread speedrun\_way_name::create_endmap((0, 0, 0), 100, 150, "s0");

thread speedrun\_way_name::create_tp((0, 0, 0), 100, 150, (0, 0, 0), 0, "freeze", "blue", "s0");
thread speedrun\_way_name::create_tp((0, 0, 0), 100, 150, (0, 0, 0), 0, "freeze");

// CJ
speedrun\maptriggers::cj_dvar(); // CJ MAP

// Q3
level.slide_map = true;
level.slide_map_multiplier = 4; // this is a speed multiplier, you can change it if its too slow/fast

////////////////////////////////////////////////////////////
// _transporter debug
tp()
{
	entTransporter = getentarray( "enter", "targetname" );
 
	level waittill("round_started");
 
	if(isdefined(entTransporter))
	{
		for( i = 0; i < entTransporter.size; i++ )
			entTransporter[i] thread transporter(i);
	}
}

transporter(i)
{	
	while(true)
	{
		self waittill( "trigger", player );
		
		iprintlnbold(i);
		iprintlnbold(self.target);

		entTarget = getEnt( self.target, "targetname" );
		player setOrigin( entTarget.origin );
		player setplayerangles( entTarget.angles );
	}
}

// ------------------------ DEATHRUN ------------------------
// ----------------------------------------------------------

if(!plugins\_respect::roomCheck(player))
	continue;

level.respect_noretp = true; // tp back off
level.respect_tp_pos = (0,0,0); // tp back pos

if (isDefined(getEnt("endmap_trig", "targetname")))
	getEnt("endmap_trig", "targetname") delete();
trig = spawn("trigger_radius",(0,0,0),0,150,250);
trig.radius = 150;
trig.targetname = "endmap_trig";

//////////////////////////////////////////////////////////
// spawn trigger near rooms (order)
end_sr()
{
	t1 = spawn("trigger_radius",(-2604,639,65-40),0,100,200);
	t2 = spawn("trigger_radius",(-2436,639,65-40),0,100,200);
	t3 = spawn("trigger_radius",(-2267,639,65-40),0,100,200);

	t1 thread endmapsr();
	t2 thread endmapsr();
	t3 thread endmapsr();
}

endmapsr()
{
	while(1)
	{
		self waittill("trigger",player);

		if(player.pers["team"] == "axis")
    		continue;

		if(isDefined(player.already_check) && player.already_check)
			continue;

		if(!plugins\_respect::roomCheck(player))
			player thread endmap_sefe();
        else
        {
        	player.already_check = true;
        	player thread already_check_reset();
        }
	}
}

endmap_sefe()
{
	self endon("death");
	self endon("disconnect");

	self freezeControls(1);
	if (isDefined(level.respect_tp_pos))
		self setOrigin(level.respect_tp_pos);
	else
		self setOrigin(getEnt("endmap_trig","targetname").origin);
	wait 0.05;
	self freezeControls(0);
}

already_check_reset()
{
	self endon("disconnect");
	self waittill("death");

	self.already_check = undefined;
}
