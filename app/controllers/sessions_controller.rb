class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_email(session_params[:email].downcase)
    if @user&.authenticate(session_params[:password])
      log_in(@user)
      session_params[:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = "メーアドレスまたはパスワードが異なります"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end
end
