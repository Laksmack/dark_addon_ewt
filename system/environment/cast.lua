local addon, dark_addon = ...

function _CastSpellByName(spell, target)
  local target = target or "target"
  if dark_addon.adv_protected then
    CastSpellByName(spell, target)
    dark_addon.console.debug(2, 'cast', 'red', spell .. ' on ' .. target)
    dark_addon.interface.status(spell)
  else
    secured = false
    while not secured do
      RunScript([[
        for index = 1, 500 do
          if not issecure() then
            return
          end
        end
        CastSpellByName("]] .. spell .. [[", "]] .. target .. [[")
        secured = true
      ]])
      if secured then
        dark_addon.console.debug(2, 'cast', 'red', spell .. ' on ' .. target)
        dark_addon.interface.status(spell)
      end
    end
  end
end

function _CastGroundSpellByName(spell, target)
  local target = target or "target"
  if dark_addon.adv_protected then
    RunMacroText("/cast [@cursor] " .. spell)
    dark_addon.console.debug(2, 'cast', 'red', spell .. ' on ' .. target)
    dark_addon.interface.status(spell)
  else
    secured = false
    while not secured do
      RunScript([[
        for index = 1, 500 do
          if not issecure() then
            return
          end
        end
        RunMacroText("/cast [@cursor] ]] .. spell .. [[")
        secured = true
      ]])
      if secured then
        dark_addon.console.debug(2, 'cast', 'red', spell .. ' on ' .. target)
        dark_addon.interface.status(spell)
      end
    end
  end
end

function _CastSpellByID(spell, target)
  if tonumber(spell) then
    spell, _ = GetSpellInfo(spell)
  end
  return _CastSpellByName(spell, target)
end

function _CastGroundSpellByID(spell, target)
  if tonumber(spell) then
    spell, _ = GetSpellInfo(spell)
  end
  return _CastGroundSpellByName(spell, target)
end

function _SpellStopCasting()
  if dark_addon.adv_protected then
    SpellStopCasting()
  else
    secured = false
    while not secured do
      RunScript([[
        for index = 1, 500 do
          if not issecure() then
            return
          end
        end
        SpellStopCasting()
        secured = true
      ]])
    end
  end
end

local function auto_attack()
  if not IsCurrentSpell(6603) then
    if dark_addon.adv_protected then
      CastSpellByID(6603)
    else
      secured = false
      while not secured do
        RunScript([[
          for index = 1, 500 do
            if not issecure() then
              return
            end
          end
          CastSpellByID(6603)
          secured = true
        ]])
      end
    end
  end
end

local function auto_shot()
  if not IsCurrentSpell(75) then
    if dark_addon.adv_protected then
      CastSpellByID(75)
    else
      secured = false
      while not secured do
        RunScript([[
          for index = 1, 500 do
            if not issecure() then
              return
            end
          end
          CastSpellByID(75)
          secured = true
        ]])
      end
    end

  end
end

function _RunMacroText(text)
  if dark_addon.adv_protected then
    RunMacroText(text)
    dark_addon.console.debug(2, 'macro', 'red', text)
    dark_addon.interface.status('Macro')
  else
    secured = false
    while not secured do
      RunScript([[
        for index = 1, 500 do
          if not issecure() then
            return
          end
        end
        RunMacroText("]] .. text .. [[")
        secured = true
      ]])
      if secured then
        dark_addon.console.debug(2, 'macro', 'red', text)
        dark_addon.interface.status('Macro')
      end
    end
  end
end

dark_addon.tmp.store('lastcast', spell)

local function is_unlocked()
   unlocked = false
   for x = 1, 2000 do
    RunScript([[
      for index = 1, 100 do
        if not issecure() then
          return
        end
      end
      unlocked = true
    ]])
   end
   return unlocked
end

local turbo = false

function dark_addon.environment.hooks.cast(spell, target)
  turbo = dark_addon.settings.fetch('_engine_turbo', false)
  if not dark_addon.protected then return end
  if type(target) == 'table' then target = target.unitID end
  if turbo or not UnitCastingInfo('player') then
    if target == 'ground' then
      if tonumber(spell) then
        _CastGroundSpellByID(spell, target)
      else
        _CastGroundSpellByName(spell, target)
      end
    else
      if tonumber(spell) then
        _CastSpellByID(spell, target)
      else
        _CastSpellByName(spell, target)
      end
    end
  end
end

function dark_addon.environment.hooks.sequenceactive(sequence)
  if sequence.active then
    return true
  end
  return false
end

function dark_addon.environment.hooks.dosequence(sequence)
  if sequence.complete then return false end
  if #sequence.spells == 0 then return false end
  return true
end

function dark_addon.environment.hooks.sequence(sequence)
  if not dark_addon.protected then return end
  if sequence.complete then return true end
  if not sequence.active then sequence.active = true end
  if not sequence.copy then
    sequence.copy = { }
    for _, value in ipairs(sequence.spells) do
      table.insert(sequence.copy, value)
    end
  end
  local lastcast = dark_addon.tmp.fetch('lastcast', false)
  local nextcast = sequence.copy[1]
  if tonumber(nextcast.spell) then
    nextcast.spell = GetSpellInfo(nextcast.spell)
  end
  if lastcast ~= nextcast.spell then
    _CastSpellByName(nextcast.spell, nextcast.target)
  else
    table.remove(sequence.copy, 1)
    if #sequence.copy == 0 then
      sequence.complete = true
    end
  end
end

function dark_addon.environment.hooks.resetsequence(sequence)
  if sequence.copy then
    sequence.copy = nil
    sequence.complete = false
    sequence.active = false
  end
end

function dark_addon.environment.hooks.auto_attack()
  auto_attack()
end

function dark_addon.environment.hooks.auto_shot()
  auto_shot()
end

function dark_addon.environment.hooks.stopcast()
  _SpellStopCasting()
end

function dark_addon.environment.hooks.macro(text)
  _RunMacroText(text)
end

local timer
timer = C_Timer.NewTicker(0.5, function()
  if UnloadEWT then
    dark_addon.log('Detected EWT, it is currently running!')
    dark_addon.protected = true
    dark_addon.adv_protected = true
    timer:Cancel()
  end
  if not dark_addon.protected then
    if is_unlocked() then
      dark_addon.log('Enhanced functionality enabled!')
      dark_addon.protected = true
      dark_addon.adv_protected = false
      timer:Cancel()
    end
  end
end)

dark_addon.event.register("UNIT_SPELLCAST_SUCCEEDED", function(...)
  local unitID, lineID, spellID = ...
  local spell = GetSpellInfo(spellID)
  if unitID == "player" then
    dark_addon.tmp.store('lastcast', spell)
  end
end)
