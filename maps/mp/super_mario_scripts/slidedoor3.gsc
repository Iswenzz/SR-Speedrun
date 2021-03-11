//////////////////////////////////////////////////////////////
//////////////////////map by jerkan///////////////////////////
//////////////////////////////////////////////////////////////
/////////////////////XFire: jerkan18//////////////////////////
//////////////////////////////////////////////////////////////
///////////////////e-mail: jerkan@net.hr//////////////////////
//////////////////////////////////////////////////////////////
////////////////www.jerkanmaps.weebly.com/////////////////////
//////////////////////////////////////////////////////////////

main() 

{ 
	thread pokretna_vrata3(); 

}

pokretna_vrata3()
{
	doortrig = getEnt( "trigger_vrata3", "targetname" );
	// doortrig.doorclosed = true;

	vrata1 = getEnt( "vrata_l3", "targetname" );
	vrata2 = getEnt( "vrata_r3", "targetname" );
	
	vrata1 delete();
	vrata2 delete();
	doortrig delete();

}

move(other)
{

	vrata1 = getEnt( "vrata_l3", "targetname" );
	vrata2 = getEnt( "vrata_r3", "targetname" );

	self notify("doortrig_finish");
	self.doorclosed = false;
	vrata1 playsound("sm_door");
	vrata1 movey(-34, 2, 0.5, 0.5);
	vrata2 playsound("sm_door");
	vrata2 movey(34, 2, 0.5, 0.5);
	vrata1 waittill ("movedone");

	if(isDefined(other) && other isTouching(self))
	{
		while(isDefined(other) && other isTouching(self))
		{
			wait 2; // Wait until 'other' is no longer touching the trigger
		}
	}

	vrata1 playsound("elevator");
	vrata1 movey(34, 2, 0.5, 0.5);
	vrata2 playsound("sm_door");
	vrata2 movey(-34, 2, 0.5, 0.5);
	vrata1 waittill ("movedone");
	self.doorclosed = true;
}
