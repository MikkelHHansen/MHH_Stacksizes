# MHH Stack Sizes

A Factorio mod that provides configurable stack sizes for all items except buildings and equipment.

## Features

- **9 Configurable Categories**: Raw materials, plates, ingots, intermediates, science packs, barrels, ammunition, modules, and other items
- **Full Space Exploration Support**: Automatically detects and categorizes SE materials (beryllium, holmium, iridium, naquium, cryonite, vulcanite, vitamelange)
- **Pattern-Based Detection**: Works with most mods without explicit support
- **Intelligent Categorization**: Uses item names and subgroups to automatically categorize modded items

## Installation

1. Copy the `MHH_Stacksizes` folder to your Factorio mods directory:
   - Windows: `%appdata%\Factorio\mods`
   - Linux: `~/.factorio/mods`
   - Mac: `~/Library/Application Support/factorio/mods`

2. Launch Factorio and enable the mod in the Mods menu

3. Configure stack sizes in Settings > Mod settings > Startup

## Stack Size Categories

### Raw Materials (Default: 50)
- Vanilla ores (iron-ore, copper-ore, coal, stone, uranium-ore)
- SE ores (beryllium-ore, holmium-ore, iridium-ore, naquium-ore)
- SE special materials (cryonite, vulcanite, vitamelange)
- Other modded ores

### Plates (Default: 100)
- Vanilla plates (iron-plate, copper-plate, steel-plate)
- SE plates (beryllium-plate, holmium-plate, iridium-plate, naquium-plate)
- Other modded plates

### Ingots (Default: 50)
- SE ingots (iron-ingot, steel-ingot, copper-ingot, beryllium-ingot, holmium-ingot, iridium-ingot, naquium-ingot)
- Other modded ingots

### Intermediate Products (Default: 200)
- Vanilla intermediates (circuits, gears, engines, etc.)
- SE processed materials (powders, crushed, crystals, sulfates, chlorides, rods, etc.)
- Other modded intermediate products

### Science Packs (Default: 200)
- All science packs

### Barrels (Default: 10)
- All fluid barrels

### Ammunition (Default: 200)
- All ammunition types

### Modules (Default: 50)
- All modules

### Other Items (Default: 100)
- Everything else that doesn't fit above categories

## Compatibility

- **Space Exploration**: Full support for all SE materials and processing stages
- **Krastorio 2**: Should work via pattern detection (not explicitly tested)
- **Bob's/Angel's Mods**: Should work via pattern detection
- **Most other mods**: Pattern-based detection handles common naming conventions

## Excluded Items

The following items are never modified (must remain stack_size=1 or have special requirements):
- Buildings and entities
- Armor and equipment
- Weapons (guns)
- Blueprint tools
- Planning tools (upgrade planner, deconstruction planner, etc.)
- Items with "not-stackable" flag

## Version History

- **3.0.0** - Added Space Exploration compatibility, new ingots category, pattern-based item detection
- 2.1.3 - Fix stack_size=1 requirement for planning tools
- 2.1.2 - Fix not-stackable items error (red-wire, green-wire)
- 2.1.1 - Remove incompatibility with space-exploration-postprocess
- 2.1.0 - Add ammunition and modules as configurable categories
- 2.0.0 - Configurable stack sizes with in-game settings
- 1.0.0 - Initial release
