candler = {}

candler.cats = {}
candler.commands = {}

-- Configuration for Candler.
candler.config = {
    prefix = ".", -- The prefix Candler uses by default.
    b_printCommand = 1, -- Should the command sent be printed into chat? Example: "> exampleCommand argument"
}
-- END CONFIG

if config:load("candler") then
    candler.config = config:load("candler")
end

if candler.config.printCommand then candler.config.b_printCommand = candler.config.printCommand end

local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

-- ========== LIBRARY ========== --
local lib = {}

-- Register a new category (cats for short).
---@param name string The name of the category. Will be used as the cat's namespace and help name.
---@param information table The information of the category. See README.MD for more information and a template to copy.
function lib.newCategory(name, information)
    if not name then
        error("Category name is required.")
        return false
    end
    if type(name) ~= "string" then
        error("Category name must be string.")
        return false
    end
    if type(information) ~= "table" then
        error("Category information must be table.")
        return false
    end

    name = string.lower(name)

    candler.cats[name] = information
    candler.cats[name].commands = {}
    return true
end

-- Register a new command.
---@param cat string The name of the category to put the command under.
---@param name string The name of the command, also used as the command's main alias.
---@param information table Information about the command. See README.MD for more information and a template to copy.
---@param funct function The function to call when the command is called.
function lib.setCommand(cat, name, information, funct)
    if not cat then
        error("Category name is required.")
        return false
    end
    if not name then
        error("Command name is required.")
        return false
    end
    if not funct then
        error("Command function is required.")
        return false
    end
    if type(cat) ~= "string" then
        error("Category name must be string.")
        return false
    end
    if type(name) ~= "string" then
        error("Command name must be string.")
        return false
    end
    if type(information) ~= "table" then
        error("Command information must be table.")
        return false
    end
    if type(funct) ~= "function" then
        error("Command function must be function.")
        return false
    end

    cat = string.lower(cat)
    name = string.lower(name)

    candler.cats[cat].commands[name] = information
    candler.cats[cat].commands[name].command = funct
    candler.commands[name] = funct

    if information.aliases then
        for _, v in ipairs(information.aliases) do
            candler.commands[v] = funct
        end
    end
end

-- Removes a category from the registry.
---@param cat string The name of the category to remove.
function lib.removeCategory()
    if not cat then
        error("Category name is required.")
        return false
    end
    if type(cat) ~= "string" then
        error("Category name must be string.")
        return false
    end
    candler.cats[cat] = nil
end

-- Removes a command from a category.
---@param cat string The name of the category that contains the command to remove.
---@param name string The name of the command to remove.
function lib.removeCommand(cat, name)
    if not cat then
        error("Category name is required.")
        return false
    end
    if not name then
        error("Command name is required.")
        return false
    end
    if type(cat) ~= "string" then
        error("Category name must be string.")
        return false
    end
    if type(name) ~= "string" then
        error("Command name must be string.")
        return false
    end
    candler.cats[cat].commands[name] = nil
end

-- Send a command on behalf of the user. For sending a command with Minecraft's text JSON, use runCommand with value "/::candler." as your prefix.
---@param cmd string The command to send to Candler.
---@param fb boolean Whether Candler should print the command back to the user. Remember that this will not print feedback if the config option "printCommnad" is 1 or higher.
function lib.sendCommand(cmd, fb)
    local args = split(cmd, " ")
        
        if candler.config.b_printCommand >=1 and fb then
            local jsonMsg = '[{"text":"> ","color":"dark_gray"}'
            for i, v in ipairs(args) do
                local thing = string.gsub(v, "\\", "\\\\")
                thing = string.gsub(thing, "\"", "\\\"")
                if i == 1 then
                    jsonMsg = jsonMsg .. ', {"text":"' .. thing .. ' ", "color":"gray"}'
                else
                    jsonMsg = jsonMsg .. ', {"text":"' .. thing .. ' ", "color":"aqua"}'
                end
            end
            jsonMsg = jsonMsg .. ', {"text":"\n"}]'
            printJson(jsonMsg)
        end
        
        if cmd == "" then
            printJson('[{"text":"ERROR!", "color":"red", "bold":true}, {"text":" No command specified. Type \\\"' .. candler.config.prefix .. 'help\\\" for help.", "color":"gray", "bold":false}]')
            return nil
        end

        for k, v in pairs(candler.commands) do
            if k == string.lower(args[1]) then
                local aliasused = args[1]
                table.remove(args, 1)

                local _, err = pcall(function()
                    v(args, aliasused)
                end)

                if err then
                    printJson('[{"text":"ERROR!", "color":"red", "bold":true}, {"text":" Your command errored! No need to worry, however, Candler prevented your avatar from crashing!", "color":"gray", "bold":false},{"text":"\n\n' .. err .. '", "color":"red","bold":false}]')
                end

                return nil
            end
        end

        printJson('[{"text":"ERROR!", "color":"red", "bold":true}, {"text":" Unknown command. Type \\\"' .. candler.config.prefix .. 'help\\\" for help.", "color":"gray", "bold":false}]')
end

candler.lib = lib

-- ========= MESSAGE HANDLER ==========--

events.CHAT_SEND_MESSAGE:register(function(msg)
    if string.sub(msg, 1, string.len(candler.config.prefix)) == candler.config.prefix then
        local cmd = string.sub(msg, string.len(candler.config.prefix)+1, -1)
        lib.sendCommand(cmd, true)
        host:appendChatHistory(msg)
        return nil
    end
    return msg
end)

events.RENDER:register(function()
    if host:getChatText() then
        if string.sub(host:getChatText(), 1, string.len(candler.config.prefix)) == candler.config.prefix then
            host:setChatColor(vectors.hexToRGB("#54fbfb"))
        else
            host:setChatColor(vec(1,1,1))
        end
    end
end)

-- ========== COMMAND TOOLS ========== --
function requireArgs(l, args)
    for _, v in ipairs(l) do
        if not args[v] then
            print("Error! Argument " .. tostring(v) .. " required!")
            return false
        end
    end
    return true
end

-- ========== REGISTER CATEGORY ========== --

lib.newCategory("Candler", {
    description = "A command interpreter for Figura.",
    author = "Slymeball",
    version = "0.1.2",
    website = "https://github.com/Slymeball/Candler/",
    issues = "https://github.com/Slymeball/Candler/issues"
})

return lib