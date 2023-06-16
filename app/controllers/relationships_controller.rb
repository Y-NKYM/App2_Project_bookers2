class RelationshipsController < ApplicationController
  def create
  	followed = User.find(params[:user_id])
  	relationship = Relationship.new(followed_id: followed.id)
  	relationship.follower_id = current_user.id
  	relationship.save
  	redirect_back(fallback_location: users.path)
  end

  def destroy
  end
end
