class AvailableRepositories
  def initialize(user, token)
    @user = user
    @token = token
  end

  def repository_names
    installation_ids = client.find_user_installations[:installations].pluck(:id)
    installation_ids.flat_map do |id|
      client.find_installation_repositories_for_user(id)[:repositories].pluck(:full_name)
    end
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: @token)
  end
end
