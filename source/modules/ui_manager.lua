local ui_manager = {}

ui_manager.init = function(self)
    self.config = {
        game = {
            name = "Pocket Lands",
            version = "0.1",
            author = "Nanskip",
            gdk = "NaN-GDK",
        },
        themes = {
            default = {
                blank_color = Color(255, 255, 255),
                button_texture = textures.button_template,
                frame_texture = textures.frame_template,
            }
        }
    }
end