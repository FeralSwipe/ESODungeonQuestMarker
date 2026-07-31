MDSafeFilter = MDSafeFilter or {}

local SF = MDSafeFilter
SF.name = "MassDeconstructorSafeFilter"
SF.displayName = "Mass Deconstructor Safe Filter"
SF.version = "1.2.0"

local SET_TYPE_ARENA = LIBSETS_SETTYPE_ARENA or 1
local SET_TYPE_MONSTER = LIBSETS_SETTYPE_MONSTER or 8
local SET_TYPE_IMPERIAL_CITY_MONSTER = LIBSETS_SETTYPE_IMPERIALCITY_MONSTER or 13
local SET_TYPE_CYRODIIL_MONSTER = LIBSETS_SETTYPE_CYRODIIL_MONSTER or 14
local QUALITY_LEGENDARY = ITEM_DISPLAY_QUALITY_LEGENDARY or 5
local QUALITY_MYTHIC = ITEM_DISPLAY_QUALITY_MYTHIC_OVERRIDE or 6

local defaults = {
    protectMythic = true,
    protectLegendary = true,
    protectMonsterSets = true,
    protectArenaWeapons = true,
    showSummary = true,
}

local translations = {
    en = {
        description = "Extra safety exclusions applied only to Mass Deconstructor. Manual deconstruction and item locks are not changed.",
        protectMythic = "Protect mythic items",
        protectMythicTip = "Exclude orange mythic items, such as the Ring of the Pale Order.",
        protectLegendary = "Protect legendary items",
        protectLegendaryTip = "Exclude all gold legendary items. This option is independent from mythic, monster-set, and arena protection.",
        protectMonster = "Protect monster sets",
        protectMonsterTip = "Exclude dungeon, Imperial City, and Cyrodiil monster-set pieces.",
        protectArena = "Protect arena weapons",
        protectArenaTip = "Exclude weapons and shields from arena sets whose maximum bonus requires one or two equipped pieces.",
        showSummary = "Show exclusion summary in chat",
        hookMissing = "Mass Deconstructor was not found; protection hook was not installed.",
        summary = "Excluded %d item(s): mythic %d, legendary %d, monster sets %d, arena weapons %d.",
        deconstructError = "Mass Deconstructor error: ",
        listError = "Mass Deconstructor list error: ",
        status = "mythic=%s, legendary=%s, monster=%s, arena=%s, hook=%s, language=%s",
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
        showSummary = "Zusammenfassung der Ausschlüsse im Chat anzeigen",
        hookMissing = "Mass Deconstructor wurde nicht gefunden; der Schutz konnte nicht aktiviert werden.",
        summary = "%d Gegenstand/Gegenstände ausgeschlossen: mythisch %d, legendär %d, Monstersets %d, Arenawaffen %d.",
        deconstructError = "Fehler in Mass Deconstructor: ",
        listError = "Fehler in der Mass-Deconstructor-Liste: ",
        status = "mythisch=%s, legendär=%s, monster=%s, arena=%s, schutz=%s, sprache=%s",
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
        showSummary = "Afficher le résumé des exclusions dans le chat",
        hookMissing = "Mass Deconstructor est introuvable ; la protection n'a pas été installée.",
        summary = "%d objet(s) exclu(s) : mythiques %d, légendaires %d, ensembles de monstre %d, armes d'arène %d.",
        deconstructError = "Erreur Mass Deconstructor : ",
        listError = "Erreur de liste Mass Deconstructor : ",
        status = "mythique=%s, légendaire=%s, monstre=%s, arène=%s, protection=%s, langue=%s",
    },
    ru = {
        description = "Дополнительные защитные исключения только для Mass Deconstructor. Ручной разбор и блокировки предметов не изменяются.",
        protectMythic = "Защищать мифические предметы",
        protectMythicTip = "Исключать оранжевые мифические предметы, например Кольцо Бледного ордена.",
        protectLegendary = "Защищать легендарные предметы",
        protectLegendaryTip = "Исключать все золотые предметы легендарного качества. Настройка не зависит от защиты мифических предметов, монстр-сетов и арен.",
        protectMonster = "Защищать монстр-сеты",
        protectMonsterTip = "Исключать части монстр-сетов из подземелий, Имперского города и Сиродила.",
        protectArena = "Защищать оружие арен",
        protectArenaTip = "Исключать оружие и щиты комплектов арен, максимальный бонус которых требует один или два надетых предмета.",
        showSummary = "Показывать итог исключений в чате",
        hookMissing = "Mass Deconstructor не найден; защитный перехватчик не установлен.",
        summary = "Исключено предметов: %d. Мифические: %d, легендарные: %d, монстр-сеты: %d, оружие арен: %d.",
        deconstructError = "Ошибка Mass Deconstructor: ",
        listError = "Ошибка списка Mass Deconstructor: ",
        status = "мифические=%s, легендарные=%s, монстр-сеты=%s, арены=%s, защита=%s, язык=%s",
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
        showSummary = "Mostrar resumen de exclusiones en el chat",
        hookMissing = "No se encontró Mass Deconstructor; no se instaló la protección.",
        summary = "%d objeto(s) excluido(s): míticos %d, legendarios %d, conjuntos de monstruo %d, armas de arena %d.",
        deconstructError = "Error de Mass Deconstructor: ",
        listError = "Error de lista de Mass Deconstructor: ",
        status = "mítico=%s, legendario=%s, monstruo=%s, arena=%s, protección=%s, idioma=%s",
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
        showSummary = "在聊天中显示排除摘要",
        hookMissing = "未找到 Mass Deconstructor；未安装保护挂钩。",
        summary = "已排除 %d 件物品：神话 %d，传奇 %d，怪物套装 %d，竞技场武器 %d。",
        deconstructError = "Mass Deconstructor 错误：",
        listError = "Mass Deconstructor 列表错误：",
        status = "神话=%s，传奇=%s，怪物套装=%s，竞技场=%s，保护=%s，语言=%s",
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
        showSummary = "除外結果をチャットに表示",
        hookMissing = "Mass Deconstructor が見つからないため、保護フックを設定できませんでした。",
        summary = "%d 個のアイテムを除外：秘術 %d、伝説 %d、モンスターセット %d、アリーナ武器 %d。",
        deconstructError = "Mass Deconstructor エラー：",
        listError = "Mass Deconstructor リストエラー：",
        status = "秘術=%s、伝説=%s、モンスター=%s、アリーナ=%s、保護=%s、言語=%s",
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

-- Returns true plus a short reason when Mass Deconstructor must skip the item.
function SF.IsProtected(bagId, slotIndex)
    local itemLink = GetItemLink(bagId, slotIndex, LINK_STYLE_DEFAULT)
    if itemLink == nil or itemLink == "" then
        return false
    end

    local quality = GetItemLinkDisplayQuality(itemLink)
    if SF.settings.protectMythic and quality == QUALITY_MYTHIC then
        return true, "mythic"
    end

    if SF.settings.protectLegendary and quality == QUALITY_LEGENDARY then
        return true, "legendary"
    end

    local libSets = LibSets
    if libSets == nil or libSets.IsSetByItemLink == nil then
        return false
    end

    local isSet, _, setId, _, _, maxEquipped = libSets.IsSetByItemLink(itemLink)
    if not isSet or setId == nil then
        return false
    end

    local setType = libSets.GetSetType and libSets.GetSetType(setId) or nil

    if SF.settings.protectMonsterSets and IsMonsterSetType(setType) then
        return true, "monster"
    end

    if SF.settings.protectArenaWeapons
        and setType == SET_TYPE_ARENA
        and IsWeapon(itemLink)
        and maxEquipped ~= nil
        and maxEquipped <= 2 then
        return true, "arena"
    end

    return false
end

local function RemoveProtectedQueueItems()
    if MD == nil or type(MD.deconstructQueue) ~= "table" then
        return
    end

    for index = #MD.deconstructQueue, 1, -1 do
        local queuedItem = MD.deconstructQueue[index]
        if queuedItem ~= nil and SF.IsProtected(queuedItem.bagId, queuedItem.slotIndex) then
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
local function CallWithVirtualLocks(callback, excluded, ...)
    local originalIsItemPlayerLocked = IsItemPlayerLocked

    IsItemPlayerLocked = function(bagId, slotIndex)
        local protected, reason = SF.IsProtected(bagId, slotIndex)
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
        local excluded = { mythic = 0, legendary = 0, monster = 0, arena = 0, seen = {} }

        -- Mass Deconstructor builds its batch through this API. Intercepting it
        -- leaves normal/manual deconstruction untouched and does not lock items.
        AddItemToDeconstructMessage = function(bagId, slotIndex, quantity)
            local protected, reason = SF.IsProtected(bagId, slotIndex)
            if protected then
                RecordExcluded(excluded, bagId, slotIndex, reason, quantity)
                return false
            end
            return originalAddItem(bagId, slotIndex, quantity)
        end

        local results = CallWithVirtualLocks(originalStartDeconstruction, excluded, ...)
        AddItemToDeconstructMessage = originalAddItem

        -- Also protect the legacy one-at-a-time queue used by older paths.
        RemoveProtectedQueueItems()

        if SF.settings.showSummary then
            local total = excluded.mythic + excluded.legendary + excluded.monster + excluded.arena
            if total > 0 then
                Print(string.format(
                    T("summary"),
                    total,
                    excluded.mythic,
                    excluded.legendary,
                    excluded.monster,
                    excluded.arena
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
            local results = CallWithVirtualLocks(originalOnCrafting, nil, ...)
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

    local options = {
        {
            type = "description",
            text = T("description"),
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
            name = T("showSummary"),
            getFunc = function() return SF.settings.showSummary end,
            setFunc = function(value) SF.settings.showSummary = value end,
            default = defaults.showSummary,
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

    SLASH_COMMANDS["/mdsf"] = function(argument)
        argument = zo_strlower(zo_strtrim(argument or ""))
        if argument == "status" or argument == "" then
            Print(string.format(
                T("status"),
                tostring(SF.settings.protectMythic),
                tostring(SF.settings.protectLegendary),
                tostring(SF.settings.protectMonsterSets),
                tostring(SF.settings.protectArenaWeapons),
                tostring(SF.hookInstalled == true),
                languageCode
            ))
        end
    end
end

EVENT_MANAGER:RegisterForEvent(SF.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
