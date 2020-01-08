list_color_db = Array.new # 色彩判定データベース格納用配列

File.open('color_db.txt', 'r') do |file| # 'color_db.txt'は色彩値データベースを保存したテキストファイル
    file.each{ |db|
        array = Array.new
        array = db.chomp.split(':')[1]#色彩値
        array = array.scan(/.{1,#{2}}/)
        list_color_db << array
    }
end
zzz = Array.new
list_color_db.each{|a|
    arr = Array.new
    arr << a.to_a + ":"
    zzz << arr
}

# File.open('color_db.txt', 'r') do |file| # 'color_db.txt'は色彩値データベースを保存したテキストファイル
#     file.each{ |db|
#         hash = Hash.new
#         hash['color_name'.to_sym] = db.chomp.split(':')[0]#色彩の名前
#         hash['color_hex'.to_sym] = db.chomp.split(':')[1]#色彩値
#         list_color_db << hash
#     }
# end
#  puts list_color_db
 puts zzz