class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to places_path, notice: "Hesabın başarıyla oluşturuldu."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end
end
