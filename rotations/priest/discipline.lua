-- Discipline Priest for 8.1 by Rotations 12/2018
-- Talents: All 
-- Alt = Mass Dispell
-- Shift = Halo or Divine Star
-- Control = Barrier
local race = UnitRace("player")
local realmName = GetRealmName()
local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.priest

local function combat()

    local dispellable_unit = group.removable('disease', 'magic')
    local buffable_unit = group.buffable(SB.PowerWordShield)
    local callpet = dark_addon.settings.fetch('dr_disc_callpet', false)
    local multinumber = dark_addon.settings.fetch('dr_disc_multi', 1)
    local usepws = dark_addon.settings.fetch('dr_disc_pwsuse', 90)
    local usehealthstone = dark_addon.settings.fetch('dr_disc_healthstone.check', false)
    local healthstonepercent = dark_addon.settings.fetch('dr_disc_healthstone.spin', 20)
    local intpercent = dark_addon.settings.fetch('dr_disc_spinner', 75)
    local halopercentuse = dark_addon.settings.fetch('dr_disc_halopercent', 75)
    local nameplates = dark_addon.settings.fetch('dr_disc_usenameplates', false)
    local seeplates = GetCVar("nameplateShowEnemies")
  
    if nameplates == true and seeplates == '0' then
     SetCVar("nameplateShowEnemies",1)
    end
    if nameplates == false and seeplates == '1' then
     SetCVar("nameplateShowEnemies",0)
    end

  -- Start of Raider Rotation Using 3 3 3 0 1 3 3
  if player.alive and not player.channeling() and toggle('raid', false) then 

    if talent(7,3) and player.spell(SB.PowerWordRadiance).lastcast and -spell(SB.Evangelism) == 0 and group.under(70, 40, true) >= 2  then
      return cast(SB.Evangelism)
    end

    if talent(5,3) and player.spell(SB.PowerWordRadiance).lastcast  and -spell(SB.ShadowConvenant) == 0 then
      return cast(SB.ShadowConvenant)
    end

    if buffable_unit and buffable_unit.health.percent <= usepws and buffable_unit.buff(SB.Atonement).remains <= 2 then
      return cast(SB.PowerWordShield, buffable_unit)
    end

    if buffable_unit and buffable_unit.health.percent <= usepws and not -buffable_unit.buff(SB.Atonement) then
      return cast(SB.PowerWordShield, buffable_unit)
    end

    if player.power.mana.percent  <= 50 and target.enemy and target.alive and target.distance <= 40 and talent(3,3) and -spell(SB.PowerWordSolace) == 0 then
      return cast(SB.PowerWordSolace, target)
    end

    if modifier.control and -spell(SB.PowerWordBarrier) == 0 then
      return cast(SB.PowerWordBarrier, ground)
    end

    if castable(SB.PsychicScream, 'target') and target.interrupt(intpercent, false) and toggle('interrupt', false) and target.distance <= 8 then
      return cast(SB.PsychicScream, 'target')
    end

    if modifier.alt and -spell(SB.MassDispell) == 0 then
      return cast(SB.MassDispell, ground)
    end

    if talent(6,3) and modifier.shift and -spell(SB.Halo) == 0 then 
      return cast(SB.Halo)
    end

    if talent(6,2) and modifier.shift and -spell(SB.DivineStar) == 0 then  
      return cast(SB.DivineStar)
    end

    if toggle('dispel', false) and dispellable_unit and spell(SB.Purify).cooldown == 0 then
     return cast(SB.Purify, dispellable_unit)
    end

    if lowest.health.percent <= 79 and -spell(SB.Penance) == 0 then
      return cast(SB.Penance, lowest)
    end

    if -buff(SB.PowerOfTheDarkSide) and lowest.health.percent >= 80 and -spell(SB.Penance) == 0 then
      return cast(SB.Penance, target)
    end

    if player.health.percent <= 90 and not player.buff(SB.Atonement) then
      return cast(SB.PowerWordShield, player)
    end

    if lowest.health.percent <= usepws and not -lowest.debuff(SB.WeekendSoul) and -lowest.buff(SB.Atonement) then
      return cast(SB.PowerWordShield, lowest)
    end

    if target.enemy and target.alive and target.distance <= 40 and talent(3,3) and -spell(SB.PowerWordSolace) == 0 then
      return cast(SB.PowerWordSolace, target)
    end

    if lowest.health.percent <= 70 and -spell(SB.ShadowMend) == 0 and not -lowest.buff(SB.Atonement) then 
      return cast(SB.ShadowMend, lowest)
    end

    if lowest.health.percent <= 30 and toggle('cooldowns', false) and -spell(SB.PainSuppression) == 0 then
      return cast(SB.PainSuppression, lowest)
    end

    if lowest.health.percent <= 80 and spell(SB.PowerWordRadiance).charges >= 1 and group.under(80, 40, true) >= 2 and not player.spell(SB.PowerWordRadiance).lastcast then
      return cast(SB.PowerWordRadiance, lowest)
    end

    if talent(6,1) and not target.debuff(SB.PurgetheWickedDebuff) and -spell(SB.PurgetheWicked) == 0 and not player.spell(SB.PurgetheWicked).lastcast then
      return cast(SB.PurgetheWicked)
    end

    if talent(6, 3) and group.under(halopercentuse, 40, true) >= 2 and castable(SB.Halo) and spell(SB.Halo).cooldown == 0 and toggle('halocd', false) then
      return cast(SB.Halo)
    end

    if -spell(SB.DesperatePrayer) == 0 and lowest.health.percent <= 80 then
      return cast(SB.DesperatePrayer, lowest)
    end

    if -spell(SB.Schism) == 0 and target.alive and target.enemy and talent (1,3) then
      return cast(SB.Schism, target)
    end

    if not target.debuff(SB.ShadowWordPain) or target.debuff(SB.ShadowWordPain).remains <= 2 and target.enemy then
      return cast(SB.ShadowWordPain, target)
    end

    if not talent(3,2) and -spell(SB.Shadowfiend) == 0 and toggle('cooldowns', false) and callpet == true then
      return cast(SB.Shadowfiend)
    end

    if talent(3,2) and -spell(SB.Mindbender) == 0 and toggle('cooldowns', false) and callpet == true then
      return cast(SB.Mindbender, target)
    end

    if GetItemCooldown(5512) == 0 and player.health.percent <= healthstonepercent and usehealthstone == true then
      macro('/use Healthstone')
    end

    if target.enemy and target.alive then
      return cast(SB.Smite, target)
    end
   end
  end

-- Put great stuff here to do when your out of combat
local function resting()
   local healthstonepercent = dark_addon.settings.fetch('dr_disc_healthstone.spin') 
   local group_type_ds = IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
   local nameplates = dark_addon.settings.fetch('dr_disc_usenameplates', false)
   local seeplates = GetCVar("nameplateShowEnemies")
   local dispellable_unit = group.removable('disease', 'magic')

if player.alive then
    if nameplates == true and seeplates == '0' then
     SetCVar("nameplateShowEnemies",1)
    end

    if nameplates == false and seeplates == '1' then
     SetCVar("nameplateShowEnemies",0)
    end
 
    if toggle('dispel', false) and dispellable_unit and spell(SB.Purify).cooldown == 0 then
      return cast(SB.Purify, dispellable_unit)
    end

    if not player.moving and lowest.health.percent <= 70 and -spell(SB.ShadowMend) == 0 then
      return cast(SB.ShadowMend, lowest)
    end

    if lowest.health.percent <= 70 and -spell(SB.Penance) == 0 then
      return cast(SB.Penance, lowest)
    end
end
end


function interface()
local discgui = {
    key = 'dr_disc',
    title = 'DarkRotations - Disc Priest',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = '               Discipline Settings' },
      { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine.' },
      { type = 'rule' },   
      { type = 'text', text = 'General Settings' },
      { key = 'callpet', type = 'checkbox', text = 'Call Pet', desc = 'Always call Mindbender or Shadowfiend' },
      { key = 'usenameplates', type = 'checkbox', text = 'Show Enemy Nameplates', desc = 'Use name plates to count baddies' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Auto use Healthstone at health %',default = 20, min = 5, max = 100, step = 5 },
      { key = 'multi', type = 'spinner', text = 'MultiTarget', desc = 'Number of enemies to use AOE', default = 1, min = 1, max = 20, step = 1 },
      -- { key = 'input', type = 'input', text = 'TextBox', desc = 'Description of Textbox' },
      { key = 'halopercent', type = 'spinner', text = 'Group health% for Halo', desc = 'Use in conjunction with Halo on CD option', min = 5, max = 100, step = 5 },
      { key = 'spinner', type = 'spinner', text = 'Interrupt %', desc = 'What % you will be interupting at', default = 75, min = 5, max = 100, step = 5 },
      { key = 'pwsuse', type = 'spinner', text = 'PWS%', desc = 'What % health gets PWS', default =90, min = 5, max = 100, step = 5 },
      { type = 'rule' },   
      { type = 'text', text = 'PVP Options' },
     -- { key = 'check', type = 'checkbox', text = 'TextLabel', desc = 'Description here' },
      { type = 'rule' },   
      { type = 'text', text = 'Raid / M+ / Party Options' },
      { key = 'heavymovement', type = 'checkbox', text = 'Heavy movement fight', desc = 'Rotation will be based on heavy movement' },
    }
  }

  configWindow = dark_addon.interface.builder.buildGUI(discgui)

    dark_addon.interface.buttons.add_toggle({
    name = 'raid',
    label = 'Raid / Dungeon Healing Mode',
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
    name = 'halocd',
    label = 'Use Halo on CD',
    on = {
      label = 'Halo',
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.blue, 0.7)
    },
    off = {
      label = 'Halo',
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
  spec = dark_addon.rotation.classes.priest.discipline,
  name = 'disc',
  label = 'Disc by Rotations',
  combat = combat,
  resting = resting,
  interface = interface
})
