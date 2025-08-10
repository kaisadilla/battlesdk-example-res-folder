target.meta = {
    blocks_input = false,

}

local font = renderer:get_default_font();
local line_height = font.line_height

local frame = renderer:get_frame('ui/frames/dp_box')
local frame_padding = frame.padding
local frame_pos = Vec2.new(2, 2)
local frame_size = Vec2.new(124, frame.padding.top + 4 + frame.padding.bottom + line_height * 5)


local txt_city = font:render_plain_text_shadowed("Letepa Town") -- TODO: Localize
local txt_player = font:render_plain_text_shadowed("Player")
local txt_badges = font:render_plain_text_shadowed("Badges")
local txt_pokedex = font:render_plain_text_shadowed("Pokédex")
local txt_time = font:render_plain_text_shadowed("Time")

local txt_player_val = font:render_plain_text_shadowed(loc("{player}"))
local txt_badges_val = font:render_plain_text_shadowed(0)
local txt_pokedex_val = font:render_plain_text_shadowed("42")
local txt_time_val = font:render_plain_text_shadowed(
    Fmt.time_span_as_hh_mm(G.time_played)
)

local txt_city_x = (frame_size.x - txt_city.width) / 2

txt_city.set_color(Color.new(49, 82, 206, 255))
txt_city.set_shadow_color(Color.new(49, 82, 206, 74))

function target:open ()

end

function target:update ()

end

function target:draw ()
    frame.draw(frame_pos, frame_size)

    txt_city.draw(frame_pos + Vec2.new(
        txt_city_x,
        frame_padding.top + 2
    ))

    draw_text(txt_player, 0, 1)
    draw_text(txt_badges, 0, 2)
    draw_text(txt_pokedex, 0, 3)
    draw_text(txt_time, 0, 4)

    draw_text(txt_player_val, 1, 1)
    draw_text(txt_badges_val, 1, 2)
    draw_text(txt_pokedex_val, 1, 3)
    draw_text(txt_time_val, 1, 4)
end

function target:handle_input ()
    if Controls.get_key_down(ActionKey.primary) then
        Audio.play_beep_short()
        target:close()
    end
end

--- Draws the text in the place given.
---@param sprite Sprite
---@param row any The row.
---@param col any The column.
function draw_text (sprite, row, col)
    sprite.draw(frame_pos + Vec2.new(
        frame_padding.left + 5 + (row * frame_size.x / 2),
        frame_padding.top + 2 + (col * line_height)
    ))
end
