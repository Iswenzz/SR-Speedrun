main()
{
while(1)
{
thread obrazy();
wait 20;
}
}

obrazy()
{
 rightbut=RandomIntRange(0,4);
 for(i=0; i<4; i++) 
 {
  thread WaitforInput(i,rightbut);
 }

}

WaitforInput(i,rightbut)
{
 trig=getent ("obraz_"+i,"targetname");

 if (i==rightbut)
    {
     trig thread OpenGate();
    }

}

OpenGate()
{
self movey(121,5);
wait 10;
self movey(-121,5);
}