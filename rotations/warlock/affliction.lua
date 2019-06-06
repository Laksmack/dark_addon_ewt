-- Affliction Warlock for 8.1 by Rotations - 10/2018
-- Talents: Any
-- Holding Alt = Drain Life
-- Holding Shift = 
-- Multitarget will cause Seed of Corruption on current target


local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.warlock

local function combat()
  if target.alive and target.enemy and not player.channeling() then

    if player.spell(SB.SummonDarkglare).lastcast and -spell(SB.DarksoulMisery) == 0 and talent (7,3) then
      return cast(SB.DarksoulMisery)
    end
    if player.spell(SB.UnstableAffliction).lastcast and -spell(SB.DeathBolt) == 0 and talent(1,3) then
      return cast(SB.DeathBolt)
    end
    --if GetItemCooldown(159615) == 0 and player.power.soulshards.actual == 0 then
   --    macro('/use 13') 
   -- end
    -- Keybinds
    if modifier.alt then
      return cast(SB.DrainLife, 'target')
    end
    if modifier.shift then
      return cast(SB.Fear, 'target')
    end






    -- Lets maintain our dots on our target
    if not target.debuff(SB.CorruptionDebuff) or target.debuff(SB.CorruptionDebuff).remains <= 4.2 then
      return cast(SB.Corruption, 'target')
    end
    if not target.debuff(SB.Agony) or target.debuff(SB.Agony).remains <= 5.4 then
      return cast(SB.Agony, 'target')
    end
    if not target.debuff(SB.SiphonLife) or target.debuff(SB.SiphonLife).remains <= 4.5 and talent(2,3) then
      return cast(SB.SiphonLife)
    end
    if toggle('multitarget', false) and not target.debuff(SB.SeedOfCorruption) then
      return cast(SB.SeedOfCorruption, 'target')
    end
    -- Lets get into some CD's
    if -target.debuff(SB.CorruptionDebuff) and -target.debuff(SB.Agony) and player.power.soulshards.actual == 0 and -target.debuff(SB.UAdebuffTwo) and toggle('cooldowns', false) and -spell(SB.SummonDarkglare) == 0 and (-target.debuff(SB.SiphonLife) or not talent(2,3)) then
      return cast(SB.SummonDarkglare)
    end
    if player.power.soulshards.actual == 5 then
      return cast(SB.UnstableAffliction, 'target')
    end
    if talent(6,2) and -spell(SB.Haunt) == 0 then
      return cast(SB.Haunt)
    end
    if talent(4,2) and -spell(SB.PhantonSing) == 0 then
      return cast(SB.PhantonSing)
    end
    if talent(4,3) and -spell(SB.VileTaint) == 0 then
      return cast(SB.VileTaint)
    end
    if player.power.soulshards.actual > 0 then
      return cast(SB.UnstableAffliction, 'target')
    end
    if talent(1,2) then 
      return cast(SB.DrainSoul)
    end
    if not player.channeling() and not talent(1,2) then
      return cast(SB.ShadowBolt) 
    end


  end
end

local function resting() end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.warlock.affliction,
  name = 'affliction',
  label = 'Bundled Affliction by Rotations',
  combat = combat,
  resting = resting,
  -- interface = interface
})
