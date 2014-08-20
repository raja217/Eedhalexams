class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.text    :ques
      t.string  :is_answer
      t.references :student_additional_field
      t.references :exam_group
      t.text    :ans1
      t.text    :ans2
      t.text    :ans3
      t.text    :ans4
    end
  end

  def self.down
    drop_table :questions
  end
end
