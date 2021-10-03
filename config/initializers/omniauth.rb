OmniAuth.config.allowed_request_methods = [:post, :get]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Rails.application.credentials[Rails.env.to_sym][:github_app][:client_id], Rails.application.credentials[Rails.env.to_sym][:github_app][:secret]
end
