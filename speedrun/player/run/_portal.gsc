start()
{
	self speedrun\player\run\_210::start();

	self endon("disconnect");
	self endon("death");

	self allowAds(true);

	weapon = level.portalgun;
	self takeAllWeapons();
	self giveWeapon(weapon);
	self setSpawnWeapon(weapon);
	self giveMaxAmmo(weapon);

	while (true)
	{
		wait 0.05;

		if (self getCurrentWeapon() != level.portalgun || self isOnLadder() || self isMantling() || self.throwingGrenade)
		{
			self sr\libs\portal\_hud::updateHud("none");
			wait 1;
			continue;
		}

		color = undefined;
		if (self attackButtonPressed())
			color = "blue";
		else if (self aimButtonPressed())
			color = "red";
		else if (self fragButtonPressed())
			self sr\libs\portal\_portal_gun::resetPortals();

		if (isDefined(color))
		{
			self playLocalSound("portal_gun_shoot_" + color);
			self thread sr\libs\portal\_portal_gun::portal(color);
		}
		while (self attackButtonPressed() || self aimButtonPressed() || self fragButtonPressed())
			wait 0.05;
	}
}
