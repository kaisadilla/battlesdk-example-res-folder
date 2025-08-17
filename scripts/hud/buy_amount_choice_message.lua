local BOX_POS = Vec2.new(renderer.width - 2, renderer.height - 69)

---@type MessageHudElement | nil
local message = nil
---@type ScriptHudElement | nil
local box = nil

function target.open (args)
    local msg = args.message
    local price = args.price

    message = renderer.get_message_hud_element(
        "ui/frames/dp_textbox_1",
        "power_clear",
        msg
    )
    box = renderer.get_script_hud_element("hud/buy_amount_box", Object.new({
        price = price,
        position = BOX_POS - Vec2.new(108, 44),
    }))
end

function target.draw ()
    message.draw()
    if message.is_message_complete then
        if box then box.draw() end
    end
end

function target.update ()
    message.update()
    box.update()
end

function target.handle_input ()
    if message.is_message_complete == false then return end

    box.handle_input()
    if box.is_closed then
        target.set_result(box.result)
        target.close()
    end
end
