---@class Screen
local target = {}

--- This function is called once when the screen is opened.
function target:open () end
--- This function is called every frame to draw to the screen. Asynchronous
--- function calls CANNOT be called inside this function.
function target:draw () end
--- This function is called every frame to retrieve input made by the player
--- that frame.
function target:handle_input() end
