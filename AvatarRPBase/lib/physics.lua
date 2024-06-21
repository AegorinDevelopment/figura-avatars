--[[
    Based on: Swinging Physics by Manuel_
    https://github.com/Manuel-3/figura-scripts/tree/main/src/swingingphysics
--]]

local lib = {}

local GRAVITY = 0.05
local FRICTION = 0.1
local CENTRIFUGAL_FORCE = 0.2

local playerVelocity

local function sin_rad(x)
    return math.sin(math.rad(x))
end
local function cos_rad(x)
    return math.cos(math.rad(x))
end

local moveAngle = 0
local playerSpeed = 0
local _yRotHead = 0
local yRotHead = 0
local forceHead = 0
local downHead = vec(0, 0, 0)
local _yRotBody = 0
local yRotBody = 0
local forceBody = 0
local downBody = vec(0, 0, 0)

--- Returns movement angle relative to look direction (2D top down view, ignores Y)
--- - 0   : forward
--- - 45  : left forward
--- - 90  : left
--- - 135 : left backwards
--- - 180 : backwards
--- - -135: right backwards
--- - -90 : right
--- - -45 : right forward
--- @param velocity Vector3 player velocity
--- @return integer
local function playerMoveAngle(velocity)
    local lookdir = player:getLookDir()
    local movementAngle = 90 + math.deg(math.atan(velocity.z / velocity.x))

    if velocity.x < 0 then
        movementAngle = movementAngle + 180
    end

    local lookDirAngle = 90 + math.deg(math.atan(lookdir.z / lookdir.x))

    if lookdir.x < 0 then
        lookDirAngle = lookDirAngle + 180
    end

    local ret = lookDirAngle - movementAngle

    if ret ~= ret then
        return 0
    else
        return ret
    end
end

--- Returns the angle in degree between 0 0 and a given point
--- @param pivot Vector3 Point to calculate the angle to
--- @return number Angle in degree
local function getAngleToCenter(pivot)
    return math.deg(math.atan2(pivot.z, pivot.x)) + 90
end


function events.entity_init()
    _yRotHead = player:getRot().y
    yRotHead = _yRotHead

    _yRotBody = player:getBodyYaw()
    yRotBody = _yRotBody

    playerVelocity = player:getVelocity()
    playerVelocity.y = 0
end

function events.tick()
    moveAngle = playerMoveAngle(playerVelocity)

    playerVelocity = player:getVelocity()
    playerVelocity.y = 0

    playerSpeed = playerVelocity:length() * 6

    local playerRot = player:getRot()

    -- Head
    _yRotHead = yRotHead
    yRotHead = playerRot.y

    forceHead = (_yRotHead - yRotHead) / 8
    downHead.x = playerRot.x

    -- Body
    _yRotBody = yRotBody
    yRotBody = player:getBodyYaw()

    forceBody = (_yRotBody - yRotBody) / 8
    if player:getPose() == "CROUCHING" then
        downBody.x = math.deg(0.5)
    else
        downBody.x = 0
    end
end


--- @class SwingHandler
local SwingHandler = {
    --- @param enabled boolean
    setEnabled = function(self, enabled) end
}

--- Adds swinging physics to a part that is attached to the head or body
--- @param part ModelPart The model part that should swing
--- @param type "Head"|"Body" Parent type the physics should use
--- @param limits table|nil Limits the rotation of the part to make it appear like its colliding with something. Format: {xLow, xHigh, yLow, yHigh, zLow, zHigh} (optional)
--- @param root ModelPart|nil Required if it is part of a chain. Note that the first chain element does not need this root parameter, and does also not need the depth parameter. Only following chain links need it.
--- @param depth number|nil An integer that should increase by 1 for each consecutive chain link after the root. The root itself doesnt need this parameter. This increases the friction which makes it look more realistic.
--- @return SwingHandler
function lib.setSwing(part, type, limits, root, depth)
    assert(part, "Model Part does not exist!")

    --if depth == nil then depth = 0 end
    depth = depth or 0
    
    local angleToCenter = getAngleToCenter(part:getPivot())

    local _rotation = vec(0,0,0)
    local rotation = vec(0,0,0)
    local velocity = vec(0,0,0)

    local downPart
    local forcePart

    if type == "Head" then
        downPart = downHead
        forcePart = forceHead
    elseif type == "Body" then
        downPart = downBody
        forcePart = forceBody
    else
        error("Invalid type: " .. type .. " ['Head'/'Body']")
    end

    _FRICTION = FRICTION * math.pow(1.5, depth)

    local handler = {
        --- @type SwingHandler
    }

    handler.enabled = true
    --- @param enabled boolean
    function handler:setEnabled(enabled)
        self.enabled = enabled
        if not self.enabled then
            rotation = vec(0, 0, 0)
            _rotation = rotation
            part:setOffsetRot(rotation)
        end
    end

    events.tick:register(function()
        if not handler.enabled then return end

        _rotation = rotation

        local gravity
        if root ~= nil then
            gravity = GRAVITY * (-rotation + (downPart - root:getOffsetRot()))
        else
            gravity = GRAVITY * (-rotation + downPart)
        end
        
        local force = vec(0, 0, 0)

        force.x = sin_rad(angleToCenter) * forcePart - cos_rad(moveAngle) * playerSpeed + cos_rad(angleToCenter) * math.abs(forcePart) * CENTRIFUGAL_FORCE
        force.z = cos_rad(angleToCenter) * forcePart + sin_rad(moveAngle) * playerSpeed - sin_rad(angleToCenter) * math.abs(forcePart) * CENTRIFUGAL_FORCE

        velocity = (velocity + gravity + force) * (1-_FRICTION)
        rotation = rotation + velocity

        if limits ~= nil then 
            if not handler.enabled then return end
            
            if rotation.x < limits[1] then rotation.x = limits[1] velocity.x = 0 end
            if rotation.x > limits[2] then rotation.x = limits[2] velocity.x = 0 end
            if rotation.y < limits[3] then rotation.y = limits[3] velocity.y = 0 end
            if rotation.y > limits[4] then rotation.y = limits[4] velocity.y = 0 end
            if rotation.z < limits[5] then rotation.z = limits[5] velocity.z = 0 end
            if rotation.z > limits[6] then rotation.z = limits[6] velocity.z = 0 end
        end
    end)

    events.render:register(function(delta)
        if not handler.enabled then return end

        part:setOffsetRot(math.lerp(_rotation, rotation, delta))
    end)

    return handler
end

return lib