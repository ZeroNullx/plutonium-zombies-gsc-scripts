// zm_lod_enforcer.gsc — force client LOD dvars for each player

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread enforce_lod_loop();
    }
}

enforce_lod_loop()
{
    self endon("disconnect");

    // apply once on connect
    self setclientdvar("r_lodBiasRigid", "-1000");
    self setclientdvar("r_lodBiasSkinned", "-1000");

    // re-apply every 30s in case a menu/mod resets them
    for (;;)
    {
        wait 30;
        self setclientdvar("r_lodBiasRigid", "-1000");
        self setclientdvar("r_lodBiasSkinned", "-1000");
    }
}
