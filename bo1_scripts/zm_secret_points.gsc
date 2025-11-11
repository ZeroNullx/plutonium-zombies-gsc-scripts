#include maps\_utility;
#include common_scripts\utility;

init()
{
    if ( GetDvar(#"zombiemode") == "1" )
        level thread bp_on_connect();
}

// ------------------------------------------------------------
// Player connect handler
// ------------------------------------------------------------
bp_on_connect()
{
    while (1)
    {
        level waittill("connected", player);
        player thread bp_player_loop();
    }
}

// ------------------------------------------------------------
// Per-player loop
// ------------------------------------------------------------
bp_player_loop()
{
    self endon("disconnect");

    // one entry per player; holds rounds already used
    self.bp_claimed_rounds = [];

    while (1)
    {
        self waittill("spawned_player");
        self thread bp_check_inputs();
    }
}

// ------------------------------------------------------------
// Input watcher – aim + melee = bonus if eligible
// ------------------------------------------------------------
bp_check_inputs()
{
    self endon("disconnect");
    self endon("death");

    while (isAlive(self))
    {
        if ( self ADSButtonPressed() && self MeleeButtonPressed() )
        {
            r = level.round_number;

            bonus = 0;
            if (r == 1)
                bonus = 1000;
            else if (r == 5)
                bonus = 1500;
            else if (r == 13)
                bonus = 2500;
            else if (r == 18)
                bonus = 5000;

            if (bonus > 0 && !bp_has_claimed(self, r))
            {
                bp_add_claim(self, r);
                self maps\_zombiemode_score::add_to_player_score(bonus);
                self playsound("zmb_spawn_powerup");
                self iprintlnbold("^2Bonus! ^7+" + bonus + " Points");
            }

            wait 0.5; // debounce
        }

        wait 0.05;
    }
}

// ------------------------------------------------------------
// Array helpers (T5-compatible manual versions)
// ------------------------------------------------------------
bp_has_claimed(player, roundnum)
{
    if (!isDefined(player.bp_claimed_rounds))
        return false;

    i = 0;
    while (i < player.bp_claimed_rounds.size)
    {
        if (player.bp_claimed_rounds[i] == roundnum)
            return true;
        i++;
    }
    return false;
}

bp_add_claim(player, roundnum)
{
    if (!isDefined(player.bp_claimed_rounds))
    {
        player.bp_claimed_rounds = [];
        player.bp_claimed_rounds[0] = roundnum;
        return;
    }

    idx = player.bp_claimed_rounds.size;
    player.bp_claimed_rounds[idx] = roundnum;
}
