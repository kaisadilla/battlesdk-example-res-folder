local ListMgr = require("lib.scrollable_list_manager")

local OPTIONS_POS = Vec2.new(8, 2)
local FRAME_POS = Vec2.new(2, 18)
local TEXTBOX_POS = Vec2.new(2, 192)
local TEXTBOX_SIZE = Vec2.new(renderer.width - 4, 46)
local VISIBLE_ITEMS = 10
local GAP = 16

local TXT_COLOR_REGULAR = Settings.default_text_color
local TXT_COLOR_REGULAR_SHADOW = Settings.default_text_shadow_color
local LABEL_COLOR_FOCUSED = Color.new(48, 80, 200, 255)
local LABEL_COLOR_FOCUSED_SHADOW = Color.new(48, 80, 200, TXT_COLOR_REGULAR_SHADOW.a)
local OPTION_COLOR_FOCUSED = Color.new(224, 8, 8, 255)
local OPTION_COLOR_FOCUSED_SHADOW = Color.new(224, 8, 8, TXT_COLOR_REGULAR_SHADOW.a)

local OPTION_X_OFFSET = 120

local TEXT_SPEED_SLOW = 10
local TEXT_SPEED_MID = 30
local TEXT_SPEED_FAST = 80
local TEXT_SPEED_INSTANT = math.huge

local bg = renderer.get_sprite("ui/options_bg")
local cursor = renderer.get_sprite("ui/choice_arrow")

---@type Font
local font
---@type PlainTextSprite
local options_txt

---@type FrameSprite1
local frame
local frame_padding
local frame_size = Vec2.new(
    renderer.width - 4,
    renderer.height - 4 - 16 - 48
)

---@type AnimatableTextbox
local textbox

local options
local close_txt
---@type ScrollableListManager
local list_mgr

local label_x
local label_first_y
local option_x
---The horizontal area available to draw each option.
---@type number
local option_width

local input_locked = true

--#region Option: Screen size
local screen_size_1x_txt
local screen_size_2x_txt
local screen_size_3x_txt
local screen_size_4x_txt
local screen_size_full_txt
--#endregion Option: Screen size

--#region Option: Music volume
---@type Scrollbar
local music_volume_scrollbar
---@type PlainTextSprite
local music_volume_txt
--#endregion Option: Music volume

--#region Option: Sound volume
---@type Scrollbar
local sound_volume_scrollbar
---@type PlainTextSprite
local sound_volume_txt
--#endregion Option: Sound volume

--#region Option: Text speed
local text_speed_slow_txt
local text_speed_mid_txt
local text_speed_fast_txt
local text_speed_instant_txt
--#endregion Option: Text speed

--#region Option: Battle animations
local battle_anims_on_txt
local battle_anims_off_txt
--#endregion Option: Battle animations

--#region Option: Give nicknames
local give_nicknames_on_txt
local give_nicknames_off_txt
--#endregion Option: Give nicknames

--#region Option: Message frame
---A list of all available frames for messages.
local message_frames
---The index of the current message frame.
local message_frame_index
---@type PlainTextSprite
local message_frame_txt
--#endregion Option: Message frame

--#region Option: Box frame
local box_frames
local box_frame_index
---@type PlainTextSprite
local box_frame_txt
--#endregion Option: Box frame

local function init ()
    font = renderer.get_default_font()
    options_txt = font.render_plain_text_shadowed(loc("screens.options.title"))

    frame = renderer.get_default_box_frame()
    frame_padding = frame.padding
    close_txt = font.render_plain_text_shadowed(loc("screens.options.close"))

    label_x = FRAME_POS.x + frame_padding.left + 13
    label_first_y = FRAME_POS.y + frame_padding.top + font.line_offset - 1
    option_x = FRAME_POS.x + OPTION_X_OFFSET
    option_width = frame_size.x - frame_padding.left - frame_padding.right - OPTION_X_OFFSET

    screen_size_1x_txt = font.render_plain_text_shadowed(
        loc("screens.options.screen_size.1x")
    )
    screen_size_2x_txt = font.render_plain_text_shadowed(
        loc("screens.options.screen_size.2x")
    )
    screen_size_3x_txt = font.render_plain_text_shadowed(
        loc("screens.options.screen_size.3x")
    )
    screen_size_4x_txt = font.render_plain_text_shadowed(
        loc("screens.options.screen_size.4x")
    )
    screen_size_full_txt = font.render_plain_text_shadowed(
        loc("screens.options.screen_size.full")
    )
    recolor_screen_size()

    build_music_volume()
    build_sound_volume()
    build_text_speed()
    build_battle_anims()
    build_give_nicknames()
    build_message_frame()
    build_box_frame()

    options = {
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.screen_size")
            ),
            description = loc("screens.options.desc.screen_size"),
            draw = draw_screen_size,
            handle_input = handle_input_screen_size
        },
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.music_volume")
            ),
            description = loc("screens.options.desc.music_volume"),
            draw = draw_music_volume,
            handle_input = handle_input_music_volume,
        },
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.sound_volume")
            ),
            description = loc("screens.options.desc.sound_volume"),
            draw = draw_sound_volume,
            handle_input = handle_input_sound_volume,
        },
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.text_speed")
            ),
            description = loc("screens.options.desc.text_speed"),
            draw = draw_text_speed,
            handle_input = handle_input_text_speed,
        },
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.battle_animations")
            ),
            description = loc("screens.options.desc.battle_animations"),
            draw = draw_battle_anims,
            handle_input = handle_input_battle_anims,
        },
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.give_nicknames")
            ),
            description = loc("screens.options.desc.give_nicknames"),
            draw = draw_give_nicknames,
            handle_input = handle_input_give_nicknames,
        },
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.message_frame")
            ),
            description = loc("screens.options.desc.message_frame"),
            draw = draw_message_frame,
            handle_input = handle_input_message_frame,
        },
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.menu_frame")
            ),
            description = loc("screens.options.desc.menu_frame"),
            draw = draw_box_frame,
            handle_input = handle_input_box_frame,
        },
        {
            label = font.render_plain_text_shadowed(
                loc("screens.options.labels.font")
            ),
            description = loc("screens.options.desc.font"),
        }
    }

    local cursor = 1

    if list_mgr then
        cursor = list_mgr.cursor
    end
    
    list_mgr = ListMgr.new(#options + 1, VISIBLE_ITEMS)
    list_mgr.cursor = cursor
    update_label_colors()

    build_textbox()

    input_locked = false
end

function target.open ()
    init()
end

function target.update ()
    if textbox then textbox.update() end
end

function target.draw ()
    bg.draw(Vec2.zero)
    options_txt.draw(OPTIONS_POS)
    frame.draw(FRAME_POS, frame_size)

    draw_options()
    draw_cursor()

    if textbox then textbox.draw() end
end

function target.handle_input ()
    if input_locked then return end

    if list_mgr.cursor <= #options and options[list_mgr.cursor].handle_input then
        options[list_mgr.cursor].handle_input()
    end
    
    if Controls.get_key_down(ActionKey.up) then
        Audio.play_beep_short()

        list_mgr:move_cursor_up()
        update_label_colors()
        build_textbox()
    elseif Controls.get_key_down(ActionKey.down) then
        Audio.play_beep_short()

        list_mgr:move_cursor_down()
        update_label_colors()
        build_textbox()
    end

    if Controls.get_key_down(ActionKey.primary) then
        if list_mgr.cursor <= #options then
            close()
        end
    end
    if Controls.get_key_down(ActionKey.secondary) then
        close()
    end
end

function close ()
    input_locked = true
    Audio.play("screen_close")
    Screen.play_transition("transitions/fade", 0.25, false)
    Script.wait(0.5)
    target.close()
    Screen.play_transition("transitions/fade", 0.25, true)
end

function update_label_colors ()
    for i, option in ipairs(options) do
        if i == list_mgr.cursor then
            option.label.set_color(LABEL_COLOR_FOCUSED)
            option.label.set_shadow_color(LABEL_COLOR_FOCUSED_SHADOW)
        else
            option.label.set_color(TXT_COLOR_REGULAR)
            option.label.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
        end
    end

    if list_mgr.cursor == #options + 1 then
        close_txt.set_color(LABEL_COLOR_FOCUSED)
        close_txt.set_shadow_color(LABEL_COLOR_FOCUSED_SHADOW)
    else
        close_txt.set_color(TXT_COLOR_REGULAR)
        close_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
end

function build_textbox ()
    if list_mgr.cursor <= #options then
        textbox = renderer.get_animatable_textbox(
            G.game_options.message_frame,
            G.game_options.font,
            TEXTBOX_POS,
            TEXTBOX_SIZE,
            options[list_mgr.cursor].description
        )
    else
        textbox = nil
    end
end

function draw_options ()
    local first_index = list_mgr:get_first_visible_index()

    for i = 0, VISIBLE_ITEMS - 1 do
        local index = i + first_index
        local y_offset = i * GAP
        local label_pos = Vec2.new(label_x, label_first_y + y_offset)

        if index <= #options then
            options[index].label.draw(label_pos)

            if options[index].draw then
                options[index].draw(y_offset)
            end
        elseif index == #options + 1 then
            close_txt.draw(label_pos)
        end
    end
end

function draw_cursor ()
    local cursor_pos = list_mgr:get_cursor_screen_position()

    cursor.draw(Vec2.new(label_x - 7, label_first_y + 3 + (list_mgr.cursor - 1) * GAP))
end

---@param y_offset number
function draw_screen_size (y_offset)
    local eff_width = option_width - screen_size_full_txt.width
    local step = eff_width / 4
    local y_pos = label_first_y + y_offset

    screen_size_1x_txt.draw(Vec2.new(option_x, y_pos))
    screen_size_2x_txt.draw(Vec2.new(option_x + math.floor(step), y_pos))
    screen_size_3x_txt.draw(Vec2.new(option_x + math.floor(step * 2), y_pos))
    screen_size_4x_txt.draw(Vec2.new(option_x + math.floor(step * 3), y_pos))
    screen_size_full_txt.draw(Vec2.new(option_x + math.floor(step * 4), y_pos))
end

function handle_input_screen_size ()
    if Controls.get_key_down(ActionKey.left) then
        Audio.play_beep_short()

        if G.game_options.is_full_screen then
            G.game_options.set_full_screen(false)
            G.game_options.set_window_scale(4)
        elseif G.game_options.window_scale <= 1 then
            G.game_options.set_full_screen(true)
        elseif G.game_options.window_scale <= 2 then
            G.game_options.set_window_scale(1)
        elseif G.game_options.window_scale <= 3 then
            G.game_options.set_window_scale(2)
        elseif G.game_options.window_scale <= 4 then
            G.game_options.set_window_scale(3)
        end

        recolor_screen_size()
    elseif Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        if G.game_options.is_full_screen then
            G.game_options.set_full_screen(false)
            G.game_options.set_window_scale(1)
        elseif G.game_options.window_scale <= 1 then
            G.game_options.set_window_scale(2)
        elseif G.game_options.window_scale <= 2 then
            G.game_options.set_window_scale(3)
        elseif G.game_options.window_scale <= 3 then
            G.game_options.set_window_scale(4)
        elseif G.game_options.window_scale <= 4 then
            G.game_options.set_full_screen(true)
        end

        recolor_screen_size()
    end
end

function recolor_screen_size ()
    if G.game_options.window_scale == 1 and G.game_options.is_full_screen == false then
        screen_size_1x_txt.set_color(OPTION_COLOR_FOCUSED)
        screen_size_1x_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        screen_size_1x_txt.set_color(TXT_COLOR_REGULAR)
        screen_size_1x_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
    if G.game_options.window_scale == 2 and G.game_options.is_full_screen == false then
        screen_size_2x_txt.set_color(OPTION_COLOR_FOCUSED)
        screen_size_2x_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        screen_size_2x_txt.set_color(TXT_COLOR_REGULAR)
        screen_size_2x_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
    if G.game_options.window_scale == 3 and G.game_options.is_full_screen == false then
        screen_size_3x_txt.set_color(OPTION_COLOR_FOCUSED)
        screen_size_3x_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        screen_size_3x_txt.set_color(TXT_COLOR_REGULAR)
        screen_size_3x_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
    if G.game_options.window_scale == 4 and G.game_options.is_full_screen == false then
        screen_size_4x_txt.set_color(OPTION_COLOR_FOCUSED)
        screen_size_4x_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        screen_size_4x_txt.set_color(TXT_COLOR_REGULAR)
        screen_size_4x_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
    if G.game_options.is_full_screen then
        screen_size_full_txt.set_color(OPTION_COLOR_FOCUSED)
        screen_size_full_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        screen_size_full_txt.set_color(TXT_COLOR_REGULAR)
        screen_size_full_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
end

-- #region Option: Music volume
function build_music_volume ()
    local vol = G.game_options.music_volume
    music_volume_txt = font.render_plain_text_shadowed(math.floor((vol * 100) + 0.5))
    music_volume_txt.set_anchor(AnchorPoint.top_right)
    music_volume_txt.set_color(OPTION_COLOR_FOCUSED)
    music_volume_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)

    if music_volume_scrollbar then
        music_volume_scrollbar.set_value(G.game_options.music_volume)
    else
        music_volume_scrollbar = renderer.get_scrollbar(option_width - 24, vol)
    end
end

function draw_music_volume (y_offset)
    local y_pos = label_first_y + y_offset

    music_volume_scrollbar.draw(Vec2.new(option_x, y_pos))
    music_volume_txt.draw(Vec2.new(option_x + option_width, y_pos))
end

function handle_input_music_volume ()
    if Controls.get_key_down(ActionKey.left) then
        Audio.play_beep_short()
        
        G.game_options.reduce_music_volume(0.01)

        build_music_volume()
    elseif Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        G.game_options.increase_music_volume(0.01)

        build_music_volume()
    end
end
-- #endregion Option: Music volume

-- #region Option: Sound volume
function build_sound_volume ()
    local vol = G.game_options.sound_volume
    sound_volume_txt = font.render_plain_text_shadowed(math.floor((vol * 100) + 0.5))
    sound_volume_txt.set_anchor(AnchorPoint.top_right)
    sound_volume_txt.set_color(OPTION_COLOR_FOCUSED)
    sound_volume_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)

    if sound_volume_scrollbar then
        sound_volume_scrollbar.set_value(G.game_options.sound_volume)
    else
        sound_volume_scrollbar = renderer.get_scrollbar(option_width - 24, vol)
    end
end

function draw_sound_volume (y_offset)
    local y_pos = label_first_y + y_offset

    sound_volume_scrollbar.draw(Vec2.new(option_x, y_pos))
    sound_volume_txt.draw(Vec2.new(option_x + option_width, y_pos))
end

function handle_input_sound_volume ()
    if Controls.get_key_down(ActionKey.left) then
        Audio.play_beep_short()
        
        G.game_options.reduce_sound_volume(0.01)

        build_sound_volume()
    elseif Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        G.game_options.increase_sound_volume(0.01)

        build_sound_volume()
    end
end
-- #endregion Option: Sound volume

-- #region Option: Text speed
function build_text_speed ()
    text_speed_slow_txt = font.render_plain_text_shadowed(
        loc("screens.options.text_speed.slow")
    )
    text_speed_mid_txt = font.render_plain_text_shadowed(
        loc("screens.options.text_speed.mid")
    )
    text_speed_fast_txt = font.render_plain_text_shadowed(
        loc("screens.options.text_speed.fast")
    )
    text_speed_instant_txt = font.render_plain_text_shadowed(
        loc("screens.options.text_speed.instant")
    )
    recolor_text_speed()
end

function draw_text_speed (y_offset)
    local eff_width = option_width - text_speed_instant_txt.width
    local step = eff_width / 3
    local y_pos = label_first_y + y_offset

    text_speed_slow_txt.draw(Vec2.new(option_x, y_pos))
    text_speed_mid_txt.draw(Vec2.new(option_x + math.floor(step), y_pos))
    text_speed_fast_txt.draw(Vec2.new(option_x + math.floor(step * 2), y_pos))
    text_speed_instant_txt.draw(Vec2.new(option_x + math.floor(step * 3), y_pos))
end

function handle_input_text_speed ()
    if Controls.get_key_down(ActionKey.left) then
        Audio.play_beep_short()

        if G.game_options.text_speed <= TEXT_SPEED_SLOW then
            G.game_options.set_text_speed(TEXT_SPEED_INSTANT)
        elseif G.game_options.text_speed <= TEXT_SPEED_MID then
            G.game_options.set_text_speed(TEXT_SPEED_SLOW)
        elseif G.game_options.text_speed <= TEXT_SPEED_FAST then
            G.game_options.set_text_speed(TEXT_SPEED_MID)
        else
            G.game_options.set_text_speed(TEXT_SPEED_FAST)
        end

        recolor_text_speed()
        build_textbox()
    elseif Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        if G.game_options.text_speed <= TEXT_SPEED_SLOW then
            G.game_options.set_text_speed(TEXT_SPEED_MID)
        elseif G.game_options.text_speed <= TEXT_SPEED_MID then
            G.game_options.set_text_speed(TEXT_SPEED_FAST)
        elseif G.game_options.text_speed <= TEXT_SPEED_FAST then
            G.game_options.set_text_speed(TEXT_SPEED_INSTANT)
        else
            G.game_options.set_text_speed(TEXT_SPEED_SLOW)
        end

        recolor_text_speed()
        build_textbox()
    end
end

function recolor_text_speed ()
    if G.game_options.text_speed == TEXT_SPEED_SLOW then
        text_speed_slow_txt.set_color(OPTION_COLOR_FOCUSED)
        text_speed_slow_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        text_speed_slow_txt.set_color(TXT_COLOR_REGULAR)
        text_speed_slow_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
    if G.game_options.text_speed == TEXT_SPEED_MID then
        text_speed_mid_txt.set_color(OPTION_COLOR_FOCUSED)
        text_speed_mid_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        text_speed_mid_txt.set_color(TXT_COLOR_REGULAR)
        text_speed_mid_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
    if G.game_options.text_speed == TEXT_SPEED_FAST then
        text_speed_fast_txt.set_color(OPTION_COLOR_FOCUSED)
        text_speed_fast_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        text_speed_fast_txt.set_color(TXT_COLOR_REGULAR)
        text_speed_fast_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
    if G.game_options.text_speed > TEXT_SPEED_FAST then
        text_speed_instant_txt.set_color(OPTION_COLOR_FOCUSED)
        text_speed_instant_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    else
        text_speed_instant_txt.set_color(TXT_COLOR_REGULAR)
        text_speed_instant_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    end
end
-- #endregion Option: Text speed

-- #region Option: Battle anims
function build_battle_anims ()
    battle_anims_on_txt = font.render_plain_text_shadowed(loc("on"))
    battle_anims_off_txt = font.render_plain_text_shadowed(loc("off"))
    recolor_battle_anims()
end

function draw_battle_anims (y_offset)
    local eff_width = option_width - battle_anims_off_txt.width
    local y_pos = label_first_y + y_offset

    battle_anims_on_txt.draw(Vec2.new(option_x, y_pos))
    battle_anims_off_txt.draw(Vec2.new(option_x + math.floor(eff_width), y_pos))
end

function handle_input_battle_anims ()
    if Controls.get_key_down(ActionKey.left) or Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        G.game_options.set_battle_animations(not G.game_options.battle_animations)

        recolor_battle_anims()
    end
end

function recolor_battle_anims ()
    if G.game_options.battle_animations then
        battle_anims_on_txt.set_color(OPTION_COLOR_FOCUSED)
        battle_anims_on_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
        battle_anims_off_txt.set_color(TXT_COLOR_REGULAR)
        battle_anims_off_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    else
        battle_anims_on_txt.set_color(TXT_COLOR_REGULAR)
        battle_anims_on_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
        battle_anims_off_txt.set_color(OPTION_COLOR_FOCUSED)
        battle_anims_off_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    end
end
-- #endregion Option: Battle anims

-- #region Option: Give nicknames
function build_give_nicknames ()
    give_nicknames_on_txt = font.render_plain_text_shadowed(loc("on"))
    give_nicknames_off_txt = font.render_plain_text_shadowed(loc("off"))
    recolor_give_nicknames()
end

function draw_give_nicknames (y_offset)
    local eff_width = option_width - give_nicknames_off_txt.width
    local y_pos = label_first_y + y_offset

    give_nicknames_on_txt.draw(Vec2.new(option_x, y_pos))
    give_nicknames_off_txt.draw(Vec2.new(option_x + math.floor(eff_width), y_pos))
end

function handle_input_give_nicknames ()
    if Controls.get_key_down(ActionKey.left) or Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        G.game_options.set_battle_animations(not G.game_options.battle_animations)

        recolor_give_nicknames()
    end
end

function recolor_give_nicknames ()
    if G.game_options.battle_animations then
        give_nicknames_on_txt.set_color(OPTION_COLOR_FOCUSED)
        give_nicknames_on_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
        give_nicknames_off_txt.set_color(TXT_COLOR_REGULAR)
        give_nicknames_off_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
    else
        give_nicknames_on_txt.set_color(TXT_COLOR_REGULAR)
        give_nicknames_on_txt.set_shadow_color(TXT_COLOR_REGULAR_SHADOW)
        give_nicknames_off_txt.set_color(OPTION_COLOR_FOCUSED)
        give_nicknames_off_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
    end
end
-- #endregion Option: Give nicknames

-- #region Option: Message frame
function build_message_frame ()
    message_frames = Data.message_frames
    message_frame_index = List.index_of(message_frames, G.game_options.message_frame)

    message_frame_txt = font.render_plain_text_shadowed(
        loc("screens.options.message_frames.current", message_frame_index, #message_frames)
    )
    message_frame_txt.set_color(OPTION_COLOR_FOCUSED)
    message_frame_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
end

function draw_message_frame (y_offset)
    local x_pos = option_x + math.floor((option_width - message_frame_txt.width) / 2)
    local y_pos = label_first_y + y_offset

    message_frame_txt.draw(Vec2.new(x_pos, y_pos))
end

function handle_input_message_frame ()
    if Controls.get_key_down(ActionKey.left) then
        Audio.play_beep_short()

        if message_frame_index > 1 then
            message_frame_index = message_frame_index - 1
        else
            message_frame_index = #message_frames
        end

        G.game_options.set_message_frame(message_frames[message_frame_index])

        build_message_frame()
    elseif Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        if message_frame_index < #message_frames then
            message_frame_index = message_frame_index + 1
        else
            message_frame_index = 1
        end

        G.game_options.set_message_frame(message_frames[message_frame_index])

        build_message_frame()
    end
end
-- #endregion Option: Message frame

-- #region Option: Box frame
function build_box_frame ()
    box_frames = Data.box_frames
    box_frame_index = List.index_of(box_frames, G.game_options.box_frame)

    box_frame_txt = font.render_plain_text_shadowed(
        loc("screens.options.box_frames.current", box_frame_index, #box_frames)
    )
    box_frame_txt.set_color(OPTION_COLOR_FOCUSED)
    box_frame_txt.set_shadow_color(OPTION_COLOR_FOCUSED_SHADOW)
end

function draw_box_frame (y_offset)
    local x_pos = option_x + math.floor((option_width - box_frame_txt.width) / 2)
    local y_pos = label_first_y + y_offset

    box_frame_txt.draw(Vec2.new(x_pos, y_pos))
end

function handle_input_box_frame ()
    if Controls.get_key_down(ActionKey.left) then
        Audio.play_beep_short()

        if box_frame_index > 1 then
            box_frame_index = box_frame_index - 1
        else
            box_frame_index = #box_frames
        end

        G.game_options.set_box_frame(box_frames[box_frame_index])

        build_box_frame()
        init()
    elseif Controls.get_key_down(ActionKey.right) then
        Audio.play_beep_short()

        if box_frame_index < #box_frames then
            box_frame_index = box_frame_index + 1
        else
            box_frame_index = 1
        end

        G.game_options.set_box_frame(box_frames[box_frame_index])

        build_box_frame()
        init()
    end
end
-- #endregion Option: Box frame
