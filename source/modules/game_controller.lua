local game_controller = {}

game_controller.init = function()
    debug.log("Game controller initialized.")
    _CAMERA_POS = Number3(0, 0, 0)
    _CAMERA_ROT = Rotation(1, 0, 0)
    Camera:SetModeFree()
    _TERRAIN = worldgen.generateFlatLand()

    _DX = 0
    _DY = 0
    
    _CURSOR_QUAD = models.cursor_outline[1]:Copy()
    _CURSOR_QUAD.Scale = 15

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
            _CURSOR_QUAD.Position = Number3(_HIT_POS.X//5*5, 20, _HIT_POS.Z//5*5)
        end
    end
end

game_controller.moveListener = LocalEvent:Listen(LocalEvent.Name.PointerMove, function(pe)
    game_controller.pointer = { pe.X, pe.Y }

    -- Получаем луч от курсора
    local ray = Camera:ScreenToRay(Number2(pe.X, pe.Y))
    local impact = ray:Cast()

    if impact then
        local hit_pos = ray.Origin + ray.Direction * impact.Distance
        _HIT_POS = hit_pos
        _HIT_OBJECT = impact.Object
    else
        _HIT_POS = nil
        _HIT_OBJECT = nil
    end
end)
