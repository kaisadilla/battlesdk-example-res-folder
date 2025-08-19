-- #region AnimatableTextbox
---@class AnimatableTextbox
---@field position Vec2
---@field width number
---@field height number
AnimatableTextbox = {}

---@return Vec2
function AnimatableTextbox.get_position () end

---@return number
function AnimatableTextbox.get_width () end

---@return number
function AnimatableTextbox.get_height () end

function AnimatableTextbox.draw () end

---@param anchor number 
function AnimatableTextbox.set_anchor (anchor) end

---@return string
function AnimatableTextbox.to_string () end

---@return string
function AnimatableTextbox.str () end
-- #endregion AnimatableTextbox

-- #region Audio
---@class Audio
Audio = {}

---@param sound_name any 
function Audio.play (sound_name) end

function Audio.play_beep_short () end

---@return string
function Audio.to_string () end
-- #endregion Audio

-- #region ChoiceBox
---@class ChoiceBox
---@field position Vec2
---@field width number
---@field height number
ChoiceBox = {}

---@return Vec2
function ChoiceBox.get_position () end

---@return number
function ChoiceBox.get_width () end

---@return number
function ChoiceBox.get_height () end

function ChoiceBox.draw () end

function ChoiceBox.move_up () end

function ChoiceBox.move_down () end

---@return string
function ChoiceBox.to_string () end

---@return string
function ChoiceBox.str () end
-- #endregion ChoiceBox

-- #region Color
---@class Color
---@field r number
---@field g number
---@field b number
---@field a number
Color = {}

---@param r number 
---@param g number 
---@param b number 
---@param a number 
---@return Color
function Color.new (r, g, b, a) end

---@return string
function Color.to_string () end

---@return string
function Color.str () end
-- #endregion Color

-- #region Controls
---@class Controls
Controls = {}

---@param key number 
---@return boolean
function Controls.get_key_down (key) end

---@param key number 
---@return boolean
function Controls.get_key (key) end

---@param key number 
---@return boolean
function Controls.get_key_up (key) end

---@return string
function Controls.to_string () end
-- #endregion Controls

-- #region Data
---@class Data
Data = {}

---@param item_id string 
---@return Item
function Data.get_item (item_id) end

---Returns the name of the pocket the item given naturally belongs to.
---@param item_id string The id of the item to check.
---@return string
function Data.get_item_pocket (item_id) end

---@return string
function Data.to_string () end
-- #endregion Data

-- #region Entity
---@class Entity
Entity = {}

---Moves the character up once, unless a different amount of steps is
---specified.
---@param steps number | nil The amount of steps to take.
function Entity.move_up (steps) end

---Moves the character up down, unless a different amount of steps is
---specified.
---@param steps number | nil The amount of steps to take.
function Entity.move_down (steps) end

---Moves the character left once, unless a different amount of steps is
---specified.
---@param steps number | nil The amount of steps to take.
function Entity.move_left (steps) end

---Moves the character right once, unless a different amount of steps is
---specified.
---@param steps number | nil The amount of steps to take.
function Entity.move_right (steps) end

function Entity.look_up () end

function Entity.look_down () end

function Entity.look_left () end

function Entity.look_right () end

function Entity.look_towards_player () end

---@param steps number | nil The amount of steps to take.
function Entity.jump (steps) end

---@param val boolean 
function Entity.ignore_characters (val) end

---@return string
function Entity.to_string () end
-- #endregion Entity

-- #region Fmt
---@class Fmt
Fmt = {}

---@param val any 
---@param padding unknown 
---@param total_width number 
---@return string
function Fmt.pad_left (val, padding, total_width) end

---Formats time as HH:mm.
---@param time number An amount of time, in seconds.
---@return string
function Fmt.time_span_as_hh_mm (time) end

---Formats time as X d X h X m, ignoring any part that is 0 (e.g. 0 days,
---12 hours, 15 minutes becomes "12 h 15 m").
---@param time number 
---@return string
function Fmt.time_span_as_h_m (time) end

---@return string
function Fmt.to_string () end
-- #endregion Fmt

-- #region Font
---@class Font
---@field line_height number -- The height of one line in this font.
---@field line_offset number -- Given a point P, the vertical gap between that point and where the text             should be actually rendered to look good.
Font = {}

---@return number
function Font.get_line_height () end

---@return number
function Font.get_line_offset () end

---@param str string 
---@param max_width number 
---@return PlainTextSprite
function Font.render_plain_text (str, max_width) end

---@param str string 
---@param max_width number 
---@return PlainTextSprite
function Font.render_plain_text_shadowed (str, max_width) end

---@return string
function Font.to_string () end

---@return string
function Font.str () end
-- #endregion Font

-- #region FrameSprite
---@class FrameSprite
---@field padding Rect
FrameSprite = {}

---@return Rect
function FrameSprite.get_padding () end

---@param pos Vec2 
---@param size Vec2 
function FrameSprite.draw (pos, size) end

---@param anchor number 
function FrameSprite.set_anchor (anchor) end

---@return string
function FrameSprite.to_string () end

---@return string
function FrameSprite.str () end
-- #endregion FrameSprite

-- #region G
---@class G
---@field game_options GameSettings -- The options chosen by the player for this specific game.
---@field name string -- The current player's name.
---@field time_played number -- The amount of time, in seconds, that this game has been played.
---@field money number -- The amount of money the player has.
---@field inventory Inventory
---@field dex_unlocked boolean
G = {}

---@return GameSettings
function G.get_game_options () end

---@return string
function G.get_name () end

---@return number
function G.get_time_played () end

---@return number
function G.get_money () end

---@return Inventory
function G.get_inventory () end

---@return boolean
function G.get_dex_unlocked () end

---Adds the amount of money given to the player. Do not use negative
---numbers to remove money from them, instead use `G.remove_money(int)`.
---@param amount number The amount of money to give to the player.
function G.add_money (amount) end

---Removes the amount of money given to the player. Do not use negative
---numbers to give money to them, instead use `G.add_money(int)`.
---@param amount number The amount of money to take from the player.
function G.remove_money (amount) end

---@return string
function G.to_string () end
-- #endregion G

-- #region GameSettings
---@class GameSettings
---@field window_scale number -- The scale of the renderer.
---@field is_full_screen boolean -- True when the game is in full screen. This setting has priority over             'window_scale'.
---@field music_volume number -- A value between 0 and 1 indicating the volume of background music.
---@field sound_volume number -- A value between 0 and 1 indicating the volume of sound effects.
---@field battle_animations boolean -- When false, moves don't have any animation during battle.
---@field give_nicknames boolean -- When false, the player won't be asked to give a nickname to creatures             they receive.
---@field message_frame string -- The default frame to use for messages.
---@field box_frame string -- The default frame to use for other kinds of boxes.
---@field font string -- The default font to use.
GameSettings = {}

---@return number
function GameSettings.get__window_scale () end

---@return boolean
function GameSettings.get_is_full_screen () end

---@return number
function GameSettings.get__music_volume () end

---@return number
function GameSettings.get__sound_volume () end

---@return boolean
function GameSettings.get__battle_animations () end

---@return boolean
function GameSettings.get__give_nicknames () end

---@return string
function GameSettings.get__message_frame () end

---@return string
function GameSettings.get__box_frame () end

---@return string
function GameSettings.get__font () end

---@param scale number 
function GameSettings.set_window_scale (scale) end

---@param active boolean 
function GameSettings.set_full_screen (active) end

---@param volume number 
function GameSettings.set_music_volume (volume) end

---@param volume number 
function GameSettings.set_sound_volume (volume) end

---@param active boolean 
function GameSettings.set_battle_animations (active) end

---@param active boolean 
function GameSettings.set_give_nicknames (active) end

---@param sprite_name string 
function GameSettings.set_message_frame (sprite_name) end

---@param sprite_name string 
function GameSettings.set_box_frame (sprite_name) end

---@param font_name string 
function GameSettings.set_font (font_name) end

---@return string
function GameSettings.to_string () end

---@return string
function GameSettings.str () end
-- #endregion GameSettings

-- #region Hud
---@class Hud
Hud = {}

---Displays a message on a textbox.
---@param text string The localization key for the message to display.
function Hud.message (text) end

---@param message string The content of the textbox.
---@param choices unknown An array of keys for localized strings. Each string represents one choice.
---@param can_be_cancelled boolean | nil True if the choice can be cancelled.
---@param default_choice number | nil The default choice if the player cancels the choice. A value of -1 indicates no choice.
function Hud.choice_message (message, choices, can_be_cancelled, default_choice) end

---Displays a hud element defined by the script given.
---@param script_name string The name of the script in the registry for the hud element.
---@param args Object The arguments that will be passed to the script's 'open' function.
function Hud.script_element (script_name, args) end

---Pauses execution of this script for the amount of time given (in ms).
---@param ms number The amount of time, in milliseconds, to wait.
function Hud.wait (ms) end

---@return string
function Hud.to_string () end

---@return string
function Hud.str () end
-- #endregion Hud

-- #region HudElement
---@class HudElement
---@field is_closed boolean
HudElement = {}

---@return boolean
function HudElement.get_is_closed () end

function HudElement.draw () end

function HudElement.update () end

function HudElement.handle_input () end

function HudElement.close () end

---@return string
function HudElement.to_string () end

---@return string
function HudElement.str () end
-- #endregion HudElement

-- #region Inventory
---@class Inventory
Inventory = {}

---@param item_id string 
---@return number
function Inventory.get_amount (item_id) end

---@param item_id string 
---@param amount number 
---@return number
function Inventory.add_amount (item_id, amount) end

---@param item_id string 
---@param amount number 
---@return number
function Inventory.remove_amount (item_id, amount) end

---@param item_id string 
function Inventory.add_favorite (item_id) end

---@param item_id string 
function Inventory.remove_favorite (item_id) end

---@param index number 
---@return unknown
function Inventory.get_items_at (index) end

---@return unknown
function Inventory.get_favorite_items () end

---@return string
function Inventory.to_string () end

---@return string
function Inventory.str () end
-- #endregion Inventory

-- #region InventoryItem
---@class InventoryItem
---@field item_id string
---@field amount number
InventoryItem = {}

---@param item_id string 
---@param amount number 
---@return InventoryItem
function InventoryItem.new (item_id, amount) end

---@return string
function InventoryItem.to_string () end

---@return string
function InventoryItem.str () end
-- #endregion InventoryItem

-- #region Item
---@class Item
---@field category_id string -- The id of the category this item belongs to.
---@field price number -- The item's price. This value can contain decimals.
Item = {}

---@return unknown
function Item.get__item () end

---@return string
function Item.get_category_id () end

---@return number
function Item.get_price () end

---@return string
function Item.to_string () end

---@return string
function Item.str () end
-- #endregion Item

-- #region List
---@class List
---@field item unknown
List = {}

---@return List
function List.new () end

---@param tbl table 
---@return List
function List.new (tbl) end

---@param key number 
---@return unknown
function List.get__item (key) end

---@param key number 
---@param value unknown 
function List.set__item (key, value) end

---@param ctx unknown 
---@param args unknown 
---@return any
function List.ipairs (ctx, args) end

---@return string
function List.to_string () end

---@return string
function List.str () end
-- #endregion List

-- #region Logger
---@class Logger
Logger = {}

---@param msg any 
function Logger.trace (msg) end

---@param msg any 
function Logger.debug (msg) end

---@param msg any 
function Logger.info (msg) end

---@param msg any 
function Logger.error (msg) end

---@param msg any 
function Logger.fatal (msg) end

---@return string
function Logger.to_string () end
-- #endregion Logger

-- #region MessageHudElement
---@class MessageHudElement
---@field is_message_complete boolean
---@field is_closed boolean
MessageHudElement = {}

---@return boolean
function MessageHudElement.get_is_message_complete () end

---@return string
function MessageHudElement.to_string () end

---@return string
function MessageHudElement.str () end

---@return boolean
function MessageHudElement.get_is_closed () end

function MessageHudElement.draw () end

function MessageHudElement.update () end

function MessageHudElement.handle_input () end

function MessageHudElement.close () end

---@return string
function MessageHudElement.str () end
-- #endregion MessageHudElement

-- #region Object
---@class Object
---@field item unknown
Object = {}

---@param ctx unknown 
---@param args unknown 
---@return any
function Object.new (ctx, args) end

---@param key string 
---@return unknown
function Object.get__item (key) end

---@param key string 
---@param value unknown 
function Object.set__item (key, value) end

---@param ctx unknown 
---@param args unknown 
---@return any
function Object.pairs (ctx, args) end

---@return string
function Object.to_string () end

---@return string
function Object.str () end
-- #endregion Object

-- #region PlainTextSprite
---@class PlainTextSprite
---@field width number -- This sprite's width.
---@field height number -- This sprite's height.
PlainTextSprite = {}

---@param anchor number 
function PlainTextSprite.set_anchor (anchor) end

---@param color Color 
function PlainTextSprite.set_color (color) end

---@param color Color 
function PlainTextSprite.set_shadow_color (color) end

---@return string
function PlainTextSprite.to_string () end

---@return number
function PlainTextSprite.get_width () end

---@return number
function PlainTextSprite.get_height () end

---Draws the sprite at the position given, anchored at the top left.
---@param pos Vec2 The position at which to draw the sprite.
function PlainTextSprite.draw (pos) end

---Draws the sprite at the position given, with the anchor given.
---@param pos Vec2 The position at which to draw the sprite.
---@param anchor unknown The anchor to use.
function PlainTextSprite.draw (pos, anchor) end

---Draws the sprite at the position given, with the size given.
---@param pos Vec2 The position at which to draw the sprite.
---@param size Vec2 The size in the screen of the drawn sprite.
function PlainTextSprite.draw (pos, size) end

---@param anchor number 
function PlainTextSprite.set_anchor (anchor) end

---@return string
function PlainTextSprite.str () end
-- #endregion PlainTextSprite

-- #region Rect
---@class Rect
---@field left number
---@field right number
---@field top number
---@field bottom number
Rect = {}

---@param top number 
---@param left number 
---@param bottom number 
---@param right number 
---@return Rect
function Rect.new (top, left, bottom, right) end

---@return string
function Rect.to_string () end

---@return string
function Rect.str () end
-- #endregion Rect

-- #region Renderer
---@class Renderer
---@field width number -- The viewport's logical width when scale = 1.
---@field height number -- The viewport's logical height when scale = 1.
Renderer = {}

---@return number
function Renderer.get_width () end

---@return number
function Renderer.get_height () end

---Returns the sprite with the name given.
---@param arg any The name of the sprite.
---@return Sprite
function Renderer.get_sprite (arg) end

---Returns the sprite with the name given as a FrameSprite, or null if no
---such sprite exists, or if it's not a frame.
---@param arg any The name of the sprite.
---@return FrameSprite
function Renderer.get_frame (arg) end

---Returns the font with the name given, or null if no such font exists.
---@param name string The name of the font.
---@return Font
function Renderer.get_font (name) end

---Returns the default text font of the game.
---@return Font
function Renderer.get_default_font () end

---@param frame string 
---@param font string 
---@param pos Vec2 
---@param size Vec2 
---@param text string 
---@return Textbox
function Renderer.get_textbox (frame, font, pos, size, text) end

---@param frame string 
---@param font string 
---@param pos Vec2 
---@param anchor number 
---@param choices unknown 
---@return ChoiceBox
function Renderer.get_choice_box (frame, font, pos, anchor, choices) end

---@param script_name string 
---@return ScriptElement
function Renderer.get_script_element (script_name) end

---Gets a message hud element that isn't controlled by the Hud.
---@param frame string The name of the frame to use.
---@param font string The name of the font to use.
---@param text string The text contained in the message box.
---@return MessageHudElement
function Renderer.get_message_hud_element (frame, font, text) end

---@param script_name string 
---@param args Object 
---@return ScriptHudElement
function Renderer.get_script_hud_element (script_name, args) end

---Paints the entire screen on the color given.
---@param color Color The color to use.
function Renderer.paint_screen (color) end

---Draws a rectangle with the parameters given.
---@param pos Vec2 The position of the top-left corner.
---@param size Vec2 The rectangle's size.
---@param color Color The rectangle's color.
function Renderer.draw_rectangle (pos, size, color) end

---@return string
function Renderer.to_string () end

---@return string
function Renderer.str () end
-- #endregion Renderer

-- #region Screen
---@class Screen
Screen = {}

---Closes the current screen.
function Screen.close_current_screen () end

---Opens the main menu.
function Screen.open_main_menu () end

---Opens the bag.
function Screen.open_bag () end

---Opens the save game screen.
function Screen.open_save_game () end

---Opens the shop screen, if it exists.
function Screen.open_shop () end

---Plays a transition on screen as described.
---@param script_name string The name of the transition's script.
---@param seconds number The time, in seconds, that will take for the             transition to complete.
---@param reverse boolean True to transition FROM black, rather than TO black.
function Screen.play_transition (script_name, seconds, reverse) end

---@return string
function Screen.to_string () end

---@return string
function Screen.str () end
-- #endregion Screen

-- #region Script
---@class Script
Script = {}

---Pauses execution of this script for the amount of time given (in seconds).
---@param seconds number The amount of time, in seconds, to wait.
function Script.wait (seconds) end

---Pauses execution of this script until the next frame.
function Script.wait_for_next_frame () end

---@return string
function Script.to_string () end

---@return string
function Script.str () end
-- #endregion Script

-- #region ScriptElement
---@class ScriptElement
ScriptElement = {}

function ScriptElement.draw () end

function ScriptElement.update () end

---@param func string 
---@param args Object 
function ScriptElement.call (func, args) end

---@return string
function ScriptElement.to_string () end

---@return string
function ScriptElement.str () end
-- #endregion ScriptElement

-- #region ScriptHudElement
---@class ScriptHudElement
---@field result any
---@field is_closed boolean
ScriptHudElement = {}

---@return any
function ScriptHudElement.get__result () end

---@param result any 
function ScriptHudElement.set_result (result) end

---@return string
function ScriptHudElement.to_string () end

---@return boolean
function ScriptHudElement.get_is_closed () end

function ScriptHudElement.draw () end

function ScriptHudElement.update () end

function ScriptHudElement.handle_input () end

function ScriptHudElement.close () end

---@return string
function ScriptHudElement.str () end
-- #endregion ScriptHudElement

-- #region Sprite
---@class Sprite
---@field width number -- This sprite's width.
---@field height number -- This sprite's height.
Sprite = {}

---@return number
function Sprite.get_width () end

---@return number
function Sprite.get_height () end

---Draws the sprite at the position given, anchored at the top left.
---@param pos Vec2 The position at which to draw the sprite.
function Sprite.draw (pos) end

---Draws the sprite at the position given, with the anchor given.
---@param pos Vec2 The position at which to draw the sprite.
---@param anchor unknown The anchor to use.
function Sprite.draw (pos, anchor) end

---Draws the sprite at the position given, with the size given.
---@param pos Vec2 The position at which to draw the sprite.
---@param size Vec2 The size in the screen of the drawn sprite.
function Sprite.draw (pos, size) end

---@param anchor number 
function Sprite.set_anchor (anchor) end

---@return string
function Sprite.to_string () end

---@return string
function Sprite.str () end
-- #endregion Sprite

-- #region Textbox
---@class Textbox
---@field position Vec2
---@field width number
---@field height number
Textbox = {}

---@return Vec2
function Textbox.get_position () end

---@return number
function Textbox.get_width () end

---@return number
function Textbox.get_height () end

function Textbox.draw () end

---@param anchor number 
function Textbox.set_anchor (anchor) end

---@return string
function Textbox.to_string () end

---@return string
function Textbox.str () end
-- #endregion Textbox

-- #region Vec2
---@class Vec2
---@field x number
---@field y number
---@field zero Vec2 -- The vector (0, 0).
Vec2 = {}

---@return Vec2
function Vec2.get_zero () end

---@param x number 
---@param y number 
---@return Vec2
function Vec2.new (x, y) end

---@param a Vec2 
---@param b Vec2 
---@return Vec2
function Vec2.op__addition (a, b) end

---@param a Vec2 
---@param b Vec2 
---@return Vec2
function Vec2.op__subtraction (a, b) end

---@param mult number 
---@param vec Vec2 
---@return Vec2
function Vec2.op__multiply (mult, vec) end

---@param vec Vec2 
---@param mult number 
---@return Vec2
function Vec2.op__multiply (vec, mult) end

---@return string
function Vec2.str () end
-- #endregion Vec2

