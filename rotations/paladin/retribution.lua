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

local function combat()
  if not target.alive or not target.enemy then return end

  if castable(SB.FlashofLight) and -player.health <= 80 and buff(SB.SelflessHealer).count == 4 then
    return cast(SB.FlashofLight, 'player')
  end

  if toggle('cooldowns') and castable(SB.LayonHands) and -player.health <= 8 and not -debuff(SB.Forbearance) then
    return cast(SB.LayonHands, 'player')
  end

  if toggle('interrupts') and castable(SB.Rebuke) and target.interrupt(90) then
    return cast(SB.Rebuke)
  end

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


  if castable(SB.Inquisition) and (not -buff(SB.Inquisition) or buff(SB.Inquisition).remains <= 3) then
    return cast(SB.Inquisition)
  end

  ---- Avenging Wrath

  --  Inquisition should always be up before casting.
  if toggle('cooldowns') and not talent(TB.Crusade) and castable(SB.AvengingWrath) and -buff(SB.Inquisition) then
    return cast(SB.AvengingWrath)
  end
  if toggle('cooldowns') and not talent(TB.Crusade) and not talent(TB.Inquisition) and castable(SB.AvengingWrath) then
    return cast(SB.AvengingWrath)
  end
  --  Wake of Ashes should be used immediately after using  Avenging Wrath.
  if lastcast(SB.AvengingWrath) and talent(TB.WakeofAshes) and castable(SB.WakeofAshes) then
    return cast(SB.WakeofAshes)
  end

  ---- Crusade

  -- If you aren't using  Wake of Ashes, use with 4+ Holy Power stocked up to build stacks as quick as possible.
  if toggle('cooldowns') and talent(TB.Crusade) and not talent(TB.WakeofAshes) and castable(SB.Crusade) and -power.holypower >= 4 then
    return cast(SB.Crusade)
  end
  -- If you are using  Wake of Ashes, stack to 3 Holy Power, Use  Crusade then Templar's Verdict before getting back to 5 Holy Power with  Wake of Ashes.
  if toggle('cooldowns') and talent(TB.Crusade) and talent(TB.WakeofAshes) and castable(SB.Crusade) and -power.holypower >= 3 then
    return cast(SB.Crusade)
  end
  if lastcast(SB.Crusade) and talent(TB.WakeofAshes) and castable(SB.TemplarsVerdict) then
    return cast(SB.TemplarsVerdict)
  end
  if lastcast(SB.TemplarsVerdict) and talent(TB.WakeofAshes) and castable(SB.WakeofAshes) then
    return cast(SB.WakeofAshes)
  end
  -- If you are using  Execution Sentence, use 2 finishers then cast  Execution Sentence. This allows for maximum finishers at max  Crusade stacks within  Execution Sentence's window.
  if talent(TB.Crusade) and talent(TB.ExecutionSentence) and buff(SB.Crusade).count >= 10 and castable(SB.ExecutionSentence) then
    return cast(SB.ExecutionSentence)
  end

  ----  Templar's Verdict / Divine Storm (5 Holy Power)

  -- Wait to use if Execution Sentence will be up within the next 2 seconds or  Crusade will be up before you can get 4+ Holy Power once again.
  -- NYI

  -- Use immediately if you have 5 Holy Power
  if not toggle('multitarget', false) and -power.holypower == 5 and castable(SB.TemplarsVerdict) then
    return cast(SB.TemplarsVerdict)
  end
  if toggle('multitarget', false) and -power.holypower == 5 and castable(SB.DivineStorm) then
    return cast(SB.DivineStorm)
  end

  -- At 3-4 Holy Power if following spells/buffs are active:  Divine Purpose,  Avenging Wrath/ Crusade,  Execution Sentence.
  if not toggle('multitarget', false) and -power.holypower >= 4 and castable(SB.TemplarsVerdict) and (-buff(SB.DivinePurpose) or -buff(SB.AvengingWrath) or -buff(SB.Crusade) or -target.debuff(SB.ExecutionSentence)) then
    return cast(SB.TemplarsVerdict)
  end
  if toggle('multitarget', false) and -power.holypower >= 4 and castable(SB.DivineStorm) and (-buff(SB.DivinePurpose) or -buff(SB.AvengingWrath) or -buff(SB.Crusade) or -target.debuff(SB.ExecutionSentence)) then
    return cast(SB.DivineStorm)
  end

  ---- Wake of Ashes

  -- If you have 0 Holy Power or at 1 Holy Power if  Blade of Justice is not available.
  if talent(TB.WakeofAshes) and (-power.holypower == 0 or (-power.holypower == 1 and not castable(SB.BladeOfJustice))) and castable(SB.WakeofAshes) then
    return cast(SB.WakeofAshes)
  end

  ---- Blade of Justice

  -- If you have 3 or less Holy Power. The goal is to keep  Blade of Justice on cooldown as much as possible.
  if -power.holypower <= 3 and castable(SB.BladeOfJustice) then
    return cast(SB.BladeOfJustice)
  end

  ---- Judgment

  -- If you have 4 Holy Power or you have 3 or less Holy Power and  Blade of Justice is on cooldown.
  if (-power.holypower == 4 or (-power.holypower <= 3 and not castable(SB.BladeOfJustice))) and castable(SB.Judgment) then
    return cast(SB.Judgment)
  end

  -- Hammer of Wrath

  -- If you have 4 Holy Power or if you have 3 or less Holy Power and  Blade of Justice is not available.
  if talent(TB.HammerofWrath) and (-power.holypower == 4 or (-power.holypower <= 3 and not castable(SB.BladeOfJustice))) and castable(SB.HammerofWrath) and ((-buff(SB.Crusade) or -buff(SB.AvengingWrath)) or -target.health <= 20) then
    return cast(SB.HammerofWrath)
  end

  --  Consecration > Crusader Strike

  -- If everything else is on cooldown and you have 4 or less Holy Power.
  if -power.holypower <= 4 and castable(SB.ConsecrationRet) and toggle('multitarget', false) then
    return cast(SB.ConsecrationRet)
  end

  if -power.holypower <= 4 and castable(SB.CrusaderStrike)then
    return cast(SB.CrusaderStrike)
  end

  ----  Templar's Verdict/ Divine Storm (3-4 Holy Power)

  -- Wait to use if  Execution Sentence will be up within the next 2 seconds or  Crusade will be up before you can get 4+ Holy Power once again.
  if -power.holypower <= 4 and ((talent(TB.ExecutionSentence) and -spell(SB.ExecutionSentence) >= 2) or (talent(TB.Crusade) and -spell(SB.Crusade) >= 3)) and castable(SB.TemplarsVerdict) and not toggle('multitarget') then
    return cast(SB.TemplarsVerdict)
  end
  if -power.holypower <= 4 and ((talent(TB.ExecutionSentence) and -spell(SB.ExecutionSentence) >= 2) or (talent(TB.Crusade) and -spell(SB.Crusade) >= 3)) and castable(SB.DivineStorm) and toggle('multitarget') then
    return cast(SB.DivineStorm)
  end

  if -power.holypower <= 4 and (not talent(TB.ExecutionSentence) and not talent(TB.Crusade)) and castable(SB.TemplarsVerdict) and not toggle('multitarget', false) then
    return cast(SB.TemplarsVerdict)
  end

  if -power.holypower <= 4 and (not talent(TB.ExecutionSentence) and not talent(TB.Crusade)) and castable(SB.DivineStorm) and toggle('multitarget', false) then
    return cast(SB.DivineStorm)
  end

  if -power.holypower == 5 and castable(SB.TemplarsVerdict) then

    return cast(SB.TemplarsVerdict)
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

dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.paladin.retribution,
  name = 'retribution',
  label = 'Bundled Retribution',
  combat = combat,
  resting = resting,
  interface = interface
})
