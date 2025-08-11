function target.draw (progress)
    renderer:paint_screen(Color.new(0, 0, 0, math.ceil(255 * progress)))
end
