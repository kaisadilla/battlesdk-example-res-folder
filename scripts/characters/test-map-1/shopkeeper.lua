Hud.script_element(
    "hud/shop",
    Object.new({
        welcome_msg = "Hello, how may I help you?",
        items = Object.new({
            items = List.new(
                {
                    {
                        id = "poke_ball",
                    },
                    {
                        id = "great_ball",
                    },
                    {
                        id = "ultra_ball",
                        price = 1000 -- override default price, this doesn't affect sell price.
                    },
                    {
                        id = "net_ball",
                    },
                    {
                        id = "dive_ball",
                    },
                    {
                        id = "nest_ball",
                        price = 500
                    },
                    {
                        id = "dive_ball",
                    },
                    {
                        id = "dive_ball",
                    },
                    {
                        id = "dive_ball",
                    },
                    {
                        id = "dive_ball",
                    },
                    {
                        id = "dive_ball",
                    },
                    {
                        id = "dive_ball",
                    },
                    {
                        id = "dive_ball",
                    },
                }
            )
        })
    })
)
