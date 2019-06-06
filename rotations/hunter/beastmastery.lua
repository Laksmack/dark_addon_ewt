-- Beastmastery Hunter for 8.1 by ShasVa - 10/2018
-- Talents: 1 3 2 3 2 1 1
-- Holding Alt = Tar Trap
-- Holding Shift = Freezing Trap

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.hunter

local function combat()

  if target.alive and target.enemy then
	
	auto_shot()

	if toggle('interrupts') and castable(SB.CounterShot) and target.interrupt(50) then
		return cast(SB.CounterShot)
		end

	if modifier.shift and not modifier.alt and -spell(SB.FreezingTrap) == 0 then
      	return cast(SB.FreezingTrap, 'target')
    	end
		
	if modifier.alt and not modifier.shift and -spell(SB.TarTrap) == 0  then
      	return cast(SB.TarTrap, 'target')
    	end

	if pet.dead then
		return cast(SB.RevivePet)
		end

	if pet.alive and castable(SB.Misdirection) and -spell(SB.Misdirection) == 0 then
		return cast(SB.Misdirection, 'pet')
		end

	if pet.alive and castable(SB.Intimidation) and -spell(SB.Intimidation) == 0 then
		return cast(SB.Intimidation)
		end			
		
	if castable(SB.Exhilaration) and -spell(SB.Exhilaration) == 0 and player.health.percent <= 70 or pet.health.percent <= 20 then
		return cast(SB.Exhilaration)
		end
		
	if pet.health.percent <= 70 and -spell(SB.MendPet) == 0 then
		return cast(SB.MendPet)
		end
		
	if spell(SB.BarbedShot).charges == 2 then --and pet.buff(SB.Frenzy).remains <= 2 then
		return cast(SB.BarbedShot, 'target')
		end

	if -power.focus >= 70 and toggle('multitarget', false) then
        return cast (SB.MultiShot, 'target')
		end
		
	if castable(SB.AMurderOfCrows) and -spell(SB.AMurderOfCrows) == 0 then
		return cast(SB.AMurderOfCrows, 'target')
		end
		
	if castable(SB.AncestralCall) and -spell(SB.AncestralCall) == 0 then
		return cast(SB.AncestralCall)
		end	
		
	if castable(SB.AspectOfTheWild) and -spell(SB.AspectOfTheWild) == 0 then
		return cast(SB.AspectOfTheWild)
		end
		
	if castable(SB.BestialWrath) and -spell(SB.BestialWrath) == 0 then
		return cast(SB.BestialWrath)
		end

	if -power.focus >= 45 and -spell(SB.KillCommand) == 0 then
		return cast(SB.KillCommand, 'target')
		end
		
	if -power.focus <= 60 and -spell(SB.ChimaeraShot) == 0 then
		return cast(SB.ChimaeraShot, 'target')
		end
		
	if spell(SB.BarbedShot).charges >= 1 or -power.focus <= 60 then
		return cast(SB.BarbedShot, 'target')
		end
		
	if -power.focus >= 80 then
		return cast(SB.CobraShot, 'target')
		end
    end
end

local function resting()
    if not pet.exists then
		return cast(SB.CallPet1)
	end
end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.hunter.beastmastery,
  name = 'beastmastery',
  label = 'BM v2',
  combat = combat,
  resting = resting,
})