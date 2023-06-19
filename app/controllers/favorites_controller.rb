class FavoritesController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    favorite = Favorite.new(book_id: book.id)
    favorite.user_id = current_user.id
    favorite.save
    @book = Book.find(params[:book_id])
    # redirect_back(fallback_location: books_path)
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    @book = Book.find(params[:book_id])
    # redirect_back(fallback_location: books_path)
  end
en
