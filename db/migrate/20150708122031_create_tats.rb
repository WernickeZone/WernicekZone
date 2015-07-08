class CreateTats < ActiveRecord::Migration
  def change
    create_table :tats do |t|
      t.text :fullText
      t.text :tat_content
      t.text :tat_responses

      t.timestamps
    end
  end
end
