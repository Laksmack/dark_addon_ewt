local addon, dark_addon = ...

dark_addon.rotation = {
  classes = {
    deathknight = { blood = 250, frost = 251, unholy = 252 },
    demonhunter = { havoc = 577, vengeance = 581 },
    druid = { balance = 102, feral = 103, guardian = 104, restoration = 105 },
    hunter = { beastmastery = 253, marksmanship = 254, survival = 255 },
    mage = { arcane = 62, fire = 63, frost = 64 },
    monk = { brewmaster = 268, windwalker = 269, mistweaver = 270 },
    paladin = { holy = 65, protection = 66, retribution = 70 },
    priest = { discipline = 256, holy = 257, shadow = 258 },
    rogue = { assassination = 259, outlaw = 260, subtlety = 261 },
    shaman = { elemental = 262, enhancement = 263, restoration = 264 },
    warlock = { affliction = 265, demonology = 266, destruction = 267 },
    warrior = { arms = 71, fury = 72, protection = 73 }
  },
  rotation_store = { },
  spellbooks = { },
  talentbooks = { },
  dispellbooks = { },
  active_rotation = false
}

function dark_addon.rotation.register(config)
  if config.gcd then
    setfenv(config.gcd, dark_addon.environment.env)
  end
  if config.combat then
    setfenv(config.combat, dark_addon.environment.env)
  end
  if config.resting then
    setfenv(config.resting, dark_addon.environment.env)
  end
  dark_addon.rotation.rotation_store[config.name .. config.spec] = config
end

function dark_addon.rotation.load(name)
  local rotation
  for _, rot in pairs(dark_addon.rotation.rotation_store) do
    if (rot.spec == dark_addon.rotation.current_spec or rot.spec == false) and rot.name == name then
      rotation = rot
    end
  end

  if rotation then
    dark_addon.settings.store('active_rotation_' .. dark_addon.rotation.current_spec, name)
    dark_addon.rotation.active_rotation = rotation
    dark_addon.interface.buttons.reset()
    if rotation.interface then
      rotation.interface(rotation)
    end
    dark_addon.log('Loaded rotation: ' .. name)
    dark_addon.interface.status('Ready...')
  else
    dark_addon.error('Unload to load rotation: ' .. name)
  end
end

local loading_wait = false

local function init()
  if not loading_wait then
    C_Timer.After(0.3, function()
      dark_addon.rotation.current_spec = GetSpecializationInfo(GetSpecialization())
      local active_rotation = dark_addon.settings.fetch('active_rotation_' .. dark_addon.rotation.current_spec, false)
      if active_rotation then
        dark_addon.rotation.load(active_rotation)
        dark_addon.interface.status('Ready...')
      else
        dark_addon.interface.status('Load a rotation...')
      end
      loading_wait = false
    end)
  end
end

dark_addon.on_ready(function()
  init()
  loading_wait = true
end)

dark_addon.event.register("ACTIVE_TALENT_GROUP_CHANGED", function(...)
  init()
  loading_wait = true
end)
