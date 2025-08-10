-- #region Audio
---@class Audio
Audio = {}

---@param sound_name any 
function Audio.play (sound_name) end

function Audio.play_beep_short () end

---@return string
function Audio.to_string () end
-- #endregion Audio

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

-- #region Font
---@class Font
---@field line_height number -- The height of one line in this font.
Font = {}

---@return number
function Font.get_line_height () end

---@param str string 
---@return PlainTextSprite
function Font.render_plain_text (str) end

---@param str string 
---@return PlainTextSprite
function Font.render_plain_text_shadowed (str) end

---@return string
function Font.to_string () end
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

---@return string
function FrameSprite.to_string () end
-- #endregion FrameSprite

-- #region G
---@class G
---@field money number -- The amount of money the player has.
---@field dex_unlocked boolean
G = {}

---@return number
function G.get_money () end

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

---Pauses execution of this script for the amount of time given (in ms).
---@param ms number The amount of time, in milliseconds, to wait.
function Hud.wait (ms) end

---@return string
function Hud.to_string () end
-- #endregion Hud

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

-- #region PlainTextSprite
---@class PlainTextSprite
---@field width number -- This sprite's width.
---@field weight number -- This sprite's height.
PlainTextSprite = {}

---@param color Color 
function PlainTextSprite.set_color (color) end

---@param color Color 
function PlainTextSprite.set_shadow_color (color) end

---@return string
function PlainTextSprite.to_string () end

---@return number
function PlainTextSprite.get_width () end

---@return number
function PlainTextSprite.get_weight () end

---@param pos Vec2 
function PlainTextSprite.draw (pos) end

---@param pos Vec2 
---@param size Vec2 
function PlainTextSprite.draw (pos, size) end
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

---@return string
function Renderer.to_string () end
-- #endregion Renderer

-- #region Screen
---@class Screen
Screen = {}

---Closes the current screen.
function Screen.close_current_screen () end

---Opens the main menu.
function Screen.open_main_menu () end

---Opens the save game screen.
function Screen.open_save_game () end

---@return string
function Screen.to_string () end
-- #endregion Screen

-- #region Sprite
---@class Sprite
---@field width number -- This sprite's width.
---@field weight number -- This sprite's height.
Sprite = {}

---@return number
function Sprite.get_width () end

---@return number
function Sprite.get_weight () end

---@param pos Vec2 
function Sprite.draw (pos) end

---@param pos Vec2 
---@param size Vec2 
function Sprite.draw (pos, size) end

---@return string
function Sprite.to_string () end
-- #endregion Sprite

-- #region Vec2
---@class Vec2
---@field x number
---@field y number
Vec2 = {}

---@param x number 
---@param y number 
---@return Vec2
function Vec2.new (x, y) end

---@param a Vec2 
---@param b Vec2 
---@return Vec2
function Vec2.op__addition (a, b) end

---@param mult number 
---@param vec Vec2 
---@return Vec2
function Vec2.op__multiply (mult, vec) end

---@param vec Vec2 
---@param mult number 
---@return Vec2
function Vec2.op__multiply (vec, mult) end
-- #endregion Vec2

