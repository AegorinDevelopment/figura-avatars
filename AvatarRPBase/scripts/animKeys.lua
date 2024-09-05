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
    { key = "key.keyboard.keypad.0", mod = 0, name = "Sitting Tailor", anim = "pose.sitting.tailor" },
    { key = "key.keyboard.keypad.1", mod = 0, name = "Sitting Knees", anim = "pose.sitting.knees" },
    { key = "key.keyboard.keypad.2", mod = 0, name = "Sitting Back", anim = "pose.sitting.back" },
    { key = "key.keyboard.keypad.3", mod = 0, name = "Lying Dead", anim = "pose.lying.dead" },
    { key = "key.keyboard.keypad.4", mod = 0, name = "Lying Chilled", anim = "pose.lying.chilled" },
    { key = "key.keyboard.keypad.5", mod = 0, name = "Lying Belly", anim = "pose.lying.belly" },
    { key = "key.keyboard.keypad.6", mod = 0, name = "Kneeling Default", anim = "pose.kneeling.default" },
    { key = "key.keyboard.keypad.7", mod = 0, name = "Kneeling Bow", anim = "pose.kneeling.bow" },
    { key = "key.keyboard.keypad.8", mod = 0, name = "Kneeling Sit", anim = "pose.kneeling.sit" },
    { key = "key.keyboard.keypad.9", mod = 0, name = "Kneeling Ninja", anim = "pose.kneeling.ninja" },
    { key = "key.keyboard.keypad.0", mod = 2, name = "Standing Interlaced", anim = "pose.standing.interlaced" },
    { key = "key.keyboard.keypad.1", mod = 2, name = "Standing Guard", anim = "pose.standing.guard" },
    { key = "key.keyboard.keypad.2", mod = 2, name = "Standing Fight", anim = "pose.standing.fight" },
    { key = "key.keyboard.keypad.3", mod = 2, name = "Standing See Nothing", anim = "pose.standing.see_nothing" },
    { key = "key.keyboard.keypad.4", mod = 2, name = "Standing Leaned", anim = "pose.standing.leaned" },
    { key = "key.keyboard.keypad.5", mod = 2, name = "Dancing Weird", anim = "pose.dancing.weird" },
    { key = "key.keyboard.keypad.6", mod = 2, name = "Waving Happy", anim = "pose.waving.happy" },
}


-- ! Do not change anything below this line !
-- ------------------------------------------

--- @alias keybind {key: Minecraft.keyCode, mod: Event.Press.modifiers, name: string, anim: string}

--- @type table<string, boolean>
local animStates = {}

--- Creates new keybinds and saves all of them in a table to index them later
for _, keybind in ipairs(KEYBINDS) do
    local key = keybinds:newKeybind(keybind.name, keybind.key, false)
    animStates[keybind.anim] = false

    -- Create on press event
    key.press = function(modifier)
        if modifier ~= keybind.mod then return end

        local keyNew = not animStates[keybind.anim]

        -- Switch only given keyState
        pings.animPing(keybind.anim, keyNew)

        -- log(keybind.name .. " " .. (animStates[keybind.anim] and "enabled" or "disabled"))
    end
end

--- Turns off all animations and only updates the given one using the state or false if not given
--- @param anim string The animation to update
--- @param state boolean The state of the animation
function pings.animPing(anim, state)
    if not player:isLoaded() then return end

    for key in pairs(animStates) do
        if key == anim then
            animStates[key] = state
        else
            animStates[key] = false
        end

        animations.avatar[key]:setPlaying(animStates[key])
    end
end


-- Update animations every few seconds
local ANIM_INTERVAL = 100
local anim_timer = 0

events.TICK:register(function()
    if not player:isLoaded() then return end

    if anim_timer > 0 then
        anim_timer = anim_timer - 1
        return
    else
        anim_timer = ANIM_INTERVAL
    end

    for anim, state in pairs(animStates) do
        if state then
            pings.animPing(anim, state)
        end
    end
end, "animUpdate")