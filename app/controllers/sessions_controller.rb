class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(session_params[:email].downcase)
    if user&.authenticate(session_params[:password])

    else
      flash.now[:danger] = "メードアドレスまたはパスワードが異なります"
      render :new
    end
  end

  def destroy
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
