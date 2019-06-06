-- Retribution Paladin for 8.1 by Dark - 8/2018
-- Talents: 2 3 3 3 1 1 3

local addon, dark_addon = ...
local SB = dark_addon.rotation.spellbooks.paladin
local TB = dark_addon.rotation.talentbooks.paladin

-- https://github.com/simulationcraft/simc/blob/bfa-dev/profiles/Tier21/T21_Paladin_Retribution.simc

local wake_opener_ES_CS = {
  complete = false,
  spells = {
    { spell = SB.BladeOfJustice, target = 'target' },
    { spell = SB.Judgment, target = 'target' },
    { spell = SB.Crusade, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' },
    { spell = SB.WakeofAshes, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' },
    { spell = SB.CrusaderStrike, target = 'target' },
    { spell = SB.ExecutionSentence, target = 'target' }
  }
}

local wake_opener_CS = {
  complete = false,
  spells = {
    { spell = SB.ShieldofVengeance, target = 'target' },
    { spell = SB.BladeOfJustice, target = 'target' },
    { spell = SB.Judgment, target = 'target' },
    { spell = SB.Crusade, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' },
    { spell = SB.WakeofAshes, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' },
    { spell = SB.CrusaderStrike, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' }
  }
}

local wake_opener_ES_HoW = {
  complete = false,
  spells = {
    { spell = SB.ShieldofVengeance, target = 'target' },
    { spell = SB.BladeOfJustice, target = 'target' },
    { spell = SB.Judgment, target = 'target' },
    { spell = SB.Crusade, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' },
    { spell = SB.WakeofAshes, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' },
    { spell = SB.HammerofWrath, target = 'target' },
    { spell = SB.ExecutionSentence, target = 'target' }
  }
}

local wake_opener_HoW = {
  complete = false,
  spells = {
    { spell = SB.ShieldofVengeance, target = 'target' },
    { spell = SB.BladeOfJustice, target = 'target' },
    { spell = SB.Judgment, target = 'target' },
    { spell = SB.Crusade, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' },
    { spell = SB.WakeofAshes, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' },
    { spell = SB.HammerofWrath, target = 'target' },
    { spell = SB.TemplarsVerdict, target = 'target' }
  }
}

local wake_opener_Inq = {
  complete = false,
  spells = {
    { spell = SB.ShieldofVengeance, target = 'target' },
    { spell = SB.BladeOfJustice, target = 'target' },
    { spell = SB.Judgment, target = 'target' },
    { spell = SB.Inquisition, target = 'target' },
    { spell = SB.AvengingWrath, target = 'target' },
    { spell = SB.WakeofAshes, target = 'target' }
  }
}

local function finishers()
  -- actions.finishers=variable,name=ds_castable,value=spell_targets.divine_storm>=3|!talent.righteous_verdict.enabled&talent.divine_judgment.enabled&spell_targets.divine_storm>=2|azerite.divine_right.enabled&target.health.pct<=20&buff.divine_right.down
  local ds_castable = toggle('multitarget') -- or not talent(1, 2) and talent(4, 1) and toggle('multitarget')
  -- actions.finishers+=/inquisition,if=buff.inquisition.down|buff.inquisition.remains<5&holy_power>=3|talent.execution_sentence.enabled&cooldown.execution_sentence.remains<10&buff.inquisition.remains<15|cooldown.avenging_wrath.remains<15&buff.inquisition.remains<20&holy_power>=3
  if castable(SB.Inquisition) and talent(TB.Inquisition) and not -buff(SB.Inquisition) or buff(SB.Inquisition).remains < 5 and -power.holypower >= 3 or talent(TB.ExecutionSentence) and -spell(SB.ExecutionSentence) < 10 and buff(SB.Inquisition).remains < 15 or -spell(SB.AvengingWrath) < 15 and buff(SB.Inquisition).remains < 20 and power.holypower >= 3 then
    return SB.Inquisition, 'target'
  end
  -- actions.finishers+=/execution_sentence,if=spell_targets.divine_storm<=3&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*2)
  if castable(SB.ExecutionSentence) and talent(TB.ExecutionSentence) and toggle('multitarget') and (not talent(TB.Crusade) or -spell(SB.Crusade) > 2) then
    return SB.ExecutionSentence, 'target'
  end
  -- actions.finishers+=/divine_storm,if=variable.ds_castable&buff.divine_purpose.react
  if ds_castable and -buff(SB.DivinePurpose) then
    return SB.DivineStorm, 'target'
  end
  -- actions.finishers+=/divine_storm,if=variable.ds_castable&(!talent.crusade.enabled|cooldown.crusade.remains>gcd*2)
  if ds_castable and (not talent(TB.Crusade) or -spell(SB.Crusade) > 2) then
    return SB.DivineStorm, 'target'
  end
  -- actions.finishers+=/templars_verdict,if=buff.divine_purpose.react&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd)
  if -buff(SB.DivinePurpose) and (not talent(TB.ExecutionSentence) or -spell(SB.ExecutionSentence) > 2) then
    return SB.TemplarsVerdict, 'target'
  end
  -- actions.finishers+=/templars_verdict,if=(!talent.crusade.enabled|cooldown.crusade.remains>gcd*2)&(!talent.execution_sentence.enabled|buff.crusade.up&buff.crusade.stack<10|cooldown.execution_sentence.remains>gcd*2)
  if (not talent(TB.Crusade) or -spell(SB.Crusade) > 2) and (not talent(TB.ExecutionSentence) or -buff(SB.Crusade) and buff(SB.Crusade).count < 10 or spell(SB.ExecutionSentence) > 2) then
    return SB.TemplarsVerdict, 'target'
  end
  return false
end
dark_addon.environment.hook(finishers)

local function combat()

  local HoW = (not talent(TB.HammerofWrath) or -target.health >= 20 and (not -buff(SB.AvengingWrath) or not -buff(SB.Crusade)))

  -- actions.opener=sequence,
  -- if=talent.wake_of_ashes.enabled&talent.crusade.enabled&talent.execution_sentence.enabled&!talent.hammer_of_wrath.enabled
  -- name=wake_opener_ES_CS:shield_of_vengeance:blade_of_justice:judgment:crusade:templars_verdict:wake_of_ashes:templars_verdict:crusader_strike:execution_sentence
  if toggle('opener') and talent(TB.WakeofAshes) and talent(TB.Crusade) and talent(TB.ExecutionSentence) and not talent(TB.HammerofWrath) and dosequence(wake_opener_ES_CS) then
    return sequence(wake_opener_ES_CS)
  end

  -- actions.opener+=/sequence,
  -- if=talent.wake_of_ashes.enabled&talent.crusade.enabled&!talent.execution_sentence.enabled&!talent.hammer_of_wrath.enabled,
  -- name=wake_opener_CS:shield_of_vengeance:blade_of_justice:judgment:crusade:templars_verdict:wake_of_ashes:templars_verdict:crusader_strike:templars_verdict
  if toggle('opener') and talent(TB.WakeofAshes) and talent(TB.Crusade) and not talent(TB.ExecutionSentence) and not talent(TB.HammerofWrath) and dosequence(wake_opener_CS) then
    return sequence(wake_opener_CS)
  end

  -- actions.opener+=/sequence,
  -- if=talent.wake_of_ashes.enabled&talent.crusade.enabled&talent.execution_sentence.enabled&talent.hammer_of_wrath.enabled,
  -- name=wake_opener_ES_HoW:shield_of_vengeance:blade_of_justice:judgment:crusade:templars_verdict:wake_of_ashes:templars_verdict:hammer_of_wrath:execution_sentence
  if toggle('opener') and talent(TB.WakeofAshes) and talent(TB.Crusade) and not talent(TB.ExecutionSentence) and not talent(TB.HammerofWrath) and dosequence(wake_opener_ES_HoW) then
    return sequence(wake_opener_ES_HoW)
  end

  -- actions.opener+=/sequence,
  -- if=talent.wake_of_ashes.enabled&talent.crusade.enabled&!talent.execution_sentence.enabled&talent.hammer_of_wrath.enabled,
  -- name=wake_opener_HoW:shield_of_vengeance:blade_of_justice:judgment:crusade:templars_verdict:wake_of_ashes:templars_verdict:hammer_of_wrath:templars_verdict
  if toggle('opener') and talent(TB.WakeofAshes) and talent(TB.Crusade) and not talent(TB.ExecutionSentence) and talent(TB.HammerofWrath) and dosequence(wake_opener_HoW) then
    return sequence(wake_opener_HoW)
  end

  -- actions.opener+=/sequence,
  -- if=talent.wake_of_ashes.enabled&talent.inquisition.enabled,
  -- name=wake_opener_Inq:shield_of_vengeance:blade_of_justice:judgment:inquisition:avenging_wrath:wake_of_ashes
  if toggle('opener') and talent(TB.WakeofAshes) and talent(TB.Inquisition) and dosequence(wake_opener_Inq) then
    return sequence(wake_opener_Inq)
  end


  -- actions.cooldowns=potion,if=(buff.bloodlust.react|buff.avenging_wrath.up|buff.crusade.up&buff.crusade.remains<25|target.time_to_die<=40)
  -- actions.cooldowns+=/lights_judgment,if=spell_targets.lights_judgment>=2|(!raid_event.adds.exists|raid_event.adds.in>75)
  -- actions.cooldowns+=/fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
  -- actions.cooldowns+=/shield_of_vengeance
  if toggle('cooldowns') and -spell(SB.ShieldofVengeance) == 0 then
    return cast(SB.ShieldofVengeance)
  end
  -- actions.cooldowns+=/avenging_wrath,if=buff.inquisition.up|!talent.inquisition.enabled
  if toggle('cooldowns') and (-buff(SB.Inquisition) or not talent(TB.Inquisition)) and -spell(SB.AvengingWrath) == 0 then
    return cast(SB.AvengingWrath)
  end
  -- actions.cooldowns+=/crusade,if=holy_power>=4
  if toggle('cooldowns') and -power.holypower >= 4 and -spell(SB.Crusade) == 0 then
    return cast(SB.Crusade)
  end

  -- actions.generators+=/call_action_list,name=finishers,if=holy_power>=5
  if -power.holypower >= 5 then
    local fspell, ftarget = finishers()
    if fspell then return cast(fspell, ftarget) end
  end

  -- actions.generators+=/wake_of_ashes,if=(!raid_event.adds.exists|raid_event.adds.in>20)&(holy_power<=0|holy_power=1&cooldown.blade_of_justice.remains>gcd)
  if -power.holypower <= 1 and -spell(SB.BladeOfJustice) > 1 then
    return cast(SB.WakeofAshes)
  end

  -- actions.generators+=/blade_of_justice,if=holy_power<=2|(holy_power=3&(cooldown.hammer_of_wrath.remains>gcd*2|variable.HoW))
  if castable(SB.BladeOfJustice) and -power.holypower <= 2 or (-power.holypower == 3 and (-spell(SB.HammerofWrath) > 2 or HoW)) then
    return cast(SB.BladeOfJustice)
  end

  -- actions.generators+=/judgment,if=holy_power<=2|(holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|variable.HoW))
  if -power.holypower <= 2 or (-power.holypower <= 4 and (-spell(SB.BladeOfJustice) > 2 or HoW)) then
    return cast(SB.Judgment)
  end

  -- actions.generators+=/hammer_of_wrath,if=holy_power<=4
  if -power.holypower <= 4 and talent(TB.HammerofWrath) and usable(SB.HammerofWrath) then
    return cast(SB.HammerofWrath)
  end

  -- actions.generators+=/consecration,if=holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2
  if usable(SB.Consecration) and -power.holypower <= 2 or -power.holypower <= 3 and -spell(SB.BladeOfJustice) > 2 or -power.holypower == 4 and -spell(SB.BladeOfJustice) > 2 and -spell(SB.Judgment) > 2 then
    return cast(SB.Consecration)
  end

  -- actions.generators+=/call_action_list,name=finishers,if=talent.hammer_of_wrath.enabled&(target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up)&(buff.divine_purpose.up|buff.crusade.stack<10)
  if talent(TB.HammerofWrath) and (-target.health <= 20 or -buff(SB.AvengingWrath) or -buff(SB.Crusade)) and (-buff(SB.DivinePurpose) or buff(SB.Crusade).count < 10) then
    local fspell, ftarget = finishers()
    if fspell then return cast(fspell, ftarget) end
  end

  -- actions.generators+=/crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2&cooldown.consecration.remains>gcd*2)
  if spell(SB.CrusaderStrike).fractionalcharges >= 1.75 and (-power.holypower <= 2 or -power.holypower <= 3 and -spell(SB.BladeOfJustice) > 2 or -power.holypower == 4 and -spell(SB.BladeOfJustice) > 2 and -spell(SB.Judgment) > 2 and -spell(SB.Consecration) > 2) then
    return cast(SB.CrusaderStrike)
  end

  -- actions.generators+=/call_action_list,name=finishers
  local fspell, ftarget = finishers()
  if fspell then return cast(fspell, ftarget) end

  -- actions.generators+=/crusader_strike,if=holy_power<=4
  if -power.holypower <= 4 then
    return cast(SB.CrusaderStrike)
  end
end

local function resting()
  resetsequence(wake_opener_ES_CS)
  resetsequence(wake_opener_CS)
  resetsequence(wake_opener_ES_HoW)
  resetsequence(wake_opener_HoW)
  resetsequence(wake_opener_Inq)
end

function interface()
  dark_addon.interface.buttons.add_toggle({
    name = 'opener',
    label = 'Opener',
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

dark_addon.rotation.register('retribution', combat, resting, interface)
