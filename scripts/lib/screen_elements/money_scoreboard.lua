local sb = {}
sb.__index = sb

local font = renderer.get_default_font()
local line_height = font.line_height

local frame = renderer.get_frame("ui/frames/dp_box")
local frame_padding = frame.padding
local frame_size = Vec2.new(92, 44)

local label = font.render_plain_text_shadowed(loc("ui.scoreboard.money.label"))

-- The amount of money the player had when the text was rendered.
local money_val = G.money

function sb.new (row)
    row = row or 0

    local value = font.render_plain_text_shadowed(
        loc("ui.scoreboard.money.value")
    )
    value.set_anchor(AnchorPoint.bottom_right)

    return setmetatable({
        frame_pos = Vec2.new(2, 2 + ((frame_size.y + 2) * row)),
        value = value,
    }, sb)
end

function sb:draw ()
    frame.draw(self.frame_pos, frame_size)
    label.draw(
        self.frame_pos + Vec2.new(frame_padding.left + 1, frame_padding.top + 1)
    )
    self.value.draw(
        self.frame_pos
            + frame_size
            - Vec2.new(frame_padding.right + 1, frame_padding.bottom + 1)
    )
end

function sb:update ()
    if money_val ~= G.money then
        money_val = G.money
        self.value = font.render_plain_text_shadowed(
            loc("ui.scoreboard.money.value")
        )
        self.value.set_anchor(AnchorPoint.bottom_right)
    end
end

return sb
