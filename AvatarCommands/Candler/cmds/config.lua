local function saveToConfig(k, v)
    candler.config[k] = v
    config:save("candler", candler.config)
end

function printConfig(confkey, confval)
    if confkey then
        handleSaveToConfig({confkey, confval})
    end
    local header = ('[{"text":"                    ","color":"yellow","strikethrough":true},{"text":" Candler Configuration ","color":"white","strikethrough":false},{"text":"                    ","color":"yellow","strikethrough":true}]')
    printJson(header)
    local idx = 17
    for k, v in pairs(candler.config) do
        idx = idx - 1
        if string.sub(k, 1, 2) == "b_" then
            printJson('[{"text":"\n' .. string.sub(k, 3, -1) .. ': ", "color":"gray"}]')
            if v >= 1 then
                printJson('["",{"text":"True","color":"aqua","underlined":true,"clickEvent":{"action":"figura_function","value":"printConfig(\\\"' .. k .. '\\\", 1)"}}," ",{"text":"False","color":"white","underlined":false,"clickEvent":{"action":"figura_function","value":"printConfig(\\\"' .. k .. '\\\", 0)"}}]')
            else
                printJson('["",{"text":"True","color":"white","clickEvent":{"action":"figura_function","value":"printConfig(\\\"' .. k .. '\\\", 1)"}}," ",{"text":"False","color":"aqua","underlined":true,"clickEvent":{"action":"figura_function","value":"printConfig(\\\"' .. k .. '\\\", 0)"}}]')
            end
        elseif type(v) == "number" then
            printJson('[{"text":"\n' .. tostring(k) .. ': ", "color":"gray"},{"text":"‹ ","color":"white","clickEvent":{"action":"figura_function","value":"printConfig(' .. tostring(k) .. ', ' .. tostring(v-1) .. ')"}},{"text":"' .. tostring(v) .. '","color":"aqua","clickEvent":{"action":"suggest_command","value":"' .. candler.config.prefix .. 'config ' .. tostring(k) .. ' ' ..  tostring(v) .. '"}},{"text":" ›","color":"white","clickEvent":{"action":"figura_function","value":"printConfig(' .. tostring(k) .. ', ' .. tostring(v-1) .. ')"}}]')
        else
            printJson('[{"text":"\n' .. tostring(k) .. ': ", "color":"gray"},{"text":"\\\"' .. tostring(v) .. '\\\"","color":"aqua","clickEvent":{"action":"suggest_command","value":"' .. candler.config.prefix .. 'config ' .. tostring(k) .. ' ' ..  tostring(v) .. '"}}]')
        end
    end
    
    if idx >= 1 then
        for i = 1, idx do
            printJson("\n")
        end
    end
    
    printJson('{"text":"\nPlease open chat to view the configuration.","color":"gray"}')

    local headerWidth = client:getTextWidth(header)
    local spaces = ""
    local footer
    while true do
        spaces = spaces .. " "
        footer = '[{"text":"\n' .. spaces .. '","color":"yellow","strikethrough":true}]'
        if client:getTextWidth(footer) >= headerWidth then
            break
        end
    end
    printJson(footer)
end

function handleSaveToConfig(args, fb)
    if not candler.config[args[1]] then
        printJson('[{"text":"ERROR!", "color":"red", "bold":true}, {"text":" This config option does not exist! Maybe check for typos?", "color":"gray", "bold":false}]')
        return
    end
    -- print(type(candler.config[args[1]]))
    -- if true then
    if type(candler.config[args[1]]) == "number" then
        if not tonumber(args[2]) then
            printJson('[{"text":"ERROR!", "color":"red", "bold":true}, {"text":" Incorrect type! This is a ' .. type(candler.config[args[1]]) .. '!", "color":"gray", "bold":false}]')
            return
        end
        args[2] = tonumber(args[2])
    end
    saveToConfig(args[1], args[2])
    if fb then
        printJson('[{"text":"", "color":"gray"},{"text":"✔", "color":"green"}," Set config ",{"text":"' .. args[1] .. '","color":"green"}," to ",{"text":"' .. tostring(args[2]) .. '","color":"green"},"."]')
    end
end

events.TICK:register(function()
    if candler then
        candler.lib.setCommand("Candler", "config", {
            description = "Set a configuration option for Candler or print the config.",
            aliases = {"candconfig"},
            arguments = {
                {
                    name = "key",
                    description = "The option to change. If left blank, the config will be printed out.",
                    required = false
                },
                {
                    name = "value",
                    description = "The value to change it to.",
                    required = false
                }
            }
        }, function (args)
            if not args[1] then
                -- printJson('{"text":"aaa","color":"aqua","clickEvent":{"action":"figura_function","value":"candler.lib.sendCommand(\\\"config prefix >\\\")"}}')
                printConfig()
                return
            else
                handleSaveToConfig(args, true)
            end
        end)
        events.TICK:remove("reg.candler.config")
    end
end, "reg.candler.config")