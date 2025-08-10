local choice = Hud.choice_message(
    "characters.test-map-1.brawly.msg",
    {
        "characters.test-map-1.brawly.choices.1",
        "characters.test-map-1.brawly.choices.2",
        "characters.test-map-1.brawly.choices.3",
        "characters.test-map-1.brawly.choices.4",
        "characters.test-map-1.brawly.choices.5",
    },
    false
)

if choice == 1 then
    Hud.message("characters.test-map-1.brawly.answers.1")
elseif choice == 2 then
    Hud.message("characters.test-map-1.brawly.answers.2")
elseif choice == 3 then
    Hud.message("characters.test-map-1.brawly.answers.3")
elseif choice == 4 then
    Hud.message("characters.test-map-1.brawly.answers.4")
elseif choice == 5 then
    Hud.message("characters.test-map-1.brawly.answers.5")
else
    Hud.message("characters.test-map-1.brawly.answers.cancel")
end
