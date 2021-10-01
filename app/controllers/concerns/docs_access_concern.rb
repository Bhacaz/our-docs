module DocsAccessConcern
  def can_access?(repo)
    return session[:repos][repo] if session[:repos]&.key?(repo)

    client = ::Octokit::Client.new(access_token: session[:token])
    client.repository?(repo)
    session[:repos] ||= {}
    session[:repos][repo] = true
  end
end
