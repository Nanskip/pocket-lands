local game_controller = {}

game_controller.init = function()
    debug.log("Game controller initialized.")
    _CAMERA_POS = Number3(0, 0, 0)
    _CAMERA_ROT = Rotation(1, 0, 0)
    Camera:SetModeFree()
    _TERRAIN = worldgen.generateFlatLand()

    _DX = 0
    _DY = 0

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
    end
end