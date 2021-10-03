class AuthController < ApplicationController

  def login

  end

  def index

  end

  def create
    token = request.env['omniauth.auth']['credentials']['token']
    info = request.env['omniauth.auth']['info']
    user = User.find_or_create_by!(email: info['email'])
    user.assign_attributes(username: info['nickname'], name: info['name'], profile_picture: info['image'])
    user.save!

    session[:token] = token
    session[:user_id] = user.id
    redirect_to user_path(user)
  end
end
