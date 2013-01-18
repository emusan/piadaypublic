class UsersController < ApplicationController
  before_filter :non_signed_in_user,only: [:new,:create]
  before_filter :confirmed_user,    only: [:destroy]
  before_filter :signed_in_user,    only: [:edit,:update,:index,:destroy]
  before_filter :correct_user,      only: [:edit,:update]
  before_filter :admin_user,        only: [:destroy]

  def show
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.test_frequency = 7
    if @user.save
      @user.reset_email_confirmed
      sign_in @user
      flash[:success] = "Welcome to Pi a Day!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    if User.find(params[:id]) != current_user
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    else
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @user.authenticate(params[:old_password]) == @user
      if params[:user][:email] == @user.email && @user.update_attributes(params[:user])
        flash[:success] = "Profile updated!"
        update_test_times
        sign_in @user
        redirect_to root_path
      elsif @user.update_attributes(params[:user])
        flash[:success] = "Profile updated, please reconfirm your email"
        update_test_times
        @user.reset_email_confirmed
        sign_in @user
        redirect_to root_path
      else
        render 'edit'
      end
    else
      flash[:error] = "Old password incorrect"
      render 'edit'
    end
  end

  private

  def update_test_times
    if @user.pi
      @user.pi.next_test = @user.test_frequency.days.from_now
      @user.pi.save!
    end
    if @user.e
      @user.e.next_test = @user.test_frequency.days.from_now
      @user.e.save!
    end
    if @user.phi
      @user.phi.next_test = @user.test_frequency.days.from_now
      @user.phi.save!
    end
  end

  def confirmed_user
    redirect_to(root_path,alert: "You must confirm your email to use this feature") unless current_user.confirmed?
  end

  def non_signed_in_user
    redirect_to(root_path) unless !signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
