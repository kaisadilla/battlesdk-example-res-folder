local GameSummary = require("lib.screen_elements.game_summary")

---@type GameSummary
local summary

function target:open ()
    summary = GameSummary.new()

    local choice = Hud.choice_message(
        loc("screens.save.text.1"),
        {
            loc("yes"),
            loc("no"),
        },
        true,
        2
    )

    if choice == 2 then
        target:close()
        return
    end

    Audio.play("game_saved")
    Hud.message(loc("screens.save.text.2"))
    Logger.info("Now the game would be saved.")
    target:close()
end

function target:draw ()
    if summary then summary:draw() end
end
