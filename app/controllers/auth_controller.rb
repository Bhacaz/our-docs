class AuthController < ApplicationController

  def login

  end

  def index

  end

  def create
    token = request.env['omniauth.auth']['credentials']['token']
    session[:token] = token
    client = ::Octokit::Client.new(:access_token => token )
    @user = client.user
  end
end
