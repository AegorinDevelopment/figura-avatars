--[[
    This script allows to resize your avatar to your liking.
]]--

-- Edit the following variables to your liking
-- -------------------------------------------

--- Change to `false` if you want to use custom textures
--- @type boolean
USE_SKIN = true


-- ! Do not change anything below this line !
-- ------------------------------------------

--- Default height of the MC player character in cm
--- @type number
DEFAULT_HEIGHT = 187.5

ScaleValue = 1

local parts = require("lib.loadParts")


--- Sets and returns the scale value for the model
--- @param height number
function SetScaleValue(height)
    ScaleValue = height / DEFAULT_HEIGHT
end

--- Resizes the model to the given height
--- @param height number
function ResizeModel(height)
    SetScaleValue(height)

    models.avatar:setScale(ScaleValue, ScaleValue, ScaleValue)
    renderer:setShadowRadius(0.5 * ScaleValue)
    nameplate.ENTITY:setPivot(0, ScaleValue * 2.3, 0)
    nameplate.ENTITY:setScale(ScaleValue, ScaleValue, ScaleValue)
end

function events.entity_init()
    vanilla_model.PLAYER:setVisible(false)
    
    parts.loadCustomParts()

    if config:load("height") then
        pings.setHeight(tonumber(config:load("height")))
    else
        pings.setHeight(DEFAULT_HEIGHT)
    end
    
    pings.setModelType(player:getModelType())

    -- IS_DEFAULT_TYPE = player:getModelType() == "DEFAULT"

    -- models.avatar.root.LeftArm.LA_Default:setVisible(IS_DEFAULT_TYPE)
    -- models.avatar.root.RightArm.RA_Default:setVisible(IS_DEFAULT_TYPE)
    -- models.avatar.root.LeftArm.LA_Slim:setVisible(not IS_DEFAULT_TYPE)
    -- models.avatar.root.RightArm.RA_Slim:setVisible(not IS_DEFAULT_TYPE)

    if USE_SKIN then
        models.avatar.root.Head.H_Default:setPrimaryTexture("SKIN")
        models.avatar.root.Body.B_Default:setPrimaryTexture("SKIN")
        models.avatar.root.LeftArm.LA_Default:setPrimaryTexture("SKIN")
        models.avatar.root.LeftArm.LA_Slim:setPrimaryTexture("SKIN")
        models.avatar.root.RightArm.RA_Default:setPrimaryTexture("SKIN")
        models.avatar.root.RightArm.RA_Slim:setPrimaryTexture("SKIN")
        models.avatar.root.LeftLeg.LL_Default:setPrimaryTexture("SKIN")
        models.avatar.root.RightLeg.RL_Default:setPrimaryTexture("SKIN")
    end
end

function events.render()
    -- Sets the correct positions for sitting / riding
    if player:getVehicle() ~= nil then
        models.avatar:setPos(0, -10 * ScaleValue + 10 , 0)
    else
        models.avatar:setPos(0, 0, 0)
    end
end

--- Updates the players height
--- @param height integer|nil
function pings.setHeight(height)
    if not player:isLoaded() then return end

    if height then
        ResizeModel(height)
    else
        ResizeModel(DEFAULT_HEIGHT)
    end
end

--- @alias model_type "DEFAULT" | "SLIM" 

--- Updates the model type
--- @param type model_type
function pings.setModelType(type)
    if type == "DEFAULT" then
        models.avatar.root.LeftArm.LA_Default:setVisible(true)
        models.avatar.root.RightArm.RA_Default:setVisible(true)
        models.avatar.root.LeftArm.LA_Slim:setVisible(false)
        models.avatar.root.RightArm.RA_Slim:setVisible(false)
    else
        models.avatar.root.LeftArm.LA_Default:setVisible(false)
        models.avatar.root.RightArm.RA_Default:setVisible(false)
        models.avatar.root.LeftArm.LA_Slim:setVisible(true)
        models.avatar.root.RightArm.RA_Slim:setVisible(true)
    end
end


-- Update the avatar every few seconds
local UPDATE_INTERVAL = 100
local update_timer = 0

events.TICK:register(function()
    if not player:isLoaded() then return end

    if update_timer > 0 then
        update_timer = update_timer - 1
        return
    else
        update_timer = UPDATE_INTERVAL
    end

    if config:load("height") then
        pings.setHeight(tonumber(config:load("height")))
    else
        pings.setHeight(DEFAULT_HEIGHT)
    end

    pings.setModelType(player:getModelType())
end, "avatarUpdate")