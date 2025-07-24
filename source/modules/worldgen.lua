local worldgen = {}

worldgen.generateFlatLand = function(config)
    local defaulConfig = {
        scale = _MAP_SIZE, -- scale of the land, width and height
        size = 5, -- size of mutableShape object
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
    terrain.Scale = cfg.size

    local objects = {}

    for x = 0, cfg.scale-1 do
        objects[x] = {}
        for y = 0, cfg.scale-1 do
            local randomDiff = math.random(-3, 3)*2
            local color = Color(75 + randomDiff, 189 + randomDiff, 67 + randomDiff)
            local block = Block(color, Number3(x, 0, y))

            terrain:AddBlock(block)
        end
    end

    for i = 1, cfg.treeCount do
        local x = math.random(0, cfg.scale-1)
        local z = math.random(0, cfg.scale-1)
        local y = 0

        if objects[x][z] == nil then
            local tree = models.tree[1]:Copy()
            objects[x][z] = "tree"
            tree:SetParent(terrain)
            tree.Position = Number3(x+0.5, y+1, z+0.5) * cfg.size
            tree.Scale = 0.2
            tree.Rotation.Y = math.random(0, 360) * math.pi / 180

            tree.Shadow = true
        end
    end

    for i = 1, cfg.rockCount do
        local x = math.random(0, cfg.scale-1)
        local z = math.random(0, cfg.scale-1)
        local y = 0

        if objects[x][z] == nil then
            local rock = models.rock[1]:Copy()
            objects[x][z] = "rock"
            rock:SetParent(terrain)
            rock.Position = Number3(x+0.5, y+1, z+0.5) * cfg.size
            rock.Scale = 0.25
            rock.Rotation.Y = math.random(0, 360) * math.pi / 180

            rock.Shadow = true
        end
    end

    terrain:SetParent(World)
    terrain.Pivot = Number3(terrain.Width / 2, -2, terrain.Depth / 2)
    terrain.objects = objects
    terrain.isTerrain = true

    return terrain
end