class Site < ApplicationRecord
  belongs_to :user

  def site_folder
    repo.gsub('/', '__')
  end
end
