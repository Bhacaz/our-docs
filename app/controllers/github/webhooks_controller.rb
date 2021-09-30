module Github
  class WebhooksController < ApplicationController

    skip_forgery_protection only: :webhook

    def webhook
      repo = params[:repository][:full_name]
      branch = params[:ref].split('/').last
      installation_id = params[:installation][:id]

      site = Site.find_by(repo: repo, branch: branch, installation_id: installation_id)
      InstallationClient.new(site).download_new_version if site
    end
  end
end
