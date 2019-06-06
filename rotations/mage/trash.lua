if target.castable(SB.LunarStrike) then
  if
    (player.buff(SB.SolarEmpowerment).count < 3 or player.buff(SB.SolarEmpowerment).down) and
      (power.astral.actual <= 86 or player.buff(SB.LunarEmpowerment).count == 3) and
      ((player.buff(SB.WarriorOfElune).up or player.buff(SB.LunarEmpowerment).up or
        enemyCount >= 2 and player.buff(SB.SolarEmpowerment).down) and
        (not az_ss or player.buff(burst).down or
          (not player.spell(SB.LunarStrike).lastcast and not talent(5, 3) or player(SB.SolarWrath).lastcast)) or
        az_ss and player.buff(burst).up and player.spell(SB.SolarWrath).lastcast)
   then
    return cast(SB.LunarStrike, "target")
  end
end
