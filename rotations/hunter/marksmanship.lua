-- Marksmanship Hunter by Rotations - 3/2019
-- Talents: 1 1 2 3 2 3 2
-- Holding Alt = 
-- Holding Shift = 

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.hunter
function GroupType()
    return IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
end
local function combat()

  -- Lets read what the settings page says right now before we evaluate anything
     
    local spellcasting, _, _, _, endTimeloc = UnitCastingInfo("player")
    local multinumber = dark_addon.settings.fetch('dr_marksmanship_multi')
    local intpercent = dark_addon.settings.fetch('dr_marksmanship_spinner')
    local usehealthstone = dark_addon.settings.fetch('dr_marksmanship_healthstone.check')
    local usehealthpots = dark_addon.settings.fetch('dr_marksmanship_healthpots.check')
    local healthpotspercent = dark_addon.settings.fetch('dr_marksmanship_healthpots.spin')
    local healthstonepercent = dark_addon.settings.fetch('dr_marksmanship_healthstone.spin')
    local callpet = dark_addon.settings.fetch('dr_marksmanship_callpet')
    local heavymove = dark_addon.settings.fetch('dr_marksmanship_heavymovement')
    local nameplates = dark_addon.settings.fetch('dr_marksmanship_usenameplates')
    local maxfocusmin = dark_addon.settings.fetch('dr_marksmanship_maxfocus')
    local group_type = GroupType()

  if target.alive and target.enemy and not player.channeling() then
    local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Arcane Shot', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
    end
    dark_addon.interface.status_extra('GT: ' .. group_type .. '  R:' .. dark_addon.version ..  '      T#:' .. inRange .. ' |cff5BFF33   D:|r ' .. target.distance)

  local Trinket13 = GetInventoryItemID("player", 13)
  local Trinket14 = GetInventoryItemID("player", 14)
  local Neck2 = GetInventoryItemID("player", 2)

  if nameplates == true and seeplates == '0' then
     SetCVar("nameplateShowEnemies",1)
  end

  if nameplates == false and seeplates == '1' then
     SetCVar("nameplateShowEnemies",0)
  end


  if -spell(SB.RapidFire) == 0 and spell(SB.AimedShot).charges > 0 and toggle('cooldowns', false) and -spell(SB.Trueshot) == 0 then
    return cast(SB.Trueshot, 'target')
  end

  if -buff(SB.LockAndLoad) then
    return cast(SB.AimedShot, 'target')
  end

  if toggle('misdirect', false) and -spell(SB.Misdirection) == 0 and not group_type == solo then
    return cast(SB.Misdirection, 'tank')
  end

  if toggle('multitarget', false) and inRange >= multinumber and -spell(SB.MultiShot) == 0 and -power.focus >= 40 then
    return cast(SB.MultiShot, 'target')   
  end

  if Trinket13 == 159614 and GetItemCooldown(159614) == 0 and toggle('cooldowns', false) then
      macro('/use 13')
  end

  if  target.debuff(SB.HuntersMarkMM).down and not player.spell(SB.HuntersMarkMM).lastcast then
    return cast(SB.HuntersMarkMM, 'target')
  end

  if -spell(SB.RapidFire) == 0 then
    return cast(SB.RapidFire, 'target')
  end

  if target.interrupt(intpercent, false) and toggle('interrupts', false) and -spell(SB.CounterShot) == 0 then 
    return cast(SB.CounterShot, 'target')
  end
 -- CD's 
  if toggle('cooldowns', false) and -spell(SB.AMurderOfCrowsMM) == 0 and talent(1,3) then
    return cast(SB.AMurderOfCrowsMM, 'target')
  end

  if toggle('cooldowns', false) and talent(6,3) and -spell(SB.DoubleTap) == 0 then
    return cast(SB.DoubleTap)
  end

  if toggle('cooldowns', false) and -spell(SB.Trueshot) == 0 and target.health.percent >= 80 then
    return cast(SB.Trueshot)
  end

  if toggle('cooldowns', false) and -spell(SB.Trueshot) == 0 and target.health.percent <= 20 then
    return cast(SB.Trueshot)
  end

  if -buff(SB.DoubleTap) and talent(2,1) and not -buff(SB.PreciseShots) and not player.moving then
    return cast(SB.AimedShot, 'target')
  end

  if -buff(SB.DoubleTap) and not talent(2,1) and not -buff(SB.PreciseShots) then
    return cast(SB.RapidFire, 'target')
  end

  if spell(SB.AimedShot).charges > 0 and not -buff(SB.PreciseShots) and not player.moving   then 
    return cast(SB.AimedShot, 'target')
   end

  if -buff(SB.PreciseShots) and -spell(SB.ArcaneShot) == 0 and -power.focus >= 15 then
    return cast(SB.ArcaneShot)
  end

	if modifier.shift and not modifier.alt and -spell(SB.FreezingTrap) == 0 then
    return cast(SB.FreezingTrap, 'ground')
  end

	if modifier.alt and not modifier.shift and -spell(SB.ExplosiveTrap) == 0  then
    return cast(SB.ExplosiveTrap, 'ground')
  end

  if modifier.alt and modifier.shift then
	  return cast(SB.Disengage)
	 end

	if -buff(SB.LethalShots) and -spell(SB.RapidFire) == 0  then
		return cast(SB.RapidFire, 'target')
	 end

  if spell(SB.AimedShot).charges > 1 and not player.moving  then 
	  return cast(SB.AimedShot, 'target')
	 end

  if -power.focus >= maxfocusmin then
    return cast(SB.ArcaneShot, 'target')
  end

  if GetItemCooldown(5512) == 0 and player.health.percent < healthstonepercent and usehealthstone == true then
      macro('/use Healthstone')
  end
		 	
  if GetItemCooldown(152494) == 0 and player.health.percent < healthpotspercent and usehealthpots == true and GetItemCooldown(5512) >= 1  then
      macro('/use Coastal Healing Potion')
  end	
  
  if toggle('multitarget', false) and inRange >= multinumber and -spell(SB.MultiShot) == 0 then
    return cast(SB.MultiShot, 'target') 	
  end
    	
 -- Filler Spell

    return cast(SB.SteadyShots, 'target')
    end
end

local function resting()
    local spellcasting, _, _, _, endTimeloc = UnitCastingInfo("player")
    local multinumber = dark_addon.settings.fetch('dr_marksmanship_multi')
    local intpercent = dark_addon.settings.fetch('dr_marksmanship_spinner')
    local usehealthstone = dark_addon.settings.fetch('dr_marksmanship_healthstone.check')
    local usehealthpots = dark_addon.settings.fetch('dr_marksmanship_healthpots.check')
    local healthpotspercent = dark_addon.settings.fetch('dr_marksmanship_healthpots.spin')
    local healthstonepercent = dark_addon.settings.fetch('dr_marksmanship_healthstone.spin')
    local callpet = dark_addon.settings.fetch('dr_marksmanship_callpet')
    local heavymove = dark_addon.settings.fetch('dr_marksmanship_heavymovement')
    local nameplates = dark_addon.settings.fetch('dr_marksmanship_usenameplates')
    local maxfocusmin = dark_addon.settings.fetch('dr_marksmanship_maxfocus')
    local group_type = GroupType()

    local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Ebonbolt', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
    end
   dark_addon.interface.status_extra('GT: ' .. group_type .. '  R:' .. dark_addon.version ..  '      T#:' .. inRange .. ' |cff5BFF33   D:|r ' .. target.distance)
end
  if nameplates == true and seeplates == '0' then
     SetCVar("nameplateShowEnemies",1)
  end

  if nameplates == false and seeplates == '1' then
     SetCVar("nameplateShowEnemies",0)
  end

function gcd()
end

function interface()
local marksmanship = {
    key = 'dr_marksmanship',
    title = 'DarkRotations - Marksmanship Hunter',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Marksmanship Hunter Settings', align= 'center' },
      { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine.' },
      { type = 'rule' },   
      { type = 'text', text = 'General Settings' },
      { key = 'callpet', type = 'checkbox', text = 'Call Pet', desc = 'Always call Pet when alive ' },
      { key = 'usenameplates', type = 'checkbox', text = 'Show Enemy Nameplates', desc = 'Use name plates to count baddies' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Auto use Healthstone at health %', min = 5, max = 100, step = 5 },
      { key = 'healthpots', type = 'checkspin', text = 'Healthpots', desc = 'Auto use Healthpots at health % (after using Healthstone', min = 5, max = 100, step = 5 },
      { key = 'multi', type = 'spinner', text = 'MultiTarget', desc = 'Number of enemies to use AOE', min = 1, max = 20, step = 1 },
      { key = 'maxfocus', type = 'spinner', text = 'Max Focus', desc = 'What % focus to keep (suggested is 46)', min = 1, max = 100, step = 1 },
      -- { key = 'input', type = 'input', text = 'TextBox', desc = 'Description of Textbox' },
      { key = 'spinner', type = 'spinner', text = 'Interrupt %', desc = 'What % you will be interupting at', min = 5, max = 100, step = 5 },
      { type = 'rule' },   
      { type = 'text', text = 'PVP Options' },
      { type = 'rule' },   
      { type = 'text', text = 'Raid / M+ / Party Options' },
      { key = 'heavymovement', type = 'checkbox', text = 'Heavy movement fight', desc = 'Rotation will be based on heavy movement' },
    }
  }

  configWindow = dark_addon.interface.builder.buildGUI(marksmanship)

  dark_addon.interface.buttons.add_toggle({
     name = 'misdirect',
    label = 'Misdirect the Baddy',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('cube'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('cube'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
    dark_addon.interface.buttons.add_toggle({
    name = 'settings',
    label = 'Rotation Settings',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('cog'),
      color = dark_addon.interface.color.cyan,
      color2 = dark_addon.interface.color.dark_blue
    },
    off = {
      label = dark_addon.interface.icon('cog'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    },
    callback = function(self)
      if configWindow.parent:IsShown() then
        configWindow.parent:Hide()
      else
        configWindow.parent:Show()
      end

    end
  })
end
dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.hunter.marksmanship,
  name = 'marksmanship',
  label = 'MM by Rotations',
  combat = combat,
  gcd = gcd,
  GroupType = GroupType,
  resting = resting,
  interface = interface
})




