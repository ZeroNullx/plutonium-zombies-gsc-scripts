/*
    .info, .help, .list, .commands, .discord, and .site command system for Plutonium T6 Zombies
    Author: ZeroNullx
    Includes color styling, independent prefixes, and timed section spacing
*/

#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;

init()
{
    onPlayerSay(::hook_chat_info);
    level thread onPlayerConnect_hud();
}

onPlayerConnect_hud()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread show_info_hint_hud();
    }
}

show_info_hint_hud()
{
    hud = createFontString("objective", 2);
    hud setPoint("CENTER", "TOP", 0, 40);
    hud.alpha = 0;
    hud setText("^5Tip:^7 Use ^3.info^7 to display available commands");
    hud fadeOverTime(0.5);
    hud.alpha = 1;

    wait 7; // display duration

    hud fadeOverTime(1);
    hud.alpha = 0;
    wait 1;
    hud destroy();
}

hook_chat_info(message, mode)
{
    message = toLower(message);

    // Aliases for info/help list
    if (message == ".info" || message == ".help" || message == ".list" || message == ".commands")
    {
        afk_prefix   = "[^6MAfk^7]";
        bank_prefix  = "[^2BANK^7]";
        info_prefix  = "[^5INFO^7]";

        // AFK section
        afk_lines = [];
        afk_lines[0] = afk_prefix + " ^5AFK Commands:";
        afk_lines[1] = "^3.afk^7 - Toggle AFK mode";
        afk_lines[2] = "^3.afk off^7 - Return from AFK";
        afk_lines[3] = "^3.afk time^7 - Check AFK time remaining";

        // Bank section
        bank_lines = [];
        bank_lines[0] = bank_prefix + " ^5Bank Commands:";
        bank_lines[1] = "^3.b^7 - Check current balance";
        bank_lines[2] = "^3.d [amount]^7 - Deposit points (^41k^7 increments)";
        bank_lines[3] = "^3.w [amount]^7 - Withdraw points (^41k^7 increments)";

        // Server info section
        info_lines = [];
        info_lines[0] = info_prefix + " ^5Server Commands:";
        info_lines[1] = "^3.info^7 / ^3.help^7 / ^3.list^7 / ^3.commands^7 - Display this list";
        info_lines[2] = "^3.discord^7 - Join the Discord community";
        info_lines[3] = "^3.site^7 - Visit our website";

        if (isDefined(self.tell))
        {
            foreach(line in afk_lines) { self tell(line); wait 0.5; }
            wait 1.3;

            foreach(line in bank_lines) { self tell(line); wait 0.5; }
            wait 1.3;

            foreach(line in info_lines) { self tell(line); wait 0.5; }
        }
        else
        {
            hud = createFontString("objective", 2);
            hud setPoint("CENTER", "TOP", 0, 50);
            hud setText(info_prefix + " ^5Available Commands:");
            wait 0.7;

            foreach(line in afk_lines) { self iPrintLn(line); wait 0.6; }
            wait 1.3;

            foreach(line in bank_lines) { self iPrintLn(line); wait 0.6; }
            wait 1.3;

            foreach(line in info_lines) { self iPrintLn(line); wait 0.6; }

            wait 8;
            hud destroy();
        }

        return false;
    }

    // .discord — shows invite popup
    if (message == ".discord")
    {
        self iPrintLnBold("[^5INFO^7] Join our Discord:");
        self iPrintLn("^3https://discord.gg/thenet");
        wait 6;
        return false;
    }

    // .site — shows website popup
    if (message == ".site")
    {
        self iPrintLnBold("[^5INFO^7] Visit our website:");
        self iPrintLn("^3https://0nx.dev");
        wait 6;
        return false;
    }

    return true;
}
