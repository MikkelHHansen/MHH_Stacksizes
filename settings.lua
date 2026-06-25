-- MHH Stack Sizes Mod Settings
-- Allows users to configure stack sizes for different item categories

data:extend({
    -- Raw materials (ores, stone, coal, etc.)
    {
        type = "int-setting",
        name = "mhh-stacksize-raw-materials",
        setting_type = "startup",
        default_value = 50,  -- Factorio default for ores
        minimum_value = 1,
        maximum_value = 10000,
        order = "a"
    },
    -- Plates and basic materials
    {
        type = "int-setting",
        name = "mhh-stacksize-plates",
        setting_type = "startup",
        default_value = 100,  -- Factorio default for plates
        minimum_value = 1,
        maximum_value = 10000,
        order = "b"
    },
    -- Intermediate products (circuits, gears, etc.)
    {
        type = "int-setting",
        name = "mhh-stacksize-intermediates",
        setting_type = "startup",
        default_value = 200,  -- Factorio default for most intermediates
        minimum_value = 1,
        maximum_value = 10000,
        order = "c"
    },
    -- Science packs
    {
        type = "int-setting",
        name = "mhh-stacksize-science",
        setting_type = "startup",
        default_value = 200,  -- Factorio default for science packs
        minimum_value = 1,
        maximum_value = 10000,
        order = "d"
    },
    -- Fluids in barrels
    {
        type = "int-setting",
        name = "mhh-stacksize-barrels",
        setting_type = "startup",
        default_value = 10,  -- Factorio default for barrels
        minimum_value = 1,
        maximum_value = 10000,
        order = "e"
    },
    -- Other items (default for everything else)
    {
        type = "int-setting",
        name = "mhh-stacksize-other",
        setting_type = "startup",
        default_value = 100,  -- Factorio default for misc items
        minimum_value = 1,
        maximum_value = 10000,
        order = "f"
    },
})
