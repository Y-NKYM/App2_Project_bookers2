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

  def edit
    @group = Group.find(params[:id])
  end

  def update
    group = Group.find(params[:id])
    group.update(group_params)
    redirect_to groups_path
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    redirect_to groups_path
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
