class ServeStaticController < ApplicationController

  layout false
  skip_forgery_protection

  def index
    repo = "#{params[:owner]}/#{params[:project]}"
    site = Site.find_by!(repo: repo)
    status, headers, body =
      ::Rack::File.new(nil)
                  .serving(request, Rails.root.join('sites', site.site_folder, params[:file] || 'index.html'))
    render file: body.path, headers: headers, status: status
  end
end
