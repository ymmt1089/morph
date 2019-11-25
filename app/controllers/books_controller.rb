class BooksController < ApplicationController

	before_action :authenticate_user!, only:[:edit, :update]

	def index
		if params[:keyword]
			keyword = params[:keyword]
			@books = Book.joins(:morphemes).where("morphemes.origin like ? ","%#{keyword}%").page(params[:page]).per(15)
		else
			@books = Book.all.page(params[:page]).per(15)
		end
		@words_array = []
		@words_hash = {}
		@books.each do |book|
			one_book_morpheme_origins = Morpheme.where("(pos like ? or pos like ? or pos like ? or pos like ? or pos like ? or pos like ? ) and origin not like ? and origin not like ? and origin not like ? and origin not like ? and origin not like ? and book_id = ? ","名詞-一般","%名詞-固有名詞%","名詞-副詞可能","名詞-接尾-人名","名詞-接尾-地域","動詞-自立","する","ある","なる","いう","いる", book.id)
			one_book_morpheme_origins_count = one_book_morpheme_origins.group(:origin).count
			one_book_morpheme_origins_count_sorted_hash = Hash[one_book_morpheme_origins_count.sort_by{ |_, v| -v } ] #hash化及び、valueの昇順(DESC)でソートする
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
      if @book.save
      	flash[:notice] = "形態素解析が完了しました。"

      	# @book = Book.find(params[:id])
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
		new_model = []
		mecab_arr.each { |arr|
		  next if arr.count == 1
		  # Model -> DBに登録したいモデル
		  morpheme = Morpheme.new(
		      surface: arr[0],
		      reading: arr[1],
		      origin: arr[2],
		      pos: arr[3],
		      book_id: @book.id
		  )
		  morpheme.inflection = arr[4] if arr[4].present?
		  morpheme.conjugation = arr[5] if arr[5].present?
		  new_model << morpheme
		}
		new_model.each_slice(100).each do |morphemes|
		Morpheme.import morphemes
		end
		origins = []
		morphemes = Morpheme.all
		morphemes.each do |morpheme|
		  origins.push(morpheme.origin)
		end
      	redirect_to book_path(@book.id)
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
		book = Book.with_deleted.find(params[:id])
		if  book.destroy
			redirect_to books_path
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
