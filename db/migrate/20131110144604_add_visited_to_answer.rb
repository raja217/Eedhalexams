class AddVisitedToAnswer < ActiveRecord::Migration
  def self.up
    add_column :answers, :visited, :integer
  end

  def self.down
    remove_column :answers, :visited
  end
end
