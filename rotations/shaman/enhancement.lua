local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.shaman

local function combat()

  if target.alive and target.enemy and player.alive then
  auto_attack()
  
  -- get our GUI eadings
   local lavauseperc = dark_addon.settings.fetch('dr_enhancement_lavause.spin', 90)
    -- Interupts

    if target.interrupt(100, false) and toggle('interrupts', false) and -spell(SB.WindShear) == 0 then
      return cast(SB.WindShear, 'target')
    end

    if modifier.shift then
      return cast(SB.CapTotem, 'ground')
    end

    if modifier.alt then
      return cast(SB.Hex, 'target')
    end

    if modifier.control then
      return cast(SB.EarthbindTotem, 'ground')
    end

    if -power.maelstrom >= lavauseperc and  -spell(SB.LavaLash) == 0 then
      return cast(SB.LavaLash, 'target')
    end

    if not -buff(SB.FuryofAir) and -power.maelstrom >= 3 and talent(6,2) then
      return cast(SB.FuryofAir)
    end

    if talent (2,3) and not -buff(SB.ResonanceTotem_Enh) and not -buff(SB.StormTotem_Enh) and not -buff(SB.EmberTotaem_Enh) and not -buff(SB.TailwindTotem_Enh) and -spell(SB.TotemMastery) == 0 then
      return cast(SB.TotemMastery)
    end

    if enemies.around(10) >= 2 and not -buff(SB.CrashLightningBuff)  and -spell(SB.CrashLightning) == 0  then
      return cast(SB.CrashLightning, 'target')
    end

    if talent(6,3) and -spell(SB.Sundering) == 0 then
      return cast(SB.Sundering) 
    end

    if -buff(SB.AscendanceBuff_Enh)  and -spell(SB.Windstrike) == 0 then
      return cast(SB.Windstrike, 'target')
    end

    if not -buff(SB.FlametongueBuff)  and -spell(SB.Flametongue) == 0 then
      return cast(SB.Flametongue, 'target')
    end

    if toggle('cooldowns', false)  and -spell(SB.FeralSpirit) == 0  then
      return cast(SB.FeralSpirit)
    end

    if talent(7,2) and -spell(SB.EarthenSpike) == 0  then
      return cast(SB.EarthenSpike, 'target')
    end

    if talent(4,2)  and not -buff(SB.Frostbrand) and -spell(SB.Frostbrand) == 0  then
      return cast(SB.Frostbrand, 'target')
    end

    if talent(7,3)  and -spell(SB.Ascendance_Enh) == 0 and toggle('cooldowns', false) then
      return cast(SB.Ascendance_Enh)
    end

    if -buff(SB.Stormbringer) and -spell(SB.Stormstrike) == 0 then
      return cast(SB.Stormstrike, 'target')
    end

    if -buff(SB.HotHands)  and -spell(SB.LavaLash) == 0 then 
      return cast(SB.LavaLash)
    end

    if  -spell(SB.Stormstrike) == 0 then 
      return cast(SB.Stormstrike, 'target')
    end

    if enemies.around(10) >= 3  and -spell(SB.CrashLightning) == 0  then
      return cast(SB.CrashLightning, 'target')
    end

    if spell(SB.Rockbiter).charges == 2 and -spell(SB.Rockbiter) == 0 then 
      return cast(SB.Rockbiter)
    end

    if -power.maelstrom >= 40 and not talent(6,2) and -spell(SB.LightningBolt) == 0  then
      return cast(SB.LightningBolt, 'target')
    end

    if -power.maelstrom >= 50 and talent(6,2) and -spell(SB.LightningBolt) == 0 then
      return cast(SB.LightningBolt, 'target')
    end

    if -buff(SB.SearingAssault)  and -spell(SB.Flametongue) == 0  then 
      return cast(SB.Flametongue, 'target')
    end

    if -power.maelstrom <= 39 and spell(SB.Rockbiter).charges == 1 and -spell(SB.Rockbiter) == 0 then
      return cast(SB.Rockbiter, 'target')
    end

    if talent(4,2) and  -buff(SB.Frostbrand) and -buff(SB.Frostbrand).remains <= 4 and -spell(SB.Frostbrand) == 0  then
      return cast(SB.Frostbrand, 'target')
    end

    if enemies.around(10) >= 2 and -spell(SB.CrashLightning) == 0  then
      return cast(SB.CrashLightning, 'target')
    end

    if -power.maelstrom >= 40 and not talent(6,2) and -spell(SB.LavaLash) == 0  then
      return cast(SB.LavaLash, 'target')
    end

    if  -power.maelstrom >= 50 and talent(6,2) and -spell(SB.LavaLash) == 0  then
      return cast(SB.LavaLash, 'target')
    end

  end
end

local function resting()
   local lavauseperc = dark_addon.settings.fetch('dr_enhancement_lavause.spin', 90)

  if not -buff(SB.LightningShield) then
    return cast(SB.LightningShield)
  end

  if modifier.shift then
    return cast(SB.TotemMastery)
  end
end
local function interface()
local enhancegui = {
    key = 'dr_enhancement',
    title = 'DarkRotations - Enhancement Shaman',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Enhancement Shaman Settings', align= 'center' },
      { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine.' },
      { type = 'rule' },   
      { type = 'text', text = 'General Settings' },
      { key = 'callpet', type = 'checkbox', text = 'Call Pet', desc = 'Always call Mindbender or Shadowfiend' },
      { key = 'usenameplates', type = 'checkbox', text = 'Show Enemy Nameplates', desc = 'Use name plates to count baddies' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Auto use Healthstone at health %',default = 20, min = 5, max = 100, step = 5 },
      { key = 'lavause', type = 'checkspin', text = 'Maelstrom Dump', desc = 'What % to start dumping Maelstrom',default = 20, min = 5, max = 100, step = 5 },
      { key = 'multi', type = 'spinner', text = 'MultiTarget', desc = 'Number of enemies to use AOE', default = 1, min = 1, max = 20, step = 1 },
      -- { key = 'input', type = 'input', text = 'TextBox', desc = 'Description of Textbox' },
      --{ key = 'halopercent', type = 'spinner', text = 'Group health% for Halo', desc = 'Use in conjunction with Halo on CD option', min = 5, max = 100, step = 5 },
      { key = 'spinner', type = 'spinner', text = 'Interrupt %', desc = 'What % you will be interupting at', default = 75, min = 5, max = 100, step = 5 },
      --{ key = 'pwsuse', type = 'spinner', text = 'PWS%', desc = 'What % health gets PWS', default =90, min = 5, max = 100, step = 5 },
      { type = 'rule' },   
      { type = 'text', text = 'PVP Options' },
     -- { key = 'check', type = 'checkbox', text = 'TextLabel', desc = 'Description here' },
      { type = 'rule' },   
      { type = 'text', text = 'Raid / M+ / Party Options' },
      { key = 'heavymovement', type = 'checkbox', text = 'Heavy movement fight', desc = 'Rotation will be based on heavy movement' },
    }
  }

  configWindow = dark_addon.interface.builder.buildGUI(enhancegui)

    dark_addon.interface.buttons.add_toggle({
    name = 'raid',
    label = 'Raid / Dungeon Modes',
    on = {
      label = 'Raid',
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.blue, 0.7)
    },
    off = {
      label = 'Dung',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  dark_addon.interface.buttons.add_toggle({
    name = 'dispel',
    label = 'Auto Dispel',
    on = {
      label = 'DSP',
      color = dark_addon.interface.color.red,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.red, 0.7)
    },
    off = {
      label = 'dsp',
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
      color2 = dark_addon.interface.color.dark_cyan
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
  spec = dark_addon.rotation.classes.shaman.enhancement,
  name = 'enhancement',
  label = 'Bundled Enhancement',
  combat = combat,
  resting = resting,
  interface = interface
})
