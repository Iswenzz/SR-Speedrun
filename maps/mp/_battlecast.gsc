/*
------------------------------------------------------------------------------
##############################################################################
##|       |##\  \####/  /##|        |##|        |##|        |##|   \####|  |##
##|   _   |###\  \##/  /###|  ______|##|   __   |##|   __   |##|    \###|  |##
##|  |_|  |####\  \/  /####|  |########|  |  |  |##|  |  |  |##|  \  \##|  |##
##|       |#####\    /#####|  |########|  |  |  |##|  |  |  |##|  |\  \#|  |##
##|       |######|  |######|  |########|  |  |  |##|  |  |  |##|  |#\  \|  |##
##|  |\  \#######|  |######|  |########|  |__|  |##|  |__|  |##|  |##\  |  |##
##|  |#\  \######|  |######|        |##|        |##|        |##|  |###\    |##
##|__|##\__\#####|__|######|________|##|________|##|________|##|__|####\___|##
##############################################################################
------------------------------------------------------------------------------
	Please give me credits for using this in your map/mod.
------------------------------------------------------------------------------
*/

init()
{
	level.battlecast["fireball_idle"] = LoadFX("fire/firelp_med_pm");
	level.battlecast["fireball_explosion"] = LoadFX("mag/fireball2_explosion");
	
	level.battlecast["firewall"] = LoadFX("mag/firewall3");
	
	level.battlecast["lightning"] = LoadFX("mag/lightning3");
	level.battlecast["lightning_impact"] = LoadFX("mag/lightning3_explosion");
}

FinalFightPower()
{
	self.maxhealth = 300;
	self.health = self.maxhealth;
	self thread UseSpells();
	self thread SuperJumping( 5 );
}

SuperJumping( strenght )
{
	self endon("disconnect");
	self endon("death");
	level endon("game over");
	
	oldpos = self.origin;
	jumped = false;
	
	if( !isDefined( strenght ) || strenght < 1 )
		strenght = 1;
	
	while(1)
	{
		if((self.origin[2] - oldpos[2] ) > 10  && !self IsOnGround() && !jumped)
		{
			if(jumped)
				continue;
			for(i=0;i<strenght;i++)
			{
				self.health += 100;
				self finishPlayerDamage(self, level.jumpattacker, 100, 0, "MOD_FALLING", "shock_mp", self.origin, AnglesToForward((-90,0,0)), "none", 0);
			}
			jumped = true;
		}
		else if(oldpos[2] > self.origin[2] && self IsOnGround() && jumped)
			jumped = false;
		oldpos = self.origin;
		wait 0.1;
	}
}

UseSpells()
{
	self endon("disconnect");
	self endon("death");
	level endon("game over");
	
	delay = 0;
	self.cur_spell = 1;
	
	while(1)
	{
		if( self AttackButtonPressed() && delay < 1 )
		{
			if( self.cur_spell == 1 )
				self thread CastFireBall();
			else if( self.cur_spell == 2 )
				self thread CastFireWall();
			else if( self.cur_spell == 3 )
				self thread CastLightning();
			delay = 30;
		}
		if( self FragButtonPressed() )
		{
			self.cur_spell++;
			if( self.cur_spell > 4 )
				self.cur_spell = 1;
			self iprintlnbold("You choosed: " + GetSpellNameByNum( self.cur_spell ) );
		}
		if( delay > 0 )
			delay --;
		while( self AttackButtonPressed() || self FragButtonPressed() )
			wait 0.1;
		wait 0.1;
	}
}

GetSpellNameByNum( num )
{
	if( num == 1 )
		return "fireball";
	else if( num == 2 )
		return "firewall";
	else if( num == 3 )
		return "lightning";
	else
		return "none";
}

CastFireBall()
{
	Obj = Spawn("script_model", self GetEye()+AnglesToForward( self GetPlayerAngles() )*30 );
	Obj setModel("tag_origin");
	Obj.angles = self GetPlayerAngles();
	wait 0.05;
	PlayFXOnTag( level.battlecast["fireball_idle"], Obj, "tag_origin" );
	
	obj PlaySound("fire_cast");
	obj PlayLoopSound("firewall");
	
	while(1)
	{
		target = obj.origin+AnglesToForward( obj.angles )*80;
		obj MoveTo( target, 0.1, 0, 0 );
		if( !BulletTracePassed( obj.origin, target, true, self ) )
			break;
		wait 0.1;
	}
	Obj PlaySound("explo_metal_rand");
	PlayFX( level.battlecast["fireball_explosion"], obj.origin );
	EarthQuake( 1, 1, obj.origin, 600 );
	RadiusDamage( obj.origin, 400, 100, 30, self );
	obj delete();
}

CastFireWall()
{
	obj = Spawn("script_model", self GetEye()+AnglesToForward( self GetPlayerAngles() )*30 );
	obj SetModel("tag_origin");
	obj.angles = self GetPlayerAngles();
	wait 0.05;
	PlayFXOnTag( level.battlecast["firewall"], obj, "tag_origin" );
	
	obj PlaySound("fire_cast");
	obj PlayLoopSound("firewall");
	
	target = obj.origin+AnglesToForward( obj.angles )*600;
	obj MoveTo( target, 4, 0, 0 );
	
	time = 40;
	
	while(1)
	{
		if( time > 0 )
		{
			RadiusDamage( obj.origin, 200, 20, 10, self );
			time --;
		}
		else
			break;
		wait 0.1;
	}
	obj delete();
}

CastLightning()
{
	trace = BulletTrace( self GetEye(), self GetEye()+AnglesToForward( self GetPlayerAngles() )*3000, false, self );
	center = trace["position"];
	
	obj = Spawn("script_origin", center );
	
	x = 5+RandomInt(3);
	for(i=0;i<x;i++)
	{
		pos = center+(RandomInt(200,-200),RandomInt(200,-200),0);
		trace = BulletTrace( pos+(0,0,200), pos-(0,0,600), false, self );
		obj.origin = trace["position"];
		obj PlaySound("lightning");
		PlayFX( level.battlecast["lightning"], trace["position"] );
		PlayFX( level.battlecast["lightning_impact"], trace["position"] );
		EarthQuake( 1, 1, trace["position"], 400 );
		RadiusDamage( trace["position"], 100, 50, 15, self );
		wait 0.3+RandomFloat(0.2);
	}
	obj delete();
}

/*
##############################################################################
##|       |##\  \####/  /##|        |##|        |##|        |##|   \####|  |##
##|   _   |###\  \##/  /###|  ______|##|   __   |##|   __   |##|    \###|  |##
##|  |_|  |####\  \/  /####|  |########|  |  |  |##|  |  |  |##|  \  \##|  |##
##|       |#####\    /#####|  |########|  |  |  |##|  |  |  |##|  |\  \#|  |##
##|       |######|  |######|  |########|  |  |  |##|  |  |  |##|  |#\  \|  |##
##|  |\  \#######|  |######|  |########|  |__|  |##|  |__|  |##|  |##\  |  |##
##|  |#\  \######|  |######|        |##|        |##|        |##|  |###\    |##
##|__|##\__\#####|__|######|________|##|________|##|________|##|__|####\___|##
##############################################################################
*/