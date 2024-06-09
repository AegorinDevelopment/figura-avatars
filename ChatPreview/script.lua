--[[
    This script allows to configure custom text formatting to be desplayed in a chat 
    preview above your normal chat input.
]]

-- Edit the following variables to your liking
-- -------------------------------------------

-- ! Do not change anything below this line !
-- ------------------------------------------


local chat_preview = models:newPart("ChatPreview", "HUD"):newText("")


function FormatText(text, matcher, replacer)
    return text:gsub("%s%*", " §6*"):gsub("%*%s", "*§7 ")
end


function events.TICK()
    if not host:isChatOpen() then 
        chat_preview:setVisible(false)
        return 
    end

    local window_size = client:getScaledWindowSize()

    chat_preview:setPos(-3, -window_size.y+37, 1000)
    chat_preview:setWidth(window_size.x-6)
    chat_preview:setBackgroundColor(0, 0, 0, 0.5)

    chat_preview:setVisible(true)
    chat_preview:setText(FormatText("§7" .. host:getChatText()))
end