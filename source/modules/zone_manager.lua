-- Zone manager
-- basically it is a zone manager do define and show different lands on map

local zone_manager = {}

zone_manager.createZone = function(self, name, color)
    local zone = {
        name = name or "unnamed_zone",
        color = color or Color(255, 255, 255),
        lands = {},
        buildings = {},
        borders = {},
    }

    for x = 1, _MAP_SIZE do
        zone.lands[x] = {}
        zone.buildings[x] = {}
        for y = 1, _MAP_SIZE do
            zone.lands[x][y] = false
            zone.buildings[x][y] = nil
        end
    end

    return zone
end

zone_manager.addLand = function(self, zone, x, y)
    zone.lands[x][y] = true
end

zone_manager.showZone = function(self, zone)
    for key, value in pairs(zone.borders) do
        value:SetParent(nil)
        value = nil
    end
    for x = 1, _MAP_SIZE do
        for y = 1, _MAP_SIZE do
            if zone.lands[x][y] then
                -- spawn transparent quad to show land color
                local quad = Quad()
                quad.Color = zone.color
                quad.Color.A = 50
                quad.Scale = Number3(1, 1, 1)*5
                quad.Rotation.X = math.pi/2
                quad.Position = Number3(
                    (x - _TERRAIN.Width//2)*5,
                    15.005,
                    (y - _TERRAIN.Depth//2)*5
                )
                zone.borders[#zone.borders+1] = quad
                quad:SetParent(World)

                -- calculate borders
                if zone.lands[x-1][y] == false then
                    zone.borders[#zone.borders+1] = zone_manager:spawnBorder(zone, x, y, "left")
                end
                if zone.lands[x+1][y] == false then
                    zone.borders[#zone.borders+1] = zone_manager:spawnBorder(zone, x, y, "right")
                end
                if zone.lands[x][y+1] == false then
                    zone.borders[#zone.borders+1] = zone_manager:spawnBorder(zone, x, y, "top")
                end
                if zone.lands[x][y-1] == false then
                    zone.borders[#zone.borders+1] = zone_manager:spawnBorder(zone, x, y, "bottom")
                end
            end
        end
    end
end

zone_manager.spawnBorder = function(self, zone, x, y, direction)
    local pos_offset = Number3(0, 0, 0)
    local rot_offset = Rotation(0, 0, 0)
    if direction == "left" then
        pos_offset.X = -1
    end
    if direction == "right" then
        pos_offset.X = -0.05
    end
    if direction == "top" then
        pos_offset.Z = 1-0.05
        rot_offset.Y = -math.pi/2
    end
    if direction == "bottom" then
        rot_offset.Y = -math.pi/2
    end
    local quad = Quad()

    quad.Color = zone.color
    quad.Scale = Number3(0.05, 1, 1)*5
    quad.Position = Number3(
        (x - _TERRAIN.Width//2)*5 + 5,
        15.01,
        (y - _TERRAIN.Depth//2)*5
    ) + (pos_offset*5)
    quad.Rotation = Rotation(math.pi/2, 0, 0) + rot_offset

    quad:SetParent(World)

    return quad
end