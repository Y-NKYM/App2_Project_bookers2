class GroupsController < ApplicationController
  def index
    @book = Book.new
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    group = Group.new(group_params)
    group.owner_id = current_user.id
    group.users << current_user
    if group.save
      flash[:notice] = "You have created group successfully."
      redirect_to groups_path
    else
      @group = group
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def join
    group = Group.find(params[:group_id])
    group.users << current_user
    redirect_to groups_path
  end

  def leave
    group = Group.find(params[:group_id])
    group.users.delete(current_user)
    redirect_to groups_path
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    group = Group.find(params[:id])
    if group.update(group_params)
      flash[:notice] = "You have updated group successfully."
      redirect_to groups_path
    else
      @group = group
      render :edit
    end
  end

  def event_mail
  end

  def destroy
    group = Group.find(params[:id])
    if group.destroy
      flash[:notice] = "Group deleted successfully"
      redirect_to groups_path
    end
  end

  def send_mail
    group = Group.find(params[:group_id])
    owner = User.find(group.owner_id)
    member = group.users
    @title = params[:title]
    @content = params[:content]
    GroupMailer.event_mail(owner, member, @title, @content).deliver_now
    render :sent_mail
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
