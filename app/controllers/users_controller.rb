class UsersController < ApplicationController
    before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @book = Book.new
    @users = User.all
  end

  def show
    @book = Book.new
    @user = User.find(params[:id])
	  # 日での比較
	  @today_count = @books.where('created_at > ?', Date.today).count
	  @yesterday_count = @books.where('created_at > ?', Date.yesterday).count
	  if @today_count == 0
	    @today_yesterday_ratio = 0
    elsif @yesterday_count == 0
      @today_yesterday_ratio = 0
    else
      @today_yesterday_ratio = (@today_count.to_f/@yesterday_count*100).round(0)
    end
	  # 週での比較
	  @week_count = @books.where(created_at: Date.today.all_week).count
	  @week_ago_count = @books.where(created_at: Date.today.prev_week.all_week).count
	  if @week_ago_count == 0
	    @week_ratio = 0
    elsif @week_count == 0
      @week_ratio = 0
    else
      @week_ratio = (@week_count.to_f/@week_ago_count*100).round(0)
    end

    # tag用変数
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    # 選択しているUserが自分自身でない場合、自分と相手のidを変数へ保存
	  unless @user.id == current_user.id then
	    @current_entry.each do |current|
        @another_entry.each do |another|
          # 自分と相手のidを持つroomがEntry内に存在するかチェック。あればroom_idを変数へ保存
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      # 部屋が存在していない場合
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
	  end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(user.id)
    else
      @user = user
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end

end
