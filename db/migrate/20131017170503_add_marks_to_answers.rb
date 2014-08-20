class AddMarksToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :marks, :integer
  end

  def self.down
    remove_column :answers, :marks
  end
end
