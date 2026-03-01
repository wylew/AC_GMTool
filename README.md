# AC_GMTool
My Gm tool for private azerothcore server

AzerothCore GM Tool v2.5 — Readme
This addon is a comprehensive management suite designed specifically for AzerothCore (3.3.5a) Game Masters. It provides a graphical interface for the most common server commands, a searchable item/spell database, and a built-in command wiki.
## Core Features
• GM Sidebar: A collapsible, draggable menu for quick access to level adjustments, gold, and skill boosting.
• Searchable Database: Real-time search for items and spells. Surfaces results directly from the server's .lookup commands into a UI list.
• Dressing Room Integration: Preview any item from the search results using Ctrl+Click on the icon.
• Command Wiki: A categorized, searchable library of AzerothCore GM commands with "Run" buttons to automate syntax.
• Mount & Teleport Hubs: Quick-access slide-out menus for legendary mounts and major city coordinates.
• Super Speed/Fly Toggle: A single button to toggle GM flight and 10x movement speed simultaneously.
## Installation
1. Navigate to your World of Warcraft directory: World of Warcraft/Interface/AddOns/.
2. Create a new folder named AC_GMTool.
3. Place AC_GMTool.lua and AC_GMTool.toc inside that folder.
4. Restart World of Warcraft.
5. Click the Blizzard Icon on your Minimap to open the tool.
## Usage Guide
Search & Database
1. Click Search DB.
2. Type a keyword (e.g., "Frostmourne") and hit Search.
3. The results window will populate with icons.
• Left-Click "Add": Grants the item/spell to your current target.
• Ctrl+Click Icon: Opens the Dressing Room to preview the item.
• Mouseover: Displays the standard in-game tooltip.
Command Wiki
• If you forget a command syntax, open the Command Wiki.
• Use the search bar at the top to filter by keyword (e.g., "ban" or "modify").
• Click Run to execute the command. If the command requires a variable (like a player name), it will automatically open your chat box and pre-type the command for you.
Teleports & Mounts
• Click the >> buttons to expand sub-menus.
• Use the Custom... buttons within these menus to manually enter coordinates or specific Spell IDs not listed in the defaults.
## Troubleshooting
• Search results not appearing? Ensure you have GM permissions on the server. The addon "listens" to the system messages sent by the server after a .lookup command.
• Icons showing as Question Marks? This happens if the item is not in your local cache. Hover your mouse over the icon for one second; the addon will force the client to request the data from the server. Re-opening the search will usually fix the icon.
• Window is off-screen? You can reset the position by deleting the AC_GM_Angle line in your WTF/Account/YOUR_NAME/SavedVariables/AC_GMTool.lua file.
