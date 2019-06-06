-- Outlaw for 8.1 by Rotations - 10/2018
-- Talents: 2 1 1 2 3 2 2
-- Holding Alt = 
-- Holding Shift = 

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.rogue

local function combat()

  if target.alive and target.enemy and player.alive and not -player.buff(SB.Stealth) and not -player.buff(SB.Vanishbuff) then
    auto_attack()

  if -buff(SB.Opportunity) and -spell(SB.PistolShot) == 0 then
    return cast(SB.PistolShot)
  end

  if modifier.shift and -spell(SB.Sap) == 0 and mouseover.enemy and mouseover.alive then
    return cast(SB.Sap, 'mouseover')
end
  
-- Lets eval our buffs

  if -player.buff(SB.Ruthlessprecision) then rpb = 1 else rpb = 0 end
  if -player.buff(SB.GrandMelee) then gmb = 1 else gmb = 0 end
  if -player.buff(SB.Broadside) then bsb = 1 else bsb = 0 end
  if -player.buff(SB.SkullandCrossBones) then scb = 1 else scb = 0 end
  if -player.buff(SB.BurriedTreasure) then btb = 1 else btb = 0 end
  if -player.buff(SB.TrueBearings) then tbd = 1 else tbd = 0 end
  rollthebonestotal = rpb + gmb + bsb + scb + btb + tbd
  rtbtotal = gmb + rpb
--and rollthebonestotal < 2
if castable(SB.RolltheBones) and -spell(SB.RolltheBones) == 0  and player.power.combopoints.actual >= 4 and rtbtotal <= 0 then
      rpb = 0
      gmb = 0
      bsb = 0
      scb = 0 
      btb = 0
      tbd = 0
    return cast(SB.RolltheBones)
  end



 local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Ambush', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
    end

  dark_addon.interface.status_extra('|cffFF0000 R#|r' .. dark_addon.version .. '         |cff5BFF33 RTB#|r' .. rollthebonestotal ..  ' |cff5BFF33 T#|r' .. inRange .. ' |cff5BFF33 D#|r ' .. target.distance)

  -- Interupts 

  if -spell(SB.Blind) == 0 and target.interrupt(100, false)  and -spell(SB.Kick) >= 1 and toggle('interrupts', false)  then
    return cast(SB.Blind, 'target')
  end

  if target.distance <= 5 and toggle('gouge', false) and -spell(SB.Gouge) == 0 then 
    return cast(SB.Gouge)
  end

  if target.distance <= 5 and toggle('gouge', false) and -spell(SB.Riposite) == 0 and -player.health < 70 then
    return cast(SB.Riposite)
  end

  if -spell(SB.Kick) == 0 and target.interrupt(100, false) and toggle('interrupts', false) and -spell(SB.Blind) >= 1  then
    return cast(SB.Kick, 'target')
  end

  if -player.health < 40 and -spell(SB.CrimsonVile) == 0 then 
    return cast(SB.CrimsonVile) 
  end

  if player.power.combopoints.actual < 5 and -spell(SB.GhostlyStrike) == 0 and talent(1,3) then
    return cast(SB.GhostlyStrike)
  end

  if inRange >= 2 and -spell(SB.BladeFlurry) == 0 and not -buff(SB.BladeFlurry) and spell(SB.BladeFlurry).charges > 0  then
    return cast(SB.BladeFlurry, 'target')
  end

  if -spell(SB.BladeRush) == 0 and talent(7,2) and not -buff(SB.AdrenalineRush) and modifier.shift then
    return cast(SB.BladeRush, 'target')
  end

  if -spell(SB.KillingSpree) == 0 and talent(7,3) and not -buff(SB.AdrenalineRush) then
    return cast(SB.KillingSpree)
  end

  if castable(SB.AdrenalineRush) and -spell(SB.AdrenalineRush) == 0 and toggle('cooldowns', false) then
    return cast(SB.AdrenalineRush)
  end

  if -spell(SB.MarkedforDeath) == 0 and toggle('cooldowns', false) and player.power.combopoints.actual <  2 and talent(3,3) then
    return cast(SB.MarkedforDeath)
  end

  if -spell(SB.BetweentheEyes) == 0 and player.power.combopoints.actual >= 3 then 
    return cast(SB.BetweentheEyes, 'target')
  end

    if -spell(SB.Dispatch) == 0 and player.power.combopoints.actual >= 3 then 
    return cast(SB.Dispatch, 'target')
  end

    return cast(SB.SinisterStrike, 'target')
  end
end

local function resting()
  

  if player.alive then 
-- If you need to assist another player (used for leveling) put the toon name below. 
  --if toggle('assist', false) then
 -- macro ('/assist PLAYERNAME')
 -- end

  if not -buff(SB.Stealth) and toggle('use_stealth', false) and player.moving then 
    return cast(SB.Stealth)
  end

  if target.distance <= 8 and -spell(SB.Ambush) == 0 and -buff(SB.Stealth) and target.enemy and modifier.control then
    return cast(SB.Ambush)
  end

if player.alive and target.enemy then 
 local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Ambush', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
  end
dark_addon.interface.status_extra('|cffFF0000 R#|r' .. dark_addon.version .. '         |cff5BFF33 RTB#|r'  ..  ' |cff5BFF33 T#|r' .. inRange .. ' |cff5BFF33 D#|r ' .. target.distance)

 if -spell(SB.BladeRush) == 0 and modifier.shift and target.distance <= 20 and target.enemy then
    return cast(SB.BladeRush, 'target')
 end

  -- Put great stuff here to do when your out of combat
end

end
end


function interface()
  dark_addon.interface.buttons.add_toggle({
    name = 'use_stealth',
    label = 'Auto use Stealth',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('low-vision'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('low-vision'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
     dark_addon.interface.buttons.add_toggle({
     name = 'assist',
    label = 'Assist other members of your party',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('hand-holding-heart'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('hand-holding'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  dark_addon.interface.buttons.add_toggle({
    name = 'gouge',
    label = 'use Gouge (must be in front of target)',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('angry'),
      color = dark_addon.interface.color.red,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.red, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('angry'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })


end

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.rogue.outlaw,
  name = 'outlaw',
  label = 'Private Outlaw',
  combat = combat,
  resting = resting,
  interface = interface
})


