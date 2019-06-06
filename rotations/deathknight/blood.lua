local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.deathknight

local function combat()
  if target.alive and target.enemy and not player.channeling() then

 auto_attack()
 
-- Defensive CDs
    if -player.health < 40 then
      return cast(SB.IceboundFortitude, 'player')
    end
    if target.distance >= 8 and target.distance <= 30 and -spell(SB.BloodDrink) == 0 then 
      return cast(SB.BloodDrink)
    end
    if modifier.alt then
      return cast(SB.BoneStorm, 'player')
    end
--Get Aggro
    if not -target.debuff(SB.BloodPlague) then
      return cast(SB.BloodBoil, 'target')
    end
    if modifier.shift and -spell(SB.DeathAndDecay) == 0 then
      return cast(SB.DeathAndDecay, 'ground')
    end

--Interrupts
    if toggle('interrupts') and target.interrupt() and -spell(SB.MindFreeze) == 0 then
      return cast(SB.MindFreeze, 'target')
    end
    if toggle('interrupts') and target.interrupt() and -spell(SB.MindFreeze) > 1.5 and -spell(SB.ArcaneTorrent) == 0 then
      return cast(SB.ArcaneTorrent, 'target')
    end

--Continue do some damage and healing
    if buff(SB.BoneShield).count <= 7 and -spell(SB.Marrowrend) == 0 then
      return cast(SB.Marrowrend, 'target')
    end
    if spell(SB.BloodBoil).charges >= 1 then
      return cast(SB.BloodBoil, 'target')
    end
    if power.runicpower.actual >= 75 then
      return cast(SB.DeathStrike, 'target')
    end
    if power.runicpower.actual <= 75 and -spell(SB.HeartStrike) == 0 then
      return cast(SB.HeartStrike, 'target')
    end

    return cast(SB.HeartStrike, 'target')

  end
end

local function resting()
  local indoors = IsIndoors() 
  
  -- Put great stuff here to do when your out of combat
end

function interface()

end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.deathknight.blood,
  name = 'blood',
  label = 'Bundled Blood',
  combat = combat,
  resting = resting,
  interface = interface
})
