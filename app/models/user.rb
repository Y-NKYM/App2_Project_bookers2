class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # フォロー側
  # User(follower)モデルのidをRelationshipモデルのfollower_idと関連付ける
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 上記はあくまで各UserとRelationshipのidの関連付け。一つのUserからもう一つのUserの情報入手のための記述が以下。
  # 現在ログインしているUserモデル(follower)からUserモデル(followed)のデータをRelationshipモデルを通して入手できるようにする。
  # has_many後最初の記述がメソッド名の指定。user.followingsが可能
  has_many :followings, through: :following_relationships, source: :followed

  # フォロワー側
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(
        io: File.open(file_path),
        filename: 'default-image.jpg',
        content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # ログイン者が各Userをフォローしているかどうか
  def following?(user)
    # ログイン側(follower)から見てRelationship内に((follower.)id: (followed.)user.id)が存在するかのチェック。
    followings.exists?(id: user.id)
  end

  def self.looks(word, search)
    if search == 'perfect_match'
      @users = User.where("name LIKE ?", "#{word}")
    elsif search == 'forward_match'
      @users = User.where("name LIKE ?", "#{word}%")
    elsif search == 'backward_match'
      @users = User.where("name LIKE ?", "%#{word}")
    elsif search == 'partial_match'
      @users = User.where("name LIKE ?", "%#{word}%")
    else
      @users = User.all
    end
  end

  validates :name, uniqueness: true, length: {minimum: 2, maximum: 20}
  validates :introduction, length: { maximum: 50 }

end