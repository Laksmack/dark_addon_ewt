-- Guardian Druid for 8.0.1 by prescient - 8/2018
-- Talents: 3 3 1 1 2 3 3
-- left alt to moonfire target
-- left shift to taunt target

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.druid


local function combat()
  if target.alive and target.enemy and not player.channeling() then

    -- Interrupts
      -- Skull Bash
      if toggle('interrupts', false) and target.interrupt() and castable(SB.SkullBash) then
        return cast(SB.SkullBash)
      end

      if toggle('interrupts', false) and target.interrupt() and player.talent(4,1) and castable(SB.MightyBash) then
        return cast(SB.MightyBash)
      end


    -- Toggles
      --- Frenzied Regeneration
      if castable(SB.FrenziedRegeneration, 'player') and not -buff(SB.FrenziedRegeneration) and player.health.percent < 50 and toggle('frenzied_regeneration', false) then
       return cast(SB.FrenziedRegeneration, 'player')
      end

      -- Barkskin
     -- if castable(SB.Barkskin, 'player') and boss1.alive and toggle('barkskin', false) then
     --   return cast(SB.Barkskin, 'player')
     -- end

      -- Bristling Fur
     -- if castable(SB.BristlingFur, 'player') and boss1.alive and toggle('bristling_fur', false) then
     --   return cast(SB.BristlingFur, 'player')
     -- end

      -- Survival Instincts
      --if castable(SB.SurvivalInstincts, 'player') and boss1.alive and toggle('survival_instincts', false) then
     --  return cast(SB.SurvivalInstincts, 'player')
     -- end


    -- Mouseover
      -- Hold left alt to moonfire mouseover target
      if modifier.lalt and mouseover.alive and mouseover.enemy then
        return cast(SB.Moonfire, 'mouseover')
      end

      -- Hold left shift to taunt mouseover target
      if modifier.lshift and mouseover.alive and mouseover.enemy then
        return cast(SB.Growl, 'mouseover')
      end


    -- The main event

    -- Bear Form
    if castable(SB.BearForm, 'player') and not -buff(SB.BearForm) then
      return cast(SB.BearForm, 'player')
    end

    -- ironfur if we don't have it
    if castable(SB.Ironfur, 'player') and not -buff(SB.Ironfur) then
      return cast(SB.Ironfur, 'player')
    end

    if not target.debuff(SB.MoonfireDebuff) or target.debuff(SB.MoonfireDebuff).remains <=3 then
      return cast(SB.Moonfire, 'target')
    end

    -- pulverize if we have 3 thrash debuffs on target and can reapply one
    if castable(SB.Pulverize, 'target') and player.spell(SB.Thrash).cooldown < 2 and target.debuff(192090).count == 3 then
      return cast(SB.Pulverize, 'target')
    end

    -- mangle if we have Incarnation up
    if castable(SB.Mangle, 'target') and -buff(SB.IncarnationB) then
      return cast(SB.Pulverize, 'target')
    end

    -- thrash
    if castable(SB.ThrashBear, 'target') and target.distance <= 10 then
      return cast(SB.ThrashBear, 'target')
    end

    -- free mangle proc
    if -buff(93622) then
      return cast(SB.Mangle, 'target')
    end

    -- free moonfire proc if moonfire will fall off soon
    if -buff(213708) and target.debuff(SB.MoonfireDebuff).remains <= 6 then
      return cast(SB.Moonfire, 'target')
    end

    -- dump rage with maul, maintaining enough to still ironfur
    if power.rage.actual >= 90 then
      return cast(SB.Maul, 'target')
    end

    -- swipe
    if castable(SB.SwipeBear) then
      return cast(SB.SwipeBear, 'target')
    end
  end
end

local function resting()

end

function interface()
   --dark_addon.interface.buttons.add_toggle({
   -- name = 'barkskin',
   -- label = 'Use Barkskin on cooldown when fighting a Boss',
   -- on = {
   --   label = 'Bark',
   --   color = dark_addon.interface.color.orange,
   --   color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
   -- },
   -- off = {
   --   label = 'Bark',
   --   color = dark_addon.interface.color.grey,
   --   color2 = dark_addon.interface.color.dark_grey
   -- }
  --})

  --dark_addon.interface.buttons.add_toggle({
  --  name = 'bristling_fur',
  --  label = 'Use Bristling Fur on cooldown when fighting a Boss',
  --  on = {
  --    label = 'Fur',
  --    color = dark_addon.interface.color.red,
  --    color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
  --  },
  --  off = {
  --    label = 'Fur',
  --    color = dark_addon.interface.color.grey,
  --    color2 = dark_addon.interface.color.dark_grey
  -- }
  --})

dark_addon.interface.buttons.add_toggle({
    name = 'frenzied_regeneration',
    label = 'Use Frenzied Regeneration if Health goes below 50% and it isnt already running',
    on = {
      label = 'Regen',
      color = dark_addon.interface.color.orange,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'Regen',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  --dark_addon.interface.buttons.add_toggle({
  --  name = 'survival_instincts',
  --  label = 'Use Surival Instincts on cooldown when fighting a Boss - not recommended',
  --  on = {
  --    label = 'SI',
  --    color = dark_addon.interface.color.green,
  --    color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
  --  },
  --  off = {
  --    label = 'SI',
  --    color = dark_addon.interface.color.grey,
  --   color2 = dark_addon.interface.color.dark_grey
  --  }
  --})
end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.druid.guardian,
  name = 'guardian',
  label = 'prescient Guardian',
  combat = combat,
  resting = resting,
  interface = interface,
})