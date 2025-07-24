local buildings = {}

buildings.spawn = function(self, name, pos)
    local building = Object()
    building.name = name
    building.Position = Number3(
        (pos[1] - _TERRAIN.Width//2)*5 + 2.5,
        15,
        (pos[2] - _TERRAIN.Depth//2)*5 + 2.5
    )
    building.Rotation = Rotation(0, 0, 0)

    building.mesh = self:getBuilding(name, building)
    building.mesh:SetParent(building)

    building:SetParent(World)

    return building
end

buildings.clear = function(self)
    for _, building in ipairs(self.buildings) do
        self:despawn(building)
    end
end

buildings.despawn = function(self, building)
    building:Remove()
end

buildings.getBuilding = function(self, name, building)
    local mesh = models[buildings.list[name].name][1]:Copy()
    if buildings.list[name].objects ~= 1 then
        for i = 2, buildings.list[name].objects do
            local object = models[buildings.list[name].name][i]:Copy()
            object:SetParent(building)
        end
    end
    mesh.Rotation = Rotation(0, 0, 0)

    return mesh
end

buildings.list = {
    flag = {
        name = "flag",
        objects = 1,
        scale = 1.5
    },
}