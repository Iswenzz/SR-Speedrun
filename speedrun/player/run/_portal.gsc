start()
{
	self speedrun\player\run\_210::start();

	self allowAds(true);

	weapon = level.portalgun;
	self takeAllWeapons();
	self giveWeapon(weapon);
	self setSpawnWeapon(weapon);
	self giveMaxAmmo(weapon);

	self thread sr\libs\portal\_portal_gun::watch();
}
