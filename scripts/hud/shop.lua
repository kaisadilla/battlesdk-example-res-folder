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
    --el.call("say_hi", Object.new({ msg = "Mega marshall message" }))
    local res = Hud.choice_message(
        welcome_msg,
        {
            "Buy",
            "Sell",
            "See ya!",
        }
    )

    if res == 1 then
        buy(welcome_msg, items)
    elseif res == 2 then
        start(welcome_msg, items)
    else
        target.close()
    end
end

function buy (welcome_msg, items)
    Hud.script_element("hud/shop_buy", items)
    start(welcome_msg, items)
end
