--[[
    This script allows to configure custom text formatting to be displayed in a chat 
    preview above your normal chat input.
    Using the `FORMATTINGS` variable you can define custom rules to format the chat text.
]]

-- Edit the following variables to your liking
-- -------------------------------------------

--- Tha place where the chat preview is displayed. You can use the following values:
--- - `Top`: Display the preview on top of the screen
--- - `Bottom`: Display the preview right above the chat input
--- @type string
DISPLAY_LOCATION = "Bottom"

--- The default color to apply to the chat preview (use `§` for MC color codes)
--- @type color
DEFAULT_COLOR = "§7"

--- The formatting rules to apply to the chat preview. You can add your own rules by extending
--- the list.
--- - `matcher`: The pattern to search for in the chat text (https://www.lua.org/pil/20.2.html)
--- - `replacer`: The string to replace the matched pattern with (use `DEFAULT_COLOR` to reset)
--- @type format[]
FORMATTINGS = {
    { matcher = "%* ", replacer = "§3*" .. DEFAULT_COLOR .. " " },
    { matcher = "%*", replacer = "§3*" },
    { matcher = "%]", replacer = "§9]" .. DEFAULT_COLOR },
    { matcher = "%[", replacer = "§9[" },
    { matcher = "%)", replacer = "§8)" .. DEFAULT_COLOR },
    { matcher = "%(", replacer = "§8(" },
    { matcher = "| ", replacer = "§4" .. DEFAULT_COLOR .. " " },
    { matcher = "|", replacer = "§4" },
    { matcher = "%>", replacer = "§e>" },
}

--- The interval in which the chat preview is updated (in ticks)
--- @type integer
UPDATE_INTERVAL = 5


-- ! Do not change anything below this line !
-- ------------------------------------------

---@alias color
---| '"§0"' # Black
---| '"§1"' # Dark Blue
---| '"§2"' # Dark Green
---| '"§3"' # Dark Aqua
---| '"§4"' # Dark Red
---| '"§5"' # Dark Purple
---| '"§6"' # Gold
---| '"§7"' # Gray
---| '"§8"' # Dark Gray
---| '"§9"' # Blue
---| '"§a"' # Green
---| '"§b"' # Aqua
---| '"§c"' # Red
---| '"§d"' # Light Purple
---| '"§e"' # Yellow
---| '"§f"' # White
---| '"§k"' # Obfuscated
---| '"§l"' # Bold
---| '"§m"' # Strikethrough
---| '"§n"' # Underline
---| '"§o"' # Italic
---| '"§r"' # Reset

---@alias format { matcher: string, replacer: string }


CHAT_PREVIEW = models:newPart("ChatPreview", "HUD"):newText("")

CHAT_PREVIEW:setBackgroundColor(0, 0, 0, 0.5)
CHAT_PREVIEW:setShadow(true)

--- Formats a text using a given format table
--- @param text string
--- @param format format
--- @return string, integer
function CustomFormat(text, format)
    return text:gsub(format.matcher, format.replacer)
end

--- Formats a text using a list of format tables
--- @param text string
--- @param formats format[]
--- @return string
function CustomFormatAll(text, formats)
    for _, format in ipairs(formats) do
        text = CustomFormat(text, format)
    end
    return text
end


local counter = 0

--- Redraw the preview every couple of ticks and apply the current window size
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

    -- Define the chat preview position and size
    WINDOW_SIZE_SCALED = client:getScaledWindowSize()
    if DISPLAY_LOCATION == "Top" then
        CHAT_PREVIEW:setScale(1)
        CHAT_PREVIEW:setPos(-3, -3, -99)
        CHAT_PREVIEW:setWidth(WINDOW_SIZE_SCALED.x - 6)
    else
        CHAT_PREVIEW:setScale(0.8)
        CHAT_PREVIEW:setPos(-3, -WINDOW_SIZE_SCALED.y + 38, -99)
        CHAT_PREVIEW:setWidth((WINDOW_SIZE_SCALED.x - 6) / 0.8)
    end

    -- Update the chat preview text
    CHAT_PREVIEW:setVisible(true)
    CHAT_PREVIEW:setText(CustomFormatAll(DEFAULT_COLOR .. host:getChatText(), FORMATTINGS))
end