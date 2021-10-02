class AddUserToSite < ActiveRecord::Migration[7.0]
  def change
    add_reference :sites, :user
  end
end
