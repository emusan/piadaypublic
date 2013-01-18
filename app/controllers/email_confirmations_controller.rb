class EmailConfirmationsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_email_confirmation if user
    redirect_to root_url,notice: "Email sent!"
  end

  def edit
    @user = User.find_by_email_confirmation_token!(params[:id])
    if @user.email_confirmation_sent_at < 1.day.ago
      redirect_to root_path,alert: "email confirmation link has expired."
    elsif @user.set_confirmed
      redirect_to root_path,notice: "email confirmation successful!"
    end
  end
end
