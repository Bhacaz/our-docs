require 'jwt'
require 'openssl'
require 'open-uri'
require 'zip'

class InstallationClient
  PRIVATE_PEM_PATH = 'ourdocs-app.2021-09-20.private-key.pem'
  APP_ID = 139445

  def initialize(site)
    @site = site
  end

  def branches
    installation_client.branches @site.repo
  end

  def download_archive
    sha = branches.detect { |branch| branch[:name] == @site.branch }[:commit][:sha]
    link = installation_client.archive_link(@site.repo, format: 'zipball', ref: sha)
    file_path = Rails.root.join('tmp', "#{@site.site_folder}.zip")
    IO.copy_stream(URI.parse(link).open, file_path)
    most_recent_content_folder = extract_zip(file_path, Rails.root.join('sites', @site.site_folder)).keys.first
    toggle_content(most_recent_content_folder)
  end

  def toggle_content(most_recent_content_folder_name)
    File.symlink(Rails.root.join('sites', @site.site_folder), Rails.root.join('tmp', most_recent_content_folder_name))
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

  def extract_zip(file, destination)
    FileUtils.mkdir_p(destination)

    ::Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(destination, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end
end
