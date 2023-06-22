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
    case order
    when nil then
      @books = Book.all
    when 'high-score'
      @books = Book.all.order("score DESC")
    else
      @books = Book.all
    end

  end

  def show
    @book = Book.new
    @book_comment = BookComment.new
    @book_show = Book.find(params[:id])
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
    params.require(:book).permit(:title, :body, :score)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    user = User.find(book.user_id)
    unless user.id == current_user.id
      redirect_to books_path
    end
  end

end
