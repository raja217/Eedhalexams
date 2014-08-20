class AddPassageToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :passage, :text
    add_column :questions, :is_pass, :string
  end

  def self.down
    remove_column :questions, :is_pass
    remove_column :questions, :passage
  end
end
