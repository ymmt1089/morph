class UsersController < ApplicationController

	before_action :authenticate_user!, only:[ :show, :edit, :update]

	def show
		@user = User.find(params[:id])
		@books = @user.books.with_deleted

		@words_hash = {}
		@words_array = []
		@books.each do |book|
			one_book_morpheme_origins = Morpheme.where("(pos like ? or pos like ? or pos like ? or pos like ? or pos like ? or pos like ? ) and origin not like ? and origin not like ? and origin not like ? and origin not like ? and origin not like ? and book_id = ? ","名詞-一般","%名詞-固有名詞%","名詞-副詞可能","名詞-接尾-人名","名詞-接尾-地域","動詞-自立","する","ある","なる","いう","いる", book.id)
			one_book_morpheme_origins_count = one_book_morpheme_origins.group(:origin).count
			one_book_morpheme_origins_count_sorted_hash = Hash[one_book_morpheme_origins_count.sort_by{ |_, v| -v } ]
			result = one_book_morpheme_origins_count_sorted_hash.reject{|key,value|(/nil/ =~ key) || (value <= (Math.sqrt(one_book_morpheme_origins_count_sorted_hash.first[1])/2))}

			changed_result = result.map{|v| {text:v[0],size:v[1]}}
			words = changed_result.to_json.html_safe
			book_columns = Book.with_deleted.find(book.id)

			@words_array.push({
				book_id: book_columns.id,
			    title: book_columns.title,
			    body: book_columns.body,
			    words_array: words
			})
		end
		 @words_array = Kaminari.paginate_array(@words_array).page(params[:page]).per(5)
	end

	def edit
		@user = User.find(params[:id])
		if @user.id != current_user.id
			flash[:notice] = "編集を完了しました"
			redirect_to user_path(current_user.id)
		end
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect_to user_path(@user.id)
		else
			render :edit
		end
	end

	def destroy
		user = User.find(params[:id])
		if  user.destroy
			if admin_signed_in?
				redirect_to admins_path
			else
				redirect_to books_path
			end
		else
			redirect_to edit_book_path
		end
	end

	private
	def user_params
		params.require(:user).permit(:user_name, :email, :user_image, :self_introduction)
	end
end