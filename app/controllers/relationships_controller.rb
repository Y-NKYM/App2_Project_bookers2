class RelationshipsController < ApplicationController
  def create
    # following=nilもといparams[:user_id]が存在しない場合の対策のため、直接記入しない。
    following = User.find(params[:user_id])
    # Relationship内にデータを記入。
  	relationship = Relationship.new(followed_id: following.id, follower_id: current_user.id)
  	relationship.save
  	redirect_back(fallback_location: users_path)
  end

  def destroy
    # Relationshipテーブルからデータ行を探しだす。必ずfollower_idとfollowed_idの両方が一致していること。
    relationship = current_user.following_relationships.find_by(followed_id: params[:user_id])
    relationship.destroy
    redirect_back(fallback_location: users_path)
  end

  # フォローしているUser一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  # フォローされているUser一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
