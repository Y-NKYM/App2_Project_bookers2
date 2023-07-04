class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def create
    book = Book.new(book_params)
    book.user_id = current_user.id
    if book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(book.id)
    else
      @book = book
      @books = Book.all
      render :index
    end
  end

  def index
    @book = Book.new
    order = params[:order]
    @books = order_books(order)
  end

  def show
    @book = Book.new
    @book_comment = BookComment.new
    @book_show = Book.find(params[:id])
    access = Access.new(book_id: @book_show.id, user_id: current_user.id)
    access.save
    @user = @book_show.user
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    book = Book.find(params[:id])
    if book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(book.id)
    else
      @book = book
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.delete
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to books_path
    end
  end

  def order_books(order)
    if !order then
      @books = Book.all
    elsif order == "post"
      @books = Book.order(created_at: :DESC)
    elsif order == "favorite"
      @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    else
      @books = Book.all
    end
  end

end
