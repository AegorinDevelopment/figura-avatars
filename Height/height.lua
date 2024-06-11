--[[
    This script allows to resize your avatar to your liking.
]]--

-- Edit the following variables to your liking
-- -------------------------------------------

--- Height of the player in cm
--- @type number
PLAYER_HEIGHT = 100

--- Change to `false` if you want to use custom textures
--- @type boolean
USE_SKIN = true


-- ! Do not change anything below this line !
-- ------------------------------------------

DEFAULT_HEIGHT = 187.5

ScaleValue = 1
BodyPos = 0

CameraEnabled = true

vanilla_model.PLAYER:setVisible(false)

keybinds:newKeybind("Toggle Camera Height", "key.keyboard.c", false):setOnRelease(function()
    CameraEnabled = not CameraEnabled
    AdjustCameraHeight(PLAYER_HEIGHT)
end)


--- Sets and returns the scale value for the model
--- @param height number
--- @return number
function SizeToScale(height)
    ScaleValue = height / DEFAULT_HEIGHT

    return ScaleValue
end

--- Resizes the model to the given height
--- @param height number
function ResizeModel(height)
    ScaleValue = SizeToScale(height)

    models:setScale(ScaleValue, ScaleValue, ScaleValue)
    renderer:setShadowRadius(0.5 * ScaleValue)
    nameplate.ENTITY:setPivot(0, ScaleValue * 2.3, 0)
    nameplate.ENTITY:setScale(ScaleValue, ScaleValue, ScaleValue)
end

function events.entity_init()
    ResizeModel(PLAYER_HEIGHT)
    log(ScaleValue)
    log(1 - ScaleValue * 3)
    
    IS_DEFAULT_TYPE = player:getModelType() == "DEFAULT"

    models.model.root.LeftArm:setVisible(IS_DEFAULT_TYPE)
    models.model.root.RightArm:setVisible(IS_DEFAULT_TYPE)
    models.model.root.LeftArmSlim:setVisible(not IS_DEFAULT_TYPE)
    models.model.root.RightArmSlim:setVisible(not IS_DEFAULT_TYPE)

    -- ToDo: Set primary texture at root level
    if USE_SKIN then
        models.model:setPrimaryTexture("SKIN")
    end
end



--- Adjusts the camera height based on the given height
--- @param height number
function AdjustCameraHeight(height)
    -- ToDo: Add eye offset to the renderer
    -- https://wiki.figuramc.org/globals/Renderer#setEyeOffset

    if CameraEnabled then
        if ScaleValue >= 1 then
            -- renderer.setCameraPos( 0, 1.62 * (ScaleValue-1), 0 )
            -- camera.THIRD_PERSON.setPos({ 0, 1.62 * (scale_value-1), 4 * (scale_value-1) })
        else
            -- camera.FIRST_PERSON.setPos({ 0, 1.62 * -(1-scale_value), 0 })
            -- camera.THIRD_PERSON.setPos({ 0, 1.62 * -(1-scale_value), 4 * -(1-scale_value) })
        end
    else
        -- camera.FIRST_PERSON.setPos({ 0, 0, 0 })
        -- camera.THIRD_PERSON.setPos({ 0, 0, 0 })
    end
end