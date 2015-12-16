class CreateQcms < ActiveRecord::Migration
  def change
    create_table :qcms do |t|
      t.text :fullText
      t.text :step
      t.text :qcm_content
      t.text :qcm_answers
      t.text :qcm_choices
      t.text :user_answers
      t.text :is_right

      t.timestamps
    end
  end
end
