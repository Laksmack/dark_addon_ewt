-- Protection Paladin for 8.1 by Rotations - 8/2018
-- Talents: 2 3 1 2 3 2 1
-- Holding Alt = Shield of Righteous
-- Holding Shift = Hammer of Justice

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.paladin

local function combat()




  if not target.alive or not target.enemy then return end

  auto_attack()

  if -buff(SB.AvengingWrath) and spell(SB.ShieldoftheRighteous).charges > 1 then
    return cast(SB.ShieldoftheRighteous, 'player')
  end
  if toggle('interrupts', false) and target.interrupt() and -spell(SB.Rebuke) == 0 then
    return cast(SB.Rebuke, 'target')
  end

  if spell(SB.ShieldoftheRighteous).charges == 0 and toggle('cooldowns', false) and -spell(SB.BastionofLight) == 0 then
    return cast(SB.BastionofLight, 'target')
  end

  if modifier.shift and -spell(SB.HammerofJustice) == 0 then
    return cast(SB.HammerofJustice, 'target')
  end
  if spell(SB.ShieldoftheRighteous).charges > 1 then
    return cast(SB.ShieldoftheRighteous, 'target')
  end

  if modifier.alt and -spell(SB.ShieldoftheRighteous) == 0  then
    return cast(SB.ShieldoftheRighteous, 'target')
  end

  -- Ok Lets start healing ourselves because we are taking a beating..
  if -player.health < 90  and -spell(SB.HandoftheProtector) == 0 then
    return cast(SB.HandoftheProtector, 'player')
  end

  if -player.health < 30  and -spell(SB.ArdentDefender) == 0 then
    return cast(SB.ArdentDefender, 'player')
  end

  if -player.health < 30  and -spell(SB.ArdentDefender) > 0 and -spell(SB.GuardianofAncientKings) == 0 then
    return cast(SB.GuardianofAncientKings, 'player')
  end

  -- Ok Lets do some cooldowns
  if toggle('cooldowns', false) and -spell(SB.AvengingWrath) == 0 then
    return cast(SB.AvengingWrath, 'player')
  end

  -- Rotation standard
  if -spell(SB.Judgment) == 0 then
    return cast(SB.Judgment)
  end

  if -spell(SB.AvengersShield) == 0 then
    return cast(SB.AvengersShield)
  end

  if -spell(SB.ConsecrationProt) == 0 then
    return cast(SB.ConsecrationProt)
  end

  if -spell(SB.HammerOfTheRighteous) == 0 then
    return cast(SB.HammerOfTheRighteous)
  end
end

local function resting()
  local incomingheal = UnitGetIncomingHeals("target") or 0
  local heal = UnitGetIncomingHeals("player") or 0

  if heal > 0 then
    print (heal .. '  Incoming Heal on you... ')
   
  end
  

  -- Put great stuff here to do when your out of combat
end

function interface()
end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.paladin.protection,
  name = 'protection',
  label = 'Bundled Protection',
  combat = combat,
  resting = resting,
  interface = interface
})
