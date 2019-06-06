-- Unholy DK for 8.1 by Rotations - 8/2018
-- Talents: 1 1 3 1 3 3 2
-- Holding Alt =
-- Holding Shift =

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.deathknight

local function combat()

  if target.alive and target.enemy then
auto_attack()
-- Defensive CDs
--    if -player.health < 40 and not -buff(IceboundFortitude) then
--      return cast(SB.IceboundFortitude, 'player')
--    end

--Procs
    if -buff(SB.SuddenDoom) then
      return cast(SB.DeathCoil, 'target')
    end
    if -buff(SB.DarkSuccor) then
      return cast(SB.DeathStrike, 'target')
    end

--and -power.runes > 2

--Apply Disease
    if not -target.debuff(SB.VirulentPlague) and -spell(SB.Outbreak) == 0 then
      return cast(SB.Outbreak, 'target')
    end
    if target.debuff(SB.FesteringWound).count < 2 and -spell(SB.FesteringStrike) == 0 then
      return cast(SB.FesteringStrike, 'target')
    end

--Interrupt
    if toggle('interrupts') and target.interrupt() and -spell(SB.MindFreeze) == 0 then
      return cast(SB.MindFreeze, 'target')
    end

--Cooldowns
    if toggle('cooldowns') and -spell(SB.ArmyOfTheDead) == 0 then
      return cast(SB.ArmyOfTheDead, 'target')
    end
    if toggle('cooldowns') and -spell(SB.DarkTransformation) == 0 then
      return cast(SB.DarkTransformation, 'target')
    end
    if toggle('cooldowns') and -spell(SB.UnholyFrenzy) == 0 then
      return cast(SB.UnholyFrenzy, 'target')
    end

--DPS rotation
    if -power.runicpower > 65  then
      return cast(SB.DeathCoil, 'target')
    end

    if modifier.shift then
      return cast(SB.Defile, 'ground')
    --  print(power.runicpower.actual)
    end
    if -buff(SB.SuddenDoom) then
      return cast(SB.DeathCoil, 'target')
    end

    if -target.health < 40 and  -spell(SB.SoulReaper) == 0 then
      return cast(SB.SoulReaper, 'target')
    end
    if target.debuff(SB.FesteringWound).count > 1 and -spell(SB.ScourgeStrike) == 0 then
      return cast(SB.ScourgeStrike, 'target')
    end

    if -spell(SB.FesteringStrike) == 0 and target.debuff(SB.FesteringWound).count < 2 then
      return cast(SB.FesteringStrike, 'target')
    end

    return cast(SB.FesteringStrike, 'target')

  end
end

local function resting()
  -- Put great stuff here to do when your out of combat
end

function interface()

end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.deathknight.unholy,
  name = 'unholy',
  label = 'Bundled Unholy',
  combat = combat,
  resting = resting,
  interface = interface
})
