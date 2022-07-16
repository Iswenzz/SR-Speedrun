main()
{
entTransporter = getentarray( "enter", "targetname" );
AmbientPlay( "ambient5" );
if(isdefined(entTransporter))
for( i = 0; i < entTransporter.size; i++ )
entTransporter[i] thread transporter();
}
transporter()
{
for(;;)
{
self waittill( "trigger", player );
entTarget = getEnt( self.target, "targetname" );
player setOrigin( entTarget.origin );
player setplayerangles( entTarget.angles );
player thread sr\api\_speedrun::finishWay("secret_0");

}
}