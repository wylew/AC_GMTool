# AzerothCore GM Tool v2.5

An advanced, lightweight graphical interface for Game Masters on **AzerothCore (3.3.5a)**. This tool replaces the need to memorize hundreds of chat commands by providing a searchable database, a command wiki, and quick-access utility menus.

---

## 🚀 Features

### 🛠️ Main Sidebar
* **Character Management:** One-click Level 80, 10k Gold, and Max Weapon Skills.
* **Profession Suite:** Buttons for Max Profession Skills and a prompt to learn all recipes for any specific profession.
* **Movement Toggle:** Combined **Speed + Fly** button (sets speed to 10x and enables GM flight).
* **Draggable UI:** Move the sidebar anywhere; position is saved across sessions.

### 🔍 Search Engine & Dressing Room
* **Real-Time Capture:** Automatically captures results from `.lookup item` and `.lookup spell` into a clean UI list.
* **AtlasLoot Style Tooltips:** Hover over icons to see full item stats and spell descriptions.
* **Preview System:** **Ctrl + Left Click** any item icon to open the in-game Dressing Room.
* **Smart Filtering:** Separates Items and Spells into distinct, scrollable categories.

### 📚 Command Wiki
* **Full Database:** Contains essential AzerothCore commands (Account, NPC, Server, Cheat, etc.).
* **Live Search:** Filter the entire command list by keyword (e.g., "ban", "tele", "modify").
* **Smart Run:** Clicking "Run" executes simple commands instantly or pre-fills your chat box for commands requiring parameters.

### 🐎 Teleport & Mount Hubs
* **Quick Travel:** Instant teleports to Dalaran, Shattrath, and all major Capital Cities.
* **Mount Spawner:** One-click learning for legendary mounts (Invincible, Mimiron's Head, etc.).
* **Custom Inputs:** Manual entry support for custom Teleport locations or specific Mount IDs.

---

## 📦 Installation

1. Download the repository files.
2. Navigate to your WoW Directory: `World of Warcraft/Interface/AddOns/`.
3. Create a folder named `AC_GMTool`.
4. Move `AC_GMTool.lua` and `AC_GMTool.toc` into that folder.
5. Launch the game and ensure "Load out of date AddOns" is checked in the AddOns menu.

---

## ⌨️ Controls

| Action | Result |
| :--- | :--- |
| **Left Click Minimap Icon** | Toggle Main Sidebar |
| **Left Click "Run/Add"** | Execute command or add item |
| **Ctrl + Left Click Icon** | Preview item in Dressing Room |
| **Mouseover Icon** | View Item/Spell Tooltip |
| **Drag Sidebar** | Reposition the UI |

---

## ⚠️ Troubleshooting

* **Icons as Question Marks:** If an item isn't in your local cache, it shows a `?`. Hover over it for 1 second to "query" the server. Close and re-open the search to see the updated icon.
* **Search Not Working:** Ensure your character has the required GM permissions to use `.lookup`.
* **Addon Not Loading:** Verify the folder name is exactly `AC_GMTool` and that the `.toc` and `.lua` files are inside.

---

*Created with ❤️ for the AzerothCore Community.*
