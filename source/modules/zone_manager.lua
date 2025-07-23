-- Zone manager
-- basically it is a zone manager do define and show different lands on map

local zone_manager = {}

zone_manager.createZone = function(self, name, color)
    local zone = {
        name = name or "unnamed_zone",
        color = color or Color(255, 255, 255),
        lands = {},
        borders = {},
    }

    for x = 1, _MAP_SIZE do
        zone.lands[x] = {}
        for y = 1, _MAP_SIZE do
            zone.lands[x][y] = false
        end
    end

    return zone
end

zone_manager.addLand = function(self, zone, x, y)
    zone.lands[x][y] = true
end

zone_manager.showZone = function(self, zone)
    for x = 1, _MAP_SIZE do
        for y = 1, _MAP_SIZE do
            if zone.lands[x][y] then
                -- calculate borders
                local left = x - 1
                local right = x + 1
                local top = y - 1
                local bottom = y + 1

                if zone.lands[left] == false then
                    zone.borders[#zone.borders+1] = zone_manager:spawnBorder(zone, x, y, "left")
                end
                if zone.lands[right] == false then
                    zone.borders[#zone.borders+1] = zone_manager:spawnBorder(zone, x, y, "right")
                end
                if zone.lands[top] == false then
                    zone.borders[#zone.borders+1] = zone_manager:spawnBorder(zone, x, y, "top")
                end
                if zone.lands[bottom] == false then
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
    if direction == "top" then
        pos_offset.Y = 1
        rot_offset.Y = math.pi/2
    end
    if direction == "bottom" then
        rot_offset.Y = -math.pi/2
    end
    local quad = Quad()

    quad.Color = zone.color
    quad.Scale = Number3(0.1, 1, 1)*5
    quad.Position = Number3(x, 15.01, y)*5 + pos_offset
    quad.Rotation = Rotation(math.pi/2, 0, 0) + rot_offset

    quad:SetParent(World)

    return quad
end