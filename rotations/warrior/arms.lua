-- Arms Warrior for 8.1 by Rotations - 8/2018
-- Talents: 3 3 1 3 2 1 1
-- Holding Alt = 
-- Holding Shift = 


local addon, dark_rotation = ...
local SB = dark_rotation.rotation.spellbooks.warrior

local function combat()
  if target.alive and target.enemy then


  	if toggle('cooldowns', false) and -spell(SB.BerserkerRage) == 0 then
  		return cast(SB.BerserkerRage)
  	end

  	if -power.rage < 60 and -spell(SB.Skullsplitter) == 0 then
  		return cast(SB.Skullsplitter)
  	end

  	if toggle('multitarget', false) and -spell(SB.SweepingStrikes) == 0 then
  		return cast(SB.SweepingStrikes)
  	end

  	if -spell(SB.Warbreaker) == 0 then
  		return cast(SB.Warbreaker)
  	end

  	if -player.buff(SB.SuddenDeath) then
        return cast(SB.Execute)
    end

    if -player.buff(SB.Overpower) and -spell(SB.MortalStrike) == 0 then
    	return cast(SB.MortalStrike)
    end

    if not -target.debuff(SB.DeepWoundsDebuff) and -spell(SB.MortalStrike) == 0 then
    	return cast(SB.MortalStrike)
    end

    if -target.debuff(SB.ColossusSmashDebuff) and -spell(SB.BladestormArms) == 0 then

    	return cast(SB.BladestormArms)
    end

    if -spell(SB.ColossusSmash) == 0 then
    	return cast(SB.ColossusSmash)
    end

    if -spell(SB.Overpower) == 0 then
    	return cast(SB.Overpower)
    end

    if -target.health < 35  then
    	return cast(SB.Execute)
    end

    if -power.rage < 10 then 
    	return cast(SB.StormBolt)
    end
    -- Use this area to print variables for testing
   -- print (-target.debuff(SB.ColossusSmashDebuff))
   -- print (-spell(SB.BladestormArms))
    return cast(SB.Slam) -- Filler spell, last spell in the rotation
   
  end
end

local function resting()
-- put cool stuff here when out of combat
 end

dark_rotation.rotation.register({
  spec = dark_rotation.rotation.classes.warrior.arms,
  name = 'arms',
  label = 'Basic  Arms',
  combat = combat,
  resting = resting,
})
