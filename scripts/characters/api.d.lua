-- #region Global functions
--- Waits for the amount of time given before executing the next instruction.
---@param ms number The amount of time, in milliseconds, to wait.
function wait(ms) end

--- Opens a message textbox with the text provided.
---@param text string The text to display.
function message(text) end
-- #endregion Global functions

---@class Character
local Character = {}

--- Moves the character n steps up (1 if no amount is provided),
---@overload fun(): void
---@overload fun(steps: integer): void
function Character.move_up(steps) end

--- Moves the character n steps down (1 if no amount is provided),
---@overload fun(): void
---@overload fun(steps: integer): void
function Character.move_down(steps) end

--- Moves the character n steps to the left (1 if no amount is provided),
---@overload fun(): void
---@overload fun(steps: integer): void
function Character.move_left(steps) end

--- Moves the character n steps to the right (1 if no amount is provided),
---@overload fun(): void
---@overload fun(steps: integer): void
function Character.move_right(steps) end

--- Makes the character look upwards.
function Character.look_up() end

--- Makes the character look downwards.
function Character.look_down() end

--- Makes the character look to the left.
function Character.look_left() end

--- Makes the character look to the right.
function Character.look_right() end

--- Makes the character look towards the player.
function Character.look_towards_player() end

--- Makes the character jump in place n times (1 if no amount is provided),
---@overload fun(): void
---@overload fun(times: integer): void
function Character.jump(times) end

--- Makes the character start or stop ignoring other characters while moving.
---@overload fun(): void 
---@overload fun(val: boolean): void
---@param val boolean? True to ignore characters, false to stop ignoring them.
function Character.ignore_characters(val) end

---@type Character -- The character that owns this interaction.
target = {}
---@type Character -- The player.
player = {}