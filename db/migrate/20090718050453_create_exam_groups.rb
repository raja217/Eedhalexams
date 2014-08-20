class CreateExamGroups < ActiveRecord::Migration
  def self.up
    create_table :exam_groups do |t|
      t.string     :name
      t.references :batch
      t.string     :time
      t.boolean    :is_published, :default=>false
      t.boolean    :result_published, :default=>false
      t.date       :exam_date
      t.references :student_aditional_field
    end
  end

  def self.down
    drop_table :exam_groups
  end
end
