local game_controller = {}

game_controller.init = function()
    debug.log("Game controller initialized.")
    _CAMERA_POS = Number3(0, 0, 0)
    _CAMERA_ROT = Rotation(1, 0, 0)
    Camera:SetModeFree()

    _MAP_SIZE = 50
    _TERRAIN = worldgen.generateFlatLand()
    _TERRAIN.Physics = PhysicsMode.StaticPerBlock

    _DX = 0
    _DY = 0
    
    _CURSOR_QUAD = Quad()
    _CURSOR_QUAD.Scale = 5
    _CURSOR_QUAD.Color = Color(255, 255, 255, 127)
    _CURSOR_QUAD.Rotation.X = math.pi/2

    _CURSOR_QUAD:SetParent(World)

    Client.DirectionalPad = function(x, y)
        _DX = x
        _DY = y
    end

    game_controller.start()
end

game_controller.start = function()
    debug.log("Game controller started working on main scene.")

    game_controller.tick = Object()
    game_controller.tick.Tick = function(self, dt)
        Camera.Position = _CAMERA_POS
        Camera.Rotation = _CAMERA_ROT
        Camera.Position = Camera.Position + Camera.Backward * 50

        _CAMERA_POS = _CAMERA_POS + (Number3(_DX, 0, _DY) * dt * 20)

        if _HIT_POS ~= nil and _HIT_OBJECT ~= nil then
            _CURSOR_QUAD.Position = Number3((_HIT_POS.X)//5*5, 15.02, (_HIT_POS.Z)//5*5)
        end

        if game_controller.last_camera_pos ~= Number3(_CAMERA_POS.X, _CAMERA_POS.Y, _CAMERA_POS.Z)
        and game_controller.last_camera_pos ~= nil then
            local difference = Number3(
                (game_controller.last_camera_pos.X - _CAMERA_POS.X),
                (game_controller.last_camera_pos.Y - _CAMERA_POS.Y),
                (game_controller.last_camera_pos.Z - _CAMERA_POS.Z)
            )
            _HIT_POS = Number3(
                (_HIT_POS.X - difference.X + 2.5),
                (_HIT_POS.Y - difference.Y + 2.5),
                (_HIT_POS.Z - difference.Z + 2.5)
            )
            game_controller.last_camera_pos = Number3(
                (_CAMERA_POS.X + 2.5),
                (_CAMERA_POS.Y + 2.5),
                (_CAMERA_POS.Z + 2.5)
            )
        end

        if _HIT_POS ~= nil then
            _CURSOR_POS = Number3(_HIT_POS.X//5 + (_TERRAIN.Width//2), 0, _HIT_POS.Z//5 + (_TERRAIN.Depth//2))
        end
    end
end

game_controller.captureLand = function(self, x, y)
    _HAS_FLAG = true
    _TERRAIN.objects[_CURSOR_POS.X][_CURSOR_POS.Z] = "flag"

    _PLAYER_ZONE = zone_manager:createZone("Player", Color(255, 255, 255))
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X, _CURSOR_POS.Z)

    -- capture all adjacent lands on the horizontal and vertical
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X-1, _CURSOR_POS.Z)
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X+1, _CURSOR_POS.Z)
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X, _CURSOR_POS.Z-1)
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X, _CURSOR_POS.Z+1)

    -- capture all adjacent lands on the diagonal
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X-1, _CURSOR_POS.Z-1)
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X-1, _CURSOR_POS.Z+1)
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X+1, _CURSOR_POS.Z-1)
    zone_manager:addLand(_PLAYER_ZONE, _CURSOR_POS.X+1, _CURSOR_POS.Z+1)

    zone_manager:showZone(_PLAYER_ZONE)

    _PLAYER_ZONE.buildings[_CURSOR_POS.X][_CURSOR_POS.Z] = buildings:spawn("flag", {_CURSOR_POS.X, _CURSOR_POS.Z})
end

game_controller.moveListener = LocalEvent:Listen(LocalEvent.Name.PointerMove, function(pe)
    game_controller.pointer = pe
    for key, value in pairs(pe) do
        print(key, value)
    end

    game_controller.cast_ray(pe)
end)

game_controller.clickListener = LocalEvent:Listen(LocalEvent.Name.PointerClick, function(pe)
    if _CURSOR_POS ~= nil then
        local item = _TERRAIN.objects[_CURSOR_POS.X][_CURSOR_POS.Z]
        if item == "nothing" or item == nil then
            if not _HAS_FLAG then
                game_controller:captureLand(_CURSOR_POS.X, _CURSOR_POS.Z)
            end
        else
            print("There is an " .. item .. " here!")
        end
    end
end)

game_controller.cast_ray = function(pe)
    if pe ~= nil and _CAMERA_POS ~= nil then
        local impact = pe:CastRay()
        game_controller.pointer = pe
        game_controller.last_camera_pos = Number3(_CAMERA_POS.X, _CAMERA_POS.Y, _CAMERA_POS.Z)

        if impact and impact.Block then
            local hit_pos = impact.Block.Position
            _HIT_POS = hit_pos
            _HIT_OBJECT = impact.Object
        else
            _HIT_POS = nil
            _HIT_OBJECT = nil
        end
    end
end