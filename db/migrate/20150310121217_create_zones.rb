class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :title
      t.text :body
      t.boolean :published

      t.timestamps
    end
  end
end
