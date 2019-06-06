-- Windwalker Monk for 8.1 by Laksmackt - 10/2018

-- Holding Shift = LegSweep
-- Holding ALT = SpinningCrane
-- Holding CTRL = Karma


--Supported talents: all - ring of peace has to be placed manually



local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.monk

local function combat()
  if not target.alive or not target.enemy and not player.channeling() then
    return
  end

  if target.enemy and target.distance <= 8 then
    auto_attack()
  end

  -- Interupts
  if toggle('interrupts', false) and target.interrupt() and target.distance < 8 and -spell(SB.SpearHandStrike) == 0 then
    return cast(SB.SpearHandStrike, 'target')
  end

  --Defensive CD's
  if talent(5, 2) and toggle('def', false) and  player.health.percent <= 60 and -spell(SB.DiffuseMagic) == 0 then
    return cast(SB.DiffuseMagic)
  end
  if talent(5, 3) and toggle('def', false) and  player.health.percent <= 60 and -spell(SB.Dampen) == 0 then
    return cast(SB.Dampen)
  end

  if toggle('def', false) and -spell(SB.TouchofKarma) == 0 and player.health.percent <= 70 then
    print("karma!")
    return cast(SB.TouchofKarma)
  end

   --use healthstone at 40% health
  if GetItemCooldown(5512) == 0 and player.health.percent < 40 then
    macro('/use Healthstone')
  end


  --Modifiers
  if modifier.shift and -spell(SB.LegSweep) == 0 then
    return cast(SB.LegSweep, 'target')
  end

  if modifier.lalt and -spell(SB.SpinningCrane) == 0 and -power.chi >= 2 then
    return cast(SB.SpinningCrane)
  end

    if modifier.control and -spell(SB.TouchofKarma) == 0 then
    return cast(SB.TouchofKarma, target)
  end


  --CooldDowns

  --TouchofDeath on CD (will ignore mobs that are low on health)
  if toggle('cooldowns', false) and -spell(SB.TouchofDeath) == 0 and target.enemy and target.distance <= 8 and target.health.percent > 50 then
    return cast(SB.TouchofDeath, target)
  end

  if toggle('cooldowns', false) and -spell(SB.StormEarthFire) == 0 and target.enemy and target.distance < 10 and target.health.percent > 30 then
    return cast(SB.StormEarthFire)
  end

  if talent(6, 3) and toggle('cooldowns', false) and -spell(SB.TouchofDeath) > 0 and -spell(SB.InvokeXuen) == 0 then
    return cast(SB.InvokeXuen)
  end


  --DPS rotation
  if toggle('multitarget') and talent(6, 2) and player.buff(SB.RushingJadeWind).down and target.distance < 10 then
    return cast(SB.RushingJadeWind)
  end

  if talent(3, 3) and -spell(SB.EnergizingElixir) == 0 and -power.chi <= 1 then
    return cast(SB.EnergizingElixir)
  end


  if talent(7, 2) and -spell(SB.WhirlingDragonPunch) == 0 and -spell(SB.FistofFury) > 0 and -spell(SB.RisingSunKick) > 0 and target.enemy and target.distance <= 8 then
  return cast(SB.WhirlingDragonPunch, target)
  end

  if player.buff(SB.BlackoutKickBuff).up and not player.spell(SB.BlackoutKick).lastcast and target.distance <= 8 then
  return cast(SB.BlackoutKick, target)
  end

  if talent(1, 3) and -spell(SB.ChiBurst) == 0 and -power.chi <= 4 and target.distance < 40 then
  return cast(SB.ChiBurst)
  end

  if talent(3, 2) and -power.chi < 3 and target.castable(SB.FistoftheWhiteTiger) and target.distance <= 8 then
  return cast(SB.FistoftheWhiteTiger, target)
  end

  if target.distance <= 8 and -power.chi < 4 and -power.energy >= 75 and not player.spell(SB.TigerPalm).lastcast then
  return cast(SB.TigerPalm, target)
  end

  if target.distance <= 8 and -power.chi >= 3 and -spell(SB.FistofFury) == 0 then
  return cast(SB.FistofFury, target)
  end

  if target.distance <= 8 and -power.chi >= 1 and not player.spell(SB.RisingSunKick).lastcast and -spell(SB.RisingSunKick) == 0 then
  return cast(SB.RisingSunKick, target)
  end

  if target.distance <= 8 and -power.chi >= 1 and not player.spell(SB.BlackoutKick).lastcast and -spell(SB.BlackoutKick) == 0 then
  return cast(SB.BlackoutKick, target)
  end

  if talent(1, 2) and target.castable(SB.ChiWave) and target.distance <= 40 then
  return cast(SB.ChiWave, target)
  end

  if target.distance <= 8 and not player.spell(SB.TigerPalm).lastcast then
  return cast(SB.TigerPalm, target)
  end


  -- self-cleanse
  local dispellable_unit = player.removable('poison', 'disease')
  if dispellable_unit and -spell(SB.DetoxDPS) == 0 then
  return cast(SB.DetoxDPS, dispellable_unit)
  end


end

local function resting()
  -- self-cleanse
  local dispellable_unit = player.removable('poison', 'disease')
  if player.alive and toggle('cleanse', false) and dispellable_unit and -spell(SB.DetoxDPS) == 0 then
    return cast(SB.DetoxDPS, dispellable_unit)
  end

  if player.alive and player.health.percent < 30 and toggle('def', false) then
    return cast(SB.Vivify)
  end

end

function interface()
    dark_addon.interface.buttons.add_toggle({
      name = 'def',
      label = 'Defensive CDs',
      on = {
        label = 'DefCD',
        color = dark_addon.interface.color.orange,
        color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
      },
      off = {
        label = 'DefCD',
        color = dark_addon.interface.color.grey,
        color2 = dark_addon.interface.color.dark_grey
      }
    })
  dark_addon.interface.buttons.add_toggle({
      name = 'cleanse',
      label = 'Self Cleanse',
      on = {
        label = 'Detox',
        color = dark_addon.interface.color.orange,
        color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
      },
      off = {
        label = 'Detox',
        color = dark_addon.interface.color.grey,
        color2 = dark_addon.interface.color.dark_grey
      }
    })
end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.monk.windwalker,
  name = 'Windwalker',
  label = 'DPS monknn',
  combat = combat,
  resting = resting,
  interface = interface,
})
