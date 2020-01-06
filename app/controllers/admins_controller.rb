class AdminsController < ApplicationController

    before_action :authenticate_admin!

    def index
        @books = Book.all
        @users = User.with_deleted
    end

    def show
        @user = User.with_deleted.find(params[:id])
    end

    def edit
        @book = Book.find(params[:id])
    end

end
