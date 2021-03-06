class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_user_permission, only: [:edit, :update, :destroy]
  # CRUD posts
  def index
    @groups = Group.all
  end
  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5 )
  end

  def edit
  end  
  def update
    if @group.update(group_params)
      redirect_to groups_path, notice:"Update Success"
    else
      render :edit
    end
  end

  def new
    @group = Group.new
  end
  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end

  def destroy
    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
  end
  
  # member manage
  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "Join success"
    else
      flash[:warning] = "Already join"
    end
    redirect_to group_path(@group)
  end
  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:notice] = "Quit success"
    else
      flash[:warning] = "Not group member currently"
    end
    redirect_to group_path(@group)
  end

  private
  def group_params
    params.require(:group).permit(:title, :desc)
  end

  def check_user_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert:"You do not have permission."
    end
  end
end
