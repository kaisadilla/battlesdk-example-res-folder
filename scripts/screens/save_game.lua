local summary

function target:open ()
    summary = require("lib.screen_elements.game_summary")
    summary.build()

    local choice = Hud.choice_message(
        "screens.save.text.1",
        {
            "yes",
            "no",
        },
        true,
        2
    )

    if choice == 2 then
        target:close()
        return
    end

    Audio.play("game_saved")
    Hud.message("screens.save.text.2")
    Logger.info("Now the game would be saved.")
    target:close()
end

function target:draw ()
    if summary then summary.draw() end
end
