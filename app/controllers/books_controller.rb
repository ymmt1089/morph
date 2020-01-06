class BooksController < ApplicationController

	before_action :authenticate_user!, only:[:edit, :update]

	def index
		# 検索機能用の記載。やや冗長的。
		if params[:keyword]
			keyword = params[:keyword]
			unless keyword.blank?
				@books = Book.joins(:morphemes).where("morphemes.origin like ? ","%#{keyword}%").page(params[:page]).per(15)
			else
				@books = Book.all.page(params[:page]).per(15)
			end
		else
			@books = Book.all.page(params[:page]).per(15)
		end
		# 以下形態素結果のハッシュ化。他で酷似した記載あるので部分テンプレート化
		@words_array = []
		@words_hash = {}
		@books.each do |book|
			one_book_morpheme_origins = Morpheme.where("(pos like ? or pos like ? or pos like ? or pos like ? or pos like ? or pos like ? ) and origin not like ? and origin not like ? and origin not like ? and origin not like ? and origin not like ? and book_id = ? ","名詞-一般","%名詞-固有名詞%","名詞-副詞可能","名詞-接尾-人名","名詞-接尾-地域","動詞-自立","する","ある","なる","いう","いる", book.id)
			one_book_morpheme_origins_count = one_book_morpheme_origins.group(:origin).count
			one_book_morpheme_origins_count_sorted_hash = Hash[one_book_morpheme_origins_count.sort_by{ |key,value| -value }  ] #hash化及び、valueの昇順(DESC)でソートする
			result = one_book_morpheme_origins_count_sorted_hash.reject{|key,value|(/nil/ =~ key) || (value <= (Math.sqrt(one_book_morpheme_origins_count_sorted_hash.first[1])/2))}
			changed_result = result.map{|v| {text:v[0],size:v[1]}}
			words = changed_result.to_json.html_safe
			@words_array << words
			@words_hash[book.id] = words
		end
	end

	def show
		@book = Book.with_deleted.find(params[:id])
		@user = User.find(@book.user_id)
	end

	def new
		@book = Book.new
		@book.user_id = current_user.id
	end

	def edit
		@book = Book.with_deleted.find(params[:id])
		@user = User.find(@book.user_id)
	end

	def create
		@book = Book.new(book_params)
		@book.user_id = current_user.id

		# 以下形態素解析の記述。やや冗長的。
		# 本番環境でmecab-ipadic-Neologdが使えなかったためwakatiに変換した後、chasen化
      	if @book.save
      		flash[:notice] = "形態素解析が完了しました。"
			require 'mecab'
			wakati = MeCab::Tagger.new ("-Owakati")
			book_wakati = wakati.parse (@book.body)
				book_wakati_gsub = book_wakati.gsub(/\r/,'')
				book_wakati_result = book_wakati_gsub.gsub(/\n/,'')
			chasen = MeCab::Tagger.new ("-Ochasen")
			book_chasen = chasen.parse(book_wakati)
			mecab = book_chasen
			mecab_split = mecab.split("\n")
			mecab_arr = []
			mecab_split.each do |mecab_split|
				mecab_split = mecab_split.gsub(/\r/,'')
				mecab_arr.push(mecab_split.split("\t"))
		end
		# 以下データ収納時間短縮のためバルクインサート使用
		mecab_result = []
		mecab_arr.each { |arr|
		  next if arr.count == 1
		  morpheme = Morpheme.new(
		      surface: arr[0],
		      reading: arr[1],
		      origin: arr[2],
		      pos: arr[3],
		      book_id: @book.id
		  )
		  morpheme.inflection = arr[4] if arr[4].present?
		  morpheme.conjugation = arr[5] if arr[5].present?
		  mecab_result << morpheme
		}
		mecab_result.each_slice(100).each do |morphemes|
			Morpheme.import morphemes
		end
		origins = []
		morphemes = Morpheme.all
		morphemes.each do |morpheme|
			origins.push(morpheme.origin)
		end
		  redirect_to book_path(@book.id)

		# 以下感情分析
		# 感情分析用配列
		one_book_morpheme_origins_all = Morpheme.where("(pos not like ? and pos not like ? and origin not like ? and origin not like ? and origin not like ? and origin not like ? and origin not like ?) and book_id = ?","%記号%","助詞%","する","ある","なる","いう","いる" ,@book.id)
		one_book_morpheme_origins_count_all = one_book_morpheme_origins_all.group(:origin).count
		one_book_morpheme_origins_count_sorted_hash_all = Hash[one_book_morpheme_origins_count_all.sort_by{ |key,value| -value }  ]
		result_all = one_book_morpheme_origins_count_sorted_hash_all.reject{|key,value|(/nil/ =~ key) || (value <= 0)}
		result_all_map = result_all.map{|v| {text:v[0],size:v[1]}}
		sentimental_result = result_all_map.compact

		list_sentimental_db = Array.new # 単語感情極性対応データベース格納用配列
		File.open('sentimental_db.txt', 'r') do |file| # 'sentimental_db.txt'は単語感情極性対応データベースを保存したテキストファイル
			file.each{ |db|
				hash = Hash.new
				hash['text'.to_sym] = db.chomp.split(':')[0]#単語（origin）
				hash['semantic_orientations'.to_sym] = db.chomp.split(':')[3]#感情値
				list_sentimental_db << hash
			}
		end
		semantic_arr = Array.new # 感情値格納用配列
		sentimental_result.each{ |result|
			tmp = Array.new
			result.each{ |h|
				list_sentimental_db.each{ |db|
					# 単語、読み、品詞が一致の場合、感情値をカウント
					if result[:text] == db[:text] then
						tmp.push (db[:semantic_orientations])
					end
				}
			}
			# カウントした感情値の平均値
			semantic_ave = tmp.inject(0){ |sum, i| sum += i.to_f} / tmp.size unless tmp.size == 0
			semantic_arr.push semantic_ave
		}
		semantic_arr_compact = semantic_arr.compact
		sum_semantic_compact_sum = semantic_arr_compact.sum
		unless sum_semantic_compact_sum == 0
			semantic_average = sum_semantic_compact_sum / semantic_arr_compact.length
			@semantic_average_par = (semantic_average*100).round(2)
			@book.sentiment = @semantic_average_par
		else
			@book.sentiment = nil
		end
		@book.save
      else
      	render :new
      end
	end

	def update
		book = Book.find(params[:id])
		if book.update(book_params)
			redirect_to book_path(book.id)
			flash[:notice] = "編集を完了しました。"
		else
			redirect_to book_path(book.id)
		end
	end

	def destroy
		book = Book.find(params[:id])
		if  book.destroy
			if admin_signed_in?
				redirect_to admin_path(book.user.id)
			else
				redirect_to books_path
			end
		else
			redirect_to edit_book_path
		end
	end

	def restore
		@book = Book.restore(params[:id])
		redirect_to edit_book_path(params[:id])
	end

	private
	def book_params
		params.require(:book).permit(:title, :body)
	end


end
