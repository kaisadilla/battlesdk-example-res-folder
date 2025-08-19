function target.open (args)
    local welcome_msg = args.welcome_msg
    local items = args.items

    start(welcome_msg, items)
end

function target.update ()

end

function target.draw ()

end

function start (welcome_msg, items)
    local res = Hud.choice_message(
        welcome_msg,
        {
            "Buy",
            "Sell",
            "See ya!",
        }
    )

    if res == 1 then
        buy(items)
    elseif res == 2 then
        sell(items)
    else
        Hud.message(loc("characters.default.shopkeeper.goodbye"))
        target.close()
    end
end

function buy (items)
    Hud.script_element("hud/shop_buy", Object.new({ items = items }))
    start(loc("characters.default.shopkeeper.more"), items)
end

function sell (items)
    Hud.script_element("hud/shop_sell")
    start(loc("characters.default.shopkeeper.more"), items)
end
