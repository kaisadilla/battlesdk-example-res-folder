target:look_left()
wait(750)
target:look_right()
wait(750)
target:look_towards_player()
target:jump()
message(
    "Wow, we can speak, but there's a pandemic so you'll have to respect our distance."
)
player:jump()
target:move_down(2)
target:move_left()
target:look_towards_player()
player:jump()
player:jump()
message(
    "Get ready, I'm about to tell you a very long paragraph."
)
message(
    "When I was a kid, all of this was black empty tiles. " ..
    "Now there's trees and stuff. There's also textboxes, " ..
    "which we need to fill right now with as many words as we can. " ..
    "This text is even longer, as we now have to check transitions across " ..
    "several lines.\n...\nAnd yes, this is being called from Lua."
)
