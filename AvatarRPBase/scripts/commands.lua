local candler = require("lib.Candler.candler")

candler.newCategory("Avatar", {
    description = "Commands for avatar manipulation",
    author = "Anfauglir/Valaron/Jakob",
    commands = "[height]",
})

candler.setCommand("Avatar", "height", {
    description = "Change the height of your avatar",
    args = {
        {
            name = "<number>",
            description = "The height in cm",
            required = false
        }
    }
}, function(args)
    local input = tonumber(args[1])

    if input ~= nil then
        if input < 80 or input > 300 then
            print("§cHeight must be between 80 and 300cm")
        end

        local height = math.min(math.max(input, 80), 300)

        config:save("height", height)

        print("Height set to " .. height .. "cm")
        pings.setHeight(height)
    else
        config:save("height", nil)

        print("Height set to default")
        pings.setHeight()
    end
end)