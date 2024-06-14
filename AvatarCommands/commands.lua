local candler = require("Candler.candler")

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
    if args[1] then
        print("Test command ran with arg: " .. args[1])
    else
        print("Test command ran!")
    end
end)