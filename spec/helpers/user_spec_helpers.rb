module UserSpecHelpers
  def sign_in(user)
    post login_url, params: { session: { username_signin: user.username, password_signin: user.password } }
  end
end
