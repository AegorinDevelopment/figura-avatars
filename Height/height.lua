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
    ResizeModel(PLAYER_HEIGHT)
    LoadCustomParts()
    
    IS_DEFAULT_TYPE = player:getModelType() == "DEFAULT"

    models.base.root.LeftArm:setVisible(IS_DEFAULT_TYPE)
    models.base.root.RightArm:setVisible(IS_DEFAULT_TYPE)
    models.base.root.LeftArmSlim:setVisible(not IS_DEFAULT_TYPE)
    models.base.root.RightArmSlim:setVisible(not IS_DEFAULT_TYPE)

    if USE_SKIN then
        models.base:setPrimaryTexture("SKIN")
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

--- Converts modelparts to an indexed table
--- @param model ModelPart
--- @return table<string, ModelPart>
function GetModelChildsAssoc(model)
    local children = model:getChildren()
    local childTable = {}

    for _, child in pairs(children) do
        childTable[child:getName()] = child
    end

    return childTable
end

--- Loads custom parts and moves them to the correct position
function LoadCustomParts()
    local defaultBones = GetModelChildsAssoc(models.base.root)
    local parts = GetModelChildsAssoc(models)
    parts["base"] = nil

    for _, part in pairs(parts) do
        -- if part == nil then goto continue end
        
        local bones = part:getChildren()

        for _, bone in pairs(bones) do
            if defaultBones[bone:getName()] ~= nil then
                bone:moveTo(defaultBones[bone:getName()])
            end
        end

        -- ::continue::
    end
end