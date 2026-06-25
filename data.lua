-- MHH Stack Sizes Mod
-- Configurable stack sizes for all items except buildings and equipment

-- Get settings values
local raw_materials_stack = settings.startup["mhh-stacksize-raw-materials"].value
local plates_stack = settings.startup["mhh-stacksize-plates"].value
local intermediates_stack = settings.startup["mhh-stacksize-intermediates"].value
local science_stack = settings.startup["mhh-stacksize-science"].value
local barrels_stack = settings.startup["mhh-stacksize-barrels"].value
local other_stack = settings.startup["mhh-stacksize-other"].value

-- Items/equipment that should NOT have their stack sizes modified
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

-- Category definitions for different item types
local raw_materials = {
    ["iron-ore"] = true,
    ["copper-ore"] = true,
    ["coal"] = true,
    ["stone"] = true,
    ["uranium-ore"] = true,
    ["wood"] = true,
    ["raw-fish"] = true,
}

local plates = {
    ["iron-plate"] = true,
    ["copper-plate"] = true,
    ["steel-plate"] = true,
    ["stone-brick"] = true,
    ["uranium-235"] = true,
    ["uranium-238"] = true,
}

local intermediates = {
    ["iron-gear-wheel"] = true,
    ["copper-cable"] = true,
    ["iron-stick"] = true,
    ["electronic-circuit"] = true,
    ["advanced-circuit"] = true,
    ["processing-unit"] = true,
    ["engine-unit"] = true,
    ["electric-engine-unit"] = true,
    ["flying-robot-frame"] = true,
    ["low-density-structure"] = true,
    ["rocket-fuel"] = true,
    ["rocket-control-unit"] = true,
    ["battery"] = true,
    ["plastic-bar"] = true,
    ["sulfur"] = true,
    ["explosives"] = true,
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

-- Function to determine what stack size to use for an item
local function get_stack_size_for_item(name, item)
    -- Check if it's a raw material
    if raw_materials[name] or (item.subgroup and string.find(item.subgroup, "raw%-resource")) then
        return raw_materials_stack
    end
    
    -- Check if it's a plate
    if plates[name] or (item.subgroup and (item.subgroup == "raw-material" or string.find(item.subgroup, "plate"))) then
        return plates_stack
    end
    
    -- Check if it's an intermediate product
    if intermediates[name] or (item.subgroup and string.find(item.subgroup, "intermediate%-product")) then
        return intermediates_stack
    end
    
    -- Check if it's a barrel
    if string.find(name, "barrel") or (item.subgroup and item.subgroup == "fill-barrel") then
        return barrels_stack
    end
    
    -- Default to other
    return other_stack
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
                    -- Set the stack size based on item category
                    if item.stack_size then
                        -- For science packs (tools), use science stack size
                        if item_type == "tool" then
                            item.stack_size = science_stack
                        else
                            item.stack_size = get_stack_size_for_item(name, item)
                        end
                    end
                end
            end
        end
    end
end
