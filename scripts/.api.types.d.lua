-- #region Audio
---@class Audio
Audio = {}

---@param sound_name any 
function Audio.play (sound_name) end

function Audio.play_beep_short () end

---@return string
function Audio.to_string () end
-- #endregion Audio

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

---@param times number? 
function Entity.move_up (times) end

---@param times number? 
function Entity.move_down (times) end

---@param times number? 
function Entity.move_left (times) end

---@param times number? 
function Entity.move_right (times) end

function Entity.look_up () end

function Entity.look_down () end

function Entity.look_left () end

function Entity.look_right () end

function Entity.look_towards_player () end

---@param times number? 
function Entity.jump (times) end

---@param val boolean 
function Entity.ignore_characters (val) end

---@return string
function Entity.to_string () end
-- #endregion Entity

-- #region Font
---@class Font
Font = {}

---@param str string 
---@return Sprite
function Font.render_plain_text (str) end

---@param str string 
---@return Sprite
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
---@field dex_unlocked boolean
G = {}

---@return boolean
function G.get_dex_unlocked () end

---@return string
function G.to_string () end
-- #endregion G

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

-- #region Sprite
---@class Sprite
Sprite = {}

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

