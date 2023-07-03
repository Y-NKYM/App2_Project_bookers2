class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update]

  def create
    @room = Room.create
    current_entry = Entry.create(room_id: @room.id, user_id: current_user.id)
    another_entry = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to room_path(@room.id)
  end

  # def index
  #   # 特定のユーザーが持つroom_idを入手。このデータはハッシュでroom_idとuser_idのセット。
  #   current_entries = current_user.entries
  #   my_room_id = []
  #   # 複数入っているハッシュの中からroom_idのみ入手し、配列に保存
  #   current_entries.each do |entry|
  #     my_room_id << entry.room.id
  #   end
  #   # 自分とつながりのある相手側のEntryデータを入手
  #   @another_entries = Entry.where(room_id: my_room_id).where.not(user_id: current_user.id)
  # end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id,room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
      @member = []
      @entries.each do |member|
        if member.user_id != current_user.id
          @member << member.user
        end
      end
    else
      # user/show画面へ戻る。
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end

end
