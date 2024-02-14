require "chunky_png"

img = ChunkyPNG::Image.new(260, 260, ChunkyPNG::Color::TRANSPARENT)
for i in 0..50
    for j in 0..50
        if i % 2 == 0 and j % 2 == 0 then 
            img[i, j] = ChunkyPNG::Color.from_hex("000000")
        else
            img[i, j] = ChunkyPNG::Color.from_hex("ffffff")
        end
    end
end

img.save("grid.png", interlace: true)