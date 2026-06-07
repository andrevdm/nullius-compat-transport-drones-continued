local transport_drone_recipe_names = {
  "transport-drone",
  "road",
  "fast-road",
  "supply-depot",
  "request-depot",
  "buffer-depot",
  "fluid-depot",
  "fuel-depot",
  "active-depot",
  "storage-depot",
  "drone-dispatcher",
  "road-network-reader",
  "transport-depot-reader",
  "transport-depot-writer",
}

local transport_system_recipe_names = {
  "transport-drone",
  "road",
  "supply-depot",
  "request-depot",
  "fluid-depot",
}

local function capture_enabled_transport_drone_recipes(force)
  local enabled = {}
  for _, name in pairs(transport_drone_recipe_names) do
    local recipe = force.recipes[name]
    enabled[name] = recipe and recipe.enabled or false
  end
  return enabled
end

local function restore_enabled_recipes(force, enabled)
  for name, was_enabled in pairs(enabled) do
    if was_enabled then
      local recipe = force.recipes[name]
      if recipe then
        recipe.enabled = true
      end
    end
  end
end

local function unlock_researched_tech_recipes(force)
  for _, technology in pairs(force.technologies) do
    if technology.researched and technology.prototype then
      for _, effect in pairs(technology.prototype.effects or {}) do
        if effect.type == "unlock-recipe" and effect.recipe then
          local recipe = force.recipes[effect.recipe]
          if recipe then
            recipe.enabled = true
          end
        end
      end
    end
  end
end

local function unlock_transport_system_recipes(force)
  if not settings.startup["nullius-early-transport-drones"].value then return end
  local technology = force.technologies["transport-system"]
  if ((technology == nil) or (not technology.researched)) then return end
  for _, name in pairs(transport_system_recipe_names) do
    local recipe = force.recipes[name]
    if recipe then
      recipe.enabled = true
    end
  end
end

local function refresh_force(force)
  -- Needed when adding this compatibility mod to an existing Nullius save:
  -- recipe prototypes and technology effects changed after the save was created.
  -- Preserve already-enabled Transport Drones recipes so old saves don't lose
  -- access when recipes move to different Nullius-integrated technologies.
  local previously_enabled = capture_enabled_transport_drone_recipes(force)
  force.reset_technologies()
  force.reset_recipes()
  local effects_reset = pcall(function()
    force.reset_technology_effects()
  end)
  if not effects_reset then
    unlock_researched_tech_recipes(force)
  end
  restore_enabled_recipes(force, previously_enabled)
  unlock_transport_system_recipes(force)
end

local function refresh_all_forces()
  for _, force in pairs(game.forces) do
    refresh_force(force)
  end
end

script.on_init(refresh_all_forces)
script.on_configuration_changed(refresh_all_forces)
