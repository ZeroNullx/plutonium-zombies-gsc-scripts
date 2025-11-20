## BO1 – No Perk Limit Script

This snippet explains how to use **no_perk_limit.gsc** with your Black Ops 1 zombies mod setup on Plutonium.

### Requirements
To ensure the script works correctly, you must place the following file in the proper directory:

- **_zombiemode_perks.gsc**  
  Location:  
  `Plutonium/storage/t5/maps/`

### Usage
1. Place **no_perk_limit.gsc** inside `Plutonium/storage/t5/script/sp/zom/`.
2. Make sure **_zombiemode_perks.gsc** is installed in the path shown above so the game can override the perk logic.
3. Load your script as usual. Once in game, the perk limit will be removed and all perks can be purchased without restriction.

### Notes
This script overrides the default perk system. If you have other perk-related edits, verify they do not conflict with the modified `_zombiemode_perks.gsc`.
