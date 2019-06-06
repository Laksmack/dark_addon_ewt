-- Vengeance Demon Hunter for 8.1 by Tacotits - 8/2018
-- Talents: 1213121
-- Holding Alt =
-- Holding Shift = Infernal Strike (leap to location)

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.demonhunter
local TB = dark_addon.rotation.talentbooks.demonhunter

local function combat()
  if target.alive and target.enemy then
    auto_attack()
    --Infernal Strike (Leap) on Shift key
    if modifier.shift and castable(SB.InfernalStrike) and toggle('leap') then
      return cast(SB.InfernalStrike, 'ground')
    end

    -- Interrupt
    if toggle('interrupts') and castable(SB.Disrupt) and target.interrupt(90) and power.pain.deficit >= 30 then
      return cast(SB.Disrupt)
    end

    -- Consume Magic simply purges one magic buff from an enemy and provides you with 20 Pain if you successfully do so.
    if castable(SB.ConsumeMagic, 'target') and target.buff(SB.ConsumeMagic).up and power.pain.deficit >= 20 then
      return cast(SB.ConsumeMagic, 'target')
    end

    -- Metamorphosis - emergency cooldown to heal you up when you drop low on health. The extra Pain that Metamorphosis generates is also a nice bonus, which you can use on Soul Cleave for more healing.
    if castable(SB.MetamorphosisVengeance) and player.health.percent <= 50 then
      return cast(SB.MetamorphosisVengeance)
    end

    -- Demon Spikes - Always keep at least one of its charges rolling. Off the GCD. Save other charge for incoming damage.
    if castable(SB.DemonSpikes) and spell(SB.DemonSpikes).charges > 1 and not buff(SB.DemonSpikes).up then
      return cast(SB.DemonSpikes)
    end

    -- Fiery Brand - if Burning Alive talented, use on coooldown. Else save for high damage times.
    if -spell(SB.FieryBrand) == 0 and talent(TB.BurningAlive) or player.health.percent <= 80 then
       return cast(SB.FieryBrand, 'target')
     end

    -- Spirit Bomb - if 4+ Soul Fragments are active. (40 yd)
    if castable(SB.SpiritBomb) and buff(SB.SoulFragments).count > 3 and target.distance <= 30 then
      return cast(SB.SpiritBomb)
    end

    -- Fracture - if you will not cap on Pain/Souls and you are taking the Fracture talent.
    if castable(SB.Fracture, 'target') and talent(TB.Fracture) and power.pain.deficit >= 25 and buff(SB.SoulFragments).count < 4 then
      return cast(SB.Fracture, 'target')
    end

    -- Immolation Aura - if you will not cap on Pain/Souls.
    if castable(SB.ImmolationAura) and power.pain.deficit >= 10 and buff(SB.SoulFragments).count < 5 then
      return cast(SB.ImmolationAura)
    end

    -- Soul Cleave - for whenever you require additional healing, to dump pain, or to consume Soul Fragments.
    if castable(SB.SoulCleave, 'target') and (player.health.percent <= 75 or power.pain.deficit < 10 or buff(SB.SoulFragments).count >= 4) then
      return cast(SB.SoulCleave, 'target')
    end

    -- Sigil of Flame
    if castable(SB.SigilOfFlame) and target.distance <= 8 then
      return cast(SB.SigilOfFlame)
    end

    -- Shear - for filler/if you will not cap on Pain/Souls and you do not have Fracture talented.
    if not talent(TB.Fracture) and castable(SB.Shear, 'target') and power.pain.deficit >= 25 or buff(SB.SoulFragments).count < 5 then
      return cast(SB.Shear, 'target')
    end

    -- Throw Glaive - as a filler if you have Fracture.
    if castable(SB.ThrowGlaiveVengeance, 'target') and talent(TB.Fracture) and target.distance <= 30 then
      return cast(SB.ThrowGlaiveVengeance, 'target')
    end
  end
end

local function resting()
  if modifier.shift and castable(SB.InfernalStrike) and toggle('leap') then
    return cast(SB.InfernalStrike, 'ground')
  end
end

function interface()
  dark_addon.interface.buttons.add_toggle({
    name = 'leap',
    label = 'Leap',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('bars'),
      color = dark_addon.interface.color.green,
      color2 = dark_addon.interface.color.dark_green
    },
    off = {
      label = dark_addon.interface.icon('bars'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.demonhunter.vengeance,
  name = 'vengeance',
  label = 'Bundled Vengeance',
  combat = combat,
  resting = resting,
  interface = interface
})
