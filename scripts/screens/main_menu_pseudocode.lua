local menu_open = Registry.sounds['menu_open']
local menu_close = Registry.sounds['menu_close']
local beep_short = Registry.sounds['beep_short']
local current_index = 1

local OPTIONS = {
    { text = "menu.pokedex", image = "menu/pokedex" },
    { text = "menu.pokemon", image = "menu/pokemon" },
    { text = "menu.bag", image = "menu/bag" },
    { text = "menu.player", image = "menu/player" },
    { text = "menu.save", image = "menu/save" },
    { text = "menu.options", image = "menu/options" },
    { text = "menu.debug", image = "menu/debug" },
    { text = "menu.exit", image = "menu/exit" },
}

function Screen:open ()
    menu_open:play()
end

function Screen:render ()
    local screen_width = Renderer:get_width()
    local screen_height = Renderer:get_height()

    local frame = Settings:get_box_frame()
    
    local size = IVec2:new(60, 200)
    local pos = IVec2:new(
        screen_width - size.x - 10,
        screen_height - size.y - 10
    )

    frame:draw(pos, size)

    for index, value in ipairs(OPTIONS) do
        draw_option(pos, index, index == current_index)
    end

    draw_highlight_frame(pos, size, current_index)

    return false -- whether this blocks screen layers below it.
end

function Screen:handle_input ()
    if Controls:get_key_down(ActionKey.up) then
        beep_short.play()

        if current_index > 1 then
            current_index = current_index - 1
        end
    end
    if Controls:get_key_down(ActionKey.down) then
        beep_short.play()

        if current_index < #OPTIONS then
            current_index = current_index + 1
        end
    end
    if Controls:get_key_down(ActionKey.primary) then
        -- TODO: Do whichever option is selected.
    end
    if Controls:get_key_down(ActionKey.secondary) then
        menu_close:play()
        Screen:close()
    end
end

--- Draw one option
---@param menu_pos IVec2 The menu's position.
---@param index number Its index in the menu.
---@param highlighted boolean True if this option is highlighted.
function draw_option (menu_pos, index, highlighted)
    local option = OPTIONS[index]

    local sprite = Registry.uiSprites[option.image]
    local sprite_pos = IVec2:new(menu_pos.x, menu_pos.y + ((index - 1) * 24))

    local txt = Localization:text(option.text)
    local txt_pos = sprite_pos + IVec2:new(24, 0)

    sprite:draw(sprite_pos, sprite, {
        grayscale = not highlighted
    })
    Graphics:draw_text(txt_pos, txt)
end

function draw_highlight_frame (menu_pos, menu_size, index)
    local pos = IVec2:new(menu_pos.x, menu_pos.y + ((index - 1) * 24))
    local size = IVec2:new(menu_size.x, 26)

    local highlight_frame = Registry.frameSprites['menu_highlight']
    highlight_frame:draw(pos, size)
end
