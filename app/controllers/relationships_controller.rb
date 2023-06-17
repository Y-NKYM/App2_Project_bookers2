class RelationshipsController < ApplicationController
  def create
    # following=nilもといparams[:user_id]が存在しない場合の対策のため、直接記入しない。
    following = User.find(params[:user_id])
    # フォローしたいユーザーが見つからない時のエラーflash
    if following == nil
      flash[:notice] = "User you want to follow is not found."
      # 同じアクション内にredirect_toを複数回使用しているのでreturnを付ける。
      redirect_to users_path and return
    end
    # Relationship内にデータを記入。
  	relationship = Relationship.new(followed_id: following.id, follower_id: current_user.id)
    # 二窓構成により、複数回フォローをできないようにするエラーflash
    if Relationship.exists?(followed_id: following.id, follower_id: current_user.id)
      flash[:notice] = "Already followed."
      redirect_to users_path and return
    else
      relationship.save
      redirect_back(fallback_location: users_path)
    end

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
