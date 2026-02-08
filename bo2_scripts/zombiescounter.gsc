#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

/*
    Mod: Zombies Counter (Bottom Center + Glow)
    Developed by Cabcon, tweaked by ZeroNullx
*/

init()
{
    init_ZombiesCounter();
}

init_ZombiesCounter()
{
    zombiesCounter = createServerFontString("objective", 1.4);

    zombiesCounter.alignX = "center";
    zombiesCounter.alignY = "bottom";
    zombiesCounter.horzAlign = "center";
    zombiesCounter.vertAlign = "bottom";
    zombiesCounter.x = 0;
    zombiesCounter.y = -10;

    zombiesCounter.hideWhenInMenu = 1;
    zombiesCounter.archived = 0;

    zombiesCounter.foreground = 1;
    zombiesCounter.glowColor = (0, 0, 0);
    zombiesCounter.glowAlpha = 0.35;
    zombiesCounter.glowSize = 2;
    zombiesCounter.color = (1, 1, 1);

    flag_wait("initial_blackscreen_passed");
    level thread ZC_Monitor(zombiesCounter);
    level thread ZC_HideOnEndGame(zombiesCounter);
}

ZC_HideOnEndGame(zombiesCounter)
{
    level waittill("end_game");
    zombiesCounter affectElement("alpha", 4, 0);
    wait 4;
    zombiesCounter destroy();
}

ZC_Monitor(zombiesCounter)
{
    level endon("end_game");
    oldRemaining = -1;

    while (true)
    {
        remaining = get_zombies_remaining_to_kill();

        if (remaining >= 0)
        {
            if (oldRemaining != remaining)
            {
                oldRemaining = remaining;
                zombiesCounter setText("^7Zombies Remaining: ^1" + remaining);
            }
        }
        else
        {
            zombiesCounter affectElement("alpha", 0.2, 0);
            wait 0.2;
            zombiesCounter affectElement("alpha", 0.5, 1);
            zombiesCounter setText("^3Loading...");
        }

        wait 0.5;
    }
}

/*
    BO2 Zombies Remaining:
      remaining = alive + left_to_spawn

    - Spawning: alive++, left_to_spawn-- => remaining stays the same
    - Killing:  alive--, left_to_spawn unchanged => remaining goes down
*/
get_zombies_remaining_to_kill()
{
    // left_to_spawn is the BO2 round spawner's remaining count
    if (!isDefined(level.zombie_total))
        return -1;

    aliveArr = get_round_enemy_array();
    if (!isDefined(aliveArr))
        return -1;

    return aliveArr.size + level.zombie_total;
}

affectElement(type, time, value)
{
    if (type == "x" || type == "y")
        self moveOverTime(time);
    else
        self fadeOverTime(time);

    if (type == "x")
        self.x = value;
    if (type == "y")
        self.y = value;
    if (type == "alpha")
        self.alpha = value;
    if (type == "color")
        self.color = value;
}
