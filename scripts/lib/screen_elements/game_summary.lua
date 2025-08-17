local game_summary = {}

local font = renderer.get_default_font();
local line_height = font.line_height

local frame = renderer.get_frame("ui/frames/dp_box")
local frame_padding = frame.padding
local frame_pos = Vec2.new(2, 2)
local frame_size = Vec2.new(124, frame.padding.top + 4 + frame.padding.bottom + line_height * 5)

local label_player = font.render_plain_text_shadowed("Player")
local label_badges = font.render_plain_text_shadowed("Badges")
local label_pokedex = font.render_plain_text_shadowed("Pokédex")
local label_time = font.render_plain_text_shadowed("Time")

---@type PlainTextSprite | nil
local val_city = nil
---@type PlainTextSprite | nil
local val_player = nil
---@type PlainTextSprite | nil
local val_badges = nil
---@type PlainTextSprite | nil
local val_pokedex = nil
---@type PlainTextSprite | nil
local val_time = nil

local txt_city_x = 0

--- Generates the summary's volatile info.
function game_summary.build ()
    val_city = font.render_plain_text_shadowed("Letepa Town") -- TODO: Localize
    val_player = font.render_plain_text_shadowed(loc("{player}"))
    val_badges = font.render_plain_text_shadowed(0)
    val_pokedex = font.render_plain_text_shadowed("42")
    val_time = font.render_plain_text_shadowed(
        Fmt.time_span_as_hh_mm(G.time_played)
    )

    val_city.set_color(Color.new(49, 82, 206, 255))
    val_city.set_shadow_color(Color.new(49, 82, 206, 74))

    txt_city_x = (frame_size.x - val_city.width) / 2
end

function game_summary.draw ()
    frame.draw(frame_pos, frame_size)

    val_city.draw(frame_pos + Vec2.new(
        txt_city_x,
        frame_padding.top + 2
    ))

    draw_text(label_player, 0, 1)
    draw_text(label_badges, 0, 2)
    draw_text(label_pokedex, 0, 3)
    draw_text(label_time, 0, 4)

    draw_text(val_player, 1, 1)
    draw_text(val_badges, 1, 2)
    draw_text(val_pokedex, 1, 3)
    draw_text(val_time, 1, 4)
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

return game_summary
