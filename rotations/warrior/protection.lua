-- Prot Warrior for 8.1 by Rotations - 3/2019
-- Talents: 3 3 1 3 2 1 1
-- Holding Alt =
-- Holding Shift = Heroic Leap

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.warrior

local function combat()

  if modifier.shift and castable(SB.HeroicLeap) and toggle('leap') then
    return cast(SB.HeroicLeap, 'ground')
  end

  if GetItemCooldown(5512) == 0 and player.health.percent < 20 then
    macro('/use Healthstone')
  end

  if castable(SB.LastStand) and player.health.percent <= 30 then
      return cast(SB.LastStand, 'target')
  end

  if target.alive and target.enemy and not player.channeling() then
    auto_attack()

   -- Interrupt
    if toggle('interrupts') and castable(SB.Pummel) and target.interrupt(70) then
     return cast(SB.Pummel)
    end

    if castable(SB.ShieldWall) and player.health.percent <= 15 then
        return cast(SB.ShieldWall, 'target')
    end

    if modifier.control and castable(SB.Shockwave) and toggle('leap') then
      return cast(SB.Shockwave, 'target')
    end

    if toggle('cooldowns') and castable(SB.Avatar) then
      return cast(SB.Avatar, 'target')
    end

    -- Get some HP back
    if castable(SB.VictoryRush) and player.health.percent <= 45 then
     return cast(SB.VictoryRush, 'target')
    end

    -- Shield Block - Always keep at least one of its charges rolling. Off the GCD. Save other charge for incoming damage.
    if spell(SB.ShieldBlock).charges > 1 and not buff(SB.ShieldBlock).up and target.distance <= 12 and player.power.rage.actual > 30 then
      return cast(SB.ShieldBlock)
    end

    if castable(SB.IgnorePain) and buff(SB.ShieldBlock).up and target.distance <= 20 and player.health.percent <= 65 and player.power.rage.actual > 40 then
      return cast(SB.IgnorePain)
    end

  	if castable(SB.ShieldSlam) then
  		return cast(SB.ShieldSlam)
  	end

    if castable(SB.ThunderClap) and target.distance <= 8 then
      return cast(SB.ThunderClap)
    end

    if castable(SB.DemoralizingShout) and target.distance <= 7 then
      return cast(SB.DemoralizingShout)
    end

    if castable(SB.Revenge) and buff(SB.RevengeBuff).up then
      return cast(SB.Revenge)
    end

    if castable(SB.Revenge) and player.power.rage.actual > 85 then
      return cast(SB.Revenge)
    end

    if castable(SB.Devastate) then
      return cast(SB.Devastate)
    end

    -- Use this area to print variables for testing
    -- print (-target.debuff(SB.ColossusSmashDebuff))
    -- print (-spell(SB.BladestormArms))

  end
end

local function resting()
  if modifier.shift and castable(SB.HeroicLeap) and toggle('leap') then
    return cast(SB.HeroicLeap, 'ground')
  end

  if player.buff(SB.BattleShout).down and castable(SB.BattleShout) then
      return cast(SB.BattleShout, 'player')
  end
 end

function interface()
  dark_addon.interface.buttons.add_toggle({
   name = 'leap',
   label = 'Leap',
   font = 'dark_addon_icon',
   on = {
     label = dark_addon.interface.icon('bars'),
     color = dark_addon.interface.color.green,
     color2 = dark_addon.interface.color.dark_green
   },
   off = {
     label = dark_addon.interface.icon('bars'),
     color = dark_addon.interface.color.grey,
     color2 = dark_addon.interface.color.dark_grey
   }
  })
end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.warrior.protection,
  name = 'Protection',
  label = 'Basic  Prot',
  combat = combat,
  resting = resting,
  interface = interface
})
