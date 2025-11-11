#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;

/*
    No Perk Limit (BO2 T6 ZM)
    - Removes 4-perk cap by forcing perk purchase limit high
    - Reasserts periodically to prevent resets
*/

init()
{
    level thread npl_init(9); // set your cap here
}

npl_init(limit)
{
    level endon("end_game");
    flag_wait("initial_blackscreen_passed");

    npl_apply(limit);
    level thread npl_reapply_loop(limit);
    level thread npl_on_connect_assert(limit);
}

npl_apply(limit)
{
    // no 'string()' — just pass int
    setDvar("perk_purchase_limit", limit);

    level.perk_purchase_limit = limit;
    level.zm_perk_limit = limit;
    level.zombies_perk_limit = limit;
}

npl_reapply_loop(limit)
{
    for (;;)
    {
        wait 5.0;
        npl_apply(limit);
    }
}

npl_on_connect_assert(limit)
{
    for (;;)
    {
        level waittill("connected", player);
        player thread npl_player_touch(limit);
    }
}

npl_player_touch(limit)
{
    self endon("disconnect");

    self.perk_purchase_limit = limit;
    wait 1.0;
    self.perk_purchase_limit = limit;
}
