OmniAuth.config.allowed_request_methods = [:post, :get]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, 'Iv1.69c45daa3ff9b3a7', '87acd3645dc44c58047ace67e43762c3a8374d74'
end
