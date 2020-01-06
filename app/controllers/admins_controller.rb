class AdminsController < ApplicationController

    def index
        @books = Book.all
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
    end

    def edit
        @book = Book.find(params[:id])
    end

    def destroy
        binding.pry
        user = User.with_deleted.find(params[:id])
        book = Book.with_deleted.find(params[:id])
		if  user.destroy
			redirect_to back
        elsif book.destroy
			redirect_to admin_path(book.user.id)
        end
            redirect_to edit_admins_path
    end
end
