-- Shadow Priest for 8.1 by Rotations - 3/2019
-- Talents: 1 1 3 3 1 2 2
-- Holding 
-- Holding 


local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.priest

local function combat()
    local blowup = dark_addon.settings.fetch('dr_example_priest_blowup')
    local multinumber = dark_addon.settings.fetch('dr_example_priest_multi')
    local intpercent = dark_addon.settings.fetch('dr_example_priest_spinner')
    local usehealthstone = dark_addon.settings.fetch('dr_example_priest_healthstone.check')
    local healthstonepercent = dark_addon.settings.fetch('dr_example_priest_healthstone.spin')
    local callpet = dark_addon.settings.fetch('dr_example_priest_callpet')
    local usepoly = dark_addon.settings.fetch('dr_example_priest_usepolymorph')
    local usefrostnova = dark_addon.settings.fetch('dr_example_priest_usefrostnova')
    local heavymove = dark_addon.settings.fetch('dr_example_priest_heavymovement')
    local usespellsteal = dark_addon.settings.fetch('dr_example_priest_usespellsteal')
    local nameplates = dark_addon.settings.fetch('dr_example_priest_usenameplates')
    local critChance = GetCritChance() -- in development for future use

   if target.alive  and target.enemy and player.alive and not player.channeling() and not -buff(SB.Dispersion) then

    -- Lets heal the party

    if toggle('heal_tank', false)  and player.health.percent <= 90  then
      return cast(SB.ShadowMend, 'player')
    end
        if toggle('heal_tank', false)  and not -lowest.buff(SB.PowerWordFortitude) and lowest.health.percent <= 90 then
      return cast(SB.PowerWordFortitude, lowest)
    end

    if toggle('heal_tank', false)  and not -lowest.buff(SB.PowerWordShield) and lowest.health.percent <= 70 then
      return cast(SB.PowerWordShield, lowest)
    end
    if toggle('heal_tank', false) and lowest.health.percent <= 90 and player.power.mana.percent >= 10 then
      return cast(SB.FlashHeal, lowest)
    end
----
    local nearest_target = enemies.match(function (unit)
    return unit.alive and unit.combat and unit.distance <= 40
  end)
  
  if (not target.exists or target.distance > 40) and nearest_target and nearest_target.name then
    macro('/target ' .. nearest_target.name)
  end
----
    if toggle('auto_dot', false) then
        local enemy_for_mark = enemies.match(function (unit)
          return unit.alive and unit.combat and unit.distance <= 40 and unit.debuff(SB.ShadowWordPain).remains < 2
        end)
local enemies_around = enemies.around(40)
        if target.debuff(SB.ShadowWordPain).remains > 10 and enemy_for_mark and enemy_for_mark.name then
          for i=1,enemies_around do
            macro('/target ' .. enemy_for_mark.name)
            if target.guid == enemy_for_mark.guid then break end
          end
        end
      end
---

    -- Ok lets get busy with some DPS

    if -spell(SB.Silence) == 0 and target.interrupt(100, false) then
      return cast(SB.Silence, 'target')
    end
    if -spell(SB.PsychicScream) == 0 and target.interrupt(100, false) and -spell(SB.Silence) >= 1 then
      return cast(SB.PsychicScream, 'target')
    end
    if -spell(SB.PsychicHorror) == 0 and target.interrupt(100, false) and -spell(SB.PsychicScream)  >= 1 and  -spell(SB.Silence) >= 1 then
      return cast(SB.PsychicHorror, 'target')
    end
    if player.health.percent <= 15 and -spell(SB.PowerWordShield) == 0 and not -buff(SB.PowerWordShield) then
      return cast(SB.PowerWordShield, 'player')
    end
    if player.health.percent <= 20 and -spell(SB.Dispersion) == 0 then
      return cast(SB.Dispersion, 'player')
    end
    if -buff(SB.Voidform) and -spell(SB.VoidBolt) == 0 then 
      return cast(SB.VoidBolt)
    end
    if toggle('multitarget', false) and -spell(SB.DarkAscension) == 0 and talent (7,2) then
      return cast(SB.DarkAscension, 'target')
    end
    if toggle('multitarget', false) and -spell(SB.MindbenderShadow) == 0 then
      return cast(SB.MindbenderShadow, 'target')
    end
    if not -target.debuff(SB.ShadowWordPain) then
      return cast(SB.ShadowWordPain, 'target')
    end
    if not -target.debuff(SB.VampiricTouch) and not player.spell(SB.VampiricTouch).lastcast then
      return cast(SB.VampiricTouch, 'target')
    end
    if -spell(SB.DarkVoid) == 0  then
      return cast(SB.DarkVoid, 'target')
    end
    if -spell(SB.VoidEruption) == 0 and player.power.insanity.actual >= 90 then
      return cast(SB.VoidEruption, 'target')
    end
    if -spell(SB.MindBlast) == 0  then
      return cast(SB.MindBlast, 'target')
    end


    if -spell(SB.MindFlay) == 0  then
      return cast(SB.MindFlay, 'target')
    end
 end
end

local function resting()
 


  -- Put great stuff here to do when your out of combat
    if not -player.buff(SB.PowerWordFortitude) and player.moving and player.alive then
      return cast(SB.PowerWordFortitude, 'player')
 end
end

local function interface()

    local example = {
    key = 'dr_example_priest_priest',
    title = 'DarkRotations - Shadow',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Shadow Settings', align= 'center' },
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

  configWindow = dark_addon.interface.builder.buildGUI(example)

   dark_addon.interface.buttons.add_toggle({
    name = 'heal_tank',
    label = 'Shit just got real, time to heal!',
    on = {
      label = 'Heal',
      color = dark_addon.interface.color.orange,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'Heal',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
   dark_addon.interface.buttons.add_toggle({
    name = 'auto_dot',
    label = 'Apply Dot to All Units (set in settings)',
    on = {
      label = 'Dot',
      color = dark_addon.interface.color.dark_blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = 'Dot',
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
  spec = dark_addon.rotation.classes.priest.shadow,
  name = 'shadow',
  label = 'Bundled Shadow',
  combat = combat,
  resting = resting,
  interface = interface  -- Put back in for buttons
})


