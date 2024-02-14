require "chunky_png"
require "digest/md5"

print "passe um user para gerar a imagem: "
hash_input = gets.chomp

hash_color = []
hash_pattern = []
hash = Digest::MD5.hexdigest(hash_input)
hash.to_s
hash_char = hash.split('')

def separate_hashes(hash_char: String)
    hash_char.each_with_index do |c, i|
        if i > 5 then
            hash_pattern[i] = c
        else
            hash_color[i] = c
        end
    end
end

hash_pattern = hash_pattern.join.bytes
hash_color = hash_color.join

img = ChunkyPNG::Image.new(251,251, ChunkyPNG::Color::WHITE)
grid = []

# gather 13 first items
hash_pattern.each_with_index do |n, i|
   if i < 15 then
    grid[i] = n
   end
end

# mirroring array
# iterar sobre o grid -> index -> 3 6 9 12 -> grid.delete()

grid_final = []
grid_tmp = []
for i in 0..grid.length/3.to_i
    if i == 0 then
        grid_tmp = grid.first(3) 
    else
        grid_tmp = grid[i*3..i*3+2]
    end
    grid_final << grid_tmp
end

# mirroring
grid_final.each do |arr|
    arr << arr[0..1].reverse!
end
grid_final.flatten!

# filtering numbers
grid_final = grid_final.collect do |n|
    n.even? ? n : 0
end


pixels = []
for i in 0..grid_final.length-1
    if grid_final[i] == 0 then
        vertical_trail = 0
        horizontal_trail = 0
        pixels[i] = { 
            :init => [ vertical_trail, horizontal_trail ], 
            :end => [ vertical_trail, horizontal_trail ] 
        }
    else
        vertical_trail = (i % 5).to_i * 50
        horizontal_trail = (i / 5).to_i * 50
        pixels[i] = { 
            :init => [ vertical_trail, horizontal_trail ], 
            :end => [ vertical_trail+50, horizontal_trail+50 ] 
        }
    end
end

puts pixels

pixels.each do |p|
    for v in p[:init][0]..p[:end][0]
        for h in p[:init][1]..p[:end][1]
            img[v, h] = ChunkyPNG::Color.from_hex(hash_color)
        end
    end
end


img.save('test.png', interlace:true)