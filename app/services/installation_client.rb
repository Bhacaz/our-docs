require 'jwt'
require 'openssl'

class InstallationClient
  PRIVATE_PEM_PATH = 'ourdocs-app.2021-09-20.private-key.pem'
  APP_ID = 139445

  def initialize(site)
    @site = site
  end

  def branches
    installation_client.branches @site.repo
  end

  private

  def generate_jwt
    private_key = OpenSSL::PKey::RSA.new(File.read(PRIVATE_PEM_PATH))
    payload = {
      # issued at time, 60 seconds in the past to allow for clock drift
      iat: Time.now.to_i - 60,
      # JWT expiration time (10 minute maximum)
      exp: Time.now.to_i + (10 * 60),
      # GitHub App's identifier
      iss: APP_ID
    }
    JWT.encode(payload, private_key, "RS256")
  end

  def app_client
    @app_client ||= Octokit::Client.new(bearer_token: generate_jwt)
  end

  def installation_client
    @installation_client ||= Octokit::Client.new(access_token: installation_token)
  end

  def installation_token
    installation_id = app_client.find_installations.detect { |installation| installation[:id] == @site.installation_id }[:id]
    app_client.create_app_installation_access_token(installation_id)[:token]
  end
end

return

# client = Octokit::Client.new(:client_id  => "Iv1.69c45daa3ff9b3a7",  :client_secret => "87acd3645dc44c58047ace67e43762c3a8374d74")
# client.branches 'Bhacaz/private-docs-as-code'
#
#
# # Private key contents
#
# # Generate the JWT
#
# client = Octokit::Client.new(bearer_token: jwt)
#
#
# installation_id = client.find_installations.first[:id]
# token = client.create_app_installation_access_token(installation_id)[:token]
#
# installation_client = Octokit::Client.new(access_token: token)
# installation_client.branches 'Bhacaz/private-docs-as-code'
