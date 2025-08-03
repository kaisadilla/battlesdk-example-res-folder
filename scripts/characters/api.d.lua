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

--- Makes the character start or stop ignoring other characters while moving.
---@overload fun(): void 
---@overload fun(val: boolean): void
---@param val boolean? True to ignore characters, false to stop ignoring them.
function Character.ignore_characters(val) end

---@type Character -- The character that owns this interaction.
target = {}

--- Opens a message textbox with the text provided.
---@param text string The text to display.
function message(text) end