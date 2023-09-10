class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @new_book = Book.new

    # エラーメッセージがsessionに保存されていた場合、それを@userオブジェクトに設定
    if session[:error_messages]
      @user.errors.add(:base, session[:error_messages])
      session.delete(:error_messages)
    end

  end

  def index
    @users = User.all
    @new_book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      # # @user = User.find(params[:id]) # これを書かないとフォームで入力した値が遷移先でそのままでる。
      # @books = @user.books
      # @new_book = Book.new
      render "edit"
      # flash[:user_data] = @user.attributes
      # session[:error_messages] = @user.errors.full_messages
      # redirect_to user_path(@user)

    end
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
  end

  def following
    @user = User.find(params[:id])
    @follows = @user.following
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
