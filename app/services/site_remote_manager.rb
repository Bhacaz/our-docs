require 'jwt'
require 'openssl'
require 'open-uri'
require 'zip'

class SiteRemoteManager
  PRIVATE_PEM_PATH = 'ourdocs-app.2021-09-20.private-key.pem'
  APP_ID = 139445

  def initialize(site)
    @site = site
  end

  def init_folder_content_and_download
    FileUtils.mkdir_p(site_folder_path)
    download_new_version
  end

  def download_new_version
    sha = branches.detect { |branch| branch[:name] == @site.branch }[:commit][:sha]
    link = installation_client.archive_link(@site.repo, format: 'zipball', ref: sha)
    FileUtils.mkdir_p(extract_path)
    IO.copy_stream(URI.parse(link).open, download_archive_file_path)
    @most_recent_content_folder = extract_zip(download_archive_file_path, extract_path).keys.first
    toggle_content
  end

  private

  def branches
    installation_client.branches @site.repo
  end

  def toggle_content
    # FileUtils.ln_s("#{last_archive_folder_path}/", site_folder_path.to_s)
    # TODO: Use some symlink to achive that
    FileUtils.remove_dir(site_folder_path)
    FileUtils.mv(last_archive_folder_path, Rails.root.join('sites'))
    File.rename(Rails.root.join('sites', @most_recent_content_folder), site_folder_path)
  end

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

  # Where to download the archive zip in "tmp/Bhacaz__private-docs-as-code/Bhacaz__private-docs-as-code.zip"
  def download_archive_file_path
    Rails.root.join('tmp', @site.site_folder, "#{@site.site_folder}.zip")
  end

  # Where static site content is "sites/Bhacaz__private-docs-as-code"
  def site_folder_path
    Rails.root.join('sites', @site.site_folder)
  end

  # Where the last extracted version of the site is with is sha
  #   "sites/Bhacaz__private-docs-as-code/Bhacaz-private-docs-as-code-16ba471fccfbccf32bdbbe724e2579499916f8c8"
  def last_archive_folder_path
    Rails.root.join('tmp', @site.site_folder, @most_recent_content_folder)
  end

  # To extract the zip "tmp/Bhacaz__private-docs-as-code"
  def extract_path
    Rails.root.join('tmp', @site.site_folder)
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
