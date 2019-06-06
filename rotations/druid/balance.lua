-- Balance Druid for 8.1.5 by Rotations
-- Talents: 2000231
-- Holding Alt = Typhoon if talented
-- Holding Alt = Might MassEntanglement at Your Mouse if talented
-- Holding Shift = Starfall at the mouse

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.druid

--Spells not in spellbook
SB.StellarDrift = 163222
SB.TigerDashBuff = 252216
SB.Starlord = 279709
SB.CelestialAlignment = 194223
SB.Berserking = 26297
SB.DawningSun = 276152
SB.Sunblaze = 274399
SB.IncarnationBalance = 102560
SB.FuryofElune = 202770
---
SB.StellarFlare = 202347
SB.Rebirth = 20484
SB.RejuvenationGermination = 155777
SB.ForceofNature = 205636
SB.ArcanicPulsar = 287790


function GroupType()
    return IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
end

local function combat()

   if target.alive and target.enemy and not player.channeling() then --and not toggle('multitarget', false) then
    local group_type = GroupType()
    local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Sunfire', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
    end
   dark_addon.interface.status_extra('GroupType:' .. group_type .. '  R:' .. dark_addon.version ..  '      T#:' .. inRange .. ' |cff5BFF33   D:|r ' .. target.distance)

    if spell(SB.StellarFlare).current and  -target.debuff(SB.StellarFlare) then
      stopcast()
    end

    if spell(SB.LunarStrike).current and not -buff(SB.LunarEmpowerment) then
      stopcast()
    end

    if toggle('healme', false) and player.health.percent <= 60 and -spell(SB.Renewal) == 0 then
      return cast(SB.Renewal)
    end

    if modifier.shift and power.astral.actual >= 50 then
      return cast(SB.Starfall, 'ground')
    end

    if talent(1,3) and -spell(SB.ForceofNature) == 0 and toggle('cooldowns', false) then 
      return cast(SB.ForceofNature)
    end
    
    if talent(4,3) and -spell(SB.Typhoon) == 0 and modifier.alt and target.distance <= 20 then
      return cast(SB.Typhoon, 'target')
    end

    if target.interrupt(70, false) and toggle('interrupts', false) and talent(4,1) and -spell(SB.MightyBash) == 0 and target.distance <= 10 then
      return cast(SB.MightyBash, 'target')
    end

    if talent(4,2) and -spell(SB.MassEntanglement) == 0 and modifier.alt  then
      return cast(SB.MassEntanglement, 'ground')
    end

    if toggle('cooldowns', false) and power.astral.actual >= 40 and -spell(SB.CelestialAlignment) == 0 then
      return cast(SB.CelestialAlignment)
    end

    if toggle('cooldowns', false) and -spell(SB.WarriorOfElune) == 0 and not -player.buff(SB.WarriorOfElune) and power.astral.actual <= 30  then
      return cast(SB.WarriorOfElune)
    end

    if -player.buff(SB.WarriorOfElune) then
      return cast(SB.LunarStrike, 'target')
    end

    if not -target.debuff(SB.SunfireDebuff) and not player.spell(SB.Sunfire).lastcast then
      return cast(SB.Sunfire, 'target')
    end

    if not -target.debuff(SB.MoonfireDebuff) and not player.spell(SB.Moonfire).lastcast then
      return cast(SB.Moonfire, 'target')
    end

    if not -target.debuff(SB.StellarFlare) and power.astral.actual >= 10 and talent(6,3) and not player.spell(SB.StellarFlare).lastcast and not player.moving then
      return cast(SB.StellarFlare, 'target')
    end

    if not modifier.shift and power.astral.actual >= 60 then
      return cast(SB.Starsurge, 'target')
    end

    if buff(SB.SolarEmpowerment).count >= 2 and not player.moving then
      return cast(SB.SolarWrath, 'target')
    end

    if -player.buff(SB.LunarEmpowerment) and not player.spell(SB.LunarStrike).lastcast and not player.moving then
      return cast(SB.LunarStrike, 'target')
    end

    if -player.buff(SB.SolarEmpowerment) and not player.spell(SB.SolarWrath).lastcast and not player.moving then
      return cast(SB.SolarWrath, 'target')
    end

    if not modifier.shift and power.astral.actual >= 40 then
      return cast(SB.Starsurge, 'target')
    end

    if inRange >= 2 and not player.moving then 
      return cast(SB.LunarStrike, 'target')
    end

    if not player.moving then 
      return cast(SB.SolarWrath, 'target')
    end

    if player.moving then 
      return cast(SB.Sunfire, 'target')
    end

end
end

local function interface()
  local balance = {
    key = 'dr_balance',
    title = 'DarkRotations - Balance Druid',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Balance Druid  Settings', align= 'center' },
      { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine.' },
      { type = 'rule' },   
      { type = 'text', text = 'General Settings' },
     -- { key = 'callpet', type = 'checkbox', text = 'Call Pet', desc = 'Always call Water Elemental ' },
      { key = 'usenameplates', type = 'checkbox', text = 'Show Enemy Nameplates', desc = 'Use name plates to count baddies' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Auto use Healthstone at health %', min = 5, max = 100, step = 5 },
      { key = 'multi', type = 'spinner', text = 'MultiTarget', desc = 'Number of enemies to use AOE', min = 1, max = 20, step = 1 },
      -- { key = 'input', type = 'input', text = 'TextBox', desc = 'Description of Textbox' },
      { key = 'spinner', type = 'spinner', text = 'Interrupt %', desc = 'What % you will be interupting at', min = 5, max = 100, step = 5 },
      { type = 'rule' },   
      { type = 'text', text = 'PVP Options' },
     -- { key = 'usepolymorph', type = 'checkbox', text = 'Polymorph', desc = 'Polymorph your target if possible' },
    --  { key = 'usefrostnova', type = 'checkbox', text = 'Frost Nova', desc = 'Auto use Frost Nova if target is near' },
    --  { key = 'usespellsteal', type = 'checkbox', text = 'Spell Steal', desc = 'Use Spell Steal when possible' },
      { type = 'rule' },   
      { type = 'text', text = 'Raid / M+ / Party Options' },
      { key = 'heavymovement', type = 'checkbox', text = 'Heavy movement fight', desc = 'Rotation will be based on heavy movement' },
    }
  }

  configWindow = dark_addon.interface.builder.buildGUI(balance)


  dark_addon.interface.buttons.add_toggle({
     name = 'sounds',
    label = 'Use Sounds to Emphasize Cooldowns',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('music'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('music'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
    dark_addon.interface.buttons.add_toggle({
     name = 'healme',
    label = 'Use Healing on Myself (non raid)',
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
     name = 'autoform',
    label = 'Automatic Play Form Change',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('cube'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('smile'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
    dark_addon.interface.buttons.add_toggle({
     name = 'pvpdrinks',
    label = 'Use Third Wind Potions in BGs',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('smile'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('smile'),
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

local function resting()
  local flying = IsFlying()
  local indoors = IsIndoors()
  --print (indoors)

  if toggle('autoform', false) and player.moving and not -buff(SB.TravelForm) and indoors == false then
    return cast(SB.TravelForm)
  end

  if  toggle('autoform', false) and not player.moving and not -buff(SB.MoonkinForm) and flying == false then
    return cast(SB.MoonkinForm)
  end
 -- print (toggle('multitarget', false))
  if GetShapeshiftForm() == 3 then return end
end

--dark_addon.environment.hook(your_func)
dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.druid.balance,
  name = 'balance',
  label = 'Bundled Balance',
  interface = interface,
  combat = combat,
  resting = resting
})
