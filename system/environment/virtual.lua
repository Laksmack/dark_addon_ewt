local addon, dark_addon = ...

dark_addon.environment.virtual = {
  targets = {},
  resolvers = {},
  resolved = {},
  exclude_tanks = true
}

local function GroupType()
  return IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
end

function dark_addon.environment.virtual.validate(virtualID)
  if dark_addon.environment.virtual.targets[virtualID] or virtualID == 'group' then
    return true
  end
  return false
end

function dark_addon.environment.virtual.resolve(virtualID)
  if virtualID == 'group' then
    return 'group', 'group'
  else
    return dark_addon.environment.virtual.resolved[virtualID], 'unit'
  end
end

function dark_addon.environment.virtual.targets.lowest()
  local members = GetNumGroupMembers()
  local group_type = GroupType()
  if dark_addon.environment.virtual.resolvers[group_type] then
    return dark_addon.environment.virtual.resolvers[group_type](members)
  end
end

function dark_addon.environment.virtual.targets.tank()
  return dark_addon.environment.virtual.resolvers.tanks('MAINTANK')
end

function dark_addon.environment.virtual.targets.offtank()
  return dark_addon.environment.virtual.resolvers.tanks('MAINASSIST')
end

function dark_addon.environment.virtual.resolvers.unit(unitA, unitB)
  local healthA = UnitHealth(unitA) / UnitHealthMax(unitA) * 100
  local healthB = UnitHealth(unitB) / UnitHealthMax(unitB) * 100
  if healthA < healthB then
    return unitA, healthA
  else
    return unitB, healthB
  end
end

function dark_addon.environment.virtual.resolvers.party(members)
  local lowest = 'player'
  local lowest_health
  for i = 1, (members - 1) do
    local unit = 'party' .. i
    if not UnitCanAttack('player', unit) and UnitInRange(unit) and not UnitIsDeadOrGhost(unit) and (not dark_addon.environment.virtual.exclude_tanks or not dark_addon.environment.virtual.resolvers.tank(unit)) then
      if not lowest then
        lowest, lowest_health = dark_addon.environment.virtual.resolvers.unit(unit, 'player')
      else
        lowest, lowest_health = dark_addon.environment.virtual.resolvers.unit(unit, lowest)
      end
    end
  end
  return lowest
end

function dark_addon.environment.virtual.resolvers.raid(members)
  local lowest = 'player'
  local lowest_health
  for i = 1, members do
    local unit = 'raid' .. i
    if not UnitCanAttack('player', unit) and UnitInRange(unit) and not UnitIsDeadOrGhost(unit) and (not dark_addon.environment.virtual.exclude_tanks or not dark_addon.environment.virtual.resolvers.tank(unit)) then
      if not lowest then
        lowest, lowest_health = unit, UnitHealth(unit)
      else
        lowest, lowest_health = dark_addon.environment.virtual.resolvers.unit(unit, lowest)
      end
    end
  end
  return lowest
end

function dark_addon.environment.virtual.resolvers.tank(unit)
  return GetPartyAssignment('MAINTANK', unit) or GetPartyAssignment('MAINASSIST', unit) or UnitGroupRolesAssigned(unit) == 'TANK'
end

function dark_addon.environment.virtual.resolvers.tanks(assignment)
  local members = GetNumGroupMembers()
  local group_type = GroupType()
  if UnitExists('focus') and not UnitCanAttack('player', 'focus') and not UnitIsDeadOrGhost('focus') and assignment == 'MAINTANK' then
    return 'focus'
  end
  if group_type ~= 'solo' then
    for i = 1, (members - 1) do
      local unit = group_type .. i
      if (GetPartyAssignment(assignment, unit) or (assignment == 'MAINTANK' and UnitGroupRolesAssigned(unit) == 'TANK')) and not UnitCanAttack('player', unit) and not UnitIsDeadOrGhost(unit) then return unit end
    end
  end
  return 'player'
end

function dark_addon.environment.virtual.resolvers.solo()
  return 'player'
end

dark_addon.on_ready(function()
  C_Timer.NewTicker(0.1, function()
    for target, callback in pairs(dark_addon.environment.virtual.targets) do
      dark_addon.environment.virtual.resolved[target] = callback()
    end
  end)
end)
