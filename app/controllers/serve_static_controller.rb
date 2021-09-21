class ServeStaticController < ApplicationController
  SITE_MAP = {
    'chapter-rails-blog' => '_site',
    'test' => '_site2'
  }

  layout false

  def index
    status, headers, body = ::Rack::File.new(nil)
                                        .serving(request, Rails.root.join(SITE_MAP[params[:site]], params[:file] || 'index.html'))
    p body
    render file: body.path, headers: headers, status: status
  end
end
