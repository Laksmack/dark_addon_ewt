-- Arcane Mage for 8.1 by Rotations - 8/2018
-- Talents: 2 2 1 2 2 2 1
-- Holding Alt = Missles
-- Holding Shift = Arcane Explosion

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.mage

local function combat()

  if player.power.mana.percent <= 10 and toggle('burn', false) == true then
    macro('/dr toggle burn')
  end

  if player.power.mana.percent >= 90 and toggle('burn', false) == false then
    macro('/dr toggle burn')
  end

  if spell(SB.Evocation).current and player.power.mana.percent >= 95 then
    stopcast()
  end


  if target.alive and target.enemy and not player.channeling() then

    if spell(SB.ArcaneBlast).current and -power.arcanecharges == 4  and not toggle('burn', false) then
     stopcast()
    end
    
    if player.power.mana.percent <= 30 and -spell(SB.Evocation) == 0 then
      return cast(SB.Evocation, 'player')
    end

    if modifier.alt  then
      return cast(SB.ArcaneMissiles, 'target')
    end

    if modifier.shift  then
      return cast(SB.ArcaneExplosion, 'target')
    end

    if player.moving then
      return cast(SB.ArcaneBarrage)
    end

    if -spell(SB.ArcanePower) == 0 and  toggle('burn', false) and -power.arcanecharges == 4 then
      return cast(SB.ArcanePower, 'player')
    end

	  if -spell(SB.PrismaticBarrier) == 0 and not -buff(SB.PrismaticBarrier) and player.moving then
      return cast(SB.PrismaticBarrier, 'player')
	  end

  	if -spell(SB.PrismaticBarrier) == 0 and not -buff(SB.PrismaticBarrier) and -player.health < 50 and toggle('prismatic_barrier', false) then
    	return cast(SB.PrismaticBarrier, 'player')
  	end

    if -power.arcanecharges == 0 and not player.spell(SB.ChargedUp).lastcast and toggle('cooldowns', false) and -spell(SB.ChargedUp) == 0 and talent(4,2) then
	   	return cast(SB.ChargedUp, 'player')
  	end

    if -power.arcanecharges <= 2 and not player.spell(SB.ChargedUp).lastcast and toggle('cooldowns', false) and -spell(SB.ChargedUp) == 0 and talent(4,2) and toggle('burn', false) then
      return cast(SB.ChargedUp, 'player')
    end    

    if -buff(SB.ClearcastingBuff)  and not -player.buff(SB.ArcanePower) and player.power.mana.percent <= 50 then
      return cast(SB.ArcaneMissiles)
    end

    if -spell(SB.PrecenseofMind) == 0 and not -player.buff(SB.PrecenseofMind) and toggle('burn', false) then
      return cast(SB.PrecenseofMind, 'player')
    end

    if -power.arcanecharges < 4 then
		  return cast(SB.ArcaneBlast, 'target')
    end

    if -power.arcanecharges == 4 and not toggle('burn', false) then
		  return cast(SB.ArcaneBarrage, 'target')
    end

    if GetItemCooldown(159624) == 0 and toggle('cooldowns', false) then
           macro('/cast Rotcrusted Voodoo Doll')
    end

        return cast(SB.ArcaneBlast, 'target')
    end

end
-- local spellcasting, _, _, _, endTimeloc = UnitCastingInfo("player")
local function resting()
  local function OnEvent(self, event)
    local fone, ftwo, fthree, ffour, ffive, fsix, fseven, feight, fnine, ften, feleven, ftwelve, fthirteen, ffourteen, f15 = CombatLogGetCurrentEventInfo()
    --if ftwo =="SPELL_CAST_FAILED"  then
  dark_addon.interface.status_extra(f15)
  if ffive == "Sedaralys" then
  --print (f15)
end
      if ffive  == "Sed$aralys" and ftwo =="SPELL_CAST_FAILED" then
      print( fone)
      print( ftwo)
      print( fthree)
      print(ffour)
      print( ffive)
      print(fsix)
      print( fseven)
      print( feight)
      print(fnine)
      print( ften)
      print(feleven)
      print(ftwelve)
      print( fthirteen)
      print(ffourteen)
      print( f15)


    end
    if ftwo =="SPELL_CAST_FAILED" then
     -- print '------Hi Laks, My spell just failed to cast. Target not in front of me------------'
    end
  --print(CombatLogGetCurrentEventInfo())
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", OnEvent)
---------------------------------------------------------------------------
  

--------------------------------------------------------------------------------------------------------------------------------

	if -spell(SB.PrismaticBarrier) == 0 and not -buff(SB.PrismaticBarrier) and toggle('prismatic_barrier', false) and player.moving then
    	return cast(SB.PrismaticBarrier, 'player')
  end

  -- Put great stuff here to do when your out of combat
end
function interface()
   dark_addon.interface.buttons.add_toggle({
    name = 'prismatic_barrier',
    label = 'Ice Barrier Auto Cast',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('globe'),
      color = dark_addon.interface.color.orange,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'PB',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })

  dark_addon.interface.buttons.add_toggle({
    name = 'aoe',
    label = 'Use Frozen Orb Auto',
    on = {
      label = 'AOE',
      color = dark_addon.interface.color.red,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'AOE',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })



  dark_addon.interface.buttons.add_toggle({
    name = 'burn',
    label = 'Burn Phase on / off',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('fire'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.blue, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('fire'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
  dark_addon.interface.buttons.add_toggle({
    name = 'polymorph',
    on = {
      label = 'PM',
      color = dark_addon.interface.color.green,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'PM',
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
end
dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.mage.arcane,
  name = 'arcane',
  label = 'Bundled Arcane',
  combat = combat,
  resting = resting,
  interface = interface
})

--{ "Pyroblast", { "player.buff(Kael'thas's Ultimate Ability)", "!player.buff(48108)", "!modifier.last(Pyroblast)", "!player.moving"}},
-- "player.spell(Fire Blast).charges < 1"
