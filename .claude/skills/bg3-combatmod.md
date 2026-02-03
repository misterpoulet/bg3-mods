# BG3 CombatMod (Trials of Tav Reloaded) Development Guide

## Overview

**Mod Name:** Trials of Tav Reloaded (CombatMod)
**ModTable:** `ToT`
**Language:** Lua (BG3 Script Extender v29+)
**Dependencies:** AdvancedTabletopSpells (fa49db03-caa7-49c8-7c76-e6c38b60267a) v1.1.8.4+

A roguelike combat arena mod featuring wave-based encounters, procedural enemy spawning, difficulty scaling, and loot rewards.

---

## Project Structure

```
CombatMod/
├── Mods/CombatMod/ScriptExtender/Lua/
│   ├── BootstrapServer.lua    # Server entry point
│   ├── BootstrapClient.lua    # Client entry point
│   ├── _Server.lua            # Server initialization, PersistentVars
│   ├── _Client.lua            # Client initialization
│   ├── Scenario.lua           # Combat encounter orchestration (~1530 lines)
│   ├── Enemy.lua              # Enemy entity management
│   ├── Item.lua               # Loot generation
│   ├── GameMode.lua           # Difficulty/progression (~660 lines)
│   ├── Player.lua             # Party/player utilities
│   ├── Map.lua                # Arena management
│   ├── Templates.lua          # Enemy/map/scenario templates
│   ├── NetEvents.lua          # Client-server communication
│   ├── ModEvents.lua          # External mod hooks
│   ├── External.lua           # JSON config I/O
│   ├── Commands.lua           # Console commands (/TT)
│   ├── Intro.lua              # Onboarding dialogs
│   ├── StoryBypass.lua        # Story encounter handling
│   ├── Overwrites.lua         # Game system overrides
│   ├── Unlock.lua             # Progression rewards
│   └── ModActive/Client/      # Client GUI (IMGUI)
│       ├── _Init.lua
│       └── GUI/*.lua
├── Shared/Hlib/               # 17 shared utility libraries
└── Exclude/                   # Dev-only files (not packaged)
```

---

## BG3 Script Extender API Reference

### Entity System

```lua
-- Get entity by GUID
local entity = Ext.Entity.Get(guid)

-- Query entities by component
local entities = Ext.Entity.GetAllEntitiesWithComponent("ServerCharacter")

-- Access entity components
entity.Stats.Abilities[1]              -- Strength (1-indexed)
entity.Stats.Abilities[2]              -- Dexterity
entity.Stats.Abilities[3]              -- Constitution
entity.Stats.Abilities[4]              -- Intelligence
entity.Stats.Abilities[5]              -- Wisdom
entity.Stats.Abilities[6]              -- Charisma
entity.EocLevel.Level                  -- Character level
entity.Health.Hp                       -- Current HP
entity.ServerExperienceGaveOut.Experience
entity.CombatParticipant.InitiativeRoll

-- Replicate changes to clients
entity:Replicate("EocLevel")
entity:Replicate("Stats")
```

### Template & Stats

```lua
-- Get template data
local template = Ext.Template.GetTemplate(templateId)
local statsId = template.Stats

-- Get stats object
local stats = Ext.Stats.Get(statsId)
local allCharStats = Ext.Stats.GetStats("Character")

-- Static data access
local data = Ext.StaticData.Get(uuid, "StatusData")
```

### Osiris Functions (Osi.*)

```lua
-- Spawning
Osi.CreateAt(templateId, x, y, z, temporary, playSpawnEffect, "")

-- Teleportation
Osi.TeleportToPosition(guid, x, y, z, "", skipEffects, keepOffset)

-- Position queries
local x, y, z = Osi.GetPosition(guid)
Osi.FindValidPosition(x, y, z, radius, referenceGuid, 1)  -- Returns valid position

-- Combat management
Osi.EnterCombat(guid1, guid2)
Osi.LeaveCombat(guid)
Osi.SetHostileAndEnterCombat(faction1, faction2, guid1, guid2)
Osi.PauseCombat()
Osi.ResumeCombat()
Osi.EndTurn(guid)
local combatGuid = Osi.CombatGetGuidFor(guid)

-- Status effects
Osi.HasActiveStatus(guid, statusName)       -- Returns 0 or 1
Osi.ApplyStatus(guid, statusName, duration, causeCleanse, sourceGuid)
Osi.RemoveStatus(guid, statusName)

-- Stat boosts
Osi.AddBoosts(guid, boostString, sourceId, causeName)
-- Example: Osi.AddBoosts(guid, "Ability(Strength,2)", "ToT", "")

-- Faction management
local faction = Osi.GetFaction(guid)
Osi.SetFaction(guid, factionGuid)

-- State queries
Osi.IsInCombat(guid)         -- Returns 0 or 1
Osi.IsDead(guid)             -- Returns 0 or 1
Osi.IsAlly(guid1, guid2)     -- Returns 0 or 1
Osi.IsSummon(guid)           -- Returns 0 or 1
Osi.GetHitpointsPercentage(guid)

-- Level management
local level = Osi.GetLevel(guid)
Osi.SetLevel(guid, level)

-- Rewards
Osi.AddGold(guid, amount)
Osi.AddExplorationExperience(guid, amount)

-- Visibility/Stage
Osi.SetVisible(guid, 1)      -- 1 = visible, 0 = invisible
Osi.SetOnStage(guid, 1)      -- 1 = on stage, 0 = off stage

-- Tags
Osi.SetTag(guid, tagUuid)

-- Party/AI
Osi.GetClosestAlivePlayer(referenceGuid)

-- Display name
local handle = Osi.GetDisplayName(guid)
local name = Osi.ResolveTranslatedString(handle)
```

### Osiris Event Listeners

```lua
-- Register event listener
Ext.Osiris.RegisterListener("EventName", paramCount, "after", function(...)
    -- Handler code
end)

-- Common events and their parameters:
Ext.Osiris.RegisterListener("Died", 1, "after", function(guid) end)
Ext.Osiris.RegisterListener("Resurrected", 1, "after", function(guid) end)
Ext.Osiris.RegisterListener("EnteredCombat", 2, "after", function(guid, combatGuid) end)
Ext.Osiris.RegisterListener("TurnStarted", 1, "after", function(guid) end)
Ext.Osiris.RegisterListener("TurnEnded", 1, "after", function(guid) end)
Ext.Osiris.RegisterListener("CombatRoundStarted", 2, "after", function(combatGuid, round) end)
Ext.Osiris.RegisterListener("TeleportedFromCamp", 1, "after", function(guid) end)
Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", function(guid) end)
Ext.Osiris.RegisterListener("ShortRested", 1, "after", function(guid) end)
Ext.Osiris.RegisterListener("LongRestFinished", 0, "after", function() end)
Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(guid) end)
Ext.Osiris.RegisterListener("CharacterLeftParty", 1, "after", function(guid) end)
```

### Networking (Client-Server)

```lua
-- Server to client broadcast
Ext.Net.BroadcastMessage("ChannelName", Ext.Json.Stringify(payload))

-- Server to specific client
Ext.Net.PostMessageToUser(userId, "ChannelName", Ext.Json.Stringify(payload))

-- Client to server
Ext.Net.PostMessageToServer("ChannelName", Ext.Json.Stringify(payload))

-- Environment detection
if Ext.IsServer() then ... end
if Ext.IsClient() then ... end
```

### Mod & Utils

```lua
-- Check mod loaded
Ext.Mod.IsModLoaded(modUuid)
local mod = Ext.Mod.GetMod(modUuid)

-- Mod variables (persistent)
local vars = Ext.Vars.GetModVariables(modUuid)

-- Localization
Ext.Loca.GetTranslatedString(handle)
Ext.Loca.UpdateTranslatedString(handle, newText)

-- Math/Utils
local dist = Ext.Math.Distance({x1,y1,z1}, {x2,y2,z2})
local time = Ext.Utils.MonotonicTime()

-- Debug
Ext.DumpExport(object)
```

---

## Hlib Shared Utilities

Located in `Shared/Hlib/`. Loaded via `Ext.Require("Shared/Hlib/_Init.lua")`.

### Async Operations

```lua
-- Run on next frame
Schedule(function()
    -- code
end)

-- Run after delay (milliseconds)
Defer(1000, function()
    -- runs after 1 second
end)

-- Run after N game ticks
WaitTicks(6, function()
    -- runs after 6 ticks
end)

-- Retry until condition met (chainable)
RetryUntil(function()
    return Osi.IsInCombat(guid) == 1
end, { immediate = true, retries = 10, interval = 500 })
    :After(function()
        -- success callback
    end)
    :Catch(function()
        -- failure callback
    end)
```

### Event System

```lua
-- Subscribe to events
Event.On("CustomEventName", function(data)
    -- handler
end)

-- Trigger events
Event.Trigger("CustomEventName", { key = "value" })

-- Mod-specific events (exposed to other mods)
-- ScenarioStarted, ScenarioEnded, ScenarioRoundStarted, ScenarioEnemySpawned, etc.
```

### Net Events (Hlib wrapper)

```lua
-- Server-side: listen for client messages
Net.On("ActionName", function(payload, peerId)
    -- handle request
    Net.Respond(peerId, "ActionName", responseData)
end)

-- Client-side: send to server
Net.Send("ActionName", payload)

-- Server-side: broadcast to all clients
Net.Broadcast("ActionName", payload)
```

### Struct System

```lua
-- Define a typed struct
local Enemy = Libs.Struct({
    Name = { type = "string", required = true },
    TemplateId = { type = "string", required = true },
    Tier = { type = "string", default = "low" },
    GUID = { type = "string", default = nil },
    Info = { type = "table", default = {} }
})

-- Create instance
local enemy = Enemy.Init({
    Name = "Goblin",
    TemplateId = "abc-123-def"
})
```

### GameUtils

```lua
-- Get all party members
local party = GU.Party.Get()

-- Get character by GUID
local char = GU.Character.Get(guid)

-- Distance calculation
local dist = GU.Distance(guid1, guid2)

-- Entity queries
local entities = GU.Entity.GetAllWithComponent("ServerCharacter")
```

### Logging

```lua
Log.Debug("Debug message", data)
Log.Info("Info message")
Log.Warn("Warning message")
Log.Error("Error message")
```

### Utils

```lua
-- Table operations
Utils.Table.DeepClone(tbl)
Utils.Table.Merge(target, source)
Utils.Table.Filter(tbl, predicate)
Utils.Table.Map(tbl, transform)
Utils.Table.Find(tbl, predicate)
Utils.Table.Contains(tbl, value)

-- String operations
Utils.String.Split(str, delimiter)
Utils.String.Trim(str)

-- UUID validation
Utils.UUID.IsValid(str)
Utils.UUID.Generate()

-- Random
Utils.Random(min, max)
Utils.RandomFromTable(tbl)
```

---

## Core Data Structures

### Enemy

```lua
{
    Name = "MOD_Vlaakith_Combat",
    TemplateId = "e0a624a2-55b3-4438-96b5-59de300940ac",
    Tier = "mythical",  -- low|mid|high|ultra|epic|legendary|mythical|divine|avatar
    GUID = nil,         -- Set after spawning
    Info = {
        AC = 20,
        Level = 23,
        Pwr = 300.0,    -- Power rating
        Stats = 24,     -- Highest ability score
        Vit = 400       -- Vitality/HP
    }
}
```

### Map

```lua
{
    Region = "ACT1",
    Name = "Nautiloid",
    Author = "Author Name",
    Enter = { x, y, z },                    -- Entry teleport point
    Spawns = { {x,y,z}, {x,y,z}, ... },     -- Enemy spawn positions
    Timeline = { 1, 2, 1, 3, 2 },           -- Optional spawn sequencing
    Helpers = {}                             -- Persistent helper entities
}
```

### Scenario

```lua
{
    Name = "Level 1-3",
    Map = "Nautiloid",                       -- Map name or function returning Map
    Timeline = {
        { "low", "low", "low" },             -- Round 1: 3 low-tier enemies
        {},                                   -- Round 2: empty (rest round)
        { "low", "mid" }                      -- Round 3: mixed tiers
    },
    Loot = C.LootRates,                      -- Custom loot rates
    RogueLike = true,                        -- Roguelike mode flag
    OnStart = function(scenario) end,        -- Callback
    OnEnd = function(scenario, won) end      -- Callback
}
```

### PersistentVars (State)

```lua
PersistentVars = {
    Asked = false,              -- Onboarding completed
    Active = false,             -- Mod active
    RogueModeActive = false,    -- In roguelike run
    SpawnedEnemies = {},        -- Current enemies { [GUID] = Enemy }
    SpawnedItems = {},          -- Loot on ground
    Scenario = {},              -- Current scenario state
    Config = {},                -- User settings
    RogueScore = 0,             -- Difficulty progression (0-190)
    HardMode = false,
    SuperHardMode = false,
    LoneWolfMode = false,
    GMMode = false,
    Currency = 0,
    History = {},               -- Past run stats
    RandomLog = {},             -- Recent selections (prevent repeats)
    LootFilter = {},            -- Rarity toggles
    Unlocked = {},              -- Purchased upgrades
    Unlocks = {},               -- Unlock progress
    RegionsCleared = {}         -- Map completion
}
```

---

## Enemy Tiers & Difficulty

### Tier Hierarchy (ascending difficulty)

1. `low` - Basic enemies
2. `mid` - Standard enemies
3. `high` - Challenging enemies
4. `ultra` - Elite enemies
5. `epic` - Boss-tier enemies
6. `legendary` - Major bosses
7. `mythical` - Near-god tier
8. `divine` - God-tier
9. `avatar` - Superboss (not scored)

### Enemy Themes

Enemies can be grouped by theme for thematic encounters. Themes are defined in `Constants.lua` under `C.EnemyThemes`:

| Theme | Description | Example Patterns |
|-------|-------------|------------------|
| Undead | Undead creatures | Zombie, Skeleton, Wraith, Vampire |
| Drow | Dark elves | Drow, DrowLolth, DrowCpt |
| Goblinoid | Goblinoids | Goblin, Hobgoblin, Bugbear |
| Githyanki | Githyanki warriors | Githyanki, Vlaakith, Zrell |
| Devil | Devils from Nine Hells | Zariel, Raphael, Mizora, PitFiend |
| Demon | Demons from the Abyss | Balor, Marilith, Quasit |
| Giant | Giants and giant-kin | FireGiant, FrostGiant, Ogre, Troll |
| Beast | Beasts and monstrosities | Spider, Wolf, Displacer |
| Construct | Constructs | Golem, Retriever, Automaton |
| Elemental | Elemental creatures | Myrmidon, Djinni, Mephit |
| Mindflayer | Mind flayers | Mindflayer, Intellect_Devourer |
| Celestial | Celestial beings | Solar, Planetar, Eladrin |

**Theme Functions:**
```lua
-- Get all enemies matching a theme
Enemy.GetByTheme("Undead", templates)

-- Get enemies matching both theme and tier
Enemy.GetByThemeAndTier("Drow", "high", templates)

-- Check if enemy matches a theme
Enemy.MatchesTheme(enemy, "Devil")

-- Get enemy's theme
local theme = Enemy.GetTheme(enemy)

-- Get all available themes with their tiers
local themes = Enemy.GetAvailableThemes(templates)
```

**Scenario Theme Selection:**
- Scenarios automatically pick a random theme by default
- Set `template.Theme = "Undead"` to force a specific theme
- Set `template.RandomTheme = false` to disable themed selection

### RogueScore Scaling

- Score range: 0-190 (cap reduced by -5 for HardMode, -10 for SuperHardMode)
- Converts to spawn value via sigmoid: `max_value * (1 - exp(-rate * score))`
- Higher tiers have multiplier reductions (legendary 2.2x, mythical 3.6x, divine 4.4x, avatar 8.3x)

### Party Size Scaling

```lua
1 player:  0.7x spawn value
2 players: 0.8x
3 players: 0.9x
4 players: 1.0x (baseline)
5+ players: 1.2x - 2.0x
```

---

## Common Patterns

### Module Definition Pattern

```lua
ModuleName = {}

-- Private helper
local function privateHelper() end

-- Public API
function ModuleName.PublicMethod()
    -- implementation
end

-- Event registration at end of file
Ext.Osiris.RegisterListener("Died", 1, "after", function(guid)
    -- handler
end)
```

### Spawning Enemies

```lua
-- 1. Get spawn position from map
local pos = map.Spawns[index]

-- 2. Add randomization
local offset = Config.RandomizeSpawnOffset or 2
local x = pos[1] + Utils.Random(-offset, offset)
local z = pos[3] + Utils.Random(-offset, offset)

-- 3. Spawn entity
local guid = Osi.CreateAt(enemy.TemplateId, x, pos[2], z, 1, 0, "")

-- 4. Validate position (async)
Defer(100, function()
    Osi.FindValidPosition(x, pos[2], z, 5, guid, 1)
end)

-- 5. Force into combat
Osi.SetHostileAndEnterCombat(enemyFaction, playerFaction, guid, playerGuid)
```

### Safe Async Operations

```lua
RetryUntil(function()
    return Osi.IsInCombat(enemy.GUID) == 1
end, { retries = 10, interval = 500 })
    :After(function()
        Log.Info("Enemy in combat")
    end)
    :Catch(function()
        Log.Warn("Enemy failed to enter combat, removing")
        -- cleanup
    end)
```

### State Persistence

```lua
-- In _Server.lua, define template
PersistentVarsTemplate = {
    MyNewFeature = {
        enabled = false,
        data = {}
    }
}

-- Access anywhere on server
PersistentVars.MyNewFeature.enabled = true

-- Save happens automatically on GameState.OnSave
```

---

## Adding New Features

### Adding a New Enemy

1. Find template ID in game files or use existing templates
2. Add to `Templates.lua` in appropriate tier table:

```lua
Templates.Enemies.high[#Templates.Enemies.high + 1] = {
    Name = "MyCustomEnemy",
    TemplateId = "uuid-here",
    Tier = "high"
}
```

### Adding a New Map

1. Get coordinates in-game using console commands
2. Add to `Templates.lua`:

```lua
Templates.Maps[#Templates.Maps + 1] = {
    Region = "ACT2",
    Name = "MyArena",
    Author = "YourName",
    Enter = { x, y, z },
    Spawns = {
        { x1, y1, z1 },
        { x2, y2, z2 },
        -- more spawn points
    }
}
```

### Adding a New Scenario

```lua
Templates.Scenarios[#Templates.Scenarios + 1] = {
    Name = "My Custom Encounter",
    Map = "MyArena",
    Timeline = {
        { "low", "low" },
        { "mid" },
        { "high", "mid", "low" }
    },
    Loot = C.LootRates,
    OnStart = function(scenario)
        Log.Info("Custom scenario started!")
    end
}
```

### Adding New Net Events

```lua
-- In NetEvents.lua (server side)
Net.On("MyAction", function(payload, peerId)
    -- process request
    local result = doSomething(payload)
    Net.Respond(peerId, "MyAction", result)
end)

-- In client GUI
Net.Send("MyAction", { data = "value" })
```

---

## Build & Test

### Makefile Commands

```bash
make copy MOD=CombatMod    # Copy mod to game directory
make sync-files            # Live sync via rsync
make watch-files           # Auto-sync on file changes
```

### Console Commands

- `/TT` - Main debug command (defined in Commands.lua)

### Testing

- Test files in `Exclude/Tests.lua` (not packaged)
- Debug enemies in `Exclude/DebugEnemies.lua`

---

## File I/O & External Config

```lua
-- Save JSON config
External.SaveConfig(PersistentVars.Config)

-- Load external templates
local enemies = External.LoadEnemies()
local maps = External.LoadMaps()

-- Validate external data
External.Validators.Enemy = tt({
    Name = { "string" },
    TemplateId = { U.UUID.IsValid },
    Tier = { C.EnemyTier }
})
```

Config files are stored in versioned subdirectories (e.g., `v1.0/`) in the game's script extender directory.

---

## Debugging Tips

1. Use `Log.Debug()` liberally during development
2. Check `Ext.DumpExport(entity)` for entity structure
3. Use `OsirisEventDebug.lua` to trace all Osiris events
4. Test spawning with `/TT` console command
5. Validate positions with `Osi.FindValidPosition()` before spawning
