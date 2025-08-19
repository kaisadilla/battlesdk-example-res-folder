local OPTION_HEIGHT = 24

---@type Font
local font
local options

---@type FrameSprite
local frame
---@type Rect
local frame_padding
---@type Vec2
local frame_size

local menu_cursor_frame = renderer.get_sprite('ui/menu_selection')
local menu_pos = Vec2.new(renderer.width - 102, 2)

local cursor = 1
local input_locked = false

local function init ()
    font = renderer.get_default_font();
    options = {}

    frame = renderer.get_default_box_frame()
    frame_padding = frame.padding

    if G.dex_unlocked then
        table.insert(options, {
            id = "pokedex",
            name = font:render_plain_text_shadowed(loc("menu.pokedex")),
            icon = renderer.get_sprite('ui/menu_icons/pokedex'),
            inactive_icon = renderer.get_sprite('ui/menu_icons/pokedex_gray'),
        })
    end
    table.insert(options, {
        id = "pokemon",
        name = font:render_plain_text_shadowed(loc("menu.pokemon")),
        icon = renderer.get_sprite('ui/menu_icons/pokemon'),
        inactive_icon = renderer.get_sprite('ui/menu_icons/pokemon_gray'),
    })
    table.insert(options, {
        id = "bag",
        name = font:render_plain_text_shadowed(loc("menu.bag")),
        icon = renderer.get_sprite('ui/menu_icons/bag_f'),
        inactive_icon = renderer.get_sprite('ui/menu_icons/bag_f_gray'),
    })
    table.insert(options, {
        id = "player",
        name = font:render_plain_text_shadowed(loc("menu.player")),
        icon = renderer.get_sprite('ui/menu_icons/player'),
        inactive_icon = renderer.get_sprite('ui/menu_icons/player_gray'),
    })
    table.insert(options, {
        id = "save",
        name = font:render_plain_text_shadowed(loc("menu.save")),
        icon = renderer.get_sprite('ui/menu_icons/save'),
        inactive_icon = renderer.get_sprite('ui/menu_icons/save_gray'),
    })
    table.insert(options, {
        id = "options",
        name = font:render_plain_text_shadowed(loc("menu.options")),
        icon = renderer.get_sprite('ui/menu_icons/options'),
        inactive_icon = renderer.get_sprite('ui/menu_icons/options_gray'),
    })
    table.insert(options, {
        id = "exit",
        name = font:render_plain_text_shadowed(loc("menu.exit")),
        icon = renderer.get_sprite('ui/menu_icons/exit'),
        inactive_icon = renderer.get_sprite('ui/menu_icons/exit_gray'),
    })

    frame_size = Vec2.new(
        100,
        (#options * OPTION_HEIGHT) + frame_padding.top + frame_padding.bottom
    )
end

function target.open ()
    init()

    Audio.play("menu_open")
    input_locked = false
end

function target.draw ()
    if frame == nil then return end

    frame.draw(menu_pos, frame_size)

    for i = 1, #options do
        draw_option(i)
    end

    draw_selection_frame()
end

function target.handle_input ()
    if input_locked then return end

    if Controls.get_key_down(ActionKey.up) then
        Audio.play_beep_short()

        if cursor > 1 then
            cursor = cursor - 1
        else
            cursor = #options
        end
    elseif Controls.get_key_down(ActionKey.down) then
        Audio.play_beep_short()

        if cursor < #options then
            cursor = cursor + 1
        else
            cursor = 1
        end
    end
    if Controls.get_key_down(ActionKey.primary) then
        if options[cursor].id == "bag" then
            input_locked = true
            Audio.play_beep_short()
            Screen.play_transition("transitions/fade", 0.25, false)
            Script.wait(0.5)
            Screen.open_bag()
            Screen.play_transition("transitions/horizontal_wipe", 0.25, true)
            input_locked = false
        elseif options[cursor].id == "save" then
            Audio.play_beep_short()
            target.close()
            Screen.open_save_game()
        elseif options[cursor].id == "options" then
            Audio.play_beep_short()
        elseif options[cursor].id == "exit" then
            Audio.play_beep_short()
            target.close()
        end
    end
    if
        Controls.get_key_down(ActionKey.secondary)
        or Controls.get_key_down(ActionKey.menu)
    then
        Audio.play_beep_short()
        target.close()
    end
end

-- #region Draw functions
function draw_option (i)
    local opt = options[i]

    local offset = Vec2.new(7, 5 + (OPTION_HEIGHT * (i - 1)))

    if i == cursor then
        opt.icon.draw(menu_pos + offset)
    else
        opt.inactive_icon.draw(menu_pos + offset)
    end

    opt.name.draw(menu_pos + offset + Vec2.new(24 + 2, 0 + 5))
end

function draw_selection_frame ()
    local offset = Vec2.new(
        frame_padding.left - 1,
        frame_padding.top + (OPTION_HEIGHT * (cursor - 1)) - 1
    )
    local size = Vec2.new(
        (frame_padding.right - frame_padding.left) + 2,
        OPTION_HEIGHT + 2
    )
    
    menu_cursor_frame.draw(menu_pos + offset, Vec2:new(92, 26))
end
-- #endregion Draw functions
