--- Adds the given item to the player's inventory, and shows a message explaining
--- that the player put the item in the inventory.
---@param item_id string The id of the item to give to the player.
---@param amount number The amount of said item to give to the player.
function obtain_items (item_id, amount)
    if item_id == nil then error("Missing item id.") end
    if amount == nil then error("Missing amount.") end

    local pocket = Data.get_item_pocket(item_id)

    G.inventory.add_amount(item_id, amount)
    Hud.message(loc(
        "You put away the {%0} in the {%1} Pocket.",
        loc("names.items." .. item_id),
        loc("names.bag." .. pocket)
    ))
end
