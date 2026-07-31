MDSafeFilter = MDSafeFilter or {}

local SF = MDSafeFilter
SF.name = "MassDeconstructorSafeFilter"
SF.displayName = "Mass Deconstructor Safe Filter"
SF.version = "1.1.0"

local SET_TYPE_ARENA = LIBSETS_SETTYPE_ARENA or 1
local SET_TYPE_MONSTER = LIBSETS_SETTYPE_MONSTER or 8
local SET_TYPE_IMPERIAL_CITY_MONSTER = LIBSETS_SETTYPE_IMPERIALCITY_MONSTER or 13
local SET_TYPE_CYRODIIL_MONSTER = LIBSETS_SETTYPE_CYRODIIL_MONSTER or 14

local defaults = {
    protectMythic = true,
    protectMonsterSets = true,
    protectArenaWeapons = true,
    showSummary = true,
}

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

    if SF.settings.protectMythic then
        local quality = GetItemLinkDisplayQuality(itemLink)
        if quality == ITEM_DISPLAY_QUALITY_MYTHIC_OVERRIDE then
            return true, "mythic"
        end
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
        Print("Mass Deconstructor was not found; protection hook was not installed.")
        return false
    end

    if SF.hookInstalled then
        return true
    end

    local originalStartDeconstruction = MD.StartDeconstruction

    MD.StartDeconstruction = function(...)
        local originalAddItem = AddItemToDeconstructMessage
        local excluded = { mythic = 0, monster = 0, arena = 0, seen = {} }

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
            local total = excluded.mythic + excluded.monster + excluded.arena
            if total > 0 then
                Print(string.format(
                    "Excluded %d item(s): mythic %d, monster sets %d, arena weapons %d.",
                    total,
                    excluded.mythic,
                    excluded.monster,
                    excluded.arena
                ))
            end
        end

        if not results[1] then
            Print("Mass Deconstructor error: " .. tostring(results[2]))
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
                Print("Mass Deconstructor list error: " .. tostring(results[2]))
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
            text = "Extra safety exclusions applied only to Mass Deconstructor. Manual deconstruction and item locks are not changed.",
        },
        {
            type = "checkbox",
            name = "Protect mythic items",
            tooltip = "Exclude orange mythic items, such as the Ring of the Pale Order. Gold legendary items are not protected by this option.",
            getFunc = function() return SF.settings.protectMythic end,
            setFunc = function(value) SF.settings.protectMythic = value end,
            default = defaults.protectMythic,
        },
        {
            type = "checkbox",
            name = "Protect monster sets",
            tooltip = "Exclude dungeon, Imperial City, and Cyrodiil monster-set pieces.",
            getFunc = function() return SF.settings.protectMonsterSets end,
            setFunc = function(value) SF.settings.protectMonsterSets = value end,
            default = defaults.protectMonsterSets,
        },
        {
            type = "checkbox",
            name = "Protect arena weapons",
            tooltip = "Exclude weapons and shields from arena sets whose maximum bonus requires one or two equipped pieces.",
            getFunc = function() return SF.settings.protectArenaWeapons end,
            setFunc = function(value) SF.settings.protectArenaWeapons = value end,
            default = defaults.protectArenaWeapons,
        },
        {
            type = "checkbox",
            name = "Show exclusion summary in chat",
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
                "mythic=%s, monster=%s, arena=%s, hook=%s",
                tostring(SF.settings.protectMythic),
                tostring(SF.settings.protectMonsterSets),
                tostring(SF.settings.protectArenaWeapons),
                tostring(SF.hookInstalled == true)
            ))
        end
    end
end

EVENT_MANAGER:RegisterForEvent(SF.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
