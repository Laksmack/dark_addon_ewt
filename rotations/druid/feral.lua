-- Feral Druid for 8.0.1 by ShasVa - 10/2018
-- Talents: 2 3 1 1 1 3 1
-- Holding Alt = Swipe

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.druid

local function combat()

  if target.alive and target.enemy then
  
	auto_attack()
	
	-- Cat Form
	if castable(SB.CatForm, 'player') and not -buff(SB.CatForm) then
		return cast(SB.CatForm, 'player')
		end
		
	-- Go Stealth when in Cat Form
	if castable(SB.Prowl, 'player') and -buff(SB.CatForm, 'player') then
		return cast(SB.Prowl, 'player')
		end

	-- Interrupt
if castable(SB.SkullBash, 'target') and target.interrupt(100, false) and -spell(SB.SkullBash) == 0 then
      return cast(SB.SkullBash, 'target')
    end
    if castable(SB.MightyBash, 'target') and target.interrupt(100, false) and -spell(SB.MightyBash) == 0 and -spell(SB.SkullBash) >= 1 and talent(4,1) then
      return cast(SB.MightyBash, 'target')
    end
        if castable(SB.Hibernate, 'target') and target.interrupt(100, false) and -spell(SB.MightyBash) >= 1 and -spell(SB.SkullBash) >= 1  then
      return cast(SB.Hibernate, 'target')
    end
	
	-- Renewal at 70% health or lower
	if castable(SB.Renewal) and -spell(SB.Renewal) == 0 and player.health.percent <= 70 then
		return cast(SB.Renewal)
		end
		
	-- Regrowth on Predatory Swiftness proc
	if castable(SB.Regrowth) and -buff(SB.PredatorySwiftness, 'player') and player.health.percent <= 80 then
		return cast(SB.Regrowth, 'player')
		end
		
	-- Survival Instincts defensive
	if castable(SB.SurvivalInstincts) and -spell(SB.SurvivalInstincts) == 0 and player.health.percent <= 50 then
		return cast(SB.SurvivalInstincts)
		end

	-- Swipe for AoE
	if modifier.alt and -spell(SB.SwipeCat) == 0 then
      	return cast(SB.SwipeCat)
    	end
		
	-- Tiger's Fury cooldown
	if castable(SB.TigersFury) and -power.energy <= 50 and -spell(SB.TigersFury) == 0 then
		return cast(SB.TigersFury)
		end
		
	-- Berserk cooldown
	if castable(SB.Berserk) and -spell(SB.Berserk) == 0 then
		return cast(SB.Berserk)
		end
		
	-- Savage Roar upkeep
    if buff(SB.SavageRoar).remains <= 10 and -power.combopoints == 5 and -power.energy >= 40 then
		return cast(SB.SavageRoar)
		end	
	
	-- Rip upkeep
	if castable(SB.Rip) and -power.combopoints == 5 and -power.energy >= 40 and target.debuff(SB.Rip).remains <= 2 then
		return cast(SB.Rip)
		end
		
	-- Rake upkeep
	if castable(SB.Rake) and -power.combopoints <= 4 and -power.energy >= 55 and target.debuff(SB.RakeDebuff).remains <= 2 then
		return cast(SB.Rake)
		end
		
	-- Thrash upkeep
	if castable(SB.ThrashCat) and -power.combopoints <= 4 and -power.energy >= 60 and target.debuff(SB.ThrashCat).remains <= 2 then
		return cast(SB.ThrashCat)
		end
		
	-- Ferocious Bite
	if castable(SB.FerociousBite) and -power.combopoints == 5 and -power.energy >= 65 then
		return cast(SB.FerociousBite)
		end
		
	-- Shred with Clearcasting
	if castable(SB.Shred) and -buff(SB.ClearcastingF, 'player') then
		return cast(SB.Shred)
		end
		
	-- Moonfire if Lunar Inspiration talent is chosen
	if castable(SB.Moonfire) and -buff(SB.CatForm, 'player') and -power.energy == 30 then
		return cast(SB.Moonfire)
		end
		
	-- Shred
	if castable(SB.Shred) and -power.combopoints <= 4 and -power.energy >= 60 then
		return cast(SB.Shred)
		end
    end
end

local function resting()
-- Prowl out of combat when in Cat Form
	if castable(SB.Prowl, 'player') and -buff(SB.CatForm, 'player') then
		return cast(SB.Prowl, 'player')
	end
end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.druid.feral,
  name = 'feral',
  label = 'Feral',
  combat = combat,
  resting = resting,
})