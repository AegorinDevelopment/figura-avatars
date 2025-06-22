
local myinput = models:newPart("ChatInput", "GUI"):newText("Input")
myinput:setText("")

function events.CHAR_TYPED(char, modifier, codepoint)
    if not host:isChatOpen() then return end  -- Only handle input when chat is open

    myinput:setText(myinput:getText() .. char)
end

function events.KEY_PRESS(key, action, modifier)
    if action ~= 0 then return end  -- Only handle key released events

    -- 259 `⟵ Backspace`
    if key == 259 then
        -- Handle the backspace key press, e.g., remove the last character
        local currentText = myinput:getText()
        if #currentText > 0 then
            myinput:setText(currentText:sub(1, -2))  -- Remove last character
        end

    -- 257 `↵ Enter`
    elseif key == 257 then
        -- Handle the enter key press, e.g., send the chat message
        -- print("Sending message: " .. myinput:getText())
        myinput:setText("")  -- Clear input after sending

    -- 256 `⎋ Esc`
    elseif key == 256 then
        -- Handle the escape key press, e.g., close the chat input
        -- print("Closing chat input")
        myinput:setText("")  -- Clear input on close
    end

    -- return true  -- Indicate that the key press was handled
end