local addon, dark_addon = ...

dark_addon.rotation.spellbooks.demonhunter = {
  --- Racials
  ArcaneTorrent = 202719,

  --- Common
  SpectralSight = 188501,
  Imprison = 217832,
  Glide = 131347,
  Disrupt = 183752,
  ConsumeMagic = 278326,

  --- Vengeance
  ThrowGlaiveVengeance = 204157,
  DemonSpikes = 203720,
  FieryBrand = 204021,
  ImmolationAura = 178740,
  InfernalStrike = 189110,
  Shear = 203782,
  Fracture = 263642,
  SigilOfFlame = 204513,
  SigilOfMisery = 202140,
  SigilOfSilence = 207682,
  SoulCleave = 228477,
  Torment = 185245,
  SpiritBomb = 247454, -- tid 22513
  SoulFragments = 203981,
  MetamorphosisVengeance = 187827,

  --- Havoc
  ThrowGlaive = 185123,
  Metamorphosis = 191427,
  BladeDance = 188499,
  Blur = 198589,
  ChaosNova = 179057,
  ChaosStrike = 162794,
  Darkness = 196718,
  DemonsBite = 162243,
  EyeBeam = 198013,
  FelRush = 195072,
  TormentHavoc = 281854,
  VengefulRetreat = 198793,
  FelBarrage = 258925, -- tid 21862
  Nemesis = 206491, -- tid 22547
  ImmolationAuraHavoc = 258920, -- tid 22799
  Felblade = 232893, -- tid 22416
  DeathSweep = 188499,
  Annihilation = 162794
}

dark_addon.rotation.talentbooks.demonhunter = {
  --- Vengeance
  AbyssalStrike = {1, 1},
  AgonizingFlames = {1, 2},
  RazorSpikes = {1, 3},
  FeastOfSouls = {2, 1},
  Fallout = {2, 2},
  BurningAlive = {2, 3},
  FlameCrash = {3, 1},
  CharredFlesh = {3, 2},
  Felblade = {3, 3},
  SoulRending = {4, 1},
  FeedTheDemon = {4, 2},
  Fracture = {4, 3},
  ConcentratedSigils = {5, 1},
  QuickenedSigils = {5, 2},
  SigilOfChains = {5, 3},
  Gluttony = {6, 1},
  SpiritBomb = {6, 2},
  FelDevastation = {6, 3},
  LastResort = {7, 1},
  VoidReaver = {7, 2},
  SoulBarrier = {7, 3},

  --- Havoc
  BlindFury = {1, 1},
  DemonicAppetite = {1, 2},
  FelbladeHavoc = {1, 3},
  InsatiableHunger = {2, 1},
  DemonBlades = {2, 2},
  ImmolationAura = {2, 3},
  TrailOfRuin = {3, 1},
  FelMastery = {3, 2},
  FelBarrage = {3, 3},
  --SoulRending = {4, 1},
  DesperateInstincts = {4, 2},
  Netherwalk = {4, 3},
  CycleOfHatred = {5, 1},
  FirstBlood = {5, 2},
  DarkSlash = {5, 3},
  UnleashedPower = {6, 1},
  MasterOfTheGlave = {6, 2},
  FelEruption = {6, 3},
  Demonic = {7, 1},
  Momentum = {7, 2},
  Nemesis = {7, 3}
}
