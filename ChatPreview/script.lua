--[[
    This script allows to configure custom text formatting to be desplayed in a chat 
    preview above your normal chat input.
]]

-- Edit the following variables to your liking
-- -------------------------------------------

-- The default color to apply to the chat preview
DEFAULT_COLOR = "§7"

-- The formatting rules to apply to the chat preview
FORMATTINGS = {
    { matcher = "%* ", replacer = "§6*" .. DEFAULT_COLOR .. " " },
    { matcher = "%*", replacer = "§6*" },
    { matcher = "%]", replacer = "§9]" .. DEFAULT_COLOR },
    { matcher = "%[", replacer = "§9[" },
    { matcher = "%)", replacer = "§8)" .. DEFAULT_COLOR },
    { matcher = "%(", replacer = "§8(" },
    { matcher = "| ", replacer = "§4" .. DEFAULT_COLOR .. " " },
    { matcher = "|", replacer = "§4" },
}

-- The interval in which the chat preview is updated in ticks
UPDATE_INTERVAL = 5

-- ! Do not change anything below this line !
-- ------------------------------------------

CHAT_PREVIEW = models:newPart("ChatPreview", "HUD"):newText("")

CHAT_PREVIEW:setBackgroundColor(0, 0, 0, 0.5)
CHAT_PREVIEW:setShadow(true)


function FormatText(text, format)
    return text:gsub(format.matcher, format.replacer)
end

function FormatAllTexts(text, formats)
    for _, format in ipairs(formats) do
        text = FormatText(text, format)
    end
    return text
end


local counter = 0

function events.TICK()
    if counter > 0 then
        counter = counter - 1
        return
    else
        counter = UPDATE_INTERVAL
    end

    if not host:isChatOpen() then 
        CHAT_PREVIEW:setVisible(false)
        return 
    end

    WINDOW_SIZE_SCALED = client:getScaledWindowSize()

    CHAT_PREVIEW:setPos(-3, -WINDOW_SIZE_SCALED.y + 37, -99)
    CHAT_PREVIEW:setWidth(WINDOW_SIZE_SCALED.x - 6)

    CHAT_PREVIEW:setVisible(true)
    CHAT_PREVIEW:setText(FormatAllTexts("§7" .. host:getChatText(), FORMATTINGS))
end