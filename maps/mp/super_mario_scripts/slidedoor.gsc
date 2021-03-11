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
	thread pokretna_vrata(); 

}

pokretna_vrata()
{
	doortrig = getEnt( "trigger_vrata", "targetname" );
	doortrig delete();

	vrata1 = getEnt( "vrata_l", "targetname" );
	vrata2 = getEnt( "vrata_r", "targetname" );
	
	vrata1 delete();
	vrata2 delete();

}

move(other)
{

	vrata1 = getEnt( "vrata_l", "targetname" );
	vrata2 = getEnt( "vrata_r", "targetname" );

	self notify("doortrig_finish");
	self.doorclosed = false;
	vrata1 playsound("sm_door");
	vrata1 movex(-64, 2, 0.5, 0.5);
	vrata2 playsound("sm_door");
	vrata2 movex(64, 2, 0.5, 0.5);
	vrata1 waittill ("movedone");

	if(isDefined(other) && other isTouching(self))
	{
		while(isDefined(other) && other isTouching(self))
		{
			wait 2; // Wait until 'other' is no longer touching the trigger
		}
	}

	vrata1 playsound("elevator");
	vrata1 movex(64, 2, 0.5, 0.5);
	vrata2 playsound("sm_door");
	vrata2 movex(-64, 2, 0.5, 0.5);
	vrata1 waittill ("movedone");
	self.doorclosed = true;
}
