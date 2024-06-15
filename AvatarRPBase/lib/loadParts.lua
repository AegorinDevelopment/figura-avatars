local lib = {}

--- Converts modelparts to an indexed table
--- @param model ModelPart
--- @return table<string, ModelPart>
local function getModelChildsAssoc(model)
    local children = model:getChildren()
    local childTable = {}

    for _, child in pairs(children) do
        childTable[child:getName()] = child
    end

    return childTable
end

--- Loads custom parts and moves them to the correct position
function lib.loadCustomParts()
    if models.parts == nil then
        return
    end

    local defaultBones = getModelChildsAssoc(models.avatar.root)
    local parts = getModelChildsAssoc(models.parts)

    parts["avatar"] = nil

    for _, part in pairs(parts) do
        local bones = part:getChildren()

        for _, bone in pairs(bones) do
            if defaultBones[bone:getName()] ~= nil then
                local subBones = bone:getChildren()

                for _, subBone in pairs(subBones) do
                    subBone:moveTo(defaultBones[bone:getName()])
                end
            end
        end
    end
end

return lib