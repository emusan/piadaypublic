module SessionsHelper
  # Most of this code blatantly copied from a railscast video 
  # I believe, though the permanent sign in I think I wrote 
  # myself.

  def sign_in_permanent(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_in(user)
    cookies[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token]
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def forget_location
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path,notice: "Please sign in."
    end
  end

  def confirmed_user
    unless current_user.confirmed?
      redirect_to root_path,notice: "Please confirm your email."
    end
  end
end
