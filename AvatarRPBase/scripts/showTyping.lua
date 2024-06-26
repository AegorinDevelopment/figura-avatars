--[[
    This script allows to display if you are currently typing in the chat.
    It will replace or extend your nameplate and tablist with a given string 
    as long as you are typing in the chat.
]]

-- Edit the following variables to your liking
-- -------------------------------------------

--- Maximum time (in ticks) the tablist and nameplate should remain changed
--- @type integer
MAX_COOLDOWN = 200

--- String to display in the tablist while you are typing (after your name)
--- - *Set this to "" if you dont want others to see you typing*
--- @type string
TABLIST_STRING = "..."

--- String to display on your nameplate while you are typing
--- @type string
NAMEPLATE_STRING = "Typing..."

--- Boolean to determine if the string should replace your nameplate or extend it
--- - `false` will add the string to the nameplate
--- - *You may want to add a space to the `NAMEPLATE_STRING` if you set this to false*
--- @type boolean
NAMEPLATE_REPLACE = true


-- ! Do not change anything below this line !
-- ------------------------------------------

COMMAND_PREFIX = "/"

local cooldown = 0

function events.CHAR_TYPED(char)
    if not host:isChatOpen() then return end
    if IsCommand(host:getChatText() .. char) then return end

    -- Set cooldown to max again
    if cooldown < MAX_COOLDOWN / 4 then
        pings.IsTyping()
        cooldown = MAX_COOLDOWN
    end
end

function events.TICK()
    if cooldown == 0 then return end

    cooldown = cooldown - 1

    if cooldown == 1 then
        pings.EndsTyping()
    end

    if not host:isChatOpen() then
        pings.EndsTyping()
        cooldown = 0
    end
end

--- Sets nanameplate and tablist to the typing state
function pings.IsTyping()
    nameplate.LIST:setText("${name}" .. TABLIST_STRING)

    if NAMEPLATE_REPLACE then
        nameplate.ENTITY:setText(NAMEPLATE_STRING)
    else
        nameplate.ENTITY:setText("${name}" .. NAMEPLATE_STRING)
    end
end

--- Resets nameplate and tablist to the default state
function pings.EndsTyping()
    nameplate.LIST:setText("${name}")
    nameplate.ENTITY:setText("${name}")
end

--- Check if the string is a command
--- @param text string
--- @return boolean
function IsCommand(text)
    return text:find(COMMAND_PREFIX) == 1
end