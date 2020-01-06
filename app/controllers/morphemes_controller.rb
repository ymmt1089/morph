class MorphemesController < ApplicationController

	def show
		@book = Book.with_deleted.find(params[:id])
		@words_array = []
		one_book_morpheme_origins = Morpheme.where("(pos like ? or pos like ? or pos like ? or pos like ? or pos like ? or pos like ? ) and origin not like ? and origin not like ? and origin not like ? and origin not like ? and origin not like ? and book_id = ? ","名詞-一般","%名詞-固有名詞%","名詞-副詞可能","名詞-接尾-人名","名詞-接尾-地域","動詞-自立","する","ある","なる","いう","いる", @book.id)
		one_book_morpheme_origins_count = one_book_morpheme_origins.group(:origin).count
		one_book_morpheme_origins_count_sorted_hash = Hash[one_book_morpheme_origins_count.sort_by{ |_, v| -v } ] #hash化及び、valueの昇順(DESC)でソートする
		result = one_book_morpheme_origins_count_sorted_hash.reject{|key,value|(/nil/ =~ key) || (value <= (Math.sqrt(one_book_morpheme_origins_count_sorted_hash.first[1]))/2)} #＠hindoのkeyがnilまたはvalueが60未満は除外
		changed_result = result.map{|v| {text:v[0],size:v[1]}}
		words = changed_result.to_json.html_safe
		@words_array = words

		# 以下グラフ用。グラフの記述はリファクタリング必須。
		# 名詞のみの頻出度
		@meishis_array = []
		one_book_morpheme_meishi = Morpheme.where("(pos like ? or pos like ? or pos like ? or pos like ? or pos like ?) and book_id = ?","名詞-一般","%名詞-固有名詞%","名詞-副詞可能","名詞-接尾-人名","名詞-接尾-地域", @book.id)
		one_book_morpheme_meishi_count = one_book_morpheme_meishi.group(:origin).count
		one_book_morpheme_meishi_count_sorted_hash = Hash[one_book_morpheme_meishi_count.sort_by{ |key,value| -value } ]
		result_meishi = one_book_morpheme_meishi_count_sorted_hash.reject{|key,value|(/nil/ =~ key) || (value < 1)}
		unless result_meishi.values.map(&:to_f).sum == 0
			meishi_par = (100) / (result_meishi.values.map(&:to_f).sum)
		end
		changed_result_meishi = result_meishi.map{|v| {meishi:v[0],count:(v[1])*(meishi_par)}}
		meishis = changed_result_meishi.to_json.html_safe
		@meishis_array = meishis

		table_meishi = Hash[*result_meishi.to_a.shift(20).flatten!]
		@table_meishi = table_meishi.map{|v| {meishi:v[0],count:v[1]}}
		table_meishi = Hash[*result_meishi.to_a.shift(10).flatten!]
		table_meishi = table_meishi.map{|v| {meishi:v[0],count:v[1]}}
		table_meishi_changed_json = table_meishi.to_json.html_safe
		@table_maishi_graph = table_meishi_changed_json

		# 動詞のみの頻出度
		@doushis_array = []
		one_book_morpheme_doushi = Morpheme.where("(pos like ? and origin not like ? and origin not like ? and origin not like ? and origin not like ? and origin not like ?) and book_id = ?","動詞-自立","する","ある","なる","いう","いる" ,@book.id)
		one_book_morpheme_doushi_count = one_book_morpheme_doushi.group(:origin).count
		one_book_morpheme_doushi_count_sorted_hash = Hash[one_book_morpheme_doushi_count.sort_by{ |key,value| -value } ]
		result_doushi = one_book_morpheme_doushi_count_sorted_hash.reject{|key,value|(/nil/ =~ key) || (value < 1)}
		unless result_doushi.values.map(&:to_f).sum == 0
			doushi_par = (100) / (result_doushi.values.map(&:to_f).sum)
		end
		changed_result_doushi = result_doushi.map{|v| {doushi:v[0],count:(v[1])*(doushi_par)}}
		doushis = changed_result_doushi.to_json.html_safe
		@doushis_array = doushis

		table_doushi = Hash[*result_doushi.to_a.shift(20).flatten!]
		@table_doushi = table_doushi.map{|v| {doushi:v[0],count:v[1]}}
		table_doushi = Hash[*result_doushi.to_a.shift(10).flatten!]
		table_doushi = table_doushi.map{|v| {doushi:v[0],count:v[1]}}
		table_doushi_changed_json = table_doushi.to_json.html_safe
		@table_doushi_graph = table_doushi_changed_json

		# 品詞のみの頻出度
		@hinshis_array = []
		one_book_morpheme_hinshi = Morpheme.where("book_id = ?", @book.id)
		one_book_morpheme_hinshi_count = one_book_morpheme_hinshi.group(:pos).count
		one_book_morpheme_hinshi_count_sorted_hash = Hash[one_book_morpheme_hinshi_count.sort_by{ |key,value| -value }  ]
		result_hinshi = one_book_morpheme_hinshi_count_sorted_hash.reject{|key,value|(/nil/ =~ key) || (value < 1)}
		unless result_hinshi.values.map(&:to_f).sum == 0
			hinshi_par = (100) / (result_hinshi.values.map(&:to_f).sum)
		end
		changed_result_hinshi = result_hinshi.map{|v| {hinshi:v[0],count:(v[1])*(hinshi_par)}}
		hinshis = changed_result_hinshi.to_json.html_safe
		@hinshis_array = hinshis

		table_hinshi = Hash[*result_hinshi.to_a.shift(20).flatten!]
		@table_hinshi = table_hinshi.map{|v| {hinshi:v[0],count:v[1]}}
		table_hinshi = Hash[*result_hinshi.to_a.shift(10).flatten!]
		table_hinshi = table_hinshi.map{|v| {hinshi:v[0],count:v[1]}}
		table_hinshi_changed_json = table_hinshi.to_json.html_safe
		@table_hinshi_graph = table_hinshi_changed_json

	end

	def index
	end
end
