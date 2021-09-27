class ServeStaticController < ApplicationController

  layout false
  skip_forgery_protection

  def index
    file = params[:file]
    file = "#{file}/index.html" if file&.exclude?('.') # If no extension must be index.html of a folder

    repo = "#{params[:owner]}/#{params[:project]}"
    site = Site.find_by!(repo: repo)
    status, headers, body =
      ::Rack::File.new(nil)
                  .serving(request, Rails.root.join('sites', site.site_folder, file || 'index.html'))
    render file: body.path, headers: headers, status: status
  end
end
