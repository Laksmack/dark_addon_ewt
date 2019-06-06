-- Firemage for 8.1 by Rotations - 5/2019
-- Recomend Talents: 2 2 1 3 2 2 1
-- Holding Alt = DragonsBreath
-- Holding Shift = FlameStrike
-- Holding Control = FrostNova

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.mage
local cccount = 1
local function combat()
if target.alive and target.enemy and player.alive and not -target.debuff(SB.Polymorph)  then

    local spellcasting, _, _, _, endTimeloc = UnitCastingInfo("player")
    local intpercent = dark_addon.settings.fetch('dr_example_spinner', 45)
    local usehealthstone = dark_addon.settings.fetch('dr_example_healthstone.check', true)
    local healthstonepercent = dark_addon.settings.fetch('dr_example_healthstone.spin', 35)
    local usepoly = dark_addon.settings.fetch('dr_example_usepolymorph', false)
    local arenahackson = dark_addon.settings.fetch('dr_example_arenahacks', true)
    local usefrostnova = dark_addon.settings.fetch('dr_example_usefrostnova', false)
    local heavymove = dark_addon.settings.fetch('dr_example_heavymovement', false)
    local usespellsteal = dark_addon.settings.fetch('dr_example_usespellsteal', true)
    local nameplates = dark_addon.settings.fetch('dr_example_usenameplates', true)
    local critChance = GetCritChance()
    local group_type = GroupType()
    local affectingCombat = UnitAffectingCombat("player");

   if modifier.control and not -target.debuff(SB.FrostNova) and spell(SB.FrostNova).charges >= 1 then
      return cast(SB.FrostNova)
    end

   if modifier.alt and -spell(SB.DragonsBreath) == 0 then
      return cast(SB.DragonsBreath, 'target')
    end

   if not -arena1.debuff(SB.Polymorph) and arena1.distance <= 29 and toggle('arenaone', false) then
      return cast(SB.Polymorph, "arena1")
    end

   if not -arena2.debuff(SB.Polymorph) and arena2.distance <= 29 and toggle('arenatwo', false) then
      return cast(SB.Polymorph, "arena2")
    end

   if not HasFullControl() and -spell(SB.GladMed) == 0 then
      return cast(SB.GladMed, 'player')
    end

   if spell(SB.Polymorph).current and  -target.debuff(SB.Polymorph)  then
      stopcast()
    end

   if spell(SB.Fireball).current and  -buff(SB.HotStreak) then
      stopcast()
    end

   if spell(SB.Scorch).current and -buff(SB.HotStreak) and not player.moving then
      stopcast()
    end

   if spell(SB.Pyroblast).current and not -buff(SB.HotStreak) then
      stopcast()
    end

   if mouseover.alive and mouseover.enemy and mouseover.distance <= 30 and toggle('autopoly', false) and not -target.debuff(SB.Polymorph) and not modifier.shift then
      return cast(SB.Polymorph, 'mouseover')
    end

   if -spell(SB.Meteor) == 0 and talent(7,3) then
      return cast(SB.Meteor, 'ground')
    end

   if modifier.shift and -spell(SB.Flamestrike) == 0  then
     return cast(SB.Flamestrike, 'ground')
    end

    if -buff(SB.HotStreak) and not modifier.shift then
      return cast(SB.Pyroblast, 'target')
    end

    if target.distance <= 8 and target.interrupt(intpercent, false) and -spell(SB.ArcaneTorrent) == 0 and -spell(SB.Counterspell) >= 1 and castable(SB.ArcaneTorrent) then
      return cast(SB.ArcaneTorrent)
    end

  local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Fireball', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
        inRange = inRange + 1
      end
    end
   dark_addon.interface.status_extra('CC#' .. cccount .. '  R:' .. dark_addon.version .. '   Targets#:' .. inRange .. ' |cff5BFF33 Distance:|r ' .. target.distance)

    if arena1.interrupt(100, false) and toggle('interrupts', false) and arena1.interrupt(intpercent, false) and arenahackson == true and arena1.distance <= 40 and -spell(SB.Counterspell) == 0 then
     print 'Arena one counterspell'
      return cast(SB.Counterspell, "arena1")
    end
   
    if arena2.interrupt(100, false) and toggle('interrupts', false) and arena2.interrupt(intpercent, false) and arenahackson == true and arena2.distance <= 40 and -spell(SB.Counterspell) == 0 then
     print 'Arena two counterspell'
      return cast(SB.Counterspell, "arena2")
    end

    if castable(SB.Counterspell, 'target') and target.interrupt(intpercent, false) and toggle('interrupts', false) and -spell(SB.Counterspell) == 0 and target.distance <= 40 then
      return cast(SB.Counterspell, 'target')
    end

    if arena1.has_stealable and toggle('spellstealpvp', false) and castable(SB.SpellSteal, 'arena1') and player.power.mana.percent >= 50 and arena1.distance <= 40 and arenahackson == true and -spell(SB.SpellSteal) == 0 then
      print 'Stole Arena1 Spells'
      return cast(SB.SpellSteal, 'arena1')
    end

    if arena2.has_stealable and toggle('spellstealpvp', false) and castable(SB.SpellSteal, 'arena2') and player.power.mana.percent >= 50 and arena2.distance <= 40 and arenahackson == true and -spell(SB.SpellSteal) == 0  then
      print 'Stole Arena2'
      return cast(SB.SpellSteal, "arena2")
    end

    if target.has_stealable and toggle('spellstealpvp', false) and castable(SB.SpellSteal, 'target') and player.power.mana.percent >= 50 and not HasFullControl() and target.distance <= 40 and -spell(SB.SpellSteal) == 0  then
      print 'Stole Target Spell'
      return cast(SB.SpellSteal, 'target')
    end

	  if toggle('polymorph', false)  and target.distance <= 40 and not -target.debuff(SB.Polymorph) then
		return cast(SB.Polymorph, 'target')
		end

    if -buff(SB.HeatingUp) and spell(SB.FireBlast).charges > 0 and toggle('phoenix_flames', false) then
      return cast(SB.FireBlast)
	  end
    if -buff(SB.HeatingUp) and spell(SB.PhoenixFlames).charges > 0 and toggle('phoenix_flames', false) then
      return cast(SB.PhoenixFlames, 'target')
	  end

    if player.moving  then
      return cast(SB.Scorch, 'target')
    end

    if -spell(SB.BlazingBarrier) == 0 and not -buff(SB.BlazingBarrier) and toggle('blazing_barrier', false) then
      return cast(SB.BlazingBarrier, 'player')
    end

    if -spell(SB.Combustion) == 0 and toggle('cooldowns', false) then
      return cast(SB.Combustion, 'player')
    end

    if GetItemCooldown(159615) == 0 and toggle('usetrinkets', false) then
           macro("/cast Ignition Mage's Fuse")
    end

    if GetItemCooldown(166793) == 0 and toggle('usetrinkets', false) then
           macro('/cast Ancient Knot of Wisdom')
    end

    if GetItemCooldown(165666) == 0 and toggle('usetrinkets', false) then
           macro('/cast Moonstone of Zin-Azhari')
    end

    if GetItemCooldown(159624) == 0 and toggle('cooldowns', false) then
           macro('/cast Rotcrusted Voodoo Doll')
    end

    if GetItemCooldown(5512) == 0 and player.health.percent < healthstonepercent and usehealthstone == true then
      macro('/use Healthstone')
    end

    if usefrostnova == true and not -target.debuff(SB.FrostNova) and spell(SB.FrostNova).charges >= 1 and target.distance <= 12 then
      return cast(SB.FrostNova)
    end

    if modifier.alt and -spell(SB.BlazingBarrier) == 0 and not -buff(SB.BlazingBarrier) then
      return cast(SB.BlazingBarrier, 'player')
    end

    if -buff(SB.Combustion) then
      return cast(SB.Scorch)
    end

    if talent(6,3) and not target.debuff(SB.LivingBomb) then
      return cast(SB.LivingBomb, 'target')
    end

    if -spell(SB.GreaterPyroblast) == 0 and toggle('gripfire', false) and target.distance <= 40 then
      return cast(SB.GreaterPyroblast, 'target')
    end

    return cast(SB.Fireball, 'target')
    end
end


local function resting()
if player.alive   then

  if not player.buff(SB.ArcaneInt).any and player.moving and player.alive then
    return cast(SB.ArcaneInt, 'player')
  end

end
  local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Fireball', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
        inRange = inRange + 1
      end
  end

  local mylevel = UnitLevel("player")
  local group_type_ds = IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
  local nameplates = dark_addon.settings.fetch('dr_example_usenameplates', false)
  local seeplates = GetCVar("nameplateShowEnemies")
  local group_type = GroupType()
  
  dark_addon.interface.status_extra('Group:' .. group_type .. '  ' .. dark_addon.version ..  '      Targets#:' .. inRange .. ' |cff5BFF33   Distance:|r ' .. target.distance)

if player.alive then
  if nameplates == true and seeplates == '0' then
     SetCVar("nameplateShowEnemies",1)
  end

  if nameplates == false and seeplates == '1' then
     SetCVar("nameplateShowEnemies",0)
  end
	if toggle('blazing_barrier', false) and -spell(SB.BlazingBarrier) == 0 and not -buff(SB.BlazingBarrier) and player.moving then
     return cast(SB.BlazingBarrier, 'player')
  end

  if player.alive and player.spell(SB.Shimmer).lastcast and ugh==nil then
     PlaySoundFile("Interface\\AddOns\\WeakAuras\\PowerAurasMedia\\Sounds\\sonar.ogg", "Master")
     ugh = 1
     return cast(SB.ArcaneInt, player)
   end

   if ugh == 1 then
    ugh = nil
  end
end

end


local function interface()
    local example = {
    key = 'dr_example',
    title = 'DarkRotations - Fire Mage',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Fire Mage Settings', align= 'center' },
       { type = 'text', text = 'Recomend Talents: 2 2 1 3 2 2 1' },
      { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine.' },
      { type = 'rule' },
      { type = 'text', text = 'General Settings' },
      { key = 'usenameplates', type = 'checkbox', text = 'Show Enemy Nameplates', desc = 'Use name plates to count baddies' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Auto use Healthstone at health %', min = 5, max = 100, step = 5 },
      { key = 'multi', type = 'spinner', text = 'MultiTarget', desc = 'Number of enemies to use AOE', min = 1, max = 20, step = 1 },
      -- { key = 'input', type = 'input', text = 'TextBox', desc = 'Description of Textbox' },
      { key = 'spinner', type = 'spinner', text = 'Interrupt %', desc = 'What % you will be interupting at', min = 5, max = 100, step = 5 },
      { type = 'rule' },
      { type = 'text', text = 'PVP Options' },
      { key = 'usepolymorph', type = 'checkbox', text = 'Polymorph', desc = 'Polymorph your target if possible' },
      { key = 'arenahacks', type = 'checkbox', text = 'Interupt and Steal from all Arena players', desc = 'Be careful of line of sight' , default = true },
      { key = 'usefrostnova', type = 'checkbox', text = 'Frost Nova', desc = 'Auto use Frost Nova if target is near' },
      { key = 'usespellsteal', type = 'checkbox', text = 'Spell Steal', desc = 'Use Spell Steal when possible' },
      { type = 'rule' },
      { type = 'text', text = 'Raid / M+ / Party Options' },
      { key = 'heavymovement', type = 'checkbox', text = 'Heavy movement fight', desc = 'Rotation will be based on heavy movement' },

    }
  }

  configWindow = dark_addon.interface.builder.buildGUI(example)
   dark_addon.interface.buttons.add_toggle({
    name = 'blazing_barrier',
    label = 'Blazing Barrier',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('globe'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('globe'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

    dark_addon.interface.buttons.add_toggle({
     name = 'phoenix_flames',
    label = 'Use Phoenix Flames Off When You Are Not Needing DPS Boost',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('fire'),
      color = dark_addon.interface.color.red,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.red, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('fire'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
        dark_addon.interface.buttons.add_toggle({
     name = 'arenaone',
    label = 'Auto Poly Arena1',
    on = {
      label = 'A1',
      color = dark_addon.interface.color.yellow,
      color2 = dark_addon.interface.color.yellow
    },
    off = {
      label = 'A1',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
    })
        dark_addon.interface.buttons.add_toggle({
     name = 'arenatwo',
    label = 'Auto Poly Arena2',
    on = {
      label = 'A2',
      color = dark_addon.interface.color.yellow,
      color2 = dark_addon.interface.color.yellow
    },
    off = {
      label = 'A2',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
    })
        dark_addon.interface.buttons.add_toggle({
     name = 'autopoly',
    label = 'Mouseover will cast Polymorph automatic',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('allergies'),
      color = dark_addon.interface.color.red,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.red, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('allergies'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
    dark_addon.interface.buttons.add_toggle({
     name = 'usetrinkets',
    label = 'Use Trinkets on CD',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('crown'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('crown'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
  dark_addon.interface.buttons.add_toggle({
   name = 'gripfire',
  label = 'Use Greater Pyroblast',
  font = 'dark_addon_icon',
  on = {
    label = dark_addon.interface.icon('golf-ball'),
    color = dark_addon.interface.color.blue,
    color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
  },
  off = {
    label = dark_addon.interface.icon('golf-ball'),
    color = dark_addon.interface.color.grey,
    color2 = dark_addon.interface.color.dark_grey
  }
})
    dark_addon.interface.buttons.add_toggle({
     name = 'spellstealpvp',
    label = 'Spellsteal the target if possible',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('user-ninja'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('user-ninja'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

   dark_addon.interface.buttons.add_toggle({
    name = 'polymorph',
    label = 'Auto Polymorph your target',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('smile'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('alarm-clock'),
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
  spec = dark_addon.rotation.classes.mage.fire,
  name = 'fire',
  label = 'Rotations Private Fire',
  combat = combat,
  resting = resting,
  interface = interface
})
