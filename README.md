Advanced Car-Lock Script for FiveM
A simple yet highly advanced vehicle locking system for your FiveM server. This script allows players to lock and unlock their vehicles with a single keystroke or attempt to lockpick other vehicles using specialized equipment.

Features
Fully Configurable: Every core mechanic can be adjusted directly inside the config.lua file. No coding knowledge required.

Key Item Requirement: Integrates with your inventory system by requiring a specific item to lock or unlock vehicles.

Lockpicking System: Gives players the ability to break into locked vehicles if they possess the required tool.

Custom Chance & Duration: Fine-tune how long a lockpick attempt takes and the mathematical probability of its success.

Configuration (config.lua)
The script is designed for easy customization. Open the config.lua file and adjust the following variables to match your server's needs:

Lua
Config = {}

-- The control key pressed to lock/unlock the vehicle (Default: 47 = G)
Config.LockKey = 47 

-- The maximum distance (in meters) a player can stand from the vehicle to toggle locks
Config.LockDistance = 5.0 

-- The exact item name required in the database/inventory to act as the car key
Config.CarkeyItem = 'Carkey'

-- The item required to initiate a lockpick attempt on a vehicle
Config.LockpickItem = 'plasma_cutter'

-- The duration of the lockpick progress bar (in milliseconds) (5000 ms = 5 seconds)
Config.LockpickDuration = 5000 

-- The percentage chance that the lockpick attempt succeeds (60 = 60% success rate)
Config.LockpickChance = 60 
Installation
Drag and drop the script folder into your server's resources directory.

Open your server.cfg file and add the following line:

Code-Snippet
ensure Z-CarlockV2
Ensure that the items Carkey and plasma_cutter (or whatever names you chose in the configuration) are correctly registered in your inventory system or database.

Restart your server or use the server console commands refresh and start Z-CarlockV2.

Credits & Support
Developer: Zenon Studios

Support: For questions, bug reports, or assistance, please open a ticket in our Discord server.
