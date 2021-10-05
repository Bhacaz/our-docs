class ServeStaticController < ApplicationController
  include DocsAccessConcern

  before_action :validate_permission, only: :index
  before_action :download_site_if_no_present, only: :index

  layout false
  skip_forgery_protection

  def index
    file = params[:file]
    file = "#{file}/index.html" if file&.exclude?('.') # If no extension must be index.html of a folder

    status, headers, body =
      ::Rack::File.new(nil)
                  .serving(request, Rails.root.join('sites', site.site_folder, file || 'index.html'))
    render file: body.path, headers: headers, status: status
  end

  private

  def file
    file = params[:file].presence || '/index.html'
    file = "#{file}/index.html" if file&.exclude?('.') # If no extension must be index.html of a folder
    file
  end

  def repo
    "#{params[:owner]}/#{params[:project]}"
  end

  def site
    @site ||= Site.find_by!(repo: repo)
  end

  def download_site_if_no_present
    return if File.exist?(Rails.root.join('sites', site.site_folder))

    SiteRemoteManager.new(site).init_folder_content_and_download
  end

  def validate_permission
    return unless session[:token].nil? || !can_access?(repo)

    raise ActionController::RoutingError, 'Not Found'
  end
end
