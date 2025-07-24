Modules = {
    worldgen = "modules/worldgen.lua",
    loading_screen = "modules/loading_screen.lua",
    debug = "modules/debug.lua",
    mathlib = "modules/mathlib.lua",
    advanced_ui = "modules/advanced_ui.lua",
    game_controller = "modules/game_controller.lua",
    buildings = "modules/buildings.lua",
    ui_manager = "modules/ui_manager.lua",
    zone_manager = "modules/zone_manager.lua",
}

Models = {
    tree = "models/tree.glb",
    rock = "models/rock.glb",
    flag = "models/flag.glb",
    cursor_outline = "models/cursor_outline.glb",
}

Textures = {
    intro_logo = "textures/intro_logo.png",
    cursor_outline = "textures/cursor_outline.png",
    button_template = "textures/button_template.png",
    framee_template = "textures/frame_template.png",
}

Sounds = {
    loading_completed = "sounds/loading_completed.mp3",
    intro = "sounds/intro.mp3",
}

Data = {

}

Other = {
    vcr_font = "other/vcr_font.ttf",
}

_ON_START = function()
    loading_screen:intro()
    _UI:init()
end

_ON_START_CLIENT = function()
    _UIKIT = require("uikit")
    _UI = advanced_ui

    loading_screen:start()
end