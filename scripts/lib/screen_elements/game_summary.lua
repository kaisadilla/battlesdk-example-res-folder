---@class GameSummary
local GameSummary = {}
GameSummary.__index = GameSummary

local draw_text

---@return GameSummary
function GameSummary.new ()
    local font = renderer.get_default_font()
    local line_height = font.line_height
    local frame = renderer.get_default_box_frame()
    local frame_size = Vec2.new(124, frame.padding.top + 4 + frame.padding.bottom + line_height * 5)

    local val_city = font.render_plain_text_shadowed("Letepa Town")
    val_city.set_color(Color.new(49, 82, 206, 255))
    val_city.set_shadow_color(Color.new(49, 82, 206, 74))

    return setmetatable({
        font = font,
        line_height = line_height,

        frame = frame,
        frame_padding = frame.padding,
        frame_pos = Vec2.new(2, 2),
        frame_size = frame_size,

        label_player = font.render_plain_text_shadowed("Player"),
        label_badges = font.render_plain_text_shadowed("Badges"),
        label_pokedex = font.render_plain_text_shadowed("Pokédex"),
        label_time = font.render_plain_text_shadowed("Time"),

        val_city = val_city, -- TODO: Localize,
        val_player = font.render_plain_text_shadowed(loc("{player}")),
        val_badges = font.render_plain_text_shadowed(0),
        val_pokedex = font.render_plain_text_shadowed("42"),
        val_time = font.render_plain_text_shadowed(
            Fmt.time_span_as_hh_mm(G.time_played)
        ),

        txt_city_x = (frame_size.x - val_city.width) / 2,
    }, GameSummary)
end

---@param self GameSummary
function GameSummary:draw ()
    self.frame.draw(self.frame_pos, self.frame_size)

    self.val_city.draw(
        self.frame_pos + Vec2.new(self.txt_city_x, self.frame_padding.top + 2)
    )

    draw_text(self, self.label_player, 0, 1)
    draw_text(self, self.label_badges, 0, 2)
    draw_text(self, self.label_pokedex, 0, 3)
    draw_text(self, self.label_time, 0, 4)

    draw_text(self, self.val_player, 1, 1)
    draw_text(self, self.val_badges, 1, 2)
    draw_text(self, self.val_pokedex, 1, 3)
    draw_text(self, self.val_time, 1, 4)
end

--- Draws the text in the place given.
---@param self GameSummary
---@param sprite Sprite
---@param row any The row.
---@param col any The column.
draw_text = function (self, sprite, row, col)
    sprite.draw(self.frame_pos + Vec2.new(
        self.frame_padding.left + 5 + (row * self.frame_size.x / 2),
        self.frame_padding.top + 2 + (col * self.line_height)
    ))
end

return GameSummary
