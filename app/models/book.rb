class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :favorited_users, through: :favorites, source: :user

  has_many :accesses, dependent: :destroy
  has_many :book_tags, dependent: :destroy, foreign_key: 'book_id'
  has_many :tags, through: :book_tags

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
      favorites.exists?(user_id: user.id)
  end

  #looksクラスメソッドを作成
  #検索方法について
  def self.looks(word, search)
    if search == 'perfect_match'
      @books = Book.where("title LIKE ?", "#{word}")
    elsif search == 'forward_match'
      @books = Book.where("title LIKE ?", "#{word}%")
    elsif search == 'backward_match'
      @books = Book.where("title LIKE ?", "%#{word}")
    elsif search == 'partial_match'
      @books = Book.where("title LIKE ?", "%#{word}%")
    else
      @books = Book.all
    end
  end

  def get_tag(sent_tags)
  # 普段はtagsはnilになることはない。tagに何も入力しない場合は[]になり、[].nilはfalseとなる。
    current_tags = tags.pluck(:tag)
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      tags.delete Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(name: new)
      tags << new_book_tag
    end
  end

end
