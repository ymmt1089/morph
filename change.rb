list_color_db = Array.new # 色彩判定データベース格納用配列

File.open('color_db.txt', 'r') do |file| # 'color_db.txt'は色彩値データベースを保存したテキストファイル
    file.each{ |db|
        array = Array.new
        array_one = Array.new
        array = db.chomp.split(':')[1]#色彩値
        array = array.scan(/.{1,#{2}}/)
        array.first(3).each do |value|
            array_one << value + ":"
        end
        list_color_db << array_one
    }
end

zzz = Array.new
list_color_db.each{|a|
    arr = Array.new
    arr = a
    zzz << arr
}
puts list_color_db
# puts zzz

# File.open('color_db.txt', 'r') do |file| # 'color_db.txt'は色彩値データベースを保存したテキストファイル
#     file.each{ |db|
#         hash = Hash.new
#         hash['color_name'.to_sym] = db.chomp.split(':')[0]#色彩の名前
#         hash['color_hex'.to_sym] = db.chomp.split(':')[1]#色彩値
#         list_color_db << hash
#     }
# end