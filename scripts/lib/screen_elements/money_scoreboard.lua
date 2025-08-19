local sb = {}
sb.__index = sb

local FRAME_SIZE = Vec2.new(92, 44)

function sb.new (row)
    row = row or 0

    local font = renderer.get_default_font()
    local frame = renderer.get_default_box_frame()

    local value = font.render_plain_text_shadowed(
        loc("ui.scoreboard.money.value")
    )
    value.set_anchor(AnchorPoint.bottom_right)

    return setmetatable({
        font = font,
        line_height = font.line_height,

        frame = frame,
        frame_padding = frame.padding,
        frame_pos = Vec2.new(2, 2 + ((FRAME_SIZE.y + 2) * row)),

        label = font.render_plain_text_shadowed(loc("ui.scoreboard.money.label")),
        value = value,

        -- The amount of money the player had when the text was rendered.
        money_val = G.money,
    }, sb)
end

function sb:draw ()
    self.frame.draw(self.frame_pos, FRAME_SIZE)
    self.label.draw(
        self.frame_pos + Vec2.new(self.frame_padding.left + 1, self.frame_padding.top + 1)
    )
    self.value.draw(
        self.frame_pos
            + FRAME_SIZE
            - Vec2.new(self.frame_padding.right + 1, self.frame_padding.bottom + 1)
    )
end

function sb:update ()
    if self.money_val ~= G.money then
        self.money_val = G.money
        self.value = self.font.render_plain_text_shadowed(
            loc("ui.scoreboard.money.value")
        )
        self.value.set_anchor(AnchorPoint.bottom_right)
    end
end

return sb
