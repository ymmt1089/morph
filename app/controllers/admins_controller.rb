class AdminsController < ApplicationController

    def index
        @books = Book.all
        @users = User.all
    end

end
