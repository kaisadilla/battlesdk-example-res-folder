local ListMgr = require("lib.scrollable_list_manager")
local MoneyScoreboard = require("lib.screen_elements.money_scoreboard")

local VISIBLE_ITEMS = 7
local ITEM_X = 192
local FIRST_ITEM_Y = 15
local ITEM_HEIGHT = 16
local PRICE_X = 342

--- The position of the "In bag: X" textbox.
local IN_BAG_POS = Vec2.new(2, 171)
--- The size of the "In bag: X" textbox.
local IN_BAG_SIZE = Vec2.new(92, 30)

--- The position of the selected item's icon.
local ITEM_SPRITE_POS = Vec2.new(8, 192)
--- The position of the item's description string.
local DESC_POS = Vec2.new(44, 176)
--- The size of the item's description string.
local DESC_SIZE = Vec2.new(324 - 44, 240 - 176)
local DESC_TEXT_COLOR = Color.new(255, 255, 255, 255)
local DESC_SHADOW_COLOR = Color.new(0, 0, 0, 153)

local CURSOR_X = ITEM_X - 9
local CURSOR_RELATIVE_Y = -9

local BUY_BOX_POS = Vec2.new(renderer.width - 2, renderer.height - 69)

local font = renderer.get_default_font()

local bg = renderer.get_sprite("ui/shop/bg")
local cursor_sprite = renderer.get_sprite("ui/shop/cursor")

local items = {}

---@type PlainTextSprite[]
local name_txts = {}
---@type PlainTextSprite[]
local price_txts = {}
local close_txt = font.render_plain_text_shadowed(loc("ui.shop.cancel"))

local list_mgr

---@type Sprite | nil
local item_txt = nil
---@type PlainTextSprite | nil
local item_desc_txt = nil
---@type Textbox | nil
local in_bag_tb = nil

local money_sb = nil

function target.open (args)
    for i, item_def in args.items.ipairs() do
        local item = {}

        if item_def.id then
            item.id = item_def.id
        end

        if item_def.price then
            item.price = item_def.price
        else
            local data = Data.get_item(item_def.id)
            if data == nil then
                error("Unknown item: '" .. item_def.id .."'.")
            end
            item.price = data.price
        end

        table.insert(items, item)
    end

    for i, item in ipairs(items) do
        table.insert(
            name_txts,
            font.render_plain_text_shadowed(
                loc("names.items." .. item.id)
            )
        )
        table.insert(
            price_txts,
            font.render_plain_text_shadowed(
                loc("$ " .. item.price)
            )
        )
    end

    list_mgr = ListMgr.new(#name_txts, VISIBLE_ITEMS)
    money_sb = MoneyScoreboard.new()
    update_focused_item_info()
end

function target.update ()
    money_sb:update()
end

function target.draw ()
    bg.draw(Vec2.zero)

    draw_item_list()
    draw_cursor()
    draw_desc_box()

    money_sb:draw()

    if amount_box then
        amount_box.draw()
    end
end

function target.handle_input ()
    if Controls.get_key_down(ActionKey.up) then
        Audio.play_beep_short()
        
        list_mgr:move_cursor_up()
        update_focused_item_info()
    elseif Controls.get_key_down(ActionKey.down) then
        Audio.play_beep_short()

        list_mgr:move_cursor_down()
        update_focused_item_info()
    elseif Controls.get_key_down(ActionKey.primary) then
        Audio.play_beep_short()
        
        if list_mgr.cursor <= #name_txts then
            purchase_current_item()
        else
            target.close()
        end
    elseif Controls.get_key_down(ActionKey.secondary) then
        Audio.play_beep_short()
        target.close()
    end
end

function update_focused_item_info ()
    if list_mgr.cursor <= #items then
        local item = items[list_mgr.cursor]
        local in_bag = G.inventory.get_amount(item.id)

        item_txt = renderer.get_sprite("items/" .. item.id)
        item_desc_txt = font.render_plain_text_shadowed(
            loc("descriptions.items." .. item.id), DESC_SIZE.x
        )
        item_desc_txt.set_color(DESC_TEXT_COLOR)
        item_desc_txt.set_shadow_color(DESC_SHADOW_COLOR)

        in_bag_tb = renderer.get_textbox(
            "ui/frames/dp_box",
            "power_clear",
            IN_BAG_POS,
            IN_BAG_SIZE,
            "In bag: " .. in_bag
        )
        in_bag_tb.set_anchor(AnchorPoint.bottom_left)
    else
        item_txt = renderer.get_sprite("ui/shop/back_icon")
        item_desc_txt = nil
    end
end

function purchase_current_item ()
    local item = items[list_mgr.cursor]

    -- When the player can't even buy 1x of the item, the purchase dialog is
    -- never shown.
    if G.money < item.price then
        Hud.message(loc("ui.shop.not_enough_money"))
        return
    end

    local amount = Hud.script_element(
        "hud/amount_choice_message",
        Object.new({
            message = loc("ui.shop.buy_how_many", loc("names.items." .. item.id)),
            price = item.price,
            position = BUY_BOX_POS - Vec2.new(108, 44),
            max_amount = math.floor(G.money / item.price),
        }
    ))

    -- if the result is 'nil', the player cancelled the purchase.
    if amount == nil then return end
    local total_price = item.price * amount

    local res = Hud.choice_message(
        loc(
            "ui.shop.buy_confirm",
            loc("names.items." .. item.id),
            amount,
            total_price
        ),
        {
            loc("yes"),
            loc("no"),
        }
    )

    -- 1 = "yes".
    if res ~= 1 then return end

    Audio.play("spend_money")
    G.remove_money(total_price)
    Hud.message(loc("ui.shop.buy_complete"))
    obtain_items(item.id, amount)
    update_focused_item_info()
end

-- #region Draw functions
function draw_item_list ()
    local first_index = list_mgr:get_first_visible_index()

    for i = 0, VISIBLE_ITEMS - 1 do
        local index = i + first_index
        local y_pos = FIRST_ITEM_Y + (i * ITEM_HEIGHT)

        if index <= #name_txts then
            name_txts[index].draw(Vec2.new(ITEM_X, y_pos))
            price_txts[index].draw(
                Vec2.new(PRICE_X, y_pos), AnchorPoint.top_right
            )
        elseif index == #name_txts + 1 then
            close_txt.draw(Vec2.new(ITEM_X, y_pos))
        end
    end
end

function draw_cursor ()
    local cursor_pos = list_mgr:get_cursor_screen_position()

    cursor_sprite.draw(Vec2.new(
        CURSOR_X,
        FIRST_ITEM_Y + ((cursor_pos - 1) * ITEM_HEIGHT) + CURSOR_RELATIVE_Y
    ))
end

function draw_desc_box ()
    if item_txt then
        item_txt.draw(ITEM_SPRITE_POS)
    end
    if item_desc_txt then
        item_desc_txt.draw(DESC_POS)
    end
    if in_bag_tb then
        in_bag_tb.draw()
    end
end
-- #endregion Draw functions
