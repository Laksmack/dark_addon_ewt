local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.rogue

-- Talents

--Spells
SB.Rupture = 1943
SB.Vendetta = 79140
SB.Vanish = 1856
SB.Subterfuge = 108208
SB.Nightstalker = 14062
SB.Garrote = 703
SB.ToxicBlade = 245388
SB.Exsanguinate = 200806
SB.Envenom = 32645
SB.DeeperStratagem = 193531
SB.PoisonedKnife = 185565
SB.SharpenedBlades = 272911
SB.FanofKnives = 51723
SB.HiddenBlades = 270061
SB.Blindside = 111240
SB.Mutilate = 1329
SB.CrimsonTempest = 121411
SB.Vigor = 14983
SB.DeadlyPoison = 2823
SB.CripplingPoison = 3408
SB.VenomousWounds = 79134
SB.SealFate = 14190
SB.Feint = 1966
SB.Elusiveness = 79008
SB.CloakofShadows = 31224
SB.Evasion = 5277
SB.CheatDeath = 31230
SB.CrimsonVial = 185311
SB.nightstalkerStealth = 1784
SB.subStealth = 115191
SB.MarkedforDeath = 137619

local function combat()
if target.alive and target.enemy and player.alive and not player.channeling() then

if talent(2,1) or talent(2,3) then SB.Stealth = 1784 end
if talent(2,2) then SB.Stealth = 115191 end  

  --Reading from settings
  local intpercentlow = dark_addon.settings.fetch('sinrog_settings_intpercentlow',50)
  local intpercenthigh = dark_addon.settings.fetch('sinrog_settings_intpercenthigh',65)
  local kickInt = dark_addon.settings.fetch('sinrog_settings_usetrinkets', true)
  local blindInt = dark_addon.settings.fetch('sinrog_settings_usetrinkets', true)  
  local cos = dark_addon.settings.fetch('sinrog_settings_cos.check', true)
  local cospercent = dark_addon.settings.fetch('sinrog_settings_cos.spin', 50)
  local cv = dark_addon.settings.fetch('sinrog_settings_cv.check', true)
  local cvpercent = dark_addon.settings.fetch('sinrog_settings_cv.spin', 30)
  local fnt = dark_addon.settings.fetch('sinrog_settings_fnt.check', true)
  local fntpercent = dark_addon.settings.fetch('sinrog_settings_fnt.spin', 40)
  local ev = dark_addon.settings.fetch('sinrog_settings_ev.check', true)
  local evpercent = dark_addon.settings.fetch('sinrog_settings_ev.spin', 60)
  local healthstone = dark_addon.settings.fetch('sinrog_settings_healthstone.check', true)
  local healthstonepercent = dark_addon.settings.fetch('sinrog_settings_healthstone.spin', 20)
  local usetrinkets = dark_addon.settings.fetch('sinrog_settings_usetrinkets', true)   
  
  --Targets in range check
  local enemyCount = enemies.around(8)
  if enemyCount == 0 then enemyCount = 1 end    
  dark_addon.interface.status_extra('T#:' .. enemyCount .. ' D:' .. target.distance)

  --Auto Attack
  if target.enemy and target.alive and target.distance < 8 then
    auto_attack()
  end

  --Interrupts
  --Define random number for interrupt
  local intpercent = math.random(intpercentlow,intpercenthigh)
  
  --Kick
  if toggle('interrupts', false) and castable(SB.Kick) and -spell(SB.Kick) == 0 and target.interrupt(intpercent, false) and target.distance < 8 and kickInt then
    print('Kick @ ' .. intpercent)
    return cast(SB.Kick, 'target')
  end

  --Blind
  if toggle('interrupts', false) and castable(SB.Blind) and -spell(SB.Blind) == 0 and -spell(SB.Kick) > 0 and -spell(SB.Gouge) > 0 
  and target.interrupt(intpercent, false) and target.distance < 8 and blindInt then
    print('Blind @ ' .. intpercent)
    return cast(SB.Blind, 'target')
  end    
  
  --Defensive and Utility Abilities
  --Cloak of Shadows
  local dispellable_unit = player.removable('disease', 'magic', 'poison')

  if castable(SB.CloakofShadows) and -spell(SB.CloakofShadows) == 0 and -player.health <= cospercent and cos and dispellable_unit then
    return cast(SB.CloakofShadows, 'player')
  end
         
  --Feint
  if castable(SB.Feint) and -spell(SB.Feint) == 0 and -player.health <= fntpercent and fnt then
    return cast(SB.Feint, 'player')
  end
    
  -- Evasion increases your Dodge chance by 100% for 10 seconds. This can be useful if you have to tank some adds or the boss for a few seconds.
  if castable(SB.Evasion) and -spell(SB.Evasion) == 0 and -player.health <= evpercent and ev then
    return cast(SB.Evasion, 'player')
  end
    
  --Healing
  if castable(SB.CrimsonVial) and -spell(SB.CrimsonVial) == 0 and -player.health <= cvpercent and cv then
    return cast(SB.CrimsonVial, 'player')
  end

  --Healthstone
  if healthstone and GetItemCooldown(5512) == 0 and player.health.percent < healthstonepercent and GetItemCount(5512) >= 1  then
    macro('/use Healthstone')
  end

  --Trinkets
  local Trinket13 = GetInventoryItemID("player", 13)
  local Trinket14 = GetInventoryItemID("player", 14)

 -- if usetrinkets then
  --  if GetItemCooldown(Trinket13) == 0 then
 --     macro('/use 13')
 --   end
 --   if GetItemCooldown(Trinket14) == 0 then
 --     macro('/use 14')
 --   end
--  end

  -- "custom": "function(event, _, type, _, src, _, _, _, dest, _, _, _, spellId)    
  -- if event ~= \"COMBAT_LOG_EVENT_UNFILTERED\" then return end 
  -- if src ~= UnitGUID(\"player\") then return end   
  -- -- Check for Nightstalker rupture\n    if IsPlayerSpell(14062) or IsPlayerSpell(200806) then      
  -- --init table for target on applying rupture      
  -- if type == \"SPELL_CAST_SUCCESS\" and spellId == 1943 then            
  -- if (_G['RuptureDB'][dest] == nil) then              
  -- _G['RuptureDB'][dest] = {dest, [\"NS\"] = false,                   [\"Exsang\"] = false}          
  -- else\n                _G['RuptureDB'][dest][\"Exsang\"] = false            end          
  
  -- -- set Nightstalker bool\n            
  -- if IsStealthed() then\n                _G['RuptureDB'][dest][\"NS\"] = true\n            
  -- else\n                _G['RuptureDB'][dest][\"NS\"] = false\n            end\n            \n       
  --  elseif type == \"SPELL_AURA_REMOVED\" and spellId ==  1943 then\n            \n            
  --  _G['RuptureDB'][dest] = nil\n        end\n        \n    end\n    \n    
   
  --  -- Check for exanguinate\n    if type == \"SPELL_CAST_SUCCESS\" and spellId == 200806 then\n        
  --  if (_G['RuptureDB'][dest] ~= nil) then\n            
  --  _G['RuptureDB'][dest][\"Exsang\"] = true\n        end\n    end    \n    \n    
   
  --  -- Check for subterfuge garrote\n    
  --  if type == \"SPELL_AURA_APPLIED\" or  type == \"SPELL_CAST_SUCCESS\" then\n        
  --  if spellId == 703 then\n            
  --  if IsStealthed() or UnitBuff(\"player\", GetSpellInfo(108208))\n            
  --  then\n                _G['GarroteDB'][dest] =true \n            
  --  else\n                _G['GarroteDB'][dest] = nil\n                \n            end\n        end\n    
  --  elseif type == \"SPELL_AURA_REMOVED\" and spellId == 703 then\n        _G['GarroteDB'][dest] = nil\n    end\nend",  

  --Rotation
  if (enemyCount == 1 or not toggle('multitarget')) then
      
    --Single Target
    --Maintain Rupture (4+ Combo Points).
    if castable(SB.Rupture) and -spell(SB.Rupture) == 0 and (target.debuff(SB.Rupture).down or target.debuff(SB.Rupture).remains <= 6) 
    and player.power.combopoints.actual >= 4 then
      return cast(SB.Rupture, 'target')
    end
      
    --Activate Vendetta when available.
    if toggle('cooldowns', false) and castable(SB.Vendetta) and -spell(SB.Vendetta) == 0 then
      return cast(SB.Vendetta, 'target')
    end      
      
    --Activate Vanish on cooldown if using Subterfuge or with 5 Combo Points in order to facilitate Nightstalker -empowered Rupture
    if toggle('cooldowns', false) and castable(SB.Vanish) and -spell(SB.Vanish) == 0 
    and ((-spell(SB.Garrote) == 0 and talent(2,2)) or (player.power.combopoints.actual >= 5 and talent(2,1))) then
      return cast(SB.Vanish, 'player')
    end  

    --Cast Marked for Death (if talented) if you have 0-1 Combo Points.
    if castable(SB.MarkedforDeath) and -spell(SB.MarkedforDeath) == 0 and player.power.combopoints.actual <= 1 and talent(3,3) then
      return cast(SB.MarkedforDeath, 'target')
    end
        
    --Maintain Garrote
    if castable(SB.Garrote) and -spell(SB.Garrote) == 0 and (target.debuff(SB.Garrote).down or target.debuff(SB.Garrote).remains <= 5.4) then
      return cast(SB.Garrote, 'target')
    end
        
    --Cast Toxic Blade when available, if you have chosen this talent.
    if castable(SB.ToxicBlade) and -spell(SB.ToxicBlade) == 0 and talent(6,2) then
      return cast(SB.ToxicBlade, 'target')
    end
        
    --Cast Exsanguinate on cooldown, if your Rupture has more than 20 seconds remaining, and Garrote is above 50% of its duration.
    if castable(SB.Exsanguinate) and -spell(SB.Exsanguinate) == 0 and target.debuff(SB.Rupture).remains > 20 and target.debuff(SB.Garrote).remains > 9 
    and talent(6,3) then
      return cast(SB.Exsanguinate, 'target')
    end

    --Cast Envenom with 4-5 Combo Points (5-6 with Deeper Stratagem).
    if castable(SB.Envenom) and -spell(SB.Envenom) == 0 and (player.power.combopoints.actual >= 4 or (player.power.combopoints.actual >= 5 and talent(3,3))) then
      return cast(SB.Envenom, 'target')
    end      
      
    --Cast Poisoned Knife when Sharpened Blades is above 29 stacks.
    if castable(SB.PoisonedKnife) and -spell(SB.PoisonedKnife) == 0 and player.buff(SB.SharpenedBlades).count >= 29 then
      return cast(SB.PoisonedKnife, 'target')
    end 

    --Cast Fan of Knives when Hidden Blades is above 19 stacks.
    if castable(SB.FanofKnives) and -spell(SB.FanofKnives) == 0 and player.buff(SB.HiddenBlades).count >= 19 then
      return cast(SB.FanofKnives, 'target')
    end 

    --Cast Blindside when available, if you have chosen this talent.
    if castable(SB.Blindside) and -spell(SB.Blindside) == 0 and player.power.combopoints.actual <= 4 and talent(1,3) then
      return cast(SB.Blindside, 'target')
    end

    --Cast Mutilate to generate Combo Points (do not use it if Blindside is available).
    if castable(SB.Mutilate) and -spell(SB.Mutilate) == 0 and player.power.combopoints.actual <= 3 then
      return cast(SB.Mutilate, 'target')
    end 

  end
    
  if (enemyCount >= 2 or toggle('multitarget')) then
      
    --Multi-Target
    --Maintain Rupture on up to 3 targets.
    if castable(SB.Rupture) and -spell(SB.Rupture) == 0 and (target.debuff(SB.Rupture).down or target.debuff(SB.Rupture).remains <= 6) 
    and player.power.combopoints.actual >= 4 then
      return cast(SB.Rupture, 'target')
    end      
     
    --Activate Vendetta when available.
    if toggle('cooldowns', false) and castable(SB.Vendetta) and -spell(SB.Vendetta) == 0 then
      return cast(SB.Vendetta, 'target')
    end      
      
    --Activate Vanish and apply Garrote empowered by Subterfuge to as many targets as possible.
    if toggle('cooldowns', false) and castable(SB.Vanish) and -spell(SB.Vanish) == 0 and -spell(SB.Garrote) == 0 then
      return cast(SB.Vanish, 'player')
    end

    --Cast Marked for Death (if talented) if you have 0-1 Combo Points.
    if castable(SB.MarkedforDeath) and -spell(SB.MarkedforDeath) == 0 and player.power.combopoints.actual <= 1 and talent(3,3) then
      return cast(SB.MarkedforDeath, 'target')
    end    
        
    --Maintain Garrote on up to 3 targets (try to not overwrite empowered ones).
    if castable(SB.Garrote, 'target') and -spell(SB.Garrote) == 0 and (target.debuff(SB.Garrote).down or target.debuff(SB.Garrote).remains <= 5.4) then
      return cast(SB.Garrote, 'target')
    end      
      
    --Cast Crimson Tempest with 4-5 Combo Points.
    if castable(SB.CrimsonTempest) and -spell(SB.CrimsonTempest) == 0 and player.power.combopoints.actual >= 4 and talent(7,3) then
      return cast(SB.CrimsonTempest, 'target')
    end

    --Cast Envenom with 4-5 Combo Points (do not use it if you have Crimson Tempest talented).
    if castable(SB.Envenom) and -spell(SB.Envenom) == 0 and player.power.combopoints.actual >= 4 and not talent(7,3) then
      return cast(SB.Envenom, 'target')
    end      
      
    --Cast Poisoned Knife when Sharpened Blades is above 29 stacks.
    if castable(SB.PoisonedKnife) and -spell(SB.PoisonedKnife) == 0 and player.buff(SB.SharpenedBlades).count >= 29 then
      return cast(SB.PoisonedKnife, 'target')
    end 

    --Cast Fan of Knives when 2+ targets are within range to generate Combo Points.
    if castable(SB.FanofKnives) and -spell(SB.FanofKnives) == 0 and player.power.combopoints.actual <= 4 then
      return cast(SB.FanofKnives, 'target')
    end

  end    

end
end

local function resting()

local enemyCount = enemies.around(8)
dark_addon.interface.status_extra('T#:' .. enemyCount .. ' D:' .. target.distance)

if target.alive and target.enemy and player.alive and not player.channeling() then

  --Empowered Rupture/Garrote 
  if castable(SB.Garrote) and player.spell(SB.Vanish).lastcast and talent(2,2) then
    return cast(SB.Garrote, 'target')
  end

  if castable(SB.Rupture) and player.spell(SB.Vanish).lastcast and talent(2,1) then
    return cast(SB.Rupture, 'target')
  end

end       
  
-- Apply Deadly Poison
if castable(SB.DeadlyPoison) and not -buff(SB.DeadlyPoison) then
  return cast(SB.DeadlyPoison)
end

--Stealth OOC
if castable(SB.Stealth) and -spell(SB.Stealth) == 0 and player.buff(SB.Stealth).down then 
  return cast(SB.Stealth, 'player')
end 

end

local function interface()

    local settings = {
        key = 'sinrog_settings',
        title = 'Assassination Rogue',
        width = 300,
        height = 600,
        resize = true,
        show = false,
        template = {
            { type = 'header', text = "            Rex's Assassination Rogue Settings" },
            { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine' },
            { type = 'text', text = 'Suggested Talents - 1 2 1 2 3 2 1' },
            { type = 'text', text = 'Vendetta and Vanish are managed by the Cooldowns toggle' },                       
            { type = 'text', text = 'If you want automatic AOE then please remember to turn on EnemyNamePlates in WoW (V key)' },
            { type = 'rule' },
            { type = 'text', text = 'Interrupt Settings' },
            { key = 'intpercentlow', type = 'spinner', text = 'Interrupt Low %', default = '50', desc = '', min = 5, max = 50, step = 1 },
            { key = 'intpercenthigh', type = 'spinner', text = 'Interrupt High %', default = '65', desc = '', min = 51, max = 100, step = 1 },
            { key = 'kickInt', type = 'checkbox', text = 'Use Kick as an interrupt', desc = '', default = true },
            { key = 'blindInt', type = 'checkbox', text = 'Use Blind as an interrupt', desc = '', default = true },            
            { type = 'text', text = 'Defensive Settings' },
            { key = 'cos', type = 'checkspin', text = 'Cloak of Shadows', desc = 'Health % to cast at', default_check = true, default_spin = 50, min = 5, max = 100, step = 1 },
            { key = 'cv', type = 'checkspin', text = 'Crimson Vial', desc = 'Health % to cast at', default_check = true, default_spin = 30, min = 5, max = 100, step = 1 },                       
            { key = 'fnt', type = 'checkspin', text = 'Feint', desc = 'Health % to cast at', default_check = true, default_spin = 40, min = 5, max = 100, step = 1 },
            { key = 'ev', type = 'checkspin', text = 'Evasion', desc = 'Health % to cast at', default_check = true, default_spin = 60, min = 5, max = 100, step = 1 },
            { type = 'text', text = 'General Settings' },
            { key = 'usetrinkets', type = 'checkbox', text = 'Auto Trinket', desc = '', default = true },
            { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Health % to cast at', default_check = true, default_spin = 20, min = 5, max = 100, step = 5 },                                                  
        }
    }

    configWindow = dark_addon.interface.builder.buildGUI(settings)

    dark_addon.interface.buttons.add_toggle({
    name = 'ttdtoggle',
    label = 'BF TTD',
    on = {
      label = 'BF TTD On',
      color = dark_addon.interface.color.yellow,
      color2 = dark_addon.interface.color.yellow
    },
    off = {
      label = 'BF TTD Off',
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

-- This is what actually tells DR about your custom rotation
dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.rogue.assassination,
  name = 'RexSinRog',
  label = 'Rex Assassination Rogue',
  combat = combat,
  resting = resting,
  interface = interface
})
