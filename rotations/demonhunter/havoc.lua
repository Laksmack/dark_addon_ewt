-- Havok Demon Hunter for 8.1 by Tacotits - 8/2018
-- Talents: 3210223
-- Holding Alt =
-- Holding Shift =

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.demonhunter
local TB = dark_addon.rotation.talentbooks.demonhunter

local function combat()
  if target.alive and target.enemy and not player.channeling() then

   auto_attack()

    local blade_dance = (talent(TB.FirstBlood) or toggle('multitarget')) and target.distance <= 8
    local waiting_for_nemesis = not (not talent(TB.Nemesis) or spell(SB.Nemesis).cooldown == 0 or spell(SB.Nemesis).cooldown > target.time_to_die or spell(SB.Nemesis).cooldown > 60)
    local pooling_for_meta = not talent(TB.Demonic) and spell(SB.Metamorphosis).cooldown < 6 and power.fury.deficit > 30 and (not waiting_for_nemesis or spell(SB.Nemesis).cooldown < 10)
    local pooling_for_blade_dance = blade_dance and ((talent(TB.FirstBlood) and power.fury.actual < 55) or power.fury.actual < 75)
    local waiting_for_dark_slash = talent(TB.DarkSlash) and not pooling_for_blade_dance and not pooling_for_meta and spell(SB.DarkSlash).cooldown == 0
    local waiting_for_momentum = talent(TB.Momentum) and not buff(SB.Momentum).up


    if toggle('interrupts') and castable(SB.Disrupt) and target.interrupt(90) then
      return cast(SB.Disrupt)
    end
    if castable(SB.Blur) and player.health.percent <= 30 then
      return cast(SB.Blur)
    end
    if toggle('cooldowns') then
      if castable(SB.Metamorphosis, 'ground') and not (talent(TB.Demonic) or pooling_for_meta or waiting_for_nemesis) then -- or target.time_to_die < 25
        return cast(SB.Metamorphosis, 'ground')
      end
      if castable(SB.Metamorphosis, 'ground') and talent(TB.Demonic) and buff(SB.Metamorphosis).up then
        return cast(SB.Metamorphosis, 'ground')
      end
      if castable(SB.Nemesis, 'target') and toggle('multitarget') and target.debuff(SB.Nemesis).down then
        return cast(SB.Nemesis, 'target')
      end
      if castable(SB.Nemesis, 'target') and not toggle('multitarget') then
        return cast(SB.Nemesis, 'target')
      end
      -- if usable(SB.Potion, 'target') and buff('Metamorphosis').remains > 25 and target.time_to_die < 60 then
      --   return use(SB.Potion, 'target')
      -- end
      -- if usable(SB.GalecallersBoon, 'player') then
      --   return use(SB.GalecallersBoon, 'player')
      -- end
      -- if usable(SB.LustrousGoldenPlumage, 'player') then
      --   return use(SB.LustrousGoldenPlumage, 'player')
      -- end
    end

    -- actions+=/pick_up_fragment,if=fury.deficit>=35

    if talent(TB.DarkSlash) and (waiting_for_dark_slash or debuff.dark_slash.up) then
      if castable(SB.DarkSlash, 'target') and power.fury >= 80 and (not blade_dance or not spell(SB.BladeDance).cooldown == 0) then
        return cast(SB.DarkSlash, 'target')
      end
      if castable(SB.Annihilation, 'target') and target.debuff(SB.DarkSlash).up then
        return cast(SB.Annihilation, 'target')
      end
      if castable(SB.ChaosStrike, 'target') and target.distance <= 8 and target.debuff(SB.DarkSlash).up then
        return cast(SB.ChaosStrike, 'target')
      end
    end

    -- Demonic
    if talent(TB.Demonic) then
      if talent(TB.FelBarrage) and toggle('multitarget') and castable(SB.FelBarrage, 'target') then
        return cast(SB.FelBarrage, 'target')
      end
      if castable(SB.DeathSweep, 'target') and blade_dance then
        return cast(SB.DeathSweep, 'target')
      end
      if castable(SB.BladeDance, 'target') and blade_dance and spell(SB.EyeBeam).cooldown > 5 and spell(SB.Metamorphosis).cooldown > 0 then
        return cast(SB.BladeDance, 'target')
      end
      if castable(SB.ImmolationAura) then
        return cast(SB.ImmolationAura)
      end
      if castable(SB.Felblade, 'target') and target.distance <= 15 and (power.fury.actual < 40 or (buff(SB.Metamorphosis).down and power.fury.deficit >= 40)) then
        return cast(SB.Felblade, 'target')
      end
      if castable(SB.EyeBeam, 'target') and target.distance <= 8 and (not talent(TB.BlindFury) or power.fury.deficit >= 70) and buff(SB.Metamorphosis).remains > 16 then
        return cast(SB.EyeBeam, 'target')
      end
      if castable(SB.Annihilation, 'target') and (talent(TB.DemonBlades) or power.fury.deficit < 30 or buff(SB.Metamorphosis).remains < 5) and not pooling_for_blade_dance then
        return cast(SB.Annihilation, 'target')
      end
      if castable(SB.ChaosStrike, 'target') and target.distance <= 8 and (talent(TB.DemonBlades) or power.fury.deficit < 30) and not pooling_for_meta and not pooling_for_blade_dance then
        return cast(SB.ChaosStrike, 'target')
      end
      -- actions.demonic+=/fel_rush,if=talent.demon_blades.enabled&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
      -- actions.demonic+=/fel_rush,if=!talent.demon_blades.enabled&!cooldown.eye_beam.ready&azerite.unbound_chaos.rank>0
      -- actions.demonic+=/demons_bite
      if castable(SB.ThrowGlaive, 'target') and target.distance >= 8 then
        return cast(SB.ThrowGlaive, 'target')
      end
      -- actions.demonic+=/fel_rush,if=movement.distance>15|buff.out_of_range.up
      -- actions.demonic+=/vengeful_retreat,if=movement.distance>15
      if castable(SB.ThrowGlaive, 'target') and talent(TB.DemonBlades) then
        return cast(SB.ThrowGlaive, 'target')
      end
    end

    -- actions.normal=vengeful_retreat,if=talent.momentum.enabled&buff.prepared.down
    -- actions.normal+=/fel_rush,if=(variable.waiting_for_momentum|talent.fel_mastery.enabled)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))

    if talent(TB.FelBarrage) and toggle('multitarget') and castable(SB.FelBarrage, 'target') and not waiting_for_momentum then
      return cast(SB.FelBarrage, 'target')
    end
    if castable(SB.ImmolationAura) then
      return cast(SB.ImmolationAura)
    end
    if castable(SB.EyeBeam, 'target') and target.distance <= 8 and toggle('multitarget') and not waiting_for_momentum then
      return cast(SB.EyeBeam, 'target')
    end
    if castable(SB.DeathSweep, 'target') and blade_dance then
      return cast(SB.DeathSweep, 'target')
    end
    if castable(SB.BladeDance, 'target') and blade_dance then
      return cast(SB.BladeDance, 'target')
    end
    -- actions.normal+=/fel_rush,if=!talent.momentum.enabled&!talent.demon_blades.enabled&azerite.unbound_chaos.rank>0
    if castable(SB.Felblade, 'target') and target.distance <= 15 and power.fury.deficit >= 40 then
      return cast(SB.Felblade, 'target')
    end
    if castable(SB.EyeBeam, 'target') and target.distance <= 8 and not talent(TB.BlindFury) and not waiting_for_dark_slash then
      return cast(SB.EyeBeam, 'target')
    end
    if castable(SB.Annihilation, 'target') and (talent(TB.DemonBlades) or waiting_for_momentum or power.fury.deficit < 30 or buff(SB.Metamorphosis).remains < 5) and not pooling_for_blade_dance and not waiting_for_dark_slash then
      return cast(SB.Annihilation, 'target')
    end
    if castable(SB.ChaosStrike, 'target') and target.distance <= 8 and (talent(TB.DemonBlades) or not waiting_for_momentum or power.fury.deficit < 30) and not pooling_for_meta and not pooling_for_blade_dance and not waiting_for_dark_slash then
      return cast(SB.ChaosStrike, 'target')
    end
    if castable(SB.EyeBeam, 'target') and target.distance <= 8 and talent(TB.BlindFury) then
      return cast(SB.EyeBeam, 'target')
    end
    -- actions.normal+=/demons_bite
    -- actions.normal+=/fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&talent.demon_blades.enabled
    if castable(SB.Felblade, 'target') and target.distance <= 15 and target.distance >= 8 then
      return cast(SB.Felblade, 'target')
    end
    -- actions.normal+=/fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
    -- actions.normal+=/vengeful_retreat,if=movement.distance>15
    -- actions.normal+=/throw_glaive,if=talent.demon_blades.enabled
    if castable(SB.ThrowGlaive, 'target') and talent(TB.DemonBlades) then
      return cast(SB.ThrowGlaive, 'target')
    end

  end
end

local function resting()
  -- Put great stuff here to do when your out of combat
end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.demonhunter.havoc,
  name = 'havoc',
  label = 'Bundled Havoc',
  combat = combat,
  resting = resting
})
