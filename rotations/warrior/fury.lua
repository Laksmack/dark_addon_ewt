-- Fury Warrior for 8.1 by Rotations - 8/2018
-- Talents: 1 1 2 2 1 3 1
-- Holding Alt = 
-- Holding Shift = 


local addon, dark_rotation = ...
local SB = dark_rotation.rotation.spellbooks.warrior

local function combat()
  if target.alive and target.enemy then

  	if -player.buff(SB.SuddenDeath) and -spell(SB.ExecuteFury) == 0 then 
  		return cast(SB.Execute)
  	end
  	
  	if toggle('cooldowns', false) and -spell(SB.BerserkerRage) == 0 then
  		--print '1'
  		return cast(SB.BerserkerRage)
  	end

  	if -power.rage > 75 and -spell(SB.Rampage) == 0 then
  		--print '2'
  		return cast(SB.Rampage)
  	end

  	if toggle('cooldowns', false) and -spell(SB.Recklessness) == 0 then
  		--print '3'
  		return cast(SB.Recklessness)
  	end

  	if -target.health < 25 and -spell(SB.Execute) == 0 then
  		--print '4'
  		return cast(SB.Execute)
  	end

  	if not -player.buff(SB.Enrage) and -spell(SB.BloodThirst) == 0 then
  		--print '5'
  		return cast(SB.BloodThirst)
  	end

  	if spell(SB.RagingBlow).charges > 1 then 
  	--	print '6'
  		return cast(SB.RagingBlow)
  	end

  	if -player.buff(SB.Enrage) and -spell(SB.Bladestorm) == 0 then
  	--	print '7'
  		return cast(SB.Bladestorm)
  	end

  	if -power.rage < 20 and spell(SB.RagingBlow).charges > 0 then
  		--print '8'
  		return cast(SB.RagingBlow)
  	end
  		--print 'end'
  	return cast(SB.WhirlWind)

    -- Use this area to print variables for testing
   -- print (-target.debuff(SB.ColossusSmashDebuff))
   -- print (-spell(SB.BladestormArms))
    
  end
end

local function resting()
-- put cool stuff here when out of combat
 end

dark_rotation.rotation.register({
  spec = dark_rotation.rotation.classes.warrior.fury,
  name = 'fury',
  label = 'Basic  fury',
  combat = combat,
  resting = resting,
})
