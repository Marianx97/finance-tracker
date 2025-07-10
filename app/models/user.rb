class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  # Friendships initiated by this user
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend

  # # Friendships where this user is the recipient
  # has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  # has_many :inverse_friends, through: :inverse_friendships, source: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def under_stock_limit?
    stocks.count < 10
  end

  def stock_already_tracked?(ticker_symbol)
    stocks.find_by(ticker: ticker_symbol).present?
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
    first_name || last_name ? "#{first_name} #{last_name}" : "Anonymous"
  end

  def already_friends?(friend)
    friends.find_by(email: friend.email).present?
  end

  def self.search_other_users_like(current_user, param)
    value = "%#{param}%".downcase
    query = "LOWER(email) like :value OR LOWER(first_name) like :value OR LOWER(last_name) like :value"
    where(query, value: value).reject { |user| user.id === current_user.id }
  end
end
