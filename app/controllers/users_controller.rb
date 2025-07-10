class UsersController < ApplicationController
  before_action :set_friend, only: [ :add_friend, :remove_friend ]

  def show
    @user = User.find(params[:id])
  end

  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends.reload
  end

  def search
    @users = []
    if params[:search_input].present?
      @users = User.search_other_users_like(current_user, params[:search_input])

      if @users.empty?
        flash.now[:alert] = 'No user found for the given username or email'
      end
    else
      flash.now[:alert] = 'Please enter a users name or email'
    end

    render turbo_stream: [
      turbo_stream.replace('search_friend_result', partial: 'friends/search', locals: { users: @users }),
      turbo_stream.replace('friend_operation_message', partial: 'friends/message')
    ]
  end

  def add_friend
    current_user.friendships.create(friend: @friend)
    flash.now[:notice] = "User #{@friend.full_name} is now your friend"

    @friends = current_user.friends.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to my_friends_path, notice: "#{@friend.full_name} is now your friend" }
    end
  end

  def remove_friend
    current_user.friendships.find_by(friend_id: @friend.id).destroy
    flash.now[:notice] = "You and #{@friend.full_name} are no longer friends"

    @friends = current_user.friends.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to my_friends_path, notice: "#{@friend.full_name} is now your friend" }
    end
  end

  private

  def set_friend
    @friend = User.find(params[:friend])
  end
end
