local enemyTemplates = Require("BattleMode/Server/Templates/Enemies.lua")
local soloModeEnemyTemplates = Require("BattleMode/Server/Templates/LoneWolfEnemies.lua")
local exandriaEnemyTemplates = Require("BattleMode/Server/Templates/SOEEnemies.lua")
local exandriaSoloEnemyTemplates = Require("BattleMode/Server/Templates/SOELoneWolfEnemies.lua")
local mapTemplates = Require("BattleMode/Server/Templates/Maps.lua")
local scenarioTemplates = Require("BattleMode/Server/Templates/Scenarios.lua")
local unlockTemplates = Require("BattleMode/Server/Templates/Unlocks.lua")
local itemBlacklist = Require("BattleMode/Server/Templates/ItemBlacklist.lua")
local originalLootRates = table.deepclone(C.LootRates)
local exandriaCheck = Ext.Mod.IsModLoaded("a27fdbe3-4d1a-641d-d05f-1ba4ee529da8")

if exandriaCheck then
	External.File.ExportIfNeeded("Enemies", exandriaEnemyTemplates)
else
	External.File.ExportIfNeeded("Enemies", enemyTemplates)
end
External.File.ExportIfNeeded("Maps", mapTemplates)
External.File.ExportIfNeeded("Scenarios", scenarioTemplates)
External.File.ExportIfNeeded("LootRates", originalLootRates)
External.File.ExportIfNeeded("ItemFilters", { Names = {}, Mods = {} })

function Templates.ExportEnemies()
    External.File.Export("Enemies", enemyTemplates)
end

function Templates.ExportSoloModeEnemies()
    External.File.Export("Enemies", soloModeEnemyTemplates)
end

function Templates.ExportExandriaModeEnemies()
    External.File.Export("Enemies", exandriaEnemyTemplates)
end

function Templates.ExportExandriaSoloModeEnemies()
    External.File.Export("Enemies", exandriaSoloEnemyTemplates)
end

function Templates.ExportMaps()
    External.File.Export("Maps", mapTemplates)
end

function Templates.ExportScenarios()
    External.File.Export("Scenarios", scenarioTemplates)
end

function Templates.ExportLootRates()
    External.File.Export("LootRates", originalLootRates)
end

function Templates.GetEnemies()
    if exandriaCheck then
		return table.deepclone(exandriaEnemyTemplates)
	else
		return table.deepclone(enemyTemplates)
	end
end

function Templates.GetMaps()
    return table.deepclone(mapTemplates)
end

function Templates.GetScenarios()
    return table.deepclone(scenarioTemplates)
end

function Templates.GetUnlocks()
    return table.deepclone(unlockTemplates)
end

function Templates.GetItemFilters()
    return table.deepclone({ Names = itemBlacklist, Mods = {} })
end
