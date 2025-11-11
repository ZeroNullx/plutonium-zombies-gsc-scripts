#include maps\_utility;
#include common_scripts\utility;

init()
{
    if ( GetDvar( #"zombiemode" ) == "1" )
        level thread on_player_connect();
}

// -------------------- PLAYER CONNECT --------------------
on_player_connect()
{
    while (1)
    {
        level waittill("connected", player);
        player thread on_player_lifecycle();
    }
}

// -------------------- HANDLE RESPAWN / SPECTATE --------------------
on_player_lifecycle()
{
    self endon("disconnect");

    while (1)
    {
        self waittill("spawned_player");

        // remove any old HUDs
        self thread hud_remove();

        // create new HUDs
        self thread hud_create();

        // wait until death or spectator
        self waittill("death");
        self thread hud_remove();
    }
}

// -------------------- CLEAR OLD HUD --------------------
hud_remove()
{
    if (isDefined(self.hud_health_label))
    {
        self.hud_health_label destroy();
        self.hud_health_label = undefined;
    }
    if (isDefined(self.hud_health_val))
    {
        self.hud_health_val destroy();
        self.hud_health_val = undefined;
    }
    if (isDefined(self.hud_zm_label))
    {
        self.hud_zm_label destroy();
        self.hud_zm_label = undefined;
    }
    if (isDefined(self.hud_zm_val))
    {
        self.hud_zm_val destroy();
        self.hud_zm_val = undefined;
    }
}

// -------------------- CREATE HUD --------------------
hud_create()
{
    // HEALTH LABEL
    self.hud_health_label = NewClientHudElem(self);
    self.hud_health_label.horzAlign = "center";
    self.hud_health_label.vertAlign = "bottom";
    self.hud_health_label.alignX = "center";
    self.hud_health_label.alignY = "bottom";
    self.hud_health_label.x = -50;
    self.hud_health_label.y = -37;
    self.hud_health_label.foreground = 1;
    self.hud_health_label.fontscale = 1.4;
    self.hud_health_label.alpha = 1;
    self.hud_health_label.color = (0.8,0.8,0.8);
    self.hud_health_label SetText("HP:");

    // HEALTH VALUE
    self.hud_health_val = NewClientHudElem(self);
    self.hud_health_val.horzAlign = "center";
    self.hud_health_val.vertAlign = "bottom";
    self.hud_health_val.alignX = "center";
    self.hud_health_val.alignY = "bottom";
    self.hud_health_val.x = -15;
    self.hud_health_val.y = -37;
    self.hud_health_val.foreground = 1;
    self.hud_health_val.fontscale = 1.4;
    self.hud_health_val.alpha = 1;
    self.hud_health_val.color = (0,1,0);
    self.hud_health_val SetValue(self.health);

    // ZOMBIE LABEL
    self.hud_zm_label = NewClientHudElem(self);
    self.hud_zm_label.horzAlign = "center";
    self.hud_zm_label.vertAlign = "bottom";
    self.hud_zm_label.alignX = "center";
    self.hud_zm_label.alignY = "bottom";
    self.hud_zm_label.x = 25;
    self.hud_zm_label.y = -37;
    self.hud_zm_label.foreground = 1;
    self.hud_zm_label.fontscale = 1.4;
    self.hud_zm_label.alpha = 1;
    self.hud_zm_label.color = (0.8,0.8,0.8);
    self.hud_zm_label SetText("ZM:");

    // ZOMBIE VALUE
    self.hud_zm_val = NewClientHudElem(self);
    self.hud_zm_val.horzAlign = "center";
    self.hud_zm_val.vertAlign = "bottom";
    self.hud_zm_val.alignX = "center";
    self.hud_zm_val.alignY = "bottom";
    self.hud_zm_val.x = 60;
    self.hud_zm_val.y = -37;
    self.hud_zm_val.foreground = 1;
    self.hud_zm_val.fontscale = 1.4;
    self.hud_zm_val.alpha = 1;
    self.hud_zm_val.color = (1,0,0);
    self.hud_zm_val SetValue(0);

    self thread hud_update_loop();
}

// -------------------- UPDATE HUD --------------------
hud_update_loop()
{
    self endon("disconnect");
    self endon("death");

    if (!isDefined(self.maxhealth) || self.maxhealth <= 0)
        self.maxhealth = 100;

    while (isAlive(self))
    {
        hp = self.health;

        // health color
        if (hp > 100)
            self.hud_health_val.color = (1,0,1);   // purple
        else if (hp == 100)
            self.hud_health_val.color = (0,1,0);   // green
        else
            self.hud_health_val.color = (1,0,0);   // red

        self.hud_health_val SetValue(int(hp));

        zmcount = get_enemy_count();
        self.hud_zm_val SetValue(zmcount);

        wait 0.1;
    }
}

// -------------------- ZOMBIE COUNT --------------------
get_enemy_count()
{
    enemies = GetAiSpeciesArray("axis", "all");
    valid = [];
    i = 0;
    while (i < enemies.size)
    {
        e = enemies[i];
        if (is_true(e.ignore_enemy_count))
        {
            i++;
            continue;
        }
        if (isDefined(e.animname))
            valid = array_add(valid, e);
        i++;
    }
    return valid.size;
}
