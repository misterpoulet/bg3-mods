Scenario = {}
Enemy = {}
Map = {}
Item = {}
GameMode = {}
StoryBypass = {}
Unlock = {}

function LogRandom(key, value, max)
    if not max then
        max = 10
    end

    if not PersistentVars.RandomLog[key] then
        PersistentVars.RandomLog[key] = {}
    end

    table.insert(PersistentVars.RandomLog[key], value)
    if #PersistentVars.RandomLog[key] > max then
        table.remove(PersistentVars.RandomLog[key], 1)
    end
end

GameState.OnSave(function()
    PersistentVars.Config = Config

    for obj, _ in pairs(PersistentVars.SpawnedEnemies) do
        if not Ext.Entity.Get(obj) then
            L.Debug("Cleaning up SpawnedEnemies", obj)
            PersistentVars.SpawnedEnemies[obj] = nil
        end
    end

    for obj, _ in pairs(PersistentVars.SpawnedItems) do
        if
            GU.Object.IsOwned(obj) or Osi.IsItem(obj) ~= 1 -- was used
        then
            L.Debug("Cleaning up SpawnedItems", obj)
            PersistentVars.SpawnedItems[obj] = nil
        end
    end
end)

GameState.OnLoad(function()
	local exandriaCheck = Ext.Mod.IsModLoaded("a27fdbe3-4d1a-641d-d05f-1ba4ee529da8")
    Enemy.RestoreFromSave(PersistentVars.SpawnedEnemies)

    if eq(PersistentVars.Scenario, {}) then
        PersistentVars.Scenario = nil
    end

    if PersistentVars.Scenario ~= nil then
        Scenario.RestoreFromSave(PersistentVars.Scenario)
    end

    Player.AskConfirmation([[
Regenerate enemy, item, and map tables?
If you've recently updated, this is recommended.
Old data may need to be cleared, and new data may need to be pulled in]]):After(function(confirmed)
                if confirmed and exandriaCheck then
                    L.Debug("Regenerating tables", confirmed)
                    Templates.ExportScenarios()
                    Templates.ExportMaps()
					Templates.ExportExandriaModeEnemies()
                    Templates.ExportLootRates()
                    Net.Send("GetTemplates")
                    Net.Send("GetSelection")
                    L.Debug("Tables regenerated", confirmed)
				elseif confirmed then
					L.Debug("Regenerating tables", confirmed)
                    Templates.ExportScenarios()
                    Templates.ExportMaps()
                    Templates.ExportEnemies()
                    Templates.ExportLootRates()
                    Net.Send("GetTemplates")
                    Net.Send("GetSelection")
                    L.Debug("Tables regenerated", confirmed)
                end
        end)
end, true)

Require("BattleMode/ModActive/Server/Templates")
Require("BattleMode/ModActive/Server/Scenario")
Require("BattleMode/ModActive/Server/Enemy")
Require("BattleMode/ModActive/Server/Map")
Require("BattleMode/ModActive/Server/Item")
Require("BattleMode/ModActive/Server/StoryBypass")
Require("BattleMode/ModActive/Server/GameMode")
Require("BattleMode/ModActive/Server/NetEvents")
Require("BattleMode/ModActive/Server/Unlock")
Require("BattleMode/ModActive/Server/Player")

-- collect stats
Event.On("ScenarioEnded", function(scenario)
    table.insert(PersistentVars.History, {
        HardMode = PersistentVars.HardMode,
        SuperHardMode = PersistentVars.SuperHardMode,
        LoneWolfMode = PersistentVars.LoneWolfMode,
		GMMode = PersistentVars.GMMode,
        RogueScore = PersistentVars.RogueScore,
        Currency = PersistentVars.Currency,
        Scenario = {
            Enemies = table.size(scenario.KilledEnemies),
            Rounds = scenario.Round - 1,
            Map = scenario.Map.Name,
        },
    })
end)
