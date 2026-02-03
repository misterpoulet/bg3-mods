# Trials of Tav Reloaded - Themed Monster Spawning

This fork adds a **themed monster spawning system** to the Trials of Tav mod. Instead of randomly selecting enemies, the mod now groups enemies by theme (Undead, Drow, Goblins, etc.) for more cohesive and immersive combat encounters.

## Features

- **30+ Enemy Themes**: Undead, Drow, Goblinoid, Githyanki, Devils, Demons, Giants, Beasts, Constructs, Elementals, Mindflayers, and many more
- **Automatic Theme Selection**: Each scenario randomly picks a theme at start
- **Fallback System**: If a theme doesn't have enough enemies for a tier, falls back to random selection
- **Full Customization**: Force specific themes or disable themed selection entirely

## Installation

1. Requires [BG3 Script Extender](https://github.com/Norbyte/bg3se) v29+
2. Requires [Advanced Tabletop Spells](https://www.nexusmods.com/baldursgate3/mods/14430) mod
3. Place the CombatMod folder in your BG3 mods directory

## Console Commands

Access the Script Extender console by enabling it in `ScriptExtenderSettings.json`:
```json
{
    "CreateConsole": true,
    "EnableLogging": true,
    "LogLevel": "DEBUG"
}
```

### Standard Commands

| Command | Description |
|---------|-------------|
| `!TT` | List all available commands |
| `!TT Scenarios` | List all scenarios with IDs |
| `!TT Maps` | List all maps with IDs |
| `!TT Start <scenarioId> <mapId>` | Start a specific scenario on a map |
| `!TT Stop` | Stop the current scenario |
| `!TT Spawn <enemyName>` | Spawn a specific enemy |
| `!TT Kill [guid]` | Kill spawned enemies |
| `!TT Pos` | Show current position and region |
| `!TT Reload` | Reload config and templates |

### Theme Commands

| Command | Description |
|---------|-------------|
| `!TT Themes` | List all themes with enemy counts per tier |
| `!TT ThemeEnemies <theme> [tier]` | List enemies for a specific theme |
| `!TT SpawnTheme <theme> [tier]` | Spawn a random enemy from a theme |
| `!TT StartThemed <theme> [scenarioId] [mapId]` | Start scenario with a forced theme |
| `!TT CurrentTheme` | Show active scenario's theme |
| `!TT TestThemes` | Audit theme coverage across all enemies |

### Examples

```bash
# List all available themes
!TT Themes

# See all Undead enemies
!TT ThemeEnemies Undead

# See only high-tier Drow enemies
!TT ThemeEnemies Drow high

# Spawn a random mid-tier Goblinoid
!TT SpawnTheme Goblinoid mid

# Start scenario 1 on map 1 with Devil theme
!TT StartThemed Devil 1 1

# Check what theme is active in current scenario
!TT CurrentTheme

# Find enemies without theme coverage
!TT TestThemes
```

## Scenario and Map IDs

Use `!TT Scenarios` and `!TT Maps` to see the full list. Here are some common ones:

### Scenarios (scenarioId)

| ID | Name | Description |
|----|------|-------------|
| 1 | level 1 | Easy, 3 low-tier enemies |
| 2 | level 1-3 | 5 rounds, low-tier enemies |
| 3 | level 3-5 | Mixed low-tier with rest rounds |
| 4 | level 5-7 | Low/mid/high tiers mixed |
| 5 | level 7-9 | Medium-focused with high-tier bosses |
| 6 | level 8-10 | High-tier focused |
| 7 | level 10-12 | Ultra/epic tier enemies |
| 8 | very hard | Extreme difficulty |

### Maps (mapId)

Maps are region-specific. Use `!TT Maps` in-game to see maps available for your current region.

**Act 1 (WLD_Main_A):**
| ID | Name |
|----|------|
| 1 | Swamp (entrance) |
| 2 | Swamp |
| 3 | Zhentarim Hideout |
| 4 | Grove |
| 5 | Harpy nest |
| 6 | Goblin Camp (entrance) |
| 7 | Underdark (near beach) |
| 8 | Underdark (Dread Hollow) |
| 9 | Underdark (near Selune Outpost) |
| 10 | Goblin Camp (exterior) |

## Available Themes

| Theme | Description | Example Enemies |
|-------|-------------|-----------------|
| **Undead** | Undead creatures | Zombies, Skeletons, Vampires, Death Knights |
| **Drow** | Dark elves | Drow warriors, Lolth priests, Viconia |
| **Goblinoid** | Goblinoids | Goblins, Hobgoblins, Bugbears |
| **Githyanki** | Githyanki warriors | Raiders, Gish, Vlaakith, Orpheus |
| **Devil** | Devils from Nine Hells | Imps, Cambions, Zariel, Raphael |
| **Demon** | Demons from the Abyss | Balor, Marilith, Glabrezu |
| **Giant** | Giants and giant-kin | Fire/Frost/Stone Giants, Ogres |
| **Beast** | Beasts and monstrosities | Wolves, Spiders, Owlbears, Displacer Beasts |
| **Construct** | Constructs | Golems, Steel Watchers, Animated Armor |
| **Elemental** | Elemental creatures | Myrmidons, Mephits, Oozes |
| **Mindflayer** | Mind flayers | Illithids, Intellect Devourers, Alhoon |
| **Kobold** | Kobolds | Various Kobold types |
| **FlamingFist** | Flaming Fist | Mercenaries and guards |
| **Celestial** | Celestial beings | Solar, Planetar, Devas |
| **Harpy** | Harpies | Harpy variants |
| **Human** | Human enemies | Bandits, Smugglers, Guards |
| **Dwarf** | Dwarves | Hill Dwarves, Duergar |
| **Tiefling** | Tieflings | Tiefling cultists and warriors |
| **HalfOrc** | Half-Orcs | Half-Orc enemies |
| **Cultist** | Cultists | Bhaal, Bane, Sharran cultists |
| **Absolute** | Soldiers of the Absolute | Ketheric, Gortash, Thralls |
| **Gnoll** | Gnolls | Gnolls, Flinds |
| **Werewolf** | Werewolves | Werewolves, Loup Garou |
| **Fey** | Fey creatures | Pixies, Redcaps, Hags |
| **Beholder** | Beholders | Beholders, Spectators |
| **Dragon** | Dragons | Dragons, Ansur |
| **Sahuagin** | Aquatic creatures | Sahuagin, Kuo-toa |
| **Shadow** | Shadow creatures | Shadows, Shadow Dogs |
| **Minotaur** | Minotaurs | Minotaur |
| **Doppelganger** | Shapeshifters | Doppelgangers |
| **Legendary** | Named heroes/villains | Elminster, Drizzt, Minsc |

## Customizing Theme Selection

### In Scenario Templates

```lua
-- Force a specific theme
{
    Name = "Undead Assault",
    Theme = "Undead",
    Timeline = { ... }
}

-- Disable themed selection (pure random)
{
    Name = "Random Chaos",
    RandomTheme = false,
    Timeline = { ... }
}
```

### Adding New Themes

Edit `Constants.lua` and add to the `EnemyThemes` table:

```lua
MyNewTheme = {
    patterns = { "Pattern1", "Pattern2", "EnemyNameContains" },
    description = "Description of the theme",
},
```

Patterns are matched against enemy names using `string.find()`.

## Debugging

### Log Location

**Windows:** `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Script Extender\osiris.log`

### Enable Debug Mode

```bash
!TT Dev
```

### Check Theme Coverage

Run `!TT TestThemes` to see:
- How many enemies have themes
- How many enemies are unthemed
- Sample list of unthemed enemies (to help add missing patterns)

## Credits

- Original Trials of Tav mod by [Hippo0o](https://github.com/Hippo0o/bg3-mods)
- Updated fork by [celerev](https://github.com/celerev/bg3-mods)
- Themed spawning system by [misterpoulet](https://github.com/misterpoulet/bg3-mods)
