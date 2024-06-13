--[[
    This script allows to toggle different animation poses by pressing keys on 
    your keyboard.
]]

-- Edit the following variables to your liking
-- -------------------------------------------

--- List of keybinds on your numpad to toggle different animations. Change to your liking.
--- - `key` - Set to whatever button you want to press to toggle the animation.
--- - `mod` - Set the modifier, that needs to be pressed alongside the keybind to
---         toggle the animations. Common values are: (Numbers)
---         | 0 for no Modifier
---         | 1 for `⇧ Shift`
---         | 2 for `✲ Ctrl`
---         | 4 for `⎇ Alt`
--- - `name` - Set to the name your animation should be shown as
--- - `anim` - Set to the animation you want to toggle
--- @type keybind[]
KEYBINDS = {
    { key = "key.keyboard.keypad.0", mod = 0, name = "Sitting", anim = "pose.sitting" },
    { key = "key.keyboard.keypad.1", mod = 0, name = "Standing", anim = "pose.standing" },
    { key = "key.keyboard.keypad.1", mod = 2, name = "Standing 2", anim = "pose.standing.2" },
}


-- ! Do not change anything below this line !
-- ------------------------------------------

--- @alias keybind {key: Minecraft.keyCode, mod: Event.Press.modifiers, name: string, anim: string}

--- @type table<string, boolean>
local keyStates = {}

--- Creates new keybinds and saves all of them in a table to index them later
for _, keybind in ipairs(KEYBINDS) do
    local key = keybinds:newKeybind(keybind.name, keybind.key, false)
    keyStates[keybind.anim] = false

    -- Create on press event
    key.press = function(modifier)
        if modifier ~= keybind.mod then return end

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
