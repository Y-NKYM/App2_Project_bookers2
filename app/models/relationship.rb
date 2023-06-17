class Relationship < ApplicationRecord
  # class_nameでUserモデル内記載のsource名をfollowerとfollowedにする。
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

end
