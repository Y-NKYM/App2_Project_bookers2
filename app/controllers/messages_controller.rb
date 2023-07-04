class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    message.room_id = params[:room_id]
    if message.save
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_to room_path(params[:room_id])
  end

  private
  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end