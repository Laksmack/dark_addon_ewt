-- Frost DK for 8.1 by Rotations - 8/2018
-- Talents: 2 1 2 2 1 1 2
-- Holding Alt =
-- Holding Shift =

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.deathknight

local function combat()

  if target.alive and target.enemy then
auto_attack()
-- Defensive CDs
--    if -player.health < 30 and not -buff(IceboundFortitude) then
--      return cast(SB.IceboundFortitude, 'player')
--    end

--Interrupt
    if toggle('interrupts') and target.interrupt() and -spell(SB.MindFreeze) == 0 then
      return cast(SB.MindFreeze, 'target')
    end

--Cooldowns
    if toggle('cooldowns') and -spell(SB.EmpowerRuneWeapon) == 0 then
      return cast(SB.EmpowerRuneWeapon, 'target')
    end
    if toggle('cooldowns') and -spell(SB.PillarOfFrost) == 0 then
      return cast(SB.PillarOfFrost, 'target')
    end
    if toggle('cooldowns') and -player.health < 40 and -spell(SB.DeathStrike) == 0 then
      return cast(SB.DeathStrike, 'target')
    end

--Apply Disease
    if (-buff(SB.DarkSuccor) and buff(SB.DarkSuccor).remains < 3) or -player.health < 50 then
      return cast(SB.DeathStrike, 'target')
    end
    if -spell(SB.RemorselessWinter) == 0 then
      return cast(SB.RemorselessWinter, 'target')
    end
    if -buff(SB.KillingMachine) and -spell(SB.Obliterate) == 0 then
      return cast(SB.Obliterate, 'target')
    end

    if -power.runicpower > 95 then
      return cast(SB.FrostStrike, 'target')
    end
    if -buff(SB.Rime) and -spell(SB.HowlingBlast) == 0 then
      return cast(SB.HowlingBlast, 'target')
    end
    if not -buff(SB.KillingMachine) and -power.runicpower > 75 then
      return cast(SB.FrostStrike, 'target')
    end
    if -spell(SB.Obliterate) == 0 then
      return cast(SB.Obliterate, 'target')
    end

  --  return cast(SB.FrostStrike, 'target')

  end
end

local function resting()
  -- Put great stuff here to do when your out of combat
end

function interface()

end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.deathknight.frost,
  name = 'frost',
  label = 'Bundled Frost',
  combat = combat,
  resting = resting,
  interface = interface
})
