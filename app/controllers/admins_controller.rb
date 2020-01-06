class AdminsController < ApplicationController

    def index
        @books = Book.all
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = User.find(params[:id])
        @book = Book.find(params[:id])
    end

end
