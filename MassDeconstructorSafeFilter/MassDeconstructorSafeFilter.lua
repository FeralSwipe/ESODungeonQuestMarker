MDSafeFilter = MDSafeFilter or {}

local SF = MDSafeFilter
SF.name = "MassDeconstructorSafeFilter"
SF.displayName = "Mass Deconstructor Safe Filter"
SF.version = "1.5.0"

local SET_TYPE_ARENA = LIBSETS_SETTYPE_ARENA or 1
local SET_TYPE_MONSTER = LIBSETS_SETTYPE_MONSTER or 8
local SET_TYPE_IMPERIAL_CITY_MONSTER = LIBSETS_SETTYPE_IMPERIALCITY_MONSTER or 13
local SET_TYPE_CYRODIIL_MONSTER = LIBSETS_SETTYPE_CYRODIIL_MONSTER or 14
local QUALITY_LEGENDARY = ITEM_DISPLAY_QUALITY_LEGENDARY or 5
local QUALITY_MYTHIC = ITEM_DISPLAY_QUALITY_MYTHIC_OVERRIDE or 6

-- Recommended U50 PvE/PvP collection. Names are documentation only; item
-- matching always uses the stable numeric setId returned by LibSets.
-- Both normal and Perfected variants are included where ESO uses separate IDs.
local currentMetaSetIds = {
    [29] = "Sergeant's Mail",
    [66] = "Robes of the Hist", -- commonly called "Hist Sap" by players
    [107] = "Wyrd Tree's Blessing",
    [127] = "Deadly Strike",
    [133] = "Buffer of the Swift",
    [147] = "Way of Martial Knowledge",
    [163] = "Bloodspawn",
    [164] = "Lord Warden",
    [180] = "Powerful Assault",
    [185] = "Spell Power Cure",
    [188] = "Storm Master",
    [198] = "Essence Thief",
    [208] = "Trial by Fire",
    [210] = "Mark of the Pariah",
    [235] = "Robes of Transmutation",
    [236] = "Vicious Death",
    [270] = "Slimecraw",
    [276] = "Tremorscale",
    [281] = "Armor of the Trainee",
    [314] = "Puncturing Remedy",
    [315] = "Stinging Slashes",
    [316] = "Caustic Arrow",
    [318] = "Grand Rejuvenation",
    [324] = "Daedric Trickery",
    [331] = "War Machine",
    [332] = "Master Architect",
    [336] = "Pillar of Nirn",
    [346] = "Jorvuld's Guidance",
    [353] = "Mechanical Acuity",
    [369] = "Merciless Charge",
    [373] = "Crushing Wall",
    [389] = "Arms of Relequen",
    [391] = "Vestment of Olorime",
    [393] = "Perfected Arms of Relequen",
    [395] = "Perfected Vestment of Olorime",
    [397] = "Balorgh",
    [403] = "Savage Werewolf",
    [413] = "Spectral Cloak",
    [414] = "Virulent Shot",
    [416] = "Mender's Ward",
    [425] = "Perfected Spectral Cloak",
    [426] = "Perfected Virulent Shot",
    [428] = "Perfected Mender's Ward",
    [436] = "Symphony of Blades",
    [455] = "Z'en's Redress",
    [456] = "Azureblight Reaper",
    [459] = "Maarselok",
    [474] = "Draugrkin's Grip",
    [475] = "Aegis Caller",
    [479] = "Kjalnar's Nightmare",
    [491] = "Dragon's Appetite",
    [496] = "Roaring Opportunist",
    [497] = "Perfected Roaring Opportunist",
    [503] = "Ring of the Wild Hunt",
    [516] = "Elemental Catalyst",
    [522] = "Perfected Merciless Charge",
    [526] = "Perfected Crushing Wall",
    [529] = "Perfected Puncturing Remedy",
    [530] = "Perfected Stinging Slashes",
    [531] = "Perfected Caustic Arrow",
    [533] = "Perfected Grand Rejuvenation",
    [557] = "Executioner's Blade",
    [563] = "Perfected Executioner's Blade",
    [575] = "Ring of the Pale Order",
    [576] = "Pearls of Ehlnofey",
    [577] = "Encratis's Behemoth",
    [585] = "Saxhleel Champion",
    [586] = "Sul-Xan's Torment",
    [589] = "Perfected Saxhleel Champion",
    [590] = "Perfected Sul-Xan's Torment",
    [593] = "Gaze of Sithis",
    [594] = "Harpooner's Wading Kilt",
    [596] = "Death Dealer's Fete",
    [602] = "Crimson Oath's Rive",
    [604] = "Rush of Agony",
    [609] = "Magma Incarnate",
    [610] = "Wretched Vitality",
    [616] = "Dark Convergence",
    [617] = "Plaguebreak",
    [622] = "Turning Tide",
    [625] = "Markyn Ring of Majesty",
    [627] = "Spaulder of Ruin",
    [629] = "Rallying Cry",
    [633] = "Nazaray",
    [634] = "Nunatak",
    [641] = "Serpent's Disdain",
    [646] = "Whorl of the Depths",
    [647] = "Coral Riptide",
    [648] = "Pearlescent Ward",
    [649] = "Pillager's Profit",
    [650] = "Perfected Pillager's Profit",
    [651] = "Perfected Pearlescent Ward",
    [652] = "Perfected Coral Riptide",
    [653] = "Perfected Whorl of the Depths",
    [654] = "Mora's Whispers",
    [657] = "Sea-Serpent's Coil",
    [658] = "Oakensoul Ring",
    [666] = "Archdruid Devyric",
    [676] = "Syrabane's Ward",
    [683] = "Roksa the Warped",
    [684] = "Runecarver's Blaze",
    [687] = "Ozezan the Inferno",
    [691] = "Cryptcanon Vestments",
    [694] = "Velothi Ur-Mage's Amulet",
    [702] = "Ansuul's Torment",
    [707] = "Perfected Ansuul's Torment",
    [736] = "Tarnished Nightmare",
    [738] = "The Blind",
    [754] = "Oakfather's Retribution",
    [762] = "The Saint and the Seducer",
    [767] = "Slivers of the Null Arca",
    [768] = "Lucent Echoes",
    [769] = "Xoryn's Masterpiece",
    [770] = "Perfected Xoryn's Masterpiece",
    [771] = "Perfected Lucent Echoes",
    [772] = "Perfected Slivers of the Null Arca",
    [775] = "Spattering Disjunction",
    [776] = "Pyrebrand",
    [777] = "Corpseburster",
    [781] = "Aerie's Cry",
    [792] = "Farstrider",
    [813] = "Monomyth Reforged",
    [848] = "Shattered Paths Signet",
    [850] = "Thousand Eyes",
    [855] = "Gorethief",
}

-- Sets from the older Alcast tank/healer/magicka/stamina guides that are not
-- part of the current U50 collection above. The tables are intentionally
-- disjoint so one item can match only one meta category.
local legacyMetaSetIds = {
    [21] = "Akaviri Dragonguard",
    [39] = "Alessian Order",
    [50] = "The Morag Tong",
    [75] = "Torug's Pact",
    [80] = "Hunding's Rage",
    [92] = "Kagrenac's Hope",
    [98] = "Necropotence",
    [110] = "Sanctuary",
    [122] = "Ebon Armory",
    [123] = "Hircine's Veneer",
    [124] = "The Worm's Raiment",
    [137] = "Berserking Warrior",
    [141] = "Healing Mage",
    [144] = "Twice-Fanged Serpent",
    [160] = "Burning Spellweave",
    [167] = "Nightflame",
    [168] = "Nerien'eth",
    [169] = "Valkyn Skoria",
    [170] = "Maw of the Infernal",
    [171] = "Eternal Warrior",
    [173] = "Vicious Serpent",
    [184] = "Brands of Imperium",
    [190] = "Scathing Mage",
    [196] = "Leeching Plate",
    [207] = "Law of Julianos",
    [212] = "Briarheart",
    [215] = "Elemental Succession",
    [231] = "Lunar Bastion",
    [232] = "Roar of Alkosh",
    [256] = "Mighty Chudan",
    [257] = "Velidreth",
    [266] = "Kra'gh",
    [267] = "Swarm Mother",
    [268] = "Sentinel of Rkugamz",
    [269] = "Chokethorn",
    [273] = "Ilambris",
    [274] = "Iceheart",
    [275] = "Stormfist",
    [278] = "The Troll King",
    [279] = "Selene",
    [280] = "Grothdarr",
    [288] = "Beekeeper's Gear",
    [289] = "Spinner's Garments",
    [292] = "Mother's Sorrow",
    [293] = "Plague Doctor",
    [301] = "Strength of the Automaton",
    [302] = "Leviathan",
    [304] = "Medusa",
    [317] = "Destructive Impact",
    [341] = "Earthgore",
    [342] = "Domihaus",
    [350] = "Zaan",
    [361] = "Perfected Concentrated Force",
    [362] = "Perfected Timeless Blessing",
    [367] = "Concentrated Force",
    [368] = "Timeless Blessing",
    [372] = "Thunderous Volley",
    [390] = "Mantle of Siroria",
    [394] = "Perfected Mantle of Siroria",
    [418] = "Spell Strategist",
    [422] = "Battalion Defender",
    [430] = "Tzogvin's Warband",
    [444] = "False God's Devotion",
    [445] = "Tooth of Lokkestiiz",
    [446] = "Claw of Yolnahkriin",
    [449] = "Perfected False God's Devotion",
    [450] = "Perfected Tooth of Lokkestiiz",
    [451] = "Perfected Claw of Yolnahkriin",
    [452] = "Hollowfang Thirst",
    [470] = "New Moon Acolyte",
    [471] = "Hiti's Hearth",
    [487] = "Winter's Respite",
    [505] = "Torc of Tonal Constancy",
    [521] = "Bloodlord's Embrace",
    [525] = "Perfected Thunderous Volley",
    [532] = "Perfected Destructive Impact",
    [562] = "Force Overflow",
    [568] = "Perfected Force Overflow",
    [570] = "Kinras's Wrath",
    [571] = "Drake's Rush",
    [574] = "Foolkiller's Ward",
    [584] = "Diamond's Victory",
    [587] = "Bahsei's Mania",
    [588] = "Stone-Talker's Oath",
    [591] = "Perfected Bahsei's Mania",
    [592] = "Perfected Stone-Talker's Oath",
    [603] = "Scorion's Feast",
    [661] = "Stone's Accord",
    [662] = "Rage of the Ursauk",
    [664] = "Grave Inevitability",
    [704] = "Transformative Hope",
    [705] = "Perfected Transformative Hope",
    [759] = "Ayleid Refuge",
    [760] = "Rourken Steamguards",
    [795] = "Jerensi's Bladestorm",
}

local defaults = {
    protectMythic = true,
    protectLegendary = true,
    protectMonsterSets = true,
    protectArenaWeapons = true,
    protectRecommendedU50Sets = true,
    protectLegacyMetaSets = true,
    protectPAWorkerResearch = true,
    protectResearchBoPTradeable = true,
    protectResearchBankItems = true,
    protectResearchRetraited = true,
    protectResearchCrafted = true,
    protectResearchReconstructed = true,
    protectResearchLegendary = true,
    protectResearchMythic = true,
    protectResearchSpecialSets = true,
    prioritizeResearchTraits = true,
    showSummary = true,
}

local translations = {
    en = {
        description = "Extra safety exclusions for Mass Deconstructor and PersonalAssistant Worker. Manual actions and item locks are not changed.",
        deconstructionHeader = "Mass Deconstructor protection",
        protectMythic = "Protect mythic items",
        protectMythicTip = "Exclude orange mythic items, such as the Ring of the Pale Order.",
        protectLegendary = "Protect legendary items",
        protectLegendaryTip = "Exclude all gold legendary items. This option is independent from mythic, monster-set, and arena protection.",
        protectMonster = "Protect monster sets",
        protectMonsterTip = "Exclude dungeon, Imperial City, and Cyrodiil monster-set pieces.",
        protectArena = "Protect arena weapons",
        protectArenaTip = "Exclude weapons and shields from arena sets whose maximum bonus requires one or two equipped pieces.",
        protectRecommended = "Protect current meta sets",
        protectRecommendedTip = "Exclude the current U50 PvE/PvP collection by stable setId, including normal and Perfected variants.",
        protectLegacy = "Protect legacy meta sets",
        protectLegacyTip = "Exclude additional sets from the older Alcast tank, healer, Magicka DPS, and Stamina DPS guides.",
        researchHeader = "PersonalAssistant Worker auto-research protection",
        protectResearchMaster = "Enable auto-research protection",
        protectResearchMasterTip = "Apply the options below only while PersonalAssistant Worker automatically selects a trait-research item. Manual research is not changed.",
        protectResearchBoP = "Protect tradeable Bind-on-Pickup items",
        protectResearchBoPTip = "Do not let PAWorker research group-bound items while their trade window is still open.",
        protectResearchBank = "Protect bank items",
        protectResearchBankTip = "Do not let PAWorker auto-research items from the bank or ESO Plus bank.",
        protectResearchRetraited = "Protect transmuted-trait items",
        protectResearchRetraitedTip = "Do not let PAWorker auto-research items whose trait was changed at a Transmute Station.",
        protectResearchCrafted = "Protect crafted items",
        protectResearchCraftedTip = "Do not let PAWorker auto-research player-crafted items.",
        protectResearchReconstructed = "Protect reconstructed items",
        protectResearchReconstructedTip = "Do not let PAWorker auto-research items reconstructed from Collections.",
        protectResearchLegendary = "Protect legendary items from auto-research",
        protectResearchLegendaryTip = "Do not let PAWorker auto-research gold legendary items.",
        protectResearchMythic = "Protect mythic items from auto-research",
        protectResearchMythicTip = "Do not let PAWorker auto-research orange mythic items.",
        protectResearchSpecial = "Protect arena weapons and monster sets",
        protectResearchSpecialTip = "Do not let PAWorker auto-research arena weapons or monster-set pieces whose full set bonus requires at most two pieces.",
        prioritizeResearchTraits = "Prioritize popular traits",
        prioritizeResearchTraitsTip = "Let PAWorker choose commonly used PvE/PvP traits first, useful traits second, and all remaining traits last.",
        showSummary = "Show exclusion summary in chat",
        hookMissing = "Mass Deconstructor was not found; protection hook was not installed.",
        summary = "Excluded %d item(s): mythic %d, legendary %d, monster sets %d, arena weapons %d, current meta %d, legacy meta %d.",
        deconstructError = "Mass Deconstructor error: ",
        listError = "Mass Deconstructor list error: ",
        status = "mythic=%s, legendary=%s, monster=%s, arena=%s, current=%s, legacy=%s, deconstruct-hook=%s, auto-research=%s, PAWorker-hook=%s, language=%s",
    },
    de = {
        description = "Zusätzliche Schutzausnahmen nur für Mass Deconstructor. Manuelles Zerlegen und Gegenstandssperren werden nicht verändert.",
        protectMythic = "Mythische Gegenstände schützen",
        protectMythicTip = "Schließt orange mythische Gegenstände aus, zum Beispiel den Ring des Fahlen Ordens.",
        protectLegendary = "Legendäre Gegenstände schützen",
        protectLegendaryTip = "Schließt alle goldenen legendären Gegenstände aus. Diese Option ist unabhängig vom Schutz für mythische Gegenstände, Monstersets und Arenen.",
        protectMonster = "Monstersets schützen",
        protectMonsterTip = "Schließt Teile von Monstersets aus Verliesen, der Kaiserstadt und Cyrodiil aus.",
        protectArena = "Arenawaffen schützen",
        protectArenaTip = "Schließt Waffen und Schilde aus Arenasets aus, deren maximaler Bonus ein oder zwei ausgerüstete Teile benötigt.",
        protectRecommended = "Aktuelle Meta-Sets schützen",
        protectRecommendedTip = "Schließt die aktuelle U50-PvE/PvP-Sammlung anhand stabiler setIds ein, einschließlich normaler und perfektionierter Varianten.",
        protectLegacy = "Frühere Meta-Sets schützen",
        protectLegacyTip = "Schließt zusätzliche Sets aus älteren Alcast-Guides für Tanks, Heiler, Magicka-DPS und Stamina-DPS aus.",
        showSummary = "Zusammenfassung der Ausschlüsse im Chat anzeigen",
        hookMissing = "Mass Deconstructor wurde nicht gefunden; der Schutz konnte nicht aktiviert werden.",
        summary = "%d Gegenstand/Gegenstände ausgeschlossen: mythisch %d, legendär %d, Monstersets %d, Arenawaffen %d, aktuelle Meta %d, frühere Meta %d.",
        deconstructError = "Fehler in Mass Deconstructor: ",
        listError = "Fehler in der Mass-Deconstructor-Liste: ",
        status = "mythisch=%s, legendär=%s, monster=%s, arena=%s, aktuell=%s, früher=%s, schutz=%s, sprache=%s",
    },
    fr = {
        description = "Exclusions de sécurité supplémentaires appliquées uniquement à Mass Deconstructor. Le démontage manuel et les verrous d'objets ne sont pas modifiés.",
        protectMythic = "Protéger les objets mythiques",
        protectMythicTip = "Exclut les objets mythiques orange, comme l'Anneau de l'Ordre pâle.",
        protectLegendary = "Protéger les objets légendaires",
        protectLegendaryTip = "Exclut tous les objets légendaires dorés. Cette option est indépendante de la protection des objets mythiques, ensembles de monstre et arènes.",
        protectMonster = "Protéger les ensembles de monstre",
        protectMonsterTip = "Exclut les pièces d'ensembles de monstre des donjons, de la Cité impériale et de Cyrodiil.",
        protectArena = "Protéger les armes d'arène",
        protectArenaTip = "Exclut les armes et boucliers des ensembles d'arène dont le bonus maximal demande une ou deux pièces équipées.",
        protectRecommended = "Protéger les ensembles méta actuels",
        protectRecommendedTip = "Exclut la collection JcE/JcJ U50 actuelle via des setId stables, y compris les variantes normales et perfectionnées.",
        protectLegacy = "Protéger les anciens ensembles méta",
        protectLegacyTip = "Exclut les ensembles supplémentaires des anciens guides Alcast pour tank, soigneur, DPS Magie et DPS Vigueur.",
        showSummary = "Afficher le résumé des exclusions dans le chat",
        hookMissing = "Mass Deconstructor est introuvable ; la protection n'a pas été installée.",
        summary = "%d objet(s) exclu(s) : mythiques %d, légendaires %d, ensembles de monstre %d, armes d'arène %d, méta actuelle %d, ancienne méta %d.",
        deconstructError = "Erreur Mass Deconstructor : ",
        listError = "Erreur de liste Mass Deconstructor : ",
        status = "mythique=%s, légendaire=%s, monstre=%s, arène=%s, actuel=%s, ancien=%s, protection=%s, langue=%s",
    },
    ru = {
        description = "Дополнительные защитные исключения для Mass Deconstructor и PersonalAssistant Worker. Ручные действия и блокировки предметов не изменяются.",
        deconstructionHeader = "Защита Mass Deconstructor",
        protectMythic = "Защищать мифические предметы",
        protectMythicTip = "Исключать оранжевые мифические предметы, например Кольцо Бледного ордена.",
        protectLegendary = "Защищать легендарные предметы",
        protectLegendaryTip = "Исключать все золотые предметы легендарного качества. Настройка не зависит от защиты мифических предметов, монстр-сетов и арен.",
        protectMonster = "Защищать монстр-сеты",
        protectMonsterTip = "Исключать части монстр-сетов из подземелий, Имперского города и Сиродила.",
        protectArena = "Защищать оружие арен",
        protectArenaTip = "Исключать оружие и щиты комплектов арен, максимальный бонус которых требует один или два надетых предмета.",
        protectRecommended = "Защищать актуальные метовые сеты",
        protectRecommendedTip = "Исключать актуальную U50-коллекцию PvE/PvP по устойчивым setId, включая обычные и совершенные варианты.",
        protectLegacy = "Защищать устаревшие метовые сеты",
        protectLegacyTip = "Исключать дополнительные сеты из старых гайдов Alcast для танка, хила, Magicka DPS и Stamina DPS.",
        researchHeader = "Защита автоизучения PersonalAssistant Worker",
        protectResearchMaster = "Включить защиту автоизучения",
        protectResearchMasterTip = "Применять параметры ниже только при автоматическом выборе предмета для изучения трейта в PAWorker. Ручное изучение не изменяется.",
        protectResearchBoP = "Защищать доступные для обмена BoP-предметы",
        protectResearchBoPTip = "Не позволять PAWorker изучать привязанные к группе предметы, пока ещё открыто окно обмена.",
        protectResearchBank = "Защищать предметы в банке",
        protectResearchBankTip = "Не позволять PAWorker автоматически изучать предметы из обычного банка и банка ESO Plus.",
        protectResearchRetraited = "Защищать предметы с изменённым трейтом",
        protectResearchRetraitedTip = "Не позволять PAWorker автоматически изучать предметы, чей трейт изменён на станции трансмутации.",
        protectResearchCrafted = "Защищать крафтовые предметы",
        protectResearchCraftedTip = "Не позволять PAWorker автоматически изучать созданные игроками предметы.",
        protectResearchReconstructed = "Защищать воссозданные предметы",
        protectResearchReconstructedTip = "Не позволять PAWorker автоматически изучать предметы, воссозданные из коллекции.",
        protectResearchLegendary = "Защищать легендарные предметы от автоизучения",
        protectResearchLegendaryTip = "Не позволять PAWorker автоматически изучать золотые предметы легендарного качества.",
        protectResearchMythic = "Защищать мифические предметы от автоизучения",
        protectResearchMythicTip = "Не позволять PAWorker автоматически изучать оранжевые мифические предметы.",
        protectResearchSpecial = "Защищать оружие арен и монстр-сеты",
        protectResearchSpecialTip = "Не позволять PAWorker автоматически изучать оружие арен и части монстр-сетов, полный бонус которых требует не более двух предметов.",
        prioritizeResearchTraits = "Сначала изучать востребованные трейты",
        prioritizeResearchTraitsTip = "PAWorker сначала выберет популярные PvE/PvP-трейты, затем полезные и только потом все оставшиеся.",
        showSummary = "Показывать итог исключений в чате",
        hookMissing = "Mass Deconstructor не найден; защитный перехватчик не установлен.",
        summary = "Исключено предметов: %d. Мифические: %d, легендарные: %d, монстр-сеты: %d, оружие арен: %d, актуальная мета: %d, устаревшая мета: %d.",
        deconstructError = "Ошибка Mass Deconstructor: ",
        listError = "Ошибка списка Mass Deconstructor: ",
        status = "мифические=%s, легендарные=%s, монстр-сеты=%s, арены=%s, актуальные=%s, устаревшие=%s, перехват-разбора=%s, автоизучение=%s, перехват-PAWorker=%s, язык=%s",
    },
    es = {
        description = "Exclusiones de seguridad adicionales aplicadas solo a Mass Deconstructor. El desguace manual y los bloqueos de objetos no cambian.",
        protectMythic = "Proteger objetos míticos",
        protectMythicTip = "Excluye objetos míticos naranjas, como el Anillo de la Orden Pálida.",
        protectLegendary = "Proteger objetos legendarios",
        protectLegendaryTip = "Excluye todos los objetos legendarios dorados. Esta opción es independiente de la protección de míticos, conjuntos de monstruo y arenas.",
        protectMonster = "Proteger conjuntos de monstruo",
        protectMonsterTip = "Excluye piezas de conjuntos de monstruo de mazmorras, la Ciudad Imperial y Cyrodiil.",
        protectArena = "Proteger armas de arena",
        protectArenaTip = "Excluye armas y escudos de conjuntos de arena cuya bonificación máxima requiere una o dos piezas equipadas.",
        protectRecommended = "Proteger conjuntos meta actuales",
        protectRecommendedTip = "Excluye la colección JcE/JcJ U50 actual mediante setId estables, incluidas las variantes normales y perfeccionadas.",
        protectLegacy = "Proteger conjuntos meta antiguos",
        protectLegacyTip = "Excluye conjuntos adicionales de las guías antiguas de Alcast para tanque, sanador, DPS de magia y DPS de aguante.",
        showSummary = "Mostrar resumen de exclusiones en el chat",
        hookMissing = "No se encontró Mass Deconstructor; no se instaló la protección.",
        summary = "%d objeto(s) excluido(s): míticos %d, legendarios %d, conjuntos de monstruo %d, armas de arena %d, meta actual %d, meta antigua %d.",
        deconstructError = "Error de Mass Deconstructor: ",
        listError = "Error de lista de Mass Deconstructor: ",
        status = "mítico=%s, legendario=%s, monstruo=%s, arena=%s, actual=%s, antiguo=%s, protección=%s, idioma=%s",
    },
    zh = {
        description = "仅对 Mass Deconstructor 应用额外的安全排除，不会更改手动分解或物品锁定。",
        protectMythic = "保护神话物品",
        protectMythicTip = "排除橙色神话物品，例如苍白教团戒指。",
        protectLegendary = "保护传奇物品",
        protectLegendaryTip = "排除所有金色传奇物品。此选项独立于神话物品、怪物套装和竞技场保护。",
        protectMonster = "保护怪物套装",
        protectMonsterTip = "排除地下城、帝都和西罗帝尔的怪物套装部件。",
        protectArena = "保护竞技场武器",
        protectArenaTip = "排除最大套装加成只需装备一件或两件的竞技场武器和盾牌。",
        protectRecommended = "保护当前主流套装",
        protectRecommendedTip = "通过稳定的 setId 排除当前 U50 PvE/PvP 套装，包括普通和完美版本。",
        protectLegacy = "保护旧版主流套装",
        protectLegacyTip = "排除旧版 Alcast 坦克、治疗、魔法 DPS 和耐力 DPS 指南中的其他套装。",
        showSummary = "在聊天中显示排除摘要",
        hookMissing = "未找到 Mass Deconstructor；未安装保护挂钩。",
        summary = "已排除 %d 件物品：神话 %d，传奇 %d，怪物套装 %d，竞技场武器 %d，当前主流 %d，旧版主流 %d。",
        deconstructError = "Mass Deconstructor 错误：",
        listError = "Mass Deconstructor 列表错误：",
        status = "神话=%s，传奇=%s，怪物套装=%s，竞技场=%s，当前=%s，旧版=%s，保护=%s，语言=%s",
    },
    jp = {
        description = "Mass Deconstructor にのみ追加の安全除外を適用します。手動解体やアイテムロックは変更しません。",
        protectMythic = "秘術アイテムを保護",
        protectMythicTip = "ペイル騎士団の指輪など、オレンジ色の秘術アイテムを除外します。",
        protectLegendary = "伝説アイテムを保護",
        protectLegendaryTip = "金色の伝説アイテムをすべて除外します。秘術、モンスターセット、アリーナの保護とは独立した設定です。",
        protectMonster = "モンスターセットを保護",
        protectMonsterTip = "ダンジョン、帝都、シロディールのモンスターセット部位を除外します。",
        protectArena = "アリーナ武器を保護",
        protectArenaTip = "最大ボーナスに装備数1～2個を必要とするアリーナセットの武器と盾を除外します。",
        protectRecommended = "現在のメタセットを保護",
        protectRecommendedTip = "通常版と完全版を含む現在のU50 PvE/PvPセットを、安定したsetIdで除外します。",
        protectLegacy = "旧メタセットを保護",
        protectLegacyTip = "旧Alcastのタンク、ヒーラー、Magicka DPS、Stamina DPSガイドの追加セットを除外します。",
        showSummary = "除外結果をチャットに表示",
        hookMissing = "Mass Deconstructor が見つからないため、保護フックを設定できませんでした。",
        summary = "%d 個のアイテムを除外：秘術 %d、伝説 %d、モンスターセット %d、アリーナ武器 %d、現在のメタ %d、旧メタ %d。",
        deconstructError = "Mass Deconstructor エラー：",
        listError = "Mass Deconstructor リストエラー：",
        status = "秘術=%s、伝説=%s、モンスター=%s、アリーナ=%s、現在=%s、旧=%s、保護=%s、言語=%s",
    },
}

local languageAliases = { ja = "jp", jp = "jp", zh = "zh", de = "de", en = "en", es = "es", fr = "fr", ru = "ru" }
local languageCode = zo_strlower(GetCVar("language.2") or "en")
languageCode = languageAliases[languageCode] or "en"
local activeTranslation = translations[languageCode]

local function T(key)
    return activeTranslation[key] or translations.en[key] or key
end

local function Print(message)
    d(string.format("|cD6B450[MDSafeFilter]|r %s", message))
end

local function IsWeapon(itemLink)
    local weaponType = GetItemLinkWeaponType(itemLink)
    return weaponType ~= nil and weaponType ~= WEAPONTYPE_NONE
end

local function IsMonsterSetType(setType)
    return setType == SET_TYPE_MONSTER
        or setType == SET_TYPE_IMPERIAL_CITY_MONSTER
        or setType == SET_TYPE_CYRODIIL_MONSTER
end

local function StoreProtectionResult(cache, cacheKey, isProtected, reason)
    if cache ~= nil and cacheKey ~= nil then
        cache[cacheKey] = { isProtected = isProtected, reason = reason }
    end
    return isProtected, reason
end

-- Single early-exit path for every protection category. A per-operation cache
-- lets the virtual lock, batch interceptor, and legacy queue share one lookup.
function SF.ShouldProtectItem(bagId, slotIndex, cache)
    local cacheKey = nil
    if cache ~= nil then
        cacheKey = tostring(bagId) .. ":" .. tostring(slotIndex)
        local cached = cache[cacheKey]
        if cached ~= nil then
            return cached.isProtected, cached.reason
        end
    end

    local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_DEFAULT)
    if itemLink == nil or itemLink == "" then
        return StoreProtectionResult(cache, cacheKey, false)
    end

    if SF.settings.protectMythic or SF.settings.protectLegendary then
        local quality = GetItemLinkDisplayQuality(itemLink)
        if SF.settings.protectMythic and quality == QUALITY_MYTHIC then
            return StoreProtectionResult(cache, cacheKey, true, "mythic")
        end

        if SF.settings.protectLegendary and quality == QUALITY_LEGENDARY then
            return StoreProtectionResult(cache, cacheKey, true, "legendary")
        end
    end

    if not SF.settings.protectMonsterSets
        and not SF.settings.protectArenaWeapons
        and not SF.settings.protectRecommendedU50Sets
        and not SF.settings.protectLegacyMetaSets then
        return StoreProtectionResult(cache, cacheKey, false)
    end

    local libSets = LibSets
    if libSets == nil or libSets.IsSetByItemLink == nil then
        return StoreProtectionResult(cache, cacheKey, false)
    end

    local isSet, _, setId, _, _, maxEquipped = libSets.IsSetByItemLink(itemLink)
    if not isSet or setId == nil then
        return StoreProtectionResult(cache, cacheKey, false)
    end

    local setType = nil
    if SF.settings.protectMonsterSets or SF.settings.protectArenaWeapons then
        setType = libSets.GetSetType and libSets.GetSetType(setId) or nil
    end

    if SF.settings.protectMonsterSets and IsMonsterSetType(setType) then
        return StoreProtectionResult(cache, cacheKey, true, "monster")
    end

    if SF.settings.protectArenaWeapons
        and setType == SET_TYPE_ARENA
        and IsWeapon(itemLink)
        and maxEquipped ~= nil
        and maxEquipped <= 2 then
        return StoreProtectionResult(cache, cacheKey, true, "arena")
    end

    if SF.settings.protectRecommendedU50Sets and currentMetaSetIds[setId] ~= nil then
        return StoreProtectionResult(cache, cacheKey, true, "currentMeta")
    end

    if SF.settings.protectLegacyMetaSets and legacyMetaSetIds[setId] ~= nil then
        return StoreProtectionResult(cache, cacheKey, true, "legacyMeta")
    end

    return StoreProtectionResult(cache, cacheKey, false)
end

-- Preserve the existing public helper name for compatibility with any macros
-- or companion addons that already call it.
SF.IsProtected = SF.ShouldProtectItem

local traitPriority = {}

local function SetTraitPriority(priority, ...)
    for index = 1, select("#", ...) do
        local traitType = select(index, ...)
        if traitType ~= nil then
            traitPriority[traitType] = priority
        end
    end
end

-- Priority 1: traits commonly requested by current PvE/PvP builds.
SetTraitPriority(1,
    ITEM_TRAIT_TYPE_ARMOR_DIVINES,
    ITEM_TRAIT_TYPE_ARMOR_REINFORCED,
    ITEM_TRAIT_TYPE_ARMOR_IMPENETRABLE,
    ITEM_TRAIT_TYPE_ARMOR_WELL_FITTED,
    ITEM_TRAIT_TYPE_ARMOR_INFUSED,
    ITEM_TRAIT_TYPE_ARMOR_STURDY,
    ITEM_TRAIT_TYPE_WEAPON_NIRNHONED,
    ITEM_TRAIT_TYPE_WEAPON_PRECISE,
    ITEM_TRAIT_TYPE_WEAPON_SHARPENED,
    ITEM_TRAIT_TYPE_WEAPON_INFUSED,
    ITEM_TRAIT_TYPE_WEAPON_CHARGED,
    ITEM_TRAIT_TYPE_WEAPON_POWERED,
    ITEM_TRAIT_TYPE_WEAPON_DEFENDING,
    ITEM_TRAIT_TYPE_JEWELRY_BLOODTHIRSTY,
    ITEM_TRAIT_TYPE_JEWELRY_INFUSED,
    ITEM_TRAIT_TYPE_JEWELRY_SWIFT,
    ITEM_TRAIT_TYPE_JEWELRY_TRIUNE
)

-- Priority 2: useful secondary, tanking, levelling, and support traits.
SetTraitPriority(2,
    ITEM_TRAIT_TYPE_ARMOR_NIRNHONED,
    ITEM_TRAIT_TYPE_ARMOR_TRAINING,
    ITEM_TRAIT_TYPE_WEAPON_TRAINING,
    ITEM_TRAIT_TYPE_WEAPON_DECISIVE,
    ITEM_TRAIT_TYPE_JEWELRY_HARMONY,
    ITEM_TRAIT_TYPE_JEWELRY_PROTECTIVE
)

local function GetTraitPriority(traitType)
    return traitPriority[traitType] or 3
end

local function GetAutoResearchCacheKey(bagId, slotIndex)
    local uniqueId = GetItemUniqueId and GetItemUniqueId(bagId, slotIndex) or nil
    if uniqueId ~= nil and Id64ToString ~= nil then
        return tostring(bagId) .. ":" .. tostring(slotIndex) .. ":" .. Id64ToString(uniqueId)
    end
    return tostring(bagId) .. ":" .. tostring(slotIndex) .. ":" .. tostring(GetItemLink(bagId, slotIndex, LINK_STYLE_DEFAULT))
end

-- One early-exit path for all PAWorker auto-research exclusions. Results are
-- cached by the item's unique id for the whole recursive auto-research run.
function SF.ShouldProtectAutoResearchItem(bagId, slotIndex, traitInformation, cache)
    if not SF.settings.protectPAWorkerResearch then
        return false
    end

    local cacheKey = GetAutoResearchCacheKey(bagId, slotIndex)
    local cached = cache and cache[cacheKey] or nil
    if cached ~= nil then
        return cached.isProtected, cached.reason
    end

    if SF.settings.protectResearchBoPTradeable and IsItemBoPAndTradeable(bagId, slotIndex) then
        return StoreProtectionResult(cache, cacheKey, true, "researchBoPTradeable")
    end

    if SF.settings.protectResearchBankItems
        and (bagId == BAG_BANK or bagId == BAG_SUBSCRIBER_BANK) then
        return StoreProtectionResult(cache, cacheKey, true, "researchBank")
    end

    if SF.settings.protectResearchRetraited
        and traitInformation == ITEM_TRAIT_INFORMATION_RETRAITED then
        return StoreProtectionResult(cache, cacheKey, true, "researchRetraited")
    end

    local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_DEFAULT)
    if itemLink == nil or itemLink == "" then
        return StoreProtectionResult(cache, cacheKey, false)
    end

    if SF.settings.protectResearchCrafted and IsItemLinkCrafted(itemLink) then
        return StoreProtectionResult(cache, cacheKey, true, "researchCrafted")
    end

    if SF.settings.protectResearchReconstructed and IsItemReconstructed(bagId, slotIndex) then
        return StoreProtectionResult(cache, cacheKey, true, "researchReconstructed")
    end

    if SF.settings.protectResearchLegendary or SF.settings.protectResearchMythic then
        local quality = GetItemLinkDisplayQuality(itemLink)
        if SF.settings.protectResearchLegendary and quality == QUALITY_LEGENDARY then
            return StoreProtectionResult(cache, cacheKey, true, "researchLegendary")
        end
        if SF.settings.protectResearchMythic and quality == QUALITY_MYTHIC then
            return StoreProtectionResult(cache, cacheKey, true, "researchMythic")
        end
    end

    if not SF.settings.protectResearchSpecialSets then
        return StoreProtectionResult(cache, cacheKey, false)
    end

    local libSets = LibSets
    if libSets == nil or libSets.IsSetByItemLink == nil then
        return StoreProtectionResult(cache, cacheKey, false)
    end

    local isSet, _, setId, _, _, maxEquipped = libSets.IsSetByItemLink(itemLink)
    if not isSet or setId == nil or maxEquipped == nil or maxEquipped > 2 then
        return StoreProtectionResult(cache, cacheKey, false)
    end

    local setType = libSets.GetSetType and libSets.GetSetType(setId) or nil
    if IsMonsterSetType(setType) then
        return StoreProtectionResult(cache, cacheKey, true, "researchMonster")
    end

    if setType == SET_TYPE_ARENA and IsWeapon(itemLink) then
        return StoreProtectionResult(cache, cacheKey, true, "researchArena")
    end

    return StoreProtectionResult(cache, cacheKey, false)
end

local RunPAWorkerResearchPasses

local function CallInPAWorkerResearchContext(state, callback, ...)
    local originalGetItemTraitInformation = GetItemTraitInformation
    local originalZoCallLater = zo_callLater

    GetItemTraitInformation = function(bagId, slotIndex)
        local traitInformation = originalGetItemTraitInformation(bagId, slotIndex)
        if traitInformation ~= ITEM_TRAIT_INFORMATION_CAN_BE_RESEARCHED
            and traitInformation ~= ITEM_TRAIT_INFORMATION_RETRAITED then
            return traitInformation
        end

        local protected = SF.ShouldProtectAutoResearchItem(
            bagId,
            slotIndex,
            traitInformation,
            state.protectionCache
        )
        if protected then
            return ITEM_TRAIT_INFORMATION_NONE or 0
        end

        if traitInformation == ITEM_TRAIT_INFORMATION_CAN_BE_RESEARCHED
            and state.activePriority ~= nil
            and GetTraitPriority(GetItemTrait(bagId, slotIndex)) ~= state.activePriority then
            return ITEM_TRAIT_INFORMATION_NONE or 0
        end

        return traitInformation
    end

    zo_callLater = function(delayedCallback, delayMilliseconds)
        if delayMilliseconds == 100 then
            state.selectionScheduled = true
        elseif delayMilliseconds == 1000 and state.suppressExit then
            return nil
        end

        if delayMilliseconds == 500 and SF.settings.prioritizeResearchTraits then
            return originalZoCallLater(function()
                return RunPAWorkerResearchPasses(state, delayedCallback)
            end, delayMilliseconds)
        end

        return originalZoCallLater(function(...)
            local delayedResults = CallInPAWorkerResearchContext(state, delayedCallback, ...)
            if not delayedResults[1] then
                error(delayedResults[2])
            end
            return unpack(delayedResults, 2)
        end, delayMilliseconds)
    end

    local results = { pcall(callback, ...) }
    GetItemTraitInformation = originalGetItemTraitInformation
    zo_callLater = originalZoCallLater
    return results
end

RunPAWorkerResearchPasses = function(state, callback, ...)
    local arguments = { ... }
    local lastPriority = SF.settings.prioritizeResearchTraits and 3 or 1

    for priority = 1, lastPriority do
        state.activePriority = SF.settings.prioritizeResearchTraits and priority or nil
        state.selectionScheduled = false
        state.suppressExit = priority < lastPriority

        local results = CallInPAWorkerResearchContext(state, callback, unpack(arguments))
        if not results[1] then
            error(results[2])
        end
        if state.selectionScheduled or priority == lastPriority then
            return unpack(results, 2)
        end
    end
end

local function InstallPAWorkerResearchHook()
    local personalAssistant = PersonalAssistant
    local worker = personalAssistant and personalAssistant.Worker or nil
    if worker == nil or type(worker.StartResearchTrait) ~= "function" then
        return false
    end

    if SF.paWorkerHookInstalled then
        return true
    end

    local originalStartResearchTrait = worker.StartResearchTrait
    worker.StartResearchTrait = function(...)
        if not SF.settings.protectPAWorkerResearch and not SF.settings.prioritizeResearchTraits then
            return originalStartResearchTrait(...)
        end

        return RunPAWorkerResearchPasses({ protectionCache = {} }, originalStartResearchTrait, ...)
    end

    SF.paWorkerHookInstalled = true
    return true
end

local function RemoveProtectedQueueItems(cache)
    if MD == nil or type(MD.deconstructQueue) ~= "table" then
        return
    end

    for index = #MD.deconstructQueue, 1, -1 do
        local queuedItem = MD.deconstructQueue[index]
        if queuedItem ~= nil and SF.ShouldProtectItem(queuedItem.bagId, queuedItem.slotIndex, cache) then
            table.remove(MD.deconstructQueue, index)
        end
    end
end

local function RecordExcluded(excluded, bagId, slotIndex, reason, quantity)
    if excluded == nil or reason == nil then
        return
    end

    excluded.seen = excluded.seen or {}
    local key = tostring(bagId) .. ":" .. tostring(slotIndex)
    if excluded.seen[key] then
        return
    end

    excluded.seen[key] = true
    excluded[reason] = (excluded[reason] or 0) + (quantity or 1)
end

-- Mass Deconstructor already respects ESO's player-lock check. Replace that
-- check only while it builds a queue, without changing the real item lock.
local function CallWithVirtualLocks(callback, excluded, cache, ...)
    local originalIsItemPlayerLocked = IsItemPlayerLocked

    IsItemPlayerLocked = function(bagId, slotIndex)
        local protected, reason = SF.ShouldProtectItem(bagId, slotIndex, cache)
        if protected then
            RecordExcluded(excluded, bagId, slotIndex, reason, 1)
            return true
        end
        return originalIsItemPlayerLocked(bagId, slotIndex)
    end

    local results = { pcall(callback, ...) }
    IsItemPlayerLocked = originalIsItemPlayerLocked
    return results
end

local function InstallMassDeconstructorHook()
    if MD == nil or type(MD.StartDeconstruction) ~= "function" then
        Print(T("hookMissing"))
        return false
    end

    if SF.hookInstalled then
        return true
    end

    local originalStartDeconstruction = MD.StartDeconstruction

    MD.StartDeconstruction = function(...)
        local originalAddItem = AddItemToDeconstructMessage
        local excluded = {
            mythic = 0,
            legendary = 0,
            monster = 0,
            arena = 0,
            currentMeta = 0,
            legacyMeta = 0,
            seen = {},
        }
        local protectionCache = {}

        -- Mass Deconstructor builds its batch through this API. Intercepting it
        -- leaves normal/manual deconstruction untouched and does not lock items.
        AddItemToDeconstructMessage = function(bagId, slotIndex, quantity)
            local protected, reason = SF.ShouldProtectItem(bagId, slotIndex, protectionCache)
            if protected then
                RecordExcluded(excluded, bagId, slotIndex, reason, quantity)
                return false
            end
            return originalAddItem(bagId, slotIndex, quantity)
        end

        local results = CallWithVirtualLocks(originalStartDeconstruction, excluded, protectionCache, ...)
        AddItemToDeconstructMessage = originalAddItem

        -- Also protect the legacy one-at-a-time queue used by older paths.
        RemoveProtectedQueueItems(protectionCache)

        if SF.settings.showSummary then
            local total = excluded.mythic
                + excluded.legendary
                + excluded.monster
                + excluded.arena
                + excluded.currentMeta
                + excluded.legacyMeta
            if total > 0 then
                Print(string.format(
                    T("summary"),
                    total,
                    excluded.mythic,
                    excluded.legendary,
                    excluded.monster,
                    excluded.arena,
                    excluded.currentMeta,
                    excluded.legacyMeta
                ))
            end
        end

        if not results[1] then
            Print(T("deconstructError") .. tostring(results[2]))
            return
        end

        return unpack(results, 2)
    end

    -- Mass Deconstructor registered its crafting event before this addon was
    -- loaded. Re-register the same handler through our virtual lock so its
    -- initial verbose list is filtered too.
    if type(MD.OnCrafting) == "function" then
        local originalOnCrafting = MD.OnCrafting
        MD.OnCrafting = function(...)
            local results = CallWithVirtualLocks(originalOnCrafting, nil, {}, ...)
            if not results[1] then
                Print(T("listError") .. tostring(results[2]))
                return
            end
            return unpack(results, 2)
        end

        EVENT_MANAGER:UnregisterForEvent(MD.name, EVENT_CRAFTING_STATION_INTERACT)
        EVENT_MANAGER:RegisterForEvent(MD.name, EVENT_CRAFTING_STATION_INTERACT, MD.OnCrafting)
    end

    if type(MD.ContinueWork) == "function" then
        local originalContinueWork = MD.ContinueWork
        MD.ContinueWork = function(...)
            RemoveProtectedQueueItems()
            return originalContinueWork(...)
        end
    end

    SF.hookInstalled = true
    return true
end

local function RegisterSettingsMenu()
    local LAM = LibAddonMenu2
    if LAM == nil then
        return
    end

    local panel = {
        type = "panel",
        name = SF.displayName,
        displayName = SF.displayName,
        author = "Codex for @FeralSwipe",
        version = SF.version,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local function IsAutoResearchProtectionDisabled()
        return not SF.settings.protectPAWorkerResearch
    end

    local options = {
        {
            type = "description",
            text = T("description"),
        },
        {
            type = "header",
            name = T("deconstructionHeader"),
        },
        {
            type = "checkbox",
            name = T("protectMythic"),
            tooltip = T("protectMythicTip"),
            getFunc = function() return SF.settings.protectMythic end,
            setFunc = function(value) SF.settings.protectMythic = value end,
            default = defaults.protectMythic,
        },
        {
            type = "checkbox",
            name = T("protectLegendary"),
            tooltip = T("protectLegendaryTip"),
            getFunc = function() return SF.settings.protectLegendary end,
            setFunc = function(value) SF.settings.protectLegendary = value end,
            default = defaults.protectLegendary,
        },
        {
            type = "checkbox",
            name = T("protectMonster"),
            tooltip = T("protectMonsterTip"),
            getFunc = function() return SF.settings.protectMonsterSets end,
            setFunc = function(value) SF.settings.protectMonsterSets = value end,
            default = defaults.protectMonsterSets,
        },
        {
            type = "checkbox",
            name = T("protectArena"),
            tooltip = T("protectArenaTip"),
            getFunc = function() return SF.settings.protectArenaWeapons end,
            setFunc = function(value) SF.settings.protectArenaWeapons = value end,
            default = defaults.protectArenaWeapons,
        },
        {
            type = "checkbox",
            name = T("protectRecommended"),
            tooltip = T("protectRecommendedTip"),
            getFunc = function() return SF.settings.protectRecommendedU50Sets end,
            setFunc = function(value) SF.settings.protectRecommendedU50Sets = value end,
            default = defaults.protectRecommendedU50Sets,
        },
        {
            type = "checkbox",
            name = T("protectLegacy"),
            tooltip = T("protectLegacyTip"),
            getFunc = function() return SF.settings.protectLegacyMetaSets end,
            setFunc = function(value) SF.settings.protectLegacyMetaSets = value end,
            default = defaults.protectLegacyMetaSets,
        },
        {
            type = "checkbox",
            name = T("showSummary"),
            getFunc = function() return SF.settings.showSummary end,
            setFunc = function(value) SF.settings.showSummary = value end,
            default = defaults.showSummary,
        },
        {
            type = "header",
            name = T("researchHeader"),
        },
        {
            type = "checkbox",
            name = T("protectResearchMaster"),
            tooltip = T("protectResearchMasterTip"),
            getFunc = function() return SF.settings.protectPAWorkerResearch end,
            setFunc = function(value) SF.settings.protectPAWorkerResearch = value end,
            default = defaults.protectPAWorkerResearch,
        },
        {
            type = "checkbox",
            name = T("prioritizeResearchTraits"),
            tooltip = T("prioritizeResearchTraitsTip"),
            getFunc = function() return SF.settings.prioritizeResearchTraits end,
            setFunc = function(value) SF.settings.prioritizeResearchTraits = value end,
            default = defaults.prioritizeResearchTraits,
        },
        {
            type = "checkbox",
            name = T("protectResearchBoP"),
            tooltip = T("protectResearchBoPTip"),
            getFunc = function() return SF.settings.protectResearchBoPTradeable end,
            setFunc = function(value) SF.settings.protectResearchBoPTradeable = value end,
            disabled = IsAutoResearchProtectionDisabled,
            default = defaults.protectResearchBoPTradeable,
        },
        {
            type = "checkbox",
            name = T("protectResearchBank"),
            tooltip = T("protectResearchBankTip"),
            getFunc = function() return SF.settings.protectResearchBankItems end,
            setFunc = function(value) SF.settings.protectResearchBankItems = value end,
            disabled = IsAutoResearchProtectionDisabled,
            default = defaults.protectResearchBankItems,
        },
        {
            type = "checkbox",
            name = T("protectResearchRetraited"),
            tooltip = T("protectResearchRetraitedTip"),
            getFunc = function() return SF.settings.protectResearchRetraited end,
            setFunc = function(value) SF.settings.protectResearchRetraited = value end,
            disabled = IsAutoResearchProtectionDisabled,
            default = defaults.protectResearchRetraited,
        },
        {
            type = "checkbox",
            name = T("protectResearchCrafted"),
            tooltip = T("protectResearchCraftedTip"),
            getFunc = function() return SF.settings.protectResearchCrafted end,
            setFunc = function(value) SF.settings.protectResearchCrafted = value end,
            disabled = IsAutoResearchProtectionDisabled,
            default = defaults.protectResearchCrafted,
        },
        {
            type = "checkbox",
            name = T("protectResearchReconstructed"),
            tooltip = T("protectResearchReconstructedTip"),
            getFunc = function() return SF.settings.protectResearchReconstructed end,
            setFunc = function(value) SF.settings.protectResearchReconstructed = value end,
            disabled = IsAutoResearchProtectionDisabled,
            default = defaults.protectResearchReconstructed,
        },
        {
            type = "checkbox",
            name = T("protectResearchLegendary"),
            tooltip = T("protectResearchLegendaryTip"),
            getFunc = function() return SF.settings.protectResearchLegendary end,
            setFunc = function(value) SF.settings.protectResearchLegendary = value end,
            disabled = IsAutoResearchProtectionDisabled,
            default = defaults.protectResearchLegendary,
        },
        {
            type = "checkbox",
            name = T("protectResearchMythic"),
            tooltip = T("protectResearchMythicTip"),
            getFunc = function() return SF.settings.protectResearchMythic end,
            setFunc = function(value) SF.settings.protectResearchMythic = value end,
            disabled = IsAutoResearchProtectionDisabled,
            default = defaults.protectResearchMythic,
        },
        {
            type = "checkbox",
            name = T("protectResearchSpecial"),
            tooltip = T("protectResearchSpecialTip"),
            getFunc = function() return SF.settings.protectResearchSpecialSets end,
            setFunc = function(value) SF.settings.protectResearchSpecialSets = value end,
            disabled = IsAutoResearchProtectionDisabled,
            default = defaults.protectResearchSpecialSets,
        },
    }

    LAM:RegisterAddonPanel(SF.name .. "Options", panel)
    LAM:RegisterOptionControls(SF.name .. "Options", options)
end

local function OnAddonLoaded(_, addonName)
    if addonName ~= SF.name then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(SF.name, EVENT_ADD_ON_LOADED)
    SF.settings = ZO_SavedVars:NewAccountWide(
        "MassDeconstructorSafeFilterSavedVars",
        1,
        nil,
        defaults,
        GetWorldName()
    )

    RegisterSettingsMenu()
    InstallMassDeconstructorHook()
    if not InstallPAWorkerResearchHook() then
        local paWorkerEventName = SF.name .. "PAWorker"
        EVENT_MANAGER:RegisterForEvent(paWorkerEventName, EVENT_ADD_ON_LOADED, function(_, loadedAddonName)
            if loadedAddonName == "PersonalAssistantWorker" and InstallPAWorkerResearchHook() then
                EVENT_MANAGER:UnregisterForEvent(paWorkerEventName, EVENT_ADD_ON_LOADED)
            end
        end)
    end

    SLASH_COMMANDS["/mdsf"] = function(argument)
        argument = zo_strlower(zo_strtrim(argument or ""))
        if argument == "status" or argument == "" then
            Print(string.format(
                T("status"),
                tostring(SF.settings.protectMythic),
                tostring(SF.settings.protectLegendary),
                tostring(SF.settings.protectMonsterSets),
                tostring(SF.settings.protectArenaWeapons),
                tostring(SF.settings.protectRecommendedU50Sets),
                tostring(SF.settings.protectLegacyMetaSets),
                tostring(SF.hookInstalled == true),
                tostring(SF.settings.protectPAWorkerResearch or SF.settings.prioritizeResearchTraits),
                tostring(SF.paWorkerHookInstalled == true),
                languageCode
            ))
        end
    end
end

EVENT_MANAGER:RegisterForEvent(SF.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
