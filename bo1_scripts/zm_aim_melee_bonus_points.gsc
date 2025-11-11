#include maps\_utility;
#include common_scripts\utility;

init()
{
    if ( GetDvar( #"zombiemode" ) == "1" )
        level thread on_player_connect();
}

on_player_connect()
{
    while (1)
    {
        level waittill( "connected", player );
        player thread on_player_spawned();
    }
}

on_player_spawned()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );

    // Start monitor for aim + melee combo
    self thread bonus_aim_melee();
}

// ============================================================
// GIVE POINTS WHEN AIM + MELEE PRESSED TOGETHER
// ============================================================
bonus_aim_melee()
{
    self endon( "disconnect" );

    while (1)
    {
        // wait until both buttons held: ADS + melee
        if ( self adsButtonPressed() && self meleeButtonPressed() )
        {
            // cooldown check
            if ( !isDefined( self.last_bonus_time ) || ( gettime() - self.last_bonus_time ) > 5000 )
            {
                self.last_bonus_time = gettime();

                bonus = 40000;

                if ( !isDefined( self.score ) )
                    self.score = 0;

                self.score += bonus;
                self maps\_zombiemode_score::player_add_points( bonus );

                self iprintlnbold( "^2+40,000 Bonus Points!" );
            }

            // prevent multiple triggers from one press
            wait 0.3;
        }

        wait 0.05;
    }
}
