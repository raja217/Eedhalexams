class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
    	t.string :answer
    	t.references :questions
    	t.references :user
    	t.references :exam_group
    	t.references :modules
    end
  end

  def self.down
    drop_table :answers
  end
end
