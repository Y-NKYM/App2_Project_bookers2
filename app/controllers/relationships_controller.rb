class RelationshipsController < ApplicationController
  def create
    following = User.find(params[:user_id])
  	relationship = Relationship.new(followed_id: following.id, follower_id: current_user.id)
  	relationship.save
  	redirect_back(fallback_location: users_path)
  end

  def destroy
    relationship = current_user.following_relationships.find_by(followed_id: params[:user_id])
    relationship.destroy
    redirect_back(fallback_location: users_path)
  end
end
