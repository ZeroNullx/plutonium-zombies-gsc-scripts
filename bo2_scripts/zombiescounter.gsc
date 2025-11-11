#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

/*
    Mod: Zombies Counter (Bottom Center + Glow)
    Developed by Cabcon, tweaked by ZeroNullx
    Repositioned and styled by ChatGPT (Bottom-Center HUD)
*/

init()
{
    init_ZombiesCounter();
}

init_ZombiesCounter()
{
    zombiesCounter = createServerFontString("objective", 1.4);

    // Manual bottom-center anchor (works in server HUD)
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
    oldZombiesCount = 0;

    while (true)
    {
        zombiesCount = get_current_zombie_count();

        if (zombiesCount > 0)
        {
            if (oldZombiesCount != zombiesCount)
            {
                oldZombiesCount = zombiesCount;
                zombiesCounter setText("^7Zombies: ^1" + zombiesCount);
            }
        }
        else
        {
            zombiesCounter affectElement("alpha", 0.2, 0);
            wait 0.2;
            zombiesCounter affectElement("alpha", 0.5, 1);
            zombiesCounter setText("^3Loading...");

            ZC_WaitZombiesRespawn();

            zombiesCounter affectElement("alpha", 0.2, 0);
            wait 0.2;
            zombiesCounter setText("^7Zombies: ^1" + get_current_zombie_count());
            zombiesCounter affectElement("alpha", 0.5, 1);
        }

        wait 0.5;
    }
}

ZC_WaitZombiesRespawn()
{
    while (get_current_zombie_count() == 0)
    {
        wait 0.05;
    }
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
