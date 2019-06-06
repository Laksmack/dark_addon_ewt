-- Restoration Druid for 8.1 by Tacotits - 9/2018
-- Talents: Raid=3133213 Dungeon=1133212
-- Holding Alt = Efflorescence
-- Holding Shift =

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.druid
local TB = dark_addon.rotation.talentbooks.druid
local DB = dark_addon.rotation.dispellbooks.druid
local DS = dark_addon.rotation.dispellbooks.soothe

local function combat()
  if player.buff(SB.TravelForm).exists or player.buff(SB.Refreshment).up or player.channeling() then return end

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

  -- Barkskin
  if player.castable(SB.Barkskin) and player.health.percent < 66 then
    return cast(SB.Barkskin, player)
  end

  -- TODO: target/mouseover healing, healthstone

  --- Healing Cooldowns
  if toggle('cooldowns') then
    -- Tranquility should be used during heavy raid damage or when you are assigned to use it by your raid leader. Casting Wild Growth Icon Wild Growth before Tranquility is recommended to increase the benefits from Mastery. In cases where Tranquility might be too dangerous to cast, you might want to use either Barkskin Icon Barkskin, Ironbark Icon Ironbark or even both on yourself.
    -- Use Tranquility, if the group is still taking heavy damage. It does 100% more healing in 5-man content.
    if player.castable(SB.Tranquility) and not player.moving
    and (IsInRaid() and group_health_percent < 70 or group_health_percent < 50) then
      return cast(SB.Tranquility, player)
    end

    -- Innervate should be used as many times during the fight as possible. Refresh Efflorescence, cast Wild Growth, and spam Rejuvenation during Innervate.
    if player.castable(SB.Innervate) and player.power.mana.percent < 90
    and (IsInRaid() and group_health_percent < 90 or group_health_percent < 70) then
      return cast(SB.Innervate, player)
    end

    -- Ironbark should be used to reduce the damage a tank is taking during critical moments (such as when important boss abilities are about to be cast). In the absence of such situations, you should just use it on players who are taking damage. You may be assigned to use it at a specific time, as part of a rotation with other healers and the tanks' own cooldowns.
    if tank.castable(SB.Ironbark) and tank.health.percent < 66 then
      return cast(SB.Ironbark, tank)
    end

    -- Flourish should be used during heavy raid damage. Ideally, you should use it together with Wild Growth. In most situations it is optimal to couple it with Velen's Future Sight Icon Velen's Future Sight.
    -- Use Flourish as often as possible. Make sure you have cast Wild Growth before using Flourish.
    if talent(TB.Flourish) and player.castable(SB.Flourish)
    and (lastcast(SB.WildGrowth) or lastcast(SB.Tranquility)) then
      return cast(SB.Flourish, player)
    end

    -- Maintain Efflorescence under the melee group.
    if IsAltKeyDown() and not lastcast(SB.Efflorescence) then
      return cast(SB.Efflorescence, 'ground')
    end

    -- Keep Lifebloom, on an active tank.
    if tank.castable(SB.Lifebloom) and tank.buff(SB.Lifebloom).down and not lastcast(SB.Lifebloom) then
      return cast(SB.Lifebloom, tank)
    end
  end

  --- Soothe
  if target.castable(SB.Soothe) then
    for i=1,40 do
      local name, _, _, count, debuff_type, _, _, _, _, _, spell_id = UnitAura("target", i)
      if name and DS[spell_id] then
        print("Soothing "..name.." off the target.")
        return cast(SB.Soothe, target)
      end
    end
  end

  --- Decurse
  local dispellable_unit = group.removable('curse', 'magic', 'poison')
  if dispellable_unit and spell(SB.NaturesCure).cooldown == 0 then
    return cast(SB.NaturesCure, dispellable_unit)
  end

  --- Healing
  -- Use Clearcasting procs to cast Regrowth on any person in the raid.
  if player.buff(SB.Clearcasting).up and lowest.castable(SB.Regrowth) and lowest.health.percent < 95
  and not player.moving then
    return cast(SB.Regrowth, lowest)
  end

  -- Use Cenarion Ward on cooldown.
  if talent(TB.CenarionWard) and tank.castable(SB.CenarionWard) then
    return cast(SB.CenarionWard, tank)
  end

  -- Keep Rejuvenation, on the tank and on members of the group that just took damage or are about to take damage.
  if tank.castable(SB.Rejuvenation) and (tank.buff(SB.Rejuvenation).down or (talent(TB.Germination)
  and tank.buff(SB.RejuvenationGermination).down)) then
    return cast(SB.Rejuvenation, tank)
  end
  if lowest.castable(SB.Rejuvenation) and (lowest.buff(SB.Rejuvenation).down and lowest.health.percent < 100)
  or (talent(TB.Germination) and lowest.buff(SB.RejuvenationGermination).down
  and (lowest.health.percent < 80 or player.buff(SB.Innervate))) then
    return cast(SB.Rejuvenation, lowest)
  end

  -- Use Wild Growth, when at least 4/6 members of the group/raid are damaged.
  if lowest.castable(SB.WildGrowth) and not player.moving
  and (not IsInRaid() and damaged_units >= 4 or damaged_units >= 6) then
    return cast(SB.WildGrowth, lowest)
  end

  -- Use Swiftmend on a player that just took heavy damage. If not in immediate danger, use Rejuvenation first.
  if tank.castable(SB.Swiftmend) and tank.health.percent <= 75 then
    return cast(SB.Swiftmend, tank)
  end
  if lowest.castable(SB.Swiftmend)
  and (lowest.buff(SB.Rejuvenation).up and lowest.health.percent <= 75 or lowest.health.percent <= 50) then
    return cast(SB.Swiftmend, lowest)
  end

  -- Use Regrowth as an emergency heal.
  if not IsInRaid() then
    if tank.castable(SB.Regrowth) and not player.moving and tank.health.percent <= 70 then
      return cast(SB.Regrowth, tank)
    end
    if lowest.castable(SB.Regrowth) and not player.moving and lowest.health.percent <= 50 then
      return cast(SB.Regrowth, lowest)
    end
  end

  -- During downtime, use Moonfire, Sunfire and Solar Wrath on enemies to help with the damage.
  if player.power.mana.percent > 70 and lowest.health.percent > 95 then
    if target.castable(SB.Moonfire) and target.debuff(SB.Moonfire).down then
      return cast(SB.Moonfire, target)
    end
    if target.castable(SB.Sunfire) and target.debuff(SB.Sunfire).down then
      return cast(SB.Sunfire, target)
    end
    if target.castable(SB.SolarWrathResto) and not player.moving then
      return cast(SB.SolarWrathResto, target)
    end
  end
end

local function resting()
  -- Maintain Efflorescence under the melee group.
  if IsAltKeyDown() then
    return cast(SB.Efflorescence, 'ground')
  end
  -- Keep Lifebloom, on an active tank.
  if IsInGroup() and tank.castable(SB.Lifebloom) and tank.buff(SB.Lifebloom).down and not lastcast(SB.Lifebloom) then
    return cast(SB.Lifebloom, tank)
  end
  -- Swiftmend
  if player.castable(SB.Swiftmend) and player.health.percent < 50 then
    return cast(SB.Swiftmend, player)
  end
  -- Rejuvenation
  if player.castable(SB.Rejuvenation) and not player.buff(SB.Rejuvenation).up and player.health.percent < 75 then
    return cast(SB.Rejuvenation, player)
  end
  -- Regrowth
  if player.castable(SB.Regrowth) and ((player.health.percent < 75 and not player.buff(SB.Regrowth).up) or player.health.percent < 30) then
    return cast(SB.Regrowth, player)
  end
  -- Barkskin
  if player.castable(SB.Barkskin) and player.health.percent < 50 then
    return cast(SB.Barkskin, player)
  end
  if lowest.castable(SB.Rejuvenation) and (lowest.buff(SB.Rejuvenation).down and lowest.health.percent <= 95)
  or (talent(TB.Germination) and lowest.buff(SB.RejuvenationGermination).down and lowest.health.percent <= 75) then
    return cast(SB.Rejuvenation, lowest)
  end
end

--dark_addon.environment.hook(your_func)
dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.druid.restoration,
  name = 'restoration',
  label = 'Bundled Restoration Druid',
  combat = combat,
  resting = resting
})
