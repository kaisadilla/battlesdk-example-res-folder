local SIZE = Vec2.new(108, 44)

local font = renderer:get_default_font();

local frame = renderer:get_frame('ui/frames/dp_box')
local padding = frame.padding

local position = Vec2.zero

local amount = 1
local price = 0
---@type PlainTextSprite | nil
local amount_txt = nil
---@type PlainTextSprite | nil
local price_txt = nil
local amount_offset = Vec2.new(padding.left + 1, padding.top + 9)
local price_offset = Vec2.new(SIZE.x - (padding.right + 1), padding.top + 9)

local up_arrow = renderer.get_sprite("ui/arrows/up")
local down_arrow = renderer.get_sprite("ui/arrows/down")

local up_arrow_offset = Vec2.new(padding.left + 4, padding.top - 1)
local down_arrow_offset = Vec2.new(padding.left + 4, padding.top + 23)

local max_amount = 1

--pos: 242,127

function target.open (args)
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
