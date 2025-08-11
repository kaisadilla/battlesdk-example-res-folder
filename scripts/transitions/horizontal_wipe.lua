local col = Color.new(0, 0, 0, 255)

function target.draw (progress)
    renderer:draw_rectangle(
        Vec2.zero,
        Vec2.new(renderer.width, (renderer.height / 2) * progress),
        col
    )
    renderer:draw_rectangle(
        Vec2.new(0, 1 + (renderer.height / 2) + ((renderer.height / 2) * (1 - progress))),
        Vec2.new(renderer.width, (renderer.height / 2) * progress),
        col
    )
end
