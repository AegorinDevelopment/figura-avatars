events.TICK:register(function()
    if candler then
        candler.lib.setCommand("Candler", "categories", {
            aliases = {"cats","cat"},
            description = "Lists all categories.",
            arguments = {}
        }, function ()
            local idx = 0
            local cats = "["
            for catk, _ in pairs(candler.cats) do
                -- table.insert(catList, catk)
                idx = idx + 1
                if idx == 1 then
                    cats = cats .. '{"text":" - ","color":"dark_gray"},{"text":"' .. catk .. '","color":"green"}'
                else
                    cats = cats .. ',{"text":", ","color":"white"},{"text":"' .. catk .. '","color":"green"}'
                end
            end
            cats = cats .. "]"
            printJson('{"text":"Categories (' .. idx .. '):\n","color":"gold"}')
            printJson(cats)
        end)
        events.TICK:remove("reg.candler.cat")
    end
end, "reg.candler.cat")