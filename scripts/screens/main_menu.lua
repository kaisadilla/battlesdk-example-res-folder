local OPTION_HEIGHT = 24

local font = renderer:get_default_font();
if font == nil then Logger.error("Couldn't load font.") end

local options = {}

if G.dex_unlocked then
    table.insert(options, {
        name = font:render_plain_text_shadowed("Pokédex"),
        icon = renderer:get_sprite('ui/menu_icons/pokedex'),
        inactive_icon = renderer:get_sprite('ui/menu_icons/pokedex_gray'),
    })
end
table.insert(options, {
    name = font:render_plain_text_shadowed("Pokémon"),
    icon = renderer:get_sprite('ui/menu_icons/pokemon'),
    inactive_icon = renderer:get_sprite('ui/menu_icons/pokemon_gray'),
})
table.insert(options, {
    name = font:render_plain_text_shadowed("Bag"),
    icon = renderer:get_sprite('ui/menu_icons/bag_f'),
    inactive_icon = renderer:get_sprite('ui/menu_icons/bag_f_gray'),
})
table.insert(options, {
    name = font:render_plain_text_shadowed("$player"),
    icon = renderer:get_sprite('ui/menu_icons/player'),
    inactive_icon = renderer:get_sprite('ui/menu_icons/player_gray'),
})
table.insert(options, {
    name = font:render_plain_text_shadowed("Save"),
    icon = renderer:get_sprite('ui/menu_icons/save'),
    inactive_icon = renderer:get_sprite('ui/menu_icons/save_gray'),
})
table.insert(options, {
    name = font:render_plain_text_shadowed("Options"),
    icon = renderer:get_sprite('ui/menu_icons/options'),
    inactive_icon = renderer:get_sprite('ui/menu_icons/options_gray'),
})
table.insert(options, {
    name = font:render_plain_text_shadowed("Exit"),
    icon = renderer:get_sprite('ui/menu_icons/exit'),
    inactive_icon = renderer:get_sprite('ui/menu_icons/exit_gray'),
})

local cursor = 1

local menu_frame = renderer:get_frame('ui/frames/dp_menu')
local menu_padding = menu_frame.padding
local menu_selection_frame = renderer:get_sprite('ui/menu_selection')

local menu_pos = Vec2.new(renderer.width - 102, 2)
local menu_size = Vec2.new(
    100,
    (#options * OPTION_HEIGHT) + menu_padding.top + menu_padding.bottom + 2
)

if menu_frame == nil then
    Logger.error("Couldn't find menu frame")
end

Logger.info("Loaded main menu!")

function Screen:open ()
    Audio.play("menu_open")
end

function Screen:draw ()
    if menu_frame == nil then return end

    menu_frame.draw(menu_pos, menu_size)

    for i = 1, #options do
        draw_option(i)
    end

    draw_selection_frame()
end

function Screen:handle_input ()
    if Controls:get_key_down(ActionKey.up) then
        Audio.play_beep_short()

        if cursor > 1 then
            cursor = cursor - 1
        else
            cursor = #options
        end
    elseif Controls:get_key_down(ActionKey.down) then
        Audio.play_beep_short()

        if cursor < #options then
            cursor = cursor + 1
        else
            cursor = 1
        end
    end
    if Controls:get_key_down(ActionKey.primary) then
        -- TODO: Do whichever option is selected.
    end
    if
        Controls.get_key_down(ActionKey.secondary)
        or Controls.get_key_down(ActionKey.menu)
    then
        Audio.play_beep_short()
        Screen:close()
    end
end

function draw_option (i)
    local opt = options[i]

    local offset = Vec2.new(7, 6 + (OPTION_HEIGHT * (i - 1)))

    if i == cursor then
        opt.icon.draw(menu_pos + offset)
    else
        opt.inactive_icon.draw(menu_pos + offset)
    end

    opt.name.draw(menu_pos + offset + Vec2.new(24 + 2, 0 + 8))
end

function draw_selection_frame ()
    local offset = Vec2.new(
        menu_padding.left - 1,
        menu_padding.top + (OPTION_HEIGHT * (cursor - 1))
    )
    local size = Vec2.new(
        (menu_padding.right - menu_padding.left) + 2,
        OPTION_HEIGHT + 2
    )
    
    menu_selection_frame.draw(menu_pos + offset, Vec2:new(92, 26))
end
