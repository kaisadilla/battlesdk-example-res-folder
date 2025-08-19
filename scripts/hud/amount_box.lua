local SIZE = Vec2.new(108, 44)

---@type Font
local font
---@type FrameSprite
local frame
---@type Rect
local padding

local position = Vec2.zero

local amount = 1
local price = 0
---@type PlainTextSprite | nil
local amount_txt = nil
---@type PlainTextSprite | nil
local price_txt = nil
---@type Vec2
local amount_offset
---@type Vec2
local price_offset

local up_arrow = renderer.get_sprite("ui/arrows/up")
local down_arrow = renderer.get_sprite("ui/arrows/down")

---@type Vec2
local up_arrow_offset
---@type Vec2
local down_arrow_offset

local max_amount = 1

local function init ()
    font = renderer.get_default_font();
    frame = renderer.get_default_box_frame()
    padding = frame.padding

    amount_offset = Vec2.new(padding.left + 1, padding.top + 9)
    price_offset = Vec2.new(SIZE.x - (padding.right + 1), padding.top + 9)

    up_arrow_offset = Vec2.new(padding.left + 4, padding.top - 1)
    down_arrow_offset = Vec2.new(padding.left + 4, padding.top + 23)
end

function target.open (args)
    init()

    price = args.price
    position = args.position or position
    max_amount = args.max_amount

    update_amount()
end

function target.draw ()
    frame.draw(position, SIZE)

    if amount_txt then
        amount_txt.draw(position + amount_offset)
    end
    if price_txt then
        price_txt.draw(position + price_offset)
    end

    up_arrow.draw(position + up_arrow_offset)
    down_arrow.draw(position + down_arrow_offset)
end

function target.handle_input ()
    if Controls.get_key_down(ActionKey.up) then
        Audio.play_beep_short()

        amount = amount + 1
        if amount > max_amount then
            amount = 1
        end

        update_amount()
    elseif Controls.get_key_down(ActionKey.down) then
        Audio.play_beep_short()

        amount = amount - 1
        if amount <= 0 then
            amount = max_amount
        end

        update_amount()
    elseif Controls.get_key_down(ActionKey.primary) then
        Audio.play_beep_short()

        target.set_result(amount)
        target.close()
    elseif Controls.get_key_down(ActionKey.secondary) then
        Audio.play_beep_short()
        
        target.set_result(nil)
        target.close()
    end
end

function update_amount ()
    amount_txt = font.render_plain_text_shadowed("x " .. Fmt.pad_left(amount, '0', 3))
    price_txt = font.render_plain_text_shadowed("$ " .. price * amount)
    price_txt.set_anchor(AnchorPoint.top_right)
end
