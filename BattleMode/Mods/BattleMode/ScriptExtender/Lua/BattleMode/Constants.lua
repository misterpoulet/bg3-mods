---@type Constants
local Constants = Require("Hlib/Constants")

---@class MyConstants : Constants
C = {
    ModUUID = Mod.UUID,
    EnemyFaction = "64321d50-d516-b1b2-cfac-2eb773de1ff6", -- NPC Evil
    NeutralFaction = "cfb709b3-220f-9682-bcfb-6f0d8837462e", -- NPC Neutral
    ShadowCurseTag = "b47643e0-583c-4808-b108-f6d3b605b0a9", -- ACT2_SHADOW_CURSE_IMMUNE
    CompanionFaction = "4abec10d-c2d1-a505-a09a-719c83999847",
    ScenarioHelper = {
        TemplateId = "5ec892d5-9929-4c22-a7a0-0cb6c8a83f20",
        Handle = "hb7387af8g9102g4aabgb7d2g6ddb935e6f65",
        Faction = "4be9261a-e481-8d9d-3528-f36956a19b17",
    },
    MapHelper = "c13a872b-7d9b-4c1d-8c65-f672333b0c11",
    -- Themed enemy groups: patterns to match against enemy names
    EnemyThemes = {
        -- Major races/factions
        Undead = {
            patterns = { "Zombie", "Skeleton", "Undead", "Necro", "Wraith", "Ghoul", "Ghast", "Wight", "Mummy", "Lich", "Vampire", "Shadow_Wraith", "Myrkul", "Bodhi", "DeathKnight", "Ghost", "Demilich", "Cazador", "DarkJusticiar", "Nightwalker", "Meenlock" },
            description = "Undead creatures",
        },
        Drow = {
            patterns = { "Drow", "DrowLolth", "DrowCpt", "DrowSha", "Viconia", "Oblodra", "Yochlol" },
            description = "Dark elves from the Underdark",
        },
        Goblinoid = {
            patterns = { "Goblin", "Hobgoblin", "Bugbear", "Goblins", "DrorRagzlin", "PriestessGut" },
            description = "Goblinoids",
        },
        Githyanki = {
            patterns = { "Githyanki", "Gith", "Vlaakith", "Zrell", "Kithrak", "Orpheus", "GithInquisitor", "GithPaladin", "AncientGith", "Therezzyn" },
            description = "Githyanki warriors",
        },
        Devil = {
            patterns = { "Devil", "Imp", "Cambion", "Zariel", "Dispater", "Glasya", "Fierna", "Belial", "Mephisto", "Asmo", "Raphael", "Mizora", "Erinyes", "Malebranche", "PitFiend", "Falxugon", "Merregon", "Orthon", "Abishai", "Haarlep", "Helsik", "Boar_Devil", "Boar_Raphael" },
            description = "Devils from the Nine Hells",
        },
        Demon = {
            patterns = { "Demon", "Balor", "Marilith", "Quasit", "ShadowDemon", "Glabrezu", "Yochlol" },
            description = "Demons from the Abyss",
        },
        Giant = {
            patterns = { "Giant", "FireGiant", "FrostGiant", "StoneGiant", "CloudGiant", "StormGiant", "Ogre", "Troll" },
            description = "Giants and giant-kin",
        },
        Beast = {
            patterns = { "Spider", "Wolf", "Bear", "Boar", "Rat", "Hyena", "Eagle", "Owl", "Displacer", "HookHorror", "Alioramus", "Rothe", "Panther", "Sabretooth", "Bat", "Worg", "Owlbear", "Bulette", "Badger", "Dog", "Hound", "OX_", "BIRD_", "Bird_", "Ettercap", "Cloaker", "Mimic" },
            description = "Beasts and monstrosities",
        },
        Construct = {
            patterns = { "Golem", "Construct", "Retriever", "SteelWatcher", "Steel_Watcher", "Automaton", "AnimatedArmor", "HollowArmor", "Bernard" },
            description = "Constructed creatures",
        },
        Elemental = {
            patterns = { "Elemental", "Myrmidon", "Mephit", "Djinni", "Efreeti", "Azer", "Ooze", "ShamblingMound", "WoodWoad", "BLIGHT", "Blight", "VINE", "Vine", "Myconid" },
            description = "Elemental and nature creatures",
        },
        Mindflayer = {
            patterns = { "Mindflayer", "MindFlayer", "Illithid", "Intellect_Devourer", "Intellect_Detonator", "Netherbrain", "Ulitharid", "Alhoon", "MindMaster", "Cranium_Rat" },
            description = "Mind flayers and their thralls",
        },
        Kobold = {
            patterns = { "Kobold", "Kobolds" },
            description = "Kobolds",
        },
        FlamingFist = {
            patterns = { "FlamingFist", "Flaming_Fist", "CountingHouse" },
            description = "Flaming Fist mercenaries",
        },
        Celestial = {
            patterns = { "Solar", "Planetar", "Eladrin", "Hollyphant", "Angel", "Deva", "Nightsong" },
            description = "Celestial beings",
        },
        Harpy = {
            patterns = { "Harpy" },
            description = "Harpies",
        },
        -- Humanoid factions
        Human = {
            patterns = { "Humans_", "Human_", "Bandit", "Smuggler", "Smugger", "Corsair", "Pirate", "CountingHouse", "Zhent", "Anders", "Aradin", "Wulbren", "Roah", "Devella", "Guild", "Surgeon", "Brewer", "TollCollector", "Keene" },
            description = "Human enemies and bandits",
        },
        Dwarf = {
            patterns = { "Dwarf", "Dwarves", "Duergar" },
            description = "Dwarves and Duergar",
        },
        Tiefling = {
            patterns = { "Tiefling", "Tieflings" },
            description = "Tieflings",
        },
        HalfOrc = {
            patterns = { "HalfOrc", "HalfOrcs" },
            description = "Half-Orcs",
        },
        Cultist = {
            patterns = { "Cultist", "Sharran", "Bhaal", "Bane", "DeadThree", "Sarevok", "Orin", "Slayer", "Abdirak", "MyrkuliteLord" },
            description = "Cultists of various dark gods",
        },
        Absolute = {
            patterns = { "Absolute", "Ketheric", "Gortash", "Nere", "Thrall_" },
            description = "Soldiers of the Absolute",
        },
        -- Monster types
        Gnoll = {
            patterns = { "Gnoll", "Flind", "FangOfYeenoghu" },
            description = "Gnolls and hyena-kin",
        },
        Werewolf = {
            patterns = { "Werewolf", "LoupGarou" },
            description = "Werewolves and lycanthropes",
        },
        Fey = {
            patterns = { "Fey", "Pixie", "Redcap", "Hag", "Ethel", "Dryad", "Leafsong" },
            description = "Fey creatures",
        },
        Beholder = {
            patterns = { "Beholder", "Spectator" },
            description = "Beholders and beholder-kin",
        },
        Dragon = {
            patterns = { "Dragon", "Ansur" },
            description = "Dragons",
        },
        Sahuagin = {
            patterns = { "Sahuagin", "Kuotoa" },
            description = "Aquatic creatures",
        },
        Shadow = {
            patterns = { "Shadow_A", "Shadow_Dog", "ShadowOwlbear", "Shadow_Wraith", "ShadarKai" },
            description = "Shadow creatures",
        },
        Minotaur = {
            patterns = { "Minotaur" },
            description = "Minotaurs",
        },
        Doppelganger = {
            patterns = { "Doppelganger" },
            description = "Doppelgangers and shapeshifters",
        },
        -- Named/Legendary enemies (for special encounters)
        Legendary = {
            patterns = { "Elminster", "Drizzt", "Minsc", "Jaheira", "JonIrenicus", "Lorroakan", "Balthazar", "Iggwilv", "Tarrasque", "Ravager", "Kagha" },
            description = "Legendary heroes and villains",
        },
    },
    ItemRarity = {
        "Common",
        "Uncommon",
        "Rare",
        "VeryRare",
        "Legendary",
    },
    EnemyTier = {
        "low",
        "mid",
        "high",
        "ultra",
        "epic",
        "legendary",
        "mythical",
        "divine",
		"avatar",
    },
    RoguelikeScenario = "Roguelike",
    LootRates = {
        Objects = {
            Common = 40,
            Uncommon = 20,
            Rare = 10,
            VeryRare = 5,
            Legendary = 2,
        },
        Armor = {
            Common = 30, -- has only junk or invalid items
            Uncommon = 65,
            Rare = 20,
            VeryRare = 10,
            Legendary = 2,
        },
        Weapons = {
            Common = 30, -- has only junk or invalid items
            Uncommon = 65,
            Rare = 20,
            VeryRare = 10,
            Legendary = 2,
        },
    },
	Asylum = {
		Act1 = {
        asylumX = -284.551,
        asylumY = 24.104,
        asylumZ = 116.642,
		},
		Act1b = {
		asylumX = 736.06,
        asylumY = 0,
        asylumZ = -743.228,
		},
		Act2 = {
		asylumX = 55.421,
        asylumY = 0,
        asylumZ = -1407.249,
		},
		Act2b = {
		asylumX = 1154.142,
        asylumY = 0,
        asylumZ = -181.505,
		},
		Act3 = {
		asylumX = 605.245,
        asylumY = 0,
        asylumZ = -750.309,
		},
		Act3b = {
		asylumX = -1565.942,
        asylumY = 0.853,
        asylumZ = 297.384,
		},
		Act3c = {
		asylumX = -1909.747,
        asylumY = -0.232,
        asylumZ = 2675.996,
		},
		Act3i = {
		asylumX = 169.889,
        asylumY = 0,
        asylumZ = 11.882,
		},
	},
}
C = table.merge(Constants, C)
