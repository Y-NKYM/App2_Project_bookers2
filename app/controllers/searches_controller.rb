class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]   #UserまたはBook
    @word = params[:word]     #検索ワード
    search = params[:search]  #検索方法
    if @range == 'User'
      @users = User.looks(@word, search)
    else   #つまりBook
      @books = Book.looks(@word, search)
    end
  end

end
