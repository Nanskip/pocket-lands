local worldgen = {}

worldgen.generateFlatLand = function(config)
    local defaulConfig = {
        scale = 50, -- scale of the land, width and height
        treeCount = 300, -- number of trees per terrain
        rockCount = 200, -- number of rocks per terrain
        -- other config parameters later
    }

    local cfg = {}
    for k, v in pairs(defaulConfig) do
        if config[k] ~= nil then
            cfg[k] = config[k]
        else
            cfg[k] = v
        end
    end

    -- generating terrain
    local terrain = MutableShape()

    for x = 0, cfg.scale-1 do
        for y = 0, cfg.scale-1 do
            local block = Block(Color(255, 255, 255), Number3(x, 0, y))

            terrain:AddBlock(block)
        end
    end

    for i = 1, cfg.treeCount do
        local x = math.random(0, cfg.scale-1)
        local z = math.random(0, cfg.scale-1)
        local y = 0

        local tree = models.tree:Copy()
        tree:SetParent(terrain)
        tree.Position = Number3(x, y+1, z)
        tree.Rotation.Y = math.random(0, 360) * math.pi / 180
    end

    terrain:SetParent(World)

    return terrain
end