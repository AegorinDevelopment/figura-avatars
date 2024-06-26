--[[
    This script allows to resize your avatar to your liking.
]]--

-- Edit the following variables to your liking
-- -------------------------------------------

--- Height of the player in cm
--- @type number
PLAYER_HEIGHT = 200

--- Change to `false` if you want to use custom textures
--- @type boolean
USE_SKIN = true


-- ! Do not change anything below this line !
-- ------------------------------------------

DEFAULT_HEIGHT = 187.5

ScaleValue = 1

vanilla_model.PLAYER:setVisible(false)

local parts = require("loadParts")


--- Sets and returns the scale value for the model
--- @param height number
function SetScaleValue(height)
    ScaleValue = height / DEFAULT_HEIGHT
end

--- Resizes the model to the given height
--- @param height number
function ResizeModel(height)
    SetScaleValue(height)

    models:setScale(ScaleValue, ScaleValue, ScaleValue)
    renderer:setShadowRadius(0.5 * ScaleValue)
    nameplate.ENTITY:setPivot(0, ScaleValue * 2.3, 0)
    nameplate.ENTITY:setScale(ScaleValue, ScaleValue, ScaleValue)
end

function events.entity_init()
    parts.loadCustomParts()
    ResizeModel(PLAYER_HEIGHT)
    
    IS_DEFAULT_TYPE = player:getModelType() == "DEFAULT"

    models.base.root.LeftArm.LA_Default:setVisible(IS_DEFAULT_TYPE)
    models.base.root.RightArm.RA_Default:setVisible(IS_DEFAULT_TYPE)
    models.base.root.LeftArm.LA_Slim:setVisible(not IS_DEFAULT_TYPE)
    models.base.root.RightArm.RA_Slim:setVisible(not IS_DEFAULT_TYPE)

    if USE_SKIN then
        models.base.root.Head.H_Default:setPrimaryTexture("SKIN")
        models.base.root.Body.B_Default:setPrimaryTexture("SKIN")
        models.base.root.LeftArm.LA_Default:setPrimaryTexture("SKIN")
        models.base.root.LeftArm.LA_Slim:setPrimaryTexture("SKIN")
        models.base.root.RightArm.RA_Default:setPrimaryTexture("SKIN")
        models.base.root.RightArm.RA_Slim:setPrimaryTexture("SKIN")
        models.base.root.LeftLeg.LL_Default:setPrimaryTexture("SKIN")
        models.base.root.RightLeg.RL_Default:setPrimaryTexture("SKIN")
    end
end

function events.render()
    -- Sets the correct positions for sitting / riding
    if player:getVehicle() ~= nil then
        models:setPos(0, -10 * ScaleValue + 10 , 0)
    else
        models:setPos(0, 0, 0)
    end
end
