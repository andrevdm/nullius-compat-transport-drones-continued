-- Nullius + Transport Drones Continued compatibility.

local has_transport_drones = mods["Transport_Drones_Continued"]
local early_transport_drones = settings.startup["nullius-early-transport-drones"].value

if has_transport_drones then
  assert(data.raw["item-subgroup"]["transport-drones"] ~= nil, "Nullius Transport Drones compatibility requires item-subgroup[transport-drones]")
  assert(data.raw.technology["transport-system"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-system]")
  assert(data.raw.recipe["transport-drone"] ~= nil, "Nullius Transport Drones compatibility requires recipe[transport-drone]")
  assert(data.raw.item["transport-drone"] ~= nil, "Nullius Transport Drones compatibility requires item[transport-drone]")
  assert(data.raw.recipe["road"] ~= nil, "Nullius Transport Drones compatibility requires recipe[road]")
  assert(data.raw.item["road"] ~= nil, "Nullius Transport Drones compatibility requires item[road]")
  assert(data.raw.technology["fast-road"] ~= nil, "Nullius Transport Drones compatibility requires technology[fast-road]")
  assert(data.raw.recipe["fast-road"] ~= nil, "Nullius Transport Drones compatibility requires recipe[fast-road]")
  assert(data.raw.item["fast-road"] ~= nil, "Nullius Transport Drones compatibility requires item[fast-road]")
  assert(data.raw.tile["transport-drone-road-better"] ~= nil, "Nullius Transport Drones compatibility requires tile[transport-drone-road-better]")
  assert(data.raw.technology["transport-depot-circuits"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-depot-circuits]")
  assert(data.raw.technology["transport-drone-speed-1"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-speed-1]")
  assert(data.raw.technology["transport-drone-speed-2"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-speed-2]")
  assert(data.raw.technology["transport-drone-speed-3"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-speed-3]")
  assert(data.raw.technology["transport-drone-speed-4"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-speed-4]")
  assert(data.raw.technology["transport-drone-speed-5"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-speed-5]")
  assert(data.raw.technology["transport-drone-capacity-1"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-capacity-1]")
  assert(data.raw.technology["transport-drone-capacity-2"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-capacity-2]")
  assert(data.raw.technology["transport-drone-capacity-3"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-capacity-3]")
  assert(data.raw.technology["transport-drone-capacity-4"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-capacity-4]")
  assert(data.raw.technology["transport-drone-capacity-5"] ~= nil, "Nullius Transport Drones compatibility requires technology[transport-drone-capacity-5]")
  assert(data.raw["assembling-machine"]["request-depot"] ~= nil, "Nullius Transport Drones compatibility requires assembling-machine[request-depot]")
  assert(data.raw["assembling-machine"]["buffer-depot"] ~= nil, "Nullius Transport Drones compatibility requires assembling-machine[buffer-depot]")
  assert(data.raw["assembling-machine"]["fuel-depot"] ~= nil, "Nullius Transport Drones compatibility requires assembling-machine[fuel-depot]")
  assert(data.raw["furnace"]["fluid-depot"] ~= nil, "Nullius Transport Drones compatibility requires furnace[fluid-depot]")

  data.raw["item-subgroup"]["transport-drones"].order = "gd"

  local dispatcher_enabled = false
  for _,effect in pairs(data.raw.technology["transport-system"].effects or {}) do
    if ((effect.type == "unlock-recipe") and (effect.recipe == "drone-dispatcher")) then
      dispatcher_enabled = true
    end
  end

  data.raw.technology["transport-system"].order = "nullius-dg"
  local transport_system_effects = {
    {type = "unlock-recipe", recipe = "transport-drone"},
    {type = "unlock-recipe", recipe = "supply-depot"},
    {type = "unlock-recipe", recipe = "road"}
  }
  if early_transport_drones then
    transport_system_effects = {
      {type = "unlock-recipe", recipe = "transport-drone"},
      {type = "unlock-recipe", recipe = "supply-depot"},
      {type = "unlock-recipe", recipe = "request-depot"},
      {type = "unlock-recipe", recipe = "fluid-depot"},
      {type = "unlock-recipe", recipe = "road"}
    }
    data.raw.technology["transport-system"].prerequisites = {
      "nullius-traffic-control", "nullius-personal-transportation-1",
      "nullius-pumping-2" }
  else
    data.raw.technology["transport-system"].prerequisites = {
      "nullius-robotics-1", "nullius-personal-transportation-1",
      "nullius-checkpoint-compressed-nitrogen" }
  end
  data.raw.technology["transport-system"].effects = transport_system_effects
  data.raw.technology["transport-system"].unit = {
    count = 100, time = 30,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1}
    }
  }
  data.raw.technology["transport-depot-circuits"].order = "nullius-dk"
  data.raw.technology["transport-depot-circuits"].prerequisites = {
    "transport-system", "nullius-broadcasting-1" }
  data.raw.technology["transport-depot-circuits"].unit = {
    count = 80, time = 30,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1}
    }
  }
  if not early_transport_drones then
    table.insert(data.raw.technology["nullius-sensors-2"].prerequisites,"transport-depot-circuits")
  end

  if (data.raw.technology["transport-fluids"] ~= nil) then
    data.raw.technology["transport-fluids"].order = "nullius-dh"
    if early_transport_drones then
      data.raw.technology["transport-fluids"].localised_name = {"", "Transport depot infrastructure"}
      data.raw.technology["transport-fluids"].effects = {
        {type = "unlock-recipe", recipe = "buffer-depot"},
        {type = "unlock-recipe", recipe = "fuel-depot"}
      }
      if dispatcher_enabled then
        table.insert(data.raw.technology["transport-fluids"].effects,
          {type = "unlock-recipe", recipe = "drone-dispatcher"})
      end
      data.raw.technology["transport-fluids"].prerequisites = { "transport-system" }
      data.raw.technology["transport-fluids"].unit = {
        count = 150, time = 30,
        ingredients = {
          {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
          {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1}
        }
      }
    else
      data.raw.technology["transport-fluids"].effects = {
        {type = "unlock-recipe", recipe = "fluid-depot"},
        {type = "unlock-recipe", recipe = "request-depot"}
      }
      data.raw.technology["transport-fluids"].prerequisites = {
        "transport-system", "nullius-pumping-2" }
      data.raw.technology["transport-fluids"].unit = {
        count = 150, time = 30,
        ingredients = {
          {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
          {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
          {"nullius-chemical-pack", 1}
        }
      }
    end
  end

  if (data.raw.technology["transport-buffering"] ~= nil) then
    data.raw.technology["transport-buffering"].order = "nullius-di"
    if early_transport_drones then
      data.raw.technology["transport-buffering"].effects = {}
      data.raw.technology["transport-buffering"].enabled = false
      data.raw.technology["transport-buffering"].hidden = true
    else
      data.raw.technology["transport-buffering"].effects = {
        {type = "unlock-recipe", recipe = "buffer-depot"},
        {type = "unlock-recipe", recipe = "fuel-depot"}
      }
      if dispatcher_enabled then
        table.insert(data.raw.technology["transport-buffering"].effects,
          {type = "unlock-recipe", recipe = "drone-dispatcher"})
      end
      data.raw.technology["transport-buffering"].prerequisites = { "transport-fluids" }
      data.raw.technology["transport-buffering"].unit = {
        count = 300, time = 30,
        ingredients = {
          {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
          {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
          {"nullius-chemical-pack", 1}
        }
      }
    end
  end

  if (data.raw.technology["transport-logistics"] ~= nil) then
    local active_supply = data.raw.technology["transport-active-supply"]
    data.raw.technology["transport-logistics"].order = "nullius-dj"
    -- Continued always creates this tech, but it can be empty if both depots are disabled.
    if ((active_supply ~= nil) and (next(active_supply.effects or {}) ~= nil)) then
      data.raw.technology["transport-logistics"].prerequisites = {
        "transport-active-supply", "nullius-logistic-robot-1" }
    else
      if early_transport_drones then
        data.raw.technology["transport-logistics"].prerequisites = {
          "transport-fluids", "nullius-distribution-2", "nullius-logistic-robot-1" }
      else
        data.raw.technology["transport-logistics"].prerequisites = {
          "transport-buffering", "nullius-distribution-2", "nullius-logistic-robot-1" }
      end
    end
    data.raw.technology["transport-logistics"].unit = {
      count = 300, time = 30,
      ingredients = {
        {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
        {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
        {"nullius-chemical-pack", 1}
      }
    }
  end

  if (data.raw.technology["transport-active-supply"] ~= nil) then
    data.raw.technology["transport-active-supply"].order = "nullius-dka"
    if early_transport_drones then
      data.raw.technology["transport-active-supply"].prerequisites = {
        "transport-fluids", "nullius-distribution-2" }
    else
      data.raw.technology["transport-active-supply"].prerequisites = {
        "transport-buffering", "nullius-distribution-2" }
    end
    data.raw.technology["transport-active-supply"].unit = {
      count = 500, time = 30,
      ingredients = {
        {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
        {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
        {"nullius-chemical-pack", 1}
      }
    }
  end

  if (data.raw.technology["transport-multi-pipe"] ~= nil) then
    data.raw.technology["transport-multi-pipe"].order = "nullius-dkb"
    data.raw.technology["transport-multi-pipe"].prerequisites = {
      "transport-fluids", "nullius-pumping-2" }
    data.raw.technology["transport-multi-pipe"].unit = {
      count = 300, time = 30,
      ingredients = {
        {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
        {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
        {"nullius-chemical-pack", 1}
      }
    }
  end

  data.raw.technology["transport-drone-speed-1"].order = "nullius-dl"
  data.raw.technology["transport-drone-speed-1"].prerequisites = {
    "nullius-robot-speed-1" }
  data.raw.technology["transport-drone-speed-1"].unit = {
    count = 200, time = 30,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1}
    }
  }
  data.raw.technology["transport-drone-capacity-1"].order = "nullius-dl"
  data.raw.technology["transport-drone-capacity-1"].prerequisites = {
    "transport-drone-speed-1", "nullius-braking-1"}
  data.raw.technology["transport-drone-capacity-1"].unit = {
    count = 250, time = 30,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1}
    }
  }
  if not early_transport_drones then
    data.raw.technology["nullius-braking-2"].prerequisites =
        {"nullius-checkpoint-ceramic-powder", "transport-drone-capacity-1"}
  end

  data.raw.technology["transport-drone-speed-2"].order = "nullius-en"
  data.raw.technology["transport-drone-speed-2"].prerequisites = {
    "nullius-robot-speed-2", "nullius-checkpoint-truck" }
  data.raw.technology["transport-drone-speed-2"].unit = {
    count = 800, time = 35,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}
    }
  }
  data.raw.technology["transport-drone-capacity-2"].order = "nullius-eo"
  data.raw.technology["transport-drone-capacity-2"].prerequisites = {
    "transport-drone-speed-2", "nullius-robot-cargo-1" }
  data.raw.technology["transport-drone-capacity-2"].unit = {
    count = 1000, time = 35,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}
    }
  }
  if not early_transport_drones then
    table.insert(data.raw.technology["nullius-electromagnetism-3"].prerequisites,"transport-drone-capacity-2")
  end

  data.raw.technology["transport-drone-speed-3"].order = "nullius-fh"
  data.raw.technology["transport-drone-speed-3"].prerequisites = {
    "transport-drone-capacity-3", "nullius-robot-speed-3" }
  data.raw.technology["transport-drone-speed-3"].unit = {
    count = 1600, time = 45,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}, {"nullius-physics-pack", 1}
    }
  }

  data.raw.technology["fast-road"].order = "nullius-fha"
  data.raw.technology["fast-road"].effects = {
    { type = "unlock-recipe", recipe = "fast-road" }
  }
  data.raw.technology["fast-road"].prerequisites = {
    "transport-drone-speed-3", "transport-depot-circuits",
    "nullius-packaging-4", "nullius-aesthetics-2" }
  data.raw.technology["fast-road"].unit = {
    count = 1600, time = 45,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}, {"nullius-physics-pack", 1}
    }
  }

  data.raw.technology["transport-drone-capacity-3"].order = "nullius-fh"
  data.raw.technology["transport-drone-capacity-3"].prerequisites = {
    "nullius-mechanical-engineering-2" }
  data.raw.technology["transport-drone-capacity-3"].unit = {
    count = 1600, time = 45,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}, {"nullius-physics-pack", 1}
    }
  }
  if not early_transport_drones then
    table.insert(data.raw.technology["nullius-braking-6"].prerequisites,"transport-drone-speed-3")
  end

  data.raw.technology["transport-drone-speed-4"].order = "nullius-fu"
  data.raw.technology["transport-drone-speed-4"].prerequisites = {
    "nullius-personal-transportation-3", "nullius-robot-speed-4" }
  data.raw.technology["transport-drone-speed-4"].unit = {
    count = 4200, time = 55,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}, {"nullius-physics-pack", 1}
    }
  }
  data.raw.technology["transport-drone-capacity-4"].order = "nullius-fv"
  data.raw.technology["transport-drone-capacity-4"].prerequisites = {
    "transport-drone-speed-4", "nullius-braking-8" }
  data.raw.technology["transport-drone-capacity-4"].unit = {
    count = 4500, time = 55,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}, {"nullius-physics-pack", 1}
    }
  }
  if not early_transport_drones then
    table.insert(data.raw.technology["nullius-inserter-capacity-6"].prerequisites,"transport-drone-capacity-4")
  end

  data.raw.technology["transport-drone-speed-5"].order = "nullius-gj"
  data.raw.technology["transport-drone-speed-5"].prerequisites = {
    "nullius-robot-speed-5" }
  data.raw.technology["transport-drone-speed-5"].unit = {
    count_formula = "(2^(L-5))*15000", time = 60,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}, {"nullius-physics-pack", 1},
      {"nullius-astronomy-pack", 1}
    }
  }
  data.raw.technology["transport-drone-capacity-5"].order = "nullius-gj"
  data.raw.technology["transport-drone-capacity-5"].prerequisites = {
    "nullius-inserter-capacity-7" }
  data.raw.technology["transport-drone-capacity-5"].unit = {
    count = 25000, time = 60,
    ingredients = {
      {"nullius-geology-pack", 1}, {"nullius-climatology-pack", 1},
      {"nullius-mechanical-pack", 1}, {"nullius-electrical-pack", 1},
      {"nullius-chemical-pack", 1}, {"nullius-physics-pack", 1},
      {"nullius-astronomy-pack", 1}
    }
  }
  if not early_transport_drones then
    data.raw.technology["nullius-inserter-capacity-8"].prerequisites =
        {"transport-drone-capacity-5", "nullius-locomotion-5"}
  end

  local function set_transport_drone_item(opts)
    local item = data.raw.item[opts.name]
    if (item == nil) then return false end
    item.order = opts.order
    item.stack_size = opts.stack_size
    return true
  end

  local function set_transport_drone_recipe(opts)
    local recipe = data.raw.recipe[opts.name]
    if (recipe == nil) then return false end
    recipe.order = opts.order
    recipe.enabled = false
    recipe.always_show_made_in = true
    recipe.category = opts.category
    recipe.energy_required = opts.time
    recipe.ingredients = opts.ingredients
    recipe.results = opts.results or {
      {type = "item", name = opts.name, amount = opts.amount or 1}
    }
    if (opts.properties ~= nil) then
      for key,value in pairs(opts.properties) do
        recipe[key] = value
      end
    end
    return true
  end

  set_transport_drone_item({name = "road", order = "nullius-b", stack_size = 500})
  set_transport_drone_recipe({
    name = "road",
    order = "nullius-b",
    category = "hand-casting",
    time = 3,
    amount = 4,
    ingredients = {
      {type = "item", name = "nullius-rubber", amount = 1},
      {type = "item", name = "nullius-land-fill-sand", amount = 1},
      {type = "item", name = "nullius-gravel", amount = 3}
    },
    properties = {
      show_amount_in_title = false,
      always_show_products = true
    }
  })

  set_transport_drone_item({name = "transport-drone", order = "nullius-c", stack_size = 20})
  set_transport_drone_recipe({
    name = "transport-drone",
    order = "nullius-c",
    category = "medium-crafting",
    time = 10,
    amount = 3,
    ingredients = {
      {type = "item", name = "nullius-car-1", amount = 1},
      {type = "item", name = "arithmetic-combinator", amount = 5},
      {type = "item", name = "programmable-speaker", amount = 2},
      {type = "item", name = "bob-turbo-inserter", amount = 3}
    },
    properties = {
      show_amount_in_title = false,
      always_show_products = true
    }
  })

  set_transport_drone_item({name = "supply-depot", order = "nullius-d", stack_size = 20})
  set_transport_drone_recipe({
    name = "supply-depot",
    order = "nullius-d",
    category = "large-crafting",
    time = 12,
    ingredients = {
      {type = "item", name = "nullius-large-chest-1", amount = 1},
      {type = "item", name = "nullius-steel-beam", amount = 4},
      {type = "item", name = "nullius-glass", amount = 2},
      {type = "item", name = "train-stop", amount = 1}
    }
  })

  set_transport_drone_item({name = "request-depot", order = "nullius-e", stack_size = 20})
  local request_depot_ingredients = {
    {type = "item", name = "fluid-depot", amount = 1},
    {type = "item", name = "nullius-hangar-1", amount = 1}
  }
  if early_transport_drones then
    request_depot_ingredients = {
      {type = "item", name = "fluid-depot", amount = 1},
      {type = "item", name = "train-stop", amount = 1},
      {type = "item", name = "nullius-sensor-1", amount = 1},
      {type = "item", name = "arithmetic-combinator", amount = 1},
      {type = "item", name = "programmable-speaker", amount = 1},
      {type = "item", name = "nullius-red-wire", amount = 2}
    }
  end
  set_transport_drone_recipe({
    name = "request-depot",
    order = "nullius-e",
    category = "large-crafting",
    time = 6,
    ingredients = request_depot_ingredients
  })

  set_transport_drone_item({name = "buffer-depot", order = "nullius-f", stack_size = 20})
  set_transport_drone_recipe({
    name = "buffer-depot",
    order = "nullius-f",
    category = "large-crafting",
    time = 4,
    ingredients = {
      {type = "item", name = "request-depot", amount = 1},
      {type = "item", name = "train-stop", amount = 1}
    },
    properties = { no_productivity = true }
  })

  set_transport_drone_item({name = "fluid-depot", order = "nullius-g", stack_size = 20})
  set_transport_drone_recipe({
    name = "fluid-depot",
    order = "nullius-g",
    category = "large-crafting",
    time = 4,
    ingredients = {
      {type = "item", name = "supply-depot", amount = 1},
      {type = "item", name = "nullius-medium-tank-2", amount = 1},
      {type = "item", name = "nullius-barrel-pump-1", amount = 1}
    }
  })

  set_transport_drone_item({name = "fuel-depot", order = "nullius-h", stack_size = 20})
  set_transport_drone_recipe({
    name = "fuel-depot",
    order = "nullius-h",
    category = "large-crafting",
    time = 4,
    ingredients = {
      {type = "item", name = "buffer-depot", amount = 1},
      {type = "item", name = "nullius-pump-2", amount = 2}
    }
  })

  set_transport_drone_item({name = "active-depot", order = "nullius-fa", stack_size = 20})
  set_transport_drone_recipe({
    name = "active-depot",
    order = "nullius-fa",
    category = "large-crafting",
    time = 8,
    ingredients = {
      {type = "item", name = "supply-depot", amount = 1},
      {type = "item", name = "nullius-large-supply-chest-1", amount = 1},
      {type = "item", name = "nullius-hangar-1", amount = 1},
      {type = "item", name = "nullius-green-wire", amount = 4}
    }
  })

  set_transport_drone_item({name = "storage-depot", order = "nullius-fb", stack_size = 20})
  set_transport_drone_recipe({
    name = "storage-depot",
    order = "nullius-fb",
    category = "large-crafting",
    time = 8,
    ingredients = {
      {type = "item", name = "supply-depot", amount = 1},
      {type = "item", name = "nullius-large-storage-chest-1", amount = 1},
      {type = "item", name = "nullius-red-wire", amount = 2},
      {type = "item", name = "nullius-green-wire", amount = 2}
    }
  })

  set_transport_drone_item({name = "drone-dispatcher", order = "nullius-ha", stack_size = 20})
  local drone_dispatcher_ingredients = {
    {type = "item", name = "fuel-depot", amount = 1},
    {type = "item", name = "nullius-hangar-1", amount = 1},
    {type = "item", name = "arithmetic-combinator", amount = 2},
    {type = "item", name = "nullius-green-wire", amount = 4}
  }
  if early_transport_drones then
    drone_dispatcher_ingredients = {
      {type = "item", name = "fuel-depot", amount = 1},
      {type = "item", name = "train-stop", amount = 1},
      {type = "item", name = "nullius-sensor-1", amount = 2},
      {type = "item", name = "arithmetic-combinator", amount = 2},
      {type = "item", name = "programmable-speaker", amount = 1},
      {type = "item", name = "nullius-green-wire", amount = 4}
    }
  end
  set_transport_drone_recipe({
    name = "drone-dispatcher",
    order = "nullius-ha",
    category = "large-crafting",
    time = 8,
    ingredients = drone_dispatcher_ingredients
  })

  set_transport_drone_item({name = "road-network-reader", order = "nullius-i", stack_size = 50})
  set_transport_drone_recipe({
    name = "road-network-reader",
    order = "nullius-i",
    category = "small-crafting",
    time = 5,
    ingredients = {
      {type = "item", name = "rail-chain-signal", amount = 1},
      {type = "item", name = "nullius-sensor-1", amount = 1},
      {type = "item", name = "programmable-speaker", amount = 1}
    }
  })

  set_transport_drone_item({name = "transport-depot-reader", order = "nullius-j", stack_size = 50})
  set_transport_drone_recipe({
    name = "transport-depot-reader",
    order = "nullius-j",
    category = "small-crafting",
    time = 2,
    ingredients = {
      {type = "item", name = "road-network-reader", amount = 1},
      {type = "item", name = "nullius-red-wire", amount = 2}
    }
  })

  set_transport_drone_item({name = "transport-depot-writer", order = "nullius-k", stack_size = 50})
  set_transport_drone_recipe({
    name = "transport-depot-writer",
    order = "nullius-k",
    category = "small-crafting",
    time = 3,
    ingredients = {
      {type = "item", name = "road-network-reader", amount = 1},
      {type = "item", name = "nullius-green-wire", amount = 3}
    }
  })

  data.raw["assembling-machine"]["request-depot"].fluid_boxes[2].base_level = 6
  data.raw["assembling-machine"]["buffer-depot"].fluid_boxes[2].base_level = 6
  data.raw["assembling-machine"]["fuel-depot"].fluid_boxes[2].base_level = -3
  data.raw["assembling-machine"]["fuel-depot"].fluid_boxes[2].height = 8
  data.raw["assembling-machine"]["fuel-depot"].fluid_boxes[2].base_area = 250
  data.raw["furnace"]["fluid-depot"].fluid_boxes[2].base_level = -3
  data.raw["furnace"]["fluid-depot"].fluid_boxes[2].height = 8
  data.raw["furnace"]["fluid-depot"].fluid_boxes[2].base_area = 125

  data.raw.item["fast-road"].stack_size = 500
  data.raw.item["fast-road"].order = "nullius-ba"
  data.raw.item["fast-road"].icons[1].tint = { 0.66, 0.66, 0.66 }
  data.raw.tile["transport-drone-road-better"].tint = {0.66, 0.66, 0.66}
  data.raw.tile["transport-drone-road-better"].vehicle_friction_modifier = 0.4
  data.raw.item["nullius-black-concrete"].icons[1].tint = { 0.4, 0.4, 0.4 }
  data.raw.tile["black-refined-concrete"].tint = {0.4, 0.4, 0.4}

  data.raw.recipe["fast-road"].icons = data.raw.item["fast-road"].icons
  data.raw.recipe["fast-road"].order = "nullius-ba"
  data.raw.recipe["fast-road"].enabled = false
  data.raw.recipe["fast-road"].hidden = false
  data.raw.recipe["fast-road"].always_show_made_in = true
  data.raw.recipe["fast-road"].show_amount_in_title = false
  data.raw.recipe["fast-road"].always_show_products = true
  data.raw.recipe["fast-road"].category = "large-crafting"
  data.raw.recipe["fast-road"].energy_required = 30
  data.raw.recipe["fast-road"].results = {
    {type = "item", name = "fast-road", amount = 8}
  }
  data.raw.recipe["fast-road"].ingredients = {
    {type = "item", name = "road", amount = 50},
    {type = "item", name = "nullius-box-black-concrete", amount = 6},
    {type = "item", name = "road-network-reader", amount = 1}
  }
end
