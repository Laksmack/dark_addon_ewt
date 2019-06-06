local addon, dark_addon = ...

dark_addon.rotation.spellbooks.druid = {

	-- All specs
	AutoAttack = 6603,
	Typhoon = 132469,
	SkullBash = 106839,
	MightyBash = 175682,
	RemoveCorruption = 2782,
	Soothe = 2908,
	Barkskin = 22812,
	SurvivalInstincts = 61336,
	Moonfire = 8921,
	Regrowth = 8936,
	Clearcasting = 16870,
	Renewal = 108238,
	TravelForm = 783,
	Hibernate = 2637,
	
	-- Balance
	MoonkinForm = 24858,
	SolarWrath = 190984,
	Starsurge = 78674,
	LunarStrike = 194153,
	Sunfire = 93402,
	RemoveCorruption = 2782,
	Starfall = 191034,
	Soothe = 2908,
	SolarBeam = 78675,
	WarriorOfElune = 202425,
	IncarnationB = 102560,
	FuryOfElune = 202770,
	Flap = 164862,
	MoonfireDebuff = 164812,
	SunfireDebuff = 164815,
	LunarEmpowerment = 164547,
	SolarEmpowerment = 164545,
	
	-- Feral
	CatForm = 768,
	FerociousBite = 22568,
	Rake = 1822,
	RakeDebuff = 155722,
	ThrashCat = 106830,
	TigersFury = 5217,
	Prowl = 5215,
	Rip = 1079,
	SwipeCat =106785,
	Berserk = 106951,
	Maim = 22570,
	PredatorySwiftness = 16974,
	Shred = 5221,
	Dash = 1850,
	SavageRoar = 52610,
	ClearcastingF = 135700,
	
	-- Guardian
	BearForm = 5487,
	Maul = 6807,
	ThrashBear = 77758,
	ThrashDebuff = 192090,
	Ironfur = 192081,
	SwipeBear = 213771,
	FrenziedRegeneration = 22842,
	StampedingRoar = 106898,
	Mangle = 33917,
	BristlingFur = 155835,
	WildCharge = 16979,
	Pulverize = 80313,
	StampedingRoar = 77761,
	GalacticGuardian = 203964,
	
	-- Restoration
	Rejuvenation = 774,
	Swiftmend = 18562,
	Lifebloom = 33763,
	NaturesCure = 88423,
	WildGrowth = 48438,
	Innervate = 29166,
	Ironbark = 102342,
	Revitalize = 212040,
	Efflorescence = 145205,
	Tranquility = 740,
	CenarionWard = 102351,
	IncarnationR = 33891,
	Flourish = 197721,
	TranquilityBuff = 157982,
	UrsolsVortex = 102793,
}

dark_addon.rotation.dispellbooks.soothe = {
	-- Soothe
	[228318] = "Raging", -- Raging Affix	All	-	No	+100% damage dealt
	[255824] = "Fanatic's Rage", -- Dazar'ai Juggernaut	Atal'Dazar	12	Yes	+50% attack speed +20% dmg dealt, -50% mvespd
	[257476] = "Bestial Wrath", -- Irontide Mastiff	Freehold	60	No	+50% damage dealt
	[269976] = "Ancestral Fury", -- Shadow-Borne Champion	King's Rest	-	No	+100% damage dealt
	[262092] = "Inhale Vapors", -- Addled Thug	Motherlode	15	Yes	+50% damage dealt
	[272888] = "Ferocity", -- Ashvane Destroyer	Siege of Boralus	15	No	+65% haste
	[259975] = "Enrage", -- The Sand Queen	Tol Dagor	4	No	+5% damage, +5% haste, Stacks
	[265081] = "Warcry", -- Chosen Blood Matron	Underrot	30	No	+100% haste, AoE
	[266209] = "Wicked Frenzy", -- Fallen Deathspeaker	Underrot	8	Yes	+100% haste, Shadow damage on melee
	[257260] = "Enrage" -- Thornguard	Waycrest Manor	10	No	+25% damage dealt
}