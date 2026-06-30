local categories = {}
local compat = require("lib.compat")

local keep_default = {
  ["rocket-fuel"] = true,
  ["satellite"] = true,
  ["nuclear-fuel"] = true,
  ["artillery-shell"] = true,
  ["se-arcosphere"] = true,
  ["se-arcosphere-a"] = true,
  ["se-arcosphere-b"] = true,
  ["se-arcosphere-c"] = true,
  ["se-arcosphere-d"] = true,
  ["se-arcosphere-e"] = true,
  ["se-arcosphere-f"] = true,
  ["se-arcosphere-g"] = true,
  ["se-arcosphere-h"] = true,
  ["se-arcosphere-collector"] = true,
  ["se-navigation-satellite"] = true,
  ["se-star-probe"] = true,
  ["se-belt-probe"] = true,
  ["se-void-probe"] = true,
  ["se-naquium-processor"] = true,
  ["se-naquium-tessaract"] = true,
  ["kr-gps-satellite"] = true,
  ["se-cargo-rocket-section"] = true,
  ["se-cargo-rocket-section-packed"] = true,
}

local excluded_types = {
  ["item-with-entity-data"] = true,
  ["armor"] = true,
  ["gun"] = true,
  ["selection-tool"] = true,
  ["blueprint-book"] = true,
  ["upgrade-item"] = true,
  ["deconstruction-item"] = true,
  ["blueprint"] = true,
  ["copy-paste-tool"] = true,
  ["spidertron-remote"] = true,
  ["repair-tool"] = true,
}

local placeable_exceptions = {
  ["se-cargo-rocket-cargo-pod"] = true,
}

local item_types = {
  "item", "ammo", "capsule", "tool", "module",
  "item-with-entity-data", "item-with-label", "item-with-inventory",
  "item-with-tags", "selection-tool", "blueprint-book",
  "upgrade-item", "deconstruction-item", "blueprint",
  "copy-paste-tool", "spidertron-remote", "armor",
  "repair-tool", "rail-planner", "gun",
}

local category_setting_map = {
  ["raw-materials"]  = "mhh-stacksize-raw-materials",
  ["plates"]         = "mhh-stacksize-plates",
  ["ingots"]         = "mhh-stacksize-ingots",
  ["intermediates"]  = "mhh-stacksize-intermediates",
  ["science"]        = "mhh-stacksize-science",
  ["barrels"]        = "mhh-stacksize-barrels",
  ["fuel-burner"]    = "mhh-stacksize-fuel-burner",
  ["fuel-advanced"]  = "mhh-stacksize-fuel-advanced",
  ["ammo-basic"]     = "mhh-stacksize-ammo-basic",
  ["ammo-advanced"]  = "mhh-stacksize-ammo-advanced",
  ["ammo-capsule"]   = "mhh-stacksize-ammo-capsule",
  ["modules"]        = "mhh-stacksize-modules",
  ["rocket-parts"]   = "mhh-stacksize-rocket-parts",
  ["data"]           = "mhh-stacksize-data",
}

function categories.is_keep_default(name)
  return keep_default[name] or false
end

-- Returns true if the item should be skipped entirely (excluded or keep-default)
function categories.should_exclude(item, name, item_type)
  if excluded_types[item_type] then
    return true
  end

  if keep_default[name] then
    return true
  end

  if item["not-stackable"] then
    return true
  end

  if item.flags then
    for _, flag in pairs(item.flags) do
      if flag == "not-stackable" then
        return true
      end
    end
  end

  if item.hidden then
    return true
  end

  if item.parameter then
    return true
  end

  if item.place_result and not placeable_exceptions[name] then
    return true
  end

  if item.place_as_tile then
    return true
  end

  if item.placed_as_equipment_result then
    return true
  end

  local sub = item.subgroup
  if sub and (sub == "equipment" or sub == "combat-armor" or sub == "utility-equipment" or sub == "military-equipment" or sub == "train-transport") then
    return true
  end

  return false
end

-- Returns a category string, or nil if no category matched
function categories.categorize(name, item, item_type)
  -- Rule 1: Modules (detect by type or module_effects property)
  if item_type == "module" or item.module_effects then
    return "modules"
  end

  -- Rule 2: Ammo
  if item_type == "ammo" then
    local cat = item.ammo_category
    if cat == "bullet" or cat == "shotgun-shell" then
      return "ammo-basic"
    end
    return "ammo-advanced"
  end

  -- Rule 3: Capsules
  if item_type == "capsule" then
    return "ammo-capsule"
  end

  local sub = item.subgroup

  -- Rule 4: Science packs (tool type in any science-pack subgroup)
  if item_type == "tool" and sub and string.find(sub, "science%-pack") then
    return "science"
  end

  -- Rule 5: Fuel (checked early so SE material ores with fuel_value land here, not raw-materials)
  -- In data phase, fuel_value is a string like "2MJ" (not a number)
  local fuel_val = item.fuel_value
  if fuel_val and item.fuel_category then
    local is_fuel = false
    if type(fuel_val) == "number" then
      is_fuel = fuel_val > 0
    elseif type(fuel_val) == "string" then
      is_fuel = fuel_val ~= "0J"
    end
    if is_fuel then
      if item.fuel_category == "chemical" then
        return "fuel-burner"
      end
      return "fuel-advanced"
    end
  end

  -- Rule 6a: Chemical intermediates (SE processed forms — checked BEFORE plate/ingot/raw-material)
  if string.find(name, "%-sulfate$") or
     string.find(name, "%-chloride$") or
     string.find(name, "%-blastcake$") or
     string.find(name, "%-rod$") or
     string.find(name, "%-crystal$") then
    return "intermediates"
  end

  -- Rule 7: Plates (checked BEFORE raw-material subgroup to catch se-beryllium-plate etc.)
  if string.find(name, "%-plate$") or
     (sub and sub == "uranium") or
     (sub and sub == "raw-material") then
    return "plates"
  end

  -- Rule 8: Ingots (checked BEFORE raw-material subgroup to catch se-beryllium-ingot etc.)
  if string.find(name, "%-ingot$") then
    return "ingots"
  end

  -- Rule 6b: Raw materials — subgroup or name-pattern based (after plate/ingot checks so processed forms fall through correctly)
  if name == "stone" or
     (sub and compat.se_material_subgroups[sub]) or
     string.find(name, "%-ore$") or
     string.find(name, "%-crushed$") or
     (sub and (sub == "raw-resource" or sub == "stone" or sub == "water" or sub == "oil")) then
    return "raw-materials"
  end

  -- Rule 9: Intermediates
  if (sub and compat.intermediate_subgroups[sub]) or
     (sub and string.find(sub, "intermediate%-product")) then
    return "intermediates"
  end

  -- Rule 10: Rocket parts
  if sub == "rocket-part" or sub == "rocket-logistics" then
    return "rocket-parts"
  end

  -- Rule 11: Data items (SE)
  if sub and string.find(sub, "^data%-") then
    return "data"
  end

  -- Rule 12: Barrels
  if string.find(name, "barrel") or sub == "fill-barrel" or sub == "barrel" then
    return "barrels"
  end

  -- Rule 13: Science-pack subgroup fallback (items with type=item in any science-pack subgroup)
  if sub and string.find(sub, "science%-pack") then
    return "science"
  end

  return nil
end

function categories.get_setting_name(category)
  return category_setting_map[category]
end

function categories.process_all()
  local counts = {}
  local uncategorized = {}
  local excluded_count = 0
  local keep_default_count = 0

  for _, item_type in pairs(item_types) do
    if data.raw[item_type] then
      for name, item in pairs(data.raw[item_type]) do
        if categories.should_exclude(item, name, item_type) then
          if keep_default[name] then
            keep_default_count = keep_default_count + 1
          else
            excluded_count = excluded_count + 1
          end
        else
          local category = categories.categorize(name, item, item_type)
          if category then
            local setting_name = categories.get_setting_name(category)
            local stack_size = settings.startup[setting_name].value
            if item.stack_size and item.stack_size ~= stack_size then
              item.stack_size = stack_size
            end
            counts[category] = (counts[category] or 0) + 1
          else
            table.insert(uncategorized, {name = name, proto_type = item_type, subgroup = item.subgroup or "(none)", item = item})
          end
        end
      end
    end
  end

  -- Log report (only when debug setting is enabled)
  if settings.startup["mhh-stacksize-debug-log"].value then
    log("")
    log("=== MHH_Stacksizes 4.0.0 Report ===")
    local total = 0
    local order = {"raw-materials","plates","ingots","intermediates","science","fuel-burner","fuel-advanced","ammo-basic","ammo-advanced","ammo-capsule","modules","rocket-parts","data","barrels"}
    for _, cat in ipairs(order) do
      local c = counts[cat] or 0
      total = total + c
      if c > 0 then
        log(string.format("  %-20s: %d items", cat, c))
      end
    end
    log(string.format("  Total categorized:   %d", total))
    log(string.format("  Excluded:            %d", excluded_count))
    log(string.format("  Keep-default:        %d", keep_default_count))
    if #uncategorized > 0 then
      log(string.format("  UNCATEGORIZED:       %d items <<< ERROR >>>", #uncategorized))
      for _, u in ipairs(uncategorized) do
        local extra = ""
        if u.item then
          local fv = u.item.fuel_value
          if fv then extra = extra .. string.format(" fuel=%s", fv) end
          local fc = u.item.fuel_category
          if fc then extra = extra .. string.format(" fuel_cat=%s", fc) end
          if u.item.module_effects then extra = extra .. " has_module_effects" end
          if u.item.placed_as_equipment_result then extra = extra .. " placed_as_eq=" .. u.item.placed_as_equipment_result end
        end
        log(string.format("    %-35s type=%-15s sub=%-25s%s", u.name, u.proto_type, u.subgroup, extra))
      end
    else
      log("  Uncategorized:       0 (none) - OK")
    end
    log("=== End Report ===")
    log("")
  end
end

return categories
