module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    # TODO Method current_user= never gets called?
    current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  private

  def user_from_remember_token
    User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token]
  end

end
