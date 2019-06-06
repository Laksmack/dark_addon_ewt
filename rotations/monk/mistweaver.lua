-- Mistweaver Monk for 8.1 by Rotations - 10/2018
-- Talents: 3 2 2 3 2 1 3
-- Holding Alt = SpinningCraneKick
-- Holding Shift = SummonJadeSerpent or SummonRefreshingJade or RedCrane
-- Holding Control = Mana tea
local race = UnitRace("player")
local realmName = GetRealmName()
local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.monk



local function combat()
 

--- Reticulate Splines
    local group_health_percent = 100 * UnitHealth("player") / UnitHealthMax("player") or 0
    local group_health = group_health_percent
    local group_unit_count = IsInGroup() and GetNumGroupMembers() or 1
    local damaged_units = group_health_percent < 90 and 1 or 0
    local dead_units = 0
    for i = 1,group_unit_count-1 do
      local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
      local unit = IsInRaid() and "raid"..i or "party"..i
      local unit_health = 100 * UnitHealth(unit) / UnitHealthMax(unit) or 0
      if unit_health < 90 then
        damaged_units = damaged_units + 1
      end
      if isDead or not online or not UnitInRange(unit) then
        dead_units = dead_units + 1
      else
        group_health = group_health + unit_health
      end
    end
    group_health_percent = group_health / (group_unit_count - dead_units)


-- Main rotation
if player.alive and not player.channeling() then -- target.alive and target.enemy then

if target.enemy and target.distance < 8 then
      auto_attack()
end

 local inRange = 0
  for i = 1, 40 do
    if UnitExists('nameplate' .. i) and IsSpellInRange('Rising Sun Kick', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
      
      inRange = inRange + 1
    end
    
  end


  --modifiers
    if modifier.control and -spell(SB.Paralysis) == 0 then
      return cast(SB.Paralysis, target)
    end

   if modifier.shift and talent(6, 1) and -spell(SB.SummonJade) == 0 then
      return cast(SB.SummonJade, 'ground')
   elseif modifier.shift and talent(6, 3) and -spell(SB.RedCrane) == 0 then
      return cast(SB.RedCrane)
   elseif modifier.shift and talent(6, 2) and -spell(SB.RefreshingJadeWind) == 0 then
      return cast(SB.RefreshingJadeWind)
    end

    if modifier.alt and -spell(SB.SpinningCrane) == 0 then
      return cast(SB.SpinningCrane)
    end
-- tank.health.percent < 40

--Dispell
    local dispellable_unit = group.removable('disease', 'magic', 'poison')
    if toggle('dispell', false) and dispellable_unit and spell(SB.Detox).cooldown == 0 then
      return cast(SB.Detox, dispellable_unit)
    end
-- self-cleanse
    local dispellable_unit = player.removable('disease', 'magic', 'poison')
    if toggle('DISPELL', false) and dispellable_unit then
     return cast(SB.Cleanse, dispellable_unit)
    end

    if player.spell(SB.SummonJade).lastcast then
      return cast(SB.SoothingMist, lowest)
    end

    if group_health_percent <= 90 and -spell(SB.EssenceFont) == 0 then
      return cast(SB.EssenceFont)
    end

    if player.moving and lowest.health.percent <= 95 and -spell(SB.EssenceFont) == 0 and toggle('multitarget', false) then
      return cast(SB.EssenceFont)
    end
    if player.moving and tank.health.percent <= 95 and -spell(SB.EssenceFont) == 0 and toggle('multitarget', false) then
      return cast(SB.EssenceFont)
    end

--Buff
    if lowest.health.percent < 70  and -spell(SB.ThunderFocus) == 0 and not -buff(SB.ThunderFocus) then
      return cast(SB.ThunderFocus, lowest)
    end

    if player.health.percent <= 30  and -spell(SB.Dampen) == 0 and talent(5,3) then
      return cast(SB.Dampen, player)
    end
    if player.health.percent <= 30 and -spell(SB.Dampen) == 0 and talent(5,2) then
      return cast(SB.DiffuseMagic, player)
    end

--Healing
    if player.health.percent <= 70 and -spell(SB.FortBrew) == 0 then
      print 'fortbrew'
      return cast(SB.FortBrew)
    end
-- tank.health.percent < 40
    if tank.health.percent < 90 and -spell(SB.RenewingMist) == 0 and not -tank.buff(SB.RenewingMistBuff) then
      return cast(SB.RenewingMist, tank)
    end

    if lowest.health.percent <= 90 and -spell(SB.RenewingMist) == 0 and not -lowest.buff(SB.RenewingMistBuff) then
      return cast(SB.RenewingMist, lowest)
    end

    if talent(1, 2) and lowest.health.percent <= 80 and -spell(SB.ChiWave) == 0 then
      return cast(SB.ChiWave, lowest)
    end

    --
    if lowest.health.percent < 50  and not player.spell(SB.Vivity).lastcast then
      return cast(SB.Vivity, lowest)
    end

    if tank.health.percent < 50  and not player.spell(SB.Vivity).lastcast then
      return cast(SB.Vivity, tank)
    end

    if target.distance <= 5 and toggle('interrupts', false) and target.interrupt(100, false) and -spell(SB.LegSweep) == 0 then
      return cast(SB.LegSweep, target)
    end


    if lowest.health.percent <= 70 and -lowest.buff(SB.RenewingMistBuff) and not -lowest.buff(SB.EnvelopeMist) and -spell(SB.EnvelopeMist) == 0 and not player.spell(SB.EnvelopeMist).lastcast then
      return cast(SB.EnvelopeMist, lowest)
    end

    if tank.health.percent <= 70 and -lowest.buff(SB.RenewingMistBuff) and not -tank.buff(SB.EnvelopeMist) and -spell(SB.EnvelopeMist) == 0 and not player.spell(SB.EnvelopeMist).lastcast then
      return cast(SB.EnvelopeMist, tank)
    end

    if lowest.health.percent <= 40 and -lowest.buff(SB.RenewingMistBuff) and not -lowest.buff(SB.LifeCocoon) and -spell(SB.LifeCocoon) == 0 and toggle('cooldowns', false) then
      return cast(SB.LifeCocoon, lowest)
    end

    if tank.health.percent <= 40 and -tank.buff(SB.RenewingMistBuff) and not -tank.buff(SB.LifeCocoon) and -spell(SB.LifeCocoon) == 0 and toggle('cooldowns', false) then
      return cast(SB.LifeCocoon, tank)
    end

    if lowest.health.percent <= 80 and -lowest.buff(SB.RenewingMistBuff)  then -- and -spell(SB.LifeCocoon) >= 1
      return cast(SB.SoothingMist, lowest)
    end

    if tank.health.percent <= 80 and -tank.buff(SB.RenewingMistBuff)  then -- and -spell(SB.LifeCocoon) >= 1
      return cast(SB.SoothingMist, tank)
    end

  if toggle('cooldowns', false) and group_health_percent <= 50 and -spell(SB.Revival) == 0 then
      return cast(SB.Revival)
    end

    if target.distance <= 6 and target.enemy and -spell(SB.RisingSunKick) == 0 and talent(7,3) then
      return cast(SB.RisingSunKick, target)
    end

    if target.distance <= 6 and target.enemy and -spell(SB.BlackoutKick) == 0 then
      return cast(SB.BlackoutKick, target)
    end

    if target.distance <= 6 and target.enemy and -spell(SB.TigerPalm) == 0 then
      return cast(SB.TigerPalm, target)
    end

    if GetItemCooldown(5512) == 0 and player.health.percent < 30 then
      macro('/use Healthstone')
    end



    if player.health.percent <= 50 and spell(SB.HealingPot).charges >= 1 and talent(5,1) then
      return cast(SB.HealingPot)
    end

    if toggle('multitarget', false) and -spell(SB.ChiBurst) == 0 and talent(1,3) and target.enemy then 
      return cast(SB.ChiBurst, target)
    end
    if modifier.control and -spell(SB.ManaTea) == 0 and talent(3,3) then
      return cast(SB.ManaTea)
    end

    -- Ok lets do some tab targetting to find some people in the party to overheal on.  But dont make it look too obviouse. 


   if player.alive and toggle('over_heal', false) and not target.enemy then
      macro('/targetfriendplayer')

    if target.health.percent <= 98 and -spell(SB.RenewingMist) == 0 and not -target.buff(SB.RenewingMistBuff) then
      return cast(SB.RenewingMist, target)
    end

    if talent(1, 2) and target.health.percent <= 98 and -spell(SB.ChiWave) == 0 then
      return cast(SB.ChiWave, target)
    end
    if group_health_percent <= 98 and -spell(SB.EssenceFont) == 0 then
      return cast(SB.EssenceFont)
    end
    if target.health.percent <= 98 and -target.buff(SB.RenewingMistBuff) and not -target.buff(SB.EnvelopeMist) and -spell(SB.EnvelopeMist) == 0 and not player.spell(SB.EnvelopeMist).lastcast then
      return cast(SB.EnvelopeMist, target)
    end    
    if target.health.percent < 95  and not player.spell(SB.Vivity).lastcast then
      return cast(SB.Vivity, target)
    end


   end

  end
end

-- Put great stuff here to do when your out of combat
local function resting()

  if player.alive then 

  local SB = dark_addon.rotation.spellbooks.monk
     local group_health_percent = 100 * UnitHealth("player") / UnitHealthMax("player") or 0
    local group_health = group_health_percent
    local group_unit_count = IsInGroup() and GetNumGroupMembers() or 1
    local damaged_units = group_health_percent < 90 and 1 or 0
    local dead_units = 0
    for i = 1,group_unit_count-1 do
      local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
      local unit = IsInRaid() and "raid"..i or "party"..i
      local unit_health = 100 * UnitHealth(unit) / UnitHealthMax(unit) or 0
      if unit_health < 90 then
        damaged_units = damaged_units + 1
      end
      if isDead or not online or not UnitInRange(unit) then
        dead_units = dead_units + 1
      else
        group_health = group_health + unit_health
      end
    end
    group_health_percent = group_health / (group_unit_count - dead_units)
    
    if modifier.control and -spell(SB.Paralysis) == 0 then
      return cast(SB.Paralysis, target)
    end

--Dispell
    local dispellable_unit = group.removable('disease', 'magic', 'poison')
    if toggle('dispell', false) and dispellable_unit and spell(SB.Detox).cooldown == 0 then
      return cast(SB.Detox, dispellable_unit)
    end
-- self-cleanse
    local dispellable_unit = player.removable('disease', 'magic', 'poison')
    if toggle('DISPELL', false) and dispellable_unit then
     return cast(SB.Cleanse, dispellable_unit)
    end


    if group_health_percent <= 98 and -spell(SB.EssenceFont) == 0 then
      return cast(SB.EssenceFont)
    end

--Healing

    if lowest.health.percent <= 90 and -spell(SB.RenewingMist) == 0 and not -lowest.buff(SB.RenewingMistBuff) then
      return cast(SB.RenewingMist, lowest)
    end


    if talent(1, 2) and lowest.health.percent <= 80 and -spell(SB.ChiWave) == 0 then
      return cast(SB.ChiWave, lowest)
    end

    --
    if lowest.health.percent < 50  and not player.spell(SB.Vivity).lastcast then
      return cast(SB.Vivity, lowest)
    end

    if lowest.health.percent <= 90 and -lowest.buff(SB.RenewingMistBuff) and not -lowest.buff(SB.EnvelopeMist) and -spell(SB.EnvelopeMist) == 0 and not player.spell(SB.EnvelopeMist).lastcast then
      return cast(SB.EnvelopeMist, lowest)
    end

    if lowest.health.percent <= 40 and -lowest.buff(SB.RenewingMistBuff) and not -lowest.buff(SB.LifeCocoon) and -spell(SB.LifeCocoon) == 0 and toggle('cooldowns', false) then
      return cast(SB.LifeCocoon, lowest)
    end


    if lowest.health.percent <= 90 and -lowest.buff(SB.RenewingMistBuff)  then -- and -spell(SB.LifeCocoon) >= 1
      return cast(SB.SoothingMist, lowest)
    end

    if target.distance <= 6 and target.enemy and -spell(SB.RisingSunKick) == 0 and talent(7,3) then
      return cast(SB.RisingSunKick, target)
    end

    if target.distance <= 6 and target.enemy and -spell(SB.BlackoutKick) == 0 then
      return cast(SB.BlackoutKick, target)
    end

    if target.distance <= 6 and target.enemy and -spell(SB.TigerPalm) == 0 then
      return cast(SB.TigerPalm, target)
    end

    if modifier.control and -spell(SB.ManaTea) == 0 and talent(3,3) then
      return cast(SB.ManaTea)
    end

end
end

function interface()
   dark_addon.interface.buttons.add_toggle({
    name = 'heal_tank',
    label = 'Heal the Tanks',
    on = {
      label = 'HT',
      color = dark_addon.interface.color.orange,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'HT',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  dark_addon.interface.buttons.add_toggle({
    name = 'dispell',
    label = 'Auto Dispell',
    on = {
      label = 'DSP',
      color = dark_addon.interface.color.red,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.red, 0.7)
    },
    off = {
      label = 'dsp',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  dark_addon.interface.buttons.add_toggle({
    name = 'over_heal',
    label = 'Lets do some over healing',
    on = {
      label = 'OH',
      color = dark_addon.interface.color.red,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.red, 0.7)
    },
    off = {
      label = 'OH',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
end
dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.monk.mistweaver,
  name = 'mistweaver',
  label = 'Bundled Mistweaver With Overheal',
  combat = combat,
  resting = resting,
  interface = interface
})





