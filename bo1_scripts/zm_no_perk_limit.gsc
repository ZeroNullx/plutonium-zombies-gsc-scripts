// ============================================================
// BO1 Zombies — Reliable No Perk Limit (T5 Safe)
// ============================================================
// File: Plutonium/storage/t5/scripts/sp/zom/zm_no_perk_limit.gsc
// ============================================================

init()
{
    level thread perk_limit_global_enforce();
    level thread perk_limit_on_connect();
}

// ------------------------------------------------------------
// GLOBAL LEVEL ENFORCER — Keeps global limit unlocked
// ------------------------------------------------------------
perk_limit_global_enforce()
{
    while ( !isDefined(level.perk_purchase_limit) )
        wait 0.05;

    level.perk_purchase_limit = 99;

    while (1)
    {
        if (!isDefined(level.perk_purchase_limit) || level.perk_purchase_limit < 99)
            level.perk_purchase_limit = 99;
        wait 1;
    }
}

// ------------------------------------------------------------
// PLAYER HANDLER — Watches each player connection/spawn
// ------------------------------------------------------------
perk_limit_on_connect()
{
    while (1)
    {
        level waittill("connected", player);
        player thread perk_limit_player_lifecycle();
    }
}

// ------------------------------------------------------------
// PLAYER LOOP — Handles respawns and re-applies limit
// ------------------------------------------------------------
perk_limit_player_lifecycle()
{
    self endon("disconnect");

    while (1)
    {
        self waittill("spawned_player");

        // ensure defined and high limit
        if (!isDefined(self.perk_purchase_limit) || self.perk_purchase_limit < 99)
            self.perk_purchase_limit = 99;

        // confirmation message once per spawn
        self iprintlnbold("^2No Perk Limit Active");

        // monitor and re-assert during play
        while (isAlive(self))
        {
            if (!isDefined(self.perk_purchase_limit) || self.perk_purchase_limit < 99)
                self.perk_purchase_limit = 99;
            wait 1;
        }

        // safety wait before respawn loop restarts
        wait 0.5;
    }
}
