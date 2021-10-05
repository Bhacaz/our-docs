class ServeStaticController < ApplicationController
  include DocsAccessConcern

  layout false
  skip_forgery_protection

  def index
    client = ::Octokit::Client.new(access_token: session[:token])

    if session[:token].nil? || !can_access?(repo)
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found
      return
    end

    content = client.contents(repo, path: file, ref: site.branch)[:content]

    file_name = file.split('/').last
    path = file.gsub("/#{file_name}", '')
    folder_write_content = Rails.root.join('tmp', site.site_folder, path)
    FileUtils.mkdir_p(folder_write_content)
    full_path = "#{folder_write_content.to_s}/#{file_name}"
    File.open(full_path, 'w') { |f| f.puts(Base64.decode64(content).force_encoding('UTF-8')) }

    status, headers, body =
      ::Rack::File.new(nil)
                  .serving(request, full_path)
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
end
