class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "登録が完了しました"
      log_in(@user)
      redirect_to @user
    else
      flash[:danger] = @user.errors.full_messages
      # FIXME: レンダリング後に再読込を行うとindexアクションが呼ばれる
      # render :new
      redirect_to signup_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
