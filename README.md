# MHH Stack Sizes

A Factorio mod that modifies stack sizes for various items to improve gameplay and inventory management.

## Installation

1. Copy the `MHH_Stacksizes` folder to your Factorio mods directory:
   - Windows: `%appdata%\Factorio\mods`
   - Linux: `~/.factorio/mods`
   - Mac: `~/Library/Application Support/factorio/mods`

2. Launch Factorio and enable the mod in the Mods menu

## Usage

Edit `data.lua` to customize which items have modified stack sizes. The file includes examples for common items that you can uncomment and adjust.

### Example:

```lua
-- Increase stack size for iron plates to 200
data.raw["item"]["iron-plate"].stack_size = 200
```

## Finding Item Names

To find the internal name of an item in Factorio:
1. Enable debug mode by adding `--debug` to Factorio launch options
2. Press F5 in game to see entity/item names
3. Or check the Factorio wiki for item names

## Compatible with Factorio 2.0+

## Version History

- 1.0.0 - Initial release
