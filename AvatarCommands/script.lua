
local candler = require("AvatarCommands.Candler.candler")

candler.newCategory("Test", {
    description = "Desc for Test category"
})

candler.setCommand("Test", "test", {
    description = "Desc for test command",
    aliases = {"testing"},
    args = {
        {
            name = "arg",
            description = "Desc for arg",
            required = false
        }
    }
}, function(args)
    if args[0] then
        print("Test command ran with arg: " .. args[0])
    else
        print("Test command ran!")
    end
end)