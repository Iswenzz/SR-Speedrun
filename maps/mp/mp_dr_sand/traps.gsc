main()
{
	thread trap1();
		level.sand_trap1 = loadFX("mp_dr_sand/sand_trap1");
		level.smoke_trap1 = loadFX("mp_dr_sand/smoke_trap1");
		level.fire_trap1 = loadFX("mp_dr_sand/fire_trap1");
		level.water_trap1 = loadFX("mp_dr_sand/water_trap1");
	thread trap2();
		level.fire_trap2 = loadFX("mp_dr_sand/fire_trap2");
		level.fire2_trap2 = loadFX("mp_dr_sand/fire2_trap2");
		level.fire3_trap2 = loadFX("mp_dr_sand/fire3_trap2");
		level.fire4_trap2 = loadFX("mp_dr_sand/fire4_trap2");
	thread trap3();
		level.explo_trap3 = loadFX("mp_dr_sand/explo_trap3");
	thread trap4();
	thread trap5();
}

flote(objet)
{
	while(1)
	{
		objet moveZ(-10,4,.5,.5);
		wait 4;
		objet moveZ(10,4,.5,.5);
		wait 4;
	}
}



trap1()
{
	pelle1=getent("trap1_brush1","targetname");
	pelle2=getent("trap1_brush2","targetname");
	sable=getent("trap1_brush4","targetname");
	trig=getent("trap1_trig","targetname");
	ori=getent("trap1_ori","targetname");
	ori2=getent("trap1_ori2","targetname");
	brush=getent("trap1_dmg1","targetname");
	dmg=getent("trap1_dmg2","targetname");
	brush2=getent("trap1_button","targetname");
	trig2=getent("trap1_but_trig","targetname");
	
	dmg enablelinkto();
	dmg linkto(brush);
	trig2 enablelinkto();
	trig2 linkto(brush2);
	
	wait 1;
	
	sable hide();
	sable MoveZ(-96, 1);
	brush hide();
	brush2 moveZ(-70,1);
	
}


trap2()
{
	ori1=getent("trap2_ori1","targetname");
	ori2=getent("trap2_ori2","targetname");
	ori3=getent("trap2_ori3","targetname");
	ori4=getent("trap2_ori4","targetname");
	trig=getent("trap2_trig","targetname");
	brush=getent("trap2_dmg","targetname");
	dmg1=getent("trap2_dmg1","targetname");
	dmg2=getent("trap2_dmg2","targetname");
	dmg3=getent("trap2_dmg3","targetname");
	dmg4=getent("trap2_dmg4","targetname");
	
	brush hide();
	
	dmg1 enablelinkto();
	dmg1 linkto(brush);
	dmg2 enablelinkto();
	dmg2 linkto(brush);
	dmg3 enablelinkto();
	dmg3 linkto(brush);
	dmg4 enablelinkto();
	dmg4 linkto(brush);
	
	brush moveZ(500,1);
}


trap3()
{
	c4=getent("trap3_c4","targetname");
	c42=getent("trap3_c42","targetname");
	c43=getent("trap3_c43","targetname");
	c44=getent("trap3_c44","targetname");
	c45=getent("trap3_c45","targetname");
	c46=getent("trap3_c46","targetname");
	c47=getent("trap3_c47","targetname");
	c48=getent("trap3_c48","targetname");
	c49=getent("trap3_c49","targetname");
	c5=getent("trap3_c5","targetname");
	trig=getent("trap3_trig","targetname");
	brush1=getent("trap3_brush1","targetname");
	brush2=getent("trap3_brush2","targetname");
	brush3=getent("trap3_brush3","targetname");
	brush4=getent("trap3_brush4","targetname");
	ori=getent("trap3_ori","targetname");
	ori2=getent("trap3_ori2","targetname");
	dmg=getent("trap3_dmg","targetname");
	dmg2=getent("trap3_dmg2","targetname");
	
	dmg2 hide();
	dmg enablelinkto();
	dmg linkto(dmg2);
	dmg2 moveZ(1000,1);
	
}


trap4()
{
	trig=getent("trap4_trig","targetname");
	brush=getent("trap4_brush","targetname");
}


trap5()
{
	trig=getent("trap5_trig","targetname");
	brush1=getent("trap5_brush1","targetname");
	brush2=getent("trap5_brush2","targetname");
}

