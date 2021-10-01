class AuthController < ApplicationController

  def login

  end

  def index

  end

  def create
    token = request.env['omniauth.auth']['credentials']['token']
    session[:token] = token
    redirect_to sites_path
  end
end
