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

  def search_tag
    @word = params[:word]
    # @books = params[:word].present? ? Tag.find_by(name: params[:word]).books : Book.all
    if @word.present?
      @books = Tag.find_by(name: @word).books
    else
      @books = Book.all
    end
  end
end
