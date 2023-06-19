class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = Favorite.new(book_id: @book.id)
    favorite.user_id = current_user.id
    if Favorite.exists?(book_id: @book.id, user_id: current_user.id)
      flash[:error] = "The page is not up to date. Please reload page."
      render :error
    else
      favorite.save
      render :create
    end
    # redirect_back(fallback_location: books_path)
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    unless favorite == nil
      favorite.destroy
      render :destroy
    else
      flash[:error] = "The page is not up to date. Please reload page."
      render :error
    end
    # redirect_back(fallback_location: books_path)
  end
end
