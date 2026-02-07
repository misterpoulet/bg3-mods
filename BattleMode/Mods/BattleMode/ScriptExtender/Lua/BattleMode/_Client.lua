if Ext.IMGUI == nil then
    L.Error("IMGUI not available.", "Update to latest Script Extender.")
    return
end

Require("BattleMode/Shared")

ModEvent.Register("ModInit")

local isActive = false
function IsActive()
    return isActive
end

local function init()
    if isActive then
        return
    end
    isActive = true

    Require("BattleMode/ModActive/Client/_Init")

    Event.Trigger(GameState.EventLoad)

    Event.Trigger("ModInit")
end

Require("BattleMode/Overwrites")

Net.On("ModActive", init, true)
