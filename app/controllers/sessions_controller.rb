class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to places_path, notice: "Giriş başarılı."
    else
      flash.now[:alert] = "E-posta veya şifre hatalı."
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session
    redirect_to places_path, notice: "Çıkış yapıldı."
  end
end
