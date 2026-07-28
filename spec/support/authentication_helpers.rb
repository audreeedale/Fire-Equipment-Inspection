module AuthenticationHelpers
  def sign_in(user)
    post login_path, params: { email: user.email, password: user.password }
  end
end
