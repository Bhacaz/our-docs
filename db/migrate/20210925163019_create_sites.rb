class CreateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :sites do |t|
      t.string :repo
      t.string :branch
      t.integer :installation_id

      t.timestamps
    end
  end
end
