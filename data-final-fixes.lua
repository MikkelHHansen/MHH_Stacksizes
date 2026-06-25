-- MHH Stack Sizes Mod - Final Fixes Phase
-- This runs AFTER all other mods (including Space Exploration) have made their changes
-- Used to ensure our stack size settings are applied last

-- Get settings values
local science_stack = settings.startup["mhh-stacksize-science"].value

-- Fix space-science-pack specifically (SE overrides this in their data phase)
if data.raw.tool["space-science-pack"] then
    data.raw.tool["space-science-pack"].stack_size = science_stack
end
