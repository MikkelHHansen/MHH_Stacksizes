# MHH Stack Sizes

Configurable stack sizes for almost every item in Factorio — ores, plates, ingots, intermediates, science, fuel, ammo, modules, barrels, rocket parts, data items, and more. Items are dynamically categorized by their properties (type, subgroup, fuel value, name patterns), so it works seamlessly with vanilla, Space Age, Space Exploration, Krastorio 2, Bob's/Angel's, and most other mods without explicit support.

## Categories

| Category | Setting Name | Default | What Goes In |
|---|---|---|---|
| Raw Materials | `mhh-stacksize-raw-materials` | 50 | Ores, crushed materials, stone, SE cryonite/vulcanite/vitamelange |
| Plates | `mhh-stacksize-plates` | 100 | Plates, bricks, uranium processing items |
| Ingots | `mhh-stacksize-ingots` | 50 | All ingots (vanilla & SE) |
| Intermediates | `mhh-stacksize-intermediates` | 200 | Circuits, gears, engines, SE sulfates/chlorides/rods/crystals |
| Science | `mhh-stacksize-science` | 200 | All science packs |
| Fuel — Burner | `mhh-stacksize-fuel-burner` | 50 | Burner fuels (coal, wood, solid fuel) |
| Fuel — Advanced | `mhh-stacksize-fuel-advanced` | 10 | Rocket fuel, nuclear fuel, chemical fuels |
| Ammo — Basic | `mhh-stacksize-ammo-basic` | 200 | Bullets, shotgun shells |
| Ammo — Advanced | `mhh-stacksize-ammo-advanced` | 100 | Piercing/uranium ammo, rockets, artillery shells, cannon shells |
| Ammo — Capsule | `mhh-stacksize-ammo-capsule` | 100 | Grenades, capsules, combat robots |
| Modules | `mhh-stacksize-modules` | 50 | All modules |
| Rocket Parts | `mhh-stacksize-rocket-parts` | 25 | Rocket parts, satellite, cargo rocket sections |
| Data | `mhh-stacksize-data` | 100 | SE data cards |
| Barrels | `mhh-stacksize-barrels` | 10 | All fluid barrels |

## How Categorization Works

Instead of maintaining a hardcoded item list, the mod detects items by their prototype properties:

1. **Type-based** — Modules (type=`module` or has `module_effects`), ammo (type=`ammo`), capsules (type=`capsule`)
2. **Fuel-based** — Any item with `fuel_value > 0` and a `fuel_category` (burner vs. chemical/other)
3. **Subgroup-based** — Science packs, intermediate products, rocket parts, data items, barrels
4. **Name-pattern-based** — `*-plate`, `*-brick`, `*-ingot`, `*-ore`, `*-crushed`, `*-sulfate`, `*-chloride`, `*-rod`, `*-crystal`
5. **Priority ordering** — Fuel is checked early (so SE ores with fuel_value land in fuel, not raw-materials); plates/ingots checked before raw-materials (so `se-beryllium-plate` goes to plates, not raw-materials); chemical intermediate patterns checked before raw-materials

## Excluded Items

These items keep their default stack sizes (never modified):

- **Buildings** — any item with `place_result` (except known exceptions like stone, stone-brick, SE cargo pod)
- **Armor & Equipment** — type=`armor`, type=`gun`, `placed_as_equipment_result`, or in equipment subgroups
- **Tools** — blueprints, upgrade/deconstruction planners, selection tools, copy-paste tools, repair tools, spidertron remotes, rail planners
- **Non-stackable** — items with `not-stackable` flag or `not-stackable` in their flags array
- **Hidden/Parameter** — hidden items and parameter items (virtual signal types)
- **Special keep_default items** — arcospheres, navigation satellites, probes, processors (stack_size=1 items that shouldn't change)

## Settings

All settings are **startup** type (require a game restart):

| Setting | Type | Default | Description |
|---|---|---|---|
| mhh-stacksize-raw-materials | int | 50 | Raw materials stack size (1–10000) |
| mhh-stacksize-plates | int | 100 | Plates stack size (1–10000) |
| mhh-stacksize-ingots | int | 50 | Ingots stack size (1–10000) |
| mhh-stacksize-intermediates | int | 200 | Intermediate products stack size (1–10000) |
| mhh-stacksize-science | int | 200 | Science packs stack size (1–10000) |
| mhh-stacksize-barrels | int | 10 | Barrels stack size (1–10000) |
| mhh-stacksize-fuel-burner | int | 50 | Burner fuels stack size (1–10000) |
| mhh-stacksize-fuel-advanced | int | 10 | Advanced fuels stack size (1–10000) |
| mhh-stacksize-ammo-basic | int | 200 | Basic ammo stack size (1–10000) |
| mhh-stacksize-ammo-advanced | int | 100 | Advanced ammo stack size (1–10000) |
| mhh-stacksize-ammo-capsule | int | 100 | Capsules/combat items stack size (1–10000) |
| mhh-stacksize-modules | int | 50 | Modules stack size (1–10000) |
| mhh-stacksize-rocket-parts | int | 25 | Rocket parts stack size (1–10000) |
| mhh-stacksize-data | int | 100 | Data items stack size (1–10000) |
| mhh-stacksize-debug-log | bool | false | Enable debug logging to factorio-current.log |

## Compatibility

| Mod | Status |
|---|---|
| **Space Age** | Detected — space platform items, asteroid chunks, promethium handled |
| **Space Exploration** | Full support — all materials, processing stages, arcosphere exception, data cards, cargo rocket sections |
| **Krastorio 2** | Works via pattern detection |
| **Bob's / Angel's** | Works via pattern detection |
| **Other mods** | Pattern-based detection handles common naming conventions |

## Debug Logging

Enable `mhh-stacksize-debug-log` in startup settings to get a per-category item count report in `factorio-current.log`. The report runs in all three data phases (data.lua, data-updates.lua, data-final-fixes.lua) and shows categorized counts, excluded items, and any uncategorized items with full prototype details.

## Requirements

- **Factorio 2.0**
- Optional: Space Age, Space Exploration, Krastorio 2
