-- Spielerhoehe in Metern angeben und mit . als Komma nutzen
-- Es wird eine Blockbench Model benötigt, welche die defaultgroesse hat

local yourPlayerHight = 2

-- Change to false if you want to use blockbench textures
local useVanillaTextures = true


local hight = yourPlayerHight - 2
local scale = yourPlayerHight / 2


models:setScale(scale, scale, scale)
renderer:setOffsetCameraPivot(0, hight, 0)
nameplate.Entity:setPos(0, hight, 0)


--hide vanilla model
vanilla_model.PLAYER:setVisible(false)


if useVanillaTextures then
    models.model.root.LeftLeg:setPrimaryTexture("SKIN")
    models.model.root.RightLeg:setPrimaryTexture("SKIN")
    models.model.root.Head:setPrimaryTexture("SKIN")
    models.model.root.Body:setPrimaryTexture("SKIN")
    models.model.root.LeftArm:setPrimaryTexture("SKIN")
    models.model.root.RightArm:setPrimaryTexture("SKIN")
    models.model.root.LeftArmSlim:setPrimaryTexture("SKIN")
    models.model.root.RightArmSlim:setPrimaryTexture("SKIN")
end



function events.entity_init()
    if player:getModelType() == "DEFAULT" then
        models.model.root.LeftArm:setVisible(true)
        models.model.root.RightArm:setVisible(true)
    else
        models.model.root.LeftArmSlim:setVisible(true)
        models.model.root.RightArmSlim:setVisible(true)
    end
end