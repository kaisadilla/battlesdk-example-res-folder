local OPTION_HEIGHT = 24

local options = {}
table.insert(options, {
    icon = renderer:get_sprite('ui/menu_icons/pokedex')
})
table.insert(options, {
    icon = renderer:get_sprite('ui/menu_icons/pokemon')
})
table.insert(options, {
    icon = renderer:get_sprite('ui/menu_icons/bag_f')
})

local cursor = 1

local menu_frame = renderer:get_frame('ui/frames/dp_menu')
local menu_padding = menu_frame.padding
local menu_selection_frame = renderer:get_sprite('ui/menu_selection')

local menu_pos = IVec2.new(renderer.width - 102, 2)
local menu_size = IVec2.new(100, 150)

if menu_frame == nil then
    Logger.error("Couldn't find menu frame")
end

Logger.info("Loaded main menu!")

function Screen:open ()
    Audio.play("menu_open")
end

function Screen:draw ()
    if menu_frame == nil then return end

    menu_frame.draw(menu_pos, menu_size)

    for i = 1, #options do
        draw_option(i)
    end

    draw_selection_frame()
end

function Screen:handle_input ()
    if Controls:get_key_down(ActionKey.up) then
        Audio.play_beep_short()

        if cursor > 1 then
            cursor = cursor - 1
        else
            cursor = #options
        end
    elseif Controls:get_key_down(ActionKey.down) then
        Audio.play_beep_short()

        if cursor < #options then
            cursor = cursor + 1
        else
            cursor = 1
        end
    end
    if Controls:get_key_down(ActionKey.primary) then
        -- TODO: Do whichever option is selected.
    end
    if Controls.get_key_down(ActionKey.secondary) then
        Audio.play_beep_short()
        Screen:close()
    end
end

function draw_option (i)
    local opt = options[i]

    opt.icon.draw(menu_pos + IVec2.new(7, 6 + (OPTION_HEIGHT * (i - 1))))
    --opt.icon.draw(IVec2.new(menu_pos.x + 7, menu_pos.y + 6 + (OPTION_HEIGHT * (i - 1))))
end

function draw_selection_frame ()
    menu_selection_frame.draw(menu_pos + IVec2.new(4, 5 + (OPTION_HEIGHT * (cursor - 1))), IVec2:new(92, 26))
end
