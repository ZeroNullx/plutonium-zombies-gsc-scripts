// ============================================================
// BO1 Zombies — Reliable No Perk Limit (T5 Safe)
// ============================================================
// PLACE SCRIPT INTO: Plutonium/storage/t5/scripts/sp/zom/zm_no_perk_limit.gsc
// REQUIRES: Plutonium/storage/t5/maps/_zombiemode_perks.gsc
// ============================================================

init()
{
	thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill ("connecting", player);

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");

		self.num_perks = -5; //Remove perk limit, must be a negative number

	}
}

