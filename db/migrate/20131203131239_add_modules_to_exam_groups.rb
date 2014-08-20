class AddModulesToExamGroups < ActiveRecord::Migration
  def self.up
    add_column :exam_groups, :modules, :text
  end

  def self.down
    remove_column :exam_groups, :modules
  end
end
