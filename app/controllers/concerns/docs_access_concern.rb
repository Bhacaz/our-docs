module DocsAccessConcern
  def can_access?(repo)
    client = ::Octokit::Client.new(access_token: session[:token])
    client.repository?(repo)
  end
end
