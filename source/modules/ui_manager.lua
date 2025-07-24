local ui_manager = {}

ui_manager.init = function(self)
    debug.log("UI Manager initialized.")
    self.config = {
        game = {
            name = "Pocket Lands",
            version = "0.1",
            author = "Nanskip",
            gdk = "NaN-GDK",
        },
        themes = {
            default = {
                blank_color = Color(255, 255, 255, 254),
                button_texture = textures.button_template,
                frame_texture = textures.frame_template,
            }
        }
    }

    self.theme = self.config.themes.default
    debug.log("UI Manager: set default theme.")
end

ui_manager.createButton = function(self, config)
    local defaultConfig = {
        text = "Button",
        size = Number2(100, 100),
        pos = Number2(0, 0),
        color = self.theme.blank_color,
        texture = self.theme.button_texture,
        onPress = function(self)
            debug.log("Button pressed: " .. self.text)
        end,
    }

    local cfg = {}
    for k, v in pairs(defaultConfig) do
        if config[k] ~= nil then
            cfg[k] = config[k]
        else
            cfg[k] = v
        end
    end

    -- creating button
    local button = _UIKIT:createFrame()
    -- button.background is a quad, let's texture it with 9-slice
    button.background.Image = {
        data = ui_manager.theme.button_texture,
        slice9 = true,
        slice9Width = 20,
        slice9Scale = 2
    }
    button.Width = cfg.size.X
    button.Height = cfg.size.Y
    button.pos = cfg.pos
    button.background.Color = cfg.color
    button.text = cfg.text

    button.onPress = cfg.onPress

    return button
end