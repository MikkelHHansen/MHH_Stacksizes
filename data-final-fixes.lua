-- MHH Stack Sizes Mod - Final Fixes Phase
-- This runs AFTER all other mods (including Space Exploration) have made their changes
-- Used to ensure our stack size settings are applied last

-- Get settings values
local raw_materials_stack = settings.startup["mhh-stacksize-raw-materials"].value
local science_stack = settings.startup["mhh-stacksize-science"].value
local modules_stack = settings.startup["mhh-stacksize-modules"].value
local rocket_parts_stack = settings.startup["mhh-stacksize-rocket-parts"].value
local fuel_stack = settings.startup["mhh-stacksize-fuel"].value

-- Fix space-science-pack specifically (SE overrides this in their data phase)
if data.raw.tool["space-science-pack"] then
    data.raw.tool["space-science-pack"].stack_size = science_stack
end

-- Fix stone specifically (base game may override this in data-updates/data-final-fixes)
if data.raw.item["stone"] then
    data.raw.item["stone"].stack_size = raw_materials_stack
end

-- Re-apply module stack sizes for modules added in other mods' data-updates phase
-- (e.g. SE modules 4-9 defined in space-exploration's data-updates.lua)
-- Must match items by type OR name, since some mods may use non-standard prototype types
local final_item_types = {
    "item",
    "module",
    "ammo",
    "capsule",
    "tool",
    "item-with-entity-data",
    "item-with-label",
    "item-with-inventory",
    "item-with-tags",
}
for _, item_type in pairs(final_item_types) do
    if data.raw[item_type] then
        for name, item in pairs(data.raw[item_type]) do
            if item.stack_size and (item_type == "module" or string.find(name, "module")) then
                if not item["not-stackable"] then
                    if item.flags then
                        local excluded = false
                        for _, flag in pairs(item.flags) do
                            if flag == "not-stackable" then
                                excluded = true
                                break
                            end
                        end
                        if not excluded then
                            item.stack_size = modules_stack
                        end
                    else
                        item.stack_size = modules_stack
                    end
                end
            end
        end
    end
end

-- Re-apply rocket parts stack size (SE postprocess may change rocket-fuel and other items)
local rocket_part_subgroups = { ["rocket-part"] = true }
for _, item_type in pairs(final_item_types) do
    if data.raw[item_type] then
        for name, item in pairs(data.raw[item_type]) do
            if item.stack_size and item.subgroup and rocket_part_subgroups[item.subgroup] then
                if not item["not-stackable"] then
                    local excluded = false
                    if item.flags then
                        for _, flag in pairs(item.flags) do
                            if flag == "not-stackable" then
                                excluded = true
                                break
                            end
                        end
                    end
                    if not excluded then
                        item.stack_size = rocket_parts_stack
                    end
                end
            end
        end
    end
end


