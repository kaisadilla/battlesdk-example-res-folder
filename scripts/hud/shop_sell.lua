local Bag = require("lib.bag")
local MoneyScoreboard = require("lib.screen_elements.money_scoreboard")

local SELL_BOX_POS = Vec2.new(renderer.width - 2, renderer.height - 69)

local money_sb = nil

local function close_bag (self)
    self.input_locked = true
    Audio.play_beep_short()
    Screen.play_transition("transitions/horizontal_wipe", 0.25, false)
    Script.wait(0.5)
    target.close()
    Screen.play_transition("transitions/fade", 0.25, true)
end

local function select (self, item_id)
    local item = Data.get_item(item_id)
    local user_amount = G.inventory.get_amount(item_id)
    if item == nil then error("Item '" .. item_id .. "' does not exist.") end

    local sell_price = item.price / 2 -- TODO: Do not hardcode.

    local amount = Hud.script_element(
        "hud/amount_choice_message",
        Object.new({
            message = loc("ui.shop.sell_how_many", loc("names.items." .. item_id)),
            price = sell_price,
            position = SELL_BOX_POS - Vec2.new(108, 44),
            max_amount = user_amount,
        }
    ))

    if amount == nil then self:end_item_selection() return end

    local total_price = sell_price * amount

    local res = Hud.choice_message(
        loc(
            "ui.shop.sell_confirm",
            total_price
        ),
        {
            loc("yes"),
            loc("no"),
        }
    )

    -- 1 = "yes".
    if res ~= 1 then self:end_item_selection() return end

    Audio.play("spend_money")
    G.inventory.remove_amount(item_id, amount)
    G.add_money(total_price)
    self:update_item_list()
    Hud.message(loc(
        "ui.shop.sell_complete",
        loc("names.items." .. item_id),
        total_price
    ))

    self:end_item_selection()
end

local bag = Bag.new(select, close_bag)

local opened = false

function target.open (args)
    bag:open()
    money_sb = MoneyScoreboard.new()

    Screen.play_transition("transitions/fade", 0.25, false)
    Script.wait(0.5)
    opened = true
    Screen.play_transition("transitions/horizontal_wipe", 0.25, true)
end

function target.update ()
    money_sb:update()
end

function target.draw ()
    if opened == false then return end
    bag:draw()
    money_sb:draw()
end

function target.handle_input ()
    bag:handle_input()
end
