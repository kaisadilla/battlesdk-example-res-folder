function target:open ()
    Logger.info("a")
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

    Logger.info("b")
    Audio.play("game_saved")
    Hud.message("screens.save.text.2")
    Logger.info("Now the game would be saved.")
    target:close()
end
