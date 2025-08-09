local result = Hud.message_with_choices(
    "I will offer you 4 choices",
    {
        "Choice 1", -- id: 1, to respect Lua's interesting decision of starting arrays at #1.
        "Choice 2",
        "Choice 3",
        "Choice 4",
    },
    true, -- can_cancel
    1 -- default choice (Choice 1)
)

if result == 1 then
    Hud.message("You didn't even bother to move arrows!")
elseif result == 2 then
    Hud.message("Minimal effort.")
elseif result == 3 then
    Hud.message("You are the working type.")
elseif result == 4 then
    Hud.message("Don't lie, you just wrapped around.")
else
    Hud.message("Why did you cancel?")
end
