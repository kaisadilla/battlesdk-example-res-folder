local ListMgr = require("lib.scrollable_list_manager")

local Bag = {}
Bag.__index = Bag

local VISIBLE_ITEMS = 9
local CURSOR_POSITION = 5
local FIRST_ITEM_Y = 14
local ITEM_X = 171
local AMOUNT_X = 320
local CURSOR_X = 162
local CURSOR_RELATIVE_Y = -9
local ITEM_HEIGHT = 16 -- If we use font.line_offset, we'll have to calculate all.

--- The topleft corner of the scrollbar's track.
local TRACK_TOP_LEFT = Vec2.new(330, 27)
--- The width of the scrollbar's track.
local TRACK_WIDTH = 18
--- The height of the scrollbar's track.
local TRACK_HEIGHT = 120
--- The minimum size of the scrollbar's thumb.
local MIN_THUMB_SIZE = 8

local ITEM_SPRITE_POS = Vec2.new(8, 192)

--- The position of the item's description string.
local DESC_POS = Vec2.new(44, 176)
--- The size of the item's description string.
local DESC_SIZE = Vec2.new(324 - 44, 240 - 176)
local DESC_TEXT_COLOR = Color.new(255, 255, 255, 255)
local DESC_SHADOW_COLOR = Color.new(0, 0, 0, 153)

local SELECTION_CHOICE_BOX_POS = Vec2.new(renderer.width - 3, renderer.height - 70)

local font = renderer:get_default_font();

local pocket_name_txts = {
    font:render_plain_text_shadowed(loc("names.bag.favorites")),
    font:render_plain_text_shadowed(loc("names.bag.key_items")),
    font:render_plain_text_shadowed(loc("names.bag.medicine")),
    font:render_plain_text_shadowed(loc("names.bag.poke_balls")),
    font:render_plain_text_shadowed(loc("names.bag.battle_items")),
    font:render_plain_text_shadowed(loc("names.bag.tms")),
    font:render_plain_text_shadowed(loc("names.bag.berries")),
    font:render_plain_text_shadowed(loc("names.bag.other_items")),
}
local pocket_bgs = {
    renderer:get_sprite("ui/bag/bg_favorites"),
    renderer:get_sprite("ui/bag/bg_key_items"),
    renderer:get_sprite("ui/bag/bg_medicine"),
    renderer:get_sprite("ui/bag/bg_poke_balls"),
    renderer:get_sprite("ui/bag/bg_battle_items"),
    renderer:get_sprite("ui/bag/bg_tms"),
    renderer:get_sprite("ui/bag/bg_berries"),
    renderer:get_sprite("ui/bag/bg_other_items"),
}
local bag_sprites = {
    renderer:get_sprite("ui/bag/bag_1_favorites"),
    renderer:get_sprite("ui/bag/bag_1_key_items"),
    renderer:get_sprite("ui/bag/bag_1_medicine"),
    renderer:get_sprite("ui/bag/bag_1_poke_balls"),
    renderer:get_sprite("ui/bag/bag_1_battle_items"),
    renderer:get_sprite("ui/bag/bag_1_tms"),
    renderer:get_sprite("ui/bag/bag_1_berries"),
    renderer:get_sprite("ui/bag/bag_1_other_items"),
}

---The "<close>" text.
local close_bag_txt = font:render_plain_text_shadowed(loc("screens.bag.close"))
---The sprite that appears when the focused "item" is the close bag option.
local close_bag_sprite = renderer:get_sprite("ui/bag/back_icon")

local move = renderer:get_sprite("ui/bag/move")
local select = renderer:get_sprite("ui/bag/select")

local slider_arrow_up = renderer:get_sprite('ui/bag/slider_arrows/up')
local slider_arrow_down = renderer:get_sprite('ui/bag/slider_arrows/down')
local slider_thumb = renderer:get_sprite('ui/bag/slider_thumb')

local bag_pos = Vec2.new(48, 30)
local arrow_up_pos = Vec2.new(330, 8)
local arrow_down_pos = Vec2.new(330, 146)

--- Private methods
local update_pocket_info,
    update_item_info,
    build_section_list,
    close_bag,
    draw_item_list,
    draw_cursor,
    draw_arrows,
    draw_desc_box

function Bag.new (select_callback, close_callback)
    return setmetatable({
        input_locked = true,
        ---The pouch in the bag that's currently active.
        section = 1,
        ---The list manager for the current section.
        list_mgr = ListMgr.new(1, 1),
        ---True if the currently focused item is selected.
        is_item_selected = false,
        ---A list of items in the current section.
        ---@type InventoryItem[]
        section_items = {},

        ---The sprites for the names of all items in the section.
        ---@type PlainTextSprite[]
        item_name_sprites = {},

        ---The sprites for the amounts of all items in the section.
        ---@type PlainTextSprite[]
        item_amount_sprites = {},

        ---The sprite for the focused item's picture.
        ---@type Sprite | nil
        item_sprite = nil,
        ---The sprite for the focused item's description.
        ---@type PlainTextSprite | nil
        item_desc_sprite = nil,

        select_callback = select_callback,
        close_callback = close_callback,
    }, Bag)
end

function Bag:open ()
    update_pocket_info(self)
    self.input_locked = false
end

function Bag:draw ()
    pocket_bgs[self.section].draw(Vec2.zero)
    bag_sprites[self.section].draw(bag_pos)

    local name_x = (164 - pocket_name_txts[self.section].width) / 2
    pocket_name_txts[self.section].draw(Vec2.new(name_x, 140 + font.line_offset))

    draw_item_list(self)
    draw_cursor(self)
    draw_arrows(self)
    draw_desc_box(self)
end

function Bag:handle_input ()
    if self.input_locked then return end

    if Controls.get_key_down(ActionKey.left) then
        if self.is_item_selected then return end

        Audio.play_beep_short()

        if self.section > 1 then
            self.section = self.section - 1
        else
            self.section = #pocket_bgs
        end

        update_pocket_info(self)
    elseif Controls.get_key_down(ActionKey.right) then
        if self.is_item_selected then return end

        Audio.play_beep_short()

        if self.section < #pocket_bgs then
            self.section = self.section + 1
        else
            self.section = 1
        end

        update_pocket_info(self)
    end
    if Controls.get_key_down(ActionKey.up) then
        if self.is_item_selected then return end

        Audio.play_beep_short()

        self.list_mgr:move_cursor_up()
        update_item_info(self)
    elseif Controls.get_key_down(ActionKey.down) then
        if self.is_item_selected then return end

        Audio.play_beep_short()

        self.list_mgr:move_cursor_down()
        update_item_info(self)
    end
    if Controls.get_key_down(ActionKey.primary) then
        if self.is_item_selected then return end
        
        if self.list_mgr.cursor <= #self.section_items then
            Audio.play_beep_short()

            if self.select_callback == nil then return end

            self.is_item_selected = true
            self:select_callback(self.section_items[self.list_mgr.cursor].item_id)
        else
            close_bag(self)
        end
    end
    if Controls.get_key_down(ActionKey.secondary) then
        if self.is_item_selected then return end

        close_bag(self)
    end
end

function Bag:update_item_list ()
    build_section_list(self)
    update_item_info(self)

    local cursor = self.list_mgr.cursor
    self.list_mgr = ListMgr.new(#self.section_items, VISIBLE_ITEMS)
    self.list_mgr.cursor = cursor
end

function Bag:end_item_selection ()
    Script.wait_for_next_frame()
    self.is_item_selected = false
end

update_pocket_info = function (self)
    -- Section 1 is favorites.
    if self.section == 1 then
        -- TODO
    else -- All other sections are the ones defined in bag.json
        build_section_list(self)
    end

    update_item_info(self)
    self.list_mgr = ListMgr.new(#self.section_items, VISIBLE_ITEMS)
end

update_item_info = function (self)
    if self.list_mgr.cursor <= #self.section_items then
        local item = self.section_items[self.list_mgr.cursor]

        self.item_sprite = renderer:get_sprite("items/" .. item.item_id)
        self.item_desc_sprite = font:render_plain_text_shadowed(
            loc("descriptions.items." .. item.item_id), DESC_SIZE.x
        )
        self.item_desc_sprite.set_color(DESC_TEXT_COLOR)
        self.item_desc_sprite.set_shadow_color(DESC_SHADOW_COLOR)
    else
        self.item_sprite = close_bag_sprite
        self.item_desc_sprite = nil
    end
end

build_section_list = function (self)
    self.section_items = G.inventory.get_items_at(self.section - 1)
    self.item_name_sprites = {}
    self.item_amount_sprites = {}

    for i, item in ipairs(self.section_items) do
        table.insert(
            self.item_name_sprites,
            font:render_plain_text_shadowed(loc("names.items." .. item.item_id))
        )
        table.insert(
            self.item_amount_sprites,
            font:render_plain_text_shadowed("x " .. item.amount)
        )
    end
end

close_bag = function (self)
    if self.close_callback then
        self:close_callback()
    end
end

-- #region Draw methods
draw_item_list = function (self)
    local first_index = self.list_mgr:get_first_visible_index()

    for i = 0, VISIBLE_ITEMS - 1 do
        local index = i + first_index
        local y_pos = FIRST_ITEM_Y + (i * ITEM_HEIGHT)
        if index <= #self.section_items then
            self.item_name_sprites[index].draw(
                Vec2.new(ITEM_X, y_pos)
            )
            self.item_amount_sprites[index].draw(
                Vec2.new(AMOUNT_X, y_pos),
                AnchorPoint.top_right
            )
        elseif index == #self.section_items + 1 then
            close_bag_txt.draw(
                Vec2.new(ITEM_X, y_pos)
            )
        end
    end
end

draw_cursor = function (self)
    local cursor_pos = self.list_mgr:get_cursor_screen_position()

    move.draw(Vec2.new(
        CURSOR_X,
        FIRST_ITEM_Y + ((cursor_pos - 1) * ITEM_HEIGHT) + CURSOR_RELATIVE_Y
    ))
end

draw_arrows = function (self)
    local count = #self.section_items + 1

    if count <= VISIBLE_ITEMS then return end

    local thumb_size = math.max(TRACK_HEIGHT * (VISIBLE_ITEMS / count), MIN_THUMB_SIZE)
    local thumb_range = TRACK_HEIGHT - thumb_size
    local thumb_pos = (thumb_range / (count - 1)) * (self.list_mgr.cursor - 1)

    slider_arrow_up.draw(arrow_up_pos)
    slider_arrow_down.draw(arrow_down_pos)
    slider_thumb.draw(
        TRACK_TOP_LEFT + Vec2.new(0, thumb_pos),
        Vec2.new(TRACK_WIDTH, thumb_size)
    )
end

draw_desc_box = function (self)
    if self.item_sprite then
        self.item_sprite.draw(ITEM_SPRITE_POS)
    end
    if self.item_desc_sprite then
        self.item_desc_sprite.draw(DESC_POS)
    end
end
-- #endregion

return Bag
