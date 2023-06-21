class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = Favorite.new(book_id: @book.id)
    favorite.user_id = current_user.id
    # ブラウザバックによりいいねが反映されていない場合エラーメッセージを出す。
    if Favorite.exists?(book_id: @book.id, user_id: current_user.id)
      # error.js.erbを通して_favorite_error.htmlが読み込まれる。
      # flash[:error] = "The page is not up to date. Please reload page."
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
    # ブラウザバックにより反映されず、favorite内がnilの場合エラーメッセージを出す。
    unless favorite == nil
      favorite.destroy
      render :destroy
    else
      # error.js.erbを通して_favorite_error.htmlが読み込まれる。
      # flash[:error] = "The page is not up to date. Please reload page."
      render :error
    end
    # redirect_back(fallback_location: books_path)
  end
end
