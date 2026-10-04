/*Map Dedicated to my Beloved Vistic
 Map By CoMpy.
  /devmap mp_dr_trancemaster

65.40
122.70
1
#A19F00FF
#400606FF 
                                                                                                            
     ***** *      **           *****  *       *******      ****           *         *****  *       * ***    
  ******  *    *****        ******  *       *       ***   *  *************       ******  *       *  ****  * 
 **   *  *       *****     **   *  *       *         **  *     *********        **   *  *       *  *  ****  
*    *  **       * **     *    *  *        **        *   *     *  *            *    *  *       *  **   **   
    *  ***      *             *  *          ***           **  *  **                *  *       *  ***        
   **   **      *            ** **         ** ***            *  ***               ** **      **   **        
   **   **      *            ** **          *** ***         **   **               ** **      **   **        
   **   **     *           **** **            *** ***       **   **             **** **      **   **        
   **   **     *          * *** **              *** ***     **   **            * *** **      **   **        
   **   **     *             ** **                ** ***    **   **               ** **      **   **        
    **  **    *         **   ** **                 ** **     **  **          **   ** **       **  **        
     ** *     *        ***   *  *                   * *       ** *      *   ***   *  *         ** *      *  
      ***     *         ***    *          ***        *         ***     *     ***    *           ***     *   
       *******           ******          *  *********           *******       ******             *******    
         ***               ***          *     *****               ***           ***                ***      
                                        *                                                                   
                                         **                                                                 
                                                                                                            

*/

main()
{
    maps\mp\_load::main();
    maps\mp\mp_dr_trancemaster_fx::main();

    game["allies"] = "marines";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "desert";
    game["axis_soldiertype"] = "desert";

    setdvar("bg_falldamageminheight" , "99998");
    setdvar("bg_falldamagemaxheight" , "99999");
    setdvar("cg_drawdecals" ,"1");

    thread autorotation();
}

autorotation()
{
 pillars = getent("pillars","targetname");
 platform = getent("platform","targetname");//snip top
 platform1 = getent("platform1","targetname");//snip bottom

  for(;;) 
  {
   pillars rotateYaw (360,5);
   platform rotateYaw (360,5);
   platform1 rotateYaw (360,5);
   wait 4;
  }
}
