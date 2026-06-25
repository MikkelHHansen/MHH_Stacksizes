-- MHH Stack Sizes Mod
-- Doubles stack sizes for all items except buildings and equipment

-- Items/equipment that should NOT have their stack sizes doubled
local excluded_types = {
    ["item-with-entity-data"] = true,  -- Buildings, vehicles, etc.
    ["armor"] = true,                   -- Power armor
    ["gun"] = true,                     -- Weapons
    ["module"] = true,                  -- Modules for buildings/armor
    ["ammo"] = true,                    -- Ammunition
}

-- Additional exclusions by subgroup (for equipment grid items)
local excluded_subgroups = {
    ["equipment"] = true,               -- All equipment grid items
    ["combat-armor"] = true,            -- Armor equipment
    ["defensive-structure"] = true,     -- Walls, gates, etc.
    ["energy-pipe-distribution"] = true,-- Power poles
    ["belt"] = true,                    -- Transport belts (placeable)
    ["inserter"] = true,                -- Inserters (placeable)
}

-- Function to check if an item should be excluded
local function should_exclude(item)
    -- Check if it's a building or vehicle (has place_result)
    if item.place_result then
        return true
    end
    
    -- Check if it's a tile
    if item.place_as_tile then
        return true
    end
    
    -- Check if it goes in equipment grid
    if item.placed_as_equipment_result then
        return true
    end
    
    -- Check subgroup exclusions
    if item.subgroup and excluded_subgroups[item.subgroup] then
        return true
    end
    
    return false
end

-- Process all item types
local item_types = {
    "item",
    "ammo",
    "capsule",
    "gun",
    "item-with-entity-data",
    "item-with-label",
    "item-with-inventory",
    "item-with-tags",
    "selection-tool",
    "blueprint-book",
    "upgrade-item",
    "deconstruction-item",
    "blueprint",
    "copy-paste-tool",
    "spidertron-remote",
    "tool",
    "armor",
    "repair-tool",
    "rail-planner",
    "module",
}

for _, item_type in pairs(item_types) do
    if data.raw[item_type] then
        for name, item in pairs(data.raw[item_type]) do
            -- Skip if this type is excluded
            if not excluded_types[item_type] then
                -- Check if individual item should be excluded
                if not should_exclude(item) then
                    -- Double the stack size
                    if item.stack_size then
                        item.stack_size = item.stack_size * 2
                    end
                end
            end
        end
    end
end
