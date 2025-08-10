if G.money > 2000 then
    Hud.message("characters.test-map-2.biker.msg_steal")
    G.remove_money(300)
    Audio.play("spend_money")
    Hud.message("characters.test-map-2.biker.lose_money")
else
    Hud.message("characters.test-map-2.biker.msg_pity")
end
