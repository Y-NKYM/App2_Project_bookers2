class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def create
    book = Book.new(book_params)
    book.user_id = current_user.id
    tag_list = params[:book][:name].split(nil)
    if book.save
      book.get_tag(tag_list)
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
    # Book.allの順番を変え可能にする。
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
    @tag_list=@book.tags.pluck(:name).join(' ')
  end

  def update
    book = Book.find(params[:id])
    tag_list = params[:book][:name].split(nil)
    if book.update(book_params)
      book.get_tag(tag_list)
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

  def order_books(order)
    case order
    when nil then
      @books = Book.all
    when 'new'
      @books = Book.all.order("created_at DESC")
    when 'high-score'
      @books = Book.all.order("score DESC")
    when "favorite"
      @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    else
      @books = Book.all
    end
  end

end
