local ADDON_NAME = "DungeonQuestMarker"
local REFRESH_DELAY_MS = 150
local MARKER_TEXTURE = "/esoui/art/floatingmarkers/quest_available_icon.dds"

local DungeonQuestMarker = {
    markerPool = nil,
    activityToQuest = {},
}

-- Each skill-point quest is shared by the normal and veteran activity.
-- Activity IDs are used instead of names so every client language works.
local DUNGEONS = {
    { questId = 4202, activities = { 8, 305 } }, -- Arx Corinium
    { questId = 6896, activities = { 613, 614 } }, -- Bal Sunnar
    { questId = 4107, activities = { 4, 20 } }, -- Banished Cells I
    { questId = 4597, activities = { 300, 301 } }, -- Banished Cells II
    { questId = 7155, activities = { 640, 641 } }, -- Bedlam Veil
    { questId = 7323, activities = { 1039, 1040 } }, -- Black Gem Foundry
    { questId = 6576, activities = { 591, 592 } }, -- Black Drake Villa
    { questId = 4589, activities = { 15, 321 } }, -- Blackheart Haven
    { questId = 4469, activities = { 14, 320 } }, -- Blessed Crucible
    { questId = 5889, activities = { 324, 325 } }, -- Bloodroot Forge
    { questId = 6507, activities = { 509, 510 } }, -- Castle Thorn
    { questId = 4778, activities = { 10, 310 } }, -- City of Ash I
    { questId = 5120, activities = { 322, 267 } }, -- City of Ash II
    { questId = 6740, activities = { 599, 600 } }, -- Coral Aerie
    { questId = 5702, activities = { 295, 296 } }, -- Cradle of Shadows
    { questId = 4379, activities = { 9, 261 } }, -- Crypt of Hearts I
    { questId = 5113, activities = { 317, 318 } }, -- Crypt of Hearts II
    { questId = 4145, activities = { 5, 309 } }, -- Darkshade Caverns I
    { questId = 4641, activities = { 308, 21 } }, -- Darkshade Caverns II
    { questId = 6251, activities = { 435, 436 } }, -- Depths of Malatar
    { questId = 4346, activities = { 11, 319 } }, -- Direfrost Keep
    { questId = 6835, activities = { 608, 609 } }, -- Earthen Root Enclave
    { questId = 4336, activities = { 7, 23 } }, -- Elden Hollow I
    { questId = 4675, activities = { 303, 302 } }, -- Elden Hollow II
    { questId = 7235, activities = { 855, 856 } }, -- Exiled Redoubt
    { questId = 5891, activities = { 368, 369 } }, -- Falkreath Hold
    { questId = 6064, activities = { 420, 421 } }, -- Fang Lair
    { questId = 6249, activities = { 433, 434 } }, -- Frostvault
    { questId = 3993, activities = { 2, 299 } }, -- Fungal Grotto I
    { questId = 4303, activities = { 18, 312 } }, -- Fungal Grotto II
    { questId = 6837, activities = { 610, 611 } }, -- Graven Deep
    { questId = 6414, activities = { 503, 504 } }, -- Icereach
    { questId = 5136, activities = { 289, 268 } }, -- Imperial City Prison
    { questId = 6351, activities = { 496, 497 } }, -- Lair of Maarselok
    { questId = 7237, activities = { 857, 858 } }, -- Lep Seclusa
    { questId = 6188, activities = { 428, 429 } }, -- March of Sacrifices
    { questId = 6186, activities = { 426, 427 } }, -- Moon Hunter Keep
    { questId = 6349, activities = { 494, 495 } }, -- Moongrave Fane
    { questId = 7320, activities = { 1037, 1038 } }, -- Naj-Caldeesh
    { questId = 7105, activities = { 638, 639 } }, -- Oathsworn Pit
    { questId = 6683, activities = { 595, 596 } }, -- Red Petal Bastion
    { questId = 5403, activities = { 293, 294 } }, -- Ruins of Mazzatun
    { questId = 6065, activities = { 418, 419 } }, -- Scalecaller Peak
    { questId = 7027, activities = { 615, 616 } }, -- Scrivener's Hall
    { questId = 4733, activities = { 16, 313 } }, -- Selene's Web
    { questId = 6742, activities = { 601, 602 } }, -- Shipwright's Regret
    { questId = 4054, activities = { 3, 315 } }, -- Spindleclutch I
    { questId = 4555, activities = { 316, 19 } }, -- Spindleclutch II
    { questId = 6505, activities = { 507, 508 } }, -- Stone Garden
    { questId = 4538, activities = { 13, 311 } }, -- Tempest Island
    { questId = 6578, activities = { 593, 594 } }, -- The Cauldron
    { questId = 6685, activities = { 597, 598 } }, -- The Dread Cellar
    { questId = 6416, activities = { 505, 506 } }, -- Unhallowed Grave
    { questId = 4822, activities = { 17, 314 } }, -- Vaults of Madness
    { questId = 4432, activities = { 12, 304 } }, -- Volenfell
    { questId = 4246, activities = { 6, 306 } }, -- Wayrest Sewers I
    { questId = 4813, activities = { 22, 307 } }, -- Wayrest Sewers II
    { questId = 5342, activities = { 288, 287 } }, -- White-Gold Tower
}

local function BuildActivityLookup()
    for _, dungeon in ipairs(DUNGEONS) do
        for _, activityId in ipairs(dungeon.activities) do
            DungeonQuestMarker.activityToQuest[activityId] = dungeon.questId
        end
    end
end

local function IsQuestComplete(questId)
    local questName = GetCompletedQuestInfo(questId)
    return questName ~= nil and questName ~= ""
end

local function GetEntryData(entry)
    if entry == nil then
        return nil
    end

    if entry.node and entry.node.data then
        return entry.node.data
    end

    if entry.data then
        return entry.data
    end

    return nil
end

local function HasDungeonAccess(entryData)
    local requiredCollectible = entryData.requiredCollectible
    if not requiredCollectible or requiredCollectible == 0 then
        return true
    end

    -- Both permanent ownership and temporary ESO Plus access count. The
    -- Activity Finder provides the DLC collectible required by each dungeon.
    if GetCollectibleUnlockStateById and COLLECTIBLE_UNLOCK_STATE_LOCKED ~= nil then
        return GetCollectibleUnlockStateById(requiredCollectible)
            ~= COLLECTIBLE_UNLOCK_STATE_LOCKED
    end

    -- Compatibility fallback for a client that does not expose the collectible
    -- unlock API but has already calculated the Activity Finder lock state.
    return entryData.isLocked ~= true
end

local function CreateMarkerPool()
    DungeonQuestMarker.markerPool = ZO_ObjectPool:New(
        function(pool)
            local markerId = pool:GetNextFree()
            local marker = WINDOW_MANAGER:CreateControl(
                ADDON_NAME .. "Marker" .. markerId,
                GuiRoot,
                CT_TEXTURE
            )

            marker:SetTexture(MARKER_TEXTURE)
            marker:SetDimensions(20, 20)
            marker:SetMouseEnabled(false)
            return marker
        end,
        function(marker)
            marker:SetHidden(true)
            marker:ClearAnchors()
            marker:SetParent(GuiRoot)
        end
    )
end

local function AddMarker(entry)
    local marker = DungeonQuestMarker.markerPool:AcquireObject()
    marker:SetParent(entry)

    -- PledgeHighlights uses the first slot. Keeping this icon farther left lets
    -- both addons remain enabled without their markers covering each other.
    marker:SetAnchor(RIGHT, entry, LEFT, -40, 0)
    marker:SetHidden(false)
end

local function ProcessEntry(entry)
    local entryData = GetEntryData(entry)
    local activityId = entryData and entryData.id
    local questId = activityId and DungeonQuestMarker.activityToQuest[activityId]

    if questId and HasDungeonAccess(entryData) and not IsQuestComplete(questId) then
        AddMarker(entry)
        return 1
    end

    return 0
end

function DungeonQuestMarker.Refresh()
    if not DungeonQuestMarker.markerPool then
        return
    end

    DungeonQuestMarker.markerPool:ReleaseAllObjects()

    local controlPrefix = "ZO_DungeonFinder_KeyboardListSectionScrollChild"
    local normalContainer = GetControl(controlPrefix .. "Container", 2)
    if not normalContainer then
        return
    end

    local dungeonCount = normalContainer:GetNumChildren()
    for index = 1, dungeonCount do
        local normalEntry = GetControl(
            controlPrefix .. "ZO_ActivityFinderTemplateNavigationEntry_Keyboard",
            index
        )
        local veteranEntry = GetControl(
            controlPrefix .. "ZO_ActivityFinderTemplateNavigationEntry_Keyboard",
            index + dungeonCount
        )

        ProcessEntry(normalEntry)
        ProcessEntry(veteranEntry)
    end
end

local function RequestRefresh()
    zo_callLater(DungeonQuestMarker.Refresh, REFRESH_DELAY_MS)
end

local function OnAddonLoaded(_, addonName)
    if addonName ~= ADDON_NAME then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)

    BuildActivityLookup()
    CreateMarkerPool()

    if ZO_DungeonFinder_KeyboardListSection then
        ZO_PostHookHandler(
            ZO_DungeonFinder_KeyboardListSection,
            "OnEffectivelyShown",
            RequestRefresh
        )
    end

    EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED, RequestRefresh)
    EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_QUEST_COMPLETE, RequestRefresh)
    EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_SKILL_POINTS_CHANGED, RequestRefresh)
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
