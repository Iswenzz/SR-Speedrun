start()
{
	self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(0.9);
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);
	self.speed = sr\api\_map::getSpeed(320);

	if (sr\api\_speedrun::isSlide())
	{
		self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.8);
		self.gravity = sr\api\_map::getGravity(1000);
		self.jumpHeight = sr\api\_map::getJumpHeight(70);
		self.speed = sr\api\_map::getSpeed(190 * level.map_slide_multiplier);
	}

	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self setMoveSpeedScale(self.moveSpeedScale);
	self setGravity(self.gravity);
	self setJumpHeight(self.jumpHeight);
	self setMoveSpeed(self.speed);

	if (!level.defragStartWeapons.size)
	{
		for (i = 0; i < level.weapons.size; i++)
		{
			weapon = level.weapons[i]["item"];
			self setWeaponAmmoClip(weapon, 0);
			self setWeaponAmmoStock(weapon, 0);
		}
		return;
	}

	self takeAllWeapons();
	for (i = 0; i < level.defragStartWeapons.size; i++)
	{
		weapon = level.defragWeapons[level.defragStartWeapons[i]];
		self giveWeapon(weapon);
		if (i == 0)
			self setSpawnWeapon(weapon);
	}
}
