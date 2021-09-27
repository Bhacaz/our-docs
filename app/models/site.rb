class Site < ApplicationRecord

  def site_folder
    repo.gsub('/', '__')
  end
end
