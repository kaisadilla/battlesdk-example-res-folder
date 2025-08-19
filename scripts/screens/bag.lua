local Bag = require("lib.bag")

local function close_bag (self)
    self.input_locked = true
    Audio.play("screen_close")
    Screen.play_transition("transitions/horizontal_wipe", 0.25, false)
    Script.wait(0.5)
    target.close()
    Screen.play_transition("transitions/fade", 0.25, true)
end

local bag

function target:open ()
    bag = Bag.new(nil, close_bag)
    bag:open()
end

function target:draw ()
    bag:draw()
end

function target:handle_input ()
    bag:handle_input()
end
