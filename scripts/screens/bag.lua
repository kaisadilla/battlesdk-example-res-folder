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

local SELECTION_CHOICE_BOX_POS = Vec2.new(renderer.width - 3, renderer.height - 70)

local input_locked = true

---The pouch in the bag that's currently active.
local section = 1
---The index of the item currently focused.
local cursor = 1
---True if the currently focused item is selected.
local is_item_selected = false

local font = renderer:get_default_font();
if font == nil then Logger.error("Couldn't load font.") end

local names = {
    font:render_plain_text_shadowed(loc("names.bag.favorites")),
    font:render_plain_text_shadowed(loc("names.bag.key_items")),
    font:render_plain_text_shadowed(loc("names.bag.medicine")),
    font:render_plain_text_shadowed(loc("names.bag.poke_balls")),
    font:render_plain_text_shadowed(loc("names.bag.battle_items")),
    font:render_plain_text_shadowed(loc("names.bag.tms")),
    font:render_plain_text_shadowed(loc("names.bag.berries")),
    font:render_plain_text_shadowed(loc("names.bag.other_items")),
}
local bgs = {
    renderer:get_sprite("ui/bag/bg_favorites"),
    renderer:get_sprite("ui/bag/bg_key_items"),
    renderer:get_sprite("ui/bag/bg_medicine"),
    renderer:get_sprite("ui/bag/bg_poke_balls"),
    renderer:get_sprite("ui/bag/bg_battle_items"),
    renderer:get_sprite("ui/bag/bg_tms"),
    renderer:get_sprite("ui/bag/bg_berries"),
    renderer:get_sprite("ui/bag/bg_other_items"),
}
local bags = {
    renderer:get_sprite("ui/bag/bag_1_favorites"),
    renderer:get_sprite("ui/bag/bag_1_key_items"),
    renderer:get_sprite("ui/bag/bag_1_medicine"),
    renderer:get_sprite("ui/bag/bag_1_poke_balls"),
    renderer:get_sprite("ui/bag/bag_1_battle_items"),
    renderer:get_sprite("ui/bag/bag_1_tms"),
    renderer:get_sprite("ui/bag/bag_1_berries"),
    renderer:get_sprite("ui/bag/bag_1_other_items"),
}

local move = renderer:get_sprite("ui/bag/move")
local select = renderer:get_sprite("ui/bag/select")

local slider_arrow_up = renderer:get_sprite('ui/bag/slider_arrows/up')
local slider_arrow_down = renderer:get_sprite('ui/bag/slider_arrows/down')
local slider_thumb = renderer:get_sprite('ui/bag/slider_thumb')

local bag_pos = Vec2.new(48, 30)
local arrow_up_pos = Vec2.new(330, 8)
local arrow_down_pos = Vec2.new(330, 146)

---A list of items in the current section.
---@type InventoryItem[]
local section_items = {}

local close_bag_sprite = font:render_plain_text_shadowed(loc("screens.bag.close"))
---The sprites for the names of all items in the section
---@type PlainTextSprite[]
local item_name_sprites = {}
---@type PlainTextSprite[]
local item_name_sprites = {}
---@type PlainTextSprite[]
local item_amount_sprites = {}
---@type Sprite | nil
local item_sprite = nil
---@type PlainTextSprite | nil
local item_desc_sprite = nil

---@type ChoiceBox | nil
local selection_choice_box = nil

function target:open ()
    update_pocket_info()
    input_locked = false
end

function target:draw ()
    bgs[section].draw(Vec2.zero)
    bags[section].draw(bag_pos)

    local name_x = (164 - names[section].width) / 2
    names[section].draw(Vec2.new(name_x, 140 + font.line_offset))

    draw_item_list()
    draw_cursor()
    draw_arrows()
    draw_desc_box()

    if is_item_selected then
        if selection_choice_box then selection_choice_box.draw() end
    end
end

function target:handle_input ()
    if input_locked then return end

    if Controls.get_key_down(ActionKey.left) then
        Audio.play_beep_short()

        if section > 1 then
            section = section - 1
        else
            section = #bgs
        end

        update_pocket_info()
    elseif Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        if section < #bgs then
            section = section + 1
        else
            section = 1
        end

        update_pocket_info()
    end
    if Controls.get_key_down(ActionKey.up) then
        Audio.play_beep_short()

        if is_item_selected then
            if selection_choice_box then
                selection_choice_box.move_up()
            end
        else
            if cursor > 1 then
                cursor = cursor - 1
            else
                cursor = #section_items + 1
            end

            update_item_info()
        end
    elseif Controls.get_key_down(ActionKey.down) then
        Audio.play_beep_short()

        if is_item_selected then
            if selection_choice_box then
                selection_choice_box.move_down()
            end
        else
            if cursor <= #section_items then
                cursor = cursor + 1
            else
                cursor = 1
            end

            update_item_info()
        end
    end
    if Controls.get_key_down(ActionKey.primary) then
        if cursor <= #section_items then
            Audio.play_beep_short()
            is_item_selected = true
        else
            close_bag()
        end
    end
    if Controls.get_key_down(ActionKey.secondary) then
        if is_item_selected then
            Audio.play_beep_short()
            is_item_selected = false
        else
            close_bag()
        end
    end
end

function update_pocket_info ()
    cursor = 1

    -- Section 1 is favorites.
    if section == 1 then
        
    else -- All other sections are the ones defined in bag.json
        build_section_list()
    end

    update_item_info()
end

--- Refreshes variables that depend on where the cursor is.
function update_item_info ()
    if cursor <= #section_items then
        local item = section_items[cursor]

        item_sprite = renderer:get_sprite("items/" .. item.item_id)
        item_desc_sprite = font:render_plain_text_shadowed(
            loc("descriptions.items." .. item.item_id), DESC_SIZE.x
        )
        item_desc_sprite.set_color(Color.new(255, 255, 255, 255)) -- TODO: Predetermined colors
        item_desc_sprite.set_shadow_color(Color.new(0, 0, 0, 153))

        selection_choice_box = renderer.get_choice_box(
            "ui/frames/dp_box",
            "power_clear",
            SELECTION_CHOICE_BOX_POS,
            AnchorPoint.bottom_right,
            {
                loc("screens.bag.item_menu.give"),
                loc("screens.bag.item_menu.toss"),
                loc("screens.bag.item_menu.cancel"),
            }
        )
    else
        item_sprite = renderer:get_sprite("ui/bag/back_icon")
        item_desc_sprite = nil
    end
end

function build_section_list ()
    section_items = G.inventory.get_items_at(section - 1)
    item_name_sprites = {}
    item_amount_sprites = {}

    for i, item in ipairs(section_items) do
        table.insert(
            item_name_sprites,
            font:render_plain_text_shadowed(loc("names.items." .. item.item_id))
        )
        table.insert(
            item_amount_sprites,
            font:render_plain_text_shadowed("x " .. item.amount)
        )
    end
end

function draw_item_list ()
    local first_index = get_first_visible_index()

    for i = 0, VISIBLE_ITEMS - 1 do
        local index = i + first_index
        local y_pos = FIRST_ITEM_Y + (i * ITEM_HEIGHT)
        if index <= #section_items then
            item_name_sprites[index].draw(
                Vec2.new(ITEM_X, y_pos)
            )
            item_amount_sprites[index].draw(
                Vec2.new(AMOUNT_X, y_pos),
                AnchorPoint.top_right
            )
        elseif index == #section_items + 1 then
            close_bag_sprite.draw(
                Vec2.new(ITEM_X, y_pos)
            )
        end
    end
end

function draw_cursor ()
    local cursor_pos = get_cursor_screen_position()

    move.draw(Vec2.new(
        CURSOR_X,
        FIRST_ITEM_Y + ((cursor_pos - 1) * ITEM_HEIGHT) + CURSOR_RELATIVE_Y
    ))
end

function draw_arrows ()
    local count = #section_items + 1

    if count <= VISIBLE_ITEMS then return end

    local thumb_size = math.max(TRACK_HEIGHT * (VISIBLE_ITEMS / count), MIN_THUMB_SIZE)
    local thumb_range = TRACK_HEIGHT - thumb_size
    local thumb_pos = (thumb_range / (count - 1)) * (cursor - 1)

    slider_arrow_up.draw(arrow_up_pos)
    slider_arrow_down.draw(arrow_down_pos)
    slider_thumb.draw(
        TRACK_TOP_LEFT + Vec2.new(0, thumb_pos),
        Vec2.new(TRACK_WIDTH, thumb_size)
    )
end

function draw_desc_box ()
    if item_sprite then
        item_sprite.draw(ITEM_SPRITE_POS)
    end
    if item_desc_sprite then
        item_desc_sprite.draw(DESC_POS)
    end

    --item_desc_sprite.draw()
end

function get_first_visible_index ()
    local last_index = #section_items + 1

    -- If there aren't enough items to fill the screen, we start at 1.
    if last_index <= VISIBLE_ITEMS then return 1 end

    -- If the cursor hasn't reached the center, we start at one.
    if cursor < CURSOR_POSITION then return 1 end

    -- If there aren't enough items to fill the lower part, the highest item
    -- that allows seeing the end of the list.
    if cursor > last_index - (VISIBLE_ITEMS - CURSOR_POSITION) then
        return (last_index - VISIBLE_ITEMS) + 1
    end

    -- The cursor minus the amount of items visible above it.
    return cursor - (CURSOR_POSITION - 1)
end

function get_cursor_screen_position ()
    local last_index = #section_items + 1

    -- All items fit on the screen, so the visual matches its logical position.
    if last_index <= VISIBLE_ITEMS then return cursor end

    -- The cursor is above the center, so visual matches logical position.
    if cursor < CURSOR_POSITION then return cursor end

    -- There aren't enough items at the tail to place the selected one in the
    -- center. When selecting the last item, the cursor is at the last position.
    if cursor > last_index - (VISIBLE_ITEMS - CURSOR_POSITION) then
        return VISIBLE_ITEMS - (last_index - cursor)
    end

    -- The cursor is in the center of the screen
    return CURSOR_POSITION
end

function close_bag ()
    input_locked = true
    Audio.play("screen_close")
    Screen.play_transition("transitions/horizontal_wipe", 0.25, false)
    Hud.wait(500)
    target.close()
    Screen.play_transition("transitions/fade", 0.25, true)
end
