--[[
    This script allows to toggle different animation poses by pressing keys on 
    your keyboard.
]]

-- Edit the following variables to your liking
-- -------------------------------------------

--- List of keybinds to toggle different animations. Change to your liking.
--- @type keybind[]
KEYBINDS = {
    { key = "key.keyboard.0", name = "Sitting", anim = "pose.sitting" },
    { key = "key.keyboard.1", name = "Standing", anim = "pose.standing" },
}

--- Set the modifier key, that needs to be pressed alongside the keybind to
--- toggle the animations. Common values are: (Numbers)
--- | 1 for `⇧ Shift`
--- | 2 for `✲ Ctrl`
--- | 4 for `⎇ Alt`
--- @type Event.Press.modifiers
MODIFIER = 1


-- ! Do not change anything below this line !
-- ------------------------------------------

--- @alias keybind {key: string, name: string, anim: string}

--- @type table<string, boolean>
local keyStates = {}

--- Creates new keybinds and saves all of them in a table to index them later
for _, keybind in ipairs(KEYBINDS) do
    local key = keybinds:newKeybind(keybind.name, keybind.key, false)
    keyStates[keybind.anim] = false

    -- Create on press event
    key.press = function(modifier)
        if modifier ~= MODIFIER then return end

        -- Turn off all states
        for _, value in pairs(keyStates) do
            keyStates[value] = false
        end

        -- Switch only given keyState
        keyStates[keybind.anim] = not keyStates[keybind.anim]
        pings.animPing(keyStates)
    end
end

--- Updates all animations
--- @param states table<string, boolean>
function pings.animPing(states)
    if not player:isLoaded() then return end
    
    for anim, state in pairs(states) do
        animations.base[anim]:setPlaying(state)
    end
end
