class CreateTats < ActiveRecord::Migration
  def change
    create_table :tats do |t|
      t.text :fullText
      t.text :step
      t.text :tat_content
      t.text :tat_answers
      t.text :user_answers
      t.text :is_right
      
      t.timestamps
    end
  end
end
