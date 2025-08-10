local OPTION_HEIGHT = 24

local font = renderer:get_default_font();
if font == nil then Logger.error("Couldn't load font.") end

local section = 1

local bg = {
    renderer:get_sprite("ui/bag/bg_items"),
    renderer:get_sprite("ui/bag/bg_medicine"),
    renderer:get_sprite("ui/bag/bg_poke_balls"),
    renderer:get_sprite("ui/bag/bg_tms"),
    renderer:get_sprite("ui/bag/bg_berries"),
    renderer:get_sprite("ui/bag/bg_mail"),
    renderer:get_sprite("ui/bag/bg_battle_items"),
    renderer:get_sprite("ui/bag/bg_key_items"),
}
local bag = {
    renderer:get_sprite("ui/bag/bag_1_items"),
    renderer:get_sprite("ui/bag/bag_1_medicine"),
    renderer:get_sprite("ui/bag/bag_1_poke_balls"),
    renderer:get_sprite("ui/bag/bag_1_tms"),
    renderer:get_sprite("ui/bag/bag_1_berries"),
    renderer:get_sprite("ui/bag/bag_1_mail"),
    renderer:get_sprite("ui/bag/bag_1_battle_items"),
    renderer:get_sprite("ui/bag/bag_1_key_items"),
}
local name = {
    font:render_plain_text_shadowed(loc("names.bag.items")),
    font:render_plain_text_shadowed(loc("names.bag.medicine")),
    font:render_plain_text_shadowed(loc("names.bag.pokeballs")),
    font:render_plain_text_shadowed(loc("names.bag.tms")),
    font:render_plain_text_shadowed(loc("names.bag.berries")),
    font:render_plain_text_shadowed(loc("names.bag.mail")),
    font:render_plain_text_shadowed(loc("names.bag.battle_items")),
    font:render_plain_text_shadowed(loc("names.bag.key_items")),
}

local bag_pos = Vec2.new(48, 30)

function target:open ()
    Audio.play_beep_short()
end

function target:draw ()
    bg[section].draw(Vec2.zero)
    bag[section].draw(bag_pos)

    local name_x = (164 - name[section].width) / 2
    name[section].draw(Vec2.new(name_x, 140 + font.line_offset))
end

function target:handle_input ()
    if Controls.get_key_down(ActionKey.left) then
        Audio.play_beep_short()

        if section > 1 then
            section = section - 1
        else
            section = #bg
        end
    elseif Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        if section < #bg then
            section = section + 1
        else
            section = 1
        end
    end
    if Controls.get_key_down(ActionKey.up) then
    elseif Controls.get_key_down(ActionKey.down) then
    end
    if Controls.get_key_down(ActionKey.primary) then
    end
    if Controls.get_key_down(ActionKey.secondary) then
        Audio.play_beep_short()
        target.close()
    end
end
