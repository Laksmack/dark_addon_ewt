local addon, dark_addon = ...

dark_addon.data.removables = {
  curse = {
    -- Siege of Boralus
    [257168] = { name = "Cursed Slash", count = 1, health = 100 }, -- Irontide Marauder Curse 10  No  +15% Damage taken
    -- Waycrest Manor
    [260703] = { name = "Unstable Runic Mark", count = 1, health = 100 }, -- Sister Malady  Curse 6 No  Minor DoT, 6yd AoE on expiry
    [263905] = { name = "Marking Cleave", count = 1, health = 100 }, -- Heartsbane Runeweaver Curse 6 Yes Moderate DoT
    [265880] = { name = "Dread Mark", count = 1, health = 100 }, -- Matron Alma Curse 6 No  Minor DoT, 6rd AoE on expiry
    [265882] = { name = "Lingering Dread", count = 1, health = 100 }, -- Matron Alma  Curse 5 No  Minor DoT, follows Dread Mark
    [264105] = { name = "Runic Mark", count = 1, health = 100 }, -- Marked Sister Curse 6 Yes Minor DoT, 6yrd AoE on expiry
    -- Atal'Dazar
    [252781] = { name = "Unstable Hex", count = 1, health = 100 }, -- Zanchuli Witch-Doctor Curse 5 Yes Polymorph, spreads on expiry
    [250096] = { name = "Wracking Pain", count = 1, health = 100 }, -- Yazma  Curse 6 Yes Moderate DoT
    -- King's Rest
    [270492] = { name = "Hex", count = 1, health = 100 }, -- Spectral Hex Priest  Curse 10  Yes Polymorph
    -- Underrot
    [265468] = { name = "Withering Curse", count = 1, health = 100 }, -- Bloodsworm Defiler  Curse 12  Yes -10% damage done, +10% damage taken, Stacks, Channeled
    [25771] = { name = "test", count = 1, health = 100 }
  },
  disease = {
    -- Freehold
    [258323] = { name = "Infected Wound", count = 1, health = 100 }, --Irontide Bonesaw  Disease 12  No  -20% healing received
    [257775] = { name = "Plague Step", count = 1, health = 100 }, --Bilge Rat Padfoot  Disease 18  No  Moderate DoT, -25% healing received
    -- Siege of Boralus
    [272588] = { name = "Rotting Wounds", count = 1, health = 100 }, -- Bilge Rat Cutthroat  Disease 15  No  -25% Healing received
    -- Waycrest Manor
    [264050] = { name = "Infected Thorn", count = 1, health = 100 }, -- Coven Thornshaper  Disease 8 Yes Moderate DoT
    [261440] = { name = "Virulent Pathogen", count = 1, health = 100 }, -- Lord Waycrest Disease 5 No Moderate DoT, -50% Movement spd, spreads to nearby players on expiry
    -- Atal'Dazar
    [250371] = { name = "Lingering Nausea", count = 1, health = 100 }, -- Vol'Kaal Disease 12  - Moderate DoT, Stacks
    -- King's Rest
    [267763] = { name = "Wretched Discharge", count = 1, health = 100 }, -- Half-finished Mummy  Disease 12  Yes Moderate DoT
    -- MOTHERLODE!!
    [263074] = { name = "Festering Bite", count = 1, health = 100 }, -- Feckless Assistant Disease 10  No  Moderate DoT
    -- Temple of Sethraliss
    [269686] = { name = "Plague", count = 1, health = 100 }, -- Plague Toad  Disease 10  Yes -Minor DoT, -50% Healing done, Stacks
    -- Underrot
    [278961] = { name = "Decaying Mind", count = 1, health = 100 }, -- Diseased Lasher Disease 30  Yes Stun, Absorbs healing, Removed when absorb removed
    [259714] = { name = "Decaying Spores", count = 1, health = 100 } -- Sporecaller Zancha Disease 6 No  Moderate DoT, Stacks
  },
  magic = {
    -- Freehold
    [257908] = { name = "Oiled Blade", count = 1, health = 100 }, --Irontide Officer  Magic 8 No  -75% healing received
    -- Shrine of the Storm
    [264560] = { name = "Choking Brine", count = 1, health = 100 }, --Aqu'sirr  Magic 20  No  Minor DoT, turns into swirls when dispelled
    [268233] = { name = "Electrifying Shock", count = 1, health = 100 },  --Guardian Elemental  Magic 20  No  Heavy DoT
    [268322] = { name = "Touch of the Drowned", count = 1, health = 100 }, --Drowned Depthbringer Magic 12  Yes Moderate DoT
    [268896] = { name = "Mind Rend", count = 1, health = 100 }, --Lord Stormsong  Magic 10  No  Minor DoT, -50% Movement Speed
    [269104] = { name = "Explosive Void", count = 1, health = 100 },  --Lord Stormsong  Magic 4 Yes Stun
    [267034] = { name = "Whispers of Power", count = 1, health = 100 }, --Vol'zith  Magic N/A No  +20% dmg / healing, can't be healed above X%, Stacks
    -- Siege of Boralus
    [272571] = { name = "Choking Waters", count = 1, health = 100 }, -- Bilge Rat Tempest Magic 6 Yes Moderate DoT, Silence
    [274991] = { name = "Putrid Waters", count = 1, health = 100 }, -- Viq'Goth Magic 30  No  Minor DoT, knocks back nearby allies if dispelled
    -- Tol Dagor
    [258128] = { name = "Debilitating Shout", count = 1, health = 100 }, -- Irontide Thug Magic 8 Yes -50% damage dealt
    [265889] = { name = "Torch Strike", count = 1, health = 100 }, -- Blacktooth Arsonist Magic 16  No  Minor DoT, Stacks
    [257791] = { name = "Howling Fear", count = 1, health = 100 }, -- Jes Howlis  Magic 6 Yes Fear
    [258864] = { name = "Suppression Fire", count = 1, health = 100 }, -- Ashvane Marine  Magic 12  No  Minor DoT
    [257028] = { name = "Fuselighter", count = 1, health = 100 }, -- Knight Captain Valyri  Magic 5 No  Minor DoT, explodes any barrels held
    [258917] = { name = "Righteous Flames", count = 1, health = 100 }, -- Ashvane Priest  Magic 8 Yes Minor DoT, Disorient
    -- Waycrest Manor
    [263891] = { name = "Grasping Thorns", count = 1, health = 100 }, -- Heartsbane Vinetwister Magic 4 Yes Stun
    [264378] = { name = "Fragment Soul", count = 1, health = 100 }, -- Coven Diviner  Magic 24  No  Minor DoT, but amplifies Consume Fragments cast so dispel quickly
    -- Atal'Dazar
    [253562] = { name = "Wildfire", count = 1, health = 100 }, -- Dazar'ai Augur  Magic 8 Yes Light DoT
    [255582] = { name = "Molten Gold", count = 1, health = 100 }, -- Priestess Alun'za  Magic 30  No  Moderate DoT
    [255041] = { name = "Terrifying Screech", count = 1, health = 100 }, -- Feasting Skyscreamer  Magic 6 Yes Fear
    [255371] = { name = "Terrifying Visage", count = 1, health = 100 }, -- Rezan  Magic 6 Yes Fear
    -- King's Rest
    [276031] = { name = "Pit of Despair", count = 1, health = 100 }, -- Minion of Zul Magic 6 Yes Fear
    --[265773] = { name = "Spit Gold", count = 1, health = 100 }, -- The Golden Serpent Magic 9 No  Heavy DoT, Spawns pool of gold on expiry
    --[270920] = { name = "Seduction", count = 1, health = 100 }, -- Queen Wasi Magic 30  No  Mind Control
    -- MOTHERLODE!!
    [280605] = { name = "Brain Freeze", count = 1, health = 100 }, -- Refreshment Vendor  Magic 6 Yes Stun
    [257337] = { name = "Shocking Claw", count = 1, health = 100 }, -- Coin-Operated Pummeler Magic 3 Yes Stun
    [270882] = { name = "Blazing Azerite", count = 1, health = 100 }, -- Coin-Operated Pummeler Magic 15  Yes +50% damage taken
    [268797] = { name = "Transmute: Enemy to Goo", count = 1, health = 100 }, -- Venture Co. Alchemist  Magic 10  Yes Polymorph
    [259856] = { name = "Chemical Burn", count = 1, health = 100 }, -- Rixxa Fluxflame  Magic 10  No  Moderate DoT
    -- Temple of Sethraliss
    [268013] = { name = "Flame Shock", count = 1, health = 100 }, -- Hoodoo Hexer Magic 15  No  Minor DoT
    [268008] = { name = "Snake Charm", count = 1, health = 100 }, -- Plague Doctor  Magic 15  No  Polymorph
    -- Underrot
    [272180] = { name = "Death Bolt", count = 1, health = 100 }, -- Grotesque Horror  Magic 6 Yes Moderate DoT, Stacks
    [272609] = { name = "Maddening Gaze", count = 1, health = 100 }, -- Faceless Corrupter  Magic 5 Yes Fear
    [269301] = { name = "Putrid Blood", count = 1, health = 100 } -- Unbound Abomination  Magic 12  No  Minor DoT, Stacks quickly
  },
  poison = {
    -- Freehold
    [257436] = { name = "Poisoning Strike", count = 1, health = 100 }, --Irontide Corsair Poison  12  No  Minor DoT, Stacks
    -- Siege of Boralus
    [275835] = { name = "Stinging Venom", count = 1, health = 100 }, -- Coating  Ashvane Invader  Poison  10  No  Moderate DoT, Stacks
    -- Tol Dagor
    [257777] = { name = "Crippling Shiv", count = 1, health = 100 }, -- Jes Howlis  Poison  12  No  Minor DoT, -50% movement speed
    -- Atal'Dazar
    [252687] = { name = "Venomfang Strike", count = 1, health = 100 }, -- Shadowblade Stalker Poison  8 No  Doubles nature damage taken
    -- King's Rest
    [270865] = { name = "Hidden Blade", count = 1, health = 100 }, -- King A'akul Poison  8 No  Spawns poison pool underneath afflicted player every 2s
    [271564] = { name = "Embalming Fluid", count = 1, health = 100 }, -- Embalming Fluid  Poison  20  No  Light DoT, -10% Movement speed, Stacks
    [270507] = { name = "Poison Barrage", count = 1, health = 100 }, -- Spectral Beastmaster  Poison  20  No  Moderate DoT
    [267273] = { name = "Poison Nova", count = 1, health = 100 }, -- Zanazal the Wise Poison  20  Yes Moderate DoT
    -- MOTHERLODE!!
    [269302] = { name = "Toxic Blades", count = 1, health = 100 }, -- Hired Assassin  Poison  6 Yes Minor DoT
    -- Temple of Sethraliss
    [273563] = { name = "Neurotoxin", count = 1, health = 100 }, -- Sandswept Marksman  Poison  8 No  Player sleeps for 5s if they move
    [272657] = { name = "Noxious Breath", count = 1, health = 100 }, -- Scaled Krolusk Rider  Poison  9 Yes Minor DoT
    [267027] = { name = "Cytotoxin", count = 1, health = 100 }, -- Venomous Ophidian  Poison  6 No  Moderate DoT
    [272699] = { name = "Venomous Spit", count = 1, health = 100 } -- Faithless Tender  Poison  9 No  Moderate DoT
  }
}
